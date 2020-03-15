<%--
	 ■ SYSTEM				: 
	 ■ SOURCE FILE NAME		: farmDeletePrc.jsp
	 ■ DESCRIPTION			: 양식장 추가  Form
	 ■ COMPANY				: 목포대학교 융합소프트웨어공학과 
	 ■ PROGRAMMER			: 장해리
	 ■ DESIGNER				: 
	 ■ PROGRAM DATE			: 2019.08.19
	 ■ EDIT HISTORY			: 
	 ■ EDIT CONTENT			: 
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="com.usertable.usertableDAO"%>

<%
	//한글 패치
	request.setCharacterEncoding("EUC-KR");

	// userID 받아오기
	String userID = request.getParameter("id");
	
	// userAuth 받아오기
	String userAuth = request.getParameter("userAuth");
	
	// farmID 받아오기
	String FarmID = request.getParameter("FarmID");

	usertableDAO cdd = new usertableDAO();
	String msg1 = "사용자가 삭제되었습니다.";
	String ccc = "userManagement.jsp";
	
	//삭제 메소드 사용	
	cdd.usertableDelete(userID, userAuth, FarmID);
%>


<script language="javascript">
      alert("<%=msg1%>");
      location.href = "<%=ccc%>	";
</script>