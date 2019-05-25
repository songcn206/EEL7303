// Copyright 2012 Cadence Design Systems, Inc. All rights reserved worldwide.
function CDNOrPrmDebugger()
{
    this.enabled = false;
    this.id = "default";
    this.loggerPresent = false;
    this.loggerPresenceChecked = false;
}

CDNOrPrmDebugger.prototype.isEnabled = function()
{
    return this.enabled;
};

CDNOrPrmDebugger.prototype.enable = function()
{
    this.enabled = true;
};

CDNOrPrmDebugger.prototype.disable = function()
{
    this.enabled = false;
};

CDNOrPrmDebugger.prototype.getId = function()
{
    return this.id;
};

CDNOrPrmDebugger.prototype.log = function(msg)
{
    if(!this.enabled)
    {
        return;
    }

    if(!this.loggerPresenceChecked)
    {
        if((typeof console != 'undefined') && (typeof console.log != 'undefined'))
        {
            this.loggerPresent = true;
        }
        this.loggerPresenceChecked = true;
    }

    if(this.loggerPresent)
    {
        console.log(msg);
    }
};

var oPrmDbg = null;

function orPrmDebugger()
{
    if(oPrmDbg == null)
    {
        oPrmDbg = new CDNOrPrmDebugger();
    }
    return oPrmDbg;
}

