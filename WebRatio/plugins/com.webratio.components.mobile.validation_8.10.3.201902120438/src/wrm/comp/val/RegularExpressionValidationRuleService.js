/**
 * Service for Regular Expression validation rules.
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

        /**
         * @private
         * @type {string|undefined}
         */
        this._ignoreCase = (descr["ignoreCase"] ? "i" : undefined);

        /**
         * @private
         * @type {RegExp}
         */
        this._regex = new RegExp(descr["regex"], this._ignoreCase);
    },

    /** @override */
    validate: function(context) {
        var property = context.getElement();
        var propertyValue = property.getValue();
        if (propertyValue === undefined || propertyValue === null || propertyValue === "") {
            return wrm.val.RulePolicy.CONTINUE;
        }
        if (!this._regex.exec(propertyValue)) {
            property.addError(this.getMessageKey("error"));
            return wrm.val.RulePolicy.STOP;
        }
        return wrm.val.RulePolicy.CONTINUE;
    },

});
