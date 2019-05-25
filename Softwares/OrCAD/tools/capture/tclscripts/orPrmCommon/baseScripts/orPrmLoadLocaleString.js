function orLoadLocalString(stringPath, stringSrc, stringName, uiSrc)
{	
   englishString = stringName;
   
   var lang = window.external.orPrmConnector("executeTcl", "capGetLanguagePack");
   
   if(lang != "ENU")
   {   
	   var JSAdd=document.createElement('script');
	   JSAdd.setAttribute('type', 'text/javascript');
	   var fileSrc=stringPath + "/" +  lang + "/" + stringSrc;
	   JSAdd.setAttribute('src', fileSrc);
	   document.getElementsByTagName('head')[0].appendChild(JSAdd);
   }
   else
   {
	   localString = stringName;
   }
   
   var JSAdd=document.createElement('script');
   JSAdd.setAttribute('type', 'text/javascript');
   JSAdd.setAttribute('src', uiSrc);
   document.getElementsByTagName('head')[0].appendChild(JSAdd);

}

