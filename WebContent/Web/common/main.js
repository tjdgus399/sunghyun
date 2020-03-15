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
■ SYSTEM                :  SAF 양식장
■ SOURCE FILE NAME      :	main.js
■ DESCRIPTION           :  WebContents/waterTank
■ COMPANY               :  목포대학교 융합소프트웨어학과 
■ PROGRAMMER            :  
■ DESIGNER              : 
■ PROGRAM DATE          :  2019.08.19
■ EDIT HISTORY          :  2019.08.22
■ EDIT CONTENT          : 
* ***************************************************************** */

//************************************************************************* START LINE
// wtRec.jsp & wtUpdateForm.jsp 에 쓰는 검색 버튼 클릭 시 validate
// ************************************************************************ END LINE
function wtSearch(){
	//jquery 형식으로 객체를 받았으면 함수도 jquery로 ...
	var tankID = $('input[name="tankID"]');
	var fishName = $('input[name="fishName"]');
	var state = $('select[name="state"]');
	var sensorFromDate = $('input[name="sensorFromDate"]');
	var sensorToDate = $('input[name="sensorToDate"]');
	// wtUpdateForm.jsp에 있는 처리일자
	var regFromDate = $('input[name="regFromDate"]');
	var regToDate = $('input[name="regToDate"]');
	
	// 조건을 입력 안하고 검색시 모든 리스트 출력	
	if(noConditionCheck(tankID,fishName,state,sensorFromDate,sensorToDate,regFromDate,regToDate)){
		wtSearchAll();
		return;
	}
	
	// toDate만 입력한 경우 alert
	if ( (!checkNull(sensorFromDate) && checkNull(sensorToDate)) || (checkNull(sensorFromDate) && !checkNull(sensorToDate)) ){
		alert("측정일시를 모두 입력해 주세요");
		return;
	}
	
	// sensorFromDate가 sensorToDate보다 클 경우 toDate 재입력 유도
	if( sensorFromDate.val() > sensorToDate.val() ){
		alert("측정일시 시작날짜와 끝날짜를 정확히 입력해 주세요.");
		sensorFromDate.val("");
		sensorToDate.val("");
		sensorFromDate.focus();
		return;
	}
	
	// regFromDate가 regToDate보다 클 경우 toDate 재입력 유도
	if( regFromDate.val() > regToDate.val() ){
		alert("처리일시 시작날짜와 끝날짜를 정확히 입력해 주세요.");
		regFromDate.val("");
		regToDate.val("");
		regFromDate.focus();
		return;
	}
	
	// wtUpdateForm.jsp용 처리일자 체크
	if ( (!checkNull(regFromDate) && checkNull(regToDate)) || (checkNull(regFromDate) && !checkNull(regToDate)) ){
		alert("처리일시를 모두 입력해 주세요");
		return;
	}
	
	//searchForm 이름의 Form에 있는 값을 submit
	searchForm.target = "_self";
	searchForm.submit();
}

//************************************************************************* START LINE
//wtRec.jsp & wtUpdateForm.jsp 에 쓰는, 조건 미입력시 전체 검색, searchForm reset 후 FarmID로만 검색
//************************************************************************ END LINE
function wtSearchAll(){

	// form 안에 있는 값들 초기화 해서 submit
	wtSearchReset();
	
	searchForm.target = "_self";
	searchForm.submit();
}

//************************************************************************* START LINE
//wtRec.jsp & wtUpdateForm.jsp 에 쓰는 초기화 버튼 클릭시 form안에 있는 값 초기화
//************************************************************************ END LINE
function wtSearchReset(){
	$('input[name="tankID"]').val("");
	$('input[name="fishName"]').val("");
	$('select[name="state"]').val("");
	$('input[name="sensorFromDate"]').val("");
	$('input[name="sensorToDate"]').val("");
	$('input[name="regFromDate"]').val("");
	$('input[name="regToDate"]').val("");
}

//************************************************************************* START LINE
// wtSearch() 함수에 쓰이는 Null값 체크용 함수, null 값 체크, obj가 null 일시 true 반환
//************************************************************************ END LINE
function checkNull(obj)
{
	if (obj == undefined || obj.val() == null || obj.val() == "")
	{
		return true;
	}
	else
	{
		return false;
	}
}

