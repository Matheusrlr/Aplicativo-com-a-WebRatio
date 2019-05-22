<?xml version="1.0"?>
<!-- =============================================================
     Rename 'SiteView' entity to 'Module'
     Renamed 'SiteViewID' attribute to 'ModuleID
     Rename 'Group_SiteView' relationship to 'Group_DefaultModule'
     Add 'Group_Module' relationship

     Version 3.0.22 (November 25 2005)
     ============================================================= -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:rdbms="http://www.webml.org/mapping/rdbms"
	xmlns:presentation="http://www.webml.org/presentation" xmlns:graphmetadata="http://www.webml.org/graphmetadata"
	xmlns:auxiliary="http://www.webml.org/auxiliary" xmlns:java="http://xml.apache.org/xslt/java"
    xmlns:saxon="http://icl.com/saxon"
	exclude-result-prefixes="saxon rdbms presentation graphmetadata auxiliary java"
	version="1.0">
	
	<xsl:output indent="yes" method="xml" encoding="ISO-8859-1" doctype-system="WebML.dtd"/>
	
	<!-- ========================================================= -->
	<!-- Document                                                  -->
	<!-- ========================================================= -->
	<xsl:template match="/">
		<xsl:apply-templates select="@*"/>
		<xsl:apply-templates select="*"/>
	</xsl:template>
	
	<xsl:template match="ENTITY[@id='SiteView']/@name">
		<xsl:attribute name="name">Module</xsl:attribute>
	</xsl:template>
	
	<xsl:template match="ENTITY[@id='SiteView']/ATTRIBUTE[@id='siteViewID']/@name">
		<xsl:attribute name="name">ModuleID</xsl:attribute>
	</xsl:template>
	
	<xsl:template match="RELATIONSHIP[@id='Group2SiteView']/@name">
		<xsl:attribute name="name">Group_DefaultModule</xsl:attribute>
	</xsl:template>
	
	<xsl:template match="RELATIONSHIP[@id='Group2SiteView']/@roleName">
		<xsl:attribute name="roleName">Group2DefaultModule</xsl:attribute>
	</xsl:template>
	
	<xsl:template match="RELATIONSHIP[@id='SiteView2Group']/@name">
		<xsl:attribute name="name">Group_DefaultModule</xsl:attribute>
	</xsl:template>
	
	<xsl:template match="RELATIONSHIP[@id='SiteView2Group']/@roleName">
		<xsl:attribute name="roleName">DefaultModule2Group</xsl:attribute>
	</xsl:template>
	
	<!-- add relationship inside group entity -->
	<xsl:template match="ENTITY[@id='Group']">
		<xsl:copy>
			<xsl:apply-templates select="@*"/>
			<xsl:apply-templates select="*"/>
			<RELATIONSHIP graphmetadata:go="Group2Module_go" id="Group2Module" inverse="Module2Group" maxCard="N" minCard="0"
				name="Group_Module" roleName="Group2Module" auxiliary:testCaseCount="20" to="SiteView"/>
		</xsl:copy>
	</xsl:template>
	
	<!-- rename siteview entity and add relationship -->
	<xsl:template match="ENTITY[@id='SiteView']">
		<xsl:copy>
			<xsl:apply-templates select="@*"/>
			<xsl:apply-templates select="*"/>
			<RELATIONSHIP graphmetadata:go="" id="Module2Group" inverse="Group2Module" maxCard="N" minCard="0" name="Group_Module"
				roleName="Module2Group" auxiliary:testCaseCount="20" to="Group"/>
		</xsl:copy>
	</xsl:template>
	
	<!-- calculate and add relationship connection go -->
	<xsl:template match="auxiliary:GraphMetaData">
		<xsl:copy>
			<xsl:apply-templates select="@*"/>
			<xsl:apply-templates select="*"/>
			<xsl:variable name="x1">
				<xsl:choose>
					<xsl:when test="graphmetadata:Node[@id='Group_go']/@x">
						<xsl:value-of select="graphmetadata:Node[@id='Group_go']/@x"/>
					</xsl:when>
					<xsl:otherwise>0</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="y1">
				<xsl:choose>
					<xsl:when test="graphmetadata:Node[@id='Group_go']/@y">
						<xsl:value-of select="graphmetadata:Node[@id='Group_go']/@y"/>
					</xsl:when>
					<xsl:otherwise>0</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="x2">
				<xsl:choose>
					<xsl:when test="graphmetadata:Node[@id='SiteView_go']/@x">
						<xsl:value-of select="graphmetadata:Node[@id='SiteView_go']/@x"/>
					</xsl:when>
					<xsl:otherwise>0</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="y2">
				<xsl:choose>
					<xsl:when test="graphmetadata:Node[@id='SiteView_go']/@y">
						<xsl:value-of select="graphmetadata:Node[@id='SiteView_go']/@y"/>
					</xsl:when>
					<xsl:otherwise>0</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<graphmetadata:Connection element="Group2Module" id="Group2Module_go" x="{($x1 + $x2) div 2 + ($y2 - $y1) div 4}"
				y="{($y1 + $y2) div 2 + ($x2 - $x1) div 4}"/>
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