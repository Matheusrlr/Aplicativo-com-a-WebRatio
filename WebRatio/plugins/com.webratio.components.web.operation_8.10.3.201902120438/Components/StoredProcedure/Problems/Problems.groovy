def procedure = component["procedure"]
def db = component["db"]
def componentName = component["name"] ? component["name"] : component["id"]

if (procedure == "") {
    addError("The procedure to call is unspecified for the operation '" + componentName + "'")
}

if (db == "") {
	addError("The database for the operation '" + componentName + "' is unspecified")
}

for (param in component.elements("StoredProcedureParameter")) {
    if (param["position"] == "") {
    	def paramName = param["name"] ? param["name"] : param["id"]
        addError("The position of the stored procedure parameter '" + paramName + "' is unspecified for the component '" + componentName + "'")
    }
}