for (classElement in component.elements("DomainModelClass")) {
	def classId = classElement["dataBinding"]
	def className = classElement["name"] ? classElement["name"] : classElement["id"]
	if (classId == "") {
		addError(classElement, "The domain-class for the component '" + className + "' is unspecified")
	}
	
	for (roleElement in classElement.elements("DomainModelRole")) {
		def roleElementName = roleElement["name"] ? roleElement["name"] : roleElement["id"] 
		def roleId = roleElement["role"]
		if (roleId == "") {
			addError(roleElement, "The association-role for the component '" + roleElementName+ "' is unspecified")
		}
		
    	def ent = getById(classId)
      	def role = getById(roleId)
		if (role != null && ent != null) {
    		def source = getSourceDomainClass(role)
        	if (!getSuperDomainClassHierarchy(ent).contains(source))  {
            	addWarning(roleElement, "Invalid association-role source class for the sub-component '" + roleElementName + "'")
        	} 
    	}
    } 
}