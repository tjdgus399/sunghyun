<%
   /*==============================================================================
	 ■ SYSTEM				: SAF(Smart Aqua Farm) - 스마트 모니터링 시스템
	 ■ SOURCE FILE NAME		: growInfo/farmInfoPrc.jsp
	 ■ DESCRIPTION			: 상태기준정보 프로세스(등록, 삭제, 수정)
	 ■ COMPANY				: 
	 ■ PROGRAMMER			: 윤건주
	 ■ DESIGNER				: 
	 ■ PROGRAM DATE			: 2019.08.16
	 ■ EDIT HISTORY			: 
	 ■ EDIT CONTENT			: 
	==============================================================================*/
%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/include/session.inc"%>
<%@ page import="com.growInfo.growInfoDTO" %>
<jsp:useBean id="dao" class="com.growInfo.growInfoDAO"/>
<jsp:useBean id="strUtil" class="com.main.StringUtil"/>
<%
	// 한글패치
	request.setCharacterEncoding("EUC-KR");
	
	// 세션정보 및 전역변수
	// 전역변수
	int FarmID = Integer.parseInt(request.getParameter("FarmID"));
	
	// 경로 및 문구/기능 식별
	String flag = request.getParameter("flag");					// i=입력/u=수정/d=삭제
	String msg = "이상이 발생했습니다. 관리자에게 문의하세요.";
		
	if(flag.equals("d"))
	{
		//삭제
		int groupcode = Integer.parseInt(request.getParameter("groupcode"));
		
		// 1이 반환되면 메시지 변경
		if(dao.deleteGrowInfo(FarmID, groupcode) == 1)
		{
			msg = "삭제가 완료되었습니다.";
		}
	}
	else
	{
		// 리스트에 정보 저장
		ArrayList<growInfoDTO> adto = new ArrayList<growInfoDTO>();
		
		// 상태저장 변수
		String state[] = {"RM", "YM", "G", "Y", "R"};
		
		// list에 정보 입력
		for(int i=0; i<5; i++)
		{
			growInfoDTO dto = new growInfoDTO();									// DTO 객체화
			dto.setFarmId(FarmID);													// 양식장ID dto 저장
			dto.setFishName(request.getParameter("fishName"));												// 양식정보이름 dto 저장
			dto.setState(state[i]);													// 상태값 저장 dto 저장
			//"DO", "WT", "pus", "pH", "NH4", "NO2"	
			dto.setDOMin(Double.parseDouble(strUtil.nullToZero(request.getParameter("DO"+i))));			// 해당상태 DO최대값 dto 저장
			dto.setDOMax(Double.parseDouble(strUtil.nullToZero(request.getParameter("DO"+(i+1)))));		// 해당상태 DO최소값 dto 저장
			dto.setWTMin(Double.parseDouble(strUtil.nullToZero(request.getParameter("WT"+i))));			// 해당상태 WT최대값 dto 저장
			dto.setWTMax(Double.parseDouble(strUtil.nullToZero(request.getParameter("WT"+(i+1)))));		// 해당상태 WT최대값 dto 저장
			dto.setPsuMin(Double.parseDouble(strUtil.nullToZero(request.getParameter("psu"+i))));		// 해당상태 psu최대값 dto 저장
			dto.setPsuMax(Double.parseDouble(strUtil.nullToZero(request.getParameter("psu"+(i+1)))));	// 해당상태 psu최대값 dto 저장
			dto.setpHMin(Double.parseDouble(strUtil.nullToZero(request.getParameter("pH"+i))));			// 해당상태 pH최대값 dto 저장
			dto.setpHMax(Double.parseDouble(strUtil.nullToZero(request.getParameter("pH"+(i+1)))));		// 해당상태 pH최대값 dto 저장
			dto.setNH4Min(Double.parseDouble(strUtil.nullToZero(request.getParameter("NH4"+i))));		// 해당상태 NH4최대값 dto 저장
			dto.setNH4Max(Double.parseDouble(strUtil.nullToZero(request.getParameter("NH4"+(i+1)))));	// 해당상태 NH4최대값 dto 저장
			dto.setNO2Min(Double.parseDouble(strUtil.nullToZero(request.getParameter("NO2"+i))));		// 해당상태 NO2최대값 dto 저장
			dto.setNO2Max(Double.parseDouble(strUtil.nullToZero(request.getParameter("NO2"+(i+1)))));	// 해당상태 NO2최대값 dto 저장
			if(!flag.equals("i"))														// 등록일 때는 그룹코드 저장x
			{
				dto.setGroupCode(Integer.parseInt(request.getParameter("groupcode")));	// 그룹코드를 dto에 저장
			}
			dto.setRegId(ID);														// 세션ID dto저장
			dto.setLastUptId(ID);													// 세션ID dto저장
			adto.add(dto);		
		}
		
		if(flag.equals("i"))
		{	// 입력		
			// 1이 반환되면 메시지 변경
			if(dao.insertGrowInfotData(adto) == 1)
			{
				msg = "등록이 완료되었습니다.";
			}
		}
		
		if(flag.equals("u"))
		{	//수정
			// 1이 반환되면 메시지 변경
			if(dao.updateGrowInfo(FarmID, adto.get(0).getGroupCode(), adto) == 1)
			{
				msg = "수정이 완료되었습니다.";
			}
		}
	}	
	
	System.out.println(strUtil.nullToBlank(request.getParameter("fishNamekeyWord")) + "|||||||");
%>
<form name="farmSelectedForm">
	<input type="hidden" name="farmNamekeyWord" value="<%=strUtil.nullToBlank(request.getParameter("farmNamekeyWord"))%>"/>
	<input type="hidden" name="fishNamekeyWord" value="<%=strUtil.nullToBlank(request.getParameter("fishNamekeyWord"))%>"/>
	<input type="hidden" name="selectedFarmId" value="<%=Integer.parseInt(request.getParameter("selectedFarmId")) %>"/>
</form>
<script>
	//메시지창 출력 및 이동
	var frm = document.farmSelectedForm;
	
	alert("<%=msg%>");
	
	frm.method = "post";
	frm.target = "_self";
	frm.action = "growInfoList.jsp";
	frm.submit();
</script>