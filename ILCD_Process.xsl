<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
	xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
	xmlns:common="http://lca.jrc.it/ILCD/Common" 
	xmlns:process="http://lca.jrc.it/ILCD/Process"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:commonRDF="http://lca.jrc.it/ILCD/Common/" 
	xmlns:processRDF="http://lca.jrc.it/ILCD/Process/"
	xmlns:flowRDF="http://lca.jrc.it/ILCD/Flow/"

	version="1.0">
	<xsl:output method="xml" encoding="UTF-8" indent="yes"/>
 
       <!-- Begin RDF document -->
       <xsl:template match="/">
              <xsl:element name="rdf:RDF">
                    <xsl:apply-templates select="//process:processDataSet"/>
	            <xsl:apply-templates select="//process:exchange"/>
              </xsl:element>
	</xsl:template>

	<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" match="process:processDataSet">
	  <rdf:Description xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
		<xsl:attribute name="rdf:about">
			<xsl:text>http://lca.jrc.it/ILCD/Process/</xsl:text>
			<xsl:value-of select="//common:UUID"/>
		</xsl:attribute>
		<rdfs:label><xsl:value-of select="//process:baseName"/></rdfs:label>

		<!-- for every process exchange, create a new object of rdf:type process:exchange -->

		<xsl:for-each select="//process:exchange">
			<xsl:variable name="exchangeURL">
				<xsl:text>http://lca.jrc.it/ILCD/Process/</xsl:text>
				<xsl:value-of select="//common:UUID"/>
				<xsl:text>/Exchange/</xsl:text>
				<xsl:value-of select="@dataSetInternalID"/>
			</xsl:variable>

			<processRDF:exchange>
				<xsl:attribute name="rdf:resource">
					<xsl:value-of select="$exchangeURL" />
				</xsl:attribute>
			</processRDF:exchange>

		</xsl:for-each>			

		<!-- set the rdf:type -->
		<rdf:type rdf:resource="http://lca.jrc.it/ILCD/Process"/>

   	  </rdf:Description>
	</xsl:template>

	<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" match="process:exchange">
   	  <rdf:Description>
		<xsl:variable name="exchangeURL">
			<xsl:text>http://lca.jrc.it/ILCD/Process/</xsl:text>
			<xsl:value-of select="//common:UUID"/>
			<xsl:text>/Exchange/</xsl:text>
			<xsl:value-of select="@dataSetInternalID"/>
		</xsl:variable>

		<xsl:attribute name="rdf:about">
			<xsl:value-of select="$exchangeURL"/>
		</xsl:attribute>

		<processRDF:exchangeDirection><xsl:value-of select="./process:exchangeDirection"/></processRDF:exchangeDirection>
		<processRDF:resultingAmount>
			<xsl:value-of select="./process:resultingAmount"/>
			<xsl:text>^^xsd:double</xsl:text>
		</processRDF:resultingAmount>
		<processRDF:meanAmount>
			<xsl:value-of select="./process:meanAmount"/>
			<xsl:text>^^xsd:double</xsl:text>
		</processRDF:meanAmount>

		<processRDF:referenceToFlowDataSet>
			<xsl:attribute name="rdf:resource">
				<xsl:text>http://lca.jrc.it/ILCD/Flow/</xsl:text>
				<xsl:value-of select="./process:referenceToFlowDataSet/@refObjectId"/>
			</xsl:attribute>
		</processRDF:referenceToFlowDataSet>

   	  </rdf:Description>
	</xsl:template>
</xsl:stylesheet>
