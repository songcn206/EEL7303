// JScript source code
var SYM = "";
var ModelText="";
var ModelName="" ;
var RefDes="MyTrModel" ;
var type = "all" ;
var mode = "" ;
var JsData = "JsData" ;
function StartUp(){
SelectType();
EnableButtons(mode);
/*
if (mode != "startup"){
document.getElementById('choice').style.display="none";
document.getElementById('rs').style.display="none";
document.getElementById('gmod').value="Update";
}
*/

ModelJsData=Read_InputData();

//var NewM = {"Name":RefDes , "Type":type, "LP1": "1m", "RP1": "10m", "RS1": "10m", "Couplig":"1", "TRaio":"3" , "WDGNO":"12"}


LoadTransformerGui(type);
}

function LoadTransformerGui(type){
EnableButtons(mode);
var TAP_MODE="S";
//Extract the TAP Winding from the part name
if (type=="CUTAPP" || type=="CUTAPS" || type=="CETAPP" ||type=="CETAPS" ){
SYM=type;
var temp_type=type;
TAP_MODE=temp_type.slice(-1);
type= type.slice(0,-1);

}
else if (type=="CUTAP"){
document.getElementById('CUTAPS').checked=true ;
SYM="CUTAPS";
}
else if (type=="CETAP" ){
document.getElementById('CETAPS').checked=true ;
SYM="CETAPS";
} else if (type == "FWD" || type =="FWDR") {
var WDG_TYPE = type;
SYM=type
type="FWD"
}
else {
SYM=type;

}


type="F"+type;
var form_view = new Array("FST","FMWT","FCUTAP","FCETAP","FFLB","FFWD");
var X;

document.forms['subckt'].style.display="none";

if (type != "Fall"){
document.getElementById('all').style.display="none" ;
for (X in form_view)
{document.getElementById(form_view[X]).style.display="none" ;   }

document.getElementById(type).style.display="block";

if (type=="FFWD"){
			if (mode == "startup") {
			document.getElementById('WOR').checked=true ;
            document.getElementById("XX").style.display="none";
			} else { 
			if (WDG_TYPE == "FWD"){ 
			document.getElementById('WOR').checked=true;
			SYM="FWD" ;
			document.getElementById('WR').disabled=true;
			} else if (WDG_TYPE == "FWDR"){ 
			document.getElementById('WR').checked=true ;
			SYM="FWDR" ;
			document.getElementById('WOR').disabled=true;
			}
                }
			}	
//Select the tap winding based on command line argument 
if (type=="FCETAP" || type=="FCUTAP"){
            if (TAP_MODE=="S"){           
            document.getElementById('CETAPS').checked=true ;
            document.getElementById('CUTAPS').checked=true ;
            if (mode != "startup"){ 
            document.getElementById('CETAPP').disabled=true ;
            document.getElementById('CUTAPP').disabled=true ;
            }
            
            }
            else if (TAP_MODE=="P"){           
            document.getElementById('CETAPP').checked=true ;
            document.getElementById('CUTAPP').checked=true ;
            if (mode != "startup"){ 
            document.getElementById('CETAPS').disabled=true ;
            document.getElementById('CUTAPS').disabled=true ;
            }
            }
            else{alert("Wrong Winding Selection of TAP, Please select primary or secondary");
            }
                }

document.getElementById("gmod").style.display="block";
//document.getElementById("ppart").style.display="block"
//This line set the selection of respective module of code to be executed based on selected type
document.getElementById("gmod").name=type;
//ModelJsData=Read_InputData()

if (mode!="startup" ){
GetTransformerDataInUi(type, SYM);
}else {
 _SeedJSDataInUI(type, 0);
    var NewModelName = "MyTrModel_" + type.slice(1).toUpperCase();
    document.getElementById(type).Name.value = NewModelName;
}
}

return true;
}


