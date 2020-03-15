package com.growInfo;

import java.sql.*;
import java.util.*;

import com.main.*;

public class growInfoDAO {
	//DB연결 객체화
	DBCon dbcp = new DBCon();
	
	//--------------------------------------------------------------
	
	/**************************************
	 * @name insertGrowInfotData()
	 * @author 윤건주
	 * @param ArrayList<growDTO>(필요한 정보 리스트)
	 *            -
	 * @return int(성공시 1, 실패시 0)
	 * @remark 상태기준정보 DB에 등록,
	 * 		   사용처 - growInfo/growInfoPrc.jsp
	 **************************************/
	
	public int insertGrowInfotData(ArrayList<growInfoDTO> adto)
	{
		// DB 연결에 필요한 변수
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		ResultSet rs = null;
		
		int result = 0;						// 반환 변수
		
		try
		{
			con = dbcp.getConnection();
			
			//최대 그룹 코드 값 가져오기
			sql = "select max(groupcode) as max from fish ";
			pstmt = con.prepareStatement(sql);
			rs = pstmt.executeQuery();
			
			rs.next();
			int max = rs.getInt("max")+1; //그룹코드 관리를 위한 변수
			
			
			
			//정보값 입력
			for(int i=0; i<5; i++)
			{
				growInfoDTO dto = adto.get(i); 
				//삽입 sql
				sql = "insert into fish(fishid, farmid, fishname, state, " + 
					"domax, domin, wtmax, wtmin, psumax, psumin, phmax, " + 
					"phmin, nh4max, nh4min, no2max, no2min, regdate, regid, " + 
					"lastuptdate, lastuptid, groupcode)" + 
					"values(fishidseq.nextval, ?, ?, ?, " + 
					"?, ?, ?, ?, ?, ?, ?, " + 
					"?, ?, ?, ?, ?, sysdate, ?, " + 
					"sysdate, ?, ?) ";
				pstmt = con.prepareStatement(sql);		
				pstmt.setInt(1, dto.getFarmId());		// 양식장ID
				pstmt.setString(2, dto.getFishName());	// 양식정보명칭
				pstmt.setString(3, dto.getState());		// 상태값
				pstmt.setDouble(4, dto.getDOMax());		// 해당 상태 용존산소 최대치
				pstmt.setDouble(5, dto.getDOMin());		// 해당 상태 용존산소 최소치
				pstmt.setDouble(6, dto.getWTMax());		// 해당 상태 수온 최대치
				pstmt.setDouble(7, dto.getWTMin());		// 해당 상태 수온 최소치
				pstmt.setDouble(8, dto.getPsuMax());	// 해당 상태 염도 최대치
				pstmt.setDouble(9, dto.getPsuMin());	// 해당 상태 염도 최소치
				pstmt.setDouble(10, dto.getpHMax());	// 해당 상태 산도 최대치
				pstmt.setDouble(11, dto.getpHMin());	// 해당 상태 산도 최소치
				pstmt.setDouble(12, dto.getNH4Max());	// 해당 상태 암모니아 최대치
				pstmt.setDouble(13, dto.getNH4Min());	// 해당 상태 암모니아 최소치
				pstmt.setDouble(14, dto.getNO2Max());	// 해당 상태아질산 최대치
				pstmt.setDouble(15, dto.getNO2Min());	// 해당 상태아질산 최소치
				pstmt.setString(16, dto.getRegId());	// 정보등록자
				pstmt.setString(17, dto.getLastUptId());// 최종수정자
				pstmt.setInt(18, max);					// 정보 그룹 코드
				pstmt.executeUpdate();
			}
			
			result = 1; //수행이 완료되면 1을 리턴
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
	 * @author 윤건주
	 * @param farmId, groupcode
	 *            -
	 * @return ArrayList<growDTO>
	 * @remark 양식정보, 양식장이름, 주소를 조회
	 * 		   사용처 - growInfo/growList.jsp
	 **************************************/
	
	public ArrayList<growInfoDTO> listData(String userId, String auth, String farmName, String fishName)
	{
		// DB 연결에 필요한 변수
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		ResultSet rs = null;
		
		int subArray[] = null;											// 양식장이 여러개인 일반사용자를 위한 변수
		
		ArrayList<growInfoDTO> adto = new ArrayList<growInfoDTO>();		// 반환 변수
		
		try
		{
			con = dbcp.getConnection();
			
			// farmID가져오기
			if(auth.equals("전체관리자"))
			{	// 전체관리자 - 전체 양식장 확인
				sql  = "select distinct a.farmid, a.farmname, a.address, b.fishName, b.groupcode " + 
					   "from farm a, (select fishname, groupcode, farmid from fish) b " + 
					   "where a.farmid = b.farmid ";
				
				// 검색조건 확인
				if(!farmName.equals(""))
				{	// 양식장이름에 검색값이 있을 경우
					sql += "and a.farmname like '%" + farmName + "%' ";
				}
				if(!fishName.equals(""))
				{	// 양식정보명에 검색값이 있을 경우
					sql += "and b.fishname like '%" + fishName + "%' ";
				}
			}
			else
			{	// 일반관리자/사용자 - usertable에 저장된 내용을 토대로 가지고 옴
				sql = "select farmid from usertable where userid = ?";
				pstmt = con.prepareStatement(sql);
				pstmt.setString(1, userId);
				rs = pstmt.executeQuery();
				
				if(rs.next());
				{	// 배열에 값 저장
					String farmId[] = rs.getString("farmid").split(",");
					
					if(farmId[0].equals(null))
					{ 	// 없으면 반환값 없음.
						return null;
					}
					else
					{	// 값이 있을 시
						subArray = new int[farmId.length];
						// 반환값 존재
						for(int i=0; i<farmId.length; i++)
						{
							subArray[i] = Integer.parseInt(farmId[i]);
						}
					}
				}
				
				sql = "select distinct a.farmid, a.farmname, a.address, b.fishName, b.groupcode " + 
					  "from farm a, (select fishname, groupcode, farmid from fish) b " + 
					  "where a.farmid = b.farmid ";
				
				// 검색조건 확인
				if(!farmName.equals(""))
				{	// 양식장이름에 검색값이 있을 경우
					sql += "and a.farmname like '%" + farmName + "%' ";
				}
				if(!fishName.equals(""))
				{	// 양식정보명에 검색값이 있을 경우
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
			{	// 배열에 값 저장
				growInfoDTO dto = new growInfoDTO();
				dto.setFarmId(rs.getInt("farmid"));														// 양식정보id
				dto.setFishName(rs.getString("fishname"));												// 양식정보명
				dto.setGroupCode(rs.getInt("groupcode"));												// 그룹코드
				String address[] = rs.getString("address").split(" ");									// 문자열 자르기
				dto.setRemark(rs.getString("farmname") + " (" + address[0] + " " + address[1] + ")");	// 양식장 이름/주소 저장
				adto.add(dto);																			// Arraylist추가
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
	 * @author 윤건주
	 * @param farmid, groupcode
	 *            -
	 * @return ArrayList<growDTO>
	 * @remark 양식정보 조회하기 , 
	 * 		   사용처 - growInfo/growInfoRead.jsp
	 **************************************/
	
	public ArrayList<growInfoDTO> readGrowInfo(int farmid, int groupcode)
	{
		// DB 연결에 필요한 변수
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		ResultSet rs = null;
		
		ArrayList<growInfoDTO> adto = new ArrayList<growInfoDTO>();						// 반환 변수
		
		try
		{
			con = dbcp.getConnection();
			
			//정보 조회 하기
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
	 * @author 윤건주
	 * @param farmId, groupcode, ArrayList<growDTO>(필요한 정보 리스트)
	 *            -
	 * @return int(성공시 1, 실패시 0)
	 * @remark 상태기준정보 수정 , 
	 * 		   사용처 - growInfo/growInfoPrc.jsp
	 **************************************/
	
	public int updateGrowInfo(int farmId, int groupcode, ArrayList<growInfoDTO> adto)
	{
		// DB 연결에 필요한 변수
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		ResultSet rs = null;
		
		int result = 0;						// 반환 변수
		
		try
		{
			con = dbcp.getConnection();
						
			//정보값 입력
			for(int i=0; i<5; i++)
			{
				growInfoDTO dto = adto.get(i); 
				//삽입 sql
				sql = "update fish "
						+ "set fishname = ?, domax = ?, domin = ?, wtmax = ?, wtmin = ?, psumax = ?, psumin = ?, phmax = ?, phmin = ?, "
						+ "nh4max = ?, nh4min = ?, no2max = ?, no2min = ?, lastuptdate = sysdate, lastuptid = ? "
						+ "where farmid = ? and state = ? and groupcode = ? ";
				pstmt = con.prepareStatement(sql);		
				pstmt.setString(1, dto.getFishName());	// 양식정보명칭
				pstmt.setDouble(2, dto.getDOMax());		// 해당 상태 용존산소 최대치
				pstmt.setDouble(3, dto.getDOMin());		// 해당 상태 용존산소 최소치
				pstmt.setDouble(4, dto.getWTMax());		// 해당 상태 수온 최대치
				pstmt.setDouble(5, dto.getWTMin());		// 해당 상태 수온 최소치
				pstmt.setDouble(6, dto.getPsuMax());	// 해당 상태 염도 최대치
				pstmt.setDouble(7, dto.getPsuMin());	// 해당 상태 염도 최소치
				pstmt.setDouble(8, dto.getpHMax());		// 해당 상태 산도 최대치
				pstmt.setDouble(9, dto.getpHMin());		// 해당 상태 산도 최소치
				pstmt.setDouble(10, dto.getNH4Max());	// 해당 상태 암모니아 최대치
				pstmt.setDouble(11, dto.getNH4Min());	// 해당 상태 암모니아 최소치
				pstmt.setDouble(12, dto.getNO2Max());	// 해당 상태아질산 최대치
				pstmt.setDouble(13, dto.getNO2Min());	// 해당 상태아질산 최소치
				pstmt.setString(14, dto.getLastUptId());// 최종수정자
				pstmt.setInt(15, dto.getFarmId());		// 양식장ID
				pstmt.setString(16, dto.getState());	// 상태값
				pstmt.setInt(17, dto.getGroupCode());	// 정보 그룹 코드
				pstmt.executeUpdate();
			}
			
			result = 1; //수행이 완료되면 1을 리턴
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
	 * @author 윤건주
	 * @param farmId, groupcode
	 *            -
	 * @return int(성공시 1, 실패시 0)
	 * @remark 상태기준정보 삭제하기 , 
	 * 		   사용처 - growInfo/growInfoPrc.jsp
	 **************************************/
	
	public int deleteGrowInfo(int farmId, int groupcode)
	{
		// DB 연결에 필요한 변수
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		ResultSet rs = null;
		
		int result = 0;						// 반환 변수
		
		try
		{
			con = dbcp.getConnection();
			
			sql = "delete fish "
					+ "where farmid = ? and groupcode = ? ";
			pstmt = con.prepareStatement(sql);	
			pstmt.setInt(1, farmId);		// 양식장ID
			pstmt.setInt(2, groupcode);	// 정보 그룹 코드
			pstmt.executeUpdate();
			
			result = 1; //수행이 완료되면 1을 리턴
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
	    * @author 장해리
	    * @param farmid(int)
	    * @return wtselectlist
	    * @remark 양식장 정보 수정에서 어종 출력 - farm/farmwtUpdateForm.jsp
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
	         // 양식장 아이디에 맞은 어종 이름 가져오기
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
	    * @author 윤건주
	    * @param farmId
	    *            -
	    * @return ArrayList<growDTO>
	    * @remark (모바일용)양식정보명/그룹코드를 조회
	    *          사용처 - mobile/fish/growList.jsp
	    **************************************/
	   
	   public ArrayList<growInfoDTO> mgrowList(int farmId)
	   {
	      // DB 연결에 필요한 변수
	      Connection con = null;
	      PreparedStatement pstmt = null;
	      String sql = null;
	      ResultSet rs = null;
	      
	      ArrayList<growInfoDTO> adto = new ArrayList<growInfoDTO>();                  // 반환 변수
	      
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
