/**
 * Service for View Component view components.
 * 
 * @constructor
 * @extends wrm.core.AbstractCachedViewComponentService
 * @param {string} id
 * @param {!Object} descr
 * @param {!wrm.core.Manager} manager
 */
export default wrm.defineService(wrm.core.AbstractCachedViewComponentService, {

    /** @override */
    createResult: function(context) {
        return {};
    }

});
