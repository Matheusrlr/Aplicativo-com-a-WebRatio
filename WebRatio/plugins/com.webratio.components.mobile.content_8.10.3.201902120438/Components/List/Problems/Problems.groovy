def dClassId = component["dataBinding"]
def componentName = component["name"] ? component["name"] : component["id"]

if (dClassId == "") {
	addError("Unspecified Data Binding")
	return
}
if (component["displayAttributes"] == "") {
	addWarning("Unspecified Display Attributes")
}
if (component.selectNodes("SortAttribute").size() == 0) {
	addWarning("Unspecified Sort Attributes")
}