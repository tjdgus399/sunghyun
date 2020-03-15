<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%--
@ Author : Gojian
@ Last Update : 2019.08.19
@ Breif : header.inc / 실시간 시계, Link, Button, Logout, 회원 정보 기능 구현 
--%>
<div id="top_header">
	<div id="headerTopLeft" class="headerTop">
		<!-- 실시간 시계 -->
		<h2 class="nowTime">현재 시간</h2><h2 class="nowTime" id="clock"></h2>
	</div>
	<div id="headerTopCenter" class="headerTop">SAF(Smart Aqua Farm)</div>
	<div id="headerTopRight" class="headerTop">
		<%=(String)session.getAttribute("Name") %>(<%= (String)session.getAttribute("ID") %> / <%= (String)session.getAttribute("Auth") %>)
		<br>
		<input type="button" class="headerButton white" onclick="goHeaderButton('../User/userInfo.jsp')" value="관리"/>
		<input type="button" class="headerButton white" onclick="goHeaderButton('../main/logout.jsp')" value="로그아웃"/>
	</div>
</div>
<div id="bottom_header">
  <input type="button" class="headerButton white bottom" onclick="goHeaderButton('../main/main.jsp')" value="모니터링"/>
  <input type="button" class="headerButton white bottom" onclick="goPage('grow')" value="상태기준정보"/>
  <input type="button" class="headerButton white bottom" onclick="goHeaderButton('../waterTank/stateRec.jsp?farmID='+farmID)" value="상태기록"/>
  <input type="button" class="headerButton white bottom" onclick="goHeaderButton('../waterTank/repairRec.jsp')" value="조치기록"/>
  <input type="button" class="headerButton white bottom" onclick="alert('준비중');" value="통계"/>
  <input type="button" class="headerButton white bottom" onclick="goHeaderButton('../User/userManagement.jsp')" value="유저정보관리"/>
  <input type="button" class="headerButton white bottom" onclick="goHeaderButton('../User/farmListForm.jsp')" value="양식장정보관리"/>
  <input type="button" class="headerButton white bottom" onclick="goPage('WT')" value="수조정보"/>
</div>