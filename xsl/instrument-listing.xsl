<xsl:stylesheet
xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:instrument="http://jason.fox/xslt/instrument/"
exclude-result-prefixes="xs instrument"
version="2.0">
  <!-- Defining that this .xsl generates plain text file -->
	<xsl:output indent="yes" method="xml" omit-xml-declaration="yes"/>

   <xsl:param as="xs:string" name="SOURCE"/>
  <xsl:variable name="SOURCEPATH" select="replace($SOURCE, '\\', '/')"/>
  <xsl:variable name="document-uri">
    <xsl:value-of select="replace(replace(replace(document-uri(/), $SOURCEPATH, ''), '.orig',''), 'file:/', '')"/>
  </xsl:variable>
  

  <xsl:template match="xsl:stylesheet">
    <xsl:element name="testsuite">
      <xsl:apply-templates select="xsl:template"/>
    </xsl:element>
  </xsl:template>
 
  <xsl:function name="instrument:compute" as="xs:string">
    <xsl:param name="node" as="element()"/>
    <xsl:param name="type" as="xs:string"/>
    <xsl:variable name="instumentation">
      <xsl:value-of select="concat(generate-id($node), ':', $document-uri, '/')"/>
      <xsl:value-of select="$type"/>
      <xsl:if test="$node/@match">
        <xsl:text> match=&quot;</xsl:text>
        <xsl:value-of select="$node/@match"/>
        <xsl:text>&quot;</xsl:text>
      </xsl:if>
      <xsl:if test="$node/@mode">
        <xsl:text> mode=&quot;</xsl:text>
        <xsl:value-of select="$node/@mode"/>
        <xsl:text>&quot;</xsl:text>
      </xsl:if>
       <xsl:if test="$node/@name">
        <xsl:text> name=&quot;</xsl:text>
        <xsl:value-of select="$node/@name"/>
        <xsl:text>&quot;</xsl:text>
      </xsl:if>
      <xsl:if test="$node/@test">
        <xsl:text> test=&quot;</xsl:text>
        <xsl:value-of select="$node/@test"/>
        <xsl:text>&quot;</xsl:text>
      </xsl:if>
     </xsl:variable>
      <xsl:value-of select="$instumentation"/>
  </xsl:function>

  <xsl:template match="xsl:template">
    <xsl:if test="not(comment()[contains(., 'ignore-instrument')]) and not(ancestor::*/comment()[contains(., 'ignore-instrument')])">
      <xsl:element name="text">
        <xsl:attribute name="id">
          <xsl:value-of select="concat('template-', generate-id(.))"/>
        </xsl:attribute>
        <xsl:value-of select="instrument:compute(., 'template')"/>
      </xsl:element>
      <xsl:apply-templates select=".//[xsl:if|xsl:when|xsl:otherwise]" mode="template"/>
    </xsl:if>
  </xsl:template>

   <xsl:template match="xsl:if" mode="template">
    <xsl:element name="text">
      <xsl:attribute name="id">
        <xsl:value-of select="concat('if-', generate-id(.))"/>
      </xsl:attribute>
      <xsl:value-of select="instrument:compute(., 'if')"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="xsl:when" mode="template">
    <xsl:element name="text">
      <xsl:attribute name="id">
        <xsl:value-of select="concat('when-', generate-id(.))"/>
      </xsl:attribute>
      <xsl:value-of select="instrument:compute(., 'when')"/>
    </xsl:element>
  </xsl:template>

   <xsl:template match="xsl:otherwise" mode="template">
    <xsl:variable name="id" select="concat($document-uri, '/', @test )"/>
    <xsl:element name="text">
      <xsl:attribute name="id">
        <xsl:value-of select="concat('otherwise-', generate-id(.))"/>
      </xsl:attribute>
      <xsl:value-of select="instrument:compute(., 'otherwise')"/>
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>