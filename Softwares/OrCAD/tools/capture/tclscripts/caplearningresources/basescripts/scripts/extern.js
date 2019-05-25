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