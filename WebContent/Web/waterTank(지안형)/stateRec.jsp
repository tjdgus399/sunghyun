<%
   /*==============================================================================
	 ■ SYSTEM				: SAF(Smart Aqua Farm) - 스마트 모니터링 시스템
	 ■ SOURCE FILE NAME		: Web/waterTank/stateRec.jsp
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
<!--  <%@ include file="../include/include/session.inc" %> -->
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
		<meta charset="EUC-KR">
		<title>스마트 모니터링 시스템</title>
		<link rel="stylesheet" href="../include/css/common.css">
		<script type="text/javascript" src="../include/js/common.js"></script>
		<script>
			// select 박스 선택
			// 화면 초기화시 (화면로딩후 시작후 바로)
			function goInit(){
				var frm = document.farmSelectedForm;
				var state = frm.state;
				state.value = "<%=state%>";
			}
			
			function paging(){
				
			}
			
			window.onload = function(){
				printClock();
				goInit();
			}
		</script>
	</head>
	<body>
		<!-- --------------------------- START HEADER ---------------------------------->
		<header>
			<%@ include file="../include/include/header.inc"%>
		</header>
		<!-- --------------------------- END  HEADER ----------------------------------->
		
		<!-- --------------------------- START SECTION --------------------------------->
		<section>
			<span id="titleName">상태기록보기(<%=farmName %>)</span>
			<hr>
			<br>
			<form name="farmSelectedForm">
				수조명 : <input type="text" name="tankId" value="<%=tankId %>" maxlength="10"/>&nbsp;&nbsp;&nbsp;
				어종 : <input type="text" name="fishName" value="<%=fishName %>" />&nbsp;&nbsp;&nbsp;
				<select name="state">
					<option value="">상태선택</option>
					<option value="G">안전</option>
					<option value="Y">경고</option>
					<option value="R">위험</option>
				</select>&nbsp;&nbsp;&nbsp;&nbsp;
				측정기간 선택 : <input type="date" name="sensorSDate" value="<%=sensorSDate%>"> ~ <input type="date" name="sensorEDate" value="<%=sensorEDate%>">
				<input type="button" id="btnSearch" onclick="wtSearch()" />
				<input type="button" id="btnReset" onclick="wtSearchReset()" />
				<!-- stateRec.jsp, repairRec.jsp 이동 위한 저장용도 -->
				<input type="hidden" name="FarmID" value="<%=FarmID %>"/>
				<!-- 페이징 이동용도 -->
				<input type="hidden" name="nowPage" value="" />
			</form>
			<br>
<%
			recADto = recDao.RecList(indto);
%>
			<table id="recTable">
				<tr id="recTableTop">
					<td>측정일시</td>
					<td>수조이름</td>
					<td>어종</td>
					<td class="sensorValue">상태</td>
					<td class="sensorValue">DO<br>(mg/L)</td>
					<td class="sensorValue">수온<br>(°C)</td>
					<td class="sensorValue">염도<br>(psu)</td>
					<td class="sensorValue">pH</td>
					<td class="sensorValue">NH4<br>(mg/L)</td>
					<td class="sensorValue">NO2<br>(mg/L)</td>
				</tr>
<%
				if(recADto.isEmpty()){
%>
					<tr>
						<td colspan="10"> 측정된 Data가 없습니다.</td>
					</tr>
<%
				} else {
					for(int i=0; i<recADto.size(); i++){
						recDTO dto = recADto.get(i);
%>
						<tr class="recTableMain listMouseEvent-default">
							<td><%=dto.getSensorDate() %></td>
							<td><%=dto.getTankId() %></td>
							<td><%=dto.getRemark() %></td>
							<td><%=dto.getState() %><br>&nbsp;<%=dto.getYrCode() %></td>
							<td><%=dto.getDoRec() %></td>
							<td><%=dto.getWtRec() %></td>
							<td><%=dto.getPsuRec() %></td>
							<td><%=dto.getPhRec() %></td>
							<td><%=dto.getNh4Rec() %></td>
							<td><%=dto.getNo2Rec() %></td>
						</tr>
<%
					} // for i 끝
				}	// if 종료
%>
			</table>
		</section>
		<!-- --------------------------- END SECTION ---------------------------------->
		
		<!-- --------------------------- START FOOTER ---------------------------------->
		<footer>
			<%@ include file="../include/include/footer.inc"%>
		</footer>
		<!-- --------------------------- END FOOTER ------------------------------------>
	</body>
</html>