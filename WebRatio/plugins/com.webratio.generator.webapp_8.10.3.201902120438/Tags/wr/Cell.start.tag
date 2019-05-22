#?delimiters [%, %], [%=, %]
[%
	printRaw(executeContextTemplate("MVC/LayoutElement.template", [\
		"_elem": $$= tag["context"] $$, \
		"_layoutTagAttributes": [:] \
	]))
%]