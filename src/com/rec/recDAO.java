
package com.rec;

import java.sql.*;
import java.util.*;

import com.main.*;

public class recDAO {
	DBCon dbcp = new DBCon();
	
	public ArrayList<recDTO> wtRecRet(String farmID) {
	
	   /**************************************
	    * @name wtRetRect
	    * @author Gojian
	    * @param farmID, 
	    * @return �닔議� �젙蹂� rec 
	    * @remark
	    **************************************/
		
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs =null;
		
		String tankCnt = null;
		String countSQL = null;
		String sql = null;
		
		ArrayList<recDTO> wtList = new ArrayList<recDTO>();
		
		try {
			//DB ????
			con =  dbcp.getConnection();
			countSQL = "select count(recseq) as CNT from REC where farmid= ?";
			
			pstmt = con.prepareStatement(countSQL);
			pstmt.setString(1,farmID);
			pstmt.executeUpdate();
			rs = pstmt.executeQuery();
			
			while (rs.next()) {
				recDTO tempbean = new recDTO();
				
				tempbean.setRemark(rs.getString("CNT"));
				wtList.add(tempbean);
			}
			
			sql = "select TANKID, STATE,YRCODE,FISHID,DOREC,WTREC,PHREC,NH4REC,NO2REC,RECSEQ"
					+ " from REC "
					+ " where farmid= ?"
					+ " order by recseq ASC";

			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, farmID);
			pstmt.executeUpdate();
			rs = pstmt.executeQuery();
			
			while (rs.next()) {
				recDTO tempbean = new recDTO();
				tempbean.setTankId(rs.getString("TANKID"));
				tempbean.setState(rs.getString("STATE"));
				tempbean.setYrCode(rs.getString("YRCODE"));
				tempbean.setFishId(rs.getInt("FISHID"));
				tempbean.setDoRec(rs.getDouble("DOREC"));
				tempbean.setWtRec(rs.getDouble("WTREC"));
				tempbean.setPhRec(rs.getDouble("PHREC"));
				tempbean.setNh4Rec(rs.getDouble("NH4REC"));
				tempbean.setNo2Rec(rs.getDouble("NO2REC"));
				tempbean.setRecSeq(rs.getInt("RECSEQ"));
				wtList.add(tempbean);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			dbcp.close(con, pstmt, rs);
	
		}
		return wtList;
	}
	
	//--------------------------------------------------------------
	
		/**************************************
		 * @name RecList()
		 * @author 臾몄씤李�
		 * @param recDTO
		 *            -
		 * @return ArrayList<recDTO>
		 * @remark �빐�떦 �뼇�떇�옣怨� 寃��깋議곌굔�뿉 留욌뒗 �긽�깭湲곕줉 寃��깋
		 * 		   �궗�슜泥� - waterTank/stateRec.jsp
		 **************************************/
		
		public ArrayList<recDTO> RecList(recDTO indto) {
			
			Connection con = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			String sql = null;
			StringUtil str = new StringUtil();
			
			ArrayList<recDTO> adto = new ArrayList<recDTO>();
			
			sql = "select * "
					+ "from "
					+ "(select rownum,to_char(sensordate, 'yyyy-mm-dd hh24:mi') as sensordate, tankid, fishid, state, yrcode, dorec, wtrec, psurec, phrec, nh4rec, no2rec,farmid,recseq  from rec) a, "
					+ "(select distinct fishname, groupcode from fish) b "
					+ "where a.fishid = b.groupcode "
					+ "and rownum >= 1 and rownum <= 10  "
					+ "and a.farmid = " + indto.getFarmId() + " ";
			
			// sensorDate媛� 怨듬갚�씠 �븘�땲硫� sql臾몄뿉 遺숈엫
			if( !indto.getSensorDate().equals("") ) {
				sql += " and " + indto.getSensorDate();
			}
			
			// �닔議곕쾲�샇(tankID) 怨듬갚, null�씠 �븘�땺�떆 異붽�
			if( !indto.getTankId().equals("")) {
				sql += " and tankID like '%" + indto.getTankId() + "%'";
			}
			
			// fishID 怨듬갚, null�씠 �븘�땺�떆 異붽�
			if( !indto.getRemark().equals("")) {
				sql += " and fishName like '%" + indto.getRemark() + "%'";
			}
			
			if(!indto.getState().equals("")) {
				sql += " and state like '%" + indto.getState() + "%'";
			}
			
			System.out.println(sql);
			sql += " order by recseq desc ";
			
			try {
				con =  dbcp.getConnection();
				pstmt = con.prepareStatement(sql);
				rs = pstmt.executeQuery();
				
				while (rs.next()) 
				{
					recDTO outdto = new recDTO();
					outdto.setSensorDate(rs.getString("sensordate"));	// �꽱�꽌 痢≪젙�씪�떆
					outdto.setTankId(rs.getString("tankid"));			// �닔議캧D
					outdto.setRemark(rs.getString("fishname"));			// �긽�깭湲곗��젙蹂대챸
					if(rs.getString("state").equals("G"))				// �긽�깭 媛� 寃곗젙
					{
						outdto.setState("정상");	
					}
					else if(rs.getString("state").equals("Y"))
					{
						outdto.setState("경고");
					}
					else if(rs.getString("state").equals("R"))
					{
						outdto.setState("위험");
					}
					outdto.setYrCode(str.nullToBlank(rs.getString("yrcode")));			// �긽�깭�씠�긽�떆 諛쒖깮 肄붾뱶
					outdto.setDoRec(rs.getDouble("dorec"));				// DO 痢≪젙媛�
					outdto.setWtRec(rs.getDouble("wtrec"));				// WT 痢≪젙媛�
					outdto.setPsuRec(rs.getDouble("psurec"));			// psu 痢≪젙媛�
					outdto.setPhRec(rs.getDouble("phrec"));				// pH 痢≪젙媛�
					outdto.setNh4Rec(rs.getDouble("nh4rec"));			// nh4 痢≪젙媛�
					outdto.setNo2Rec(rs.getDouble("no2rec"));			// no2 痢≪젙媛�
					adto.add(outdto);				
				}
			}
			catch (Exception e) 
			{
				e.printStackTrace();
			} 
			finally 
			{
				dbcp.close(con, pstmt, rs);
			}
			
			return adto;
		}
		
		/**************************************
		 * @name recTableListSize()
		 * @author 臾몄씤李�
		 * @param recDTO
		 *            -
		 * @return ArrayList<recDTO>
		 * @remark stateRec.jsp �럹�씠吏뺤쓣 �쐞�븳 硫붿냼�뱶, 寃��깋�릺�뒗 由ъ뒪�듃 �쟾泥� 媛쒖닔 援ы븿
		 * 		   �궗�슜泥� - waterTank/stateRec.jsp
		 **************************************/
		
		public int recTableListSize() {
	      Connection con = null;
	      PreparedStatement pstmt = null;
	      ResultSet rs = null;
	      String sql = null;
	      
	      int count = 0;
	      
	      try
	      {
	         con = dbcp.getConnection();
	         sql = "select count(*) as cnt from rec ";
	         pstmt = con.prepareStatement(sql);
	         rs = pstmt.executeQuery();
	         
	         if(rs.next())
	         {
	            count = rs.getInt("cnt");
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
	      
	      return count;
	   }
		
}
