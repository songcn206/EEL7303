
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >
   <xsl:template match="/ObjectDifferences">
     <html>
      <body>
        <h1 >Difference report between <xsl:value-of select="Difference/SourceObject/@ObjectName"/> and <xsl:value-of select="Difference/TargetObject/@ObjectName"/>
      </h1>
       <b>Report generated at  :</b><xsl:value-of select="TimeStamp/@Date_and_Time_of_creation"/><br/>
        <xsl:for-each select="Difference">
          <xsl:variable name="srcObj" select="SourceObject/@ObjectName"/>
          <xsl:variable name="tarObj" select="TargetObject/@ObjectName"/>
          <b>Source Object :</b><xsl:value-of select="$srcObj"/><br/>
          <b>Target Object :</b><xsl:value-of select="$tarObj"/><br/>
          
          <font size="4" color="blue"><xsl:value-of select="$srcObj"/></font> is different from <font size="4" color="blue"><xsl:value-of select="$tarObj"/></font>
        <a><xsl:attribute name="name">top</xsl:attribute></a>
          
        <xsl:variable name="no_diff" select="count(Difference)"/>
        <br/>
        Number of differences = <xsl:value-of select="$no_diff"/><br/>
        <table border="0">
          <xsl:for-each select="Difference">
            <tr>
            <xsl:variable name="srcChek" select="boolean(SourceObject/@ObjectName[.!=''])"/>
            <xsl:variable name="targChek" select="boolean(TargetObject/@ObjectName[.!=''])"/>
            
           <td> 
             <xsl:variable name="pos" select="position()"/><br/>
           </td>
            <td>
              <b><xsl:value-of select="position()"/></b>
            </td>
              <td>
                <font color="blue">
                <xsl:if test="$srcChek">
                  SourceObject:<xsl:value-of select="SourceObject/@ObjectName"/>
                </xsl:if>
                <xsl:if test="$srcChek=false">
                  SourceObject:NULL
                </xsl:if>
              </font>
              <b> is different from </b>
              <font color="blue">
                <xsl:if test="$targChek">
                  TargetObject: <xsl:value-of select="TargetObject/@ObjectName"/>
                </xsl:if>
                <xsl:if test="$targChek=false">
                  TargetObject: NULL
                </xsl:if>
                  </font>
              </td>
              <td>
            <a><xsl:attribute name="href">#<xsl:value-of select="position()"/></xsl:attribute>Details </a>
              </td>
      </tr>
          </xsl:for-each>
    </table>
          <xsl:for-each select="Difference">
            <a><xsl:attribute name="name"><xsl:value-of select="position()"/></xsl:attribute>
              <br/>
              Difference <xsl:value-of select="position()"/><br/>
            </a>
         
          <table border="1" >
            <tr>
            <th>Source</th>
            <th>Target</th>
            </tr>
        <xsl:variable name="srcCheck" select="boolean(SourceObject/@ObjectName[.!=''])"/>
         <xsl:variable name="targCheck" select="boolean(TargetObject/@ObjectName[.!=''])"/>
          
                       
          <tr>
            <xsl:if test="$srcCheck">
              <td width="300">
                <xsl:for-each select=".//SourceObject|.//SourceObject//*">
                  <xsl:variable name="srctype" select="boolean(@ObjectType[.!=''])"/>
                  <xsl:if test="$srctype">
                    <br/><br/><b><xsl:value-of select="@ObjectType"/></b> with the following attributes:
                  </xsl:if>
                  <xsl:if test="name()!='SourceObject' and name()!='TargetObject'">
                    <br/><b><xsl:value-of select="name()"/>:</b>
                  </xsl:if>
                  <xsl:for-each select="@*">
                    <xsl:choose>
                      <xsl:when test="name()='ObjectType'">
                      </xsl:when>
                      <xsl:when test="name()='ObjectName'and contains(string(.),'@')">
                      </xsl:when>
                      <xsl:otherwise>
                        <br/><font color="red"><xsl:value-of select="name()"/>: </font><xsl:value-of select="."/>
                      </xsl:otherwise>
                    </xsl:choose>
                   </xsl:for-each>
                </xsl:for-each>
              </td>
            </xsl:if>

            <xsl:if test="$srcCheck=false">
              <td width="300" align="center">
                <b>Missing in Source</b>
              </td>
            </xsl:if>
            <xsl:if test="$targCheck">
              <td width="300">
                <xsl:for-each select=".//TargetObject|.//TargetObject//*">
                  <xsl:variable name="targtype" select="boolean(@ObjectType[.!=''])"/>
                  <xsl:if test="$targtype">
                   <br/> <br/><b><xsl:value-of select="@ObjectType"/></b> with the following attributes:
                  </xsl:if>
                  <xsl:if test="name()!='SourceObject' and name()!='TargetObject'">
                    <br/><b><xsl:value-of select="name()"/>:</b>
                  </xsl:if>
                  <xsl:for-each select="@*">
                    <xsl:choose>
                      <xsl:when test="name()='ObjectType'">
                      </xsl:when>
                      <xsl:when test="name()='ObjectName'and contains(string(.),'@')">
                      </xsl:when>
                      <xsl:otherwise>
                        <br/><font color="blue"><xsl:value-of select="name()"/>:</font>
                        <xsl:value-of select="."/>
                      </xsl:otherwise>
                    </xsl:choose>
                   
                  </xsl:for-each>
                </xsl:for-each>
              </td>
            </xsl:if>
            <xsl:if test="$targCheck=false">
              <td width="300" align="center">
               <b> Missing in Target</b>
              </td>
            </xsl:if>
           </tr>
          </table>
          <a>
            <xsl:attribute name="href">#top</xsl:attribute>
            Back to top<br/><br/>
          </a>
        </xsl:for-each>

        </xsl:for-each>
        
      </body>
    </html>
  </xsl:template>
  

  
</xsl:stylesheet>