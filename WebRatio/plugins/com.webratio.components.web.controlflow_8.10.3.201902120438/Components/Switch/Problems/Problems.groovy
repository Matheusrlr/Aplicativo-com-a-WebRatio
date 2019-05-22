import org.apache.commons.collections.bag.HashBag

def componentName = component["name"] ? component["name"] : component["id"]

def caseValues = new HashBag()
component.elements("Case").each{caseValues.add(it["value"])}

for (caseValue in caseValues.uniqueSet().findAll{caseValues.getCount(it) > 1}) {
    addError("The case value '" + caseValue + "' is duplicated for the component '" + componentName + "'")
}

if (caseValues.getCount("") > 0) {
    addError("One or more cases of the component '" + componentName + "' have an unspecified value")
}

if(component["switchValues"] != "roleNames"){
	def linkCodes = new HashBag() 

	for (succFlow in getExitingFlows(component, FlowType.SUCCESS)) {
		linkCodes.add(succFlow["code"])
	}

	def caseValueSet = caseValues.uniqueSet()

	for (successFlow in getExitingFlows(component, FlowType.SUCCESS)) {
    	if ((successFlow["code"] != "") && (successFlow["code"] != "<EMPTY>") && !caseValueSet.contains(successFlow["code"])) {
       		addError("The flow '" + successFlow["name"] + "' is marked with an invalid code: " + successFlow["code"])
    	}
	}
}