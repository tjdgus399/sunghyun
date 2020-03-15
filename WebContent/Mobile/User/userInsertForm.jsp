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
		
			
	<h2 align="center">사용자 추가</h2>
	<br>
		<form name="userInsertForm">
		
		<table style="text-align:center";>
			<tr>
				<td>
					<div style="float:left"><input type="button" name="add" value="가입" onclick="checkValue()"/></div>
					<div style="float:left"><input type="button" name="cancel" value="취소" onclick="location.href='./userInfo.jsp'" /></div>
				</td>
			</tr>
		</table>
		
			<div align="center";>양식에 맞게 입력해 주세요</div>

			<table>
				<tr>
					<th width="20%">ID</th>
					<td>
					<div><input type="text" name="userID" maxlength="15" onkeydown="inputIdChk()" style="float:left; width:55%;"/></div>
					<div style="float:right;"><input type="button" value="중복확인" onclick="idCheck()" style="width:55%; float:right;" /></div>
					<input type="hidden" name="idDuplication" value="idUncheck" />
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
					<td><input type="text" name="userName" maxlength="20" style="float:left; width:70%;"/></td>
				</tr>
				<tr>
					<th>연락처</th>
					<!-- String으로 쓴 이유 : sqldeveloper에 저장될때 앞에 0이 사라져서 -->
					<td><input type="text" name="usertel" maxlength="13" style="float:left; width:70%;" onkeypress="OnlyNumber()" /></td>
				</tr>
				<tr>
					<th>직책</th>
					<td>
					<% System.out.println(Session_Auth); %>
					<% if(Session_Auth == "일반관리자"){ %>
					<select name="userAuth1">
						<option value="user">회원</option>
					</select>
					<% }else { %>
					<select name="userAuth">
						<option value="sysadmin">전체 관리자</option>
						<option value="admin">일반 관리자</option>
						<option value="user">회원</option>
					</select>
					<% } %>
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