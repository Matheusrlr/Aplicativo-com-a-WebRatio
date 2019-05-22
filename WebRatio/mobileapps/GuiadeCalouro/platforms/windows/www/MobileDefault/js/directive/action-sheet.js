(function (angular) {
    'use strict';

    angular.module('mobileDefault.actionSheet', [])
        .directive('wrActionSheet', [function () {

            function compile(element, attributes) {
                var buttonLabels = [],
                    buttonActions = [],
                    buttons = element.find('wr-action-sheet-button'),
                    i,
                    $btn;

                for (i = 0; i < buttons.length; i += 1) {
                    $btn = angular.element(buttons[i]);
                    buttonLabels.push($btn.html());
                    buttonActions.push($btn.attr("action"));
                }
                buttons.remove();


                /* Link function */
                return function ($scope, $element, $attributes) {
                    var title = $attributes.title,
                        cancelButton = $attributes.cancelButton;

                    function callback(btnIndex) {
                        if (btnIndex <= buttonActions.length) {
                            $scope.$eval(buttonActions[btnIndex - 1]);
                        }
                    }

                    $element.on('click', function (e) {
                        var options = {
                            'title': title,
                            'buttonLabels': buttonLabels
                        };

                        if (cancelButton && cancelButton !== '') {
                            options.androidEnableCancelButton = true;
                            options.addCancelButtonWithLabel = cancelButton;
                        }

                        window.plugins.actionsheet.show(options, callback);

                    });

                };
            }

            return {
                restrict: 'E',
                compile: compile
            };

        }]);
}(window.angular));