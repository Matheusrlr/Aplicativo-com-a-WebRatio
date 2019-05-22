/**
 * Service for Mandatory validation rules.
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
        this._companionFieldId = descr["companionProperty"] || undefined;

        /**
         * @private
         * @type {string|undefined}
         */
        this._predicate = this._companionFieldId && descr["predicate"];

        /**
         * @private
         * @type {boolean|undefined}
         */
        this._ignoreCase = this._companionFieldId && (descr["ignoreCase"] || false);

        /**
         * @private
         * @type {string|undefined}
         */
        this._value = this._companionFieldId && descr["value"];
    },

    /** @override */
    validate: function(context) {
        var property = context.getElement();
        var propertyValue = property.getValue();
        if (this._isEmpty(propertyValue) && this._isCompanionMatching(property)) {
            property.addError(this.getMessageKey("error"));
            return wrm.val.RulePolicy.STOP;
        }
        return wrm.val.RulePolicy.CONTINUE;
    },

    /**
     * @private
     * @param {!wrm.val.Property} property
     * @return {boolean}
     */
    _isCompanionMatching: function(property) {
        if (this._companionFieldId === undefined) {
            return true; // no companion
        }

        var companionValue = property.getObject().getProperty(this._companionFieldId).getValue();
        var ieEmptyCompanion = this._isEmpty(companionValue);
        if (this._value === undefined) {

            /* UNARY test on the companion value */
            switch (this._predicate) {
            case "empty":
                return ieEmptyCompanion;
            case "notEmpty":
                return !ieEmptyCompanion;
            }
        } else {

            /* Empty companions never pass a binary test */
            if (ieEmptyCompanion) {
                return false;
            }

            /* BINARY test against the (non empty) companion value */
            var value = this._value;
            var left = (this._ignoreCase ? wrm.data.toString(companionValue).toLowerCase() : wrm.data.toString(companionValue));
            var right = (this._ignoreCase ? value.toLowerCase() : value);
            switch (this._predicate) {
            case "eq":
                return wrm.data.equal(left, right);
            case "gteq":
                return wrm.data.compare(companionValue, value) >= 0;
            case "gt":
                return wrm.data.compare(companionValue, value) > 0;
            case "lteq":
                return wrm.data.compare(companionValue, value) <= 0;
            case "lt":
                return wrm.data.compare(companionValue, value) < 0;
            case "neq":
                return !wrm.data.equal(left, right);
            }
        }

        /* DEFAULT behavior: the companion only has to be filled */
        return !ieEmptyCompanion;
    },

    /**
     * @private
     * @param {*} value
     * @return {boolean}
     */
    _isEmpty: function(value) {
        return (value === null || value === undefined || value === "");
    },

});
