<?xml version="1.0" encoding="utf-8"?> 
<!--Stylesheet for inclusion only - not for indepent use-->
<!--naming: _e_ are templates defined in the including files, but used here-->
<!--naming: _i_ are templates defined this file, but used in including files-->
<!--naming: __ are locally-used templates-->
<!--naming:     insert - no params - just dumps the content or formatting-->
<!--naming:     format - with param - formats value passed as param-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <!-- Templates by match -->
    <xsl:template match="/ConstraintDifferenceReport">
        <html>
            <head>
                <xsl:call-template name="_e_includeScripts"/>
                <xsl:call-template name="_e_includeStyles"/>
                <title>
                    <xsl:value-of select="@Type"/>
                </title>
            </head>
            <body>
                <xsl:call-template name="_e_pageLayout"/>
            </body>
        </html>
    </xsl:template>
    <xsl:template match="/ConstraintDifferenceReport/Summaries/MainSummary">
        <xsl:element name="div">
            <xsl:attribute name="id">
                <xsl:value-of select="@ID"/>
                <xsl:text>-cashe</xsl:text>
            </xsl:attribute>
            <h1>Report summary</h1>
            <table id="ReportSummary">
                <tbody>
                    <xsl:apply-templates select="/ConstraintDifferenceReport/RptSummary/Entry"/>
                </tbody>
            </table>
            <h1>
                <xsl:element name="a">
                    <xsl:attribute name="name">
                        <xsl:value-of select="@ID"/>
                    </xsl:attribute>
                    <xsl:text>Summary</xsl:text>
                </xsl:element>
            </h1>
            <xsl:choose>
                <xsl:when test="count(./*) != 0">
                    <table>
                        <xsl:call-template name="__groupSummaryTableHeader"/>
                        <tbody>
                            <xsl:apply-templates select="ChangedObject"></xsl:apply-templates>
                        </tbody>
                    </table>
                    <xsl:apply-templates select="Attributes"/>
                </xsl:when>
                <xsl:otherwise>
                    <h2>No changes found</h2>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates select="/ConstraintDifferenceReport/Notes"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="/ConstraintDifferenceReport/RptSummary/Entry">
        <tr>
            <td>
                <xsl:value-of select="@Name"/>
            </td>
            <xsl:element name ="td">
                <xsl:if test="@Status">
                    <xsl:attribute name="class">
                        <xsl:value-of select="@Status"/>
                    </xsl:attribute>
                </xsl:if>
                <xsl:value-of select="."/>
            </xsl:element>
        </tr>
    </xsl:template>
    <xsl:template match="ChangedObject">
        <tr>
            <td>
                <xsl:call-template name="__objName"/>
            </td>
            <xsl:choose>
                <xsl:when test="@ObjNumber">
                    <td>
                        <xsl:value-of select="@ObjNumber"/>
                    </td>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:if test="../@Name='NetClasses'">
                        <xsl:element name="td">
                            <xsl:if test="@Electrical">
                                <xsl:attribute name="class">markCell</xsl:attribute>
                            </xsl:if>
                        </xsl:element>
                        <xsl:element name="td">
                            <xsl:if test="@Physical">
                                <xsl:attribute name="class">markCell</xsl:attribute>
                            </xsl:if>
                        </xsl:element>
                        <xsl:element name="td">
                            <xsl:if test="@Spacing">
                                <xsl:attribute name="class">markCell</xsl:attribute>
                            </xsl:if>
                        </xsl:element>
                        <xsl:element name="td">
                            <xsl:if test="@SNS">
                                <xsl:attribute name="class">markCell</xsl:attribute>
                            </xsl:if>
                        </xsl:element>
                    </xsl:if>
                    <td>
                        <xsl:value-of select="@Membership"/>
                    </td>
                    <td>
                        <xsl:value-of select="@Reference"/>
                    </td>
                    <td>
                        <xsl:value-of select="@Attributes"/>
                    </td>
                    <td>
                        <xsl:value-of select="@Notes"/>
                    </td>
                    <xsl:element name="td">
                        <xsl:call-template name="__status"/>
                    </xsl:element>
                </xsl:otherwise>
            </xsl:choose>
        </tr>
    </xsl:template>
    <xsl:template match="/ConstraintDifferenceReport/Summaries/GroupSummary">
        <xsl:element name="div">
            <xsl:attribute name="id">
                <xsl:value-of select="@ID"/>
                <xsl:text>-cashe</xsl:text>
            </xsl:attribute>
            <h2>
                <xsl:element name="a">
                    <xsl:attribute name="name">
                        <xsl:value-of select="@ID"/>
                    </xsl:attribute>
                    <xsl:value-of select="@Name"/>
                </xsl:element>
            </h2>
            <xsl:call-template name="_e_NavLinks"/>
            <xsl:call-template name="__groupSummaryTable"/>
        </xsl:element>
        <!-- in printable reports objects should follow their summaries -->
        <xsl:variable name="key" select="substring(@Name, 1, string-length(@Name)-2)"/>
    </xsl:template>
    <xsl:template match="/ConstraintDifferenceReport/Summaries/ObjectSummary">
        <xsl:element name="div">
            <xsl:attribute name="id">
                <xsl:value-of select="@ID"/>
                <xsl:text>-cashe</xsl:text>
            </xsl:attribute>
            <h2>
                <xsl:element name="a">
                    <xsl:attribute name="name">
                        <xsl:value-of select="@ID"/>
                    </xsl:attribute>
                    <xsl:value-of select="@Kind"/>
                    <xsl:text>: </xsl:text>
                    <xsl:value-of select="@Name"/>
                    <xsl:if test="count(@Status)>0">
                        <xsl:text> - </xsl:text>
                        <xsl:value-of select="@Status"/>
                    </xsl:if>
                </xsl:element>
            </h2>
            <xsl:call-template name="_e_NavLinks"/>
            <xsl:apply-templates select="./*">
                <xsl:sort select="name()"/>
                <xsl:sort select="@Type"/>
            </xsl:apply-templates>
        </xsl:element>
    </xsl:template>
    <!-- Attribute-related stuff -->
    <xsl:template match="Attributes">
        <h3>
            <xsl:choose>
                <xsl:when test="name(..) = 'MainSummary'">Analysis mode changes:</xsl:when>
                <xsl:otherwise>Attribute changes:</xsl:otherwise>
            </xsl:choose>
        </h3>
        <xsl:if test="./Attribute[@Type != 'Scalar']">
            <xsl:call-template name="_e_ViewSelector">
                <xsl:with-param name="global">true</xsl:with-param>
            </xsl:call-template>
        </xsl:if>
        <xsl:call-template name="__attributeTable"/>
    </xsl:template>
    <xsl:template match="Attribute">
        <xsl:param name="threecols"/>
        <tr>
            <td>
                <xsl:value-of select="@Name"/>
            </td>
            <xsl:choose>
                <xsl:when test="@Type='Scalar'">
                    <xsl:apply-templates select="Value">
                        <xsl:with-param name="threecols" select="$threecols"/>
                        <xsl:with-param name="srcTaken" select="@srcTaken"/>
                    </xsl:apply-templates>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:element name="td">
                        <xsl:attribute name="ID">
                            <xsl:value-of select="generate-id()"/>
                        </xsl:attribute>
                        <xsl:attribute name="colspan">
                            <xsl:choose>
                                <xsl:when test="$threecols='true'">3</xsl:when>
                                <xsl:otherwise>2</xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                        <xsl:attribute name="class">
                            <xsl:text>nonScalarDiff </xsl:text>
                            <xsl:call-template name="_e_DefaultNonScalarStyle"/>
                        </xsl:attribute>
                        <xsl:call-template name="_e_ViewSelector"/>
                        <xsl:call-template name="__multiValueContent"/>
                    </xsl:element>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:element name="td">
                <xsl:call-template name="__status"/>
            </xsl:element>
        </tr>
    </xsl:template>
    <xsl:template match="Value">
        <xsl:param name="threecols"/>
        <xsl:param name="srcTaken"/>
        <xsl:param name="needLyr"/>
        <xsl:param name="i"/>
        <xsl:if test="$needLyr">
            <td>
                <xsl:value-of select="/ConstraintDifferenceReport/Layers/Layer[$i]/@Name"/>
            </td>
        </xsl:if>
        <xsl:call-template name="__valueCell">
            <xsl:with-param name="val" select="@Dst"/>
            <xsl:with-param name="taken" select="$srcTaken='0'"/>
        </xsl:call-template>
        <xsl:call-template name="__valueCell">
            <xsl:with-param name="val" select="@Src"/>
            <xsl:with-param name="taken" select="$srcTaken='1'"/>
        </xsl:call-template>
        <xsl:if test="$threecols='true'">
            <xsl:call-template name="__valueCell">
                <xsl:with-param name="val" select="@Base"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    <!-- Membership-related stuff -->
    <xsl:template match="Associations">
        <h3>
            <xsl:value-of select="@Type"/>
            <xsl:text> changes:</xsl:text>
        </h3>
        <table>
            <thead>
                <tr>
                    <td>Name</td>
                    <td>Object type</td>
                    <td>Status</td>
                </tr>
            </thead>
            <tbody>
                <xsl:apply-templates select="Reference">
                    <xsl:sort select="@Kind"/>
                    <xsl:sort select="@Name"/>
                </xsl:apply-templates>
            </tbody>
        </table>
    </xsl:template>
    <xsl:template match="Reference">
        <tr>
            <td>
                <xsl:call-template name="__objName"/>
            </td>
            <td>
                <xsl:value-of select="@Kind"/>
            </td>
            <td>
                <xsl:choose>
                    <xsl:when test="@Add='true'">Add</xsl:when>
                    <xsl:otherwise>Delete</xsl:otherwise>
                </xsl:choose>
            </td>
        </tr>
    </xsl:template>
    <!-- Notes -->
    <xsl:template match="/ConstraintDifferenceReport/Notes">
        <h1>Notes</h1>
        <textarea class="legacy">
            <xsl:for-each select="Note">
                <xsl:value-of select="text()"/>
                <xsl:text>&#x0a;</xsl:text>
            </xsl:for-each>
        </textarea>
    </xsl:template>
    <xsl:template match="ObjectSummary/Notes">
        <h3>Notes:</h3>
        <xsl:call-template name="__attributeTable"/>
    </xsl:template>

    <!-- Local 'function' templates to be called from including scripts -->
    <xsl:template name="_i_includeStyleLink">
        <xsl:param name="name"/>
        <xsl:param name="media">all</xsl:param>
        <xsl:element name="link">
            <xsl:attribute name="rel">stylesheet</xsl:attribute>
            <xsl:attribute name="type">text/css</xsl:attribute>
            <xsl:attribute name="media">
                <xsl:value-of select="$media"/>
            </xsl:attribute>
            <xsl:attribute name="href">
                <xsl:value-of select="@Path"/>
                <xsl:text>/</xsl:text>
                <xsl:value-of select="$name"/>
            </xsl:attribute>
        </xsl:element>
    </xsl:template>
    <!-- Local 'function' templates -->
    <xsl:template name="__groupSummaryTableHeader">
        <thead>
            <xsl:choose>
                <xsl:when test="./ChangedObject[@ObjNumber]">
                    <td>Object type</td>
                    <td>Total changed objects</td>
                </xsl:when>
                <xsl:when test="@Name='NetClasses'">
                    <tr>
                        <td rowspan="2">Object name</td>
                        <td colspan="4">Domain</td>
                        <td rowspan="2">Membership changes</td>
                        <td rowspan="2">Reference changes</td>
                        <td rowspan="2">Attribute changes</td>
                        <td rowspan="2">Notes</td>
                        <td rowspan="2">Status</td>
                    </tr>
                    <tr>
                        <td>E</td>
                        <td>P</td>
                        <td>S</td>
                        <td>SNS</td>
                    </tr>
                </xsl:when>
                <xsl:otherwise>
                    <td>Object name</td>
                    <td>Membership changes</td>
                    <td>Reference changes</td>
                    <td>Attribute changes</td>
                    <td>Notes</td>
                    <td>Status</td>
                </xsl:otherwise>
            </xsl:choose>
        </thead>
    </xsl:template>
    <xsl:template name="__valueCell">
        <xsl:param name="val"/>
        <xsl:param name="taken"/>
        <xsl:variable name="cls">
            <xsl:choose>
                <xsl:when test="$taken">selected</xsl:when>
                <xsl:when test="@Type='Conflict'">Conflict</xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:element name="td">
            <xsl:if test="$cls">
                <xsl:attribute name="class">
                    <xsl:value-of select="$cls"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:value-of select="$val"/>
        </xsl:element>
    </xsl:template>
    <xsl:template name="__multiValueContent">
        <xsl:apply-templates select="Summary"/>
        <table>
            <xsl:call-template name="__MultiValueTHead"/>
            <tbody>
                <xsl:for-each select="Value">
                    <xsl:variable name="c1" select="@Type = 'noChange'"/>
                    <xsl:element name="tr">
                        <xsl:if test="$c1">
                            <xsl:attribute name="class">
                                <xsl:text>noChange full</xsl:text>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:apply-templates select=".">
                            <xsl:with-param name="threecols" select="count(./@Base)>0"/>
                            <xsl:with-param name="srcTaken">Unused</xsl:with-param>
                            <xsl:with-param name="needLyr" select="../@Type='Layers'"/>
                            <xsl:with-param name="i" select="position()"/>
                        </xsl:apply-templates>
                    </xsl:element>
                    <xsl:variable name="j" select="position() + 1"/>
                    <xsl:variable name="c2" select="../Value[$j]"/>
                    <xsl:variable name="c3" select="$c2 and ($c2/@Type != 'noChange')"/>
                    <xsl:variable name="c4" select="$c2 and not($c2/@Type)"/>
                    <xsl:if test="$c1 and (not($c2) or ($c2 and ($c3 or $c4)))">
                        <xsl:call-template name="_e_ChgMarker">
                            <xsl:with-param name="threecols" select="../@Status='Conflict'"/>
                        </xsl:call-template>
                    </xsl:if>
                </xsl:for-each>
            </tbody>
        </table>
    </xsl:template>
    <xsl:template name="__MultiValueTHead">
        <thead>
            <xsl:if test="@Type='Layers'">
                <xsl:call-template name="__THeadCell">
                    <xsl:with-param name="name">Layer name</xsl:with-param>
                </xsl:call-template>
            </xsl:if>
            <xsl:call-template name="__THeadCell">
                <xsl:with-param name="name">__col1</xsl:with-param>
                <xsl:with-param name="selected" select="@srcTaken = '0'"/>
            </xsl:call-template>
            <xsl:call-template name="__THeadCell">
                <xsl:with-param name="name">__col2</xsl:with-param>
                <xsl:with-param name="selected" select="@srcTaken = '1'"/>
            </xsl:call-template>
            <xsl:if test="count(./Value/@Base)>0">
                <xsl:call-template name="__THeadCell">
                    <xsl:with-param name="name">__col3</xsl:with-param>
                </xsl:call-template>
            </xsl:if>
        </thead>
    </xsl:template>
    <xsl:template name="__THeadCell">
        <xsl:param name="name"/>
        <xsl:param name="selected"/>
        <xsl:element name="td">
            <xsl:if test="$selected">
                <xsl:attribute name="class">selected</xsl:attribute>
            </xsl:if>
            <xsl:choose>
                <xsl:when test="$name = '__col1'">
                    <xsl:attribute name="title">
                        <xsl:value-of select="/ConstraintDifferenceReport/RptSummary/Entry[@Name = /ConstraintDifferenceReport/RptSummary/@Col1]"/>
                    </xsl:attribute>
                    <xsl:value-of select="/ConstraintDifferenceReport/RptSummary/@Col1"/>
                </xsl:when>
                <xsl:when test="$name = '__col2'">
                    <xsl:attribute name="title">
                        <xsl:value-of select="/ConstraintDifferenceReport/RptSummary/Entry[@Name = /ConstraintDifferenceReport/RptSummary/@Col2]"/>
                    </xsl:attribute>
                    <xsl:value-of select="/ConstraintDifferenceReport/RptSummary/@Col2"/>
                </xsl:when>
                <xsl:when test="$name = '__col3'">
                    <xsl:attribute name="title">
                        <xsl:value-of select="/ConstraintDifferenceReport/RptSummary/Entry[@Name = 'Baseline File']"/>
                    </xsl:attribute>
                    <xsl:text>Base</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$name"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>
    <xsl:template name="__objName">
        <xsl:element name="a">
            <xsl:attribute name="href">
                <xsl:text>#</xsl:text>
                <xsl:value-of select="@Ref"/>
            </xsl:attribute>
            <xsl:value-of select="@Name"/>
        </xsl:element>
    </xsl:template>
    <xsl:template name="__groupSummaryTable">
        <table>
            <xsl:call-template name="__groupSummaryTableHeader"/>
            <tbody>
                <xsl:apply-templates select="ChangedObject"></xsl:apply-templates>
            </tbody>
        </table>
    </xsl:template>
    <xsl:template name="__attributeTable">
        <table>
            <thead>
                <td>Attribute name</td>
                <xsl:call-template name="__THeadCell">
                    <xsl:with-param name="name">__col1</xsl:with-param>
                </xsl:call-template>
                <xsl:call-template name="__THeadCell">
                    <xsl:with-param name="name">__col2</xsl:with-param>
                </xsl:call-template>
                <xsl:if test="count(./Attribute/Value/@Base)>0">
                    <xsl:call-template name="__THeadCell">
                        <xsl:with-param name="name">__col3</xsl:with-param>
                    </xsl:call-template>
                </xsl:if>
                <td>Status</td>
            </thead>
            <tbody>
                <xsl:apply-templates select="Attribute">
                    <xsl:sort select="@Name"/>
                    <xsl:with-param name="threecols">
                        <xsl:if test="count(./Attribute/Value/@Base)>0">true</xsl:if>
                    </xsl:with-param>
                </xsl:apply-templates>
            </tbody>
        </table>
    </xsl:template>
    <xsl:template name="__status">
        <xsl:choose>
            <xsl:when test="count(@Status)>0 and @Status!=''">
                <xsl:choose>
                    <xsl:when test="@Status='Conflict'">
                        <xsl:attribute name="class">Conflict</xsl:attribute>
                    </xsl:when>
                    <xsl:when test="starts-with(@Status,'Delete')">
                        <xsl:attribute name="class">status-del</xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="class">status-add</xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:value-of select="@Status"/>
            </xsl:when>
            <xsl:otherwise>Change</xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
