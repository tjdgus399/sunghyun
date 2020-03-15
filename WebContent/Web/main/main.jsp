<%-- 
	■ SYSTEM                : SAF
    ■ SOURCE FILE NAME      : main.jsp
    ■ DESCRIPTION           : 메인 화면
    ■ COMPANY               : 목포대학교 융합소프트웨어학과 
    ■ PROGRAMMER            : 고지안
    ■ DESIGNER              : 
    ■ PROGRAM DATE          : 2019.08.07
    ■ EDIT HISTORY          : 2019.08.18
    ■ EDIT CONTENT          : 2019.08.25
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ page buffer="8kb" autoFlush="true" %>
<!-- 세션 정보 저장 파일 경로 -->
<%@ include file="../include/include/session.inc"%>

<!-- 세션에 저장된 권한이 없으면 index page로 리다이렉트 -->
<%
	if (Auth == null) {
		response.sendRedirect("./index.jsp");
	}
%>



<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>스마트 모니터링 시스템</title>

<!-------------------   CSS INCLUDE ------------------------->
<link rel="stylesheet" href="../common/style.css">
<link rel="stylesheet" href="../common/jqm-button/icon.css" />

<!-------------------  AJAX JS INCLUDE ------------------------>
<script type="text/javascript" src="../common/async/Monitoring.js"></script>
<script type="text/javascript">
	// Header Button Menu Parameter Global Variable
	var FarmID;
	var FarmName;

	
	// 전체 관리자가 로그인할 경우 양식장 이름과 매칭되는 양식장 아이디를 가져옴
	var requestFarmName = new XMLHttpRequest();
	function goSelectedAdmin() {

		var getSelectValue = document.getElementById("selectAdmin");
		var getSelectFarmListValue = document.getElementById("selectFarm");
		var getFarmIdStr = getSelectValue.value;
		console.log(getFarmIdStr);
		if (getFarmIdStr == "init") {
			var creDiv = document.getElementById("Main_Section_Contents_Admin");
			creDiv.innerHTML = "관리자를 선택하세요";
			getSelectFarmListValue.innerHTML = "<option>양식장을 선택하세요</option>";
		}

		else {
			requestFarmName.open("Post","../../searchAdmin?FarmID="+getFarmIdStr,true);
			requestFarmName.onreadystatechange = searchProcessAdmin;
			requestFarmName.send(null);
		}
		

	}

</script>
<style type="text/css">
	
	/* "조치 버튼 디자인" */
#handleButton {
	width:100%;
    color: #000000;
    background-color: #ffffff;
    border: #000000 solid 1px;
    padding: 10px;
    transition: all 0.1s ease;
    -webkit-transition: all 0.1s ease;
    -moz-transition: all 0.1s ease;
}

#handleButton:hover {
    color: #ffffff;
    background-color: #000000;
    animation: b09_electric_blinkIn 0.1s step-end 0 2;
    -webkit-animation: b09_electric_blinkIn 0.1s step-end 0 2;
    -moz-animation: b09_electric_blinkIn 0.1s step-end 0 2;
    transition: all 0.2s ease 0.2s;
    -webkit-transition: all 0.2s ease 0.2s;
    -moz-transition: all 0.2s ease 0.2s;
}

@-webkit-keyframes handleButton {
    from,
    to {
        background-color: #f8f8f8;
        color: #080808;
    }
    50% {
        background-color: #ffffff;
        color: #000000;
    }
}

@-moz-keyframes handleButton {
    from,
    to {
        background-color: #f8f8f8;
        color: #080808;
    }
    50% {
        background-color: #ffffff;
        color: #000000;
    }
}



</style>
</head>

