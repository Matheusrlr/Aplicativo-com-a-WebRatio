$$
import org.apache.commons.lang.StringUtils

setJavaOutput()
def classAttr = StringUtils.defaultString(tag["class"])
def separator = StringUtils.defaultString(tag["separator"])
def linkClass = StringUtils.defaultString(tag["linkClass"])
$$
$$ if (standalone) { $$
<span class="<%="$$=classAttr$$"%>">
<% for (area in getAncestorLandmarks(page).reverse()) { %>
<%="$$=separator$$"%></span><a class="<%="$$=linkClass$$"%>" href="<webratio:Link link="<%= getEventRuntimeId(area) %>"/>"><% if (getEffectiveLocalizedElement(area)) {
   %><spring:message code="<%printJSPTagValue(getTitle(area))%>"/><%
} else { 
  %><%=getTitle(area)%><%
} %>
</a><span class="<%="$$=classAttr$$"%>">
<%}%>
</span>
$$ } else { 
	if (classAttr) {
		tagProblems.addWarning("Main CSS class ignored when specifying a navigation bar body.")
	}
	if (separator) {
		tagProblems.addWarning("Separator ignored when specifying a navigation bar body.")
	}
	if (linkClass) {
		tagProblems.addWarning("Link CSS class ignored when specifying a navigation bar body.")
	}
$$
<% for (_wr_var0 in getAncestorLandmarks(page).reverse()) { %>
$$ }  $$