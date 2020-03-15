package com.repair;

import java.sql.*;
import java.util.*;
import com.main.*;

public class repairDAO {
	DBCon dbcp = new DBCon();
	
	public String retRepSeq(String farmID, String tankID) {

		// --------------------------------------------------------------

		   /**************************************
		    * @name retRepSeq
		    * @author Gojian
		    * @param farmID, tanKID
		    * @return String "議곗튂媛� �셿猷뚮릺�뿀�뒿�땲�떎" or ""
		    * @remark
		    **************************************/
		
		Connection con = null;
		String countSQL = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		String Counter1 = null;
		String Counter2 = null;

		int TypeToFarmID = Integer.parseInt(farmID);
		try {

			con = DBCon.getConnection();
			countSQL = "select COUNT(*) COMPARE from  repair where farmid=? and tankid= ? "
					+ " union ALL " 
					+ " select COUNT(*) COMPARE from  repair as of TIMESTAMP(SYSTIMESTAMP-INTERVAL '10' SECOND)  where farmid=? and tankid=?";

			pstmt = con.prepareStatement(countSQL);

			pstmt.setInt(1, TypeToFarmID);
			pstmt.setString(2, tankID);
			pstmt.setInt(3, TypeToFarmID);
			pstmt.setString(4, tankID);

			rs = pstmt.executeQuery();

			rs.next();
			Counter1 = rs.getString(1);
			rs.next();
			Counter2 = rs.getString(1);

	
			int Counter_1 = Integer.parseInt(Counter1);
			int Counter_2 = Integer.parseInt(Counter2);
			
			if (Counter_1 != Counter_2) {
				return "議곗튂媛� �셿猷뚮릺�뿀�뒿�땲�떎.";
				
			} else {
				return "";
			}

			
		} catch (

		Exception e) {
			e.printStackTrace();
		} finally {
			DBCon.close(con, pstmt, rs);
		}
		return "";
	}
	
	//--------------------------------------------------------------
	
	/**************************************
	 * @name 	repairInsert()  (議곗튂�궗�빆 �엯�젰)
	 * @author	諛뺤쭊�썑 
	 * @param	repairID(�닔�젙�옄 ID), repairContents(議곗튂�궡�슜), recSeq(湲곕줉踰덊샇) 
	 * 
	 * @return 	void
	 * @remark 	select 臾몄쓣 �넻�빐 議곗튂�븷 遺�遺꾩쓽 湲곕줉�쓣 諛쏆븘���꽌 議곗튂�궡�슜怨� �븿猿� �깉濡� 議곗튂湲곕줉�쓣 �엯�젰�븳�떎.
	 * 			�궗�슜泥� - waterTank/wtCautionPrc.jsp
	 **************************************/
	
	public void repairInsert(String repairID, String repairContents, String recSeq)	throws NullPointerException, SQLException {		
		// DB�뿰寃� 媛앹껜
		Connection con = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;
		String sql = null;
		String sql2 = null;

		int i;

		try {			
			con = DBCon.getConnection();			
			//reseq�뿉 留욌뒗 議곗튂 湲곕줉�쓣 諛쏅뒗�떎
			sql = "select recseq, tankid, farmid, fishid, state, yrcode, sensordate, regdate, regid from repair where recseq = ? ";
			pstmt = con.prepareStatement(sql);
			
			pstmt.setString(1, recSeq);
			
			rs = pstmt.executeQuery();
			
			//湲곗〈�쓽 �엳�뜕 �궡�슜�쓣 �넗��濡� 議곗튂�궡�슜怨� �닔�젙�옄瑜� 異붽��븯�뿬 repair湲곕줉�쓣 異붽�
			sql2 = " insert into repair(repairseq, recseq, tankid, farmid, fishid, state, yrcode, sensordate, regdate, regid, lastuptdate, lastuptid, repairid, repaircontents)"
					+ "values(repairseq.nextval, ?, ?, ?, ?, ?, ?, ?, ?, ?, sysdate, ?, ?, ?)";

			pstmt2 = con.prepareStatement(sql2);
			
			//sql�뿉�꽌 諛쏆� 媛믩뱾�쓣 sql2�뿉 �엯�젰
			if (rs.next()) 
			{
				for (i = 1; i < 10; i++)
				{
					if (i == 7 || i == 8)
					{
						pstmt2.setDate(i, rs.getDate(i));
					} 
					else
					{
						pstmt2.setString(i, rs.getString(i));						
					}

				}
			}

			pstmt2.setString(10, repairID);
			pstmt2.setString(11, repairID);
			pstmt2.setString(12, repairContents);
			pstmt2.executeUpdate();

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			// �뿰寃� �걡湲�
			DBCon.close(con, pstmt, rs);
			DBCon.close(con, pstmt2, rs);
		}

	}
	
	//--------------------------------------------------------------
	
