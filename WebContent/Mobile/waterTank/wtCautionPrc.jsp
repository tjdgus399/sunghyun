<!-- 
   /*==============================================================================
    ■ SYSTEM            : 
    ■ SOURCE FILE NAME  : wtCautionPrc.jsp
    ■ DESCRIPTION       : 조치내용 입력 PRC
    ■ COMPANY           : 목포대학교 융합소프트웨어공학과
    ■ PROGRAMMER        : 박진후
    ■ DESIGNER          : 
    ■ PROGRAM DATE      : 2019.08.19
    ■ EDIT HISTORY      : 
    ■ EDIT CONTENT      : 
   ==============================================================================*/ 
-->

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!-- beans를 사용하기 위한 import -->
<%@page import="com.repair.*"%>
<%@ include file="../include/SessionState.inc" %>

<%
   // 한글패치
   request.setCharacterEncoding("UTF-8");

   //앞에서 확인 버튼을 누를때 기록코드, 조치내용을 받아온다
   String recSeq = request.getParameter("recSeq");
   String repairContents = request.getParameter("repairContents");
   //받아오는 부분 끝
   
   String msg = null;
   
   //조치내용의 값을 확인하는 부분
   if(repairContents != null && repairContents != "")
   {
      //입력 된거 확인시키는 메세지
      msg = "조치내용이 입력되었습니다.";
      
      //repair패키지의 기능을 이용하기 위해 생성자 생성 후
      repairDAO dao =  new repairDAO();
      
      //조치부분을 입력하는 메소드를 호출하여 매개변수를 입력
      dao.repairInsert(Session_ID, repairContents, recSeq);
   }
   else
   {
      //입력 되지 않으면 표시되는 메세지
      msg = "조치내용을 입력해주세요.";
   }

%>

<script>
   /* 경고창 출력 및 이동 */
   alert("<%=msg%>");
   close();
</script>