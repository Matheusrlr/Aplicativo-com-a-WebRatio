#!/usr/bin/env node

var fs = require('fs');
var path = require('path');

/* Inputs */
var rootPath = process.argv[2];

/* Align the Xcode Project file */
(function() {
    var projectName = getIosProjectName(path.join(rootPath, "platforms/ios"));
    var sdkProjectPath = path.join(rootPath, "platforms/ios/" + projectName+".xcodeproj","project.pbxproj");
    if (fs.existsSync(sdkProjectPath)) {
        var contents = fs.readFileSync(sdkProjectPath, {
            encoding: "utf8" }
        );
        contents = removeGermanLanguage(contents);
        fs.writeFileSync(sdkProjectPath, contents, {
            encoding: "utf8"
        });
    }
})();

/*
 * Utilities
 */

/* Function for removing the german language the Xcode Project file */
function removeGermanLanguage(text) {
    
    /* remove German language */
    var GERMAN_LANGUAGE = "30A0434814DC770100060A13 /* Localizable.strings in Resources */,";
    return text.replace(GERMAN_LANGUAGE,"");;
};

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
