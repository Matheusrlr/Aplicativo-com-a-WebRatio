/**
 * Service for Contacts Operation operations.
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

        /**
         * @private
         * @type {Object}
         */
        this._addresses = descr["addresses"];

        /**
         * @private
         * @type {Object}
         */
        this._phones = descr["phones"];

        /**
         * @private
         * @type {Object}
         */
        this._emails = descr["emails"];

        /**
         * @private
         * @type {!string}
         */
        this._mode = descr["mode"];
    },

    /** @override */
    executeOperation: function(context) {
        var thisService = this;
        var input = context.getInput();

        if (this._mode === "save") {
            var contact = thisService._createContact(input);
            return thisService._execSaveAndEditContact(contact);
        } else {
            return thisService._execPickContact();
        }
    },

    /**
     * @private
     */
    _execSaveAndEditContact: function(contact) {

        var saveContactPromise = new Promise(function(resolve, reject) {
            function onSuccess(saveResult) {
                resolve(saveResult);
            }

            function onError(code) {
                reject(code);
            }
            contact.saveAndEdit(onSuccess, onError);
        });

        return saveContactPromise.then(function(result) {
            var output = result;
            return new wrm.nav.Output("success", output);
        }, function(e) {
            if (e.code === ContactError.OPERATION_CANCELLED_ERROR) {
                return new wrm.nav.Output("success.Cancel");
            }
            return new wrm.nav.Output("error", {
                "errorMessage": e
            });
        });
    },

    /**
     * @private
     */
    _execPickContact: function() {
        var thisService = this;

        var pickContactPromise = new Promise(function(resolve, reject) {
            function onSuccess(result) {
                var output = {};
                if (result["code"] === 0) {
                    output = result;
                } else {
                    output = thisService._createPickOutput(result);
                }
                resolve(output);
            }

            function onError(code) {
                reject(code);
            }
            navigator.contacts.pickContact(onSuccess, onError);
        });

        return pickContactPromise.then(function(result) {
            if (result["code"] === 0) {
                return new wrm.nav.Output("success.Cancel");
            } else {
                return new wrm.nav.Output("success", result);
            }
        }, function(e) {
            if (e === ContactError.OPERATION_CANCELLED_ERROR) {
                return new wrm.nav.Output("success.Cancel");
            }
            return new wrm.nav.Output("error", {
                "errorMessage": e
            });
        });
    },

    /**
     * @private
     */
    _createContact: function(input) {

        /* Create Contact object */
        var contact = navigator.contacts.create();

        /* Add 'id' to Contact object */
        contact.id = input["id"];

        /* Add 'name' object to Contact object */
        contact.name = new ContactName('', input["lastName"], input["firstName"], '', '', '');

        /* Add 'addresses' array to Contact object */
        var addresses = [], currentObject, field;
        for (currentObject in this._addresses) {
            field = this._addresses[currentObject];
            var streetInput = wrm.data.toStringArray(input[field["street"]]);
            var cityInput = wrm.data.toStringArray(input[field["city"]]);
            var regionInput = wrm.data.toStringArray(input[field["region"]]);
            var countryInput = wrm.data.toStringArray(input[field["country"]]);
            var postalCodeInput = wrm.data.toStringArray(input[field["postalCode"]]);
            var test = this._getMaxField(input, field);
            for (var i = 0; i < test; i++) {
                addresses.push(new ContactAddress(false, field["type"], null, streetInput[i], cityInput[i], regionInput[i],
                        postalCodeInput[i], countryInput[i]));
            }
        }
        if (addresses.length > 0) {
            contact.addresses = addresses;
        }

        /* Add 'emails' array to Contact object */
        var emails = [];
        var currentInput, index;
        for (currentObject in this._emails) {
            field = this._emails[currentObject];
            currentInput = wrm.data.toStringArray(input[field["email"]]);
            for (index in currentInput) {
                emails.push(new ContactField(field["type"], currentInput[index], false));
            }
        }
        if (emails.length > 0) {
            contact.emails = emails;
        }

        /* Add 'phoneNumbers' array to Contact object */
        var phoneNumbers = [];
        for (currentObject in this._phones) {
            field = this._phones[currentObject];
            currentInput = wrm.data.toStringArray(input[field["number"]]);
            for (index in currentInput) {
                phoneNumbers.push(new ContactField(field["type"], currentInput[index], false));
            }
        }
        if (phoneNumbers.length > 0) {
            contact.phoneNumbers = phoneNumbers;
        }
        return contact;
    },

    /**
     * @private
     */
    _createPickOutput: function(result) {

        var output = {};
        var field = [];
        var obj = {};
        var root;
        for (field in result) {

            if (field === "id") {
                output.id = result[field] ? wrm.data.toStringArray(result[field]) : []
                continue;
            }

            if (field === "name") {
                root = result[field];
                if (root !== null) {
                    output.firstName = root["givenName"] ? wrm.data.toStringArray(root["givenName"]) : [];
                    output.lastName = root["familyName"] ? wrm.data.toStringArray(root["familyName"]) : [];
                }
                continue;
            }

            if (field === "phoneNumbers") {
                for (obj in result[field]) {
                    root = result[field][obj];
                    this._setOutputField(output, root, "Phone", "value");
                }
                continue;
            }

            if (field === "emails") {
                for (obj in result[field]) {
                    root = result[field][obj];
                    this._setOutputField(output, root, "Email", "value");
                }
                continue;
            }

            if (field === "addresses") {
                for (obj in result[field]) {
                    root = result[field][obj];
                    this._setOutputField(output, root, "Street", "streetAddress");
                    this._setOutputField(output, root, "City", "locality");
                    this._setOutputField(output, root, "Region", "region");
                    this._setOutputField(output, root, "Country", "country");
                    this._setOutputField(output, root, "PostalCode", "postalCode");
                }
                continue;
            }
        }
        return output;
    },

    /**
     * @private
     */
    _setOutputField: function(output, root, field, value) {
        if (!root[value]) {
            return;
        }
        if (output[root["type"] + field] === undefined) {
            output[root["type"] + field] = [];
            output[root["type"] + field].push(root[value]);
        } else {
            output[root["type"] + field].push(root[value]);
        }
    },

    /**
     * @private
     */
    _getMaxField: function(input, field) {
        var fieldArray = [ wrm.data.toStringArray(input[field["street"]]), wrm.data.toStringArray(input[field["city"]]),
                wrm.data.toStringArray(input[field["postalCode"]]), wrm.data.toStringArray(input[field["region"]]),
                wrm.data.toStringArray(input[field["country"]]) ];
        var max = 0;
        var i;
        for (i = 0; i < fieldArray.length; i++) {
            if (fieldArray[i].length > max) {
                max = fieldArray[i].length;
            }
        }
        return max;
    },
});
