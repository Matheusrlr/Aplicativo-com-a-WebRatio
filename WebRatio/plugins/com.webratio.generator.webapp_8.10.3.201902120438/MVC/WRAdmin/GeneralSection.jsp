<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="webratio" uri="http://www.webratio.com/2006/TagLib/JSP20"%>
<%@ page import="org.apache.commons.lang.exception.ExceptionUtils" %> 
<%@ page contentType="text/html; charset=UTF-8"%>
<webratio:Page page="GeneralSection" />
<table cellspacing="0" cellpadding="0" width="100%" style="border:1px solid #cccccc; background: #f0f0e7">
	<tr>
	   <td style="padding-left:7px;font-weight:bold; height: 20px" rowspan="1" colspan="1">
	    <table>
	      <tr>
	        <td><img src="WRResources/general.png" border="0"/></td>
	        <td>General</td>  
	      </tr>
	    </table>
       </td>
	</tr>
</table>
<table>
	<tr>
	    <c:choose>
		<c:when test="${empty(general.exception)}">
		<td valign="top">
		<table valign="top">
		    <tr>
				<td class="text" style="border:1px solid #C8C8C8; background: #DFDFDF;">Deployment Information</td>
			</tr>
		    <tr>
				<td class="text">Host Name: <b><c:out value="${general.hostName}" /></b></td>
			</tr>
			<tr>
				<td class="text">IP Address: <b><c:out value="${general.ip}" /></b></td>
			</tr>
			<tr>
				<td class="text">Port Number: <b><c:out value="${general.port}" /></b></td>
			</tr>
			<tr>
				<td class="text">Application Path: <b><c:out value="${general.path}" /></b></td>
			</tr>
		</table>
		</td>
		<td valign="top" style="padding-left:30px">
		<table valign="top">
		    <tr>
				<td class="text" style="border:1px solid #C8C8C8; background: #DFDFDF;">Model Information</td>
			</tr>
		    <tr>
				<td class="text">Units: <b><c:out value="${general.units}" /></b></td>
			</tr>
			<tr>
				<td class="text">Pages: <b><c:out value="${general.pages}" /></b></td>
			</tr>
			<tr>
				<td class="text">Users: <b><c:out value="${general.users}" /></b></td>
			</tr>
		</table>
		</td>
		<c:if test="${general.showActivationLink}">
		<td valign="top" style="padding-left:30px">
		<table valign="top">
		    <tr>
				<td class="text" style="border:1px solid #C8C8C8; background: #DFDFDF;">Activation</td>
			</tr>
		    <tr>
				<td valign="top">
				  To activate the application <a href="<webratio:BLOB value="activation-request.webratio"/>" target="blank" class="menu">download</a> the 
				  Activation Request File&nbsp;<img src="WRResources/activation.png" border="0" />
		        </td>
			</tr>
		</table>
		</td>
		</c:if>
	    </c:when>
		<c:otherwise>
		  <td valign="top" class="text">
		    <b>Unable to compute application details</b>
		    <br>
		    <c:set var="generalException" value="${general.exception}"/>
		    <pre style="color:red;font-weight:bold"><%=ExceptionUtils.getFullStackTrace((Throwable) pageContext.getAttribute("generalException"))%></pre>
		  </td>
		</c:otherwise>
		</c:choose>
	</tr>
</table>
<br/>
