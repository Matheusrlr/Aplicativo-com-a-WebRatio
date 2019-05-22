<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="webratio" uri="http://www.webratio.com/2006/TagLib/JSP20"%>
<%@ page import="org.apache.commons.lang.exception.ExceptionUtils"%>
<%@ page contentType="text/html; charset=UTF-8"%>

<table cellspacing="0" cellpadding="0" width="100%" style="border:1px solid #cccccc; background: #f0f0e7">
 <tr>
    <td style="padding-left:7px;font-weight:bold; height: 20px" rowspan="1" colspan="1">
			<table>
				<tr>
					<td><img src="WRResources/properties.png" border="0" />
					</td>
					<td>Properties</td>
				</tr>
			</table></td>
	</tr>
</table>
<table>
	<tr>
	 <td valign="top">
	 
<% com.webratio.rtx.application.RTXApplication rtxApp = com.webratio.web.mvc.WebConstants.RTX_APP_KEY.get(application); %>
<table>
	<tr>
	   <th colspan="2" align="left" style="border:1px solid #C8C8C8; background: #DFDFDF;">Runtime Properties</th>
	</tr>
	<tr>
		<th align="left">Key</th>
		<th align="left">Value</th>
	</tr>
	<tr>
		<td>workDir</td>
		<td><%=rtxApp.getConfiguration().getWorkDirectory()%></td>
	</tr>
    <tr>
		<td>logDir</td>
		<td><%=rtxApp.getConfiguration().getLogDirectory()%></td>
	</tr>
    <tr>
		<td>uploadDir</td>
		<td><%=rtxApp.getConfiguration().getUploadDirectory()%></td>
	</tr>
	<%
	java.util.Map props = rtxApp.getConfiguration().getProperties();
	java.util.Set keySet = new java.util.TreeSet(props.keySet());
	for (java.util.Iterator iterator = keySet.iterator(); iterator.hasNext();) {
	    Object key = iterator.next();
    %>    
      <tr>
		<td><%=key%></td>
		<td>'<%=props.get(key)%>'</td>
	  </tr>    
    <%}%>	
	<tr>
	   <th colspan="2" align="left" style="border:1px solid #C8C8C8; background: #DFDFDF;">Runtime Variables</th>
	</tr>
	<tr>
		<th align="left">Key</th>
		<th align="left">Value</th>
	</tr>
	<%
	props = rtxApp.getConfiguration().getVariables();
	keySet = new java.util.TreeSet(props.keySet());
	for (java.util.Iterator iterator = keySet.iterator(); iterator.hasNext();) {
	    Object key = iterator.next();
    %>    
    <tr>
		<td><%=key%></td>
		<td>'<%=props.get(key)%>'</td>
	  </tr>     
    <%}%>	
	<tr>
	   <th colspan="2" align="left" style="border:1px solid #C8C8C8; background: #DFDFDF;">System Properties</th>
	</tr>
	<tr>
		<th align="left">Key</th>
		<th align="left">Value</th>
	</tr>
	<%
	props = System.getProperties();
	keySet = new java.util.TreeSet(props.keySet());
	for (java.util.Iterator iterator = keySet.iterator(); iterator.hasNext();) {
	    Object key = iterator.next();
    %>     
    <tr>
		<td><%=key%></td>
		<td>'<%=props.get(key)%>'</td>
	  </tr>     
    <%}%>	
</table>
</td>
	</tr>
</table>
<br />


