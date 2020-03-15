<%--
	■ SYSTEM				: 
	■ SOURCE FILE NAME		: userMyPageForm.jsp
	■ DESCRIPTION			: 내 정보 수정  Form
	■ COMPANY				: 목포대학교 융합소프트웨어공학과 
	■ PROGRAMMER			: 김성현 
	■ DESIGNER				: 
	■ PROGRAM DATE			: 2019.08.19
	■ EDIT HISTORY			: 
	■ EDIT CONTENT			: 
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.usertable.*"%>
<%@ include file="../include/include/session.inc"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>스마트 모니터링 시스템</title>

<link rel="stylesheet" href="../common/jqm-button/icon.css" />
<link rel="stylesheet" href="../common/style.css">
<%
	//한글패치
	request.setCharacterEncoding("EUC-KR");
	
	usertableDAO dao = new usertableDAO();
	
	// 전화번호, 양식장 id 가져오기
	usertableDTO dto = dao.getuser(ID);

	String tel = dto.getUserTel();		// 전화번호
	String FarmID = dto.getFarmId();	// 양식장 id
%>

<script src="../common/main.js"></script>

</head>

<body onload="goInit();">

	<header>
		<%@ include file="../include/header.inc" %>
	</header>
	<section>
	
		<form name="userUpdateForm">
		<h2>내 정보 수정</h2>
		<br>
		
			<input type="button" class="del" onclick="goDelete();">
			<input type="button" class="cor" onclick="checkValueUpdate()"/>
			<% if(!Auth.equals("사용자")){ %>
			<input type="button" class="cancel" onclick="location.href='userInfo.jsp'" />
			<% } %>
			<div class="info">양식에 맞게 입력해 주세요</div>
			
			<table class="userInfo">
				<tr>
					<th width="20%">ID</th>
					<td>
					<input type="text" name="id" style="float:left; width:99%;" readonly value="<%= ID %>" />
					</td>
				</tr>
				<tr>
					<th>비밀번호</th>
					<td><input type="password" name="userPW" maxlength="20" style="float:left; width:99%;"/></td>
				</tr>
				<tr>
					<th>비밀번호확인</th>
					<td><input type="password" name="userPWChk" maxlength="20" style="float:left; width:99%;"/></td>
				</tr>
				<tr>
					<th>이름</th>
					<td><input type="text" name="name" style="float:left; width:99%;" value="<%=Name%>" maxlength="20" /></td>
				</tr>
				<tr>
					<th>연락처</th>
					<td><input type="text" name="usertel" maxlength="13" value="<%= tel %>"
					 style="float:left; width:99%;" onkeypress="OnlyNumber()" /></td>
				</tr>
				<tr>
					<th>직책</th>
					<td>
					<%= Auth %>
					</td>
				</tr>
			</table>
		</form>
	</section>

</body>
</html>