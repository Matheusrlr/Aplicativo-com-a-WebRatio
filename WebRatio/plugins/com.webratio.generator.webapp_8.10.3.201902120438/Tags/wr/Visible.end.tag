$$ 
import org.apache.commons.lang.StringUtils

setJavaOutput() 
def otherwise = tag["otherwise"]
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
def selector = StringUtils.defaultIfEmpty(tag["select"], ".")

$$ <% def _elem$$=_wr_tag_index$$ = $$=context$$?.selectSingleNode("$$=selector$$") %>$$

/* Visibility condition check */
if(StringUtils.isBlank(otherwise)){
$$
<% if(getVisibilityCondition(_elem$$=_wr_tag_index$$) != null){ %></c:if><% } %>
$$ }else{ $$
<% if(getVisibilityCondition(_elem$$=_wr_tag_index$$) != null){ %></c:when><c:otherwise>$$=otherwise$$</c:otherwise></c:choose><% } %>   
$$ 
}

/* Target accessibility check */
$$ <% if (_elem$$=_wr_tag_index$$.valueOf("NavigationFlow/@to|@landmark") && getClosestAccessAwareElement(_elem$$=_wr_tag_index$$["landmark"] == "true" ? _elem$$=_wr_tag_index$$ : getById(_elem$$=_wr_tag_index$$.valueOf("NavigationFlow/@to")))) { %>
    <% def _visPol$$=_wr_tag_index$$ = getInaccessibleEventPolicy(_elem$$=_wr_tag_index$$)%>
	<% if (_visPol$$=_wr_tag_index$$ == "" || _visPol$$=_wr_tag_index$$ == "hide") { %>
		$$ if (! StringUtils.isBlank(otherwise)) { $$
			</c:when><c:otherwise>$$=otherwise$$</c:otherwise></c:choose>
		$$ } else { $$
			</c:if>
		$$ } $$
	<% } %>
<% } %>
$$

/* Hiding of AJAX events with no presentation */
$$ <% } %> $$
