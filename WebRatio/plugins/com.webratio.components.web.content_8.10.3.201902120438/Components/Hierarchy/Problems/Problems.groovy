def dClassId = component["dataBinding"]
def componentName = component["name"] ? component["name"] : component["id"]

if (dClassId == "") {
	addError("Unspecified Data Binding")
} else {
	if (component["displayAttributes"] == "") {
		addWarning("Unspecified display attributes")
		if (component["distinct"] == "true") {
			addError("Unspecified display attributes with 'distinct' property enabled")
		}
	}
			
	if (component.selectNodes("SortAttribute").size() == 0) {
		addWarning("Unspecified sorting attributes")
	}
}

def levels = component.selectNodes(".//HierarchyLevel");

for (level in levels) {
	
	def levelName = level["name"] ? level["name"] : level["id"]
	
	if (level["dataBinding"] == "") {
		addError(level, "Unspecified Level Data Binding")
	} else if (level.selectNodes("SortAttribute").size() == 0) {
		addWarning(level, "Unspecified Level sorting attributes")
	}
	
	if (level["role"] == "") {
		addError(level, "Unspecified Level Association Role")
	}
	
	def orderIdsLevel = level["levelOrder"]
	def validIdsLevel = new HashSet(level.selectNodes("HierarchyLevel")?.collect{it["id"]})    
	def invalidOrderIdsLevel = orderIdsLevel.tokenize(" ").findAll{!validIdsLevel.contains(it)}
	if (!invalidOrderIdsLevel.empty) {   
	   	def fix = createRemoveInvalidReferenceTokens("Remove the invalid references '" + invalidOrderIdsLevel.join(" ") + "'.", "levelOrder")
		addError(level, "Invalid levels " + invalidOrderIdsLevel.join(" ") + " specified in level order", fix)
	}
}

def orderIds = component["levelOrder"]
def validIds = new HashSet(component.selectNodes("HierarchyLevel")?.collect{it["id"]})    
def invalidOrderIds = orderIds.tokenize(" ").findAll{!validIds.contains(it)}
if (!invalidOrderIds.empty) {   
   	def fix = createRemoveInvalidReferenceTokens("Remove the invalid references '" + invalidOrderIds.join(" ") + "'.", "levelOrder")
	addError("Invalid levels " + invalidOrderIds.join(" ") + " specified in level order", fix)
}   	  