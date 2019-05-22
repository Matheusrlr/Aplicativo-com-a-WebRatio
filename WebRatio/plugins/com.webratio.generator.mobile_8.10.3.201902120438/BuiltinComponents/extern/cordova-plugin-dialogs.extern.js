/**
 * @fileoverview Externs for the cordova-plugin-dialogs plugin. This is NOT
 *               OFFICIAL, with only the API we use at WebRatio.
 * @externs
 */

/** @const */
navigator.notification;

/**
 * @param {string} message
 * @param {function()} alertCallback
 * @param {string=} title
 * @param {string=} buttonName
 */
navigator.notification.alert = function(message, alertCallback, title,
		buttonName) {};

/**
 * @param {string} message
 * @param {function(number)} confirmCallback
 * @param {string=} title
 * @param {!Array<string>=} buttonLabels
 */
navigator.notification.confirm = function(message, confirmCallback, title,
		buttonLabels) {};
