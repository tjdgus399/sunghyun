<%--
	■ SYSTEM                : SAF 양식장
	■ SOURCE FILE NAME      : growList.jsp
	■ DESCRIPTION           : 
	■ COMPANY               : 목포대학교 융합소프트웨어학과 
	■ PROGRAMMER            : 윤건주
	■ DESIGNER              : 
	■ PROGRAM DATE          : 2019.08.
	■ EDIT HISTORY          : 2019.08.16
	■ EDIT CONTENT          : 2019.08.16
--%>

<%@page import="com.growInfo.growInfoDTO"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<jsp:useBean id="gDAO" class="com.growInfo.growInfoDAO"/>
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
		String farmName = "";
		String fishName = "";
		
		// farmName의 검색어 들어있으면
		if(request.getParameter("farmNamekeyWord") != null)
		{
			farmName = request.getParameter("farmNamekeyWord");
		}
		
		// fishName의 검색어 들어있으면
		if(request.getParameter("fishNamekeyWord") != null)
		{
			fishName = request.getParameter("fishNamekeyWord");
		}
	%>
	<meta charset="EUC-KR">
		<title>스마트 모니터링 시스템</title>
		<link rel="stylesheet" href="../common/main.css">
		<script type="text/javascript">
			//등록으로 이동
			function goInsert()
			{
				var frm = document.listForm;
				frm.method = "post";
				frm.target = "_self";
				frm.action = "growInfoInsert.jsp";
				frm.submit();
				
			}
			
			//읽기
			function goRead(farmid, groupcode, farmName)
			{
				var frm = document.listForm;
				frm.farmid.value = farmid;
				frm.groupcode.value = groupcode;
				frm.farmNameAddress.value = farmName;
				frm.method = "post";
				frm.target = "_self";
				frm.action = "growInfoRead.jsp";
				frm.submit();
			}
			
			// 검색
			function search()
			{
				var frm = document.listForm;
				frm.farmNamekeyWord.value = frm.farmName.value;
				frm.fishNamekeyWord.value = frm.growInfoName.value;
				frm.method = "post";
				frm.action = "growList.jsp";
				frm.target = "_self";
				frm.submit();
			}
			
			// 검색해제
			function noSearch()
			{
				var frm = document.listForm;
				frm.farmNamekeyWord.value = "";
				frm.fishNamekeyWord.value = "";
				frm.method = "post";
				frm.action = "growList.jsp";
				frm.target = "_self";
				frm.submit();
			}
		</script>
	<link rel="stylesheet" href="../common/jqm-button/icon.css" />
	<link rel="stylesheet" href="../common/style.css" />
	</head>
	<body>
		<!-- 헤더 -->
		<header>
			<%@ include file="../include/include/header.inc" %>
		</header>
		
		<!-- 본문 -->
		<section style="height:740px;">
			<form name="listForm">
				<h1>양식정보보기</h1>
				<br>
				<% 
					if(Session_Auth.equals("전체관리자") || Session_Auth.equals("일반관리자"))
					{
						%>
						<input type="button" value="등록" onclick="goInsert()"/>
						<%
					}
				%>
				<br>
				<br>
				<br>
				양식장이름 : <input type="text" name="farmName" value="<%=farmName%>"/>&nbsp;&nbsp;|&nbsp;&nbsp; 
				양식정보명 : <input type="text" name="growInfoName" value="<%=fishName%>"/>&nbsp;&nbsp;
				<input type="button" value="검색" onclick="search()"/>
				<input type="button" value="초기화" onclick="noSearch()"/>
				<br>
				<br>
				<table>
					<tr>
						<td>정보보기</td>
						<td>양식장이름</td>
						<td>양식정보명</td>
					</tr>
					<%
						list = gDAO.listData(Session_ID, Session_Auth, farmName, fishName);
						if(list.isEmpty())
						{
							%>
							<tr>
								<td colspan="3">
									<br>
									<br>
									<br>
									<br>
									입력된 양식장 및 양식정보가 없습니다.
									<br>
									<br>
									<br>
									<br>
								</td>
							</tr>
							<%
						}
						else
						{
							for(int i=0; i<list.size(); i++)
							{
								growInfoDTO dto = list.get(i);
								%>
								<tr>
									<!-- 읽기로 이동 버튼 -->
									<td><input type="button" onclick="goRead('<%=dto.getFarmId() %>', '<%=dto.getGroupCode() %>', '<%=dto.getRemark() %>')" value="보기"/></td>
									<!-- 양식장 이름 -->
									<td><%=dto.getRemark() %></td>
									<!-- 양식정보이름 -->
									<td><%=dto.getFishName() %></td>
								</tr>
								<%
							}
						}
					%>
					<tr>
					</tr>
				</table>
				<input type="hidden" name="FarmID"/>
				<input type="hidden" name="groupcode"/>
				<input type="hidden" name="farmNameAddress"/>
				<input type="hidden" name="farmNamekeyWord"/>
				<input type="hidden" name="fishNamekeyWord"/>
			</form>
		</section>
		
		<!-- 푸터 -->
		<footer>
			<%@ include file="../include/footer.inc" %>
		</footer>
	</body>
</html>