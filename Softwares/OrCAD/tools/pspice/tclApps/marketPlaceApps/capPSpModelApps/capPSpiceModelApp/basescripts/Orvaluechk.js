// JScript source code
     function verify_value(str, name,MIN, MAX)   {
        //var unit = ""
        // Suppose the value is 10k
       /* var len1 = str.length   // 3
        var val= Number(parseFloat(str))   // 10
        var val1 = val.toString() //10
        
        if (isNaN(val1))
        {
            alert("Please enter numeric value in " + name)
            return false;
        }
       
        var len2 = val1.length   // 3
     
        if (len1 != len2)
        {
            var unit_len = eval(len1 - len2)    // 1
            var unit = str.slice(-unit_len) // k
            
        }*/
        
        
        
        
  /////////////////////////////////////////new Function    (start)  
var unit = "";
  
var len = str.length;



var ki = $.trim(str);

           

lenval = ki.length;
      

var cnt=0;


for(j=lenval-1;j>-1;j--)
{

if(isNaN(ki.charAt(j)) && (ki.charAt(j)!= "."))

{

cnt=cnt+1;
continue;
}
else
{
break;
}


}        
   
  str1 = ki.substring(0,lenval-cnt);     //value
   str2 = ki.substring(lenval,lenval-cnt);   //unit
   
        if (str2 !== "" )
         {
                
                unit  = str2;
              
                
          }    
        

          if (isNaN(str1) || str1 === "" )
             {
               
                alert("Enter a numeric value for "+name);
                return false;
                
                }
                
    
         
         var len5 = str1.length;
       
         Tstr1 = $.trim( str1);
       
         len6 = Tstr1.length;
         
         
             
         if(len5!=len6)
         {
         alert("Remove space between Magnitude and Unit for " + name);
         return false;
         }
         
         
         var f =0;
         for(k=0;k<len;k++)
         {
                            if(str.charAt(k)== " ")
                {
                            f =f+1;
                            continue;
                }
                            else
                    {
                            break;
                      }

           }
         
         if(f >=1)
         {
         alert("Remove extra spaces before the data for " + name );
         
         return false;
         }

      
        if (unit !== "")
        {
        
        
           var nResult = verify_unit(unit); 
           if (nResult === false)
            {
               alert("correct the unit in "+ name );
               return false;
            }
           else
           {
           //alert("in")
               nResult1 = eng_conv(unit);
               nResult1=str1*parseFloat(nResult1);
               nResult1=nResult1.toPrecision(4);
               var ft = range_chk(nResult1,MIN,MAX);
             //alert(ft)
             if (ft === true)
             {
               return nResult1;
              }
              
              else
              {
              return false;
              }
              
           }
        }
        else
        {
            nResult1=parseFloat(str1);
            ft =range_chk(nResult1,MIN,MAX);
            //alert(ft)
             
             if (ft === true)
             {
               return nResult1;
              }
              
              else
              {
              return false;
              }
            
            
        }
        
        
    }
    function verify_unit(unit_name)
    {
        unit_name = unit_name.toLowerCase();

        if (unit_name == "f" || unit_name == "p" || unit_name == "n" || unit_name == "u" || unit_name == "m" || unit_name == "k" || unit_name == "M" || unit_name == "g" || unit_name == "t" || unit_name == "meg" ||unit_name=="%" )
        {
            return true;
         }
         else
         {
         return false;
         }
          
    }
 function eng_conv(str)
    {
        
        str = str.toLowerCase();
        if (str == "meg")
        {
            unit = 1000000;
            return unit;
        }
        else if (str == "f" )
        {
            unit = 0.000000000000001;
            return unit;
        }
        else if (str == "p" )
        {
            unit = 0.000000000001;
            return unit;
        } 
        else if (str == "n" )
        {
            unit = 0.000000001;
            return unit;
        }
        else if (str == "u" )
        {
            unit = 0.000001;
            return unit;
        }
        else if (str == "m")
        {
            unit = 0.001;
            return unit;
        }
        else if (str == "k" )
        {
            unit = 1000;
            return unit;
        }
        else if (str == "g" )
        {
            unit = 1000000000;
            return unit;
        }
        else if (str == "t" )
        {
            unit = 1000000000000;
            return unit;
        }
    }

 function range_chk(num,MIN, MAX)
    {
       //alert(num + " " + MIN + " " + MAX)
    //if (num != ""){
        
        if(MIN !=undefined && MAX !=undefined){
            if(num < parseFloat(MIN) || num > parseFloat(MAX))
                    {   alert("Input is out of range. Value should be in range of " + MIN + " to " + MAX); 
                
                  return false;      
                   }
                        
                 }
        else if (MAX !=undefined ) 
            {       
                if(num > parseFloat(MAX)) 
                {       alert("Input is out of range. Value should be < " + MAX);  
                return false;       
                }
                
            }
        else if (MIN !=undefined ) { 
                if(num < parseFloat(MIN)) 
            {       alert("Input is out of range. Value should be > " + MIN);
             return false; 
             }
            
            }
//        }
   return true;
   } 


function namecheck(Dname) {

if((Dname).indexOf(' ') > -1)
{	alert("Remove spaces from Model Name");
	return false; 

} 
else if (Dname == "") {

	alert("Provide Model Name");
	return false; 
}
	
else { return Dname ; } 
}