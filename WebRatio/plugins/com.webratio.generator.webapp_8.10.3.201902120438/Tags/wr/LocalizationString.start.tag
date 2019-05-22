$$ 
setJavaOutput() 
$$<% if (getEffectiveLocalizedElement(page)) {
   %><spring:message code="$$=tag["key"]$$"/><%
} else { 
  %><%="$$=tag["key"]$$"%><% 
} %>