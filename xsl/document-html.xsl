<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="/">
        <xsl:text>&#xA;&#x9;</xsl:text>
        <xsl:copy-of select="//main[last()]" /> 
        <xsl:text>&#xA;</xsl:text>
    </xsl:template>
</xsl:stylesheet>