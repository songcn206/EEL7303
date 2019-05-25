function orPrmIsHosted()
{
    var hosted = false;
    if(window.external)
    {
        hosted = (window.external.orPrmWidgetId != null);
    }
    return hosted;
}

function orPrmGetWidgetId()
{
    var widgetId = -1;
    if(orPrmIsHosted())
    {
        widgetId = window.external.orPrmWidgetId;
    }
    return widgetId;
}

function orPrmIsCanvasAware()
{
    return !!document.createElement('canvas').getContext;
}

function orPrmInitLayer()
{
    var scriptTags = document.getElementsByTagName("script");
    var currScriptSrc = scriptTags[scriptTags.length - 1].src;
    var currScriptDir = currScriptSrc.replace(/\/[^\/]*$/g, '');

    var scriptFileToLoad = null;
    if(orPrmIsHosted())
    {
        scriptFileToLoad = currScriptDir + '/orPrmJSHostedLayer.js';
    }
    else
    {
        scriptFileToLoad = currScriptDir + '/orPrmJSBrowserLayer.js';
    }

    var scriptTag = document.createElement('script');
    scriptTag.setAttribute('src', scriptFileToLoad);
    scriptTag.setAttribute('type', 'text/javascript');

    var scriptLoaded = false;
    scriptTag.onload = scriptTag.onreadystatechange = function()
    {
        if(!scriptLoaded
                && (!this.readyState || this.readyState == "loaded" || this.readyState == "complete"))
        {
            scriptLoaded = true;
            if(typeof(orPrmPostLoad) == typeof(Function))
            {
                orPrmPostLoad();
            }
        }
    };

    document.getElementsByTagName('head')[0].appendChild(scriptTag);
}

orPrmInitLayer();

