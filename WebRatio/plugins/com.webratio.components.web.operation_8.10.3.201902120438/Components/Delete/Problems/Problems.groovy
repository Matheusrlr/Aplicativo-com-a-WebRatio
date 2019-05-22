def dClassId = component["dataBinding"]
def componentName = component["name"] ? component["name"] : component["id"]

if (dClassId == "") {
	addError("The class for the operation '" + componentName + "'is unspecified") 
}

def selector = component.element("ConditionalExpression")
if ((selector == null) || (selector.selectSingleNode("KeyCondition | AttributesCondition | AssociationRoleCondition") == null)) {
    addError("The delete operation '" + componentName + "' requires at least one Conditional Expression")
}

def dClass = getByIdOptional(dClassId) 

if (dClass != null) {
    def outgoingRoles = getOutgoingRoles(dClass)
    for (cascade in component.selectNodes(".//CascadeDeleteRole")) {
        def roleId = cascade["role"]
        if (roleId == "") {
            addError("The association role for the element '" + cascade["name"] + "' is unspecified")
        } else if(cascade.parent.name == "CascadeDeleteRole") {
        	if (getByIdOptional(roleId) == null) {
        		addError("The association role for the element '" + cascade["name"] + "' is invalid")
        	} else {
        		def parentOutGoingRoles =  getOutgoingRoles(getTargetDomainClass(getByIdOptional(cascade.parent["role"])))
        		if (!parentOutGoingRoles.contains(getByIdOptional(roleId))) {
            		addError("The association role '" + getById(roleId)["name"] + "' for the element '" + cascade["name"] + "' is invalid")
            	}
        	}  
        } else if (!outgoingRoles.contains(getById(roleId))) {
        	addError("The association role '" + getById(roleId)["name"] + "' for the element '" + cascade["name"] + "' is invalid")
        }
    }
}