<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%--
@ Author : Gojian
@ Last Update : 2019.08.19
@ Breif :  권한에 따른 메뉴 버튼이 다르게 나오도록 수정
--%>

<style>
   .nowTime
   {
      display : inline-block;
   }
   .headerTop
   {
      display : inline-block;
      width : 33%;
   }
</style>
<script>
   function goHeaderButton(str)
   {
       location.href=str;
   }
   
   /* 양식장 관리등록으로 가는 페이지 */
   function farmListPopUP(param1) {

   var url = param1;
   var name = "farmListForm popupt test";
   var option = "width=700 height=500 location=no";
   window.open(url, name, option);

}
   
</script>
<script type="text/javascript" src="../common/main.js"></script>
<script src="../common/async/serverDateTime.js"></script>

<div id="top_header">
	<div id="left" class="headerTop">
		<!-- 현재시각부분 -->
		<h3 class="nowTime"><br><br><br>현재시각 :&nbsp;</h3><h3 class="nowTime" id="clock">&nbsp;&nbsp;0000년 00월 00일 00:00:00</h3>
	</div>
   
	<div id="center" class="headerTop">
		<a href="../main/main.jsp" style="text-decoration:none; color:black;"><h4>스마트 양식장<h4></a>
	</div>
   
	<div id="right" class="headerTop">
		<br>
		<a href="../User/userInfo.jsp"> <%=(String)session.getAttribute("Name") %>(<%= (String)session.getAttribute("ID") %> / <%= (String)session.getAttribute("Auth") %>)</a>
		<br>
		<button type="button" class="button white logoutButton" onclick="location.href='../main/logout.jsp'">
			<span class="icon-minus"></span>로그아웃
		</button>
   </div>
</div>

<div id="bottom_header">
 	<button onclick="goHeaderButton('../main/main.jsp')" class="button white">모니터링</button>
 	<button onclick="goHeaderButton('../growInfo/growInfoList.jsp')" class="button white">상태기준정보</button>
 	<button onclick="goButtonwtRec(FarmID)" class="button white">상태기록</button>
 	<button onclick="goButtonwtUpdateForm(FarmID)" class="button white">조치기록</button>
 	<button onclick="alert('준비중');" class="button white">통계</button>
<!--
  <button onclick="goHeaderButton('../User/userManagement.jsp')" class="button white">유저정보관리</button>
  -->
   <button onclick="farmListPopUP('../User/farmListForm.jsp')" class="button white">양식장정보관리</button>
  
  	<% if (Auth.contains("관리자")) { %>
  	<button id="wtTankSelect" type="button" onclick="goButtonFarmwtSearch(FarmID)" class="button white">수조정보</button>
	<% } else { %>
		<button id="wtTankSelect" type="button" onclick="goButtonFarmwtSearch(User_FarmID)" class="button white">수조정보</button>
		<% } %>
  
</div>

<!-- 시간 출력 부분 -->
<script> printClock(); </script>