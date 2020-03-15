<!-- 
   /*==============================================================================
    ■ SYSTEM            : 
    ■ SOURCE FILE NAME  : main.jsp
    ■ DESCRIPTION       : 수조 정보 모니터링 (메인 화면)
    ■ COMPANY           : 목포대학교 융합소프트웨어공학과
    ■ PROGRAMMER        : 고지안
    ■ DESIGNER          : 
    ■ PROGRAM DATE      : 2019.08.19
    ■ EDIT HISTORY      : 
    ■ EDIT CONTENT      : 
   ==============================================================================*/
 -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/SessionState.inc"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>스마트 양식장</title>

<!--  Jquery Mobile CSS Include  -->
<link rel="stylesheet" href="../common/style.css" />
<link rel="stylesheet" href="../common/jquery/jquery.mobile-1.0.1.css" />
<!--  수조 정보CSS -->
<style type="text/css">
.ui-grid-b {
	align : center;
	position : relative;
	top : 10px;
}
/*한 행에 3개의 수조 정보를 나타냄*/
.ui-block-e {
	font-size :12px;
	font-weight: 500;
	width: 32.5%;
	height: 33%;
	text-align: left;

}

/* "조치" 버튼 레이아웃*/
button#flow{
	width :100%;
	height :20%;
	color : blue;
	background-image: linear-gradient(to right, #1CD8D2 0%, #93EDC7 51%, #1CD8D2 100%);
}

/*각 수조에 대한 이상 표시를 나타내기 위함*/
#monitorContent{
	font-size :12px;
	font-weight: 900;
	color : black;
	background :linear-gradient(45deg, white 55%, transparent);
	vertical-align:top;
	position : relative;
	left : 1.5%;
}

/* 전체 수조 정보 바깥 영역에 대한 크기 조절*/
#Main_Section_Contents_Admin
{
	vertical-align:top;
	display:left;
	flex:1;
	
}
</style>
<script src="../common/main.js"></script>

<!-- JavaScript ASYNC INCLUDE -->
<script src="../common/async/Monitoring.js"></script>

<!--  Jquery Mobile JS Include  -->
<script src="../common/jquery/demos/jquery.js"></script>
<script src="../common/jquery/jquery.mobile-1.0.1.js"></script>

<!-- 양식장 선택 시 해당 양식장의 "아이디"와 "이름"을 가져옴  -->
<script type="text/javascript">
var FarmID;
var FarmName;

function goSelectedForm() {
	
	var obj = document.getElementById('selectFarm');
	var text = obj.options[obj.selectedIndex].text
	var value =  obj.options[obj.selectedIndex].value
	
	console.log(text);
	console.log(value);
	
	if ((value == "init")){
		FarmID = "init";
		
	} else {
		FarmID = value;
		FarmName = text;
	
	}
}



function gofarmtwtSearch(param1) {
	if(typeof param1 == "undefined") {
		alert("양식장을 선택해주세요");
		return;
	} 
	
	
	if(param1 == "init"){
		alert("양식장을 선택해주세요");
		return;
	}
	
	location.href = "../farm/farmwtSearch.jsp?FarmID="+param1;
}

</script>

</head>
<body onload="_GetAjaxConnection()">
	<%
		System.out.println("=========" + Session_ID);
	%>

	<header data-role="header" data-position="fixed">
		<%@ include file="../include/headerTitle.inc" %>
	</header>
	
	<section data-role="section">
		<%@include file="../include/headerMenu.inc" %>
		<%!// "관리자용" 아이디의 서블릿과 연결될 전역변수
		int wtNumber = 0;
		String FarmName = null;
		//일반 사용자
		int userFarmID = 0;
		%>
	
		<%@include file="./mainPrcMob.jsp"%>
		<%------------  "일반관리자" 권한을 가진 유저의 수조정보 데이터를 보여줌  START LINE ------------------%>
		<%
			if (Session_Auth.contains("일반관리자")) {
		%>
		<div class="ui-grid-a" data-type="horizontal" >

			<div class="ui-block-c" data-inline="true">
				<select id="selectFarm" name="selectFarm" onchange="goSelectedForm()">
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
		</div>

		<div class="ui-grid-b">
				<div id="Main_Section_Contents_Admin">
				
				</div>
		</div>

		<%------------  "일반관리자" 권한을 가진 유저의 수조정보 데이터를 보여줌  END LINE ------------------%>

		<%------------  "사용자" 권한을 가진 유저의 수조정보 데이터를 보여줌  START LINE ------------------%>

		<%
		} else if (Session_Auth.contains("사용자")) {
			userFarmID = farm_list.get(0).getFarmId();
			FarmName = farm_list.get(0).getFarmName();
			
		%>
		
		<input  data-role="button" type="button" value="<%=FarmName%>"/>
		
		<div class="ui-grid-b">
				<div id="Main_Section_Contents_User">
				
				</div>
		</div>
		
		
		
		<% } else {System.out.println("[+]Not Found ID");}%>
		<%------------  "사용자" 권한을 가진 유저의 수조정보 데이터를 보여줌  END LINE ------------------%>
	</section>
	
	<footer data-role="footer" data-position="fixed">
		<%@ include file="../include/footer.inc"%>
	</footer>
	

</body>

<script type="text/javascript">
var request = new XMLHttpRequest();
var UserAuth = "<%=Session_Auth%>";
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
				request.open("Post", "../../searchwtRECMob?FarmID=" + FarmID, true);
				request.onreadystatechange = function() {
					searchProcess(FarmID);
				};
				request.send(null);
			}
			
		} else if (UserAuth.includes("사용자")) {

			// 양식장 선택시 해당 양식장ID(farmid)를 서블릿 객체에 전달
			request.open("Post", "../../searchwtRECMob?FarmID=" + encodeURIComponent(User_FarmID), true);
			request.onreadystatechange = function() {
				searchProcessUser(User_FarmID);
			};
			request.send(null);

		} else {
		 }
	}
	
	
	function _GetAjaxConnection() {
		setInterval("RunAjax()", 1900);
	}
</script>
</html>