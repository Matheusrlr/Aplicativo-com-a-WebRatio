<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:saxon="http://icl.com/saxon"
	xmlns:stringutils="java:org.apache.commons.lang.StringUtils"
	extension-element-prefixes="saxon"
	exclude-result-prefixes="saxon stringutils"
	version="1.0">

  <xsl:output method="xml" indent="yes" encoding="UTF-8"/>

  <xsl:template match="/">
    <topic href="html/reference/{stringutils:replace(/doc/@title, ' ', '_')}">
     <xsl:attribute name="label">
       <xsl:value-of select="/doc/@title"/>
     </xsl:attribute>
     <xsl:for-each select="/doc/s1">
       <topic href="{stringutils:replace(../@title, ' ', '_')}/{stringutils:replace(@title, ' ', '_')}.html">
         <xsl:attribute name="label">
           <xsl:value-of select="@title"/>
         </xsl:attribute>
       </topic>
     </xsl:for-each>
    </topic>
  </xsl:template>
</xsl:stylesheet>