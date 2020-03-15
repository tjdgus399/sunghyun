<%-- 
	■ SYSTEM				: SAF 양식장
	■ SOURCE FILE NAME		: farmwtUserForm_in.jsp
	■ DESCRIPTION			: 담당자 검색화면(farmwtInsertForm.jsp에서 넘어옴)
	■ COMPANY				: 목포대학교 융합소프트웨어학과 
	■ PROGRAMMER			: 황선주
	■ DESIGNER				: 
	■ PROGRAM DATE			: 2019.08.
	■ EDIT HISTORY			: 2019.08.16
	■ EDIT CONTENT			: 2019.08.16 
--%>
	 
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.farm.*"%>
<%@ page import="com.usertable.*" %>
<%@ include file="../include/include/session.inc"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>스마트 모니터링 시스템</title>
		<link rel="stylesheet" href="../common/style.css">
		<script src="../common/main.js"></script>
	</head>
<body>

	<!-- 2. 본문 -->
	<section>
	
	<%	
		request.setCharacterEncoding("UTF-8");
	
		usertableDAO cdd = new usertableDAO();
	
		String searchuser = request.getParameter("searchuser");				//검색 조건 값
		String searchuserinput = request.getParameter("searchuserinput");	//검색창 값
		String FarmID = request.getParameter("FarmID");
		ArrayList<usertableDTO> userlist = cdd.usertableSearch(FarmID, searchuser, searchuserinput);
	%>

	<fieldset>
		<h3 align="center" color="white">회원검색</h3>

	</fieldset>
		
		<form name = "farmUser">
		<input type="hidden" name="FarmID" value="<%=FarmID %>"/>
			<%		
				if(searchuser == "null") {		// 담당자 검색 조건이 null일 때 공백 출력
					searchuser ="";
				}
				if(searchuserinput == null) {	// 담당자 검색창이 null일 때 공백 출력
					searchuserinput = "";
				}
		
			%>
			
		<!-- 셀렉트 박스 -->
		
		<p>
			<select name="searchuser">
				<option value='null'>조건선택</option>
				<option value='username'>이름</option>
				<option value='userid'>ID</option>
			</select>
			
			<!-- 담당자 재검색시 검색조건 값 유지 -->
			<script>farmUser.searchuser.value ='<%=searchuser%>'</script>
			
			<!-- 검색창 , value:담당자 재검색시 검색창 값 유지 -->
			<input type="search" name="searchuserinput" value="<%=searchuserinput%>" />	
			
			<!-- 담당자 검색시 farmwtUserPrc_in.jsp로 넘어감 --> 
			<input type="image" src="../common/images/btn_a_inquiry.gif" onclick="searchuserCheck_in(); return false;"/>
		
		</p>
		
		<br>
		
		<!-- 3. 테이블 시작 -->
		
		<table class="tablefarmuser_upt" >
			<tr>
				<th>이름</th>
				<th>ID</th>
				<th>버튼</th>
			</tr>
			<%
				if(userlist.isEmpty()) {	// 담당자 검색 리스트가 공백시 출력되는 값
			%>
				<tr>
					<td colspan="3"> <br> 비어있습니다. <br> </td>
				</tr>
			<%	
				} else {
					for (int i = 0; i < userlist.size(); i++) {		//farmDAO에서 받아온 userlist 출력
	            	
					usertableDTO vo = (usertableDTO) userlist.get(i);
					
					// usertableDTO에 저장한 값 재저장
	            	String username = vo.getUserName();
					String userid = vo.getUserId();

			%>
			
			<tr>
				<td><%=username %></td>
				<td><%=userid %></td>
				
				<input type="hidden" name="userid" value="<%=userid%>"/>
		
				<td>
					<input type="image" src="../common/images/btn_a_select.gif" onclick="check_in('<%=userid%>', '<%=FarmID%>'); return false;"/>
				</td>
			</tr>
			
			<%
					}	// for end
				}	// if end
			%>
		</table>
		
		</form>
		<!-- 테이블 끝 -->
	</section>
	<!-- 본문 끝 -->
</body>
</html>