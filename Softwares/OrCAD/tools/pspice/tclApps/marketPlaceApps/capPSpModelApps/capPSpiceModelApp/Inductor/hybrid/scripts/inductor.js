
var SYM = "";
var ModelText="";
var ModelName="";
var RefDes="MyIndModel";
var type = "" ;
var mode = "" ;
var JsData = "JsData" ;
var l_type = "";
function StartUp(){

SelectType();
EnableButtons(mode);


 
 
 
if (type == "IND_R") 
 
 {
 l_type = "IND_R";
 type ="IND";
 /*document.getElementById('XX').style.display="block";
document.getElementById('XX_V').style.display="inline";
document.getElementById("Img3").src = './Images/ind_par_sch.png'*/

Set_Input('XX',1,'./Images/ind_par_sch.png','XX_V');

 
 }
 else if(type == "IND" || type == "all")
 {
type ="IND";
l_type = "IND";

}

ModelJsData=Read_InputData();
 







document.getElementById("gmod").name=type;



if (mode!="startup" ){

GetInductorDataInUi(type);
}else {


 _SeedJSDataInUI(type,0);

    var NewModelName = "MyIndModel_" + type.toUpperCase();

    document.getElementById(type).Name.value = NewModelName;
}




}




function Set_Input(id,sel,img,pres) {
   
if (sel=="1"){
document.getElementById(id).style.display="block";
document.getElementById(pres).style.display="inline";
document.getElementById("Img3").src = img;


}
if (sel=="0"){
document.getElementById(id).style.display="none";
document.getElementById(pres).style.display="none";
document.getElementById("Img3").src = img;

}
return true;

}






function Gen_Model_ind (type){



var len = document.getElementById(type).length;

for (i=0;i<len;i++)
{
                   

        
        
        
        if ((document.getElementById(type).elements[i].style.display != "none") && (document.getElementById(type).elements[i].type == "text") )
        {
         if(document.getElementById(type).elements[i].name == "Name")
                    {
                    var Cname = document.getElementById(type).elements[i].value;
                    res = namecheck(Cname);
                    }


        else if (document.getElementById(type).elements[i].name == "res"){
        res = verify_value(document.getElementById(type).elements[i].value,document.getElementById(type).elements[i].name,1,undefined);
    
      }  
      else {
      res = verify_value(document.getElementById(type).elements[i].value,document.getElementById(type).elements[i].name,0,undefined);
      }
      
        if (typeof(res) == "boolean"   )

                {
                        return false;
                            
                 }
        }


}

	
	if (document.getElementById('WOR').checked)
	
	{
	
	var A=new Array(3);
var pi = Math.PI;




	
	ver_L_IND = verify_value(document.getElementById(type).ind.value,"L_IND",0,undefined);
	
	           
	p2PieSrf = 2*pi*(verify_value(document.getElementById(type).srf.value,"SRF",0,undefined));
	
	sq_2PieSrf= Math.pow(p2PieSrf,2);
	val= sq_2PieSrf*ver_L_IND;
	val1 = (verify_value(document.getElementById(type).rdc.value,"RDC",0,undefined))*p2PieSrf;
	//val1= p2PieSrf*(verify_value(document.getElementById(type).qfac.value,"qfac",0,undefined))*(verify_value(document.getElementById(type).rdc.value,"RDC",0,undefined))

	val2=val+val1;
    
	cp=1/val2;
	
cp = cp.toPrecision(5);
   
A[0] = ".SUBCKT " + document.getElementById(type).Name.value + " P1 P2 " + "\n";
A[1] = "RDC P1 PI " + document.getElementById(type).rdc.value;
A[2] = "L_IND PI P2 " + document.getElementById(type).ind.value;
A[3] = "CP P1 P2 " + cp;
A[4] = ".ends " + document.getElementById(type).Name.value +"\n";
A[5] = "\n";


 SYM = "IND";

ModelName = document.getElementById(type).Name.value;

ModelText = Gen_Subckt_ind(A,5,SYM);
	
	Write_Model();
	
	}
	
	
	
	
	
	
	
	if (document.getElementById('WR').checked){
    A=new Array(4);
    pi = Math.PI;

	
	
	ver_L_IND = verify_value(document.getElementById(type).ind.value,"L_IND",0,undefined);
	
	           
	p2PieSrf = 2*pi*(verify_value(document.getElementById(type).srf.value,"SRF",0,undefined));
	
	sq_2PieSrf= Math.pow(p2PieSrf,2);
	val= sq_2PieSrf*ver_L_IND;
	val1 = (verify_value(document.getElementById(type).rdc.value,"RDC",0,undefined))*p2PieSrf;
	//val1= p2PieSrf*(verify_value(document.getElementById(type).qfac.value,"qfac",0,undefined))*(verify_value(document.getElementById(type).rdc.value,"RDC",0,undefined))

	val2=val+val1;
    
	cp=1/val2;
	
	cp = cp.toPrecision(5);
   

A[0] = ".SUBCKT " + document.getElementById(type).Name.value + " P1 P2" + "\n";
A[1] = "RDC P1 PI " + document.getElementById(type).rdc.value ;
A[2] = "L_IND PI P2 " + document.getElementById(type).ind.value;
A[3] = "CP P1 P2 " + cp;
A[4] = "RP P1 P2 " + document.getElementById(type).res.value;
A[5] = ".ends " + document.getElementById(type).Name.value +"\n";
A[6] = "\n";


SYM = "IND_R";

ModelName = document.getElementById(type).Name.value;

ModelText = Gen_Subckt_ind(A,6,SYM);

Write_Model();
}   
	
	
	
	
	
	
	
	
	
	 RefDes=document.getElementById(type).Name.value;
 var Status=0;

 if (mode == "startup")
 
 {
   RefDes=document.getElementById(type).Name.value;
      Status=UpdateInductorData(type);
    if (Status==1){
	Write_Model();
	Place_Part(SYM);	
	}   
 }
 else
{

Status=UpdateInductorData("IND");
	if (Status==1){
		Write_Model();
        Close_View();}
    
}




return true;
}


   
//Start of Subckt function
function Gen_Subckt_ind(A,n,Sname){
//A is string array with individual model component values
//type is form id, which also indicated the transformer
//n is number of element in sub circuit, this control element in array A

subtxt = Header(Sname);



for (i=0;i<=n;i++)
{
subtxt= subtxt + A[i] + "\n";
}



document.getElementById('subckt').style.display="block";
document.forms['subckt'].elements['subckt_textarea'].value = subtxt;


return subtxt;
}

