import org.apache.commons.lang.math.NumberUtils
def dClassId = component["dataBinding"]
def componentName = component["name"] ? component["name"] : component["id"]

if (dClassId == "") {
	addError("Unspecified Data Binding")
} else {
	if (component["displayAttributes"] == "") {
		addWarning("Unspecified display attributes")
	}
	if (component.selectNodes("SortAttribute").size() == 0) {
		addWarning("Unspecified sorting attributes")
	}
}

def blockFactor = component["blockFactor"]
def blockWindow = component["blockWindow"]
def sortHistorySize = component["sortHistorySize"]

if (blockFactor != "" && NumberUtils.toInt(blockFactor, -1) <= 0) {
    addWarning("Invalid block factor")
}
if (blockWindow != "" && NumberUtils.toInt(blockWindow, -1) <= 0) {
    addWarning("Invalid block window")
}
if (sortHistorySize != "" && NumberUtils.toInt(sortHistorySize, -1) <= 0) {
    addWarning("Invalid sort history size")
}

if (isIneffectiveDistinctFlag(component)) {
	addWarning("Ineffective distinct flag (all key attributes have been included in the select clause)")
}