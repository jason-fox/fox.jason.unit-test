<xsl:stylesheet
xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
version="2.0">
  <!-- Defining that this .xsl generates plain text file -->
	<xsl:output indent="yes" method="xml" omit-xml-declaration="yes"/>

   <xsl:param as="xs:string" name="SOURCE"/>
  <xsl:variable name="SOURCEPATH" select="replace($SOURCE, '\\', '/')"/>
  <xsl:variable name="document-uri">
    <xsl:value-of select="replace(replace(replace(document-uri(/), $SOURCEPATH, ''), '.orig',''), 'file:/', '')"/>
  </xsl:variable>
  

  <xsl:template match="/">
    <xsl:element name="testsuite">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="@*|node()">
      <xsl:apply-templates select="@*|node()"/>
  </xsl:template>

  <xsl:template match="xsl:template">
    <xsl:variable name="name" select="concat($document-uri, '-', @name, '-' , @mode, '-' , @match )"/>
    <xsl:if test="not(contains(@match, '@'))">
      <xsl:element name="text">
        <xsl:attribute name="id">
          <xsl:value-of select="concat('template-', replace($name, '[^a-zA-Z0-9\-]', ''))"/>
        </xsl:attribute>
       <xsl:value-of select="$name"/>
      </xsl:element>
    </xsl:if>
    <xsl:apply-templates select="node()"/>
  </xsl:template>

  <!--xsl:template match="xsl:if">
          
    <xsl:variable name="name" select="concat(ancestor::xsl:template[1]/@name , '-', ancestor::xsl:template[1]/@mode , '-', ancestor::xsl:template[1]/@match , '-', @test)"/>
    <xsl:element name="text">
      <xsl:attribute name="id">
        <xsl:value-of select="concat('i-',replace($name, '[^a-zA-Z0-9\-]', ''))"/>
      </xsl:attribute>
     <xsl:value-of select="$name"/>
    </xsl:element>
      <xsl:apply-templates select="node()"/>
  </xsl:template-->
</xsl:stylesheet>