function Close_View(){
orPrmNativeCall("executeTcl", "MenuCommand \"57927\"");
}




function EnableButtons(mode) {
if (mode != "startup"){

document.getElementById('rs').style.display="none";
document.getElementById('gmod').value="Update";
}else {

document.getElementById('rs').style.display="block";
document.getElementById('gmod').value="Place";
}


}




function _SeedJSDataInUI(type,X)

{


    document.getElementById(type).Name.value =  ModelJsData.Inductor[X].Name;
    document.getElementById(type).ind.value =  ModelJsData.Inductor[X].ind;
    document.getElementById(type).rdc.value =  ModelJsData.Inductor[X].rdc;
    //document.getElementById(type).qfac.value =  ModelJsData.Inductor[X].qfac;
    document.getElementById(type).srf.value =  ModelJsData.Inductor[X].srf;
    document.getElementById(type).res.value =  ModelJsData.Inductor[X].res;

if (mode!="startup"){
	if (ModelJsData.Inductor[X].Type  == "IND" && l_type == "IND"){
	document.getElementById('WOR').checked = true;//Select radio for IND,
	document.getElementById('WR').disabled = true;//Disable INDR radio
	
	}
	else /*if (ModelJsData.Inductor[X].Type  == "IND_R")*/{
	//alert("pind")
	document.getElementById('WOR').disabled = true; //Select radio for IND,
	document.getElementById('WR').checked = true;//Disable INDR radio
	}
	}

}


function _GetUIDataInJS(type,X)

{

    ModelJsData.Inductor[X].Name = document.getElementById(type).Name.value;
    ModelJsData.Inductor[X].ind  = document.getElementById(type).ind.value;
    ModelJsData.Inductor[X].rdc  = document.getElementById(type).rdc.value;
    //ModelJsData.Inductor[X].qfac  = document.getElementById(type).qfac.value; 
    ModelJsData.Inductor[X].srf = document.getElementById(type).srf.value;
    ModelJsData.Inductor[X].res  = document.getElementById(type).res.value;
	
	
	if(document.getElementById('WOR').checked)
	{//alert("wor")
	ModelJsData.Inductor[X].Type  = "IND";
	}
	else 
	{//alert("wr")
	ModelJsData.Inductor[X].Type  = "IND_R";

    }
    
}




