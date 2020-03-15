<%
   /*==============================================================================
	 ■ SYSTEM				: SAF(Smart Aqua Farm) - 스마트 모니터링 시스템
	 ■ SOURCE FILE NAME		: growInfo/growInfoInsert.jsp
	 ■ DESCRIPTION			: 상태기준정보 등록 화면
	 ■ COMPANY				: 
	 ■ PROGRAMMER			: 윤건주
	 ■ DESIGNER				: 
	 ■ PROGRAM DATE			: 2019.08.19
	 ■ EDIT HISTORY			: 
	 ■ EDIT CONTENT			: 
	==============================================================================*/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/include/session.inc" %>
<!DOCTYPE html>
<html>
	<head>
<%
/* 		int selectFarmId = Integer.parseInt(request.getParameter("selectedFarmId")); */
%>
		<meta charset="EUC-KR">
		<title>스마트 모니터링 시스템</title>
		<link rel="stylesheet" href="../include/css/common.css">
		<script type="text/javascript" src="../include/js/common.js"></script>
		<script>
			// 양식장 검색
			function farmSearch() {
				//팝업창 
				window.open("farmSearch.jsp", "confirm", "toolbar=no, location=no, status=no, menubar=no, scrollbars=no, resizable=no, width=480px, height=500px");
			}
			
			// 등록
			function goInsert()
			{
				var frm = document.farmSelectedForm;
				
				if(frm.fishName.value == "")
				{	// 정보명 빈칸확인
					alert("상태기준정보명을 입력하세요");
					return;
				}
				else if(frm.farmId.value == "")
				{	// 양식장 선택확인
					alert("양식장을 선택해 주세요.");
					return;
				}
				else
				{
					if(confirm("입력한 상태기준정보를 등록하시겠습니까?"))
					{
						frm.target = "_self";
						frm.action = "growInfoPrc.jsp";
						frm.method = "post";
						frm.submit();
					}
				}
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
			<span id="titleName">상태기준정보 등록</span>
			<hr>
			<br>
			<div>
				<input type="button" id="btnInsert" onclick="goInsert()"/>&nbsp;&nbsp;&nbsp;&nbsp;
				<input type="button" id="btnList" onclick="goList()"/>
			</div>
			<br>
			
			<form name="farmSelectedForm">
				<table id="growInfoTable">
					<tr>
						<!-- 양식장 선택 -->
						<td colspan="4" class="growInfoTableTop">양식장&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="button" onclick="farmSearch()" id="btnFarmSearch"/>
						</td>
						<!-- farmID -->
						<td colspan="4" class="growInfoTableTop">
							<span id="farmName">조회 버튼을 이용하여 입력하세요</span>
							<input type="hidden" name="farmId" value=""/>
						</td>
						<!-- 어종입력/fishName -->
						<td colspan="4" class="growInfoTableTop">상태기준정보명</td>
						<td colspan="4" class="growInfoTableTop"><input id="growInfoLabel" type="text" name="fishName" maxlength="20" required="required" value=""/></td>
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
											<td><input type="text" maxlength="7" name="<%= item[i]%><%=j%>" onkeyup="fncDigit(this);"/></td>
											<%
										}
										else
										{
											%>
											<td colspan="2"><input type="text" maxlength="7" name="<%= item[i]%><%=j%>" onkeyup="fncDigit(this);"/></td>
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
				<input type="hidden" name="flag" value="i" />
				<%-- <input type="hidden" name="selectedFarmId" value="<%=selectFarmId %>"/> --%>
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