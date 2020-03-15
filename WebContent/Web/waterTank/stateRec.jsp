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
		int farmId = 3;//Integer.parseInt(request.getParameter("farmID"));
		String farmName = farmDao.farmidToName(farmId);
		
		// 페이징에 필요한 변수
		int pageListSize = 7; // 한페이지에 나오는 리스트 개수
		int pageSize = 10; // 한번에 표현할 페이지 개수
		int nowPage = 1; // 현재 페이지 저장할 변수
		int listTotalSize; // rownum 조건을 붙이지 않은 검색 결과 개수 저장 용도
		
		//페이지에 보여질 리스트의 시작과 끝 번호(rownum 시작 / 끝)
		int listStart;
		int listEnd;
		
		if(request.getParameter("nowPage") != null){
	    	nowPage = Integer.parseInt(request.getParameter("nowPage"));
	    }
		
		listStart = (nowPage * pageListSize) - pageListSize + 1;
		listEnd = listStart + pageListSize - 1;
		
		// 검색어 관련 변수(수조이름 / 어종 / 상태기준정보명 / 측정일시(검색용도, 시작/끝/통합))
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
		indto.setFarmId(farmId);
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
			
			// paging 할때 검색어 유지를 하려고 따로 검색값 저장 해둠
			var searchList = {tankId:"<%=tankId %>", fishName:"<%=fishName %>", state:"<%=state%>", sensorSDate:"<%=sensorSDate%>", sensorEDate:"<%=sensorEDate%>"}
			
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
				<input type="button" value="초기화" id="btnReset" onclick="wtSearchReset()" />
				<!-- stateRec.jsp, repairRec.jsp 이동 위한 저장용도 -->
				<input type="hidden" name="selectedFarmId" value="<%=farmId %>"/>
				<!-- 페이징 이동용도 -->
				<input type="hidden" name="nowPage" value="<%=nowPage %>" />
			</form>
			<br>
<%
			// 출력할 List 뽑아오기
			recADto = recDao.RecList(indto);

			// 검색 결과 개수 뽑기
			listTotalSize = recDao.recTableListSize();
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
					<tr>
						<td colspan="10">
<%
						boolean next, prev; // next, prev 버튼이 보일지 안보일지 저장하는 변수
                  		int pageEnd = ((nowPage + (pageSize - 1)) / pageSize) * pageSize;
						// https://cbts.tistory.com/294?category=651229 참고
						int pageStart = pageEnd - (pageSize - 1);
						int totalPage = ((listTotalSize - 1)/pageListSize) + 1;
						// 총 리스트 개수 102개, 페이지당 보여지는 개수 10개 일때 총 필요한 페이지 수는 11p
						// 즉 102/10 --> 10 + 1    99 / 10 --> 9 + 1 수학 함수 안쓰고 수식으로 계산하려고 이런식으로 함 
						
						
						prev = (pageStart==1) ? false : true; // nowPage가 11이상일 때만 prev가 나옴

						if(prev){
%>
							<input type="button" value="◀" onclick="wtPageSearch(<%=pageEnd %>-<%=pageSize %>,searchList)">
<%
						}
						
						if(totalPage <= pageEnd){
							pageEnd = totalPage;
							next = false;
						}else{
							next = true;
						}
						
                  		for(; pageStart <= pageEnd; pageStart++){
                  			if(pageStart == nowPage){
%>
								<input style="background-color:gold" type="button" value=" <%=pageStart %> " onclick="wtPageSearch(<%=pageStart %>,searchList)" />
<%
                  			}else{
%>
								<input type="button" value=" <%=pageStart %> " onclick="wtPageSearch(<%=pageStart %>,searchList)" />
<%
							}
						}
                  		
						if(next){
%>
							<input type="button" value="▶" onclick="wtPageSearch(<%=pageEnd %>+1,searchList)">
<%
						}
%>
						</td>
					</tr>
			</table>
		</section>
		<!-- --------------------------- START FOOTER ---------------------------------->
		
		<!-- --------------------------- START FOOTER ---------------------------------->
		<footer>
			<%@ include file="../include/include/footer.inc"%>
		</footer>
		<!-- --------------------------- END FOOTER ------------------------------------>
	</body>
</html>