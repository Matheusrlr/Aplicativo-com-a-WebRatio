<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<% 	
	response.setHeader("Cache-Control", "no-store,no-cache, must-revalidate");
	response.setDateHeader("Expires", -1);
	response.setHeader("Pragma", "No-cache");
%>
<html lang="en" xml:lang="en" xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>Login Page</title>
<style type="text/css">
body {
  font-family: sans-serif;
  color: black;
  background: white;
}
h3 {
  color: #C80028;
}
a img { color: white; }
</style>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"/>
</head>
<body>
<form:form action="form_login.do" enctype="multipart/form-data">
<form:hidden path="lastURL"/>
<h1>Please Login</h1>
<hr/>
<table>
  <tr>
    <td>Username</td>
    <td>
      <form:input path="userName" autocomplete="off"/>
    </td>
  </tr>
  <tr>
    <td>Password</td>
    <td>
      <form:password path="password" autocomplete="off"/>
    </td>
  </tr>
  <tr>
    <td colspan="2">
      <input type="submit" value="Enter"/>
    </td>
  </tr>
</table>
<hr/>
</form:form>
</body>
</html>