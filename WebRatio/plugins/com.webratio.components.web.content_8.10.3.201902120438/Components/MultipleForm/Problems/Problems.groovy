import org.apache.commons.lang.StringUtils

def fields = component.elements("Field")
def links = getExitingFlows(component, FlowType.NAVIGATION)
def selFields = component.elements("SelectionField")
def multiSelFields = component.elements("MultiSelectionField")
def componentName = component["name"] ? component["name"] : component["id"]

if (links.empty && fields.empty && selFields.empty && multiSelFields.empty) {
    addWarning("Unspecified Fields or Flows")
}