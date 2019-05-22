def dClassBased = component["classBased"] == "true"
def componentName = component["name"] ? component["name"] : component["id"]
if (dClassBased) {
    def dClassId = component["dataBinding"]
    
    if (dClassId == "") {
    	addError("Unspecified Data Binding")
    }
    
    def dateAttrId = component["dateAttribute"]
    if (dateAttrId == "") {
    	addError("Unspecified Date Attribute")
    } else if (getById(dateAttrId)["type"] != "date") {
    	addError("Invalid attribute " + getById(dateAttrId)["name"] + " '" + dateAttrId + "'  for " + component["name"])
    }
    
    if (component["displayAttributes"] == "") {
    	addWarning("Unspecified Display Attributes")
    }
    
   	if (component.selectNodes("SortAttribute").size() == 0) {
   		addWarning("Unspecified Sort Attributes")
   	}
}