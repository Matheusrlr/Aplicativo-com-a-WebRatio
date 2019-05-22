/**
 * @fileoverview Externs for the WebRatio Account Manager Cordova plugin.
 * @externs
 */

/** @const */
var accountmanager;

/**
 * @param {string} packageName
 * @param {function()} successCallback
 * @param {function(string)} errorCallback
 */
accountmanager.setPackage = function(packageName, successCallback,
		errorCallback) {};

/**
 * @param {string} groupId
 * @param {string} teamId
 * @param {function()} successCallback
 * @param {function(string)} errorCallback
 */
accountmanager.enableSharing = function(groupId, teamId, successCallback,
		errorCallback) {};

/**
 * @param {function()} successCallback
 * @param {function(string)} errorCallback
 */
accountmanager.clear = function(successCallback, errorCallback) {};

/**
 * @param {?string} username
 * @param {function()} successCallback
 * @param {function(string)} errorCallback
 */
accountmanager.setUsername = function(username, successCallback,
		errorCallback) {};

/**
 * @param {function(?string)} successCallback
 * @param {function(string)} errorCallback
 */
accountmanager.getUsername = function(successCallback, errorCallback) {};

/**
 * @param {?string} password
 * @param {function()} successCallback
 * @param {function(string)} errorCallback
 */
accountmanager.setPassword = function(password, successCallback,
		errorCallback) {};

/**
 * @param {function(?string)} successCallback
 * @param {function(string)} errorCallback
 */
accountmanager.getPassword = function(successCallback, errorCallback) {};

/**
 * @param {?string} token
 * @param {function()} successCallback
 * @param {function(string)} errorCallback
 */
accountmanager.setToken = function(token, successCallback, errorCallback) {};

/**
 * @param {function(?string)} successCallback
 * @param {function(string)} errorCallback
 */
accountmanager.getToken = function(successCallback, errorCallback) {};

/**
 * @param {string} message
 * @param {function({buttonIndex:number, username:string, password:string})}
 *        successCallback
 * @param {{title:(string|undefined), usernameDefault:string,
 *        usernameReadOnly:(boolean|undefined),
 *        buttonLabels:(!Array<string>|undefined)}} options
 */
accountmanager.loginPrompt = function(message, successCallback, options) {};
