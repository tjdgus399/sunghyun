<%
   /*==============================================================================
	 ■ SYSTEM				: SAF(Smart Aqua Farm) - 스마트 모니터링 시스템
	 ■ SOURCE FILE NAME		: growInfo/growInfoRead.jsp
	 ■ DESCRIPTION			: 상태기준정보 보는 화면
	 ■ COMPANY				: 
	 ■ PROGRAMMER			: 윤건주
	 ■ DESIGNER				: 
	 ■ PROGRAM DATE			: 2019.08.16
	 ■ EDIT HISTORY			: 
	 ■ EDIT CONTENT			: 
	==============================================================================*/
%>
<%@page import="com.growInfo.growInfoDTO"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/include/session.inc" %>
<jsp:useBean id="gdao" class="com.growInfo.growInfoDAO"/>
<jsp:useBean id="StrUtil" class="com.main.StringUtil" />
<!DOCTYPE html>
<%
		// 인코딩/한글패치
		request.setCharacterEncoding("UTF-8");
		
		// 변수
		// 양식장/양식정보DTO
		ArrayList<growInfoDTO> gadto = null;
		
		// request 값 받아오기
		// 양식장ID / 양식장이름 / 그룹코드 / list에서 사용했던 keyWord(2개)
		int FarmID = Integer.parseInt(request.getParameter("FarmID"));
		String farmName = request.getParameter("farmNameAddress");
		int groupcode = Integer.parseInt(request.getParameter("groupcode"));
		String farmNamekeyWord = StrUtil.nullToBlank(request.getParameter("farmNamekeyWord"));
		String fishNamekeyWord = StrUtil.nullToBlank(request.getParameter("fishNamekeyWord"));
	/* 	int selectFarmId = Integer.parseInt(request.getParameter("selectedFarmId")); */
