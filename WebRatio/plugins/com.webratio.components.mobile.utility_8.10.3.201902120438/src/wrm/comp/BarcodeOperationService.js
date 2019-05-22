/**
 * Service for Barcode Operation operations.
 * 
 * @constructor
 * @extends wrm.core.AbstractOperationService
 * @param {string} id
 * @param {!Object} descr
 * @param {!wrm.core.Manager} manager
 */
export default wrm.defineService(wrm.core.AbstractOperationService, {

    /**
     * @private
     * @const
     */
    ISO_BARCODE_NAMES: {
        "QR_CODE": "QR Code",
        "DATA_MATRIX": "Data Matrix",
        "UPC_A": "UPC-A",
        "UPC_E": "UPC-E",
        "EAN_8": "EAN-8",
        "EAN_13": "EAN-13",
        "CODE_128": "Code 128",
        "CODE_39": "Code 39",
        "CODE_93": "Code 93",
        "CODABAR": "Codabar",
        "RSS_EXPANDED": "RSS Expanded"
    },

    /** @override */
    executeOperation: function(context) {
        var thisService = this;

        var scanPromise = new Promise(function(resolve, reject) {
            cordova.plugins.barcodeScanner.scan(function(scanResult) {
                resolve(scanResult);
            }, function(error) {
                reject(error);
            }, []);
        });

        return scanPromise.then(function(scanResult) {
            if (scanResult["cancelled"]) {
                return new wrm.nav.Output("success.Cancel");
            } else {
                var output = {};
                var value = scanResult["text"];
                var outputFormat = scanResult["format"];
                output["format"] = thisService.ISO_BARCODE_NAMES[outputFormat] ? thisService.ISO_BARCODE_NAMES[outputFormat]
                        : outputFormat;
                output["valueType"] = thisService._getValueType(value);
                output["value"] = value;
                return new wrm.nav.Output("success", output);
            }
        }, function(e) {
            return new wrm.nav.Output("error", {
                "errorMessage": e
            });
        });
    },

    /**
     * @private
     * @param {!String} value
     * @return {!string}
     */
    _getValueType: function(value) {
        if (value.indexOf("http://") === 0 || value.indexOf("https://") === 0) {
            return "url";
        }
        if (value.indexOf("SMSTO:") === 0) {
            return "sms";
        }
        if (value.indexOf("MATMSG:") === 0) {
            return "email";
        }
        if (value.indexOf("tel:") === 0) {
            return "phone";
        }
        if (value.indexOf("geo:") === 0) {
            return "geo";
        }
        if (value.indexOf("MECARD:") === 0) {
            return "phoneContact";
        }
        return "text";
    }
});
