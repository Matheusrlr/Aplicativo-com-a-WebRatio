import org.apache.commons.lang.math.NumberUtils

def name = element["name"] ? element["name"] : element["id"]
if (element.parent.parent["type"] != "password") {
    addError("The validation rule 'name' must be applied on a password attribute")
} else if (element["securityLevel"] == "low") {
    addWarning("The 'Low' level of the validation rule 'name' is weak")
} else if (element["securityLevel"] == "custom") {
	int minLength = NumberUtils.toInt(element["minLength"])  
	int maxLength = NumberUtils.toInt(element["maxLength"])
	if (element["minLength"] == "") {
	    addError("The 'Custom' level of the validation rule 'name' requires to set a 'Min Length'")
	} else if (element["minLength"] != Integer.toString(minLength)) {
		addError("The 'Min Length' of the validation rule 'name' must be a number")
	}
	if (element["maxLength"] == "") {
	    addError("The 'Custom' level of the validation rule 'name' requires to set a 'Max Length'")
	} else if (element["maxLength"] != Integer.toString(maxLength)) {
		addError("The 'Max Length' of the validation rule 'name' must be a number")
	}
	if(maxLength < minLength){
		addError("The 'Max Length' of the validation rule 'name' must be greater then the 'Min Length'")
	}
	if(element["useNumbers"] == "" && element["useLowerCaseCharacters"] == "" && element["useUpperCaseCharacter"] == "" && element["useSpecialCharacters"] == "") {
		addError("The 'Custom' level of the validation rule 'name' requires to set at least one security criteria")
	}
}
