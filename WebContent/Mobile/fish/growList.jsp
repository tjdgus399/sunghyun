<!-- 
   /*==============================================================================
    ■ SYSTEM            : 
    ■ SOURCE FILE NAME  : growList.jsp
    ■ DESCRIPTION       : 양식장의 상태기준정보 리스트
    ■ COMPANY           : 목포대학교 융합소프트웨어공학과
    ■ PROGRAMMER        : 김성현
    ■ DESIGNER          : 
    ■ PROGRAM DATE      : 2019.08.19
    ■ EDIT HISTORY      : 
    ■ EDIT CONTENT      : 
   ==============================================================================*/
 -->
<%@page import="com.growInfo.growInfoDTO"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/SessionState.inc"%>
<jsp:useBean id="farmDAO" class="com.farm.farmDAO"/>
<jsp:useBean id="growDAO" class="com.growInfo.growInfoDAO"/>
<!DOCTYPE html>
<html>
	<head>
<%
		//한글패치
		request.setCharacterEncoding("EUC-KR");

		// 양식장에서 넘겨온 파라미터를 받는 변수
		int FarmID = Integer.parseInt("1");
		String farmName = farmDAO.farmidToName(FarmID);
%>
		<meta charset="UTF-8">
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<title>스마트 양식장</title>
		
		<!--  Jquery Mobile CSS Include  -->
		<link rel="stylesheet" href="../common/style.css" />
		<link rel="stylesheet" href="../common/jquery/jquery.mobile-1.0.1.css" />
		<link rel="stylesheet" href="growInfo.css" />
		
		<!--  Jquery Mobile JS Include  -->
		<script src="../common/jquery/demos/jquery.js"></script>
		<script src="../common/jquery/jquery.mobile-1.0.1.js"></script>
		<script src="../common/main.js"></script>
		
		<script>		
			function growInfoMove(groupcode)
			{
				var frm = document.InfoForm;
				
				frm.groupcode.value = groupcode;
				alert(frm.FarmID.value);
				frm.method = "post";
				frm.action = "growRead.jsp";
				frm.target = "_self";
				frm.submit();
			}
		</script>
	</head>
	<body>
		<!-- Header Start -->
		<header data-role="header" data-position="fixed">
			<%@ include file="../include/headerTitle.inc" %>
		</header>
		<!-- Header End -->
		
		<!-- Section Start -->
		<section data-role="section">
			<%@include file="../include/headerMenu.inc" %>
			<br>
			<table>
				<tr id="farmTitle"><td><%=farmName %><hr>상태기준정보 선택</td></tr>
<%
				ArrayList<growInfoDTO> list = growDAO.mgrowList(FarmID);
				if(list.isEmpty())
				{
%>
					<tr><td> 등록된 양식정보가 없습니다 </td></tr>
<%
				}
				else
				{
					for(int i=0; i<list.size(); i++)
					{
						growInfoDTO dto = list.get(i);
%>
						<tr class="growInfoItem" onclick="growInfoMove('<%=dto.getGroupCode()%>')"><td><%=dto.getFishName() %></td></tr>
<%
					}
				}
%>
			</table>
			<form name="InfoForm">
				<input type="hidden" name="groupcode"/>
				<input type="hidden" name="FarmID" value="<%=FarmID%>"/>
			</form>
		</section>
		<!-- Section End -->
		
		<!-- Footer Start -->
		<footer data-role="footer" data-position="fixed">
			<%@ include file="../include/footer.inc"%>
		</footer>
		<!-- Footer End -->
	</body>
</html>