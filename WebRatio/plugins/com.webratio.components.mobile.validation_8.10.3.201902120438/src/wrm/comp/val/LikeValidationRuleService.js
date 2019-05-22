/**
 * Service for Like validation rules.
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
        var key = "";
        var value = this._value;
        if (this._valueFieldId !== undefined) {
            value = property.getObject().getProperty(this._valueFieldId).getValue();
        }

        var left = (this._ignoreCase ? wrm.data.toString(propertyValue).toLowerCase() : wrm.data.toString(propertyValue));
        /**
         * @type {string|null}
         */
        var right = (this._ignoreCase ? wrm.data.toString(value).toLowerCase() : wrm.data.toString(value)) || null;

        if (right === null || right === "") {
            return wrm.val.RulePolicy.CONTINUE;
        }

        switch (this._predicate) {
        case "beginsWith":
            if (left.indexOf(right) !== 0) {
                key = (this._valueFieldId ? "beginsWith.property" : "beginsWith");
                valid = false;
            }
            break;
        case "contains":
            if (left.indexOf(right) === -1) {
                key = (this._valueFieldId ? "contains.property" : "contains");
                valid = false;
            }
            break;
        case "endsWith":
            var leftLength = left.length;
            if ((leftLength < right.length) || (!wrm.data.equal(left.substring(leftLength - right.length, leftLength), right))) {
                key = (this._valueFieldId ? "endsWith.property" : "endsWith");
                valid = false;
            }
            break;
        case "notBeginsWith":
            if (left.indexOf(right) === 0) {
                key = (this._valueFieldId ? "notBeginsWith.property" : "notBeginsWith");
                valid = false;
            }
            break;
        case "notContains":
            if (left.indexOf(right) !== -1) {
                key = (this._valueFieldId ? "notContains.property" : "notContains");
                valid = false;
            }
            break;
        case "notEndsWith":
            var leftLength = left.length;
            if ((leftLength >= right.length) && (wrm.data.equal(left.substring(leftLength - right.length, leftLength), right))) {
                key = (this._valueFieldId ? "notEndsWith.property" : "notEndsWith");
                valid = false;
            }
            break;
        }

        if (!valid) {
            property.addError(this.getMessageKey(key), {
                "value": right,
                "otherPropertyName": this._valueFieldId
            });
            return wrm.val.RulePolicy.STOP;
        }
        return wrm.val.RulePolicy.CONTINUE;
    },

});
