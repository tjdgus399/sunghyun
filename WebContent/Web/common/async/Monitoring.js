/*
 * @ Method : colorChange ,InButtonCheck() @ Parameter : param1 : 수조상태값(DB의
 * state) @ @ colorChange task : state 값에 따라 "BackgroundColor" 값을 리턴 @
 * InButtonCheck taks : state 값에 따라 "submit" 생성 유무 리턴
 */

var testtemp;

function wtCautionPopUP(param1, param2, param3) {

	var url = "../waterTank/wtCautionForm.jsp?tankid=" + param1 + "&FarmID="
			+ param2 + "&RecSeq=" + param3;
	var name = "wtCaution popupt test";
	var option = "width=700 height=500 location=no";
	window.open(url, name, option);

}

// 수조 상태별 배경색  바뀌는 function
function colorChange(param1) {
	this.param1 = param1;
	if (this.param1 == "R") {
		return "linear-gradient( to bottom, red 17% , white 55%)";
	} else if (this.param1 == "Y") {
		return "linear-gradient( to bottom, yellow 17% , white 55%)";
	} else {
		
		return "white";
	}
}

// 수조 상태가 위험이나 경고일 때 배경색이 바뀌는 function
function InButtonCheck(IsCheckFlag, param1, param2, param3) {
	this.IsCheckFlag = IsCheckFlag;

	if (this.IsCheckFlag == "G") {
		return "";

	} else if ((this.IsCheckFlag == "Y") || (this.IsCheckFlag == "R")) {
		var InsertButton = "<input id='handleButton' type='button' value='조치' onclick=\"wtCautionPopUP("
				+ "'"
				+ param1
				+ "',"
				+ "'"
				+ param2
				+ "',"
				+ "'"
				+ param3
				+ "'" + ")\"/>"

		return InsertButton
	} else {
		return "";
	}
}
/* ======================================================= */

// 관리자 권한 을 위한 비동기 통신

function searchProcess(FarmID) {

	// 연결이 성공적으로 이뤄졌는지 체크
	if (request.readyState == 4 && request.status == 200) {
		// 리턴받은 searchwtREC 값을 object로 저장
		// eval()은 문자열을 코드로 인식하게 하는 함수
		// 전달받은 값은 Json 포맷
		var object = eval('(' + request.responseText + ')');
		var result = object.result;
		tmp = result;
		// 리턴받은 Json 포맷의 가장 첫번재 인덱스는 해당 양식장의 모든 수조의 갯수를 나타냄
		var AllwtCnt = result[0][0].value.slice(7);
		// 양식장 ID의 수조 갯수 별 DIV를 생성하기 위한 변수
		var createDivNumber = AllwtCnt;
		var creDiv = document.getElementById("Main_Section_Contents_Admin");

		// 검색된 수조의 갯수가 0개 이면..
		if (createDivNumber == 0) {
			creDiv.innerHTML = "검색된 수조가 없습니다.";
			return;
		}

		// 검색된 수조의 갯수가 0개가 아닐 때
		if (createDivNumber != 0) {
			// 이전에 검색했던 다른 양식장의 수조의 결과를
			// 다른 양식장을 검색했을 떄 지워줌
			creDiv.innerHTML = "";
			// 검색된 양식장의 수조 수 만큼 div 영역을 생성함
			for (var i = 0; i < createDivNumber; i++) {
				creDiv.insertAdjacentHTML("beforeend", "<div>");
			}

		}
		// 수조의 기록값은 [1][0] 부터 시작
		for (var i = 1; i < result.length; i++) {
			var temp = "";
			for (var j = 0; j < 11; j++) {
				if (j == 9) {
					continue;
				}
				temp += result[i][j].value + "<br>";

				// REC 테이블의 "State" 수조상태 값 파싱
				stateCode = result[i][1].value.slice(8);

				if (j == 1) {
					// ColorChange() 함수에 변수 ColorCode를 파라미터로 전달

					var HexCode = colorChange(stateCode);
					creDiv.children[i - 1].style.background = HexCode;

				}
				// 수조번호,수조상태,상태이상 까지의 구분선
				if (j == 2) {
					temp += "<hr>";
				}

				if (j == 10) {
					// 양식장 ID (TANKID)
					TankID = result[i][0].value.slice(8);
					// 기록 시퀀스 값 (rec.RECSEQ)
					recSeq = result[i][9].value.slice(11);
					// 수조상태 값 (rec.STATE)
					StateCode = result[i][1].value.slice(8);

					// StateCode 변수의 값을 InButtonCheck() 함수에 따라
					// "submit"을 "Insert" or "NULL" 로 둘 것인지 결정
					var inButtonCheck = InButtonCheck(stateCode, TankID,
							FarmID, recSeq)

					// 동적인 "fomr" 태그를 생성하기 위한 문자열 바인딩
					// wtCautionForm.jsp 에 넘기는 파라미터 TankID,FarmId,recSeq
					if (result[i][10].value == "") {

						temp += "<hr>" + inButtonCheck;
					} else {
						ret = result[i][10].value.slice(3);

						temp += "<hr>" + inButtonCheck

					}
					// 수조의 측정값을 creDIV의 자식 <div> 태
					creDiv.children[i - 1].innerHTML = temp;
				}

			}

		}
	}

}

