#?delimiters [%, %], [%=, %]
$$ setJavaOutput() $$
[%
def masterPage$$= _wr_tag_index $$ = (page["ignoreMasterContainer"] == "true") ? null : getEffectiveMasterContainer(page)
def customLocation$$= _wr_tag_index $$ = null
if (masterPage$$= _wr_tag_index $$) {
	customLocation$$= _wr_tag_index $$ = masterPage$$= _wr_tag_index $$.selectSingleNode("layout:CustomLocation[@name = '$$= tag["name"] $$']")
}
if (!customLocation$$= _wr_tag_index $$) {
	customLocation$$= _wr_tag_index $$ = page.selectSingleNode("layout:CustomLocation[@name = '$$= tag["name"] $$']")
}
if (customLocation$$= _wr_tag_index $$) {
	printRaw(executeContextTemplate("MVC/LayoutElement.template", [\
		"_elem": customLocation$$= _wr_tag_index $$, \
		"_layoutTagAttributes": [:], \
		"suppressWrappers": $$= tag["usedInHead"] ?: false $$ \
	]))
} %]