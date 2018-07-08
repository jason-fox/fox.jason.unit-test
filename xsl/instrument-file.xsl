<xsl:stylesheet
xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
version="2.0">

  <xsl:param as="xs:string" name="SOURCE"/>
  <xsl:variable name="SOURCEPATH" select="replace($SOURCE, '\\', '/')"/>
  <xsl:variable name="document-uri">
    <xsl:value-of select="replace(replace(replace(document-uri(/), $SOURCEPATH, ''), '.orig',''), 'file:/', '')"/>
  </xsl:variable>

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

 <xsl:template match="xsl:template">
    <xsl:element name="{name()}">
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates select="xsl:param"/>
      <xsl:if test="not(contains(@match, '@*'))">
        <xsl:text>&#xA;</xsl:text>
        <xsl:element name="xsl:comment">
          <xsl:value-of select="concat($document-uri, '/', @name, '/' , @mode, '/' , @match )"/>
        </xsl:element>
        <xsl:text>&#xA;</xsl:text>
      </xsl:if>
      <xsl:apply-templates select="node()[not(self::xsl:param)]"/>
    </xsl:element>
  </xsl:template>

  <!--xsl:template match="xsl:if">
    <xsl:element name="{name()}">
      <xsl:apply-templates select="@*"/>
        <xsl:text>&#xA;</xsl:text>
        <xsl:element name="xsl:comment">
          <xsl:value-of select="concat(ancestor::xsl:template[1]/@name , '-', ancestor::xsl:template[1]/@mode , '-', ancestor::xsl:template[1]/@match , '-', @test)"/>
        </xsl:element>
        <xsl:text>&#xA;</xsl:text>
      <xsl:apply-templates select="node()"/>
    </xsl:element>
  </xsl:template-->
</xsl:stylesheet>