// 일반사용자 권한을 위한 비동기 통신 함수
function searchProcessUser(FarmID) {
	if (request.readyState == 4 && request.status == 200) {
		var object = eval('(' + request.responseText + ')');
		var result = object.result;
		tmp = result;

		var AllwtCnt = result[0][0].value.slice(7);

		// 양식장 ID의 수조 갯수 별 DIV를 생성하기 위한 변수
		var createDivNumber = AllwtCnt;

		var creDiv = document.getElementById("Main_Section_Contents_User");

		// 검색된 수조의 갯수가 0개 이면..
		if (createDivNumber == 0) {
			creDiv.innerHTML = "검색된 수조가 없습니다.";
			return;
		}

		// 검색된 수조의 갯수가 0개가 아닐 때
		if (createDivNumber != 0) {
			// 이전에 검색했던 다른 양식장의 수조의 결과를
			// 다른 양식장을 검색했을 떄 지워줌
			creDiv.innerHTML = "";
			// 검색된 양식장의 수조 수 만큼 div 영역을 생성함
			for (var i = 0; i < createDivNumber; i++) {
				creDiv.insertAdjacentHTML("beforeend", "<div>");
			}

		}

		// 수조의 기록값은 [1][0] 부터 시작
		for (var i = 1; i < result.length; i++) {
			var temp = "";
			for (var j = 0; j < 11; j++) {
				if (j == 9) {
					continue;
				}

				temp += result[i][j].value + "<br>";

				// REC 테이블의 "State" 수조상태 값 파싱
				stateCode = result[i][1].value.slice(8);

				if (j == 1) {
					// ColorChange() 함수에 변수 ColorCode를 파라미터로 전달
					var HexCode = colorChange(stateCode);
					creDiv.children[i - 1].style.backgroundColor = HexCode;

				}
				// 수조번호,수조상태,상태이상 까지의 구분선
				if (j == 2) {
					temp += "<hr>";
				}

				// 동적으로 "submit"을 생성하고 wtCautionForm과 연결되기 위한 조건
				if (j == 10) {
					// 양식장 ID (TANKID)
					TankID = result[i][0].value.slice(8);
					// 기록 시퀀스 값 (rec.RECSEQ)
					recSeq = result[i][9].value.slice(11);
					// 수조상태 값 (rec.STATE)
					StateCode = result[i][1].value.slice(8);

					// StateCode 변수의 값을 InButtonCheck() 함수에 따라
					// "submit"을 "Insert" or "NULL" 로 둘 것인지 결정
					var inButtonCheck = InButtonCheck(stateCode, TankID,
							FarmID, recSeq)

					// 동적인 "fomr" 태그를 생성하기 위한 문자열 바인딩
					// wtCautionForm.jsp 에 넘기는 파라미터 TankID,FarmId,recSeq
					if (result[i][10].value == "") {

						temp += "<hr>" + inButtonCheck;
					} else {
						ret = result[i][10].value.slice(3);

						temp += "<hr>" + inButtonCheck

					}
					// 수조의 측정값을 creDIV의 자식 <div> 태
					creDiv.children[i - 1].innerHTML = temp;
				}

			}
		}
	}

}


// 전체 관리자는 일반관리자 이름을 보고 양식장을 선택할 수 있음
function searchProcessAdmin() {

	if (requestFarmName.readyState == 4 && requestFarmName.status == 200) {
		var object = eval('(' + requestFarmName.responseText + ')');
		var result = object.result;
		var insertFarmInfoID = document.getElementById("selectFarm");
		insertFarmInfoID.innerHTML = "<option value='init'>양식장을 선택하세요</option>";

		for (var i = 0; i < result.length; i++) {
			
			if(result[i][1].value == null ) {
				insertFarmInfoID.insertAdjacentHTML("beforeend", "");
			} else {
				var InnerOption = "<option value="+result[i][0].value+">"+result[i][1].value+"</option>";
				insertFarmInfoID.insertAdjacentHTML("beforeend", InnerOption);
			}
		}
	}
}
