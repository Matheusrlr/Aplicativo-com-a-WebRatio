$$
import org.apache.commons.lang.StringUtils

setJavaOutput()
def context = tag["context"]
def isPageTag = false
if (StringUtils.isEmpty(context)) {
    def names = new HashSet(["wr:LandmarkOperationMenu", "wr:LandmarkPageMenu", "wr:LandmarkAreaMenu", 
		    "wr:LandmarkMenu", "wr:LandmarkAreaLink", "wr:LandmarkPageLink", "wr:LandmarkOperationLink", 
		    "wr:LandmarkEvent", "wr:PageEvents", "wr:Iterate", "wr:NavigationBar"])
    def loopTags = ancestorTags.findAll{names.contains(it.name)}
    def loopTagsSize = loopTags.size()
    if (loopTagsSize == 0) {
      tagProblems.addFatalError("<wr:Event/> must be surrounded by one of the following tags: " + names)
    }
    
    def loopTagVar = loopTags[0].attributes.var 
    if (!StringUtils.isEmpty(loopTagVar)) {
        context = loopTagVar
    } else {
        context = "_wr_var" + (loopTagsSize - 1)
    }
    isPageTag = (loopTags[0].name != "wr:Iterate")
    isPageLinkTag = (loopTags[0].name == "wr:PageEvents")
}
def selector = StringUtils.defaultIfEmpty(tag["select"], ".")

def position = tag["position"]
if (position == null) {
    position = "'index'"
}
def classAttr = StringUtils.defaultString(tag["class"])
def type = StringUtils.defaultString(tag["type"])
if (isPageTag) {$$ 
<% def _elem$$=_wr_tag_index$$ = $$=context$$?.selectSingleNode("$$=selector$$")
  $$ if (isPageLinkTag) { $$
	if (getClosestAccessAwareElement(getById(_elem$$=_wr_tag_index$$.valueOf("NavigationFlow/@to")))) {
  $$ } else { $$
	if (getClosestAccessAwareElement(_elem$$=_wr_tag_index$$)) {
  $$ } $$
	  def _visPol$$=_wr_tag_index$$ = getInaccessibleEventPolicy(_elem$$=_wr_tag_index$$)
	  if (_visPol$$=_wr_tag_index$$ == "" || _visPol$$=_wr_tag_index$$ == "hide") { 
	    %><c:if test="${webratio:isTargetAccessible('<%= getEventRuntimeId(_elem$$=_wr_tag_index$$)%>', pageContext)}"><%
	  } else if (_visPol$$=_wr_tag_index$$ == "inactive") { 
	    %><c:choose>
	       <c:when test="${webratio:isTargetAccessible('<%= getEventRuntimeId(_elem$$=_wr_tag_index$$)%>', pageContext)}"><%
	  }
	} %>
$$ } $$