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

      pre code {padding-left: 4em; font-size : medium; line-height: 0.8em}
      pre code.template {padding-left: 0px;}
      pre code.if {padding-left: 2em}

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

    <table class="details" border="0" cellpadding="0" cellspacing="0" width="95%">
      <tr valign="top">
        <th width="20%">id</th>
        <th style="text-align:left">Templates</th>
        <th width="5em">Count</th>
      </tr>
      <xsl:for-each select="*">
        <xsl:variable name="token" select="."/>
          <xsl:variable name="xslfile" select="substring-after(substring-before($token, '.xsl/'),':')"/>
          <xsl:variable name="previous" select="substring-after(substring-before(preceding-sibling::*[ 1], '.xsl/'),':')"/>

          <xsl:variable name="type" select="instrument:getType(.)"/>
          <xsl:variable name="previoustype" select="instrument:getType(preceding-sibling::*[1])"/>
          <xsl:variable name="nexttype" select="instrument:getType(following-sibling::*[ 1])"/>
        <tr>
          <xsl:attribute name="class">
            <xsl:if test="@count = 0">Error </xsl:if>
            <xsl:if test="not(@count = 0)">Success </xsl:if>
            <xsl:if test="$xslfile = $previous">Merge </xsl:if>
          </xsl:attribute>
          <td>
            <xsl:attribute name="class">None</xsl:attribute>
            <xsl:if test="not($xslfile = $previous)">
              <xsl:value-of select="$xslfile"/>
            </xsl:if>
          </td>
          <td>
            <xsl:if test="$type = 'when' or $type = 'otherwise'">
              <xsl:if test="not($previoustype = 'when') and not(substring-after(preceding-sibling::*[ 1], '.xsl/') = 'otherwise')">
                <xsl:variable name="count" select="preceding-sibling::*[contains(@id, 'template')][1]/@count"/>
                <pre>
                  <code>
                     <xsl:attribute name="class">
                      <xsl:if test="$count = 0">Error if</xsl:if>
                      <xsl:if test="not($count = 0)">Success if</xsl:if>
                    </xsl:attribute>
                    <xsl:text>&lt;xsl:choose&gt;</xsl:text>
                  </code>
                </pre>
              </xsl:if>
            </xsl:if>
            <pre>
              <code>
                <xsl:attribute name="class">
                   <xsl:value-of select="substring-before(substring-after($token, '.xsl/'),' ')"/>
                </xsl:attribute>
                <xsl:text>&lt;xsl:</xsl:text>
                <xsl:value-of select="substring-after($token, '.xsl/')"/>
                <xsl:if test="not($type = 'template')">
                  <xsl:text>/</xsl:text>
                </xsl:if>
                <xsl:if test="$type = 'template' and ($nexttype = 'template' or $nexttype = '') ">
                  <xsl:text>/</xsl:text>
                </xsl:if>
                 <xsl:text>&gt;</xsl:text>
              </code>
            </pre>
            <xsl:if test="$type = 'when' or $type = 'otherwise'">
              <xsl:if test="not($nexttype = 'when') and not(substring-after(following-sibling::*[ 1], '.xsl/') = 'otherwise')">
                <xsl:variable name="count" select="preceding-sibling::*[contains(@id, 'template')][1]/@count"/>
                <pre>
                  <code>
                     <xsl:attribute name="class">
                      <xsl:if test="$count = 0">Error if</xsl:if>
                      <xsl:if test="not($count = 0)">Success if</xsl:if>
                    </xsl:attribute>
                    <xsl:text>&lt;/xsl:choose&gt;</xsl:text>
                  </code>
                </pre>
              </xsl:if>
            </xsl:if>
             <xsl:if test="not($type = 'template') and ($nexttype = 'template' or $nexttype = '')">
                <xsl:variable name="count" select="preceding-sibling::*[contains(@id, 'template')][1]/@count"/>
                <pre>
                  <code>
                     <xsl:attribute name="class">
                      <xsl:if test="$count = 0">Error template</xsl:if>
                      <xsl:if test="not($count = 0)">Success template</xsl:if>
                    </xsl:attribute>
                    <xsl:text>&lt;/xsl:template&gt;</xsl:text>
                    
                  </code>
                </pre>
            </xsl:if>
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

