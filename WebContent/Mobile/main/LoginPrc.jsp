<%-- 
	■ SYSTEM                : SAF
    ■ SOURCE FILE NAME      : loginPrc.jsp
    ■ DESCRIPTION           : 로그인 PRC
    ■ COMPANY               : 목포대학교 융합소프트웨어학과 
    ■ PROGRAMMER            : 윤건주
    ■ DESIGNER              : 
    ■ PROGRAM DATE          : 2019.08.07
    ■ EDIT HISTORY          : 2019.08.18
    ■ EDIT CONTENT          : 2019.08.20
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- beans를 사용하기 위한 import -->
<%@ page import="com.usertable.*"%>

<jsp:useBean id="Mgr" class="com.usertable.usertableDAO" />

<!-- 로그인 기능을 사용하기 위한 useBean -->
<!-- mainMgr.java 파일 안에 login() 메서드 -->

<%
	// 한글패치
	request.setCharacterEncoding("UTF-8");

	// 변수
	// ID/비밀번호/이름/권한
	String ID = request.getParameter("ID");
	String PW = request.getParameter("PW");
	String Name = null;
	String Auth = null;
	
	// bool저장 변수 / 경로 및 문구 / 리스트관련 변수
	String msg = "ID와 비밀번호를 확인하세요.";
	String route = "index.jsp";

	// login함수 사용
	usertableDTO bean = Mgr.login(ID, PW);

	// 이름/권한 불러오기
	Name = bean.getUserName();
	Auth = bean.getUserAuth();
	
	// 리스트가 비어있지 않으면
	if (Name != null) {
		// 한글로 전환
		if (Auth.equals("user")) {
			Auth = "사용자";
		} else if (Auth.equals("admin")) {
			Auth = "일반관리자";
		} else if (Auth.equals("sysadmin")) {
			Auth = "전체관리자";
		}

		//문구변경
		route = "main.jsp";
		msg = "어서오세요. " + Name + "(" + ID + " / " + Auth + ") 반갑습니다.";

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