<?xml version="1.0" encoding="UTF-8"?>
<%@ page contentType="text/html; charset=UTF-8" %>
<%

if(!"true".equals(request.getHeader(com.webratio.rtx.RTXConstants.DEBUG_KEY))){
   throw new Exception("Invalid request");
}
com.webratio.rtx.debug.DebugAgent debugAgent = com.webratio.web.mvc.WebConstants.RTX_KEY.get(application).getDebugAgent();
response.setContentType("text/xml");
%>
<RuntimeDebug>
<%
if(debugAgent == null){
  %><Error>Runtime debug not enabled.

To enable debugging, the application server must be started with the following option:

  -D<%= com.webratio.rtx.RTXConstants.DEBUG_KEY %>=true

For more information, see "Instrumenting a Web Server for Debug" in the WebRatio Product Documentation.
  </Error><%
}else{
   String operation = com.webratio.rtx.beans.BeanHelper.asString(request.getParameter("op"));
   operation = org.apache.commons.lang.StringUtils.defaultIfEmpty(operation, "NULL");
   try {
     %><Operation><%=operation%></Operation><%
     if("start".equals(operation)) {
        int socketPortNumber = org.apache.commons.lang.math.NumberUtils.toInt(com.webratio.rtx.beans.BeanHelper.asString(request.getParameter("port")), -1);
        debugAgent.start(socketPortNumber);
        %><SocketPortNumber><%=debugAgent.getSocketPortNumber()%></SocketPortNumber><%
        String deploymentPath = org.apache.commons.lang.StringUtils.defaultString(application.getRealPath("/"));
        if (deploymentPath != null) {
          %><DeploymentPath><%=deploymentPath%></DeploymentPath><%
        }
        %><Result>success</Result><%
     } else {
        %><Result>error</Result><%
        %><Error>Invalid 'op' parameter value (<%=operation%>)</Error><%
     }
   } catch(Exception e) {
     %><Result>error</Result><%
     %><Error>Unable to <%=operation%> the runtime debug agent: <%=org.apache.commons.lang.StringEscapeUtils.escapeXml(e.getMessage())%></Error><%
     %><Exception><%=org.apache.commons.lang.StringEscapeUtils.escapeXml(org.apache.commons.lang.exception.ExceptionUtils.getFullStackTrace(e))%></Exception><% 
   }   
}
%>
</RuntimeDebug>