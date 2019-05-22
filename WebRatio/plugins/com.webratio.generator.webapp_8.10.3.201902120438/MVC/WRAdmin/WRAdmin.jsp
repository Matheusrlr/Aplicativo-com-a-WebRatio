<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="webratio" uri="http://www.webratio.com/2006/TagLib/JSP20"%>
<%@ page contentType="text/html; charset=UTF-8" errorPage="Error.jsp"%>
<webratio:Page page="AdminPage" />
<html>
<head>
<title><c:out value="${applicationName}"/>  Administration</title>
<base href="${wrBaseURI}" />
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<style>
  body { font-family: sans-serif; color: black; background: F5F5F5; }
  h2 { color: #C80028; }
  a img { color: white; }
  .text {padding-left:5px; padding-right:5px}
  .dividingline {BORDER-RIGHT: #D4D8D2 1px solid; PADDING-RIGHT: 4px; BORDER-TOP: #D4D8D2 1px solid; PADDING-LEFT: 4px; PADDING-BOTTOM: 4px; BORDER-LEFT: #D4D8D2 1px solid; PADDING-TOP: 4px; BORDER-BOTTOM: #D4D8D2 1px solid}
  .contentright {PADDING-RIGHT: 2px; PADDING-LEFT: 2px; FONT-SIZE: 10px; PADDING-BOTTOM: 2px; COLOR: #828282; PADDING-TOP: 2px; FONT-FAMILY: Arial, Helvetica, sans-serif; TEXT-ALIGN: left} 
</style>
</head>
<body>
<form:form id="AdminFormBean" enctype="multipart/form-data">
	
	<table>
       <tr>
		 <td><a href="http://www.webratio.com/"><img src="WRResources/WRLogo50.png" alt="WebRatio" width="50" style="border: 0px"/></a></td>
		 <td style="width:100%;vertical-align: middle;padding-left: 40px"><h2><c:out value="${applicationName}"/> Administration</h2></td>
		 <td valign="bottom" align="right"><input type="submit" value="Logout" name="button:logout" /></td>
	   </tr>
    </table>
    <hr size="1" width="100%" color="#D4D8D2" noshade="noshade"/>
	
	<table width="100%">
		<c:if test="${not empty(general)}">
		   <tr><td><c:import url="GeneralSection.jsp" /></td></tr>
		</c:if>
		<c:if test="${not empty(protection)}">
		   <tr><td><c:import url="ProtectionSection.jsp" /></td></tr>
		</c:if>
		<c:if test="${not empty(localization)}">
		  <tr><td><c:import url="LocalizationSection.jsp" /></td></tr>
		</c:if>
		<tr><td><c:import url="PropertiesSection.jsp" /></td></tr>
		<tr><td><c:import url="LogsSection.jsp" /></td></tr>
		<tr><td height="100%">&nbsp;</td></tr>
	</table>

    <table border="0" width="100%" cellPadding="0" cellSpacing="2" valign="bottom" style="padding-top:20px;">
	  <tr>
		<td width="300" class="dividingline" height="8"></td>
		<td width="207" class="dividingline" height="8"></td>
		<td width="158" class="dividingline" height="8"></td>
		<td width="125" class="dividingline" height="8"></td>
		<td width="110" class="dividingline" height="8"></td>				
	  </tr>
	  <tr>
	    <td valign="bottom"><div align="center" class="contentright">Copyright 2015, WebRatio s.r.l. All rights reserved.</div></td>
	  </tr>
    </table>
    
</form:form>
</body>
</html>
