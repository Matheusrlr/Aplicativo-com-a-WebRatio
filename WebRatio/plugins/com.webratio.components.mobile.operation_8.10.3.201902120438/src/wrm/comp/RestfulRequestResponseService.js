/**
 * Service for Restful Request Response operations.
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

        /** @private */
        this._requestInputs = this._createDataParameterInfos(descr["requestInputs"]);

        /** @private */
        this._responseOutputs = this._createDataParameterInfos(descr["responseOutputs"]);

        /** @private */
        this._requestHeaderInputs = this._createHeaderParameterInfos(descr["requestHeaderInputs"]);

        /** @private */
        this._responseHeaderOutputs = this._createHeaderParameterInfos(descr["responseHeaderOutputs"]);

        /**
         * @private
         * @type {!string}
         */
        this._method = descr["method"];

        /**
         * @private
         * @type {!string}
         */
        this._url = descr["url"];

        /**
         * @private
         * @type {?{username:string, password:string}}
         */
        this._httpAuthentication = descr["httpAuthentication"] || null;

        /**
         * @private
         * @type {?RequestType}
         */
        this._requestType = (descr["requestType"] ? wrm.util.obj.castEnumValue(RequestType, descr["requestType"]) : null);

        /**
         * @private
         * @type {!ResponseType}
         */
        this._responseType = wrm.util.obj.castEnumValue(ResponseType, descr["responseType"])

        /**
         * @private
         * @type {number}
         */
        this._timeout = descr["timeout"];

        /* Check some descriptor consistency */
        if (!this._url) {
            throw new Error("Unspecified endpoint URL");
        }
    },

    /**
     * @private
     * @param {!Array<!Object>} paramsDescr
     * @return {!Array<{name:string, path:string, arrayPath:?string}>}
     */
    _createDataParameterInfos: function(paramsDescr) {
        return paramsDescr.map(function(paramDescr) {
            return {
                name: paramDescr["name"],
                path: paramDescr["path"],
                arrayPath: paramDescr["array"] || null
            };
        });
    },

    /**
     * @private
     * @param {!Array<!Object>} paramsDescr
     * @return {!Array<{name:string, header:string, value:string}>}
     */
    _createHeaderParameterInfos: function(paramsDescr) {
        return paramsDescr.map(function(paramDescr) {
            return {
                name: paramDescr["name"],
                header: paramDescr["header"],
                value: paramDescr["value"]
            };
        });
    },

    /** @override */
    executeOperation: function(context) {
        var thisService = this;
        return this._sendRequest(context.getInput()).then(function(response) {
            var outputs = thisService._processResponse(response);
            return new wrm.nav.Output("success", outputs);
        })["catch"](function(e) {
            return new wrm.nav.Output("error", {
                "errorMessage": "Unexpected error"
            });
        });
    },

    /*
     * Request
     */

    /**
     * @param {!wrm.nav.Input} input
     * @return {!Promise<!angular.$http.Response>}
     */
    _sendRequest: function(input) {
        var platform = this.getManager().getPlatform();

        /* Prepare the URL to invoke, also replacing parameters */
        var currentUrl = this._url.replace(/\{(.+?)\}/g, function(m, placeholderName) {
            return input["path." + placeholderName];
        });

        /* Prepare the data to send in the query and in the body */
        var requestData = this._prepareRequestData(input);
        var requestHeaders = this._prepareRequestHeaders(input);
        var queryParams = this._preapreQueryParams(requestData, requestHeaders, input);
        var bodyDataPromise = this._preapreBodyData(requestData, requestHeaders, input);

        return bodyDataPromise.then(function(bodyData) {
            return platform.makeHttpRequest({
                method: this._method,
                url: currentUrl,
                headers: requestHeaders,
                params: queryParams,
                data: bodyData,
                responseType: this._responseType,
                timeout: this._timeout
            });
        }.bind(this));
    },

    /**
     * @private
     * @param {!Object} data
     * @param {!Object<string,string>} headers
     * @param {!wrm.nav.Input} input
     * @return {!Object}
     */
    _preapreQueryParams: function(data, headers, input) {
        if (!(this._method === "GET" || this._method === "DELETE")) {
            return {}; // no query for other methods
        }
        return data;
    },

    /**
     * @private
     * @param {!Object} data
     * @param {!Object<string,string>} headers
     * @param {!wrm.nav.Input} input
     * @return {!Promise<!Object>}
     */
    _preapreBodyData: function(data, headers, input) {
        if (this._method === "GET" || this._method === "DELETE") {
            return Promise.resolve(/** @type {!Object} */({})); // no body for these methods
        }

        var attachedBlobs = wrm.data.toBlobArray(input["attachmentBlobs"]);
        if (attachedBlobs.length <= 0) {
            return Promise.resolve(this._prepareBodySimple(data, headers));
        } else {
            return this._prepareBodyWithAttachments(data, headers, attachedBlobs);
        }
    },

    /**
     * @private
     * @param {!Object} data
     * @param {!Object<string,string>} headers
     * @return {!Object}
     */
    _prepareBodySimple: function(data, headers) {
        switch (this._requestType) {
        case RequestType.JSON:
            return data;
        case RequestType.FORM_DATA:
            var fd = new FormData();
            Object.keys(data).forEach(function(key) {
                fd.append(key, data[key]);
            });
            return fd;
        default:
            throw new Error("Unknown request type");
        }
    },

    /**
     * @private
     * @param {!Object} data
     * @param {!Object<string,?string|undefined>} headers
     * @param {!Array<!wrm.data.Blob>} attachedBlobs
     * @return {!Promise<!Object>}
     */
    _prepareBodyWithAttachments: function(data, headers, attachedBlobs) {
        headers["Content-Type"] = undefined;

        /** @type {!Array<!Promise<{id:string, blob:!Blob}>>} */
        var attachmentPromises = attachedBlobs.map(function(blob) {
            return blob.readBlob().then(function(nativeBlob) {
                return {
                    id: blob.getUniqueId(),
                    blob: nativeBlob
                };
            })
        });

        return Promise.all(attachmentPromises).then(function(attachments) {
            var fd = new FormData();

            switch (this._requestType) {
            case RequestType.JSON:
                fd.append("data", JSON.stringify(data));
                break;
            case RequestType.FORM_DATA:
                Object.keys(data).forEach(function(key) {
                    fd.append(key, data[key]);
                });
                break;
            default:
                throw new Error("Unknown request type");
            }

            attachments.forEach(function(attachment) {
                fd.append(attachment.id, attachment.blob);
            });

            return fd;
        }.bind(this));
    },

    /**
     * @private
     * @param {!wrm.nav.Input} input
     * @return {!Object}
     */
    _prepareRequestData: function(input) {
        var om = new wrm.util.ObjectMapper();

        /** @type {!Object<string,!Array<{elementPath:string, value:!Array<*>}>>} */
        var arrayElementInfos = {};

        /* Fill inputs that do not contribute to arrays; store away all others in order to build ARRAYS later */
        this._requestInputs.forEach(function(info) {

            /* Retrieve and convert the input value */
            var value = input[info.name];
            if (value === undefined) {
                return; // continue to next input
            }
            value = this._formatInput(value);

            /* Set value according to path; for empty paths, replace the entire object; skip and store array values */
            var path = info.path;
            var arrayPath = info.arrayPath;
            if (arrayPath) {
                var elementInfos = arrayElementInfos[arrayPath];
                if (!elementInfos) {
                    arrayElementInfos[arrayPath] = elementInfos = [];
                }
                elementInfos.push({
                    elementPath: (path.length > arrayPath.length ? path.substring(arrayPath.length + ".".length) : ""),
                    value: wrm.data.toAnyArray(value)
                });
            } else {
                if (path === "") {
                    om = new wrm.util.ObjectMapper(value);
                } else {
                    om.setValue(path, value);
                }
            }
        }, this);

        /* Build array inputs from their partial inputs */
        Object.keys(arrayElementInfos).forEach(function(arrayPath) {
            var arrayValue = this._buildArrayValue(arrayElementInfos[arrayPath], arrayPath);
            om.setValue(arrayPath, arrayValue);
        }, this);

        return om.getObject();
    },

    /**
     * @private
     * @param {!Array<{elementPath:string, value:!Array<*>}>} elementInfos
     * @param {string} arrayPath
     * @return {!Array<*>}
     */
    _buildArrayValue: function(elementInfos, arrayPath) {
        var result = [];

        /* Normalize values, turning them into arrays of the same length */
        var normalizedValues = {};
        var maxLength = 1;
        for (var i = 0; i < elementInfos.length; i++) {
            var elementInfo = elementInfos[i];
            var elementValue = elementInfo.value;
            if (elementValue.length > 1) {
                if (maxLength === 1) {
                    maxLength = elementValue.length;
                } else if (maxLength !== elementValue.length) {
                    throw new Error("Input array lengths for '" + arrayPath + "' do not match");
                }
            }
            normalizedValues[elementInfo.elementPath] = elementValue;
        }

        /* Condense elements at the same indexes into separate objects */
        for (var i = 0; i < maxLength; i++) {
            var om = new wrm.util.ObjectMapper();
            Object.keys(normalizedValues).forEach(function(elementPath) {
                var valueArray = normalizedValues[elementPath];
                var valueElement = (valueArray.length === 1 ? valueArray[0] : valueArray[i]);
                if (elementPath === "") {
                    om = new wrm.util.ObjectMapper(valueElement);
                } else {
                    om.setValue(elementPath, valueElement);
                }
            });
            result[i] = om.getObject();
        }

        return result;
    },

    /**
     * @param {!wrm.nav.Input} input
     * @return {!Object<string,string>}
     */
    _prepareRequestHeaders: function(input) {
        var headers = {};

        /* Include the HTTP authentication header */
        this._addBasicAuthenticationHeader(headers, input);

        /* Add other headers */
        this._requestHeaderInputs.forEach(function(info) {

            /* Retrieve and convert the input value */
            var value = input[info.name];
            if (value === undefined) {
                value = info.value;
            }
            value = this._formatInput(value);

            headers[info.header] = value;
        }, this);

        return headers;
    },

    /**
     * @private
     * @param {!Object<string,string>} headers
     * @param {!wrm.nav.Input} input
     */
    _addBasicAuthenticationHeader: function(headers, input) {
        var authentication = this._httpAuthentication;
        if (!authentication) {
            return; // authentication not used
        }

        var username = input["httpUsername"] || authentication.username;
        var password = input["httpPassword"] || authentication.password;

        var authorization = "Basic " + this._convertToBase64("" + username + ":" + password);
        headers["Authorization"] = authorization;
    },

    /**
     * @private
     * @param {!Array<*>|*} valueOrArray
     * @return {!Array<*>|*}
     */
    _formatInput: function(valueOrArray) {
        // TODO implement a better type conversion with information from generation
        if (Array.isArray(valueOrArray)) {
            return valueOrArray.map(this._formatInputValue, this);
        }
        return this._formatInputValue(valueOrArray);
    },

    /**
     * @private
     * @param {*} value
     * @return {*}
     */
    _formatInputValue: function(value) {

        /* Handle native dates as timestamps */
        if (value instanceof Date) {
            value = wrm.data.DateTime.fromDate(value);
        }

        /* Convert to a JSON-compatible value */
        var type = typeof value;
        if (type !== "string" && type !== "number" && type !== "boolean") {
            value = wrm.data.toString(value);
        }
        return value;
    },

    /**
     * @private
     * @param {!string} stringToConvert
     * @return {!string}
     */
    _convertToBase64: function(stringToConvert) { // TODO delete and use native base64 conversion!
        var keyStr = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
        var output = "";
        var chr1, chr2, chr3, enc1, enc2, enc3, enc4;
        var i = 0;
        stringToConvert = this._utf8_encode(stringToConvert);
        while (i < stringToConvert.length) {
            chr1 = stringToConvert.charCodeAt(i++);
            chr2 = stringToConvert.charCodeAt(i++);
            chr3 = stringToConvert.charCodeAt(i++);
            enc1 = chr1 >> 2;
            enc2 = ((chr1 & 3) << 4) | (chr2 >> 4);
            enc3 = ((chr2 & 15) << 2) | (chr3 >> 6);
            enc4 = chr3 & 63;
            if (isNaN(chr2)) {
                enc3 = enc4 = 64;
            } else if (isNaN(chr3)) {
                enc4 = 64;
            }
            output = output + keyStr.charAt(enc1) + keyStr.charAt(enc2) + keyStr.charAt(enc3) + keyStr.charAt(enc4);
        }
        return output;
    },

    /**
     * @private
     * @param {!string} stringToConvert
     * @return {!string}
     */
    _utf8_encode: function(stringToConvert) {
        stringToConvert = stringToConvert.replace(/\r\n/g, "\n");
        var utftext = "";
        for (var n = 0; n < stringToConvert.length; n++) {
            var c = stringToConvert.charCodeAt(n);
            if (c < 128) {
                utftext += String.fromCharCode(c);
            } else if ((c > 127) && (c < 2048)) {
                utftext += String.fromCharCode((c >> 6) | 192);
                utftext += String.fromCharCode((c & 63) | 128);
            } else {
                utftext += String.fromCharCode((c >> 12) | 224);
                utftext += String.fromCharCode(((c >> 6) & 63) | 128);
                utftext += String.fromCharCode((c & 63) | 128);
            }
        }
        return utftext;
    },

    /*
     * Response
     */

    /**
     * @private
     * @param {!angular.$http.Response} response
     * @return {!Object<string,*>}
     */
    _processResponse: function(response) {
        var data = response.data;
        var outputs = {};

        /* Extract response data as outputs */
        switch (this._responseType) {
        case ResponseType.JSON:
            this._extractResponseData(outputs, response.data);
            outputs["json"] = JSON.stringify(response.data);
            break;
        case ResponseType.TEXT:
            outputs["text"] = String(data);
            break;
        }

        /* Extract response headers */
        this._extractResponseHeaders(outputs, response);

        return outputs;
    },

    /**
     * @param {!Object<string,*>} outputs
     * @param {!Object} responseData
     */
    _extractResponseData: function(outputs, responseData) {
        var om = new wrm.util.ObjectMapper(responseData);
        om.setFlattenArrays(true);
        this._responseOutputs.forEach(function(info) {

            /* Get value according to path; for empty value, retrieve the entire object */
            var value;
            if (info.path === "") {
                if (info.arrayPath) {
                    value = wrm.data.toAnyArray(om.getObject());
                } else {
                    value = wrm.data.toAnySingle(om.getObject());
                }
            } else {
                if (info.arrayPath) {
                    value = om.getValues(info.path);
                } else {
                    value = om.getValue(info.path);
                }
            }

            if (value !== undefined) {
                outputs[info.name] = value;
            }
        }, this);
    },

    /**
     * @param {!Object<string,*>} outputs
     * @param {!angular.$http.Response} response
     */
    _extractResponseHeaders: function(outputs, response) {
        var headers = response.headers();
        this._responseHeaderOutputs.forEach(function(info) {
            outputs[info.name] = headers[info.header.toLowerCase()];
        });
    },

});

/**
 * @private
 * @enum {string}
 */
var RequestType = {
    JSON: "JSON",
    FORM_DATA: "FORM_DATA"
};

/**
 * @private
 * @enum {string}
 */
var ResponseType = { // values used in HTTP request config
    JSON: "json",
    TEXT: "text"
};
