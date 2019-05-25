// Copyright 2012 Cadence Design Systems, Inc. All rights reserved worldwide.

function orPrmResponseExtractor(xhr)
{
    var ret = null;
    if(xhr.responseText != "")
    {
        ret = JSON.parse(xhr.responseText);
    }
    return ret;
}

function orPrmServerCall(xhr, params, responseProcessor, isAsync)
{
    if(xhr != null)
    {
        var url = orPrmGetServerBase();
        xhr.open("POST", url, isAsync);

        if(isAsync)
        {
            xhr.onreadystatechange = responseProcessor;
        }
        
        xhr.send(params);
        
        if(!isAsync)
        {
            eval(responseProcessor);
        }
    }
}

function orPrmNativeCall(method, params, callback, xhr)
{
    var httpParams = "methodLabel=" + escape(method) + "&methodParams="
            + params;
    orPrmServerCall(xhr, httpParams, callback, true);
}

