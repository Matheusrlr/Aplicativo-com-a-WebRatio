(function($data) {
	$data.Class.define("$data.ES6Deferred", $data.PromiseHandlerBase, null, {
		constructor: function() {
			var self = this;
			this.deferred = {};
			this.deferred._promise = new Promise(function(resolve, reject) {
				self.deferred.resolve = resolve;
				self.deferred.reject = reject;
			});
		},
		createCallback: function(callback) {
			var self = this;
			callback = $data.typeSystem.createCallbackSetting(callback);
			
			return {
				success: function() {
					callback.success.apply(self.deferred, arguments);
					self.deferred.resolve.apply(self.deferred, arguments);
				},
				error: function() {
					Array.prototype.push.call(arguments, self.deferred);
					callback.error.apply(self.deferred, arguments);
				},
				notify: function() {
					callback.notify.apply(self.deferred, arguments);
				}
			};
		},
		getPromise: function() {
			return this.deferred._promise;
		}
	}, null);
	
	$data.PromiseHandler = $data.ES6Deferred;
})($data);
