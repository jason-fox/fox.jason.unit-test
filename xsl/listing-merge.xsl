<?xml version="1.0" ?>

<xsl:stylesheet version="2.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<!-- Defining that this .xsl generates an indented, UTF8-encoded XML file -->
	<xsl:output encoding="utf-8" indent="yes" method="xml" omit-xml-declaration="yes" cdata-section-elements="text"/>
	<xsl:param name="in">.</xsl:param>
	<xsl:param name="extension">xml</xsl:param>
	<xsl:param name="out">template-coverage.xml</xsl:param>
	<xsl:param as="xs:string" name="SOURCE"/>
	<!--
		XSLT engine only accept file path that start with 'file:/'

		In the code below we ensure that $in parameter that hold input path to
		where the *.xml files file which have to be merge into single .xml file
		is in a format
	-->
	<xsl:variable name="path">
		<xsl:choose>
			<xsl:when test="not(starts-with($in,'file:')) and not(starts-with($in,'/')) ">
				<xsl:value-of select="translate(concat('file:/', $in ,'?select=*.', $extension ,';recurse=yes;on-error=warning'), '\', '/')"/>
			</xsl:when>
			<xsl:when test="starts-with($in,'/')">
				<xsl:value-of select="translate(concat('file:', $in ,'?select=*.', $extension ,';recurse=yes;on-error=warning'), '\', '/')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="translate(concat($in ,'?select=*.', $extension ,';recurse=yes;on-error=warning'), '\', '/')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<!-- Template to once execute generate-template-coverage template -->
	<xsl:template match="/">
		<xsl:call-template name="generate-template-coverage"/>
	</xsl:template>
	<!--
		Template that generates the single .svrl file by copying contents
		of all .svrl files found in directory specified by $path
	-->
	<xsl:template name="generate-template-coverage">
		<xsl:element name="testsuite">
			 <xsl:attribute name="id">
			 	<xsl:value-of select="$SOURCE"/>
			 </xsl:attribute>
			
			<!-- xsl:copy-of select="@*" is the standard way of copying all attributes. -->
			<xsl:copy-of select="@*"/>
			<xsl:for-each select="collection($path)">
				<!-- xsl:copy-of copies nodes and all their descendants -->
				<xsl:apply-templates select="document(document-uri(.))/testsuite/node()" mode="identity"/>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>

	<xsl:template match="node()|@*" mode="identity">
		 <xsl:copy>
            <xsl:apply-templates select="node()|@*" mode="identity"/>
        </xsl:copy>
	</xsl:template>
</xsl:stylesheet>