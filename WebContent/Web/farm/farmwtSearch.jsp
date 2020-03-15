<%--
	 ■ SYSTEM               : SAF 양식장
	 ■ SOURCE FILE NAME     : farmwtSearch.jsp
	 ■ DESCRIPTION          : 양식장 정보 보기 화면
	 ■ COMPANY              : 목포대학교 융합소프트웨어학과  
	 ■ PROGRAMMER           : 황선주
	 ■ DESIGNER             : 
	 ■ PROGRAM DATE         : 2019.08.
	 ■ EDIT HISTORY         : 2019.08.16
	 ■ EDIT CONTENT         : 2019.08.16
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.farm.*"%>
<%@ page import="com.waterTank.*"%>
<%@ page import="com.growInfo.*"%>
<%@ page import="com.usertable.*"%>
<%@ include file="../include/include/session.inc"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>스마트 모니터링 시스템</title>	
<!-------------------   CSS INCLUDE ------------------------->
<link rel="stylesheet" href="../common/style.css">
<link rel="stylesheet" href="../common/jqm-button/icon.css" />

<!-------------------   JS INCLUDE ------------------------->
<script src="../common/main.js"></script>
<script type="text/javascript">
	// 버튼에 넘겨줄 양식장 ID
	var FarmID;
</script>


