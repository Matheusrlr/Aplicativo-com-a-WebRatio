/**
 * @fileoverview Externs for the cordova-plugin-contacts plugin. This is NOT
 *               OFFICIAL, with only the API we use at WebRatio.
 * @externs
 */

/**
 * @constructor
 * @param {boolean=} pref
 * @param {?string=} type
 * @param {?string=} formatted
 * @param {?string=} streetAddress
 * @param {?string=} locality
 * @param {?string=} region
 * @param {?string=} postalCode
 * @param {?string=} country
 */
function ContactAddress(pref, type, formatted, streetAddress, locality, region,
		postalCode, country) {}
/** @type {boolean} */
ContactAddress.prototype.pref;
/** @type {?string} */
ContactAddress.prototype.type;
/** @type {?string} */
ContactAddress.prototype.formatted;
/** @type {?string} */
ContactAddress.prototype.streetAddress;
/** @type {?string} */
ContactAddress.prototype.locality;
/** @type {?string} */
ContactAddress.prototype.region;
/** @type {?string} */
ContactAddress.prototype.postalCode;
/** @type {?string} */
ContactAddress.prototype.country;

/**
 * @constructor
 * @param {number=} code
 */
function ContactError(code) {}
/** @type {number} */
ContactError.prototype.code;
/*** @type {number} */
ContactError.UNKNOWN_ERROR;
/*** @type {number} */
ContactError.INVALID_ARGUMENT_ERROR;
/*** @type {number} */
ContactError.TIMEOUT_ERROR;
/*** @type {number} */
ContactError.PENDING_OPERATION_ERROR;
/*** @type {number} */
ContactError.IO_ERROR;
/*** @type {number} */
ContactError.NOT_SUPPORTED_ERROR;
/*** @type {number} */
ContactError.OPERATION_CANCELLED_ERROR;
/*** @type {number} */
ContactError.PERMISSION_DENIED_ERROR;

/**
 * @constructor
 * @param {string=} type
 * @param {?string=} value
 * @param {boolean=} pref
 */
function ContactField(type, value, pref) {}
/** @type {string} */
ContactField.prototype.type;
/** @type {?string} */
ContactField.prototype.value;
/** @type {boolean} */
ContactField.prototype.pref;

/**
 * @constructor
 * @param {?string=} formatted
 * @param {?string=} familyName
 * @param {?string=} givenName
 * @param {?string=} middle
 * @param {?string=} prefix
 * @param {?string=} suffix
 */
function ContactName(formatted, familyName, givenName, middle, prefix,
		suffix) {}
/** @type {?string} */
ContactName.prototype.formatted;
/** @type {?string} */
ContactName.prototype.familyName;
/** @type {?string} */
ContactName.prototype.givenName;
/** @type {?string} */
ContactName.prototype.middleName;
/** @type {?string} */
ContactName.prototype.honorificPrefix;
/** @type {?string} */
ContactName.prototype.honorificSuffix;

/**
 * @constructor
 * @param {boolean=} pref
 * @param {?string=} type
 * @param {?string=} name
 * @param {?string=} dept
 * @param {?string=} title
 */
function ContactOrganization(pref, type, name, dept, title) {}
/** @type {boolean} */
ContactOrganization.prototype.pref;
/** @type {?string} */
ContactOrganization.prototype.type;
/** @type {?string} */
ContactOrganization.prototype.name;
/** @type {?string} */
ContactOrganization.prototype.department;
/** @type {?string} */
ContactOrganization.prototype.title;

/** @constructor */
function Contact() {}

/** @type {?string} */
Contact.prototype.id;
/** @type {?string} */
Contact.prototype.displayName;
/** @type {ContactName} */
Contact.prototype.name;
/** @type {?string} */
Contact.prototype.nickname;
/** @type {!Array<!ContactField>} */
Contact.prototype.phoneNumbers;
/** @type {!Array<!ContactField>} */
Contact.prototype.emails;
/** @type {!Array<!ContactAddress>} */
Contact.prototype.addresses;
/** @type {!Array<!ContactField>} */
Contact.prototype.ims;
/** @type {!Array<!ContactOrganization>} */
Contact.prototype.organizations;
/** @type {Date} */
Contact.prototype.birthday;
/** @type {?string} */
Contact.prototype.note;
/** @type {!Array<!ContactField>} */
Contact.prototype.photos;
/** @type {!Array<!ContactField>} */
Contact.prototype.categories;
/** @type {!Array<!ContactField>} */
Contact.prototype.urls;

/**
 * @return {!Contact}
 */
Contact.prototype.clone = function() {};

/**
 * @param {function()} onSuccess
 * @param {function(!ContactError)=} onError
 */
Contact.prototype.remove = function(onSuccess, onError) {};

/**
 * @param {function(!Contact)} onSuccess
 * @param {function(!ContactError)=} onError
 */
Contact.prototype.save = function(onSuccess, onError) {};

/**
 * @param {function(!Contact)} onSuccess
 * @param {function(!ContactError)=} onError
 */
Contact.prototype.saveAndEdit = function(onSuccess, onError) {};

/** @const */
navigator.contacts;

/**
 * @param {function(!Contact)} onSuccess
 * @param {function(!ContactError)=} onError
 */
navigator.contacts.pickContact = function(onSuccess, onError) {};
