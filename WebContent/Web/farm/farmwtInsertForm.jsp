<%-- 
	■ SYSTEM                : SAF 양식장
    ■ SOURCE FILE NAME      : farmwtInsertForm.jsp
    ■ DESCRIPTION           : 양식장 정보 등록 화면(farmwtSearch.jsp에서 넘어옴)
    ■ COMPANY               : 목포대학교 융합소프트웨어학과 
    ■ PROGRAMMER            : 김수아
    ■ DESIGNER              : 
    ■ PROGRAM DATE          : 2019.08.
    ■ EDIT HISTORY          : 2019.08.18
    ■ EDIT CONTENT          : 2019.08.18 
 --%>   
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.farm.*"%>
<%@ page import="com.growInfo.*"%>
<%@ page import="com.waterTank.*"%>
<%@ page import="com.usertable.*"%>
<%@ page import="com.main.*"%>
<%@ include file="../include/include/session.inc"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>스마트 모니터링 시스템</title>
<link rel="stylesheet" href="../common/style.css">
<link rel="stylesheet" href="../common/jqm-button/icon.css" />
<script src="../common/main.js"></script>

<%
	//한글 패치
	request.setCharacterEncoding("UTF-8");
	//usertableDAO는 mgr1로 사용
	usertableDAO mgr1 = new usertableDAO();
	//growInfoDAO는 mgr2로 사용
	growInfoDAO mgr2 = new growInfoDAO();
	//farmDAO는 mgr3로 사용
	farmDAO mgr3 = new farmDAO();

	//userid 불러오기
	String test = request.getParameter("userid");

	int FarmID = Integer.parseInt(request.getParameter("FarmID"));
	
	//취소 버튼 누를때 formname 비교 하기 위해서
	String formname = "formInsert";


	//담당자 조회 부분
	ArrayList<usertableDTO> userAddlist = mgr1.usertableSelect(test);
	// 어종 선택 부분 
	ArrayList<growInfoDTO> fishname_list = mgr2.fishSelect(FarmID);
	
	ArrayList<farmDTO> farmnamelist = mgr3.farmSelect(FarmID);
%>

</head>
<body>

	<!-- 헤더 -->
	<header>
		<%@ include file="../include/header.inc"%>
		
		<!-- 양식장 이름 -->
		<br><br><br><br><br>
		</header>
	
	<!-- Prc로 넘어가는 부분 -->

	<!-- 2.본문 -->
	
	<section>
	<h2>양식장 수조 정보 등록</h2>
	    <br>
		<br>
		<!-- 2_1.양식장 정보 등록 -->
		<section>
			<%
			for (int i = 0; i < farmnamelist.size(); i++) {
					farmDTO vo = (farmDTO) farmnamelist.get(i);
		%>
		<h3 align="center">
		<%=vo.getFarmName()%>				
		<!-- 권한에 따라 받아온 양식장 이름 리스트 출력 -->
		</h3>
		<%
			} // for end
		%>
		 <script>
            FarmID = <%=FarmID%>;
         </script>
			<br><br>
<form name="farmwtInsertForm">
				<input type="hidden" name="FarmID" value="<%=FarmID %>" />
				
				<!-- 취소 버튼 누를때 form네임 비교하려고 넘겨줄 값 -->
                <input type="hidden" name="formname" value="<%=formname %>" />
				
					<!-- 양식장 정보 등록 -->
						<!-- 양식장 정보 등록 테이블(표) -->
					<table class="farmwtInsert">
						<!-- 컬럼(행) -->
						<tr>
							<!-- 해당하는 행의 바탕색 설정 -->
							<th colspan="2">수조번호</th>
							<!-- 옆으로 확장하기 -->
							<td colspan="2"><input type="text" name="tankid" size="20" style="width: 100%; border: 0;" maxlength="10"></td>
							<!-- th : 제목, td : 셀(내용) -->
						</tr>
						<!-- <tbody> -->
						<tr>
							<th>어종</th>
							<!-- 어종 선택하는거 셀렉트 박스로 만들었음 -->
							<td><select name="selectFish">
									<!-- 셀렉트 박스 어종 종류 출력 -->
									<option>어종을 선택하세요.</option>
									<%
										for (int j = 0; j < fishname_list.size(); j++) {
									%>
									<option value="<%=fishname_list.get(j).getRemark()%>"><%=fishname_list.get(j).getRemark()%></option>
									<%
										}
									%>
									
							</select></td>

					<%
						if (test != null) {
							for (int z = 0; z < 1; z++) {
					%>
							<th>담당자</th>
							<td><%=test%>
								<input type="hidden" name="userid" maxlength="10" value="<%=test%>" /> 
								<input type="image" src="../common/images/btn_search.gif" onclick="gofarmwtUserForm_in('<%=FarmID %>')" value="조회" />
							</td>
					<%
						}
						} else {
					%>
							<th class=th1>담당자</th>
							<td><input type="image" src="../common/images/btn_search.gif" onclick="gofarmwtUserForm_in('<%=FarmID %>')" value="조회" /></td>
					<%
						} //size
					%>
						</tr>

						<tr>
							<th rowspan="6">장비명</th>
							<!-- 위에서 아래로 확장하기 -->
							<th class=th3>DO</th>
							<td colspan="2"><input type="text" name="dosensor" size="20" style="width: 100%; border: 0;" maxlength="10"></td>
						</tr>

						<tr>
							<th>pH</th>
							<td colspan="2"><input type="text" name="phsensor" size="20" style="width: 100%; border: 0;" maxlength="10"></td>
						</tr>

						<tr>
							<th>PSU</th>
							<td colspan="2"><input type="text" name="psusensor" size="20" style="width: 100%; border: 0;" maxlength="10"></td>
						</tr>

						<tr>
							<th>수온</th>
							<td colspan="2"><input type="text" name="wtsensor" size="20" style="width: 100%; border: 0;" maxlength="10"></td>
						</tr>

						<tr>
							<th>NH4</th>
							<td colspan="2"><input type="text" name="nh4sensor" size="20" style="width: 100%; border: 0;" maxlength="10"></td>
						</tr>

						<tr>
							<th>NO2</th>
							<td colspan="2"><input type="text" name="no2sensor" size="20" style="width: 100%; border: 0;" maxlength="10"></td>
						</tr>
						<!-- </tbody> -->
					</table>
					<br>
					<p align="center">
						<input type="image" src="../common/images/btn_a_cancel.gif" onclick="farmCancel('<%=formname %>'); return false;" value="취소" /> <!-- 취소 버튼을 누를 시 farm.js->goCancle()작용 -->
						<input type="image" src="../common/images/btn_add.gif" onclick="farmwtInsert(); return false;" value="등록" /> <!-- 등록 버튼을 누를 시 farm.js->farmwtInsert()작용 -->
					</p>
				</form>
		</section>
		
		<!-- 양식장 정보 등록 끝 -->
	</section>
	<!-- 본문 끝 -->
	
	<!-- 푸터 -->
		<footer>
			<%@ include file="../include/footer.inc"%>
		</footer>
</body>
</html>