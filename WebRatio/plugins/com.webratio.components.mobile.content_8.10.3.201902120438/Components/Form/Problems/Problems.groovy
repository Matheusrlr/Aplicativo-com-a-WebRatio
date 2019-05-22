def componentName = component["name"] ? component["name"] : component["id"]
def fields = component.elements("Field")
def links = getExitingFlows(component, FlowType.NAVIGATION)
def selFields = component.elements("SelectionField")
def multiSelFields = component.elements("MultiSelectionField")

if (links.empty && fields.empty && selFields.empty && multiSelFields.empty) {
	addWarning("Unspecified fields or flows")
}