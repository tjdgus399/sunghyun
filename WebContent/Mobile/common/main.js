/* *****************************************************************
	■ SYSTEM                :  SAF 양식장
	■ SOURCE FILE NAME      :	main.js
	■ DESCRIPTION           :  WebContents/farm
	■ COMPANY               :  목포대학교 융합소프트웨어학과 
	■ PROGRAMMER            :  
	■ DESIGNER              : 
	■ PROGRAM DATE          :  2019.08.19
	■ EDIT HISTORY          :  2019.08.22
	■ EDIT CONTENT          : 
 * ***************************************************************** */
// ************************************************************************ START LINE
function goButtonwtUpdateForm(FarmID) {
	if (parseInt(FarmID)) {
		location.href = "../waterTank/repairRec.jsp?FarmID=" + FarmID;
	} else {
		alert("양식장 ID를 입력");
	}
}


function goButtonwtRec(FarmID) {
	if (parseInt(FarmID)) {
		location.href = "../waterTank/stateRec.jsp?FarmID=" + FarmID;
	} else {
		alert("양식장 ID를 입력");
	}
}

function goButtonFarmwtSearch(FarmID){
	console.log(FarmID);
	if (parseInt(FarmID)) {
		location.href = "../farm/farmwtSearch.jsp?FarmID=" + FarmID;
	} else {
		alert("양식장 ID를 입력");
	}	
}
// ************************************************************************ END LINE

/* *****************************************************************
	■ SYSTEM                :	SAF 양식장
	■ SOURCE FILE NAME      :	main.js
	■ DESCRIPTION           :	WebContents/User/*.js
	■ COMPANY               :	목포대학교 융합소프트웨어학과 
	■ PROGRAMMER            :  
	■ DESIGNER              : 
	■ PROGRAM DATE          :	2019.08.19
	■ EDIT HISTORY          :	2019.08.22
	■ EDIT CONTENT          : 
* ***************************************************************** */
	
// ************************************************************************
// * 아이디 빈칸확인 - userInsertForm.jsp
// ************************************************************************ START LINE
function checkValue() {
	// 이름 빈칸 확인
	if (!document.userInsertForm.userName.value) {
		alert("이름을 입력하세요.");
		return;
	}
	// ID 빈칸 확인
	if (!document.userInsertForm.userID.value) {
		alert("ID를 입력하세요.");
		return;
	}
	// ID 중복체크 확인
	if (document.userInsertForm.idDuplication.value == 0) {
		alert("ID 중복체크를 해주세요.");
		return;
	}
	// 비밀번호 빈칸 확인
	if (!document.userInsertForm.userPW.value) {
		alert("비밀번호를 입력하세요.");
		return;
	}
	// 비밀번호 일치 확인
	if (document.userInsertForm.userPW.value != document.userInsertForm.userPWChk.value) {
		alert("비밀번호를 동일하게 입력하세요.");
		return;
	}

	// 폼 찾기
	var form = document.userInsertForm;

	// 사용자 추가확인창
	if (confirm("사용자를 추가하시겠습니까?")) {
		// 확인을 누를 경우
		form.method = "post";
		form.action = "userInsertPrc.jsp";
		form.target = "_self";
		form.submit();
	}
}
// ************************************************************************ END LINE
// * 아이디 체크 - userInsertForm.jsp
// ************************************************************************ START LINE
function idCheck() {
	// ID 빈칸 확인
	if (!document.userInsertForm.userID.value) {
		alert("ID를 입력하세요");
		return;
	}
	// 팝업창 URL
	var url = "userIDCheck.jsp?userID=" + document.userInsertForm.userID.value;
	// 팝업창(userIDCheck.jsp)
	window
			.open(
					url,
					"confirm",
					"toolbar=no, location=no, status=no, menubar=no, scrollbars=no, resizable=no, width=380px, height=240px");
}

//************************************************************************ END LINE
// * 전화번호 숫자만 입력 - userInsertForm.jsp, userUpdateForm.jsp
// ************************************************************************ START LINE
function OnlyNumber(obj) // 전화번호 입력을 위한 숫자입력만 받기
{
	// var obj = userInsertForm.usertel;
	if (event.keyCode >= 48 && event.keyCode <= 57) { // 숫자키만 입력
		return true;
	} else {
		event.returnValue = false;
	}
}

