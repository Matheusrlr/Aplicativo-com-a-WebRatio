#!/usr/bin/env node

var fs = require("fs");
var path = require("path");
var xmldom = require("xmldom");
var xselect; // init'd in main

/* Inputs */
var rootPath = process.argv[2];

/** Entry point */
function main() {
    var stringsPath = path.join(rootPath, "platforms/android/res/values/strings.xml");
    if (!fs.existsSync(stringsPath)) {
        return;
    }
    
    /* Initialize the XML and XPath modules */
    var xpath = require("xpath");
    xselect = xpath.useNamespaces({
        "w": "http://www.w3.org/ns/widgets"
    });

    /* Read the configured app name */
    var escapedAppName = (function() {
        var xml = fs.readFileSync( path.join(rootPath, "config.xml"), {
            encoding: "utf8"
        });
        var doc = new xmldom.DOMParser().parseFromString(xml, "text/xml");
        return xselect("/w:widget/w:preference[@name='wr-app-name']/@value", doc)[0].textContent;
    })();
    
    log("Fixing app name in " + stringsPath);
    
    var content = fs.readFileSync(stringsPath, {
        encoding: "utf8"
    });
    
    log("Initial content: ", content);
    content = content.replace(/(<string\s+name="app_name"[^>]*>).*(<\/string>)/, function() {
        return arguments[1] + escapedAppName + arguments[2];
    });
    log("Replaced content: ", content);
    
    fs.writeFileSync(stringsPath, content, {
        encoding: "utf8"
    });
}

/**
 * Logs a debug message.
 */
function log() {
    console.log("[FixAppName]", Array.prototype.join.call(arguments, ""));
}

/* Run */
main();
