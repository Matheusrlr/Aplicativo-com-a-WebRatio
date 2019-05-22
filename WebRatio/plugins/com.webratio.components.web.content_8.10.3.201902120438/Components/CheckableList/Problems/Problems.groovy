def dClassId = component["dataBinding"]

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