
(function() {
	var GLOBAL = this;
	var _emulatorSupport = null;
	
	function doBootstrap() {
		defineModules()
		configureApp().then(function() {
			return bootstrapApp();
		}).catch(function(e) {
			console.error("Bootstrap error", e);
		});
	}
	
	function enableEmulatorSupport() {
		var wrx = GLOBAL.wrx;
		var emulatorSupport = wrx && wrx.EmulatorSupport;
		if (emulatorSupport) {
			emulatorSupport.start();
			_emulatorSupport = emulatorSupport;
		}
	}
	
	function defineModules() {
		
	}
	
	function configureApp(overrides) {
		var config = angular.module("wr.mvc.App.CONFIG", []);
		
		return Promise.resolve(_emulatorSupport ? _emulatorSupport.getConfigOverrides() : {}).then(function(configOverrides) {
			function setConfigProp(name, overrideKey, value) {
				var overrideValue = configOverrides[overrideKey];
				if (typeof overrideValue !== "undefined") {
					config.constant(name, overrideValue);
				} else {
					config.constant(name, value);
				}
			}
			
			
				setConfigProp("WRAPP_LOG_ENABLED", "logEnabled", true );
			
				setConfigProp("WRAPP_LOG_DB_ENABLED", "logDbEnabled", false );
			
				setConfigProp("WRAPP_LOG_TIMESTAMP", "logTimestamp", "short" );
			
				setConfigProp("WRAPP_LOG_MAX_ARG_LENGTH", "logMaxArgLength", "2147483647" );
			
				setConfigProp("WRAPP_EXTRA_SAFE_URL_PROTOCOLS", "extraSafeUrlProtocols", "http|https|tel|mailto|sms|market|maps|geo|google.navigation" );
			
				setConfigProp("WRAPP_EXTRA_SAFE_IMG_PROTOCOLS", "extraSafeImgProtocols", "" );
			
				setConfigProp("WRAPP_STORAGE_PREFIX", "storagePrefix", "wr|" );
			
				setConfigProp("WRAPP_NOTIFICATIONS_SENDER_ID", "notificationsSenderId", "emulator" );
			
				setConfigProp("WRAPP_DEFAULT_LOCALE", "defaultLocale", "en" );
			
				setConfigProp("WRAPP_ROUTER_VIEW_CACHE_SIZE", "routerViewCacheSize", "10" );
			
				setConfigProp("WRAPP_NETWORK_TIMEOUT", "networkTimeout", "30000" );
			
		});
	}
	
	function bootstrapApp() {
		var modules = [];
		
			modules.push("wr.mvc.App");
		
			modules.push("ngAnimate");
		
			modules.push("wr.mvc.mgmt.AppManagement");
		
			modules.push("mobileDefault.activityBehavior");
		
			modules.push("mobileDefault.ionicExtension");
		
			modules.push("angularExtension");
		
		angular.bootstrap(document, modules);
	}
	
	enableEmulatorSupport();
	
		document.addEventListener("deviceready", function() {
			doBootstrap();
		}, false);
	
	
})();