<?xml version="1.0"?>
<!-- ============================================================= -->
<!--  SDS Localization support                                                                                     -->
<!--                                                                                                                            -->
<!--   Version 0.0.1 (Sept 15 2003)                                                                               -->
<!-- ============================================================= -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:rdbms="http://www.webml.org/mapping/rdbms" 
	xmlns:presentation="http://www.webml.org/presentation" 
	xmlns:graphmetadata="http://www.webml.org/graphmetadata" 
	xmlns:auxiliary="http://www.webml.org/auxiliary" 
	xmlns:java="http://xml.apache.org/xslt/java" 
    xmlns:saxon="http://icl.com/saxon"
	exclude-result-prefixes="saxon rdbms presentation graphmetadata auxiliary java" 
	version="1.0">
	<xsl:output indent="yes" method="xml" encoding="ISO-8859-1" 
		doctype-system="WebML.dtd"/>
	
		
	<!-- ========================================================= -->
	<!-- Document                                                  -->
	<!-- ========================================================= -->
	<xsl:template match="/">
		<xsl:apply-templates select="@*"/>
		<xsl:apply-templates select="*"/>
	</xsl:template>
	
	
		<!-- =====================================================================-->
	<!-- ======== Updating references to SELECTORCONDITION  for all units ==== -->
	<!-- ===================================================================== -->	
   	
	<xsl:template match="SELECTORCONDITION">
		<xsl:copy>
           <xsl:apply-templates select="@*"/>
		   <xsl:if test="not(@booleanOperator)">
			<xsl:attribute name="booleanOperator">or</xsl:attribute>
		</xsl:if>
		<xsl:apply-templates select="*"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="SELECTOR | PRESELECTOR | SOURCESELECTOR | TARGETSELECTOR">
		<xsl:copy>
           <xsl:apply-templates select="@*"/>
		   <xsl:if test="not(@booleanOperator)">
			<xsl:attribute name="booleanOperator">and</xsl:attribute>
		</xsl:if>
		<xsl:apply-templates select="*"/>
		</xsl:copy>
	</xsl:template>
	
	
		
	<!-- ============================================================= -->
	<!-- ================ M I S C E L L A N E O U S ================== -->
	<!-- ============================================================= -->
	<!-- ========================================================= -->
	<!-- Default: copy elements and attributes                     -->
	<!-- ========================================================= -->
	<xsl:template match="*|@*">
         <xsl:copy>
            <xsl:apply-templates select="*|@*"/>
         </xsl:copy>
	</xsl:template>
	<!-- ========================================================= -->
	<!-- COMMENT: copy all comments                                -->
	<!-- ========================================================= -->
	<xsl:template match="COMMENT">
		<xsl:copy>
			<xsl:copy-of select="node()"/>
		</xsl:copy>
	</xsl:template>
</xsl:stylesheet>
