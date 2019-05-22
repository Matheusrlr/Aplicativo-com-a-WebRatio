#?delimiters [%, %], [%=, %]
[%
if (templateType == "component") {
	printRaw(executeContextTemplate("MVC/Frame.template", ["element": component, "frameMode": "end"]))
} else if (templateType == "cell") {
	printRaw(executeContextTemplate("MVC/Frame.template", ["element": cell, "frameMode": "end"]))
}
%]