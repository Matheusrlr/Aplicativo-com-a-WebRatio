def dclassId = component["dataBinding"]
def name = component["name"] ? component["name"] : component["id"]
if (dclassId == "") {
	addError("The class for the component '" + name + "' is unspecified")
}
def dclass = getById(dclassId)
def attrIds = component["distinctAttributes"]
if (component["distinct"] == "true") {
    if ((dclass != null) && (attrIds == "")) {
        addError("The distinct property is enabled but no attributes are specified for the component '" + name + "'")
    }
} 
if (isIneffectiveDistinctFlag(component)) {
    def fix = createChangeAttributeFix("Set distinct to false.", "distinct", "false")
	addError("Ineffective distinct flag (all key attributes have been included in the select clause)", fix)
}

