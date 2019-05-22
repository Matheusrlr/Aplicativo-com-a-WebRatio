def compName = component["name"] ? component["name"] : component["id"]

if (compName == "" || compName.indexOf(" ") != -1) {
	if (component["invocationStyle"] != "REST") {
	    addError("The name of the component '" + compName + "' is not a valid XML tag name")
	} else {
    	addError("The name of the component '" + compName + "' is not a valid URL name")
	}
}

def port = component.selectSingleNode("ancestor::ServicePort")
def portName = port["name"] ? port["name"] : port["id"]

if (port != null) {
	def names = port.selectNodes(".//Solicit").collect{it["name"]}.findAll{name -> name == compName}
	if (names.size() > 1) {
    	addError("The solicit component name '" + compName + "' already exists in the port '" + portName + "'")
	}
}

def paramsToCheck = []
paramsToCheck.addAll(component.selectNodes("SolicitParameter"))
if (component["invocationStyle"] != "REST") {
	paramsToCheck.addAll(component.selectNodes(".//ComplexParameterFragment"))
	paramsToCheck.addAll(component.selectNodes(".//SimpleParameterFragment"))
  	for (param in paramsToCheck) {
    	if (param["name"] == "" || param["name"].indexOf(" ") != -1) {
    		def paramName = param["name"] ? param["name"] : param ["id"]
        	addError(param, "The name of the solicit component parameter '" + paramName + "' is not a valid XML tag name")
    	}
  	}
} else {
	for (param in component.selectNodes("SolicitParameter")) {
    	def paramName = param["name"] ? param["name"] : param ["id"]
    	if (param["name"] == "" || param["name"].indexOf(" ") != -1) {
        	addError(param, "The name of the solicit component parameter '" + paramName + "' is not a valid URL parameter")
    	}
    	if (param.selectSingleNode("ComplexParameterFragment|SimpleParameterFragment") != null && (component["requestMethod"]=="GET" || component["requestMethod"]=="DELETE")) {
        	addError(param, "The solicit component parameter '" + paramName + "' has complex structure and REST invocation allows complex parameters only for POST and PUT HTTP methods")
    	}
    	if (param["xsdProvider"] != "") {
        	if(param["xsdType"].endsWith("[Element]")) {
          		addError(param, "The solicit component parameter '" + paramName + "' is mapped on element which is not supported by REST invocation")
        	} else if(param["xsdType"].endsWith("[ComplexType]")) {
          		addError(param, "The solicit component parameter '" + paramName + "' is mapped on complex type which is not supported by REST invocation")
        	}
    	}
  	}
}
for (param in paramsToCheck) {
	def paramName = param["name"] ? param["name"] : param["name"] 
	if (param["xsdProvider"] != "") {
    	if(getByIdOptional(param["xsdProvider"]) == null){
        	addError(param, "The XSD Provider of the sub element '" + paramName + "' is not valid")
       	}
       	if(param.selectSingleNode("ComplexParameterFragment|SimpleParameterFragment") != null){
        	addError(param, "The parameter '"+ paramName +"' sub-fragments cannot be declared if an XSD provider and type/element are specified") 
       	}  
	}    
}