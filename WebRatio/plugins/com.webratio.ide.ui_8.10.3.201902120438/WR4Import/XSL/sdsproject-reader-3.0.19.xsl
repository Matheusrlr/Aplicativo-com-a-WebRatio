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
	
	
	<!-- ========================================================================================= -->
	<!-- ======== Add Duration attribute if it is not present on entity structure element ======== -->
	<!-- ========================================================================================= -->	
	<xsl:template match="ENTITY[not(@duration)]">
        <ENTITY>
            <xsl:attribute name="duration">persistent</xsl:attribute>
            <xsl:apply-templates select="@*"/>
		    <xsl:apply-templates select="*"/>
        </ENTITY>
  </xsl:template>
  
  
  <!-- ========================================================================================= -->
	<!-- ========       Remove useless name attribute to the presentation fields          ======== -->
	<!-- ========================================================================================= -->	
  <xsl:template match="presentation:field/@name">
  </xsl:template>

	<!-- ========================================================================================= -->
	<!-- ======== WSUNIT ========================================================================= -->
	<!-- ========================================================================================= -->	
	<xsl:template match="WSUNIT">
	  <REQUESTRESPONSEUNIT>
	    <xsl:if test="not(@endpointType)">
	      <xsl:attribute name="endpointType">static</xsl:attribute>
	    </xsl:if>
        <xsl:apply-templates select="@*"/>
        <xsl:apply-templates select="*"/>
	  </REQUESTRESPONSEUNIT>
	</xsl:template>
		
	<xsl:template match="WSUNIT/@inputType">
		<xsl:choose>
			<xsl:when test=". = 'none'">
				<xsl:attribute name="inputType">none</xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<xsl:attribute name="inputType">document</xsl:attribute>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="WSUNIT/@soapBodyTemplate">
    <xsl:if test=". != ''">
      <xsl:attribute name="inputXSLFile"><xsl:value-of select="."/></xsl:attribute>
    </xsl:if>
	</xsl:template>

	<!-- ========================================================================================= -->
	<!-- ======== ONEWWAYUNIT ==================================================================== -->
	<!-- ========================================================================================= -->	
	<xsl:template match="ONEWAYUNIT">
	  <ONEWAYUNIT>
	    <xsl:if test="not(@endpointType)">
	      <xsl:attribute name="endpointType">static</xsl:attribute>
	    </xsl:if>
        <xsl:apply-templates select="@*"/>
        <xsl:apply-templates select="*"/>
	  </ONEWAYUNIT>
	</xsl:template>

	<xsl:template match="ONEWAYUNIT/@inputType">
		<xsl:choose>
			<xsl:when test=". = 'none'">
				<xsl:attribute name="inputType">none</xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<xsl:attribute name="inputType">document</xsl:attribute>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="ONEWAYUNIT/@soapBodyTemplate">
    <xsl:if test=". != ''">
      <xsl:attribute name="inputXSLFile"><xsl:value-of select="."/></xsl:attribute>
    </xsl:if>
	</xsl:template>

	<!-- ========================================================================================= -->
	<!-- ======== GETXMLUNIT ===================================================================== -->
	<!-- ========================================================================================= -->	
	<xsl:template match="GETXMLUNIT/@SourceType">
    <xsl:attribute name="sourceType"><xsl:value-of select="."/></xsl:attribute>
	</xsl:template>

	<xsl:template match="GETXMLUNIT/@InputType">
      <xsl:attribute name="urlType"><xsl:value-of select="."/></xsl:attribute>
	</xsl:template>

	<!-- ========================================================================================= -->
	<!-- ======== XSLUNIT ======================================================================== -->
	<!-- ========================================================================================= -->	
	<xsl:template match="XSLUNIT">
	  <ADAPTERUNIT>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates select="*"/>
	  </ADAPTERUNIT>
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
