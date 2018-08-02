<xsl:stylesheet
xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
exclude-result-prefixes="xs"
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


 <xsl:template match="xsl:template|xsl:function">
    <xsl:element name="{name()}">
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates select="xsl:param"/>
      <xsl:element name="xsl:message">
        <xsl:value-of select="concat(count(preceding::node()[not(self::xsl:message)]),':', $document-uri)"/>
      </xsl:element>
      <xsl:apply-templates select="node()[not(self::xsl:param)]"/>
    </xsl:element>
  </xsl:template>


   <xsl:template match="xsl:choose|xsl:for-each">
    <xsl:element name="xsl:message">
      <xsl:value-of select="concat(count(preceding::node()[not(self::xsl:message)]),':', $document-uri)"/>
    </xsl:element>
    <xsl:element name="{name()}">
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="xsl:when|xsl:otherwise|xsl:if">
    <xsl:element name="{name()}">
      <xsl:apply-templates select="@*"/>
      <xsl:element name="xsl:message">
        <xsl:value-of select="concat(count(preceding::node()[not(self::xsl:message)]),':', $document-uri)"/>
      </xsl:element>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>