%>
<html>
	<head>
		<meta charset="EUC-KR">
		<title>스마트 모니터링 시스템</title>
		<link rel="stylesheet" href="../include/css/common.css">
		<script type="text/javascript" src="../include/js/common.js"></script>
		<script>			
			// 수정
			function goUpdate()
			{
				var frm = document.farmSelectedForm;
				
				frm.target = "_self";
				frm.action = "growInfoUpdate.jsp";
				frm.method = "post";
				frm.submit();
			}
			
			// 리스트
			function goList()
			{
				var frm = document.farmSelectedForm;
				frm.target = "_self";
				frm.action = "growInfoList.jsp";
				frm.method = "post";
				frm.submit();
			}
			
			// 삭제
			function goDelete()
			{
				var frm = document.farmSelectedForm;
				if(confirm("삭제를 하시겠습니까?"))
				{
					frm.target = "_self";
					frm.action = "growInfoPrc.jsp";
					frm.method = "post";
					frm.submit();
				}
			}
			
			window.onload = function()
			{
				printClock();
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
			<span id="titleName">상태기준정보 보기</span>
			<hr>
			<br>
			<div>
<%
				if(!Auth.equals("사용자"))
				{
%>
					<input type="button" id="btnUpt" onclick="goUpdate()"/>&nbsp;&nbsp;&nbsp;&nbsp;
					<input type="button" id="btnDel" onclick="goDelete()"/>&nbsp;&nbsp;&nbsp;&nbsp;	
<%
				}
%>
				<input type="button" id="btnList" onclick="goList()"/>
			</div>
			<br>
			
			<form name="farmSelectedForm">
				<table id="growInfoTable">
<%
					gadto = gdao.readGrowInfo(FarmID, groupcode);	// 데이터 불러오기
%>
					<tr>
						<!-- 양식장 선택 -->
						<td colspan="4" class="growInfoTableTop">양식장</td>
						<!-- farmID -->
						<td colspan="4" class="growInfoTableTop">
							<span id="farmName"><%=farmName %></span>
							<input type="hidden" name="farmId" value="<%=FarmID%>"/>
						</td>
						<!-- 어종입력/fishName -->
						<td colspan="4" class="growInfoTableTop">상태기준정보명</td>
						<td colspan="4" class="growInfoTableTop">
							<%=gadto.get(0).getFishName() %>
						</td>
					</tr>
					<!-- 구분 -->
					<tr>
						<td class="subTitle">항목</td>
						<td colspan="3" class="mark0">위험</td>
						<td colspan="3" class="mark1">경고</td>
						<td colspan="3" class="mark2">정상</td>
						<td colspan="3" class="mark3">경고</td>
						<td colspan="3" class="mark4">위험</td>
					</tr>
					<%
						String item[] = {"DO", "WT", "psu", "pH", "NH4", "NO2"};
						String explan[] = {"(용존산소)", "(수온)", "(염도)", "(산도)", "(암모니아)", "(아질산)"};
						
						Double itembox[][] = {	{gadto.get(0).getDOMin(), gadto.get(0).getDOMax(),
												gadto.get(1).getDOMin(), gadto.get(1).getDOMax(),
												gadto.get(2).getDOMin(), gadto.get(2).getDOMax()},
												{gadto.get(0).getWTMin(), gadto.get(0).getWTMax(),
												gadto.get(1).getWTMin(), gadto.get(1).getWTMax(),
												gadto.get(2).getWTMin(), gadto.get(2).getWTMax()},
												{gadto.get(0).getPsuMin(), gadto.get(0).getPsuMax(),
												gadto.get(1).getPsuMin(), gadto.get(1).getPsuMax(),
												gadto.get(2).getPsuMin(), gadto.get(2).getPsuMax()},
												{gadto.get(0).getpHMin(), gadto.get(0).getpHMax(),
												gadto.get(1).getpHMin(), gadto.get(1).getpHMax(),
												gadto.get(2).getpHMin(), gadto.get(2).getpHMax()},
												{gadto.get(0).getNH4Min(), gadto.get(0).getNH4Max(),
												gadto.get(1).getNH4Min(), gadto.get(1).getNH4Max(),
												gadto.get(2).getNH4Min(), gadto.get(2).getNH4Max()},
												{gadto.get(0).getNO2Min(), gadto.get(0).getNO2Max(),
												gadto.get(1).getNO2Min(), gadto.get(1).getNO2Max(),
												gadto.get(2).getNO2Min(), gadto.get(2).getNO2Max()}};
						
						for(int i=0; i<6; i++)
						{	// for i start | item[] 나타내는 반복문
							%>
							<tr>
								<td class="subTitle"><%= item[i]%><br><%=explan[i] %></td>
								<%
									for(int j=0; j<6; j++)
									{	// for j start
										if(j==0 || j ==5)
										{
											%>
											<td class="valueFont"><%=StrUtil.noneToBar(itembox[i][j]) %></td>
											<%
										}
										else
										{
											%>
											<td colspan="2" class="valueFont"><%=StrUtil.noneToBar(itembox[i][j]) %></td>
											<%
										}
										
										if(!(j==5)) // j가 5일때 표현x
										{
											%>
											<td class="mark<%=j%>">~</td>
											<%
										}
									} // for j end
								%>
							</tr>
						 	<%
						} // for i end
					%>
				</table>
				
				<!-- Prc동작변수 / 양식장ID와 이름 / 정보식별을 위한 그룹코드 / 검색어 2개 -->
				<input type="hidden" name="flag" value="d" />
				<input type="hidden" name="FarmID" value="<%=FarmID%>"/>
				<input type="hidden" name="groupcode" value="<%=groupcode%>"/>
				<input type="hidden" name="farmName" value="<%=farmName%>"/>
				<input type="hidden" name="farmNamekeyWord" value="<%=farmNamekeyWord%>"/>
				<input type="hidden" name="fishNamekeyWord" value="<%=fishNamekeyWord%>"/>
				<%-- <input type="hidden" name="selectedFarmId" value="<%=selectFarmId %>"/>--%>
			</form>
		</section>
		<!-- --------------------------- END SECTION ---------------------------------->
		
		<!-- --------------------------- START FOOTER ---------------------------------->
		<footer>
			<%@ include file="../include/include/footer.inc"%>
		</footer>
		<!-- --------------------------- END FOOTER ------------------------------------>
	</body>
</html>