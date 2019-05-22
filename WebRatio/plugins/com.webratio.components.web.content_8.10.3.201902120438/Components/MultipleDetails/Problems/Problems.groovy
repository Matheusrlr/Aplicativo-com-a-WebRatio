def dClassId = component["dataBinding"]
def componentName = component["name"] ? component["name"] : component["id"]

if (dClassId == "") {
	addError("Unspecified Data Binding")
} else {
	if (component["displayAttributes"] == "") {
		
		if (component["distinct"] == "true") {
			 addError("Unspecified display attributes with 'distinct' property enabled")
		} else {
			addWarning("Unspecified display attributes")
		}
	}
	
	if (component.selectNodes("SortAttribute").size() == 0) {
		addWarning("Unspecified sorting attributes")
	}
}