def name = component["name"] ? component["name"] : component["id"]
def dClassId = component["dataBinding"]

if (dClassId == "") {
    addError("The class for the component " + name + " is unspecified.")
} 