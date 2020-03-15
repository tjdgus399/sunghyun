<%
   /*==============================================================================
	 ■ SYSTEM				: SAF(Smart Aqua Farm) - 스마트 모니터링 시스템
	 ■ SOURCE FILE NAME		: Mobile/waterTank/stateRec.jsp
	 ■ DESCRIPTION			: 수조 상태기록 표시
	 ■ COMPANY				: 
	 ■ PROGRAMMER			: 문인찬
	 ■ DESIGNER				: 
	 ■ PROGRAM DATE			: 2019.08.23
	 ■ EDIT HISTORY			: 
	 ■ EDIT CONTENT			: 
	==============================================================================*/
%>
<%@page import="com.rec.recDTO"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/SessionState.inc" %>
<jsp:useBean id="strUtil" class="com.main.StringUtil"/>
<jsp:useBean id="farmDao" class="com.farm.farmDAO"/>
<jsp:useBean id="recDao" class="com.rec.recDAO"/>
<!DOCTYPE html>
<html>
	<head>
<%
	// 한글 패치
	request.setCharacterEncoding("UTF-8");

	// 변수 받아오기
	// 양식장ID / 양식장 명 받아오기
	int FarmID = Integer.parseInt(request.getParameter("FarmID"));
	String farmName = farmDao.farmidToName(FarmID);
	
	// 검색어 관련 변수(수조이름 / 상태기준정보명 / 상태 / 측정일시)
	String tankId = strUtil.nullToBlank(request.getParameter("tankId"));
	String fishName = strUtil.nullToBlank(request.getParameter("fishName"));
	String state = strUtil.nullToBlank(request.getParameter("state"));
	String sensorSDate = strUtil.nullToBlank(request.getParameter("sensorSDate"));
	String sensorEDate = strUtil.nullToBlank(request.getParameter("sensorEDate"));
	String sensorDate;
	
	// sensorSDate랑 sensorEDate가 공백이면 sensorDate에 공백 저장
	if(sensorSDate.equals("") && sensorEDate.equals("")){
		sensorDate = "";
	} else{
		sensorDate = "sensorDate >= to_date('" + sensorSDate + "','YYYY-MM-DD') "
					+ "and sensorDate < to_date('" + sensorEDate + "','YYYY-MM-DD') + 1";
	}
	
	// 검색결과를 저장하기 위한 변수
	ArrayList<recDTO> recADto = null;
	
	// 검색어를 저장하기 위한 변수
	recDTO indto = new recDTO();
	indto.setFarmId(FarmID);
	indto.setTankId(tankId);
	indto.setRemark(fishName);
	indto.setState(state);
	indto.setSensorDate(sensorDate);
