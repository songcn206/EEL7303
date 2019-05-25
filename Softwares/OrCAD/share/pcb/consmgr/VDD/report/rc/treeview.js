$(document).ready(eventManager);

function browserSpecificObj()
{
    try
    {
        this.notifyViewer = function(){}            // stub - needed only in the diff3rptViewer
        
	    if(navigator.appName == "Microsoft Internet Explorer")
	    {
		    this.setEvents = function()
		    {
			    $("a").click(function(e)
			    {
				    location = $(this).attr('href');
				    handleHashChange();
			    });
		    }
		    this.openSummary = handleHashChange;
		    this.getHeight = function()
		    { return($("body").height() - 50); }
	    }
	    else
	    {
		    this.setEvents = function(){}
		    this.openSummary = function(){}
		    this.getHeight = function()
		    { return(window.innerHeight - 20); }
		    if(("buildID" in navigator) && (navigator.buildID == "diff3rptViewer.16.6"))
		    {
		        this.notifyViewer = function()
		        {
	                var evt = document.createEvent("Events");
	                evt.initEvent("NavigationOccurredEvent", true, false);  
	                document.dispatchEvent(evt);
		        }
		    }
	    }
	}
	catch(err)
	{alert(err);}
}

var browserSpecific = new browserSpecificObj();

window.onresize = fixMainframe;
// set up go to anchor handlers
if ("onhashchange" in window)  // event supported?
    window.onhashchange = handleHashChange;
else
{ // event not supported:
    var storedHash = window.location.hash;
    window.setInterval(
		function ()
		{
			if (window.location.hash != storedHash)
			{
				storedHash = window.location.hash;
				handleHashChange();
			}
		}, 100);
}


function eventManager(e)
{
	fixMainframe();
	handleHashChange();
	
	// tree view management
	$(".treeview li").click(handleSelect);
	$(".treeview div.hitarea").click(handleExpandCollapse);
	// per layer attributes 
	$(".viewSelector td").click(handlePerLyrDisplay);
	
	browserSpecific.setEvents();

	// resizing mamangement
	var resizing = null;

	$("td.vsplitter").mousedown(function(e) 
	{
		resizing = new splitterObj($(this), true, e.pageX);
	});
	
	$("td.hsplitter").mousedown(function(e) 
	{
		resizing = new splitterObj($(this), false, e.pageY);
	});
	
	$(document).mousemove(function(e)
	{
		if(resizing != null)
		{
			resizing.resize(e.pageX, e.pageY);
		}
	});
	
	$(document).mouseup(function() {
		if(resizing != null) 
			resizing = null;
	});
}

function splitterObj(splitter, vertical, coord)
{
	var paneID = splitter.attr("ppane");
	this.ppane = $("#" + paneID);
	this.pcontent = $("#" + paneID + " div.paneCont");
	paneID = splitter.attr("npane");
	this.npane = $("#" + paneID);
	this.ncontent = $("#" + paneID + " div.paneCont");
	if(vertical)
	{
		this.PstartSize = this.ppane.width();
		this.NstartSize = this.npane.width();
	}
	else
	{
		this.PstartSize = this.ppane.height();
		this.NstartSize = this.npane.height();
	}
	this.start = coord;
	this.vertical = vertical;
	
	this.resize = function(X, Y)
	{
		if(this.vertical)
		{
			var delta = X - this.start;
			this.pcontent.width(this.PstartSize + delta);
			this.ppane.width(this.PstartSize + delta);
			this.ncontent.width(this.NstartSize - delta);
			this.npane.width(this.NstartSize - delta);
		}
		else
		{
			var delta = Y - this.start;
			this.pcontent.height(this.PstartSize + delta);
			this.ppane.height(this.PstartSize + delta);
			this.ncontent.height(this.NstartSize - delta);
			this.npane.height(this.NstartSize - delta);
		}
	}
}

function handlePerLyrDisplay()
{
	var td = $(this).get(0);
	var clsName = td.className;
	var parent = td.parentNode.parentNode.parentNode.parentNode; 	// <parent>/table/tbody/tr/td - whoever has viewSelector
	if(parent.nodeName.toLowerCase() == "td")			// for one
		var target = $("#" + parent.id);
	else												// for all
		var target = $("#" + parent.id + " .nonScalarDiff");
		
	var PerLyrClsNames = {S:"showStat", D:"showDiff", A:"showAll"};
	
	for(cls in PerLyrClsNames)
	{
		if(cls == clsName)
			target.addClass(PerLyrClsNames[cls]);
		else
			target.removeClass(PerLyrClsNames[cls]);
	}
	
	return(false);
}

function handleExpandCollapse()
{
	var id = $(this).attr("id");
	id = id.replace("-hitarea", "");	
	doExpandCollapse(id);
	return(false);
}

function handleSelect()
{
	var id = $(this).attr("id");
	openSummary(id);
	selectTreeNode(id);
	return(false);
}

function doExpandCollapse(id)
{
	var li = $("li#" + id);
	li.toggleClass("collapsed");
	li.toggleClass("expanded");
}

function selectTreeNode(id)
{
	if(id.substring(0,1) != "#")
		id = "#" + id;
		
	$(".treeview span.selected").removeClass("selected");
	var TVnameNode = $("li" + id + " span:eq(0)");
	TVnameNode.addClass("selected");
	
	var ul = TVnameNode.get(0);		// for the first time ul is a span (name node), whose parent is li
	var li;	
	do
	{
		li = ul.parentNode;
		if(li.className.search("collapsed") >= 0)
			doExpandCollapse(li.id);
		ul = li.parentNode;
	}while(ul.nodeName.toLowerCase() == "ul");
}

function openSummary(id)
{
	location.hash = "#" + id;
	browserSpecific.openSummary();
}

function handleHashChange()
{
	if(location.hash.length == 0)
	{
		location.hash = "#mainSummary";
	}
	
	$("div#hidden-cashe").append($("td#details.pane div.paneCont").children());
	$("td#details.pane div.paneCont").append($("div#hidden-cashe div" + location.hash + "-cashe"));
	selectTreeNode(location.hash);
	
	browserSpecific.notifyViewer();
}

function fixMainframe()
{
	var H = browserSpecific.getHeight();
	$("tr#mainRow div.paneCont").height(H);
	$("tr#mainRow").height(H);
}
