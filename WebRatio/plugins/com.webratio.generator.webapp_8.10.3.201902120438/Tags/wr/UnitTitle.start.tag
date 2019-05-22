$$ 
setJavaOutput() 
$$<% if (getEffectiveLocalizedElement(component)) {
   %><spring:message code="<%printJSPTagValue(getTitle(component))%>"/><%
} else { 
  %><%=getTitle(component)%><% 
} %>