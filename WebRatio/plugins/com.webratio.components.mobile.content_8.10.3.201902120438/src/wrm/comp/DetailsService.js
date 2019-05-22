/**
 * Service for Details view components.
 * 
 * @constructor
 * @extends wrm.core.AbstractCachedViewComponentService
 * @param {string} id
 * @param {!Object} descr
 * @param {!wrm.core.Manager} manager
 */
export default wrm.defineService(wrm.core.AbstractCachedViewComponentService, {

    /** @override */
    initialize: function(descr) {
        var thisService = this;

        /**
         * @private
         * @type {!string}
         */
        this._entityId = descr["entity"];

        /**
         * @private
         * @type {!Object}
         */
        this._output; // init'd below

        /**
         * @private
         * @type {!Object}
         */
        this._toBind; // init'd below

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
            var output = descr["output"];
            thisService._output = {};
            thisService._toBind = {};
            if (output.length !== 0) {
                output.forEach(function(column) {
                    thisService._output[column["viewName"]] = column["ref"];
                    thisService._toBind[column["viewName"]] = column["bindName"];
                });
            }
        });
    },

    /** @override */
    createResult: function(context) {
        var thisService = this;
        var input = context.getInput();

        var resultsPromise = this._dataService.execute(function(d) {
            var options = {
                output: thisService._output,
                outputConfig: {
                    useNames: true
                },
                filter: thisService._condExpr
            };
            return d.selectOne(thisService._entityId, options, input);
        });

        return resultsPromise.then(function(row) {
            return {
                "data": row
            };
        }, function(e) {
            thisService.getLog().error(e);
        });
    },

    /** @override */
    isStaleResult: function(context, result) {
        return !result["data"];
    },

    /** @override */
    computeOutputFromResult: function(context, result) {
        return this._createOutput(result["data"]);
    },

    /** @override */
    submitView: function(context) {
        return this._createOutput(context.getView()["data"]);
    },

    /**
     * @private
     * @param {!Object} data
     * @returns {!Object}
     */
    _createOutput: function(data) {
        var output = {};
        if (data === null) {
            output["dataSize"] = 0;
        } else {
            var toBind = this._toBind;
            var outputData = {};
            Object.keys(this._output).forEach(function(key) {
                outputData[toBind[key]] = data[key];
            });
            output["data"] = outputData;
            output["dataSize"] = 1;
        }
        return output;
    },

});
