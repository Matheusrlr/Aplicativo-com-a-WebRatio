$$
import org.apache.commons.lang.StringUtils

setJavaOutput()
def names = new HashSet(["wr:LandmarkOperationMenu", "wr:LandmarkPageMenu", "wr:LandmarkAreaMenu", 
		"wr:LandmarkMenu", "wr:LandmarkAreaLink", "wr:LandmarkPageLink", "wr:LandmarkOperationLink", 
		"wr:LandmarkEvent", "wr:PageEvents", "wr:Iterate", "wr:NavigationBar"])
def loopTags = ancestorTags.findAll{names.contains(it.name)}
def loopTagsSize = loopTags.size()
if (loopTagsSize == 0) {
    tagProblems.addFatalError("<wr:LandmarkTitle/> must be surrounded by one of the following tags: " + names)
}
def loopTagVar = loopTags[0].attributes.var 
if (!StringUtils.isEmpty(loopTagVar)) {
    context = loopTagVar
} else {
    context = "_wr_var" + (loopTagsSize - 1)
}
$$<% if (getEffectiveLocalizedElement($$= context $$)) { %>
	<spring:message code="<% printJSPTagValue(getTitle($$= context $$)) %>"/>
<% } else { %><%= getTitle($$= context $$) %><% } %>