</head>
<body>

	<header>
		<%@ include file="../include/header.inc"%>
			<br><br><br><br><br>
			<h2 style="text-align:center">양식장 수조 정보</h2>
	</header>

	<!-- section 시작 -->
	<section id="index_Section">
		<%
			request.setCharacterEncoding("UTF-8");

			farmDAO cdd = new farmDAO(); // farmDAO 객체 생성
			waterTankDAO cdd2 = new waterTankDAO(); // waterTankDAO 객체 생성
			String farmName = null;
			String search = ""; // 검색 조건 변수
			String searchinput = ""; // 검색창 변수
			ArrayList<waterTankDTO> wtlist = null; // 양식장 정보 리스트 변수
			ArrayList<farmDTO> farmnamelist = null; // 양식장 이름 리스트 변수

			int FarmID = Integer.parseInt(request.getParameter("FarmID"));
			// wtlist,farmnamelist는 권한에 따라서 분류되서 동일한 이름의 리스트를 사용함
			if (Auth.equals("사용자")) { // 권한 : 사용자일 경우
				search = request.getParameter("search"); //검색 조건 값 받아옴
				searchinput = request.getParameter("searchinput"); //검색창 값 받아옴

				wtlist = cdd2.waterTankSearch(ID, search, searchinput);
				farmnamelist = cdd.farmSelect(ID);

			} else  { // 권한 : admin, sysadmin일 경우 		 

				search = request.getParameter("search"); //검색 조건 값  
				searchinput = request.getParameter("searchinput"); //검색창 값

				wtlist = cdd2.waterTankSearch(FarmID, search, searchinput);
				farmnamelist = cdd.farmSelect(FarmID);

			}
		%>

		<script>
		FarmID = <%=FarmID%>;
   		</script>

		<!-- 양식장 이름 출력 (권한이 admin, sysadmin일 경우 선택한 값으로 받아옴) -->
		<%
			for (int i = 0; i < farmnamelist.size(); i++) {
				farmDTO vo = (farmDTO) farmnamelist.get(i);
		%>
		<h3><br><br><br>
			<%=vo.getFarmName()%>
			<!-- 권한에 따라 받아온 양식장 이름 리스트 출력 -->
			<br>
		</h3>
		<%
			} // for end
		%>

		<form name="farmSearch">
		<input type="hidden" name="FarmID" value="<%=FarmID %>" />
			<!-- 조건 리스트 -->

				<%
					if (search == "null") {
						search = "";
					}
					if (searchinput == null) { // 검색창이 null일 경우 공백으로 출력되게함
						searchinput = "";
					}
				%>
			
			<p>
				<span style="float:center">
				<!-- 셀렉트 박스 -->
				<select name="search" id="search">
					<option selected value='null'>조건선택</option>
					<option value='tankid'>수조 번호</option>
					<option value='lastuptdate'>수정 일시</option>
					<option value='lastuptid'>수정자</option>
					<option value='userid'>담당자</option>
				</select>

				<script>farmSearch.search.value ='<%=search%>'</script>
				<!-- 재검색시 검색조건 값 유지 -->

				<!-- 검색어 창 -->
				<input type="search" id="searchinput" name="searchinput" value="<%=searchinput%>" />
				<!-- value:재검색시 검색창 값 유지 -->
				
				<!-- 검색버튼을 누르면 해당 값에 맞는 리스트값 출력 -->
				<input type="image" src="../common/images/btn_a_inquiry.gif" onclick="searchCheck(); return false;" />
				</span>
			</p>
				
			<p>
			 <!-- 등록 버튼을 누르면 양식장 정보 등록 화면으로 이동 --> 
			<%
				if (Auth.equals("사용자")) { // 권한 : 사용자일때 등록 버튼은 보이지 않도록 한다.
			%>
			 
			<%
				} else { // 권한 : admin, sysadmin일때 등록 버튼이 보이도록 한다.
			%> 
			<span style="float:right; padding-right:200px">
				<input type="image" src="../common/images/btn_a_regist.gif" onclick="gofarmwtInsertForm(); return false;" /> 
			</span>
			<%
				}
			%>
			</p>
		 	<p>
				<br>
				<br>
		 	
			<!-- 검색 정보 테이블 -->
			<table class="tablefarmuser_upt">
				<tr>
					<th rowspan="2" width="12%">수조번호</th>
					<th rowspan="2" width="12%">수정일시</th>
					<th rowspan="2" width="12%">수정자</th>
					<th rowspan="2" width="12%">어종</th>
					<th rowspan="2" width="12%">담당자</th>
					<th colspan="6" width="*">장비명</th>
				</tr>

				<tr>
					<th>DO</th>
					<th>pH</th>
					<th>염도</th>
					<th>수온</th>
					<th>NH4</th>
					<th>NO2</th>
				</tr>

				<%
					if (wtlist.isEmpty()) { // 리스트가 비어있을 경우 출력되는 값(if_1)
				%>
				<tr>
					<td colspan="11"><br> <br> <br> 조회 내용이 없습니다. <br> <br> <br></td>
				</tr>
				<%
					} else { // 리스트 값이 비어있지 않은 경우 출력되는 값

						for (int i = 0; i < wtlist.size(); i++) { //farmDAO에서 받아온 wtlist 출력               
							waterTankDTO vo = (waterTankDTO) wtlist.get(i);

							//waterTankTableDTO에 저장된 값 변수에 다시 저장
							String tankid = vo.getTankId(); // 수조번호
							String lastuptdate = vo.getLastUptdate(); // 수정일시
							String lastuptid = vo.getLastUptId(); // 수정자
							String fishname = vo.getRemark(); // 어종이름
							String userid = vo.getUserId(); // 사용자ID
							String dosensor = vo.getDoSensor(); // 장비명 : DO
							String phsensor = vo.getPhSensor(); // 장비명 : pH
							String psusensor = vo.getPsuSensor(); // 장비명 : 염도
							String wtsensor = vo.getWtSensor(); // 장비명 : 수온
							String nh4sensor = vo.getNh4Sensor(); // 장비명 : NH4
							String no2sensor = vo.getNo2Sensor(); // 장비명 : NO2

							// 화면에 출력되는 값이 null일 경우 공백으로 출력되게 함
				%>

				<tr class="listMouseEvent-pointer" onclick="goRead('<%= tankid %>','<%= FarmID %>')" >
					<%
						if (Auth.equals("사용자")) { // 권한 : 사용자(user)일 경우(if_2)
					%>
					<td><a style="text-decoration: none"><%=tankid%></a></td>
					<!-- 사용자는 조회만 가능하도록 함 -->

					<%
						} else {
					%>
					<td><%=tankid%></td>
					<!-- admin,sysadmin은 조회,수정,등록이 가능하도록함. 수조번호 선택시 farmwtUpdateForm으로 이동(tankID값과 같이 넘어간다.)   -->
					<%
						} // if_2 end
					%>
					<td><%=lastuptdate%></td>
					<td><%=lastuptid%></td>
					<td><%=fishname%></td>
					<td><%=userid%></td>
					<td><%=dosensor%></td>
					<td><%=phsensor%></td>
					<td><%=psusensor%></td>
					<td><%=wtsensor%></td>
					<td><%=nh4sensor%></td>
					<td><%=no2sensor%></td>
					<!-- 양식정보 수정시 선택한 수조번호를 넘기기 위함 -->
				</tr>
				<%
						} // for end
					} // if_1 end
				%>
			</table>
			</p>

		</form>
	</section>
	<!-- section 끝 -->
</body>


</html>