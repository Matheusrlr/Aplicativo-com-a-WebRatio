/**
 * Service for Form Not Empty validation rules.
 * 
 * @constructor
 * @extends wrm.val.AbstractObjectValidationRuleService
 * @param {string} id
 * @param {!Object} descr
 * @param {!wrm.core.Manager} manager
 */
export default wrm.defineService(wrm.val.AbstractObjectValidationRuleService, {

    /** @override */
    validate: function(context) {
        var form = context.getElement();
        var formProperties = form.getProperties();
        var valid = false;

        formProperties.forEach(function(field) {
            if (!valid && (field.getValue() !== undefined && field.getValue() !== null)) {
                valid = true;
                return;
            }
        });

        if (!valid) {
            form.addError(this.getMessageKey("error"));
            return wrm.val.RulePolicy.STOP;
        }
        return wrm.val.RulePolicy.CONTINUE;
    },

});
