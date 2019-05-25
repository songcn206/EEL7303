/** /////////////////////////////////////////////////////////////////////////////////
 *  WARRANTY: NONE. THIS PROGRAM WAS WRITTEN AS "SHAREWARE" AND IS AVAILABLE AS IS
 *            AND MAY NOT WORK AS ADVERTISED IN ALL ENVIRONMENTS. THERE IS NO
 *            SUPPORT FOR THIS PROGRAM
 *      NOTE: YOU ARE STRONGLY ADVISED TO BACKUP YOUR DESIGN
 *            BEFORE RUNNING THIS PROGRAM
 *   JS file: Controller_Cadence.js
 *            Add on file to run Automated GUI Testing 
 *
 * /////////////////////////////////////////////////////////////////////////////////
 */

function capReplay(pList){
	var dirPath = pList.drcs[0].dir;
	var file = pList.drcs[1].file;
	var starturl = window.location.href;
	window._sahi.playManual(dirPath,file,starturl);
}
function capStartRecording(pList){
	var dirPath = pList.drcs[0].dir;
	var file = pList.drcs[1].file;
	recordAll();
    window._sahi.startRecording(dirPath,file);
}
function capStopRecording(){
    window._sahi.stopPlaying();
}
Sahi.prototype.playManual = function (dirpath,file,starturl) {
    window._sahi.sendToServer("_s_/dyn/Player_setScriptFile?dir="+dirpath+"&file="+file+"&starturl="+starturl+"&manual=1");
    window._sahi.unpause();
    window._sahi.ex();
};
Sahi.prototype.startRecording = function (dirpath,file) {
    window._sahi.topSahi()._isRecording = true;
    window._sahi.addHandlersToAllFrames(window._sahi.top());
    window._sahi.sendToServer("/_s_/dyn/Recorder_start?dir="+dirpath+"&file="+file);
};

Sahi.prototype.openWin = function (e) {
};