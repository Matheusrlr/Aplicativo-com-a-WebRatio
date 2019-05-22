def dClassId = component["dataBinding"]
def dClass = getById(dClassId)
def parentAssociation = component["association"]
def componentName = component["name"] ? component["name"] : component["id"]

if (dClassId == "") {
	addError("Unspecified Data Binding")
} else {
	if (component["displayAttributes"] == "") {
		addWarning("Unspecified display attributes")
	}
	if (component.selectNodes("SortAttribute").size() == 0) {
		addWarning("Unspecified sorting attributes")
	}
	if(parentAssociation == "") {
		addError("Unspecified parent Association")
	} else {
		def childToParentRole = getById(parentAssociation)
		if (childToParentRole == null || (getSourceDomainClass(childToParentRole) != dClass) || (getTargetDomainClass(childToParentRole) != dClass)) {
			addWarning("Invalid parent Association")
		} else {
			def maxCard = childToParentRole["maxCard"]
 			if (maxCard != "1") {
   			addWarning("Invalid cardinality 'many' of parent Association")  
	  		}
		}
	}
}