def dclassId = component["dataBinding"]
if (dclassId == "") {
	addError("Unspecified Data Binding")
}
def dclass = getById(dclassId)
def attrIds = component["distinctAttributes"]
if ((component["distinct"] == "true") && (dclass != null) && (attrIds == "")) {
    def name = component["name"] ? component["name"] : component["id"]
    addError("The distinct property is enabled but no attributes are specified for the component '" + name + "'")
} 

