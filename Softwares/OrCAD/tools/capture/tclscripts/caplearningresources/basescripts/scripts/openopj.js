/*#////////////////////////////////////////////////////////////////////////
# 	Cadence Design Systems
#  (c) 2012 Cadence Design Systems, Inc. All rights reserved.
#  This work may not be copied, modified, re-published, uploaded, 
#  executed, or distributed in any way, in any medium, whether in 
#  whole or in part, without prior written permission from Cadence 
#  Design Systems, Inc.
#  
#////////////////////////////////////////////////////////////////////////*/

function OpenOpjSim(BookName, ChName,DesignFolderName,DesignName,SchematicName,PageName,ProfileName)
{
orPrmNativeCall("executeTcl", "::learningResources::openProjectSim "+ BookName + " " + ChName + " " +DesignFolderName + " " +DesignName + " " +SchematicName+ " " + PageName +" " +ProfileName);

}

function OpenOpj(BookName, ChName,DesignFolderName,DesignName,SchematicName,PageName)
{
orPrmNativeCall("executeTcl", "::learningResources::openProjectSim "+ BookName + " " + ChName + " " +DesignFolderName + " " +DesignName + " " +SchematicName+ " " + PageName);
}


function orPrmNativeCall(method, params)
{
var ret = "Tcl interface not available";
if(null !== window.external.orPrmWidgetId)
{
ret = window.external.orPrmConnector(method, params);
}
else
{
// perform processing without Tcl interface
}
return ret;
}