%>
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>스마트 모니터링 시스템</title>
	
	<!--  Jquery Mobile CSS Include  -->
	<link rel="stylesheet" href="../common/style.css" />
	<link rel="stylesheet" href="../common/jquery/jquery.mobile-1.0.1.css" />
	
	<!--  Jquery Mobile JS Include  -->
	<script src="../common/jquery/demos/jquery.js"></script>
	<script src="../common/jquery/jquery.mobile-1.0.1.js"></script>
	
	<script type="text/javascript" src="../common/main.js"></script>
	
	<script>
		var FarmID;
		FarmID = <%= FarmID %>;
	
		// select 박스 선택
		// 화면 초기화시 (화면로딩후 시작후 바로)
		function goInit(){
			var frm = document.farmSelectedForm;
			var state = frm.state;
			state.value = "<%=state%>";
		}
		
		window.onload = function(){
			goInit();
		}
	</script>
	</head>
	<body>
		<!-- --------------------------- START HEADER ---------------------------------->
		<header data-role="header">
			<%@ include file="../include/headerTitle.inc" %>
		</header>
		<!-- --------------------------- END  HEADER ----------------------------------->
		
		<!-- --------------------------- START SECTION --------------------------------->
		<section data-role="section" class="waterTank-Mobile">
			<%@include file="../include/headerMenu.inc" %>
			<div id="titleName">상태기록보기(<%=farmName %>)</div>
			
			<hr>
			<br>
			<form name="farmSelectedForm">
				<div data-role="fieldcontain">
					<div class="ui-grid-a">
						<div class="ui-block-a">
							<label for="tankId">수조명</label>
							<input type="text" name="tankId" id="tankId" value="<%=tankId %>" maxlength="10"/>
						</div>
						<div class="ui-block-b">
							<label for="fishName">어종</label>
							<input type="text" name="fishName" id="fishName" value="<%=fishName %>" maxlength="10"/>
						</div>
					</div>
					<select name="state">
						<option value="">상태선택</option>
						<option value="G">안전</option>
						<option value="Y">경고</option>
						<option value="R">위험</option>
					</select>
					<br>
					측정일시 입력(시작날짜, 끝날짜)
					<br><br>
					<div class="ui-grid-a">
						<div class="ui-block-a">
							<input type="date" name="sensorSDate" value="<%=sensorSDate%>">
						</div>
						<div class="ui-block-b">
							<input type="date" name="sensorEDate" value="<%=sensorEDate%>">
						</div>
					</div>
					<!-- stateRec.jsp, repairRec.jsp 이동 위한 저장용도 -->
					<input type="hidden" name="selectedFarmId" value="<%=FarmID %>"/>
				</div>
				<div data-role="fieldcontain">
					<div class="ui-grid-a">
						<div class="ui-block-a">
							<input type="button" value="조회" onclick="wtSearch()"/>
						</div>
						<div class="ui-block-b">
							<input type="button" value="초기화" onclick="wtSearchReset()" />
						</div>
					</div>
				</div>
				<!-- stateRec.jsp, repairRec.jsp 이동 위한 저장용도 -->
				<input type="hidden" name="selectedFarmId" value="<%=FarmID %>"/>
			</form>
			<br>
<%
			recADto = recDao.RecList(indto);

				if(recADto.isEmpty()){
%>					<table id="recTable">
						<tr>
							<td colspan="10"> 측정된 Data가 없습니다.</td>
						</tr>
					</table>
<%
				} else {
					for(int i=0; i<recADto.size(); i++){
						recDTO dto = recADto.get(i);
%>					
					<table id="recTable">
						<tr>
							<td>측정일시</td><td><%=dto.getSensorDate() %></td>
						</tr>
						<tr>
							<td>수조이름</td><td><%=dto.getTankId() %></td>
						</tr>	
						<tr>
							<td>어종</td><td><%=dto.getRemark() %></td>
						</tr>	
						<tr>
							<td>상태</td><td><%=dto.getState() %><br><%=dto.getYrCode() %></td>
						</tr>	
						<tr>	
							<td>DO<br>(mg/L)</td><td><%=dto.getDoRec() %></td>
						</tr>	
						<tr>	
							<td>수온<br>(°C)</td><td><%=dto.getWtRec() %></td>
						</tr>	
						<tr>	
							<td>염도<br>(psu)</td><td><%=dto.getPsuRec() %></td>
						</tr>	
						<tr>	
							<td>pH</td><td><%=dto.getPhRec() %></td>
						</tr>	
						<tr>	
							<td>NH4<br>(mg/L)</td><td><%=dto.getNh4Rec() %></td>
						</tr>	
						<tr>	
							<td>NO2<br>(mg/L)</td><td><%=dto.getNo2Rec() %></td>
						</tr>
					</table>
					<br>
<%
					} // for 끝
				}	// if 종료
%>
		</section>
		<!-- --------------------------- END SECTION ---------------------------------->
		
		<!-- --------------------------- START FOOTER ---------------------------------->
		<footer data-role="footer" data-position="fixed">
			<%@ include file="../include/footer.inc"%>
		</footer>
		<!-- --------------------------- END FOOTER ------------------------------------>
	</body>
</html>