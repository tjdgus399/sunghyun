<%
   /*==============================================================================
	 ■ SYSTEM				: 
	 ■ SOURCE FILE NAME		: farmSearchForm.jsp
	 ■ DESCRIPTION			: 양식장 검색 Form
	 ■ COMPANY				: 목포대학교 융합소프트웨어공학과
	 ■ PROGRAMMER			: 박진후
	 ■ DESIGNER				: 
	 ■ PROGRAM DATE			: 2019.08.24
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
	request.setCharacterEncoding("UTF-8");
	
	String userid = request.getParameter("userID");

	ArrayList list= new ArrayList();
	//검색 키워드를 일단 ""으로 초기화 한다
	String farmName = "";
	String address = "";
	String userName = "";
	String regFromDate = "";
	String regToDate = "";
	//검색 키워드를 입력하였는지를 판별하기 위한 변수
	int num = 0;
	
	list = null;
	
	//검색 기록 유지 및 데이터 저장 용도
	if(request.getParameter("farmName") != null)
	{
		farmName = request.getParameter("farmName");
		num++;
	}
	
	if(request.getParameter("address") != null)
	{
		address = request.getParameter("address");
		num++;
	}
	
	if(request.getParameter("userName") != null)
	{
		userName = request.getParameter("userName");
		num++;
	}	
	
	if(request.getParameter("regFromDate") != null && request.getParameter("regToDate") != null)
	{
		regFromDate = request.getParameter("regFromDate");
		regToDate = request.getParameter("regToDate");
		num++;
	}

	// DAO, DTO
	farmDAO dao = new farmDAO();
	farmDTO dto = new farmDTO();
	
	//검색 조건을 dto에 입력
	dto.setFarmName(farmName);
	dto.setAddress(address);
	dto.setRemark(userName);
	dto.setRegFromDate(regFromDate);
	dto.setRegToDate(regToDate);
	
	//SearchFarm에 dto값들과 검색여부를 넣음
	list = dao.SearchFarm(dto);
	
%>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>스마트 모니터링 시스템</title>
		<link rel="stylesheet" href="../common/style.css">
		<link rel="stylesheet" href="../common/jqm-button/icon.css">
		
	<script src="../common/main.js"></script>

		<script type="text/javascript">
		
			//Date값이 잘못 됬다면 알림창을 띄우고 다시 입력하게 해줌
			function nopDate() {

				alert("등록날짜를 제대로 입력하시오.");
				location.href='farmSearchForm.jsp';
				
			}
			
			//조회 버튼을 누르면 값을 넘기면서 자신에게 페이지 이동
			function farmSearch() {
				
				var form = document.farmSelect;
				form.method = "post";
				form.action = "farmSearchForm.jsp";
				form.target = "_self";
				form.submit();			
				
			}

			//추가버튼을 누를경우 양식장 정보를 userInfo페이지에 넘겨줌
			function userInfo(farmID, userid) {
				
				var form = document.farmSelect;
				
				if(confirm("추가하시겠습니까?")!=0)
				{
					form.farmID.value = farmID;
					form.userID.value = userid;
					form.method = "post";
					form.action = "userInfoPrc.jsp";
					form.target = "_self";
					form.submit();
				}
				else
				{
					close();
				}
				
				
			}
		
		</script>
	</head>
	
	<body>
		<header>
			<%@ include file="../include/header.inc"%>
		</header>
		<br>
		
		<section class="section_mini">
		<hr>
			<h3>양식장 검색</h3>
		<hr>
		<br>
		<div>
			<!-- 검색 조건을 입력하는 폼 -->
			<form name="farmSelect">
				양식장 이름 : <input type="text" name="farmName" value="<%=farmName%>" />
				주소 : <input type="text" name="address" value="<%=address%>" />
				담당자 : <input type="text" name="userName" value="<%=userName%>" />
			<br>
				등록날짜 <input type="date" name="regFromDate" value="<%=regFromDate%>" />
				~ <input type="date" name="regToDate" value="<%=regToDate%>" />
				<input type="hidden" name="FarmID" value="<%=dto.getFarmId()%>" />
				<input type="hidden" name="userID" value="<%=userid%>" />
				<input type="button" value="조회" onclick="farmSearch();" />
			<br>
			<br>
			
			<div>
				<table class="farmwtUpdate">
					<tr>
						<th class="th1">이름</th>
						<th class="th1">주소</th>						
					</tr>
<%	
				//조회 결과가 없을 경우 검색 결과가 없습니다.로 표기
				if(list == null)
				{
%>
					<tr>
						<td colspan="15" align="center"><br> <br> <br> 조회 내용이 없습니다. <br> <br> <br></td>
					</tr>
<%
				}
				//날짜의 이상 문제라면 nopDate()를 호출
				else if(list.get(0).equals("nop"))
				{					
					out.print("<script type='text/javascript'>");
					out.print("nopDate();");
					out.print("</script>");
				}
				//조회 결과가 있을 경우 그에 맞는 양식장 이름, 주소 생성
				else
				{
					for (int i = 0; i < list.size(); i++)
					{
						farmDTO	outDto= (farmDTO) list.get(i);
%>	
					<tr class="listMouseEvent-pointer" onclick="userInfo('<%=outDto.getFarmId() %>', '<%=userid %>');">
						<td><%=outDto.getFarmName()%></td>
						<td><%=outDto.getAddress()%></td>
					</tr>
<%
					}
				}		
%>
				</table>
			</div>
			</form>
		</div>	
		</section>

	</body>

</html>