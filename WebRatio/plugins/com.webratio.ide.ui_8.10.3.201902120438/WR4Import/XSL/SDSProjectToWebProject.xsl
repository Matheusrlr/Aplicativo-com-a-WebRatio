<xsl:stylesheet
    version="1.0" 
    xmlns:auxiliary="http://www.webml.org/auxiliary"
    xmlns:db="http://www.webratio.com/2006/WebML/Database"
    xmlns:sc="java:com.webratio.commons.net.EventSocketClient"
    xmlns:fn="http://www.webratio.com/fn"
    xmlns:g="http://www.webml.org/graph"
    xmlns:gr="http://www.webratio.com/2006/WebML/Graph"
    xmlns:graphmetadata="http://www.webml.org/graphmetadata"
    xmlns:layout="http://www.webratio.com/2006/WebML/Layout"
    xmlns:map="java:java.util.HashMap"
    xmlns:linkHelper="java:com.webratio.ide.transform.WR4ImportLinkHelper"
    xmlns:layoutHelper="java:com.webratio.ide.transform.WR4ImportLayoutHelper"
    xmlns:localeHelper="java:com.webratio.ide.transform.WR4ImportLocaleHelper"
    xmlns:unitHelper="java:com.webratio.ide.transform.WR4ImportUnitHelper"
    xmlns:presentation="http://www.webml.org/presentation"
    xmlns:rdbms="http://www.webml.org/mapping/rdbms"
    xmlns:saxon="http://icl.com/saxon"
    xmlns:stringutils="http://org.apache.commons.lang.StringUtils"
    xmlns:file="http://java.io.File"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    exclude-result-prefixes="fn g graphmetadata map presentation rdbms saxon stringutils">

  <xsl:output indent="yes" saxon:indent-spaces="2" encoding="UTF-8"/>
  
  <xsl:key name="id" match="*" use="@id"/>
  <xsl:key name="rel" match="RELATIONSHIP" use="@id"/>
  <xsl:key name="entity" match="/WebML/Structure/ENTITY" use="@id"/>
  <xsl:key name="all-areas" match="AREA" use="''"/>
  <xsl:key name="entity-mask" match="/WebML/Mapping/rdbms:RDBMSMapping/rdbms:ENTITYMASK" use="@entity"/>
  <xsl:key name="entity-map" match="/WebML/Mapping/rdbms:RDBMSMapping/rdbms:ENTITYMAP" use="@entity"/>
  <xsl:key name="entity-fragment" match="/WebML/Mapping/rdbms:RDBMSMapping/rdbms:ENTITYFRAGMENT" use="@entity"/>
  <xsl:key name="attr-map" match="rdbms:ATTRIBUTEMAP" use="@attribute"/>
  <xsl:key name="rel-map" match="/WebML/Mapping/rdbms:RDBMSMapping/rdbms:RELATIONSHIPMAP" use="@relationship"/>
  <xsl:key name="incoming-any-links" match="LINK|OK-LINK|KO-LINK" use="@to"/>
  <xsl:key name="all-units" match="OPERATIONUNITS/*|CONTENTUNITS/*" use="''"/>
  <xsl:key name="all-selector-conditions" match="SELECTORCONDITION" use="''"/>
  <xsl:key name="mail-units" match="EMAILUNIT|POWERMAILUNIT" use="''"/>
  <xsl:key name="mail-units-by-key" match="EMAILUNIT|POWERMAILUNIT" use="concat(@smtp-server, '__', @username, '__', @password, '__', @default-from)"/>
  
  <!-- AJAX -->
  <xsl:key name="autocomplete-depends" match="PROPERTY[@name='autocomplete-depends']" use="@value" />
  
  <xsl:variable name="linkHelperInstance" select="linkHelper:new()"/>
  <xsl:variable name="layoutHelperInstance" select="layoutHelper:new()"/>
  <xsl:variable name="localeHelperInstance" select="localeHelper:new()"/>
  
  <xsl:param name="eventSocketClient"/>
  <xsl:param name="project"/>
  <xsl:param name="nodesXY"/>
  <xsl:param name="connectionsXY"/>
  <xsl:param name="deploymentConfigurationsPath"/>
  <xsl:param name="reports"/>
  <xsl:param name="unitReports"/>

  <xsl:template match="WebML">
    <xsl:variable name="dummy">
      <xsl:value-of select="sc:sendBeginTask($eventSocketClient, 'Main', 1 + count(key('all-areas', '')))"/>
      <xsl:value-of select="linkHelper:setUnits($linkHelperInstance, key('all-units', ''))"/>
      <xsl:value-of select="linkHelper:setSelectorConditions($linkHelperInstance, key('all-selector-conditions', ''))"/>
    </xsl:variable>
    <xsl:text>&#10;</xsl:text>
    <xsl:processing-instruction name="webml">version="4.0.0"</xsl:processing-instruction>
    <xsl:text>&#10;</xsl:text>
    <WebProject outputPath="${{webapps_loc}}/${{project_name}}" gr:showUnitContent="true">
        <xsl:variable name="str">
          <xsl:for-each select="Mapping/rdbms:RDBMSMapping/rdbms:DATABASE">
            <xsl:value-of select="@url"/>
          </xsl:for-each>
          <xsl:for-each select="Navigation/SITEVIEW">
            <xsl:value-of select="@name"/>
          </xsl:for-each>
        </xsl:variable>
		<xsl:attribute name="control">
			<xsl:value-of select="unitHelper:computeControlValue(string($str))" />
		</xsl:attribute>
        <xsl:attribute name="httpPort">
	      	<xsl:choose>
	      		<xsl:when test="string(@auxiliary:http-port) != ''">
	      			<xsl:value-of select="@auxiliary:http-port"/>
	      		</xsl:when>
	      		<xsl:otherwise>
	      			<xsl:value-of select="8080"/>
	      		</xsl:otherwise>
	      	</xsl:choose>
      	</xsl:attribute>
      	<xsl:attribute name="httpsPort">
	      	<xsl:choose>
	      		<xsl:when test="string(@auxiliary:https-port) != ''">
	      			<xsl:value-of select="@auxiliary:https-port"/>
	      		</xsl:when>
	      		<xsl:otherwise>
	      			<xsl:value-of select="8443"/>
	      		</xsl:otherwise>
	      	</xsl:choose>
      	</xsl:attribute>
      <xsl:apply-templates select="*"/>
      <xsl:if test="string($deploymentConfigurationsPath) != ''">
        <xsl:variable xml:base="file:///" name="deploymentConfs" select="document($deploymentConfigurationsPath)"/>
        <xsl:for-each select="$deploymentConfs/deployment-configurations/configuration">
          <xsl:variable name="dplIndex" select="position()"/>
          <DeploymentConfiguration 
              id="dplconf{$dplIndex}"
              name="{@name}"
              outputPath="{@layoutPath}"
              httpPort="{@http-port}"
              httpsPort="{@https-port}">
            <xsl:for-each select="database">
              <DatabaseConfiguration 
                  id="dbconf{$dplIndex}_{position()}"
                  name="{@db-id}"
                  database="{@db-id}"
                  url="{@db-source}"
                  username="{@db-user}"
                  password="{@db-password}"
                  jndiName="{@db-jndi-name}"
                  connectionCount="{@db-connection-count}"
                  runtimeURL="{@db-rt-source}">
                <xsl:attribute name="type">
                  <xsl:choose>
                    <xsl:when test="@db-type = 'PostgreSQL 7'">PostgreSQL 7</xsl:when>
                    <xsl:when test="@db-type = 'PostgreSQL 8'">PostgreSQL 8</xsl:when>
                    <xsl:when test="@db-type = 'Oracle 8i'">Oracle 8i (Thin Driver)</xsl:when>
                    <xsl:when test="@db-type = 'Oracle 9i'">Oracle 9i (Thin Driver)</xsl:when>
                    <xsl:when test="@db-type = 'Oracle 10g'">Oracle 10g (Thin Driver)</xsl:when>
                    <xsl:when test="@db-type = 'Microsoft Access'">ODBC</xsl:when>
                    <xsl:when test="@db-type = 'Microsoft SQL Server'">Microsoft SQL Server 2005</xsl:when>
                    <xsl:when test="@db-type = 'FrontBase'">FrontBase</xsl:when>
                    <xsl:when test="@db-type = 'MySQL'">MySQL</xsl:when>
                    <xsl:when test="@db-type = 'DB2'">DB2 Universal Driver</xsl:when>
                    <xsl:when test="@db-type = 'SQLBase'">SQLBase</xsl:when>
                    <xsl:when test="starts-with(@db-source, 'jdbc:odbc')">ODBC</xsl:when>
                    <xsl:when test="starts-with(@db-source, 'jdbc:oracle')">Oracle 9i (Thin Driver)</xsl:when>
                    <xsl:when test="starts-with(@db-source, 'jdbc:microsoft:sqlserver')">Microsoft SQL Server 2005</xsl:when>
                    <xsl:when test="starts-with(@db-source, 'jdbc:postgresql')">PostgreSQL 8</xsl:when>
                    <xsl:when test="starts-with(@db-source, 'jdbc:mysql')">MySQL</xsl:when>
                    <xsl:when test="starts-with(@db-source, 'jdbc:db2')">DB2 Universal Driver</xsl:when>
                    <xsl:when test="starts-with(@db-source, 'jdbc:FrontBase')">FrontBase</xsl:when>
                    <xsl:when test="starts-with(@db-source, 'jdbc:sqlbase')">SQLBase</xsl:when>
                  </xsl:choose>
                </xsl:attribute>
              </DatabaseConfiguration>
            </xsl:for-each>
          </DeploymentConfiguration>
        </xsl:for-each>
      </xsl:if>
      <ServiceDataProviders>
        <xsl:for-each select="key('mail-units', '')">
          <xsl:variable name="key" select="concat(@smtp-server, '__', @username, '__', @password, '__', @default-from)"/>
          <xsl:if test="(string($key) != '____') and (@id = key('mail-units-by-key', $key)[1]/@id)">
            <SMTPServer id="smtp{@id}" name="SMTP Server {position()}" url="{@smtp-server}" defaultFrom="{@default-from}" username="{@username}" password="{@password}"/>
          </xsl:if>
        </xsl:for-each>
      </ServiceDataProviders>
    </WebProject>
    <xsl:call-template name="sendTaskDone"/>
  </xsl:template>

  <xsl:template match="Structure">
    <DataModel>
      <xsl:apply-templates select="ENTITY"/>
      <xsl:apply-templates select="ENTITY/RELATIONSHIP"/>
      <xsl:apply-templates select="/WebML/Mapping/rdbms:RDBMSMapping/rdbms:DATABASE"/>
      <xsl:apply-templates select="SUBTYPE"/>
    </DataModel>
    <xsl:call-template name="sendTaskWorked"/>
  </xsl:template>


  
  <xsl:template match="ENTITY">
    <Entity id="{@id}" name="{@name}" duration="{@duration}" gr:x="{fn:x(@id)}" gr:y="{fn:y(@id)}">
	    <xsl:if test="string(@value) != ''">
	      <xsl:attribute name="derivationQuery"><xsl:value-of select="@value"/></xsl:attribute>
	    </xsl:if>
	    <xsl:if test="string(@auxiliary:attributesVisible) = 'false'">
	      <xsl:attribute name="gr:hideAttributes">true</xsl:attribute>
	    </xsl:if>
	    <xsl:choose>
	      <xsl:when test="key('entity-mask', @id)">
	        <xsl:attribute name="db:database">
	          <xsl:value-of select="key('entity-mask', @id)/@database"/>
	        </xsl:attribute>
	        <xsl:attribute name="db:table">
	          <xsl:value-of select="fn:unescape(key('entity-mask', @id)/@table)"/>
	        </xsl:attribute>
	      </xsl:when>
	      <xsl:when test="key('entity-map', @id)">
	        <xsl:attribute name="db:database">
	          <xsl:value-of select="key('entity-map', @id)/@database"/>
	        </xsl:attribute>
	        <xsl:attribute name="db:table">
	          <xsl:value-of select="fn:unescape(key('entity-map', @id)/@table)"/>
	        </xsl:attribute>
	      </xsl:when>
	    </xsl:choose>
	    <xsl:if test="key('entity', @superEntity)">
	      <Generalization superEntity="{@superEntity}">
		      <xsl:choose>
		        <xsl:when test="key('entity-mask', @id)">
  		        <db:JoinColumn name="{fn:unescape(key('entity-mask', @id)/@oidColumn)}">
  		          <xsl:attribute name="attribute">
  		            <xsl:apply-templates select="key('entity', @superEntity)" mode="oid-attr"/>
  		          </xsl:attribute>
  		        </db:JoinColumn>
    	      </xsl:when>
			      <xsl:when test="key('entity-map', @id)">
  		        <db:JoinColumn name="{fn:unescape(key('entity-map', @id)/@oidColumn)}">
  		          <xsl:attribute name="attribute">
  		            <xsl:apply-templates select="key('entity', @superEntity)" mode="oid-attr"/>
  		          </xsl:attribute>
  		        </db:JoinColumn>
			      </xsl:when>
			    </xsl:choose>
	      </Generalization>
	    </xsl:if>
	    <xsl:apply-templates select="ATTRIBUTE"/>
	    <xsl:apply-templates select="COMMENT"/>
    </Entity>
  </xsl:template>
  
  <xsl:template match="ENTITY" mode="oid-attr">
    <xsl:choose>
      <xsl:when test="key('entity', @superEntity)">
        <xsl:apply-templates select="key('entity', @superEntity)" mode="oid-attr"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="ATTRIBUTE[@type = 'OID']/@id"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <!-- JASPER REPORTS -->
  <xsl:template match="PAGE[@presentation:page-layout = 'Jasper']/PROPERTY[@name = 'template']"/>
  
  <xsl:template match="PROPERTY">
    <Property id="{@id}" name="{@name}" value="{@value}"/>
  </xsl:template>

  <xsl:template match="LINK/PROPERTY[@name = 'do-not-refresh']"/>
  <xsl:template match="OK-LINK/PROPERTY[@name = 'do-not-refresh']"/>
  <xsl:template match="KO-LINK/PROPERTY[@name = 'do-not-refresh']"/>

  <xsl:template match="SUBTYPE">
    <SubType id="{@id}" name="{@name}">
      <xsl:attribute name="type">
        <xsl:choose>
          <xsl:when test="@type = 'BLOB'">blob</xsl:when>
          <xsl:when test="@type = 'Boolean'">boolean</xsl:when>
          <xsl:when test="@type = 'Date'">date</xsl:when>
          <xsl:when test="@type = 'Float'">float</xsl:when>
          <xsl:when test="@type = 'Integer'">integer</xsl:when>
          <xsl:when test="@type = 'Number'">decimal</xsl:when>
          <xsl:when test="@type = 'OID'">integer</xsl:when>
          <xsl:when test="@type = 'Password'">password</xsl:when>
          <xsl:when test="@type = 'String'">string</xsl:when>
          <xsl:when test="@type = 'Text'">text</xsl:when>
          <xsl:when test="@type = 'Time'">time</xsl:when>
          <xsl:when test="@type = 'TimeStamp'">timestamp</xsl:when>
          <xsl:when test="@type = 'URL'">url</xsl:when>
          <xsl:otherwise>string</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:apply-templates select="COMMENT"/>
    </SubType>
  </xsl:template>
  
  <xsl:template match="ATTRIBUTE[(@type = 'OID') and key('entity', ../@superEntity)]"/>

  <xsl:template match="*" mode="newDisplayAttributes">
    <xsl:if test="DISPLAYATTRIBUTE">
       <xsl:attribute name="displayAttributes">
          <xsl:for-each select="DISPLAYATTRIBUTE">
            <xsl:variable name="newIdRefs" select="unitHelper:convertAttributeRefs(., @attribute)"/>
            <xsl:value-of select="$newIdRefs"/>
          	<xsl:text> </xsl:text>
          </xsl:for-each>
       </xsl:attribute>
    </xsl:if> 
  </xsl:template>

  <xsl:template match="ATTRIBUTE">
    <xsl:variable name="value" select="@value"/>
  
    <Attribute name="{@name}">
     <xsl:attribute name="id">
		<xsl:value-of select="@id"/>
     </xsl:attribute>
     <xsl:if test="string(@contentType) != ''">
      	<xsl:attribute name="contentType">
      		<xsl:value-of select="@contentType"/>
      	</xsl:attribute>
      </xsl:if>
      <xsl:if test="string(@subType) != ''">
      	<xsl:attribute name="subType">
      		<xsl:value-of select="@subType"/>
      	</xsl:attribute>
      </xsl:if>
      <xsl:attribute name="type">
        <xsl:choose>
          <xsl:when test="@type = 'BLOB'">blob</xsl:when>
          <xsl:when test="@type = 'Boolean'">boolean</xsl:when>
          <xsl:when test="@type = 'Date'">date</xsl:when>
          <xsl:when test="@type = 'Float'">float</xsl:when>
          <xsl:when test="@type = 'Integer'">integer</xsl:when>
          <xsl:when test="@type = 'Number'">decimal</xsl:when>
          <xsl:when test="@type = 'OID'">integer</xsl:when>
          <xsl:when test="@type = 'Password'">password</xsl:when>
          <xsl:when test="@type = 'String'">string</xsl:when>
          <xsl:when test="@type = 'Text'">text</xsl:when>
          <xsl:when test="@type = 'Time'">time</xsl:when>
          <xsl:when test="@type = 'TimeStamp'">timestamp</xsl:when>
          <xsl:when test="@type = 'URL'">url</xsl:when>
          <xsl:otherwise>string</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:choose>
        <xsl:when test="@type = 'OID'">
        	<xsl:attribute name="key">true</xsl:attribute>
        	<xsl:choose>
        		<xsl:when test="key('entity-mask', ../@id)">
        			<xsl:attribute name="db:column">
        				<xsl:value-of select="fn:unescape(key('entity-mask', ../@id)/@oidColumn)" />
        			</xsl:attribute>
        		</xsl:when>
        		<xsl:when test="key('entity-map', ../@id)">
        			<xsl:attribute name="db:column">
        				<xsl:value-of select="fn:unescape(key('entity-map', ../@id)/@oidColumn)" />
        			</xsl:attribute>
        		</xsl:when>
        	</xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:if test="key('attr-map', @id)">
	          <xsl:attribute name="db:column">
	            <xsl:value-of select="fn:unescape(key('attr-map', @id)/@column)"/>
	          </xsl:attribute>
	          <xsl:if test="string($value) != ''">
			     <xsl:attribute name="db:table">
			        <xsl:value-of select="fn:unescape(key('attr-map', @id)/../@table)"/>
			     </xsl:attribute>  
			  </xsl:if>
			  <xsl:variable name="uploadPolicy">
			  	<xsl:value-of select="key('attr-map', @id)/@uploadPolicy"/>
			  </xsl:variable>
			  <xsl:if test="string($uploadPolicy) != ''">
			     <xsl:attribute name="uploadPolicy">
		  		   <xsl:choose>
		  			   <xsl:when test="string($uploadPolicy) = 'no action'">
		  				 <xsl:value-of select="'failOnOverwrite'"/>
		  			   </xsl:when>
		  			   <xsl:otherwise>
		  			     <xsl:value-of select="$uploadPolicy"/>
		  			   </xsl:otherwise>
		  		   </xsl:choose> 
	  		     </xsl:attribute>
	  		  </xsl:if>
	  		  <xsl:variable name="deletePolicy">
			  	<xsl:value-of select="key('attr-map', @id)/@deletePolicy"/>
			  </xsl:variable>
	  		  <xsl:if test="string($deletePolicy) != ''">
			     <xsl:attribute name="deletePolicy">
		  		   <xsl:choose>
		  			   <xsl:when test="string($deletePolicy) = 'no action'">
		  				 <xsl:value-of select="'none'"/>
		  			   </xsl:when>
		  			   <xsl:otherwise>
		  			     <xsl:value-of select="$deletePolicy"/>
		  			   </xsl:otherwise>
		  		   </xsl:choose> 
	  		     </xsl:attribute>
	  		  </xsl:if>
	  		  <xsl:variable name="storageType">
			  	<xsl:value-of select="key('attr-map', @id)/@blobStorageType"/>
			  </xsl:variable>
	  		  <xsl:if test="string($storageType) != ''">
			     <xsl:attribute name="storageType">
		  		   <xsl:value-of select="$storageType"/>
	  		    </xsl:attribute>
	  		  </xsl:if>
	  		  <xsl:variable name="blobColumn">
			  	<xsl:value-of select="key('attr-map', @id)/@blobColumn"/>
			  </xsl:variable>
	  		  <xsl:if test="string($blobColumn) != ''">
			     <xsl:attribute name="db:blobColumn">
		  		   <xsl:value-of select="fn:unescape($blobColumn)"/>
	  		    </xsl:attribute>
	  		  </xsl:if>
	  		  <xsl:if test="string(key('attr-map', @id)/@uploadPath) != ''">
			     <xsl:attribute name="uploadPath">
		  		   <xsl:value-of select="key('attr-map', @id)/@uploadPath"/>
	  		    </xsl:attribute>
	  		  </xsl:if>
	      </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="@type = 'Password' and string(key('attr-map', @id)/@encryptionClass) != ''">
        <xsl:attribute name="db:cryptAlgorithm">
          <xsl:value-of select="stringutils:replace(key('attr-map', @id)/@encryptionClass,'com.webratio.webml.rtx.core','com.webratio.rtx.core')"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:variable name="dbUrl">
           <xsl:choose>
              <xsl:when test="key('entity-mask', ../@id)">
                 <xsl:value-of select="key('id',key('entity-mask', ../@id)/@database)/@url" />
              </xsl:when>
              <xsl:when test="key('entity-map', ../@id)">
                 <xsl:value-of select="key('id',key('entity-map', ../@id)/@database)/@url" />
              </xsl:when>
           </xsl:choose>
      </xsl:variable>
      <!-- boolean true and false values -->
      <xsl:if test="@type = 'Boolean'">
        <xsl:choose>
          <xsl:when test="contains($dbUrl, 'postgresql')">
               <xsl:attribute name="db:trueValue">1</xsl:attribute>
               <xsl:attribute name="db:falseValue">0</xsl:attribute>
          </xsl:when>
        </xsl:choose>
      </xsl:if>
      <!-- use quikfix instead, due to varchar2 over text attribute  
      <xsl:if test="@type = 'Text' and contains($dbUrl, 'oracle')">
         <xsl:attribute name="db:clob">true</xsl:attribute>
      </xsl:if>  -->
      <xsl:if test="string(@value) != '' and string(@value) != 'MANUALLY_MAP'">
	    <xsl:attribute name="derivationQuery"><xsl:value-of select="@value"/></xsl:attribute>
	    <xsl:if test="key('entity-fragment', ../@id)">
            <xsl:variable name="keyAttr"><xsl:apply-templates select="key('entity', ../@id)" mode="oid-attr"/></xsl:variable>
	    	<db:JoinColumn attribute="{$keyAttr}" name="{fn:unescape(key('attr-map', @id)/../rdbms:JOIN_ON/@tableKey)}"/>
	    </xsl:if>
	  </xsl:if>
      <xsl:if test="string(@value) = 'MANUALLY_MAP'">
	   <xsl:variable name="keyAttr"><xsl:apply-templates select="key('entity', ../@id)" mode="oid-attr"/></xsl:variable> 
       <db:JoinColumn attribute="{$keyAttr}" name="{fn:unescape(key('attr-map', @id)/../rdbms:JOIN_ON/@tableKey)}"/>
	  </xsl:if>
	  <xsl:apply-templates select="COMMENT"/>
    </Attribute>
  </xsl:template>
  
  <xsl:template match="RELATIONSHIP">
    <xsl:variable name="pos1">
      <xsl:apply-templates select="." mode="pos"/>
    </xsl:variable>
    <xsl:variable name="pos2">
      <xsl:apply-templates select="." mode="inverse-pos"/>
    </xsl:variable>
    <xsl:if test="$pos1 &lt; $pos2">
      <Relationship
          id="{@id}_{@inverse}"
          name="{@name}"
          sourceEntity="{../@id}"
          targetEntity="{@to}">
          <xsl:if test="key('rel-map', @id)">
	        <xsl:attribute name="db:database">
	          <xsl:value-of select="key('rel-map', @id)/@database"/>
	        </xsl:attribute>
	        <xsl:attribute name="db:table">
	          <xsl:value-of select="fn:unescape(key('rel-map', @id)/@table)"/>
	        </xsl:attribute>
	      </xsl:if>
	      <xsl:variable name="bendpoints" select="fn:bendpoints(@id)"/>
	      <xsl:if test="string($bendpoints) != ''">
	        <xsl:attribute name="gr:bendpoints">
	          <xsl:value-of select="$bendpoints"/>
	        </xsl:attribute>
	      </xsl:if>
        <xsl:apply-templates select="." mode="role1"/>
        <xsl:apply-templates select="key('rel', @inverse)" mode="role2"/>
      </Relationship>
    </xsl:if>
  </xsl:template>

  <xsl:template match="RELATIONSHIP" mode="role1">
    <RelationshipRole1 id="{@id}" name="{@roleName}" maxCard="{@maxCard}">
      <xsl:if test="string(@value) != ''">
	    <xsl:attribute name="derivationQuery"><xsl:value-of select="@value"/></xsl:attribute>
	  </xsl:if>
      <xsl:if test="../ATTRIBUTE[@type = 'OID']">
        <xsl:variable name="keyAttr"><xsl:apply-templates select="key('entity', ../@id)" mode="oid-attr"/></xsl:variable>
        <xsl:variable name="sourceOIDColumn"><xsl:value-of select="fn:unescape(key('rel-map', @id)/@sourceOIDColumn)"/></xsl:variable>
        <xsl:if test="string($sourceOIDColumn) != ''">
           <db:JoinColumn attribute="{$keyAttr}" name="{$sourceOIDColumn}"/>
        </xsl:if>
      </xsl:if>
	  <xsl:apply-templates select="COMMENT"/>
    </RelationshipRole1>
  </xsl:template>

  <xsl:template match="RELATIONSHIP" mode="role2">
    <RelationshipRole2 id="{@id}" name="{@roleName}" maxCard="{@maxCard}">
      <xsl:if test="string(@value) != ''">
	    <xsl:attribute name="derivationQuery"><xsl:value-of select="@value"/></xsl:attribute>
	  </xsl:if>
      <xsl:if test="../ATTRIBUTE[@type = 'OID']">
        <xsl:variable name="keyAttr"><xsl:apply-templates select="key('entity', ../@id)" mode="oid-attr"/></xsl:variable>
        <xsl:variable name="sourceOIDColumn"><xsl:value-of select="fn:unescape(key('rel-map', @id)/@sourceOIDColumn)"/></xsl:variable>
        <xsl:if test="string($sourceOIDColumn) != ''">
           <db:JoinColumn attribute="{$keyAttr}" name="{$sourceOIDColumn}"/>
        </xsl:if>
      </xsl:if>
	  <xsl:apply-templates select="COMMENT"/>
    </RelationshipRole2>
  </xsl:template>

  <xsl:template match="RELATIONSHIP" mode="pos">
    <xsl:number level="any"/>
  </xsl:template>

  <xsl:template match="RELATIONSHIP" mode="inverse-pos">
    <xsl:choose>
      <xsl:when test="key('rel', @inverse)">
        <xsl:apply-templates select="key('rel', @inverse)" mode="pos"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="." mode="pos"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="rdbms:DATABASE">
    <db:Database
        id="{@id}" 
        url="{@url}"
        username="{@user}"
        password="{@password}"
        name="{@name}">
      <xsl:if test="@encrypted = 'yes'">
        <xsl:attribute name="cryptedPassword">true</xsl:attribute>
      </xsl:if>
      <xsl:attribute name="type">
        <xsl:choose>
          <xsl:when test="@databaseType = 'PostgreSQL 7'">PostgreSQL 7</xsl:when>
          <xsl:when test="@databaseType = 'PostgreSQL 8'">PostgreSQL 8</xsl:when>
          <xsl:when test="@databaseType = 'Oracle 8i'">Oracle 8i (Thin Driver)</xsl:when>
          <xsl:when test="@databaseType = 'Oracle 9i'">Oracle 9i (Thin Driver)</xsl:when>
          <xsl:when test="@databaseType = 'Oracle 10g'">Oracle 10g (Thin Driver)</xsl:when>
          <xsl:when test="@databaseType = 'Microsoft Access'">ODBC</xsl:when>
          <xsl:when test="@databaseType = 'Microsoft SQL Server'">Microsoft SQL Server 2005</xsl:when>
          <xsl:when test="@databaseType = 'FrontBase'">FrontBase</xsl:when>
          <xsl:when test="@databaseType = 'MySQL'">MySQL</xsl:when>
          <xsl:when test="@databaseType = 'DB2'">DB2 Universal Driver</xsl:when>
          <xsl:when test="@databaseType = 'SQLBase'">SQLBase</xsl:when>
          <xsl:when test="starts-with(@url, 'jdbc:odbc')">ODBC</xsl:when>
          <xsl:when test="starts-with(@url, 'jdbc:oracle')">Oracle 9i (Thin Driver)</xsl:when>
          <xsl:when test="starts-with(@url, 'jdbc:microsoft:sqlserver')">Microsoft SQL Server 2005</xsl:when>
          <xsl:when test="starts-with(@url, 'jdbc:postgresql')">PostgreSQL 8</xsl:when>
          <xsl:when test="starts-with(@url, 'jdbc:mysql')">MySQL</xsl:when>
          <xsl:when test="starts-with(@url, 'jdbc:db2')">DB2 Universal Driver</xsl:when>
          <xsl:when test="starts-with(@url, 'jdbc:FrontBase')">FrontBase</xsl:when>
          <xsl:when test="starts-with(@url, 'jdbc:sqlbase')">SQLBase</xsl:when>
        </xsl:choose>
      </xsl:attribute>
    </db:Database>
  </xsl:template>

  <xsl:template match="Navigation">
    <WebModel layout:style="WRDefault">
     <xsl:if test="string(../@homeSiteView) != ''">
        <xsl:attribute name="homeSiteView">
           <xsl:value-of select="../@homeSiteView"/>
        </xsl:attribute>
     </xsl:if>
     <xsl:variable name="language">
     	<xsl:value-of select="../Localization/LOCALE[@default='yes']/@language"/>
     </xsl:variable>
     <xsl:variable name="country">
     	<xsl:value-of select="../Localization/LOCALE[@default='yes']/@country"/>
     </xsl:variable>
     <xsl:attribute name="defaultLocale">
           <xsl:value-of select="concat($language, '_', $country)"/>
     </xsl:attribute>
      <xsl:apply-templates select="../Localization/LOCALE" mode="Local"/>
      <xsl:apply-templates select="*"/>
      <xsl:apply-templates select="SITEVIEW/GLOBALPARAMETER"/>
    </WebModel>
  </xsl:template>
  
  <xsl:template match="Localization/LOCALE" mode="Local">
  	<Locale id="{concat(@language, '_', @country)}" language="{@language}" country="{@country}">
  	  <PatternConfiguration type="boolean" pattern="{PATTERN[@webmltype = 'Boolean']/@value}"/>
  	  <PatternConfiguration type="date" pattern="{PATTERN[@webmltype = 'Date']/@value}"/>
  	  <PatternConfiguration type="decimal">
		<xsl:attribute name="maxDecimal">
		  <xsl:value-of select="localeHelper:getMaxDecimalPrecision($localeHelperInstance, PATTERN[@webmltype = 'Number'])"/>
		</xsl:attribute>
		<xsl:attribute name="minDecimal">
		  <xsl:value-of select="localeHelper:getMinDecimalPrecision($localeHelperInstance, PATTERN[@webmltype = 'Number'])"/>
		</xsl:attribute>
		<xsl:attribute name="minInteger">
		  <xsl:value-of select="localeHelper:getMinDigitsPrecision($localeHelperInstance, PATTERN[@webmltype = 'Number'])"/>
		</xsl:attribute>
		<xsl:attribute name="useThousandSeparator">
		  <xsl:value-of select="localeHelper:getUseThousandSeparator($localeHelperInstance, PATTERN[@webmltype = 'Number'])"/>
		</xsl:attribute>
  	  </PatternConfiguration>
  	  <PatternConfiguration type="float">
		<xsl:attribute name="maxDecimal">
		  <xsl:value-of select="localeHelper:getMaxDecimalPrecision($localeHelperInstance, PATTERN[@webmltype = 'Float'])"/>
		</xsl:attribute>
		<xsl:attribute name="minDecimal">
		  <xsl:value-of select="localeHelper:getMinDecimalPrecision($localeHelperInstance, PATTERN[@webmltype = 'Float'])"/>
		</xsl:attribute>
		<xsl:attribute name="minInteger">
		  <xsl:value-of select="localeHelper:getMinDigitsPrecision($localeHelperInstance, PATTERN[@webmltype = 'Float'])"/>
		</xsl:attribute>
		<xsl:attribute name="useThousandSeparator">
		  <xsl:value-of select="localeHelper:getUseThousandSeparator($localeHelperInstance, PATTERN[@webmltype = 'Float'])"/>
		</xsl:attribute>
  	  </PatternConfiguration>
  	  <PatternConfiguration type="integer">
		<xsl:attribute name="minInteger">
		  <xsl:value-of select="localeHelper:getMinDigitsPrecision($localeHelperInstance, PATTERN[@webmltype = 'Integer'])"/>
		</xsl:attribute>
		<xsl:attribute name="useThousandSeparator">
		  <xsl:value-of select="localeHelper:getUseThousandSeparator($localeHelperInstance, PATTERN[@webmltype = 'Integer'])"/>
		</xsl:attribute>
  	  </PatternConfiguration>
  	  <PatternConfiguration type="time" pattern="{PATTERN[@webmltype = 'Time']/@value}"/>
  	  <PatternConfiguration type="timestamp" pattern="{PATTERN[@webmltype = 'TimeStamp']/@value}"/>
  	  <xsl:for-each select="PATTERN[string(@subType) != '']">
  	    <xsl:variable name="subTypeId" select="@subType"/>
  	    <xsl:variable name="type" select="@webmltype"/>
  	    <PatternConfiguration type="{$subTypeId}">
  	      <xsl:choose>
  	        <xsl:when test="$type = 'Float' or $type = 'Number'">
			  <xsl:attribute name="maxDecimal">
			    <xsl:value-of select="localeHelper:getMaxDecimalPrecision($localeHelperInstance, .)"/>
			  </xsl:attribute>
			  <xsl:attribute name="minDecimal">
			    <xsl:value-of select="localeHelper:getMinDecimalPrecision($localeHelperInstance, .)"/>
			  </xsl:attribute>
			  <xsl:attribute name="minInteger">
			    <xsl:value-of select="localeHelper:getMinDigitsPrecision($localeHelperInstance, .)"/>
			  </xsl:attribute>
			  <xsl:attribute name="useThousandSeparator">
			    <xsl:value-of select="localeHelper:getUseThousandSeparator($localeHelperInstance, .)"/>
  			  </xsl:attribute>
  	        </xsl:when>
  	        <xsl:when test="$type = 'Integer'">
			  <xsl:attribute name="minInteger">
			    <xsl:value-of select="localeHelper:getMinDigitsPrecision($localeHelperInstance, .)"/>
			  </xsl:attribute>
			  <xsl:attribute name="useThousandSeparator">
			    <xsl:value-of select="localeHelper:getUseThousandSeparator($localeHelperInstance, .)"/>
  			  </xsl:attribute>
  	        </xsl:when>
  	        <xsl:otherwise>
			  <xsl:attribute name="pattern">
			    <xsl:value-of select="@value"/>
  			  </xsl:attribute>
  	        </xsl:otherwise>
  	      </xsl:choose>
  	    </PatternConfiguration>
  	  </xsl:for-each>
  	</Locale>
  </xsl:template>
  
  <xsl:template match="SITEVIEW">
    <SiteView id="{@id}" name="{@name}" layout:style="{@presentation:style-sheet}">
      <xsl:if test="string(@homePage) != ''">
        <xsl:attribute name="homePage"><xsl:value-of select="@homePage"/></xsl:attribute>
      </xsl:if>
      <xsl:if test="string(@presentation:page-layout) != ''">
        <xsl:attribute name="layout:pageLayout">
			<xsl:choose>
      			<xsl:when test="@presentation:page-layout = 'autocomplete'">
      				<xsl:text>WRDefault/Autocomplete</xsl:text>
      			</xsl:when>
      			<xsl:when test="@presentation:page-layout = 'iframe'">
      				<xsl:text>WRDefault/Empty</xsl:text>
      			</xsl:when>
				<xsl:otherwise>
        			<xsl:value-of select="@presentation:style-sheet"/>/<xsl:value-of select="@presentation:page-layout"/>
        		</xsl:otherwise>
        	</xsl:choose>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="string(@presentation:link-visibility-policy) != ''">
         <xsl:attribute name="linkVisibilityPolicy">
         	<xsl:value-of select="@presentation:link-visibility-policy"/>
		</xsl:attribute>
      </xsl:if>
      <xsl:if test="@protected = 'yes'">
        <xsl:attribute name="protected">true</xsl:attribute>
      </xsl:if>
      <xsl:if test="@secure = 'yes'">
        <xsl:attribute name="secure">true</xsl:attribute>
      </xsl:if>
      <xsl:if test="@localize = 'yes'">
        <xsl:attribute name="localized">true</xsl:attribute>
      </xsl:if>
      <xsl:if test="string(@presentation:filename) != ''">
        <xsl:attribute name="customURLName"><xsl:value-of select="@presentation:filename" /></xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="." mode="landmarks-attr"/>
      <xsl:apply-templates select="*[not(self::GLOBALPARAMETER)]"/>
    </SiteView>
  </xsl:template>

  <xsl:template match="SERVICEVIEW">
  	<ServiceView id="{@id}" name="{@name}">
  		<xsl:if test="@secure = 'yes'">
  			<xsl:attribute name="secure">true</xsl:attribute>
  		</xsl:if>
  		<xsl:apply-templates select="*"/>
  	</ServiceView>
  </xsl:template>
  
  <xsl:template match="PORT">
  	<Port id="{@id}" name="{@name}" gr:x="{fn:x(@id)}" gr:y="{fn:y(@id)}">
  		<xsl:if test="@secure = 'yes'">
  			<xsl:attribute name="secure">true</xsl:attribute>
  		</xsl:if>
  		<xsl:apply-templates select="*"/>
  	</Port>
  </xsl:template>
   
  <xsl:template match="AREA">
    <Area id="{@id}" name="{@name}" gr:x="{fn:x(@id)}" gr:y="{fn:y(@id)}">
       <xsl:apply-templates select="." mode="landmarks-attr"/>
       <xsl:if test="@localize = 'yes'">
        <xsl:attribute name="localized">true</xsl:attribute>
      </xsl:if>
      <xsl:if test="string(@presentation:page-layout) != ''">
      	<xsl:attribute name="layout:pageLayout">
			<xsl:choose>
      			<xsl:when test="@presentation:page-layout = 'autocomplete'">
      				<xsl:text>WRDefault/Autocomplete</xsl:text>
      			</xsl:when>
      			<xsl:when test="@presentation:page-layout = 'iframe'">
      				<xsl:text>WRDefault/Empty</xsl:text>
      			</xsl:when>
				<xsl:otherwise>
        			<xsl:value-of select="ancestor::SITEVIEW/@presentation:style-sheet"/>/<xsl:value-of select="@presentation:page-layout"/>
        		</xsl:otherwise>
        	</xsl:choose>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@landmark = 'yes'">
        <xsl:attribute name="landmark">true</xsl:attribute>
      </xsl:if>
      <xsl:if test="string(@presentation:link-visibility-policy) != ''">
         <xsl:attribute name="linkVisibilityPolicy">
         	<xsl:value-of select="@presentation:link-visibility-policy"/>
		</xsl:attribute>
      </xsl:if>
      <xsl:if test="@protected = 'yes'">
        <xsl:attribute name="protected">true</xsl:attribute>
      </xsl:if>
      <xsl:if test="@secure = 'yes'">
        <xsl:attribute name="secure">true</xsl:attribute>
      </xsl:if>
      <xsl:if test="string(@presentation:filename) != ''">
        <xsl:attribute name="customURLName"><xsl:value-of select="@presentation:filename" /></xsl:attribute>
      </xsl:if>
      <xsl:choose>
        <xsl:when test="string(@defaultPage) != ''">
      	  <xsl:attribute name="defaultPage">
      		<xsl:value-of select="@defaultPage"/>
       	  </xsl:attribute>
        </xsl:when>
        <xsl:when test="string(@defaultArea) != ''">
      	  <xsl:attribute name="defaultArea">
      		<xsl:value-of select="@defaultArea"/>
       	  </xsl:attribute>
        </xsl:when>
      </xsl:choose>
      <xsl:apply-templates select="*"/>
    </Area>
    <xsl:call-template name="sendTaskWorked"/>
  </xsl:template>
   
  <!-- AJAX -->
  <xsl:template match="PAGE[parent::PAGE and PROPERTY[@name ='ajax-window']]"/>
  
  <!--<xsl:template match="PROPERTY[@name='event' or @name='indicator' or @name='token' or @name='minChars' or @name='modal' or @name='width' or @name='height' or @name='title' or @name='ajax' or @name='tooltip' or @name='iframe' or @name='cascade-select' or @name='ajax-window' or @name='close-window' or @name='show-progress-dialog' or @name='autocomplete' or @name='autocomplete-depends' or @name='ajax-tooltip' or @name='drag' or @name='onDrop' or @name='sortable' or @name='blur' or @name='change' or @name='focus']"/>-->
  
  <xsl:template match="PAGE">
    <Page id="{@id}" name="{@name}" gr:x="{fn:x(@id)}" gr:y="{fn:y(@id)}">
      <xsl:choose>
      	<xsl:when test="(PROPERTY[@name = 'template']) and (string(@presentation:page-layout) = 'Jasper')">
      		<xsl:attribute name="layout:style">Reports</xsl:attribute>
      		<xsl:variable name="dummy" select="map:put($reports, string(@name), string(PROPERTY[@name = 'template']/@value))"/>
      	</xsl:when>
      	<xsl:otherwise>
      		<xsl:if test="string(@presentation:page-layout) != ''">
	          <xsl:attribute name="layout:pageLayout">
	      		<xsl:choose>
	      			<xsl:when test="@presentation:page-layout = 'autocomplete'">
	      				<xsl:text>WRDefault/Autocomplete</xsl:text>
	      			</xsl:when>
	      			<xsl:when test="@presentation:page-layout = 'iframe'">
	      				<xsl:text>WRDefault/Empty</xsl:text>
	      			</xsl:when>
    				<xsl:otherwise>
	        			<xsl:value-of select="ancestor::SITEVIEW/@presentation:style-sheet"/>/<xsl:value-of select="@presentation:page-layout"/>
	        		</xsl:otherwise>
	        	</xsl:choose>
		      </xsl:attribute>
	        </xsl:if>
      	</xsl:otherwise>
      </xsl:choose>
      
      <xsl:if test="string(@presentation:link-visibility-policy) != ''">
         <xsl:attribute name="linkVisibilityPolicy">
         	<xsl:value-of select="@presentation:link-visibility-policy"/>
		</xsl:attribute>
      </xsl:if>
      <xsl:if test="@landmark = 'yes'">
        <xsl:attribute name="landmark">true</xsl:attribute>
      </xsl:if>
      <xsl:if test="@localize = 'yes'">
        <xsl:attribute name="localized">true</xsl:attribute>
      </xsl:if>
      <xsl:if test="@protected = 'yes'">
        <xsl:attribute name="protected">true</xsl:attribute>
      </xsl:if>
      <xsl:if test="@secure = 'yes'">
        <xsl:attribute name="secure">true</xsl:attribute>
      </xsl:if>
      <xsl:if test="string(@presentation:filename) != ''">
        <xsl:attribute name="customURLName"><xsl:value-of select="@presentation:filename" /></xsl:attribute>
      </xsl:if>
      
      <!-- AJAX -->
      <xsl:if test="PROPERTY[@name='ajax']">
        <xsl:attribute name="ajaxEnabled">true</xsl:attribute>
      </xsl:if>
      <xsl:if test="not(CONTENTUNITS)">
        <ContentUnits/>
      </xsl:if>
      <xsl:apply-templates select="*"/>
    </Page>
    <xsl:for-each select="PAGE[PROPERTY[@name ='ajax-window']]">
		<Page id="{@id}" name="{@name}" gr:x="{fn:x(@id)}" gr:y="{fn:y(@id)}">
		  <xsl:variable name="page-id" select="@id"/>
	      <xsl:attribute name="layout:pageLayout">WRDefault/Empty</xsl:attribute>
	      <xsl:if test="string(@presentation:link-visibility-policy) != ''">
	         <xsl:attribute name="linkVisibilityPolicy">
	         	<xsl:value-of select="@presentation:link-visibility-policy"/>
			</xsl:attribute>
	      </xsl:if>
	      <xsl:if test="@landmark = 'yes'">
	        <xsl:attribute name="landmark">true</xsl:attribute>
	      </xsl:if>
	      <xsl:if test="@localize = 'yes'">
	        <xsl:attribute name="localized">true</xsl:attribute>
	      </xsl:if>
	      <xsl:if test="@protected = 'yes'">
	        <xsl:attribute name="protected">true</xsl:attribute>
	      </xsl:if>
	      <xsl:if test="@secure = 'yes'">
	        <xsl:attribute name="secure">true</xsl:attribute>
	      </xsl:if>
	      <!-- AJAX -->
	      <xsl:if test="PROPERTY[@name='ajax']">
	        <xsl:attribute name="ajaxEnabled">true</xsl:attribute>
	      </xsl:if>
	      <xsl:if test="not(CONTENTUNITS)">
	        <ContentUnits/>
	      </xsl:if>
	      <xsl:apply-templates select="*[not(self::presentation:grid)]"/>
	      <xsl:apply-templates select="ancestor::PAGE//presentation:grid[ancestor::presentation:subpage[key('id',@page)[PROPERTY[@name='ajax-window']]]]"/>
	    </Page>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template match="MASTERPAGE">
    <MasterPage id="{@id}" name="{@name}" gr:x="{fn:x(@id)}" gr:y="{fn:y(@id)}">
      <xsl:if test="@localize = 'yes'">
        <xsl:attribute name="localized">true</xsl:attribute>
      </xsl:if>
      <xsl:if test="not(CONTENTUNITS)">
        <ContentUnits/>
      </xsl:if>
      <xsl:apply-templates select="*"/>
    </MasterPage>
  </xsl:template>

  <xsl:template match="TRANSACTION">
    <OperationGroup id="{@id}" name="{@name}" transaction="true" gr:x="{fn:x(@id)}" gr:y="{fn:y(@id)}">
      <xsl:apply-templates select="*"/>
    </OperationGroup>
  </xsl:template>
  
  <xsl:template match="LINKSEQUENCE">
    <xsl:variable name="id">
      <xsl:apply-templates select="." mode="link-seq-id"/>
    </xsl:variable>
    <LinkSequence id="{$id}" name="{@name}" links="{@links}"/>
  </xsl:template>
  
  <xsl:template match="LINKSEQUENCE" mode="link-seq-id">
    <xsl:text>lnseq</xsl:text>
    <xsl:number level="any"/>
  </xsl:template>
  
  <xsl:template match="*" mode="link-seq-id"/>

  <xsl:template match="CUSTOMLINKPROPAGATIONS">
    <xsl:variable name="id">
      <xsl:apply-templates select="." mode="link-prop-id"/>
    </xsl:variable>
    <xsl:variable name="linkSequenceName" select="@linkSequence"/>
    <xsl:variable name="linkSequenceId">
      <xsl:apply-templates select="../LINKSEQUENCE[@name = $linkSequenceName]" mode="link-seq-id"/>    
    </xsl:variable>
    <CustomLinkPropagations id="{$id}" linkSequence="{$linkSequenceId}" navigatedLink="{@navigatedLink}"/>
  </xsl:template>

  <xsl:template match="CUSTOMLINKPROPAGATIONS" mode="link-prop-id">
    <xsl:text>lnpr</xsl:text>
    <xsl:number level="any"/>
  </xsl:template>
  
  <xsl:template match="*" mode="link-prop-id"/>

  <xsl:template match="GLOBALPARAMETER">
    <ContextParameter id="{@id}" name="{@name}">
      <xsl:choose>
        <xsl:when test="string(@entity) != ''">
          <xsl:attribute name="entity">
            <xsl:value-of select="@entity"/>
          </xsl:attribute>
          <xsl:attribute name="type">entity</xsl:attribute>
        </xsl:when>
        <xsl:when test="string(@type) != ''">
	      <xsl:attribute name="type">
	        <xsl:choose>
	          <xsl:when test="@type = 'BLOB'">blob</xsl:when>
	          <xsl:when test="@type = 'Boolean'">boolean</xsl:when>
	          <xsl:when test="@type = 'Date'">date</xsl:when>
	          <xsl:when test="@type = 'Float'">float</xsl:when>
	          <xsl:when test="@type = 'Integer'">integer</xsl:when>
	          <xsl:when test="@type = 'Number'">decimal</xsl:when>
	          <xsl:when test="@type = 'OID'">integer</xsl:when>
	          <xsl:when test="@type = 'Password'">password</xsl:when>
	          <xsl:when test="@type = 'String'">string</xsl:when>
	          <xsl:when test="@type = 'Text'">text</xsl:when>
	          <xsl:when test="@type = 'Time'">time</xsl:when>
	          <xsl:when test="@type = 'TimeStamp'">timestamp</xsl:when>
	          <xsl:when test="@type = 'URL'">url</xsl:when>
	          <xsl:otherwise>string</xsl:otherwise>
	        </xsl:choose>
	      </xsl:attribute>
        </xsl:when>
      </xsl:choose>
    </ContextParameter>
  </xsl:template>
  
  <xsl:template match="ALTERNATIVE">
    <Alternative id="{@id}" name="{@name}" gr:x="{fn:x(@id)}" gr:y="{fn:y(@id)}" defaultPage="{@defaultPage}">
      <xsl:if test="string(@defaultPage) != ''">
      	  <xsl:attribute name="defaultPage">
      		<xsl:value-of select="@defaultPage"/>
       	  </xsl:attribute>
        </xsl:if>
      <xsl:apply-templates select="*"/>
    </Alternative>
  </xsl:template>
  
  <xsl:template match="CONTENTUNITS">
    <ContentUnits>
      <xsl:apply-templates select="*"/>
      <xsl:if test="parent::PAGE[parent::ALTERNATIVE]">
        <xsl:apply-templates select="parent::PAGE" mode="alt-page-links"/>
      </xsl:if>
    </ContentUnits>
  </xsl:template>

  <xsl:template match="OPERATIONUNITS">
    <OperationUnits>
      <xsl:apply-templates select="*"/>
    </OperationUnits>
  </xsl:template>

  <xsl:template match="*" mode="copy-default-attributes">
    <xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
    <xsl:attribute name="name"><xsl:value-of select="@name"/></xsl:attribute>
    <xsl:attribute name="gr:x"><xsl:value-of select="fn:x(@id)"/></xsl:attribute>
    <xsl:attribute name="gr:y"><xsl:value-of select="fn:y(@id)"/></xsl:attribute>
    <xsl:if test="(@landmark = 'yes') and parent::OPERATIONUNITS and not(ancestor::SERVICEVIEW)">
      <xsl:attribute name="landmark">true</xsl:attribute>
    </xsl:if> 
    <xsl:if test="@secure = 'yes'">
      <xsl:attribute name="secure">true</xsl:attribute>
    </xsl:if>
    <xsl:if test="@auxiliary:custom-descriptor = 'yes'">
      <xsl:attribute name="customDescriptor">true</xsl:attribute>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="CONTENTUNITS/*" priority="-0.25">
    <xsl:element name="{name(.)}">
      <xsl:apply-templates select="." mode="copy-default-attributes"/>
      <!-- AJAX -->
      <xsl:if test="LINK[PROPERTY[@name='tooltip']]">
      	<xsl:attribute name="ajaxTooltipEnabled">true</xsl:attribute>
      	<xsl:attribute name="ajaxTooltipElement">custom</xsl:attribute>
      	<xsl:attribute name="ajaxTooltipEvent">
      		<xsl:variable name="event" select="LINK[PROPERTY[@name='tooltip']]/PROPERTY[@name='event']/@value"/>
      		<xsl:if test="$event != 'mouseover'">
      			<xsl:value-of select="$event"/>
      		</xsl:if>
      	</xsl:attribute>
      	<xsl:attribute name="ajaxTooltipLink"><xsl:value-of select="LINK[PROPERTY[@name='tooltip']][1]/@id"/></xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="@*[name(.) != 'id' and name(.) != 'name' and name(.) != 'gr:x' and name(.) != 'gr:y' and name(.) != 'landmark' and name(.) != 'secure' and name(.) != 'customDescriptor']" mode="copy-all"/>
      <xsl:apply-templates select="*[not(self::LINK) and not(self::COMMENT) and not(self::PROPERTY)]" mode="copy-all"/>
      <xsl:apply-templates select="LINK|PROPERTY|COMMENT"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="OPERATIONUNITS/*" priority="-0.25">
    <xsl:element name="{name(.)}">
      <xsl:apply-templates select="." mode="copy-default-attributes"/>
      <xsl:apply-templates select="@*[name(.) != 'id' and name(.) != 'name' and name(.) != 'gr:x' and name(.) != 'gr:y' and name(.) != 'landmark' and name(.) != 'secure' and name(.) != 'customDescriptor']" mode="copy-all"/>
      <xsl:apply-templates select="*[not(self::LINK) and not(self::OK-LINK) and not(self::KO-LINK) and not(self::COMMENT) and not(self::PROPERTY)]" mode="copy-all"/>
      <xsl:apply-templates select="LINK|OK-LINK|KO-LINK|PROPERTY|COMMENT"/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="*|@*|comment()|processing-instruction()|text()" mode="copy-all">
    <xsl:copy>
      <xsl:apply-templates select="*|@*|comment()| processing-instruction()|text()" mode="copy-all"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="COMMENT">
    <Comment xml:space="preserve"><xsl:apply-templates select="*|comment()| processing-instruction()|text()" mode="copy-all"/></Comment>
  </xsl:template>
 
  <!-- AJAX -->
  <xsl:template match="XMLHTTPREQUESTUNIT">
    <OperationUnit>
      <xsl:apply-templates select="." mode="copy-default-attributes"/>
      <xsl:apply-templates select="*"/>
    </OperationUnit>
  </xsl:template>
  
  <!-- STANDARD UNITS -->
  
  <xsl:template match="CREATEUNIT">
    <CreateUnit entity="{@entity}">
      <xsl:apply-templates select="." mode="copy-default-attributes"/>
      <xsl:apply-templates select="*"/>
    </CreateUnit>
  </xsl:template>
  
  
  <xsl:template match="CONNECTUNIT">
    <ConnectUnit relationship="{@relationship}">
      <xsl:apply-templates select="." mode="copy-default-attributes"/>
	     <xsl:choose>
            <xsl:when test="SOURCESELECTOR">
            <SourceSelector booleanOperator="{SOURCESELECTOR/@booleanOperator}" id="{@id}ssel">
              <xsl:for-each select="SOURCESELECTOR/SELECTORCONDITION">
                 <xsl:apply-templates select="."/>
              </xsl:for-each>
              </SourceSelector>
            </xsl:when>
            <xsl:otherwise>
               <SourceSelector booleanOperator="and" id="{@id}ssel">
                  <KeyCondition id="{@id}SourceKey" predicate="in"/>
               </SourceSelector>
            </xsl:otherwise>
         </xsl:choose> 
         <xsl:choose>
            <xsl:when test="TARGETSELECTOR">
              <TargetSelector booleanOperator="{TARGETSELECTOR/@booleanOperator}" id="{@id}tsel">
              <xsl:for-each select="TARGETSELECTOR/SELECTORCONDITION">
                 <xsl:apply-templates select="."/>
              </xsl:for-each>
              </TargetSelector>
            </xsl:when>
            <xsl:otherwise>
               <TargetSelector booleanOperator="and" id="{@id}tsel">
                  <KeyCondition id="{@id}TargetKey" predicate="in"/>
               </TargetSelector>
            </xsl:otherwise>
         </xsl:choose> 
       <xsl:apply-templates select="*[not(self::SOURCESELECTOR) and not(self::TARGETSELECTOR)]"/>
    </ConnectUnit>
  </xsl:template>
  
  <xsl:template match="DATAUNIT">
    <DataUnit entity="{@entity}">
      <xsl:apply-templates select="." mode="copy-default-attributes"/>
      <!-- AJAX -->
      <xsl:if test="LINK[PROPERTY[@name='tooltip']]">
      	<xsl:attribute name="ajaxTooltipEnabled">true</xsl:attribute>
      	<xsl:attribute name="ajaxTooltipElement">custom</xsl:attribute>
      	<xsl:attribute name="ajaxTooltipEvent">
      		<xsl:variable name="event" select="LINK[PROPERTY[@name='tooltip']]/PROPERTY[@name='event']/@value"/>
      		<xsl:if test="$event != 'mouseover'">
      			<xsl:value-of select="$event"/>
      		</xsl:if>
      	</xsl:attribute>
      	<xsl:attribute name="ajaxTooltipLink"><xsl:value-of select="LINK[PROPERTY[@name='tooltip']][1]/@id"/></xsl:attribute>
      </xsl:if>
      <xsl:if test="LINK[PROPERTY[@name='drag']]">
      	  	<xsl:attribute name="ajaxDragEnabled">true</xsl:attribute>
      	  	<xsl:attribute name="ajaxDragLink"><xsl:value-of select="LINK[PROPERTY[@name='drag']]/@id"/></xsl:attribute>
      </xsl:if>
      <xsl:if test="LINK[PROPERTY[@name='drop' or @name = 'onDrop']]">
      	  	<xsl:attribute name="ajaxDropEnabled">true</xsl:attribute>
      	  	<xsl:attribute name="ajaxDropLink"><xsl:value-of select="LINK[PROPERTY[@name='drop' or @name = 'onDrop']]/@id"/></xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="."  mode="newDisplayAttributes"/>
      <xsl:if test="DISPLAYALL">
        <xsl:attribute name="displayAll">true</xsl:attribute>
        <!--
        <xsl:attribute name="displayAttributes">
          <xsl:apply-templates select="key('entity', @entity)" mode="attributes"/>
        </xsl:attribute>
        -->
      </xsl:if>
           
      <xsl:choose>
        <xsl:when test="SELECTOR/SELECTORCONDITION">
          <xsl:apply-templates select="SELECTOR"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="oidParamName" select="concat(@id, '.oid')"/>
          <xsl:if test="key('incoming-any-links', @id)">
            <Selector id="{@id}sel" booleanOperator="and">
              <KeyCondition id="{@id}key" predicate="in"/>
            </Selector>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*[not(self::SELECTOR)]"/>
    </DataUnit>
  </xsl:template>

  <xsl:template match="DELETEUNIT">
    <DeleteUnit entity="{@entity}">
      <xsl:apply-templates select="." mode="copy-default-attributes"/>
      <xsl:if test="not(SELECTOR/SELECTORCONDITION) and
                    key('incoming-any-links', @id)">
        <Selector id="{@id}sel" booleanOperator="and">
          <KeyCondition id="{@id}key" predicate="in"/>
        </Selector>
      </xsl:if>
      <xsl:apply-templates select="*"/>
  	</DeleteUnit>
  </xsl:template>
  
  <xsl:template match="DISCONNECTUNIT">
    <DisconnectUnit relationship="{@relationship}">
      <xsl:apply-templates select="." mode="copy-default-attributes"/>
	     <xsl:choose>
            <xsl:when test="SOURCESELECTOR">
            <SourceSelector booleanOperator="{SOURCESELECTOR/@booleanOperator}" id="{@id}ssel">
              <xsl:for-each select="SOURCESELECTOR/SELECTORCONDITION">
                
                 <xsl:apply-templates select="."/>
                
              </xsl:for-each>
              </SourceSelector>
            </xsl:when>
            <xsl:otherwise>
               <SourceSelector booleanOperator="and" id="{@id}ssel">
                  <KeyCondition id="{@id}SourceKey" predicate="in"/>
               </SourceSelector>
            </xsl:otherwise>
         </xsl:choose> 
         <xsl:choose>
            <xsl:when test="TARGETSELECTOR">
              <TargetSelector booleanOperator="{TARGETSELECTOR/@booleanOperator}" id="{@id}tsel">
              <xsl:for-each select="TARGETSELECTOR/SELECTORCONDITION">
                 <xsl:apply-templates select="."/>
              </xsl:for-each>
              </TargetSelector>
            </xsl:when>
            <xsl:otherwise>
               <TargetSelector booleanOperator="and" id="{@id}tsel">
                  <KeyCondition id="{@id}TargetKey" predicate="in"/>
               </TargetSelector>
            </xsl:otherwise>
         </xsl:choose>
       <xsl:apply-templates select="*[not(self::SOURCESELECTOR) and not(self::TARGETSELECTOR)]"/>
    </DisconnectUnit>
  </xsl:template>
  
  <xsl:template match="ENTRYUNIT">
    <EntryUnit>
      <xsl:apply-templates select="." mode="copy-default-attributes"/>
      <!-- AJAX -->
      <xsl:if test="LINK[PROPERTY[@name='tooltip']]">
      	<xsl:attribute name="ajaxTooltipEnabled">true</xsl:attribute>
      	<xsl:attribute name="ajaxTooltipElement">custom</xsl:attribute>
      	<xsl:attribute name="ajaxTooltipEvent">
      		<xsl:variable name="event" select="LINK[PROPERTY[@name='tooltip']]/PROPERTY[@name='event']/@value"/>
      		<xsl:if test="$event != 'mouseover'">
      			<xsl:value-of select="$event"/>
      		</xsl:if>
      	</xsl:attribute>
      	<xsl:attribute name="ajaxTooltipLink"><xsl:value-of select="LINK[PROPERTY[@name='tooltip']][1]/@id"/></xsl:attribute>
      </xsl:if>
      <xsl:for-each select="FIELD | SELECTIONFIELD | MULTISELECTIONFIELD">
      	<xsl:choose>
      		<xsl:when test="name() = 'FIELD'">
		        <Field id="{@id}" name="{@name}"> 
		      	  <xsl:if test="@preloaded = 'yes'">
		      		<xsl:attribute name="preloaded">
		      			<xsl:text>true</xsl:text>
		      		</xsl:attribute>
		      	  </xsl:if>
		      	  <xsl:if test="@modifiable='yes'">
		      		<xsl:attribute name="modifiable">
		      			<xsl:text>true</xsl:text>
		      		</xsl:attribute>
		      	  </xsl:if>
		      	  <xsl:if test="@hidden='yes'">
		      		<xsl:attribute name="hidden">
		      			<xsl:text>true</xsl:text>
		      		</xsl:attribute>
		      	  </xsl:if>
		      	  <xsl:if test="string(@contentType) != ''">
		      		<xsl:attribute name="contentType">
		      			<xsl:value-of select="@contentType"/>
		      		</xsl:attribute>
		      	  </xsl:if>
		          <xsl:if test="string(@subType) != ''">
		            <xsl:attribute name="subType">
		      		  <xsl:value-of select="@subType"/>
		      	    </xsl:attribute>
		          </xsl:if>
		      	  <xsl:if test="string(@type) != ''">
				      <xsl:attribute name="type">
				        <xsl:choose>
				          <xsl:when test="@type = 'BLOB'">blob</xsl:when>
				          <xsl:when test="@type = 'Boolean'">boolean</xsl:when>
				          <xsl:when test="@type = 'Date'">date</xsl:when>
				          <xsl:when test="@type = 'Float'">float</xsl:when>
				          <xsl:when test="@type = 'Integer'">integer</xsl:when>
				          <xsl:when test="@type = 'Number'">decimal</xsl:when>
				          <xsl:when test="@type = 'OID'">integer</xsl:when>
				          <xsl:when test="@type = 'Password'">password</xsl:when>
				          <xsl:when test="@type = 'String'">string</xsl:when>
				          <xsl:when test="@type = 'Text'">text</xsl:when>
				          <xsl:when test="@type = 'Time'">time</xsl:when>
				          <xsl:when test="@type = 'TimeStamp'">timestamp</xsl:when>
				          <xsl:when test="@type = 'URL'">url</xsl:when>
				          <xsl:otherwise>string</xsl:otherwise>
				        </xsl:choose>
				      </xsl:attribute>
		      	  </xsl:if>
		      	  <!-- AJAX -->
		      	  <xsl:variable name="fieldId" select="@id"/>
		      	  <xsl:if test="../LINK[PROPERTY[(@name='focus' or @name='blur' or @name='change') and @value = $fieldId]]">
			      	<xsl:variable name="eventLinkProperty" select="../LINK/PROPERTY[(@name='focus' or @name='blur' or @name='change') and @value = $fieldId]"/>
			      	<xsl:attribute name="ajaxEventEnabled">true</xsl:attribute>
			      	<xsl:attribute name="ajaxEventType">
			      		<xsl:if test="$eventLinkProperty/@name!='change'"><xsl:value-of select="$eventLinkProperty/@name"/></xsl:if></xsl:attribute>
			      	<xsl:attribute name="ajaxEventLink"><xsl:value-of select="$eventLinkProperty/@value"/></xsl:attribute>
			      </xsl:if>
		      	  <xsl:if test="PROPERTY[@name='iframe']">
		      	  	<xsl:attribute name="ajaxUploadEnabled">true</xsl:attribute>
		      	  	<xsl:attribute name="ajaxUploadPage"><xsl:value-of select="key('id', ../LINK[PROPERTY[@name = 'iframe']]/@to)[1]/ancestor-or-self::PAGE/@id"/></xsl:attribute>
		      	  	<xsl:attribute name="ajaxUploadPageWidth"><xsl:value-of select="PROPERTY[@name = 'width']/@value"/></xsl:attribute>
		      	  	<xsl:attribute name="ajaxUploadPageHeight"><xsl:value-of select="PROPERTY[@name = 'height']/@value"/></xsl:attribute>
		      	  </xsl:if>
		      	  <xsl:if test="PROPERTY[@name='autocomplete']">
		      	  	<xsl:attribute name="ajaxAutocompleteEnabled">true</xsl:attribute>
		      	  	<xsl:attribute name="ajaxAutocompleteLink"><xsl:value-of select="../LINK[PROPERTY[@name='autocomplete']][LINKPARAMETER[@source=$fieldId]]/@id"/></xsl:attribute>
		      	  	<xsl:attribute name="ajaxAutocompleteType">
		      	  		<xsl:if test="PROPERTY[@name='useId']">selectionField</xsl:if>
		      	  	</xsl:attribute>
		      	  	<xsl:if test="PROPERTY[@name='token']">
			      	  	<xsl:attribute name="ajaxAutocompleteTokens">	
			      	  		<xsl:for-each select="PROPERTY[@name='token']"><xsl:value-of select="PROPERTY[@name='token']/@value"/><xsl:if test="position() != last()">&#160;</xsl:if></xsl:for-each>
			      	  	</xsl:attribute>
		      	  	</xsl:if>
		      	  	<xsl:if test="PROPERTY[@name='minChars']">
			      	  	<xsl:attribute name="ajaxAutocompleteMinChars"><xsl:value-of select="PROPERTY[@name='minChars']/@value"/></xsl:attribute>
			      	</xsl:if>
			      	<xsl:if test="PROPERTY[@name='indicator']">
			      	  	<xsl:attribute name="ajaxAutocompleteIndicator"><xsl:value-of select="PROPERTY[@name='indicator']/@value"/></xsl:attribute>
			      	</xsl:if>
		      	  	<xsl:attribute name="ajaxAutocompleteType">
		      	  		<xsl:if test="PROPERTY[@name='useId']">selectionField</xsl:if>
		      	  	</xsl:attribute>
		      	  	<xsl:if test="key('autocomplete-depends', $fieldId)[1]">
		      	  		<xsl:attribute name="ajaxAutocompleteDepending">
			      	  		<xsl:value-of select="key('autocomplete-depends', $fieldId)[1]/../@id"/>
			      	  	</xsl:attribute>
		      	  	</xsl:if>
		      	  </xsl:if>
		      	  <xsl:apply-templates select="*"/>
		      	</Field>
      		</xsl:when>
      		<xsl:when test="name() = 'SELECTIONFIELD'">
		      	<SelectionField id="{@id}" name="{@name}">
		      	   <xsl:if test="string(@preselectValue) != ''">
		      		<xsl:attribute name="preselectValue">
		      			<xsl:value-of select="@preselectValue"/>
		      		</xsl:attribute>
		      	  </xsl:if>
		          <xsl:if test="string(@subType) != ''">
		            <xsl:attribute name="subType">
		      		  <xsl:value-of select="@subType"/>
		      	    </xsl:attribute>
		          </xsl:if>
		      	   <xsl:if test="string(@type) != ''">
				      <xsl:attribute name="type">
				        <xsl:choose>
				          <xsl:when test="@type = 'BLOB'">blob</xsl:when>
				          <xsl:when test="@type = 'Boolean'">boolean</xsl:when>
				          <xsl:when test="@type = 'Date'">date</xsl:when>
				          <xsl:when test="@type = 'Float'">float</xsl:when>
				          <xsl:when test="@type = 'Integer'">integer</xsl:when>
				          <xsl:when test="@type = 'Number'">decimal</xsl:when>
				          <xsl:when test="@type = 'OID'">integer</xsl:when>
				          <xsl:when test="@type = 'Password'">password</xsl:when>
				          <xsl:when test="@type = 'String'">string</xsl:when>
				          <xsl:when test="@type = 'Text'">text</xsl:when>
				          <xsl:when test="@type = 'Time'">time</xsl:when>
				          <xsl:when test="@type = 'TimeStamp'">timestamp</xsl:when>
				          <xsl:when test="@type = 'URL'">url</xsl:when>
				          <xsl:otherwise>string</xsl:otherwise>
				        </xsl:choose>
				      </xsl:attribute>
		      	  </xsl:if>
		      	  <!-- AJAX -->
		      	  <xsl:variable name="fieldId" select="@id"/>
		      	  <xsl:if test="../LINK[PROPERTY[(@name='focus' or @name='blur' or @name='change') and @value = $fieldId]]">
			      	<xsl:variable name="eventLinkProperty" select="../LINK/PROPERTY[(@name='focus' or @name='blur' or @name='change') and @value = $fieldId]"/>
			      	<xsl:attribute name="ajaxEventEnabled">true</xsl:attribute>
			      	<xsl:attribute name="ajaxEventType">
			      		<xsl:if test="$eventLinkProperty/@name!='change'"><xsl:value-of select="$eventLinkProperty/@name"/></xsl:if></xsl:attribute>
			      	<xsl:attribute name="ajaxEventLink"><xsl:value-of select="$eventLinkProperty/@value"/></xsl:attribute>
			      </xsl:if>
		      	  <xsl:if test="PROPERTY[@name = 'cascade-select']">
		      	  	<xsl:attribute name="ajaxEventEnabled">true</xsl:attribute>
		      	  	<xsl:attribute name="ajaxEventLink"><xsl:value-of select="ancestor::ENTRYUNIT/LINK[PROPERTY[@name='ajax' and @value='preload']]/@id"/></xsl:attribute>
		      	  </xsl:if>
		      	  <xsl:apply-templates select="*"/>
		      	</SelectionField>
      		</xsl:when>
      		<xsl:when test="name() = 'MULTISELECTIONFIELD'">
		         <MultiSelectionField id="{@id}" name="{@name}">
		           <xsl:if test="string(@preselectValue) != ''">
		      		<xsl:attribute name="preselectValue">
		      			<xsl:value-of select="@preselectValue"/>
		      		</xsl:attribute>
		      	  </xsl:if>
		          <xsl:if test="string(@subType) != ''">
		            <xsl:attribute name="subType">
		      		  <xsl:value-of select="@subType"/>
		      	    </xsl:attribute>
		          </xsl:if>
		      	   <xsl:if test="string(@type) != ''">
				      <xsl:attribute name="type">
				        <xsl:choose>
				          <xsl:when test="@type = 'BLOB'">blob</xsl:when>
				          <xsl:when test="@type = 'Boolean'">boolean</xsl:when>
				          <xsl:when test="@type = 'Date'">date</xsl:when>
				          <xsl:when test="@type = 'Float'">float</xsl:when>
				          <xsl:when test="@type = 'Integer'">integer</xsl:when>
				          <xsl:when test="@type = 'Number'">decimal</xsl:when>
				          <xsl:when test="@type = 'OID'">integer</xsl:when>
				          <xsl:when test="@type = 'Password'">password</xsl:when>
				          <xsl:when test="@type = 'String'">string</xsl:when>
				          <xsl:when test="@type = 'Text'">text</xsl:when>
				          <xsl:when test="@type = 'Time'">time</xsl:when>
				          <xsl:when test="@type = 'TimeStamp'">timestamp</xsl:when>
				          <xsl:when test="@type = 'URL'">url</xsl:when>
				          <xsl:otherwise>string</xsl:otherwise>
				        </xsl:choose>
				      </xsl:attribute>
		      	  </xsl:if>
		      	  <xsl:variable name="fieldId" select="@id"/>
		      	  <xsl:if test="../LINK[PROPERTY[(@name='focus' or @name='blur' or @name='change') and @value = $fieldId]]">
			      	<xsl:variable name="eventLinkProperty" select="../LINK/PROPERTY[(@name='focus' or @name='blur' or @name='change') and @value = $fieldId]"/>
			      	<xsl:attribute name="ajaxEventEnabled">true</xsl:attribute>
			      	<xsl:attribute name="ajaxEventType">
			      		<xsl:if test="$eventLinkProperty/@name!='change'"><xsl:value-of select="$eventLinkProperty/@name"/></xsl:if></xsl:attribute>
			      	<xsl:attribute name="ajaxEventLink"><xsl:value-of select="$eventLinkProperty/@value"/></xsl:attribute>
			      </xsl:if>
		      	  <xsl:apply-templates select="*"/>
		         </MultiSelectionField>
      		</xsl:when>
      	</xsl:choose>
      </xsl:for-each>
      <xsl:apply-templates select="*"/>
    </EntryUnit>
  </xsl:template>
  
  <xsl:template match="MULTISELECTIONFIELD/SLOT | FIELD/SLOT | SELECTIONFIELD/SLOT">
	  	<Slot id="{@id}" name="{@name}">
	  	  <xsl:if test="string(@value) != ''">
	      	<xsl:attribute name="value">
	            <xsl:choose>
	              <xsl:when test="parent::FIELD"><xsl:value-of select="@value"/></xsl:when>
	              <xsl:otherwise><xsl:value-of select="stringutils:replace(@value,',','|')"/></xsl:otherwise>
	            </xsl:choose>
	      	</xsl:attribute>
	      </xsl:if>
	      <xsl:if test="@output = 'yes'">
	      	<xsl:attribute name="output">
	      		<xsl:text>true</xsl:text>
	      	</xsl:attribute>
	      </xsl:if>
	      <xsl:if test="@label = 'yes'">
	      	<xsl:attribute name="label">
	      		<xsl:text>true</xsl:text>
	      	</xsl:attribute>
	      </xsl:if>
	      <xsl:apply-templates select="*"/>
	  	</Slot>
  </xsl:template>
  
  <xsl:template match="MULTISELECTIONFIELD/VALIDATIONRULE | FIELD/VALIDATIONRULE | SELECTIONFIELD/VALIDATIONRULE | VALIDATIONRULE">
  	<ValidationRule id="{@id}" name="{@name}">
  	  <xsl:if test="string(@predicate) != ''">
      	<xsl:attribute name="predicate">
      	   <xsl:choose>
      	     <xsl:when test="@predicate = 'number'">
      	     	<xsl:text>decimal</xsl:text>
      	     </xsl:when>
      	     <xsl:otherwise>
      	        <xsl:value-of select="@predicate"/>
      	     </xsl:otherwise>
      	   </xsl:choose>
      	</xsl:attribute>
      </xsl:if>
      <xsl:if test="string(@value) != ''">
      	<xsl:attribute name="value">
      	   <xsl:choose>
      	     <xsl:when test="@predicate = 'in' or @predicate = 'notIn'">
      	        <xsl:value-of select="stringutils:replace(@value,';','|')"/>
      	     </xsl:when>
      	     <xsl:otherwise>
      		  <xsl:value-of select="@value"/>
      		 </xsl:otherwise>
      	   </xsl:choose>
      	</xsl:attribute>
      </xsl:if>
      <xsl:if test="string(@message) != ''">
      	<xsl:attribute name="message">
      		<xsl:value-of select="@message"/>
      	</xsl:attribute>
      </xsl:if>
      <xsl:if test="string(@class) != ''">
      	<xsl:attribute name="class">
      		<xsl:value-of select="@class"/>
      	</xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="*"/>
  	</ValidationRule>
  </xsl:template>
  
  
   <xsl:template match="MULTISELECTIONFIELD/CHECKVALIDATION">
  	<CheckValidation id="{@id}" name="{@name}">
  	  <xsl:if test="string(@predicate) != ''">
      	<xsl:attribute name="predicate">
      	   <xsl:choose>
      	     <xsl:when test="@predicate = 'number'">
      	     	<xsl:text>decimal</xsl:text>
      	     </xsl:when>
      	     <xsl:otherwise>
      	        <xsl:value-of select="@predicate"/>
      	     </xsl:otherwise>
      	   </xsl:choose>
      	</xsl:attribute>
      </xsl:if>
      <xsl:if test="string(@value) != ''">
      	<xsl:attribute name="value">
      		<xsl:value-of select="@value"/>
      	</xsl:attribute>
      </xsl:if>
      <xsl:if test="string(@message) != ''">
      	<xsl:attribute name="message">
      		<xsl:value-of select="@message"/>
      	</xsl:attribute>
      </xsl:if>
      <xsl:if test="string(@class) != ''">
      	<xsl:attribute name="class">
      		<xsl:value-of select="@class"/>
      	</xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="*"/>
  	</CheckValidation>
  </xsl:template>
  
  <xsl:template match="HIERARCHICALINDEXUNIT">
    <HierarchicalIndexUnit entity="{@entity}">
      <xsl:apply-templates select="." mode="copy-default-attributes"/>
      <!-- AJAX -->
      <xsl:if test="LINK[PROPERTY[@name='tooltip']]">
      	<xsl:attribute name="ajaxTooltipEnabled">true</xsl:attribute>
      	<xsl:attribute name="ajaxTooltipElement">custom</xsl:attribute>
      	<xsl:attribute name="ajaxTooltipEvent">
      		<xsl:variable name="event" select="LINK[PROPERTY[@name='tooltip']]/PROPERTY[@name='event']/@value"/>
      		<xsl:if test="$event != 'mouseover'">
      			<xsl:value-of select="$event"/>
      		</xsl:if>
      	</xsl:attribute>
      	<xsl:attribute name="ajaxTooltipLink"><xsl:value-of select="LINK[PROPERTY[@name='tooltip']][1]/@id"/></xsl:attribute>
      </xsl:if>
      <xsl:if test="LINK[PROPERTY[@name='drag']]">
      	  	<xsl:attribute name="ajaxDragEnabled">true</xsl:attribute>
      	  	<xsl:attribute name="ajaxDragLink"><xsl:value-of select="LINK[PROPERTY[@name='drag']]/@id"/></xsl:attribute>
      </xsl:if>
      <xsl:if test="LINK[PROPERTY[@name='drop' or @name = 'onDrop']]">
      	  	<xsl:attribute name="ajaxDropEnabled">true</xsl:attribute>
      	  	<xsl:attribute name="ajaxDropLink"><xsl:value-of select="LINK[PROPERTY[@name='drop' or @name = 'onDrop']]/@id"/></xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="."  mode="newDisplayAttributes"/>
      <xsl:choose>
        <xsl:when test="SELECTOR/SELECTORCONDITION">
          <xsl:apply-templates select="SELECTOR"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="oidParamName" select="concat(@id, '.oid.set')"/>
          <xsl:if test="key('incoming-any-links', @id)[LINKPARAMETER[@target = $oidParamName]]">
            <Selector id="{@id}sel" booleanOperator="and">
              <KeyCondition id="{@id}key" predicate="in"/>
            </Selector>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*[not(self::SELECTOR)]"/>
    </HierarchicalIndexUnit>
  </xsl:template>
  
    <xsl:template match="HIERARCHICALINDEXUNIT/HIERARCHICALINDEXLEVEL | HIERARCHICALINDEXLEVEL/HIERARCHICALINDEXLEVEL">
    <HierarchicalIndexLevel 
        id="{@id}" name="{@name}" 
        entity="{@entity}" role="{@relationship}">
      <xsl:apply-templates select="."  mode="newDisplayAttributes"/>
      <xsl:choose>
        <xsl:when test="SELECTOR/SELECTORCONDITION">
          <xsl:apply-templates select="SELECTOR"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="oidParamName" select="concat(@id, '.oid.set')"/>
          <xsl:if test="key('incoming-any-links', @id)[LINKPARAMETER[@target = $oidParamName]]">
            <Selector id="{@id}sel" booleanOperator="and">
              <KeyCondition id="{@id}key" predicate="in"/>
            </Selector>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*[not(self::SELECTOR)]"/>
    </HierarchicalIndexLevel>
  </xsl:template>
  
  <xsl:template match="ENTITY" mode="attributes">
     <xsl:for-each select="ATTRIBUTE[string(@type) != 'OID']">
     	<xsl:value-of select="@id"/>
     	<xsl:text> </xsl:text>
     </xsl:for-each>
     <xsl:if test="@superEntity != ''">
     	<xsl:apply-templates select="key('entity', @superEntity)" mode="attributes"/>
     </xsl:if>
  </xsl:template>
  
  <xsl:template match="INDEXUNIT">
    <IndexUnit entity="{@entity}">
      <xsl:apply-templates select="." mode="copy-default-attributes"/>
      <xsl:if test="@distinct = 'yes'">
        <xsl:attribute name="distinct">true</xsl:attribute>
      </xsl:if>
      <!-- AJAX -->
      <xsl:if test="LINK[PROPERTY[@name='tooltip']]">
      	<xsl:attribute name="ajaxTooltipEnabled">true</xsl:attribute>
      	<xsl:attribute name="ajaxTooltipElement">custom</xsl:attribute>
      	<xsl:attribute name="ajaxTooltipEvent">
      		<xsl:variable name="event" select="LINK[PROPERTY[@name='tooltip']]/PROPERTY[@name='event']/@value"/>
      		<xsl:if test="$event != 'mouseover'">
      			<xsl:value-of select="$event"/>
      		</xsl:if>
      	</xsl:attribute>
      	<xsl:attribute name="ajaxTooltipLink"><xsl:value-of select="LINK[PROPERTY[@name='tooltip']][1]/@id"/></xsl:attribute>
      </xsl:if>
      <xsl:if test="LINK[PROPERTY[@name='drag']]">
      	  	<xsl:attribute name="ajaxDragEnabled">true</xsl:attribute>
      	  	<xsl:attribute name="ajaxDragLink"><xsl:value-of select="LINK[PROPERTY[@name='drag']]/@id"/></xsl:attribute>
      </xsl:if>
      <xsl:if test="LINK[PROPERTY[@name='drop' or @name = 'onDrop']]">
      	  	<xsl:attribute name="ajaxDropEnabled">true</xsl:attribute>
      	  	<xsl:attribute name="ajaxDropLink"><xsl:value-of select="LINK[PROPERTY[@name='drop' or @name = 'onDrop']]/@id"/></xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="."  mode="newDisplayAttributes"/>
      <xsl:choose>
        <xsl:when test="SELECTOR/SELECTORCONDITION">
          <xsl:apply-templates select="SELECTOR"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="oidParamName" select="concat(@id, '.oid.set')"/>
          <xsl:if test="key('incoming-any-links', @id)[LINKPARAMETER[@target = $oidParamName]]">
            <Selector id="{@id}sel" booleanOperator="and">
              <KeyCondition id="{@id}key" predicate="in"/>
            </Selector>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*[not(self::SELECTOR)]"/>
      
    </IndexUnit>
  </xsl:template>

  <xsl:template match="MODIFYUNIT">
    <ModifyUnit entity="{@entity}">
      <xsl:apply-templates select="." mode="copy-default-attributes"/>
      <xsl:if test="not(SELECTOR/SELECTORCONDITION) and
                    key('incoming-any-links', @id)">
        <Selector id="{@id}sel" booleanOperator="and">
          <KeyCondition id="{@id}key" predicate="in"/>
        </Selector>
      </xsl:if>
      <xsl:apply-templates select="*"/>
    </ModifyUnit>
  </xsl:template>
  
  <xsl:template match="MULTICHOICEINDEXUNIT">
    <MultiChoiceIndexUnit entity="{@entity}">
      <xsl:apply-templates select="." mode="copy-default-attributes"/>
      <xsl:if test="@distinct = 'yes'">
        <xsl:attribute name="distinct">true</xsl:attribute>
      </xsl:if>
      <!-- AJAX -->
      <xsl:if test="LINK[PROPERTY[@name='tooltip']]">
      	<xsl:attribute name="ajaxTooltipEnabled">true</xsl:attribute>
      	<xsl:attribute name="ajaxTooltipElement">custom</xsl:attribute>
      	<xsl:attribute name="ajaxTooltipEvent">
      		<xsl:variable name="event" select="LINK[PROPERTY[@name='tooltip']]/PROPERTY[@name='event']/@value"/>
      		<xsl:if test="$event != 'mouseover'">
      			<xsl:value-of select="$event"/>
      		</xsl:if>
      	</xsl:attribute>
      	<xsl:attribute name="ajaxTooltipLink"><xsl:value-of select="LINK[PROPERTY[@name='tooltip']][1]/@id"/></xsl:attribute>
      </xsl:if>
      <xsl:if test="LINK[PROPERTY[@name='drag']]">
      	  	<xsl:attribute name="ajaxDragEnabled">true</xsl:attribute>
      	  	<xsl:attribute name="ajaxDragLink"><xsl:value-of select="LINK[PROPERTY[@name='drag']]/@id"/></xsl:attribute>
      </xsl:if>
      <xsl:if test="LINK[PROPERTY[@name='drop' or @name = 'onDrop']]">
      	  	<xsl:attribute name="ajaxDropEnabled">true</xsl:attribute>
      	  	<xsl:attribute name="ajaxDropLink"><xsl:value-of select="LINK[PROPERTY[@name='drop' or @name = 'onDrop']]/@id"/></xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="."  mode="newDisplayAttributes"/>
      <xsl:choose>
        <xsl:when test="PRESELECTOR/SELECTORCONDITION">
          <PreSelector booleanOperator="{PRESELECTOR/@booleanOperator}" id="{@id}psel">
            <xsl:for-each select="PRESELECTOR/SELECTORCONDITION">
              <xsl:apply-templates select="."/>
            </xsl:for-each>
          </PreSelector>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="oidParamName" select="concat(@id, '.pre.oid.set')"/>
          <xsl:if test="key('incoming-any-links', @id)[LINKPARAMETER[@target = $oidParamName]]">
            <PreSelector id="{@id}psel" booleanOperator="and">
              <KeyCondition id="{@id}prekey" predicate="in"/>
            </PreSelector>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:choose>
        <xsl:when test="SELECTOR/SELECTORCONDITION">
          <xsl:apply-templates select="SELECTOR"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="oidParamName" select="concat(@id, '.oid.set')"/>
          <xsl:if test="key('incoming-any-links', @id)[LINKPARAMETER[@target = $oidParamName]]">
            <Selector id="{@id}sel" booleanOperator="and">
              <KeyCondition id="{@id}key" predicate="in"/>
            </Selector>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*[not(self::SELECTOR) and not(self::PRESELECTOR)]"/>
    </MultiChoiceIndexUnit>
  </xsl:template>
  
  <xsl:template match="MULTICHOICEINDEXUNIT/CHECKVALIDATION">
  	<CheckValidation id="{@id}" name="{@name}">
  	  <xsl:if test="string(@predicate) != ''">
      	<xsl:attribute name="predicate">
      	   <xsl:choose>
      	     <xsl:when test="@predicate = 'number'">
      	     	<xsl:text>decimal</xsl:text>
      	     </xsl:when>
      	     <xsl:otherwise>
      	        <xsl:value-of select="@predicate"/>
      	     </xsl:otherwise>
      	   </xsl:choose>
      	</xsl:attribute>
      </xsl:if>
      <xsl:if test="string(@value) != ''">
      	<xsl:attribute name="value">
      		<xsl:value-of select="@value"/>
      	</xsl:attribute>
      </xsl:if>
      <xsl:if test="string(@message) != ''">
      	<xsl:attribute name="message">
      		<xsl:value-of select="@message"/>
      	</xsl:attribute>
      </xsl:if>
      <xsl:if test="string(@class) != ''">
      	<xsl:attribute name="class">
      		<xsl:value-of select="@class"/>
      	</xsl:attribute>
      </xsl:if>
  	</CheckValidation>
  </xsl:template>
  
  <xsl:template match="MULTIDATAUNIT">
    <MultiDataUnit entity="{@entity}">
      <xsl:apply-templates select="." mode="copy-default-attributes"/>
      <xsl:if test="@distinct = 'yes'">
        <xsl:attribute name="distinct">true</xsl:attribute>
      </xsl:if>
      <!-- AJAX -->
      <xsl:if test="LINK[PROPERTY[@name='tooltip']]">
      	<xsl:attribute name="ajaxTooltipEnabled">true</xsl:attribute>
      	<xsl:attribute name="ajaxTooltipElement">custom</xsl:attribute>
      	<xsl:attribute name="ajaxTooltipEvent">
      		<xsl:variable name="event" select="LINK[PROPERTY[@name='tooltip']]/PROPERTY[@name='event']/@value"/>
      		<xsl:if test="$event != 'mouseover'">
      			<xsl:value-of select="$event"/>
      		</xsl:if>
      	</xsl:attribute>
      	<xsl:attribute name="ajaxTooltipLink"><xsl:value-of select="LINK[PROPERTY[@name='tooltip']][1]/@id"/></xsl:attribute>
      </xsl:if>
      <xsl:if test="LINK[PROPERTY[@name='drag']]">
      	  	<xsl:attribute name="ajaxDragEnabled">true</xsl:attribute>
      	  	<xsl:attribute name="ajaxDragLink"><xsl:value-of select="LINK[PROPERTY[@name='drag']]/@id"/></xsl:attribute>
      </xsl:if>
      <xsl:if test="LINK[PROPERTY[@name='drop' or @name = 'onDrop']]">
      	  	<xsl:attribute name="ajaxDropEnabled">true</xsl:attribute>
      	  	<xsl:attribute name="ajaxDropLink"><xsl:value-of select="LINK[PROPERTY[@name='drop' or @name = 'onDrop']]/@id"/></xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="."  mode="newDisplayAttributes"/>
      <xsl:choose>
        <xsl:when test="SELECTOR/SELECTORCONDITION">
          <xsl:apply-templates select="SELECTOR"/>
        </xsl:when>
        <xsl:otherwise>
		  <xsl:variable name="oidParamName" select="concat(@id, '.oid.set')"/>
		  <xsl:if test="key('incoming-any-links', @id)[LINKPARAMETER[@target = $oidParamName]]">
            <Selector id="{@id}sel" booleanOperator="and">
              <KeyCondition id="{@id}key" predicate="in"/>
            </Selector>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*[not(self::SELECTOR)]"/>
    </MultiDataUnit>
  </xsl:template>
  
  <xsl:template match="SCROLLERUNIT">
    <ScrollerUnit entity="{@entity}">
      <xsl:apply-templates select="." mode="copy-default-attributes"/>
      <xsl:if test="string(@blockFactor) != ''">
        <xsl:attribute name="blockFactor">
           <xsl:value-of select="@blockFactor"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="string(@blockWindow) != '' and string(@blockWindow) != '0'">
        <xsl:attribute name="blockWindow">
           <xsl:value-of select="@blockWindow"/>
        </xsl:attribute>
      </xsl:if>
      <!-- AJAX -->
      <xsl:if test="LINK[PROPERTY[@name='tooltip']]">
      	<xsl:attribute name="ajaxTooltipEnabled">true</xsl:attribute>
      	<xsl:attribute name="ajaxTooltipElement">custom</xsl:attribute>
      	<xsl:attribute name="ajaxTooltipEvent">
      		<xsl:variable name="event" select="LINK[PROPERTY[@name='tooltip']]/PROPERTY[@name='event']/@value"/>
      		<xsl:if test="$event != 'mouseover'">
      			<xsl:value-of select="$event"/>
      		</xsl:if>
      	</xsl:attribute>
      	<xsl:attribute name="ajaxTooltipLink"><xsl:value-of select="LINK[PROPERTY[@name='tooltip']][1]/@id"/></xsl:attribute>
      </xsl:if>
      <xsl:choose>
        <xsl:when test="SELECTOR/SELECTORCONDITION">
          <xsl:apply-templates select="SELECTOR"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="oidParamName" select="concat(@id, '.oid.set')"/>
          <xsl:if test="key('incoming-any-links', @id)[LINKPARAMETER[@target = $oidParamName]]">
            <Selector id="{@id}sel" booleanOperator="and">
              <KeyCondition id="{@id}key" predicate="in"/>
            </Selector>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*[not(self::SELECTOR)]"/>
    </ScrollerUnit>
  </xsl:template>
  
  
  <xsl:template match="MULTIVIEWEVENTCALENDARUNIT">
    <MultiViewEventCalendarUnit entity="{@entity}" endDate="{@end-date-att}" startDate="{@start-date-att}" 
    shortMonths="{@shortMonths}" shortWeekdays="{@shortWeekdays}"
    viewMode="{@view-mode}" years="{@years}"
    availabilityEntity="{@availability-entity}"
    availabilityEndDate="{@availability-end-date-att}" availabilityStartDate="{@availability-start-date-att}">
      <xsl:apply-templates select="." mode="copy-default-attributes"/>
    	<!-- AJAX -->
      	<xsl:if test="LINK[PROPERTY[@name='tooltip']]">
	      	<xsl:attribute name="ajaxTooltipEnabled">true</xsl:attribute>
	      	<xsl:attribute name="ajaxTooltipElement">custom</xsl:attribute>
	      	<xsl:attribute name="ajaxTooltipEvent">
      		<xsl:variable name="event" select="LINK[PROPERTY[@name='tooltip']]/PROPERTY[@name='event']/@value"/>
	      		<xsl:if test="$event != 'mouseover'">
	      			<xsl:value-of select="$event"/>
	      		</xsl:if>
      		</xsl:attribute>
	      	<xsl:attribute name="ajaxTooltipLink"><xsl:value-of select="LINK[PROPERTY[@name='tooltip']][1]/@id"/></xsl:attribute>
      	</xsl:if>
      	<xsl:if test="LINK[PROPERTY[@name='drag']]">
      	  	<xsl:attribute name="ajaxDragEnabled">true</xsl:attribute>
      	  	<xsl:attribute name="ajaxDragLink"><xsl:value-of select="LINK[PROPERTY[@name='drag']]/@id"/></xsl:attribute>
	    </xsl:if>
	    <xsl:if test="LINK[PROPERTY[@name='drop' or @name = 'onDrop']]">
	      	  	<xsl:attribute name="ajaxDropEnabled">true</xsl:attribute>
	      	  	<xsl:attribute name="ajaxDropLink"><xsl:value-of select="LINK[PROPERTY[@name='drop' or @name = 'onDrop']]/@id"/></xsl:attribute>
	    </xsl:if>
		<xsl:attribute name="shortMonths">
	    	<xsl:choose>
	    	<xsl:when test="@shortMonths = 'yes'">true</xsl:when>
	    	<xsl:otherwise>false</xsl:otherwise>
	    	</xsl:choose>
	    </xsl:attribute>
	    <xsl:attribute name="shortWeekdays">
	    	<xsl:choose>
	    	<xsl:when test="@shortWeekdays = 'yes'">true</xsl:when>
	    	<xsl:otherwise>false</xsl:otherwise>
	    	</xsl:choose>
	    </xsl:attribute>
	    <xsl:attribute name="useAvailability">
	    	<xsl:choose>
	    	<xsl:when test="@availability = 'yes'">true</xsl:when>
	    	<xsl:otherwise>false</xsl:otherwise>
	    	</xsl:choose>
	    </xsl:attribute>
	    <xsl:attribute name="useEntity">
	    	<xsl:choose>
	    	<xsl:when test="@entity-based = 'yes'">true</xsl:when>
	    	<xsl:otherwise>false</xsl:otherwise>
	    	</xsl:choose>
	    </xsl:attribute>
      <xsl:apply-templates select="."  mode="newDisplayAttributes"/>
      <xsl:choose>
        <xsl:when test="SELECTOR/SELECTORCONDITION">
          <xsl:apply-templates select="SELECTOR"/>
        </xsl:when>
        <xsl:when test="SELECTOR-AVAILABILITY/SELECTORCONDITION">
          <xsl:apply-templates select="SELECTOR-AVAILABILITY"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="oidParamName" select="concat(@id, '.oid.set')"/>
          <xsl:if test="key('incoming-any-links', @id)">
            <Selector id="{@id}sel" booleanOperator="and">
              <KeyCondition id="{@id}key" predicate="in"/>
            </Selector>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*[not(self::SELECTOR)]"/>
    </MultiViewEventCalendarUnit>
  </xsl:template>
  
  <xsl:template match="CHECKEVENTSCONFLICTSUNIT">
    <CheckEventsConflictsUnit entity="{@entity}" endDate="{@end-date-att}" startDate="{@start-date-att}" 
    availabilityEntity="{@availability-entity}" errorMessage="{@error-message-key}"
    availabilityEndDate="{@availability-end-date-att}" availabilityStartDate="{@availability-start-date-att}">
      <xsl:apply-templates select="." mode="copy-default-attributes"/>
		<xsl:attribute name="useAvailability">
	    	<xsl:choose>
	    	<xsl:when test="@availability = 'yes'">true</xsl:when>
	    	<xsl:otherwise>false</xsl:otherwise>
	    	</xsl:choose>
	    </xsl:attribute>
      <xsl:choose>
        <xsl:when test="SELECTOR/SELECTORCONDITION">
          <xsl:apply-templates select="SELECTOR"/>
        </xsl:when>
        <xsl:when test="SELECTOR-AVAILABILITY/SELECTORCONDITION">
          <xsl:apply-templates select="SELECTOR-AVAILABILITY"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="oidParamName" select="concat(@id, '.oid.set')"/>
          <xsl:if test="key('incoming-any-links', @id)">
            <Selector id="{@id}sel" booleanOperator="and">
              <KeyCondition id="{@id}key" predicate="in"/>
            </Selector>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*[not(self::SELECTOR)]"/>
    </CheckEventsConflictsUnit>
  </xsl:template>
  
  <xsl:template match="BULKCHECKEVENTSCONFLICTSUNIT">
    <CheckEventsConflictsUnit bulk="true" entity="{@entity}" endDate="{@end-date-att}" startDate="{@start-date-att}" 
    availabilityEntity="{@availability-entity}" errorMessage="{@error-message-key}"
    availabilityEndDate="{@availability-end-date-att}" availabilityStartDate="{@availability-start-date-att}">
      <xsl:apply-templates select="." mode="copy-default-attributes"/>
		<xsl:attribute name="useAvailability">
	    	<xsl:choose>
	    	<xsl:when test="@availability = 'yes'">true</xsl:when>
	    	<xsl:otherwise>false</xsl:otherwise>
	    	</xsl:choose>
	    </xsl:attribute>
      <xsl:choose>
        <xsl:when test="SELECTOR/SELECTORCONDITION">
          <xsl:apply-templates select="SELECTOR"/>
        </xsl:when>
        <xsl:when test="SELECTOR-AVAILABILITY/SELECTORCONDITION">
          <xsl:apply-templates select="SELECTOR-AVAILABILITY"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="oidParamName" select="concat(@id, '.oid.set')"/>
          <xsl:if test="key('incoming-any-links', @id)">
            <Selector id="{@id}sel" booleanOperator="and">
              <KeyCondition id="{@id}key" predicate="in"/>
            </Selector>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*[not(self::SELECTOR)]"/>
    </CheckEventsConflictsUnit>
  </xsl:template>
  
  <xsl:template match="FREESLOTUNIT">
    <FreeSlotUnit entity="{@entity}" endDate="{@end-date-att}" startDate="{@start-date-att}" 
    availabilityEntity="{@availability-entity}"
    availabilityEndDate="{@availability-end-date-att}" availabilityStartDate="{@availability-start-date-att}"
    blockFactor="{@block-factor}" startingHour="{@start-hour}" endingHour="{@end-hour}"
    searchSlot="{@search-slot}" searchStep="{@search-step}"
    >
      <xsl:apply-templates select="." mode="copy-default-attributes"/>
    	<!-- AJAX -->
      	<xsl:if test="LINK[PROPERTY[@name='tooltip']]">
	      	<xsl:attribute name="ajaxTooltipEnabled">true</xsl:attribute>
	      	<xsl:attribute name="ajaxTooltipElement">custom</xsl:attribute>
	      	<xsl:attribute name="ajaxTooltipEvent">
	      		<xsl:variable name="event" select="LINK[PROPERTY[@name='tooltip']]/PROPERTY[@name='event']/@value"/>
	      		<xsl:if test="$event != 'mouseover'">
	      			<xsl:value-of select="$event"/>
	      		</xsl:if>
	      	</xsl:attribute>
	      	<xsl:attribute name="ajaxTooltipLink"><xsl:value-of select="LINK[PROPERTY[@name='tooltip']][1]/@id"/></xsl:attribute>
      	</xsl:if>
      	<xsl:if test="LINK[PROPERTY[@name='drag']]">
      	  	<xsl:attribute name="ajaxDragEnabled">true</xsl:attribute>
      	  	<xsl:attribute name="ajaxDragLink"><xsl:value-of select="LINK[PROPERTY[@name='drag']]/@id"/></xsl:attribute>
	    </xsl:if>
	    <xsl:if test="LINK[PROPERTY[@name='drop' or @name = 'onDrop']]">
      	  	<xsl:attribute name="ajaxDropEnabled">true</xsl:attribute>
      	  	<xsl:attribute name="ajaxDropLink"><xsl:value-of select="LINK[PROPERTY[@name='drop' or @name = 'onDrop']]/@id"/></xsl:attribute>
	    </xsl:if>
		  <xsl:attribute name="useAvailability">
	    	<xsl:choose>
	    	  	<xsl:when test="@availability = 'yes'">true</xsl:when>
	    		<xsl:otherwise>false</xsl:otherwise>
	    	</xsl:choose>
	      </xsl:attribute>
      <xsl:apply-templates select="."  mode="newDisplayAttributes"/>
	      <xsl:choose>
	        <xsl:when test="SELECTOR/SELECTORCONDITION">
	          <xsl:apply-templates select="SELECTOR"/>
	        </xsl:when>
	        <xsl:when test="SELECTOR-AVAILABILITY/SELECTORCONDITION">
	          <xsl:apply-templates select="SELECTOR-AVAILABILITY"/>
	        </xsl:when>
	        <xsl:otherwise>
	          <xsl:variable name="oidParamName" select="concat(@id, '.oid.set')"/>
	          <xsl:if test="key('incoming-any-links', @id)">
	            <Selector id="{@id}sel" booleanOperator="and">
	              <KeyCondition id="{@id}key" predicate="in"/>
	            </Selector>
	          </xsl:if>
	        </xsl:otherwise>
	      </xsl:choose>
	      <xsl:apply-templates select="*[not(self::SELECTOR)]"/>
    </FreeSlotUnit>
  </xsl:template>
  
  <xsl:template match="SELECTOR-AVAILABILITY">
    <AvailabilitySelector booleanOperator="{@booleanOperator}" defaultPolicy="{@defaultPolicy}" id="{../@id}av-sel">
      <xsl:apply-templates select="*"/>
    </AvailabilitySelector>
  </xsl:template>
  
  <xsl:template match="MULTIMESSAGEUNIT|MESSAGEUNIT">
    <MultiMessageUnit>
      <xsl:apply-templates select="." mode="copy-default-attributes"/>
      <!-- AJAX -->
      <xsl:if test="LINK[PROPERTY[@name='tooltip']]">
      	<xsl:attribute name="ajaxTooltipEnabled">true</xsl:attribute>
      	<xsl:attribute name="ajaxTooltipElement">custom</xsl:attribute>
      	<xsl:attribute name="ajaxTooltipEvent">
      		<xsl:variable name="event" select="LINK[PROPERTY[@name='tooltip']]/PROPERTY[@name='event']/@value"/>
      		<xsl:if test="$event != 'mouseover'">
      			<xsl:value-of select="$event"/>
      		</xsl:if>
      	</xsl:attribute>
      	<xsl:attribute name="ajaxTooltipLink"><xsl:value-of select="LINK[PROPERTY[@name='tooltip']][1]/@id"/></xsl:attribute>
      </xsl:if>
      <xsl:if test="LINK[PROPERTY[@name='drag']]">
      	  	<xsl:attribute name="ajaxDragEnabled">true</xsl:attribute>
      	  	<xsl:attribute name="ajaxDragLink"><xsl:value-of select="LINK[PROPERTY[@name='drag']]/@id"/></xsl:attribute>
      </xsl:if>
      <xsl:if test="LINK[PROPERTY[@name='drop' or @name = 'onDrop']]">
      	  	<xsl:attribute name="ajaxDropEnabled">true</xsl:attribute>
      	  	<xsl:attribute name="ajaxDropLink"><xsl:value-of select="LINK[PROPERTY[@name='drop' or @name = 'onDrop']]/@id"/></xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="*"/>
    </MultiMessageUnit>
  </xsl:template>
  
  
  <xsl:template match="RECURSIVETREEUNIT">
    <RecursiveHierarchicalIndexUnit entity="{@entity}" relationship="{key('id', @relationship)/@inverse}">
      <xsl:apply-templates select="." mode="copy-default-attributes"/>
      <xsl:if test="ROOTSELECTOR and string(ROOTSELECTOR/@removeChildren) != 'yes'">
         <xsl:attribute name="showAllAsRoot">true</xsl:attribute>
      </xsl:if>
      <!-- AJAX -->
      <xsl:if test="LINK[PROPERTY[@name='tooltip']]">
      	<xsl:attribute name="ajaxTooltipEnabled">true</xsl:attribute>
      	<xsl:attribute name="ajaxTooltipElement">custom</xsl:attribute>
      	<xsl:attribute name="ajaxTooltipEvent">
      		<xsl:variable name="event" select="LINK[PROPERTY[@name='tooltip']]/PROPERTY[@name='event']/@value"/>
      		<xsl:if test="$event != 'mouseover'">
      			<xsl:value-of select="$event"/>
      		</xsl:if>
      	</xsl:attribute>
      	<xsl:attribute name="ajaxTooltipLink"><xsl:value-of select="LINK[PROPERTY[@name='tooltip']][1]/@id"/></xsl:attribute>
      </xsl:if>
      <xsl:if test="LINK[PROPERTY[@name='drag']]">
      	  	<xsl:attribute name="ajaxDragEnabled">true</xsl:attribute>
      	  	<xsl:attribute name="ajaxDragLink"><xsl:value-of select="LINK[PROPERTY[@name='drag']]/@id"/></xsl:attribute>
      </xsl:if>
      <xsl:if test="LINK[PROPERTY[@name='drop' or @name = 'onDrop']]">
      	  	<xsl:attribute name="ajaxDropEnabled">true</xsl:attribute>
      	  	<xsl:attribute name="ajaxDropLink"><xsl:value-of select="LINK[PROPERTY[@name='drop' or @name = 'onDrop']]/@id"/></xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="."  mode="newDisplayAttributes"/>
      <xsl:if test="ROOTSELECTOR/SELECTORCONDITION">
         <RootSelector booleanOperator="{ROOTSELECTOR/@booleanOperator}" id="{@id}psel">
           <xsl:for-each select="ROOTSELECTOR/SELECTORCONDITION">
             <xsl:apply-templates select="."/>
           </xsl:for-each>
         </RootSelector>
      </xsl:if>
      <xsl:choose>
        <xsl:when test="SELECTOR/SELECTORCONDITION">
          <xsl:apply-templates select="SELECTOR"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="oidParamName" select="concat(@id, '.oid.set')"/>
          <xsl:if test="key('incoming-any-links', @id)[LINKPARAMETER[@target = $oidParamName]]">
            <Selector id="{@id}sel" booleanOperator="and">
              <KeyCondition id="{@id}key" predicate="in"/>
            </Selector>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*[not(self::SELECTOR) and not(self::ROOTSELECTOR)]"/>
    </RecursiveHierarchicalIndexUnit>
  </xsl:template>
  
  <!-- END STANDARD UNITS -->
  
  <!-- ADVANCED UNITS -->
  
  <xsl:template match="BULKCREATEUNIT">
    <CreateUnit entity="{@entity}" bulk="true">
      <xsl:apply-templates select="." mode="copy-default-attributes"/>
      <xsl:apply-templates select="*"/>
    </CreateUnit>
  </xsl:template>
  
  <xsl:template match="BULKMODIFYUNIT">
    <ModifyUnit entity="{@entity}" bulk="true">
      <xsl:apply-templates select="." mode="copy-default-attributes"/>
      <xsl:if test="not(SELECTOR/SELECTORCONDITION)">
        <Selector id="{@id}sel" booleanOperator="and">
          <KeyCondition id="{@id}key" predicate="in"/>
        </Selector>
      </xsl:if>
      <xsl:apply-templates select="*"/>
    </ModifyUnit>
  </xsl:template>
  
  <xsl:template match="EVENTCALENDARUNIT">
    <EventCalendarUnit>
      <xsl:apply-templates select="." mode="copy-default-attributes"/>
      <!-- AJAX -->
      <xsl:if test="LINK[PROPERTY[@name='tooltip']]">
      	<xsl:attribute name="ajaxTooltipEnabled">true</xsl:attribute>
      	<xsl:attribute name="ajaxTooltipElement">custom</xsl:attribute>
      	<xsl:attribute name="ajaxTooltipEvent">
      		<xsl:variable name="event" select="LINK[PROPERTY[@name='tooltip']]/PROPERTY[@name='event']/@value"/>
      		<xsl:if test="$event != 'mouseover'">
      			<xsl:value-of select="$event"/>
      		</xsl:if>
      	</xsl:attribute>
      	<xsl:attribute name="ajaxTooltipLink"><xsl:value-of select="LINK[PROPERTY[@name='tooltip']][1]/@id"/></xsl:attribute>
      </xsl:if>
      <xsl:if test="LINK[PROPERTY[@name='drag']]">
      	  	<xsl:attribute name="ajaxDragEnabled">true</xsl:attribute>
      	  	<xsl:attribute name="ajaxDragLink"><xsl:value-of select="LINK[PROPERTY[@name='drag']]/@id"/></xsl:attribute>
      </xsl:if>
      <xsl:if test="LINK[PROPERTY[@name='drop' or @name = 'onDrop']]">
      	  	<xsl:attribute name="ajaxDropEnabled">true</xsl:attribute>
      	  	<xsl:attribute name="ajaxDropLink"><xsl:value-of select="LINK[PROPERTY[@name='drop' or @name = 'onDrop']]/@id"/></xsl:attribute>
      </xsl:if>
      <xsl:if test="@shortMonths = 'yes'">
        <xsl:attribute name="shortMonths">true</xsl:attribute>
      </xsl:if>
      <xsl:if test="@shortWeekdays = 'yes'">
        <xsl:attribute name="shortWeekdays">true</xsl:attribute>
      </xsl:if>
      <xsl:if test="string(@years) != ''">
        <xsl:attribute name="years">
          <xsl:value-of select="@years"/>
        </xsl:attribute>
     </xsl:if>
      <xsl:if test="@entity-based = 'yes'">
      
        <xsl:attribute name="entityBased">true</xsl:attribute>
        <xsl:attribute name="entity">
           <xsl:value-of select="@entity"/>
        </xsl:attribute>
        <xsl:if test="string(@date-att)!=''">
          <xsl:attribute name="dateAttribute">
            <xsl:value-of select="@date-att"/>
          </xsl:attribute>
        </xsl:if>
      <xsl:apply-templates select="."  mode="newDisplayAttributes"/>
      <xsl:choose>
        <xsl:when test="SELECTOR/SELECTORCONDITION">
          <xsl:apply-templates select="SELECTOR"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="oidParamName" select="concat(@id, '.oid.set')"/>
          <xsl:if test="key('incoming-any-links', @id)[LINKPARAMETER[@target = $oidParamName]]">
            <Selector id="{@id}sel" booleanOperator="and">
              <KeyCondition id="{@id}key" predicate="in"/>
            </Selector>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
      </xsl:if>
      <xsl:apply-templates select="*[not(self::SELECTOR)]"/>
    </EventCalendarUnit>
  </xsl:template>
  
  <xsl:template match="ISNOTNULLUNIT">
    <IsNotNullUnit>
      <xsl:apply-templates select="." mode="copy-default-attributes"/>
      <xsl:if test="@emptyStringAsNull = 'yes'">
        <xsl:attribute name="emptyStringAsNull">true</xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="*"/>
    </IsNotNullUnit>
  </xsl:template>
  
  <xsl:template match="EMAILUNIT">
    <MailUnit format="plainText">
      <xsl:apply-templates select="." mode="copy-default-attributes"/>
      <xsl:if test="@validate-addresses = 'yes'">
        <xsl:attribute name="validateAddresses">true</xsl:attribute>
      </xsl:if>
      <xsl:if test="string(@smtp-server) != ''">
        <xsl:attribute name="smtpServer">
          <xsl:apply-templates select="." mode="smtpServer"/>
        </xsl:attribute>
      </xsl:if>
      <!--
      <xsl:if test="string(@default-from) != ''">
        <xsl:attribute name="defaultFrom">
          <xsl:value-of select="@default-from"/>
        </xsl:attribute>
      </xsl:if>
      -->
      <xsl:variable name="skipValues" select="'|subject|Subject|SUBJECT|body|Body|BODY|attachment|Attachment|ATTACHMENT|'"/>
      <xsl:variable name="skipNames" select="'|smtp-server|debug|subject-separator|body-separator|validate-addresses'"/>
      
      <xsl:variable name="subjectTemplate">
         <xsl:for-each select="PROPERTY[@value = 'subject' or @value = 'Subject' or @value = 'SUBJECT']">
           <xsl:sort  select="@name"/>
           <xsl:value-of select="@name"/>
           <xsl:if test="position() != last()">
              <xsl:value-of select="../PROPERTY[@name = 'subject-separator']/@value"/>
           </xsl:if>
         </xsl:for-each>
      </xsl:variable>
      
      <xsl:variable name="bodyTemplate">
         <xsl:for-each select="PROPERTY[@value = 'body' or @value = 'Body' or @value = 'BODY']">
           <xsl:sort select="@name"/>
           <xsl:value-of select="@name"/>
           <xsl:if test="position() != last()">
             <xsl:value-of select="../PROPERTY[@name = 'body-separator']/@value"/>
           </xsl:if>
         </xsl:for-each>
      </xsl:variable>
      
      <SubjectTemplate xml:space="preserve"><xsl:value-of select="$subjectTemplate"/></SubjectTemplate> 
      <BodyTemplate xml:space="preserve"><xsl:value-of select="$bodyTemplate"/></BodyTemplate> 
      
      <xsl:for-each select="PROPERTY[@value = 'subject' or @value = 'Subject' or @value = 'SUBJECT']">
        <PlaceHolder id="{@id}" name="{@name}"></PlaceHolder>
      </xsl:for-each>
      <xsl:for-each select="PROPERTY[@value = 'body' or @value = 'Body' or @value = 'BODY']">
        <PlaceHolder id="{@id}" name="{@name}"></PlaceHolder>
      </xsl:for-each>
      <xsl:for-each select="PROPERTY[@value = 'attachment' or @value = 'Attachment' or @value = 'ATTACHMENT']">
        <Attachment id="{@id}" name="{@name}" policy="multiple"/>
      </xsl:for-each>
      <xsl:apply-templates select="*[not(contains($skipValues, concat('|',@value,'|')))][not(contains($skipNames, concat('|',@name,'|')))]"/>
    </MailUnit>
  </xsl:template>
  
  <xsl:template match="MATHUNIT">
    <MathUnit>
      <xsl:apply-templates select="." mode="copy-default-attributes"/>
     <xsl:attribute name="resultType">
        <xsl:choose>
          <xsl:when test="@resultType = 'Boolean'">boolean</xsl:when>
          <xsl:when test="@resultType = 'Float'">float</xsl:when>
          <xsl:when test="@resultType = 'Integer'">integer</xsl:when>
          <xsl:when test="@resultType = 'Number'">decimal</xsl:when>
        </xsl:choose>
      </xsl:attribute>
	   <xsl:if test="string(@default-expression) != ''">
        <xsl:attribute name="defaultExpression">
          <xsl:value-of select="@default-expression"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:for-each select="MATHVARIABLE">
         <MathVariable id="{@id}" name="{@name}"/>
      </xsl:for-each>
      <xsl:apply-templates select="*"/>
    </MathUnit>
  </xsl:template>
  
  <xsl:template match="MULTIENTRYUNIT">
    <MultiEntryUnit>
      <xsl:apply-templates select="." mode="copy-default-attributes"/>
      <xsl:if test="string(@min-length) != ''">
        <xsl:attribute name="minLength">
          <xsl:value-of select="@min-length"/>
        </xsl:attribute>
      </xsl:if>
      <!-- AJAX -->
      <xsl:if test="LINK[PROPERTY[@name='tooltip']]">
      	<xsl:attribute name="ajaxTooltipEnabled">true</xsl:attribute>
      	<xsl:attribute name="ajaxTooltipElement">custom</xsl:attribute>
      	<xsl:attribute name="ajaxTooltipEvent">
      		<xsl:variable name="event" select="LINK[PROPERTY[@name='tooltip']]/PROPERTY[@name='event']/@value"/>
      		<xsl:if test="$event != 'mouseover'">
      			<xsl:value-of select="$event"/>
      		</xsl:if>
      	</xsl:attribute>
      	<xsl:attribute name="ajaxTooltipLink"><xsl:value-of select="LINK[PROPERTY[@name='tooltip']][1]/@id"/></xsl:attribute>
      </xsl:if>
      <xsl:for-each select="FIELD | SELECTIONFIELD">
      	<xsl:choose>
      		<xsl:when test="name() = 'FIELD'">
		        <Field id="{@id}" name="{@name}"> 
		      	  <xsl:if test="@preloaded = 'yes'">
		      		<xsl:attribute name="preloaded">
		      			<xsl:text>true</xsl:text>
		      		</xsl:attribute>
		      	  </xsl:if>
		      	  <xsl:if test="@modifiable='yes'">
		      		<xsl:attribute name="modifiable">
		      			<xsl:text>true</xsl:text>
		      		</xsl:attribute>
		      	  </xsl:if>
		      	  <xsl:if test="@hidden='yes'">
		      		<xsl:attribute name="hidden">
		      			<xsl:text>true</xsl:text>
		      		</xsl:attribute>
		      	  </xsl:if>
		      	  <xsl:if test="string(@contentType) != ''">
		      		<xsl:attribute name="contentType">
		      			<xsl:value-of select="@contentType"/>
		      		</xsl:attribute>
		      	  </xsl:if>
		      	  <xsl:if test="string(@type) != ''">
		      		<xsl:attribute name="type">
				        <xsl:choose>
				          <xsl:when test="@type = 'BLOB'">blob</xsl:when>
				          <xsl:when test="@type = 'Boolean'">boolean</xsl:when>
				          <xsl:when test="@type = 'Date'">date</xsl:when>
				          <xsl:when test="@type = 'Float'">float</xsl:when>
				          <xsl:when test="@type = 'Integer'">integer</xsl:when>
				          <xsl:when test="@type = 'Number'">decimal</xsl:when>
				          <xsl:when test="@type = 'OID'">integer</xsl:when>
				          <xsl:when test="@type = 'Password'">password</xsl:when>
				          <xsl:when test="@type = 'String'">string</xsl:when>
				          <xsl:when test="@type = 'Text'">text</xsl:when>
				          <xsl:when test="@type = 'Time'">time</xsl:when>
				          <xsl:when test="@type = 'TimeStamp'">timestamp</xsl:when>
				          <xsl:when test="@type = 'URL'">url</xsl:when>
				          <xsl:otherwise>string</xsl:otherwise>
				        </xsl:choose>
		      		</xsl:attribute>
		      	  </xsl:if>
		      	  <xsl:apply-templates select="*"/>
		      	</Field>
      		</xsl:when>
      		<xsl:when test="name() = 'SELECTIONFIELD'">
		      	<SelectionField id="{@id}" name="{@name}">
		      	   <xsl:if test="string(@preselectValue) != ''">
		      		<xsl:attribute name="preselectValue">
		      			<xsl:value-of select="@preselectValue"/>
		      		</xsl:attribute>
		      	  </xsl:if>
		      	  <xsl:if test="string(@type) != ''">
		      		<xsl:attribute name="type">
				        <xsl:choose>
				          <xsl:when test="@type = 'BLOB'">blob</xsl:when>
				          <xsl:when test="@type = 'Boolean'">boolean</xsl:when>
				          <xsl:when test="@type = 'Date'">date</xsl:when>
				          <xsl:when test="@type = 'Float'">float</xsl:when>
				          <xsl:when test="@type = 'Integer'">integer</xsl:when>
				          <xsl:when test="@type = 'Number'">decimal</xsl:when>
				          <xsl:when test="@type = 'OID'">integer</xsl:when>
				          <xsl:when test="@type = 'Password'">password</xsl:when>
				          <xsl:when test="@type = 'String'">string</xsl:when>
				          <xsl:when test="@type = 'Text'">text</xsl:when>
				          <xsl:when test="@type = 'Time'">time</xsl:when>
				          <xsl:when test="@type = 'TimeStamp'">timestamp</xsl:when>
				          <xsl:when test="@type = 'URL'">url</xsl:when>
				          <xsl:otherwise>string</xsl:otherwise>
				        </xsl:choose>
		      		</xsl:attribute>
		      	  </xsl:if>
		      	  <xsl:apply-templates select="*"/>
		      	</SelectionField>
      		</xsl:when>
      	</xsl:choose>
      </xsl:for-each>
      <xsl:apply-templates select="*"/>
    </MultiEntryUnit>
  </xsl:template>
  
  <xsl:template match="CONTENTUNIT">
    <NoOpContentUnit>
      <xsl:apply-templates select="." mode="copy-default-attributes"/>
      <xsl:if test="string(@type) != ''">
        <xsl:attribute name="type">
          <xsl:value-of select="@type"/>
        </xsl:attribute>
      </xsl:if>
      <!-- AJAX -->
      <xsl:if test="LINK[PROPERTY[@name='tooltip']]">
      	<xsl:attribute name="ajaxTooltipEnabled">true</xsl:attribute>
      	<xsl:attribute name="ajaxTooltipElement">custom</xsl:attribute>
      	<xsl:attribute name="ajaxTooltipEvent">
      		<xsl:variable name="event" select="LINK[PROPERTY[@name='tooltip']]/PROPERTY[@name='event']/@value"/>
      		<xsl:if test="$event != 'mouseover'">
      			<xsl:value-of select="$event"/>
      		</xsl:if>
      	</xsl:attribute>
      	<xsl:attribute name="ajaxTooltipLink"><xsl:value-of select="LINK[PROPERTY[@name='tooltip']][1]/@id"/></xsl:attribute>
      </xsl:if>
      <xsl:if test="LINK[PROPERTY[@name='drag']]">
      	  	<xsl:attribute name="ajaxDragEnabled">true</xsl:attribute>
      	  	<xsl:attribute name="ajaxDragLink"><xsl:value-of select="LINK[PROPERTY[@name='drag']]/@id"/></xsl:attribute>
      </xsl:if>
      <xsl:if test="LINK[PROPERTY[@name='drop' or @name = 'onDrop']]">
      	  	<xsl:attribute name="ajaxDropEnabled">true</xsl:attribute>
      	  	<xsl:attribute name="ajaxDropLink"><xsl:value-of select="LINK[PROPERTY[@name='drop' or @name = 'onDrop']]/@id"/></xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="*"/>
    </NoOpContentUnit>
  </xsl:template>
  
  <xsl:template match="OPERATIONUNIT">
    <NoOpOperationUnit>
      <xsl:apply-templates select="." mode="copy-default-attributes"/>
      <xsl:if test="string(@type) != ''">
        <xsl:attribute name="type">
          <xsl:value-of select="@type"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="*"/>
    </NoOpOperationUnit>
  </xsl:template>
  
  <xsl:template match="POWERINDEXUNIT">
    <PowerIndexUnit entity="{@entity}" sortable="true">
      <xsl:apply-templates select="." mode="copy-default-attributes"/>
      <xsl:if test="string(@blockFactor) != ''">
        <xsl:attribute name="blockFactor">
           <xsl:value-of select="@blockFactor"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="string(@blockWindow) != ''">
        <xsl:attribute name="blockWindow">
           <xsl:value-of select="@blockWindow"/>
        </xsl:attribute>
      </xsl:if>
      <!-- AJAX -->
      <xsl:if test="LINK[PROPERTY[@name='tooltip']]">
      	<xsl:attribute name="ajaxTooltipEnabled">true</xsl:attribute>
      	<xsl:attribute name="ajaxTooltipElement">custom</xsl:attribute>
      	<xsl:attribute name="ajaxTooltipEvent">
      		<xsl:variable name="event" select="LINK[PROPERTY[@name='tooltip']]/PROPERTY[@name='event']/@value"/>
      		<xsl:if test="$event != 'mouseover'">
      			<xsl:value-of select="$event"/>
      		</xsl:if>
      	</xsl:attribute>
      	<xsl:attribute name="ajaxTooltipLink"><xsl:value-of select="LINK[PROPERTY[@name='tooltip']][1]/@id"/></xsl:attribute>
      </xsl:if>
      <xsl:if test="LINK[PROPERTY[@name='drag']]">
      	  	<xsl:attribute name="ajaxDragEnabled">true</xsl:attribute>
      	  	<xsl:attribute name="ajaxDragLink"><xsl:value-of select="LINK[PROPERTY[@name='drag']]/@id"/></xsl:attribute>
      </xsl:if>
      <xsl:if test="LINK[PROPERTY[@name='drop' or @name = 'onDrop']]">
      	  	<xsl:attribute name="ajaxDropEnabled">true</xsl:attribute>
      	  	<xsl:attribute name="ajaxDropLink"><xsl:value-of select="LINK[PROPERTY[@name='drop' or @name = 'onDrop']]/@id"/></xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="."  mode="newDisplayAttributes"/>
      <xsl:choose>
        <xsl:when test="SELECTOR/SELECTORCONDITION">
          <xsl:apply-templates select="SELECTOR"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="oidParamName" select="concat(@id, '.oid.set')"/>
          <xsl:if test="key('incoming-any-links', @id)[LINKPARAMETER[@target = $oidParamName]]">
            <Selector id="{@id}sel" booleanOperator="and">
              <KeyCondition id="{@id}key" predicate="in"/>
            </Selector>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*[not(self::SELECTOR)]"/>
    </PowerIndexUnit>
  </xsl:template>
  
  <xsl:template match="POWERMAILUNIT">
    <MailUnit>
      <xsl:apply-templates select="." mode="copy-default-attributes"/>
      <xsl:if test="@validate-addresses = 'yes'">
        <xsl:attribute name="validateAddresses">true</xsl:attribute>
      </xsl:if>
      <xsl:if test="string(@smtp-server) != ''">
        <xsl:attribute name="smtpServer">
          <xsl:apply-templates select="." mode="smtpServer"/>
        </xsl:attribute>
      </xsl:if>
      <!--
      <xsl:if test="string(@default-from) != ''">
        <xsl:attribute name="defaultFrom">
          <xsl:value-of select="@default-from"/>
        </xsl:attribute>
      </xsl:if>
      -->
      <xsl:if test="string(@format) != ''">
        <xsl:attribute name="format">
          <xsl:value-of select="@format"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="string(@encoding) != ''">
        <xsl:attribute name="encoding">
          <xsl:value-of select="@encoding"/>
        </xsl:attribute>
      </xsl:if>
      
      <!-- process mail template -->
      <xsl:if test="string(@template) != ''">
	      <xsl:variable name="unitId" select="@id"/>
	      <xsl:variable name="templatePath" select="concat('/WebContent/WEB-INF/descr/',@template)"/>
	      <xsl:variable name="subject" select="unitHelper:getPowerMailSubject($project,$templatePath)"/>
	      <xsl:variable name="placeHolders" select="unitHelper:getPowerMailPlaceHolders($project,$templatePath)"/>
	      <xsl:variable name="newTemplateFileName" select="unitHelper:convertPowerMailTemplate($project,$templatePath)"/>
	      <xsl:attribute name="template">
	          <xsl:text>WEB-INF/descr/</xsl:text><xsl:value-of select="$newTemplateFileName"/>
	      </xsl:attribute>
	      <SubjectTemplate xml:space="preserve"><xsl:value-of select="$subject"/></SubjectTemplate>
	      <xsl:for-each select="saxon:tokenize($placeHolders,'|')">
	         <PlaceHolder id="{$unitId}_ph{position()}" name="{.}"></PlaceHolder>     
	      </xsl:for-each>
	  </xsl:if>
	  
	  <!-- creates the attachments sub units -->
      <xsl:if test="@attachment-count &gt; 0">
        <xsl:apply-templates select="." mode="nth-attachment-param">
          <xsl:with-param name="index" select="@attachment-count"/>
        </xsl:apply-templates>
      </xsl:if>
	  
      <xsl:apply-templates select="*"/>
    </MailUnit>
  </xsl:template>
  
  <xsl:template match="POWERMAILUNIT" mode="nth-attachment-param">
    <xsl:param name="index"/>
    <Attachment id="{@id}_at{$index}" name="Attachment{$index}" policy="oneToOne"></Attachment>
    <xsl:if test="$index &gt; 1">
      <xsl:apply-templates select="." mode="nth-attachment-param">
        <xsl:with-param name="index" select="$index - 1"/>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:template>
  
  
  <xsl:template match="SELECTORUNIT">
  	<SelectorUnit entity="{@entity}">
      <xsl:apply-templates select="." mode="copy-default-attributes"/>
      <xsl:if test="@distinct = 'yes'">
  	    <xsl:attribute name="distinct">
  	      <xsl:text>true</xsl:text>
  	    </xsl:attribute>
  	    <xsl:if test="not(DISPLAYATTRIBUTE)">
          <xsl:attribute name="distinctAttributes">
            <xsl:apply-templates select="key('entity', @entity)" mode="attributes"/>
          </xsl:attribute>
        </xsl:if>
      </xsl:if>
      <xsl:if test="DISPLAYATTRIBUTE">
         <xsl:attribute name="distinctAttributes">
            <xsl:for-each select="DISPLAYATTRIBUTE">
              <xsl:variable name="newIdRefs" select="unitHelper:convertAttributeRefs(., @attribute)"/>
              <xsl:value-of select="$newIdRefs"/>
            	<xsl:text> </xsl:text>
            </xsl:for-each>
         </xsl:attribute>
      </xsl:if> 
      <xsl:choose>
        <xsl:when test="SELECTOR/SELECTORCONDITION">
          <xsl:apply-templates select="SELECTOR"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="oidParamName" select="concat(@id, '.oid.set')"/>
          <xsl:if test="key('incoming-any-links', @id)">
            <Selector id="{@id}sel" booleanOperator="and">
              <KeyCondition id="{@id}key" predicate="in"/>
            </Selector>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*[not(self::SELECTOR)]"/>
  	</SelectorUnit>
  </xsl:template>
  
  <xsl:template match="SCRIPTUNIT">
    <ScriptUnit>
      <xsl:apply-templates select="." mode="copy-default-attributes"/>
      <xsl:if test="@distinct = 'yes'">
        <xsl:attribute name="distinct">true</xsl:attribute>
      </xsl:if>
      <xsl:if test="string(@script) != ''">
        <xsl:attribute name="script">WEB-INF/descr/<xsl:value-of select="@script"/></xsl:attribute>
      </xsl:if>
      <xsl:for-each select="SCRIPTINPUT">
         <ScriptInput id="{@id}" name="{@name}"/>
      </xsl:for-each>
      <xsl:for-each select="SCRIPTOUTPUT">
         <ScriptOutput id="{@id}" name="{@name}"/>
      </xsl:for-each>
      <xsl:if test="SCRIPTUNITTEXT">
         <ScriptUnitText xml:space="preserve"><xsl:value-of select="SCRIPTUNITTEXT/text()"/></ScriptUnitText>
      </xsl:if>
      <xsl:apply-templates select="*"/>
    </ScriptUnit>
  </xsl:template>
  
  <xsl:template match="SORTABLEINDEXUNIT">
    <PowerIndexUnit entity="{@entity}" sortable="true">
      <xsl:apply-templates select="." mode="copy-default-attributes"/>
      <xsl:if test="@distinct = 'yes'">
        <xsl:attribute name="distinct">true</xsl:attribute>
      </xsl:if>
      <!-- AJAX -->
      <xsl:if test="LINK[PROPERTY[@name='tooltip']]">
      	<xsl:attribute name="ajaxTooltipEnabled">true</xsl:attribute>
      	<xsl:attribute name="ajaxTooltipElement">custom</xsl:attribute>
      	<xsl:attribute name="ajaxTooltipEvent">
      		<xsl:variable name="event" select="LINK[PROPERTY[@name='tooltip']]/PROPERTY[@name='event']/@value"/>
      		<xsl:if test="$event != 'mouseover'">
      			<xsl:value-of select="$event"/>
      		</xsl:if>
      	</xsl:attribute>
      	<xsl:attribute name="ajaxTooltipLink"><xsl:value-of select="LINK[PROPERTY[@name='tooltip']][1]/@id"/></xsl:attribute>
      </xsl:if>
      <xsl:if test="LINK[PROPERTY[@name='drag']]">
      	  	<xsl:attribute name="ajaxDragEnabled">true</xsl:attribute>
      	  	<xsl:attribute name="ajaxDragLink"><xsl:value-of select="LINK[PROPERTY[@name='drag']]/@id"/></xsl:attribute>
      </xsl:if>
      <xsl:if test="LINK[PROPERTY[@name='drop' or @name = 'onDrop']]">
      	  	<xsl:attribute name="ajaxDropEnabled">true</xsl:attribute>
      	  	<xsl:attribute name="ajaxDropLink"><xsl:value-of select="LINK[PROPERTY[@name='drop' or @name = 'onDrop']]/@id"/></xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="."  mode="newDisplayAttributes"/>
      <xsl:choose>
        <xsl:when test="SELECTOR/SELECTORCONDITION">
          <xsl:apply-templates select="SELECTOR"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="oidParamName" select="concat(@id, '.oid.set')"/>
          <xsl:if test="key('incoming-any-links', @id)[LINKPARAMETER[@target = $oidParamName]]">
            <Selector id="{@id}sel" booleanOperator="and">
              <KeyCondition id="{@id}key" predicate="in"/>
            </Selector>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*[not(self::SELECTOR)]"/>
    </PowerIndexUnit>
  </xsl:template>
  
  <xsl:template match="STOREDPROCEDUREUNIT">
    <StoredProcedureUnit>
      <xsl:apply-templates select="." mode="copy-default-attributes"/>
      <xsl:if test="string(@db) != ''">
        <xsl:attribute name="db">
          <xsl:value-of select="@db"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="string(@procedure) != ''">
        <xsl:attribute name="procedure">
          <xsl:value-of select="@procedure"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:choose>
	      <xsl:when test="(string(@resultType) = '') or (not(@resultType))">
	        <xsl:attribute name="resultType">plain</xsl:attribute>
	      </xsl:when>
	      <xsl:otherwise>
	        <xsl:attribute name="resultType">
	          <xsl:value-of select="@resultType"/>
	        </xsl:attribute>
	      </xsl:otherwise>
	   </xsl:choose>
	 <xsl:for-each select="STOREDPROCEDUREPARAMETER">
	  <StoredProcedureParameter id="{@id}" name="{@name}">
       <xsl:choose>
	      <xsl:when test="(string(@type) = '') or (not(@type))">
	        <xsl:attribute name="type">string</xsl:attribute>
	      </xsl:when>
	      <xsl:when test="@type = 'Number'">
	        <xsl:attribute name="type">decimal</xsl:attribute>
	      </xsl:when>
	      <xsl:otherwise>
  	        <xsl:variable name="lowerCase">abcdefghijklmnopqrstuvwxyz</xsl:variable>
	        <xsl:variable name="upperCase">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
	        <xsl:attribute name="type">
	          <xsl:value-of select="translate(@type, $upperCase, $lowerCase)"/>
	        </xsl:attribute>
	      </xsl:otherwise>
	   </xsl:choose>
	   <xsl:choose>
	      <xsl:when test="(string(@direction) = '') or (not(@direction))">
	        <xsl:attribute name="direction">input</xsl:attribute>
	      </xsl:when>
	      <xsl:otherwise>
	        <xsl:attribute name="direction">
	          <xsl:value-of select="@direction"/>
	        </xsl:attribute>
	      </xsl:otherwise>
	   </xsl:choose>
	   <xsl:if test="string(@position) != ''">
        <xsl:attribute name="position">
          <xsl:value-of select="@position"/>
        </xsl:attribute>
      </xsl:if>
	   </StoredProcedureParameter>
	  </xsl:for-each>
      <xsl:apply-templates select="*"/>
    </StoredProcedureUnit>
  </xsl:template>
  
  <xsl:template match="SWITCHUNIT">
    <SwitchUnit>
      <xsl:apply-templates select="." mode="copy-default-attributes"/>
	  <xsl:for-each select="CASE">
	    <Case value="{@value}"/>
	  </xsl:for-each>
      <xsl:apply-templates select="*"/>
    </SwitchUnit>
  </xsl:template>
  
  <xsl:template match="TIMEUNIT">
    <TimeUnit>
      <xsl:apply-templates select="." mode="copy-default-attributes"/>
      <xsl:apply-templates select="*"/>
    </TimeUnit>
  </xsl:template>
  
  <!-- END ADVANCED UNITS -->
  
  <!-- WS UNITS -->
  
  <xsl:template match="ADAPTERUNIT">
    <AdapterUnit>
      <xsl:apply-templates select="." mode="copy-default-attributes"/>
      <xsl:if test="string(@inputDocCount) != ''">
        <xsl:attribute name="inputDocCount">
           <xsl:value-of select="@inputDocCount"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="string(@xslFile) != ''">
        <xsl:attribute name="xslFile">
           <xsl:text>WEB-INF/descr/</xsl:text><xsl:value-of select="@xslFile"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="*"/>
    </AdapterUnit>
  </xsl:template>
  
  <xsl:template match="ERRORRESPONSEUNIT">
    <ErrorResponseUnit>
      <xsl:apply-templates select="." mode="copy-default-attributes"/>
    </ErrorResponseUnit>
  </xsl:template>
  
  <xsl:template match="GETXMLUNIT">
    <GetXMLUnit>
      <xsl:apply-templates select="." mode="copy-default-attributes"/>
      <xsl:choose>
	      <xsl:when test="(string(@urlType) = '') or (not(@urlType))">
	        <xsl:attribute name="sourceType">static</xsl:attribute>
	      </xsl:when>
	      <xsl:otherwise>
	       <xsl:attribute name="sourceType">
	         <xsl:value-of select="@urlType"/>
	       </xsl:attribute>
	     </xsl:otherwise>
	  </xsl:choose>
	  <xsl:if test="string(@url) != ''">
        <xsl:attribute name="url">
           <xsl:value-of select="@url"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="*"/>
    </GetXMLUnit>
  </xsl:template>
  
   <xsl:template match="ONEWAYUNIT">
    <OneWayUnit>
      <xsl:apply-templates select="." mode="copy-default-attributes"/>
      <xsl:choose>
	      <xsl:when test="(string(@endpointType) = '') or (not(@endpointType))">
	        <xsl:attribute name="endpointType">static</xsl:attribute>
	      </xsl:when>
	      <xsl:otherwise>
	       <xsl:attribute name="endpointType">
	         <xsl:value-of select="@endpointType"/>
	       </xsl:attribute>
	     </xsl:otherwise>
	  </xsl:choose>
	  <xsl:if test="string(@endpointURL) != ''">
        <xsl:attribute name="endpointURL">
           <xsl:value-of select="@endpointURL"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="string(@username) != ''">
        <xsl:attribute name="username">
           <xsl:value-of select="@username"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="string(@password) != ''">
        <xsl:attribute name="password">
           <xsl:value-of select="@password"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="string(@soapActionURI) != ''">
        <xsl:attribute name="soapActionURI">
           <xsl:value-of select="@soapActionURI"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:choose>
	      <xsl:when test="(string(@inputType) = '') or (not(@inputType))">
	        <xsl:attribute name="inputType">none</xsl:attribute>
	      </xsl:when>
	      <xsl:when test="@inputType = 'none'">
	        <xsl:attribute name="inputType">
	         <xsl:value-of select="@inputType"/>
	        </xsl:attribute>
	        <xsl:if test="string(@methodName) != ''">
             <xsl:attribute name="methodName">
               <xsl:value-of select="@methodName"/>
             </xsl:attribute>
            </xsl:if>
            <xsl:if test="string(@methodNSURI) != ''">
             <xsl:attribute name="methodNSURI">
               <xsl:value-of select="@methodNSURI"/>
             </xsl:attribute>
            </xsl:if>
	      </xsl:when>
	      <xsl:otherwise>
	       <xsl:attribute name="inputType">
	         <xsl:value-of select="@inputType"/>
	       </xsl:attribute>
	       <xsl:if test="string(@inputXSLFile) != ''">
             <xsl:attribute name="inputXSLFile">
               <xsl:text>WEB-INF/descr/</xsl:text><xsl:value-of select="@inputXSLFile"/>
             </xsl:attribute>
            </xsl:if>
	     </xsl:otherwise>
	  </xsl:choose>
	  
	  <xsl:for-each select="ONEWAYPARAMETER">
	    <OneWayParameter id="{@id}" name="{@name}">
	       <xsl:if test="string(@nsURI) != ''">
             <xsl:attribute name="nsURI">
               <xsl:value-of select="@nsURI"/>
             </xsl:attribute>
            </xsl:if>
	    </OneWayParameter>
	  </xsl:for-each>
      <xsl:apply-templates select="*"/>
    </OneWayUnit>
  </xsl:template>
  
  <xsl:template match="REQUESTRESPONSEUNIT">
    <RequestResponseUnit>
      <xsl:apply-templates select="." mode="copy-default-attributes"/>
      <xsl:choose>
	      <xsl:when test="(string(@endpointType) = '') or (not(@endpointType))">
	        <xsl:attribute name="endpointType">static</xsl:attribute>
	      </xsl:when>
	      <xsl:otherwise>
	       <xsl:attribute name="endpointType">
	         <xsl:value-of select="@endpointType"/>
	       </xsl:attribute>
	     </xsl:otherwise>
	  </xsl:choose>
	  <xsl:if test="string(@endpointURL) != ''">
        <xsl:attribute name="endpointURL">
           <xsl:value-of select="@endpointURL"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="string(@username) != ''">
        <xsl:attribute name="username">
           <xsl:value-of select="@username"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="string(@password) != ''">
        <xsl:attribute name="password">
           <xsl:value-of select="@password"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="string(@soapActionURI) != ''">
        <xsl:attribute name="soapActionURI">
           <xsl:value-of select="@soapActionURI"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@fullEnvelopeOutput = 'yes'">
        <xsl:attribute name="fullEnvelopeOutput">true</xsl:attribute>
      </xsl:if>
      <xsl:if test="string(@outputXSLFile) != ''">
        <xsl:attribute name="outputXSLFile">
           <xsl:text>WEB-INF/descr/</xsl:text><xsl:value-of select="@outputXSLFile"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:choose>
	      <xsl:when test="(string(@inputType) = '') or (not(@inputType))">
	        <xsl:attribute name="inputType">none</xsl:attribute>
	      </xsl:when>
	      <xsl:when test="@inputType = 'none'">
	        <xsl:attribute name="inputType">
	         <xsl:value-of select="@inputType"/>
	        </xsl:attribute>
	        <xsl:if test="string(@methodName) != ''">
             <xsl:attribute name="methodName">
               <xsl:value-of select="@methodName"/>
             </xsl:attribute>
            </xsl:if>
            <xsl:if test="string(@methodNSURI) != ''">
             <xsl:attribute name="methodNSURI">
               <xsl:value-of select="@methodNSURI"/>
             </xsl:attribute>
            </xsl:if>
	      </xsl:when>
	      <xsl:otherwise>
	       <xsl:attribute name="inputType">
	         <xsl:value-of select="@inputType"/>
	       </xsl:attribute>
	       <xsl:if test="string(@inputXSLFile) != ''">
             <xsl:attribute name="inputXSLFile">
               <xsl:text>WEB-INF/descr/</xsl:text><xsl:value-of select="@inputXSLFile"/>
             </xsl:attribute>
            </xsl:if>
	     </xsl:otherwise>
	  </xsl:choose>
	  
	  <xsl:for-each select="REQUESTRESPONSEPARAMETER">
	    <RequestResponseParameter id="{@id}" name="{@name}">
	       <xsl:if test="string(@nsURI) != ''">
             <xsl:attribute name="nsURI">
               <xsl:value-of select="@nsURI"/>
             </xsl:attribute>
            </xsl:if>
	    </RequestResponseParameter>
	  </xsl:for-each>
      <xsl:apply-templates select="*"/>
    </RequestResponseUnit>
  </xsl:template>
  
  <xsl:template match="RESPONSEUNIT">
    <ResponseUnit>
      <xsl:apply-templates select="." mode="copy-default-attributes"/>
      <xsl:if test="string(@nsURI) != ''">
        <xsl:attribute name="nsURI">
          <xsl:value-of select="@nsURI"/>
        </xsl:attribute>
      </xsl:if>

	  <xsl:for-each select="RESPONSEPARAMETER">
	    <ResponseParameter id="{@id}" name="{@name}">
	      <xsl:if test="string(@xmlSchema) != ''">
            <xsl:attribute name="xmlSchema">
              <xsl:text>WEB-INF/descr/</xsl:text><xsl:value-of select="@xmlSchema"/>
            </xsl:attribute>
          </xsl:if>
          <xsl:if test="string(@type) != ''">
            <xsl:attribute name="type">
               <xsl:choose>
                   <xsl:when test="contains(@type, '[type]')">
                     <xsl:value-of select="stringutils:replace(@type,'[type]','[SimpleType]')"/>
                   </xsl:when>
                   <xsl:when test="contains(@type, '[complex]')">
                     <xsl:value-of select="stringutils:replace(@type,'[complex]','[ComplexType]')"/>
                   </xsl:when>
                   <xsl:when test="contains(@type, '[element]')">
                     <xsl:value-of select="stringutils:replace(@type,'[element]','[Element]')"/>
                   </xsl:when>
                   <xsl:otherwise>
                      <xsl:value-of select="concat(@type,'[SimpleType]')"/>
                   </xsl:otherwise>
               </xsl:choose>
            </xsl:attribute>
          </xsl:if>
	    </ResponseParameter>
	  </xsl:for-each>
      <xsl:apply-templates select="*"/>
    </ResponseUnit>
  </xsl:template>
  
  <xsl:template match="SOLICITUNIT">
    <SolicitUnit>
      <xsl:apply-templates select="." mode="copy-default-attributes"/>
      <xsl:if test="string(@nsURI) != ''">
        <xsl:attribute name="nsURI">
          <xsl:value-of select="@nsURI"/>
        </xsl:attribute>
      </xsl:if>

	  <xsl:for-each select="SOLICITPARAMETER">
	    <SolicitParameter id="{@id}" name="{@name}">
	      <xsl:if test="string(@xmlSchema) != ''">
            <xsl:attribute name="xmlSchema">
              <xsl:text>WEB-INF/descr/</xsl:text><xsl:value-of select="@xmlSchema"/>
            </xsl:attribute>
          </xsl:if>
          <xsl:if test="string(@type) != ''">
            <xsl:attribute name="type">
              <xsl:choose>
                <xsl:when test="contains(@type, '[type]')">
                  <xsl:value-of select="stringutils:replace(@type,'[type]','[SimpleType]')"/>
                </xsl:when>
                <xsl:when test="contains(@type, '[complex]')">
                  <xsl:value-of select="stringutils:replace(@type,'[complex]','[ComplexType]')"/>
                </xsl:when>
                <xsl:when test="contains(@type, '[element]')">
                  <xsl:value-of select="stringutils:replace(@type,'[element]','[Element]')"/>
                </xsl:when>
                <xsl:otherwise>
                   <xsl:value-of select="concat(@type,'[SimpleType]')"/>
                </xsl:otherwise>
              </xsl:choose>
           </xsl:attribute>
          </xsl:if>
	    </SolicitParameter>
	  </xsl:for-each>
      <xsl:apply-templates select="*"/>
    </SolicitUnit>
  </xsl:template>
  
  
   <xsl:template match="XMLINUNIT">
    <XMLInUnit oldDocStyle="true">
      <xsl:apply-templates select="." mode="copy-default-attributes"/>
      <xsl:if test="string(@nsURI) != ''">
        <xsl:attribute name="nsURI">
          <xsl:value-of select="@nsURI"/>
        </xsl:attribute>
      </xsl:if>

	   <xsl:for-each select="XMLINENTITY">
	    <XMLInEntity id="{@id}" name="{@name}" entity="{@entity}">
	      <xsl:if test="string(@keyAttributes) != ''">
            <xsl:attribute name="keyAttributes">
              <xsl:value-of select="@keyAttributes"/>
            </xsl:attribute>
          </xsl:if>
          <xsl:choose>
	        <xsl:when test="(string(@updatePolicy) = '') or (not(@updatePolicy))">
	         <xsl:attribute name="updatePolicy">noAction</xsl:attribute>
	        </xsl:when>
	       <xsl:otherwise>
	        <xsl:attribute name="updatePolicy">
	          <xsl:value-of select="@updatePolicy"/>
	        </xsl:attribute>
	       </xsl:otherwise>
	     </xsl:choose>
	    </XMLInEntity>
	  </xsl:for-each>
	  <xsl:for-each select="XMLINRELATIONSHIP">
	    <XMLInRelationship id="{@id}" name="{@name}" relationship="{@relationship}">
	      <xsl:if test="string(@sourceKeyAttributes) != ''">
            <xsl:attribute name="sourceKeyAttributes">
              <xsl:value-of select="@sourceKeyAttributes"/>
            </xsl:attribute>
          </xsl:if>
          <xsl:if test="string(@targetKeyAttributes) != ''">
            <xsl:attribute name="targetKeyAttributes">
              <xsl:value-of select="@targetKeyAttributes"/>
           </xsl:attribute>
          </xsl:if>
	    </XMLInRelationship>
	  </xsl:for-each>
      <xsl:apply-templates select="*"/>
    </XMLInUnit>
  </xsl:template>
  
  <xsl:template match="XMLOUTUNIT">
    <XMLOutUnit oldDocStyle="true">
      <xsl:apply-templates select="." mode="copy-default-attributes"/>

	   <xsl:for-each select="XMLOUTENTITY">
	    <XMLOutEntity id="{@id}" name="{@name}" entity="{@entity}">
	      <xsl:if test="string(@exportedAttributes) != ''">
            <xsl:attribute name="exportedAttributes">
              <xsl:value-of select="@exportedAttributes"/>
            </xsl:attribute>
          </xsl:if>
          <xsl:apply-templates select="*"/>
	    </XMLOutEntity>
	  </xsl:for-each>
	  <xsl:for-each select="XMLOUTRELATIONSHIP">
	    <XMLOutRelationship id="{@id}" name="{@name}" relationship="{@relationship}"/>
	  </xsl:for-each>
      <xsl:apply-templates select="*"/>
    </XMLOutUnit>
  </xsl:template>
  
  <!-- END WS UNITS -->
  
  <!-- SESSION UNITS -->
  
  <xsl:template match="CHANGEGROUPUNIT">
    <ChangeGroupUnit>
      <xsl:apply-templates select="." mode="copy-default-attributes"/>
      <xsl:apply-templates select="*"/>
    </ChangeGroupUnit>
  </xsl:template>
  
  <xsl:template match="GETUNIT">
    <GetUnit contextParameters="{@globalParameter}">
      <xsl:apply-templates select="." mode="copy-default-attributes"/>
      <xsl:apply-templates select="*"/>
    </GetUnit>
  </xsl:template>
  
  <xsl:template match="LOGINUNIT">
    <LoginUnit>
      <xsl:apply-templates select="." mode="copy-default-attributes"/>
      <xsl:apply-templates select="*"/>
    </LoginUnit>
  </xsl:template>

  <xsl:template match="LOGOUTUNIT">
    <LogoutUnit siteView="{@siteView}">
      <xsl:apply-templates select="." mode="copy-default-attributes"/>
      <xsl:apply-templates select="*"/>
    </LogoutUnit>
  </xsl:template>
  
  <xsl:template match="RESETUNIT">
    <ResetUnit contextParameters="{@globalParameter}">
      <xsl:apply-templates select="." mode="copy-default-attributes"/>
      <xsl:apply-templates select="*"/>
    </ResetUnit>
  </xsl:template>

  <xsl:template match="SETUNIT">
    <SetUnit contextParameters="{@globalParameter}">
      <xsl:apply-templates select="." mode="copy-default-attributes"/>
      <xsl:apply-templates select="*"/>
    </SetUnit>
  </xsl:template>
  
  <!-- END SESSION UNITS -->
  

  <xsl:template match="DISPLAYATTRIBUTE"/>

  <xsl:template match="SORTATTRIBUTE">
    <xsl:variable name="newIdRefs" select="unitHelper:convertAttributeRefs(., @attribute)"/>
    <SortAttribute attribute="{$newIdRefs}">
      <xsl:attribute name="order">
        <xsl:choose>
          <xsl:when test="@order = 'descending'">descending</xsl:when>
          <xsl:otherwise>ascending</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
    </SortAttribute>
  </xsl:template>
    
  <xsl:template match="SELECTOR">
    <Selector booleanOperator="{@booleanOperator}" defaultPolicy="{@defaultPolicy}" id="{../@id}sel">
      <xsl:apply-templates select="*"/>
    </Selector>
  </xsl:template>

  <xsl:template match="SELECTOR[not(SELECTORCONDITION)]"/>
  
  <xsl:template match="SELECTORCONDITION">
  	<xsl:if test="string(@attributes) != ''">
      <xsl:variable name="newIdRefs" select="unitHelper:convertAttributeRefs(., @attributes)"/>
  		<AttributesCondition id="{@id}" attributes="{$newIdRefs}">
  			<xsl:if test="string(@name) != ''">
              <xsl:attribute name="name">
                <xsl:value-of select="@name"/>
              </xsl:attribute>
            </xsl:if>
            <xsl:attribute name="implied">
                <xsl:choose>
                  <xsl:when test="@type = 'implied'">true</xsl:when>
                  <xsl:otherwise>false</xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:if test="string(@value) != ''">
              <xsl:attribute name="value">
                <xsl:value-of select="stringutils:replace(@value,',','|')"/>
              </xsl:attribute>
            </xsl:if>
           <xsl:choose>
			   <xsl:when test="string(@booleanOperator) = 'and'">
			     <xsl:attribute name="booleanOperator">
			       <xsl:value-of select="@booleanOperator"/>
			     </xsl:attribute>
			   </xsl:when>
			   <xsl:otherwise>
			     <xsl:attribute name="booleanOperator">
			       <xsl:text>or</xsl:text>
			     </xsl:attribute>
			   </xsl:otherwise>
		  </xsl:choose>
           <xsl:if test="string(@predicate) != ''">
              <xsl:attribute name="predicate">
                <xsl:value-of select="@predicate"/>
              </xsl:attribute>
           </xsl:if>
       </AttributesCondition>
  	</xsl:if>
	
	<xsl:if test="string(@relationship) != ''">
  		<RelationshipRoleCondition id="{@id}" role="{@relationship}">
  			<xsl:if test="string(@name) != ''">
              <xsl:attribute name="name">
                <xsl:value-of select="@name"/>
              </xsl:attribute>
            </xsl:if>
            <xsl:attribute name="implied">
                <xsl:choose>
                  <xsl:when test="@type = 'implied'">true</xsl:when>
                  <xsl:otherwise>false</xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:if test="string(@type) != ''">
              <xsl:attribute name="type">
                <xsl:value-of select="@type"/>
              </xsl:attribute>
            </xsl:if>
           <xsl:if test="string(@predicate) != ''">
              <xsl:attribute name="predicate">
                <xsl:value-of select="@predicate"/>
              </xsl:attribute>
           </xsl:if>
       </RelationshipRoleCondition>
  	</xsl:if>
  </xsl:template>
  
  <xsl:template match="ALTERNATIVE/PAGE/LINK"/>
  
  <xsl:template match="ALTERNATIVE/PAGE" mode="alt-page-links">
    <xsl:if test="LINK">
      <NoOpContentUnit gr:x="15" gr:y="15" id="gctu_{@id}" name="Links">
        <xsl:apply-templates select="LINK" mode="copy"/>
      </NoOpContentUnit>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="LINK">
    <xsl:apply-templates select="." mode="copy"/>
  </xsl:template>
  
  <xsl:template match="LINK" mode="copy">
    <Link id="{@id}" name="{@name}" to="{@to}" type="{@type}">
      <xsl:if test="string(@automaticCoupling) = 'yes'">
          <xsl:attribute name="automaticCoupling">true</xsl:attribute>
	      <xsl:if test="(parent::DATAUNIT) and (key('id', @to)/self::CHANGEGROUPUNIT)">
		  		<xsl:choose>
		  			<xsl:when test="string(../@entity) = 'User'">
				        <xsl:attribute name="automaticCoupling">false</xsl:attribute>
						<LinkParameter id="{@id}_par" name="OID_Current User" source="data.userOID">
							<xsl:attribute name="target"><xsl:value-of select="concat(@to, '.userOid')"/></xsl:attribute>
						</LinkParameter>
		  			</xsl:when>
		  			<xsl:when test="string(../@entity) = 'Group'">
				        <xsl:attribute name="automaticCoupling">false</xsl:attribute>
						<LinkParameter id="{@id}_par" name="OID_Selected Group" source="data.groupOID">
							<xsl:attribute name="target"><xsl:value-of select="concat(@to, '.groupOid')"/></xsl:attribute>
						</LinkParameter>
		  			</xsl:when>
		  		</xsl:choose>
	      </xsl:if>
      </xsl:if>
      <xsl:if test="string(@newWindow) = 'yes'">
        <xsl:attribute name="newWindow">true</xsl:attribute>
      </xsl:if>
      <xsl:choose>
  		<xsl:when test="PROPERTY[@name='ajax']">
      		<xsl:choose>
      			<xsl:when test="string(@newWindow) = 'yes'">
      				<xsl:attribute name="validate">false</xsl:attribute>
      			</xsl:when>
      			<xsl:when test="key('id', @to)[1]/self::*[ancestor-or-self::PAGE[1][parent::PAGE][PROPERTY[@name='ajax-window']]]">
      				<xsl:attribute name="validate">false</xsl:attribute>
      			</xsl:when>
      			<xsl:otherwise>
      				<xsl:attribute name="validate">true</xsl:attribute>
      			</xsl:otherwise>
      		</xsl:choose>
      	</xsl:when>
      	<xsl:otherwise>
      		<xsl:attribute name="validate">true</xsl:attribute>
      	</xsl:otherwise>
      </xsl:choose>
      <xsl:variable name="bendpoints" select="fn:bendpoints(@id)"/>
      <xsl:if test="string($bendpoints) != ''">
        <xsl:attribute name="gr:bendpoints">
          <xsl:value-of select="$bendpoints"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="PROPERTY[@name = 'do-not-refresh']">
        <xsl:attribute name="preserveForm">true</xsl:attribute>
      </xsl:if>
      <!-- AJAX -->
      <xsl:if test="PROPERTY[@name='ajax']">
        <xsl:attribute name="ajaxEnabled">true</xsl:attribute>
	      <xsl:if test="string(@newWindow) = 'yes'">
	        <xsl:attribute name="ajaxOpenWindow">true</xsl:attribute>
	        <xsl:variable name="window-page" select="key('id', @to)[1]/ancestor-or-self::PAGE"/>
	        <xsl:if test="saxon:node-set($window-page)/PROPERTY[@name='style']">
	        	<xsl:attribute name="ajaxWindowClassName">
	        		<xsl:value-of select="saxon:node-set($window-page)/PROPERTY[@name='style']/@value"/>	
	        	</xsl:attribute>
	        </xsl:if>
	        <xsl:attribute name="ajaxWindowMinimizable">
        		<xsl:choose>
        			<xsl:when test="saxon:node-set($window-page)/PROPERTY[@name='minimize'] and string(saxon:node-set($window-page)/PROPERTY[@name='minimize']/@value) != ''">
        				<xsl:value-of select="saxon:node-set($window-page)/PROPERTY[@name='minimize']/@value"/>
        			</xsl:when>
        			<xsl:otherwise>true</xsl:otherwise>
        		</xsl:choose>	
	        </xsl:attribute>
	        <xsl:attribute name="ajaxWindowMaximizable">
        		<xsl:choose>
        			<xsl:when test="saxon:node-set($window-page)/PROPERTY[@name='maximize'] and string(saxon:node-set($window-page)/PROPERTY[@name='maximize']/@value) != ''">
        				<xsl:value-of select="saxon:node-set($window-page)/PROPERTY[@name='maximize']/@value"/>
        			</xsl:when>
        			<xsl:otherwise>true</xsl:otherwise>
        		</xsl:choose>	
	        </xsl:attribute>
	        <xsl:attribute name="ajaxWindowResizable">
        		<xsl:choose>
        			<xsl:when test="saxon:node-set($window-page)/PROPERTY[@name='resizable'] and string(saxon:node-set($window-page)/PROPERTY[@name='resizable']/@value) != ''">
        				<xsl:value-of select="saxon:node-set($window-page)/PROPERTY[@name='resizable']/@value"/>
        			</xsl:when>
        			<xsl:otherwise>true</xsl:otherwise>
        		</xsl:choose>	
	        </xsl:attribute>
	        <xsl:attribute name="ajaxWindowClosable">
        		<xsl:choose>
        			<xsl:when test="saxon:node-set($window-page)/PROPERTY[@name='closable'] and string(saxon:node-set($window-page)/PROPERTY[@name='closable']/@value) != ''">
        				<xsl:value-of select="saxon:node-set($window-page)/PROPERTY[@name='closable']/@value"/>
        			</xsl:when>
        			<xsl:otherwise>true</xsl:otherwise>
        		</xsl:choose>	
	        </xsl:attribute>
	        <xsl:attribute name="ajaxWindowDraggable">
        		<xsl:choose>
        			<xsl:when test="saxon:node-set($window-page)/PROPERTY[@name='draggable'] and string(saxon:node-set($window-page)/PROPERTY[@name='draggable']/@value) != ''">
        				<xsl:value-of select="saxon:node-set($window-page)/PROPERTY[@name='draggable']/@value"/>
        			</xsl:when>
        			<xsl:otherwise>true</xsl:otherwise>
        		</xsl:choose>	
	        </xsl:attribute>
	        <xsl:attribute name="ajaxWindowModal">
        		<xsl:choose>
        			<xsl:when test="saxon:node-set($window-page)/PROPERTY[@name='modal'] and string(saxon:node-set($window-page)/PROPERTY[@name='modal']/@value) != ''">
        				<xsl:value-of select="saxon:node-set($window-page)/PROPERTY[@name='modal']/@value"/>
        			</xsl:when>
        			<xsl:otherwise>false</xsl:otherwise>
        		</xsl:choose>	
	        </xsl:attribute>
	      </xsl:if>
	      <xsl:if test="key('id', @to)[1]/self::*[ancestor-or-self::PAGE[1][parent::PAGE][PROPERTY[@name='ajax-window']]]">
	        <xsl:attribute name="ajaxOpenWindow">true</xsl:attribute>
	        <xsl:variable name="window-page" select="key('id', @to)[1]/ancestor-or-self::PAGE"/>
	        <xsl:if test="saxon:node-set($window-page)/PROPERTY[@name='style']">
	        	<xsl:attribute name="ajaxWindowClassName">
	        		<xsl:value-of select="saxon:node-set($window-page)/PROPERTY[@name='style']/@value"/>	
	        	</xsl:attribute>
	        </xsl:if>
	        <xsl:attribute name="ajaxWindowMinimizable">
        		<xsl:choose>
        			<xsl:when test="saxon:node-set($window-page)/PROPERTY[@name='minimize'] and string(saxon:node-set($window-page)/PROPERTY[@name='minimize']/@value) != ''">
        				<xsl:value-of select="saxon:node-set($window-page)/PROPERTY[@name='minimize']/@value"/>
        			</xsl:when>
        			<xsl:otherwise>true</xsl:otherwise>
        		</xsl:choose>	
	        </xsl:attribute>
	        <xsl:attribute name="ajaxWindowMaximizable">
        		<xsl:choose>
        			<xsl:when test="saxon:node-set($window-page)/PROPERTY[@name='maximize'] and string(saxon:node-set($window-page)/PROPERTY[@name='maximize']/@value) != ''">
        				<xsl:value-of select="saxon:node-set($window-page)/PROPERTY[@name='maximize']/@value"/>
        			</xsl:when>
        			<xsl:otherwise>true</xsl:otherwise>
        		</xsl:choose>	
	        </xsl:attribute>
	        <xsl:attribute name="ajaxWindowResizable">
        		<xsl:choose>
        			<xsl:when test="saxon:node-set($window-page)/PROPERTY[@name='resizable'] and string(saxon:node-set($window-page)/PROPERTY[@name='resizable']/@value) != ''">
        				<xsl:value-of select="saxon:node-set($window-page)/PROPERTY[@name='resizable']/@value"/>
        			</xsl:when>
        			<xsl:otherwise>true</xsl:otherwise>
        		</xsl:choose>	
	        </xsl:attribute>
	        <xsl:attribute name="ajaxWindowClosable">
        		<xsl:choose>
        			<xsl:when test="saxon:node-set($window-page)/PROPERTY[@name='closable'] and string(saxon:node-set($window-page)/PROPERTY[@name='closable']/@value) != ''">
        				<xsl:value-of select="saxon:node-set($window-page)/PROPERTY[@name='closable']/@value"/>
        			</xsl:when>
        			<xsl:otherwise>true</xsl:otherwise>
        		</xsl:choose>	
	        </xsl:attribute>
	        <xsl:attribute name="ajaxWindowDraggable">
        		<xsl:choose>
        			<xsl:when test="saxon:node-set($window-page)/PROPERTY[@name='draggable'] and string(saxon:node-set($window-page)/PROPERTY[@name='draggable']/@value) != ''">
        				<xsl:value-of select="saxon:node-set($window-page)/PROPERTY[@name='draggable']/@value"/>
        			</xsl:when>
        			<xsl:otherwise>true</xsl:otherwise>
        		</xsl:choose>	
	        </xsl:attribute>
	        <xsl:attribute name="ajaxWindowModal">
        		<xsl:choose>
        			<xsl:when test="saxon:node-set($window-page)/PROPERTY[@name='modal'] and string(saxon:node-set($window-page)/PROPERTY[@name='modal']/@value) != ''">
        				<xsl:value-of select="saxon:node-set($window-page)/PROPERTY[@name='modal']/@value"/>
        			</xsl:when>
        			<xsl:otherwise>false</xsl:otherwise>
        		</xsl:choose>	
	        </xsl:attribute>
	      </xsl:if>
	      <xsl:if test="PROPERTY[@name='show-progress-dialog']">
	        <xsl:attribute name="ajaxOpenWaitingDialog">true</xsl:attribute>
	        <xsl:if test="PROPERTY[@name='dialog-message']">
	        	<xsl:attribute name="ajaxWaitingDialogMessage"><xsl:value-of select="PROPERTY[@name='dialog-message']/@value"/></xsl:attribute>
	        </xsl:if>
	        <xsl:if test="PROPERTY[@name='dialog-width']">
	        	<xsl:attribute name="ajaxWaitingDialogWidth"><xsl:value-of select="PROPERTY[@name='dialog-width']/@value"/></xsl:attribute>
	        </xsl:if>
	        <xsl:if test="PROPERTY[@name='dialog-height']">
	        	<xsl:attribute name="ajaxWaitingDialogHeight"><xsl:value-of select="PROPERTY[@name='dialog-height']/@value"/></xsl:attribute>
	        </xsl:if>
	      </xsl:if>
      </xsl:if>
      <!-- AJAX -->
      <xsl:if test="PROPERTY[@name='close-window']">
        <xsl:attribute name="ajaxCloseWindow">true</xsl:attribute>
        <xsl:attribute name="preserveForm">true</xsl:attribute>
      </xsl:if>
      <xsl:if test="string(@automaticCoupling) = 'yes' and parent::MULTICHOICEINDEXUNIT and key('id', @to)/self::SETUNIT">
        <xsl:variable name="globalParameter">
  		    <xsl:value-of select="key('id', @to)/@globalParameter"/>
        </xsl:variable>
        <xsl:variable name="globalParameterEntity">
  		    <xsl:value-of select="key('id', $globalParameter)/@entity"/>
        </xsl:variable>
        <xsl:variable name="sourceOIDAttr">
  		    <xsl:apply-templates select="key('entity', ../@entity)" mode="oid-attr"/>
        </xsl:variable>
        <xsl:variable name="targetOIDAttr">
          <xsl:if test="$globalParameterEntity != 'User' and $globalParameterEntity != 'Group' and $globalParameterEntity != 'Module'">
            <xsl:value-of select="concat('.', $sourceOIDAttr)"/>
          </xsl:if>
        </xsl:variable>
        <xsl:if test="$globalParameterEntity = ../@entity">
          <xsl:attribute name="automaticCoupling">false</xsl:attribute>
          <LinkParameter id="{@id}_par" name="Selected Object (Single Row)">
    	     	<xsl:attribute name="source">
  	       		<xsl:value-of select="concat('data[].', $sourceOIDAttr)"/>
	         	</xsl:attribute>
  	       	<xsl:attribute name="target">
	         		<xsl:value-of select="concat(@to, '.', $globalParameter, $targetOIDAttr)"/>
	         	</xsl:attribute>
          </LinkParameter>
        </xsl:if>
      </xsl:if>
      <xsl:apply-templates select="*"/>
    </Link>
  </xsl:template>
  
  <xsl:template match="LINKPARAMETER">
    <xsl:choose>
      <xsl:when test="key('id', @target)/self::SELECTORCONDITION[string(@relationship) != '']">
        <xsl:variable name="oidAttr">
          <xsl:apply-templates select="key('id', key('id', @target)/self::SELECTORCONDITION/@relationship)/.." mode="oid-attr"/>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="$oidAttr != ''">
            <xsl:apply-templates select="." mode="default">
              <xsl:with-param name="target" select="concat(@target, '.', $oidAttr)"/>
            </xsl:apply-templates>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="." mode="default"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="." mode="default"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  
  <xsl:template match="LINKPARAMETER" mode="default">
    <xsl:param name="target" select="@target"/>
    <xsl:variable name="unitName" select="parent::LINK/parent::*"/>
    <LinkParameter id="{@id}" name="{@name}">
      <xsl:if test="string(@passing) = 'yes'">
        <xsl:attribute name="passing">true</xsl:attribute>
      </xsl:if>
      <xsl:if test="string(@source) != ''">
        <xsl:attribute name="source">
          <xsl:variable name="sourceValue" select="linkHelper:convertOutputParameterName($linkHelperInstance, .)"/>
          <xsl:value-of select="$sourceValue"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="$target != ''">
        <xsl:attribute name="target">
          <xsl:variable name="targetValue" select="linkHelper:convertInputParameterName($linkHelperInstance, ., key('id', ../@to))"/>
          <xsl:value-of select="$targetValue"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="string(@sourceValue) != ''">
        <xsl:attribute name="sourceValue">
          <xsl:value-of select="@sourceValue"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:choose>
	      <xsl:when test="string(@blank) = 'yes'"> 
	      	<xsl:attribute name="blank">true</xsl:attribute>
	      </xsl:when>
          <xsl:otherwise>
	        <xsl:attribute name="blank">false</xsl:attribute>
          </xsl:otherwise>
      </xsl:choose>
      
      <xsl:if test="string(@sourceLinkParameter) != ''">      
        <xsl:attribute name="sourceLinkParameter">
          <xsl:value-of select="@sourceLinkParameter"/>
        </xsl:attribute>
      </xsl:if>
    </LinkParameter>
  </xsl:template>

  <xsl:template match="OK-LINK">
    <OKLink id="{@id}" name="{@name}" to="{@to}">
      <xsl:if test="string(@automaticCoupling) = 'yes'">
        <xsl:attribute name="automaticCoupling">true</xsl:attribute>
      </xsl:if>
      <xsl:if test="string(@code) != ''">
        <xsl:attribute name="code">
          <xsl:value-of select="@code"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:variable name="bendpoints" select="fn:bendpoints(@id)"/>
      <xsl:if test="string($bendpoints) != ''">
        <xsl:attribute name="gr:bendpoints">
          <xsl:value-of select="$bendpoints"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="PROPERTY[@name = 'do-not-refresh']">
        <xsl:attribute name="preserveForm">true</xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="*"/>
    </OKLink>
  </xsl:template>

  <xsl:template match="KO-LINK">
    <KOLink id="{@id}" name="{@name}" to="{@to}">
      <xsl:if test="string(@automaticCoupling) = 'yes'">
        <xsl:attribute name="automaticCoupling">true</xsl:attribute>
      </xsl:if>
      <xsl:if test="string(@code) != ''">
        <xsl:attribute name="code">
          <xsl:value-of select="@code"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:variable name="bendpoints" select="fn:bendpoints(@id)"/>
      <xsl:if test="string($bendpoints) != ''">
        <xsl:attribute name="gr:bendpoints">
          <xsl:value-of select="$bendpoints"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="PROPERTY[@name = 'do-not-refresh']">
        <xsl:attribute name="preserveForm">true</xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="*"/>
    </KOLink>
  </xsl:template>
  
  <xsl:template match="presentation:grid">
    <layout:Grid>
		<xsl:if test="string(@align) != ''">
		  <xsl:attribute name="align">
		    <xsl:value-of select="@align"/>
		  </xsl:attribute>
		</xsl:if>
		<xsl:if test="string(@width) != ''">
		  <xsl:attribute name="width">
		    <xsl:value-of select="@width"/>
		  </xsl:attribute>
		</xsl:if>
		<xsl:if test="string(@cellpadding) != ''">
		  <xsl:attribute name="padding">
		    <xsl:value-of select="@cellpadding"/>
		  </xsl:attribute>
		</xsl:if>
		<xsl:if test="string(@cellspacing) != ''">
		  <xsl:attribute name="spacing">
		    <xsl:value-of select="@cellspacing"/>
		  </xsl:attribute>
		</xsl:if>
    	<xsl:if test="ancestor::presentation:cell[string(@unit-frame) != '']">
	    	<xsl:attribute name="layout:cellLayout">
	 			<xsl:value-of select="'None'"/>
	     	</xsl:attribute>
	     </xsl:if>
      <xsl:apply-templates select="*"/>
    </layout:Grid>
  </xsl:template>

  <xsl:template match="presentation:custom-location">
    <xsl:if test="count(*) > 0">
      <xsl:variable name="style">
        <xsl:value-of select="ancestor::SITEVIEW/@presentation:style-sheet"/>
      </xsl:variable>
	    <layout:CustomLocation name="{@name}">
	      <xsl:if test="string(@unit-frame) != ''">
	     	<xsl:attribute name="layout:frameLayout">
	     		<xsl:value-of select="concat($style, '/', @unit-frame)"/>
	     	</xsl:attribute>
	     </xsl:if>
	     <xsl:choose>
		     <xsl:when test="string(@group-core) != ''">
		     	<xsl:attribute name="layout:cellLayout">
		     		<xsl:value-of select="concat($style, '/', @group-core)"/>
		     	</xsl:attribute>
		     </xsl:when>
		     <xsl:otherwise>
	     		<xsl:choose>
	     			<xsl:when test="string(@unit-frame) != ''">
				     	<xsl:attribute name="layout:cellLayout">
	    	 				<xsl:value-of select="'Print Frame'"/>
				     	</xsl:attribute>
	     			</xsl:when>
	     			<xsl:when test="ancestor::presentation:cell[string(@unit-frame) != '']">
				     	<xsl:attribute name="layout:cellLayout">
		     				<xsl:value-of select="'None'"/>
				     	</xsl:attribute>
	     			</xsl:when>
	     		</xsl:choose>
		     </xsl:otherwise>
	     </xsl:choose>
	     <xsl:if test="string(@title) != ''">
	     	<xsl:attribute name="label">
	     		<xsl:value-of select="@title"/>
	     	</xsl:attribute>
         </xsl:if>
	     <xsl:if test="string(@align) != ''">
	     	<xsl:attribute name="align">
	     		<xsl:value-of select="@align"/>
	     	</xsl:attribute>
	     </xsl:if>
	     <xsl:if test="string(@valign) != ''">
	     	<xsl:attribute name="valign">
	     		<xsl:value-of select="@valign"/>
	     	</xsl:attribute>
	     </xsl:if>
	     <xsl:if test="string(@width) != ''">
	     	<xsl:attribute name="width">
	     		<xsl:value-of select="@width"/>
	     	</xsl:attribute>
	     </xsl:if>
	     <xsl:if test="string(@padding) != ''">
	     	<xsl:attribute name="padding">
	     		<xsl:value-of select="@padding"/>
	     	</xsl:attribute>
	     </xsl:if>
         <xsl:apply-templates select="*"/>
	   </layout:CustomLocation>
	</xsl:if>
  </xsl:template>

  <xsl:template match="presentation:row">
    <layout:Row>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates select="*"/>
    </layout:Row>
  </xsl:template>

  <xsl:template match="presentation:cell">
    <xsl:variable name="style">
      <xsl:value-of select="ancestor::SITEVIEW/@presentation:style-sheet"/>
    </xsl:variable>
    <layout:Cell>
     <xsl:if test="string(@rowspan) != ''">
     	<xsl:attribute name="rowspan">
     		<xsl:value-of select="@rowspan"/>
     	</xsl:attribute>
     </xsl:if>
     <xsl:if test="string(@colspan) != ''">
     	<xsl:attribute name="colspan">
     		<xsl:value-of select="@colspan"/>
     	</xsl:attribute>
     </xsl:if>
     <xsl:if test="string(@title) != ''">
     	<xsl:attribute name="label">
     		<xsl:value-of select="@title"/>
     	</xsl:attribute>
     </xsl:if>
     <xsl:if test="string(@unit-frame) != ''">
     	<xsl:attribute name="layout:frameLayout">
     		<xsl:value-of select="concat($style, '/', @unit-frame)"/>
     	</xsl:attribute>
     </xsl:if>
     <xsl:choose>
	     <xsl:when test="string(@group-core) != ''">
	     	<xsl:attribute name="layout:cellLayout">
	     		<xsl:value-of select="concat($style, '/', @group-core)"/>
	     	</xsl:attribute>
	     </xsl:when>
	     <xsl:otherwise>
     		<xsl:choose>
     			<xsl:when test="string(@unit-frame) != ''">
			     	<xsl:attribute name="layout:cellLayout">
     					<xsl:value-of select="'Print Frame'"/>
	    		 	</xsl:attribute>
     			</xsl:when>
     			<xsl:when test="ancestor::presentation:cell[string(@unit-frame) != '']">
			     	<xsl:attribute name="layout:cellLayout">
	     				<xsl:value-of select="'None'"/>
	    		 	</xsl:attribute>
     			</xsl:when>
     		</xsl:choose>
	     </xsl:otherwise>
     </xsl:choose>
     <xsl:if test="string(@align) != ''">
     	<xsl:attribute name="align">
     		<xsl:value-of select="@align"/>
     	</xsl:attribute>
     </xsl:if>
     <xsl:if test="string(@valign) != ''">
     	<xsl:attribute name="valign">
     		<xsl:value-of select="@valign"/>
     	</xsl:attribute>
     </xsl:if>
     <xsl:if test="string(@width) != ''">
     	<xsl:attribute name="width">
     		<xsl:value-of select="@width"/>
     	</xsl:attribute>
     </xsl:if>
     <xsl:if test="string(@padding) != ''">
     	<xsl:attribute name="padding">
     		<xsl:value-of select="@padding"/>
     	</xsl:attribute>
     </xsl:if>
     <xsl:apply-templates select="*"/>
    </layout:Cell>
  </xsl:template>
  
  <xsl:template match="SCRIPTUNIT|MULTIDATAUNIT" mode="reports">
    <xsl:variable name="dummy" select="map:put($unitReports, string(@name), string(ancestor::PAGE/@name))"/>
  </xsl:template>

  <xsl:template match="HIERARCHICALINDEXUNIT" mode="reports">
    <xsl:variable name="dummy" select="map:put($unitReports, string(@name), string(ancestor::PAGE/@name))"/>
    <xsl:apply-templates select="HIERARCHICALINDEXLEVEL" mode="reports"/>
  </xsl:template>
   <xsl:template match="HIERARCHICALINDEXLEVEL" mode="reports">
    <xsl:variable name="dummy" select="map:put($unitReports, string(@name), string(parent::HIERARCHICALINDEXLEVEL[1]/@name|parent::HIERARCHICALINDEXUNIT[1]/@name))"/>
    <xsl:apply-templates select="HIERARCHICALINDEXLEVEL" mode="reports"/>
  </xsl:template>

  <xsl:template match="presentation:unit">
    <xsl:variable name="style">
      <xsl:value-of select="ancestor::SITEVIEW/@presentation:style-sheet"/>
    </xsl:variable>
    <layout:Unit unitId="{@element}">
      <xsl:choose>
	      <xsl:when test="string(@unit-core) = 'Jasper'">
            <xsl:apply-templates select="key('id', @element)" mode="reports"/>
	      </xsl:when>
	      <xsl:otherwise>
		      <xsl:if test="string(@unit-core) != ''">
		     	<xsl:attribute name="layout:unitLayout">
		     		<xsl:value-of select="layoutHelper:getUnitLayout($layoutHelperInstance, name(key('id', @element)), $style, @unit-core)"/>
		     	</xsl:attribute>
		     </xsl:if>
	     </xsl:otherwise>
     </xsl:choose>
     <xsl:if test="string(@title) != ''">
	    <xsl:attribute name="label">
	     	<xsl:value-of select="@title"/>
	    </xsl:attribute>
     </xsl:if>
      <xsl:choose>
	      <xsl:when test="string(@unit-frame) = 'None'">
	        <xsl:attribute name="layout:frameLayout">WRDefault/Empty</xsl:attribute>
	      </xsl:when>
	      <xsl:when test="string(@unit-frame) = ''"/>
	      <xsl:otherwise>
	        <xsl:attribute name="layout:frameLayout">
     		   <xsl:value-of select="concat($style, '/', @unit-frame)"/>
     	    </xsl:attribute>
	      </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="@show-attributes-manually = 'yes'">
        <xsl:attribute name="manualAttributes">true</xsl:attribute>
      </xsl:if>
      <xsl:if test="@show-fields-manually = 'yes'">
        <xsl:attribute name="manualFields">true</xsl:attribute>
      </xsl:if>
      <xsl:if test="@show-links-manually = 'yes'">
        <xsl:attribute name="manualLinks">true</xsl:attribute>
      </xsl:if>
      <xsl:if test="key('id',@element)/self::SCROLLERUNIT | key('id',@element)/self::POWERINDEXUNIT">
         <layout:Link link="{@element}First"/>
         <layout:Link link="{@element}Previous"/>
         <layout:Link link="{@element}Block"/>
         <layout:Link link="{@element}Next"/>
         <layout:Link link="{@element}Last"/> 
      </xsl:if>
      <xsl:if test="key('id',@element)/self::EVENTCALENDARUNIT">
         <layout:Link link="{@element}-month-0"/>
         <layout:Link link="{@element}-month-1"/>
         <layout:Link link="{@element}-month-2"/>
         <layout:Link link="{@element}-month-3"/>
         <layout:Link link="{@element}-month-4"/>
         <layout:Link link="{@element}-month-5"/>
         <layout:Link link="{@element}-month-6"/>
         <layout:Link link="{@element}-month-7"/>
         <layout:Link link="{@element}-month-8"/>
         <layout:Link link="{@element}-month-9"/>
         <layout:Link link="{@element}-month-10"/>
         <layout:Link link="{@element}-month-11"/>
         <layout:Link link="{@element}-year"/> 
      </xsl:if>
      <xsl:if test="key('id',@element)/self::SORTABLEINDEXUNIT | key('id',@element)/self::POWERINDEXUNIT">
         <xsl:for-each select="key('id',@element)/SORTATTRIBUTE[@attribute = ../DISPLAYATTRIBUTE/@attribute]">
           <layout:Link link="{../@id}{@attribute}"/>
         </xsl:for-each>
      </xsl:if>
      <xsl:apply-templates select="*"/>
    </layout:Unit>
  </xsl:template>
  
  <xsl:template match="presentation:core-parameter">
  	<xsl:variable name="lowerCase">abcdefghijklmnopqrstuvwxyz</xsl:variable>
	<xsl:variable name="upperCase">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
  	<layout:LayoutParameter name="{@name}" type="unit">
  		<xsl:attribute name="value">
  			<xsl:choose>
  				<xsl:when test="@value = 'Yes'">
  				  <xsl:value-of select="'true'"/>
  				</xsl:when>
  				<xsl:when test="@value = 'No'">
  					<xsl:value-of select="'false'"/>
  				</xsl:when>
  				<xsl:otherwise>
  					<xsl:value-of select="translate(@value,$upperCase,$lowerCase)"/>
  				</xsl:otherwise>
  			</xsl:choose>
  		</xsl:attribute>
  	</layout:LayoutParameter>
  </xsl:template>

  <xsl:template match="presentation:alternative-page">
    <xsl:apply-templates select="*"/>
  </xsl:template>
  
  <xsl:template match="presentation:subpage[key('id',@page)[PROPERTY[@name='ajax-window']]]"/>
  
  <xsl:template match="presentation:subpage">
    <layout:SubPage pageId="{@page}">
      <xsl:if test="string(@title) != ''">
	    <xsl:attribute name="label">
	     	<xsl:value-of select="@title"/>
	    </xsl:attribute>
     </xsl:if> 
      <xsl:apply-templates select="*"/>
    </layout:SubPage>
  </xsl:template>
  
  <xsl:template match="presentation:subunit">
  	<xsl:variable name="elem" select="@element"/>
  	<xsl:choose>
  		<xsl:when test="key('id', $elem)/self::LINK">
  			<layout:Link link="{@element}" mode="{@mode}" unitId="{@unit}">
  			    <xsl:if test="string(@title) != ''">
				    <xsl:attribute name="label">
				     	<xsl:value-of select="@title"/>
				    </xsl:attribute>
			     </xsl:if>
  			</layout:Link>
  			<xsl:apply-templates select="*"/>
  		</xsl:when>
  		<xsl:when test="key('id', $elem)/self::ATTRIBUTE">
  		<xsl:variable name="newIdRefs" select="unitHelper:convertAttributeRefs(., @element)"/>
  			<layout:Attribute attribute="{$newIdRefs}" mode="{@mode}" unitId="{@unit}">
  			     <xsl:if test="string(@title) != ''">
				    <xsl:attribute name="label">
				     	<xsl:value-of select="@title"/>
				    </xsl:attribute>
			     </xsl:if>
  			</layout:Attribute>
  			<xsl:apply-templates select="*"/>
  	    </xsl:when>
  		<xsl:otherwise>
        	<layout:Field field="{@element}" mode="{@mode}" unitId="{@unit}">
  			    <xsl:if test="string(@title) != ''">
				    <xsl:attribute name="label">
				     	<xsl:value-of select="@title"/>
				    </xsl:attribute>
			     </xsl:if>
  			</layout:Field>
  		</xsl:otherwise>
  	</xsl:choose>
  </xsl:template>
  
  <xsl:template match="presentation:attribute">
    <xsl:variable name="newIdRefs" select="unitHelper:convertAttributeRefs(., @attribute)"/>
    <layout:Attribute attribute="{$newIdRefs}">
    	<xsl:if test="@title != ''">
    		<xsl:attribute name="label">
    			<xsl:value-of select="@title"/>
    		</xsl:attribute>
    	</xsl:if>
    	<xsl:if test="@class != ''">
    		<xsl:attribute name="styleClass">
    			<xsl:value-of select="@class"/>
    		</xsl:attribute>
    	</xsl:if>
    </layout:Attribute>
    <xsl:apply-templates select="*"/>
  </xsl:template>
  
  <xsl:template match="presentation:field">
    <layout:Field field="{@field}">
    	<xsl:if test="@title != ''">
    		<xsl:attribute name="label">
    			<xsl:value-of select="@title"/>
    		</xsl:attribute>
    	</xsl:if>
    	<xsl:if test="@class != ''">
    		<xsl:attribute name="styleClass">
    			<xsl:value-of select="@class"/>
    		</xsl:attribute>
    	</xsl:if>
    </layout:Field>
    <xsl:apply-templates select="*"/>
  </xsl:template>
  
  <xsl:template match="presentation:link[key('id',../@element)/self::SCROLLERUNIT]"/>
  
  <xsl:template match="presentation:link">
    <layout:Link link="{@link}">
    	<xsl:if test="@title != ''">
    		<xsl:attribute name="label">
    			<xsl:value-of select="@title"/>
    		</xsl:attribute>
    	</xsl:if>
    	<xsl:if test="@class != ''">
    		<xsl:attribute name="styleClass">
    			<xsl:value-of select="@class"/>
    		</xsl:attribute>
    	</xsl:if>
    </layout:Link>
    <xsl:apply-templates select="*"/>
  </xsl:template>
  
  <xsl:template match="*"/>
  
  <xsl:template match="@*"/>

  <saxon:function name="fn:unescape">
    <xsl:param name="s"/>
    <xsl:choose>
      <xsl:when test="starts-with($s, '[')">
        <xsl:variable name="length" select="string-length($s)"/>
        <saxon:return select="substring($s, 2, $length - 2)"/>
      </xsl:when>
      <xsl:otherwise>
        <saxon:return select="$s"/>
      </xsl:otherwise>
    </xsl:choose>
  </saxon:function>

  <saxon:function name="fn:x">
    <xsl:param name="id"/>
    <xsl:choose>
      <xsl:when test="map:get($nodesXY, string(@id))">
        <saxon:return select="substring-before(map:get($nodesXY, string(@id)), ',')"/>
      </xsl:when>
      <xsl:otherwise>
        <saxon:return select="'0'"/>
      </xsl:otherwise>
    </xsl:choose>
  </saxon:function>
  
  <saxon:function name="fn:y">
    <xsl:param name="id"/>
    <xsl:choose>
      <xsl:when test="map:get($nodesXY, string(@id))">
        <saxon:return select="substring-after(map:get($nodesXY, string(@id)), ',')"/>
      </xsl:when>
      <xsl:otherwise>
        <saxon:return select="'0'"/>
      </xsl:otherwise>
    </xsl:choose>
  </saxon:function>

  <saxon:function name="fn:bendpoints">
    <xsl:param name="id"/>
    <xsl:choose>
      <xsl:when test="map:get($connectionsXY, string(@id))">
        <saxon:return select="map:get($connectionsXY, string(@id))"/>
      </xsl:when>
      <xsl:otherwise>
        <saxon:return select="''"/>
      </xsl:otherwise>
    </xsl:choose>
  </saxon:function>
  
  <xsl:template match="*" mode="landmarks-attr">
    <!-- 
    <xsl:variable name="landmarks">
      <xsl:for-each select="AREA[@landmark = 'yes']|PAGE[@landmark = 'yes']|OPERATIONUNITS/*[@landmark = 'yes']|TRANSACTION/OPERATIONUNITS/*[@landmark = 'yes']">
        <xsl:if test="position() &gt; 1"><xsl:text> </xsl:text></xsl:if>
        <xsl:value-of select="@id"/>
      </xsl:for-each>
    </xsl:variable>
    <xsl:attribute name="landmarks">
      <xsl:value-of select="$landmarks"/>
    </xsl:attribute>
    -->
    <xsl:attribute name="landmarks">
      <xsl:value-of select="@landmarks"/>
    </xsl:attribute>
  </xsl:template>
  
  <xsl:template name="sendTaskWorked">
    <xsl:variable name="dummy">
      <xsl:value-of select="sc:sendTaskWorked($eventSocketClient, 'Main', 1)"/>
    </xsl:variable>
  </xsl:template>
  
  <xsl:template name="sendTaskDone">
    <xsl:variable name="dummy4">
      <xsl:value-of select="sc:sendTaskDone($eventSocketClient, 'Main')"/>
    </xsl:variable>
  </xsl:template>
  
  <xsl:template match="EMAILUNIT|POWERMAILUNIT" mode="smtpServer">
    <xsl:variable name="key" select="concat(@smtp-server, '__', @username, '__', @password, '__', @default-from)"/>
    <xsl:value-of select="concat('smtp', key('mail-units-by-key', $key)[1]/@id)"/>
  </xsl:template>

</xsl:stylesheet>