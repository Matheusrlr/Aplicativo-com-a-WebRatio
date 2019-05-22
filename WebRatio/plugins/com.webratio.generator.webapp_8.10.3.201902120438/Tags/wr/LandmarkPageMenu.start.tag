$$
import org.apache.commons.lang.StringUtils
setJavaOutput()

def names = new HashSet(["wr:LandmarkOperationMenu", "wr:LandmarkPageMenu", "wr:LandmarkAreaMenu", 
		"wr:LandmarkMenu", "wr:LandmarkAreaLink", "wr:LandmarkPageLink", "wr:LandmarkOperationLink", 
		"wr:LandmarkEvent", "wr:PageEvents", "wr:Iterate"])
def loopTags = ancestorTags.findAll{names.contains(it.name)}    
def size = loopTags.size()
def var = StringUtils.defaultIfEmpty(tag["var"], "_wr_var" + size)
def ancestor = "null"
if (size > 0) {
    ancestor = loopTags[0].attributes.var
    if (StringUtils.isEmpty(ancestor)) {
        ancestor = "_wr_var" + (size - 1)
    }
}
def nested = (ancestor != "null")
def level = 1
if (tag["level"]) {
	if (!nested) {
		level = tag["level"]
	} else {
		tagProblems.addWarning("Level has no effect when nesting inside another landmark menu.")
	}
}
def varIndex = StringUtils.defaultIfEmpty(tag["varIndex"], null)
def varCount = StringUtils.defaultIfEmpty(tag["varCount"], null)
def checkElem = "page"
if (nested && (ancestorTags[0].name != "wr:Current") && (ancestorTags[0].name != "wr:NonCurrent")) {
    checkElem = ancestor
}
$$
<% if (isSourceLandmark(page, $$= checkElem $$)) {
	def _wr_landmarks$$= _wr_tag_index $$ = safeSubList($$if (nested) { $$getChildLandmarks($$= ancestor $$, LandmarkType.PAGE)$$ } else { $$getAvailableLandmarks(page, $$= level $$, LandmarkType.PAGE)$$ } $$, "$$=tag.range$$")
	for ($$=var$$ in _wr_landmarks$$= _wr_tag_index $$) {
	$$ if (varIndex != null) { $$def $$= varIndex $$ = _wr_landmarks$$= _wr_tag_index $$.indexOf($$= var $$)$$ } $$
	$$ if (varCount != null) { $$def $$= varCount $$ = _wr_landmarks$$= _wr_tag_index $$.size()$$ } $$
%>