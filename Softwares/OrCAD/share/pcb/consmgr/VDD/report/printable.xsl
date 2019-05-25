<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="html"/>
    <xsl:include href="shared.xsl"/>
    <!-- root template is there -->

    <!-- 'function' templates called from shared -->
    <xsl:template name="_e_includeScripts"/>
    <xsl:template name="_e_includeStyles">
        <xsl:call-template name="_i_includeStyleLink">
            <xsl:with-param name="name">default.css</xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="_i_includeStyleLink">
            <xsl:with-param name="name">print.css</xsl:with-param>
            <xsl:with-param name="media">print</xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    <xsl:template name="_e_pageLayout">
        <xsl:apply-templates select="Tree/Item"/>
    </xsl:template>
    <xsl:template name="_e_DefaultNonScalarStyle">
        <xsl:text>showAll </xsl:text>
    </xsl:template>
    <xsl:template name="_e_ViewSelector"/>
    <xsl:template name="_e_ChgMarker"/>
    <xsl:template name="_e_NavLinks">
        <xsl:element name="a">
            <xsl:attribute name="href">
                <xsl:text>#mainSummary</xsl:text>
            </xsl:attribute>
            <xsl:text>Top</xsl:text>
        </xsl:element>
        <xsl:if test="name() = 'ObjectSummary'">
            <xsl:text>     </xsl:text>
            <xsl:variable name="Kind" select="@Kind"/>
            <xsl:variable name="Group" select="/ConstraintDifferenceReport/Summaries/GroupSummary[starts-with(@Name, $Kind)]"/>
            <xsl:element name="a">
                <xsl:attribute name="href">
                    <xsl:text>#</xsl:text>
                    <xsl:value-of select="$Group/@ID"/>
                </xsl:attribute>
                <xsl:value-of select="$Group/@Name"/>
            </xsl:element>
        </xsl:if>
    </xsl:template>
    <!-- Templates by match -->
    <xsl:template match="Item">
        <xsl:variable name="Ref" select="@Ref"/>
        <xsl:apply-templates select="/ConstraintDifferenceReport/Summaries/*[@ID=$Ref]"/>
        <hr/>
        <xsl:if test="./Item">
            <xsl:apply-templates select="./Item"/>
        </xsl:if>
    </xsl:template>
    <xsl:template match="Attribute/Summary"/>
</xsl:stylesheet>