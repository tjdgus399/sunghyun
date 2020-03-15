<%--
    ■ SYSTEM                : SAF 양식장
    ■ SOURCE FILE NAME      : farmwtDeletePrc.jsp
    ■ DESCRIPTION           : 양식장 정보 삭제 Prc
    ■ COMPANY               : 목포대학교 융합소프트웨어학과 
    ■ PROGRAMMER            : 황선주
    ■ DESIGNER              : 
    ■ PROGRAM DATE          : 2019.08.
    ■ EDIT HISTORY          : 2019.08.16
    ■ EDIT CONTENT          : 2019.08.16
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="com.waterTank.*"%>
<%@ include file="../include/include/session.inc"%>

<%
   request.setCharacterEncoding("UTF-8");               //한글 패치

   waterTankDAO cdd = new waterTankDAO();
   
   int FarmID = Integer.parseInt(request.getParameter("FarmID"));
   String tankID = request.getParameter("tankID2");      //farmwtUpdateForm에서 저장한 tankid값을 요청해서 받아옴 

   cdd.waterTankDelete(tankID, FarmID, ID);
   
   response.sendRedirect("farmwtSearch.jsp?FarmID="+ FarmID );
%>