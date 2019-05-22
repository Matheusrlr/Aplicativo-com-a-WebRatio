(function (angular) {
    'use strict';

    /* menuPopover.cell.template directive */
    angular.module('mobileDefault.menuPopover', ["ionic"])
        .directive('wrMenuPopover', ['$ionicPopover', '$document', '$window', '$rootScope', function ($ionicPopover, $document, $window, $rootScope) {

            function controller($scope) {
                $scope.showPopover = function ($event) {
                    if (!$scope.popover.isShown()) {
                        $scope.popover.show($event);
                    }
                };
            }

            function compile(element, attributes) {
                var ionPopoverView = element.find("ion-popover-view")[0].outerHTML;
                element.find("ion-popover-view").remove();

                return function ($scope, $element, $attributes) {

                    $scope.popover = $ionicPopover.fromTemplate(ionPopoverView, {
                        scope: $scope
                    });

                    $element.on('click', $scope.showPopover);

                    $scope.$on('popover.shown', function ($event, $popover) {
                        var popoverEle = angular.element($popover.modalEl),
                            popoverWidth = popoverEle.prop('offsetWidth'),
                            popoverHeight = popoverEle.prop('offsetHeight'),
                            popoverTop = popoverEle.prop('offsetTop'),

                            bodyWidth = $document[0].body.clientWidth,
                            bodyHeight = $window.innerHeight,
                            contentEle = angular.element(popoverEle[0].querySelector('.scroll')),
                            contentWidth = contentEle.prop('offsetWidth'),
                            contentHeight = contentEle.prop('offsetHeight'),
                            contentTop = contentEle.prop('offsetTop'),

                            newHeight = contentHeight + contentTop * 2;

                        if (popoverEle.hasClass('popover-bottom')) {

                            if (popoverTop + (popoverHeight - newHeight) < 0) {
                                newHeight = newHeight + (popoverTop + (popoverHeight - newHeight)) - 20;
                            }
                        } else if (popoverTop + newHeight + 20 > bodyHeight) {
                            newHeight = bodyHeight - popoverTop - 20;
                        }
                        popoverEle.css('height', newHeight + 'px');

                        $popover.positionView(element, popoverEle);

                        $element.addClass("open");
                        
                        $rootScope.$broadcast('overlay.shown');
                    });

                    $scope.$on('popover.hidden', function () {
                        $element.removeClass("open");
                        $rootScope.$broadcast('overlay.hidden');
                    });

                    $scope.$on('$destroy', function () {
                        $scope.popover.remove();
                    });

                };
            }

            return {
                restrict: 'E',
                scope: true,
                compile: compile,
                controller: controller
            };

        }]);
}(window.angular));