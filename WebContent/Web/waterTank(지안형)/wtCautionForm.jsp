<%
   /*==============================================================================
	 ■ SYSTEM				: 
	 ■ SOURCE FILE NAME		: wtCautionForm.jsp
	 ■ DESCRIPTION			: 조치내용 입력 Form
	 ■ COMPANY				: 목포대학교 융합소프트웨어공학과
	 ■ PROGRAMMER			: 박진후
	 ■ DESIGNER				: 
	 ■ PROGRAM DATE			: 2019.08.19
	 ■ EDIT HISTORY			: 
	 ■ EDIT CONTENT			: 
	==============================================================================*/
%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.farm.*"%>
<%@ include file="../include/include/session.inc"%>

<%
	//앞에서 조치 버튼을 누를때의 양식장 아이디와 수조 번호, 기록코드를 받아온다
	int FarmID = Integer.parseInt(request.getParameter("FarmID"));
	String tankID = request.getParameter("tankid");
	String recSeq = request.getParameter("RecSeq");
	//여기까지 받는 부분

	//이 부분은 받아온 farmID에 따라 양식장 이름을 출력하는 부분이다 
	farmDAO dao = new farmDAO(); 	
	String farmName = dao.getFarmName(FarmID);	
%>
	
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>팝업창</title>
		<link rel="stylesheet" href="../common/style.css">
		<link rel="stylesheet" href="../common/jqm-button/icon.css">

		<script src="../common/main.js"></script>
		
		<script type="text/javascript">
		
			//취소할경우 메인으로 넘어가게 하는 함수
			function go_main() {
				alert("취소하였습니다.");
				close();
			}
			
			//확인할경우 Prc로 값을 전달해주는 함수
			function wtCautionPrc() {
				var form= document.Contents;
				form.method = "post";
				form.action = "wtCautionPrc.jsp";
				form.target = "_self";
				form.submit();
			}	
	
		</script>
	</head>
	
	<body>
		<!-- 본문 -->
		<section>

		<fieldset class="fieldset1">
			<h1 align="center">조치</h1>
		</fieldset>

		<form name="Contents">
		<br>
		
			<div>
			<!-- 취소를 누르면 값을 넘기지 않고 메인페이지로 넘어감 -->
			<input type="image" src="../common/images/btn_a_cancel.gif" onclick="go_main(); return false;" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<!-- 완료를 누르면 조치내용 값을 넘기면서 DB업데이트 Prc로 넘어감 -->
			<input type="image" src="../common/images/btn_a_regist.gif"  onclick="wtCautionPrc(); return false;" />
			</div> 
		<br>
			<hr>
			<h2><%=farmName%>- 수조<%=tankID%>번</h2>
			<hr>
		<br>
			<!-- 조치사항 입력란 -->			
			<h3>조치사항 입력</h3>

			<textarea name="repairContents" rows="13" cols="80%" maxlength="200"></textarea>
			<input type="hidden" name="recSeq" value="<%= recSeq %>"/>
			<!-- 조치사항 입력란 끝 -->
		</form>
		</section>
		<!-- 본문 끝 -->
	</body>
	
</html>