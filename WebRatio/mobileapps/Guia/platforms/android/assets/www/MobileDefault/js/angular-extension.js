(function () {
    /* Module with extension and patches for AngularJS */
    var AngularExtensionModule = angular.module('angularExtension', []);
    
    
    /*
	 * Fix on Select elements 
	 * Force label update on changes 
	 * angular bug: https://github.com/angular/angular.js/issues/7986 
	 * WR bug: #8481
	 */
    AngularExtensionModule.directive('select', function() {
    	
    	function link(scope, elem, attrs, ctrl) {
    		if (ctrl && ctrl.$viewChangeListeners) {
	          ctrl.$viewChangeListeners.push(function() {
	            elem[0].blur();
	          });
	        }
    	}
    	
    	return {
    	      restrict: "E",
    	      require: 'ngModel',
    	      link: link
    	    }
    });
    
})();