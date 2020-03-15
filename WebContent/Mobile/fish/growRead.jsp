<!-- 
   /*==============================================================================
    ■ SYSTEM            : 
    ■ SOURCE FILE NAME  : growRead.jsp
    ■ DESCRIPTION       : 양식장의 해당 상태기준정보의 상세정보
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
<jsp:useBean id="StrUtil" class="com.main.StringUtil" />
<!DOCTYPE html>
<html>
	<head>
<%
		//한글패치
		request.setCharacterEncoding("EUC-KR");

		// 양식장에서 넘겨온 파라미터를 받는 변수
		int FarmID = Integer.parseInt(request.getParameter("FarmID"));
		int groupcode = Integer.parseInt(request.getParameter("groupcode"));
		
		String farmName = farmDAO.farmidToName(FarmID);
		
		ArrayList<growInfoDTO> adto = growDAO.readGrowInfo(FarmID, groupcode);
		
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
		
			function growInfoMove(farmId, groupcode)
			{
				var frm = document.InfoForm;
				
				frm.groupcode.value = groupcode;
				frm.farmId.value = farmId;
				
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
				<tr id="farmTitle"><td colspan="3"><%=farmName %><hr>상태기준정보 상세</td></tr>
				<tr>
					<td class="growInfoItem">상태기준정보명</td>
					<td class="growInfoItem" colspan="2"><%=adto.get(0).getFishName() %></td>
				</tr>
<%
					String item[] = {"DO", "WT", "psu", "pH", "NH4", "NO2"};
					Double itembox[][] = {	{adto.get(0).getDOMin(), adto.get(0).getDOMax(),
										adto.get(1).getDOMin(), adto.get(1).getDOMax(),
										adto.get(2).getDOMin(), adto.get(2).getDOMax()},
										{adto.get(0).getWTMin(), adto.get(0).getWTMax(),
										adto.get(1).getWTMin(), adto.get(1).getWTMax(),
										adto.get(2).getWTMin(), adto.get(2).getWTMax()},
										{adto.get(0).getPsuMin(), adto.get(0).getPsuMax(),
										adto.get(1).getPsuMin(), adto.get(1).getPsuMax(),
										adto.get(2).getPsuMin(), adto.get(2).getPsuMax()},
										{adto.get(0).getpHMin(), adto.get(0).getpHMax(),
										adto.get(1).getpHMin(), adto.get(1).getpHMax(),
										adto.get(2).getpHMin(), adto.get(2).getpHMax()},
										{adto.get(0).getNH4Min(), adto.get(0).getNH4Max(),
										adto.get(1).getNH4Min(), adto.get(1).getNH4Max(),
										adto.get(2).getNH4Min(), adto.get(2).getNH4Max()},
										{adto.get(0).getNO2Min(), adto.get(0).getNO2Max(),
										adto.get(1).getNO2Min(), adto.get(1).getNO2Max(),
										adto.get(2).getNO2Min(), adto.get(2).getNO2Max()}};
					
					for(int i=0; i<6; i++)
					{
%>
						<tr class="growInfoItem"><td rowspan="10" class="itemName"><%=item[i] %></td><td class="remark1" rowspan="2">위험</td><td><%=StrUtil.noneToBar(itembox[i][0]) %></td></tr>
						<tr class="growInfoItem"><td rowspan="2"><%=StrUtil.noneToBar(itembox[i][1])%></td></tr>
						<tr class="growInfoItem"><td class="remark2" rowspan="2">경고</td></tr>
						<tr class="growInfoItem"><td rowspan="2"><%=StrUtil.noneToBar(itembox[i][2])%></td></tr>			
						<tr class="growInfoItem"><td class="remark3" rowspan="2">정상</td></tr>
						<tr class="growInfoItem"><td rowspan="2"><%=StrUtil.noneToBar(itembox[i][3])%></td></tr>			
						<tr class="growInfoItem"><td class="remark2" rowspan="2">경고</td></tr>
						<tr class="growInfoItem"><td rowspan="2"><%=StrUtil.noneToBar(itembox[i][4])%></td></tr>
						<tr class="growInfoItem"><td class="remark1" rowspan="2">위험</td></tr>
						<tr class="growInfoItem"><td><%=StrUtil.noneToBar(itembox[i][5])%></td></tr>
<%
					}
%>
			</table>
			<form name="InfoForm">
				<input type="hidden" name="groupcode"/>
				<input type="hidden" name="FarmID" value="<%=FarmID %>"/>
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