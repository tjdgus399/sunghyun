<%--
	■ SYSTEM                :  SAF 양식장
	■ SOURCE FILE NAME      :  farmwtUpdateForm.jsp
	■ DESCRIPTION           :  양식장 정보 수정 화면
	■ COMPANY               :  목포대학교 융합소프트웨어학과 
	■ PROGRAMMER            :  장해리
	■ DESIGNER              : 
	■ PROGRAM DATE          :  2019.08.19
	■ EDIT HISTORY          :  2019.08.22
	■ EDIT CONTENT          : 
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.farm.*"%>
<%@ page import="com.growInfo.*"%>
<%@ page import="com.waterTank.*"%>
<%@ page import="com.usertable.*"%>
<%@ include file="../include/include/session.inc"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>스마트 모니터링 시스템</title>
<!-------------------   CSS INCLUDE ------------------------->
<link rel="stylesheet" href="../common/style.css" />
<link rel="stylesheet" href="../common/jqm-button/icon.css" />
<%!int FarmID = 0;%>
<!-------------------   JS INCLUDE ------------------------->
<script src="../common/main.js"></script>

<%
	//한글 패치
	request.setCharacterEncoding("UTF-8");

	//farmDAO는 mgr1로 사용
	farmDAO mgr1 = new farmDAO();
	//waterTankDAO는 mgr2로 사용
	waterTankDAO mgr2 = new waterTankDAO();
	//growInfoDAO는 mgr3로 사용
	growInfoDAO mgr3 = new growInfoDAO();
	//usertableDAO는 mgr4로 사용
	usertableDAO mgr4 = new usertableDAO();

	//전페이지에서 가져온 수조번호 값
	String tankID = request.getParameter("tankID"); //tankID 값 요청(int)해서 받기

	//전페이지에서 가져온 양식장 아이디 값
	int FarmID = Integer.parseInt(request.getParameter("FarmID"));
	
	//취소 버튼 누를때 formname 비교 하기 위해서
	String formname = "formUpdate";
	
	//수정할 DB에 있는 값 불러오기
	ArrayList wtselectlist = mgr2.waterTankSelect(tankID, FarmID);

	//양식장 이름 출력에 사용
	ArrayList<farmDTO> farmnamelist = mgr1.farmSelect(FarmID);

	//어종 셀렉트박스 출력 부분 
	ArrayList<growInfoDTO> fishname_list = mgr3.fishSelect(FarmID);

	String test = request.getParameter("userid");

	//담당자
	ArrayList<usertableDTO> userAddlist = mgr4.usertableSelect(test);

	/* farmDAO에서 받아온 wtselectlist 출력 */
	for (int i = 0; i < wtselectlist.size(); i++) {
		/* System.out.println(i); */
		waterTankDTO vo = (waterTankDTO) wtselectlist.get(i);
		vo = (waterTankDTO) wtselectlist.get(i);

		//만약 DB에 있는 값이 NULL이면 아무것도 출력 안되게 하려고 적음
		String tankid = vo.getTankId();
		String lastuptdate = vo.getLastUptdate();
		String lastuptid = vo.getLastUptId();
		String fishname = vo.getRemark();
		String userid = vo.getUserId();
		String dosensor = vo.getDoSensor();
		String phsensor = vo.getPhSensor();
		String psusensor = vo.getPsuSensor();
		String wtsensor = vo.getWtSensor();
		String nh4sensor = vo.getNh4Sensor();
		String no2sensor = vo.getNo2Sensor();

		if (userid == null) {
			userid = "";
		}
		if (dosensor == null) {
			dosensor = "";
		}
		if (phsensor == null) {
			phsensor = "";
		}
		if (psusensor == null) {
			psusensor = "";
		}
		if (wtsensor == null) {
			wtsensor = "";
		}
		if (nh4sensor == null) {
			nh4sensor = "";
		}
		if (no2sensor == null) {
			no2sensor = "";
		}
		
%>
<script>
		//farmwtUpdateForm.jsp에서 헤더쪽 버튼 클릭하면 값 넘겨줌
		FarmID = <%=FarmID%>;
		</script>

<script type="text/javascript">
	/*******************************************************************************
	* farmwtUpdateForm.jsp 에서 DB에 맞는 물고기가 선택되도록
	******************************************************************************/
		function goFishname() {
			var frm = document.farmSelect;
			var fish = frm.selectFish;
			fish.value = ("<%=fishname%>");
	}
</script>

</head>

<!-- DB에 있는 어종 가져오려고 goFishname으로 보냄 -->
<body onload="goFishname();">
	<!-- 헤더 -->
	<header>
		<%@ include file="../include/header.inc"%>
	</header>

	<!-- 본문 -->
	<section id="index_Section">
				<br>
				<br>
			<h2>양식장 수조 정보 수정</h2>

			<br>
		<!-- 양식장 이름 -->
		<%
			for (int x = 0; x < farmnamelist.size(); x++) {
					farmDTO vo2 = (farmDTO) farmnamelist.get(x);
		%>
		<h3 align="center">
			<%=vo2.getFarmName()%>
			<!-- 권한에 따라 받아온 양식장 이름 리스트 출력 -->
			<br>
		</h3>
		<%
			} // for end
		%>
	
	
		<br> 
		<!-- 2_1.양식장 정보 수정 -->
		<section>


			<p align="center">
				<!-- 양식장 정보 수정 -->
				<br>
				<!-- 양식장 정보 등록 테이블(표) -->
			<div>
				<div>
					<form name="farmSelect" target="return false;">
						<!-- 넘겨줄 farmid -->
						<input type="hidden" name="FarmID" value="<%=FarmID%>" />
						<!-- Prc로 넘겨줄 수조번호 값  -->
						<input type="hidden" name="tankID2" value="<%=tankID%>" />
						<!-- tankID값 담아서 tankid로 값 전송 -->
						<!-- 취소 버튼 누를때 form네임 비교하려고 넘겨줄 값 -->
						<input type="hidden" name="formname" value="<%=formname %>" />
						
						
						<p style="float:center">
							<!-- 취소, 수정, 삭제 버튼 -->
							<input type="image" src="../common/images/btn_a_cancel.gif" onclick="farmCancel('<%=formname%>'); return false;" /> 
							<input type="image" src="../common/images/btn_a_correct.gif" onclick="goUpdate(); return false;" /> 
							<input type="image" src="../common/images/btn_a_delet.gif" onclick="gofarmdelete(); return false;" />
						</p>
						<br>

						<table class="farmwtUpdate">
							<tr>
								<!-- th : 제목, td : 셀(내용) -->
								<th colspan="2">수조번호</th>
								<!-- 옆으로 확장하기 -->
								<th colspan="2" name="tankid"><%=tankid%></th>

							</tr>

							<tr>
								<th>어종</th>
								<!-- 이 수조에 들어있는 어종이름은 fishnames로 넘겨줄거... js에서 Delete부분에 쓰려고 -->
								<input type="hidden" name="fishnames" value="<%=fishname%>" />
								<!-- 어종 선택하는거 셀렉트 박스로 만들었음 -->
								<td><select name="selectFish">
										<!-- 어종 종류 출력 -->
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
								<td><%=test%> <input type="hidden" name="userid" maxlength="10" value="<%=test%>" /> 
								<input type="image" src="../common/images/btn_a_inquiry.gif" onclick="gofarmwtUserForm_upt('<%=FarmID %>','<%=tankid %>'); return false;" /></td>
								<%
									}
										} else {
								%>
								<th>담당자</th>
								<td><%=userid%> <input type="hidden" name="userid" maxlength="10" value="<%=userid%>" /> 
								<%
									if(Auth.equals("사용자")){
								%>
								<%
								}else{
								%>
								
									<input type="image" src="../common/images/btn_a_inquiry.gif" onclick="gofarmwtUserForm_upt('<%=FarmID %>','<%=tankid %>'); return false;" />
								
								<%
								}
								%>
								</td>
								<%
									}
								%>
							</tr>

							<tr>
								<th rowspan="6">장비명</th>
								<!-- 위에서 아래로 확장하기 -->
								<th>DO</th>
								<td colspan="2"><input type="text" name="dosensor" maxlength="10" size="20" style="width: 95%;" value="<%=dosensor%>"></td>
							</tr>

							<tr>
								<th>pH</th>
								<td colspan="2"><input type="text" name="phsensor" maxlength="10" size="20" style="width: 95%;" value="<%=phsensor%>"></td>
							</tr>

							<tr>
								<th>PSU</th>
								<td colspan="2"><input type="text" name="psusensor" maxlength="10" size="20" style="width: 95%;" value="<%=psusensor%>"></td>
							</tr>

							<tr>
								<th>수온</th>
								<td colspan="2"><input type="text" name="wtsensor" maxlength="10" size="20" style="width: 95%;" value="<%=wtsensor%>"></td>
							</tr>

							<tr>
								<th>NH4</th>
								<td colspan="2"><input type="text" name="nh4sensor" maxlength="10" size="20" style="width: 95%;" value="<%=nh4sensor%>"></td>
							</tr>

							<tr>
								<th>NO2</th>
								<td colspan="2"><input type="text" name="no2sensor" maxlength="10" size="20" style="width: 95%;" value="<%=no2sensor%>"></td>
							</tr>

							<%
								} //for end
							%>

						</table>
						
					</form>

				 </div>
				</div>
		</section>
		<!-- 양식장 정보 수정 끝 -->

	</section>

	<!-- 푸터 -->
	<footer>
		
	</footer>
</body>
</html>