/**
 * @fileoverview Externs for the cordova-plugin-camera plugin. This is NOT
 *               OFFICIAL, with only the API we use at WebRatio.
 * @externs
 */

/** @const */
var Camera;
/** @const */
navigator.camera;

/**
 * @param {function(string)} onSuccess
 * @param {function(string)} onError
 * @param {!CameraOptions} options
 * @return {!CameraPopoverHandle}
 */
navigator.camera.getPicture = function(onSuccess, onError, options) {};

/**
 * @param {function()} onSuccess
 * @param {function(string)} onError
 */
navigator.camera.cleanup = function(onSuccess, onError) {};

/** @record */
var CameraOptions;
/** @type {number|undefined} */
CameraOptions.prototype.quality;
/** @type {!Camera.DestinationType|undefined} */
CameraOptions.prototype.destinationType;
/** @type {!Camera.PictureSourceType|undefined} */
CameraOptions.prototype.sourceType;
/** @type {boolean|undefined} */
CameraOptions.prototype.allowEdit;
/** @type {!Camera.EncodingType|undefined} */
CameraOptions.prototype.encodingType;
/** @type {number|undefined} */
CameraOptions.prototype.targetWidth;
/** @type {number|undefined} */
CameraOptions.prototype.targetHeight;
/** @type {!Camera.MediaType|undefined} */
CameraOptions.prototype.mediaType;
/** @type {boolean|undefined} */
CameraOptions.prototype.correctOrientation;
/** @type {boolean|undefined} */
CameraOptions.prototype.saveToPhotoAlbum;
/** @type {!CameraPopoverOptions|undefined} */
CameraOptions.prototype.popoverOptions;
/** @type {!Camera.Direction|undefined} */
CameraOptions.prototype.cameraDirection;

/** @enum {number} */
Camera.DestinationType = {
	DATA_URL: 0,
	FILE_URI: 1,
	NATIVE_URI: 2
};

/** @enum {number} */
Camera.PictureSourceType = {
	PHOTOLIBRARY: 0,
	CAMERA: 1,
	SAVEDPHOTOALBUM: 2
};

/** @enum {number} */
Camera.EncodingType = {
	JPEG: 0,
	PNG: 1
};

/** @enum {number} */
Camera.MediaType = {
	PICTURE: 0,
	VIDEO: 1,
	ALLMEDIA: 2
};

/** @enum {number} */
Camera.Direction = {
	BACK: 0,
	FRONT: 1
};

/** @constructor */
function CameraPopoverHandle() {}

/**
 * @param {!CameraPopoverOptions} cameraPopoverOptions
 */
CameraPopoverHandle.prototype.setPosition = function(cameraPopoverOptions) {};

/** @record */
var CameraPopoverOptions;
/** @type {number|undefined} */
CameraPopoverOptions.prototype.x;
/** @type {number|undefined} */
CameraPopoverOptions.prototype.y;
/** @type {number|undefined} */
CameraPopoverOptions.prototype.width;
/** @type {number|undefined} */
CameraPopoverOptions.prototype.heigth;
/** @type {!Camera.PopoverArrowDirection|undefined} */
CameraPopoverOptions.prototype.arrowDir;

/** @enum {number} */
Camera.PopoverArrowDirection = {
	ARROW_UP: 1,
	ARROW_DOWN: 2,
	ARROW_LEFT: 4,
	ARROW_RIGHT: 8,
	ARROW_ANY: 15
};
