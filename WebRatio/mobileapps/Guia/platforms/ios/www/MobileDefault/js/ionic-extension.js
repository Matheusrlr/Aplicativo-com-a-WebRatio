(function() {
    'use strict';

    document.addEventListener("deviceready", function() {
        cordova.plugins && cordova.plugins.Keyboard && cordova.plugins.Keyboard.disableScroll(true);

        if (document.body.classList.contains("fullscreen")) {
            ionic.Platform.fullScreen();
        }

    }, false);

    /*
     * Module with customizations for MobileDefault Style. Extend Ionic directives to work with WebRatio.
     */
    var module = angular.module('mobileDefault.ionicExtension', [ 'wr.mvc.App', 'ionic' ]);

    /*
     * module.config(function($ionicConfigProvider) { // disable ionic js scrolling on android and use native scroll
     * $ionicConfigProvider.platform.android.scrolling.jsScrolling(false); });
     */

    /*
     * Customize Back Button Action
     */
    module.run(function(wrEventsHub, $ionicPlatform) {
        /*
         * Use a priority that is just higher than PLATFORM_BACK_BUTTON_PRIORITY_VIEW, i.e. the priority of the default back button
         * handler of Ionic. In this way we are overriding only the undesired Ionic behavior of closing our application, but still
         * preserve other functionality such as modal dialogs.
         */
        var priority = 101; // PLATFORM_BACK_BUTTON_PRIORITY_VIEW + 1

        var notifyEvent = wrEventsHub.overrideBackButtonNotification();
        function ionicButtonHandler() {
            notifyEvent();
        }

        $ionicPlatform.registerBackButtonAction(ionicButtonHandler, priority);
    });

    /*
     * Make Ionic aware of WebRatio scope disconnection
     */
    module.directive("wrScreen", [function() {
        return {
            restrict: "A",
            link: function($scope) {
                $scope.$on("wrViewLeaving", function() {
                    $scope.$$disconnected = true;
                    $scope.$broadcast("$ionic.disconnectScope", $scope);
                });
                $scope.$on("wrViewEntering", function() {
                    $scope.$$disconnected = false;
                    $scope.$broadcast("$ionic.reconnectScope", $scope);
                });
            }
        };
    }]);

    /*
     * Fix native-scrolled containers not being fully scrollable on some platforms.
     */
    module.directive("ionContent", ["$rootScope", function($rootScope) {
        if (!(device.platform === "Android" || device.platform === "android")) {
            return {}; // only on Android
        }
        var androidVersion = ionic.Platform.version().toString();
        if (!/^4\.[0123]/.test(androidVersion)) {
            return {}; // only on selected Android versions
        }
        
        var monitoringStarted = false;
        var ionContentElems = [];
        
        function link(scope, element, attrs) {
            if (attrs["overflowScroll"] !== "true") {
                return;
            }
            
            if (!monitoringStarted) {
                monitoringStarted = true;
                window.setInterval(monitor, 200);
            }
            
            scope.$on("$destroy", function() {
                for (var i = 0; i < ionContentElems.length; i++) {
                    if (ionContentElems[i] === element) {
                        ionContentElems.splice(i, 1);
                        break;
                    }
                }
            });
            
            ionContentElems.push(element);
        }
        
        function monitor() {
            for (var i = 0; i < ionContentElems.length; i++) {
                fixScroll(ionContentElems[i][0]);
            }
        }
        
        function fixScroll(element) {
            var fixKey = "" + element.scrollWidth + "," + element.srollHeight;
            /*
            if (element["__wr_scroll_fixed"] === fixKey) {
                return;
            }
            console.log("fixing", element);
            */
            
            var computedStyle = window.getComputedStyle(element);
            var oldWidth, oldHeight;
            if (computedStyle.overflowX === "scroll") {
                oldWidth = element.style.width;
                element.style.width = element.offsetWidth + "px";
            }
            if (computedStyle.overflowY === "scroll") {
                oldHeight = element.style.height;
                element.style.height = element.offsetHeight + "px";
            }
            
            if (oldWidth !== undefined || oldHeight !== undefined) {
                setTimeout(function() {
                    if (oldWidth !== undefined) {
                        element.style.width = oldWidth;
                    }
                    if (oldHeight !== undefined) {
                        element.style.height = oldHeight;
                    }
                }, 0);
            }
            
            /*element["__wr_scroll_fixed"] = fixKey;*/
        }
        
        return {
            restrict: 'E',
            priority: 1000,
            link: link
        };
    }]);

    module.directive('alignTitle', [ '$timeout', '$ionicNavBarDelegate', function($timeout, $ionicNavBarDelegate) {
        function link(scope, element, attr) {
            scope.$on('wrScreenSwitchSuccess', function() {
                $timeout(function() {
                    scope.$emit("$ionicHeader.align");
                });
            });
        }

        return {
            restrict: 'A',
            priority: 1000,
            link: link
        };
    } ]);

    module.directive('hasFooter', [ function() {

        function compile(element, attr) {
            var next = element.next();
            if (next.length && next.children().eq(0).hasClass('tabs')) {
                element.addClass('has-tabs').removeClass('has-footer');
            }
        }

        return {
            restrict: 'C',
            compile: compile
        };
    } ]);

})();
