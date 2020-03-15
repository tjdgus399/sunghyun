/************************************************************************************************************
* System		: SAF(Smart Aqua Farm) -  스마트 모니터링 시스템
* Program ID	: common.js
* Program Name	: 공통 JavaScript
* Author		: 
* Created Date	: 2019-08-22
* -----------------------------------------------------------------------------------------------------------
* Description
* - 
* -----------------------------------------------------------------------------------------------------------
* Update History
* - 
************************************************************************************************************/

/************************************************************************************************************
* Header Client 실시간 시계
* ************************************************************************************************************/
// 시계 출력
function printClock()
{
	var clock = document.getElementById("clock");	// 출력할 장소 선택
    var currentDate = new Date();	// 현재시간
    var calendar = currentDate.getFullYear() + "-" + (currentDate.getMonth()+1) + "-" + currentDate.getDate() // 현재 날짜
    var amPm = 'AM'; // 초기값 AM
    var currentHours = addZeros(currentDate.getHours(),2); 
    var currentMinute = addZeros(currentDate.getMinutes() ,2);
    var currentSeconds =  addZeros(currentDate.getSeconds(),2);
    
    if(currentHours >= 12)
    { 	// 시간이 12보다 클 때 PM으로 세팅, 12를 빼줌
    	amPm = 'PM';
    	currentHours = addZeros(currentHours - 12,2);
    }
    
    clock.innerHTML = calendar + "    " + currentHours + ":" + currentMinute+":"+currentSeconds +"  "+ amPm; //날짜를 출력해 줌
	
	setTimeout("printClock()",1000);
}

//자릿수 맞춰주기
function addZeros(num, digit) 
{ 
	  var zero = '';
	  num = num.toString();
	  if (num.length < digit) 
	  {
	    for (i = 0; i < digit - num.length; i++) 
	    {
	      zero += '0';
	    }
	  }
	  return zero + num; //한자리 수 일 경우 두자리로 출력 (1일경우 '01'로 출력
}

/************************************************************************************************************
* Header 이동함수
* ************************************************************************************************************/

function goHeaderButton(str)
{
	 location.href = str;
}

function goPage(flag)
{
	var frm = document.farmSelectedForm;
	if(frm.selectedFarmId.value == "")
	{
		alert("양식장을 선택 바랍니다.");
		return;
	}
	
	frm.method = "post";
	if(flag == "S")
	{
		alert("상태기록창으로 이동");
		frm.action = "../waterTank/stateRec.jsp";
	}
	if(flag == "grow")
	{
		alert("상태기록창으로 이동");
		frm.action = "../growInfo/growInfoList.jsp";
	}
	if(flag == "R")
	{
		alert("조치기록창으로 이동");
		frm.action = "../waterTank/repairRec.jsp";
	}
	if(flag == "WT")
	{
		alert("수조정보창으로 이동");
		frm.action = "../farm/farmwtSearch.jsp";
	}
	frm.target="_self";
	frm.submit();
}

/************************************************************************************************************
* 숫자, (.)만 입력받는 칸 만들기
* ************************************************************************************************************/
// 사용방법 onkeyup="fncDigit(this);" 이벤트 추가
function fncDigit(obj)
{
	var inText = obj.value;
	var ret;
 
    var alpha_num_Str = "0123456789.";

    for ( var i=0; alpha_num_Str.length >= i ; i++ ) {      
        var substr = inText.substring(i,i+1);  
        if (alpha_num_Str.indexOf(substr) < 0) {
            alert("숫자와 .(점)만 입력가능합니다.!");
            obj.value = "";
            obj.focus();
            return false; 
        }
    }
}
/************************************************************************************************************
* stateRec.jsp & repairRec.jsp 에 쓰는 검색 버튼 클릭 시 validate
* ************************************************************************************************************/
function wtSearch(){
	var obj = document.farmSelectedForm;
	var tankID = obj["tankId"];
	var fishName = obj["fishName"];
	var state = obj["state"];
	var sensorSDate = obj["sensorSDate"];
	var sensorEDate = obj["sensorEDate"];
	// wtUpdateForm.jsp에 있는 처리일자
	var lastUptSDate = obj["lastUptSDate"];
	var lastUptEDate = obj["lastUptEDate"];
	
	// 조건을 입력 안하고 검색시 모든 리스트 출력	
	if(noConditionCheck(tankID,fishName,state,sensorSDate,sensorEDate,lastUptSDate,lastUptEDate)){
		wtSearchAll();
		return;
	}
	
	// toDate만 입력한 경우 alert
	if ( (!checkNull(sensorSDate) && checkNull(sensorEDate)) || (checkNull(sensorSDate) && !checkNull(sensorEDate)) ){
		alert("측정일시를 모두 입력해 주세요");
		return;
	}
	
	// sensorSDate가 sensorEDate보다 클 경우 toDate 재입력 유도
	if( sensorSDate.value > sensorEDate.value ){
		alert("측정일시 시작날짜와 끝날짜를 정확히 입력해 주세요.");
		sensorSDate.value = "";
		sensorEDate.value = "";
		sensorSDate.focus();
		return;
	}
	
	// wtUpdateForm에만 lastUptSDate, lastUptEDate가 있어서 체크용도로 만듬
	if( lastUptSDate != undefined && lastUptEDate != undefined){
		// lastUptSDate가 lastUptEDate보다 클 경우 toDate 재입력 유도
		if( lastUptSDate.value > lastUptEDate.value ){
			alert("처리일시 시작날짜와 끝날짜를 정확히 입력해 주세요.");
			lastUptSDate.value = "";
			lastUptEDate.value = "";
			lastUptSDate.focus();
			return;
		}
		
		// wtUpdateForm.jsp용 처리일자 체크
		if ( (!checkNull(lastUptSDate) && checkNull(lastUptEDate)) || (checkNull(lastUptSDate) && !checkNull(lastUptEDate)) ){
			alert("처리일시를 모두 입력해 주세요");
			return;
		}
	}
	
	//searchForm 이름의 Form에 있는 값을 submit
	obj.target = "_self";
	obj.method = "POST";
	obj.submit();
}


