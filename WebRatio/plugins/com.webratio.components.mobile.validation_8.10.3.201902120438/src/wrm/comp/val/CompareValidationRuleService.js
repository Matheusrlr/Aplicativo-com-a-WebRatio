/**
 * Service for Compare validation rules.
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
         * @type {string}
         */
        this._predicate = descr["predicate"];

        /**
         * @private
         * @type {boolean}
         */
        this._ignoreCase = descr["ignoreCase"] || false;

        /**
         * @private
         * @type {string|undefined}
         */
        this._valueFieldId = descr["valueField"] || undefined;

        /**
         * @private
         * @type {string}
         */
        this._value = descr["value"];
    },

    /** @override */
    validate: function(context) {
        var property = context.getElement();
        var propertyValue = property.getValue();
        if (propertyValue === undefined || propertyValue === null || propertyValue === "") {
            return wrm.val.RulePolicy.CONTINUE;
        }
        var valid = true;
        var value = this._value;
        var key = "";
        var otherProperty = "";
        if (this._valueFieldId !== undefined) {
            otherProperty = property.getObject().getProperty(this._valueFieldId);
            value = otherProperty.getValue();
        }

        var left = (this._ignoreCase ? wrm.data.toString(propertyValue).toLowerCase() : wrm.data.toString(propertyValue));
        var right = (this._ignoreCase ? wrm.data.toString(value).toLowerCase() : wrm.data.toString(value));
        switch (this._predicate) {
        case "eq":
            if (!wrm.data.equal(left, right)) {
                key = (this._valueFieldId ? "eq.property" : "eq");
                valid = false;
            }
            break;
        case "gteq":
            var compare = wrm.data.compare(propertyValue, value);
            if (compare < 0) {
                key = (this._valueFieldId ? "gteq.property" : "gteq");
                valid = false;
            }
            break;
        case "gt":
            var compare = wrm.data.compare(propertyValue, value);
            if (compare <= 0) {
                key = (this._valueFieldId ? "gt.property" : "gt");
                valid = false;
            }
            break;
        case "lteq":
            var compare = wrm.data.compare(propertyValue, value);
            if (compare > 0) {
                key = (this._valueFieldId ? "lteq.property" : "lteq");
                valid = false;
            }
            break;
        case "lt":
            var compare = wrm.data.compare(propertyValue, value);
            if (compare >= 0) {
                key = (this._valueFieldId ? "lt.property" : "lt");
                valid = false;
            }
            break;
        case "neq":
            if (wrm.data.equal(left, right)) {
                key = (this._valueFieldId ? "neq.property" : "neq");
                valid = false;
            }
            break;
        }

        if (!valid) {
            property.addError(this.getMessageKey(key), {
                "value": right,
                "otherPropertyName": (otherProperty !== "" ? otherProperty.getLabel() : "")
            });
            return wrm.val.RulePolicy.STOP;
        }
        return wrm.val.RulePolicy.CONTINUE;
    },

});
