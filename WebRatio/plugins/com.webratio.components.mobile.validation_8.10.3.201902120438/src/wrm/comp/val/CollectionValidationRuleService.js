/**
 * Service for Collection validation rules.
 * 
 * @constructor
 * @extends wrm.val.AbstractPropertyValidationRuleService
 * @param {string} id
 * @param {!Object} descr
 * @param {!wrm.core.Manager} manager
 */
export default wrm.defineService(wrm.val.AbstractPropertyValidationRuleService, {

    /** @override */
    initialize: function(descr) {
        var thisService = this;

        /**
         * @type {string}
         */
        this._predicate = descr["predicate"];

        /**
         * @type {boolean}
         */
        this._ignoreCase = descr["ignoreCase"] || false;

        /**
         * @type {string|undefined}
         */
        this._entityId = descr["entity"] || undefined;

        if (this._entityId !== undefined) {

            // TODO cache query instead
            /**
             * @private
             * @type {!Object}
             */
            this._condExpr; // init'd below

            /**
             * @type {string}
             */
            this._output = descr["output"];

        } else {

            /**
             * @type {Array.<string>}
             */
            this._values = descr["values"].split("|");
        }

        /**
         * @private
         * @type {!wrm.data.DataService}
         */
        this._dataService; // init'd below

        if (this._entityId !== undefined) {
            return this.getManager().getDataService().then(function(dataService) {
                thisService._dataService = dataService;
                thisService._condExpr = descr["condExprs"];
            });
        }
        return Promise.resolve();
    },

    /** @override */
    validate: function(context) {
        var thisService = this;
        var input = context.getInput();
        var property = context.getElement();
        var propertyValue = property.getValue();
        if (propertyValue === undefined || propertyValue === null || propertyValue === "") {
            return wrm.val.RulePolicy.CONTINUE;
        }
        return this._retrieveResultToCompare(input, thisService.getId()).then(function(arrayResult) {
            var key = "";
            var valid = true;
            switch (thisService._predicate) {
            case "in":
                if (!thisService._isIncluded(propertyValue, arrayResult)) {
                    key = "in";
                    valid = false;
                }
                break;
            case "notIn":
                if (thisService._isIncluded(propertyValue, arrayResult)) {
                    key = "notIn";
                    valid = false;
                }
                break;
            }

            if (!valid) {
                if (thisService._entityId !== undefined) {
                    key += ".query";
                    property.addError(thisService.getMessageKey(key));
                } else {
                    property.addError(thisService.getMessageKey(key), {
                        "values": arrayResult.join("|")
                    });
                }
                return wrm.val.RulePolicy.STOP;
            }
            return wrm.val.RulePolicy.CONTINUE;
        });
    },

    /**
     * @private
     * @param {!wrm.nav.Input} input
     * @param {string} conditionId
     * @return {!Promise.<Array.<*>>}
     */
    _retrieveResultToCompare: function(input, conditionId) {
        var thisService = this;
        var promise;

        if (this._entityId === undefined) {
            promise = new Promise(function(resolve) {
                var output = input[conditionId + ".values"] || thisService._values;
                if (!angular.isArray(output)) {
                    output = output.split("|");
                }
                resolve(output);
            });
        } else {
            promise = this._dataService.execute(function(d) {
                var options = {
                    output: thisService._output,
                    outputConfig: {
                        useNames: true
                    },
                    filter: thisService._condExpr
                };
                return d.select(/** @type {string} */
                (thisService._entityId), options, input);
            });
        }

        return promise.then(function(arrayResult) {
            return arrayResult;
        });
    },

    /**
     * @private
     * @param {*} propertyValue
     * @param {Array.<*>} arrayResult
     * @return {boolean}
     */
    _isIncluded: function(propertyValue, arrayResult) {
        var thisService = this;
        var found = false;
        arrayResult.forEach(function(referenceValue) {
            if (found) {
                return;
            }
            var left = (thisService._ignoreCase ? wrm.data.toString(referenceValue).toLowerCase() : wrm.data.toString(referenceValue));
            var right = (thisService._ignoreCase ? wrm.data.toString(propertyValue).toLowerCase() : wrm.data.toString(propertyValue));
            if (wrm.data.equal(left, right)) {
                found = true;
                return;
            }
        });
        return found;
    },

});
