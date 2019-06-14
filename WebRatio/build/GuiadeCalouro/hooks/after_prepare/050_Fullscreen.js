#!/usr/bin/env node

/*
 * this hook read custom preferences from config.xml and configure the platforms
 */

var fs = require('fs');
var path = require('path');

/* Inputs */
var rootPath = process.argv[2];


(function() {
    log("Fix Fullscreen on iOS");

    /* Find config.xml */
    var configPath = path.join(rootPath, "config.xml");
    if (!fs.existsSync(configPath)) {
        configPath = path.join(rootPath, "www", "config.xml");
    }

    var isFullscreen = getFullscreen(configPath);
    log("Fullscreen: " + isFullscreen);
    if (isFullscreen) {
        editPlistFile(function(text) {
            
            var element = "  <key>UIViewControllerBasedStatusBarAppearance</key>\n" +
                            "    <false/>\n" +
                            "    <key>UIStatusBarHidden</key>\n" +
                            "    <true/>\n";
            
            var index = text.search("<\/dict>\n<\/plist>");
            return text.substring(0, index) + element + text.substring(index);            
        });
    }
    
})();

/* Loads preferences from config.xml */
function getFullscreen(configPath) {    
    var configFile = fs.readFileSync(configPath, {
        encoding: "utf8"
    });
    
    return (configFile.search("<preference name=\"Fullscreen\" value=\"true\"\/>") > -1);
}

/* Function for editing the plist file */
function editPlistFile(callback) {
    var projectName = getIosProjectName(path.join(rootPath, "platforms/ios"));
    var sdkProjectPath = path.join(rootPath, "platforms/ios/" + projectName);
    var plistPath = path.join(sdkProjectPath, projectName + "-Info.plist");
    if (fs.existsSync(plistPath)) {
        var contents = fs.readFileSync(plistPath, {
            encoding: "utf8" }
        );
        contents = callback(contents);
        fs.writeFileSync(plistPath, contents, {
            encoding: "utf8"
        });
    }
}

/* Function for getting the iOS project name */
function getIosProjectName(platformPath) {
    if (!fs.existsSync(platformPath)) {
        return null;
    }
    var result = null;
    fs.readdirSync(platformPath).forEach(function(childName) {
        var m = /^(.+?)\.xcodeproj$/.exec(childName);
        if (m) {
            result = m[1];
        }
    });
    if (!result) {
        throw new Error("IOS project not found in " + platformPath);
    }
    return result;
}



/*
 * Utilities
 */

/* Function for logging */
function log(msg) {
   //console.log("[fullscreen]", msg);
}
