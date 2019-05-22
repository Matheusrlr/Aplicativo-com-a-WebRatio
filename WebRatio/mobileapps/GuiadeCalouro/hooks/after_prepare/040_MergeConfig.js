#!/usr/bin/env node

/*
 * this hook read custom preferences from config.xml and configure the platforms
 */

var fs = require('fs');
var path = require('path');

/* Inputs */
var rootPath = process.argv[2];

if (!fs.existsSync(path.join(rootPath, 'platforms', 'android', 'AndroidManifest.xml'))) {
    return
}

var xmldom = require('xmldom');



/* DOM Helpers */
var domparser = new xmldom.DOMParser();
var domserializer = new xmldom.XMLSerializer();

(function() {
    log("Merging config.xml");

    /* Find config.xml */
    var configPath = path.join(rootPath, "config.xml");
    if (!fs.existsSync(configPath)) {
        configPath = path.join(rootPath, "www", "config.xml");
    }

    var preferences = loadPreferences(configPath);
    updateAndroid(preferences);
})();

/* Loads preferences from config.xml */
function loadPreferences(configPath) {
    var pref, configFile, configDoc;
    pref = {};
    
    log("Loading preferences");
    if (fs.existsSync(configPath)) {
        var configFile = fs.readFileSync(configPath, {
            encoding: "utf8"
        });
        var configDoc = domparser.parseFromString(configFile, 'text/xml');
        var preferences = configDoc.getElementsByTagName('preference');
        for (var i = 0; i < preferences.length; i++) {
            var p = preferences.item(i);
            pref[p.getAttribute("name").toLowerCase()] = p.getAttribute("value");
        }
    }

    return pref;
}

/* Imports preferences in Android platform */
function updateAndroid(pref) {

    /* Load manifest file */
    var manifestPath = path.join(rootPath, 'platforms', 'android', 'AndroidManifest.xml');
    if (!fs.existsSync(manifestPath)) {
        log("Android platform not found");
        return
    }
    var manifestFile = fs.readFileSync(manifestPath, {
        encoding: "utf8"
    });
    var manifestDoc = domparser.parseFromString(manifestFile, 'text/xml');

    log("Updating android platform");

    /* Set minSdkVersion */
    var minSdkVersion = pref["android-minsdkversion"];
    if (minSdkVersion) {
        log("Updating minSdkVersion to " + minSdkVersion);
        manifestDoc.getElementsByTagName('uses-sdk')[0].setAttribute('android:minSdkVersion', minSdkVersion);
    }

    /* Set targetSdkVersion */
    var targetSdkVersion = pref["android-targetsdkversion"];
    if (targetSdkVersion) {
        log("Updating targetSdkVersion to " + targetSdkVersion);
        manifestDoc.getElementsByTagName('uses-sdk')[0].setAttribute('android:targetSdkVersion', targetSdkVersion);
    }
    
    /* Set theme */
    var theme = pref["android-theme"];
    if (theme) {
        log("Updating theme to " + theme);
        var activities = manifestDoc.getElementsByTagName('application')[0].getElementsByTagName('activity');
        for (var i = 0; i < activities.length; i++) {
			var currentActivity = activities[i]; 
        	if (currentActivity.hasAttribute('android:theme') && currentActivity.getAttribute('android:theme') === "@android:style/Theme.Black.NoTitleBar") {
        		currentActivity.setAttribute('android:theme', '@android:style/' + theme);
        	}
		}
    }

    /* Save manifest */
    fs.writeFileSync(manifestPath, domserializer.serializeToString(manifestDoc), {
        encoding: "utf8"
    });
}

/*
 * Utilities
 */

/* Function for logging */
function log(msg) {
   // console.log("[mergeconfig]", msg);
}
