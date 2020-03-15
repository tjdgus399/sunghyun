/* [+] 2019.08.11
 * index.jsp ~ main.jsp 

 * */
package com.main;

import java.sql.*;
import java.text.*;
import java.util.ArrayList;

import com.farm.*;

public class mainDAO {

	DBCon dbcp = new DBCon();


	/*
	 * @Method : getFarmInfo
	 * 
	 * @author : Gojian
	 * 
	 * @param : User ID ( Session_ID ) -
	 * 
	 * @return : ArrayList<mainBeans>
	 * 
	 * @remark : mainPrc.jsp return to FarmId,FarmName
	 */

	public ArrayList<farmDTO> getFarmInfo(String UserID) {

		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		ResultSet rs = null;

		ArrayList<farmDTO> farm_List = new ArrayList<farmDTO>();
		try {
			con = dbcp.getConnection();

			// 양식장 ID,양식장 이름을 얻기 위한 SQL 쿼리
			sql = "select farmid,farmname from farm where userID = ? ";

			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, UserID);

			rs = pstmt.executeQuery();

			while (rs.next()) {
				farmDTO beans = new farmDTO();
				beans.setFarmId(Integer.parseInt(rs.getString(1)));
				beans.setFarmName(rs.getString(2));
				farm_List.add(beans);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			dbcp.close(con, pstmt, rs);
		}

		return farm_List;
	}

	/*
	 * @Date : 2019.08.13
	 * @Method : getTankCnt
	 * @author : Gojian
	 * @param : farmID
	 * @return : tankCnt 수조갯수
	 * @remark : "searchwtREC.java"
	 */

	public String getTankCnt(String farmID) {

		String tankCnt = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		ResultSet rs = null;
		int farid_Int = Integer.parseInt(farmID);

		try {
			con = dbcp.getConnection();

			sql = "select count(*) from watertank where farmid=?";

			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, farid_Int);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				tankCnt = Integer.toString(rs.getInt(1));
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			dbcp.close(con, pstmt, rs);
		}

		return tankCnt;
	}

}
