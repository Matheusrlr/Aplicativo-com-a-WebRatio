#!/usr/bin/env node

var fs = require("fs");
var path = require("path");
var xmldom = require("xmldom");
var xselect; // init'd in main
var plist; // init'd in main

/* Inputs */
var rootPath = process.argv[2];

/** Entry point */
function main() {

    /* Initialize the XML and XPath modules */
    var xpath = require("xpath");
    xselect = xpath.useNamespaces({
        "w": "http://www.w3.org/ns/widgets",
        "gap": "http://phonegap.com/ns/1.0",
        "android": "http://schemas.android.com/apk/res/android",
        "xamlp": "http://schemas.microsoft.com/winfx/2006/xaml/presentation",
        "phone": "clr-namespace:Microsoft.Phone.Controls;assembly=Microsoft.Phone"
    });

    /* Initialize the PList module (only for iOS) */
    if (fs.existsSync(path.join(rootPath, "platforms", "ios"))) {
        plist = require("plist");
    }

    /* Update the configuration files in each platform */
    fs.readdirSync(path.join(rootPath, "platforms")).forEach(function(platformDirName) {
        var platformDir = path.join(rootPath, "platforms", platformDirName);
        if (fs.lstatSync(platformDir).isDirectory()) {
            updatePlatformConfigFiles(platformDirName, platformDir);
        }
    });
}

/*
 * Preference mapping to patches
 */

/**
 * Mapping rules from <preference> elements to patches in configuration files.
 */
var PREFERENCE_MAPPING = {
    "android": {},
    "ios": {},
    "windows": {}
};

/*
 * Platform configuration updating
 */

/**
 * Updates configuration file of a specific platform.
 */
function updatePlatformConfigFiles(platform, platformDir) {
    log("Updating configuration files of " + platform + " (" + platformDir + ")");

    /* Parse config.xml */
    var configPath = path.join(rootPath, "config.xml");
    if (!fs.existsSync(configPath)) {
        configPath = path.join(rootPath, "www", "config.xml");
    }
    var configDoc = parseXmlFile(configPath);

    /* Extract patches from <preference> and <wr-config-file> elements */
    var patchesMap = {};
    xselect("/w:widget/w:preference", configDoc).forEach(addPreferencePatch.bind(this, patchesMap, platform));
    xselect("/w:widget/w:platform[@name = '" + platform + "']/w:preference", configDoc).forEach(
            addPreferencePatch.bind(this, patchesMap, platform));
    xselect("/w:widget/w:wr-config-file[@platform = '" + platform + "']", configDoc).forEach(addConfigFilePatch.bind(this, patchesMap));
    xselect("/w:widget/w:platform[@name = '" + platform + "']/w:wr-config-file", configDoc).forEach(
            addConfigFilePatch.bind(this, patchesMap));

    /* Group patches by target */
    var patchesByTarget = {};
    Object.keys(patchesMap).forEach(function(key) {
        var patches = patchesMap[key];
        patches.forEach(function(patch) {
            var list = patchesByTarget[patch.target];
            if (!list) {
                patchesByTarget[patch.target] = list = [];
            }
            list.push(patch);
        });
    });

    /* Apply patches to each target */
    Object.keys(patchesByTarget).forEach(function(target) {
        switch (target) {
        case "AndroidManifest.xml":
            patchXmlFile(platformDir, "app/src/main/AndroidManifest.xml", patchesByTarget[target]);
            break;
        case "*-Info.plist":
            patchInfoPlist(platformDir, patchesByTarget[target]);
            break;
        case "MainPage.xaml":
            patchXmlFile(platformDir, "MainPage.xaml", patchesByTarget[target]);
            break;
        default:
            throw new Error("Invalid config file target '" + target + "'");
        }
    });
}

/**
 * Adds a patch for implementing the change indicated by a config.xml <preference>
 * element.
 * 
 */
function addPreferencePatch(patchesMap, platform, preferenceElem) {
    var prefName = preferenceElem.getAttribute("name");
    var mapping = PREFERENCE_MAPPING[platform][prefName];
    if (!mapping) {
        return;
    }
    log("Will apply preference '" + prefName + "'");
    var prefValue = preferenceElem.getAttribute("value");
    var patches = mapping(prefValue);
    if (!Array.isArray(patches)) {
        patches = [ patches ];
    }
    patches.forEach(function(patch, i) {
        if (typeof patch.value === "string") {
            patch.value = cloneNodes(parseXmlString("<root>" + patch.value + "</root>").documentElement.childNodes);
        }
    });
    patchesMap[prefName] = patches;
}

/**
 * Adds a patch for implementing the change indicated by a <wr-config-file> element.
 */
function addConfigFilePatch(patchesMap, configFileElem) {
    var target = configFileElem.getAttribute("target");
    var parent = configFileElem.getAttribute("parent");
    var key = "file::" + target + ";" + parent;
    patchesMap[key] = [ {
        target: target,
        parent: parent,
        value: cloneNodes(configFileElem.childNodes),
        valueAttrs: {},
        merge: (configFileElem.getAttribute("mode") === "merge")
    } ];
}

