/**
 * @fileoverview Externs for the com.webratio.phonegap-plugin-push plugin. This
 *               is NOT OFFICIAL, with only the API we use at WebRatio.
 * @externs
 */

/** @constructor */
function PushNotification() {}

/** @record */
PushNotification.AndroidOptions = function() {};
/** @type {string} */
PushNotification.AndroidOptions.prototype.senderId;
/** @type {string|undefined} */
PushNotification.AndroidOptions.prototype.icon;
/** @type {string|undefined} */
PushNotification.AndroidOptions.prototype.iconColor;
/** @type {boolean|undefined} */
PushNotification.AndroidOptions.prototype.sound;
/** @type {boolean|undefined} */
PushNotification.AndroidOptions.prototype.vibrate;
/** @type {boolean|undefined} */
PushNotification.AndroidOptions.prototype.clearNotifications;

/** @record */
PushNotification.IosOptions = function() {};
/** @type {boolean|undefined} */
PushNotification.IosOptions.prototype.alert;
/** @type {boolean|undefined} */
PushNotification.IosOptions.prototype.badge;
/** @type {boolean|undefined} */
PushNotification.IosOptions.prototype.sound;

/** @record */
PushNotification.WindowsOptions = function() {};
/** @type {boolean|undefined} */
PushNotification.WindowsOptions.prototype.silentForeground;

/** @record */
PushNotification.Wp8Options = function() {};
/** @type {boolean|undefined} */
PushNotification.Wp8Options.prototype.channelName;

/** @record */
PushNotification.Options = function() {};
/** @type {!PushNotification.AndroidOptions|undefined} */
PushNotification.AndroidOptions.prototype.android;
/** @type {!PushNotification.IosOptions|undefined} */
PushNotification.IosOptions.prototype.ios;
/** @type {!PushNotification.WindowsOptions|undefined} */
PushNotification.WindowsOptions.prototype.windows;
/** @type {!PushNotification.Wp8Options|undefined} */
PushNotification.Wp8Options.prototype.wp8;

/**
 * @param {PushNotification.Options} options
 * @return {!PushNotification}
 */
PushNotification.init = function(options) {};

/**
 * @param {function({isEnabled:boolean})} successHandler
 */
PushNotification.hasPermission = function(successHandler) {};

/**
 * @param {function(boolean)} successCallback
 * @param {function(string)} errorCallback
 */
PushNotification.hasColdStartNotification = function(successCallback,
		errorCallback) {};

/**
 * @typedef {{ registrationId:string }}
 */
PushNotification.RegistrationEvent;

/**
 * @typedef {{ message:string, title:string,
 *          additionalData:{foreground:(boolean|undefined),
 *          coldstart:(boolean|undefined)} }}
 */
PushNotification.NotificationEvent;

/**
 * @typedef {!Error}
 */
PushNotification.ErrorEvent;

/**
 * @typedef { PushNotification.RegistrationEvent |
 *          PushNotification.NotificationEvent | PushNotification.ErrorEvent }
 */
PushNotification.Event;

/**
 * @param {string} event
 * @param {function(!PushNotification.Event)} callback
 */
PushNotification.prototype.on = function(event, callback) {};

/**
 * @param {string} event
 * @param {function(!PushNotification.Event)} callback
 */
PushNotification.prototype.off = function(event, callback) {};

/**
 * @enum {string}
 */
PushNotification.ErrorCode = {
	GENERAL: "0",
	NOTALLOWED: "1"
};
