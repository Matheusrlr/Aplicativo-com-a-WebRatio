<?xml version="1.0"?> 

<!-- ============================================================= -->
<!-- included attributes                                      	   -->
<!--                                                               -->
<!--   lists included attributes exposed by this unit              -->
<!--                                                               -->
<!--   Version X.Y (MMM DD YYYY)                                   -->
<!-- ============================================================= -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
			    xmlns:saxon="http://icl.com/saxon"
                xmlns:layout="http://www.webml.org/layout"
                exclude-result-prefixes="saxon"
                version="1.0">
 
  <xsl:key name="id" match="*" use="@id"/>
 
  <!-- ========================================================= -->
  <!-- DEFAULT RULE                                              -->
  <!-- ========================================================= -->  
   <xsl:template match="*" mode="included-attributes" priority="-20">
      <xsl:if test="string(@entity) != ''">
        <layout:displayed-entity id="@entity">
          <xsl:choose>
            <xsl:when test="DISPLAYALL">
              <xsl:variable name="all-attrs">
                <xsl:apply-templates select="key('id', @entity)" mode="isa"/>
              </xsl:variable>  
              <xsl:for-each select="key('id', saxon:tokenize($all-attrs))">
                <layout:included-attribute id="{@id}"/>
              </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
              <xsl:for-each select="DISPLAYATTRIBUTE">
                <layout:included-attribute id="{@attribute}"/> 
              </xsl:for-each>
            </xsl:otherwise>
          </xsl:choose>  
        </layout:displayed-entity>  
      </xsl:if>
      <xsl:apply-templates select="*" mode="included-attributes"/>
  </xsl:template>
  
  
  <xsl:template match="ENTITY" mode="isa">
      <xsl:for-each select="ATTRIBUTE[not(@type='OID')]">
        <xsl:value-of select="concat(' ',@id )"/>
      </xsl:for-each>
      <xsl:apply-templates select="key('id', @superEntity)" mode="isa"/>
  </xsl:template>
 
   

</xsl:stylesheet>