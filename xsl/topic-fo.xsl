<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet
  version="2.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:__NS1="http://www.w3.org/2000/xmlns"
  exclude-result-prefixes="xsl fo __NS1"
>
    <xsl:template match="/fo:root">
        <xsl:text>&#xA;&#x9;</xsl:text>
        <xsl:copy-of select="(//fo:flow)[last()]"/>
        <xsl:text>&#xA;</xsl:text>
    </xsl:template>
    
</xsl:stylesheet>
