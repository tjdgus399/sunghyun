<%
   /*==============================================================================
	 ■ SYSTEM				: 
	 ■ SOURCE FILE NAME		: farmListForm.jsp
	 ■ DESCRIPTION			: 양식장 리스트 출력 Form
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
	//ID와 권한을 받아서 그에 따른 리스트를 받는다.
	farmDAO dao = new farmDAO();
	ArrayList list = dao.farmSelect(ID, Auth);
      
	int FarmID;
%>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>스마트 모니터링 시스템</title>
		<link rel="stylesheet" href="../common/style.css"/>
		<link rel="stylesheet" href="../common/jqm-button/icon.css"/>
		
		<script type="text/javascript">
		
			//취소할경우 메인으로 넘어가게 하는 함수
			function go_main() {
				alert("취소하였습니다.");
				close();
			}
		
			//등록버튼 누를경우 넘어가게 하는 함수
			function go_AddForm() {
				location.href = 'farmAddForm.jsp';
			}
		
			//수정할 양식장 정보를 누르면 farmUpdateForm으로 값을 전달해주는 함수 
			function farmUpdate(FarmID, farmName, address, tankcnt, username, userid) {
				var form= document.farmFrm;
				form.FarmID.value = FarmID;
				form.farmName.value = farmName;
				form.address.value = address;
				form.tankcnt.value = tankcnt;
				form.username.value = username;
				form.userid.value = userid;
				form.method = "post";
				form.action = "farmUpdateForm.jsp";
				form.target = "_self";
				form.submit();
			}
	
		</script>
	</head>
	
	<body>
		<br>
   
		<section>
		<fieldset class="fieldset1">
			<h1 align="center">양식장 등록/수정</h1>
		</fieldset>	
		<br>		
		<!-- 등록버튼 -->
		<div>
			<input type="button" value="닫기" onclick="go_main(); return false;" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<input type="button" value="등록" onclick="go_AddForm(); return false;"/>
		</div>
		<br>
		<br>
		
<%
		//전체 관리자일 경우 모든 양식장이 출력되게 한다.
		if(Auth.equals("전체관리자"))
		{
%>
			<!-- 양식장 정보 테이블 -->
			<table class="tablefarmuser_upt">
				<tr height="50">
					<th width="18%">양식장이름</th>
					<th width="*">주소</th>
					<th width="10%">수조 개수</th>
					<th width="13%">관리자</th>
					<th width="13%">등록자</th>
					<th width="20%">등록일</th>
				</tr>
<%				
			//리스트의 값이 없을 경우 출력
			if(list == null)
			{
%>
				<tr>
					<td colspan="15" align="center"><br> <br> <br> 조회 내용이 없습니다. <br> <br> <br></td>
				</tr>
<%
			}
			else
			{
				for (int i = 0; i < list.size(); i++) 
				{
					farmDTO vo = (farmDTO) list.get(i);
%>	
				<!-- tr에 onclick을 줘 누를 시 값을 전달 -->
				<tr class="listMouseEvent-pointer" height="50" onclick="farmUpdate('<%=vo.getFarmId() %>', '<%=vo.getFarmName() %>', '<%=vo.getAddress() %>', '<%=vo.getTankcnt() %>', '<%=vo.getRemark()%>', '<%=vo.getUserId()%>');">
					<td><%=vo.getFarmName()%></td>
					<td><%=vo.getAddress()%></td>
					<td><%=vo.getTankcnt()%></td>
					<td><%=vo.getRemark()%></td>
					<td><%=vo.getRegId()%></td>
					<td><%=vo.getRegDate()%></td>
				</tr>
<%
				}
			}
%>
		</table>
         	
		<!-- form 선언부분 -->
		<form name="farmFrm">
			<input type="hidden" name="FarmID"  value=""/>
			<input type="hidden" name="farmName"  value=""/>
			<input type="hidden" name="address" value=""/>
			<input type="hidden" name="tankcnt" value=""/>
			<input type="hidden" name="username" value=""/>
			<input type="hidden" name="userid" value=""/>
		</form>
<%
		}
		//일반 관리자일 경우의 리스트 출력
		else
		{
			System.out.println("ff:"+list);
%>
			<!-- 양식장 정보 테이블 -->
			<table class="tablefarmuser_upt">
				<tr>
					<th width="20%">양식장이름</th>
					<th width="*">주소</th>
					<th width="10%">수조 개수</th>
					<th width="15%">등록자</th>
					<th width="15%">등록일</th>
				</tr>
<%			
			//리스트의 값이 없을 경우 출력
			if(list == null)
			{
%>
				<tr>
					<td colspan="15" align="center"><br> <br> <br> 비어있습니다. <br> <br> <br></td>
				</tr>
<%
			}
			else
			{
				for(int i = 0; i < list.size(); i++) 
				{
					farmDTO vo = (farmDTO) list.get(i);
					int tankcnt = (int) vo.getTankcnt();
					
					FarmID = vo.getFarmId();					
%>
				<!-- tr에 onclick을 줘 누를 시 값을 전달 -->
				<tr class="listMouseEvent-pointer" height="50" onclick="farmUpdate('<%=vo.getFarmId() %>', '<%=vo.getFarmName() %>', '<%=vo.getAddress() %>', '<%=vo.getTankcnt() %>', '<%=vo.getRemark()%>', '<%=vo.getUserId()%>');">
					<td><%=vo.getFarmName()%></td>
					<td><%=vo.getAddress()%></td>
					<td><%=vo.getTankcnt()%></td>
					<td><%=vo.getRegId()%></td>
					<td><%=vo.getRegDate()%></td>
				</tr>
<%
				}
			}
%>
			</table>
			
			<!-- 폼 부분 선언 -->
			<form name="farmFrm">
				<input type="hidden" name="FarmID"  value=""/>
				<input type="hidden" name="farmName"  value=""/>
				<input type="hidden" name="address" value=""/>
				<input type="hidden" name="tankcnt" value=""/>
				<input type="hidden" name="username" value=""/>
				<input type="hidden" name="userid" value=""/>
			</form>
<%
		}
%>
		<br>
		</section>

	</body>
	
</html>