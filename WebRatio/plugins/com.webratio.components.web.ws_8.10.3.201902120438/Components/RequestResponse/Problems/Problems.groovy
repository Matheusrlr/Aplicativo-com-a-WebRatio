import org.apache.commons.lang.StringUtils
import org.apache.commons.lang.exception.ExceptionUtils

def name = component["name"] ? component["name"] : component["id"]

def oneWay = component["oneWay"] == "true"
def unitId = component["id"]
def isOneWay = component["oneWay"] == "true"
def webServiceProvider = component["webServiceProvider"]
def webServiceOperation = component["webServiceOperation"]
def inputParams = null

try{
  inputParams = getInputParameters(component)?.findAll{it["type"] == ""}
}catch(Exception e){
  if(!StringUtils.isBlank(webServiceOperation)){
    def detail = null
    executeQuietly{
	    for(e2 in ExceptionUtils.getThrowables(e)){
	       if(e2 instanceof java.io.IOException){
	          detail = e2.message
	          break
	       }
	    }
    }
    if(detail != null){
       addError("Unable to locate web service operation '" + webServiceOperation + "' for the component '" + name + "'  (" + detail + ")")
    }else{
       addError("Unable to locate web service operation '" + webServiceOperation + "' for the component '" + name + "'")
    }
  }
}

if (StringUtils.isBlank(webServiceOperation)) {
	
	if (component["webServiceProvider"] == "" && (component["endpointURL"] == "")) {
		def incomingFlows = getEnteringFlows(component)
	    def providedParameters = new HashSet()
	    for (flow in incomingFlows) {
    		flow.selectNodes("ParameterBinding").each {providedParameters.add((it["target"] - (component["id"] + ".")))}	
	    }
	    if(!providedParameters.contains("endpointURL")){
	    	addError("The endpoint URL is unspecified for the component '" + name + "'")
	    }   
	}
	
	if ((component["inputType"] == "none") && (component["methodName"] == "")) {
		addError("The method name is unspecified for the component '" + name + "'")
	}
}

if (component["inputType"] == "document") {
	def reservedName = unitId + ".inputDocument"
	if(inputParams != null){
		for (input in inputParams) {
		    def paramName = input["name"]
		    if (paramName.startsWith(reservedName)) {
		        addError("Invalid transformation parameter '" + (paramName - unitId - ".") + "' for the component '" + name + "': names must not start with 'inputDocument'")
		    }
		}
	}
    def inputFileValue = component["inputXSLFile"]
    if (inputFileValue != "") {
	    def inputFile = getContentFileOptional(inputFileValue)
	    if (inputFile == null || !inputFile.isFile()) {
		    addError("The input transformation file '" + inputFileValue + "' for the component '" + name + "' does not exist.")
	    }
    }
}

if (!isOneWay){
	def outputFileValue = component["outputXSLFile"]
	if (outputFileValue != "") {
		def outputFile = getContentFileOptional(outputFileValue)
		if (outputFile == null || !outputFile.isFile()) {
		    addError("The output transformation file '" + outputFileValue + "' for the component '" + name + "' does not exist.")
		}
	}
}