if (element.parent.parent.name != "Attribute") {
	def field = element.parent.parent
	if (getLayoutElements(field).isEmpty()) {
		addError(element, "Mandatory field never shown in the layout")
	}
}