<%--
	■ SYSTEM                :  SAF 
	■ SOURCE FILE NAME      :  userInfo.jsp
	■ DESCRIPTION           :  사용자 정보 확인 form
	■ COMPANY               :  목포대학교 융합소프트웨어학과 
	■ PROGRAMMER            :  김성현
	■ DESIGNER              : 
	■ PROGRAM DATE          :  2019.08.19
	■ EDIT HISTORY          :  2019.08.22
	■ EDIT CONTENT          : 
--%>
<%@ page import="java.util.stream.Stream"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.usertable.*" %>
<%@ page import="com.farm.*" %>
<%@ include file="../include/include/session.inc"%>

<jsp:useBean id="dao" class="com.usertable.usertableDAO"/>

<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>스마트 모니터링 시스템</title>
<link rel="stylesheet" href="../common/jqm-button/icon.css" /> 
<link rel="stylesheet" href="../common/style.css">

<%-- 전화번호, 양식장 id 가져오기 --%>
<%
   usertableDTO dto = dao.getuser(ID);

   String tel = dto.getUserTel();      // 전화번호
   String FarmID = dto.getFarmId();   // 양식장 id
   
   request.getParameter(FarmID);
   
	// 사용자 소속양식장 추가 배열
	//ArrayList userlist = dao.
%>

<script src = "../common/main.js"></script>
</head>
<body>
   <header>
      <%@ include file="../include/header.inc" %>
   </header>
   
   <!-- 2. 본문 -->
   <section>
   <h2>내 정보
   <% if(!Auth.equals("사용자")){ %>
   <input type="button" name="godel" class="menu"  onclick="location.href='./userManagement.jsp'">
   <% } %>  
            </h2>
   
   <br>
      <!-- 3. 테이블 시작 -->
      <form name="userInfo">
         <table class="userInfo">
         
         <tr>
            <th colspan="2"><%= Name %>님 반갑습니다.
            <input type="button" class="cor" onclick="location.href='./userMyPageForm.jsp'">
            <input type="button" class="save" onclick="location.href='../main/main.jsp'">
            <input type="button" class="cancel" onclick="location.href='../main/main.jsp'">
                      
            </th> 
         </tr>

         <tr align="center">
            <th>직책</th>
            <td><%= Auth  %></td>
         </tr>
         
         <tr align="center">
         
            <th >소속 양식장</th>
            <td>
            <select name="getid" id="getid">
            
          
				
				<option value="">아이디</option>
				
				<option value="Y">사람을 골라요</option>
			</select>
			
            <% if(!Auth.equals("사용자")){ %>
            <input type="button" class="search" onclick="location.href='./farmSearchForm.jsp'">
            <% } %>
            </td>
      
         </tr>
         <% 
         usertableDAO fda = new usertableDAO();
         ArrayList<farmDTO> listfarm = fda.getFarmlist();
         
         if(Auth.equals("전체관리자")){
            
            for(int i=0; i<listfarm.size(); i++){
            System.out.println(listfarm.get(i).getFarmId());
            System.out.println(listfarm.get(i).getFarmName());
            %>
            
            <tr align="center">
               <td>
               <%= listfarm.get(i).getFarmName() %>(<%= listfarm.get(i).getAddress() %>)
               <td>
               <input type="button" class="del" onclick="delfarm('<%=listfarm.get(i).getFarmId()%>','<%=listfarm.get(i).getFarmName()%>')"></td>
            </tr> 
            
            <%
            }
            
         }
         
         if(!Auth.equals("전체관리자")){
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
            <input type="button" class="del" onclick="delfarm('<%=fo.getFarmId()%>','<%=fo.getFarmName()%>')"></td>
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
   <!-- 본문 끝 -->
   

</body>
</html>