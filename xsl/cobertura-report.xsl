<?xml version="1.0" encoding="utf-8"?>
<!--
  This file is part of the DITA-OT Unit Test Plug-in project.
  See the accompanying LICENSE file for applicable licenses.
-->
<xsl:stylesheet
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version="2.0"
>
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="line[not(@number)]"/>
  <xsl:template match="line[not(@hits)]"/>
</xsl:stylesheet>
