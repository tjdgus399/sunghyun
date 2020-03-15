<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.usertable.*" %>
<%@ page import="com.farm.*" %>
<%@ page import="java.util.stream.Stream"%>
<%@ include file="../include/SessionState.inc"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>스마트 양식장</title>

<%
	usertableDAO dao = new usertableDAO();
	usertableDTO dto = dao.getuser(Session_ID);

	String tel = dto.getUserTel();      // 전화번호
	String FarmID = dto.getFarmId();   // 양식장 id
   
%>

<!--  Jquery Mobile CSS Include  -->
<link rel="stylesheet" href="../common/style.css" />
<link rel="stylesheet" href="../common/jquery/jquery.mobile-1.0.1.css" />
<style type="text/css">
.ui-grid-b {
	align : center;
	position : relative;
	top : 10px;
}

.ui-block-e {
	font-size :12px;
	font-weight: 500;
	width: 32.5%;
	height: 33%;
	text-align: left;

}
button#flow{
	width :100%;
	height :20%;
	background-color : rgb(25,132,12);
	color : white;	
}



#monitorContent{
	font-size :12px;
	font-weight: bold;
  	background: linear-gradient(transparent 0, white 45%);

}


#Main_Section_Contents_Admin
{
	display:flex;
	flex:1;

}



</style>
<!-- JavaScript ASYNC INCLUDE -->
<script src="../common/async/Monitoring.js"></script>

<!--  Jquery Mobile JS Include  -->
<script src="../common/jquery/demos/jquery.js"></script>
<script src="../common/jquery/jquery.mobile-1.0.1.js"></script>


<script type="text/javascript" src="../common/main.js"></script>

</head>
<body onload="_GetAjaxConnection()">
	<%
		System.out.println("=========" + Session_ID);
	%>

	<header data-role="header" data-position="fixed">
		<%@ include file="../include/headerTitle.inc" %>
	</header>
	
	<section data-role="section">
			<%@include file="../include/headerMenu.inc" %>
		
		<h2 align="center">내 정보</h2>
		<br>
		<h3 align="center"><%= Session_Name %>님 반갑습니다.</h3>
   <br>
   
   <table>
		<tr>
			<th>
	            <div style="float:left;"><input type="button" value="수정" onclick="location.href='./userMyPageForm.jsp'"></div>
	            <div style="float:left;"><input type="button" value="저장" onclick="location.href='../main/main.jsp'"></div>
	            <div style="float:left;"><input type="button" value="취소" onclick="location.href='../main/main.jsp'"></div>
            	<% if(!Session_Auth.equals("사용자")){ %>
            	<div style="float:left;"><input type="button" value="사용자 추가" onclick="location.href='./userInsertForm.jsp'"></div>
           		<% } %>
            </th>
         </tr>
   </table>
   
      <!-- 3. 테이블 시작 -->
      <form name="userInfo">
         <table>
         <tr align="center">
            <th>직책</th>
            <td><%= Session_Auth  %></td>
         </tr>
         
         <tr align="center">
         
            <th >소속 양식장</th>
            <td>
			
            </td>
         </tr>
         <% 
         usertableDAO fda = new usertableDAO();
         ArrayList<farmDTO> listfarm = fda.getFarmlist();
         
         if(Session_Auth.equals("전체관리자")){
            
            for(int i=0; i<listfarm.size(); i++){
            %>
            
            <tr align="center">
               <td>
               <%= listfarm.get(i).getFarmName() %>(<%= listfarm.get(i).getAddress() %>)
               <td>
               <input type="button" value="삭제" onclick="delfarm('<%=listfarm.get(i).getFarmId()%>','<%=listfarm.get(i).getFarmName()%>')"></td>
            </tr> 
            
            <%
            }
            
         }
         
         if(!Session_Auth.equals("전체관리자")){
            //검색결과가 없을 때
            if(FarmID.isEmpty()){
         %>
         
         <tr>
            <td colspan="2"><br> <br> <br> 비어있습니다. <br><br> <br></td>
         </tr>
         
         <%
         
            }else{   // 검색결과가 있을때
               
            //userDAO에서 받아온 userlist 출력
            //리스트 목록 가져오기
            farmDAO list1 = new farmDAO();
            
            String ar[] = FarmID.split(",");
            int arr[] = Stream.of(FarmID.split(",")).mapToInt(Integer::parseInt).toArray();
            
            //리스트 불러오기
            ArrayList<farmDTO> list = list1.getFarm(arr);
            
            usertableDTO uo = new usertableDTO();
            
            for (int i = 0; i < list.size(); i++) { 
               farmDTO fo = list.get(i);   
               fo.setFarmId(fo.getFarmId());
         %>
         
         <tr align="center">
            <td>
            <%= fo.getFarmName() %>(<%= fo.getAddress() %>)
            <td>
            <input type="button" value="삭제" onclick="delfarm('<%=fo.getFarmId()%>','<%=fo.getFarmName()%>')"></td>
         </tr>
         
         <%
            }//end for
         	}//end if
         }//end if
         %>
         
         <tr>
            <th>연락처</th>
            <td><%= tel %></td>
         </tr>
      </table>
   </form>
      <!-- 테이블 끝 -->
	</section>
	
	<footer data-role="footer" data-position="fixed">
		<%@ include file="../include/footer.inc"%>
	</footer>
	

</body>

</html>