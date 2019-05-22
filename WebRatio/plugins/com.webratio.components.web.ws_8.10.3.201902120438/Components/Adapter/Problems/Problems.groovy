import org.apache.commons.lang.StringUtils

def name = component["name"] ? component["name"] : component["id"]
def dClassId = component["id"]
def xslFile = component["xslFile"]

if (xslFile == "") {
    addError("The transformation file is unspecified for the adapter '" + name + "'")
} else {
	def xslIOFile = getContentFileOptional(xslFile)
    if (xslIOFile == null) {
        addError("The transformation file '" + xslFile + "' for the component '" + name + "' does not exist.")
        return
    }
}

def inputParameterName = dClassId + ".inputDocument"
def inputParams = getInputParameters(component)?.findAll{it["type"] == ""}


for (input in inputParams) {
    def inputName = input["name"]
    if (inputName.startsWith(inputParameterName)) {
        addError("Invalid transformation parameter '" + (inputName - dClassId - ".") + "' for the adapter '" + name + "': names must not start with 'inputDocument'")
    }
}
