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
                exclude-result-prefixes="saxon layout"
                version="1.0">
	
	<xsl:output indent="yes" method="xml" encoding="ISO-8859-1" doctype-system="WebML.dtd"/>
    
    <xsl:include href="Old/util.xsl"/>   
    <xsl:include href="Old/included-attributes.xsl"/>   
    <xsl:include href="Old/fields.xsl"/>   
    <xsl:include href="Old/EntryUnit/fields.xsl"/>   
    <xsl:include href="Old/MultiChoiceIndexUnit/fields.xsl"/>   
    <xsl:include href="Old/MultiEntryUnit/fields.xsl"/>   
    
   
	<xsl:key name="set-unit" match="SETUNIT" use="@id"/>
	
	
	<!-- ========================================================= -->
	<!-- NEW SET/GET unit (multiple parameters)                    -->
	<!-- ========================================================= -->
	
	<!-- convert the GETUNIT outgoing link parameter -->
	<xsl:template match="GETUNIT/LINK/LINKPARAMETER">
		<xsl:copy>
			<xsl:apply-templates select="@*[not (self::source)]"/>
			<xsl:attribute name="source">
				<xsl:value-of select="concat(ancestor::GETUNIT/@id,'.',ancestor::GETUNIT/@globalParameter)"/>
			</xsl:attribute>
			<xsl:apply-templates select="*|comment()| processing-instruction()|text()"/>
		</xsl:copy>
	</xsl:template>
	
	
	<!-- convert the SETUNIT incoming link parameter -->
	<xsl:template match="LINK[key('set-unit',@to)/self::SETUNIT]/LINKPARAMETER">
		<xsl:variable name="to" select="../@to"/>
		<xsl:copy>
			<xsl:apply-templates select="@*[not (self::target)]"/>
			<xsl:attribute name="target">
				<xsl:value-of select="concat(key('set-unit',$to)/@id,'.',key('set-unit',$to)/@globalParameter)"/>
			</xsl:attribute>
			<xsl:apply-templates select="*|comment()| processing-instruction()|text()"/>
		</xsl:copy>
	</xsl:template>
	
	
	<!-- ========================================================= -->
	<!-- presentation:unit                                         -->
	<!-- ========================================================= -->
	<xsl:template match="presentation:unit">
      
      
      
		
		<xsl:variable name="pres-attributes">
			<xsl:copy-of select="presentation:attribute"/>
		</xsl:variable>
		<xsl:variable name="pres-fields">
			<xsl:copy-of select="presentation:field"/>
		</xsl:variable>
		<xsl:variable name="pres-links">
			<xsl:copy-of select="presentation:link"/>
		</xsl:variable>
        
      <xsl:copy>
         <xsl:apply-templates select="@*"/>
         
         <xsl:if test="string(@shown-attributes) != ''">
            <xsl:attribute name="show-attributes-manually">yes</xsl:attribute>
         </xsl:if>
         
         <xsl:if test="string(@shown-fields) != ''">
            <xsl:attribute name="show-fields-manually">yes</xsl:attribute>
         </xsl:if>
         
         <xsl:if test="string(@shown-links) != ''">
            <xsl:attribute name="show-links-manually">yes</xsl:attribute>
         </xsl:if>
         
         <xsl:apply-templates select="*"/>

         <!-- presentation attributes -->
         <xsl:variable name="temp-attrs">
            <xsl:choose>
               <xsl:when test="string(@shown-attributes) != ''">
                  <xsl:for-each select="saxon:tokenize(@shown-attributes)">
                     <xsl:variable name="id" select="."/>
                     <presentation:attribute attribute="{$id}">
                        <xsl:copy-of select="saxon:node-set($pres-attributes)/*[@attribute = $id]/@*"/>
                     </presentation:attribute>
                  </xsl:for-each>
               </xsl:when>
               <xsl:otherwise>
                  <!-- retrieve all unit-included-attributes -->
                  <xsl:variable name="atts">
                     <xsl:apply-templates select="key('id', @element)" mode="included-attributes"/>
                  </xsl:variable>
                  <xsl:for-each select="saxon:node-set($atts)//layout:included-attribute">
                     <xsl:variable name="attrID" select="@id"/>
                     <presentation:attribute attribute="{@id}">
                        <xsl:copy-of select="saxon:node-set($pres-attributes)/*[@attribute = $attrID]/@*"/>
                     </presentation:attribute>
                  </xsl:for-each>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:variable>
         
         <xsl:for-each select="saxon:node-set($temp-attrs)/*">
            <xsl:variable name="attrID" select="@attribute"/>
            <xsl:if test="not(preceding-sibling::*[@attribute = $attrID])">
               <xsl:copy-of select="."/>
            </xsl:if>
         </xsl:for-each>
         
         <!-- presentation fields -->
         <xsl:choose>
            <xsl:when test="string(@shown-fields) != ''">
               <xsl:for-each select="saxon:tokenize(@shown-fields)">
                  <xsl:variable name="id" select="."/>
                  <presentation:field field="{$id}">
                     <xsl:copy-of select="saxon:node-set($pres-fields)/*[@field = $id]/@*"/>
                  </presentation:field>
               </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
               <!-- retrieve all unit-included-attributes -->
               <xsl:variable name="fields">
                  <xsl:apply-templates select="key('id', @element)" mode="fields"/>
               </xsl:variable>
               <xsl:for-each select="saxon:node-set($fields)//layout:field[string(@hidden) != 'yes' and string(@field) != '']">
                  <xsl:variable name="fieldID" select="@field"/>
                  <presentation:field field="{$fieldID}">
                     <xsl:copy-of select="saxon:node-set($pres-fields)/*[@field = $fieldID]/@*"/>
                  </presentation:field>
               </xsl:for-each>
            </xsl:otherwise>
         </xsl:choose>
         
         <!-- presentation links -->
         <xsl:choose>
            <xsl:when test="string(@shown-links) != ''">
               <xsl:for-each select="saxon:tokenize(@shown-links)">
                  <xsl:variable name="id" select="."/>
                  <presentation:link link="{$id}">
                     <xsl:copy-of select="saxon:node-set($pres-links)/*[@link = $id]/@*"/>
                  </presentation:link>
               </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
               <xsl:for-each select="key('id', @element)/LINK[@type != 'transport']">
                  <xsl:variable name="linkID" select="@id"/>
                  <presentation:link link="{@id}">
                     <xsl:copy-of select="saxon:node-set($pres-links)/*[@link = $linkID]/@*"/>
                  </presentation:link>
               </xsl:for-each>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:copy>
	</xsl:template>
	

    <!-- ========================================================= -->
    <!-- Discard old attributes and presentation elements          -->
    <!-- ========================================================= --> 
    <xsl:template match="presentation:unit/@shown-attributes"/>  
    <xsl:template match="presentation:unit/@shown-fields"/>  
    <xsl:template match="presentation:unit/@shown-links"/>  
	
	<xsl:template match="presentation:unit/presentation:attribute"/>  
    <xsl:template match="presentation:unit/presentation:field"/>  
    <xsl:template match="presentation:unit/presentation:link"/>  
	
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