/**
 * Service for catching NotificationEvent.
 * 
 * @constructor
 * @extends wrm.core.AbstractCatcherService
 * @param {string} id
 * @param {!Object} descr
 * @param {!wrm.core.Manager} manager
 */
export default wrm.defineService(wrm.core.AbstractCatcherService, {

    /** @override */
    initialize: function(descr) {

        /** @private {string} */
        this._notificationName = descr["notificationName"];

        /** @private {!Object<string,string>} */
        this._parameterOutputNames = descr["parameterOutputs"];
    },

    /** @override */
    subscribe: function(context) {
        var notificationName = this._notificationName;
        var platform = this.getManager().getPlatform();
        var notify = context.getNotifierFunction();

        /* Suppress startup navigation if there are queued push notifications that will be received after subscribing */
        var promise = platform.hasPendingNotifications().then(function(pendingNotificationsPresent) {
            if (pendingNotificationsPresent) {
                context.suppressStartupNavigation();
            }
        });

        /* Subscribe to push notifications having the expected name */
        return promise = promise.then(function() {
            return platform.subscribeNotifications(notificationName, function(notification) {
                notify({
                    "title": notification.title,
                    "message": notification.message,
                    "parameters": notification.parameters
                });
            });
        });
    },

    /** @override */
    catchEvent: function(context, event) {
        var parametersOutputNames = this._parameterOutputNames;
        var eventParameters = event.getParameters();

        var output = {};
        output["title"] = eventParameters["title"];
        output["message"] = eventParameters["message"];

        /* Output parameters by their output name */
        var notificationParameters = /** @type {!Object<string,string>} */
        (eventParameters["parameters"]);
        Object.keys(notificationParameters).forEach(function(name) {
            var outputName = parametersOutputNames[name];
            if (outputName) {
                output[outputName] = notificationParameters[name];
            }
        });

        return output;
    },

});