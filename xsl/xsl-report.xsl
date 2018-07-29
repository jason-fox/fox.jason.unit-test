<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" 
  xmlns:instrument="http://jason.fox/xslt/instrument/"

        xmlns:lxslt="http://xml.apache.org/xslt">
<xsl:output method="html" indent="yes" encoding="UTF-8"
  doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN" />


<xsl:function name="instrument:getType" as="xs:string">
  <xsl:param name="node" as="element()?"/>
  <xsl:variable name="text" select="substring-after($node, '.xsl/')"/>
  <xsl:variable name="before" select="substring-before($text,' ')"/>
  <xsl:value-of select="if ($before = '') then $text else $before"/>
</xsl:function>


<xsl:template match="/">
<html>
    <head>
    <title>Template Coverage Results</title>
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
        font-size: small;
      }
      table.details td.Success {
        background: lightgreen;
      }

      table.details th {
       border-top: 2px white solid;
       border-left: 2px white solid;
       padding: 2px;
       margin:2px;
      }

      table.details tr td{
       border-top: 2px white solid;
       border-left: 2px white solid;
       padding-top: 2px;
       padding-left: 5px;
      }
      table.details tr.Merge td {
        border-top: 0px;
         padding-top:0px;
        padding-bottom:0px;
        
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
      .None {
        font-weight:bold; color:#000000;
      }

      pre {
         white-space: pre-wrap;       /* css-3 */
         white-space: -moz-pre-wrap;  /* Mozilla, since 1999 */
         white-space: -pre-wrap;      /* Opera 4-6 */
         white-space: -o-pre-wrap;    /* Opera 7 */
         word-wrap: break-word;       /* Internet Explorer 5.5+ */
      }
      pre code {padding-left: 2em; font-size : medium; line-height: 1em}

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
      <th width="5em">Templates</th>
      <th width="5em">Covered</th>
      <th width="5em">Percent</th>
    </tr>
</xsl:template>




<xsl:template name="summary">
  <h2>Summary</h2>
  <table class="details" border="0" cellpadding="5" cellspacing="2" width="95%">
     <xsl:call-template name="testsuite.coverage.header"/>
    <xsl:for-each select="//package">



    <tr>
      <xsl:choose>
        <xsl:when test="@percent &gt; 0.9"><xsl:attribute name="class">Success</xsl:attribute></xsl:when>
        <xsl:when test="@percent &gt; 0.7"/>
        <xsl:otherwise><xsl:attribute name="class">Error</xsl:attribute></xsl:otherwise>
      </xsl:choose>
      <td><xsl:value-of select="@name"/></td>
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
  <xsl:for-each select="//package">
    <h3><xsl:value-of select="@name"/></h3>

    <table class="details" border="0" cellpadding="0" cellspacing="0" width="95%">
      <tr valign="top">
        <th width="20%">id</th>
        <th style="text-align:left">Templates</th>
        <th width="5em">Hits</th>
      </tr>
      <xsl:for-each select="classes/class/lines/line">
         



        <xsl:variable name="token" select="."/>
          <xsl:variable name="xslfile" select="substring-after(@id,':')"/>
          <xsl:variable name="previousfile" select="substring-after(preceding-sibling::*[1]/@id,':')"/>

          <xsl:variable name="current" select="@element"/>
          <xsl:variable name="attributes" select="normalize-space(@attributes)"/>
          <xsl:variable name="previous" select="preceding-sibling::*[1]/@element"/>
          <xsl:variable name="next" select="following-sibling::*[1]/@element"/>

          <xsl:variable name="selfClosing" select="($current = $next) and @open and following-sibling::*[1]/@close"/>
          <xsl:variable name="selfClosed" select="($current = $previous) and @close and preceding-sibling::*[1]/@open"/>


        <xsl:if test="not($selfClosed)">
          <tr>
            <xsl:attribute name="class">
              <xsl:if test="@hits = 0">Error </xsl:if>
              <xsl:if test="not(@hits = 0)">Success </xsl:if>
              <xsl:if test="$xslfile = $previousfile">Merge </xsl:if>
            </xsl:attribute>
            <td>
              <xsl:attribute name="class">None</xsl:attribute>
              <xsl:if test="not($xslfile = $previousfile)">
                <xsl:value-of select="$xslfile"/>
              </xsl:if>
            </td>
            <td>
              <pre>
                <code>
                  <xsl:attribute name="class">
                     <xsl:value-of select="replace(substring-before(substring-after($token, '.xsl/'),' '),'/','')"/>

                  </xsl:attribute>
                  <xsl:value-of select="substring('                ', 0, @indent)"/>
                  <xsl:value-of select="substring('                ', 0, @indent)"/>
                  <xsl:text>&lt;</xsl:text>
                  <xsl:if test="@close">
                    <xsl:text>/</xsl:text>
                  </xsl:if>
                  <xsl:value-of select="@element"/>
                  <xsl:if test="@open and not($attributes='')">
                    <xsl:text> </xsl:text>
                  </xsl:if>
                  <xsl:value-of select="$attributes"/>  
                  <xsl:if test="$selfClosing">
                    <xsl:text>/</xsl:text>
                  </xsl:if>
                  <xsl:text>&gt;</xsl:text>
                </code>
              </pre>  
            </td>
            <td>
              <xsl:if test="@open">
                <xsl:value-of select="@hits"/>
              </xsl:if>
            </td>
          </tr>
        </xsl:if>
      </xsl:for-each>
    </table>
  </xsl:for-each>
</xsl:template>

</xsl:stylesheet>

