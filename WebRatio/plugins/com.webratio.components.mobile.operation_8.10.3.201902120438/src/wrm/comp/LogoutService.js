/**
 * Service for Logout operations.
 * 
 * @constructor
 * @extends wrm.core.AbstractOperationService
 * @param {string} id
 * @param {!Object} descr
 * @param {!wrm.core.Manager} manager
 */
export default wrm.defineService(wrm.core.AbstractOperationService, {

    /** @override */
    initialize: function(descr) {
        var thisService = this;

        /**
         * @private
         * @type {boolean}
         */
        this._removeUsername = descr["removeUsername"] || false;

        /**
         * @private
         * @type {!wrm.core.SecurityService}
         */
        this._securityService; // set below

        return this.getManager().getSecurityService().then(function(securityService) {
            thisService._securityService = securityService;
        });
    },

    /** @override */
    executeOperation: function(context) {
        var securityService = this._securityService;

        /* Clear authentication information */
        return securityService.clearUser(this._removeUsername).then(function() {
            context.clearPastNavigationsHistory();
            return new wrm.nav.Output("success");
        }, function() {
            return new wrm.nav.Output("error");
        });
    },

});
