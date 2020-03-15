<%--
	 ■ SYSTEM				: 
	 ■ SOURCE FILE NAME		: userIDCheck.jsp
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
<%@ page import="com.usertable.usertableDAO"%>
<html>
<head>
<title>스마트 모니터링 시스템</title>

<%
   // 한글 패치
   request.setCharacterEncoding("EUC-KR");

   // ID값 가져오기
   String userID = request.getParameter("userID");
   usertableDAO mgr = new usertableDAO();
%>

<link rel="stylesheet" href="../common/style.css">
<script type="text/javascript" src="../common/main.js"></script>
</head>
<body>

   <form name="IDCheck" method="post" action="userIDCheck.jsp">
      <br>
      <br>ID 검색<br> 
      <input type="text" name="userID" /> 
      <input type="button" value="중복확인" onclick="popupIdCheck()"/>
   </form>
   
   <%
      // 중복이 아닐 시
      if (mgr.userIDCheck(userID)) {
   %>
      입력하신 <font color="red"><%=userID%></font>은(는) 사용이 가능합니다.<br> 
      사용가능한 ID입니다.<br> 
      다른 ID를 사용하려면 ID를 검색하세요<br>
      <br> 
      <input type="button" value="등록" onclick="setId('<%=userID%>')" /> 
      <input type="button" value="취소" onclick="selfClose()" />
   
   <%
      } else { // 중복일시
   %>

      입력하신 <font color="red"><%=userID%></font>은(는) 사용이 불가능합니다.
      <br> 새로운 아이디를 검색하세요.<br>
      <br> <input type="button" value="취소" onclick="selfClose()" />

   <%
      }
   %>
</body>

</html>