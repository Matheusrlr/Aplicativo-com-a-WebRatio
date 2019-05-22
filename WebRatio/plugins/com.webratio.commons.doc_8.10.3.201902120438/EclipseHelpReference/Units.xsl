<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:saxon="http://icl.com/saxon"
	xmlns:stringutils="java:org.apache.commons.lang.StringUtils"
	exclude-result-prefixes="saxon stringutils"
	version="1.0">

  <xsl:output method="html" indent="yes" encoding="UTF-8"/>

  <xsl:template match="/">
    <html>
      <head>
        <meta name="author" content="{/doc/@authors}"/>
        <link rel="stylesheet" type="text/css" href="book.css"/>
        <title><xsl:value-of select="/doc/@title"/></title>
      </head>
      <body>
        <h1><xsl:value-of select="/doc/@title"/></h1>
         <ul>
          <xsl:apply-templates select="/doc/s1"/>
         </ul>
      </body>
    </html>
  </xsl:template>
  
  <xsl:template match="s1">
    <li><a href="{stringutils:replace(../@title, ' ', '_')}/{stringutils:replace(@title, ' ', '_')}.html"><xsl:value-of select="@title"/></a></li>
  </xsl:template>

</xsl:stylesheet>