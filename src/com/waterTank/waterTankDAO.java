package com.waterTank;

import java.sql.*;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.Date;

import com.farm.*;
import com.main.*;
import com.rec.*;
import com.repair.*;

public class waterTankDAO {

			DBCon dbcp = new DBCon();

			/*
			 * @Date : 2019.08.13
			 * 
			 * @Method : getTankCnt
			 * 
			 * @author : Gojian
			 * 
			 * @param : 
			 * 
			 * @return :
			 * 
			 * @remark : "searchwtREC.java
			 */

			public String getTankCnt(String farmID) {

				Connection con = null;
				PreparedStatement pstmt = null;
				String sql = null;

				String tankCnt = null;

				ResultSet rs = null;
				int farid_Int = Integer.parseInt(farmID);

				try {
					con = dbcp.getConnection();

					sql = "select count(*) from rec where farmid=?";

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
			
			/**************************************
			 * @name wtRecPrint()
			 * @author
			 * @param farmID,tankID,fishID,state,sensorFromDate,sensorToDate
			 *            -
			 * @return ArrayList<wtBeans>
			 * @remark wtRec.jsp 
			 **************************************/

			public ArrayList<recDTO> wtRecPrint( 
					String farmID, String tankID, 
					String fishName, String state,
					String sensorFromDate, String sensorToDate) throws NullPointerException, SQLException
			{
				PreparedStatement psmt = null;
				ResultSet rs = null;
				Connection con = null;
				StringBuilder sql = new StringBuilder();
				
				ArrayList<recDTO> dto = new ArrayList<>(); // recDTO 
				
				try {
					// db 
					con = DBCon.getConnection();
					
					sql.append("select tankID, sensordate,"
							+ " f.fishname, r.state, yrCode, DOrec,"
							+ " WTrec, PSUrec, pHrec, NH4rec, NO2rec"
							+ " from fish f, rec r "
							+ " WHERE r.farmID = "+farmID
							+ " and r.fishid = f.fishid");

					if( !sensorFromDate.equals("") && !sensorToDate.equals("") ){
						sql.append(" and r.sensordate between '"+sensorFromDate+"' and '"+sensorToDate+"'");
					}
					
					if( !tankID.equals("")) {
						sql.append(" and tankID like '%"+tankID+"%'");
					}
					
					if( !fishName.equals("")) {
						sql.append(" and fishName like '%"+fishName+"%'");
					}
					
					if(!state.equals("")) {
						sql.append(" and r.state like '%"+state+"%'");
					}
					 
					sql.append(" order by r.sensordate desc");
					psmt = con.prepareStatement(sql.toString());
					
					rs = psmt.executeQuery();
					
					while(rs.next()) {
						recDTO vo = new recDTO();
						
						vo.setTankId(rs.getString("tankID"));
						vo.setSensorDate(dateFormating(rs.getString("sensordate")));
						vo.setRemark(rs.getString("fishName")); // fishName ���옣
						vo.setYrCode(stringNullCheck(rs.getString("yrCode")));
						vo.setDoRec(rs.getDouble("DOrec"));
						vo.setWtRec(rs.getDouble("WTrec"));
						vo.setPsuRec(rs.getDouble("PSUrec"));
						vo.setPhRec(rs.getDouble("pHrec"));
						vo.setNh4Rec(rs.getDouble("NH4rec"));
						vo.setNo2Rec(rs.getDouble("NO2rec"));
					
						dto.add(vo);
					}
					
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} finally {
					DBCon.close(con, psmt, rs);
				}
				
				return dto;
			}
			
			
			
			/**************************************
			 * @name wtUpdateFormPrint()
			 * @author 
			 * @param farmID,tankID,fishID,state,sensorFromDate,sensorToDate,regFromDate,regToDate
			 *            -
			 * @return ArrayList<wtBeans>
			 * @remark wtUpdateForm.jsp 
			 **************************************/
			
			public ArrayList<repairDTO> wtUpdateFormPrint(
					String farmID, String tankID, 
					String fishName, String state,
					String sensorFromDate, String sensorToDate,
					String regFromDate, String regToDate) throws NullPointerException, SQLException
			{ 
				PreparedStatement psmt = null;
				ResultSet rs = null;
				Connection con = null;
				StringBuilder sql = new StringBuilder();
				
				ArrayList<repairDTO> dto = new ArrayList<>(); // recDTO 
				
				try {
					con = DBCon.getConnection();
					
					sql.append("select r.repairseq, r.recseq,"
							+ "r.sensordate, r.regdate, r.tankID, "
							+ "f.fishname, r.state, r.yrcode, "
							+ "r.repairID, r.repaircontents "
							+ "from repair r, fish f "
							+ "where r.farmID = "+farmID+" and r.fishID = f.fishID");
					
					if( !sensorFromDate.equals("") && !sensorToDate.equals("") ){
						sql.append(" and r.sensordate between '"+sensorFromDate+"' and '"+sensorToDate+"'");
					}
					
					if( !regFromDate.equals("") && !regToDate.equals("") ){
						sql.append(" and r.regdate between '"+regFromDate+"' and '"+regToDate+"'");
					}
					
					if( !tankID.equals("")) {
						sql.append(" and tankID like '%"+tankID+"%'");
					}
					
					if( !fishName.equals("")) {
						sql.append(" and fishName like '%"+fishName+"%'");
					}
					
					// state
					if(!state.equals("")) {
						sql.append(" and r.state like '%"+state+"%'");
					}
					
					 
					sql.append(" order by r.sensordate desc");
					
					psmt = con.prepareStatement(sql.toString());
					rs = psmt.executeQuery();
					
					while(rs.next()) {
						repairDTO vo = new repairDTO();
						
						vo.setRepairSeq(rs.getInt("repairseq"));
						vo.setRecSeq(rs.getInt("recseq"));
						vo.setSensorDate(dateFormating(rs.getString("sensorDate")));
						vo.setRegDate(dateFormating(rs.getString("regDate")));
						vo.setTankId(rs.getString("tankID"));
						vo.setRemark(rs.getString("fishName"));
						vo.setYrCode(stringNullCheck(rs.getString("yrcode")));
						vo.setRepairId(stringNullCheck(rs.getString("repairid")));
						vo.setRepairContents(stringNullCheck(rs.getString("repaircontents")));
								
						dto.add(vo);
					}
					
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} finally {
					DBCon.close(con, psmt, rs);
				}
				
				return dto;
			}
			
			
			/**************************************
			 * @name dateFormaing
			 * @author 
			 * @param forFomating
			 *            -
			 * @return String
			 * @remark wtRec.jsp 諛� wtUpdateForm.jsp 
			 **************************************/
			
			public String dateFormating(String forFomating) {
				String oldDate,newDate = null;
				Date date;
				
				oldDate = forFomating;
				
				try {
					date = new SimpleDateFormat("yyyy-MM-dd HH:mm").parse(oldDate);
					// date -> String 
					newDate = new SimpleDateFormat("yyyy-MM-dd HH:mm").format(date);
				} catch (ParseException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				
				return newDate;
			}
			

			/**************************************
		    * @name    repairInsert
		    * @author    
		    * @param    repairID, repairContents, recSeq
		    * 
		    * @return    
		    * @remark  wtCautionPrc.jsp
			**************************************/

			public void repairInsert(String repairID, String repairContents, String recSeq)
					throws NullPointerException, SQLException {
				PreparedStatement psmt = null;
				ResultSet rs = null;
				Connection con = null;
				String sql = null;
				
				try {
						con = DBCon.getConnection();
						sql = " update repair set repairID = ?, repairContents = ?, lastUptDate = sysdate, lastUptID = ? where recSeq = ? ";

						psmt = con.prepareStatement(sql);
						psmt.setString(1, repairID);
						psmt.setString(2, repairContents);
						psmt.setString(3, repairID);
						psmt.setString(4, recSeq);
						
						psmt.executeUpdate();

				} catch (Exception e) {
					e.printStackTrace();
				} finally{
					DBCon.close(con, psmt, rs);
				}
			}
			
			/**************************************
			 * @name getRepairContents
			 * @author 
			 * @param repairSeq
			 *            -
			 * @return String
			 * @remark wtCautionUpdateForm.jsp
			 **************************************/
			
			public String getRepairContents(String repairSeq) throws NullPointerException, SQLException {
				PreparedStatement psmt = null;
				ResultSet rs = null;
				Connection con = null;
				String sql = null;
				String contents = null;
				
				try {
					con = DBCon.getConnection();
					sql = "select repaircontents from repair where repairSeq = ?";
					
					psmt = con.prepareStatement(sql);
					psmt.setString(1, repairSeq);
					rs = psmt.executeQuery();
					
					while(rs.next()) {
						contents = rs.getString("repaircontents");
						contents = stringNullCheck(contents);
					}
					
				} catch (Exception e) {
					e.printStackTrace();
				} finally{
					DBCon.close(con, psmt, rs);
				}
				
				return contents;
			}
			
			/**************************************
			 * @name repairContentsUpdate
			 * @author
			 * @param repairSeq, contents
			 *            -
			 * @return 
			 * @remark wtCautionUpdateFormPrc.jsp 
			 **************************************/
			
			public void repairContentsUpdate(String repairSeq, String contents) throws NullPointerException, SQLException {
				PreparedStatement psmt = null;
				ResultSet rs = null;
				Connection con = null;
				String sql = null;
				
				try {
					con = DBCon.getConnection();
					sql = "update repair set repaircontents = ?, lastuptdate = sysdate where repairSeq = ? ";

					psmt = con.prepareStatement(sql);
					psmt.setString(1, contents);
					psmt.setString(2, repairSeq);
					
					psmt.executeUpdate();

				} catch (Exception e) {
					e.printStackTrace();
				} finally{
					DBCon.close(con, psmt, rs);
				}
			}
			
			/**************************************
			 * @name stringNullCheck
			 * @author 
			 * @param check
			 *            -
			 * @return String
			 * @remark rec, repair 
			 **************************************/
			
			public String stringNullCheck(String check) {
				if( "".equals(check) || check == null || "null".equals(check) ) {
					check = " ";
					return check;
				}else {
					return check;
				}
			}
			

			   /**************************************
			    * @name waterTankSelect()
			    * @author
			    * @param tankID, farmid
			    * @return ArrayList
			    * @remark  - farm/farmwtUpdateForm.jsp
			    **************************************/
			   public ArrayList waterTankSelect(String tankID, int farmid) throws NullPointerException, SQLException {

			      ArrayList wtselectlist = new ArrayList();
			      Connection con = null;
			      PreparedStatement pstmt = null;
			      ResultSet rs = null;

			      try {
			         con = DBCon.getConnection();
			         String sql = " select w.tankid, nvl(f.fishname, ' ') as fishname, nvl(w.userid,' ') "
			         		+ "as userid, nvl(w.dosensor,' ') as dosensor, nvl(w.phsensor,' ') "
			         		+ "as phsensor, nvl(w.psusensor, ' ') as psusensor, nvl(w.wtsensor, ' ') as wtsensor,"
			               + " nvl(w.nh4sensor, ' ') as nh4sensor , nvl(w.no2sensor, ' ' ) as no2sensor "
			               + "from watertank w, fish f where w.farmid = ? and w.farmid = f.farmid and f.fishid = w.fishid and w.tankid = ? ";

			         pstmt = con.prepareStatement(sql);
			         pstmt.setInt(1, farmid);
			         pstmt.setString(2, tankID);
			         rs = pstmt.executeQuery();

			         while (rs.next()) {
			            waterTankDTO vo = new waterTankDTO();
			            vo.setTankId(rs.getString("tankid"));
			            vo.setRemark(rs.getString("fishname"));
			            vo.setUserId(rs.getString("userid"));
			            vo.setDoSensor(rs.getString("dosensor"));
			            vo.setPhSensor(rs.getString("phsensor"));
			            vo.setPsuSensor(rs.getString("psusensor"));
			            vo.setWtSensor(rs.getString("wtsensor"));
			            vo.setNh4Sensor(rs.getString("nh4sensor"));
			            vo.setNo2Sensor(rs.getString("no2sensor"));

			            wtselectlist.add(vo);
			         }

			      } catch (Exception e) {
			         e.printStackTrace();
			      } finally {
			         DBCon.close(con, pstmt, rs);
			      }

			      return wtselectlist;
			   }
			
			   /**************************************
			    * @name waterTankUpdate()
			    * @author 
			    * @param tankID, fishName, userID, DOSensor, pHSensor, psuSensor, WTSensor,
			    *                NH4Sensor, NO2Sensor, Session_ID, farmid
			    * @return void
			    * @remark  farm/farmwtUpdatePrc.jsp
			    **************************************/

			   public void waterTankUpdate(String tankID, String fishName, String userID, String DOSensor, String pHSensor,
			         String psuSensor, String WTSensor, String NH4Sensor, String NO2Sensor, String Session_ID, int farmid)
			         throws NullPointerException, SQLException {

			      Connection con=null;
			      PreparedStatement pstmt = null;
			      ResultSet rs = null;
			      String sql = "";

			      try {
			         con = DBCon.getConnection();
			         String sql2 = " select f.fishid from fish f, waterTank w where w.farmid = ? and w.farmid = f.farmid and f.fishname = ? ";

			         pstmt = con.prepareStatement(sql2);
			         pstmt.setInt(1, farmid);
			         pstmt.setString(2, fishName);
			         rs = pstmt.executeQuery();

			         int fishid = 0;

			         if (rs.next()) {
			            fishid = rs.getInt("fishid");

			         }
			         sql = " update waterTank "
			               + "set farmID = ?, lastUptDate = sysdate, lastUptID = ?,  fishid = ?, userID = ?, DOSensor = ?, "
			               + "pHSensor = ?, psuSensor = ? , WTSensor = ?, NH4Sensor = ?, NO2Sensor = ? where tankID = ? and farmID = ? ";

			         pstmt = con.prepareStatement(sql);

			         pstmt.setInt(1, farmid);
			         pstmt.setString(2, Session_ID);
			         pstmt.setInt(3, fishid);
			         pstmt.setString(4, userID);
			         pstmt.setString(5, DOSensor);
			         pstmt.setString(6, pHSensor);
			         pstmt.setString(7, psuSensor);
			         pstmt.setString(8, WTSensor);
			         pstmt.setString(9, NH4Sensor);
			         pstmt.setString(10, NO2Sensor);
			         pstmt.setString(11, tankID);
			         pstmt.setInt(12, farmid);
			         pstmt.executeUpdate();

			      } catch (Exception e) {

			         e.printStackTrace();

			      } finally {
			         DBCon.close(con, pstmt, rs);
			      }

			   }
			   
			   /***********************************
			    * @name    waterTankSearch
			    * @author  Hwang Seon Ju
			    * @param   ID, search, searchinput
			    * @return  ArrayList<waterTankTableDTO>
			    * @remark- farmwtSearch.jsp
			    ***********************************/

			   public ArrayList<waterTankDTO> waterTankSearch(String ID, String search, String searchinput) throws NullPointerException, SQLException {
			      Connection con = null;
			      PreparedStatement pstmt = null;
			      ResultSet rs = null;
			      String sql1 = null;
			      String sql2 = null;
			      ArrayList<waterTankDTO> wtlist = new ArrayList<waterTankDTO>();

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

			         sql2 = "select w.tankid, f.fishname, nvl(w.userid, ' ') as userid, nvl(w.dosensor, ' ') as dosensor, nvl(w.phsensor, ' ') as phsensor, nvl(w.psusensor, ' ') as psusensor, nvl(w.wtsensor, ' ') as wtsensor, nvl(w.nh4sensor, ' ') as nh4sensor, nvl(w.no2sensor, ' ') as no2sensor, w.lastuptid, "
			               + " to_char(w.lastuptdate, 'YY/MM/DD HH24:MI:SS') as lastuptdate from watertank w, fish f where w.farmid = ? "
			               + " and w.farmid = f.farmid and f.fishid = w.fishid";

			         if (searchinput != null && !searchinput.equals("") && search != "null" && !search.equals("null")) {
			            sql2 += " and w." + search.trim() + " LIKE '%" + searchinput.trim() + "%' order by w.tankid";
			         } else {
			            sql2 += " order by w.tankid";
			         }

			         pstmt = con.prepareStatement(sql2);
			         pstmt.setString(1, farmid);
			         rs = pstmt.executeQuery();

			         while (rs.next()) {
			            // watertank DTO
			            waterTankDTO vo = new waterTankDTO();
			            vo.setTankId(rs.getString("tankid"));
			            vo.setRemark(rs.getString("fishname"));
			            vo.setUserId(rs.getString("userid"));
			            vo.setDoSensor(rs.getString("dosensor"));
			            vo.setPhSensor(rs.getString("phsensor"));
			            vo.setPsuSensor(rs.getString("psusensor"));
			            vo.setWtSensor(rs.getString("wtsensor"));
			            vo.setNh4Sensor(rs.getString("nh4sensor"));
			            vo.setNo2Sensor(rs.getString("no2sensor"));
			            vo.setLastUptId(rs.getString("lastuptid"));
			            vo.setLastUptdate(rs.getString("lastuptdate"));
			            wtlist.add(vo);
			         }
			      } catch (NumberFormatException e) {
			         e.printStackTrace();
			      } finally {
			         DBCon.close(con, pstmt, rs);
			      }

			      return wtlist;

			   }

			   /***********************************
			    * @name    waterTankSearch
			    * @author  Hwang Seon Ju
			    * @param   farmid, search, searchinput
			    * @return  ArrayList<waterTankTableDTO>
			    * @remark  
			    ***********************************/

			   public ArrayList<waterTankDTO> waterTankSearch(int farmid, String search, String searchinput) throws NullPointerException, SQLException {
			      Connection con = null;
			      PreparedStatement pstmt = null;
			      ResultSet rs = null;
			      String sql2 = null;
			      ArrayList<waterTankDTO> wtlist = new ArrayList<waterTankDTO>();

			      try {
			         con = DBCon.getConnection();
			         sql2 = "select w.tankid, f.fishname, nvl(w.userid, ' ') as userid, nvl(w.dosensor, ' ') as dosensor, nvl(w.phsensor, ' ') as phsensor, nvl(w.psusensor, ' ') as psusensor, nvl(w.wtsensor, ' ') as wtsensor, nvl(w.nh4sensor, ' ') as nh4sensor, nvl(w.no2sensor, ' ') as no2sensor, w.lastuptid, "
			               + " to_char(w.lastuptdate, 'YY/MM/DD HH24:MI:SS') as lastuptdate from watertank w, fish f where w.farmid = ? "
			               + " and w.farmid = f.farmid and f.fishid = w.fishid";

			         if (searchinput != null && !searchinput.equals("") && search != "null" && !search.equals("null")) {
			            sql2 += " and w." + search.trim() + " LIKE '%" + searchinput.trim() + "%' order by w.tankid";
			            
			         } else {
			            sql2 += " order by w.tankid";
			         }

			         pstmt = con.prepareStatement(sql2);
			         pstmt.setInt(1, farmid);
			         rs = pstmt.executeQuery();

			         while (rs.next()) {
			            waterTankDTO vo = new waterTankDTO();
			            vo.setTankId(rs.getString("tankid"));
			            vo.setRemark(rs.getString("fishname"));
			            vo.setUserId(rs.getString("userid"));
			            vo.setDoSensor(rs.getString("dosensor"));
			            vo.setPhSensor(rs.getString("phsensor"));
			            vo.setPsuSensor(rs.getString("psusensor"));
			            vo.setWtSensor(rs.getString("wtsensor"));
			            vo.setNh4Sensor(rs.getString("nh4sensor"));
			            vo.setNo2Sensor(rs.getString("no2sensor"));
			            vo.setLastUptId(rs.getString("lastuptid"));
			            vo.setLastUptdate(rs.getString("lastuptdate"));
			            wtlist.add(vo);
			         }

			      } catch (NumberFormatException e) {
			         e.printStackTrace();
			      } finally {
			         DBCon.close(con, pstmt, rs);
			      }
			      return wtlist;
			   }

			   /***********************************
			    * @name    waterTankDelete
			    * @author  Hwang Seon Ju
			    * @param   tankID, ID
			    * @return  void
			    * @remark   - farmwtDeletePrc.jsp
			    ***********************************/

			   public void waterTankDelete(String tankID, int farmid, String ID) throws NullPointerException, SQLException {
			      Connection con = null;
			      PreparedStatement pstmt = null;
			      ResultSet rs = null;
			      String sql1 = null;
			      String sql2 = null;

			      try {
			         con = DBCon.getConnection();
			         sql2 = " Delete watertank where farmid = ? and tankid = ?";

			         pstmt = con.prepareStatement(sql2);
			         pstmt.setInt(1, farmid);
			         pstmt.setString(2, tankID);
			         rs = pstmt.executeQuery();

			      } catch (SQLException e) {
			         e.printStackTrace();
			      } finally {
			         DBCon.close(con, pstmt, rs);
			      }
			   }
			   
			   /**********************************
				 * @name   waterTankInsert
				 * @author 
				 * @param  watertankDTO, fishName, ID
				 * 				-
				 * @return 
				 * @remark  -farmwtInsertForm.jsp
				 ***********************************/
				public void waterTankInsert(waterTankDTO bean, String fishName, String ID, int farmid, String userid)
						throws NullPointerException, SQLException {

					ResultSet rs = null;
					Connection con = null;
					PreparedStatement pstmt = null;
					String sql = "";
					con = DBCon.getConnection();

					try {
						String sql1 = " select f.fishid from fish f, waterTank w where w.farmid = ? and w.farmid = f.farmid and f.fishname = ? ";

						pstmt = con.prepareStatement(sql1);
						pstmt.setInt(1, farmid);
						pstmt.setString(2, fishName);
				
						rs = pstmt.executeQuery();

						int fishId = 0;
						
						if (rs.next()) {
							fishId = rs.getInt("fishid");
						}

						String sql2= "insert into WATERTANK(farmid, tankid, userid, fishid, dosensor, phsensor, psusensor, wtsensor, nh4sensor, no2sensor, regid, REGDATE, lastuptdate, lastuptid) "
								+ "values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, sysdate, sysdate,?)";

						pstmt = con.prepareStatement(sql2);
						pstmt.setInt(1, farmid);
						pstmt.setString(2, bean.getTankId());
						pstmt.setString(3, userid);
						pstmt.setInt(4, fishId);
						pstmt.setString(5, bean.getDoSensor());
						pstmt.setString(6, bean.getPhSensor());
						pstmt.setString(7, bean.getPsuSensor());
						pstmt.setString(8, bean.getWtSensor());
						pstmt.setString(9, bean.getNh4Sensor());
						pstmt.setString(10, bean.getNo2Sensor());
						pstmt.setString(11, ID);
						pstmt.setString(12, ID);
						System.out.println(ID);
						pstmt.executeUpdate();

					} catch (Exception e) {
						e.printStackTrace();
					} finally {
						DBCon.close(con, pstmt, rs);
					}
				}
}
