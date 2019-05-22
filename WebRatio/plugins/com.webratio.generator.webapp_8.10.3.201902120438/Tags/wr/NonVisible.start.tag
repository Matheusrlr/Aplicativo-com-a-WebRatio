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
        tagProblems.addFatalError("<wr:NonVisible/> must be surrounded by one of the following tags: " + names)
    }
    if (StringUtils.isEmpty(loopTags[0].attributes.var)) {
        context = "_wr_var" + (loopTags.size() - 1)
    } else {
        context = loopTags[0].attributes.var
    }
}
def position = StringUtils.defaultIfEmpty(tag["position"], null)
def selector = StringUtils.defaultIfEmpty(tag["select"], ".")

/* Always skip body when applied to AJAX events with no presentation */
$$ <% if (!isAjaxGenericPage(page) || _elem$$=_wr_tag_index$$.name != "Event" || $$=context$$?.selectSingleNode("$$=selector$$")["event"] == null || !isClientLogicLayoutEvent($$=context$$?.selectSingleNode("$$=selector$$"))) { %> $$

/* Determine conditions that may render the element non-visible */
$$
<%
	def _wr_hasVisibilityPolicy$$=ancestorTags.size()$$ = ($$=context$$?.selectSingleNode("$$=selector$$").valueOf("NavigationFlow/@to|@landmark") && getClosestAccessAwareElement(getById($$=context$$?.selectSingleNode("$$=selector$$").valueOf("NavigationFlow/@to")))) && (getInaccessibleEventPolicy($$=context$$?.selectSingleNode("$$=selector$$")) == "" || getInaccessibleEventPolicy($$=context$$?.selectSingleNode("$$=selector$$")) == "hide")
	def _wr_hasVisibilityCondition$$=ancestorTags.size()$$  = (getVisibilityCondition($$=context$$?.selectSingleNode("$$=selector$$")) != null)
%>
$$

/* Always skip body if element can never be hidden */
$$ <% if (_wr_hasVisibilityPolicy$$=ancestorTags.size()$$ || _wr_hasVisibilityCondition$$=ancestorTags.size()$$) { %> $$

/* Target accessibility and visibility condition check */
$$
<%
	_wr_visibilityTerms$$=ancestorTags.size()$$ = []
	if (_wr_hasVisibilityPolicy$$=ancestorTags.size()$$) {
		_wr_visibilityTerms$$=ancestorTags.size()$$.add("not(webratio:isTargetAccessible('" + getEventRuntimeId($$=context$$?.selectSingleNode("$$=selector$$")) + "', pageContext))")
	}
	if (_wr_hasVisibilityCondition$$=ancestorTags.size()$$) {
		_wr_visibilityTerms$$=ancestorTags.size()$$.add("not(" + getVisibilityCondition($$=context$$?.selectSingleNode("$$=selector$$"), $$=position$$) + ")")
	}
%>
<c:if test="${<% printJSPTagValue(_wr_visibilityTerms$$=ancestorTags.size()$$.join(" or ")) %>}">
$$