//************************************************************************* START LINE
// wtSearch() 함수에 쓰이는 조건을 입력했는지 안했는지 체크, 조건 선택을 안했을 경우 true를 반환
//************************************************************************ END LINE
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

//************************************************************************* START LINE
// wtCautionUpdateForm.jsp에 쓰이는 repair 테이블 repaircontents 업데이트용 함수
//************************************************************************ END LINE
function repairContentsUpdate(){
	 updateForm.action = "wtCautionUpdatePrc.jsp";
	 updateForm.submit();
	 opener.location.reload();
	 self.close();
}

//************************************************************************* START LINE
// wtUpdateForm.jsp에 쓰이는 리스트 클릭 시 이벤트
//************************************************************************ END LINE
function wtCautionRepairContentsUpdate(farmName, tankID, repairSeq, recSeq){
		var url = "wtCautionUpdateForm.jsp?farmName="+farmName+"&tankID="+tankID+"&rp_s="+repairSeq; 
		window.open(url, "CONTENTS", "toolbar=no, location=no, status=no, menubar=no, scrollbars=no, resizable=no, width=500px, height=240px");
}


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
	if(Auth == "일반관리자") { //전체 관리자 일 경우
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
	if(Auth == "사용자") { //일반 관리자일 경우
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

//************************************************************************ END LINE
//빈칸확인 - farmwtInsertForm.jsp
//************************************************************************ START LINE
	function farmwtInsert(){
		   // 빈칸 확인
		   if(!document.farmwtInsertForm.tankid.value){ //tankid 값이 들어가 있지 않으면 입력하라고 함.
		     alert("수조 이름을 입력하세요.");
		     return;
		   }
		   if(!document.farmwtInsertForm.dosensor.value){ //dosensor 값이 들어가 있지 않으면 입력하라고 함.
		        alert("DO 센서명을 입력하세요.");
		        return;
		      }
		   if(!document.farmwtInsertForm.phsensor.value){ //phsensor 값이 들어가 있지 않으면 입력하라고 함.
		        alert("pH 센서명을 입력하세요.");
		        return;
		      }
		   if(!document.farmwtInsertForm.wtsensor.value){ //wtsensor 값이 들어가 있지 않으면 입력하라고 함.
		        alert("수온 센서명을 입력하세요.");
		        return;
		      }
		   if(!document.farmwtInsertForm.psusensor.value){ //psusensor 값이 들어가 있지 않으면 입력하라고 함.
		        alert("PSU센서명을 입력하세요.");
		        return;
		      }
		   if(!document.farmwtInsertForm.nh4sensor.value){ //nh4sensor 값이 들어가 있지 않으면 입력하라고 함.
		        alert("NH4센서명을 입력하세요.");
		        return;
		      }
		   if(!document.farmwtInsertForm.no2sensor.value){ //no2sensor 값이 들어가 있지 않으면 입력하라고 함.
		        alert("NO2센서명을 입력하세요.");
		        return;
		      }

		   // 폼 찾기
		   var form = document.farmwtInsertForm;

		   // 정보 등록 확인창
		   if(confirm("등록 하시겠습니까?")){   
		     // 확인을 누를 경우
		     form.method = "post"; //post 방식
		     form.action = "farmwtInsertPrc.jsp"; //farmwtInsertPrc로 넘어감
		     form.target = "_self"; //현재 창에 뜨기
		     form.submit();
		   }
		}
	
//************************************************************************ END LINE
// farmwtInsertForm.jsp에서 조회 버튼 클릭시 담당자 검색 화면으로 이동하는 기능
//************************************************************************ START LINE
function gofarmwtUserForm_in(FarmID) {
	var url = "farmwtUserForm_in.jsp?FarmID=" + FarmID;
	window.open(url, "farmwtUserForm_in.jsp", "scrollbars=yes, resizable=no, width=430px, height=400px");
}
//************************************************************************ END LINE
// farmwtUserForm_upt.jsp에서 조회 버튼 클릭시 검색조건 또는 검색창이 null일 경우 경고창
//************************************************************************ START LINE
function searchuserCheck_upt(){								//검색 버튼 선택시 실행되는 기능
	if(farmUser.searchuserinput.value == '' && farmUser.searchuser.value == 'null') {
		alert("조건 선택 및 검색 단어를 입력하세요.");
		farmUser.target = "_self"; 							//새창이 열리지않고 현재창이 바뀜
		farmUser.method = "post";
      farmUser.searchuserinput.focus();				//Enter 눌러도 넘어감
      return;
	}
	else if(farmUser.searchuserinput.value == '' && farmUser.searchuser.value != 'null') {			//검색창 값이 null일 경우
		alert("검색 단어를 입력하세요.");
						//새창이 열리지않고 현재창이 바뀜
		farmUser.method = "post";
      farmUser.searchuserinput.focus();				//Enter 눌러도 넘어감
      return;
  }
  else if(farmUser.searchuser.value == 'null' && farmUser.searchuserinput.value != ''){			//검색조건이 선택되지 않았을(null) 경우
  	alert("조건을 선택하세요.");
  	farmUser.target = "_self";
  	farmUser.method = "post";
  	farmUser.searchuser.focus();				//Enter 눌러도 넘어감
      return;
  }
  else {											//둘 다 null이 아닐 경우
  	farmUser.target = "_self";
  	farmUser.method = "post";
  	farmUser.action = "farmwtUserForm_upt.jsp";  
  	farmUser.submit();
  }  
}
//************************************************************************ END LINE
//farmwtUserForm_in.jsp에서 조회 버튼 클릭시 검색조건 또는 검색창이 null일 경우 경고창
//************************************************************************ START LINE
function searchuserCheck_in(){								//검색 버튼 선택시 실행되는 기능
	if(farmUser.searchuserinput.value == '' && farmUser.searchuser.value == 'null') {
		alert("조건 선택 및 검색 단어를 입력하세요.");
		farmUser.target = "_self"; 							//새창이 열리지않고 현재창이 바뀜
		farmUser.method = "post";
      farmUser.searchuserinput.focus();				//Enter 눌러도 넘어감
      return;
	}
	else if(farmUser.searchuserinput.value == '' && farmUser.searchuser.value != 'null') {			//검색창 값이 null일 경우
		alert("검색 단어를 입력하세요.");
						//새창이 열리지않고 현재창이 바뀜
		farmUser.method = "post";
      farmUser.searchuserinput.focus();				//Enter 눌러도 넘어감
      return;
  }
  else if(farmUser.searchuser.value == 'null' && farmUser.searchuserinput.value != ''){			//검색조건이 선택되지 않았을(null) 경우
  	alert("조건을 선택하세요.");
  	farmUser.target = "_self";
  	farmUser.method = "post";
  	farmUser.searchuser.focus();				//Enter 눌러도 넘어감
      return;
  }
  else {											//둘 다 null이 아닐 경우
  	farmUser.target = "_self";
  	farmUser.method = "post";
  	farmUser.action = "farmwtUserForm_in.jsp";  
  	farmUser.submit();
  }  
}
//************************************************************************ END LINE
// farmwtUpdateForm.jsp에서 조회 버튼 클릭시 담당자 검색 팝업창으로 이동하는 기능
//************************************************************************ START LINE
function gofarmwtUserForm_upt(FarmID, tankid) {
	var url = "farmwtUserForm_upt.jsp?FarmID=" + FarmID + "&tankID2=" + tankid;
	window.open(url, "farmwtUserForm_upt.jsp", "scrollbars=yes, resizable=no, width=430px, height=400px");
}
//************************************************************************ END LINE
// farmwtUpdateForm.jsp에서 삭제 버튼 클릭시 수조정보 삭제되는 기능
//************************************************************************ START LINE
function gofarmdelete() {
	var farm = document.farmSelect;
	
	tankid = farm.tankID2.value;
	fishname = farm.fishnames.value;
	userid = farm.userid.value;
	dosensor = farm.dosensor.value;
	phsensor = farm.phsensor.value;
	psusensor = farm.psusensor.value;
	wtsensor = farm.wtsensor.value;
	nh4sensor = farm.wtsensor.value;
	no2sensor = farm.no2sensor.value;
		
	if(userid == " " && dosensor == " " && phsensor == " " && psusensor == " " &&
			wtsensor == " " && nh4sensor == " " && no2sensor == " "){
		farmSelect.method = "post";
		alert("이미 삭제된 수조정보입니다.");
		farmSelect.target = "_self";
		
		
	} else if (confirm("수조" + tankid + "의 정보를 삭제하시겠습니까?") == true) {			//삭제하기 전 경고창으로 확인받기
		farmSelect.method = "post";
		farm.action = "farmwtDeletePrc.jsp";		//확인 클릭시 페이지 이동
		farmSelect.target = "_self";
		farm.submit();
	} else {
		return;
	}
}
//************************************************************************ END LINE
//farmwtUpdateForm.jsp 에서 수정 버튼을 누를시 farmwtUpdatePrc.jsp 로 넘어가능 기능
//************************************************************************ START LINE
function goUpdate() { // 수정 버튼 클릭시
	
	var frm = document.farmSelect;
	
	if (frm.dosensor.value==' ') {
		alert("DO 센서명을 입력하세요.");
		return;
	}
	if (frm.phsensor.value==' ') {
		alert("pH센서명을 입력하세요.");
		return;
	}
	if (frm.psusensor.value==' ') {
		alert("psu센서명을 입력하세요.");
		return;
	}
	if (frm.wtsensor.value==' ') {
		alert("수온 센서명을 입력하세요.");
		return;
	}
	if (frm.nh4sensor.value==' ') {
		alert("NH4센서명을 입력하세요.");
		return;
	}
	if (frm.no2sensor.value==' ') {
		alert("NO2센서명을 입력하세요.");
		return;
	} 
	if (frm.userid.value==' '){
		alert("담당자를 선택하세요.");
		return;
	}
	
	if (confirm("수조 정보를 업데이트 하시겠습니까?")) { // 수정 전 경고창으로 확인받기
		farmSelect.method = "post";
		frm.action = "farmwtUpdatePrc.jsp"; // 확인 클릭시 페이지 이동
		frm.target = "_self";
		frm.submit();

	} else {
		return false;
	}
}
//************************************************************************ END LINE
//farmwtUserForm_in.jsp에서 추가 버튼 클릭시 farmwtInsertForm.jsp에서 추가되는 기능
//************************************************************************ START LINE
function check_in(userid, FarmID) {
	document.getElementsByName('userid')[0].value = userid;
	
	window.opener.location = "farmwtInsertForm.jsp?FarmID=" + FarmID + "&userid=" + userid;
	
	target ="_self";
	farmUser.method ="post";
	window.close();
}
//************************************************************************ END LINE
//farmwtUserForm_upt.jsp에서 추가 버튼 클릭시 farmwtUpdateForm.jsp에서 추가되는 기능
//************************************************************************ START LINE

function check_upt(userid, FarmID, tankid) {
	document.getElementsByName('userid')[0].value = userid;
	
	window.opener.location = "farmwtUpdateForm.jsp?tankID="+tankid+"&FarmID="+FarmID+"&userid="+userid;
	
	target ="_self";
	farmUser.method ="post";
	window.close();
}
// ************************************************************************ END LINE
// farmwtUpdateForm.jsp, farmwtInsertForm.jsp 에서 취소,목록보기 버튼을 누를시 farmwtSearch.jsp 로 넘어가능 기능
// ************************************************************************ STARTLINE
function farmCancel(formname) {
 if (formname =="formUpdate"){
    farmSelect.method = "post";
    document.farmSelect.action = "farmwtSearch.jsp"; // 확인 클릭시 페이지 이동
    document.farmSelect.target = "_self";
    document.farmSelect.submit();
 }
 if (formname=="formInsert"){
    // 폼 찾기
    var form = document.farmwtInsertForm;  
    // 취소를 누를 경우
    form.target = "_self";
    form.method = "post";
    form.action = "farmwtSearch.jsp";
    form.submit();
 }
}
/* ***************************************************************** END LINE*/
