def dClassBased = component["classBased"] == "true"
def componentName = component["name"] ? component["name"] : component["id"]

if (dClassBased) {
    
    def dClassId = component["dataBinding"]
    
    if (dClassId == "") {
    	addError("Unspecified Event Class")
    	return
    } 
    
  	def dClass = getById(dClassId)
    if (dClass["duration"] == "volatile") {
		addError("Invalid reference to volatile Class " + dClass["name"])
	}
   
    def dateAttrId = component["dateAttribute"]
    if (dateAttrId == "") {
    	addError("Unspecified date attribute")
    }
   	
   	if (component.selectNodes("SortAttribute").size() == 0) {
   		addWarning("Unspecified sorting attributes")
   	}
}