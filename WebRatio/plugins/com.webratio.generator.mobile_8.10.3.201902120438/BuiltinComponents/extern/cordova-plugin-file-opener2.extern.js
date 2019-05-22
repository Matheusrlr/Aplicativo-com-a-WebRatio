/**
 * @fileoverview Externs for the cordova-plugin-file-opener2
 *               plugin. This is NOT OFFICIAL, with only the API we use at
 *               WebRatio.
 * @externs
 */

/** @const */
cordova.plugins;
/** @const */
cordova.plugins.fileOpener2;

/**
 * @param {string} url
 * @param {string} contentType
 * @param {{success:(function()|undefined),
 *        error:(function({status:number,message:string})|undefined)}=} options
 */
cordova.plugins.fileOpener2.open = function(url, contentType, options) {};
