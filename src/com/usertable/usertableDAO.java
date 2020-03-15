package com.usertable;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.stream.Stream;

import com.farm.*;
import com.main.*;

import java.util.*;

/**
 * file name : farmDAO.java
 * 사   용 : 
 * 
 * 작성일 : 2019.08.10 
 * 작성자 : 
 * 수정일 : 
 * 수정자 :
 * 수정내용:
 * 
 * task : TODO
 */

public class usertableDAO {
	//DB연결
	DBCon dbcp = new DBCon();	
	
	//--------------------------------------------------------------
	
	/**************************************
	 * @name login()
	 * @author saf.user
	 * @param ID, PW
	 *            -
	 * @return userDTO
	 * @remark 로그인 기능 구현(이름, 권한 가져오기) ,
	 * 		   사용처 - main/loginPrc.jsp
	 **************************************/
			

	public usertableDTO login(String ID, String PW) {
		// DB 연결에 필요한 변수
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;

		// 값을 저장하기 위한 ArrayList선언
		usertableDTO dto = new usertableDTO();

		// 가져올 내용이 필요할 경우 사용하는 rs
		ResultSet rs = null;

		try {
			// DB접속
			con = dbcp.getConnection();

			// DB에 SQL넣기
			sql = "select username, userauth from usertable where userid = ? and userpw = ? ";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, ID); // 매개변수로 받은 ID
			pstmt.setString(2, PW); // 매개변수로 받은 비밀번호
			rs = pstmt.executeQuery();

			// 열확인
			if (rs.next()) {
				dto.setUserName(rs.getString("username")); // 유저 이름
				dto.setUserAuth(rs.getString("userauth")); // 유저 권한
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			dbcp.close(con, pstmt, rs);
		}

		return dto;
	}


	/**************************************
	 * @name getuser()
	 * @author GoJian
	 * @param ID, PW -
	 * @return userDTO
	 * @remark mainPrc.jsp - user/userInfo.jsp
	 **************************************/

	public usertableDTO getuser(String ID) {
	
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;

		usertableDTO dto = new usertableDTO();

		ResultSet rs = null;

		try {
			con = dbcp.getConnection();
			
			sql = "select farmid, usertel from usertable where userid = ? ";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, ID); 
			rs = pstmt.executeQuery();

			if (rs.next()) {

				if (rs.getString("farmid") == null) {
					dto.setFarmId("");
					dto.setUserTel(rs.getString("usertel")); 

				} else {
					dto.setFarmId(rs.getString("farmid")); 
					dto.setUserTel(rs.getString("usertel"));

				}

			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			dbcp.close(con, pstmt, rs);
		}

		return dto;
	}

