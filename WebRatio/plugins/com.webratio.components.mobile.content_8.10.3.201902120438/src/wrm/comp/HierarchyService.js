/**
 * Service for Hierarchy view components.
 * 
 * @constructor
 * @extends wrm.core.AbstractCachedViewComponentService
 * @param {string} id
 * @param {!Object} descr
 * @param {!wrm.core.Manager} manager
 */
export default wrm.defineService(wrm.core.AbstractCachedViewComponentService, {

    /** @override */
    initialize: function(descr) {
        var thisService = this;

        /**
         * @private
         * @type {!string}
         */
        this._entityId = descr["entity"];

        // TODO cache query instead
        /**
         * @private
         * @type {!string}
         */
        this._condExpr = descr["condExpr"];

        /**
         * @private
         * @type {!Array}
         */
        this._order = descr["order"];

        /**
         * @private
         * @type {!number}
         */
        this._maxResults = descr["maxResults"];

        /**
         * @private
         * @type {!Array}
         */
        this._levels = descr["levels"];

        /**
         * @private
         * @type {!Object}
         */
        this._levelsEntity = {};

        // TODO cache query instead
        /**
         * @private
         * @type {!Object<string,!Object>}
         */
        this._cachedLevelCondition = {};

        /**
         * @private
         * @type {!wrm.data.DataService}
         */
        this._dataService; // init'd below

        return this.getManager().getDataService().then(function(dataService) {
            thisService._dataService = dataService;
        });
    },

    /** @override */
    computeOutputFromResult: function(context, result) {
        var current = context.getView()["current"];
        var output = {};
        if (current !== undefined) {
            output["data"] = this._makeResult(current, result);
        }
        return output;
    },

    /** @override */
    catchEvent: function(context, event) {
        var rowIndex = event.getParameters()["position"];
        var view = context.getView();
        view["current"] = rowIndex;
    },

    /** @override */
    submitView: function(context) {
        var view = context.getView();
        var output = {};
        output["data"] = this._makeResult(view["current"], view);
        return output;
    },

    /**
     * @private
     * @param {!Array.<!Object>} current
     * @param {!Object} data
     * @returns {!Object}
     */
    _makeResult: function(current, data) {
        var thisService = this;
        var output = {};
        var deepth = current.length;

        var extractValues = function(obj, index) {
            var position = current[index];

            // by construction there is only one key in the position object
            var key = "";
            Object.keys(position).forEach(function(k) {
                key = k;
            });

            obj[key] = {};
            data = data[key][position[key]];
            var tmp = thisService._dataService.extractPropertyValuesByName(data, thisService._levelsEntity[key]);
            angular.extend(tmp, data);

            // TODO replace with angular.extend(obj[key], tmp);
            Object.keys(tmp).forEach(function(k) {
                obj[key][k] = tmp[k];
            });

            index++;
            if (index < deepth) {
                extractValues(obj[key], index);
            }
        };

        extractValues(output, 0); // recursive

        return output;
    },

    /**
     * @override
     * @protected
     */
    createResult: function(context) {
        var thisService = this;
        var input = context.getInput();
        var result = {
            "": {}
        };
        var firstLevel = {
            "entity": this._entityId,
            "condExpr": this._condExpr,
            "order": this._order,
            "maxResults": this._maxResults,
            "levels": this._levels
        };
        var servicePromise = this._retrieveQueryResult(input, firstLevel, result, [], context);
        // first call to the recursive&async function

        return servicePromise.then(function() {
            return {
                "data": result[""]["data"]
            };
        }, function(e) {
            thisService.getLog().error(e);
        });
    },

    /** @override */
    isStaleResult: function(context, result) {
        return !result["data"] || result["data"].length === 0;
    },

    /**
     * @private
     * @param {!wrm.nav.Input} input
     * @param {!Object} currLevel
     * @param {!Object<string,!Object>} resultObjs
     * @param {!Array<*>} parentKeys
     * @param {!wrm.core.ViewComponentContext} context
     * @return {!Promise<Object>}
     */
    _retrieveQueryResult: function(input, currLevel, resultObjs, parentKeys, context) {
        // prepare the query for the selection
        var thisService = this;
        var entityId = currLevel["entity"];
        var levelId = currLevel["levelId"] || "";
        var levelCondition = currLevel["condExpr"];
        var levelRoleCondition = currLevel["roleCondition"];

        if (!this._cachedLevelCondition[levelId]) { // check for cached Condition
            var newCondition = {};
            if (levelRoleCondition) {
                this._levelsEntity[levelId + "data"] = entityId;
                var roleConditionCopy = {
                    "operator": levelRoleCondition["operator"],
                    "property": levelRoleCondition["property"],
                    "valueInput": levelRoleCondition["valueInput"],
                    "implied": levelRoleCondition["implied"]
                };
                if (!levelCondition) { // there aren't additional Condition apart the implicit role
                    var config = {
                        "oneImpliedInputRequired": false
                    };
                    newCondition["config"] = config;
                    Object.keys(roleConditionCopy).forEach(function(key) {
                        newCondition[key] = roleConditionCopy[key];
                    });
                } else {
                    var and = [];
                    if (levelCondition["and"]) { // there are additional Condition
                        and = levelCondition["and"].slice(0)
                    } else { // there is only one additional Condition
                        and.push({
                            "operator": levelCondition["operator"],
                            "property": levelCondition["property"],
                            "valueInput": levelCondition["valueInput"],
                            "implied": levelCondition["implied"]
                        });
                    }
                    and.push(roleConditionCopy);
                    newCondition["and"] = and;
                    if (levelCondition["or"]) {
                        newCondition["or"] = levelCondition["or"];
                    }
                    newCondition["config"] = levelCondition["config"];
                }
            } else { // it's the first level, just copy the Condition, if there is.
                if (levelCondition) {
                    Object.keys(levelCondition).forEach(function(key) {
                        newCondition[key] = levelCondition[key];
                    });
                } else {
                    newCondition = null;
                }
                this._levelsEntity["data"] = entityId;
            }
            this._cachedLevelCondition[levelId] = newCondition; // cache computed Condition
        }

        levelCondition = this._cachedLevelCondition[levelId]; // read Condition from cache

        var entity = this._dataService.getMetadata().getEntity(entityId);
        var attributes = entity.getAttributes();
        var output = {};

        angular.forEach(attributes, function(attribute) {
            output[attribute.getName()] = attribute.getId();
        });
        output["__key"] = entity.getKeyAttribute().getId(); // for row tracking
        if (levelRoleCondition) {
            output["_parentKey"] = levelRoleCondition["property"];
        }

        var keyAttrName = entity.getKeyAttribute().getName();

        var internalPromise = this._dataService.execute(function(d) {
            var options = {
                output: output,
                outputConfig: {
                    useNames: true
                },
                filter: levelCondition,
                order: currLevel.order
            };

            var maxResultName = levelId + "maxResults";
            var resultsLength = input[maxResultName] || currLevel[maxResultName];
            if (resultsLength > 0) {
                var limit = {
                    end: resultsLength
                };
                options["limit"] = limit;
            }

            if (parentKeys.length > 0) {
                input[levelRoleCondition["valueInput"]] = parentKeys;
            }

            return d.select(entityId, options, input);
        });

        return internalPromise.then(function(rows) {
            // add retrieved results to result object and continue with analysing other levels
            var promises = [];
            var childLevelResultObjs = (currLevel["levels"].length > 0 ? {} : null); // null if no more child levels
            var childLevelParentKeys = (currLevel["levels"].length > 0 ? [] : null);
            angular.forEach(rows, function(row) {
                var objectToPush = {};
                angular.forEach(Object.keys(row), function(key) {
                    if (key === "_parentKey") {
                        return; // continue
                    }
                    objectToPush[key] = row[key];
                });
                context.markForViewTracking(objectToPush, levelId + ":" + row["__key"]);
                delete row["__key"];

                if (childLevelResultObjs && childLevelParentKeys) {
                    childLevelResultObjs[row[keyAttrName]] = objectToPush;
                    childLevelParentKeys.push(row[keyAttrName]);
                }

                (row["_parentKey"] ? wrm.data.toAnyArray(row["_parentKey"]) : [ "" ]).forEach(function(parentKey) {
                    var resultObj = resultObjs[parentKey];
                    if (resultObj) {
                        if (!resultObj[levelId + "data"]) {
                            resultObj[levelId + "data"] = [];
                        }
                        resultObj[levelId + "data"].push(objectToPush);
                    }
                });
                delete row["_parentKey"];
            });

            return Promise.all(currLevel["levels"].map(function(level) {
                return thisService._retrieveQueryResult(input, level, childLevelResultObjs, childLevelParentKeys, context)
                // recurse async
            }));
        }, function(e) {
            console.error(e);
        });
    },

});
