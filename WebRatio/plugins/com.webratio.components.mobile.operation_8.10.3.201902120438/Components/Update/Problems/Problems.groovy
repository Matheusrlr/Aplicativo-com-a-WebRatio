def dclassId = component["dataBinding"]
def isUserDclass = (dclassId == "MUser")

if (!dclassId) {
	addError("Unspecified Data Binding")
}

def selector = component.element("ConditionalExpression")
if (!isUserDclass && (!selector || !selector.selectSingleNode("KeyCondition | AttributesCondition | AssociationRoleCondition"))) {
    addError("Unspecified conditional expression")
}

def oldPasswordBound = false
def newPasswordBound = false
for (flow in getEnteringFlows(component)) {
	for (param in getParameterBindingInfos(flow)) {
		if (param.targetParam == "oldPassword") {
			oldPasswordBound = true
		} else if (param.targetParam == "newPassword") {
			newPasswordBound = true
		}
	}
}
if (oldPasswordBound != newPasswordBound) {
	addWarning("Should provide an input for both 'Old Password' and 'New Password'")
}
