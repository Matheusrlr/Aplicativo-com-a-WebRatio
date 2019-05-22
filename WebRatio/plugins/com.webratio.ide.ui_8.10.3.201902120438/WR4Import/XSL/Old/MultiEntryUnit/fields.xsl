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
  
  <!-- ========================================================= -->
  <!-- ENTRYUNIT                                                 -->
  <!-- ========================================================= -->
  <xsl:template match="MULTIENTRYUNIT" mode="fields">
    <xsl:apply-templates select="FIELD|SELECTIONFIELD" mode="fieldType"/>
    <layout:field beanid="{@id}DataSize" beantype="java.lang.Integer"/>
	<layout:field beanid="{@id}Checked" beantype="String[]"/>  
    <layout:field beanid="{@id}" beantype="com.webratio.webml.rtx.RTXBeanInterface[]"/>
  </xsl:template>
  
  <xsl:template match="MULTIENTRYUNIT/FIELD[@type='BLOB']" mode="fieldType" priority="200">
    <layout:field beanid="{@id}" beantype="org.apache.web.mvc.upload.FormFile" preloadProperty="" preloadBean="" field="{@id}" nested="yes" indexed-property="{../@id}">
      <xsl:copy-of select="@*"/>
      <xsl:copy-of select="*"/>
    </layout:field>
    <layout:field beanid="{@id}_preload" name="{@name}_preload" hidden="yes" beantype="java.lang.Object" cardinality="{@cardinality}" preloadProperty="" preloadBean="" nested="yes" indexed-property="{../@id}"/>
    <layout:field beanid="{@id}_clear" name="{@name}_clear" hidden="no" beantype="String" cardinality="{@cardinality}" preloadProperty="" preloadBean="" nested="yes" indexed-property="{../@id}"/>
  </xsl:template>

  <xsl:template match="MULTIENTRYUNIT/SELECTIONFIELD" mode="fieldType" priority="100">
    <layout:field beanid="{@id}" beantype="String" preloadProperty="" preloadBean="" field="{@id}" nested="yes" indexed-property="{../@id}">
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


  <!-- default rule -->
  <xsl:template match="MULTIENTRYUNIT/FIELD" mode="fieldType" priority="100">
    <layout:field beanid="{@id}" beantype="String" preloadProperty="" preloadBean="" field="{@id}" nested="yes" indexed-property="{../@id}">
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
