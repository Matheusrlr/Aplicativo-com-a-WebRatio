$$
import org.apache.commons.lang.StringUtils
import org.apache.commons.lang.math.NumberUtils

setJavaOutput()
def select = tag["select"]
if (StringUtils.isEmpty(select)) {
    tagProblems.addFatalError("<wr:Iterate>: the select attribute is mandatory")
}
def names = new HashSet(["wr:LandmarkOperationMenu", "wr:LandmarkPageMenu", "wr:LandmarkAreaMenu", 
	    "wr:LandmarkMenu", "wr:LandmarkAreaLink", "wr:LandmarkPageLink", "wr:LandmarkOperationLink", 
	    "wr:LandmarkEvent", "wr:PageEvents", "wr:Iterate", "wr:NavigationBar"])
def loopTags = ancestorTags.findAll{names.contains(it.name)}
def var = tag["var"]
if (StringUtils.isEmpty(var)) {
    tagProblems.addFatalError("<wr:Iterate>: the var attribute is mandatory")
}
def context = tag["context"]
if (StringUtils.isEmpty(context)) {
    tagProblems.addFatalError("<wr:Iterate>: the context attribute is mandatory")
}
def varIndex = tag["varIndex"]
if (StringUtils.isEmpty(varIndex)) {
	varIndex = "index"
}

$$<% 
def _items$$=_wr_tag_index$$ = safeSubList($$=context$$.selectNodes("$$=select$$"), "$$=tag.range$$")
for ($$=var$$ in _items$$=_wr_tag_index$$) { 
def $$=varIndex$$ = _items$$=_wr_tag_index$$.indexOf($$=var$$)
%>