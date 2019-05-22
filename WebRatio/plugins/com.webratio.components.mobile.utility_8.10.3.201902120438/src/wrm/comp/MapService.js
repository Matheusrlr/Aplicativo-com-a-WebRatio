/**
 * Service for Map view component.
 * 
 * @constructor
 * @extends wrm.core.AbstractViewComponentService
 * @param {string} id
 * @param {!Object} descr
 * @param {!wrm.core.Manager} manager
 */
export default wrm.defineService(wrm.core.AbstractViewComponentService, {

    /** @override */
    initialize: function(descr) {},

    /** @override */
    computeOutput: function(context) {
        var view = context.getView();
        return this._createOutput(view);
    },

    /** @override */
    catchEvent: function(context, event) {
        var view = context.getView();
        view["_markerIndex"] = event.getParameters()["position"];
    },

    /** @override */
    submitView: function(context) {
        var view = context.getView();
        return this._createOutput(view);
    },

    /**
     * @param {!Object} view
     * @return {!Object}
     */
    _createOutput: function(view) {
        var output = {};
        var markers = view["_markers"];
        var markerIndex = view["_markerIndex"];
        for (var i = 0; i < markers.length; i++) {
            if (markers[i].get("wrIndex") === markerIndex) {
                output['locationId'] = markers[i].get("locationId");
                break;
            }
        }
        return output;
    },

    /** @override */
    updateView: function(context) {
        var thisService = this;
        var log = this.getLog();
        var view = context.getView();
        var input = context.getInput();
        var promise = null;
        var infoClickListener = null;
        var renderDefer = null;

        if (!view["$render"]) {
            view["$render"] = function render(element) {
                if (!element) {
                    throw new ReferenceError("Missing element");
                }

                thisService._initializeMap(view, element).then(function(map) {
                    // map.setDiv(element);
                    // map.setVisible(true);

                    view["_locationsPromise"].then(function() {
                        return thisService._setMapPosition(map, view["_locations"]).then(function() {
                            thisService._setMarkers(view).then(function() {
                                var initialZoom = view["_initialZoom"] != null ? view["_initialZoom"] : 10;
                                map.setCameraZoom(initialZoom);
                            });
                        });
                    });
                });

            }
        }

        if (!view["$destroy"]) {
            view["$destroy"] = function destroy() {
                view["map"] && view["map"].remove();
                delete view["map"];
                delete view["_mapPromise"];
                delete view["_markers"];
                delete view["_markerCluster"];
            }
        }

        /* initialize the infoWindowClick */
        if (!view["infoWindowClick"]) {
            view["infoWindowClick"] = new wrm.util.ListenerList();
        }

        view["_locations"] = this._computeLocationsValues(input);
        view["_locationsPromise"] = this._computeLocationsPositions(view["_locations"]);

        if (view["map"]) {
            view["_locationsPromise"].then(function() {
                return thisService._setMapPosition(view["map"], view["_locations"]).then(function() {
                    thisService._setMarkers(view).then(function() {
                        var initialZoom = view["_initialZoom"] != null ? view["_initialZoom"] : 10;
                        view["map"].setCameraZoom(initialZoom);
                    });
                });
            });
        }
    },

    /**
     * @private
     * @param {!Object} view
     * @param {!Object} element
     * @return {!Promise}
     */
    _initializeMap: function(view, element) {
        var that = this;

        if (view["map"]) {
            view["_mapPromise"] = Promise.resolve(view["map"]);
            return view["_mapPromise"];
        }

        if (view["_mapPromise"]) {
            return view["_mapPromise"];
        }

        var MAP_INIT_OPTIONS = {
            'controls': {
                'compass': false,
                'myLocation': view["_showMyLocation"],
				'myLocationButton': view["_showMyLocation"],
                'indoorPicker': false,
                'zoom': view["_showZoomControl"]
            },
            'gestures': {
                'scroll': true,
                'tilt': false,
                'rotate': false,
                'zoom': true
            }
        };
        view["_mapPromise"] = new Promise(function(resolve, reject) {
            var map = createNewMap(element, MAP_INIT_OPTIONS);
            map.on(plugin.google.maps.event.MAP_READY, function(map) {
                map.clear();
                view["map"] = map;
                that.htmlInfoWindow = new plugin.google.maps.HtmlInfoWindow();
                var clusterMarkerIconOptions = {
                    maxZoomLevel: view["_markersClusterIconMaxZoomLevel"],
                    min: view["_markersClusterIconMinCount"],
                    url: view["_markersClusterIcon"],
                    anchor: {
                        x: view["_markersClusterIconXAnchor"],
                        y: view["_markersClusterIconYAnchor"]
                    }
                };
                map.addMarkerCluster({
                    boundsDraw: false,
                    markers: [],
                    icons: [ clusterMarkerIconOptions ]
                }, function(markerCluster) {
                    view["_markerCluster"] = markerCluster;
                    resolve(map);
                });
            });
        });

        return view["_mapPromise"];
    },

    /**
     * @private
     */
    _createMarker: function(map, markerCluster, markerValues, index, infoClickCallback) {
        var thisService = this;

        if (!markerValues["_position"]) {
            return Promise.resolve();
        }

        var markerInfo = {
            'position': markerValues["_position"],
            'title': markerValues["titles"],
            'snippet': markerValues["snippets"],
            'locationId': markerValues["locationIds"],
            'address': markerValues["addresses"],
            'latitude': markerValues["latitudes"],
            'longitude': markerValues["longitudes"],
            'wrIndex': index,
            'infoClick': infoClickCallback,
            'icon': markerValues["images"],
            'html': markerValues["htmlContents"],
            'cluster': markerValues["clusters"]
        };
        return new Promise(function(resolve, reject) {
            if (markerInfo["cluster"] == null) {
                // this is a standalone marker
                map.addMarker(markerInfo, function(marker) {
                    var markerSnippetAndTitle = (markerInfo["snippet"] != null) || (markerInfo["title"] != null);
                    if (!markerSnippetAndTitle) {
                        // if one of snippet or title is not null, the native code will render a native infowindow over the map
                        marker.on(plugin.google.maps.event.MARKER_CLICK, function() {
                            thisService.htmlInfoWindow.setContent(markerInfo["html"]);
                            thisService.htmlInfoWindow.open(marker);
                        });
                    }
                    resolve(marker);
                });
            } else {
                // this marker has to be part of a cluster
                markerCluster.addMarker(markerInfo);
                var markerId = markerInfo.id;
                var marker = markerCluster.getMarkerById(markerId);
                var markerSnippetAndTitle = (markerInfo["snippet"] != null) || (markerInfo["title"] != null);
                if (!markerSnippetAndTitle) {
                    // if one of snippet or title is not null, the native code will render a native infowindow over the map
                    marker.on(plugin.google.maps.event.MARKER_CLICK, function() {
                        thisService.htmlInfoWindow.setContent(markerInfo["html"]);
                        thisService.htmlInfoWindow.open(marker);
                    });
                }
                resolve(marker);
            }
            // });
        });

    },

    /**
     * @private
     * @return {!Promise}
     */
    _retriveLatLng: function(markerValues) {

        var thisService = this;
        var log = this.getLog();
        if (markerValues["addresses"]) {
            return this._geocode(markerValues["addresses"]).then(function(position) {
                return new plugin.google.maps.LatLng(position["lat"], position["lng"]);
            })["catch"](function(error) {
                log.warn("Unable to retrive latitude and longitude for '" + markerValues["addresses"] + "'");
            });
        } else if (markerValues["latitudes"] && markerValues["longitudes"]) {
            return Promise.resolve(new plugin.google.maps.LatLng(markerValues["latitudes"], markerValues["longitudes"]));
        } else {

            // log.warn("Impossible to compute position for marker:", markerValues);
            return Promise.resolve();
            // throw new Error("Marker doesn't have valid address or valid latitude, longitude.");
        }
    },

    /**
     * @private
     */
    _setMapPosition: function(map, locations) {
        var thisService = this;
        var log = this.getLog();

        return new Promise(function(resolve, reject) {
            if (thisService.currentPosition) {
                map.moveCamera({
                    'target': thisService.currentPosition,
                    'zoom': 14
                }, function() {
                    log.debug("Centered on current marker.");
                    resolve();
                });
            } else if (!locations || locations.length === 0) {
                thisService._geolocate(map).then(function(result) {
                    map.moveCamera({
                        'target': result["latLng"],
                        'zoom': 14
                    }, function() {
                        log.debug("No markers, map centered on current position.");
                        resolve();
                    });
                }, function(e) {
                    log.error(e);
                    resolve();
                });
            } else if (locations.length === 1) {
                map.moveCamera({
                    'target': locations[0]["_position"],
                    'zoom': 14
                }, function() {
                    log.debug("Map centered on single marker.");
                    resolve();
                });
            } else {
                var positions = [];
                locations.forEach(function(location) {
                    if (location["_position"]) {
                        positions.push(location["_position"]);
                    }
                });

                map.moveCamera({
                    'target': positions,
                    'zoom': 14
                }, function() {
                    log.debug("Map centered to current markers.");
                    resolve();
                });
            }
        });

    },

    /**
     * @private
     */
    _updateMarker: function(marker, markerValues, index) {
        if (marker.getTitle() !== markerValues["titles"]) {
            marker.setTitle(markerValues["titles"]);
        }
        if (marker.getSnippet() !== markerValues["snippets"]) {
            marker.setSnippet(markerValues["snippets"]);
        }
        if (marker.get("locationId") !== markerValues["locationIds"]) {
            marker.set("locationId", markerValues["locationIds"]);
        }
        if (marker.get("wrIndex") !== index) {
            marker.set("wrIndex", markerValues["wrIndex"]);
        }

        var positionChanged = false;
        if (marker.get("address") !== markerValues["addresses"]) {
            marker.set("address", markerValues["addresses"]);
            positionChanged = true;
        }
        if (marker.get("latitude") !== markerValues["latitudes"]) {
            marker.set("latitude", markerValues["latitudes"]);
            positionChanged = true;
        }
        if (marker.get("longitude") !== markerValues["longitudes"]) {
            marker.set("longitude", markerValues["longitudes"]);
            positionChanged = true;
        }
        if (positionChanged) {
            marker.setPosition(markerValues["_position"]);
        }
        if (marker.get("icon") !== markerValues["icons"]) {
            marker.set("icon", markerValues["icons"]);
        }
        if (marker.get("html") !== markerValues["html"]) {
            marker.set("html", markerValues["htmlContents"]);
        }
        return Promise.resolve(marker);
    },

    /**
     * @private
     */
    _removeMarker: function(marker) {
        marker.remove();
    },

    /**
     * @private
     */
    _setMarkers: function(view) {
        var thisService = this;
        var log = this.getLog();
        var map = view["map"];
        var infoClickListener = view["infoWindowClick"];
        var newMarkersValues = view["_locations"];
        var existingMarkers = []
        var mPromise = Promise.resolve();

        if (!view["_markers"]) {
            view["_markers"] = [];
        }
        var markers = view["_markers"];

        /* Retrieve old markers locationIds */
        var markersId = [];
        for (var i = 0; i < markers.length; i++) {
            markersId.push(markers[i].get("locationId"));
        }

        function infoClickCallback(marker) {
            infoClickListener.notifyAll(marker.get("wrIndex"));
        }

        newMarkersValues.forEach(function(markerValues, i) {
            var markerIndex = markersId.indexOf(markerValues["locationIds"]);
            if (markerIndex < 0) { // new marker
                mPromise = mPromise.then(function() {
                    if (!view["map"]) { // ignore if map is destroyed
                        return;
                    }
                    return thisService._createMarker(view["map"], view["_markerCluster"], markerValues, i,
                            infoClickCallback).then(function(marker) {
                                if (marker) {
                                    markers.push(marker);
                                }
                            });
                });
            } else { // existing marker
                existingMarkers.push(markerValues["locationIds"]);
                var marker = markers[markerIndex];
                mPromise = mPromise.then(function() {
                    if (!view["map"]) {
                        return;
                    }

                    return thisService._updateMarker(marker, markerValues, i);
                });
            }
        });

        /* remove markers not present in the new data */
        for (var i = 0; i < markersId.length; i++) {
            var locationId = markersId[i];
            if (existingMarkers.indexOf(locationId) < 0) { // not present in updated markers
                var markerIndex = -1;
                for (var y = 0; y < markers.length; y++) {
                    if (markers[y].get("locationId") === locationId) {
                        markerIndex = y;
                        break;
                    }
                }
                if (markerIndex >= 0) {
                    var marker = markers[markerIndex];
                    markers.splice(markerIndex, 1);
                    thisService._removeMarker(marker);
                } else {
                    // We didn't find the old marker!!! Something goes wrong!!!
                }
            }
        }

        return mPromise;
    },

    /**
     * @private
     * @param {!string} address
     * @return {!Promise<{lat:number, lng:number}>}
     */
    _geocode: function(address) {
        return new Promise(function(resolve, reject) {
            plugin.google.maps.Geocoder.geocode({
                address: address
            }, function(results) {
                if (results.length) {
                    var result = results[0];
                    var position = result.position;
                    resolve(position);
                } else {
                    reject("Unable to geocode the address");
                }
            });
        });
    },

    /**
     * @private
     */
    _geolocate: function(map) {
        return new Promise(function(resolve, reject) {

            var onSuccess = function(location) {
                var position = location;
                resolve(position);
            };

            var onError = function(msg) {
                reject("error: " + msg);
            };
            map.getMyLocation({}, onSuccess, onError);
        });
    },

    /**
     * @private
     * @param {!wrm.nav.Input} input
     * @returns {!Array.<Object>}
     */
    _computeLocationsValues: function(input) {
        var properties = [ "addresses", "images", "latitudes", "locationIds", "longitudes", "snippets", "titles", "icons",
                "htmlContents", "clusters" ];

        var result = [];

        /* Normalize input values, turning them in arrays of the same length */
        var normalizedInput = {};
        var maxLength = 0;
        for (var i = 0; i < properties.length; i++) {
            var property = properties[i];
            var propertyInput = input[property];
            if (propertyInput !== undefined) {
                if (angular.isArray(propertyInput)) {
                    if (maxLength === 0 || maxLength === 1) {
                        maxLength = propertyInput.length;
                    } else if (maxLength !== propertyInput.length) {
                        throw new Error("Input array lengths do not match");
                    }
                } else {
                    propertyInput = [ propertyInput ];
                    maxLength = maxLength || 1;
                }
                normalizedInput[property] = propertyInput;
            }
        }

        /*
         * Collect properties at the same indexes into separate value-holding objects
         */
        if (maxLength) {
            for (var k = 0; k < maxLength; k++) {
                var tmpObj = {};
                Object.keys(normalizedInput).forEach(function(propertyId) {
                    if (normalizedInput[propertyId].length === 1) {
                        tmpObj[propertyId] = normalizedInput[propertyId][0];
                    } else {
                        tmpObj[propertyId] = normalizedInput[propertyId][k];
                    }
                });
                result.push(tmpObj);
            }
        }

        return result;
    },

    /**
     * @private
     * @param {!Array.<Object>} locations
     * @returns {!Promise}
     */
    _computeLocationsPositions: function(locations) {
        var thisService = this;
        var log = this.getLog();
        var promise = Promise.resolve();
        var invalidPositions = [];

        locations.forEach(function(location) {
            promise = promise.then(function() {
                return thisService._retriveLatLng(location).then(function(latLng) {
                    location["_position"] = latLng;
                    if (!latLng) {
                        invalidPositions.push({
                            "locationId": location["locationIds"],
                            "title": location["titles"]
                        });
                    }
                });
            });
        });

        promise = promise.then(function() {
            if (invalidPositions.length) {
                log.warn("Failed to compute position for " + invalidPositions.length + " markers", invalidPositions);
            }
        });

        return promise;
    }
});

/**
 * Creates a new map instance with the specified options. Internally, a single map instance is reused and destroyed only when no longer
 * used.
 * 
 * @param {!Object} element
 * @param {!Object<string,*>} initOptions
 * @return {!plugin.google.maps.Map}
 */
var createNewMap = (function() {

    var usages = 0;

    /**
     * @param {!Object} element
     * @param {!Object<string,*>} initOptions
     * @return {!plugin.google.maps.Map}
     */
    function doCreateNewMap(element, initOptions) {
        var map = plugin.google.maps.Map.getMap(element, initOptions); // creates or reconfigures the existing one
        usages++;

        if (!map.remove["__wr_pathced"]) {
            map.remove = (function(_super) {
                return function() {
                    usages--;
                    if (usages <= 0) {
                        _super.apply(this, arguments);
                    }
                };
            })(map.remove);
            map.remove["__wr_pathced"] = true;
        }

        return map;
    }

    return doCreateNewMap;
})();
