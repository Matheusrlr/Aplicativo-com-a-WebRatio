<?xml version="1.0"?>
<!--
  =============================================================
    - SET/GET units with multiple parameters
	- Explicit Presentation Sub-elements
	
    Version 4.3.0 (08-06-2006)
  =============================================================
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:presentation="http://www.webml.org/presentation"
			    xmlns:saxon="http://icl.com/saxon"
                xmlns:layout="http://www.webml.org/layout"
                xmlns:graphmetadata="http://www.webml.org/graphmetadata" 
                xmlns:gr="http://www.webml.org/graph"
                xmlns:auxiliary="http://www.webml.org/auxiliary" 
                exclude-result-prefixes="saxon layout graphmetadata"
                version="1.0">
	
	<xsl:output indent="yes" method="xml" encoding="ISO-8859-1" doctype-system="WebML.dtd"/>
    
  	

    <!-- ========================================================= -->
    <!-- Discard old wrong attributes                              -->
    <!-- ========================================================= --> 
    <xsl:template match="@graphmetadata:go"/>  
    
	
	<!-- ============================================================= -->
	<!-- ================ M I S C E L L A N E O U S ================== -->
	<!-- ============================================================= -->
	<!-- ========================================================= -->
	<!-- Default: copy elements and attributes                     -->
	<!-- ========================================================= -->
	<xsl:template match="*|@*|comment()|processing-instruction()|text()">
		<xsl:copy>
			<xsl:apply-templates select="*|@*|comment()| processing-instruction()|text()"/>
		</xsl:copy>
	</xsl:template>
	
</xsl:stylesheet>