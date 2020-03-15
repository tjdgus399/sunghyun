package com.growInfo;

import java.sql.*;
import java.util.*;

import com.main.*;

public class growInfoDAO {
	//DB�뿰寃� 媛앹껜�솕
	DBCon dbcp = new DBCon();
	
	//--------------------------------------------------------------
	
	/**************************************
	 * @name insertGrowInfotData()
	 * @author �쑄嫄댁＜
	 * @param ArrayList<growDTO>(�븘�슂�븳 �젙蹂� 由ъ뒪�듃)
	 *            -
	 * @return int(�꽦怨듭떆 1, �떎�뙣�떆 0)
	 * @remark �긽�깭湲곗��젙蹂� DB�뿉 �벑濡�,
	 * 		   �궗�슜泥� - growInfo/growInfoPrc.jsp
	 **************************************/
	
	public int insertGrowInfotData(ArrayList<growInfoDTO> adto)
	{
		// DB �뿰寃곗뿉 �븘�슂�븳 蹂��닔
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		ResultSet rs = null;
		
		int result = 0;						// 諛섑솚 蹂��닔
		
		try
		{
			con = dbcp.getConnection();
			
			//理쒕� 洹몃９ 肄붾뱶 媛� 媛��졇�삤湲�
			sql = "select max(groupcode) as max from fish ";
			pstmt = con.prepareStatement(sql);
			rs = pstmt.executeQuery();
			
			rs.next();
			int max = rs.getInt("max")+1; //洹몃９肄붾뱶 愿�由щ�� �쐞�븳 蹂��닔
			
			
			
			//�젙蹂닿컪 �엯�젰
			for(int i=0; i<5; i++)
			{
				growInfoDTO dto = adto.get(i); 
				//�궫�엯 sql
				sql = "insert into fish(fishid, farmid, fishname, state, " + 
					"domax, domin, wtmax, wtmin, psumax, psumin, phmax, " + 
					"phmin, nh4max, nh4min, no2max, no2min, regdate, regid, " + 
					"lastuptdate, lastuptid, groupcode)" + 
					"values(fishidseq.nextval, ?, ?, ?, " + 
					"?, ?, ?, ?, ?, ?, ?, " + 
					"?, ?, ?, ?, ?, sysdate, ?, " + 
					"sysdate, ?, ?) ";
				pstmt = con.prepareStatement(sql);		
				pstmt.setInt(1, dto.getFarmId());		// �뼇�떇�옣ID
				pstmt.setString(2, dto.getFishName());	// �뼇�떇�젙蹂대챸移�
				pstmt.setString(3, dto.getState());		// �긽�깭媛�
				pstmt.setDouble(4, dto.getDOMax());		// �빐�떦 �긽�깭 �슜議댁궛�냼 理쒕�移�
				pstmt.setDouble(5, dto.getDOMin());		// �빐�떦 �긽�깭 �슜議댁궛�냼 理쒖냼移�
				pstmt.setDouble(6, dto.getWTMax());		// �빐�떦 �긽�깭 �닔�삩 理쒕�移�
				pstmt.setDouble(7, dto.getWTMin());		// �빐�떦 �긽�깭 �닔�삩 理쒖냼移�
				pstmt.setDouble(8, dto.getPsuMax());	// �빐�떦 �긽�깭 �뿼�룄 理쒕�移�
				pstmt.setDouble(9, dto.getPsuMin());	// �빐�떦 �긽�깭 �뿼�룄 理쒖냼移�
				pstmt.setDouble(10, dto.getpHMax());	// �빐�떦 �긽�깭 �궛�룄 理쒕�移�
				pstmt.setDouble(11, dto.getpHMin());	// �빐�떦 �긽�깭 �궛�룄 理쒖냼移�
				pstmt.setDouble(12, dto.getNH4Max());	// �빐�떦 �긽�깭 �븫紐⑤땲�븘 理쒕�移�
				pstmt.setDouble(13, dto.getNH4Min());	// �빐�떦 �긽�깭 �븫紐⑤땲�븘 理쒖냼移�
				pstmt.setDouble(14, dto.getNO2Max());	// �빐�떦 �긽�깭�븘吏덉궛 理쒕�移�
				pstmt.setDouble(15, dto.getNO2Min());	// �빐�떦 �긽�깭�븘吏덉궛 理쒖냼移�
				pstmt.setString(16, dto.getRegId());	// �젙蹂대벑濡앹옄
				pstmt.setString(17, dto.getLastUptId());// 理쒖쥌�닔�젙�옄
				pstmt.setInt(18, max);					// �젙蹂� 洹몃９ 肄붾뱶
				pstmt.executeUpdate();
			}
			
			result = 1; //�닔�뻾�씠 �셿猷뚮릺硫� 1�쓣 由ы꽩
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		finally 
		{
			dbcp.close(con, pstmt, rs);
		}
		
		return result;
	}
	
	//--------------------------------------------------------------
	
	/**************************************
	 * @name listData()
	 * @author �쑄嫄댁＜
	 * @param farmId, groupcode
	 *            -
	 * @return ArrayList<growDTO>
	 * @remark �뼇�떇�젙蹂�, �뼇�떇�옣�씠由�, 二쇱냼瑜� 議고쉶
	 * 		   �궗�슜泥� - growInfo/growList.jsp
	 **************************************/
	
	public ArrayList<growInfoDTO> listData(String userId, String auth, String farmName, String fishName)
	{
		// DB �뿰寃곗뿉 �븘�슂�븳 蹂��닔
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		ResultSet rs = null;
		
		int subArray[] = null;											// �뼇�떇�옣�씠 �뿬�윭媛쒖씤 �씪諛섏궗�슜�옄瑜� �쐞�븳 蹂��닔
		
		ArrayList<growInfoDTO> adto = new ArrayList<growInfoDTO>();		// 諛섑솚 蹂��닔
		
		try
		{
			con = dbcp.getConnection();
			
			// farmID媛��졇�삤湲�
			if(auth.equals("전체관리자"))
			{	// �쟾泥닿�由ъ옄 - �쟾泥� �뼇�떇�옣 �솗�씤
				sql  = "select distinct a.farmid, a.farmname, a.address, b.fishName, b.groupcode " + 
					   "from farm a, (select fishname, groupcode, farmid from fish) b " + 
					   "where a.farmid = b.farmid ";
				
				// 寃��깋議곌굔 �솗�씤
				if(!farmName.equals(""))
				{	// �뼇�떇�옣�씠由꾩뿉 寃��깋媛믪씠 �엳�쓣 寃쎌슦
					sql += "and a.farmname like '%" + farmName + "%' ";
				}
				if(!fishName.equals(""))
				{	// �뼇�떇�젙蹂대챸�뿉 寃��깋媛믪씠 �엳�쓣 寃쎌슦
					sql += "and b.fishname like '%" + fishName + "%' ";
				}
			}
			else
			{	// �씪諛섍�由ъ옄/�궗�슜�옄 - usertable�뿉 ���옣�맂 �궡�슜�쓣 �넗��濡� 媛�吏�怨� �샂
				sql = "select farmid from usertable where userid = ?";
				pstmt = con.prepareStatement(sql);
				pstmt.setString(1, userId);
				rs = pstmt.executeQuery();
				
				if(rs.next());
				{	// 諛곗뿴�뿉 媛� ���옣
					String farmId[] = rs.getString("farmid").split(",");
					
					if(farmId[0].equals(null))
					{ 	// �뾾�쑝硫� 諛섑솚媛� �뾾�쓬.
						return null;
					}
					else
					{	// 媛믪씠 �엳�쓣 �떆
						subArray = new int[farmId.length];
						// 諛섑솚媛� 議댁옱
						for(int i=0; i<farmId.length; i++)
						{
							subArray[i] = Integer.parseInt(farmId[i]);
						}
					}
				}
				
				sql = "select distinct a.farmid, a.farmname, a.address, b.fishName, b.groupcode " + 
					  "from farm a, (select fishname, groupcode, farmid from fish) b " + 
					  "where a.farmid = b.farmid ";
				
				// 寃��깋議곌굔 �솗�씤
				if(!farmName.equals(""))
				{	// �뼇�떇�옣�씠由꾩뿉 寃��깋媛믪씠 �엳�쓣 寃쎌슦
					sql += "and a.farmname like '%" + farmName + "%' ";
				}
				if(!fishName.equals(""))
				{	// �뼇�떇�젙蹂대챸�뿉 寃��깋媛믪씠 �엳�쓣 寃쎌슦
					sql += "and b.fishname like '%" + fishName + "%' ";
				}
				
				sql +=  "and a.farmid in (";
				
				for(int i=0; i<subArray.length; i++)
				{
					if(i == (subArray.length-1))
					{
						sql += subArray[i] + ") ";
					}
					else
					{
						sql += subArray[i] + ", ";
					}
				}
				
			}
			
			sql += "order by groupcode desc";
			pstmt = con.prepareStatement(sql);
			rs = pstmt.executeQuery();
			
			while(rs.next())
			{	// 諛곗뿴�뿉 媛� ���옣
				growInfoDTO dto = new growInfoDTO();
				dto.setFarmId(rs.getInt("farmid"));														// �뼇�떇�젙蹂큛d
				dto.setFishName(rs.getString("fishname"));												// �뼇�떇�젙蹂대챸
				dto.setGroupCode(rs.getInt("groupcode"));												// 洹몃９肄붾뱶
				String address[] = rs.getString("address").split(" ");									// 臾몄옄�뿴 �옄瑜닿린
				dto.setRemark(rs.getString("farmname") + " (" + address[0] + " " + address[1] + ")");	// �뼇�떇�옣 �씠由�/二쇱냼 ���옣
				adto.add(dto);																			// Arraylist異붽�
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
	 * @name readGrowInfo()
	 * @author �쑄嫄댁＜
	 * @param farmid, groupcode
	 *            -
	 * @return ArrayList<growDTO>
	 * @remark �뼇�떇�젙蹂� 議고쉶�븯湲� , 
	 * 		   �궗�슜泥� - growInfo/growInfoRead.jsp
	 **************************************/
	
	public ArrayList<growInfoDTO> readGrowInfo(int farmid, int groupcode)
	{
		// DB �뿰寃곗뿉 �븘�슂�븳 蹂��닔
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		ResultSet rs = null;
		
		ArrayList<growInfoDTO> adto = new ArrayList<growInfoDTO>();						// 諛섑솚 蹂��닔
		
		try
		{
			con = dbcp.getConnection();
			
			//�젙蹂� 議고쉶 �븯湲�
			sql = "select * from fish where farmid = ? and groupcode = ? ";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, farmid);
			pstmt.setInt(2, groupcode);
			rs = pstmt.executeQuery();
			
			boolean flag = true;
			
			while(rs.next())
			{
				if(flag)
				{
					growInfoDTO dto = new growInfoDTO();
					dto.setFishName(rs.getString("fishname"));
					dto.setDOMax(rs.getDouble("domax"));
					dto.setDOMin(rs.getDouble("domin"));
					dto.setWTMax(rs.getDouble("wtmax"));
					dto.setWTMin(rs.getDouble("wtmin"));
					dto.setPsuMax(rs.getDouble("psumax"));
					dto.setPsuMin(rs.getDouble("psumin"));
					dto.setpHMax(rs.getDouble("phmax"));
					dto.setpHMin(rs.getDouble("phmin"));
					dto.setNH4Max(rs.getDouble("nh4max"));
					dto.setNH4Min(rs.getDouble("nh4min"));
					dto.setNO2Max(rs.getDouble("no2max"));
					dto.setNO2Min(rs.getDouble("no2min"));
					adto.add(dto);
				}
				flag = !flag;
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
	 * @name updateGrowInfo()
	 * @author �쑄嫄댁＜
	 * @param farmId, groupcode, ArrayList<growDTO>(�븘�슂�븳 �젙蹂� 由ъ뒪�듃)
	 *            -
	 * @return int(�꽦怨듭떆 1, �떎�뙣�떆 0)
	 * @remark �긽�깭湲곗��젙蹂� �닔�젙 , 
	 * 		   �궗�슜泥� - growInfo/growInfoPrc.jsp
	 **************************************/
	
	public int updateGrowInfo(int farmId, int groupcode, ArrayList<growInfoDTO> adto)
	{
		// DB �뿰寃곗뿉 �븘�슂�븳 蹂��닔
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		ResultSet rs = null;
		
		int result = 0;						// 諛섑솚 蹂��닔
		
		try
		{
			con = dbcp.getConnection();
						
			//�젙蹂닿컪 �엯�젰
			for(int i=0; i<5; i++)
			{
				growInfoDTO dto = adto.get(i); 
				//�궫�엯 sql
				sql = "update fish "
						+ "set fishname = ?, domax = ?, domin = ?, wtmax = ?, wtmin = ?, psumax = ?, psumin = ?, phmax = ?, phmin = ?, "
						+ "nh4max = ?, nh4min = ?, no2max = ?, no2min = ?, lastuptdate = sysdate, lastuptid = ? "
						+ "where farmid = ? and state = ? and groupcode = ? ";
				pstmt = con.prepareStatement(sql);		
				pstmt.setString(1, dto.getFishName());	// �뼇�떇�젙蹂대챸移�
				pstmt.setDouble(2, dto.getDOMax());		// �빐�떦 �긽�깭 �슜議댁궛�냼 理쒕�移�
				pstmt.setDouble(3, dto.getDOMin());		// �빐�떦 �긽�깭 �슜議댁궛�냼 理쒖냼移�
				pstmt.setDouble(4, dto.getWTMax());		// �빐�떦 �긽�깭 �닔�삩 理쒕�移�
				pstmt.setDouble(5, dto.getWTMin());		// �빐�떦 �긽�깭 �닔�삩 理쒖냼移�
				pstmt.setDouble(6, dto.getPsuMax());	// �빐�떦 �긽�깭 �뿼�룄 理쒕�移�
				pstmt.setDouble(7, dto.getPsuMin());	// �빐�떦 �긽�깭 �뿼�룄 理쒖냼移�
				pstmt.setDouble(8, dto.getpHMax());		// �빐�떦 �긽�깭 �궛�룄 理쒕�移�
				pstmt.setDouble(9, dto.getpHMin());		// �빐�떦 �긽�깭 �궛�룄 理쒖냼移�
				pstmt.setDouble(10, dto.getNH4Max());	// �빐�떦 �긽�깭 �븫紐⑤땲�븘 理쒕�移�
				pstmt.setDouble(11, dto.getNH4Min());	// �빐�떦 �긽�깭 �븫紐⑤땲�븘 理쒖냼移�
				pstmt.setDouble(12, dto.getNO2Max());	// �빐�떦 �긽�깭�븘吏덉궛 理쒕�移�
				pstmt.setDouble(13, dto.getNO2Min());	// �빐�떦 �긽�깭�븘吏덉궛 理쒖냼移�
				pstmt.setString(14, dto.getLastUptId());// 理쒖쥌�닔�젙�옄
				pstmt.setInt(15, dto.getFarmId());		// �뼇�떇�옣ID
				pstmt.setString(16, dto.getState());	// �긽�깭媛�
				pstmt.setInt(17, dto.getGroupCode());	// �젙蹂� 洹몃９ 肄붾뱶
				pstmt.executeUpdate();
			}
			
			result = 1; //�닔�뻾�씠 �셿猷뚮릺硫� 1�쓣 由ы꽩
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		finally 
		{
			dbcp.close(con, pstmt, rs);
		}
		
		return result;
	}
	
	//--------------------------------------------------------------
	
	/**************************************
	 * @name deleteGrowInfo()
	 * @author �쑄嫄댁＜
	 * @param farmId, groupcode
	 *            -
	 * @return int(�꽦怨듭떆 1, �떎�뙣�떆 0)
	 * @remark �긽�깭湲곗��젙蹂� �궘�젣�븯湲� , 
	 * 		   �궗�슜泥� - growInfo/growInfoPrc.jsp
	 **************************************/
	
	public int deleteGrowInfo(int farmId, int groupcode)
	{
		// DB �뿰寃곗뿉 �븘�슂�븳 蹂��닔
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		ResultSet rs = null;
		
		int result = 0;						// 諛섑솚 蹂��닔
		
		try
		{
			con = dbcp.getConnection();
			
			sql = "delete fish "
					+ "where farmid = ? and groupcode = ? ";
			pstmt = con.prepareStatement(sql);	
			pstmt.setInt(1, farmId);		// �뼇�떇�옣ID
			pstmt.setInt(2, groupcode);	// �젙蹂� 洹몃９ 肄붾뱶
			pstmt.executeUpdate();
			
			result = 1; //�닔�뻾�씠 �셿猷뚮릺硫� 1�쓣 由ы꽩
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		finally 
		{
			dbcp.close(con, pstmt, rs);
		}
		
		return result;
	}
	
	//--------------------------------------------------------------
	   /**************************************
	    * @name fishSelect()
	    * @author �옣�빐由�
	    * @param farmid(int)
	    * @return wtselectlist
	    * @remark �뼇�떇�옣 �젙蹂� �닔�젙�뿉�꽌 �뼱醫� 異쒕젰 - farm/farmwtUpdateForm.jsp
	    **************************************/
	   public ArrayList<growInfoDTO> fishSelect(int farmid) throws NullPointerException, SQLException {

	      ArrayList wtselectlist = new ArrayList();
	      ArrayList fish_list = new ArrayList();
	      Connection con = null;
	      PreparedStatement pstmt = null;
	      ResultSet rs = null;
	      String sql = null;
	      
	      try {
	         con = DBCon.getConnection();
	         // �뼇�떇�옣 �븘�씠�뵒�뿉 留욎� �뼱醫� �씠由� 媛��졇�삤湲�
	         sql = "select distinct f.fishname, f.fishid "
	               + "from watertank w, fish f "
	               + "where w.farmid = ? and w.farmid = f.farmid order by f.fishid ";
	      
	         pstmt = con.prepareStatement(sql);
	         pstmt.setInt(1, farmid);
	         rs = pstmt.executeQuery();

	         while (rs.next()) {
	            growInfoDTO vo = new growInfoDTO();
	            vo.setRemark(rs.getString("fishname"));
	            wtselectlist.add(vo);
	         }

	      } catch (Exception e) {
	         e.printStackTrace();
	      } finally {
	         DBCon.close(con, pstmt, rs);
	      }

	      return wtselectlist;
	   }
	   
	 //--------------------------------------------------------------
	   
	   /**************************************
	    * @name mgrowList()
	    * @author �쑄嫄댁＜
	    * @param farmId
	    *            -
	    * @return ArrayList<growDTO>
	    * @remark (紐⑤컮�씪�슜)�뼇�떇�젙蹂대챸/洹몃９肄붾뱶瑜� 議고쉶
	    *          �궗�슜泥� - mobile/fish/growList.jsp
	    **************************************/
	   
	   public ArrayList<growInfoDTO> mgrowList(int farmId)
	   {
	      // DB �뿰寃곗뿉 �븘�슂�븳 蹂��닔
	      Connection con = null;
	      PreparedStatement pstmt = null;
	      String sql = null;
	      ResultSet rs = null;
	      
	      ArrayList<growInfoDTO> adto = new ArrayList<growInfoDTO>();                  // 諛섑솚 蹂��닔
	      
	      try
	      {
	         con = dbcp.getConnection();
	         
	         sql = "select distinct fishname, groupcode from fish where farmid = ? ";
	         pstmt = con.prepareStatement(sql);
	         pstmt.setInt(1, farmId);
	         rs = pstmt.executeQuery();
	         
	         while(rs.next())
	         {
	            growInfoDTO dto = new growInfoDTO();
	            dto.setFishName(rs.getString("fishname"));
	            dto.setGroupCode(rs.getInt("groupcode"));
	            adto.add(dto);
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
}
