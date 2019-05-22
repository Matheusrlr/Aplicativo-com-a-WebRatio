import org.apache.commons.lang.math.NumberUtils

def componentName = component["name"] ? component["name"] : component["id"]

def dClassId = component["dataBinding"]
def blockFactor = component["blockFactor"]
def blockWindow = component["blockWindow"]

if (dClassId == "") {
	addError("Unspecified Data Binding")
} else {
	if (component.selectNodes("SortAttribute").size() == 0) {
		addWarning("Unspecified sorting attributes")
	}
}

if (blockFactor != "" && NumberUtils.toInt(blockFactor, -1) <= 0) {
    addWarning("Invalid block factor")
} else if(blockFactor == "") {
    addError("Unspecified block factor")
}
if ((blockWindow != "") && NumberUtils.toInt(blockWindow, -1) <= 0) {
    addError("Invalid block window")
}