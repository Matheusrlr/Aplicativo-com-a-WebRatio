def name = component["name"] ? component["name"] : component["id"]

import org.apache.commons.lang.StringUtils
import com.webratio.generator.helpers.SpecialUtils

/*
 * test script file and retrieve headers
 */
def inputsHeaders = []
def outputsHeaders = []
def scriptValue = component["script"]
if (scriptValue != "") {
  def scriptFile = getContentFileOptional(scriptValue)
  if (scriptFile == null) {
      // file does not exit
    addError("The script file '" + scriptValue + "' for the component '" + name + "' does not exist.")
  } else {
      // file exists => retrieve headers
      inputsHeaders += SpecialUtils.getScriptInputs(scriptFile)
      outputsHeaders += SpecialUtils.getScriptOutputs(scriptFile)
    }
} else {
    // retrieve headers from ScriptText
    def scriptText = component.valueOf("ScriptText")
    inputsHeaders += SpecialUtils.getScriptInputs(scriptText)
    outputsHeaders += SpecialUtils.getScriptOutputs(scriptText)
}


/*
 * inputs
 */
def usedScriptInputElements = []; 
def scriptInputElements = component.selectNodes("ScriptInput"); 
if (!scriptInputElements.isEmpty()) {
	if (!inputsHeaders.isEmpty()) {
	
		/*
		 * hidden elements
		 */
		// TODO old key: "HIDDEN_SCRIPT_INPUTS"
	    def fix = createMoveScriptSubElementsFix("Move Input elements to the script", null, true)
    	addWarning("Hidden Input elements by the script of the component '" + name + "'", fix)
    	
	} else {
		/* compute incomingCoupling_Target */
		def incomingCoupling_Target = new HashSet();
		for(link in getEnteringFlows(component)) {
			for(parameterBinding in link.selectNodes("ParameterBinding")) {
				incomingCoupling_Target.add(parameterBinding["target"]);
			}
		}
		/* process sub elements */
		for(child in scriptInputElements) {
			if (!incomingCoupling_Target.contains(child["id"])) {
				/*
				 * never used + QF
				 */
				// TODO old key: USELESS_SCRIPT_INPUT
				def childName = child["name"] ? child["name"] : child["id"]
				def fix = createRemoveElementFix("Remove unused Input")
		        addWarning(child, "The Input '" + childName + "' is not provided to the component '" + name + "'", fix)
			} else {
				usedScriptInputElements.add(child); //save used one
			}
		}
	}
}
 
if (!usedScriptInputElements.isEmpty()) {

	/*
	 * deprecated sub element + QF
	 */
	// TODO old key: DEPRECATED_SCRIPT_INPUT
	def fix = createMoveScriptSubElementsFix("Move Input elements to the script", null , true)
    addWarning("The Input elements of Script '" + name + "' are deprecated.", fix)
}



/*
 * outputs
 */
def usedScriptOutputElements = [];
def scriptOutputElements = component.selectNodes("ScriptOutput");
if (!scriptOutputElements.isEmpty()) {
	if (!outputsHeaders.isEmpty()) {
	
		/*
		 * hidden elements
		 */
		// TODO old key: HIDDEN_SCRIPT_OUTPUTS
		def fix = createMoveScriptSubElementsFix("Move Output elements to the script", null, false)
    	addWarning("Hidden Output elements by the script of the component '" + name + "'", fix)
    	
	} else {
		
		/* compute outgoingCoupling_Source */
		def outgoingCoupling_Source = new HashSet();
		for(link in getExitingFlows(component)) {
			for(parameterBinding in link.selectNodes("ParameterBinding")) {
				outgoingCoupling_Source.add(parameterBinding["source"]);
			}
		}
		
		/* process sub elements */
		for(child in scriptOutputElements) {
			if (!outgoingCoupling_Source.contains("result("+child["name"]+")")) {
				/*
				 * never used + QF
				 */
				// TODO old key: USELESS_SCRIPT_OUTPUT
				def childName = child["name"] ? child["name"] : child["id"]
				def fix = createRemoveElementFix("Remove unused Output")
		        addWarning(child, "The Output '" + childName + "' is not provided to the component '" + name + "'", fix)
			} else {
				usedScriptOutputElements.add(child); //save used one
			}
		}
	}
}
if (!usedScriptOutputElements.isEmpty()) {

	/*
	 * deprecated sub element + QF
	 */
	// TODO old key: DEPRECATED_SCRIPT_OUTPUT
	def fix = createMoveScriptSubElementsFix("Move Output elements to the script", null , false)
    addWarning("The Output elements of Script '" + name + "' are deprecated.", fix)
}
