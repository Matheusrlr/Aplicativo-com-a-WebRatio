def dClassId = component["dataBinding"]

if (dClassId == "") {
	addError("Unspecified Data Binding") 
}

def selector = component.element("ConditionalExpression")
if ((selector == null) || (selector.selectSingleNode("KeyCondition | AttributesCondition | AssociationRoleCondition") == null)) {
    addError("Unspecified conditional expression")
}