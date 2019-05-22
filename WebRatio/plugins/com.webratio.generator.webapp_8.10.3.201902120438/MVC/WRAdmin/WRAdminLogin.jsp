<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="webratio" uri="http://www.webratio.com/2006/TagLib/JSP20"%>
<%@ page contentType="text/html; charset=UTF-8" errorPage="Error.jsp"%>
<webratio:Page page="AdminLoginPage" />
<html lang="en" xml:lang="en" xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><c:out value="${applicationName}"/> Administration - Login</title>
<base href="${wrBaseURI}" />
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"/>
<style type="text/css">
  html, body { font-family: sans-serif; color: black; background: F5F5F5;}
  h2 { color: #C80028 }
  a img { color: white}
  .dividingline {BORDER-RIGHT: #D4D8D2 1px solid; PADDING-RIGHT: 4px; BORDER-TOP: #D4D8D2 1px solid; PADDING-LEFT: 4px; PADDING-BOTTOM: 4px; BORDER-LEFT: #D4D8D2 1px solid; PADDING-TOP: 4px; BORDER-BOTTOM: #D4D8D2 1px solid}
  .contentright {PADDING-RIGHT: 2px; PADDING-LEFT: 2px; FONT-SIZE: 10px; PADDING-BOTTOM: 2px; COLOR: #828282; PADDING-TOP: 2px; FONT-FAMILY: Arial, Helvetica, sans-serif; TEXT-ALIGN: left}
</style>
</head>
<body onLoad="document.getElementById('username').focus()">
<form:form enctype="multipart/form-data">
  
  <table>
    <tr>
	 <td><a href="http://www.webratio.com/"><img src="WRResources/WRLogo50.png" alt="WebRatio" width="50" style="border: 0px"/></a></td>
	 <td style="width:100%;vertical-align: middle;padding-left: 40px"><h2><c:out value="${applicationName}"/> Administration - Login</h2></td>
	</tr>
  </table>
  <hr size="1" width="100%" color="#D4D8D2" noshade="noshade"/>

  <table align="center" style="padding-top:20px;">
    <tr>
      <td>Username:</td><td><form:input path="userName" cssStyle="width:150px" id="username"/></td>
    </tr>
    <tr>
      <td>Password:</td><td><form:password path="password" cssStyle="width:150px" id="password"/></td>
    </tr>
    <tr>
      <td colspan="2" style="color:red" align="left"><form:errors path="login" cssStyle="color:red"/></td>
    </tr>
    <tr>
      <td colspan="2" align="right"><input type="submit" value="Enter" name="button:login"/></td>
    </tr>  
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