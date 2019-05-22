/**
 * Service for Message view components.
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

        /**
         * @private
         * @type {?string}
         */
        this._defaultMessage = descr["defaultMessage"] || null;

        /**
         * @private
         * @type {?Array}
         */
        this._placeholders = descr["placeholders"];
    },

    /** @override */
    createResult: function(context) {
        var input = context.getInput();

        /* Get messages from input, or use the default one */
        var messages = input["messages"];
        if (messages === undefined) {
            messages = this._defaultMessage;
        }

        /* Get placeholders values and replace in messages */
        var placeholder = {};
        for (placeholder in this._placeholders) {
            var value = "";
            placeholder = this._placeholders[placeholder];
            if (input[placeholder["name"]] !== undefined) {
                value = input[placeholder["name"]];
            }
            var exp = new RegExp("\\$\\$" + placeholder["label"] + "\\$\\$", "g");
            if (angular.isArray(messages)) {
                var message = null;
                for (message in messages) {
                    messages[message] = messages[message].replace(exp, value);
                }
            } else {
                messages = messages.replace(exp, value);
            }
        }

        return {
            "messages": wrm.data.toStringArray(messages)
        };
    },

});
