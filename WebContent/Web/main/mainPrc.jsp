<%-- 
	■ SYSTEM                : SAF
    ■ SOURCE FILE NAME      : mainPrc.jsp
    ■ DESCRIPTION           : main.jsp에 로그인 한 유저의 정보로 양식장 정보를 가져올 수 있음
    ■ COMPANY               : 목포대학교 융합소프트웨어학과 
    ■ PROGRAMMER            : 고지안
    ■ DESIGNER              : 
    ■ PROGRAM DATE          : 2019.08.07
    ■ EDIT HISTORY          : 2019.08.18
    ■ EDIT CONTENT          : 2019.08.20

--%>

<%@ page import="java.util.*"%>
<%@ page import="com.farm.*"%>
<!-- beans를 사용하기 위한 import -->
<%@ page import="com.usertable.usertableDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!-- mainMgr의 클래스 사용을 위함 useBean -->
<!-- mainMgr.java 파일 안에 login() 메서드 -->
<jsp:useBean id="Mgr" class="com.farm.farmDAO" />
<jsp:useBean id="wtrec" class="com.usertable.usertableDAO" />
<%
	// Session_ID 는 main.jsp에서 include 한 SessionStatus 값을 물려받음
	// Session_ID 에 빨간줄이여도 신경 쓰지 말것	
	usertableDTO bean = new usertableDTO();

	System.out.println("================");
	System.out.println(ID + " " + Auth);
	System.out.println("================");
	// 양식장 매칭
	ArrayList<farmDTO> farm_list = Mgr.getFarmAdminInfo(ID, Auth);

	for (int i=0; i<farm_list.size(); i++){
		//System.out.println(farm_list.get(i).getFarmId());
		System.out.println(farm_list.get(i).getRemark());
		System.out.println(farm_list.get(i).getRemarkFarmid());
	}

%>
