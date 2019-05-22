<?xml version="1.0"?>

<!-- ============================================================= -->
<!--  SDS Meta-schema filtering stylesheet                         -->
<!--                                                               -->
<!--   Version 0.0.1 (Oct 21 2003)                                 -->
<!-- ============================================================= -->


<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:presentation="http://www.webml.org/presentation"
                xmlns:graphmetadata="http://www.webml.org/graphmetadata"
                xmlns:gr="http://www.webml.org/graph"
                xmlns:auxiliary="http://www.webml.org/auxiliary"
                version="1.0">
  
 <xsl:output indent="yes"
              method="xml"
              encoding="ISO-8859-1"
              doctype-system="WebML.dtd"/>
	     
  <!-- ========================================================= -->
  <!-- Key declarations                                          -->
  <!-- ========================================================= --> 
  <xsl:key name="graph" match="graphmetadata:Node | graphmetadata:Connection | graphmetadata:Drawing" use="@element"/>

<!-- ============================================================= -->
<!-- =================== N A V I G A T I O N ===================== -->
<!-- ============================================================= -->
  
  <xsl:template match="WebML">
   
   <WebML xmlns:auxiliary="http://www.webml.org/auxiliary" 
          xmlns:presentation="http://www.webml.org/presentation"
          xmlns:gr="http://www.webml.org/graph">
    
     <xsl:apply-templates select="@*[not(starts-with(name(),'xmlns'))]"/>
     <xsl:apply-templates select="*[name() != 'MetaStructure'][name() != 'auxiliary:GraphMetaData']"/> 
   </WebML>
  </xsl:template>
 
  <xsl:template match="*[ key('graph',@id) ]">
   <xsl:copy>
    
     <xsl:attribute name="gr:x"><xsl:value-of select="key('graph',@id)/@x"/></xsl:attribute>
     <xsl:attribute name="gr:y"><xsl:value-of select="key('graph',@id)/@y"/></xsl:attribute>
     <xsl:if test="key('graph',@id)/@scale">
      <xsl:attribute name="gr:scale"><xsl:value-of select="key('graph',@id)/@scale"/></xsl:attribute>
     </xsl:if>
   
    <xsl:apply-templates select="*|@*"/>
   </xsl:copy>
  </xsl:template>
  
  <!-- Changing  ProjectDependentOptions to ProjectOptions-->
  <xsl:template match="auxiliary:ProjectDependentOptions">
   <auxiliary:ProjectOptions>
    <xsl:apply-templates select="*|@*"/>
   </auxiliary:ProjectOptions>
  </xsl:template>
 
  <!-- Converting pattern type from Timestamp to TimeStamp -->
  <xsl:template match="PATTERN[@webmltype = 'Timestamp']">
    <xsl:copy>
      <xsl:apply-templates select="@*[name() != 'webmltype']"/>
      <xsl:attribute name="webmltype">TimeStamp</xsl:attribute>
    </xsl:copy>
  </xsl:template>
 
  <!-- Removing loopback parameters -->
  <xsl:template match="LINKPARAMETER[string(@loopback) = 'yes']">
    <!-- do nothing -->
  </xsl:template>


    <!-- ============================================================= -->
	<!-- ================ M I S C E L L A N E O U S ================== -->
	<!-- ============================================================= -->
	<!-- ========================================================= -->
	<!-- Default: copy elements and attributes                     -->
	<!-- ========================================================= -->
	<xsl:template match="*|@*|comment()|processing-instruction()|text()">
		<xsl:copy>
			<xsl:apply-templates select="*|@*|comment()| processing-instruction()|text()"/>
		</xsl:copy>
    </xsl:template>

</xsl:stylesheet>
