<?xml version="1.0"?>
<!--
  =============================================================
    Version 4.3.2 (23-10-2006)
  =============================================================
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:presentation="http://www.webml.org/presentation"
			    xmlns:saxon="http://icl.com/saxon"
                xmlns:layout="http://www.webml.org/layout"
                xmlns:graphmetadata="http://www.webml.org/graphmetadata" 
                xmlns:gr="http://www.webml.org/graph"
                xmlns:auxiliary="http://www.webml.org/auxiliary" 
                xmlns:java="http://xml.apache.org/xslt/java"
                exclude-result-prefixes="saxon layout graphmetadata java"
                version="1.0">
	
	<xsl:output indent="yes" method="xml" encoding="ISO-8859-1" doctype-system="WebML.dtd"/>
    
    <xsl:key name="msf" match="MULTISELECTIONFIELD" use="@id"/>


    <xsl:template match="LINKPARAMETER">
       <xsl:choose>
          <xsl:when test="key('msf',@target)/self::MULTISELECTIONFIELD">
             <xsl:copy>
                <xsl:copy-of select="@*" />
                <xsl:attribute name="target">
                   <xsl:value-of select="concat(@target,'.presel')" />
                </xsl:attribute>
                <xsl:copy-of select="*" />
             </xsl:copy>
          </xsl:when>
          <xsl:otherwise>
             <xsl:copy-of select="."/>
          </xsl:otherwise>
       </xsl:choose>
    </xsl:template>


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