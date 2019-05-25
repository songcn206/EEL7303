var saveDlg =
{
    Initialize : function()
    {
        document.helper = new saveHelper();
    }
};

function saveHelper()
{
    this.doc = window.arguments[0];
    this.fileUtils = new FileUtils();
    this.rptDir = Components.classes["@mozilla.org/file/directory_service;1"]
                        .getService(Components.interfaces.nsIDirectoryServiceProvider)
                        .getFile("CurWorkD",{});
    this.tbRptDir = document.getElementById('tb-dir');
    this.tbName = document.getElementById('tb-name');
    this.cmdOK = document.getElementById('cmd-OK');
    ////////////////////////////////// initializations ///
    this.tbRptDir.value = this.rptDir.path;
    
    ////////////////////////////////// event handlers /////////////////////////
    this.OnOK = function() 
    {
        try
        {
            if(!this.CreateRptFolder())
                return;
            this.CopyRc();
            this.WriteHTML();
        }
        catch(err)
        { alert("Failed to export report. Error details:\n" + err); }
        window.close();
    }
    
    this.OnCancel = function() 
    { window.close(); }
    
    this.OnNameChg = function() 
    {
        if(this.tbName.value.length > 0)
            this.cmdOK.setAttribute('disabled', false);
        else
            this.cmdOK.setAttribute('disabled', true);          
    }
    
    this.OnDirChg = function()
    {
        var dir = Components.classes["@mozilla.org/file/local;1"].createInstance(Components.interfaces.nsILocalFile);  
        dir.initWithPath(this.tbRptDir.value);
	    
	    if(dir.exists() && dir.isDirectory())
	        this.rptDir = dir;
	    else
	    {
	        alert("The directory " + this.tbRptDir.value + " does not exist...");
	        this.tbRptDir.value = this.rptDir.path;
	    }
    }
    
    this.OnBrowse = function()
    {
	    // create a file picker dialog
        var nsIFilePicker = Components.interfaces.nsIFilePicker;
	    var fp = Components.classes["@mozilla.org/filepicker;1"].createInstance(nsIFilePicker);
    	
	    // initialize the file picker dialog
	    fp.init(window, "Select a folder to place the report", nsIFilePicker.modeGetFolder);
	    // set initial directory
	    fp.displayDirectory = this.rptDir;

	    var res= fp.show();
	    if (res == nsIFilePicker.returnOK)
	    {
	        this.rptDir = fp.file;
	        this.tbRptDir.value = fp.file.path;
	    }
    }
    
    //////////////////////////////// methods ///////////////////////////////////
    
    this.CreateRptFolder = function()
    {
        this.outputDir = new Dir(this.tbRptDir.value);
        this.outputDir.append(this.tbName.value);
        
        if(this.outputDir.exists())
        {
            alert("Directory " + this.outputDir.path + " already exists, please specify a different name");
            return(false);
        }
            
        this.outputDir.create(0777);
        // safety check
        if(!this.outputDir.exists() || !this.outputDir.isDir())  
        {
            alert("Failed to create a directory " + this.outputDir.path);
            return(false);
        }
        
        return(true);
    }
    
    this.WriteHTML = function()
    {
        var path = this.fileUtils.append(this.outputDir.path, "report.html");
        var file = new File(path);
        file.create();
        if(!file.isWritable())
            throw("Cannot write to " + file.path);

        file.open("w");
        file.write(this.GetReportContent());
        file.close();
    }
    
    this.GetReportContent = function()
    {
        let s = new XMLSerializer();
	    var copy = this.doc.documentElement.cloneNode(true);
	    let string = s.serializeToString(copy);
	    string = string.replace(/file:[/]+([^ /\"<>]+\/)+/g, "rc/");
	    return(string);
    }
    
    this.CopyRc = function()
    {
        // get rc URL as string
	    var scripts = this.doc.getElementsByTagName("script");
	    var src = scripts[0].getAttribute("src");
	    var rcDirUrl = src.match(/file:[/]+([^/]+\/)+/g);
	    
	    var rcDir = new Dir(this.fileUtils.urlToPath(rcDirUrl));
	    rcDir.nsIFile.copyTo(this.outputDir.nsIFile, "");
    }
}