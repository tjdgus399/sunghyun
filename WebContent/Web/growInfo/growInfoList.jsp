<%
   /*==============================================================================
	 ■ SYSTEM				: SAF(Smart Aqua Farm) - 스마트 모니터링 시스템
	 ■ SOURCE FILE NAME		: growInfo/growInfoList.jsp
	 ■ DESCRIPTION			: 상태기준정보 리스트 화면
	 ■ COMPANY				: 
	 ■ PROGRAMMER			: 윤건주
	 ■ DESIGNER				: 
	 ■ PROGRAM DATE			: 2019.08.14
	 ■ EDIT HISTORY			: 
	 ■ EDIT CONTENT			: 
	==============================================================================*/
%>
<%@ page import="com.growInfo.growInfoDTO"%>
<%@ page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/include/session.inc" %>
<jsp:useBean id="growDAO" class="com.growInfo.growInfoDAO" />
<jsp:useBean id="StrUtil" class="com.main.StringUtil" />
<!DOCTYPE html>
<html>
	<head>
<%
		// 인코딩/한글패치
		request.setCharacterEncoding("UTF-8");
	
		// 변수선언
		// 메소드 return용
		ArrayList<growInfoDTO> list = null;
		
		// 검색에 사용하는 변수
		String searchFarm = StrUtil.nullToBlank(request.getParameter("farmNamekeyWord"));
		String searchFish = StrUtil.nullToBlank(request.getParameter("fishNamekeyWord"));
		/* int selectFarmId = Integer.parseInt(request.getParameter("selectFarm")); */
%>
		<meta charset="EUC-KR">
		<title>스마트 모니터링 시스템</title>
		<link rel="stylesheet" href="../include/css/common.css">
		<script type="text/javascript" src="../include/js/common.js"></script>
		<script>
			// 등록
			function goInsert()
			{
				var frm = document.farmSelectedForm;
				frm.method = "post";
				frm.action = "growInfoInsert.jsp";
				frm.target = "_self";
				frm.submit();
			}
			
			// 읽기
			function goRead(farmId, groupcode, remark)
			{
				var frm = document.farmSelectedForm;
				
				frm.farmId.value = farmId;
				frm.groupcode.value = groupcode;
				frm.farmNameAddress.value = remark;
				
				frm.method = "post";
				frm.action = "growInfoRead.jsp";
				frm.target = "_self";
				frm.submit();
			}
			
			// 검색
			function goSearch()
			{
				var frm = document.farmSelectedForm;
				
				frm.farmNamekeyWord.value = frm.searchFarm.value;
				frm.fishNamekeyWord.value = frm.searchFish.value;
				
				frm.method = "post";
				frm.action = "growInfoList.jsp";
				frm.target = "_self";
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
			<span id="titleName">등록된 상태기준정보 목록</span>
			<hr>
			<form name="farmSelectedForm">
				<br>
				<br>
				<!-- 검색하기 위한 칸 -->
				<span id="searchLabel">검색어 입력</span><br>
				<br>
				<span class="searchLabel">양식장이름 : </span><input type="text" name="searchFarm" class="searchForm" value="<%=searchFarm %>"/>&nbsp;&nbsp;|&nbsp;&nbsp; 
				<span class="searchLabel">상태기준정보명 : </span><input type="text" name="searchFish" class="searchForm" value="<%=searchFish %>"/>&nbsp;&nbsp;
				<br>
				<br>
				<br>
				<input type="button" id="btnSearch" onclick="goSearch()"/>
<%
				if(!Auth.equals("사용자"))
				{	// 사용자를 제외한 나머지만 양식정보 등록 가능
%>
					&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" id="btnInsert" onclick="goInsert()"/>
<%
				}
%>
				<br>
				<br>
				<br>
				<br>
				<table id="growListTable">
					<tr id="growListTr">
						<td>양식장이름</td>
						<td>상태기준정보명</td>
					</tr>
<%
					list = growDAO.listData(ID, Auth, searchFarm, searchFish);
					if(list.isEmpty())
					{	// 리스트가 비어있을 경우
%>
						<tr>
							<td colspan="3">
								<br>
								<br>
								<br>
								<br>
								입력된 양식장 및 상태기준정보가 없습니다.
								<br>
								<br>
								<br>
								<br>
							</td>
						</tr>
<%
					}
					else
					{	// 리스트 출력
						for(int i=0; i<list.size(); i++)
						{	// DTO에 저장
							growInfoDTO dto = list.get(i);
%>
							<tr class="selectGrowList" onclick="goRead('<%=dto.getFarmId()%>', '<%=dto.getGroupCode()%>', '<%=dto.getRemark()%>')">
								<!-- 양식장 이름 -->
								<td><%=dto.getRemark() %></td>
								<!-- 양식정보이름 -->
								<td><%=dto.getFishName() %></td>
							</tr>
<%
						}
					}
%>
				</table>
				<!-- 읽기에 필요한 변수저장 -->
				<input type="hidden" name="FarmID"/>
				<input type="hidden" name="groupcode"/>
				<input type="hidden" name="farmNameAddress"/>
				<input type="hidden" name="farmNamekeyWord" value="<%=searchFarm %>"/>
				<input type="hidden" name="fishNamekeyWord" value="<%=searchFish %>"/>
		<%-- 		<input type="hidden" name="selectedFarmId" value="<%=selectFarmId %>"/> --%>
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