<xsl:stylesheet
xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:instrument="http://jason.fox/xslt/instrument/" xmlns:saxon="http://saxon.sf.net/"
exclude-result-prefixes="xs instrument saxon"
version="2.0">
  <!-- Defining that this .xsl generates plain text file -->
	<xsl:output indent="yes" method="xml" omit-xml-declaration="yes" cdata-section-elements="text" />

   <xsl:param as="xs:string" name="SOURCE"/>
  <xsl:variable name="SOURCEPATH" select="replace($SOURCE, '\\', '/')"/>
  <xsl:variable name="document-uri">
    <xsl:value-of select="replace(replace(replace(document-uri(/), $SOURCEPATH, ''), '.orig',''), 'file:/', '')"/>
  </xsl:variable>
  

  <xsl:template match="xsl:stylesheet">
    <xsl:element name="lines">
      <xsl:apply-templates select="xsl:template"/>
    </xsl:element>
  </xsl:template>

   <xsl:template name="addElement">
    <xsl:param name="open" />
    <xsl:element name="line">
      <xsl:attribute name="id">
        <xsl:value-of select="concat(generate-id(.), ':', $document-uri)"/>
      </xsl:attribute>
      <xsl:attribute name="element">
        <xsl:value-of select="name()"/>
      </xsl:attribute>
      <xsl:choose>
        <xsl:when test="$open">
          <xsl:attribute name="open">
            <xsl:value-of select="true()"/>
          </xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="close">
            <xsl:value-of select="true()"/>
          </xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:attribute name="indent">
        <xsl:value-of select="count(ancestor::xsl:*)"/>
      </xsl:attribute>
      <xsl:attribute name="branch">
        <xsl:value-of select="false()"/>
      </xsl:attribute>
    
      <xsl:if test="$open">
        <xsl:attribute name="attributes">
          <xsl:value-of select="normalize-space(instrument:compute(.))"/>
        </xsl:attribute> 
        <xsl:attribute name="number">
          <xsl:value-of select="saxon:line-number()"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:value-of select="concat(generate-id(.), ':', $document-uri)"/>
    </xsl:element>
   </xsl:template>

 
  <xsl:function name="instrument:compute" as="xs:string">
    <xsl:param name="node" as="element()"/>
    <xsl:variable name="instumentation">
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
      <xsl:if test="$node/@select">
        <xsl:text> select=&quot;</xsl:text>
        <xsl:value-of select="$node/@select"/>
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
      <xsl:call-template name="addElement">
        <xsl:with-param name="open" select="true()" />
      </xsl:call-template>
      <xsl:apply-templates mode="template"/>
      <xsl:call-template name="addElement">
        <xsl:with-param name="open" select="false()" />
    </xsl:call-template>
    </xsl:if>
  </xsl:template>

 

  <xsl:template match="xsl:if" mode="template">
    <xsl:call-template name="addElement">
      <xsl:with-param name="open" select="true()" />
    </xsl:call-template>
    <xsl:apply-templates  mode="template"/>
    <xsl:call-template name="addElement">
      <xsl:with-param name="open" select="false()" />
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="xsl:choose|xsl:for-each" mode="template">
    <xsl:call-template name="addElement">
      <xsl:with-param name="open" select="true()" />
    </xsl:call-template>
    <xsl:apply-templates  mode="template"/>
    <xsl:call-template name="addElement">
      <xsl:with-param name="open" select="false()" />
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="xsl:when" mode="template">
    <xsl:call-template name="addElement">
      <xsl:with-param name="open" select="true()" />
    </xsl:call-template>
    <xsl:apply-templates  mode="template"/>
    <xsl:call-template name="addElement">
      <xsl:with-param name="open" select="false()" />
    </xsl:call-template>
  </xsl:template>

   <xsl:template match="xsl:otherwise" mode="template">
    <xsl:call-template name="addElement">
      <xsl:with-param name="open" select="true()" />
    </xsl:call-template>
    <xsl:apply-templates  mode="template"/>
    <xsl:call-template name="addElement">
      <xsl:with-param name="open" select="false()" />
    </xsl:call-template>
  </xsl:template>

   <xsl:template match="*" mode="template">
    <xsl:apply-templates  mode="template"/>
   </xsl:template>
    <xsl:template match="text()" mode="template"/>

</xsl:stylesheet>