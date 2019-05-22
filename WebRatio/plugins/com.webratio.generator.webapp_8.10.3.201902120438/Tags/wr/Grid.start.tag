#?delimiters [%, %], [%=, %]
[%
	printRaw(executeContextTemplate("MVC/LayoutElement.template", [\
		"_elem": page?.selectSingleNode("layout:Grid"), \
		"_layoutTagAttributes": [:] \
	]))
%]