<!-- 
   /*==============================================================================
    ■ SYSTEM            : 
    ■ SOURCE FILE NAME  : index.jsp
    ■ DESCRIPTION       : 로그인 폼
    ■ COMPANY           : 목포대학교 융합소프트웨어공학과
    ■ PROGRAMMER        : 고지안
    ■ DESIGNER          : 
    ■ PROGRAM DATE      : 2019.08.19
    ■ EDIT HISTORY      : 
    ■ EDIT CONTENT      : 
   ==============================================================================*/
 -->
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8" />

<meta name="viewport" content="width=device-width, initial-scale=1">
<title>로그인</title>
<!--  Jquery Mobile CSS Include  -->
<link rel="stylesheet" href="../common/style.css" />
<link rel="stylesheet" href="../common/jquery/jquery.mobile-1.0.1.css" />

<!--  Jquery Mobile JS Include  -->
<script src="../common/jquery/demos/jquery.js"></script>
<script src="../common/jquery/jquery.mobile-1.0.1.js"></script>

<!-- "아이디"와 "비밀번호" 이상 유무 체크 -->
<script type="text/javascript">
	function LoginCheck() {
		var obj = document.LoginInfo;
		var IdValue = obj[0].value;
		var PwValue = obj[1].value;

		var check = /[ㄱ-ㅎ|ㅏ-ㅣ|가-힣]/;

		if (check.test(IdValue)) {
			alert("아이디는 한글을 쓸 수 없습니다");
			return;
		}

		if ((IdValue == "") || (PwValue.length == "")) {
			alert("아이디와 비밀번호를 입력해주세요")
			return;

		} else if ((IdValue.length > 12) || (PwValue.length > 12)) {
			alert("아이디와 비밀번호를 확인해주세요");
			return;

		} else {
			obj.method = "post";
			obj.target = "_self";
			obj.action = "LoginPrc.jsp";
			obj.submit();
		}
	}
</script>
</head>


<body>
	<header class="LoginHeader" data-role="header" data-position="fixed">
		스마트양식장<br>모니터링 시스템
	</header>

	<section data-role="content">
		<br>
		<p class="loginText">
			모니터링 시스템을 사용하기<br> 위해 로그인이 필요합니다
		</p>
		<br>

		<form name="LoginInfo">
			<br> <br> 
		 	 아이디    <input type="text" id="ID" name="ID" maxlength=12 />
			 비밀번호 <input type="password" id="Passwd" name="PW" maxlength=12/>

			<div class="LoginSubmit">
				<input style="font-size: 12px;" type="button" data-theme="a" value="로그인" onclick="LoginCheck()" />
			</div>
		</form>
		
	</section>

	<footer data-role="footer" data-position="fixed">
		<%@ include file="../include/footer.inc"%>
	</footer>

</body>
</html>