/************************************************************************************************************
 * wtRec.jsp & wtUpdateForm.jsp 에 쓰는, 조건 미입력시 전체 검색, searchForm reset 후 FarmID로만 검색
* ************************************************************************************************************/
function wtSearchAll(){
	var obj = document.farmSelectedForm;
	// form 안에 있는 값들 초기화 해서 submit
	wtSearchReset();
	
	obj.target = "_self";
	obj.method = "POST";
	obj.submit();
}

/************************************************************************************************************
 * wtRec.jsp & wtUpdateForm.jsp 에 쓰는, 조건 미입력시 전체 검색, searchForm reset 후 FarmID로만 검색
* ************************************************************************************************************/
function wtSearchReset(){
	var obj = document.farmSelectedForm; 
	obj["tankId"].value = "";
	obj["fishName"].value = "";
	obj["state"].value = "";
	obj["sensorSDate"].value = "";
	obj["sensorEDate"].value = "";
	// wtUpdateForm에만 lastUptSDate, lastUptEDate가 있어서 체크용도로 만듬
	if( obj["lastUptSDate"] != undefined && obj["lastUptEDate"] != undefined){
		obj["lastUptSDate"].value = "";
		obj["lastUptEDate"].value = "";
	}
}

/************************************************************************************************************
* wtSearch() 함수에 쓰이는 Null값 체크용 함수, null 값 체크, obj가 null 일시 true 반환
* ************************************************************************************************************/
function checkNull(obj)
{
	if (obj == undefined || obj.value == null || obj.value == "")
	{
		return true;
	}
	else
	{
		return false;
	}
}

/************************************************************************************************************
* wtSearch() 함수에 쓰이는 조건을 입력했는지 안했는지 체크, 조건 선택을 안했을 경우 true를 반환
* ************************************************************************************************************/
function noConditionCheck(...obj)
{
	for(var i=0; i<obj.length; i++){
		if (checkNull(obj[i]))
		{
			continue;
		}
		else
		{	// 값이 있는 변수가 있다면,
			return false;
		}
	}
	//모든 변수가 Null 혹은 공백이라면,
	return true;
}

/************************************************************************************************************
* wtCautionUpdateForm.jsp에 쓰이는 repair 테이블 repaircontents 업데이트용 함수
* ************************************************************************************************************/
function repairContentsUpdate(){
	 updateForm.action = "wtCautionUpdatePrc.jsp";
	 updateForm.submit();
	 opener.location.reload();
	 self.close();
}

/************************************************************************************************************
* wtUpdateForm.jsp에 쓰이는 리스트 클릭 시 이벤트
* ************************************************************************************************************/
function wtCautionRepairContentsUpdate(farmName, tankID, repairSeq, recSeq){
		var url = "wtCautionUpdateForm.jsp?farmName="+farmName+"&tankID="+tankID+"&rp_s="+repairSeq+"&rc_s="+recSeq; 
		window.open(url, "CONTENTS", "toolbar=no, location=no, status=no, menubar=no, scrollbars=no, resizable=no, width=500px, height=240px");
}