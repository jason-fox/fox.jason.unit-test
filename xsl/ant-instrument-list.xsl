<xsl:stylesheet
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:saxon="http://saxon.sf.net/"
  exclude-result-prefixes="xs saxon"
  version="2.0"
>
  <!-- Defining that this .xsl generates plain text file -->
	<xsl:output indent="yes" method="xml" omit-xml-declaration="yes" cdata-section-elements="text"/>

   <xsl:param as="xs:string" name="SOURCE"/>
  <xsl:variable name="SOURCEPATH" select="replace($SOURCE, '\\', '/')"/>
  <xsl:variable name="document-uri">
    <xsl:value-of select="replace(replace(replace(document-uri(/), $SOURCEPATH, ''), '.orig',''), 'file:/', '')"/>
  </xsl:variable>
  

  <xsl:template match="project">
    <xsl:element name="lines">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

   <xsl:template name="addElement">
    <xsl:param name="open" select="true()"/>
    <xsl:param name="instrument" select="true()"/>
    <xsl:element name="line">
      <xsl:attribute name="id">
        <xsl:choose>
          <xsl:when test="$instrument">
            <xsl:value-of select="concat(generate-id(.), ':', $document-uri)"/>
          </xsl:when>
          <xsl:when test="name(..) = 'if'">
            <xsl:value-of select="concat(generate-id(ancestor::if[1]), ':', $document-uri)"/>
          </xsl:when>
           <xsl:when test="name(..) = 'for'">
            <xsl:value-of select="concat(generate-id(ancestor::for[1]), ':', $document-uri)"/>
          </xsl:when>
          <xsl:when test="ancestor::if">
            <xsl:value-of select="concat(generate-id(ancestor::if[1]), ':', $document-uri)"/>
          </xsl:when>
          <xsl:when test="ancestor::for">
            <xsl:value-of select="concat(generate-id(ancestor::for-each[1]), ':', $document-uri)"/>
          </xsl:when>
          <xsl:when test="ancestor::macrodef">
            <xsl:value-of select="concat(generate-id(ancestor::macrodef[1]), ':', $document-uri)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="concat(generate-id(ancestor::target), ':', $document-uri)"/>
          </xsl:otherwise>
        </xsl:choose>
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
        <xsl:value-of select="count(ancestor::*)"/>
      </xsl:attribute>
      <xsl:attribute name="branch">
        <xsl:value-of select="false()"/>
      </xsl:attribute>
    
      <xsl:if test="$open">
        <xsl:variable name="attributes">
          <xsl:for-each select="@*">
             <xsl:text> </xsl:text>
             <xsl:value-of select="name()"/>
             <xsl:text>=&quot;</xsl:text>
             <xsl:value-of select="."/>
             <xsl:text>&quot;</xsl:text>
          </xsl:for-each>
        </xsl:variable>
        <xsl:attribute name="attributes">
          <xsl:value-of select="normalize-space($attributes)"/>
        </xsl:attribute> 
        <xsl:attribute name="number">
          <xsl:value-of select="saxon:line-number()"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="$instrument">
        <xsl:value-of select="@name"/>
        <xsl:text>:</xsl:text>
      </xsl:if>
    </xsl:element>
   </xsl:template>



  <xsl:template match="target|macrodef">
    <xsl:if
      test="not(comment()[contains(., 'ignore-instrument')]) and not(ancestor::*/comment()[contains(., 'ignore-instrument')])"
    >
      <xsl:call-template name="addElement"/>
      <xsl:apply-templates mode="target"/>
      <xsl:call-template name="addElement">
        <xsl:with-param name="open" select="false()"/>
    </xsl:call-template>
    </xsl:if>
  </xsl:template>

 

   <xsl:template match="*" mode="target">
    <xsl:call-template name="addElement">
      <xsl:with-param name="instrument" select="false()"/>
    </xsl:call-template>
    <xsl:apply-templates mode="target"/>
    <xsl:call-template name="addElement">
      <xsl:with-param name="open" select="false()"/>
      <xsl:with-param name="instrument" select="false()"/>
    </xsl:call-template>
   </xsl:template>
  

  <xsl:template match="text()"/>

</xsl:stylesheet>
