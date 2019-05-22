#?delimiters [%, %], [%=, %]
[%
if (templateType == "component") {
	printRaw(executeContextTemplate("MVC/Frame.template", ["element": component, "frameMode": "start"]))
} else if (templateType == "cell") {
	printRaw(executeContextTemplate("MVC/Frame.template", ["element": cell, "frameMode": "start"]))
}
%]