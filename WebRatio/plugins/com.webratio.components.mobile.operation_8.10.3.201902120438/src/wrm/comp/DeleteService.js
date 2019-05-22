/**
 * Service for Delete operations.
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
         * @type {!string}
         */
        this._entityId = descr["entity"];

        // TODO cache query instead
        /**
         * @private
         * @type {!Object}
         */
        this._condExpr; // init'd below

        /**
         * @private
         * @type {!wrm.data.DataService}
         */
        this._dataService; // init'd below

        return this.getManager().getDataService().then(function(dataService) {
            thisService._dataService = dataService;
            thisService._condExpr = descr["condExprs"];
        });
    },

    /** @override */
    executeOperation: function(context) {
        var thisService = this;
        var input = context.getInput();

        var resultsPromise = this._dataService.execute(function(d) {

            var options = {
                filter: thisService._condExpr
            };

            return d.deleteGetCount(thisService._entityId, options, input);
        });

        return resultsPromise.then(function(numberDeletedObj) {
            var code = (numberDeletedObj === 0 ? "success.Not Found" : "success");
            return new wrm.nav.Output(code);
        }, function(e) {
            thisService.getLog().error(e);
            return new wrm.nav.Output("error");
        });
    },

});
