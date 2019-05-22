/**
 * Service for Switch operations.
 * 
 * @constructor
 * @extends wrm.core.AbstractOperationService
 * @param {string} id
 * @param {!Object} descr
 * @param {!wrm.core.Manager} manager
 */
export default wrm.defineService(wrm.core.AbstractOperationService, {

    /** @override */
    initialize: function(descr) {

        /** @private {?Object<string,boolean>} */
        this._codes = null;

        /* Map codes (if configured) */
        if (descr["codes"].length > 0) {
            this._codes = {};
            descr["codes"].forEach(function(code) {
                this._codes[code] = true;
            }, this);
        }
    },

    /** @override */
    executeOperation: function(context) {
        var switchValue = context.getInput()["switch"];
        var matchingCase = this._findMatchingCase(switchValue);
        var result = !!matchingCase ? "success." + matchingCase : "success";
        return new wrm.nav.Output(result, {
            "switch": switchValue
        });
    },

    /**
     * @private
     * @param {*} switchValue
     * @return {?string}
     */
    _findMatchingCase: function(switchValue) {

        /* With no codes, perform an "is not null" check, with special support for arrays */
        if (!this._codes) {
            if (Array.isArray(switchValue)) {
                if (switchValue.length <= 0 || switchValue.every(this._isEmptyValue, this)) {
                    return "<EMPTY>";
                }
                return null; // default
            }
            if (this._isEmptyValue(switchValue)) {
                return "<EMPTY>";
            }
            return null; // default
        }

        /* Convert to a scalar value */
        if (Array.isArray(switchValue)) {
            switchValue = switchValue[0];
        }
        switchValue = wrm.data.toString(switchValue);

        /* Find a matching code (or empty) */
        if (this._isEmptyValue(switchValue)) {
            return "<EMPTY>";
        }
        if (this._codes[switchValue] === true) {
            return (/** @type {string} */(switchValue)); // a known code
        }
        return null; // default
    },

    /**
     * @private
     * @param {*} value
     * @return {boolean}
     */
    _isEmptyValue: function(value) {
        return value === undefined || value === null || value === "";
    }

});