<!-----------------------------  Body  ------------------------------------------->
<body onload="_GetAjaxConnection()">
	<%!// "관리자용" 아이디의 서블릿과 연결될 전역변수
	int wtNumber = 0;
	String FarmName = null;
	//일반 사용자
	int userFarmID = 0;
	%>

	<%
		String FarmID = request.getParameter("FarmID");
	%>
	<!-- --------------------------- START HEADER ---------------------------------->
	<header>
		<%@ include file="../include/header.inc"%>
	</header>
	<!-- --------------------------- END  HEADER ----------------------------------->



	<!-- --------------------------- START SECTION --------------------------------->
	<section class="mainSection">

		<%@include file="./mainPrc.jsp"%>
		<%------------  "전체관리자" 권한을 가진 유저의 수조정보 데이터를 보여줌  START LINE ------------------%>
		<%
			if (Auth.contains("전체관리자")) {
		%>

		<div id="choiceFarm">
			양식장 선택 : <select id="selectAdmin" name="selectAdmin" onchange="goSelectedAdmin()">
				<option value="init" seleceted>관리자를 선택하세요</option>
				<%
					for (int i = 0; i < farm_list.size(); i++) {
							String AdminUserId = farm_list.get(i).getUserId();
							String AdminUserName = farm_list.get(i).getRemark();
							String AdminFarmID = farm_list.get(i).getRemarkFarmid();
				%>
				<option value="<%=AdminFarmID%>"><%=AdminUserName%></option> 
				<%
					}
				%>
			</select>
			
			<select id="selectFarm" name="selectFarm" onchange="goSelectedForm()">
				<option value="init" selected>양식장을 선택하세요</option>
				<%
					for (int i = 0; i < farm_list.size(); i++) {
							wtNumber = farm_list.get(i).getFarmId();
							FarmName = farm_list.get(i).getFarmName();
				%>
				<option value="<%=wtNumber%>"><%=FarmName%></option>
				<%
				}
				%>
				
			</select>
		</div>

		<div id="Main_Section_Contents_Admin">
			
		</div>
		<%------------  "전체관리자" 권한을 가진 유저의 수조정보 데이터를 보여줌  END LINE ------------------%>


		<%------------  "일반관리자" 권한을 가진 유저의 수조정보 데이터를 보여줌  START LINE ------------------%>
		<%
			} else if (Auth.contains("일반관리자")) {
		%>
		<div id="choiceFarm">
			양식장 선택 : <select id="selectFarm" name="selectFarm"  data-inline="true" onchange="goSelectedForm()">
				<option value="init" selected>양식장을 선택하세요</option>
				<%
					for (int i = 0; i < farm_list.size(); i++) {
							wtNumber = farm_list.get(i).getFarmId();
							FarmName = farm_list.get(i).getFarmName();
				%>
				  <option value='<%=wtNumber%>'><%=FarmName%></option>
		<%
			}
		%>
		</select>
		</div>
		<div id="Main_Section_Contents_Admin"></div>
		
			<%------------  "일반관리자" 권한을 가진 유저의 수조정보 데이터를 보여줌  END LINE ------------------%>
			
			<%------------  "사용자" 권한을 가진 유저의 수조정보 데이터를 보여줌  START LINE ------------------%>
				
		<%
			} else {
				userFarmID = farm_list.get(0).getFarmId();
				FarmName = farm_list.get(0).getFarmName();
		%>
		<div id="choiceFarm">
			<select><option value='<%=userFarmID %>' selected><%=FarmName%></option></select>
		</div>
		<div id="Main_Section_Contents_User"></div>
		<%
			}
		%>
			<%------------  "사용자" 권한을 가진 유저의 수조정보 데이터를 보여줌  END LINE ------------------%>

	</section>
	<!-- --------------------------- END SECTION ---------------------------------->


	<!-- --------------------------- START FOOTER ---------------------------------->
	<footer> </footer>
	<!-- --------------------------- END FOOTER ------------------------------------>

</body>

<script type="text/javascript">
var request = new XMLHttpRequest();
var UserAuth = "<%=Auth%>";
var UserFarmID = "<%=FarmName%>";
var User_FarmID = "<%=userFarmID%>";

// 양식장의 수조 기록 정보를 가져올 비동기 통신 함수
	function RunAjax() {
		if (UserAuth.includes("관리자")) {
			// "양식장을 선택하세요" 선택 시 내용 초기화
			var optFarmID = document.getElementById("selectFarm");
			var FarmID = optFarmID.value;
			if (FarmID == "init") {
				var creDiv = document
						.getElementById("Main_Section_Contents_Admin");
				creDiv.innerHTML = "";
			} else {
				// 양식장 선택시 해당 양식장ID(farmid)를 서블릿 객체에 전달
				request.open("Post", "../../searchwtREC?FarmID=" + FarmID, true);
				request.onreadystatechange = function() {
					searchProcess(FarmID);
				};
				request.send(null);
			}
		} else if (UserAuth.includes("사용자")) {

			// 양식장 선택시 해당 양식장ID(farmid)를 서블릿 객체에 전달
			request.open("Post", "../../searchwtREC?FarmID=" + encodeURIComponent(User_FarmID), true);
			request.onreadystatechange = function() {
				searchProcessUser(User_FarmID);
			};
			request.send(null);

		} else {
		 }
	}


function goSelectedForm() {

		var obj = document.getElementById('selectFarm');
		var hidForm = document.selectFarm;
		var idx = obj.value;
	
		if ((idx == "init")){
			return;
		} else {
			console.log(FarmID);
			console.log(FarmName);
			FarmID = obj.value
			FarmName = obj.options[FarmID].text;
		}
	}


function _GetAjaxConnection() {
	setInterval("RunAjax()", 1900);
}


</script>

</html>
