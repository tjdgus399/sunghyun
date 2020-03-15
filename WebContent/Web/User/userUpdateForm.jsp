<%--
	■ SYSTEM				: 
	■ SOURCE FILE NAME		: userUpdateForm.jsp
	■ DESCRIPTION			: 사용자 정보 수정  Form
	■ COMPANY				: 목포대학교 융합소프트웨어공학과 
	■ PROGRAMMER			: 김성현 
	■ DESIGNER				: 
	■ PROGRAM DATE			: 2019.08.30
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
	
	String id = request.getParameter("userid");
	
	//userDAO 값가져오기
	usertableDTO bean = dao.getMb(id);
	String pw = bean.getUserPw();
	String username = bean.getUserName();
	String tel = bean.getUserTel();
	String userauth = bean.getUserAuth();
	String FarmID = bean.getFarmId();
	String regdate = bean.getRegDate();
	String regid = bean.getRegId();
	
	

	System.out.println(id);
	System.out.println(userauth);
	
	if(userauth.equals("sysamdin")){
		userauth = "전체관리자";
	}else if(userauth.equals("admin")){
		userauth = "일반관리자";
	}else if(userauth.equals("user")){
		userauth = "사용자";
	}
	
	//null이면 공백으로 출력
	if (username == null) {
		username = "이름없음";
	}
	if (tel == null) {
		tel = "번호 없음";
	}
%>

<script src="../common/main.js"></script>

</head>

<body onload="goInit();">

	<header>
		<%@ include file="../include/header.inc" %>
	</header>
	<br>
	<section>
	
		<form name="userUpdateForm">
		
		<h2>사용자 정보 수정</h2>
		<br>
		
		 <input type="button" class="del" onclick="goDelete('<%= userauth %>','<%= username %>','<%= FarmID %>'); return false;"/>
         <input type="button" class="cor" onclick="checkValueUpdate(); return false;"/>
         <input type="button" class="list" onclick="usercancel(); return false;"/>
         
			<div>양식에 맞게 입력해 주세요</div>
			
			
			<table class="userInfo">
				<tr>
					<th width="20%">ID</th>
					<td>
					<input type="hidden" name="id" value ="<%= id %>" />
					<input type="text" style="float:left; width:99%;" name="id" readonly value="<%= id %>" />
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
					<td><input type="text" name="name" style="float:left; width:99%;" value="<%=username%>" maxlength="20" /></td>
				</tr>
				<tr>
					<th>연락처</th>
					<td><input type="text" name="usertel" maxlength="13" value="<%= tel %>"
					 style="float:left; width:99%;" onkeypress="OnlyNumber()" /></td>
				</tr>
				<tr>
					<th>직책</th>
					<td>
					<%= userauth %>
					</td>
				</tr>
			</table>
         
         </form>
		
	</section>

</body>
</html>