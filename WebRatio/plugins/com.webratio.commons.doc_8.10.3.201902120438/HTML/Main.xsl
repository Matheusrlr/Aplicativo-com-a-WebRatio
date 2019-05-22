<?xml version="1.0"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:saxon="http://icl.com/saxon"  
    extension-element-prefixes="saxon"
    version="1.0">

  <xsl:output method="html" indent="yes" />
  
  <xsl:key name="id" match="*" use="@id"/>
	
  <xsl:template match="/">
    <html>
      <head>
        <meta name="author" content="{/doc/@authors}"/>
        <title><xsl:value-of select="/doc/@title"/></title>
      </head>
      <body>
        <xsl:apply-templates select="/doc"/>
        <xsl:apply-templates select="/doc/s1"/>
      </body>
    </html>
  </xsl:template>
  
  <xsl:template match="doc">
    <div align="center" id="doc">
      <img src="Images/WRBanner.png" width="40%"/>
      <br/>
      <br/>
      <hr style="border: 0; width: 50%;"/>
      <h1><xsl:value-of select="@title"/></h1>
      <h2><xsl:value-of select="@subTitle"/></h2>
      <hr style="border: 0; width: 50%;"/>
      <h3><xsl:value-of select="@authors"/></h3>
      <!--
      <h4>
      <xsl:value-of select="java:format(java:java.text.SimpleDateFormat.new('dd/MM/yyyy'), java:java.util.Date.new())"/>
      </h4>
      -->
    </div>
  </xsl:template>

  <xsl:template match="s1">
    <xsl:apply-templates select="." mode="internal-anchor"/>
    <div id="s1">
      <hr style="border: 0; width: 100%;"/>
      <h1><xsl:apply-templates select="." mode="number"/><xsl:text> </xsl:text><xsl:value-of select="@title"/></h1>
      <xsl:apply-templates select="s2|p|img|anchorSet"/>
    </div>
  </xsl:template>

  <xsl:template match="s2">
    <xsl:apply-templates select="." mode="internal-anchor"/>
    <div id="s2">
      <h2><xsl:apply-templates select="." mode="number"/><xsl:text> </xsl:text><xsl:value-of select="@title"/></h2>
      <xsl:apply-templates select="s3|p|img|anchorSet"/>
    </div>
  </xsl:template>

  <xsl:template match="s3">
    <xsl:apply-templates select="." mode="internal-anchor"/>
    <div id="s3">
      <h3><xsl:apply-templates select="." mode="number"/><xsl:text> </xsl:text><xsl:value-of select="@title"/></h3>
      <xsl:apply-templates select="s4|p|img|anchorSet"/>
    </div>
  </xsl:template>

  <xsl:template match="s4">
    <xsl:apply-templates select="." mode="internal-anchor"/>
    <div id="s4">
      <h4><xsl:apply-templates select="." mode="number"/><xsl:text> </xsl:text><xsl:value-of select="@title"/></h4>
      <xsl:apply-templates select="p|img|anchorSet"/>
    </div>
  </xsl:template>
  
  <xsl:template match="p">
    <p><xsl:apply-templates select="text()|i|b|note|img|a|ul|ol|li|table|source|code"/></p>
  </xsl:template>

  <xsl:template match="anchorSet">
    <p>
      <span style="font-weight: bold;"><xsl:apply-templates select="@title"/></span>
    </p>
    <p>
      <ul>
        <xsl:for-each select="a">
          <li><xsl:apply-templates select="."/></li>
        </xsl:for-each>
      </ul>
    </p>
  </xsl:template>
  
  <xsl:template match="note">
  	<span style="font-style: italic;"><xsl:apply-templates select="text()"/></span>
  </xsl:template>
  
  <xsl:template match="i">
    <span style="font-style: italic;"><xsl:apply-templates select="text()"/></span>
  </xsl:template>
  
  <xsl:template match="b">
    <span style="font-weight: bold;"><xsl:apply-templates select="text()"/></span>
  </xsl:template>
  
  <xsl:template match="img">
    <img src="{@src}" border="0">
      <xsl:if test="string(@alt) != ''">
        <xsl:attribute name="alt"><xsl:value-of select="@alt"/></xsl:attribute>
      </xsl:if>
    </img>
  </xsl:template>
  


  <xsl:template match="s1/img | s2/img | s3/img | s4/img">
    <xsl:apply-templates select="." mode="internal-anchor"/>
	<table width="100%">
	  <tr>
		<td>
	     <div>
		  <table>
		   <xsl:attribute name="align">
	        <xsl:choose>
	          <xsl:when test="@alignment = 'right'">right</xsl:when>
	          <xsl:when test="@alignment = 'left'">left</xsl:when>
	          <xsl:otherwise>center</xsl:otherwise>
	        </xsl:choose>
	       </xsl:attribute>
		   <tr>
		   <td>
		    <p>
	         <img src="{@src}">
	          <xsl:if test="string(@alt) != ''">
	           <xsl:attribute name="alt"><xsl:value-of select="@alt"/></xsl:attribute>
	          </xsl:if>
	         </img>
	        </p>
            <p style="text-align: center; font-weight: bold;">Figure <xsl:apply-templates select="." mode="number"/>
              <xsl:if test="@caption != ''">
                <xsl:text> - </xsl:text>
                <xsl:value-of select="@caption"/>
              </xsl:if>
            </p>
          </td>
         </tr>
        </table>
      </div>
	</td>
   </tr>
