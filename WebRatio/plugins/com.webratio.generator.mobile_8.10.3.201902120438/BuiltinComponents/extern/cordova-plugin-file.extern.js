/**
 * @fileoverview Externs for the cordova-plugin-file plugin. This is NOT
 *               OFFICIAL, with only the API we use at WebRatio.
 * @externs
 */

/** @const */
var cordova;
/** @const */
cordova.file;

/** @const {string} */
cordova.file.externalCacheDirectory;
/** @const {string} */
cordova.file.cacheDirectory;
/** @const {string} */
cordova.file.dataDirectory;

/**
 * @param {string} url
 * @param {function(!Entry)} successCallback
 * @param {function(!FileError)=} errorCallback
 */
function resolveLocalFileSystemURL(url, successCallback, errorCallback) {}

/** @const {number} */
LocalFileSystem.TEMPORARY = 0;

/** @const {number} */
LocalFileSystem.PERSISTENT = 1;
