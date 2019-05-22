<xsl:stylesheet 
    version="1.0" 
    xmlns:saxon="http://icl.com/saxon"
    xmlns:stringutils="java:org.apache.commons.lang.StringUtils"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    exclude-result-prefixes="saxon stringutils">

  <xsl:output indent="yes" saxon:indent-spaces="2" encoding="UTF-8"/>
  
  <xsl:key name="prop" match="*" use="@id"/>
  
  <xsl:template match="unit-descriptor|sub-unit">
    <xsl:variable name="name">
      <xsl:choose>
        <xsl:when test="name(.) = 'unit-descriptor'">Unit</xsl:when>
        <xsl:otherwise>SubUnit</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:element name="{$name}">
      <xsl:if test="self::unit-descriptor">
        <xsl:attribute name="type"><xsl:value-of select="@type"/></xsl:attribute>
        <xsl:attribute name="formBased">false</xsl:attribute>
      </xsl:if>
      <xsl:if test="self::sub-unit">
        <xsl:attribute name="elementName"><xsl:value-of select="@tag-name"/></xsl:attribute>
      </xsl:if>
      <xsl:attribute name="idPrefix"><xsl:value-of select="@id-prefix"/></xsl:attribute>
      <xsl:attribute name="namePrefix"><xsl:value-of select="@name-prefix"/></xsl:attribute>
      <xsl:attribute name="label"><xsl:value-of select="@label"/></xsl:attribute>
      <xsl:if test="self::unit-descriptor">
        <xsl:apply-templates select="@views"/>
        <xsl:call-template name="copy-implied-attribute">
          <xsl:with-param name="source">link-source</xsl:with-param>
          <xsl:with-param name="target">linkSource</xsl:with-param>
          <xsl:with-param name="boolean">true</xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="copy-implied-attribute">
          <xsl:with-param name="source">link-target</xsl:with-param>
          <xsl:with-param name="target">linkTarget</xsl:with-param>
          <xsl:with-param name="boolean">true</xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="copy-implied-attribute">
          <xsl:with-param name="source">ko-link-source</xsl:with-param>
          <xsl:with-param name="target">koLinkSource</xsl:with-param>
          <xsl:with-param name="boolean">true</xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="copy-implied-attribute">
          <xsl:with-param name="source">ko-link-target</xsl:with-param>
          <xsl:with-param name="target">koLinkTarget</xsl:with-param>
          <xsl:with-param name="boolean">true</xsl:with-param>
        </xsl:call-template>
        <xsl:if test="@ko-link-cardinality = 'many'">
          <xsl:attribute name="multipleKOLinkCardinality">true</xsl:attribute>
        </xsl:if>
        <xsl:call-template name="copy-implied-attribute">
          <xsl:with-param name="source">ok-link-source</xsl:with-param>
          <xsl:with-param name="target">okLinkSource</xsl:with-param>
          <xsl:with-param name="boolean">true</xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="copy-implied-attribute">
          <xsl:with-param name="source">ok-link-target</xsl:with-param>
          <xsl:with-param name="target">okLinkTarget</xsl:with-param>
          <xsl:with-param name="boolean">true</xsl:with-param>
        </xsl:call-template>
        <xsl:if test="@ok-link-cardinality = 'many'">
          <xsl:attribute name="multipleOKLinkCardinality">true</xsl:attribute>
        </xsl:if>
        <xsl:call-template name="copy-implied-attribute">
          <xsl:with-param name="source">non-contextual-link-target</xsl:with-param>
          <xsl:with-param name="target">nonContextualLinkTarget</xsl:with-param>
          <xsl:with-param name="boolean">true</xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="copy-implied-attribute">
          <xsl:with-param name="source">default-inter-page-link-type</xsl:with-param>
          <xsl:with-param name="target">defaultInterPageLinkType</xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="copy-implied-attribute">
          <xsl:with-param name="source">default-intra-page-link-type</xsl:with-param>
          <xsl:with-param name="target">defaultIntraPageLinkType</xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="copy-implied-attribute">
          <xsl:with-param name="source">default-towards-operation-link-type</xsl:with-param>
          <xsl:with-param name="target">defaultTowardsOperationLinkType</xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="copy-implied-attribute">
          <xsl:with-param name="source">displayable</xsl:with-param>
          <xsl:with-param name="target">displayable</xsl:with-param>
          <xsl:with-param name="boolean">true</xsl:with-param>
        </xsl:call-template>
      </xsl:if>
      <xsl:apply-templates select="*"/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="sub-unit-reference">
    <SubUnitReference elementName=""/>
  </xsl:template>

  <xsl:template match="unit-descriptor/@views">
    <xsl:choose>
      <xsl:when test=". = 'SITEVIEW|SERVICEVIEW'"/>
      <xsl:when test=". = 'SITEVIEW'">
        <xsl:attribute name="views">SiteView</xsl:attribute>
      </xsl:when>
      <xsl:when test=". = 'SERVICEVIEW'">
        <xsl:attribute name="views">ServiceView</xsl:attribute>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template name="copy-implied-attribute">
    <xsl:param name="source"/>
    <xsl:param name="target"/>
    <xsl:param name="boolean" select="'false'"/>
    <xsl:variable name="value" select="string(@*[name() = $source])"/>
    <xsl:if test="$value != ''">
      <xsl:attribute name="{$target}">
        <xsl:choose>
          <xsl:when test="($boolean = 'true') and ($value = 'yes')">true</xsl:when>
          <xsl:when test="($boolean = 'true') and ($value = 'no')">false</xsl:when>
          <xsl:otherwise><xsl:value-of select="$value"/></xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="string-property">
    <StringProperty label="{@label}" attributeName="{@attribute-name}" defaultValue="{default/constant-value/@value}">
      <xsl:apply-templates select="*"/>
    </StringProperty>
  </xsl:template>

  <xsl:template match="integer-property">
    <IntegerProperty label="{@label}" attributeName="{@attribute-name}" defaultValue="{default/constant-value/@value}">
      <xsl:apply-templates select="*"/>
    </IntegerProperty>
  </xsl:template>

  <xsl:template match="boolean-property">
    <BooleanProperty label="{@label}" attributeName="{@attribute-name}" defaultValue="{default/constant-value/@value}">
      <xsl:apply-templates select="*"/>
    </BooleanProperty>
  </xsl:template>
  
  <xsl:template match="webmltype-property">
    <TypeProperty typeAttributeName="type" subTypeAttributeName="subType" defaultValue="string"/>
  </xsl:template>
  
  <xsl:template match="selector/enum-property"/>
  
  <xsl:template match="enum-property">
    <EnumProperty label="{@label}" attributeName="{@attribute-name}" defaultValue="{default/constant-value/@value}">
      <xsl:for-each select="enum-value">
        <EnumItem value="{@value}" label="{@label}"/>
      </xsl:for-each>
    </EnumProperty>
  </xsl:template>

  <xsl:template match="file-property">
    <FileProperty label="{@label}" attributeName="{@attribute-name}" extension="{@extension}" defaultValue="{default/constant-value/@value}">
      <xsl:apply-templates select="*"/>
    </FileProperty>
  </xsl:template>

  <xsl:template match="float-property">
    <FloatProperty label="{@label}" attributeName="{@attribute-name}" defaultValue="{default/constant-value/@value}">
      <xsl:apply-templates select="*"/>
    </FloatProperty>
  </xsl:template>

  <xsl:template match="global-parameters-property">
    <ContextParametersProperty label="{@label}" attributeName="{@attribute-name}">
      <xsl:apply-templates select="*"/>
    </ContextParametersProperty>
  </xsl:template>

  <xsl:template match="list-property">
    <ListProperty label="{@label}" attributeName="{@attribute-name}" elementName="{@sub-element-tag-name}">
      <xsl:apply-templates select="*"/>
    </ListProperty>
  </xsl:template>

  <xsl:template match="password-property">
    <PasswordProperty label="{@label}" attributeName="{@attribute-name}">
      <xsl:apply-templates select="*"/>
    </PasswordProperty>
  </xsl:template>

  <xsl:template match="property[@label = 'Password']">
    <PasswordProperty label="{@label}" attributeName="{property-reader/parameter[@name = 'attribute-name']/constant-value/@value}">
      <xsl:apply-templates select="*"/>
    </PasswordProperty>
  </xsl:template>

  <xsl:template match="text-property">
    <TextProperty label="{@label}" elementName="{@element-name}"  defaultValue="{default/constant-value/@value}">
      <xsl:apply-templates select="*"/>
    </TextProperty>
  </xsl:template>

  <xsl:template match="xsd-type-property">
    <XSDTypeProperty label="{@label}" attributeName="{@attribute-name}">
      <xsl:apply-templates select="." mode="refAttribute">
        <xsl:with-param name="oldAttribute">schema-property</xsl:with-param>
        <xsl:with-param name="newAttribute">schemaExpr</xsl:with-param>
      </xsl:apply-templates>
      <xsl:apply-templates select="*"/>
    </XSDTypeProperty>
  </xsl:template>

  <xsl:template match="entity-property">
    <EntityProperty label="{@label}" attributeName="{@attribute-name}">
      <xsl:attribute name="includeDerived">
        <xsl:choose>
          <xsl:when test="string(@include-derived) = 'no'">false</xsl:when>
          <xsl:otherwise>true</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:apply-templates select="*"/>
    </EntityProperty>
  </xsl:template>

  <xsl:template match="relationship-property">
    <RelationshipRoleProperty label="{@label}" attributeName="{@attribute-name}">
      <xsl:attribute name="includeDerived">
        <xsl:choose>
          <xsl:when test="string(@include-derived) = 'no'">false</xsl:when>
          <xsl:otherwise>true</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:apply-templates select="." mode="refAttribute">
        <xsl:with-param name="oldAttribute">source-entity-property</xsl:with-param>
        <xsl:with-param name="newAttribute">sourceEntityIdExpr</xsl:with-param>
      </xsl:apply-templates>
      <xsl:apply-templates select="." mode="refAttribute">
        <xsl:with-param name="oldAttribute">target-entity-property</xsl:with-param>
        <xsl:with-param name="newAttribute">targetEntityIdExpr</xsl:with-param>
      </xsl:apply-templates>
      <xsl:apply-templates select="*"/>
    </RelationshipRoleProperty>
  </xsl:template>

  <xsl:template match="included-attributes">
    <AttributesProperty 
        label="{@label}">
      <xsl:apply-templates select="." mode="refAttribute">
        <xsl:with-param name="oldAttribute">parent-entity-property</xsl:with-param>
        <xsl:with-param name="newAttribute">entityIdExpr</xsl:with-param>
      </xsl:apply-templates>
      <xsl:attribute name="elementName">
        <xsl:choose>
          <xsl:when test="string(@display-attribute-element-tag) != ''">
            <xsl:value-of select="@display-attribute-element-tag"/>
          </xsl:when>
          <xsl:otherwise>DisplayAttribute</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:attribute name="attributeName">attribute</xsl:attribute>
      
      <xsl:apply-templates select="*"/>
    </AttributesProperty>
  </xsl:template>

  <xsl:template match="sort-attributes">
    <SortAttributesProperty 
        label="{@label}" 
        elementName="SortAttribute"
        attributeName="attribute">
      <xsl:apply-templates select="." mode="refAttribute">
        <xsl:with-param name="oldAttribute">parent-entity-property</xsl:with-param>
        <xsl:with-param name="newAttribute">entityIdExpr</xsl:with-param>
      </xsl:apply-templates>
      <xsl:apply-templates select="*"/>
    </SortAttributesProperty>
  </xsl:template>

  <xsl:template match="attribute-property">
    <AttributeProperty label="{@label}" attributeName="{@attribute-name}">
      <xsl:apply-templates select="." mode="refAttribute">
        <xsl:with-param name="oldAttribute">parent-entity-property</xsl:with-param>
        <xsl:with-param name="newAttribute">entityIdExpr</xsl:with-param>
      </xsl:apply-templates>
      <xsl:apply-templates select="*"/>
    </AttributeProperty>
  </xsl:template>

  <xsl:template match="selector">
    <Selector
        label="{@selector-label}">
      <xsl:attribute name="entityIdExpr">
        <xsl:choose>
          <xsl:when test="string(@population-entity-property) != ''">
            <xsl:text>../../@</xsl:text>
            <xsl:value-of select="key('prop', @population-entity-property)/@attribute-name"/>
          </xsl:when>
          <xsl:when test="population-entity/property-value/@modifier = 'getSourceEntity'">
            <xsl:text>get-source-entity-id(id(../../@</xsl:text>
            <xsl:value-of select="key('prop', population-entity/property-value/@property)/@attribute-name"/>
            <xsl:text>))</xsl:text>
          </xsl:when>
          <xsl:when test="population-entity/property-value/@modifier = 'getTargetEntity'">
            <xsl:text>get-target-entity-id(id(../../@</xsl:text>
            <xsl:value-of select="key('prop', population-entity/property-value/@property)/@attribute-name"/>
            <xsl:text>))</xsl:text>
          </xsl:when>
        </xsl:choose>
      </xsl:attribute>
      <xsl:attribute name="elementName">
        <xsl:choose>
          <xsl:when test="string(@selector-tag-name) = 'SELECTOR'">Selector</xsl:when>
          <xsl:when test="string(@selector-tag-name) = 'PRESELECTOR'">PreSelector</xsl:when>
          <xsl:when test="string(@selector-tag-name) = 'SOURCESELECTOR'">SourceSelector</xsl:when>
          <xsl:when test="string(@selector-tag-name) = 'TARGETSELECTOR'">TargetSelector</xsl:when>
          <xsl:otherwise><xsl:value-of select="@selector-tag-name"/></xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:attribute name="defaultPolicy">
        <xsl:choose>
          <xsl:when test="enum-property[@attribute-name = 'defaultPolicy']">true</xsl:when>
          <xsl:otherwise>false</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:apply-templates select="*"/>
    </Selector>
  </xsl:template>
  
  <xsl:template match="default"/>
  
  <xsl:template match="is-editable">
    <IsEnabled><xsl:apply-templates select="*"/></IsEnabled>
  </xsl:template>
  
  <xsl:template match="condition">
    <xsl:text>return </xsl:text>
    <xsl:apply-templates select="*"/>
  </xsl:template>

  <xsl:template match="and">
    <xsl:text>(</xsl:text>
    <xsl:for-each select="*">
      <xsl:if test="position() &gt; 1"> and </xsl:if>
      <xsl:apply-templates select="."/>
    </xsl:for-each>
    <xsl:text>)</xsl:text>
  </xsl:template>

  <xsl:template match="or">
    <xsl:text>(</xsl:text>
    <xsl:for-each select="*">
      <xsl:if test="position() &gt; 1"> or </xsl:if>
      <xsl:apply-templates select="."/>
    </xsl:for-each>
    <xsl:text>)</xsl:text>
  </xsl:template>

  <xsl:template match="not">
    not(<xsl:apply-templates select="*"/>)
  </xsl:template>

  <xsl:template match="equals">
    <xsl:text>(</xsl:text>
    <xsl:apply-templates select="*[1]"/> == <xsl:apply-templates select="*[2]"/>
    <xsl:text>)</xsl:text>
  </xsl:template>

  <xsl:template match="is-null">
    <xsl:text>(</xsl:text>
    <xsl:apply-templates select="*"/>
    <xsl:text>) == ""</xsl:text>
  </xsl:template>

  <xsl:template match="constant-value">
    <xsl:text>"</xsl:text>
    <xsl:value-of select="@value"/>
    <xsl:text>"</xsl:text>
  </xsl:template>

  <xsl:template match="is-valid">
    <xsl:text>is-valid(</xsl:text>
    <xsl:apply-templates select="*"/>
    <xsl:text>)</xsl:text>
  </xsl:template>

  <xsl:template match="property-value">
    <xsl:variable name="ref-prop-id" select="@property"/>
    <xsl:variable name="prop-id" select="ancestor::*[string(@id) != '']/@id"/>
    <xsl:choose>
      <xsl:when test="key('prop', $prop-id)/../@tag-name = key('prop', $ref-prop-id)/../@tag-name">
        <xsl:text>unit.valueOf("@</xsl:text>
        <xsl:value-of select="key('prop', $ref-prop-id)/@attribute-name"/>
        <xsl:text>")</xsl:text>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="*" mode="refAttribute">
    <xsl:param name="oldAttribute"/>
    <xsl:param name="newAttribute"/>
    <xsl:variable name="prop" select="string(@*[name(.) = $oldAttribute])"/>
    <xsl:if test="$prop != ''">
      <xsl:choose>
        <xsl:when test="starts-with($prop, 'parent::')">
          <xsl:variable name="value" select="string(key('prop', substring($prop, 9))/@attribute-name)"/>
          <xsl:if test="$value != ''">
            <xsl:attribute name="{$newAttribute}">../@<xsl:value-of select="$value"/></xsl:attribute>
          </xsl:if>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="value" select="string(key('prop', $prop)/@attribute-name)"/>
          <xsl:if test="$value != ''">
            <xsl:attribute name="{$newAttribute}">@<xsl:value-of select="$value"/></xsl:attribute>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="*"/>
  
  <xsl:template match="text()"/>
  
</xsl:stylesheet>