/**
 * Service for Update operations.
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
        this._entity; // init'd below

        /**
         * @private
         * @type {boolean}
         */
        this._userServiceMode = descr["userService"] || false;

        /**
         * @private
         * @type {boolean}
         */
        this._bulk = descr["bulk"] || false;

        /**
         * @private
         * @type {!wrm.data.Condition}
         */
        this._condition; // init'd below

        /**
         * @private
         * @type {!wrm.data.Condition}
         */
        this._keyCondition; // init'd below

        /**
         * @private
         * @type {!wrm.data.DataService}
         */
        this._dataService; // init'd below

        /** @private {!Array<string>} */
        this._conditionInputKeys; // init'd below

        /** @private {!Array<string>} */
        this._updateInputKeys; // init'd below

        return this.getManager().getDataService().then(function(dataService) {
            thisService._entity = dataService.getMetadata().getEntity(descr["entity"]);
            thisService._condition = dataService.prepareCondition(thisService._entity.getId(), descr["condExprs"]);
            var keyId = thisService._entity.getKeyAttribute().getId();
            thisService._keyCondition = dataService.prepareCondition(thisService._entity.getId(), {
                "property": keyId,
                "operator": "eq",
                "valueInput": "keyId",
                "config": {
                    "oneImpliedInputRequired": false
                }
            });
            thisService._dataService = dataService;

            /* Compute the parameter keys expected as inputs */
            thisService._conditionInputKeys = thisService._condition.getExplicitInputNames().slice(); // clone
            thisService._updateInputKeys = thisService._entity.getProperties().map(function(property) {
                return property.getId();
            });
        });
    },

    /** @override */
    executeOperation: function(context) {
        var input = context.getInput();

        /* Update in a different way for User and other entities */
        var updatePromise;
        if (this._userServiceMode) {
            updatePromise = this._executeUserUpdate(input);
        } else {
            updatePromise = this._executeOtherUpdate(input);
        }

        /* Output the updated keys */
        var keyAttrId = this._entity.getKeyAttribute().getId();
        return updatePromise.then(function(updatedKeys) {
            var output = {};
            output[keyAttrId] = updatedKeys;
            var code = (updatedKeys.length === 0 ? "success.Not Found" : "success");
            return new wrm.nav.Output(code, output);
        });
    },

    /**
     * @private
     * @param {!wrm.nav.Input} input
     * @return {!Promise<!Array>}
     */
    _executeUserUpdate: function(input) {
        var manager = this.getManager();

        /* Update through the security service (will also update on database) */
        var oldPassword = wrm.data.toString(input["oldPassword"]) || null;
        var newPassword = wrm.data.toString(input["newPassword"]) || null;
        var newValues = this._extractInputObject(input, this._updateInputKeys, 0);
        return manager.getSecurityService().then(function(securityService) {
            return securityService.updateUserInfo(newValues, oldPassword, newPassword);
        }).then(function(newUserInfo) {
            var key = newUserInfo.getKey();
            return (key !== undefined ? [ key ] : []);
        });
    },

    /**
     * @private
     * @param {!wrm.nav.Input} input
     * @return {!Promise<!Array>}
     */
    _executeOtherUpdate: function(input) {
        if (this._bulk) {
            return this._updateBulk(input);
        } else {
            return this._updateSingle(input);
        }
    },

    /**
     * @private
     * @param {!wrm.nav.Input} input
     * @return {!Promise<!Array>}
     */
    _updateSingle: function(input) {
        var condition = this._condition;
        var entityId = this._entity.getId();

        /* Update on database */
        var newObject = this._extractInputObject(input, this._updateInputKeys, 0);
        return this._dataService.execute(function(d) {
            return d.update(entityId, {
                filter: condition,
                update: newObject
            }, input);
        });
    },

    /**
     * @private
     * @param {!wrm.nav.Input} input
     * @return {!Promise<!Array>}
     */
    _updateBulk: function(input) {
        var thisService = this;
        var condition = this._condition;
        var entityId = this._entity.getId();

        /* Determine the number of updates and check input consistency */
        var valuesCount = this._computeObjectsCount(input, this._updateInputKeys);
        var updateCount = this._computeObjectsCount(input, this._conditionInputKeys);
        if (valuesCount > 1 && valuesCount < updateCount) {
            throw new Error("Invalid number of inputs for bulk update");
        }

        return this._dataService.execute(function(d) {
            var results = [];
            var promise = Promise.resolve();

            for (var index = 0; index < updateCount; index++) {
                (function() {
                    var newObject = thisService._extractInputObject(input, thisService._updateInputKeys, index);
                    var bulkInput = thisService._extractInputObject(input, thisService._conditionInputKeys, index);
                    promise = promise.then(function() {
                        return d.update(entityId, {
                            filter: condition,
                            update: newObject
                        }, bulkInput).then(function(result) {
                            results.push(result);
                        });
                    });
                })();
            }

            return promise.then(function() {
                var updatedObjectsKeys = [];
                results.forEach(function(updatedObj) {
                    updatedObj.forEach(function(key) {
                        updatedObjectsKeys.push(key);
                    });
                });
                return updatedObjectsKeys;
            });
        });
    },

    /**
     * @private
     * @param {!Object} newObject
     * @param {!Object} input
     * @return {!Promise}
     */
    _execUpdate: function(newObject, input) {
        var thisService = this;
        var entityId = this._entity.getId();
        return this._dataService.execute(function(d) {
            return d.update(entityId, {
                output: entityId,
                filter: thisService._keyCondition,
                update: newObject
            }, input);
        });
    },

    /**
     * @private
     * @param {!wrm.nav.Input} input
     * @param {!Array<string>} keys
     * @return {number}
     */
    _computeObjectsCount: function(input, keys) {
        var arrayLen = 0;
        var foundScalars = false;
        keys.forEach(function(key) {
            var value = input[key];
            if (value !== undefined) {
                var valueLen = Array.isArray(value) ? value.length : 1;
                if (valueLen === 1) {
                    foundScalars = true;
                } else if (arrayLen === 0) {
                    arrayLen = valueLen;
                } else if (arrayLen !== valueLen) {
                    throw new Error("Lengths of input arrays differ");
                }
            }
        });
        if (arrayLen <= 0 && !foundScalars) {
            return 0;
        }
        return arrayLen > 0 ? arrayLen : 1; // foundScalar true here
    },

    /**
     * @private
     * @param {!wrm.nav.Input} input
     * @param {!Array<string>} keys
     * @param {number} index
     * @return {!Object}
     */
    _extractInputObject: function(input, keys, index) {
        var result = {};
        keys.forEach(function(key) {
            var value = input[key];
            if (value !== undefined) {
                if (!Array.isArray(value)) {
                    result[key] = value;
                } else if (value.length === 1) {
                    result[key] = value[0];
                } else {
                    result[key] = value[index];
                }
            }
        });
        return result;
    },

});
