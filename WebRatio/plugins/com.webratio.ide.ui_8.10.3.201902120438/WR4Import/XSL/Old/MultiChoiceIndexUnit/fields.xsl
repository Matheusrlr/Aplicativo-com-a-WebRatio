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
  <!-- MULTICHOICEINDEXUNIT                                      -->
  <!-- ========================================================= -->
  <xsl:template match="MULTICHOICEINDEXUNIT" mode="fields">
     <layout:field beanid="{@id}Checked" beantype="String[]" preloadProperty="" preloadBean="">
       <xsl:copy-of select="@*"/>
       <xsl:apply-templates select="CHECKVALIDATION"/>
     </layout:field>
  </xsl:template>
  
  <!-- check validation -->
  <xsl:template match="CHECKVALIDATION">
  	<CHECKVALIDATION>
  	    <xsl:copy-of select="@*"/>
        <xsl:copy-of select="*"/>
  	</CHECKVALIDATION>
  </xsl:template>

</xsl:stylesheet>