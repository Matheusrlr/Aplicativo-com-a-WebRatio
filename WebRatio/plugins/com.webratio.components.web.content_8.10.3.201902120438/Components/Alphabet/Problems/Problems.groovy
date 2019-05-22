def dClassId = component["dataBinding"]
def attrId = component["attribute"]

if (dClassId != "") {
	def dClass = getById(dClassId)
	if (dClass["duration"] == "volatile") {
		addError("Invalid reference to volatile Class " + dClass["name"])
		return
	}
	
	if (attrId == "") {
		addError("Unspecified Attribute")
	}
}