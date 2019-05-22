$$ 
setJavaOutput() 
$$<% if (getEffectiveLocalizedElement(element)) {
   %><spring:message code="<%printJSPTagValue(getTitle(element))%>"/><%
} else { 
  %><%=getTitle(element)%><% 
} %>