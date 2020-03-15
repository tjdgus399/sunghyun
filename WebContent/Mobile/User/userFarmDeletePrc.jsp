<%--
	 ■ SYSTEM				: 
	 ■ SOURCE FILE NAME		: userFarmDeletePrc.jsp
	 ■ DESCRIPTION			: 양식장 삭제  Form
	 ■ COMPANY				: 목포대학교 융합소프트웨어공학과 
	 ■ PROGRAMMER			: 김성현
	 ■ DESIGNER				: 
	 ■ PROGRAM DATE			: 2019.08.19
	 ■ EDIT HISTORY			: 
	 ■ EDIT CONTENT			: 
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.usertable.*" %>
<%@ page import="com.farm.*" %>
<%@ include file="../include/SessionState.inc" %>
<jsp:useBean id="dao" class="com.usertable.usertableDAO" />

<%
	// 한글 패치
	request.setCharacterEncoding("EUC-KR");

	// 전화번호, 양식장 id 가져오기
	usertableDTO dto = dao.getuser(Session_ID);
	
	String FarmID = dto.getFarmId();	// 양식장 id
	
	String fid = request.getParameter("FarmID");
	
	if(Session_Auth.equals("전체관리자")){
		dao.sysdelFarm(fid);
	}else{
		dao.delFarm(fid, Session_ID);
	}
	
	response.sendRedirect("./userInfo.jsp");
%>
<script>
	location.href = "userInfo.jsp";
</script>