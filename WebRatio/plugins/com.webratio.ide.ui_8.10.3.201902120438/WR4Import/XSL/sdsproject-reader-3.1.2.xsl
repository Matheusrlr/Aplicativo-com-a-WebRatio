<?xml version="1.0"?>
<!--
=============================================================
Convert old style protected property
	
Version 3.1.2 (March 28 2006)
=============================================================
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:presentation="http://www.webml.org/presentation"
	xmlns:graphmetadata="http://www.webml.org/graphmetadata" xmlns:gr="http://www.webml.org/graph"
	xmlns:auxiliary="http://www.webml.org/auxiliary" version="1.0">
	
	<xsl:output indent="yes" method="xml" encoding="ISO-8859-1" doctype-system="WebML.dtd"/>
	
	<!-- convert old style protected property -->
	<xsl:template match="PAGE|AREA">
		<xsl:copy>
			<xsl:apply-templates select="@*"/>
			<xsl:if test="PROPERTY[@name='protected' and @value='yes']">
				<xsl:attribute name="protected">yes</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates select="*|comment()| processing-instruction()|text()"/>
		</xsl:copy>
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