	/***********************************
	 * @name userManagement
	 * @author user.userDAO
	 * @param -
	 * @return ArrayList
	 * @remark 사용자 목록 출력,
	 ***********************************/
	// 조건에 따라 양식장 조회하기(검색)
	public ArrayList<usertableDTO> userselect() throws NullPointerException, SQLException {

		ArrayList<usertableDTO> userlist = new ArrayList<usertableDTO>();
		Connection conn = dbcp.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = "";

		try {

			sql = "select * from usertable ";

			/* System.out.println("sql =" + sql); */

			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();

			while (rs.next()) {

				usertableDTO vo = new usertableDTO();

				vo.setUserId(rs.getString("userid"));

				vo.setUserPw(rs.getString("userpw"));

				vo.setUserName(rs.getString("username"));

				vo.setUserTel(rs.getString("usertel"));

				vo.setUserAuth(rs.getString("userauth"));

				vo.setFarmId(rs.getString("farmid"));

				vo.setRegDate(rs.getString("regdate"));

				userlist.add(vo);
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			dbcp.close(conn, pstmt, rs);
		}
		return userlist;
	}
    
    /**************************************
    * @name    user_farmAdd()  (양식장검색)
    * @author    박진후
    * @param    farmID(양식장 번호), userID(양식장 정보를 추가할 사용자ID), Auth(사용자 권한)
    * 
    * @return  void
    * @remark    userID에 맞는 조건의 정보에 입력받은 farmID를 추가
    *          사용처 - userInfoPrc.jsp
    **************************************/
   
   public void user_farmAdd(int farmID, String userID, String regid) throws NullPointerException, SQLException {
      //DB연결
      Connection con = null;
      PreparedStatement pstmt = null;
      PreparedStatement pstmt2 = null;
      ResultSet rs = null;
      String sql = null;
      String sql2 = null;
      String set = null;
       
      try {
          con = dbcp.getConnection();          
          
          sql = "select farmid from usertable where userid=?";          
          pstmt = con.prepareStatement(sql);
          pstmt.setString(1, userID); 
          
          rs = pstmt.executeQuery();          
           
          if(rs.next())
          {
             set = rs.getString(1) +","+ farmID;
          }
          
          //추가한 부분을 usertable에 수정
          sql2 = "update usertable set farmid=?, lastuptdate = sysdate, lastuptid = ? where userid=?";
          
          pstmt2 = con.prepareStatement(sql2);
           
          pstmt2.setString(1, set);
          pstmt2.setString(2, regid);
          pstmt2.setString(2, userID);
            
          pstmt2.executeUpdate();

      } catch (Exception e) {
           e.printStackTrace();
      } finally {
         dbcp.close(con, pstmt, rs);
         dbcp.close(con, pstmt2, rs);
      }

   }

   /**************************************
    * @name userInsert()
    * @author 김성현
    * @param usertableDTO bean
    * @return void
    * @remark 사용자 추가 , 사용처 - userInsertPrc.jsp
    **************************************/
   // 사용자 정보 추가 용도
   public void userInsert(usertableDTO bean) throws NullPointerException, SQLException {
      // DB 연결에 필요한 변수
      Connection con = null;
      PreparedStatement pstmt = null;
      String sql = null;

      try {

         con = dbcp.getConnection();

         sql = "insert into usertable values(?,?,?,?,?,?,sysdate,?,sysdate,?)";

         pstmt = con.prepareStatement(sql);
         pstmt.setString(1, bean.getUserId());
         pstmt.setString(2, bean.getUserPw());
         pstmt.setString(3, bean.getUserName());
         pstmt.setString(4, bean.getUserTel());
         pstmt.setString(5, bean.getUserAuth());
         pstmt.setString(6, bean.getFarmId());
         pstmt.setString(7, bean.getUserAuth());
         pstmt.setString(8, bean.getUserAuth());

         // executeUpdate() - select 구문 제외 수행 int 값 반환
         pstmt.executeUpdate();

      } catch (Exception e) {
         e.printStackTrace();
      } finally {
         dbcp.close(con, pstmt, null);
      }
   }

   /**************************************
    * @name updateMember()
    * @author 김성현
    * @param usertableDTO bean
    * @return void
    * @remark 사용자 정보 수정, 사용처 - updatePrc.jsp
    **************************************/

   // 회원정보 수정하기
   public void updateMember(usertableDTO bean) {
      Connection con = null;
      PreparedStatement pstmt = null;
      String sql = null;

      try {
         con = dbcp.getConnection();

         // sql문 작성(수정문)
         sql = "update usertable" + " set userPW = ?, username=?, usertel = ?," + " lastuptid=?"
               + " where userid= ?";

         pstmt = con.prepareStatement(sql);
         pstmt.setString(1, bean.getUserPw()); // userDTO에 저장된 사용자 비밀번호
         pstmt.setString(2, bean.getUserName()); // userDTO에 저장된 사용자 이름
         pstmt.setString(3, bean.getUserTel()); // userDTO에 저장된 사용자 전화번호
         pstmt.setString(4, bean.getLastUptId());// 사용자 정보를 변경한 사용자
         pstmt.setString(5, bean.getUserId()); // userDTO에 저장된 사용자 id
         pstmt.executeUpdate();

      } catch (Exception e) {
         e.printStackTrace();
      } finally {
         dbcp.close(con, pstmt, null);
      }
   }

   /**************************************
    * @name getMb()
    * @author 김성현
    * @param id -
    * @return Bean
    * @remark 사용자 상세정보를 가져와 화면에 보여줌, 사용처 - userInfo.jsp
    **************************************/

   // 회원 상세조회
   public usertableDTO getMb(String id) {
      Connection con = null;
      PreparedStatement pstmt = null;
      ResultSet rs = null;
      String sql = null;

      // 반환 받을 Bean선언
      usertableDTO bean = new usertableDTO();

      try {
         con = dbcp.getConnection();

         // bean에 저장할 date조회
         sql = "select * from usertable where userid = ?";
         pstmt = con.prepareStatement(sql);
         pstmt.setString(1, id); // 매개변수로 들어온 id
         rs = pstmt.executeQuery();

         // 해당ID 유저의 정보 가지고 오기
         if (rs.next()) {
            bean.setUserId(rs.getString("userid")); // DB에 저장되어 있는 userID정보를 Bean저장
            bean.setUserPw(rs.getString("userpw")); // DB에 저장되어 있는 userPW정보를 Bean저장
            bean.setUserName(rs.getString("username")); // DB에 저장되어 있는 userName정보를 Bean저장
            bean.setUserTel(rs.getString("usertel")); // DB에 저장되어 있는 userTel정보를 Bean저장
            bean.setUserAuth(rs.getString("userauth")); // DB에 저장되어 있는 userAuth정보를 Bean저장
            bean.setFarmId(rs.getString("farmid")); // DB에 저장되어 있는 farmId정보를 Bean저장
            bean.setRegDate(rs.getString("regdate")); // DB에 저장되어 있는 regDate정보를 Bean저장
            bean.setRegId(rs.getString("regid")); // DB에 저장되어 있는 regId정보를 Bean저장
         }
      } catch (Exception e) {
         e.printStackTrace();
      } finally {
         dbcp.close(con, pstmt, rs);
      }

      return bean;
   }

   /**************************************
    * @name userIDCheck()
    * @author 김성현
    * @param String ID
    * @return boolean flag
    * @remark 아이디 중복확인 , 사용처 - userIDCheck.jsp
    **************************************/

   public boolean userIDCheck(String ID) {
      Connection con = null;
      PreparedStatement pstmt = null;
      ResultSet rs = null;
      String sql = null;

      boolean flag = true;

      try {
         con = dbcp.getConnection();

         sql = "select * from usertable where userID = ?";

         pstmt = con.prepareStatement(sql);
         pstmt.setString(1, ID);

         // executeQuery() - select 문 수행 resultset 객체 값 반환
         rs = pstmt.executeQuery();

         if (rs.next()) {
            flag = false;
         }

      } catch (SQLException e) {
         e.printStackTrace();
      } finally {
         dbcp.close(con, pstmt, rs);
      }

      return flag;
   }


   /**************************************
    * @name getFarm()
    * @author 김성현
    * @param 
    * @return vlist
    * @remark 사용자 정보 창에서 양식장리스트를 보여줌, 사용처 - userInfo.jsp
    **************************************/
   public ArrayList<usertableDTO> getFarm() {
      DBCon cdd = new DBCon();
      Connection con = null;
      PreparedStatement pstmt = null;
      ResultSet rs = null;
      String sql = null;

      // 반환 받을 ArrayList
      ArrayList<usertableDTO> vlist = new ArrayList<usertableDTO>();

      try {
         // DB접속
         con = cdd.getConnection();

         sql = "select * from usertable";
         pstmt = con.prepareStatement(sql);
         rs = pstmt.executeQuery();

         // 열에 id/이름 저장후 list에 더해준 후 다음열로 이동
         while (rs.next()) {
            usertableDTO bean = new usertableDTO();
            bean.setFarmId(rs.getString("farmid")); // DB에 저장되어 있는 farmid정보를 Bean저장

            vlist.add(bean); // return ArrayList에 추가
         }
      } catch (Exception e) {
         e.printStackTrace();
      } finally {
         cdd.close(con, pstmt, rs);
      }

      return vlist;
   }

   /**************************************
    * @name delFarm()
    * @author 김성현
    * @param String fid(farmid), String id(userid)
    * @return
    * @remark 사용자 정보에서 양식장정보를 삭제, 사용처 - userFarmDeletePrc.jsp
    **************************************/
   public void delFarm(String fid, String id) {
      DBCon cdd = new DBCon();
      Connection con = null;
      PreparedStatement pstmt = null;
      PreparedStatement pstm = null;
      String sql = null; // select 문
      String sqll = null; // update 문
      String farmlist = null;
      String farmNewList = "";
      ResultSet rs = null;

      try {
         con = cdd.getConnection();
         sql = "select farmid from usertable where userid=? ";

         pstm = con.prepareStatement(sql);
         pstm.setString(1, id);
         rs = pstm.executeQuery();

         while (rs.next()) {
            farmlist = rs.getString("farmid");
         }

         usertableDTO dto = new usertableDTO();

         // farmid 숫자별로 배열 삽입
         String ar[] = farmlist.split(",");

         if (ar.length == 1) {
            dto.setFarmId(farmlist);
            sqll = "update usertable set farmid=? where userid = ?";
            pstmt = con.prepareStatement(sqll);
            pstmt.setString(1, null);
            pstmt.setString(2, id);
            pstmt.executeUpdate();
         }

         // farmid 맞는 것 맞춘 후 farmNewList 배열에 삽입
         for (int i = 0; i < ar.length; i++) {
            if (!ar[i].contains(fid)) {
               farmNewList += ar[i].concat(",");
            }
         }

         // 문자열 뒤에 , 지워주는 역활
         String str = farmNewList.substring(0, farmNewList.length() - 1);

         dto.setFarmId(str);
         sqll = "update usertable set farmid=? where userid = ?";
         pstmt = con.prepareStatement(sqll);
         pstmt.setString(1, dto.getFarmId());
         pstmt.setString(2, id);
         pstmt.executeUpdate();

      } catch (Exception e) {
         e.printStackTrace();
      } finally {
         cdd.close(con, pstmt, null);
      }
   }

   /**************************************
    * @name sysdelFarm()
    * @author 김성현
    * @param String fid(farmid)
    * @return
    * @remark 전체 관리자가 양식장 삭제, 사용처 - userFarmDeletePrc.jsp
    **************************************/
   public void sysdelFarm(String fid) {
      Connection con = null;
      PreparedStatement pstmt = null;
      String sql = null;
      ResultSet rs = null;
      
      // 받은 양식장 String id를 int형으로 형변환
      int farmid = Integer.parseInt(fid);
      
      try {
         con = DBCon.getConnection();
         sql = "delete from farm where farmid=?";
         pstmt = con.prepareStatement(sql);
         pstmt.setInt(1, farmid);
         pstmt.executeUpdate();

      } catch (Exception e) {
         e.printStackTrace();
      } finally {
         DBCon.close(con, pstmt, rs);
      }
   }

   
   /**************************************
    * @name getFarmlist()
    * @author 김성현
    * @param id -
    * @return Bean
    * @remark 양식장 이름, 주소, id 출력 - userInfo.jsp
    **************************************/

   public ArrayList<farmDTO> getFarmlist() {
      DBCon cdd = new DBCon();
      Connection con = null;
      PreparedStatement pstmt = null;
      ResultSet rs = null;
      String sql = null;
      String farmlst = null;

      ArrayList<farmDTO> list = new ArrayList<farmDTO>();

      try {
      
         con = DBCon.getConnection();

         sql = "select farmid, farmname, address from farm";
         pstmt = con.prepareStatement(sql);
         rs = pstmt.executeQuery();

         while (rs.next()) {
            farmDTO bean = new farmDTO();
            bean.setFarmId(rs.getInt("farmid"));
      
            bean.setFarmName(rs.getString("FARMNAME"));
      
            bean.setAddress(rs.getString("address"));
            list.add(bean); 

         }
      } catch (Exception e) {
         e.printStackTrace();
      } finally {
         DBCon.close(con, pstmt, rs);
      }

      return list;
   }
   
   /***********************************
	 *
	 * @name sysuserselect
	 * @author 김수아
	 * @param userauth(String)
	 * @return userlist
	 * @remark 전체 관리자일 경우 사용자 목록 출력
	 * 			사용처-userManagement.jsp
	 ***********************************/
	// 조건에 따라 양식장 조회하기(검색)
	public ArrayList<usertableDTO> sysuserselect(String userauth) throws NullPointerException, SQLException {

		ArrayList<usertableDTO> userlist = new ArrayList<usertableDTO>();
		Connection con = dbcp.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = "";

		try {

			// farmid을 farmName로 바꾸는 작업
//	  String sql1 = " select f.farmname from farm f, usertable u where u.farmid=? and u.farmid=f.farmid and f.farmid=? ";
//      pstmt= con.prepareStatement(sql1);
//      
//      pstmt.setInt(1, farmId);
//      rs = pstmt.executeQuery();
//      
//      String farmName="";
//      
//      if(rs.next()) {
//         
//         farmName = rs.getString("farmname");
//
//      }
			String sql1 = "select USERID" + "     , USERPW" + "     , USERNAME" + "     ,nvl(usertel, 'X') as usertel" + "     , USERAUTH"
					+ "     , decode(userauth, 'sysadmin', '전체관리자', 'admin', '일반관리자', 'user', '사용자', '') as authname"
					+ "     , nvl(farmid, 'X') as farmid" + "     , to_char(REGDATE, 'yyyy/mm/dd hh24:mi:ss') as REGDATE " + "     , REGID"
					+ "     , LASTUPTDATE" + "     , LASTUPTID"
					+ "  from usertable where Not userauth In ('sysadmin') ";

			pstmt = con.prepareStatement(sql1);
			rs = pstmt.executeQuery();

			while (rs.next()) {

				usertableDTO vo = new usertableDTO();

				vo.setUserId(rs.getString("userid"));

				vo.setUserPw(rs.getString("userpw"));

				vo.setUserName(rs.getString("username"));

				vo.setUserTel(rs.getString("usertel"));

				vo.setUserAuth(rs.getString("authname"));

				vo.setFarmId(rs.getString("farmid"));

				/*
				* if (rs.getString("farmid") == null) { vo.setFarmId("X"); } else {
				* vo.setFarmId(rs.getString("farmid")); }
				*/
				vo.setRegDate(rs.getString("regdate"));
				userlist.add(vo);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			dbcp.close(con, pstmt, rs);
		}
		return userlist;
	}

	/***********************************
	 *
	 * @name adminuserselect
	 * @author 김수아
	 * @param userauth(String)
	 * @return userlist
	 * @remark 일반 관리자일 경우 사용자 목록 출력
	 * 			사용처-userManagement.jsp
	 ***********************************/
	// 조건에 따라 양식장 조회하기(검색)
	public ArrayList<usertableDTO> adminuserselect(String userauth) throws NullPointerException, SQLException {

		ArrayList<usertableDTO> userlist = new ArrayList<usertableDTO>();
		Connection con = dbcp.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = "";

		try {
			/*사용자가 가지고 있는 farmid만 출력되게하는 부분*/
			/*String sql1 = "로그인한 user의 farmid를 받아와서 ";*/
			
			
			String sql2 = " select USERID" + "     , USERPW" + "     , USERNAME" + "     ,nvl(usertel, 'X') as usertel" + "     , USERAUTH"
					+ "     , decode(userauth, 'sysadmin', '전체관리자', 'admin', '일반관리자', 'user', '사용자', '') as authname"
					+ "     , nvl(farmid, 'X') as farmid" + "     , to_char(REGDATE, 'yyyy/mm/dd hh24:mi:ss') as REGDATE " + "     , REGID"
					+ "     , LASTUPTDATE" + "     , LASTUPTID"
					+ "  from usertable where Not userauth In ('admin', 'sysadmin')";

			pstmt = con.prepareStatement(sql2);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				usertableDTO vo = new usertableDTO();

				vo.setUserId(rs.getString("userid"));

				vo.setUserPw(rs.getString("userpw"));

				vo.setUserName(rs.getString("username"));

				vo.setUserTel(rs.getString("usertel"));
				
				vo.setUserAuth(rs.getString("authname"));
				
				vo.setFarmId(rs.getString("farmid"));
				
				vo.setRegDate(rs.getString("regdate"));
				userlist.add(vo);
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			dbcp.close(con, pstmt, rs);
		}
		return userlist;
	}

  /**************************************
   * @name usertableDelete()
   * @author 장해리
   * @param userID, userAuth
   * @return void
   * @remark 사용자 관련 정보들 삭제, 사용처 - user/userDeletePrc.jsp
   **************************************/
  public void usertableDelete(String userID, String userAuth, String farmID) {

     // DB 연결에 필요한 변수
     Connection con = null;
     PreparedStatement pstmt = null;
     ResultSet rs = null;
     
     // 양식장 아이디 여러개일 경우 나눠서 farmSplit 배열에 저장
     String[] farmSplit = farmID.split(",");

     try {
        // DB접속
        con = dbcp.getConnection();

        //삭제할 사용자의 직책이 user일 경우 (그 사용자만 삭제한다)
        if (userAuth.equals("사용자")) {
        String sql1 = " delete from usertable where userid = ? ";
        pstmt = con.prepareStatement(sql1);
        pstmt.setString(1, userID); // 매개변수로 받은 ID
        pstmt.executeUpdate();
        }
        
        //삭제할 사용자의 직책이 admin일 경우 (admin이 소유한 양식장에 관한 모든 정보를 삭제한다)
        if (userAuth.equals("일반관리자")) {

          // 선택된 사용자의 양식장 삭제
         String sql2 = " delete from farm where userid = ? ";
         pstmt = con.prepareStatement(sql2);
         pstmt.setString(1, userID); // 매개변수로 받은 ID
         pstmt.executeUpdate();
           
         // 선택된 사용자 삭제 
        String sql3 = " delete from usertable where userid = ? ";
        pstmt = con.prepareStatement(sql3);
        pstmt.setString(1, userID); // 매개변수로 받은 ID
        pstmt.executeUpdate();
        
        
        // userid가 아닌 farmid를 조건절에 사용해야 하는 sql들
        for(int i=0; i<farmSplit.length; i++){
              /*
               * // 사용자의 양식장 String sql4 = " select FARMID from farm where farmid = ? "; pstmt
               * = con.prepareStatement(sql4); pstmt.setString(1, farmSplit[i]);
               * pstmt.executeQuery();
               */
           
           
           String sql4 = " delete from fish where farmid = ? ";
           pstmt = con.prepareStatement(sql4);
           pstmt.setString(1, farmSplit[i]);
           pstmt.executeQuery();

           // rec 테이블에서 farmid가 일치할 경우
           String sql5 = " delete from rec where farmid = ? ";
           pstmt = con.prepareStatement(sql5);
           pstmt.setString(1, farmSplit[i]);
           pstmt.executeQuery();
           
           // repair 테이블에서 farmid가 일치할 경우
           String sql6 = " delete from repair where farmid = ? ";
           pstmt = con.prepareStatement(sql6);
           pstmt.setString(1, farmSplit[i]);
           pstmt.executeQuery();
           
           // watertank 테이블에서 farmid가 일치할 경우 삭제
           String sql7 = " delete from waterTank where farmid = ? ";
           pstmt = con.prepareStatement(sql7);
           pstmt.setString(1, farmSplit[i]);
           pstmt.executeQuery();
           
           //userTable 테이블에서 farmid가 일치할 경우 삭제
           String sql8 = " delete from usertable where farmid = ? ";
           pstmt = con.prepareStatement(sql8);
           pstmt.setString(1, farmSplit[i]);
           pstmt.executeQuery();
        }
           } 

        
     } catch (Exception e) {
        e.printStackTrace();
     } finally {
        dbcp.close(con, pstmt, rs);
     }
  }
  
  /***********************************
   * @name usertableSearch
   * @author Hwang Seon Ju
   * @param - ID, searchuser, searchuserinput
   * @return ArrayList
   * @remark 담당자 조회하기, 사용처 - farmwtUserForm.jsp
   ***********************************/

  public ArrayList<usertableDTO> usertableSearch(String farmid, String searchuser, String searchuserinput) throws NullPointerException, SQLException {
     
     Connection con = null;
     PreparedStatement pstmt = null;
     ResultSet rs = null;
     String sql2 = null;
     ArrayList<usertableDTO> userlist = new ArrayList();

     try {
        con = DBCon.getConnection();
        sql2 = "select userid, username from usertable where farmid=?";

        if (searchuserinput != null && !searchuserinput.equals("") && searchuser != "null"
              && !searchuser.equals("null")) {
           sql2 += "and " + searchuser.trim() + " LIKE '%" + searchuserinput.trim() + "%' order by username";

        } else {
           // 모든 정보 출력
           sql2 += " order by username";
        }

        pstmt = con.prepareStatement(sql2);
        pstmt.setString(1, farmid);
        rs = pstmt.executeQuery();

        while (rs.next()) {
           usertableDTO vo = new usertableDTO();
           vo.setUserId(rs.getString("userid"));
           vo.setUserName(rs.getString("username"));
           userlist.add(vo);
        }
     } catch (Exception e) {
        e.printStackTrace();
     } finally {
        DBCon.close(con, pstmt, rs);
     }
     return userlist;
  }

  /***********************************
   * @name usertableSelect
   * @author Hwang Seon Ju
   * @param - userid
   * @return ArrayList
   * @remark 선택한 담당자 양식장 정보 수정 폼에 data 불러오기, 사용처 - farmwt
   ***********************************/

  public ArrayList<usertableDTO> usertableSelect(String userid) throws NullPointerException, SQLException {

     Connection con = null;
     PreparedStatement pstmt = null;
     ResultSet rs = null;
     String sql = null;
     ArrayList<usertableDTO> userAddlist = new ArrayList();

     try {
        con = DBCon.getConnection();
        sql = "select userid from usertable where userid=?";
        pstmt = con.prepareStatement(sql);
        pstmt.setString(1, userid);

        rs = pstmt.executeQuery();

        if (rs.next()) {
           usertableDTO vo = new usertableDTO();
           vo.setUserId(rs.getString("userid"));
           userAddlist.add(vo);
        }
     } catch (Exception e) {
        e.printStackTrace();
     } finally {
        DBCon.close(con, pstmt, rs);
     }

     return userAddlist;
  }
  
  //--------------------------------------------------------------

  /**************************************
  * @name       ShowUser()  (양식장검색)
  * @author    박진후
  * @param      Auth(사용자 권한)
  * 
  * @return     ArrayList
  * @remark    권한에 맞는 하위 유저들의 리스트를 반환
  *             사용처 - farmUpdateForm.jsp
  **************************************/
 
  public ArrayList ShowUser(String Auth) throws NullPointerException, SQLException {
     
     //DB연결
     Connection con = null;
     PreparedStatement pstmt = null;
     ResultSet rs = null;
     String sql = null;      
     ArrayList list = new ArrayList();      

     try {
        con = DBCon.getConnection();
        
        System.out.println("ID: "+Auth);
        
        if(Auth.equals("전체관리자"))
        {
           sql = "select userid, username from usertable";         
        }
        else
        {
           sql = "select userid, username from usertable where userauth = 'admin' or userauth = 'user'";
        }
        
        System.out.println("sql:"+sql);
        
        pstmt = con.prepareStatement(sql);
        
        rs = pstmt.executeQuery();
         
        while(rs.next())
        {
           usertableDTO dto = new usertableDTO();

           dto.setUserId(rs.getString(1));
           dto.setUserName(rs.getString(2));
                       
           list.add(dto);
        }         

     } catch (Exception e) {
        e.printStackTrace();
     } finally {
       DBCon.close(con, pstmt, rs);
    }      
     
    return list;

 } 
   
	
}
