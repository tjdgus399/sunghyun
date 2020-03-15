<%
   /*==============================================================================
	 ■ SYSTEM				: 
	 ■ SOURCE FILE NAME		: farmAddForm.jsp
	 ■ DESCRIPTION			: 양식장 추가  Form
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
<%@ page import="java.util.*"%>
<%@ page import="java.sql.*"%>
<!-- beans를 사용하기 위한 import -->
<%@page import="com.farm.*"%>
<%@ include file="../include/include/session.inc"%>

<%
	//권한 미달일 경우 알림창과 함께 뒤 페이지로 넘어감
	if(Auth.equals("사용자"))
	{
%>
		<script type="text/javascript">
			alert('권한이 없습니다.'); window.history.back(); 
		</script>
<%
	}
	
%>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>스마트 모니터링 시스템</title>
		<link rel="stylesheet" href="../common/style.css">
		<link rel="stylesheet" href="../common/jqm-button/icon.css">

		<!-- <script src="../common/main.js"></script> -->
		
		<script type="text/javascript">
		
			//취소할경우 메인으로 넘어가게 하는 함수
			function go_back() {
				alert("취소하였습니다.");
				location.href='farmListForm.jsp';
			}
		
			//확인할경우 Prc로 값을 전달해주는 함수
			function farmAdd() {
				var form = document.farm;
				form.method = "post";
				form.action = "farmAddPrc.jsp";
				form.target = "_self";
				form.submit();
			}
		</script>
	</head>
	
	<body>
	<section>
		<fieldset class="fieldset1">
			<h1 align="center">양식장 등록</h1>
		</fieldset>

		<div>
		<!-- 양식장 등록 폼 -->
		<form name="farm">
						
			<br>
			<div>
				<input type="button" value="취소" onclick="go_back(); return false;" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<input type="button" value="확인" onclick="farmAdd(); return false;"/>
			</div>
			<br>
			<br>
				<table class="tablefarmuser_upt">
					<tr height="50">
						<th colspan="6">양식장 정보 입력란</th>
					</tr>
					<tr height="50">
						<th colspan="2">양식장 이름</th>
							<td colspan="4"><input type="text" name="farmName" size="10" style="width: 80%; border: 0;"></td>
					</tr>
					<tr height="50">
						<th colspan="2">양식장 주소</th>
							<td colspan="4"><input type="text" name="Address" size="10" style="width: 80%; border: 0;"></td>
					</tr>
					<tr height="50">
						<th colspan="2">수조 개수</th>
							<td colspan="4"><input type="text" name="tankCnt" size="10" style="width: 80%; border: 0;"></td>
					</tr>						
				</table>
			<br>


			
		</form>
		</div>
	</section>

	<!-- 푸터 -->
	<footer>
		<%@ include file="../include/footer.inc"%>
	</footer>
		
	</body>
	
</html>