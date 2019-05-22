import org.apache.commons.lang.StringUtils

def name = component["name"] ? component["name"] : component["id"]

def serverId = component["smtpServer"]
def noSmtpServerSpecified = serverId == ""
if (noSmtpServerSpecified) {
	def mandatoryParameters = ["username", "password", "protocol", "host", "port"]
	def incomingLinks = getEnteringFlows(component)
	def providedParameters = [] as Set
	component.selectNodes("Property").each {
		providedParameters.add(it["name"])
	}
	for (link in incomingLinks) {
    	link.selectNodes("ParameterBinding").each {
    		providedParameters.add((it["target"] - (component["id"] + ".")))
    	}	
	}
	for(parameter in mandatoryParameters) {
		if(!providedParameters.contains(parameter)) {
			addError("The mandatory parameter " + parameter + " for the component " + name + " is not provided.")
		}
	}
} 

def PREDEFINED_INPUTS = ["FROM", "TO", "CC", "BCC", "SUBJECT", "BODY"]
def placeHolders = component.selectNodes("Placeholder")
def template = component.attributeValue("template")
def subjectTemplate = component.valueOf("SubjectTemplate")
def subject = subjectTemplate != "" ? "_" + subjectTemplate : ""
def templateFile = null
if (template != null && template != "") {
	templateFile = getContentFileOptional(template)
	if (templateFile == null) {
		addError("Missing template '" + template + "'")
	}
}

def templateTxt = null
if (templateFile != null) {
	try {
		templateTxt = templateFile.getText()
	} catch (Throwable e) {
        // ignore any exception
    }
}
if (StringUtils.isBlank(templateTxt)) {
  	templateTxt = component.valueOf("BodyTemplate");
}

Set tokens = new HashSet()
Set allTokens = new HashSet()
def names = placeHolders.collect{it["name"]}
def templateString = "_" + StringUtils.replace(templateTxt, "\$\$\$\$", "\$\$_\$\$") + subject
holders = StringUtils.splitByWholeSeparator(templateString, "\$\$")
for (i in 0..holders.size() - 1) {
  if (i % 2 != 0) {
	  tokens.add(holders[i])
	  allTokens.add(holders[i])
  }
}
// add warning for colliding placeholder names
for (token in allTokens.findAll{PREDEFINED_INPUTS.contains(it.toUpperCase())}) { 
   addError("The placeholder '" + token + "' for the component '" + name + "' conflicts with the name of a predefined input.")
}

if(!names.isEmpty()){
	for (token in names.findAll{PREDEFINED_INPUTS.contains(it.toUpperCase())}) { 
	   addError("The placeholder '" + token + "' for the component '" + name + "' conflicts with the name of a predefined input.")
	}
	// add warning for each undeclared placeholder
	tokens.removeAll(names)
	for (token in tokens) { 
	   addWarning("The placeholder '" + token + "' for the component '" + name + "' is unspecified.")
	}
	// add warning for each useless placeholder
	names.removeAll(allTokens)
	for (token in names) { 
	  addWarning("The placeholder '" + token + "' for the component '" + name + "' is declared but never used.")
	}		
}