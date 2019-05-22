def svId = component["siteView"]
def sv = getById(svId)
def name = component["name"] ? component["name"] : component["id"]

if (sv["protected"] == "true") {
        addError("The target site view " + sv["name"] + " of the component " + name + " is protected")
}

if (component.selectSingleNode("ancestor::ServiceView") != null) {
	def job = component.selectSingleNode("ancestor::Job")
	if (job == null) {
		/* WARNING#CM354 */
		addError("The session-aware component " + name + " is not valid in a session-unaware context.")
	} else {
		if (!isSessionEnabledJob(job)) {
			/* WARNING#CM355 */
			addError("The session-aware component " + name + " is not valid in a session-unaware context.");
		}
	}
}