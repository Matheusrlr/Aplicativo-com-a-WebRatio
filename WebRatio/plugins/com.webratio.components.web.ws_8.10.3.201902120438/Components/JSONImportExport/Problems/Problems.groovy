def dClassId = component["dataBinding"]
def name = component["name"] ? component["name"] : component["id"]

if (dClassId == ""){
	addError("The class for the component '" + name + " ' is unspecified")
} 

if(component["attributes"] == ""){
	if(component["mode"] == "import"){
		addError(component, "No attributes to import have been selected for the component " + name + ".")
	}else if (component["mode"] == "export") {
	    addError(component, "No attributes to export have been selected for the component " + name + ".")
	}
}