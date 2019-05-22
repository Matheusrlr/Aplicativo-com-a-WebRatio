(function() {
	'use strict';
	
	/* Input directive to manage date,time and timestamp when not natively supported */
	angular.module('mobileDefault.dateInput', ['ionic'])
	.directive('input', ['wrInputFormatter', '$window', '$filter', function(wrInputFormatter, $window, $filter) {
		if (!(device.platform === "Android" || device.platform === "android" || device.platform === "Win32NT")) { // Android and Win32NT only
			return {};
		}
		var platformVersion = ionic.Platform.version().toString();
		var supported = false;
		if(device.platform === "Android" || device.platform === "android"){
			supported = (platformVersion.indexOf("4.0") === 0) || (platformVersion.indexOf("4.1") === 0) || (platformVersion.indexOf("4.2") === 0);
		}
		var support = {
			date: isSupportedType('date'),
			time: isSupportedType('time'),
			timestamp: isSupportedType('datetime-local')
		};
		var isOpen = false;
		
		function isSupportedType(type) {
			if (supported) {
				return false;
			}
			var input = document.createElement('input');
			var invalidValue = 'invalidValue';
			input.setAttribute('type', type);
			input.setAttribute('value', invalidValue);
			return !(input.value === invalidValue);
		}
		
		function showPicker(mode, value) {
			return new Promise(function (resolve, reject) {
				$window.plugins.datePicker.show({
					date: value || new Date(),
					mode: mode,
					clearButton: true
				}, function(result) {
					if (result) {
						resolve(result);
					} else {
						reject();
					}
				});
			});
			
		}
		
		function link($scope, $element, $attr, ngModel) {
			var type = $attr.type;
			type = type === 'datetime-local' ? 'timestamp' : type;
			if (!(type in support) || support[type]) {
				return;
			}
			if (device.platform === "Android" || device.platform === "android") {
				// change type because some android have a poor support of native types
				$element.attr('type', 'text');
			}
			var formatter = wrInputFormatter.getFormatter(type);
			var thisIsOpen = false;
			
			ngModel.$render = function(newValue) {
				if (ngModel.$isEmpty(ngModel.$viewValue)) {
					$element.val("");
					return;
				}
				var value = newValue || formatter.toModel(ngModel.$viewValue).asDate();
				var selector = type === "timestamp" ? "date and time" : type;
				
				navigator.globalization.dateToString(
				value,
				function(result) {
					$element.val(result.value);
				},
				function() { // fallback
					if (type === 'date') {
						value = $filter('date')(ngModel.$viewValue, 'longDate');
					} else if (type === 'time') {
						value = $filter('date')(ngModel.$viewValue, 'shortTime');
					} else if (type === 'timestamp') {
						value = $filter('date')(ngModel.$viewValue, 'medium');
					}
					$element.val(value);
				}, {
					selector: selector
				}
				);
				
			};
			
			$element.on('focus', function($event) {
				$event.preventDefault();
				$event.stopPropagation();
				$element[0].blur();
				if (isOpen) {
					return;
				}
				
				isOpen = true;
				thisIsOpen = true;
				var promise = null;
				var currentValue = ngModel.$viewValue;
				if (type === 'date') {
					currentValue = wrm.data.toDate(currentValue);
				} else if (type === 'time') {
					currentValue = wrm.data.toTime(currentValue);
				} else if (type === 'timestamp') {
					currentValue = wrm.data.toTimestamp(currentValue);
				}
				currentValue = currentValue && currentValue.asDate();
				
				if (type === 'timestamp') { // show datepicker and then timepicker
					promise = showPicker('date', currentValue).then(function(value) {
						if (value instanceof Date) {
							var dateValue = value;
							return showPicker('time', currentValue).then(function(timeValue) {
								if (timeValue instanceof Date) {
									return new Date(dateValue.getFullYear(), dateValue.getMonth(), dateValue.getDate(), timeValue.getHours() || 0, timeValue.getMinutes() || 0, timeValue.getSeconds() || 0, timeValue.getMilliseconds() || 0);
								}
								return timeValue;
							});
						}
						return value;
					});
				} else {
					promise = showPicker(type, currentValue);
				}
				
				promise.then(function(value) {
					if (value && value instanceof Date) {
						var newValue = formatter.toView(value);
						ngModel.$setViewValue(newValue);
						ngModel.$render(value);
					} else if (value === "clear") {
						ngModel.$setViewValue("");
						ngModel.$render();
					}
				}, function() {
					
				}).then(function() {
					isOpen = false;
					thisIsOpen = false;
					ionic.trigger('native.keyboardhide');
				});
				
			});
		}
		
		return {
			restrict: 'E',
			require: 'ngModel',
			link: link
		};
	}])
	.directive('input', [function() { // bug #9737
		var version = ionic.Platform.version().toString();			
		
		function compile(element, attrs) {					
			if (attrs.type === 'date') {
				if (!angular.isDefined(attrs.min) && !attrs.ngMin) {
					element.attr("min", "1000-01-01");
				}
				if (!angular.isDefined(attrs.max) && !attrs.ngMax) {
					element.attr("max", "9999-12-31");
				}
			}
		}			
		if ((device.platform === "Android" || device.platform === "android") && (version.indexOf("5.") === 0)) { // Android L only
			return {
				restrict: 'E',
				compile: compile
			};
		}
		return {};
	}])
	.directive('input', [function() { // bug #9869
		var focusBlocked = false;
		
		function link(scope, element, attrs) {					
			if (attrs.type === 'date' || attrs.type === 'time' || attrs.type === 'datetime-local') {						
				element.on('click', function checkBlocked(event) {
					if (focusBlocked) {
						event.preventDefault();
						var oldReadOnly = element[0].readOnly;
						element[0].readOnly = true;
						setTimeout(function() {
							element[0].readOnly = oldReadOnly;
						}, 500);
						return;
					}							
					focusBlocked = true;
					setTimeout(function() {
						focusBlocked = false;
					}, 500);
				});
			}
		}
		
		if ((device.platform === "Android" || device.platform === "android") && device.version === "4.4.2") { // Android 4.4.2 only
			return {
				restrict: 'E',
				link: link
			};				
		}
		return {};            
	}]);
}());