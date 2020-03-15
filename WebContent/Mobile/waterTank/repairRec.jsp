<%
   /*==============================================================================
	 ■ SYSTEM				: SAF(Smart Aqua Farm) - 스마트 모니터링 시스템
	 ■ SOURCE FILE NAME		: Web/waterTank/stateRec.jsp
	 ■ DESCRIPTION			: 수조 조치기록 표시
	 ■ COMPANY				: 
	 ■ PROGRAMMER			: 문인찬
	 ■ DESIGNER				: 
	 ■ PROGRAM DATE			: 2019.08.23
	 ■ EDIT HISTORY			: 
	 ■ EDIT CONTENT			: 
	==============================================================================*/
%>
<%@page import="com.repair.repairDTO"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!-- <%@ include file="../include/include/session.inc" %> -->
<jsp:useBean id="strUtil" class="com.main.StringUtil"/>
<jsp:useBean id="repairDAO" class="com.repair.repairDAO"/>
<jsp:useBean id="farmDAO" class="com.farm.farmDAO"/>
<!DOCTYPE html>
<html>
	<head>
<%
		int FarmID = 0;
		// 한글 패치
		request.setCharacterEncoding("UTF-8");
		
		// 변수 받아오기
		// 양식장ID / 양식장 명 받아오기
		try {
			FarmID = Integer.parseInt(request.getParameter("FarmID"));
			System.out.println(FarmID);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		String farmName = farmDAO.farmidToName(FarmID);
		
		// 검색어 관련 변수(수조이름 / 상태기준정보명 / 상태 / 측정일시)
		String tankId = strUtil.nullToBlank(request.getParameter("tankId"));
		String fishName = strUtil.nullToBlank(request.getParameter("fishName"));
		String state = strUtil.nullToBlank(request.getParameter("state"));
		String sensorSDate = strUtil.nullToBlank(request.getParameter("sensorSDate"));
		String sensorEDate = strUtil.nullToBlank(request.getParameter("sensorEDate"));
		String lastUptSDate = strUtil.nullToBlank(request.getParameter("lastUptSDate"));
		String lastUptEDate = strUtil.nullToBlank(request.getParameter("lastUptEDate"));
		String sensorDate;
		String lastUptDate;
		
		// sensorSDate랑 sensorEDate가 공백이면 sensorDate에 공백 저장
		// 날짜 당일까지 포함하려고 이렇게 하였음.
		if(sensorSDate.equals("") && sensorEDate.equals("")){
			sensorDate = "";
		} else{
			sensorDate = "sensorDate >= to_date('" + sensorSDate + "','YYYY-MM-DD') "
						+ "and sensorDate < to_date('" + sensorEDate + "','YYYY-MM-DD') + 1";
		}
		
		// regSDate랑 regEDate가 공백이면 regDate에 공백 저장
		if(lastUptSDate.equals("") && lastUptEDate.equals("")){
			lastUptDate = "";
		} else{
			lastUptDate = "lastUptDate >= to_date('" + lastUptSDate + "','YYYY-MM-DD') "
						+ "and lastUptDate < to_date('" + lastUptEDate + "', 'YYYY-MM-DD') + 1";
		}
		
		// 검색결과를 저장하기 위한 변수
		ArrayList<repairDTO> repairADto = null;
		
		// 검색어를 저장하기 위한 변수
		repairDTO indto = new repairDTO();
		indto.setFarmId(FarmID);
		indto.setTankId(tankId);
		indto.setRemark(fishName);
		indto.setState(state);
		indto.setSensorDate(sensorDate);
		indto.setLastUptdate(lastUptDate);
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
			
			window.onload = function()
			{
				printClock();
				goInit();
			}
		</script>
	</head>
	<body>
		<!-- --------------------------- START HEADER ---------------------------------->
		<header>
			<%@ include file="../include/header.inc"%>
		</header>
		<!-- --------------------------- END  HEADER ----------------------------------->
		
		<!-- --------------------------- START SECTION --------------------------------->
		<section>
			<span id="titleName">조치기록보기(<%=farmName %>)</span>
			<hr>
			<br>
			<form method="POST" name="farmSelectedForm">
				수조이름 : <input type="text" name="tankId" value="<%=tankId %>" maxlength="10"/>
				어종 : <input type="text" name="fishName" value="<%=fishName %>" />
				<select name="state">
					<option value="">상태(이상명)</option>
					<option value="R">위험</option>
					<option value="Y">경고</option>
					<option value="G">안전</option>
				</select>
				<br>측정일시 : <input type="date" name="sensorSDate" value="<%=sensorSDate%>" > ~ <input type="date" name="sensorEDate" value="<%=sensorEDate%>">
				&nbsp;&nbsp;처리일시 : <input type="date" name="lastUptSDate" value="<%=lastUptSDate %>" > ~ <input type="date" name="lastUptEDate" value="<%=lastUptEDate%>" >
				<input type="button" value="조회" onclick="wtSearch()">
				<input type="button" value="초기화" onclick="wtSearchReset()">
				<!-- stateRec.jsp, repairRec.jsp 이동 위한 저장용도 -->
				<input type="hidden" name="FarmID" value="<%=FarmID %>"/>
			</form>
			<br>
<%
			repairADto = repairDAO.repairRec(indto);
%>
			<table id="repairTable">
				<tr id="repairTableTop">
					<td class="contents">수조이름</td>
					<td class="contents">어종</td>
					<td>측정일시</td>
					<td class="contents">상태</td>
					<td>처리일시</td>
					<td class="contents">처리자</td>
					<td class="repairContents">조치내용</td>
				</tr>
<%
				if(repairADto.isEmpty())
				{
%>
					<tr>
						<td colspan="7"> 측정된 Data가 없습니다.</td>
					</tr>
<%
				}
				else
				{
					for(int i=0; i<repairADto.size(); i++)
					{
						repairDTO dto = repairADto.get(i);
%>
						<tr class="recTableMain listMouseEvent-pointer" onclick="wtCautionRepairContentsUpdate('<%=farmName%>','<%=dto.getTankId()%>',<%=dto.getRepairSeq()%>,<%=dto.getRecSeq()%>)">
							<td><%=dto.getTankId() %></td>
							<td><%=dto.getRemark() %></td>
							<td><%=dto.getSensorDate() %></td>
							<td><%=dto.getState() %><br>&nbsp;<%=dto.getYrCode() %></td>
							<td><%=dto.getLastUptdate() %></td>
							<td><%=dto.getLastUptId() %></td>
							<td><%=dto.getRepairContents() %></td>
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