/*
 * XML files patching
 */

/**
 * Updates a platform XML file with a series of patches.
 */
function patchXmlFile(platformDir, fileName, patches) {
    var xmlFile = path.join(platformDir, fileName);
    log("Patching XML " + xmlFile);
    var doc = parseXmlFile(xmlFile);
    log("Initial content: ", doc);
    patches.forEach(function(patch) {
        patchDocument(doc, patch);
    });
    log("Patched content: ", doc);
    serializeXmlFile(xmlFile, doc);
}

/*
 * *-Info.plist patching
 */

/**
 * Updates the iOS project main property list file with a series of patches.
 */
function patchInfoPlist(platformDir, patches) {
    var projectName = getIosProjectName(platformDir);
    var plistFile = path.join(platformDir, projectName, projectName + "-Info.plist");
    log("Patching iOS property list " + plistFile);
    var obj = parsePlistFile(plistFile);
    log("Initial content: ", obj);
    patches.forEach(function(patch) {
        patchProperties(obj, patch);
    });
    log("Patched content: ", obj);
    serializePlistFile(plistFile, obj);
}

/*
 * XML handling
 */

/**
 * Parsers a file into an XML DOM.
 */
function parseXmlFile(file, encoding) {
    var xml = fs.readFileSync(file, {
        encoding: encoding || "utf8"
    });
    return parseXmlString(xml);
}

/**
 * Parsers a string into an XML DOM.
 */
function parseXmlString(xml) {
    return new xmldom.DOMParser().parseFromString(xml, "text/xml");
}

/**
 * Serializes an XML DOM to a file.
 */
function serializeXmlFile(file, doc, encoding) {
    var xml = serializeXmlString(doc);
    fs.writeFileSync(file, xml, {
        encoding: encoding || "utf8"
    });
}

/**
 * Serializes an XML DOM into a string.
 */
function serializeXmlString(doc) {
    return new xmldom.XMLSerializer().serializeToString(doc);
}

/**
 * Applies a patch to an XML document DOM.
 */
function patchDocument(doc, patch) {
    var newChildNodes = patch.value || [];
    var newAttributes = patch.valueAttrs || {};

    /* Locate each parent element and patch it separately */
    log("Applying patch to ", patch.parent, " with ", newChildNodes.length, " new nodes and ",
            Object.keys(newAttributes).length, " attributes", (patch.merge ? " (merge mode)" : ""));
    xselect(patch.parent, doc).forEach(function(parentElem) {
        patchChildNodes(parentElem, importNodes(newChildNodes, parentElem.ownerDocument), patch.merge);
        patchAttributes(parentElem, newAttributes);
    });
}

/**
 * Patches a series of child nodes into a parent element. With 'merge' mode active, the new nodes will replace existing nodes having
 * the same name; otherwise, the new nodes are just appended.
 */
function patchChildNodes(parentElem, newChildNodes, merge) {

    /* If merging, find all "same" nodes and remove them */
    if (merge) {
        var newNodeKeys = {};
        newChildNodes.forEach(function(node) {
            newNodeKeys[getNodeIdentityKey(node)] = true;
        });

        var nodesToRemove = [];
        iterateArrayLike(parentElem.childNodes, function(node) {
            if (newNodeKeys[getNodeIdentityKey(node)]) {
                nodesToRemove.push(node);
            }
        });

        nodesToRemove.forEach(function(node) {
            node.parentNode.removeChild(node);
        });
    }

    /* Append all new nodes */
    newChildNodes.forEach(function(node) {
        parentElem.appendChild(node);
    });
}

/**
 * Patches a set of attribute values into a parent element. Null and undefined values cause the attribute to be removed.
 */
function patchAttributes(parentElem, newAttributes) {
    
    /* Set all attribute values */
    Object.keys(newAttributes).forEach(function(name) {
        var value = newAttributes[name];
        if (value === null || value === undefined) {
            parentElem.removeAttribute(name);
        } else {
            parentElem.setAttribute(name, String(value));
        }
    });
}

/**
 * Computes a key identifying a node for the purpose of replacing/merging.
 */
function getNodeIdentityKey(node) {
    return "" + node.nodeType + "," + node.nodeName;
}

/**
 * Creates an array of nodes cloned from a node list.
 */
function cloneNodes(nodeList) {
    return Array.prototype.slice.call(nodeList).map(function(node) {
        return cloneNodeFix(node);
    });
}

/**
 * Clone recursively a node removing the namespace "widgets".
 */
