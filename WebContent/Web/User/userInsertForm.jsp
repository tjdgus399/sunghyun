<%--
	■ SYSTEM				: 
	■ SOURCE FILE NAME		: userInsertForm.jsp
	■ DESCRIPTION			: 사용자 추가  Form
	■ COMPANY				: 목포대학교 융합소프트웨어공학과 
	■ PROGRAMMER			: 김성현 
	■ DESIGNER				: 
	■ PROGRAM DATE			: 2019.08.19
	■ EDIT HISTORY			: 
	■ EDIT CONTENT			: 
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/include/session.inc"%>
<%@ page import="com.usertable.*" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>스마트 모니터링 시스템</title>

<link rel="stylesheet" href="../common/jqm-button/icon.css" />
<link rel="stylesheet" href="../common/style.css">
<script src="../common/main.js"></script>
</head>

<body>

	<header>
		<%@ include file="../include/header.inc" %>
	</header>
	<section>

	<h2>사용자 추가</h2>
	<br>
		<form name="userInsertForm">
			<input type="button" name="add" class="save"
			onclick="checkValue()"/>
			<input type="button" name="cancel" class="cancel"
			onclick="location.href='./userManagement.jsp'" />
			<div class="info">양식에 맞게 입력해 주세요</div>

			<table class="userInfo">
				<tr>
					<th width="20%">ID</th>
					<td>
					<input type="text" name="userID" maxlength="15" onkeydown="inputIdChk()" style="float:left; width:70%;"/>
					<input type="button" class="duplicate" onclick="idCheck()" style="float: right;" />
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
					<% System.out.println(Auth); %>
					<% if(Auth == "일반관리자"){ %>
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

</body>
</html>