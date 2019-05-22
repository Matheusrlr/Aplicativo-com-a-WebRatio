<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:saxon="http://icl.com/saxon"
	xmlns:map="java:java.util.Map"
	xmlns:file="java:java.io.File"
	xmlns:stringUtils="java:org.apache.commons.lang.StringUtils"
	extension-element-prefixes="saxon"
	exclude-result-prefixes="saxon map file stringUtils"
	version="1.0">

  <xsl:output method="html" indent="yes" encoding="UTF-8"/>
  
  <xsl:param name="inputPath"/>
  <xsl:param name="pathToRoot"/>
  <xsl:param name="validPaths"/>
  
  <xsl:template match="/">
    <xsl:apply-templates select="/doc/s1[1]"/>
    <xsl:if test="count(/doc/s1) &gt; 1">
      <echo>Warning: more than one &lt;s1&gt;</echo>
    </xsl:if>
  </xsl:template>

	<xsl:template match="doc/img">
		<xsl:apply-templates select="s1"/>
	</xsl:template>

  
  <xsl:template match="s1">
    <xsl:variable name="title">
      <xsl:choose>
        <xsl:when test="string(@title) != ''"><xsl:value-of select="@title"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="../@title"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <html>
      <head>
        <meta name="author" content="{/doc/@authors}"/>
        <link rel="stylesheet" type="text/css" href="{$pathToRoot}book.css"/>
        <link rel="stylesheet" type="text/css" href="{$pathToRoot}schema.css"/>
        <script language="JavaScript" src="PLUGINS_ROOT/org.eclipse.help/livehelp.js"></script>
        <script language="JavaScript" src="PLUGINS_ROOT/org.eclipse.help.webapp/advanced/contentActions.js"></script>
        <title><xsl:value-of select="$title"/></title>
      </head>
      <body>
      	<center>
      	  <xsl:choose>
	     	<xsl:when test="ancestor::doc/img">
	     	  <xsl:variable name="src">
	     	  	<xsl:value-of select="ancestor::doc/img/@src"/>
	     	  </xsl:variable>
	     	  <table border="0">
	     	  	<tr>
	     	  		<td valign="middle">
			     		<img border="0">
					      <xsl:attribute name="src">
					      	<xsl:choose>
					      		<xsl:when test="starts-with($src, '/')">
					      			<xsl:value-of select="concat(substring-after($pathToRoot, '../'), substring-after($src, '/'))"/>
					      		</xsl:when>
					      		<xsl:when test="starts-with($src, 'PLUGIN_ID=')">
					      			<xsl:value-of select="concat(substring-after($pathToRoot, '../'), 'Images/', substring-after($src, 'PLUGIN_ID='))"/>
					      		</xsl:when>
					      		<xsl:otherwise>
					      			<xsl:value-of select="$src"/>
					      		</xsl:otherwise>
					      	</xsl:choose>
					      </xsl:attribute>
					      <xsl:if test="string(@alt) != ''">
					        <xsl:attribute name="alt"><xsl:value-of select="@alt"/></xsl:attribute>
					      </xsl:if>
					    </img>
			    	</td>
			    	<td valign="middle">
			    		<h1><xsl:value-of select="$title"/></h1>
			    	</td>
			     </tr>
			    </table>
	     	 </xsl:when>
	     	 <xsl:otherwise>
	     	 	<h1><xsl:value-of select="$title"/></h1>
	     	 </xsl:otherwise>
	     	</xsl:choose>
           </center>
        <xsl:apply-templates />
      </body>
    </html>
  </xsl:template>
  
  
  <xsl:template match="s2">
  	
  		<xsl:choose>
	     	<xsl:when test="string(@img)!=''">
	     	  <xsl:variable name="src">
	     	  	<xsl:value-of select="@img"/>
	     	  </xsl:variable>
	     	  <table border="0">
	     	  	<tr>
	     	  		<td valign="bottom">
			     		<img border="0">
					      <xsl:attribute name="src">
					      	<xsl:choose>
					      		<xsl:when test="starts-with($src, '/')">
					      			<xsl:value-of select="concat(substring-after($pathToRoot, '../'), substring-after($src, '/'))"/>
					      		</xsl:when>
					      		<xsl:when test="starts-with($src, 'PLUGIN_ID=')">
					      			<xsl:value-of select="concat(substring-after($pathToRoot, '../'), 'Images/', substring-after($src, 'PLUGIN_ID='))"/>
					      		</xsl:when>
					      		<xsl:otherwise>
					      			<xsl:value-of select="$src"/>
					      		</xsl:otherwise>
					      	</xsl:choose>
					      </xsl:attribute>
					    </img>
			    	</td>
			    	<td valign="bottom">
			    		<h2 class="CaptionFigColumn" id="header"><xsl:value-of select="@title"/></h2>
			    	</td>
			     </tr>
			    </table>
	     	 </xsl:when>
	     	 <xsl:otherwise>
	     	 	<h2 class="CaptionFigColumn" id="header"><xsl:value-of select="@title"/></h2>
	     	 </xsl:otherwise>
	     	</xsl:choose>
	<p>
     <xsl:apply-templates />
	</p>
  </xsl:template>
  
  <xsl:template match="s3">
  	<xsl:choose>
	 	<xsl:when test="string(@img)!=''">
	 	  <xsl:variable name="src">
	 	  	<xsl:value-of select="@img"/>
	 	  </xsl:variable>
	 	  <table border="0">
	 	  	<tr>
	 	  		<td valign="bottom">
		     		<img border="0">
				      <xsl:attribute name="src">
				      	<xsl:choose>
				      		<xsl:when test="starts-with($src, '/')">
				      			<xsl:value-of select="concat(substring-after($pathToRoot, '../'), substring-after($src, '/'))"/>
				      		</xsl:when>
				      		<xsl:when test="starts-with($src, 'PLUGIN_ID=')">
				      			<xsl:value-of select="concat(substring-after($pathToRoot, '../'), 'Images/', substring-after($src, 'PLUGIN_ID='))"/>
				      		</xsl:when>
				      		<xsl:otherwise>
				      			<xsl:value-of select="$src"/>
				      		</xsl:otherwise>
				      	</xsl:choose>
				      </xsl:attribute>
				    </img>
		    	</td>
		    	<td valign="bottom">
		    		<h3 class="CaptionFigColumn" id="header"><xsl:value-of select="@title"/></h3>
		    	</td>
		     </tr>
		    </table>
	 	 </xsl:when>
	 	 <xsl:otherwise>
	 	 	<h3 class="CaptionFigColumn" id="header"><xsl:value-of select="@title"/></h3>
	 	 </xsl:otherwise>
	 	</xsl:choose>
	 
	 <p>
      <xsl:apply-templates />
	 </p>
  </xsl:template>  
  
  <xsl:template match="s4">
  	 <xsl:choose>
	 	<xsl:when test="string(@img)!=''">
	 	  <xsl:variable name="src">
	 	  	<xsl:value-of select="@img"/>
	 	  </xsl:variable>
	 	  <table border="0">
	 	  	<tr>
	 	  		<td valign="bottom">
		     		<img border="0">
				      <xsl:attribute name="src">
				      	<xsl:choose>
				      		<xsl:when test="starts-with($src, '/')">
				      			<xsl:value-of select="concat(substring-after($pathToRoot, '../'), substring-after($src, '/'))"/>
				      		</xsl:when>
				      		<xsl:when test="starts-with($src, 'PLUGIN_ID=')">
				      			<xsl:value-of select="concat(substring-after($pathToRoot, '../'), 'Images/', substring-after($src, 'PLUGIN_ID='))"/>
				      		</xsl:when>
				      		<xsl:otherwise>
				      			<xsl:value-of select="$src"/>
				      		</xsl:otherwise>
				      	</xsl:choose>
				      </xsl:attribute>
				    </img>
		    	</td>
		    	<td valign="bottom">
		    		<h4 class="CaptionFigColumn" id="header"><xsl:value-of select="@title"/></h4>
		    	</td>
		     </tr>
		    </table>
	 	 </xsl:when>
	 	 <xsl:otherwise>
	 	 	<h4 class="CaptionFigColumn" id="header"><xsl:value-of select="@title"/></h4>
	 	 </xsl:otherwise>
	 	</xsl:choose>
	 
	 <p>
      <xsl:apply-templates />
	 </p>
  </xsl:template>
 
 <xsl:template match="s5">
  	 <xsl:choose>
	 	<xsl:when test="string(@img)!=''">
	 	  <xsl:variable name="src">
	 	  	<xsl:value-of select="@img"/>
	 	  </xsl:variable>
	 	  <table border="0">
	 	  	<tr>
	 	  		<td valign="bottom">
		     		<img border="0">
				      <xsl:attribute name="src">
				      	<xsl:choose>
				      		<xsl:when test="starts-with($src, '/')">
				      			<xsl:value-of select="concat(substring-after($pathToRoot, '../'), substring-after($src, '/'))"/>
				      		</xsl:when>
				      		<xsl:when test="starts-with($src, 'PLUGIN_ID=')">
				      			<xsl:value-of select="concat(substring-after($pathToRoot, '../'), 'Images/', substring-after($src, 'PLUGIN_ID='))"/>
				      		</xsl:when>
				      		<xsl:otherwise>
				      			<xsl:value-of select="$src"/>
				      		</xsl:otherwise>
				      	</xsl:choose>
				      </xsl:attribute>
				    </img>
		    	</td>
		    	<td valign="bottom">
		    		<h5 class="CaptionFigColumn" id="header"><xsl:value-of select="@title"/></h5>
		    	</td>
		     </tr>
		    </table>
	 	 </xsl:when>
	 	 <xsl:otherwise>
	 	 	<h5 class="CaptionFigColumn" id="header"><xsl:value-of select="@title"/></h5>
	 	 </xsl:otherwise>
	 	</xsl:choose>
	 
	 <p>
      <xsl:apply-templates />
	 </p>
  </xsl:template> 

  <xsl:template match="p">
    <p><xsl:apply-templates select="text()|s2|s3|s4|s5|i|b|note|svg|img|a|ul|ol|li|table|source|code|command"/></p>
  </xsl:template>

  <xsl:template match="anchorSet">
    <xsl:if test="count(a) = 0">
      <xsl:message>Empty anchorSet[title='<xsl:value-of select="@title"/>']</xsl:message>
    </xsl:if>
    <xsl:if test="count(a) &gt; 0">
	    <p>
	      <img>
	      <xsl:attribute name="src">
	      	<xsl:value-of select="concat(substring-after($pathToRoot, '../'), 'Images/Pointer.png')"/>
	      </xsl:attribute>
	      </img>
	      <strong style="color:#929292; padding-left:5"><xsl:apply-templates select="@title"/></strong>
	    </p>
	    <p>
	      <ul>
	        <xsl:for-each select="a">
	          <li style="list-style:none">
	          	<xsl:apply-templates select="."/>
	         </li>
	        </xsl:for-each>
	      </ul>
	    </p>
	</xsl:if>
  </xsl:template>
  
  <xsl:template match="note">
	<p class="Note">
   				NOTE:<xsl:apply-templates select="text()"/>
	</p>
  </xsl:template>
  
  <xsl:template match="i">
    <span style="font-style: italic;"><xsl:apply-templates select="text()"/></span>
  </xsl:template>
  
  <xsl:template match="b">
    <strong><xsl:apply-templates select="text()"/></strong>
  </xsl:template>
  
  <xsl:template match="img">
  	<img border="0">
      <xsl:attribute name="src">
      	<xsl:choose>
      		<xsl:when test="starts-with(@src, '/')">
      			<xsl:value-of select="concat(substring-after($pathToRoot, '../'), substring-after(@src, '/'))"/>
      		</xsl:when>
      		<xsl:when test="starts-with(@src, 'PLUGIN_ID=')">
      			<xsl:value-of select="concat(substring-after($pathToRoot, '../'), 'Images/', substring-after(@src, 'PLUGIN_ID='))"/>
      		</xsl:when>
      		<xsl:otherwise>
      			<xsl:value-of select="@src"/>
      		</xsl:otherwise>
      	</xsl:choose>
      </xsl:attribute>
      <xsl:if test="string(@alt) != ''">
        <xsl:attribute name="alt"><xsl:value-of select="@alt"/></xsl:attribute>
      </xsl:if>
    </img>
  </xsl:template>
  
  <xsl:template match="svg">
    <xsl:message>QUI</xsl:message>
  	<embed width="{@width}" height="{@height}" pluginspage="http://www.adobe.com/svg/viewer/install/" type="image/svg+xml">
      <xsl:attribute name="src">
      	<xsl:choose>
      		<xsl:when test="starts-with(@src, '/')">
      			<xsl:value-of select="concat(substring-after($pathToRoot, '../'), substring-after(@src, '/'))"/>
      		</xsl:when>
      		<xsl:when test="starts-with(@src, 'PLUGIN_ID=')">
      			<xsl:value-of select="concat(substring-after($pathToRoot, '../'), 'Images/', substring-after(@src, 'PLUGIN_ID='))"/>
      		</xsl:when>
      		<xsl:otherwise>
      			<xsl:value-of select="@src"/>
      		</xsl:otherwise>
      	</xsl:choose>
      </xsl:attribute>
    </embed>
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
    <pre align="left" style="{@style}"><xsl:apply-templates/></pre>
  </xsl:template>
  
  <xsl:template match="code">
    <code><xsl:apply-templates/></code>
  </xsl:template>
  
  <xsl:template match="br">
    <br/>
  </xsl:template>
  
  <xsl:template match="table">
    <xsl:variable name="width">
    	<xsl:choose>
    		<xsl:when test="string(@width) != ''">
    			<xsl:value-of select="@width"/>
    		</xsl:when>
    		<xsl:otherwise>
    			<xsl:value-of select="'100%'"/>
    		</xsl:otherwise>
    	</xsl:choose>
    </xsl:variable>
  	<table border="0" cellspacing="0" cellpadding="5" width="{$width}">
	  	<xsl:choose>
	  		<xsl:when test="@border = 'none'">
	  			<xsl:attribute name="border">0</xsl:attribute>
	  		</xsl:when>
	  		<xsl:otherwise>
	  			<xsl:attribute name="border">1</xsl:attribute>
	  		</xsl:otherwise>
	  	</xsl:choose>
	    <xsl:apply-templates/>
    </table>
  </xsl:template>
  
  <xsl:template match="header">
    <tr>
    	<xsl:for-each select="cell">
    		<xsl:choose>
		  		<xsl:when test="div">
		  			<td colspan="{@colspan}">
		  				<xsl:variable name="borderTop">
			  				<xsl:choose>
			  					<xsl:when test="../@top = 'none'"></xsl:when>
			  					<xsl:otherwise>border-top:2px solid black;</xsl:otherwise>
			  				</xsl:choose>
		  				</xsl:variable>
		  				<div style="{$borderTop} border-bottom:2px solid black; font-weight:bold;">
		  					<p style="font-size:20px"><xsl:value-of select="div/text()"/></p>
		  				</div>
		  				<xsl:apply-templates select="anchor" />
		  			</td>
		  		</xsl:when>
		  		<xsl:otherwise>
		  			<th><p><strong><xsl:value-of select="text()"/></strong></p></th>
		  		</xsl:otherwise>
		  	</xsl:choose>
    	</xsl:for-each>
    </tr>
  </xsl:template>
  
  <xsl:template match="row">
    <tr>
    	<xsl:if test="(@style != '')">
       		<xsl:attribute name="style"><xsl:value-of select="@style"/></xsl:attribute>
       	</xsl:if>
    	<xsl:apply-templates/>
    </tr>
  </xsl:template>
  
  <xsl:template match="cell">
  			<td>
  			 	<xsl:if test="@border = 'true'">
  			 		<xsl:attribute name="style">border-bottom:2px solid black</xsl:attribute>
  			 	</xsl:if>
		   		<xsl:if test="(@alignment != '')">
		       		<xsl:attribute name="align"><xsl:value-of select="@alignment"/></xsl:attribute>
		       	</xsl:if>
		       	<xsl:if test="(@width != '')">
		       		<xsl:attribute name="width"><xsl:value-of select="@width"/></xsl:attribute>
		       	</xsl:if>
		       	<xsl:if test="(@valign != '')">
		       		<xsl:attribute name="valign"><xsl:value-of select="@valign"/></xsl:attribute>
		       	</xsl:if>
		       	<xsl:if test="(@style != '')">
		       		<xsl:attribute name="style"><xsl:value-of select="@style"/></xsl:attribute>
		       	</xsl:if>
		       	<xsl:if test="(@colspan != '')">
		       		<xsl:attribute name="colspan"><xsl:value-of select="@colspan"/></xsl:attribute>
		       	</xsl:if>
		       	<xsl:if test="(@rowspan != '')">
		       		<xsl:attribute name="rowspan"><xsl:value-of select="@rowspan"/></xsl:attribute>
		       	</xsl:if>
		       	<xsl:variable name="fontSize"><xsl:value-of select="@fontSize"/></xsl:variable>
			   <xsl:choose>
				   <xsl:when test="(normalize-space(text()) = '') and (count(*) = 0)">
				       <p>&#160;&#160;&#160;</p>
				   </xsl:when>
				   <xsl:otherwise>
				   		<xsl:choose>
				   			<xsl:when test="$fontSize != ''">
				   				<p style="font-size:{$fontSize}px"><xsl:apply-templates select="*|text()" /></p>
				   			</xsl:when>
				   			<xsl:otherwise>
				   				<p><xsl:apply-templates select="*|text()" /></p>
				   			</xsl:otherwise>
				   		</xsl:choose>
				   </xsl:otherwise>
			   </xsl:choose>
			 </td>
  </xsl:template>
  
  <xsl:template match="a">
    <xsl:choose>
	    <xsl:when test="starts-with(@href, 'http')">
	    	<a href="{@href}" target="_new">
	    	  <xsl:choose>
	    	    <xsl:when test="string(text()) != ''">
	    	      <xsl:value-of select="text()"/>
	    	    </xsl:when>
	    	    <xsl:otherwise>
                  <xsl:value-of select="@href"/>
	    	    </xsl:otherwise>
	    	  </xsl:choose>
	    	</a>
	    </xsl:when>
	    <xsl:when test="(starts-with(@href, '#')) or (starts-with(@href, 'PLUGINS_ROOT')) or (starts-with(@href, '../')) or (starts-with(@href, 'javascript'))">
	    	<a href="{@href}">
	    	  <xsl:choose>
	    	    <xsl:when test="string(text()) != ''">
	    	      <xsl:value-of select="text()"/>
	    	    </xsl:when>
	    	    <xsl:otherwise>
                  <xsl:value-of select="@href"/>
	    	    </xsl:otherwise>
	    	  </xsl:choose>
	    	</a>
	    </xsl:when>
	    <xsl:otherwise>
		    <xsl:variable name="htmlHref">
		    	<xsl:choose>
		    		<xsl:when test="contains(@href, '#')">
		    		  <xsl:choose>
		    		    <xsl:when test="starts-with(@href, '/')">
		    			   <xsl:value-of select="concat(substring-after($pathToRoot, '../') , substring-before(@href, '#') , '.html#', substring-after(@href, '#'))"/>
			    		</xsl:when>
			    		<xsl:otherwise>
			    			<xsl:value-of select="concat(substring-before(@href, '#') , '.html#', substring-after(@href, '#'))"/>
			    		</xsl:otherwise>
		    		  </xsl:choose>
		    		</xsl:when>
		    		<xsl:when test="starts-with(@href, '/')">
		    			<xsl:value-of select="concat(substring-after($pathToRoot, '../') , substring-after(@href, '/') , '.html')"/>
		    		</xsl:when>
		    		<xsl:otherwise>
		    			<xsl:value-of select="concat(@href , '.html')"/>
		    		</xsl:otherwise>
		    	</xsl:choose>
		    </xsl:variable>
		    <xsl:variable name="normalizedHtmlHref">
			    <xsl:value-of select="stringUtils:replace(string($htmlHref), '//', '/')"/>
		    </xsl:variable>
		    <xsl:variable name="refAbsolutePath">
		      <xsl:value-of select="$inputPath"/>
		      <xsl:text>/../</xsl:text>
		    	<xsl:choose>
		    		<xsl:when test="starts-with(@href, '/')">
		    			<xsl:value-of select="concat(substring-after($pathToRoot, '../') , substring-after(@href, '/'))"/>
		    		</xsl:when>
		    		<xsl:otherwise>
		    			<xsl:value-of select="@href"/>
		    		</xsl:otherwise>
		    	</xsl:choose>
		    </xsl:variable>
		    <xsl:variable name="refFile" select="file:new($refAbsolutePath)"/>
		    <xsl:variable name="key" select="file:getCanonicalPath(file:new(file:getCanonicalPath($refFile)))"/>
		    <xsl:variable name="label" select="map:get($validPaths, $key)"/>
		    <xsl:choose>
		      <xsl:when test="string($label) != ''">
		        <a href="{$normalizedHtmlHref}">
		    	  <xsl:choose>
		    	    <xsl:when test="string(text()) != ''">
		    	      <xsl:value-of select="text()"/>
		    	    </xsl:when>
		    	    <xsl:otherwise>
		              <xsl:value-of select="$label"/>
		    	    </xsl:otherwise>
		    	  </xsl:choose>
		        </a>
		      </xsl:when>
		      <xsl:otherwise>
			    <a href="{$normalizedHtmlHref}">
		    	  <xsl:choose>
		    	    <xsl:when test="string(text()) != ''">
		    	      <xsl:value-of select="text()"/>
		    	    </xsl:when>
		    	    <xsl:otherwise>
			          <xsl:value-of select="$normalizedHtmlHref"/>
		    	    </xsl:otherwise>
		    	  </xsl:choose>
			    </a>
		      </xsl:otherwise>
		    </xsl:choose>
	    </xsl:otherwise>
   </xsl:choose>
  </xsl:template>
  
  <xsl:template match="command">
    <a class="command-link" href='javascript:executeCommand("{@path}")'>
      <img src="PLUGINS_ROOT/org.eclipse.help/command_link.png" alt="{@alt}"/>  
      <b><xsl:value-of select="text()"/></b></a>
  </xsl:template>
  
  <xsl:template match="*" mode="number"/>
  
  <xsl:template match="s1|s2|s3|s4|s5" mode="number">
    <xsl:apply-templates select=".." mode="number"/>
    <xsl:number/>
    <xsl:text>.</xsl:text>
  </xsl:template>

  <xsl:template match="img" mode="number">
    <xsl:apply-templates select="ancestor::s1" mode="number"/>
    <xsl:variable name="src" select="@src"/>
    <xsl:for-each select="ancestor::s1//img[parent::s1 or parent::s2 or parent::s3 or parent::s4 or parent::s5]">
      <xsl:if test="@src = $src"><xsl:value-of select="position()"/></xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="anchor">
      <a name="{@name}"><xsl:comment> </xsl:comment></a>
  </xsl:template>
  
  <xsl:template match="*" mode="internal-anchor">
    <xsl:if test="string(@id) != ''">
      <a name="{@id}"><xsl:comment> </xsl:comment></a>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="*" mode="anchor-label">
	<xsl:choose>
		<xsl:when test="self::s1" >Chapter </xsl:when>
    	<xsl:when test="self::s2 or self::s3 or self::s4 or self::s5">Section </xsl:when>
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
