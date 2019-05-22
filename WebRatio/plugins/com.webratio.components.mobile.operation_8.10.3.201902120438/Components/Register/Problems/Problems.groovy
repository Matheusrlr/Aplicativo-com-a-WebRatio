def dclass = getById("MUser")
if (!dclass["serverClass"]) {
    addError("The Register operation requires that the " + dclass["name"] + " class is mapped on a DataService project class")
}