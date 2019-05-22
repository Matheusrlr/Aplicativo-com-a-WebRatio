import org.apache.commons.collections.bag.HashBag

def componentName = component["name"] ? component["name"] : component["id"]
def caseValues = new HashBag()
def linkCodes = new HashBag()
component.elements("Case").each{caseValues.add(it["value"])}

for (caseValue in caseValues.uniqueSet().findAll{caseValues.getCount(it) > 1}) {
    addError("Duplicated switch case '" + caseValue + "'")
}

if (caseValues.getCount("") > 1) {
    addError("Switch case/s with unspecified value found")
} 

for (succFlow in getExitingFlows(component, FlowType.SUCCESS)) {
	linkCodes.add(succFlow["code"])
}

if (linkCodes.getCount("") == 0) {
    addWarning("No default Success Flow specified")
}

for (successFlow in getExitingFlows(component, FlowType.SUCCESS)) {
    flowName = successFlow["name"] ? successFlow["name"] : successFlow["id"]
    if (successFlow["code"] != "<EMPTY>" && successFlow["code"] != "" && !caseValues.uniqueSet().contains(successFlow["code"])) {
       addError(successFlow, "Invalid flow code '" + successFlow["code"] + "'")
    }
}