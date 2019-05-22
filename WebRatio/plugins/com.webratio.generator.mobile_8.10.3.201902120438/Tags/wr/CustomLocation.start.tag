#?delimiters [%, %], [%=, %]
$$ setJavaOutput() $$
[%

/* Find the effective custom location that matches the name */
def customLocation$$= _wr_tag_index $$ = null
for (panel$$= _wr_tag_index $$ in ([] + getEffectiveToolbars(screen) + [screen])) {
	def tempLocation = panel$$= _wr_tag_index $$.selectSingleNode("layout:CustomLocation[@name = '$$= tag["name"] $$']")
	if (tempLocation && (customLocation$$= _wr_tag_index $$ == null || tempLocation["customizeContent"] == "true")) {
		customLocation$$= _wr_tag_index $$ = tempLocation
	}
}

if (customLocation$$= _wr_tag_index $$) {
	printRaw(executeContextTemplate("MVC/LayoutElement.template", [\
		"_elem": customLocation$$= _wr_tag_index $$.selectSingleNode(".//layout:Cell"), \
		"_layoutTagAttributes": [:]
	]))
} %]