<?xml version="1.0"?> 

<!-- ============================================================= -->
<!-- util                                                          -->
<!--                                                               -->
<!--   miscellaneous utilities                                     -->
<!--                                                               -->
<!--   Version X.Y (MMM DD YYYY)                                   -->
<!-- ============================================================= -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
			    xmlns:saxon="http://icl.com/saxon"
                xmlns:auxiliary="http://www.webml.org/auxiliary"
                xmlns:logic="http://www.webml.org/logic"
                exclude-result-prefixes="saxon auxiliary logic"
                version="1.0">

  <xsl:output method="xml" indent="yes"/>


  <!-- ========================================================= -->
  <!-- Key declarations                                          -->
  <!-- ========================================================= --> 
  <xsl:key name="id" match="*" use="@id"/>
  <xsl:key name="incoming-links" match="LINK" use="@to"/>
  <xsl:key name="incoming-ok-links" match="OK-LINK" use="@to"/>
  <xsl:key name="incoming-ko-links" match="KO-LINK" use="@to"/>
  <xsl:key name="incoming-any-links" match="LINK|OK-LINK|KO-LINK" use="@to"/>

  <!-- ========================================================= -->
  <!-- Generic: shows name and identifier                        -->
  <!-- ========================================================= --> 
  <xsl:template match="*" mode="name-and-id">
    <xsl:param name="id" select="@id"/>
    <xsl:text>'</xsl:text><xsl:value-of select="key('id', $id)[1]/@name"/><xsl:text>' [id='</xsl:text><xsl:value-of select="$id"/><xsl:text>']</xsl:text>
  </xsl:template>

  <!-- ========================================================= -->
  <!-- ENTITY: returns a space-delimited list composed by the    -->
  <!-- identifier of an entity as well as its ancestors          -->
  <!-- ========================================================= --> 
  <xsl:template match="ENTITY" mode="self-and-ancestors">
    <xsl:value-of select="@id"/>
    <xsl:if test="key('id', @superEntity)">
      <xsl:value-of select="' '"/>
      <xsl:apply-templates select="key('id', @superEntity)" mode="self-and-ancestors"/>
    </xsl:if>
  </xsl:template>

  <!-- ========================================================= -->
  <!-- ENTITY: returns a space-delimited list composed by the    -->
  <!-- identifier of an entity as well as its descendants        -->
  <!-- ========================================================= --> 
  <xsl:template match="ENTITY" mode="self-and-descendants">
    <xsl:value-of select="@id"/>
    <xsl:value-of select="' '"/>
    <xsl:apply-templates select="." mode="descendants"/>
  </xsl:template>

  <!-- ========================================================= -->
  <!-- ENTITY: returns a space-delimited list composed by the    -->
  <!-- identifier of all entities having the matched entity as   -->
  <!-- ancestor                                                  -->
  <!-- ========================================================= --> 
  <xsl:template match="ENTITY" mode="descendants">
    <xsl:variable name="id" select="@id"/>
    <xsl:for-each select="../ENTITY">
      <xsl:variable name="is-ancestor">
        <xsl:apply-templates select="." mode="is-descendant">
          <xsl:with-param name="entity-id" select="$id"/>
        </xsl:apply-templates>
      </xsl:variable>
      <xsl:if test="$is-ancestor = 'yes'">
        <xsl:value-of select="@id"/>
        <xsl:value-of select="' '"/>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!-- ========================================================= -->
  <!-- ENTITY: returns yes if the matched entity is a descendant -->
  <!-- of the passed-in entity                                   -->
  <!-- ========================================================= --> 
  <xsl:template match="ENTITY" mode="is-descendant">    
    <xsl:param name="entity-id"/>
    <xsl:choose>
      <xsl:when test="key('id', @superEntity)">
        <xsl:choose>
          <xsl:when test="@superEntity = $entity-id">yes</xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="key('id', @superEntity)" mode="is-descendant">
              <xsl:with-param name="entity-id" select="$entity-id"/>
            </xsl:apply-templates>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>no</xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- ========================================================= -->
  <!-- ENTITY: returns a space-delimited list composed by the    -->
  <!-- identifiers of its attributes as well as attributes of    -->
  <!-- its ancestors; includes the OID of this entity, but       -->
  <!-- not the OIDs of ancestors                                 -->
  <!-- ========================================================= -->
  <xsl:template match="ENTITY" mode="attributes">
    <xsl:for-each select="ATTRIBUTE">
      <xsl:value-of select="concat(@id, ' ')"/>
    </xsl:for-each>
    <xsl:apply-templates select="key('id', @superEntity)[1]" mode="attributes-no-oid"/>
  </xsl:template>

  <!-- ========================================================= -->
  <!-- ENTITY: returns a space-delimited list composed by the    -->
  <!-- identifiers of its attributes as well as attributes of    -->
  <!-- its ancestors; all OIDs are included                      -->
  <!-- ========================================================= -->
  <xsl:template match="ENTITY" mode="attributes-all-oids">
    <xsl:for-each select="ATTRIBUTE">
      <xsl:value-of select="concat(@id, ' ')"/>
    </xsl:for-each>
    <xsl:apply-templates select="key('id', @superEntity)[1]" mode="attributes-all-oids"/>
  </xsl:template>

  <!-- ========================================================= -->
  <!-- ENTITY: returns a space-delimited list composed by the    -->
  <!-- identifiers of its attributes as well as attributes of    -->
  <!-- its ancestors; do not include the OIDs                    -->
  <!-- ========================================================= -->
  <xsl:template match="ENTITY" mode="attributes-no-oid">
    <xsl:for-each select="ATTRIBUTE[not(@type) or (@type != 'OID')]">
      <xsl:value-of select="concat(@id, ' ')"/>
    </xsl:for-each>
    <xsl:apply-templates select="key('id', @superEntity)[1]" mode="attributes-no-oid"/>
  </xsl:template>

  <!-- ========================================================= -->
  <!-- ENTITY: returns a space-delimited list composed by the    -->
  <!-- identifiers of its BLOB attributes as well as BLOB        -->
  <!-- attributes of its ancestors                               -->
  <!-- ========================================================= -->
  <xsl:template match="ENTITY" mode="blob-attributes">
    <xsl:param name="recurse-on-ancestors" select="yes"/>
    <xsl:for-each select="ATTRIBUTE[@type = 'BLOB']">
      <xsl:value-of select="concat(@id, ' ')"/>
    </xsl:for-each>
    <xsl:if test="$recurse-on-ancestors = 'yes'">
      <xsl:apply-templates select="key('id', @superEntity)[1]" mode="blob-attributes">
        <xsl:with-param name="recurse-on-ancestors" select="$recurse-on-ancestors"/>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:template>

  <!-- ========================================================= -->
  <!-- ENTITY: returns a space-delimited list composed by the    -->
  <!-- identifiers of its displayed attributes                   -->
  <!-- ========================================================= -->
  <xsl:template match="ENTITY" mode="display-attributes">
    <xsl:variable name="id" select="@id"/>
    <xsl:variable name="attr-list" select="saxon:tokenize(DESCRIPTION/@attributes)"/>
    <xsl:choose>
      <xsl:when test="count($attr-list) &gt; 0">  <!-- at least one display attribute -->
        <xsl:value-of select="DESCRIPTION/@attributes"/>
      </xsl:when>
      <xsl:otherwise>  <!-- recurses over ancestors -->
        <xsl:apply-templates select="key('id', @superEntity)[1]" mode="display-attributes"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
 
  <!-- ========================================================= -->
  <!-- Returns 'yes' if the input argument includes the          -->
  <!-- identifier of a boolean attribute                         -->
  <!-- ========================================================= -->
  <xsl:template match="*" mode="includes-boolean-attribute">
    <xsl:param name="attributes" select="@attributes"/>
    <xsl:variable name="result">
      <xsl:for-each select="key('id', saxon:tokenize($attributes))">
		 <xsl:if test="@type = 'Boolean'">t</xsl:if>
	  </xsl:for-each>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="contains($result, 't')">yes</xsl:when>
      <xsl:otherwise>no</xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <!-- check the brackets of the given message  -->
  <xsl:template name="check-brackets">
    <xsl:param name="message"/>
    <xsl:variable name="allowed-value0">
      <xsl:value-of select="'0'"/>
    </xsl:variable>
    <xsl:variable name="allowed-value1">
      <xsl:value-of select="'1'"/>
    </xsl:variable>
    <xsl:variable name="allowed-value2">
      <xsl:value-of select="'2'"/>
    </xsl:variable>
    <xsl:variable name="allowed-value3">
      <xsl:value-of select="'3'"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="contains($message,'{') or contains($message,'}')">
        <xsl:choose>
          <xsl:when test="contains($message,'{') and contains($message,'}')">
            <xsl:choose>
              <xsl:when test="string-length(substring-before($message, '{')) &lt; string-length(substring-before($message, '}'))">
                <xsl:choose>
                  <xsl:when test="starts-with(substring-after($message,'{'), concat($allowed-value0, '}'))
                                  or starts-with(substring-after($message,'{'), concat($allowed-value1, '}'))
                                  or starts-with(substring-after($message,'{'), concat($allowed-value2, '}'))
                                  or starts-with(substring-after($message,'{'), concat($allowed-value3, '}'))">
                    <xsl:call-template name="check-brackets">
                      <xsl:with-param name="message">
                        <xsl:value-of select="substring-after($message,'}')"/>
                      </xsl:with-param>
                    </xsl:call-template>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="'yes'"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="'yes'"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="'yes'"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="'no'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
	

</xsl:stylesheet>