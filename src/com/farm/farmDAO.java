package com.farm;

import com.main.*;
import java.sql.*;
import java.util.*;

import com.usertable.*;
import com.waterTank.*;
import com.growInfo.*;

public class farmDAO {

	// Global Variable Data Base Connect 
	DBCon dbcp = new DBCon();

	
	/**************************************
	 * @name farmSearch()
	 * @author �쑄嫄댁＜
	 * @param ID, Auth, farmName
	 *            -
	 * @return ArrayList<farmDTO>
	 * @remark �벑濡앹뿉 �븘�슂�븳 �뼇�떇�옣 寃��깋, 
	 * 		   �궗�슜泥� - growInfo/farmSearch.jsp
	 **************************************/
	
	public ArrayList<farmDTO> farmSearch(String ID, String Auth, String farmname)
	{
		// DB �뿰寃곗뿉 �븘�슂�븳 蹂��닔
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		ResultSet rs = null;
		
		ArrayList<farmDTO> adto = new ArrayList<farmDTO>();		// 諛섑솚 蹂��닔
		
		try
		{
			con = dbcp.getConnection();
			
			// 湲곕낯 sql
			sql = "select farmid, farmname, address from farm ";
			
			if(Auth.equals("�쟾泥닿�由ъ옄"))
			{	// �쟾泥닿�由ъ옄�씪�떆
				if(!farmname.equals(""))
				{
					sql += "where farmname like '%" + farmname + "%' ";
				}
			}
			else
			{	// �씪諛섍�由ъ옄�씪�떆
				sql += "where userid = '"+ ID +"' ";
				
				if(Auth.equals("�쟾泥닿�由ъ옄"))
				{	// �쟾泥닿�由ъ옄�씪�떆
					if(!farmname.equals(""))
					{
						sql += "and farmname like '%" + farmname + "%' ";
					}
				}
			}
			pstmt = con.prepareStatement(sql);
			rs = pstmt.executeQuery();
			
			while(rs.next())
			{
				farmDTO dto = new farmDTO();
				dto.setFarmId(rs.getInt("farmid"));						// �뼇�떇�옣ID
				dto.setFarmName(rs.getString("farmname"));				// �뼇�떇�옣�씠由�
				String address[] = rs.getString("address").split(" ");	// 二쇱냼瑜� 諛쏆븘�� �옄由�
				dto.setAddress(address[0] + " " + address[1]);			// �룄/�떆留� �엯�젰
				adto.add(dto);											// 諛섑솚�븿�닔 ���옣
			}
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		finally 
		{
			dbcp.close(con, pstmt, rs);
		}
		
		return adto;
	}
	
	 //--------------------------------------------------------------
	
	/**************************************
	    * @name getFarmInfo()
	    * @author GoJian
	    * @Method getFarmAdminInfo()
	    * @param Session_ID (UserID), Session_Auth(UserAuth)
	    * @remark mainPrc.jsp �뿉 FarmId(�뼇�떇�옣 ID) , FarmName(�뼇�떇�옣 �씠由�) return
	    * @package farmTable
	    * @return farmTableDTO
	    **************************************/
	public ArrayList<farmDTO> getFarmAdminInfo(String UserID, String UserAuth) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		ResultSet rs = null;
		ArrayList<farmDTO> farm_List = new ArrayList<farmDTO>();
		try {
			con = DBCon.getConnection();
			if (UserAuth.equals("전체관리자")) {
				con = DBCon.getConnection();
				String sql1 = "select userid,username,farmid from usertable where userauth='admin'";
				pstmt = con.prepareStatement(sql1);
				rs = pstmt.executeQuery();

				while (rs.next()) {
					farmDTO beans = new farmDTO();
					beans.setUserId(rs.getString("USERID")); 
					beans.setRemark(rs.getString("USERNAME")); 
					beans.setRemarkFarmid(rs.getString("FARMID")); 
					farm_List.add(beans);
				}

			} else if (UserAuth.equals("일반 관리자")) {
				sql = "select FARMID,FARMNAME from farm where userID = ?";
				pstmt = con.prepareStatement(sql);
				pstmt.setString(1, UserID);
				rs = pstmt.executeQuery();

				while (rs.next()) {
					farmDTO beans = new farmDTO();
					beans.setFarmId(rs.getInt("FARMID"));
					beans.setFarmName(rs.getString("FARMNAME"));
					farm_List.add(beans);
				}
			} else {
				sql = "select * from usertable where userid=?";

				pstmt = con.prepareStatement(sql);
				pstmt.setString(1, UserID);
				rs = pstmt.executeQuery();
				usertableDTO beans = new usertableDTO();
				farmDTO retBeans = new farmDTO();
				while (rs.next()) {
					beans.setFarmId(rs.getString("FARMID"));

					
					String sql2 = "select farmid,farmname from farm where farmid= ?";
					pstmt = con.prepareStatement(sql2);
					pstmt.setString(1, beans.getFarmId());
					rs = pstmt.executeQuery();
					if (rs.next()) {
						retBeans.setFarmId(rs.getInt("FARMID"));
						retBeans.setFarmName(rs.getString("FARMNAME"));
					}
					farm_List.add(retBeans);
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBCon.close(con, pstmt, rs);
		}

		return farm_List;
	}
	
	 //--------------------------------------------------------------
	
	   /**************************************
	    * @name getFarmSysInfo()
	    * @author Go Jian
	    * @Method 
	    * @param Session_ID (FarmID)
	    * @remark searchAdmin Servlet�뿉 �뼇�떇�옣 �젙蹂�  由ы꽩
	    * @package farmTable
	    * @return farmTableDTO
	    **************************************/
	public ArrayList<farmDTO> getFarmSysInfo(String FarmID) {
		
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		ResultSet rs = null;
		String[] farmSplit = FarmID.split(",");
		
		ArrayList<farmDTO> farm_Name = new ArrayList<farmDTO>();
		try {
			con = DBCon.getConnection();
			
			for(int i=0; i<farmSplit.length; i++)
			{
		
				sql = "select FARMID,FARMNAME from farm where farmid=?";
				pstmt = con.prepareStatement(sql);
				System.out.println("FARMID   :  "+farmSplit[i]);
				pstmt.setString(1, farmSplit[i]);
		
				rs = pstmt.executeQuery();
				while(rs.next()) {
				farmDTO tempBeans = new farmDTO();
				tempBeans.setFarmId(rs.getInt("FARMID"));
				tempBeans.setFarmName(rs.getString("FARMNAME"));
				farm_Name.add(tempBeans);
				}
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBCon.close(con, pstmt, rs);
		}
		
		return farm_Name;
	}
	
	 //--------------------------------------------------------------
	
	/***********************************
	    * @name   farmSelect()
	    * @author Hwang Seon Ju
	    * @param  farmid
	    * @return ArrayList<farmDTO>
	    * @remark �뼇�떇�옣 �씠由� 異쒕젰(沅뚰븳 : admin, sysadmin) , �궗�슜泥� - main.jsp ,farmwtSearch.jsp
	    ***********************************/

	   public ArrayList<farmDTO> farmSelect(int farmid) throws NullPointerException, SQLException {
	      
	      Connection con = null;
	      PreparedStatement pstmt = null;
	      ResultSet rs = null;
	      String sql = null;
	      ArrayList<farmDTO> farmnamelist = new ArrayList<farmDTO>();
	      
	      try {
	         con = DBCon.getConnection();
	         sql = "select farmname from farm where farmid = ?";
	         pstmt = con.prepareStatement(sql);
	         pstmt.setInt(1, farmid);
	         rs = pstmt.executeQuery();

	         while (rs.next()) {
	            farmDTO vo = new farmDTO();
	            
	            vo.setFarmName(rs.getString("farmname"));      // �뼇�떇�옣 �씠由�
	            
	            farmnamelist.add(vo);
	         }
	         
	      } catch (NumberFormatException e) {
	         e.printStackTrace();
	      } finally {
	         DBCon.close(con, pstmt, rs);
	      }
	      return farmnamelist;
	   }
	   
		 //--------------------------------------------------------------

	/***********************************
	    * @name    farmSelect
	    * @author  Hwang Seon Ju
	    * @param   ID
	    * @return  ArrayList<farmDTO>
	    * @remark  �뼇�떇�옣 �씠由� 異쒕젰(沅뚰븳 : �궗�슜�옄) , �궗�슜泥� - main.jsp ,farmwtSearch.jsp
	    ***********************************/
	   
	   public ArrayList<farmDTO> farmSelect(String ID) throws NullPointerException, SQLException {
	      Connection con = null;
	      PreparedStatement pstmt = null;
	      ResultSet rs = null;
	      String sql1 = null;
	      String sql2 = null;
	      ArrayList<farmDTO> farmnamelist = new ArrayList<farmDTO>();

	      try {
	         con = DBCon.getConnection();
	         sql1 = "select farmid from usertable where userid=?";
	         pstmt = con.prepareStatement(sql1);
	         pstmt.setString(1, ID);
	         rs = pstmt.executeQuery();
	         String farmid = "";

	         if (rs.next()) {
	            farmid = rs.getString("farmid");
	         }

	         sql2 = "select farmname from farm where farmid = ?";
	         pstmt = con.prepareStatement(sql2);
	         pstmt.setString(1, farmid);
	         rs = pstmt.executeQuery();

	         while (rs.next()) {
	            farmDTO vo = new farmDTO();
	            vo.setFarmName(rs.getString("farmname"));
	            farmnamelist.add(vo);
	         }
	         
	      } catch (NumberFormatException e) {
	         e.printStackTrace();
	      } finally {
	         DBCon.close(con, pstmt, rs);
	      }
	      return farmnamelist;
	   }
	   
	//--------------------------------------------------------------
	   
	   /**************************************
	    * @name  getFarm()
	    * @author  源��꽦�쁽
	    * @param   FarmID from FarmTable
	    * @return  list
	    * @remark  �궗�슜�옄 �젙蹂댁뿉�꽌 �뼇�떇�옣 媛믪쓣 媛��졇�삩�떎 - userInfo.jsp
	    **************************************/
	   public ArrayList<farmDTO> getFarm(int arr[]) {
	      Connection con = null;
	      PreparedStatement pstmt = null;
	      ResultSet rs = null;
	      String sql = null;

	      ArrayList list = new ArrayList();

	      try {
	         con = DBCon.getConnection();

	         for (int i = 0; i < arr.length; i++) {

	            sql = "select farmid, farmname, address " + "from farm " + "where farmid = ?";

	            pstmt = con.prepareStatement(sql);
	            pstmt.setInt(1, arr[i]);
	            rs = pstmt.executeQuery();
	            farmDTO bean = new farmDTO();

	            while (rs.next()) {
	               bean.setFarmId(rs.getInt("farmid"));
	               bean.setFarmName(rs.getString("farmname"));
	               bean.setAddress(rs.getString("address"));
	               list.add(bean);
	            }
	         }
	      } catch (Exception e) {
	         e.printStackTrace();
	      } finally {
	         DBCon.close(con, pstmt, rs);
	      }
	      return list;

	   }
	
	//--------------------------------------------------------------
	
	/**************************************
	 * @name 	getFarmName()	(�뼇�떇�옣 �씠由� 異쒕젰)
	 * @author 	諛뺤쭊�썑
	 * @param 	farmID(�뼇�떇�옣 踰덊샇)
	 * 
	 * @return 	String
	 * @remark 	farmID瑜� 諛쏆븘�꽌 洹몄뿉 留욌뒗 farmName�쓣 異쒕젰�븿
	 * 			�궗�슜泥� - wtCautionForm.jsp
	 **************************************/
	public String getFarmName(int farmID) {
		//DB�뿰寃� 媛앹껜
		Connection con = null;
		PreparedStatement pstmt = null;	
		ResultSet rs = null;		
		String sql = null;
		
		farmDTO dto= new farmDTO();

		try {
			con = DBCon.getConnection();			
			//farmID瑜� 鍮꾧탳�븯�뿬 洹몄뿉 留욌뒗 farmName�쓣 議고쉶
			sql = "select farmName from farm where farmID=?";
			pstmt = con.prepareStatement(sql);
			
			pstmt.setInt(1, farmID);
			
			rs = pstmt.executeQuery();
			
			if(rs.next())
			{
				dto.setFarmName(rs.getString(1));
			}			
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBCon.close(con, pstmt, rs);
		}

		return dto.getFarmName();
		
	}	
	
	//--------------------------------------------------------------
	
	/**************************************
	 * @name 	farmSelect()	(�뼇�떇�옣 �씠由� 異쒕젰)
	 * @author 	諛뺤쭊�썑
	 * @param 	userID(�궗�슜�옄 �븘�씠�뵒), Auth(�궗�슜�옄 沅뚰븳)
	 * 
	 * @return  ArrayList
	 * @remark 	userID�� Auth瑜� 諛쏆븘�꽌 洹몄뿉 留욌뒗 farm �젙蹂대�� 異쒕젰�븿
	 * 			�궗�슜泥� - farmListForm.jsp
	**************************************/
	public ArrayList farmSelect(String ID, String Auth) throws NullPointerException, SQLException {				
		//DB�뿰寃� 媛앹껜
		ArrayList list = new ArrayList();
		Connection con = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;
		ResultSet rs2 = null;
		String sql = null;

		try {	    	
			con = DBCon.getConnection();	
			//沅뚰븳�씠 sysadmin�씪 寃쎌슦 DB�뿉 �엳�뒗 紐⑤뱺 �뼇�떇�옣�쓽 �젙蹂대�� 異쒕젰
			if(Auth.equals("�쟾泥닿�由ъ옄"))
			{    		
				sql = "select f.farmID, f.farmName, f.address, f.tankCnt, u1.username, u2.username, to_char(f.regdate,'yyyy-mm-dd hh24:mi'), f.userID "	    				
						+ "from farm f left outer join usertable u1 on f.userID= u1.userID left outer join usertable u2 on f.regid = u2.userid order by f.farmid";		         
				//rs.next()瑜� �넻�븳 由ъ뒪�듃 議댁옱 �뿬遺�瑜� �뙋蹂꾩쓣 �쐞�빐 諛쏆쓬
				pstmt = con.prepareStatement(sql);
				rs = pstmt.executeQuery();
				
				//議고쉶 寃곌낵瑜� 由ъ뒪�듃�뿉 諛쏄린 �쐞�븳 rs2 諛쏄린
				pstmt2 = con.prepareStatement(sql);
				rs2 = pstmt2.executeQuery();			
			}
			//洹� �쇅�쓽 寃쎌슦�뿏 admin�씠 蹂댁쑀�븳 �뼇�떇�옣�씠�굹 user媛� 愿�由ъ쨷�씤 �뼇�떇�옣留� 異쒕젰
			else
			{
				sql = "select f.farmID, f.farmName, f.address, f.tankCnt, u1.username, u2.username, to_char(f.regdate,'yyyy-mm-dd hh24:mi'), f.userID "
						+ "from farm f left outer join usertable u1 on f.userID= u1.userID left outer join usertable u2 on f.regid = u2.userid where f.userid=? order by f.farmid";		 
				//rs.next()瑜� �넻�븳 由ъ뒪�듃 議댁옱 �뿬遺�瑜� �뙋蹂꾩쓣 �쐞�빐 諛쏆쓬
				pstmt = con.prepareStatement(sql);
		         
				pstmt.setString(1, ID);

				rs = pstmt.executeQuery();
				
				//議고쉶 寃곌낵瑜� 由ъ뒪�듃�뿉 諛쏄린 �쐞�븳 rs2 諛쏄린
				pstmt2 = con.prepareStatement(sql);
				
				pstmt2.setString(1, ID);
				
				rs2 = pstmt2.executeQuery();				
			}
			
			if (rs.next())
			{
				while (rs2.next()) 
				{
					farmDTO dto = new farmDTO();
		            
					dto.setFarmId(rs2.getInt(1));
					dto.setFarmName(rs2.getString(2));
					dto.setAddress(rs2.getString(3));
					dto.setTankcnt(rs2.getInt(4));
					dto.setRemark(rs2.getString(5));
					dto.setRegId(rs2.getString(6));
					dto.setRegDate(rs2.getString(7));
					dto.setUserId(rs2.getString(8));

					list.add(dto);
				}
			}
			else
			{
				list = null;
			}
	    	
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBCon.close(con, pstmt, rs);
			DBCon.close(con, pstmt2, rs2);
		}

		return list;

	}
	
	//--------------------------------------------------------------
	
	/**************************************
	 * @name 	farmInsert()	(�뼇�떇�옣  異붽�)
	 * @author 	諛뺤쭊�썑
	 * @param 	ID(�궗�슜�옄 �븘�씠�뵒), farmname(�뼇�떇�옣 �씠由�), address(�뼇�떇�옣 二쇱냼), tankcnt(�닔議� 媛쒖닔)
	 * 
	 * @return  void
	 * @remark 	ID, farmname, address, tankcnt瑜� 諛쏆븘�꽌 �뼇�떇�옣�쓣 �깉濡� 異붽�
	 * 			�궗�슜泥� - farmAddPrc.jsp
	 **************************************/
	public void farmInsert(String ID, String farmname, String address, String tankcnt) throws NullPointerException, SQLException {
		//DB�뿰寃� 媛앹껜
		ArrayList list = new ArrayList();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
	    String set = null;
	    int farmID = 0;

	    try {	    	
	    	con = DBCon.getConnection();
	    	//諛쏆� �뼇�떇�옣 �젙蹂댁뿉 留욊쾶 �뼇�떇�옣 異붽�
	    	sql = "insert into farm(farmid, farmname, address, tankcnt, userid, regdate, regid, lastuptdate, lastuptid)"
	    			+ "values(farmidseq.nextval, ?, ?, ?, ?, sysdate, ?, sysdate, ?)";

	    	pstmt = con.prepareStatement(sql);

	    	pstmt.setString(1, farmname);
	    	pstmt.setString(2, address);
	    	pstmt.setString(3, tankcnt);
	    	pstmt.setString(4, ID);
	    	pstmt.setString(5, ID);
	    	pstmt.setString(6, ID);   
	    	
	    	pstmt.executeUpdate();

	    	//諛⑷툑 異붽��븳 �뼇�떇�옣 踰덊샇��  湲곗〈�뿉 �엳�뜕 �궗�슜�옄�쓽 �뼇�떇�옣 踰덊샇瑜� 議고쉶
	    	sql = "select farmidseq.currval, u.farmid from farm f, usertable u where u.userid=?";
	    	
	    	pstmt = con.prepareStatement(sql);

	    	pstmt.setString(1, ID);
	    	
	    	rs = pstmt.executeQuery();

	    	if(rs.next())
	    	{
	    		farmID = rs.getInt(1);
	    		
	    		if(rs.getString(2) == null || rs.getString(2) == "")
	    		{
	    			set = rs.getString(1);
	    		}
	    		else
	    		{
	    			//湲곗〈�뿉 �엳�뜕 �뼇�떇�옣 踰덊샇�뿉 異붽��븳 �뼇�떇�옣 踰덊샇瑜� 異붽�
	    			set = rs.getString(2) +","+ rs.getInt(1);
	    		}
	    	}	       
	        
	    	//異붽��븳 遺�遺꾩쓣 usertable�뿉 �닔�젙
	    	sql = "update usertable set farmid=? where userid=?";
	        
	    	pstmt = con.prepareStatement(sql);
	        
	    	pstmt.setString(1, set);
	    	pstmt.setString(2, ID);
	         
	    	pstmt.executeUpdate();

	    } catch (Exception e) {
	    	e.printStackTrace();
	    } finally {
	    	DBCon.close(con, pstmt, rs);
	    }

	}
	 
	 //--------------------------------------------------------------
		
	 /**************************************
	 * @name 	SearchFarm()  (�뼇�떇�옣寃��깋)
	 * @author 	諛뺤쭊�썑
	 * @param 	farmDTO(寃��깋 議곌굔 由ъ뒪�듃)
	 * 
	 * @return  ArrayList
	 * @remark 	dto瑜� 諛쏆븘�꽌 dto�뿉 留욌뒗 議곌굔�쓽 由ъ뒪�듃瑜� select�븯怨� 紐⑤뱺 由ъ뒪�듃瑜� select
	 * 			�궗�슜泥� - farmSearchForm.jsp
	 **************************************/
	
	public ArrayList SearchFarm(farmDTO dto) throws NullPointerException, SQLException {
		// farmwtSearch �빐�떦 �뼇�떇�옣�쓽 寃��깋 議곌굔�뿉 留욊쾶 異쒕젰
		ArrayList list = new ArrayList();
		Connection con = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;
		ResultSet rs2 = null;		 
		 
		try {
			con = DBCon.getConnection();
			//�뼇�떇�옣 �쟾泥댁쓽  farmName, address瑜� 異쒕젰�븯�뒗 荑쇰━臾�
			String sql = "select f.farmName, f.address, f.farmid from farm f left outer join usertable u on f.farmid>=0 group by f.farmname, f.address, f.farmid";
			String sql2 = " having f.farmid>=0";

			//寃��깋 議곌굔�씠 �엳�쓣 �떆 洹몄뿉 留욊쾶 荑쇰━臾몄쓣 遺숈엫
			if(dto.getFarmName() != "")
			{
				sql = sql + ", f.farmname";
				sql2 = sql2+" and f.farmName like '%" + dto.getFarmName() + "%'";
			}
  
			if(dto.getAddress() != "")
			{
				sql = sql + ", f.address";
				sql2 = sql2+" and f.address like '%" + dto.getAddress() + "%'";
			}

			if(dto.getRemark() != "")
			{
				sql = sql + ", f.userid, u.userid, u.username";
				sql2 = sql2+" and f.userID = u.userID and u.username like '%"+ dto.getRemark()+"%'";	
			}

			if(dto.getRegFromDate() != "" && dto.getRegToDate() != "")
			{
				sql = sql + ", f.regdate";
				sql2 = sql2+" and f.regDate between to_date('"+dto.getRegFromDate()+"') and to_date('"+dto.getRegToDate()+"')";
			}
			//寃��깋 議곌굔 �뙋蹂� �걹

			//�젙�젹�쓣 �쐞�빐 留덉�留됱쑝濡� 遺숈엫
			sql = sql + sql2 + " order by f.farmid";

			System.out.println(sql);
			
			//議고쉶 寃곌낵瑜� 鍮꾧탳�븯湲� �쐞�븳 rs 諛쏄린
			pstmt = con.prepareStatement(sql);
			rs = pstmt.executeQuery();
			//議고쉶 寃곌낵瑜� 由ъ뒪�듃�뿉 諛쏄린 �쐞�븳 rs2 諛쏄린
			pstmt2 = con.prepareStatement(sql);
			rs2 = pstmt2.executeQuery();

			if (rs.next())
			{
				while(rs2.next())
				{ 
					farmDTO fto = new farmDTO();

					fto.setFarmName(rs2.getString(1));
					fto.setAddress(rs2.getString(2));
					fto.setFarmId(rs2.getInt(3));

					list.add(fto);
				}
				
				//議고쉶 寃곌낵�쓽 �궡�슜�씠 �몢 �궇吏쒖쨷 �븯�굹�씪�룄 �엯�젰�씠 �릺吏� �븡�븘 �굹�삩  寃껋씠�씪硫� 由ъ뒪�듃瑜� 鍮꾩슦怨� nop瑜� 諛섑솚
				if(!((dto.getRegFromDate() == "" && dto.getRegToDate() == "") || 
						(dto.getRegFromDate() != "" && dto.getRegToDate() != "")))
				{
					list.clear();
					list.add(0, "nop");
				}					
					
			}
			else
			{
				//議고쉶 寃곌낵媛� �뾾�쓣 寃쎌슦 �궇吏쒖쓽 媛믪쓣 鍮꾧탳
				int compare = dto.getRegToDate().compareTo(dto.getRegFromDate());
				
				//�궇吏쒖쓽 �떆�옉怨� �걹�씠 諛붾�� 寃껋씠�씪硫� 由ъ뒪�듃瑜� 鍮꾩슦怨� nop瑜� 諛섑솚
				if(compare < 0)
				{
					list.clear();
					list.add(0, "nop");
				}
				//議고쉶 寃곌낵媛� �뾾�뒗 寃껋씠�씪硫� null�쓣 諛섑솚
				else
				{
					list = null;
				}
			}

		} catch (Exception e) {
		     e.printStackTrace();
		} finally {
			DBCon.close(con, pstmt, rs);
			DBCon.close(con, pstmt2, rs2);
		}

		return list;

	}
	
	//--------------------------------------------------------------
	
	/**************************************
	    * @name farmidToName()
	    * @author �쑄嫄댁＜
	    * @param farmId
	    *            -
	    * @return String(farmName)
	    * @remark �빐�떦 ID�쓽 �빐�떦 �뼇�떇�옣 紐낆쑝濡� 援먰솚, 
	    *          �궗�슜泥� - waterTank/stateRec.jsp
	    **************************************/
	   
	   public String farmidToName(int farmId)
	   {
	      // DB �뿰寃곗뿉 �븘�슂�븳 蹂��닔
	      Connection con = null;
	      PreparedStatement pstmt = null;
	      String sql = null;
	      ResultSet rs = null;
	      
	      String farmName = "";
	      
	      try
	      {
	         con = dbcp.getConnection();
	         
	         // 湲곕낯 sql
	         sql = "select farmname from farm where farmid = ? ";
	         pstmt = con.prepareStatement(sql);
	         pstmt.setInt(1, farmId);                        // 留ㅺ컻蹂��닔濡� 諛쏆� �뼇�떇�옣ID
	         rs = pstmt.executeQuery();
	         
	         if(rs.next())
	         {
	            farmName = rs.getString("farmname");            // �빐�떦 ID�쓽 �뼇�떇�옣�쓽 �씠由�
	         }
	      }
	      catch(Exception e)
	      {
	         e.printStackTrace();
	      }
	      finally 
	      {
	         dbcp.close(con, pstmt, rs);
	      }
	      
	      return farmName;
	   }
	   
	    //--------------------------------------------------------------
	   
	    /**************************************
	    * @name    farmUpdate()  (�뼇�떇�옣�닔�젙)
	    * @author    諛뺤쭊�썑
	    * @param    Session_id(�닔�젙�옄 �븘�씠�뵒), farmId(�뼇�떇�옣 踰덊샇), farmName(�뼇�떇�옣 �씠由�), Address(二쇱냼), tankCnt(�닔議� 媛쒖닔), search(諛붾�뚮뒗 愿�由ъ옄), userid(愿�由ъ옄ID)
	    * 
	    * @return  void
	    * @remark    �닔�젙 �궡�슜�쓣 諛쏆븘�꽌 洹몄뿉 留욎떠�꽌 �궡�슜�뱾�쓣 �닔�젙
	    *          �궗�슜泥� - farmUpdatePrc.jsp
	    **************************************/
	   
	   public void farmUpdate(String Session_id, int farmId, String farmName, String Address, int tankCnt, String search, String userid) throws NullPointerException, SQLException {
	      //DB�뿰寃�      
	      Connection con = null;
	      PreparedStatement pstmt = null;
	      PreparedStatement pstmt2 = null;
	      PreparedStatement pstmt3 = null;
	      ResultSet rs = null;
	      ResultSet rs2 = null;
	      String sql = null;
	      String sql2 = null;
	      String sql3 = null;
	      int num = 2;
	      String s = null;
	       
	      try {
	         con = DBCon.getConnection();
	         //�뼇�떇�옣�쓽 �궡�슜�쓣 議곌굔�뿉 留욊쾶 �닔�젙�븯�뒗 荑쇰━臾�
	         sql = "update farm set lastuptdate=sysdate, lastuptid=?";

	         //�닔�젙 媛믪씠 �엳�쓣 �떆 洹몄뿉 留욊쾶 荑쇰━臾몄쓣 遺숈엫
	         if(!farmName.equals(""))
	         {
	            sql = sql + ", farmName=?";
	            System.out.println("farmName: "+farmName);
	         }
	 
	         if(!Address.equals(""))
	         {
	            sql = sql + ", Address=?";
	            System.out.println("Address: "+Address);
	         }

	         if(!Integer.toString(tankCnt).equals(""))
	         {
	            sql = sql + ", tankCnt=?";
	            System.out.println("tankCnt: "+tankCnt);
	         }

	         if(!search.equals(""))
	         {
	            sql = sql + ", userid=?";
	            System.out.println("last_userid: "+search);
	         }

	         sql = sql + " where farmid=?";

	         System.out.println("first_userid: "+ userid);

	         //�닔�젙�쓣 �쐞�븳 rs諛쏄린
	         pstmt = con.prepareStatement(sql);

	         pstmt.setString(1, Session_id);
	         
	         System.out.println(num);
	         
	         //�닔�젙 媛믪씠 �엳�쓣 �떆 洹몄뿉 留욊쾶 荑쇰━臾몄쓣 遺숈엫
	         if(!farmName.equals(""))
	         {
	            pstmt.setString(num, farmName);
	            num++;
	            System.out.println(num);
	         }
	 
	         if(!Address.equals(""))
	         {
	            pstmt.setString(num, Address);
	            num++;
	            System.out.println(num);
	         }

	         if(!Integer.toString(tankCnt).equals(""))
	         {
	            pstmt.setInt(num, tankCnt);
	            num++;
	            System.out.println(num);
	         }
	         
	         sql2 = "select farmid from usertable where userid=?";
	         pstmt2 = con.prepareStatement(sql2);
	         
	         pstmt2.setString(1, userid);
	                     
	         rs = pstmt2.executeQuery();

	         if(!(search.equals(""))&&(!userid.equals(search)))
	         {
	            pstmt.setString(num, search);
	            num++;
	            
	            sql2 = "select farmid from usertable where userid=?";
	            pstmt2 = con.prepareStatement(sql2);
	            
	            pstmt2.setString(1, userid);
	                        
	            rs = pstmt2.executeQuery();
	            
	            if(rs.next())
	            {
	               if(rs.getString(1).substring(rs.getString(1).length() -1, rs.getString(1).length())==Integer.toString(farmId))
	               {
	                  s = Integer.toString(farmId);
	                  s = rs.getString(1).replaceFirst(s, "");
	               }
	               else
	               {
	                  s = Integer.toString(farmId) +",";
	                  s = rs.getString(1).replaceFirst(s, "");
	               }               
	            }
	            
	            sql3 = "update usertable set farmid = ? where userid=?";
	            pstmt3 = con.prepareStatement(sql3);
	            
	            pstmt3.setString(1, s);
	            pstmt3.setString(2, userid);

	            pstmt3.executeUpdate();
	            
	            sql2 = "select farmid from usertable where userid=?";
	            pstmt2 = con.prepareStatement(sql2);
	            
	            pstmt2.setString(1, search);
	                        
	            rs2 = pstmt2.executeQuery();
	            
	            if(rs2.next())
	            {
	               s = rs2.getString(1);
	            }
	            
	            s = s +","+ farmId;
	            
	            sql3 = "update usertable set farmid = ? where userid=?";
	            pstmt3 = con.prepareStatement(sql3);
	            
	            pstmt3.setString(1, s);
	            pstmt3.setString(2, search);
	            
	            pstmt3.executeUpdate();
	         }
	         else
	         {
	            pstmt.setString(num, search);
	            num++;
	         }
	         
	         pstmt.setInt(num, farmId);
	         
	         System.out.println(sql);
	         
	         pstmt.executeUpdate();

	      } catch (Exception e) {
	           e.printStackTrace();
	      } finally {
	         DBCon.close(con, pstmt, rs);
	         DBCon.close(con, pstmt2, rs2);
	         DBCon.close(con, pstmt3, rs);
	      }

	   }
	
	/*
	 * ============================= END METHOD ==================================
	 */
}
