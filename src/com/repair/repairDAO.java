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
		    * @return String "조치가 완료되었습니다" or ""
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
				return "조치가 완료되었습니다.";
				
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
	 * @name 	repairInsert()  (조치사항 입력)
	 * @author	박진후 
	 * @param	repairID(수정자 ID), repairContents(조치내용), recSeq(기록번호) 
	 * 
	 * @return 	void
	 * @remark 	select 문을 통해 조치할 부분의 기록을 받아와서 조치내용과 함께 새로 조치기록을 입력한다.
	 * 			사용처 - waterTank/wtCautionPrc.jsp
	 **************************************/
	
	public void repairInsert(String repairID, String repairContents, String recSeq)	throws NullPointerException, SQLException {		
		// DB연결 객체
		Connection con = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;
		String sql = null;
		String sql2 = null;

		int i;

		try {			
			con = DBCon.getConnection();			
			//reseq에 맞는 조치 기록을 받는다
			sql = "select recseq, tankid, farmid, fishid, state, yrcode, sensordate, regdate, regid from repair where recseq = ? ";
			pstmt = con.prepareStatement(sql);
			
			pstmt.setString(1, recSeq);
			
			rs = pstmt.executeQuery();
			
			//기존의 있던 내용을 토대로 조치내용과 수정자를 추가하여 repair기록을 추가
			sql2 = " insert into repair(repairseq, recseq, tankid, farmid, fishid, state, yrcode, sensordate, regdate, regid, lastuptdate, lastuptid, repairid, repaircontents)"
					+ "values(repairseq.nextval, ?, ?, ?, ?, ?, ?, ?, ?, ?, sysdate, ?, ?, ?)";

			pstmt2 = con.prepareStatement(sql2);
			
			//sql에서 받은 값들을 sql2에 입력
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
			// 연결 끊기
			DBCon.close(con, pstmt, rs);
			DBCon.close(con, pstmt2, rs);
		}

	}
	
	//--------------------------------------------------------------
	
	/**************************************
	 * @name repairRec()
	 * @author 문인찬
	 * @param repairDTO
	 *            -
	 * @return ArrayList<repairDTO>
	 * @remark 해당 양식장과 검색조건에 맞는 조치기록 검색
	 * 		   사용처 - waterTank/repairRec.jsp
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
		
		// sensorDate가 공백이 아니면 sql문에 붙임
		if( !indto.getSensorDate().equals("") ) {
			sql += " and " + indto.getSensorDate();
		}
		
		// regDate가 공백이 아니면 sql문에 붙임
		if( !indto.getLastUptdate().equals("") ) {
			sql += " and " + indto.getLastUptdate();
		}
		
		// 수조번호(tankID) 공백, null이 아닐시 추가
		if( !indto.getTankId().equals("")) {
			sql += " and tankID like '%" + indto.getTankId() + "%'";
		}
		
		// fishID 공백, null이 아닐시 추가
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
				if(rs.getString("state").equals("G"))				// 상태 값 결정
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
	 * @author 문인찬
	 * @param repairSeq, recSeq
	 *            -
	 * @return String
	 * @remark 긴 repairContents 내용이 있을 수도 있어서 repairSeq, recSeq를 받아서 따로 뽑아옴
	 * 		   사용처 - waterTank/wtCautionUpdateForm.jsp
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
	 * @author 문인찬
	 * @param repairSeq, recSeq, contents
	 *            -
	 * @return 
	 * @remark repairContents 업데이트 용도
	 * 		   사용처 - waterTank/wtCautionUpdatePrc.jsp
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
