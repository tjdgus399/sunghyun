<!-- 
   /*==============================================================================
    ■ SYSTEM            : 
    ■ SOURCE FILE NAME  : userInfoPrc.jsp
    ■ DESCRIPTION       : 사용자 정보에 양식장 추가 Prc
    ■ COMPANY           : 목포대학교 융합소프트웨어공학과
    ■ PROGRAMMER        : 박진후
    ■ DESIGNER          : 
    ■ PROGRAM DATE      : 2019.08.26
    ■ EDIT HISTORY      : 
    ■ EDIT CONTENT      : 
   ==============================================================================*/ 
-->
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<!-- beans를 사용하기 위한 import -->
<%@ page import="com.usertable.*"%>
<%@ include file="../include/include/session.inc" %>

<%
   // 한글패치
   request.setCharacterEncoding("UTF-8");

   //앞에서 추가를 확인하면 farmID를 받아온다
   int FarmID = Integer.parseInt(request.getParameter("FarmID"));
   String userid = request.getParameter("userID");
   String regid = request.getParameter("regID");

   //Prc에서 넘어갈 화면
   String route = "userInfo.jsp";
   
   //입력 된거 확인시키는 메세지
   String msg = "양식장이 추가되었습니다.";
   
   //farm패키지의 기능을 이용하기 위해 생성자 생성
   usertableDAO dao = new usertableDAO();
   
   //양식장을 usertable에 추가하는 메소드를 호출하여 값을 입력
   dao.user_farmAdd(FarmID, userid, regid);

%>
<script>
   //경고창 출력 및 이동
   alert("<%=msg%>");
   location.href="<%=route%>";
</script>