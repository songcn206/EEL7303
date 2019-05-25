// the one and only viewer object
var oCDNOrPrimeViewer = null;

var CDNOrPrime = CDNOrPrime ||
{};

CDNOrPrime.Viewer = function()
{
    this.version = "0.1";
    this.streams = [];
    this.id = -1;
    this.xhr = null;
};

CDNOrPrime.Viewer.prototype.setTestMode = function(testMode)
{
    this.testMode = testMode;
};

CDNOrPrime.Viewer.prototype.getTestMode = function()
{
    return this.testMode;
};

CDNOrPrime.Viewer.prototype.getXHR = function()
{
    if(null == this.xhr)
    {
        this.xhr = new XMLHttpRequest();
    }
    return this.xhr;
};

CDNOrPrime.Viewer.prototype.getViewType = function()
{
    return this.viewType;
};

CDNOrPrime.Viewer.prototype.getStream = function(id)
{
    return this.streams[id];
};

CDNOrPrime.Viewer.prototype.setStream = function(id, stream)
{
    this.streams[id] = stream;
};

CDNOrPrime.Viewer.prototype.setType = function(type)
{
    this.viewType = type;
};

CDNOrPrime.Viewer.prototype.getStreamData = function(id, name)
{
    var ret = null;
    var stream = this.getStream(id);
    if(stream)
    {
        ret = stream[name];
    }

    return ret;
};

CDNOrPrime.Viewer.prototype.init = function()
{
    oCDNOrPrimeViewer = new CDNOrPrime.Viewer();
};

CDNOrPrime.Viewer.prototype.getSessionId = function()
{
    if(this.id == -1)
    {
        if(this.isHosted())
        {
            this.id = window.external.orPrmWidgetId;
        }
        else
        {
            this.id = 1;
        }
    }
    return this.id;
};

function getApp()
{
    return oCDNOrPrimeViewer;
}

function orPrmViewerSetData(divId, data)
{
    getApp().setStream(divId, data);
}

function orPrmViewerGetData(divId)
{
    return getApp().getStream(divId);
}

function orPrmGetFontHeight(fontStyle) 
{
    var body = document.getElementsByTagName("body")[0];
    var dummy = document.createElement("div");
    var dummyText = document.createTextNode("M");
    dummy.appendChild(dummyText);
    dummy.setAttribute("style", fontStyle);
    body.appendChild(dummy);
    var result = dummy.offsetHeight;
    body.removeChild(dummy);
    return result;
}

CDNOrPrime.Viewer.prototype.init();

