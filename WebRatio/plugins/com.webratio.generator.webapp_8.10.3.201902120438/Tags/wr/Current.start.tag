$$
import org.apache.commons.lang.StringUtils
setJavaOutput()
def names = new HashSet(["wr:LandmarkOperationMenu", "wr:LandmarkPageMenu", "wr:LandmarkAreaMenu", 
		"wr:LandmarkMenu", "wr:LandmarkAreaLink", "wr:LandmarkPageLink", "wr:LandmarkOperationLink", 
		"wr:LandmarkEvent", "wr:PageEvents", "wr:Iterate"])
def loopTags = ancestorTags.findAll{names.contains(it.name)}
if (loopTags.empty) {
    tagProblems.addFatalError("<wr:Current/> must be surrounded by one of the following tags: " + names)
}
def var = loopTags[0].attributes.var 
if (StringUtils.isEmpty(var)) {
    var = "_wr_var" + (loopTags.size() - 1)
}
$$<% def isChainLandmark$$= _wr_tag_index $$ = (getClosestTopGenericPage($$= var $$) == null) %>
<% if (isSourceLandmark(page, $$= var $$) || isChainLandmark$$= _wr_tag_index $$) { %>
<% if (isChainLandmark$$= _wr_tag_index $$ && !isSourceLandmark(page, $$= var $$)) { %><c:if test="${webratio:getStartOperation(pageContext) eq '<%= $$= var $$["id"] %>'}"><% } %>