function Gen_Model(type){


// Start of Single Phase Transfomer
if(type=="FST"){
var A=new Array(7);
var unit_n1=verify_value(document.getElementById(type).LP.value,"LP",0,undefined);
var unit_ratio=verify_value(document.getElementById(type).T_Ratio.value,"T_ratio",0,undefined);
var N2= (parseFloat(unit_n1)*parseFloat(unit_ratio)*parseFloat(unit_ratio)).toPrecision(4);
A[0] = ".SUBCKT " + document.getElementById(type).Name.value + " P1 P2 S1 S2" + "\n";
A[1] = "LP1 PI P2 " + document.getElementById(type).LP.value ;
A[2] = "LS1 SI S2 " + N2 ;//parseFloat(document.getElementById(type).LP.value)*parseFloat(document.getElementById(type).T_Ratio.value)*parseFloat(document.getElementById(type).T_Ratio.value)
A[3] = "RP1 P1 PI " + document.getElementById(type).Rp1.value;
A[4] = "RS1 S1 SI " + document.getElementById(type).Rs1.value;
A[5] = "K1 LP1 LS1 " + document.getElementById(type).Coupling.value;
A[6] = "RG1 S2 0 " + "1G";
A[7] = ".ends " + document.getElementById(type).Name.value +"\n";
ModelName=document.getElementById(type).Name.value;
ModelText=Gen_Subckt(A,type,7);

}

// End of Single Phase Transfomer

// Start of Single Phase Centre TAP Transfomer
if(type=="FCETAP"){

if (document.getElementById('CETAPS').checked){

unit_n1=verify_value(document.getElementById(type).LP.value,"LP",undefined,undefined);
unit_ratio=verify_value(document.getElementById(type).T_Ratio.value,"T_Ratio",undefined,undefined);
N2= (parseFloat(unit_n1)*parseFloat(unit_ratio)*parseFloat(unit_ratio)*0.5).toPrecision(4);
//var N2 = parseFloat(document.getElementById(type).LP.value)*parseFloat(document.getElementById(type).T_Ratio.value)*parseFloat(document.getElementById(type).T_Ratio.value)/2;

var R2=parseFloat(verify_value(document.getElementById(type).Rs1.value,"Rs1",undefined,undefined))*0.5;
//var R2 = parseFloat(document.getElementById(type).Rs1.value)/2;


A=new Array(9);
A[0] = ".SUBCKT " + document.getElementById(type).Name.value + " P1 P2 S1 SC S2" + "\n";
A[1] = "LP1 PI P2 " + document.getElementById(type).LP.value ;
A[2] = "RP1 P1 PI " + document.getElementById(type).Rp1.value;
A[3] = "LS1 SI1 SC " + N2;
A[4] = "RS1 S1 SI1 " + R2;
A[5] = "LS2 SI2 SC " + N2;
A[6] = "RS2 SI2 S2 " + R2;
A[7] = "K1 LP1 LS1 LS2 " + document.getElementById(type).Coupling.value;
A[8] = "RG1 SC 0 " + "1G";
A[9] = ".ends " + document.getElementById(type).Name.value +"\n";
ModelName=document.getElementById(type).Name.value;
ModelText=Gen_Subckt(A,type,9);
}
if (document.getElementById('CETAPP').checked){
unit_n1=verify_value(document.getElementById(type).LP.value,"LP",undefined,undefined);
unit_ratio=verify_value(document.getElementById(type).T_Ratio.value,"T_ratio",undefined,undefined);
N2= (parseFloat(unit_n1)*parseFloat(unit_ratio)*parseFloat(unit_ratio)*0.5).toPrecision(4);

//var N2 = parseFloat(document.getElementById(type).LP.value)*parseFloat(document.getElementById(type).T_Ratio.value)*parseFloat(document.getElementById(type).T_Ratio.value)/2;
R1=parseFloat(verify_value(document.getElementById(type).Rp1.value,"Rp1",undefined,undefined))*0.5;
//var R1 = parseFloat(document.getElementById(type).Rp1.value)/2;
A=new Array(9);
A[0] = ".SUBCKT " + document.getElementById(type).Name.value + " P1 PC P2 S1 S2" + "\n";
A[1] = "RP1 P1 PI1 " + R1 ;
A[2] = "LP1 PI1 PC " + parseFloat(unit_n1)/2;
A[3] = "LP2 PI2 PC " + parseFloat(unit_n1)/2;
A[4] = "RP2 P2 PI2 " + R1;
A[5] = "LS1 SI S2 " + N2;
A[6] = "RS1 S1 SI " + document.getElementById(type).Rs1.value;
A[7] = "K1 LP1 LP2 LS1 " + document.getElementById(type).Coupling.value;
A[8] = "RG1 S2 0 " + "1G";
A[9] = ".ends " + document.getElementById(type).Name.value +"\n";
ModelName=document.getElementById(type).Name.value;
ModelText=Gen_Subckt(A,type,9);
}
}
// End of Single Phase Centre TAP Transfomer
// Start of Single Phase Custom TAP Transfomer
if(type=="FCUTAP"){
A=new Array(9);
if (document.getElementById('CUTAPS').checked){

unit_n1=verify_value(document.getElementById(type).LP.value,"LP",undefined,undefined);
unit_ratio=verify_value(document.getElementById(type).T_Ratio.value,"T_Ratio",undefined,undefined);
N2= (parseFloat(unit_n1)*parseFloat(unit_ratio)*parseFloat(unit_ratio)).toPrecision(4);
//var N2 = parseFloat(document.getElementById(type).LP.value)*parseFloat(document.getElementById(type).T_Ratio.value)*parseFloat(document.getElementById(type).T_Ratio.value);
N21= (parseFloat(N2)*(0.01*parseFloat(document.getElementById(type).TAP.value))).toPrecision(4);
N22= (parseFloat(N2)*(0.01*(100-parseFloat(document.getElementById(type).TAP.value)))).toPrecision(4);
R21 = (parseFloat(document.getElementById(type).Rs1.value)*(0.01*parseFloat(document.getElementById(type).TAP.value))).toPrecision(4);
R22 = (parseFloat(document.getElementById(type).Rs1.value)*(0.01*(100-parseFloat(document.getElementById(type).TAP.value)))).toPrecision(4);
A[0] = ".SUBCKT " + document.getElementById(type).Name.value + " P1 P2 S1 SC S2" + "\n";
A[1] = "LP1 PI P2 " + document.getElementById(type).LP.value ;
A[2] = "RP1 P1 PI " + document.getElementById(type).Rp1.value;
A[3] = "LS1 SI1 SC " + N21;
A[4] = "RS1 S1 SI1 " + R21;
A[5] = "LS2 SI2 SC " + N22;
A[6] = "RS2 SI2 S2 " + R22;
A[7] = "K1 LP1 LS1 LS2 " + document.getElementById(type).Coupling.value;
A[8] = "RG1 SC 0 " + "1G";
A[9] = ".ends " + document.getElementById(type).Name.value +"\n";
ModelName=document.getElementById(type).Name.value;
ModelText=Gen_Subckt(A,type,9);
}
if (document.getElementById('CUTAPP').checked){
unit_n1=verify_value(document.getElementById(type).LP.value,"LP",undefined,undefined);
unit_ratio=verify_value(document.getElementById(type).T_Ratio.value,"T_Ratio",undefined,undefined);
N2= (parseFloat(unit_n1)*parseFloat(unit_ratio)*parseFloat(unit_ratio)).toPrecision(4);
unit_rp1=verify_value(document.getElementById(type).Rp1.value,"Rp1",undefined,undefined);
//var N2 = parseFloat(document.getElementById(type).LP.value)*parseFloat(document.getElementById(type).T_Ratio.value)*parseFloat(document.getElementById(type).T_Ratio.value);

A[0] = ".SUBCKT " + document.getElementById(type).Name.value + " P1 PC P2 S1 S2" + "\n";
A[1] = "RP1 P1 PI1 " + (parseFloat(unit_rp1)*(0.01*parseFloat(document.getElementById(type).TAP.value))).toPrecision(4); 
A[2] = "LP1 PI1 PC " + (parseFloat(unit_n1)*(0.01*parseFloat(document.getElementById(type).TAP.value))).toPrecision(4);
A[3] = "LP2 PI2 PC " + (parseFloat(unit_n1)*(0.01*(100-parseFloat(document.getElementById(type).TAP.value)))).toPrecision(4);
A[4] = "RP2 P2 PI2 " + (parseFloat(unit_rp1)*(0.01*(100-parseFloat(document.getElementById(type).TAP.value)))).toPrecision(4);
A[5] = "LS1 SI S2 " + N2;
A[6] = "RS1 S1 SI " + document.getElementById(type).Rs1.value;
A[7] = "K1 LP1 LP2 LS1" + document.getElementById(type).Coupling.value;
A[6] = "RG1 S2 0 " + "1G";
A[9] = ".ends " + document.getElementById(type).Name.value +"\n";
ModelName=document.getElementById(type).Name.value;
ModelText=Gen_Subckt(A,type,9);
}
}
// End of Single Phase Custom TAP Transfomer
// Start of Multi Winding Transfomer
if(type=="FMWT"){
A=new Array(5);
unit_n1=verify_value(document.getElementById(type).LP.value,"LP",undefined,undefined);
unit_ratio=verify_value(document.getElementById(type).T_Ratio.value,"T_Ratio",undefined,undefined);
N2= (parseFloat(unit_n1)*parseFloat(unit_ratio)*parseFloat(unit_ratio)).toPrecision(4);

A[0]=".SUBCKT MWT_" + RefDes + " P1 P2 ";
N=document.getElementById(type).NWDG.value;
var subckt="";
var head = "";
var coup="K1 L1 ";
for (i=1;i<=N;i++)
{
head= head + "S"+i+"1" + " S"+i+"2 ";
subckt= subckt + "LS"+i + " S"+i+"1" + " S"+i+"2 " + N2 +"\n";
coup = coup + "LS"+i + " ";
}
A[0]= A[0]+ head +"\n";
A[1] = "RP1 P1 PI " + document.getElementById(type).Rp1.value;
A[2] = "LP1 PI P2 " + document.getElementById(type).LP.value ;
A[3]=subckt;
A[4]=coup + document.getElementById(type).Coupling.value;
A[5] = ".ends " + document.getElementById(type).Name.value +"\n";
ModelName=document.getElementById(type).Name.value;
ModelText=Gen_Subckt(A,type,5);

}
// Start of Flyback Transformer

if(type=="FFLB"){
unit_n1=verify_value(document.getElementById(type).LP.value,"LP",undefined,undefined);
unit_ratio=verify_value(document.getElementById(type).T_Ratio.value,"T_Ratio",undefined,undefined);
N2= (parseFloat(unit_n1)*parseFloat(unit_ratio)*parseFloat(unit_ratio)).toPrecision(4);

//var N2 = parseFloat(document.getElementById(type).LP.value)*parseFloat(document.getElementById(type).T_Ratio.value)*parseFloat(document.getElementById(type).T_Ratio.value);


A=new Array(8);
A[0]= ".SUBCKT " + document.getElementById(type).Name.value + " P1 P2 S1 S2" + "\n";
A[1] = "RP1 P1 PI " + document.getElementById(type).Rp1.value;
A[2] = "LP1 PI P2 " + document.getElementById(type).LP.value ;
A[3] = "LS1 S2 SI1  " + N2;
A[4] = "LL1 S1 SI2 " + document.getElementById(type).Lls.value ;
A[5] = "RS1 SI2 SI1 " + document.getElementById(type).Rs1.value ;
A[6] = "K1 LP1 LS1 1" ;
A[7] = "RG1 S2 0 " + "1G";
A[8] = ".ends " + document.getElementById(type).Name.value +"\n";
ModelName=document.getElementById(type).Name.value;
ModelText=Gen_Subckt(A,type,8);
}


// Start of Forward Transformer

if(type=="FFWD"){
A=new Array(10);

unit_n1=verify_value(document.getElementById(type).LP.value,"LP",undefined,undefined);
unit_ratio=verify_value(document.getElementById(type).T_Ratio.value,"T_Ratio",undefined,undefined);
N2= (parseFloat(unit_n1)*parseFloat(unit_ratio)*parseFloat(unit_ratio)).toPrecision(4);

//var N2 = parseFloat(document.getElementById(type).LP.value)*parseFloat(document.getElementById(type).T_Ratio.value)*parseFloat(document.getElementById(type).T_Ratio.value);
if (document.getElementById('WOR').checked){

A[0] = ".SUBCKT " + document.getElementById(type).Name.value + " P1 P2 S1 S2" + "\n";
A[1] = "RP1 P1 PI " + document.getElementById(type).Rp1.value;
A[2] = "LP1 PI P2 " + document.getElementById(type).LP.value ;
A[3] = "LS1 SI2 S2 " + N2;
A[4] = "LL1 S1 SI1 " + document.getElementById(type).Lls.value ;
A[5] = "RS1 SI1 SI2 " + document.getElementById(type).Rs1.value ;
A[6] = "K1 LP1 LS1 1" ;
A[7] = "RG1 S2 0 " + "1G";
A[8] = ".ends " + document.getElementById(type).Name.value +"\n";
A[9] = "\n";
A[10] = "\n";
ModelName=document.getElementById(type).Name.value;
ModelText=Gen_Subckt(A,type,10);
}
if (document.getElementById('WR').checked){


A[0] = ".SUBCKT " + document.getElementById(type).Name.value + " P1 P2 RS1 RS2 S1 S2" + "\n";
A[1] = "RP1 P1 PI " + document.getElementById(type).Rp1.value;
A[2] = "LP1 PI P2 " + document.getElementById(type).LP.value ;
A[3] = "LS1 SI1 S2 " + N2;
A[4] = "LL1 SI1 SI2 " + document.getElementById(type).Lls.value ;
A[5] = "RS1 SI2 S1 " + document.getElementById(type).Rs1.value ;
A[6] = "LRS1 RS2 RS1 " + (parseFloat(unit_n1)*parseFloat(document.getElementById(type).Rst.value)).toPrecision(4);
A[7] = "K1 LP1 LS1 LRS1 1";
A[8] = "RG1 S2 0 " + "1G";
A[9] = "RG2 RS2 0 " + "1G";
A[10] = ".ends " + document.getElementById(type).Name.value +"\n";
ModelName=document.getElementById(type).Name.value;
ModelText=Gen_Subckt(A,type,10);

}
}
//alert(type)

RefDes=document.getElementById(type).Name.value;
var Status=0;
if (mode == "startup"){
    RefDes=document.getElementById(type).Name.value;
    Status=UpdateTransformerData(type, SYM);
    if (Status==1){
	Write_Model();	
	Place_Part(SYM);}
    }
    else {
	//alert(type + "  SYM IS " + SYM)
	Status=UpdateTransformerData(type,SYM);
	if (Status==1){
		Write_Model();
        Close_View();}
        }


return true;
}

