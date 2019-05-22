/**
 * Service for Credit Card validation rules.
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
         * @type {!Object.<string,RegExp>}
         */
        this._creditCards = {
            "visa": /^4\d{12}(?:\d{3})?$/,
            "masterCard": /^5[1-5]\d{14}$/,
            "americanExpress": /^3[47]\d{13}$/,
            "discover": /^6(?:011|5\d{2})\d{12}$/
        };
    },

    /** @override */
    validate: function(context) {
        var property = context.getElement();
        var propertyValue = wrm.data.toString(property.getValue());
        if (propertyValue === undefined || propertyValue === null || propertyValue === "") {
            return wrm.val.RulePolicy.CONTINUE;
        }
        if (!this._isValidCard(propertyValue)) {
            property.addError(this.getMessageKey("error"));
            return wrm.val.RulePolicy.STOP;
        }
        return wrm.val.RulePolicy.CONTINUE;
    },

    /**
     * @private
     * @param {?string=} cardNumber
     * @returns {boolean}
     */
    _isValidCard: function(cardNumber) {
        if ((cardNumber.length < 13) || (cardNumber.length > 19)) {
            return false;
        }
        if (!this._isValidType(cardNumber)) {
            return false;
        }
        if (!this._luhnCheck(cardNumber)) {
            return false;
        }
        return true;
    },

    _luhnCheck: function(cardNumber) {
        if (isNaN(Number(cardNumber))) {
            return false;
        }
        var digits = cardNumber.length;
        var odd = digits % 2;
        var sum = 0;
        for (var count = 0; count < digits; count++) {
            var digit = 0;
            digit = Number(cardNumber[count]);
            if (((count & 1) ^ odd) == 0) { // not
                digit *= 2;
                if (digit > 9) {
                    digit -= 9;
                }
            }
            sum += digit;
        }
        return (sum == 0) ? false : (sum % 10 == 0);
    },

    _isValidType: function(cardNumber) {
        var thisService = this;
        var valid = false;
        Object.keys(this._creditCards).forEach(function(card) {
            if (thisService._creditCards[card].exec(cardNumber)) {
                valid = true;
            }
        });
        return valid;
    },

});
