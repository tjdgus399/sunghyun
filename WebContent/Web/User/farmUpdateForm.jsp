<%
   /*==============================================================================
    ■ SYSTEM            : 
    ■ SOURCE FILE NAME      : farmUpdateForm.jsp
    ■ DESCRIPTION         : 양식장 수정 Form
    ■ COMPANY            : 목포대학교 융합소프트웨어공학과 
    ■ PROGRAMMER         : 박진후
    ■ DESIGNER            : 
    ■ PROGRAM DATE         : 2019.08.26
    ■ EDIT HISTORY         : 
    ■ EDIT CONTENT         : 
   ==============================================================================*/ 
%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.sql.*"%>
<!-- beans를 사용하기 위한 import -->
<%@page import="com.usertable.*"%>
<%@ include file="../include/include/session.inc"%>
<%
   request.setCharacterEncoding("UTF-8");
   
   int FarmID = Integer.parseInt(request.getParameter("FarmID"));   //양식장 번호
   String farmName =  request.getParameter("farmName");         //현재 양식장 이름
   String address = request.getParameter("address");            //현재 양식장 주소
   String tankcnt = request.getParameter("tankcnt");            //현재 수조 개수
   String username =  request.getParameter("username");         //현재 관리자 이름
   String userid =  request.getParameter("userid");            //현재 관리자 아이디
   
   usertableDAO dao = new usertableDAO();
   ArrayList list = dao.ShowUser(Auth);
   
%>

<!DOCTYPE html>
<html>
   <head>
      <meta charset="UTF-8">
      <title>팝업창</title>
      <link rel="stylesheet" href="../common/style.css">
      <link rel="stylesheet" href="../common/jqm-button/icon.css">

      <!-- <script src="../common/main.js"></script> -->
      
      <script type="text/javascript">
      
         //취소할 경우 farmListForm으로 넘어가게 하는 함수
         function go_List() {
            alert("취소하였습니다.");
            location.href = 'farmListForm.jsp';
         }
      
         //수정할 경우 Prc로 값을 전달해주는 함수
         function farmUpdatePrc() {
            var form = document.farm;
            
            if(confirm("수정하시겠습니까?")!=0)
            {
               form.method = "post";
               form.action = "farmUpdatePrc.jsp";
               form.target = "_self";
               form.submit();
            }
            else
            {
               return;
            }            

         }
         
         //삭제할 경우 Prc로 값을 전달해주는 함수
         function farmDelete() {
            var form = document.farm;
            
            if(confirm("삭제하시겠습니까?")!=0)
            {               
               form.method = "post";
               form.action = "farmDeletePrc.jsp";
               form.target = "_self";
               form.submit();
            }
            else
            {
               return;
            }

         }
         
      </script>
   </head>
   
   <body>
      <br>
      <br>

      <div>
      <!-- 양식장 등록 폼 -->
      <form name="farm">
      
         <section>
         <hr>         
            <h3>양식장 수정</h3>
         <hr>  
                  
         <br>
         <div>
            <input type="button" value="취소" onclick="go_List(); return false;" />
            <input type="button" value="수정" onclick="farmUpdatePrc(); return false;" />
            <input type="button" value="삭제" onclick="farmDelete(); return false;" />
         </div>
         <br>
            <table class="tablefarmuser_upt">
               <tr>
                  <th colspan="6" height="50">양식장</th>
               </tr>
               <tr>
                  <th colspan="2" height="50">양식장 이름</th>
                     <td colspan="4">
                        <input type="text" name="farmName" style="text-align:center;" value="<%=farmName %>"/>
                     </td>
               </tr>
               <tr>
                  <th colspan="2" height="50">양식장 주소</th>
                     <td colspan="4">
                        <input type="text" name="Address" style="text-align:center;" value="<%=address %>"/>
                     </td>
               </tr>
               <tr>
                  <th colspan="2" height="50">수조 개수</th>
                     <td colspan="4">
                        <input type="text" name="tankCnt" style="text-align:center;" value="<%=tankcnt %>"/>            
                     </td>
               </tr>
               <tr>
                  <th colspan="2" height="50">관리자</th>
                     <td colspan="4">
                        <select name="search">
                           <option selected value='<%=userid %>'><%=username %>(현재 관리자)</option>
<%         
                        for(int i=0; i<list.size(); i++)
                        {
                           usertableDTO dto = (usertableDTO) list.get(i);
                           
                           if(!username.equals(dto.getUserName()))
                           {
%>
                           <option value='<%=dto.getUserId()%>'><%=dto.getUserName()%>(<%=dto.getUserId()%>)</option>
<%
                           }
                        }
%>
                        </select>
                        <%-- <input type="text" name="last_username" style="text-align:center;" value="<%=username %>"/> --%>
                        <input type="hidden" name="FarmID" value="<%= FarmID %>" />
                        <%-- <input type="hidden" name="username" value="<%= username %>" /> --%>
                        <input type="hidden" name="userid" value="<%= userid %>" />
                     </td>
               </tr>
            </table>
         <br>
         
         </section>
         
      </form>
      </div>

      <!-- 푸터 -->
      <footer>
         <%@ include file="../include/footer.inc"%>
      </footer>
      
   </body>
   
</html>