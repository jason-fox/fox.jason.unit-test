<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
        xmlns:lxslt="http://xml.apache.org/xslt">
<xsl:output method="html" indent="yes" encoding="UTF-8"
  doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN" />

<xsl:template match="/">
<html>
    <head>
    <title>Coverage Results</title>
    <style type="text/css">
      body {
        font:normal 68% verdana,arial,helvetica;
        color:#000000;
      }

     

      table tr td, table tr th {
          font-size: 68%;
      }
      table.details tr th{
        font-weight: bold;
        text-align:left;
        background:#a6caf0;
      }
      table.details tr td{
        background:#eeeee0;
      }
      table.details td.Success {
        background: lightgreen;
      }
      table.details td.Failure {
         background: lightcoral; color: whitesmoke;
      }

      p {
        line-height:1.5em;
        margin-top:0.5em; margin-bottom:1.0em;
      }
      h1 {
        margin: 0px 0px 5px; font: 165% verdana,arial,helvetica
      }
      h2 {
        margin-top: 1em; margin-bottom: 0.5em; font: bold 125% verdana,arial,helvetica
      }
      h3 {
        margin-bottom: 0.5em; font: bold 115% verdana,arial,helvetica
      }
      h4 {
        margin-bottom: 0.5em; font: bold 100% verdana,arial,helvetica
      }
      h5 {
        margin-bottom: 0.5em; font: bold 100% verdana,arial,helvetica
      }
      h6 {
        margin-bottom: 0.5em; font: bold 100% verdana,arial,helvetica
      }
      .Error {
        font-weight:bold; color:red;
      }
      .Success {
        font-weight:bold; color:green;
      }
      .Failure {
        font-weight:bold; color:purple;
      }
      .Properties {
        text-align:right;
      }
      
      </style>
    </head>
  <body>

    <!-- Summary part -->
    <xsl:call-template name="summary"/>
    <hr size="1" width="95%" align="left"/>
    <!-- Details part -->
   <xsl:call-template name="test-suites"/>
    <hr size="1" width="95%" align="left"/>
  </body>
</html>
</xsl:template>




<xsl:template name="display-percent">
    <xsl:param name="value"/>
    <xsl:value-of select="format-number($value,'0.00%')"/>
</xsl:template>

<xsl:template name="testsuite.coverage.header">
      <tr valign="top">
      <th style="text-align:left">Title</th>
      <th width="30%" ></th>
      <th width="5em" >Tokens</th>
      <th width="5em">Covered</th>
      <th width="5em">Percent</th>
    </tr>
</xsl:template>




<xsl:template name="summary">
  <h2>Summary</h2>
  <table class="details" border="0" cellpadding="5" cellspacing="2" width="95%">
     <xsl:call-template name="testsuite.coverage.header"/>
    <xsl:for-each select="testsuites/testsuite">



    <tr>
      <xsl:choose>
        <xsl:when test="@percent &gt; 0.9"><xsl:attribute name="class">Success</xsl:attribute></xsl:when>
        <xsl:when test="@percent &gt; 0.7"/>
        <xsl:otherwise><xsl:attribute name="class">Error</xsl:attribute></xsl:otherwise>
      </xsl:choose>
      <td><xsl:value-of select="@id"/></td>
      <td>
         <div>
            <xsl:attribute name="style">background-color:coral;width:100%</xsl:attribute>
            <div>
               <xsl:attribute name="style">background-color:lightgreen;width:<xsl:value-of select="format-number(@percent,'0.00%')"/></xsl:attribute>
               &#160;
             </div>
        </div> 
      </td>
      <td><xsl:value-of select="@tokens"/></td>
      <td><xsl:value-of select="@covered"/></td>
      <td>
         <xsl:call-template name="display-percent">
            <xsl:with-param name="value" select="@percent"/>
        </xsl:call-template>
      </td>
    </tr>
    </xsl:for-each>
  </table>
</xsl:template>





<xsl:template name="test-suites">
  <h2>Test suites</h2>
  <xsl:for-each select="testsuites/testsuite">
    <h3><xsl:value-of select="@id"/></h3>

    <table class="details" border="0" cellpadding="5" cellspacing="2" width="95%">
      <tr valign="top">
        <th width="20%">id</th>
        <th style="text-align:left">Token</th>
        <th width="5em">Count</th>
      </tr>
      <xsl:for-each select="*">
        <tr>
          <xsl:choose>
            <xsl:when test="@count=0"><xsl:attribute name="class">Error</xsl:attribute></xsl:when>
            <xsl:otherwise><xsl:attribute name="class">Success</xsl:attribute></xsl:otherwise>
          </xsl:choose>
          <td><xsl:value-of select="@id"/></td>
          <td>
            <pre><code><xsl:value-of select="."/></code></pre>
          </td>
          <td>
            <xsl:value-of select="@count"/>
          </td>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:for-each>
</xsl:template>

</xsl:stylesheet>

