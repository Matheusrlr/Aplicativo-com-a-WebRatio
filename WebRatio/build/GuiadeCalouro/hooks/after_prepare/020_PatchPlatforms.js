#!/usr/bin/env node

var fs = require('fs');
var path = require('path');

/* Inputs */
var rootPath = process.argv[2];

/* Copy platform merges over platforms */
copyRecursive(path.join(rootPath, "platforms_merges"), path.join(rootPath, "platforms"))

/*
 * Utilities
 */

/* Function for recursively copying files and directories */
function copyRecursive(sourcePath, targetPath) {
	if (!fs.existsSync(sourcePath)) {
	    return;
	}
	var stats = fs.lstatSync(sourcePath);
    if (stats.isSymbolicLink()) {
        return;
    }
    if (stats.isDirectory()) {
        if (!fs.existsSync(targetPath)) {
            fs.mkdirSync(targetPath);
        }
        fs.readdirSync(sourcePath).forEach(function(childName) {
            var sourceChildPath = path.join(sourcePath, childName);
            var targetChildPath = path.join(targetPath, childName);
            copyRecursive(sourceChildPath, targetChildPath); // recurse
        });
    } else {
        fs.createReadStream(sourcePath).pipe(fs.createWriteStream(targetPath));
    }
}
