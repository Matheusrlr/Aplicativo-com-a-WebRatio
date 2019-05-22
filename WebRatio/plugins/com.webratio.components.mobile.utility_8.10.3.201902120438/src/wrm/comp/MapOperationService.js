/**
 * Service for Map Operation operations.
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

        var thisService = this;
        var input = context.getInput();

        return Promise.resolve().then(function(value) {

            if (!input["sourceAddress"] || !input["destinationAddress"]) {
                throw new Error("Source or destination address is missing.");
            }
            launchnavigator.navigate(input["destinationAddress"], {
                start: input["sourceAddress"]
            });
            return new wrm.nav.Output("success");
        }, function(error) {
            // never called
        });
    },
});