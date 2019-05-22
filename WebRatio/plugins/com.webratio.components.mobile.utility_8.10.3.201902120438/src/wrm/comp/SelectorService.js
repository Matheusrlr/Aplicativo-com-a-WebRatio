/**
 * Service for Selector view components and operations.
 * 
 * @constructor
 * @extends wrm.core.AbstractCachedViewComponentService
 * @implements wrm.OperationService
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
         * @type {!wrm.data.meta.Entity}
         */
        this._entity; // init'd below

        /**
         * @private
         * @type {string}
         */
        this._entityId; // init'd below

        // TODO cache query instead
        /**
         * @private
         * @type {!Object}
         */
        this._condExpr; // init'd below

        /**
         * @private
         * @type {!number}
         */
        this._maxResults = descr["maxResults"];

        /**
         * @private
         * @type {!boolean}
         */
        this._distinct = descr["distinct"] || false;

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

        /**
         * @private
         * @type {!Array}
         */
        this._order = descr["order"];

        /**
         * @private
         * @type {!wrm.data.DataService}
         */
        this._dataService; // init'd below

        return this.getManager().getDataService().then(function(dataService) {
            thisService._dataService = dataService;
            thisService._entity = dataService.getMetadata().getEntity(descr["entity"]);
            thisService._entityid = thisService._entity.getId();
            thisService._condExpr = descr["condExprs"];
            var output = descr["output"];
            thisService._output = {};
            thisService._toBind = {};
            if (output.length !== 0) {
                output.forEach(function(column) {
                    thisService._output[column["viewName"]] = column["ref"];
                    thisService._toBind[column["viewName"]] = column["bindName"];
                });
            } else {
                var keyAtt = thisService._entity.getKeyAttribute();
                thisService._output[keyAtt.getName()] = keyAtt.getId();
                thisService._toBind[keyAtt.getName()] = keyAtt.getId();
            }
        });
    },

    /** @override */
    executeOperation: function(context) {
        var resultsPromise = this._askResult(context.getInput());
        var thisService = this;

        return resultsPromise.then(function(rows) {

            var outputResult = [];
            var toBind = thisService._toBind;
            var outputLabels = thisService._output;

            rows.forEach(function(currentRow) {
                var outputData = {};
                Object.keys(outputLabels).forEach(function(key) {
                    outputData[toBind[key]] = currentRow[key];
                });
                outputResult.push(outputData);
            });

            var output = {
                "data": wrm.util.obj.extractPropertyValues(outputResult),
                "dataSize": rows.length
            };

            var code = (output["dataSize"] === 0 ? "success.Not Found" : "success");
            return new wrm.nav.Output(code, output);
        }, function(e) {
            return new wrm.nav.Output("error");
        });
    },

    /** @override */
    createResult: function(context) {
        var input = context.getInput();
        var thisService = this;
        var resultsPromise = this._askResult(input);

        return resultsPromise.then(function(rows) {

            var outputResult = [];
            var toBind = thisService._toBind;
            var outputLabels = thisService._output;

            rows.forEach(function(currentRow) {
                var outputData = {};
                Object.keys(outputLabels).forEach(function(key) {
                    outputData[toBind[key]] = currentRow[key];
                });
                outputResult.push(outputData);
            });

            var output = {
                "data": wrm.util.obj.extractPropertyValues(outputResult),
                "dataSize": rows.length
            };

            return output;
        }, function(e) {
            thisService.getLog().error(e);
        });
    },

    /** @override */
    isStaleResult: function(context, result) {
        return result["dataSize"] === 0;
    },

    /** @override */
    computeOutputFromResult: function(context, result) {
        var output = {
            "data": result["data"],
            "dataSize": result["dataSize"]
        };
        return output;
    },

    /**
     * @private
     * @param {!wrm.nav.Input} input
     * @returns {Promise|Array.<Object>}
     */
    _askResult: function(input) {
        var thisService = this;
        return this._dataService.execute(function(d) {
            var options = {
                output: thisService._output,
                outputConfig: {
                    useNames: true
                },
                distinct: thisService._distinct,
                filter: thisService._condExpr,
                order: thisService._order
            };

            var resultsLength = input["maxResults"] || thisService._maxResults;
            if (resultsLength > 0) {
                var limit = {
                    count: resultsLength
                };
                options["limit"] = limit;
            }

            return d.select(thisService._entityid, options, input);
        });
    },

});