function cloneNodeFix(node) {
    if (node.nodeType !== 1/*Node.ELEMENT_NODE*/) {
        return node.cloneNode(false);
    }
    var clonedElem;
    if (node.namespaceURI && node.namespaceURI !== "http://www.w3.org/ns/widgets") {
        clonedElem = node.ownerDocument.createElementNS(node.namespaceURI, node.prefix + ":" + node.localName);
    } else {
        clonedElem = node.ownerDocument.createElement(node.localName);
    }
    var children = node.childNodes;
    for (var i = 0; i < children.length; i++) {
        var clonedChild = cloneNodeFix(children[i]);
        clonedElem.appendChild(clonedChild);
    }
    var attributes = node.attributes;
    for (var i = 0; i < attributes.length; i++) {
        var attr = attributes[i];
        var localName = attr.localName.toLowerCase();
        if ((localName === "xmlns") || localName.startsWith("xmlns:")) {
            continue;
        }
        if (attr.namespaceURI && attr.namespaceURI !== "http://www.w3.org/ns/widgets") {
            clonedElem.setAttributeNS(attr.namespaceURI, attr.prefix + ":" + attr.localName, attr.value);
        } else {
            clonedElem.setAttribute(attr.localName, attr.value);
        }
    }
    return clonedElem;
}

/**
 * Creates an array of nodes cloned from a node list.
 */
function importNodes(nodeList, doc) {
    return Array.prototype.slice.call(nodeList).map(function(node) {
        return doc.importNode(node, true);
    });
}

/*
 * Property List handling
 */

/**
 * Parsers a file into a PList object structure.
 */
function parsePlistFile(file, encoding) {
    var xml = fs.readFileSync(file, {
        encoding: encoding || "utf8"
    });
    return parsePlistString(xml);
}

/**
 * Parsers a string into a PList object structure.
 */
function parsePlistString(xml) {
    return plist.parse(xml);
}

/**
 * Serializes a PList object structure to a file.
 */
function serializePlistFile(file, obj, encoding) {
    var xml = serializePlistString(obj, true);
    fs.writeFileSync(file, xml, {
        encoding: encoding || "utf8"
    });
}

/**
 * Serializes a PList object structure into a string.
 */
function serializePlistString(obj, fullDocument) {
    var xml = plist.build(obj);
    if (!fullDocument) {
        xml = /^[\S\s]+?<plist\b.*?>([\S\s]+)<\/plist>$/.exec(xml)[1];
    }
    return xml;
}

/**
 * Applies a patch to a PList object structure.
 */
function patchProperties(obj, patch) {

    /* Prepare the new value */
    var valueNode = null;
    iterateArrayLike(patch.value, function(node) {
        if (node.nodeType === 1) { // element
            if (!valueNode) {
                valueNode = node;
            } else {
                throw new Error("Property list patches can supply only one element");
            }
        }
    });
    if (!valueNode) {
        return;
    }
    var newValueObj = parsePlistString("<plist>" + serializeXmlString(valueNode) + "</plist>");
    log("Applying patch to ", patch.parent, " with value ", newValueObj, (patch.merge ? " (merge mode)" : ""));

    /* Locate the target object and its key; create missing objects along the way */
    var path = patch.parent.split("/");
    var targetKey = path.pop();
    var targetObj = path.reduce(function(pathStep) {
        var nextObj = obj[pathStep];
        if (!nextObj) {
            obj[pathStep] = nextObj = {};
        }
        return nextObj;
    }, obj);

    patchObjectValue(targetObj, targetKey, newValueObj, patch.merge);
}

/**
 * Patches an object property value with a new one.
 */
function patchObjectValue(obj, key, newValue, merge) {
    var oldValue = merge ? obj[key] : undefined;

    /* Merge with the old value */
    if (oldValue) {
        (function() {
            if (typeof oldValue !== "object" || typeof newValue !== "object") {
                throw new Error("Cannot merge value of '" + key + "'");
            }
            var useArray = Array.isArray(oldValue);
            if (useArray !== Array.isArray(newValue)) {
                throw new Error("Cannot merge array with non-array in '" + key + "'");
            }
            var oldObjectValue = useArray ? buildSetObject(oldValue) : oldValue;
            var newObjectValue = useArray ? buildSetObject(newValue) : newValue;
            for ( var key in oldObjectValue) {
                if (oldObjectValue.hasOwnProperty(key) && !newObjectValue.hasOwnProperty(key)) {
                    newObjectValue[key] = oldObjectValue[key];
                }
            }
            newValue = useArray ? Object.keys(newObjectValue) : newObjectValue;
        })();
    }

    obj[key] = newValue;
}

/*
 * iOS project handling
 */

/**
 * Gets the name of iOS project found within an iOS platform directory.
 */
function getIosProjectName(platformDir) {
    var result = null;
    fs.readdirSync(platformDir).forEach(function(childName) {
        var m = /^(.+?)\.xcodeproj$/.exec(childName);
        if (m) {
            result = m[1];
        }
    });
    if (!result) {
        throw new Error("iOS project not found in " + platformPath);
    }
    return result;
}

/*
 * Utilities
 */

/**
 * Iterates an array-like object.
 */
function iterateArrayLike(arrayLike, iterator, context) {
    Array.prototype.forEach.call(arrayLike, iterator, context);
}

/**
 * Transforms an array of keys into an object acting as a set.
 */
function buildSetObject(keys) {
    var result = {};
    for (var i = 0; i < keys.length; i++) {
        result[keys[i]] = true;
    }
    return result;
}

/**
 * Logs a debug message.
 */
function log() {
    console.log("[UpdateConfig]", Array.prototype.join.call(arguments, ""));
}

/* Run */
main();