</table>
	
  </xsl:template>
  
  <xsl:template match="ul">
    <ul><xsl:apply-templates/></ul>
  </xsl:template>
  
  <xsl:template match="ol">
    <ol><xsl:apply-templates/></ol>
  </xsl:template>  
  
  <xsl:template match="li">
    <li><xsl:apply-templates/></li>
  </xsl:template>
  
  <xsl:template match="source">
    <pre><xsl:apply-templates/></pre>
  </xsl:template>
  
  <xsl:template match="code">
    <code><xsl:apply-templates/></code>
  </xsl:template>
  
  <xsl:template match="table">
  	<!-- TODO WIDTHS -->
    <table cellspan="0px" cellpadding="0px"><xsl:apply-templates/></table>
  </xsl:template>
  
  <xsl:template match="header">
    <tr><xsl:apply-templates/></tr>
  </xsl:template>
  
  <xsl:template match="row">
    <tr><xsl:apply-templates/></tr>
  </xsl:template>

  <xsl:template match="header/cell">
    <td style="border: solid 2px black"><xsl:apply-templates/></td>
  </xsl:template>

  <xsl:template match="cell[not(*) and normalize-space(text()) = '']">
    <td style="border: solid 1px black">&#160;</td>
  </xsl:template>
  
  <xsl:template match="cell">
    <td style="border: solid 1px black"><xsl:apply-templates/></td>
  </xsl:template>
  
  <xsl:template match="a">
    <xsl:choose>
      <xsl:when test="starts-with(@href, '#') and (text() != '' or img)">
        <a href="{@href}"><xsl:apply-templates select="text()|img"/></a>
      </xsl:when>
      <xsl:when test="starts-with(@href, '#')">
        <a href="{@href}"><xsl:apply-templates select="key('id', substring(@href, 2))" mode="anchor-label"/></a>
      </xsl:when>
      <xsl:otherwise>
        <a href="{@href}"><xsl:apply-templates select="text()|img"/></a>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="*" mode="number"/>
  
  <xsl:template match="s1|s2|s3|s4" mode="number">
    <xsl:apply-templates select=".." mode="number"/>
    <xsl:number/>
    <xsl:text>.</xsl:text>
  </xsl:template>

  <xsl:template match="img" mode="number">
    <xsl:apply-templates select="ancestor::s1" mode="number"/>
    <xsl:variable name="src" select="@src"/>
    <xsl:for-each select="ancestor::s1//img[parent::s1 or parent::s2 or parent::s3 or parent::s4]">
      <xsl:if test="@src = $src"><xsl:value-of select="position()"/></xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="*" mode="internal-anchor">
    <xsl:if test="string(@id) != ''">
      <a name="{@id}"><xsl:comment> </xsl:comment></a>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="*" mode="anchor-label">
	<xsl:choose>
		<xsl:when test="self::s1" >Chapter </xsl:when>
    	<xsl:when test="self::s2 or self::s3 or self::s4">Section </xsl:when>
    </xsl:choose>
    <xsl:variable name="number">
      <xsl:apply-templates select="." mode="number"/>
    </xsl:variable>
    <xsl:value-of select="substring($number, 1, string-length($number) - 1)"/>
  </xsl:template>
  
  <xsl:template match="img" mode="anchor-label">
    <xsl:text>Figure </xsl:text>
    <xsl:apply-templates select="." mode="number"/>
  </xsl:template>
  
</xsl:stylesheet>