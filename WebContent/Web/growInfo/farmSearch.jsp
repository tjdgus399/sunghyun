<%
   /*==============================================================================
	 ■ SYSTEM				: SAF(Smart Aqua Farm) - 스마트 모니터링 시스템
	 ■ SOURCE FILE NAME		: growInfo/farmSearch.jsp
	 ■ DESCRIPTION			: 상태기준정보 등록 화면에 필요한 양식장 검색
	 ■ COMPANY				: 
	 ■ PROGRAMMER			: 윤건주
	 ■ DESIGNER				: 
	 ■ PROGRAM DATE			: 2019.08.16
	 ■ EDIT HISTORY			: 
	 ■ EDIT CONTENT			: 
	==============================================================================*/
%>
<%@page import="com.farm.farmDTO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="sun.font.SunFontManager.FamilyDescription"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/include/session.inc" %>
<jsp:useBean id="StrUtil" class="com.main.StringUtil"/>
<jsp:useBean id="fdao" class="com.farm.farmDAO"/>
<%
	// 한글 패치
	request.setCharacterEncoding("EUC-KR");
	
	// 양식장 이름값
	String farmName = StrUtil.nullToBlank(request.getParameter("farmName"));
%>
<style>
	/*표 중앙배치*/
	#farmSearchTable
	{
		margin:auto;
		width:410px;
		border-collapse: collapse;
		text-align: center;
	}
	
	/*표 실선*/
	#farmSearchTable th, td 
	{
		border: 1px solid black;
	}
	
	#farmSearchheaderTable
	{
		background-color: #DCDCDC;
	}
	
	#farmSearchSectionTable td:hover
	{
		background-color: gold;
	}
	
	#btnSearch
	{
		background-image:url('../include/etc/images/btn_a_inquiry.gif');
		background-repeat: no-repeat;
		background-position: center;
		background-size: 70px 30px;
		width:70px;
		height:30px;
	}
	
	#btnCancel
	{
		background-image:url('../include/etc/images/btn_cancel.gif');
		background-repeat: no-repeat;
		background-position: center;
		background-size: 70px 30px;
		width:70px;
		height:30px;
	}
</style>
<title>스마트 모니터링 시스템</title>
<script>
	function pick(id, name, address)
	{
		if(confirm("해당 양식장을 선택하시겠습니까?"))
		{
			//부모객체 farmID값 수정
			opener.document.growInfoForm.FarmID.value = id;
			//부모객체 farmName값 수정
			opener.document.getElementById("farmName").innerHTML = name + "(" + address + ")";
			self.close();
		}
	}
	
	//초기화
	function farmSearch() {
		var frm = document.checkForm;
		frm.method = "post";
		frm.action = "farmSearch.jsp";
		frm.target = "_self";
		frm.submit();
	}

	//창 닫기
	function selfClose() {
		self.close();
	}
</script>
<form name="checkForm" method="post" action="farmSearch.jsp" >
	<center>
		<h2>양식장 검색/추가</h2>
		<hr>
		<input type="text" name="farmName" value="<%=farmName %>"/>&nbsp;&nbsp;
		<input type="button" id="btnSearch" onclick="farmSearch()" />
		<input type="button" id="btnCancel" onclick="selfClose()"/>
		<hr>
	</center>
</form>
<table id="farmSearchTable">
<%
	if(farmName.equals(""))
	{
%>
		<tr id="farmSearchheaderTable">
			<td>검색어를 입력하세요</td>
		</tr>
<%
	}
	else
	{
%>
		<tr id="farmSearchheaderTable">
			<td>"<%=farmName %>"에 대한 검색 결과</td>
		</tr>
<%
		ArrayList<farmDTO> adto = fdao.farmSearch(ID, Auth, farmName);
		if(adto.isEmpty())
		{
%>
			<tr>
				<td>조회 내용이 없습니다.</td>
			</tr>
<%
		}
		else
		{
			for(int i=0; i<adto.size(); i++)
			{
				farmDTO dto = adto.get(i);
				%>
				<tr id="farmSearchSectionTable" onclick="pick('<%=dto.getFarmId() %>','<%=dto.getFarmName() %>','<%=dto.getAddress() %>')">
					<td><%=dto.getFarmName() %> / <%=dto.getAddress() %></td>
				</tr>
				<%
			}
		}
	}
%>
</table>