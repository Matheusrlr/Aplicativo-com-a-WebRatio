<?xml version="1.0"?>
<!--
=============================================================
Added 'ModuleName' attribute

Version 3.1.1 (February 27 2006)
=============================================================
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:presentation="http://www.webml.org/presentation"
	xmlns:graphmetadata="http://www.webml.org/graphmetadata" xmlns:gr="http://www.webml.org/graph"
	xmlns:auxiliary="http://www.webml.org/auxiliary" version="1.0">
	
	<xsl:output indent="yes" method="xml" encoding="ISO-8859-1" doctype-system="WebML.dtd"/>
	
	<!-- add name to module entity -->
	<xsl:template match="ENTITY[@id='SiteView' or @id='Module']">
		<xsl:copy>
			<xsl:apply-templates select="@*"/>
			<xsl:apply-templates select="*"/>
            <ATTRIBUTE id="moduleName" name="ModuleName" auxiliary:testCaseFile="default.txt" type="String"/>
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