<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="2.0"
 >
    <xsl:template match="/">
        <xsl:text>&#xA;&#x9;</xsl:text>
        <xsl:copy-of select="//main[last()]" /> 
        <xsl:text>&#xA;</xsl:text>
    </xsl:template>
</xsl:stylesheet>