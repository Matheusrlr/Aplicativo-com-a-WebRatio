/**
 * Service for Register operations.
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
         * @type {!wrm.data.meta.Entity}
         */
        this._userEntity; // set below

        return this.getManager().getSecurityService().then(function(securityService) {
            thisService._userEntity = securityService.getUserEntity();
            if (!securityService.isUserServiceAvailable()) {
                throw new Error("User services are not available");
            }
        });
    },

    /** @override */
    executeOperation: function(context) {
        var manager = this.getManager();
        var input = context.getInput();
        var username = wrm.data.toString(input["username"]);
        var password = wrm.data.toString(input["password"]);

        /* Compute the user object */
        var userObject = this._computeUserObject(input);

        /* Invoke the back-end user registration service */
        var promise = manager.getSecurityService().then(function(securityService) {
            if (typeof username !== "string" || typeof password !== "string") {
                throw new Error('Missing username or password');
            }
            return securityService.registerUser(username, password, userObject);
        }).then(function(newUserInfo) {
            return new wrm.nav.Output("success", {
                "username": username,
                "password": password
            });
        });

        /* In case of error, return an appropriate output code */
        promise = promise["catch"](function(e) {
            return new wrm.nav.Output("error", {
                "errorMessage": e.message
            });
        });
        return promise;
    },

    /**
     * @private
     * @param {!wrm.nav.Input} input
     * @returns {!Object}
     */
    _computeUserObject: function(input) {
        var result = {};
        this._userEntity.getProperties().forEach(function(property) {
            var propertyId = property.getId();
            if (input[propertyId] !== undefined) {
                result[propertyId] = input[propertyId];
            }
        });
        return result;
    },

});
