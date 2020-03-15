<%--
	■ SYSTEM				: 
	■ SOURCE FILE NAME		: userInsertPrc.jsp
	■ DESCRIPTION			: 사용자 추가 Prc
	■ COMPANY				: 목포대학교 융합소프트웨어공학과 
	■ PROGRAMMER			: 김성현 
	■ DESIGNER				: 
	■ PROGRAM DATE			: 2019.08.19
	■ EDIT HISTORY			: 
	■ EDIT CONTENT			: 
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="com.usertable.*"%>
<%@ include file="../include/include/session.inc"%>
<%
	request.setCharacterEncoding("UTF-8");

	// loginPrc에서 값 보냄
	// 이름
	String Session_Name = (String)session.getAttribute("Name");
	
	// 객체화
	usertableDTO bean = new usertableDTO();
	
	bean.setUserId(request.getParameter("userID"));	// 사용자 ID
	bean.setUserPw(request.getParameter("userPW"));	// 사용자 pw
	bean.setUserName(request.getParameter("userName"));	// 사용자 이름
	bean.setUserTel(request.getParameter("usertel"));	// 사용자 번호
	bean.setUserAuth(request.getParameter("userAuth"));	// 사용자 권한
	bean.setFarmId(request.getParameter("FarmID"));	// 양식장 이름
	bean.setRegId(Session_Name);							// 등록자 이름
	
	String msg = "가입이 완료되었습니다.";
	
	usertableDAO doa = new usertableDAO();
	doa.userInsert(bean);
	
	response.sendRedirect("./userManagement.jsp");
%>

<script language="javascript">
	alert("<%=msg%>");
</script>
