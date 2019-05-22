#?delimiters [%, %], [%=, %]
[%
	printRaw(executeContextTemplate("MVC/LayoutElement.template", [\
		"_elem": screen.selectSingleNode("layout:Grid"), \
		"_layoutTagAttributes": [:] \
	]))
%]