/**
 * Service for Login operations.
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
        this._onlySaveCredentials = descr["onlySaveCredentials"] || false;

        /**
         * @private
         * @type {!wrm.core.SecurityService}
         */
        this._securityService; // set below

        /**
         * @private
         * @type {!wrm.data.DataService}
         */
        this._dataService; // set below

        return Promise.all([ this.getManager().getSecurityService().then(function(securityService) {
            thisService._securityService = securityService;
        }), this.getManager().getDataService().then(function(dataService) {
            thisService._dataService = dataService;
        }) ]);
    },

    /** @override */
    executeOperation: function(context) {
        var thisService = this;
        var securityService = this._securityService;
        var input = context.getInput();

        var username = wrm.data.toString(input["username"]);
        var password = wrm.data.toString(input["password"]);
        var token = wrm.data.toString(input["token"]);

        if (typeof username !== "string" || typeof password !== "string") {
            throw new Error('Missing username or password');
        }

        var oldAuthUsername;

        /*
         * Change the currently logged in user, possibly by first authenticating. The chosen behavior depends on the
         * 'onlySaveCredentials' specified by the descriptor.
         */
        var promise = securityService.retrieveAuthUsername().then(function(oldUsername) {
            oldAuthUsername = oldUsername;
        }).then(function() {
            if (thisService._onlySaveCredentials) {
                return securityService.changeUser(username, password, token);
            }
            return securityService.authenticateChangeUser(username, password);
        });

        /* If logged in correctly, reset data and environment as needed by the new user */
        promise = promise.then(function() {
            if (!oldAuthUsername || (oldAuthUsername !== username)) {
                return thisService._dataService.restoreInitialData();
            }
        }).then(function() {
            context.clearPastNavigationsHistory();
            return new wrm.nav.Output("success");
        });

        /* In case of error, return an appropriate output code */
        promise = promise["catch"](function(e) {
            var result = (e instanceof wrm.core.AuthenticationError ? "error" : "error.Internal Error");
            return new wrm.nav.Output(result, {
                "errorMessage": e.message
            });
        });

        return promise;
    },

});
