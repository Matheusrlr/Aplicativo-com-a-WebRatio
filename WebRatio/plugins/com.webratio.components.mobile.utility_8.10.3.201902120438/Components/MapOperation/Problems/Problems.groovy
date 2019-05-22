def componentName = component["name"] ? component["name"] : component["id"]

def bindings = [:]

for (flow in getEnteringFlows(component)) {
	for (binding in flow.elements("ParameterBinding")) {
		bindings.put(binding["target"], "true")
	}
}

if (!bindings["sourceAddress"]) {
	addError("Missing source address")
}

if (!bindings["destinationAddress"]) {
	addError("Missing destination address")
}