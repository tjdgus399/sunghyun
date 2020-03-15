<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
	String Session_ID = (String)session.getAttribute("ID");
	String Session_Name = (String)session.getAttribute("Name");
	String Session_Auth = (String)session.getAttribute("Auth");


	if (Session_Auth == null)
	{
%>

<script>
	alert("다시 로그인해주세요");
	location.href = "../main/index.jsp";
</script>

<%
	}
%>