//************************************************************************ END LINE
// * 아이디 중복확인 유지 - userInsertForm.jsp 중복체크 후 다시 아이디 창이 새로운 아이디를 입력했을 때 다시 중복체크를
// * 하도록 한다.
//************************************************************************ START LINE
function inputIdChk() {
	document.userInsertForm.idDuplication.value = "idUncheck";
}

//************************************************************************ END LINE
// * 정보수정 비번확인 - userUpdateForm.jsp
//************************************************************************ START LINE
function checkValueUpdate() {

	// 비밀번호 빈칸 확인
	if (!document.userUpdateForm.userPW.value) {
		alert("비밀번호를 입력하세요.");
		return false;
	}
	// 비밀번호 일치 확인
	if (document.userUpdateForm.userPW.value != document.userUpdateForm.userPWChk.value) {
		alert("비밀번호를 동일하게 입력하세요.");
		return false;
	}

	// 폼 찾기
	var form = document.userUpdateForm;

	// 사용자 추가확인창
	if (confirm("사용자 정보를 변경하시겠습니까?")) {
		// 확인을 누를 경우
		form.method = "post";
		form.action = "userUpdatePrc.jsp";
		form.target = "_self";
		form.submit();
	} else {
		// 취소를 누를 경우
		return false;
	}
}

//************************************************************************ END LINE
// * 읽기 수정으로 이동(id 클릭 시) - userManagement.jsp
//************************************************************************ START LINE
function goReadUser(userid) {
	var farm = document.userManagement;

	farm.userid.value = userid;

	farm.method = "post";
	farm.action = "userUpdateForm.jsp";
	farm.submit();

}

//************************************************************************ END LINE
// * 등록화면으로 이동 - userManagement.jsp
//************************************************************************ START LINE
function goList() {
	var frm = document.listform;
	alert("등록화면");// 테스트용 지우고 사용할것.

	frm.target = "_self";
	frm.action = "insertForm.jsp";
	frm.submit();

}

//************************************************************************ END LINE
//* userUpdateForm.jsp에서 삭제 버튼 누를때 사용
//************************************************************************ START LINE

function goDelete(Auth, Name, FarmID) { // 삭제 버튼 클릭시
	if(Auth == "admin") { //전체 관리자 일 경우
		if (confirm(Name + "를 삭제할 시 관련된 양식장 정보가 모두 삭제됩니다. 삭제 하시겠습니까?")) {
		document.userUpdateForm.method = "post";
		document.userUpdateForm.action = "userDeletePrc.jsp?userAuth="+Auth+"&FarmID="+FarmID; // 확인 클릭시 페이지 이동
		document.userUpdateForm.target = "_self";
		document.userUpdateForm.submit();
		}
		else {
			return;
		}
	}
	if(Auth == "user") { //일반 관리자일 경우
		if (confirm(Name + "의 정보를 삭제하시겠습니까?")) {
		document.userUpdateForm.method = "post";
		document.userUpdateForm.action = "userDeletePrc.jsp?userAuth="+Auth+"&FarmID="+FarmID; // 확인 클릭시 페이지 이동
		document.userUpdateForm.target = "_self";
		document.userUpdateForm.submit();
		}
		else {
			return;
		}
	}
	}
//************************************************************************ END LINE
// * userUpdateForm.jsp 에서 목록보기 버튼을 누를시 userManagement.jsp 로 넘어가능 기능
//************************************************************************ START LINE

function usercancel() { // 목록 으로 되돌아가기 (취소)
	if (confirm("이전 화면으로 돌아가시겠습니까?")) {// 삭제하기 전 경고창으로 확인받기
		document.userUpdateForm.method = "post";
		document.userUpdateForm.action = "userManagement.jsp"; // 확인 클릭시 페이지 이동
		document.userUpdateForm.target = "_self";
		document.userUpdateForm.submit();
	} else {
		return false;
	}
}
	

