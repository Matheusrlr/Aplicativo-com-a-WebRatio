/**
 * Service for Connect operations.
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
        this._sourceEntity = descr["sourceEntity"];

        /**
         * @private
         * @type {!string}
         */
        this._targetEntity = descr["targetEntity"];

        /**
         * @private
         * @type {?wrm.data.meta.Attribute}
         */
        this._sourceKey; // init'd below

        /**
         * @private
         * @type {?wrm.data.meta.Attribute}
         */
        this._targetKey; // init'd below

        /**
         * @private
         * @type {!wrm.data.Condition}
         */
        this._sourceExpr; // init'd below

        /**
         * @private
         * @type {!wrm.data.Condition}
         */
        this._targetExpr; // init'd below

        /**
         * @private
         * @type {!wrm.data.meta.Property}
         */
        this._role; // init'd below

        /**
         * @private
         * @type {!wrm.data.meta.Attribute}
         */
        this._inverseEntityKey; // init'd below

        /**
         * @private
         * @type {!wrm.data.DataService}
         */
        this._dataService; // init'd below

        return this.getManager().getDataService().then(function(dataService) {
            thisService._dataService = dataService;
            var metadata = dataService.getMetadata();
            var currentRole = metadata.getEntity(thisService._sourceEntity).getProperty(descr["role"]);
            thisService._sourceExpr = dataService.prepareCondition(thisService._sourceEntity, descr["sourceExprs"]);
            thisService._targetExpr = dataService.prepareCondition(thisService._targetEntity, descr["targetExprs"]);
            thisService._sourceKey = metadata.getEntity(thisService._sourceEntity).getKeyAttribute();
            thisService._targetKey = metadata.getEntity(thisService._targetEntity).getKeyAttribute();
            thisService._role = currentRole;
            thisService._inverseEntityKey = currentRole.getInverseEntity().getKeyAttribute();
        });

    },

    /** @override */
    executeOperation: function(context) {
        var input = context.getInput();
        var resultsPromise = this._makeResult(input);

        return resultsPromise.then(function(result) {
            return new wrm.nav.Output("success", result);
        }, function(e) {
            return new wrm.nav.Output("error");
        });
    },

    /**
     * @param {!wrm.nav.Input} input
     * @returns {!Object|!Promise.<Object>}
     */
    _makeResult: function(input) {
        var thisService = this;

        /* initialize and clear the result object */
        var result = {};

        result["source" + this._sourceKey.getId()] = [];
        result["target" + this._targetKey.getId()] = [];

        var promises = [];

        /* select all the source and target objects */
        promises.push(this._retrieveEntityData(this._sourceEntity, this._sourceExpr, true, input));
        promises.push(this._retrieveEntityData(this._targetEntity, this._targetExpr, false, input));

        /* wait to have both */
        return Promise.all(promises).then(function(rows) {
            var sourceRows = rows[0];
            var targetRows = rows[1];

            /* execute the updates in chain */
            var internalPromise = Promise.resolve();
            internalPromise = sourceRows.reduce(function(chain, row) {
                return chain.then(function() {
                    var newAssociations = null;
                    if (!thisService._role.isMany()) {
                        newAssociations = targetRows[0];

                        /* fill the result object */
                        result["target" + thisService._targetKey.getId()].push(newAssociations);
                    } else {
                        var oldAssociations = row[thisService._role.getId() + "_" + thisService._inverseEntityKey.getId()];
                        newAssociations = (angular.isArray(oldAssociations) ? oldAssociations : [ oldAssociations ]);
                        targetRows.forEach(function(element) {
                            newAssociations.push(element);

                            /* fill the result object */
                            result["target" + thisService._targetKey.getId()].push(element);
                        });
                    }

                    var updtate = {};
                    updtate[thisService._role.getName()] = newAssociations;

                    /* fill the result object */

                    result["source" + thisService._sourceKey.getId()].push(row[thisService._sourceKey.getName()]);

                    var options = {
                        filter: {
                            property: thisService._sourceKey.getId(),
                            operator: "in"
                        },
                        update: thisService._dataService.extractPropertyValuesByName(updtate, thisService._sourceEntity)
                    };
                    // execute the update
                    return thisService._executeUpdate(thisService._sourceEntity, options, [ row[thisService._sourceKey.getName()] ]);
                });
            }, internalPromise);

            return internalPromise.then(function() {
                return result;
            });
        });
    },

    /**
     * @param {!string} entity
     * @param {!wrm.data.Condition} condExpr
     * @param {!boolean} isSource
     * @param {!wrm.nav.Input} input
     * @return {!*|!Promise.<*>}
     */
    _retrieveEntityData: function(entity, condExpr, isSource, input) {
        var output = (isSource ? [ this._sourceKey.getId(), this._role.getId() + "." + this._inverseEntityKey.getId() ]
                : this._targetKey.getId());
        var resultsPromise = this._dataService.execute(function(d) {
            var options = {
                output: output,
                filter: condExpr
            };
            return d.selectOld(entity, options, input);
        });

        return resultsPromise.then(function(rows) {
            return rows;
        });
    },

    /**
     * @param {!string} entity
     * @param {?} options
     * @param {?} input
     * @returns {!Promise.<!Array.<!*>>}
     */
    _executeUpdate: function(entity, options, input) {
        return this._dataService.execute(function(d) {
            return d.update(entity, options, input);
        });
    },

});
