<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="webratio" uri="http://www.webratio.com/2006/TagLib/JSP20"%>
<%@ page import="org.apache.commons.lang.exception.ExceptionUtils" %> 
<%@ page contentType="text/html; charset=UTF-8"%>


<script type="text/javascript"> 
function toggleKeyDiv(showHideDiv) {
	var ele = document.getElementById(showHideDiv);
	if(ele.style.display == "block") {
    	ele.style.display = "none";
	} else {
		ele.style.display = "block";
	}
}
</script>


<table cellspacing="0" cellpadding="0" width="100%" style="border:1px solid #cccccc; background: #f0f0e7">
 <tr>
    <td style="padding-left:7px;font-weight:bold; height: 20px" rowspan="1" colspan="1">
    <table>
      <tr>
        <td><img src="WRResources/localization.png" border="0"/></td>
        <td>Localization</td>  
      </tr>
    </table>
    </td>
 </tr>
</table>
<table>
    <c:choose>
      <c:when test="${not(empty(localization.exception))}">
	    <tr>
	      <td valign="top" class="text">
		    <b>Unable to update database stored bundle data</b>
		    <br/>
		    <c:set var="localizationException" value="${localization.exception}"/>
		    <pre style="color:red;font-weight:bold"><%=ExceptionUtils.getFullStackTrace((Throwable) pageContext.getAttribute("localizationException"))%></pre>
		  </td>
	    </tr>
      </c:when>
	  <c:when test="${localization.showUpdateButton}">
	      <tr><td align="left" class="text">The database bundle data is not aligned with the model.</td></tr> 
		  <c:if test="${localization.missingKeyCount gt 0}">
		     <tr><td align="left" class="text"><a href="javascript:toggleKeyDiv('missingKeys');" >Missing bundle keys (nr. ${localization.missingKeyCount})</a></td></tr>
		     <tr>
		       <td>
		          <table>
		             <tr>
		               <td>
		                  <div id="missingKeys" style="border: 1px solid black; background-color: #CDCDCD; display: none;padding: 5px;">
		                    <c:set var="missingKeys" value="${localization.missingKeys}"/>
	             	        <%= org.apache.commons.lang.StringUtils.join((java.util.Collection) pageContext.getAttribute("missingKeys"), ", ")%>
		                  </div>
		               </td>
		             </tr>
		          </table>       
		       </td>
		     </tr>
		  </c:if>
		  <c:if test="${localization.invalidKeyCount gt 0}">
		     <tr><td align="left" class="text"><a href="javascript:toggleKeyDiv('invalidKeys');" >Invalid bundle keys (nr. ${localization.invalidKeyCount})</a></td></tr>
		     <tr>
		       <td>
		          <table>
		             <tr>
		               <td>
		                  <div id="invalidKeys" style="border: 1px solid black; background-color: #CDCDCD; display: none;padding: 5px;">
		                    <c:set var="invalidKeys" value="${localization.invalidKeys}"/>
		                    <%= org.apache.commons.lang.StringUtils.join((java.util.Collection) pageContext.getAttribute("invalidKeys"), ", ")%>
	             	      </div>
		               </td>
		             </tr>
		          </table>       
		       </td>
		     </tr>
		  </c:if>
		  <tr><td><input type="submit" value="Update Bundle Data" name="button:updateBundle"/></td></tr>
		</tr>
	  </c:when> 
	  <c:otherwise>
	    <tr>
		  <td align="left" colspan="2" class="text">The database bundle data is aligned with the model</td>
		</tr>    
	  </c:otherwise>
	</c:choose>
</table>

