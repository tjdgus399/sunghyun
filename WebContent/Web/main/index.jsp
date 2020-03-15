<%-- 
	■ SYSTEM                : SAF
    ■ SOURCE FILE NAME      : index.jsp
    ■ DESCRIPTION           : 로그인 화면
    ■ COMPANY               : 목포대학교 융합소프트웨어학과 
    ■ PROGRAMMER            : 윤건주
    ■ DESIGNER              : 
    ■ PROGRAM DATE          : 2019.08.07
    ■ EDIT HISTORY          : 2019.08.18
    ■ EDIT CONTENT          : 2019.08.20
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>

<head>
<meta charset="EUC-KR">
<title>스마트 모니터링 시스템</title>
<link rel="stylesheet" href="../common/style.css">
<style type="text/css">
	 body {
	 	height : 100px;
	 }
</style>
<script>
	//로그인 기능 함수 구현
	function login() {
		//폼 객체 찾기
		var frm = document.loginForm;
		frm.method = "post";
		frm.target = "_self";
		frm.action = "loginPrc.jsp";
		frm.submit();
	}
</script>


</head>
<body>
	<!-- 헤더 -->
	<header>
		<h2 id="h2Header">
			<br> 모니터링시스템을 사용하기<br>위해 로그인이 필요합니다.
		</h2>
	</header>

	<!-- 본문 -->
	<section id="index_Section">

		<div id="index_Section_Area">
			<form name="loginForm" method="post" action="loginPrc.jsp">
				<h1>
					ID/PW 분실, 회원가입<br>관리자 문의
				</h1>
				<br> <br>
				<!-- ID입력란 -->
				아이디 &nbsp;&nbsp;&nbsp;: <input type="text" name="ID" required="required" style="text-align-last: left;" /><br> <br>
				<!-- PW입력란 -->
				비밀번호 : <input type="password" name="PW" required="required" style="text-align-last: left;" /><br> <br>
				<!-- 로그인 버튼 -->
				<input type="button" onclick="login()" value="로그인" />
			</form>
		</div>


		<div id="loader"></div>


	</section>

	<!-- 푸터 -->
	<footer id="indexFooter">
		<%@include file="../include/footer.inc"%>
	</footer>
</body>
</html>