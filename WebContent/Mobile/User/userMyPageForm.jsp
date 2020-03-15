<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.usertable.*" %>
<%@ page import="com.farm.*" %>
<%@ page import="java.util.stream.Stream"%>
<%@ include file="../include/SessionState.inc"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>스마트 양식장</title>

<%
	usertableDAO dao = new usertableDAO();
	usertableDTO dto = dao.getuser(Session_ID);

	String tel = dto.getUserTel();      // 전화번호
	String FarmID = dto.getFarmId();   // 양식장 id
   
%>

<!--  Jquery Mobile CSS Include  -->
<link rel="stylesheet" href="../common/style.css" />
<link rel="stylesheet" href="../common/jquery/jquery.mobile-1.0.1.css" />

<!-- JavaScript ASYNC INCLUDE -->
<script src="../common/async/Monitoring.js"></script>

<!--  Jquery Mobile JS Include  -->
<script src="../common/jquery/demos/jquery.js"></script>
<script src="../common/jquery/jquery.mobile-1.0.1.js"></script>


<script type="text/javascript" src="../common/main.js"></script>

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
		
		<form name="userUpdateForm">
		<h2 align="center">내 정보 수정</h2>
		<br>
		<table text-align="center">
			<tr>
				<td><input type="button" value="수정" onclick="checkValueUpdate()"/></td>
				<% if(!Session_Auth.equals("사용자")){ %>
				<td><input type="button" value="취소" onclick="location.href='userInfo.jsp'" /></td>
				<% } %>
			</tr>
		</table>
			<div align="center">양식에 맞게 입력해 주세요</div>
			
			<table>
				<tr>
					<th width="20%">ID</th>
					<td>
					<input type="text" name="id" style="float:left; width:70%;" readonly value="<%=Session_ID%>" />
					</td>
				</tr>
				<tr>
					<th>비밀번호</th>
					<td><input type="password" name="userPW" maxlength="20" style="float:left; width:70%;"/></td>
				</tr>
				<tr>
					<th>비밀번호확인</th>
					<td><input type="password" name="userPWChk" maxlength="20" style="float:left; width:70%;"/></td>
				</tr>
				<tr>
					<th>이름</th>
					<td><input type="text" name="name" style="float:left; width:70%;" value="<%=Session_Name%>" maxlength="20" /></td>
				</tr>
				<tr>
					<th>연락처</th>
					<td><input type="text" name="usertel" maxlength="13" value="<%= tel %>"
					 style="float:left; width:70%;" onkeypress="OnlyNumber()" /></td>
				</tr>
				<tr>
					<th>직책</th>
					<td>
					<%= Session_Auth %>
					</td>
				</tr>
			</table>
		</form>
	</section>
	
	<footer data-role="footer" data-position="fixed">
		<%@ include file="../include/footer.inc"%>
	</footer>
	

</body>

</html>