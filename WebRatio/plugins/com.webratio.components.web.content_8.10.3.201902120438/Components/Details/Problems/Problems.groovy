def dClassId = component["dataBinding"]

if (dClassId == "") {
	addError("Unspecified Data Binding")
} else {
	if (component["displayAll"] != "true") {
		if (component["displayAttributes"] == "") {
			addWarning("Unspecified display attributes")
		}
	}
}