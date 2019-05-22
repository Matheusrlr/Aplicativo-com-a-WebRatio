<?xml version="1.0"?> 

<!-- ============================================================= -->
<!-- fields                                             	   -->
<!--                                                               -->
<!--   lists fields exposed by this unit                           -->
<!--                                                               -->
<!--   Version X.Y (MMM DD YYYY)                                   -->
<!-- ============================================================= -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
			    xmlns:saxon="http://icl.com/saxon"
                xmlns:layout="http://www.webml.org/layout"
                exclude-result-prefixes="saxon"
                version="1.0">
  
  <!-- Note: keys and rules of '_common/util.xsl' are 
       available in this stylesheet -->
  
  <!-- ========================================================= -->
  <!-- Key declarations                                          -->
  <!-- ========================================================= --> 
  <xsl:key name="id" match="*" use="@id"/>

  <!-- ========================================================= -->
  <!-- Default rule: prevents the default recursive rule from    -->
  <!--               being applied				                 -->
  <!-- ========================================================= -->
  <xsl:template match="*" mode="fields"/>

</xsl:stylesheet>