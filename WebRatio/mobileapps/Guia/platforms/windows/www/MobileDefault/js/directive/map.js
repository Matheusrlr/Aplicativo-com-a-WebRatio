(function(angular) {
	'use strict';
	
	/* Shows map inside the container */
	angular.module('mobileDefault.map', []).directive('wrMap', [ '$timeout', '$parse', function($timeout, $parse) {
		function link(scope, element, attrs) {
			
			var map;
			
			/*scope.$watch("view.$render", function(renderFunc) {
			if (renderFunc) {
			$timeout(function() {
			renderFunc(element[0]);
			}, 300);
			}
			});*/
			
			scope.$on('wrViewEntering', function() {
				if (scope["view"] && scope["view"].$render) {
					scope["view"].$render(element[0]);
				} else {
					var unwatch = scope.$watch("view.$render", function(renderFunc) {
						if (renderFunc) {
							$timeout(function() {
								renderFunc(element[0]);
								unwatch();
							}, 300);
						}
					});
				}
			});
			
			
			scope.$watch(attrs.map, function(newMap) {
				map = newMap;
			});
			
			// Listen for overlay
			scope.$on('overlay.shown', function(e) {
				map && map.setClickable(false);
			});
			
			scope.$on('overlay.hidden', function(e) {
				map && map.setClickable(true);
			});
			
			// Listen for overlay
			scope.$on('$ionicSideMenuOpen', function(e) {
				map && map.setClickable(true);
			});
			
			scope.$on('$ionicSideMenuClose', function(e) {
				map && map.setClickable(false);
			});
			
			if (attrs.infoWindowClickListener && attrs.infoWindowClick) {
				var clickEventFunction = $parse(attrs.infoWindowClick);
				var throwEvent = function(index) {
					clickEventFunction(scope, {
						"$index": index
					});
				}
				
				scope.$watch(attrs.infoWindowClickListener, function(listener) {
					if (listener) {
						listener.add(throwEvent);
						scope.$on("$destroy", function() {
							listener.remove(throwEvent);
						});
					}
				});
			}
			
			scope.$on('wrViewLeaving', function() {
				scope["view"] && scope["view"].$destroy && scope["view"].$destroy();
			});
			
			/* Map controls */
			// my location
			if (attrs.showMyLocation){
				scope["view"]._showMyLocation = (attrs.showMyLocation == 'true'); 
			} else {
				scope["view"]._showMyLocation = false;
			}
			
			// zoom control
			if (attrs.showZoomControl){
				scope["view"]._showZoomControl = (attrs.showZoomControl == 'true'); 
			} else {
				scope["view"]._showZoomControl = false;
			}
			
			/* Cluster marker options */
			// cluster marker icon
			if (attrs.markersClusterIcon){ 
				scope["view"]._markersClusterIcon = attrs.markersClusterIcon; 
			}
			// minimum number of simple marker close enough to be rendered as a cluster
			if (attrs.markersClusterIconMinCount){ 
				var minCount;
				if (isNaN(attrs.markersClusterIconMinCount)){
					minCount = 2;
				} else {
					minCount = Number(attrs.markersClusterIconMinCount);
					if (minCount < 2){
						minCount = 2;
					}
				}
				scope["view"]._markersClusterIconMinCount = minCount;
			} else {
				scope["view"]._markersClusterIconMinCount = 2;
			}
			// cluster marker icon maximum zoom level of rendering (optional)
			if (attrs.markersClusterIconMaxZoomLevel){ 
				var maxZoomLevel;
				if (isNaN(attrs.markersClusterIconMaxZoomLevel)){
					maxZoomLevel = 15;
				} else {
					maxZoomLevel = Number(attrs.markersClusterIconMaxZoomLevel);
					if (maxZoomLevel < 1 || maxZoomLevel > 18){
						maxZoomLevel = 15;
					}
				}
				scope["view"]._markersClusterIconMaxZoomLevel = maxZoomLevel;
			}
			// cluster marker icon horizontal offset of anchor point
			if (attrs.markersClusterIconXAnchor){ 
				scope["view"]._markersClusterIconXAnchor = Number(attrs.markersClusterIconXAnchor);
			} else {
				scope["view"]._markersClusterIconXAnchor = 32;	// it assumes a cluster marker icon of 64x64 pixels
			}
			// cluster marker icon vertical offset of anchor point
			if (attrs.markersClusterIconYAnchor){ 
				scope["view"]._markersClusterIconYAnchor = Number(attrs.markersClusterIconYAnchor);
			} else {
				scope["view"]._markersClusterIconYAnchor = 32;	// it assumes a cluster marker icon of 64x64 pixels
			}

			// fix for iOS 11.x/iPhone X
			var scrollParent = element.parent().parent()[0];
			if (scrollParent && (!scrollParent.classList.contains('wr-map-area') && scrollParent.classList.contains("scroll"))) {
				scrollParent.classList.add("wr-map-area");
			}
		}		
		return {
			restrict: 'E',
			link: link
		};
	} ]);
}(window.angular));