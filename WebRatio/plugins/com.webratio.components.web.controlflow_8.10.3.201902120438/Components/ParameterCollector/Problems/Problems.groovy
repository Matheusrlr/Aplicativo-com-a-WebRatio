def names = new HashSet()
def rootId = component.valueOf("ancestor::*[parent::WebModel]/@id");

def getMissingInputParams =  { component ->
    def mandatoryInputs = [:]
    getInputParameters(component).each{mandatoryInputs.put(it["name"], it.attributeValue("label", it["name"]))}
    if (mandatoryInputs.empty) {
        return []
    }
    for (link in getEnteringFlows(component)) {
        if (link["automaticCoupling"] == "true") {
            getAutomaticParameterBindings(link).each{mandatoryInputs.remove(it.target)}
        } else {
            link.selectNodes("ParameterBinding").each{mandatoryInputs.remove(it["target"])}
        }
        if (mandatoryInputs.empty) {
            return []
        }
    }
    def mandatoryInputNames = []
    mandatoryInputNames.addAll(mandatoryInputs.keySet())
    mandatoryInputNames.sort()
    return mandatoryInputNames
}

def getMissingOutputParams = { component ->
    def mandatoryOutputs = [:]
    getOutputParameters(component).each{mandatoryOutputs.put(it["name"], it.attributeValue("label", it["name"]))}
    if (mandatoryOutputs.empty) {
        return []
    }
    for (link in getExitingFlows(component)) {
        if (link["automaticCoupling"] == "true") {
            getAutomaticParameterBindings(link).each{mandatoryOutputs.remove(it.source)}
        } else {
            link.selectNodes("ParameterBinding").each{mandatoryOutputs.remove(it["source"])}
        }
        if (mandatoryOutputs.empty) {
            return []
        }
    }
    def mandatoryOutputNames = []
    mandatoryOutputNames.addAll(mandatoryOutputs.keySet())
    mandatoryOutputNames.sort()
    return mandatoryOutputNames
}

for (parameter in component.selectNodes("CollectorParameter")) {
	if(names.contains(parameter["name"])){
		addWarning("The collector parameter '" + parameter["name"] + "' is duplicated")
   	}
   	names.add(parameter["name"])
}

def missingInputParams = getMissingInputParams(component);
def missingOutputParams = getMissingOutputParams(component);

for (paramId in missingInputParams) { 
	def paramName = getByIdOptional(paramId)["name"]
	if (missingOutputParams.contains(paramId)) {
		def fix = createRemoveElementFix("Remove the useless collector parameter '" + paramName + "'")
		addWarning(getByIdOptional(paramId), "The collector parameter '" + paramName + "' is not provided to the component '" + component["name"] + "'", fix)
  	 }
  } 