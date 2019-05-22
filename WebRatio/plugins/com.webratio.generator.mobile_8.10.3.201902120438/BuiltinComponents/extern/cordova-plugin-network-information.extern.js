/**
 * @fileoverview Externs for the cordova-plugin-network-information plugin. This
 *               is NOT OFFICIAL, with only the API we use at WebRatio.
 * @externs
 */

/** @const */
navigator.connection;

/** @const {!Connection} */
navigator.connection.type;

/**
 * @enum {string}
 */
var Connection = {
	UNKNOWN: "unknown",
	ETHERNET: "ethernet",
	WIFI: "wifi",
	CELL_2G: "2g",
	CELL_3G: "3g",
	CELL_4G: "4g",
	CELL: "cellular",
	NONE: "none"
};
