<%
   /*==============================================================================
	 ■ SYSTEM				: SAF(Smart Aqua Farm) - 스마트 모니터링 시스템
	 ■ SOURCE FILE NAME		: Mobile/waterTank/wtCautionUpdateForm.jsp
	 ■ DESCRIPTION			: 수조 조치기록 수정 팝업창
	 ■ COMPANY				: 목포대학교 융합소프트웨어공학과 
	 ■ PROGRAMMER			: 문인찬
	 ■ DESIGNER				: 
	 ■ PROGRAM DATE			: 2019.08.23
	 ■ EDIT HISTORY			: 
	 ■ EDIT CONTENT			: 
	==============================================================================*/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.repair.*" %>
<jsp:useBean id="strUtil" class="com.main.StringUtil"/>
<jsp:useBean id="repairDAO" class="com.repair.repairDAO"/>

<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>스마트 모니터링 시스템</title>
<!-------------------   CSS INCLUDE ------------------------->
<link rel="stylesheet" href="../common/style.css">
<link rel="stylesheet" href="../common/jqm-button/icon.css" />

<!-------------------   JS INCLUDE ------------------------->
<script src="../common/jquery/jquery-2.2.4.js"></script>
<script src="../common/main.js"></script>

<script>
<%
request.setCharacterEncoding("UTF-8");


// 클릭한 리스트 데이터 받아오는 용도
String farmName = strUtil.nullToBlank(request.getParameter("farmName"));
String tankID = strUtil.nullToBlank(request.getParameter("tankID"));
String repairSeq = strUtil.nullToBlank(request.getParameter("rp_s"));
String recSeq = strUtil.nullToBlank(request.getParameter("rc_s"));
//repaircontents 입력되어 있던 내용 출력
String contents = repairDAO.getRepairContents(Integer.parseInt(repairSeq),Integer.parseInt(recSeq));

%>

</script>
</head>
<body>

    <!-- 섹션 시작 -->
    <section>
		<fieldset>
			<h4 align="center"> 조치 내용 수정 </h4>
		</fieldset>
	<div class="wtCautionUpdateForm">
		<div class="record">
			<div> <%= farmName %> </div> <!-- 양식장 이름 -->
			<div> <%= tankID %> </div> <!-- 수조ID -->
		</div>
		<form method="POST" name="updateForm">
			<p>
			<input type="hidden" name="repairSeq" value="<%= repairSeq %>" />
			<input type="hidden" name="recSeq" value="<%= recSeq %>" />
			<textarea name="repairContents" autofocus ><%= contents %></textarea>
			</p>
			<input type="button" value="취소" onclick="self.close()" />
			<input type="button" value="확인" onclick="repairContentsUpdate()" />
		</form>
	</div>
	
	</section>
	<!-- 섹션 끝 -->
	
</body>
</html>