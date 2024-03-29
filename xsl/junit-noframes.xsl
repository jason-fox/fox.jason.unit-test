<?xml version="1.0"?>
<!--
  This file is part of the DITA-OT Unit Test Plug-in project.
  See the accompanying LICENSE file for applicable licenses.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xmlns:lxslt="http://xml.apache.org/xslt">
  <xsl:output method="html" indent="yes" encoding="UTF-8" doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"/>
  <xsl:decimal-format decimal-separator="." grouping-separator=","/>
  <!--
    Licensed to the Apache Software Foundation (ASF) under one
    or more contributor license agreements.  See the NOTICE file
    distributed with this work for additional information
    regarding copyright ownership.  The ASF licenses this file
    to you under the Apache License, Version 2.0 (the
    "License"); you may not use this file except in compliance
    with the License.  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing,
    software distributed under the License is distributed on an
    "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
    KIND, either express or implied.  See the License for the
    specific language governing permissions and limitations
    under the License.
  -->
  <!--

     Sample stylesheet to be used with Ant JUnitReport output.

     It creates a non-framed report that can be useful to send via
     e-mail or such.
  -->
  <xsl:template match="testsuites">
    <html>
      <head>
        <title>AntUnit Test Results</title>
        <style type="text/css">
body {
  font: normal 68% verdana, arial, helvetica;
  color: #000000;
}

table tr td,
table tr th {
  font-size: 68%;
}
table.details tr th {
  font-weight: bold;
  text-align: left;
  background: #a6caf0;
}
table.details tr td {
  background: #eeeee0;
}
table.details td.Success {
  background: lightgreen;
}
table.details td.Failure {
  background: lightcoral;
  color: whitesmoke;
}

