<%
   /*==============================================================================
	 ■ SYSTEM				: SAF(Smart Aqua Farm) - 스마트 모니터링 시스템
	 ■ SOURCE FILE NAME		: logIn.jsp
	 ■ DESCRIPTION			: 회원 로그인 처리
	 ■ COMPANY				:  
	 ■ PROGRAMMER			: 윤건주
	 ■ DESIGNER				: -
	 ■ PROGRAM DATE			: 2019.08.19
	 ■ EDIT HISTORY			: 
	 ■ EDIT CONTENT			: 
	==============================================================================*/
%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@page import="com.usertable.usertableDTO"%>
<jsp:useBean id="dao" class="com.usertable.usertableDAO"/>
<%
	// 한글패치
	request.setCharacterEncoding("EUC-KR");

	// 변수 선언
	// ID/비밀번호/이름/권한
	String ID = request.getParameter("ID");
	String PW = request.getParameter("PW");
	String Name = null;
	String Auth = null;
	
	// bool저장 변수 / 경로 및 문구
	String msg = "로그인이 불가합니다. ID와 비밀번호를 확인하세요.";
	String route = "../index.jsp";
	
	// login함수 사용
	usertableDTO dto = dao.login(ID, PW);
	
	// 이름/권한 불러오기
	Name = dto.getUserName();
	Auth = dto.getUserAuth();
	
	// 리스트가 비어있지 않으면
	if(Name != null)
	{
		// 한글로 전환
		if(Auth.equals("user"))
		{
			Auth = "사용자";
		}
		else if(Auth.equals("admin"))
		{
			Auth = "일반관리자";
		}
		else if(Auth.equals("sysadmin"))
		{
			Auth = "전체관리자";
		}
		
		// 경로/문구변경
		route = "main.jsp";
		msg = "어서오세요. " + Name + "(" + ID +" / "+ Auth +") 반갑습니다.";
		
		//세션저장
		session.setAttribute("ID", ID);
		session.setAttribute("Name", Name);
		session.setAttribute("Auth", Auth);
	}
%>
<script>
	//경고창 출력 및 이동
	alert("<%=msg%>");
	location.href="<%=route%>";
</script>