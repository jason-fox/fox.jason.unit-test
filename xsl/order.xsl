<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="2.0"
   
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   exclude-result-prefixes="xsl"
    
   >
    
 
    <xsl:template match="/">
        <svrl:schematron-output 
            xmlns:saxon="http://saxon.sf.net/"
            xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
            xmlns:xhtml="http://www.w3.org/1999/xhtml">
            
            <xsl:apply-templates select="//failed-assert">
                <xsl:sort select="@location"/>
                <xsl:sort select="@role"/>
            </xsl:apply-templates>
        </svrl:schematron-output>
    </xsl:template>
    <xsl:template match="*">
        <xsl:copy-of select="."/>
         
        <xsl:text>&#xA;</xsl:text>
    </xsl:template>
    
</xsl:stylesheet>


