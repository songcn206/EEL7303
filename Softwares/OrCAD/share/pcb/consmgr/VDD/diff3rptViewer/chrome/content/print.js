var ppreview = 
{
    Initialize : function ()
    {
        content.location = window.arguments[0];
        document.fileToRemove = window.arguments[1];
    },
    
    OnPrint : function()
    {
        content.print();
        this.Close();
    },
    
    Close : function()
    {
        try { document.fileToRemove.remove(false); }
        catch(err)
        { ; }
        content.close();
    }
};