p {
  line-height: 1.5em;
  margin-top: 0.5em;
  margin-bottom: 1em;
}
h1 {
  margin: 0px 0px 5px;
  font: 165% verdana, arial, helvetica;
}
h2 {
  margin-top: 1em;
  margin-bottom: 0.5em;
  font: bold 125% verdana, arial, helvetica;
}
h3 {
  margin-bottom: 0.5em;
  font: bold 115% verdana, arial, helvetica;
}
h4 {
  margin-bottom: 0.5em;
  font: bold 100% verdana, arial, helvetica;
}
h5 {
  margin-bottom: 0.5em;
  font: bold 100% verdana, arial, helvetica;
}
h6 {
  margin-bottom: 0.5em;
  font: bold 100% verdana, arial, helvetica;
}
.Error {
  font-weight: bold;
  color: red;
}
.Failure {
  font-weight: bold;
  color: purple;
}
.Properties {
  text-align: right;
}
        </style>
      </head>
      <body>
        <a name="top"/>
        <xsl:call-template name="pageHeader"/>

        <!-- Summary part -->
        <xsl:call-template name="summary"/>
        <hr size="1" width="95%" align="left"/>

        <!-- Directory List part -->
        <xsl:call-template name="directorylist"/>
        <hr size="1" width="95%" align="left"/>

        <!-- For each directory create its part -/->
		  <xsl:call-template name="directories"/>
		  <hr size="1" width="95%" align="left"/-->

        <!-- For each class create the  part -->
        <xsl:call-template name="classes"/>
      </body>
    </html>
  </xsl:template>

  <!-- ================================================================== -->
  <!-- Write a list of all directories with an hyperlink to the anchor of    -->
  <!-- of the directory name.									  -->
  <!-- ================================================================== -->
  <xsl:template name="directorylist">
    <h2>Test Suites</h2>
    Note: test suite statistics are not computed recursively, they only sum up all of its testsuites numbers.
    <table class="details" border="0" cellpadding="5" cellspacing="2" width="95%">
      <xsl:call-template name="testsuite.test.header"/>
      <!-- list all directories recursively -->
      <xsl:for-each select="./testsuite[not(./@package = preceding-sibling::testsuite/@package)]">
        <xsl:sort select="@package"/>
        <xsl:variable name="testsuites-in-directory" select="/testsuites/testsuite[./@package = current()/@package]"/>
        <xsl:variable name="testCount" select="sum($testsuites-in-directory/tests/text())"/>
        <xsl:variable name="errorCount" select="sum($testsuites-in-directory/errors/text())"/>
        <xsl:variable name="failureCount" select="sum($testsuites-in-directory/failures/text())"/>
        <xsl:variable name="timeCount" select="sum($testsuites-in-directory/time/text())"/>

        <!-- write a summary for the directory -->
        <tr valign="top">
          <!-- set a nice color depending if there is an error/failure -->
          <xsl:attribute name="class">
            <xsl:choose>
              <xsl:when test="$failureCount &gt; 0">Failure</xsl:when>
              <xsl:when test="$errorCount &gt; 0">Error</xsl:when>
            </xsl:choose>
          </xsl:attribute>
          <td>
            <a href="#{replace(@package, '^.*\.', '')}">
              <xsl:value-of select="replace(@package, '^.*\.', '')"/>
            </a>
          </td>
          <td>
            <xsl:value-of select="$testCount"/>
          </td>
          <td>
            <xsl:if test="$errorCount &gt; 0">
              <xsl:attribute name="class">Error</xsl:attribute>
            </xsl:if>
            <xsl:value-of select="$errorCount"/>
          </td>
          <td>
            <xsl:if test="$failureCount &gt; 0">
              <xsl:attribute name="class">Failure</xsl:attribute>
            </xsl:if>
            <xsl:value-of select="$failureCount"/>
          </td>
          <td>
            <xsl:call-template name="display-time">
              <xsl:with-param name="value" select="$timeCount"/>
            </xsl:call-template>
          </td>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>

  <!-- ================================================================== -->
  <!-- Write a directory level report							    -->
  <!-- It creates a table with values from the document:			   -->
  <!-- Name | Tests | Errors | Failures | Time					   -->
  <!-- ================================================================== -->
  <xsl:template name="directories">
    <!-- create an anchor to this directory name -->
    <xsl:for-each select="/testsuites/testsuite[not(./@package = preceding-sibling::testsuite/@package)]">
      <xsl:sort select="@package"/>
      <a name="{@package}"/>
      <h3>
        Tests for
        <xsl:value-of select="replace(@package, '^.*\.', '')"/>
      </h3>

      <table class="details" border="0" cellpadding="5" cellspacing="2" width="95%">
        <xsl:call-template name="testsuite.test.header"/>

        <!-- match the testsuites of this directory -->
        <xsl:apply-templates select="/testsuites/testsuite[./@package = current()/@package]" mode="print.test"/>
      </table>
      <a href="#top">Back to top</a>
      <p/>
      <p/>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="classes">
    <xsl:for-each select="testsuite">
      <xsl:sort select="@name"/>
      <!-- create an anchor to this class name -->
      <a name="{replace(@package, '^.*\.', '')}"/>
      <h3>
        Tests for
        <xsl:value-of select="replace(@package, '^.*\.', '')"/>
      </h3>

      <table class="details" border="0" cellpadding="5" cellspacing="2" width="95%">
        <xsl:call-template name="testcase.test.header"/>
        <!--
		    test can even not be started at all (failure to load the class)
		    so report the error directly
		    -->
        <xsl:if test="./error">
          <tr class="Error">
            <td colspan="4">
              <xsl:apply-templates select="./error"/>
            </td>
          </tr>
        </xsl:if>
        <xsl:apply-templates select="./testcase" mode="print.test"/>
      </table>
      <p/>

      <a href="#top">Back to top</a>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="summary">
    <h2>Summary</h2>
    <xsl:variable name="testCount" select="sum(testsuite/tests/text())"/>
    <xsl:variable name="errorCount" select="sum(testsuite/errors/text())"/>
    <xsl:variable name="failureCount" select="sum(testsuite/failures/text())"/>
    <xsl:variable name="timeCount" select="sum(testsuite/time/text())"/>
    <xsl:variable name="successRate" select="($testCount - $failureCount - $errorCount) div $testCount"/>
    <table class="details" border="0" cellpadding="5" cellspacing="2" width="95%">
      <tr valign="top">
        <th>Tests</th>
        <th>Failures</th>
        <th>Errors</th>
        <th>Success rate</th>
        <th>Time</th>
      </tr>
      <tr valign="top">
        <xsl:attribute name="class">
          <xsl:choose>
            <xsl:when test="$failureCount &gt; 0">Failure</xsl:when>
            <xsl:when test="$errorCount &gt; 0">Error</xsl:when>
          </xsl:choose>
        </xsl:attribute>
        <td>
          <xsl:value-of select="$testCount"/>
        </td>
        <td>
          <xsl:value-of select="$failureCount"/>
        </td>
        <td>
          <xsl:value-of select="$errorCount"/>
        </td>
        <td>
          <xsl:call-template name="display-percent">
            <xsl:with-param name="value" select="$successRate"/>
          </xsl:call-template>
        </td>
        <td>
          <xsl:call-template name="display-time">
            <xsl:with-param name="value" select="$timeCount"/>
          </xsl:call-template>
        </td>
      </tr>
    </table>
    <table border="0" width="95%">
      <tr>
        <td style="text-align: justify;">
          Note:
          <i>failures</i>
          are anticipated and checked for with assertions while
          <i>errors</i>
          are unanticipated.
        </td>
      </tr>
    </table>
  </xsl:template>
  <!-- Page HEADER -->
  <xsl:template name="pageHeader">
    <h1>Unit Test Results</h1>
    <table width="100%">
      <tr>
        <td align="left"/>
        <td align="right">
          Designed for use with
          <a href='http://ant.apache.org/antlibs/antunit/'>AntUnit</a>
          and
          <a href='http://ant.apache.org/'>Ant</a>
          .
        </td>
      </tr>
    </table>
    <hr size="1"/>
  </xsl:template>

  <xsl:template match="testsuite" mode="header">
    <tr valign="top">
      <th width="80%">Name</th>
      <th>Tests</th>
      <th>Errors</th>
      <th>Failures</th>
      <th nowrap="nowrap">Time(s)</th>
    </tr>
  </xsl:template>

  <!-- class header -->
  <xsl:template name="testsuite.test.header">
    <tr valign="top">
      <th width="80%">Name</th>
      <th>Tests</th>
      <th>Errors</th>
      <th>Failures</th>
      <th nowrap="nowrap">Time(s)</th>
    </tr>
  </xsl:template>

  <!-- method header -->
  <xsl:template name="testcase.test.header">
    <tr valign="top">
      <th width="40%">Name</th>
      <th width="5em">Status</th>
      <th width="40%">Type</th>
      <th nowrap="nowrap">Time(s)</th>
    </tr>
  </xsl:template>

  <!-- class information -->
  <xsl:template match="testsuite" mode="print.test">
    <tr valign="top">
      <!-- set a nice color depending if there is an error/failure -->
      <xsl:attribute name="class">
        <xsl:choose>
          <xsl:when test="failures/text()[.&gt; 0]">Failure</xsl:when>
          <xsl:when test="errors/text()[.&gt; 0]">Error</xsl:when>
        </xsl:choose>
      </xsl:attribute>

      <!-- print testsuite information -->
      <td>
        <a href="#{@name}">
          <xsl:value-of select="@name"/>
        </a>
      </td>
      <td>
        <xsl:value-of select="tests/text()"/>
      </td>
      <td>
        <xsl:value-of select="errors/text()"/>
      </td>
      <td>
        <xsl:value-of select="failures/text()"/>
      </td>
      <td>
        <xsl:call-template name="display-time">
          <xsl:with-param name="value" select="time/text()"/>
        </xsl:call-template>
      </td>
      <td>
        <xsl:apply-templates select="@timestamp"/>
      </td>
      <td>
        <xsl:apply-templates select="@hostname"/>
      </td>
    </tr>
  </xsl:template>

  <xsl:template match="testcase" mode="print.test">
    <tr valign="top">
      <xsl:attribute name="class">
        <xsl:choose>
          <xsl:when test="error">Error</xsl:when>
          <xsl:when test="failure">Failure</xsl:when>
          <xsl:otherwise>TableRowColor</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <td>
        <xsl:value-of select="normalize-space(@name)"/>
      </td>
      <xsl:choose>
        <xsl:when test="failure">
          <td class="Failure">Failure</td>
          <td>
            <xsl:apply-templates select="failure"/>
          </td>
        </xsl:when>
        <xsl:when test="error">
          <td class="Failure">Error</td>
          <td>
            <xsl:apply-templates select="error"/>
          </td>
        </xsl:when>
        <xsl:otherwise>
          <td class="Success">Success</td>
          <td/>
        </xsl:otherwise>
      </xsl:choose>
      <td>
        <xsl:call-template name="display-time">
          <xsl:with-param name="value" select="time/text()"/>
        </xsl:call-template>
      </td>
    </tr>
  </xsl:template>

  <xsl:template match="failure">
    <xsl:call-template name="display-failures"/>
  </xsl:template>

  <xsl:template match="error">
    <xsl:call-template name="display-failures"/>
    <!-- display the stacktrace -->
    <br/>
    <br/>
    <code>
      <xsl:call-template name="br-replace">
        <xsl:with-param name="word" select="."/>
      </xsl:call-template>
    </code>
    <!-- the latter is better but might be problematic for non-21" monitors... -->
    <!--pre><xsl:value-of select="."/></pre-->
  </xsl:template>

  <!-- Style for the error and failure in the tescase template -->
  <xsl:template name="display-failures">
    <xsl:choose>
      <xsl:when test="not(@message)">N/A</xsl:when>
      <xsl:when test="contains(@message, '===================================================')">
        <pre>
          <xsl:text>===================================================&#xa;</xsl:text>
          <xsl:value-of select="replace(@message, '^.*\n.*\n.*\n', '')"/>
        </pre>
      </xsl:when>

      <xsl:otherwise>
        <pre>
          <xsl:value-of select="@message"/>
        </pre>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:choose>
      <xsl:when test="@linenumber">
        <br/>
        at line
        <xsl:value-of select="@linenumber"/>
        <xsl:choose>
          <xsl:when test="@columnnumber">
            , column
            <xsl:value-of select="@columnnumber"/>
          </xsl:when>
        </xsl:choose>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="JS-escape">
    <xsl:param name="string"/>
    <xsl:param name="tmp1" select="replace(string($string),'\\','\\\\')"/>
    <xsl:param name="tmp2" select="replace(string($tmp1),&quot;'&quot;,&quot;\&apos;&quot;)"/>
    <xsl:value-of select="$tmp2"/>
  </xsl:template>

  <!--
    template that will convert a carriage return into a br tag
    @param word the text from which to convert CR to BR tag
-->
  <xsl:template name="br-replace">
    <xsl:param name="word"/>
    <xsl:choose>
      <xsl:when test="contains($word, '&#xa;')">
        <xsl:value-of select="substring-before($word, '&#xa;')"/>
        <br/>
        <xsl:call-template name="br-replace">
          <xsl:with-param name="word" select="substring-after($word, '&#xa;')"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$word"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="display-time">
    <xsl:param name="value"/>
    <xsl:value-of select="format-number($value,'0.000')"/>
  </xsl:template>

  <xsl:template name="display-percent">
    <xsl:param name="value"/>
    <xsl:value-of select="format-number($value,'0.00%')"/>
  </xsl:template>
</xsl:stylesheet>
