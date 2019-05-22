def endpointURL = component["endpointURL"]
def requestMethod = component["requestMethod"]

if (endpointURL == "") {
	addError("Unspecified Endpoint URL")
}

if ((component["requestMethod"] == "PUT" || component["requestMethod"] == "POST") && component["requestContentType"] == "") {
	addError("Unspecified Request Content Type")
}