def checkOutputParameters = {outputParameterType ->
    def outputParameterTypes = []
	def outputParameterWarnings = []
	for(outputParameter in component.selectNodes(outputParameterType)) {
		def parameterType = outputParameter["type"]
		if (outputParameterTypes.contains(parameterType) && !outputParameterWarnings.contains(parameterType)) {
			addWarning(component, "Duplicated " + outputParameterType.replaceAll("(.)(\\p{Lu})", "\$1 \$2").toLowerCase() + " type '" + parameterType.toLowerCase() + "'")
			outputParameterWarnings.add(parameterType)			
		} else if (!outputParameterTypes.contains(parameterType)) {
			outputParameterTypes.add(parameterType)
		}
	}
}

if(component["mode"] == "pick") {
	checkOutputParameters("ContactAddress")
	checkOutputParameters("ContactEmail")
	checkOutputParameters("ContactPhone")
}
