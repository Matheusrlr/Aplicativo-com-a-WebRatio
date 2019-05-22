$$ 
import org.apache.commons.lang.StringUtils

setJavaOutput() 
def context = tag["context"]
if (StringUtils.isEmpty(context)) {
    def names = new HashSet(["wr:LandmarkOperationMenu", "wr:LandmarkPageMenu", "wr:LandmarkAreaMenu", 
	        "wr:LandmarkMenu", "wr:LandmarkAreaLink", "wr:LandmarkPageLink", "wr:LandmarkOperationLink", 
	        "wr:LandmarkEvent", "wr:PageEvents", "wr:Iterate"])
    def loopTags = ancestorTags.findAll{names.contains(it.name)}
    if (loopTags.empty) {
        tagProblems.addFatalError("<wr:Visible/> must be surrounded by one of the following tags: " + names)
    }
    if (StringUtils.isEmpty(loopTags[0].attributes.var)) {
        context = "_wr_var" + (loopTags.size() - 1)
    } else {
        context = loopTags[0].attributes.var
    }
}
def position = StringUtils.defaultIfEmpty(tag["position"], null)
def selector = StringUtils.defaultIfEmpty(tag["select"], ".")

$$ <% def _elem$$=_wr_tag_index$$ = $$=context$$?.selectSingleNode("$$=selector$$") %>$$

/* Hiding of AJAX events with no presentation */
$$ <% if (!isAjaxGenericPage(page) || _elem$$=_wr_tag_index$$.name != "Event" || _elem$$=_wr_tag_index$$["event"] == null || !isClientLogicLayoutEvent(_elem$$=_wr_tag_index$$)) { %> $$

/* Target accessibility check */
$$ <% if (_elem$$=_wr_tag_index$$.valueOf("NavigationFlow/@to|@landmark") && getClosestAccessAwareElement(_elem$$=_wr_tag_index$$["landmark"] == "true" ? _elem$$=_wr_tag_index$$ : getById(_elem$$=_wr_tag_index$$.valueOf("NavigationFlow/@to")))) { %>
	<% def _visPol$$=_wr_tag_index$$ = getInaccessibleEventPolicy(_elem$$=_wr_tag_index$$)%>
	<% if (_visPol$$=_wr_tag_index$$ == "" || _visPol$$=_wr_tag_index$$ == "hide") { %>
		$$ if (StringUtils.isBlank(tag["otherwise"])) { $$
			<c:if test="${webratio:isTargetAccessible('<%= getEventRuntimeId(_elem$$=_wr_tag_index$$)%>', pageContext)}">
		$$ } else { $$
			<c:choose><c:when test="${webratio:isTargetAccessible('<%= getEventRuntimeId(_elem$$=_wr_tag_index$$)%>', pageContext)}">
		$$ } $$
	<% } %>
<% } %>
$$

/* Visibility condition check */
$$ <% def _visCond$$=_wr_tag_index$$ = getVisibilityCondition(_elem$$=_wr_tag_index$$, $$=position$$)%> $$
if(StringUtils.isBlank(tag["otherwise"])){
$$
<% if(_visCond$$=_wr_tag_index$$ != null){%>
<c:if test="${<% printJSPTagValue(_visCond$$=_wr_tag_index$$)%>}"><% } %>
$$ }else{ $$
<% if(_visCond$$=_wr_tag_index$$ != null){ %><c:choose><c:when test="${<% printJSPTagValue(_visCond$$=_wr_tag_index$$)%>}"><% } %> 
$$   
}
