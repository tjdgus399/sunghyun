<%--
   ■ SYSTEM					: SAF 양식장
   ■ SOURCE FILE NAME   	: farmwtUpdatePrc.jsp
   ■ DESCRIPTION			: 양식장 정보 수정 기능
   ■ COMPANY				: 목포대학교 융합소프트웨어학과 
   ■ PROGRAMMER				: 장해리
   ■ DESIGNER				: 
   ■ PROGRAM DATE			: 2019.08.
   ■ EDIT HISTORY			: 2019.08.18
   ■ EDIT CONTENT			: 2019.08.22
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="com.farm.*"%>
<%@ page import="com.growInfo.*"%>
<%@ include file="../include/include/session.inc"%>
	<%
		//한글패치
			request.setCharacterEncoding("UTF-8");
			
			//앞에서 받아온 값들
			String tankID = request.getParameter("tankID2");
			int FarmID = Integer.parseInt(request.getParameter("FarmID"));
			String fishName = request.getParameter("selectFish");
			String userID = request.getParameter("userid");
			String DOSensor = request.getParameter("dosensor");
			String pHSensor = request.getParameter("phsensor");
			String psuSensor = request.getParameter("psusensor");
			String WTSensor = request.getParameter("wtsensor");
			String NH4Sensor = request.getParameter("nh4sensor");
			String NO2Sensor = request.getParameter("no2sensor");
			
			
			com.waterTank.waterTankDAO mgr = new com.waterTank.waterTankDAO();
			
			// Session_ID 에 빨간줄이여도 신경 쓰지 말것?
			//수조 정보 수정 메소드 사용
			mgr.waterTankUpdate(tankID, fishName, userID, DOSensor, pHSensor,
					psuSensor, WTSensor, NH4Sensor, NO2Sensor, ID, FarmID);
			
			//메소드 사용 후 farmwtSearch로 이동. farmid 설정해서 보냄
			response.sendRedirect("farmwtSearch.jsp?FarmID="+ FarmID );
	%>