	/**************************************
	 * @name repairRec()
	 * @author 臾몄씤李�
	 * @param repairDTO
	 *            -
	 * @return ArrayList<repairDTO>
	 * @remark �빐�떦 �뼇�떇�옣怨� 寃��깋議곌굔�뿉 留욌뒗 議곗튂湲곕줉 寃��깋
	 * 		   �궗�슜泥� - waterTank/repairRec.jsp
	 **************************************/
	
	public ArrayList<repairDTO> repairRec(repairDTO indto) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		
		ArrayList<repairDTO> adto = new ArrayList<repairDTO>();
		StringUtil str = new StringUtil();
		
		sql = "select repairseq, recSeq, tankid, fishname, state ,yrcode, "
				+ "to_char(sensordate, 'yyyy-mm-dd hh24:mi') as sensordate, repaircontents, "
				+ "lastuptid, to_char(lastuptdate, 'yyyy-mm-dd hh24:mi') as lastuptdate "
				+ "from repair r, (select distinct groupcode, fishname from fish) f "
				+ "where r.fishId = f.groupcode and farmId = " + indto.getFarmId() + " ";
		
		// sensorDate媛� 怨듬갚�씠 �븘�땲硫� sql臾몄뿉 遺숈엫
		if( !indto.getSensorDate().equals("") ) {
			sql += " and " + indto.getSensorDate();
		}
		
		// regDate媛� 怨듬갚�씠 �븘�땲硫� sql臾몄뿉 遺숈엫
		if( !indto.getLastUptdate().equals("") ) {
			sql += " and " + indto.getLastUptdate();
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
		
		sql += " order by repairseq desc ";
		
		try {
			con =  dbcp.getConnection();
			pstmt = con.prepareStatement(sql);
			rs = pstmt.executeQuery();
			
			while (rs.next()) 
			{
				repairDTO outdto = new repairDTO();
				outdto.setRepairSeq(rs.getInt("repairseq"));
				outdto.setRecSeq(rs.getInt("recseq"));
				outdto.setTankId(rs.getString("tankid"));
				outdto.setRemark(rs.getString("fishname"));
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
				outdto.setYrCode(rs.getString("yrcode"));
				outdto.setSensorDate(rs.getString("sensordate"));
				outdto.setRepairContents(str.nullToBlank(rs.getString("repaircontents")));
				outdto.setLastUptId(str.nullToBlank(rs.getString("lastuptid")));
				outdto.setLastUptdate(rs.getString("lastuptdate"));
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
	
	//--------------------------------------------------------------
	
	/**************************************
	 * @name getRepairContents
	 * @author 臾몄씤李�
	 * @param repairSeq, recSeq
	 *            -
	 * @return String
	 * @remark 湲� repairContents �궡�슜�씠 �엳�쓣 �닔�룄 �엳�뼱�꽌 repairSeq, recSeq瑜� 諛쏆븘�꽌 �뵲濡� 戮묒븘�샂
	 * 		   �궗�슜泥� - waterTank/wtCautionUpdateForm.jsp
	 **************************************/
	
	public String getRepairContents(int repairSeq, int recSeq) throws NullPointerException, SQLException {
		PreparedStatement psmt = null;
		ResultSet rs = null;
		Connection con = null;
		String sql = null;
		String contents = null;
		StringUtil str = new StringUtil();
		
		try {
			con = DBCon.getConnection();
			sql = "select repaircontents from repair where repairSeq = ? and recSeq = ?";
			
			psmt = con.prepareStatement(sql);
			psmt.setInt(1, repairSeq);
			psmt.setInt(2, recSeq);
			rs = psmt.executeQuery();
			
			while(rs.next()) {
				contents = rs.getString("repaircontents");
				contents = str.nullToBlank(contents);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally{
			DBCon.close(con, psmt, rs);
		}
		
		return contents;
	}
	
	//--------------------------------------------------------------
	
	/**************************************
	 * @name repairContentsUpdate
	 * @author 臾몄씤李�
	 * @param repairSeq, recSeq, contents
	 *            -
	 * @return 
	 * @remark repairContents �뾽�뜲�씠�듃 �슜�룄
	 * 		   �궗�슜泥� - waterTank/wtCautionUpdatePrc.jsp
	 **************************************/
	
	public void repairContentsUpdate(int repairSeq, int recSeq, String contents) throws NullPointerException, SQLException {
		PreparedStatement psmt = null;
		ResultSet rs = null;
		Connection con = null;
		String sql = null;
		
		try {
			con = DBCon.getConnection();
			sql = "update repair set repaircontents = ?, lastuptdate = sysdate where repairSeq = ? and recSeq = ? ";

			psmt = con.prepareStatement(sql);
			psmt.setString(1, contents);
			psmt.setInt(2, repairSeq);
			psmt.setInt(3, recSeq);
			
			psmt.executeUpdate();

		} catch (Exception e) {
			e.printStackTrace();
		} finally{
			DBCon.close(con, psmt, rs);
		}
	}
	
}
