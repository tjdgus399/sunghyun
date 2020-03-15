<%
   /*==============================================================================
    ■ SYSTEM            : 
    ■ SOURCE FILE NAME      : farmUpdatePrc.jsp
    ■ DESCRIPTION         : 양식장 정보 수정 Prc
    ■ COMPANY            : 목포대학교 융합소프트웨어공학과
    ■ PROGRAMMER         : 박진후
    ■ DESIGNER            : 
    ■ PROGRAM DATE         : 2019.08.26
    ■ EDIT HISTORY         : 
    ■ EDIT CONTENT         : 
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

   //앞에서 수정을 확인하면 값들을 받아온다
   int FarmID = Integer.parseInt(request.getParameter("FarmID"));      //양식장 번호 (고정)
   String farmName = request.getParameter("farmName");               //바뀐 양식장 이름
   String Address = request.getParameter("Address");               //바뀐 양식장 주소
   int tankCnt = Integer.parseInt(request.getParameter("tankCnt"));   //바뀐 수조 개수
   /* String username = request.getParameter("username");            //바뀐 관리자 이름 */
   String id = ID;                                    //수정자 아이디
   String userid = request.getParameter("userid");                  //현재 관리자 아이디
   String search = request.getParameter("search");                  //바뀐 관리자 아이디
   
   System.out.println("search: "+search);

   //Prc에서 넘어갈 화면
   String route = "farmListForm.jsp";
   
   //입력 된거 확인시키는 메세지
   String msg = "양식장이 수정되었습니다.";
   
   //farm패키지의 기능을 이용하기 위해 생성자 생성
   farmDAO dao = new farmDAO();
   
   //양식장을 수정하는 메소드를 호출하여 값을 입력
   dao.farmUpdate(id, FarmID, farmName, Address, tankCnt, search, userid);

%>
<script>
   //경고창 출력 및 이동
   alert("<%=msg%>");
   location.href="<%=route%>";
</script>