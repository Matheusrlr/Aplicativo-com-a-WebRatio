/**
 * Service for Barcode view components.
 * 
 * @constructor
 * @extends wrm.core.AbstractViewComponentService
 * @param {string} id
 * @param {!Object} descr
 * @param {!wrm.core.Manager} manager
 */
export default wrm.defineService(wrm.core.AbstractViewComponentService, {

    /** @override */
    initialize: function(descr) {
        var thisService = this;

        /**
         * @private
         * @type {!string}
         */
        this._format = descr["format"];

        /**
         * @private
         * @type {string}
         */
        this._valueType = descr["valueType"];

    },

    /** @override */
    computeOutput: function(context) {},

    /** @override */
    submitView: function(context) {
        return {};
    },

    /** @override */
    updateView: function(context) {
        var thisService = this;
        var view = context.getView();
        var input = context.getInput();
        if (!thisService._validInput(input)) {
            return view;
        }
        var encodePromise = new Promise(function(resolve, reject) {
            var type = cordova.plugins.barcodeScanner.Encode.TEXT_TYPE;
            cordova.plugins.barcodeScanner.encode(type, thisService._createMessage(input), resolve, reject, {
                format: thisService._format
            });
        });

        return encodePromise.then(function(row) {
            var dataUriRegEx = /^data:(.*?)(?:;(base64))?,(.*)$/;
            var barcode = {};
            var barcodeBlob = null;
            if (!(dataUriRegEx.exec(row["file"]))) {
                return wrm.util.fs.lookupFile("file://" + row["file"]).then(function(file) {
                    barcodeBlob = wrm.data.Blob.fromFile(file, "image/png");
                    barcode["image"] = barcodeBlob;
                    view["barcode"] = barcode;
                    return view;
                });
            } else {
                barcodeBlob = wrm.data.Blob.fromDataUri(row["file"]);
            }
            barcode["image"] = barcodeBlob;
            view["barcode"] = barcode;
            return view;
        }, function(e) {
            thisService.getLog().error("An error occurred while generating the barcode/qrcode" + e);
            var barcode = {};
            barcode["encodeFailure"] = true;
            view["barcode"] = barcode;
            return view;
        });
    },

    /**
     * @private
     * @param {!Object} input
     * @return {!string}
     */
    _createMessage: function(input) {
        if (this._format === "CODE_128") {
            return input["text"];
        }
        if (this._valueType === "text") {
            return input["text"];
        } else if (this._valueType === "url") {
            return input["url"];
        } else if (this._valueType === "sms") {
            return "SMSTO:" + input["phoneNumber"] + ":" + input["text"];
        } else if (this._valueType === "email") {
            return "MATMSG:TO:" + input["recipient"] + (input["subject"] ? ";SUB:" + input["subject"] : "") + (input["body"]
                    ? ";BODY:" + input["body"] + ";;" : ";BODY:;;");
        } else if (this._valueType === "phone") {
            return "tel:" + input["phoneNumber"];
        } else if (this._valueType === "geo") {
            return "geo:" + input["latitude"] + "," + input["longitude"];
        } else if (this._valueType === "phoneContact") {
            return "MECARD:" + "N:" + (input["contactName"] ? input["contactName"] : "") + (input["contactAddress"]
                    ? ";ADR:" + input["contactAddress"] : "") + (input["contactPhone"] ? ";TEL:" + input["contactPhone"] : "")
                    + (input["contactEmail"] ? ";EMAIL:" + input["contactEmail"] : "") + ";";
        }
        return "";
    },

    /**
     * @private
     * @param {!Object} input
     * @return {!boolean}
     */
    _validInput: function(input) {
        if (this._format === "CODE_128") {
            if (input["text"]) {
                return true;
            }
            ;
        } else {
            if (this._valueType === "text") {
                if (input["text"]) {
                    return true;
                }
                ;
            } else if (this._valueType === "url") {
                if (input["url"]) {
                    return true;
                }
                ;
            } else if (this._valueType === "sms") {
                if (input["phoneNumber"] || input["text"]) {
                    return true;
                }
            } else if (this._valueType === "email") {
                if (input["recipient"] || input["subject"] || input["body"]) {
                    return true;
                }
            } else if (this._valueType === "phone") {
                if (input["phoneNumber"]) {
                    return true;
                }
            } else if (this._valueType === "geo") {
                if (input["latitude"] || input["longitude"]) {
                    return true;
                }
            } else if (this._valueType === "phoneContact") {
                if (input["contactName"] || input["contactAddress"] || input["contactPhone"] || input["contactEmail"]) {
                    return true;
                }
            }
        }
        return false;
    }
});
