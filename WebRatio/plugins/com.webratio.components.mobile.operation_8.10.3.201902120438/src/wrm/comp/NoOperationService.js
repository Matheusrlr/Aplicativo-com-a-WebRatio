/**
 * Service for Operation operations.
 * 
 * @constructor
 * @extends wrm.core.AbstractOperationService
 * @param {string} id
 * @param {!Object} descr
 * @param {!wrm.core.Manager} manager
 */
export default wrm.defineService(wrm.core.AbstractOperationService, {

    /** @override */
    executeOperation: function(context) {
        return new wrm.nav.Output("success");
    },

});
