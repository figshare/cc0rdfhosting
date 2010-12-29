<?xml version="1.0"?>
<!--

sparql-html.xsl, version 0.2 (2006-07-11):
XSLT for transformation of SPARQL Query Results XML Format into XHTML.

Copyright (c) 2005 Morten Frederiksen
License: http://www.gnu.org/licenses/gpl
     or: http://www.w3.org/Consortium/Legal/2002/copyright-software-20021231

-->
<xsl:transform
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:dawg1="http://www.w3.org/2001/sw/DataAccess/rf1/result"
	xmlns:dawg="http://www.w3.org/2001/sw/DataAccess/rf1/result2"
	xmlns:res="http://www.w3.org/2005/sparql-results#"
	xmlns="http://www.w3.org/1999/xhtml"
	exclude-result-prefixes="dawg1 dawg res"
	version="1.0">
<xsl:output
	doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
	doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
	indent="yes"
	method="xml"/>

<xsl:param name="_now" select="false()"/>
<xsl:param name="_id"/>
<xsl:param name="_uri"/>
<xsl:param name="sparql-query"/>
<xsl:param name="sparql-query-lang"/>
<xsl:param name="sparql-data"/>
<xsl:param name="sparql-format"/>
<xsl:param name="sparql-output-xslt"/>
<xsl:param name="sparql-output-type"/>

<!-- Create document from SPARQL Query Results XML Format -->
<xsl:template match="/">
	<html xml:lang="en" lang="en">
		<head>
			<title>Results</title>
			<link rel="stylesheet" type="text/css" href="common.css" />
            <link rel="stylesheet" type="text/css" href="meniu.css" />
			<style>
