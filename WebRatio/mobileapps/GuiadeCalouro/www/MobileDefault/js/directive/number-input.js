(function() {
    "use strict";
    
    var module = angular.module("mobileDefault.numberInput", [ "ionic" ]);
    
    /* Input directive for triggering an appropriate IME for decimal number fields */
    module.directive("input", [ function() {
        if (!(device.platform === "Android" || device.platform === "android")) { // Android only
            return {}; // only on Android
        }
        var androidVersion = ionic.Platform.version().toString();
        if (!/^4\.[3]/.test(androidVersion)) {
            return {}; // only on selected Android versions
        }
        
        function link(scope, element, attrs) {
            if (attrs["type"] !== "number" || attrs["step"] !== "any") {
                return;
            }
            element.attr("type", "tel");
        }
        
        return {
            restrict: "E",
            priority: -1,
            link: link
        };
    } ]);
    
    /* Input directive to cope for wrong native validation in number fields */
    module.directive("input", [ function() {
        if (!(device.platform === "Android" || device.platform === "android")) { // Android only
            return {}; // only on Android
        }
        var androidVersion = ionic.Platform.version().toString();
        if (!/^4\.[012]/.test(androidVersion)) {
            return {}; // only on selected Android versions
        }

        /* Next-tick scheduling */
        var schedule = (function() {
            if (typeof window.postMessage === "function") {
                var handlers = [];
                var messageToken = "schedule" + Math.random() + "$";
                window.addEventListener("message", function(event) {
                    if (event.source === window && event.data === messageToken) {
                        var handler = handlers.shift();
                        if (handler) {
                            handler();
                        }
                    }
                });
                return function scheduleWithPostMessage(handler) {
                    handlers.push(handler);
                    window.postMessage(messageToken, "*");
                };
            } else {
                return function scheduleWithSetTimeout(handler) {
                    window.setTimeout(handler, 0);
                };
            }
        })();
        
        function link(scope, element, attrs) {
            if (attrs["type"] !== "number") {
                return;
            }
            var rawElement = element[0];
            
            function resetCorrectValue() {
                var selOffset = rawElement.selectionStart;
                var value = rawElement.value;
                rawElement.value = value;
                selOffset = Math.min(selOffset, value.length);
                rawElement.setSelectionRange(selOffset, selOffset);
            }
            
            function handleKeypress(event) {
                schedule(resetCorrectValue);
            }
            
            element.on("keypress", handleKeypress);
            scope.$on("$destroy", function() {
                element.off("keypress", handleKeypress);
            });
        }

        return {
            restrict: "E",
            priority: -2,
            link: link
        };
    } ]);
})();