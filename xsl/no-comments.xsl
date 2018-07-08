<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
        xmlns:lxslt="http://xml.apache.org/xslt">
  <xsl:output omit-xml-declaration="yes" indent="yes"/>
  <xsl:template match="element()|text()|@*" name="identity">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
   </xsl:template>
   <xsl:template match="comment()" name="strip-comments"/>
</xsl:stylesheet>