table { border: 1px solid #999 }
th { border: 1px solid #666 }
td { border: 1px solid #ccc }
			</style>
		</head>
		<body>
<div id="meniu">
        <a href="index.php">Home</a>
        <a href="sparql-editor.html">Query editor</a>
</div>
<div id="hr"></div>
    <h3 style="padding-left:50px;margin-top:220px;">Results Table</h3>
			<div style="padding-left:50px;">
				<xsl:if test="string-length($sparql-query)!=0">
					<p>
						<xsl:text>Results for </xsl:text>
						<xsl:choose>
							<xsl:when test="$sparql-query-lang='rdql'">RDQL</xsl:when>
							<xsl:otherwise>SPARQL</xsl:otherwise>
						</xsl:choose>
						<xsl:text> query</xsl:text>
						<xsl:if test="string-length($sparql-query)!=0">
							<xsl:text>: </xsl:text>
							<pre>
								<xsl:value-of select="$sparql-query"/>
							</pre>
						</xsl:if>
					</p>
				</xsl:if>
				<table>
					<xsl:apply-templates mode="root" select="/dawg1:sparql/*|/dawg:sparql/*|/res:sparql/*"/>
				</table>
                <!--    <h3><a href="javascript:show_xml();">Raw SPARQL XML</a></h3>
				<pre id="rawxml">
					<xsl:apply-templates mode="dump" select="/*"/>
                </pre>
                -->
			</div>
            <div id="bottom">
             <img src="opendata.png" alt="opendata" />
             <img src="http://i.creativecommons.org/p/zero/1.0/80x15.png" style="border-style: none;" alt="CC0" />
                <p xmlns:dct="http://purl.org/dc/terms/" xmlns:vcard="http://www.w3.org/2001/vcard-rdf/3.0#">
                <a rel="license" href="http://creativecommons.org/publicdomain/zero/1.0/"></a>
                 <br /> To the extent possible under law,<a rel="dct:publisher"  href="http://www.science3point0.com/opendata/">
                 <span property="dct:title">Science3.0</span></a>
                 has waived all copyright and related or neighboring rights to
                <span property="dct:title">CC0 RDF Hosting For Scientists</span>.
                This work is published from:
                <span property="vcard:Country" datatype="dct:ISO3166"  content="GB" about="http://www.science3point0.com/opendata/">
                 United Kingdom</span>.</p></div>
		</body>
	</html>
</xsl:template>

<!-- Process head element -->
<xsl:template mode="root" priority="0.2" match="dawg1:head[dawg1:variable and ../dawg1:results[dawg1:result]]|dawg:head[dawg:variable and ../dawg:results[dawg:result]]|res:head[res:variable and ../res:results[res:result]]">
	<tr>
		<xsl:apply-templates mode="variable" select="*"/>
	</tr>
</xsl:template>

<!-- Process variable elements -->
<xsl:template mode="variable" match="dawg1:variable|dawg:variable|res:variable">
	<th>
		<xsl:value-of select="@name"/>
	</th>
</xsl:template>

<!-- Process results element -->
<xsl:template mode="root" priority="0.2" match="dawg1:results[dawg1:result]|dawg:results[dawg:result]|res:results[res:result]">
	<xsl:apply-templates mode="result" select="dawg1:result|dawg:result|res:result"/>
</xsl:template>

<!-- First order elements other than head or results must be an error -->
<xsl:template mode="root" priority="0.1" match="*[1]">
	<tr>
		<td>
			<xsl:text>No results.</xsl:text>
		</td>
	</tr>
</xsl:template>

<!-- Process result elements -->
<xsl:template mode="result" match="dawg1:result|dawg:result|res:result">
	<tr>
		<xsl:apply-templates mode="binding" select="dawg1:*|dawg:binding|res:binding"/>
	</tr>
</xsl:template>

<!-- Process binding element -->
<xsl:template mode="binding" match="dawg1:*|dawg:binding|res:binding">
	<td>
		<xsl:apply-templates mode="value" select="."/>
	</td>
</xsl:template>

<!-- String value of binding for first draft -->
<xsl:template mode="value" match="dawg1:*">
	<xsl:choose>
		<xsl:when test="@uri">
			<a href="{@uri}">
				<xsl:value-of select="@uri"/>
			</a>
		</xsl:when>
		<xsl:when test="@bnodeid">
			<xsl:text>(</xsl:text>
			<xsl:value-of select="@bnodeid"/>
			<xsl:text>)</xsl:text>
		</xsl:when>
		<xsl:when test="@datatype">
			<xsl:value-of select="text()"/>
			<xsl:text> ^^ </xsl:text>
			<xsl:value-of select="@datatype"/>
		</xsl:when>
		<xsl:when test="@xml:lang">
			<xsl:value-of select="text()"/>
			<xsl:text> @ </xsl:text>
			<xsl:value-of select="@xml:lang"/>
		</xsl:when>
		<xsl:when test="string-length(text())!=0 or not(@bound='false')">
			<xsl:value-of select="text()"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>-</xsl:text>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- String value of binding for second draft -->
<xsl:template mode="value" match="dawg:binding">
	<xsl:choose>
		<xsl:when test="dawg:uri">
			<a href="{dawg:uri}">
				<xsl:value-of select="dawg:uri"/>
			</a>
		</xsl:when>
		<xsl:when test="dawg:bnode">
			<xsl:text>(</xsl:text>
			<xsl:value-of select="dawg:bnode"/>
			<xsl:text>)</xsl:text>
		</xsl:when>
		<xsl:when test="dawg:literal[@datatype]">
			<xsl:value-of select="dawg:literal/text()"/>
			<xsl:text> ^^ </xsl:text>
			<xsl:value-of select="dawg:literal/@datatype"/>
		</xsl:when>
		<xsl:when test="dawg:literal[@xml:lang]">
			<xsl:value-of select="dawg:literal/text()"/>
			<xsl:text> @ </xsl:text>
			<xsl:value-of select="dawg:literal/@xml:lang"/>
		</xsl:when>
		<xsl:when test="dawg:literal">
			<xsl:value-of select="dawg:literal/text()"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>-</xsl:text>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- String value of binding for final (?) draft -->
<xsl:template mode="value" match="res:binding">
	<xsl:choose>
		<xsl:when test="res:uri">
			<a href="{res:uri}">
				<xsl:value-of select="res:uri"/>
			</a>
		</xsl:when>
		<xsl:when test="res:bnode">
			<xsl:text>(</xsl:text>
			<xsl:value-of select="res:bnode"/>
			<xsl:text>)</xsl:text>
		</xsl:when>
		<xsl:when test="res:literal[@datatype]">
			<xsl:value-of select="res:literal/text()"/>
			<xsl:text> ^^ </xsl:text>
			<xsl:value-of select="res:literal/@datatype"/>
		</xsl:when>
		<xsl:when test="res:literal[@xml:lang]">
			<xsl:value-of select="res:literal/text()"/>
			<xsl:text> @ </xsl:text>
			<xsl:value-of select="res:literal/@xml:lang"/>
		</xsl:when>
		<xsl:when test="res:literal">
			<xsl:value-of select="res:literal/text()" disable-output-escaping="yes" />
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>-</xsl:text>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- Dump XML... -->
<xsl:template mode="dump" match="*">
	<xsl:param name="indent" select="0"/>
	<xsl:apply-templates mode="indent" select=".">
		<xsl:with-param name="indent" select="$indent"/>
	</xsl:apply-templates>
	<xsl:text>&lt;</xsl:text>
	<xsl:value-of select="local-name()"/>
	<xsl:if test="namespace-uri()!=namespace-uri(..)">
		<xsl:text> xmlns="</xsl:text>
		<xsl:value-of select="namespace-uri()"/>
		<xsl:text>"</xsl:text>
	</xsl:if>
	<xsl:apply-templates mode="dump" select="@*"/>
	<xsl:choose>
		<xsl:when test="*|text()[string-length(normalize-space(.))!=0]">
			<xsl:text>&gt;</xsl:text>
			<xsl:choose>
				<xsl:when test="*">
					<xsl:text>
</xsl:text>
					<xsl:apply-templates mode="dump" select="*|text()[string-length(normalize-space(.))!=0]">
						<xsl:with-param name="indent" select="$indent + 2"/>
					</xsl:apply-templates>
					<xsl:apply-templates mode="indent" select=".">
						<xsl:with-param name="indent" select="$indent"/>
					</xsl:apply-templates>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates mode="dump" select="text()[string-length(normalize-space(.))!=0]"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:text>&lt;/</xsl:text>
			<xsl:value-of select="local-name()"/>
			<xsl:text>&gt;
</xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>/&gt;
</xsl:text>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>
<xsl:template mode="dump" match="@*">
	<xsl:text> </xsl:text>
	<xsl:value-of select="local-name()"/>
	<xsl:text>="</xsl:text>
	<xsl:value-of select="."/>
	<xsl:text>"</xsl:text>
</xsl:template>
<xsl:template mode="dump" match="text()">
	<xsl:value-of select="."/>
</xsl:template>
<xsl:template mode="indent" match="*">
	<xsl:param name="indent" select="0"/>
	<xsl:if test="$indent &gt; 0">
		<xsl:text> </xsl:text>
		<xsl:apply-templates mode="indent" select=".">
			<xsl:with-param name="indent" select="$indent - 1"/>
		</xsl:apply-templates>
	</xsl:if>
</xsl:template>

</xsl:transform>