//************************************************************************ END LINE
// * 삭제버튼 - userInfo.jsp
//************************************************************************ START LINE
function delfarm(param1,param2)
{
	var FarmID = param1;
	var farmname = param2;

	var frm = document.userInfo;
	frm.setAttribute("target","_self");
	frm.setAttribute("method","Post");
	frm.setAttribute("action","userFarmDeletePrc.jsp");	
	
	var hiddenfield = document.createElement("input");
	hiddenfield.setAttribute("type","hidden");
	hiddenfield.setAttribute("name","FarmID");
	hiddenfield.setAttribute("value",FarmID);

	if (confirm(farmname + " 의 정보를 삭제하시겠습니까?")) {
	
		frm.appendChild(hiddenfield);
		frm.submit();
	} 
}

//************************************************************************ END LINE
//* userIDCheck.jsp 에서 id중복확인
//************************************************************************ START LINE
function setId(userID){
	// 이 창을 연 기존 창의 객체 참조
	opener.document.userInsertForm.userID.value = userID;
	// 기존 창의 id 값 수정
	opener.document.userInsertForm.idDuplication.value = "1";
	// 중복체크한 아이디는 수정불가하도록
	opener.document.userInsertForm.id.readOnly = 'true';
	self.close();
}

//************************************************************************ END LINE
//* userIDCheck.jsp 에서 창 닫기
//************************************************************************ START LINE
function selfClose() {
	self.close();
}
//************************************************************************ END LINE

/* *****************************************************************
	■ SYSTEM                :	SAF 양식장
	■ SOURCE FILE NAME      :	main.js
	■ DESCRIPTION           :	WebContents/farm/*.js
	■ COMPANY               :	목포대학교 융합소프트웨어학과 
	■ PROGRAMMER            :  
	■ DESIGNER              : 
	■ PROGRAM DATE          :	2019.08.19
	■ EDIT HISTORY          :	2019.08.22
	■ EDIT CONTENT          : 
 * ***************************************************************** */
// main.jsp에서 수조정보수정 버튼 선택시 farmwtSearch.jsp로 화면이 넘어가는 기능
//************************************************************************ START LINE
function gofarmwtSearch() {
	// If not Select "FARMNAME" don't skip the Page of "farmwtSearch.jsp"
	var IsONFarmNameCheck = document.getElementById("selectFarm");
	
	
	if(IsONFarmNameCheck.value == "init") {
		alert("양식장을 선택해주세요");
		return;
	} else {
	
	document.selectFarm.target = "_self";
	document.selectFarm.method = "post";
	document.selectFarm.action = "../farm/farmwtSearch.jsp";  
	document.selectFarm.submit();
	}
}
//************************************************************************ END LINE
// farmwtSearch.jsp에서 '수정일시' 조건 선택시 검색창이 날짜로 바뀌게 하는 기능
//************************************************************************ START LINE


/*function Chselect(value) {
		if(value == "lastuptdate") {
			document.getElementById("searchinput").type = "date";
	
		} else {
			document.getElementById("searchinput").type = "search";
		}
}*/

//************************************************************************ END LINE
// farmwtSearch.jsp에서 조회버튼 클릭시 검색조건 또는 검색창이 null일 경우 경고창
//************************************************************************ START LINE
function searchCheck(){	
		
		if(farmSearch.searchinput.value == '' && farmSearch.search.value == 'null') {
			alert("조건 선택 및 검색 단어를 입력하세요.");
			farmSearch.target = "_self"; 							//새창이 열리지않고 현재창이 바뀜
			farmSearch.method = "post";
          farmSearch.searchinput.focus();				//Enter 눌러도 넘어감
          return;
		}
		else if(farmSearch.searchinput.value == '' && farmSearch.search.value != 'null') {			//검색창 값이 null일 경우
			alert("검색 단어를 입력하세요.");
			farmSearch.target = "_self";				//새창이 열리지않고 현재창이 바뀜
			farmSearch.method = "post";
          farmSearch.searchinput.focus();				//Enter 눌러도 넘어감
          return;
      }
      else if(farmSearch.search.value == 'null' && farmSearch.searchinput.value != ''){			//검색조건이 선택되지 않았을(null) 경우
      	alert("조건을 선택하세요.");
      	farmSearch.target = "_self";
      	farmSearch.method = "post";
      	farmSearch.search.focus();				//Enter 눌러도 넘어감
          return;
      } 
      else {											//둘 다 null이 아닐 경우
      	farmSearch.target = "_self";
      	farmSearch.method = "post";
      	farmSearch.action = "farmwtSearch.jsp";  
      	farmSearch.submit();
      }
  }
