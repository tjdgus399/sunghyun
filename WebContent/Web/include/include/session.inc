<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%

	String ID = (String)session.getAttribute("ID");
	String Name = (String)session.getAttribute("Name");
	String Auth = (String)session.getAttribute("Auth");
	
	if(ID == null)	
	{		%>
		<script>
			alert("로그인해주실 바랍니다..");
			location.href="../index.jsp";
		</script>
		<%
	}
%>