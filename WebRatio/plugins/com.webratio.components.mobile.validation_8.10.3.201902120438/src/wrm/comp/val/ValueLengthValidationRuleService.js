/**
 * Service for Value Length validation rules.
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
         * @type {string}
         */
        this._predicate = descr["predicate"];

        /**
         * @type {number}
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
        var length = 0;
        var isBlob = false;

        if (propertyValue instanceof wrm.data.Blob) {
            length = propertyValue.getSize();
            isBlob = true;
        } else {
            length = wrm.data.toString(propertyValue).length;
        }

        switch (this._predicate) {
        case "eq":
            if (!wrm.data.equal(length, this._value)) {
                key = (isBlob ? "blob.eq" : "eq");
                valid = false;
            }
            break;
        case "neq":
            if (wrm.data.equal(length, this._value)) {
                key = (isBlob ? "blob.neq" : "neq");
                valid = false;
            }
            break;
        case "min":
            var compare = wrm.data.compare(length, this._value);
            if (compare < 0) {
                key = (isBlob ? "blob.min" : "min");
                valid = false;
            }
            break;
        case "max":
            var compare = wrm.data.compare(length, this._value);
            if (compare > 0) {
                key = (isBlob ? "blob.max" : "max");
                valid = false;
            }
            break;
        }

        if (!valid) {
            property.addError(this.getMessageKey(key), {
                "length": this._value
            });
            return wrm.val.RulePolicy.STOP;
        }
        return wrm.val.RulePolicy.CONTINUE;
    },

});