//************************************************************************ END LINE
// farmwtSearch.jsp에서 수조번호 클릭시 수정화면으로 이동하는 기능
//************************************************************************ START LINE
	function goRead(tankid,FarmID) {
		var farm = document.farmSearch;
		if (tankid != null) {
			//farm.tankID.value = tankid;
			alert(tankid + "수조가 선택되었습니다.");
			farm.target = "_self";
			farm.method = "post";
			farm.action = "farmwtUpdateForm.jsp?tankID="+tankid+"&FarmID="+FarmID;
			farm.submit();
		}
	}
//************************************************************************ END LINE
// farmwtSearch.jps에서 등록 버튼 클릭시 등록화면으로 이동하는 기능
//************************************************************************ START LINE
	function gofarmwtInsertForm() {
		var farm = document.farmSearch;
		
		farm.target = "_self";
  	farm.method = "post";
		farm.action="farmwtInsertForm.jsp";
		farm.submit();
	}
/* ***************************************************************** END LINE*/

/* *****************************************************************
■ SYSTEM                :  SAF 양식장
■ SOURCE FILE NAME      :	main.js
■ DESCRIPTION           :  WebContents/waterTank
■ COMPANY               :  목포대학교 융합소프트웨어학과 
■ PROGRAMMER            :  문인찬
■ DESIGNER              : 
■ PROGRAM DATE          :  2019.08.19
■ EDIT HISTORY          :  2019.09.02
■ EDIT CONTENT          : 
* ***************************************************************** */

//************************************************************************ START LINE
// stateRec.jsp & repairRec.jsp 에 쓰는 검색 버튼 클릭 시 validate

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
//************************************************************************ END LINE

//************************************************************************ START LINE
// wtRec.jsp & wtUpdateForm.jsp 에 쓰는, 조건 미입력시 전체 검색, searchForm reset 후 FarmID로만 검색

function wtSearchAll(){
	var obj = document.farmSelectedForm;
	// form 안에 있는 값들 초기화 해서 submit
	wtSearchReset();
	
	obj.target = "_self";
	obj.method = "POST";
	obj.submit();
}
//************************************************************************ END LINE

//************************************************************************ START LINE
// wtRec.jsp & wtUpdateForm.jsp 에 쓰는, 조건 미입력시 전체 검색, searchForm reset 후 FarmID로만 검색

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
//************************************************************************ END LINE

//************************************************************************ START LINE
// wtSearch() 함수에 쓰이는 Null값 체크용 함수, null 값 체크, obj가 null 일시 true 반환

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
//************************************************************************ END LINE

//************************************************************************ START LINE
// wtSearch() 함수에 쓰이는 조건을 입력했는지 안했는지 체크, 조건 선택을 안했을 경우 true를 반환

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
//************************************************************************ END LINE

//************************************************************************ START LINE
// wtCautionUpdateForm.jsp에 쓰이는 repair 테이블 repaircontents 업데이트용 함수

function repairContentsUpdate(){
	 updateForm.action = "wtCautionUpdatePrc.jsp";
	 updateForm.submit();
	 opener.location.reload();
	 self.close();
}
//************************************************************************ END LINE

//************************************************************************ START LINE
// wtUpdateForm.jsp에 쓰이는 리스트 클릭 시 이벤트
function wtCautionRepairContentsUpdate(farmName, tankID, repairSeq, recSeq){
		var url = "wtCautionUpdateForm.jsp?farmName="+farmName+"&tankID="+tankID+"&rp_s="+repairSeq+"&rc_s="+recSeq; 
		window.open(url, "CONTENTS", "toolbar=no, location=no, status=no, menubar=no, scrollbars=no, resizable=no, width=500px, height=240px");
}
//************************************************************************ END LINE




















//farmwtInsertForm.jsp에서 조회 버튼 클릭시 담당자 검색 화면으로 이동하는 기능
//************************************************************************ START LINE
function goButtonGrowInfoForm(FarmID) {
	if (parseInt(FarmID)) {
		location.href = "../fish/growList.jsp?FarmID=" + FarmID;
	} else {
		alert("양식장 ID를 입력");
	}
}
//************************************************************************ END LINE