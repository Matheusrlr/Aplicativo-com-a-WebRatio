def componentName = component["name"] ? component["name"] : component["id"]

def bindings = [:]

for (flow in getEnteringFlows(component)) {
	for (binding in flow.elements("ParameterBinding")) {
		bindings.put(binding["target"], flow)
	}
}

def latFlow = bindings["latitudes"]
def lgtFlow = bindings["longitudes"]
def adrFlow = bindings["addresses"]
def snippetFlow  = bindings["snippets"]
def titleFlow    = bindings["titles"]
def htmlFlow     = bindings["htmlContents"]

if (component["mapsProvider"] == "") {
	addError("Unspecified maps provider")
}

if ((adrFlow != null) && ((adrFlow == latFlow) || (adrFlow == lgtFlow))) {
	addError("Both addresses and latitudes/longitudes specified")
}

if (adrFlow == null) {
	if ((latFlow == null) && (lgtFlow == null)) {
		addWarning("No addresses or latitudes/longitudes specified")
	}
	if ((latFlow != null) && (lgtFlow == null)) {
		addError("Only latitudes specified")
	}
	if ((latFlow == null) && (lgtFlow != null)) {
		addError("Only longitudes specified")
	}
}

if (htmlFlow != null && ((snippetFlow != null) || (titleFlow != null))) {
	addWarning("'HTML contents' will be ignored because 'Snippets' and/or 'Titles' is specified")
}