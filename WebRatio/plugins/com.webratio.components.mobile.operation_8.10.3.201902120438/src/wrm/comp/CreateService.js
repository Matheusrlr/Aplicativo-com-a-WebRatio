/**
 * Service for Create operations.
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
        this._bulk = descr["bulk"] || false;

        /**
         * @private
         * @type {!wrm.data.DataService}
         */
        this._dataService; // init'd below

        return this.getManager().getDataService().then(function(dataService) {
            thisService._entity = dataService.getMetadata().getEntity(descr["entity"]);
            thisService._dataService = dataService;
        });

    },

    /** @override */
    executeOperation: function(context) {
        var input = context.getInput();

        /* Create the creation promise */
        var createPromise = this._executeCreate(input);

        /* Output the created attribute values */
        return createPromise.then(function(createdValues) {
            return new wrm.nav.Output("success", createdValues);
        });
    },

    /**
     * @private
     * @param {!wrm.nav.Input} input
     * @return {!Promise.<!wrm.nav.Output>}
     */
    _executeCreate: function(input) {
        var entityId = this._entity.getId();
        var keyAttrId = this._entity.getKeyAttribute().getId();
        var dataService = this._dataService;

        /* Prepare new object(s) */
        var newValues;
        if (!this._bulk) {
            newValues = [ this._computeInsertValues(input) ];
        } else {
            newValues = this._computeInsertValuesFromBulk(input);
        }

        /* Insert in database */
        return this._dataService.execute(function(d) {
            return d.insert(entityId, newValues);
        }).then(function(insertedKeys) {

            /* Add inserted keys to all new objects that were inserted */
            for (var i = 0; i < insertedKeys.length; i++) {
                newValues[i][keyAttrId] = insertedKeys[i];
            }

            return dataService.extractPropertyValuesById(newValues, entityId);
        });
    },

    /**
     * @private
     * @param {!wrm.nav.Input} input
     * @return {!Object}
     */
    _computeInsertValues: function(input) {
        var result = {};
        this._entity.getProperties().forEach(function(property) {
            var propertyId = property.getId();
            if (input[propertyId] !== undefined) {
                result[propertyId] = input[propertyId];
            }
        });
        return result;
    },

    /**
     * @private
     * @param {!wrm.nav.Input} input
     * @return {!Array<Object>}
     */
    _computeInsertValuesFromBulk: function(input) {
        var properties = this._entity.getProperties();

        var result = [];

        /* Normalize input values, turning them in arrays of the same length */
        var normalizedInput = {};
        var maxLength = 1;
        for (var i = 0; i < properties.length; i++) {
            var property = properties[i];
            var propertyInput = input[property.getId()];
            if (propertyInput !== undefined) {
                if (angular.isArray(propertyInput)) {
                    if (propertyInput.length !== 1) {
                        if (maxLength === 1) {
                            maxLength = propertyInput.length;
                        } else if (maxLength !== propertyInput.length) {
                            throw new Error("Lengths of input arrays differ");
                        }
                    }
                } else {
                    propertyInput = [ propertyInput ];
                }
                normalizedInput[property.getId()] = propertyInput;
            }
        }

        /* Collect properties at the same indexes into separate value-holding objects */
        for (var k = 0; k < maxLength; k++) {
            var tmpObj = {};
            Object.keys(normalizedInput).forEach(function(propertyId) {
                if (normalizedInput[propertyId].length === 1) {
                    tmpObj[propertyId] = normalizedInput[propertyId][0];
                } else {
                    tmpObj[propertyId] = normalizedInput[propertyId][k];
                }
            });
            result.push(tmpObj);
        }

        return result;
    },

});