//Start of Subckt function
function Gen_Subckt(A,type,n){
//A is string array with individual model component values
//type is form id, which also indicated the transformer
//n is number of element in sub circuit, this control element in array A

//subtxt = ".SUBCKT TRAN P1 P2 S1 S2" + "\n"
//subtxt = "*Transformer Model Generated using PSpice Model App" +"\n"
subtxt = Header(type);
for (i=0;i<=n;i++)
{
subtxt= subtxt + A[i] + "\n" ;
}

//subtxt= subtxt + "\n" + ".ends " + type +"_" + RefDes + "\n" 
document.getElementById('subckt').style.display="block";
document.forms['subckt'].elements['subckt_textarea'].value = subtxt;

//document.getElementById(type).GM.value="Update Model"
//orPrmNativeCall("executeTcl", "OPage \"SCHEMATIC1\" \"PAGE1\"");

return subtxt;
}
//End of Subckt function

function Set_Input(id,mode) {

if (mode=="1"){
document.getElementById(id).style.display="block";
SYM="FWDR";
}
if (mode=="0"){
document.getElementById(id).style.display="none";
SYM="FWD";
}
}



function SetSym(name){
SYM=name;
//alert(SYM)
}

function GetTransformerDataInUi(type, SYM) {
var X=1;
var ModelFound = 0;
if (ModelJsData.Transformer.length>1){

for (X in ModelJsData.Transformer)
{
    if (((ModelJsData.Transformer[X].Name).toUpperCase() == (RefDes).toUpperCase())&& ((ModelJsData.Transformer[X].Type).toUpperCase() == (SYM.toUpperCase()))) {
//    alert("mathched " + X + " " + ModelJsData.Transformer[X].Name + "type " + ModelJsData.Transformer[X].Type + " " + (type.slice(1)).toUpperCase()) 
    _SeedJSDataInUI(type, X);
    ModelFound = 1;
    break;   
   }
}
} 
//If model data is not found in record, This would initialize the data with default values
if (ModelFound === 0){
//         var NewModelName = RefDes
//         var NewRec = {"Name":NewModelName, "Type":type.slice(1).toUpperCase(),"LP1": "1m","RP1": "10m","RS1": "10m","Coupling": "1","Ratio": "10","TAP": "25","NWDG": "2","Lls":"10u","Rst":"1" }
//         ModelJsData.Transformer.push(NewRec)
//         X = ModelJsData.Transformer.length -1 
	 _SeedJSDataInUI(type, 0);
  	  var NewModelName = "MyTrModel_" + type.slice(1).toUpperCase();
	  alert("Model Data Not Found, Initializing to Default values");
    	document.getElementById(type).Name.value = NewModelName;
}
//}}

}

