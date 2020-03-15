<%--
	■ SYSTEM				: 
	■ SOURCE FILE NAME		: userManagement.jsp
	■ DESCRIPTION			: 사용자 목록 리스트  Form
	■ COMPANY				: 목포대학교 융합소프트웨어공학과 
	■ PROGRAMMER			: 김수아
	■ DESIGNER				: 
	■ PROGRAM DATE			: 2019.08.19
	■ EDIT HISTORY			: 
	■ EDIT CONTENT			: 
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.farm.*"%>
<%@ page import="com.growInfo.*"%>
<%@ page import="com.waterTank.*"%>
<%@ page import="com.usertable.*"%>
<%@ page import="com.main.*"%>
<%@ include file="../include/include/session.inc"%>
<!DOCTYPE html>
<html>
<head>
<title>스마트 모니터링 시스템</title>
<!--  CSS File Include -->

<link rel="stylesheet" href="../common/jqm-button/icon.css" />
<link rel="stylesheet" href="../common/style.css">
<script src="../common/main.js"></script>

<script type="text/javascript">
function goTouserInsertForm(){
	location.href = "../User/userInsertForm.jsp";
}
</script>


<%

	//한글 패치
	request.setCharacterEncoding("EUC-KR");

	usertableDAO cdd = new usertableDAO();

	String FarmID = request.getParameter("FarmID");
	String userauth = request.getParameter("userauth");

	//리스트 목록 가져오기
	ArrayList userlist = cdd.sysuserselect(userauth);
	ArrayList userlist2 = cdd.adminuserselect(userauth);
%>


</head>
<body>

	<header>
		<%@ include file="../include/header.inc"%>
	</header>
	<section align="center">
		<form name="userManagement">
		<h2>사용자 정보 리스트</h2>
		<br>
	<%

	if(FarmID!=null){
		FarmID="";
		}
	%>		
			<table class="userlistbutton">
			<tr>
				<th></th>
				<th></th>
				<th></th>
				<th></th>
				<th></th>
				<th></th>
				<th><input style="width:60px; height:30px" type="image" src="../common/images/btn_a_add.gif"
			onclick="goTouserInsertForm(); return false;"/></th>
			</tr>
			</table>
			
			<table class="userlist">
				<tr>
					<th>ID</th>
					<th>PW</th>
					<th>이름</th>
					<th>연락처</th>
					<th>직책</th>
					<th>소속양식장</th>
					<th>가입일</th>
				</tr>

				<%
					//userDAO에서 받아온 userlist 출력
					for (int i = 0; i < userlist.size(); i++) {
						usertableDTO vo = (usertableDTO) userlist.get(i);
						vo = (usertableDTO) userlist.get(i);
						String userid = vo.getUserId();

						// wtlist,farmnamelist는 권한에 따라서 분류되서 동일한 이름의 리스트를 사용함
						if (Auth.equals("전체관리자")) { // 권한 : 전체관리자일 경우
							userlist = cdd.sysuserselect(userauth);
				%>

				<tr class="listMouseEvent-pointer" onclick="goReadUser('<%=userid%>')">
					<!-- userid를 누르면 userUpdate.jsp로 넘어간다. -->
					<td><%=vo.getUserId()%></td>
					<td><%=vo.getUserPw()%></td>
					<td><%=vo.getUserName()%></td>
					<td><%=vo.getUserTel()%></td>
					<td><%=vo.getUserAuth()%></td>
					<td><%=vo.getFarmId()%></td>
					<td><%=vo.getRegDate()%></td>
				</tr>

				<%
						} 
					}
				%>
				
				<%
				for (int i = 0; i < userlist2.size(); i++) {
					usertableDTO vo = (usertableDTO) userlist2.get(i);
					vo = (usertableDTO) userlist2.get(i);
					String userid = vo.getUserId();
					
					if (Auth.equals("일반관리자")) { // 권한 : 일반관리자일 경우
					userlist2 = cdd.adminuserselect(userauth);
				%>
				<tr class="listMouseEvent-pointer" onclick="goReadUser('<%=userid%>')">
					<td><%=vo.getUserId()%></td>
					<td><%=vo.getUserPw()%></td>
					<td><%=vo.getUserName()%></td>
					<td><%=vo.getUserTel()%></td>
					<td><%=vo.getUserAuth()%></td>
					<td><%=vo.getFarmId()%></td>
					<td><%=vo.getRegDate()%></td>
				</tr>
				<%
						} // 권한: 사용자일 경우

					}
				%>

			</table>
			<%
				if (Auth.equals("사용자")) {
			%>
			<br> 사용하실 수 없습니다. <br> <br>
			<%
				}
			%>
			<input type="hidden" name="userid" value="userid" /> <input
				type="hidden" name="username" value="username" /> <input
				type="hidden" name="userauth" value="userauth" />
		</form>
	</section>

	<!-- 푸터 -->
	<footer> </footer>

</body>
</html>