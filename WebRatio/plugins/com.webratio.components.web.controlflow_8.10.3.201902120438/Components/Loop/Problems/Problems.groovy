import org.apache.commons.lang.math.NumberUtils

def componentName = component["name"] ? component["name"] : component["id"]
def successFlows = getExitingFlows(component, FlowType.SUCCESS)
def nextFlowsSize = successFlows.findAll{it["code"] == "next"}.size()
def endFlowsSize = successFlows.findAll{it["code"] == "end"}.size()
def invalidCodeFlows = successFlows.findAll{it["code"] != "end" && it["code"] != "next" && it["code"] != "break"}

if (nextFlowsSize == 0) {
    addError("An outgoing success flow with code 'next' is mandatory for the component '" + componentName + "'")
}

if (endFlowsSize == 0) {
    addError("An outgoing success flow with code 'end' is mandatory for the component '" + componentName + "'")
}

for (flow in invalidCodeFlows) {
	def flowName = flow["name"] ? flow["name"] : flow["id"]
    addError("The success flow '" + flowName + "' requires either 'next', 'end' or 'break' as flow's code")
}

def maxSize = component["iterationSize"]
if ((maxSize != "") && NumberUtils.toInt(maxSize, -1) <= 0) {
    addError("The maximum iteration size for the component '" + componentName + "' is invalid")
}

def inputs = new HashSet()
def incomingFlows = getEnteringFlows(component)
for (incomingFlow in incomingFlows) {
	getParameterBindingInfos(incomingFlow).each{inputs.add(it.targetParam)}
}

if(!inputs.contains(component["id"] + ".array") && !inputs.contains(component["id"] + ".iterationCount")){
    addError("At least the 'Input Array' or 'Iteration Count' input parameter must be defined for the component '" + componentName + " '")
}