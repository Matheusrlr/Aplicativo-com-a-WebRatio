def notificationName = event.attributeValue("name")

/* The name of a Notification Event must not be empty */
if (!notificationName) {
	addError("Unspecified name")
}

/* Notification Events cannot have the same name */
def uniqueNames = [] as Set
for (otherEvent in getAllFloatingEvents().findAll { it != event && it.name == event.name }) {
	uniqueNames.add(otherEvent.attributeValue("name"))
}
if (uniqueNames.contains(notificationName)) {
	addError("Duplicated notification event name")
}

/* Parameters under the same Notification Event must have different names */
def uniqueParamNames = [] as Set
for (param in event.elements("NotificationEventParameter")) {
	def paramName = param.attributeValue("name")
	if (!uniqueParamNames.add(paramName)) {
		addError("Duplicated parameter name '${paramName}'")
	}
}