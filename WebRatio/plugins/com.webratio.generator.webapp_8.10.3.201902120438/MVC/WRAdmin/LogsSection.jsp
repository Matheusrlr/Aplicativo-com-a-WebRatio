<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<table cellspacing="0" cellpadding="0" width="100%" style="border:1px solid #cccccc; background: #f0f0e7">
 <tr>
    <td style="padding-left:7px;font-weight:bold; height: 20px" rowspan="1" colspan="1">
			<table>
				<tr>
					<td><img src="WRResources/properties.png" border="0" />
					</td>
					<td>Logs</td>
				</tr>
			</table></td>
	</tr>
</table>
<table>
	<tr>
	 <td valign="top">	 
<table>
  <% com.webratio.rtx.application.RTXApplication rtxApp = com.webratio.web.mvc.WebConstants.RTX_APP_KEY.get(application); 
     java.io.File logDir = new java.io.File(rtxApp.getConfiguration().getLogDirectory());
  %>
  <%try{%>
  <%if(!logDir.exists()){%>
     <tr>
      <td colspan="3" style="color:red;font-weight:bold">Log directory not found (<%=logDir.getAbsolutePath()%>)</td>
    </tr>	
  <%}else{%>
  <tr>
    <th align="left" style="border:1px solid #C8C8C8; background: #DFDFDF;">File</th>
	<th align="center" style="border:1px solid #C8C8C8; background: #DFDFDF;padding-left:25px;padding-right:25px">Date</th>
	<th align="center" style="border:1px solid #C8C8C8; background: #DFDFDF;padding-left:25px;padding-right:25px">Size</th>
  </tr>
  <% String resServletPath = com.webratio.web.mvc.WebConstants.RESOURCE_SERVLET_PATH_KEY.get(application); %>
  <%for(java.io.File file : logDir.listFiles()){%>
       <% String path = org.apache.commons.lang.StringUtils.removeStart(file.getAbsolutePath(), logDir.getAbsolutePath());%>
       <% session.setAttribute(file.getName(), file); %>
       <tr>
          <td><a href="<%=resServletPath%>/<%=file.getName()%>" target="_blank"><%=logDir.getAbsolutePath()%><%=path%></td></a></td>
          <td style="padding-left:25px;padding-right:25px"><%=org.apache.commons.lang.time.DateFormatUtils.format(file.lastModified(), "yyyy-MM-dd HH:mm:ss")%></td>
          <td style="padding-left:25px;padding-right:25px"><%=org.apache.commons.io.FileUtils.byteCountToDisplaySize(file.length())%></td>
       </tr>
  <%}%>
  <%}%>
 <%}catch(Exception e){%>
    <tr>
      <td colspan="3">
	     <pre style="color:red;font-weight:bold">
<%=org.apache.commons.lang.exception.ExceptionUtils.getFullStackTrace(e)%>
		 </pre>
	  </td>
    </tr>	
 <%}%> 
</table>
</td>
	</tr>
</table>
<br/>


