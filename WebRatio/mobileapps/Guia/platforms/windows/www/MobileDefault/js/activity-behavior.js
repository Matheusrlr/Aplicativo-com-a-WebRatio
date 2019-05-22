(function () {
	/* Module with customizations for MobileDefault Style */
	var module = angular.module('mobileDefault.activityBehavior', ['wr.mvc.App']);
	
	/* Wait experience using native dialogs */
	module.run([
		'$rootScope', '$filter',
		function($rootScope, $filter) {
			var DEFAULT_MESSAGE_KEY = "notification.activityProgress";
			var localizer = $filter('wrLocalize');
		
			// wrEntranceComplete: when all startup activities are completed and the first screen is loaded
			var screenSwitchOff = $rootScope.$on("wrEntranceComplete", function() {
				screenSwitchOff(); //Remove listener
				navigator.splashscreen.hide();
			});
		
			$rootScope.$on("wrActivityStart", function() {
				navigator.notification.activityStart("", localizer(DEFAULT_MESSAGE_KEY) , false);
			});
			$rootScope.$on("wrActivityProgress", function(event, args) {
				navigator.notification.activityStart("", args.message ? escapeHtml(args.message) : localizer(DEFAULT_MESSAGE_KEY), false);
			});
			$rootScope.$on("wrActivityStop", function() {
				navigator.notification.activityStop();
			});
		}
	]);
	
	/* Wait experience using ionic  */
	/*
	module.run([
		'$rootScope', '$location', '$ionicLoading',
		function($rootScope, $location, $ionicLoading) {
			
			document.addEventListener("deviceready", function() {
				navigator.splashscreen.hide();
			}, false);
		
			// Must set an explicit default template because of Ionic bug #2088. Remove when Ionic is updated.
			var DEFAULT_TEMPLATE = "<i class=\"icon ion-loading-d\"></i>";
		
			$rootScope.$on("wrActivityStart", function() {
				if (!inSplashScreen()) {
					$ionicLoading.show({
						template: DEFAULT_TEMPLATE
					});
				}
			});
			$rootScope.$on("wrActivityProgress", function(event, args) {
				if (!inSplashScreen()) {
					$ionicLoading.show({
						template: (args.message ? escapeHtml(args.message) : DEFAULT_TEMPLATE)
					});
				}
			});
			$rootScope.$on("wrActivityStop", function() {
				if (!inSplashScreen()) {
					$ionicLoading.hide();
				}
			});
		
			function inSplashScreen() {
				return ($location.url() === '/');
			}
		
		}
	]);
	*/	
	
	/*
	 * Utilities
	 */

	var escapeHtml = (function() {
		var escaper = document.createElement("DIV");
		return function(s) {
			escaper.innerText = s;
			var result = escaper.innerHTML;
			escaper.innerText = "";
			return result;
		};
	})();
	
})();