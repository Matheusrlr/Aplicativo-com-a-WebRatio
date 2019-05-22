/**
 * @fileoverview Externs for the cordova-plugin-globalization plugin. This is
 *               NOT OFFICIAL, with only the API we use at WebRatio.
 * @externs
 */

/** @const */
navigator.globalization;

/**
 * @param {function({value:string})} successCallback
 * @param {function(!GlobalizationError)} errorCallback
 */
navigator.globalization.getLocaleName = function(successCallback,
		errorCallback) {};

/**
 * @param {function({value:!Array<string>})} successCallback
 * @param {function(!GlobalizationError)} errorCallback
 * @param {{type:string, item:string}=} options
 */
navigator.globalization.getDateNames = function(successCallback, errorCallback,
		options) {};

/**
 * @param {function({value: number})} successCallback
 * @param {function(!GlobalizationError)} errorCallback
 */
navigator.globalization.getFirstDayOfWeek = function(successCallback,
		errorCallback) {};

/**
 * @param {function({pattern:string, timezone:string, utc_offset:number,
 *        dst_offset:number})} successCallback
 * @param {function(!GlobalizationError)} errorCallback
 * @param {{formatLength:string, selector:string}=} options
 */
navigator.globalization.getDatePattern = function(successCallback,
		errorCallback, options) {};

/**
 * @param {function({pattern:string, symbol:string, fraction:number,
 *        rounding:number, positive:string, negative:string, decimal:string,
 *        grouping:string})} successCallback
 * @param {function(!GlobalizationError)} errorCallback
 * @param {{type:string}=} options
 */
navigator.globalization.getNumberPattern = function(successCallback,
		errorCallback, options) {};

/**
 * @constructor
 * @extends {Error}
 */
function GlobalizationError() {}
;

/** @type {number} */
GlobalizationError.UNKNOWN_ERROR = 0;
/** @type {number} */
GlobalizationError.FORMATTING_ERROR = 1;
/** @type {number} */
GlobalizationError.PARSING_ERROR = 2;
/** @type {number} */
GlobalizationError.PATTERN_ERROR = 3;

/** @type {number} */
GlobalizationError.prototype.code;
