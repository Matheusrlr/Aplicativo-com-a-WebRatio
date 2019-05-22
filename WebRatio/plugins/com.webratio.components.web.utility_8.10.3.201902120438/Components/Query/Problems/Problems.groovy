def name = component["name"] ? component["name"] : component["id"]

if(component["mode"] != "dynamic"){
	def queryFileValue = component["queryFile"]
	if(queryFileValue != ""){
	  def queryFile = getContentFileOptional(queryFileValue)
	  if (queryFile == null) {
          addError("The query file '" + queryFileValue + "' for the component '" + name + "' does not exist.")
      }
    } else if(queryFileValue == ""){
      def queryText = component.selectSingleNode("QueryText")?.getText()
      if(queryText == null || queryText == ""){
        addError("The query of the component '"+ name + "' has not been defined.") 
      }
    }
    
    for(queryInput in component.selectNodes("QueryInput")){
      def nameQueryInput = queryInput["name"]
      def normalizedNameQueryName = toValidFieldName(queryInput["name"])
      if(!nameQueryInput.equals(normalizedNameQueryName)){
      	def fix = createChangeAttributeFix("Normalize the name to " + normalizedNameQueryName, "name", normalizedNameQueryName);
        addError(queryInput, "The query input name '" + nameQueryInput + "' must be normalized to '" + normalizedNameQueryName +"'.", fix)
      }
    }
}