function UpdateTransformerData(type, SYM) {


var X=1;
var UpdateS=0;
var Duplicate=0;

if ((ModelJsData.Transformer.length > 1) && (mode=="startup")){
		//alert("Startup, Case 2.1");
	for (X=1;X<=ModelJsData.Transformer.length-1;X++){
	    if (((ModelJsData.Transformer[X].Name).toUpperCase() == (document.getElementById(type).Name.value).toUpperCase())){
	    	    if (confirm("Model with same name already exists, Click OK to overwrite it, Cancel to Save with different name?")){
		_GetUIDataInJS(type,SYM, X);
		UpdateS=1;
		break;} else{
	    UpdateS = 0;
	    Duplicate=1;
	    break;
	    }
    }
    }
if ((Duplicate===0)&& (UpdateS === 0)) {
		//alert("Startup, Case 2.2");
    NewRec = {"Name":document.getElementById(type).Name.value, "Type": SYM.toUpperCase(),"LP1": "1m","RP1": "10m","RS1": "10m","Coupling": "1","Ratio": "10","TAP": "25","NWDG": "2","Lls":"10u","Rst":"1" };
            ModelJsData.Transformer.push(NewRec);
            X = ModelJsData.Transformer.length -1;
            _GetUIDataInJS(type,SYM, X);
            UpdateS=1;
    }
}
if ((mode!="startup" )&& (ModelJsData.Transformer.length >1) ){
		//alert("Update, Case 2.1");
	for (X=1;X<=ModelJsData.Transformer.length-1;X++){
	    if (((ModelJsData.Transformer[X].Name).toUpperCase() == (document.getElementById(type).Name.value).toUpperCase()) && ((ModelJsData.Transformer[X].Type).toUpperCase() == SYM.toUpperCase())){
	    _GetUIDataInJS(type,SYM, X);
	    UpdateS = 1 ;
	    break;
    	}
	else if (((ModelJsData.Transformer[X].Name).toUpperCase() == (document.getElementById(type).Name.value).toUpperCase()) && ((ModelJsData.Transformer[X].Type).toUpperCase() != SYM.slice(1).toUpperCase())){
			//alert("update, Case 2.2");
	    if (confirm("Model with same Name but of different Type is present, Click OK to overwrite it, Cancel to Save with different name?")){
		ModelJsData.Transformer[X].Type=SYM.toUpperCase();
		_GetUIDataInJS(type,SYM, X);
        UpdateS=1;
		break;
	    }else{
	    UpdateS = 0 ;
	    Duplicate=1;
	    break;}
    }}}
if (mode!="startup" && UpdateS===0 && Duplicate===0){
    		//alert("Update, Case 3");
    NewRec = {"Name":document.getElementById(type).Name.value, "Type": SYM.toUpperCase(),"LP1": "1m","RP1": "10m","RS1": "10m","Coupling": "1","Ratio": "10","TAP": "25","NWDG": "2","Lls":"10u","Rst":"1" };
            ModelJsData.Transformer.push(NewRec);
            X = ModelJsData.Transformer.length -1;
            _GetUIDataInJS(type,SYM, X);
            UpdateS=1;
            }
if ((mode!="startup" )&& (ModelJsData.Transformer.length==1) ){
		//alert("Update, Case 1");
	alert("Model data missing, Initializing to default values");
	NewRec = {"Name":document.getElementById(type).Name.value, "Type": SYM.toUpperCase(),"LP1": "1m","RP1": "10m","RS1": "10m","Coupling": "1","Ratio": "10","TAP": "25","NWDG": "2","Lls":"10u","Rst":"1" };
            ModelJsData.Transformer.push(NewRec);
            X = ModelJsData.Transformer.length -1;
            _GetUIDataInJS(type,SYM, X);
            UpdateS=1;
	}
if ((ModelJsData.Transformer.length==1) && (mode=="startup")){
		//alert("Startup, Case 1")	;
            var NewRec = {"Name":document.getElementById(type).Name.value, "Type": SYM.toUpperCase(),"LP1": "1m","RP1": "10m","RS1": "10m","Coupling": "1","Ratio": "10","TAP": "25","NWDG": "2","Lls":"10u","Rst":"1" };
            ModelJsData.Transformer.push(NewRec);
            X = ModelJsData.Transformer.length -1;
            _GetUIDataInJS(type,SYM, X);
            UpdateS=1;
 }
            
    
// If model name is not matched, create a dummy record at the end and update the value of same based on model
if (UpdateS==1){      
var updatedModel = JSON.stringify(ModelJsData);
Write_InputData(updatedModel);
}
return UpdateS;
}
/*

*/
function Set_DefaultTransformerData(type) {
    if (ModelJsData.Transformer.length===0) {
    var ModelJsData= {"Transformer": [{"Name": "MyTrModel", "Type": "ST","LP1": "1m","RP1": "10m","RS1": "10m","Coupling": "1","Ratio": "10","TAP": "25","NWDG": "2","Lls":"10u","Rst":"1" }]
        };
        ModelJsData.Transformer.Type=type;
        }
     else{
     var NewRec = {"Name": "MyTrModel", "Type": "ST","LP1": "1m","RP1": "10m","RS1": "10m","Coupling": "1","Ratio": "10","TAP": "25","NWDG": "2","Lls":"10u","Rst":"1" };
     ModelJsData.Transformer.push(NewRec);
     }   
return ModelJsData;
}

