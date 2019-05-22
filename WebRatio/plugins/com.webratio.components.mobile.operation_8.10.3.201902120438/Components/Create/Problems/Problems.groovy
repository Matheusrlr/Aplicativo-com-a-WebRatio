def dclassId = component["dataBinding"]
def dclass = getById(dclassId)

if (!dclassId) {
	addError("Unspecified Data Binding")
}

if (dclassId == "MUser" && dclass["serverClass"]) {
    addError("The domain-class " + dclass["name"] + " cannot be directly created, use the Register operation instead.")
}
