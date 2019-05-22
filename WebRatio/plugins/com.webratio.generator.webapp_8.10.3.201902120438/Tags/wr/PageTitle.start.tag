$$ 
setJavaOutput() 
$$<% if (getEffectiveLocalizedElement(page)) {
   %><spring:message code="<%printJSPTagValue(getTitle(page))%>"/><%
} else { 
  %><%=getTitle(page)%><% 
} %>