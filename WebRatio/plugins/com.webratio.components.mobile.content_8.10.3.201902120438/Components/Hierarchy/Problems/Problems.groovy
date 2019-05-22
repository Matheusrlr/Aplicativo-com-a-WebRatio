def dClassId = component["dataBinding"]

if (dClassId == "") {
	addError("Unspecified Data Binding")
} else {
	if (component["displayAttributes"] == "") {
		addWarning("Unspecified Display Attributes")
	}
}

def levels = component.selectNodes(".//HierarchyLevel");

for (level in levels) {
	
	def levelName = level["name"] ? level["name"] : level["id"]
	
	if (level["dataBinding"] == "") {
		addError(level, "Unspecified level Data Binding")
	} else { 
		if (level["displayAttributes"] == "") {
			addWarning(level, "Unspecified level Display Attributes")
		}
		if (level.selectNodes("SortAttribute").size() == 0) {
			addWarning("Unspecified level Sort Attributes")
		}	
		if (level["role"] == "") {
			addError(level, "Unspecified level Association Role")
		}
	}
	
	def orderIdsLevel = level["levelOrder"]
	def validIdsLevel = new HashSet(level.selectNodes("HierarchyLevel")?.collect{it["id"]})    
	def invalidOrderIdsLevel = orderIdsLevel.tokenize(" ").findAll{!validIdsLevel.contains(it)}
	if (!invalidOrderIdsLevel.empty) {   
	   	def fix = createRemoveInvalidReferenceTokens("Remove the invalid references '" + invalidOrderIdsLevel.join(" ") + "'.", "levelOrder")
		addError(level, "Invalid levels specified in level Level Order", fix)
	}
}

def orderIds = component["levelOrder"]
def validIds = new HashSet(component.selectNodes("HierarchyLevel")?.collect{it["id"]})    
def invalidOrderIds = orderIds.tokenize(" ").findAll{!validIds.contains(it)}
if (!invalidOrderIds.empty) {   
   	def fix = createRemoveInvalidReferenceTokens("Remove the invalid references '" + invalidOrderIds.join(" ") + "'.", "levelOrder")
	addError("Invalid levels specified in Level Order", fix)
}  