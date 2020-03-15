<%--
	■ SYSTEM				: 
	■ SOURCE FILE NAME		: userUpdatePrc.jsp
	■ DESCRIPTION			: 양식장 추가  Form
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
<%@ include file="../include/SessionState.inc" %>
<%
	request.setCharacterEncoding("UTF-8");
	
	String id = (String)session.getAttribute("ID");
	//String id = request.getParameter("userid");
	//객체화
	usertableDTO bean = new usertableDTO();
	
	bean.setUserPw(request.getParameter("userPW"));
	bean.setUserName(request.getParameter("name"));
	bean.setUserTel(request.getParameter("usertel"));
	bean.setUserAuth(Session_Auth);
	bean.setUserId(request.getParameter("id"));
	
	usertableDAO um = new usertableDAO();
	um.updateMember(bean);
	
	String msg = "수정이 완료되었습니다."; //입력 된거 확인시키려고
	
	response.sendRedirect("./userInfo.jsp");
%>

<script language="javascript">
	alert("<%=msg%>");
</script>