var diff3rptViewer = 
{
    Initialize : function ()
    {
	    let cmdLine = window.arguments[0];
	    cmdLine = cmdLine.QueryInterface(Components.interfaces.nsICommandLine);
	    this.urlstr = cmdLine.handleFlagWithParam("file", false)
	    this.browser = document.getElementById("diff3report-html-browser");
	    this.browser.diff3rptViewer = this;
	    this.browser.setAttribute('src', this.urlstr);
	    this.browser.addEventListener("DOMContentLoaded", diff3rptViewer.OnDownloadComplete, true);
	    document.addEventListener("NavigationOccurredEvent", diff3rptViewer.OnNaviagionOcurred, true, true);
        this.reportTooltip = document.getElementById("diff3report-tooltip-in-report");
        this.fileUtils = new FileUtils();
    },
    
    OnClose : function()
    {
        if(this.urlstr.substring(this.urlstr.length - 4) == ".tmp")          // not a temp file - don't remove
            return;
        var file = new File(this.fileUtils.urlToPath(this.urlstr));
        try { file.remove(false); }
        catch(err)
        { alert("Failed to remove temp file: " + this.urlstr); }
    },
    
    OnNaviagionOcurred : function()
    {
        var browser = document.getElementById("diff3report-html-browser");
        document.getElementById("goBack-cmd").setAttribute('disabled', !browser.canGoBack);
        document.getElementById("goFwd-cmd").setAttribute('disabled', !browser.canGoForward);
    },
    
    OnDownloadComplete : function()
    {
        if(navigator.productSub == "2008070208")
            window.title = this.contentDocument.title;
        else
            document.getElementById("mainFrame").setAttribute('title', this.contentDocument.title);
    },

    OnSave : function ()
    {
        window.openDialog('chrome://diff3rptViewer/content/save.xul', 'saveDlg', 'chrome,modal,maximized', content.document);
    },

    OnPrint : function ()
    {
        this.contentDocURL = this.browser.currentURI;
        var originalcontent = this.readFileFromURL2String(this.contentDocURL.spec);
        if(originalcontent.match('treeview.xsl'))
        {
            var printcontent = originalcontent.replace('treeview.xsl','printable.xsl');
	        var uriqi = this.contentDocURL.QueryInterface(Components.interfaces.nsIFileURL);
            var printfile = this.writeFile(uriqi.file.path + '.print', printcontent);
            // open a new window with print view
            var printurl = this.browser.currentURI.spec;
            var end = printurl.indexOf('#');
	        if(end > 0)
	            printurl = printurl.substring(0,end) + '.print';
	        var opts = 'chrome,scrollbars,modal,close=0,width=' + (content.innerWidth-5) + ',height=' + (window.innerHeight-5);
            var printDocumentWnd = window.openDialog('chrome://diff3rptViewer/content/printPreview.xul', 'printPreview', opts, printurl, printfile);
            printDocumentWnd.focus();
        }
        else
            this.browser.contentWindow.print();
    },
    
    OnSelectAll : function ()
    {
        var elem = this.browser.contentDocument.getElementById("details");
        var copytext=this.browser.contentWindow.getSelection().selectAllChildren(elem);
    },

    OnCopy : function ()
    {
        var copytext = this.browser.contentWindow.getSelection().toString();
        var str = Components.classes["@mozilla.org/supports-string;1"].createInstance(Components.interfaces.nsISupportsString);
        str.data=copytext;
        
        var trans = Components.classes["@mozilla.org/widget/transferable;1"].createInstance(Components.interfaces.nsITransferable);
        trans.addDataFlavor("text/unicode");
        trans.setTransferData("text/unicode",str,copytext.length*2);        // length*2 because of unicode

        var clip = Components.classes["@mozilla.org/widget/clipboard;1"].getService(Components.interfaces.nsIClipboard);
              
        clip.emptyClipboard(clip.kGlobalClipboard);
        clip.setData(trans,null,clip.kGlobalClipboard);

    },

    readFileFromURL2String : function (urlstr)
    {
        // read content
        var file = new File(this.fileUtils.urlToPath(urlstr));
        file.open('r');
        var content = file.read();
        file.close();
        return(content);
    },

    writeFile : function (filePath, contentstr)
    {
        var f = new File(filePath);
        if(!f.exists())
            f.create();
        if(!f.isWritable())
        {
            alert("Error: Cannot write to file " + filePath);
            return;
        }
        f.open('w');
        f.write(contentstr);
        f.close();
        return(f);
    },
    
    OnShowTooltip: function(tipElement)             // handle tooltips
    {
        var retVal = false;

        var titleText = null;
        var XLinkTitleText = null;

        while (!titleText && !XLinkTitleText && tipElement)     // walk through the hierarchy until found a tooltip
        {
            if (tipElement.nodeType == Node.ELEMENT_NODE) 
            {
                titleText = tipElement.getAttribute("title");
                XLinkTitleText = tipElement.getAttributeNS("http://www.w3.org/1999/xlink", "title");
            }
            tipElement = tipElement.parentNode;
        }

        var texts = [titleText, XLinkTitleText];        // can be in either location

        for (var i = 0; i < texts.length; ++i)
        {
            var t = texts[i];
            if (t && t.search(/\S/) >= 0)
            {
                this.reportTooltip.setAttribute("label", t);
                retVal = true;
            }
        }

        return retVal;
    },
};

