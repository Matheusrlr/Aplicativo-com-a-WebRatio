(function () {
	"use strict";
	angular.module('mobileDefault.select', ['ionic']).directive('select', selectDirective);
	function selectDirective() {
		if (device.platform !== "Win32NT") { // Win32NT only
			return {};
		}		
		return {
			restrict: 'E',
			replace: false,
			link: function (scope, element) {
				element.attr('data-tap-disabled', 'true');
			}
		};
	}
})();