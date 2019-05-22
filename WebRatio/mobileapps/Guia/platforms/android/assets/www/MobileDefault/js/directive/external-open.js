(function (angular) {
    'use strict';

    /* open external url in the system browser */
    angular.module('mobileDefault.externalOpen', [])
        .directive('wrExternalOpen', [function () {
            function link(scope, element, attr) {

                element.on('click', function (e) {
                    e.preventDefault();
                    e.stopPropagation();
                    window.open(attr.href, attr.target || '_system');

                    return false;
                });
            }

            return {
                restrict: 'A',
                link: link
            };
        }]);
}(window.angular));