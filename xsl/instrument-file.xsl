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

  <xsl:template match="@*|node()" mode="template">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" mode="template"/>
    </xsl:copy>
  </xsl:template>

 <xsl:template match="xsl:template">
    <xsl:element name="{name()}">
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates select="xsl:param"/>
      <xsl:element name="xsl:if">
       <xsl:attribute name="test">
          <xsl:text>. instance of element()</xsl:text>
        </xsl:attribute>
        <xsl:element name="xsl:comment">
          <xsl:value-of select="concat(generate-id(.), ':', $document-uri)"/>
        </xsl:element>
        <xsl:element name="xsl:text" xml:space="preserve">&#xA;</xsl:element>
      </xsl:element>
      <xsl:apply-templates select="node()[not(self::xsl:param)]" mode="template"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="xsl:if" mode="template">
    <xsl:element name="{name()}">
      <xsl:apply-templates select="@*"/>
      <xsl:element name="xsl:if">
       <xsl:attribute name="test">
          <xsl:text>. instance of element()</xsl:text>
        </xsl:attribute>
        <xsl:element name="xsl:comment">
          <xsl:value-of select="concat(generate-id(.), ':', $document-uri)"/>
        </xsl:element>
      </xsl:element>
      <xsl:apply-templates mode="template"/>
    </xsl:element>
  </xsl:template>

   <xsl:template match="xsl:choose|xsl:for-each" mode="template">
    <xsl:if test="not(ancestor::xsl:variable)">
    <xsl:element name="xsl:if">
     <xsl:attribute name="test">
        <xsl:text>. instance of element()</xsl:text>
      </xsl:attribute>
      <xsl:text>&#xA;</xsl:text>
      <xsl:element name="xsl:comment">
        <xsl:value-of select="concat(generate-id(.), ':', $document-uri)"/>
      </xsl:element>
      <xsl:element name="xsl:text" xml:space="preserve">&#xA;</xsl:element>
    </xsl:element>
    </xsl:if>
    <xsl:element name="{name()}">
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates mode="template"/>
    </xsl:element>
   
  </xsl:template>

  <xsl:template match="xsl:when" mode="template">
    <xsl:element name="{name()}">
      <xsl:apply-templates select="@*"/>
      <xsl:element name="xsl:if">
       <xsl:attribute name="test">
          <xsl:text>. instance of element()</xsl:text>
        </xsl:attribute>
        <xsl:element name="xsl:comment">
          <xsl:value-of select="concat(generate-id(.), ':', $document-uri)"/>
        </xsl:element>
        <xsl:element name="xsl:text" xml:space="preserve">&#xA;</xsl:element>
      </xsl:element>
      <xsl:apply-templates mode="template"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="xsl:otherwise" mode="template">
    <xsl:element name="{name()}">
      <xsl:apply-templates select="@*"/>
      <xsl:element name="xsl:if">
       <xsl:attribute name="test">
          <xsl:text>. instance of element()</xsl:text>
        </xsl:attribute>
        <xsl:element name="xsl:comment">
          <xsl:value-of select="concat(generate-id(.), ':', $document-uri)"/>
        </xsl:element>
        <xsl:element name="xsl:text" xml:space="preserve">&#xA;</xsl:element>
      </xsl:element>
      <xsl:apply-templates mode="template"/>
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>