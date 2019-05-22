<?xml version="1.0"?>

<!-- ============================================================= -->
<!-- fields                                                  -->
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
	
  <xsl:variable name="upperchars" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
  <xsl:variable name="lowerchars" select="'abcdefghijklmnopqrstuvwxyz'"/>
  		
  
  <!-- ========================================================= -->
  <!-- ENTRYUNIT                                                 -->
  <!-- ========================================================= -->
  <xsl:template match="ENTRYUNIT" mode="fields">
    <xsl:apply-templates select="FIELD | SELECTIONFIELD | MULTISELECTIONFIELD" mode="fieldType"/>
  </xsl:template>
  
   <xsl:template match="FIELD[@type='BLOB']" mode="fieldType">
    <layout:field beanid="{@id}" beantype="FormFile" preloadProperty="" preloadBean="" field="{@id}">
      <xsl:copy-of select="@*"/>
      <xsl:copy-of select="*"/>
    </layout:field>
    <layout:field beanid="{@id}_preload" name="{@name}_preload" hidden="yes" beantype="java.lang.Object" cardinality="{@cardinality}" preloadProperty="" preloadBean=""/>
    <layout:field beanid="{@id}_clear" name="{@name}_clear" hidden="no" beantype="String" cardinality="{@cardinality}" preloadProperty="" preloadBean=""/>
  </xsl:template>

  <xsl:template match="SELECTIONFIELD" mode="fieldType">
    <layout:field beanid="{@id}" beantype="String" preloadProperty="" preloadBean="" field="{@id}">
      <xsl:copy-of select="@*"/>
      <xsl:if test="string(@subType) != ''">
		  <xsl:attribute name="pattern">
			  <xsl:value-of select="translate(key('id',@subType)/@name, $upperchars, $lowerchars)"/>
		  </xsl:attribute>
	  </xsl:if>		  
      <xsl:copy-of select="*"/>
    </layout:field>
    <layout:field beanid="{@id}List" name="{@name}List" hidden="{@hidden}" beantype="String[]" cardinality="{@cardinality}" preloadProperty="" preloadBean=""/>
    <layout:field beanid="{@id}LabelList" name="{@name}LabelList" hidden="{@hidden}" beantype="String[]" cardinality="{@cardinality}" preloadProperty="" preloadBean=""/>
  </xsl:template>

  <xsl:template match="MULTISELECTIONFIELD" mode="fieldType">
    <layout:field beanid="{@id}List" name="{@name}List" hidden="{@hidden}" beantype="com.webratio.webml.rtx.core.beans.ValueBean[]" cardinality="{@cardinality}" preloadProperty="" preloadBean=""/>
    <layout:field beanid="{@id}" beantype="String[]" preloadProperty="" preloadBean="" field="{@id}">
        <xsl:copy-of select="@*"/>
	    <xsl:if test="string(@subType) != ''">
		  <xsl:attribute name="pattern">
			  <xsl:value-of select="translate(key('id',@subType)/@name, $upperchars, $lowerchars)"/>
		  </xsl:attribute>
	    </xsl:if>	
        <xsl:copy-of select="*"/>
    </layout:field>
  </xsl:template>

  <!-- default rule -->

  <xsl:template match="FIELD" mode="fieldType">
    <layout:field beanid="{@id}" beantype="String" preloadProperty="" preloadBean="" field="{@id}">
      <xsl:copy-of select="@*"/>
	  <xsl:if test="string(@subType) != ''">
		  <xsl:attribute name="pattern">
			  <xsl:value-of select="translate(key('id',@subType)/@name, $upperchars, $lowerchars)"/>
		  </xsl:attribute>
	  </xsl:if>	
      <xsl:copy-of select="*"/>
    </layout:field>
  </xsl:template>

</xsl:stylesheet>
