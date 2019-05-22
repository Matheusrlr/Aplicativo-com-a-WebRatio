<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:saxon="http://icl.com/saxon"
	extension-element-prefixes="saxon"
	exclude-result-prefixes="saxon"
	version="1.0">

  <xsl:output method="html" indent="yes" encoding="UTF-8"/>
  
  <xsl:param name="s1Title"/>
  
  <xsl:template match="/">
    <xsl:apply-templates select="/doc/s1[@title = $s1Title]"/>
  </xsl:template>

  <xsl:template match="s1">
    <html>
      <head>
        <meta name="author" content="{/doc/@authors}"/>
        <link rel="stylesheet" type="text/css" href="../book.css"/>
        <link rel="stylesheet" type="text/css" href="../schema.css"/>
        <title><xsl:value-of select="@title"/></title>
      </head>
      <body>
        <h1><center><xsl:value-of select="@title"/></center></h1>
         <p>
          <xsl:apply-templates />
          <xsl:if test="ul">
          	    <xsl:apply-templates select="ul"/>
          </xsl:if>
         </p> 
      </body>
    </html>
  </xsl:template>
  
  
  <xsl:template match="s2">
	<h6 class="CaptionFigColumn" id="header"><xsl:value-of select="@title"/></h6>
	<p>
     <xsl:apply-templates />
	</p>
  </xsl:template>
  
  <xsl:template match="s3">
   <ul>
    <li>
	 <h6 class="CaptionFigColumn" id="header"><xsl:value-of select="@title"/></h6>
	 <p>
      <xsl:apply-templates />
	 </p>
	</li>
   </ul>
  </xsl:template>  
  
  <xsl:template match="s4">
   <ul>
    <li>
	 <h6 class="CaptionFigColumn" id="header"><xsl:value-of select="@title"/></h6>
	 <p>
      <xsl:apply-templates />
	 </p>
	</li>
   </ul>
  </xsl:template> 
  
  <xsl:template match="ul">
   <ul>
    <xsl:for-each select="li">
    <li>
      <xsl:apply-templates />
	</li>
	</xsl:for-each>
   </ul>
  </xsl:template> 
  

  <xsl:template match="table">
    <p>
  	<table style="text-align: left;" border="1"  cellpadding="2" cellspacing="0">
  	 <col width="200">
	 <tr>
	   <xsl:for-each select="header/cell">
	    <td style="vertical-align: top; font-weight: bold;"><xsl:apply-templates select="*|text()" /></td>
	   </xsl:for-each>
	 </tr>
	 </col>
	 <col width="500">
	   <xsl:for-each select="row">
	     <tr>
	        <xsl:for-each select="cell">
	          <xsl:choose>
	            <xsl:when test="(normalize-space(text()) = '') and (count(*) = 0)">
	              <td style="vertical-align: top;">&#160;</td>
	            </xsl:when>
	            <xsl:otherwise>
	              <td style="vertical-align: top;"><xsl:apply-templates select="*|text()" /></td>
	            </xsl:otherwise>
	          </xsl:choose>
	        </xsl:for-each>
	     </tr>
	   </xsl:for-each>
	  </col>
  	</table>
  	</p>
</xsl:template>	

</xsl:stylesheet>