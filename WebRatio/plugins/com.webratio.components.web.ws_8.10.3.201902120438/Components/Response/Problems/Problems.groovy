def componentName = component["name"] ? component["name"] : component["id"]

def port = component.selectSingleNode("ancestor::ServicePort")

def serviceView = component.selectSingleNode("ancestor::ServiceView")

if (serviceView != null) {
	def solicits = serviceView.selectNodes(".//Solicit")
    def normalizedUnitName = com.webratio.generator.helpers.XMLUtils.normalizeTagName(componentName)
	for (solicit in solicits) {
  
		if (solicit["invocationStyle"] == "REST") {
        	continue
       	}
       	def reachableUnits = getReachableComponents(solicit)
       	
       	if (reachableUnits != null && reachableUnits.contains(component)) {
       	  
        	def expName = com.webratio.generator.helpers.XMLUtils.normalizeTagName(solicit["name"] + "Response")
         		
         	if (!normalizedUnitName.equals(expName)) {
       			def fix = createChangeAttributeFix("Change the response component name to '" + expName + "'", "name", expName)
				addWarning("To be WS-I compliant the response component named '" + componentName+ "' should be renamed to '" + expName + "'", fix)
       		}
    	}
	}
}

def paramsToCheck = []
paramsToCheck.addAll(component.selectNodes("ResponseBodyParameter"))
paramsToCheck.addAll(component.selectNodes(".//ComplexParameterFragment"))
paramsToCheck.addAll(component.selectNodes(".//SimpleParameterFragment"))

for (param in paramsToCheck) {
	def paramName = param["name"]
	msgName = paramName ? paramName : param["id"]	
	if (paramName == "" || paramName.indexOf(" ") != -1) {
    	addError("The name of the element '" + msgName + "' is not a valid XML tag name")
	}
	
	def xsdProvider = param["xsdProvider"]
    if (xsdProvider != "") {
    	if (param["xsdType"] == "") {
        	addError("The XSD Type/Element of the sub element '" + msgName + "' is not specified")
       	}    
       	if (param.selectSingleNode("ComplexParameterFragment|SimpleParameterFragment") != null) {
        	addError("The parameter '" + msgName + "' sub-fragments cannot be declared if an XSD provider and type/element are specified") 
       	}  
	}  
}