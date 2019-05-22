<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="webratio" uri="http://www.webratio.com/2006/TagLib/JSP20"%>
<%@ page import="org.apache.commons.lang.exception.ExceptionUtils" %> 
<%@ page contentType="text/html; charset=UTF-8"%>
<webratio:Page page="ProtectionSection" />
<table cellspacing="0" cellpadding="0" width="100%" style="border:1px solid #cccccc; background: #f0f0e7">
 <tr>
    <td style="padding-left:7px;font-weight:bold; height: 20px" rowspan="1" colspan="1">
    <table>
      <tr>
        <td><img src="WRResources/protection.png" border="0"/></td>
        <td>Protection</td>  
      </tr>
    </table>
    </td>
 </tr>
</table>
<table>
	<tr>
		<c:choose>
		<c:when test="${empty(protection.exception)}">
		<td valign="top">
		<table border="0" valign="top">
			<tr title="Protected modules defined in the current application but not yet added to the database.">
				<td align="left" colspan="3" class="text" style="border:1px solid #C8C8C8; background: #DFDFDF;">Modules to Add</td>
			</tr>
			<c:choose>
			<c:when test="${not(empty protection.missingModules)}">
             <c:forEach var="module" varStatus="status" items="${protection.missingModules}">
				<c:set var="index" value="${status.index}" />
				<tr>
				  <td align="center">
				    <form:checkbox path="addedModules" value="${module.key}"/>
					<td align="left" class="text"><c:out value="${module.name}" /> <span style="color: gray; ">[<c:out value="${module.id}" />]</span></td>
					<td align="left" class="text"><c:out value="${module.domain}" /></td>
				</tr>
			 </c:forEach>
			 </c:when>
			  <c:otherwise><tr><td class="text" colspan="3">No protected modules to insert found</td></tr></c:otherwise>
			 </c:choose>
		</table>
		</td>
		<td valign="top" style="padding-left:30px">
		<table border="0" valign="top">
			<tr title="Unused modules not defined in the current application.">
				<td align="left" colspan="3" class="text" style="border:1px solid #C8C8C8; background: #DFDFDF;">Unused Modules</td>
			</tr>
		    <c:choose>
			<c:when test="${not(empty protection.wrongModules)}">
			 <c:forEach var="module" varStatus="status" items="${protection.wrongModules}">
				<c:set var="index" value="${status.index}" />
				<tr>
				  <td align="center" style="padding-left: 1px;padding-right: 1px;">
					<form:checkbox path="deletedModules" value="${module.key}"/>
					<td align="left" class="text"><c:out value="${module.name}" />  <span style="color: gray; ">[<c:out value="${module.id}" />]</span></td>
					<td align="left" class="text"><c:out value="${module.domain}" /></td>
				</tr>
			 </c:forEach>
			</c:when>
		    <c:otherwise><tr><td class="text" colspan="3">No protected modules to delete found</td></tr></c:otherwise>
		    </c:choose>
		</table>
		</td>
		</c:when>
		<c:otherwise>
		  <td valign="top" class="text">
		    <b>Unable to compute protected modules</b>
		    <br>
		    <c:set var="protectionException" value="${protection.exception}"/>
		    <pre style="color:red;font-weight:bold"><%=ExceptionUtils.getFullStackTrace((Throwable) pageContext.getAttribute("protectionException"))%></pre>
		  </td>
		</c:otherwise>
		</c:choose>
	</tr>
	<c:if test="${empty(protection.exception) and protection.showUpdateButton}">
	<tr>
		<td colspan="2" align="left" style="padding-top:15px">
			<script type="text/javascript">
				function checkUpdateModules(button) {
					var added = button.form["addedModules"];
					if (added.length) {
						for (var i = 0; i < added.length; i++) {
							if (added[i].checked) { return true; }
						}
					} else {
						if (added.checked) { return true; }
					}
					var deleted = button.form["deletedModules"];
					if (deleted.length) {
						for (var i = 0; i < deleted.length; i++) {
							if (deleted[i].checked) { return true; }
						}
					} else {
						if (deleted.checked) { return true; }
					}
					alert("No modules selected.\n\nPlease select at least one new module to add or unused module to delete.");
					return false;
				}
			</script>
			<input type="submit" value="Update Modules" name="button:updateModules" onclick="return checkUpdateModules(this)"/>
		</td>
	</tr>
	</c:if>
</table>
<br/>