function UpdateInductorData(type) { 
var ltype=type;
var X=1;
var UpdateS=0;
var Duplicate=0;

if ((ModelJsData.Inductor.length > 1) && (mode=="startup")){
		//alert("Startup, Case 2.1");
	for (X=1;X<=ModelJsData.Inductor.length-1;X++){
	    if (((ModelJsData.Inductor[X].Name).toUpperCase() == (document.getElementById(type).Name.value).toUpperCase())){
	    	    if (confirm("Model with same name already exists, Click OK to overwrite it, Cancel to Save with different name?")){
		_GetUIDataInJS(type,X);
		UpdateS=1;
		break;} else{
	    UpdateS = 0;
	    Duplicate=1;
	    break;
	    }
    }
    }
    
    if ((Duplicate===0)&& (UpdateS === 0)) { 
    
		  NewRec = {"Name":document.getElementById(type).Name.value, "Type": ltype.toUpperCase(),"ind": "100u","rdc": "10m","qfac": "33","srf": "2Meg","res": "100Meg"};
            ModelJsData.Inductor.push(NewRec);
            X = ModelJsData.Inductor.length -1;
            _GetUIDataInJS(type,X);
            UpdateS=1;
    }
}
if ((mode!="startup" )&& (ModelJsData.Inductor.length >1) ){
		//alert("Update, Case 2.1");
	for (X=1;X<=ModelJsData.Inductor.length-1;X++){
	    if (((ModelJsData.Inductor[X].Name).toUpperCase() == (document.getElementById(type).Name.value).toUpperCase()) && ((ModelJsData.Inductor[X].Type).toUpperCase() == l_type.toUpperCase())){
	    _GetUIDataInJS(type,X);
	    UpdateS = 1 ;
	    break;
    	}
	else if (((ModelJsData.Inductor[X].Name).toUpperCase() == (document.getElementById(type).Name.value).toUpperCase()) && ((ModelJsData.Inductor[X].Type).toUpperCase() != l_type.toUpperCase())){
			//alert("update, Case 2.2");
	    if (confirm("Model with same Name but of different Type is present, Click OK to overwrite it, Cancel to Save with different name?")){
		ModelJsData.Inductor[X].Type=ltype.toUpperCase();
		_GetUIDataInJS(type,X);
        UpdateS=1;
		break;
	    }else{
	    UpdateS = 0 ;
	    Duplicate=1;
	    break;}
    }}}
if (mode!="startup" && UpdateS===0 && Duplicate===0){
   		//alert("Update, Case 3");
    NewRec = {"Name":document.getElementById(type).Name.value, "Type": ltype.toUpperCase(),"ind": "100u","rdc": "10m","qfac": "33","srf": "2Meg","res": "100Meg"};
            ModelJsData.Inductor.push(NewRec);
            X = ModelJsData.Inductor.length -1;
            _GetUIDataInJS(type,X);
            UpdateS=1;
            }
if ((mode!="startup" )&& (ModelJsData.Inductor.length==1) ){
		//alert("Update, Case 1");
	alert("Model data missing, Initializing to default values");
	NewRec = {"Name":document.getElementById(type).Name.value, "Type": ltype.toUpperCase(),"ind": "100u","rdc": "10m","qfac": "33","srf": "2Meg","res": "100Meg"};
            ModelJsData.Inductor.push(NewRec);
            X = ModelJsData.Inductor.length -1;
            _GetUIDataInJS(type,X); 
            UpdateS=1;
	}
if ((ModelJsData.Inductor.length==1) && (mode=="startup")){
		//alert("Startup, Case 1")	;
            var NewRec = {"Name":document.getElementById(type).Name.value, "Type": ltype.toUpperCase(),"ind": "100u","rdc": "10m","qfac": "33","srf": "2Meg","res": "100Meg"};
            ModelJsData.Inductor.push(NewRec);
            X = ModelJsData.Inductor.length -1;
            _GetUIDataInJS(type,X);
            UpdateS=1;
 }
            
    
if (UpdateS==1){      
var updatedModel = JSON.stringify(ModelJsData);
Write_InputData(updatedModel);
}
return UpdateS;
}





function GetInductorDataInUi(type) {

var X=1;
var ModelFound = 0;
if (ModelJsData.Inductor.length>1){

for (X in ModelJsData.Inductor)
{    if (((ModelJsData.Inductor[X].Name).toUpperCase() == (RefDes).toUpperCase()&&( ModelJsData.Inductor[X].Type).toUpperCase() == l_type.toUpperCase())){
        _SeedJSDataInUI( type,X);
    ModelFound = 1;
    break;   
   }
}
} 

if (ModelFound === 0){
 
	 _SeedJSDataInUI(type, 0);
  	  var NewModelName = "MyIndModel_" + type.toUpperCase();
	  alert("Model Data Not Found, Initializing to Default values");
    	document.getElementById(type).Name.value = NewModelName;
}


}

