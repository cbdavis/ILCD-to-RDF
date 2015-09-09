<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
	xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
	xmlns:common="http://lca.jrc.it/ILCD/Common" 
	xmlns:process="http://lca.jrc.it/ILCD/Process"
	xmlns:flow="http://lca.jrc.it/ILCD/Flow"
	xmlns:commonRDF="http://lca.jrc.it/ILCD/Common/" 
	xmlns:processRDF="http://lca.jrc.it/ILCD/Process/"
	xmlns:flowRDF="http://lca.jrc.it/ILCD/Flow/"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:skos="http://www.w3.org/2004/02/skos/core#"
	xmlns:fn="http://www.w3.org/2005/xpath-functions"
	version="2.0">
	<xsl:include href="url-encode.xsl"/>
	<xsl:output method="xml" encoding="UTF-8" indent="yes"/>
 
       <!-- Begin RDF document -->
       <xsl:template match="/">
              <xsl:element name="rdf:RDF">
                    <xsl:apply-templates select="//flow:flowDataSet"/>
	            <xsl:apply-templates select="//common:elementaryFlowCategorization/common:category"/>
              </xsl:element>
	</xsl:template>

	<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" match="flow:flowDataSet">
	  <rdf:Description xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
		<xsl:attribute name="rdf:about">
			<xsl:text>http://lca.jrc.it/ILCD/Flow/</xsl:text>
			<xsl:value-of select="//common:UUID"/>
		</xsl:attribute>
		<rdfs:label><xsl:value-of select="//flow:baseName"/></rdfs:label>

		<xsl:apply-templates select="//common:synonyms"/>
		
		<xsl:if test="//flow:CASNumber != ''">
			<flowRDF:CASNumber>
				<xsl:attribute name="rdf:resource">
					<xsl:text>http://enipedia.tudelft.nl/data/CAS/</xsl:text>
					<xsl:value-of select="fn:replace(//flow:CASNumber, '^0+', '')"/>
				</xsl:attribute>
			</flowRDF:CASNumber>
			<flowRDF:CASNumberText><xsl:value-of select="//flow:CASNumber"/></flowRDF:CASNumberText>
		</xsl:if>
		<flowRDF:typeOfDataSet><xsl:value-of select="//flow:typeOfDataSet"/></flowRDF:typeOfDataSet>

		<!-- 
		common:elementaryFlowCategorization and common:category aren't in a good semantic format.
		These are standard identifiers but there are no uuid's associated with them.
		Would be useful to have skos:broader and skos:narrower to represent the hierarchy between them
		-->

		<xsl:for-each select="//common:elementaryFlowCategorization/common:category">
			<commonRDF:category>
				<xsl:variable name="flowCategorizationURL">
					<xsl:text>http://lca.jrc.it/ILCD/FlowCategorization/Level/</xsl:text>
					<xsl:value-of select="./@level"/>
					<xsl:text>/</xsl:text>
					<xsl:call-template name="url-encode">
					  <xsl:with-param name="str" select="./text()" />
					</xsl:call-template>
				</xsl:variable>
				<xsl:attribute name="rdf:resource">
					<xsl:value-of select="$flowCategorizationURL" />
				</xsl:attribute>
			</commonRDF:category>
		</xsl:for-each>

		<!-- set the rdf:type -->
		<rdf:type rdf:resource="http://lca.jrc.it/ILCD/Flow"/>
   	  </rdf:Description>
	</xsl:template>


	<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" match="common:elementaryFlowCategorization/common:category">
   	  <rdf:Description>
		<xsl:variable name="flowCategorizationURL">
			<xsl:text>http://lca.jrc.it/ILCD/FlowCategorization/Level/</xsl:text>
			<xsl:value-of select="./@level"/>
			<xsl:text>/</xsl:text>
			<xsl:call-template name="url-encode">
			  <xsl:with-param name="str" select="./text()" />
			</xsl:call-template>
		</xsl:variable>

		<!-- TODO conditional statement that looks at the level and sets skos:broader, skos:narrower accordingly -->

		<xsl:attribute name="rdf:about">
			<xsl:value-of select="$flowCategorizationURL"/>
		</xsl:attribute>

		<rdfs:label><xsl:value-of select="text()"/></rdfs:label>

		<xsl:if test="./@level = '0'">
			<skos:narrower>
				<xsl:text>http://lca.jrc.it/ILCD/FlowCategorization/Level/1/</xsl:text>
				<xsl:call-template name="url-encode">
				  <xsl:with-param name="str" select="../common:category[@level='1']/text()" />
				</xsl:call-template>
			</skos:narrower>
		</xsl:if>

		<xsl:if test="./@level = '1'">
			<skos:narrower>
				<xsl:text>http://lca.jrc.it/ILCD/FlowCategorization/Level/0/</xsl:text>
				<xsl:call-template name="url-encode">
				  <xsl:with-param name="str" select="../common:category[@level='0']/text()" />
				</xsl:call-template>
			</skos:narrower>
			<skos:broader>
				<xsl:text>http://lca.jrc.it/ILCD/FlowCategorization/Level/2/</xsl:text>
				<xsl:call-template name="url-encode">
				  <xsl:with-param name="str" select="../common:category[@level='2']/text()" />
				</xsl:call-template>
			</skos:broader>
		</xsl:if>

		<xsl:if test="./@level = '2'">
			<skos:broader>
				<xsl:text>http://lca.jrc.it/ILCD/FlowCategorization/Level/1/</xsl:text>
				<xsl:call-template name="url-encode">
				  <xsl:with-param name="str" select="../common:category[@level='1']/text()" />
				</xsl:call-template>
			</skos:broader>
		</xsl:if>
   	  </rdf:Description>
	</xsl:template>

	<xsl:template match="common:synonyms/text()" name="tokenize">
		<xsl:param name="text" select="."/>
		<xsl:param name="separator" select="';'"/>
		<xsl:choose>
		    <xsl:when test="not(contains($text, $separator))">
		        <commonRDF:synonym>
		            <xsl:value-of select="normalize-space($text)"/>
		        </commonRDF:synonym>
		    </xsl:when>
		    <xsl:otherwise>
		        <commonRDF:synonym>
		            <xsl:value-of select="normalize-space(substring-before($text, $separator))"/>
		        </commonRDF:synonym>
		        <xsl:call-template name="tokenize">
		            <xsl:with-param name="text" select="substring-after($text, $separator)"/>
		        </xsl:call-template>
		    </xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