// Function Seed Data:: This function reads the Json structure and sets the UI filed with value from matching record 
//TBD:: Set the default value if record not found. 
//TBD:: Checks are based on refdes, these need to be changed on the basis of model name

function _SeedJSDataInUI(type, X){
    
switch(type) {
case "FST":
    document.getElementById(type).Name.value =  ModelJsData.Transformer[X].Name;
    document.getElementById(type).LP.value =  ModelJsData.Transformer[X].LP1;
    document.getElementById(type).Rp1.value =  ModelJsData.Transformer[X].RP1;
    document.getElementById(type).Rs1.value =  ModelJsData.Transformer[X].RS1;
    document.getElementById(type).Coupling.value =  ModelJsData.Transformer[X].Coupling;
    document.getElementById(type).T_Ratio.value =  ModelJsData.Transformer[X].Ratio;
    break;
case "FMWT":
    document.getElementById(type).Name.value =  ModelJsData.Transformer[X].Name;
    document.getElementById(type).LP.value =  ModelJsData.Transformer[X].LP1;
    document.getElementById(type).Rp1.value =  ModelJsData.Transformer[X].RP1;
    document.getElementById(type).Coupling.value =  ModelJsData.Transformer[X].Coupling;
    document.getElementById(type).T_Ratio.value =  ModelJsData.Transformer[X].Ratio;
    document.getElementById(type).NWDG.value =  ModelJsData.Transformer[X].NWDG;
    break;
case "FCUTAP":
    document.getElementById(type).Name.value =  ModelJsData.Transformer[X].Name;
    document.getElementById(type).LP.value =  ModelJsData.Transformer[X].LP1;
    document.getElementById(type).Rp1.value =  ModelJsData.Transformer[X].RP1;
    document.getElementById(type).Rs1.value =  ModelJsData.Transformer[X].RS1;
    document.getElementById(type).Coupling.value =  ModelJsData.Transformer[X].Coupling;
    document.getElementById(type).T_Ratio.value =  ModelJsData.Transformer[X].Ratio;
    document.getElementById(type).TAP.value =  ModelJsData.Transformer[X].TAP;
    break;
case "FCETAP":
    document.getElementById(type).Name.value =  ModelJsData.Transformer[X].Name;
    document.getElementById(type).LP.value =  ModelJsData.Transformer[X].LP1;
    document.getElementById(type).Rp1.value =  ModelJsData.Transformer[X].RP1;
    document.getElementById(type).Rs1.value =  ModelJsData.Transformer[X].RS1;
    document.getElementById(type).Coupling.value =  ModelJsData.Transformer[X].Coupling;
    document.getElementById(type).T_Ratio.value =  ModelJsData.Transformer[X].Ratio;
    break;
case "FFLB":
    document.getElementById(type).Name.value =  ModelJsData.Transformer[X].Name;
    document.getElementById(type).LP.value =  ModelJsData.Transformer[X].LP1;
    document.getElementById(type).Rp1.value =  ModelJsData.Transformer[X].RP1;
    document.getElementById(type).Rs1.value =  ModelJsData.Transformer[X].RS1;
    document.getElementById(type).T_Ratio.value =  ModelJsData.Transformer[X].Ratio;
    document.getElementById(type).Lls.value =  ModelJsData.Transformer[X].Lls;
    break;
case "FFWD":
    document.getElementById(type).Name.value =  ModelJsData.Transformer[X].Name;
    document.getElementById(type).LP.value =  ModelJsData.Transformer[X].LP1;
    document.getElementById(type).Rp1.value =  ModelJsData.Transformer[X].RP1;
    document.getElementById(type).Rs1.value =  ModelJsData.Transformer[X].RS1;
    document.getElementById(type).T_Ratio.value =  ModelJsData.Transformer[X].Ratio;
    document.getElementById(type).Lls.value =  ModelJsData.Transformer[X].Lls;
    document.getElementById(type).Rst.value =  ModelJsData.Transformer[X].Rst;
    break;
default:
    alert("Transformer type not defined");
    break;
}
}

