<%
   /*==============================================================================
    ■ SYSTEM            : 
    ■ SOURCE FILE NAME  : farmAddPrc.jsp
    ■ DESCRIPTION       : 양식장 추가 Prc
    ■ COMPANY           : 목포대학교 융합소프트웨어공학과
    ■ PROGRAMMER        : 박진후
    ■ DESIGNER          : 
    ■ PROGRAM DATE      : 2019.08.19
    ■ EDIT HISTORY      : 
    ■ EDIT CONTENT      : 
   ==============================================================================*/ 
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<!-- beans를 사용하기 위한 import -->
<%@ page import="com.farm.*"%>
<%@ include file="../include/include/session.inc"%>

<%
   // 한글패치
   request.setCharacterEncoding("UTF-8");

   //앞에서 확인 버튼을 누를때의 양식장 이름과 주소, 수조개수를 받아온다
   String farmname = request.getParameter("farmName");
   String address = request.getParameter("Address");
   String tankcnt = request.getParameter("tankCnt");
   //받아오는 부분 끝
   //Prc에서 넘어갈 화면
   String route = "farmListForm.jsp";
   
   //입력 된거 확인시키는 메세지
   String msg = "양식장이 추가되었습니다.";
   
   //farm패키지의 기능을 이용하기 위해 생성자 생성
   farmDAO dao = new farmDAO();
   
   if(farmname != null && address != null && tankcnt != null && farmname != "" && address != "" && tankcnt != "")
   {
      //양식장 정보를 입력하는 메소드를 호출하여 값을 입력
      dao.farmInsert(ID, farmname, address, tankcnt);
   }
   else
   {
      route = "farmAddForm.jsp";
      msg = "정보를 제대로 입력해주세요.";
   }
%>
<script>
   //경고창 출력 및 이동
   alert("<%=msg%>");
   location.href="<%=route%>";
</script>