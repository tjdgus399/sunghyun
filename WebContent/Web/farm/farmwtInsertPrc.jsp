<%--
	■ SYSTEM                : SAF 양식장
    ■ SOURCE FILE NAME      : farmwtInsertPrc.jsp
    ■ DESCRIPTION           : 양식장 정보 등록(farmwtInsertForm.jsp에서 넘어옴)
    ■ COMPANY               : 목포대학교 융합소프트웨어학과 
    ■ PROGRAMMER            : 김수아
    ■ DESIGNER              : 
    ■ PROGRAM DATE          : 2019.08.
    ■ EDIT HISTORY          : 2019.08.18
    ■ EDIT CONTENT          : 2019.08.18
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>>   
<%@ page import="com.waterTank.waterTankDTO"%>
<%@ page import="com.farm.farmDTO"%>
<%@ page import="com.growInfo.growInfoDTO"%>
<%@ include file="../include/include/session.inc"%>

<jsp:useBean id="wt" class="com.waterTank.waterTankDTO" />
<jsp:useBean id="wtdao" class="com.waterTank.waterTankDAO" />
<jsp:useBean id="fish" class="com.growInfo.growInfoDTO" />
<%
   request.setCharacterEncoding("UTF-8");
   

   //객체화
   waterTankDTO bean = new waterTankDTO();
   
   //fishname 받아오기
   String fishName= request.getParameter("selectFish");
   
   //farm 객체에 값 저장
   int FarmID = Integer.parseInt(request.getParameter("FarmID"));
   bean.setTankId(request.getParameter("tankid"));
   String userid=request.getParameter("userid");
   bean.setDoSensor(request.getParameter("dosensor"));
   bean.setPhSensor(request.getParameter("phsensor"));
   bean.setPsuSensor(request.getParameter("psusensor"));
   bean.setWtSensor(request.getParameter("wtsensor"));
   bean.setNh4Sensor(request.getParameter("nh4sensor"));
   bean.setNo2Sensor(request.getParameter("no2sensor"));
   bean.setRegId(request.getParameter("ID"));
   
   String msg = "등록 완료";
   
   wtdao.waterTankInsert(bean, fishName, ID, FarmID, userid);
   //넘어갈 화면
   /* String ccc = "farmwtSearch.jsp"; */
   response.sendRedirect("farmwtSearch.jsp?FarmID="+ FarmID );
%>
<script type="text/javascript">
   alert("<%=msg%>");
</script>