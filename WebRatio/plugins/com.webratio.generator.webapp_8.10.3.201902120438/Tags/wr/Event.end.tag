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

$$ if (standalone) { $$
<a class="<%="$$=classAttr$$"%>" href="<webratio:Link link="<%= getEventRuntimeId($$=context$$?.selectSingleNode("$$=selector$$")) %>"/>"<% if ($$=context$$?.selectSingleNode("$$=selector$$")["newWindow"] == "true") { %> target="_blank"<% } %>>
   <% if (getEffectiveLocalizedElement($$=context$$?.selectSingleNode("$$=selector$$"))) { %>
      <spring:message code="<%printJSPTagValue(getTitle($$=context$$?.selectSingleNode("$$=selector$$")))%>"/>
   <% } else { %><%=getTitle($$=context$$?.selectSingleNode("$$=selector$$"))%><% } %>
</a>
$$ } $$
<% 
  $$ if (isPageLinkTag) { $$
	if (getClosestAccessAwareElement(getById($$=context$$?.selectSingleNode("$$=selector$$").valueOf("NavigationFlow/@to")))) {
	$$ } else { $$
	if (getClosestAccessAwareElement($$=context$$?.selectSingleNode("$$=selector$$"))) {
	$$ } $$
		if (getInaccessibleEventPolicy($$=context$$?.selectSingleNode("$$=selector$$")) == "inactive") { %>
			  </c:when>
			  <c:otherwise>
			     $$ if (standalone) { $$
				   <% if (getEffectiveLocalizedElement($$=context$$?.selectSingleNode("$$=selector$$"))) { %>
				      <spring:message code="<%printJSPTagValue(getTitle($$=context$$?.selectSingleNode("$$=selector$$")))%>"/>
				   <% } else { %><%=getTitle($$=context$$?.selectSingleNode("$$=selector$$"))%><% } %>
			     $$ } $$
			  </c:otherwise>
			</c:choose>  
		<% } else if ( getInaccessibleEventPolicy($$=context$$?.selectSingleNode("$$=selector$$")) == "" || getInaccessibleEventPolicy($$=context$$?.selectSingleNode("$$=selector$$")) == "hide" ) { %>
			</c:if>
		<% } 
	} %>
$$ } else { $$
<%
	printRaw(executeContextTemplate("MVC/LayoutElement.template", [\
		"_elem": $$= context $$?.selectSingleNode("$$= selector $$"), \
		"_layoutTagAttributes": [$$
			if (tag["position"]) {
				$$"position": $$= tag["position"] $$,$$
			}
			if (tag["type"]) {
				$$"type": "$$= tag["type"] $$",$$
			}
			if (tag["class"]) {
				$$"class": "$$= tag["class"] $$",$$
			}
		$$] \
	]))
%>
$$ } $$ 