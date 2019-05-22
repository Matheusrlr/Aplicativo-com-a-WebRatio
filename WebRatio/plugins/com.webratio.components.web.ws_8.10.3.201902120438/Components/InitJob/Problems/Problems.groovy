def name = component["name"] ? component["name"] : component["id"]

if (component.element("SuccessFlow") == null) {
    addError("No success flow is specified for the component '" + name + "'")
}