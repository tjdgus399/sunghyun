<%-- 
	■ SYSTEM                : SAF
    ■ SOURCE FILE NAME      : logout.jsp
    ■ DESCRIPTION           : 로그아웃
    ■ COMPANY               : 목포대학교 융합소프트웨어학과 
    ■ PROGRAMMER            : 고지안
    ■ DESIGNER              : 
    ■ PROGRAM DATE          : 2019.08.07
    ■ EDIT HISTORY          : 2019.08.18
    ■ EDIT CONTENT          : 2019.08.20
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!doctype html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title></title>
<script>
	function Logout() {
	alert("로그아웃 되었습니다.");
	location.href = "../main/index.jsp";
	}
</script>
</head>
<body onload="Logout()">
	<%
		session.invalidate();
	%>
</body>
</html>