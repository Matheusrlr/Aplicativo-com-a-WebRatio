def name = component["name"] ? component["name"] : component["id"]

if ((component["sourceType"] == "static") && (component["url"] == "")) {
	addError("The static URL is unspecified for the component '" + name + "'")
}