function _GetUIDataInJS(type,SYM, X){ 
ltype=SYM;
//ModelJsData.Transformer[X].Type=ltype.slice(1).toUpperCase();
ModelJsData.Transformer[X].Type=ltype.toUpperCase();
switch(type) {
case "FST":
    ModelJsData.Transformer[X].Name = document.getElementById(type).Name.value;
    ModelJsData.Transformer[X].LP1= document.getElementById(type).LP.value ;
    ModelJsData.Transformer[X].RP1= document.getElementById(type).Rp1.value;
    ModelJsData.Transformer[X].RS1= document.getElementById(type).Rs1.value ;
    ModelJsData.Transformer[X].Coupling =document.getElementById(type).Coupling.value;
    ModelJsData.Transformer[X].Ratio = document.getElementById(type).T_Ratio.value;
    break;
case "FMWT":
    ModelJsData.Transformer[X].Name = document.getElementById(type).Name.value;
    ModelJsData.Transformer[X].LP1 = document.getElementById(type).LP.value;
    ModelJsData.Transformer[X].RP1= document.getElementById(type).Rp1.value;
    ModelJsData.Transformer[X].Coupling=document.getElementById(type).Coupling.value;
    ModelJsData.Transformer[X].Ratio=document.getElementById(type).T_Ratio.value;
    ModelJsData.Transformer[X].NWDG= document.getElementById(type).NWDG.value;
    break;
case "FCUTAP":
    ModelJsData.Transformer[X].Name = document.getElementById(type).Name.value;
    ModelJsData.Transformer[X].LP1= document.getElementById(type).LP.value ;
    ModelJsData.Transformer[X].RP1= document.getElementById(type).Rp1.value;
    ModelJsData.Transformer[X].RS1= document.getElementById(type).Rs1.value;
    ModelJsData.Transformer[X].Coupling =document.getElementById(type).Coupling.value;
    ModelJsData.Transformer[X].Ratio = document.getElementById(type).T_Ratio.value;
    ModelJsData.Transformer[X].TAP=document.getElementById(type).TAP.value;
    break;
case "FCETAP":
    ModelJsData.Transformer[X].Name = document.getElementById(type).Name.value;
    ModelJsData.Transformer[X].LP1= document.getElementById(type).LP.value ;
    ModelJsData.Transformer[X].RP1= document.getElementById(type).Rp1.value;
    ModelJsData.Transformer[X].RS1= document.getElementById(type).Rs1.value ; 
    ModelJsData.Transformer[X].Coupling =document.getElementById(type).Coupling.value;
    ModelJsData.Transformer[X].Ratio = document.getElementById(type).T_Ratio.value;
    break;
case "FFLB":
    ModelJsData.Transformer[X].Name = document.getElementById(type).Name.value;
    ModelJsData.Transformer[X].LP1= document.getElementById(type).LP.value ;
    ModelJsData.Transformer[X].RP1= document.getElementById(type).Rp1.value;
    ModelJsData.Transformer[X].RS1= document.getElementById(type).Rs1.value ; 
    ModelJsData.Transformer[X].Ratio = document.getElementById(type).T_Ratio.value;
    ModelJsData.Transformer[X].Lls = document.getElementById(type).Lls.value;
    break;
case "FFWD":
    ModelJsData.Transformer[X].Name = document.getElementById(type).Name.value;
    ModelJsData.Transformer[X].LP1= document.getElementById(type).LP.value ;
    ModelJsData.Transformer[X].RP1= document.getElementById(type).Rp1.value;
    ModelJsData.Transformer[X].RS1= document.getElementById(type).Rs1.value ; 
    ModelJsData.Transformer[X].Ratio = document.getElementById(type).T_Ratio.value;
    ModelJsData.Transformer[X].Lls = document.getElementById(type).Lls.value;
    ModelJsData.Transformer[X].Rst = document.getElementById(type).Rst.value;
    break;
default:
alert("Transformer type not defined");
break;
}


}

function EnableButtons(mode) {
if (mode != "startup"){
document.getElementById('choice').style.display="none";
document.getElementById('rs').style.display="none";
document.getElementById('gmod').value="Update";
}else {
document.getElementById('choice').style.display="block";
document.getElementById('rs').style.display="block";
document.getElementById('gmod').value="Place";
}


}