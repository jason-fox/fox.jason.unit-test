<xsl:stylesheet
xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:instrument="http://jason.fox/xslt/instrument/"
exclude-result-prefixes="xs instrument"
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
    <xsl:element name="{name()}">
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates select="xsl:param"/>
      <xsl:element name="xsl:if">
       <xsl:attribute name="test">
          <xsl:text>. instance of element()</xsl:text>
        </xsl:attribute>
        <xsl:text>&#xA;</xsl:text>
        <xsl:element name="xsl:comment">
          <xsl:value-of select="instrument:compute(., 'template')"/>
        </xsl:element>
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
        <xsl:text>&#xA;</xsl:text>
        <xsl:element name="xsl:comment">
          <xsl:value-of select="instrument:compute(., 'if')"/>
        </xsl:element>
      </xsl:element>
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
        <xsl:text>&#xA;</xsl:text>
        <xsl:element name="xsl:comment">
          <xsl:value-of select="instrument:compute(., 'when')"/>
        </xsl:element>
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
        <xsl:text>&#xA;</xsl:text>
        <xsl:element name="xsl:comment">
          <xsl:value-of select="instrument:compute(., 'otherwise')"/>
        </xsl:element>
      </xsl:element>
      <xsl:apply-templates mode="template"/>
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>