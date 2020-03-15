package com.main;

import com.repair.*;
import com.waterTank.*;
import com.rec.*;


import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


/**
 * Servlet implementation class searchwtREC
 */
@WebServlet("/searchwtREC")
public class searchwtREC extends HttpServlet {

	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		request.setCharacterEncoding("EUC-KR");
		response.setContentType("text/html; charset=EUC-KR;");
		String getFarmId = request.getParameter("FarmID");
		
		if (getFarmId == "init") {
			return;
		} else {
			response.getWriter().write(getJson(getFarmId));
		}
	}

	public String getJson(String FarmID) {
		
		
		recDAO rDAO = new recDAO();
		// get rec table �젙蹂� 
		ArrayList<recDTO> getWtRec = rDAO.wtRecRet(FarmID);
	
		StringBuffer result = new StringBuffer("");
		result.append("{\"result\":[");
			
		waterTankDAO getwtTankcnt = new waterTankDAO();
		// �쟾泥� �닔議� 媛��닔
		String allwtTankCnt = getwtTankcnt.getTankCnt(FarmID);
		
		result.append("[{\"value\":\"" + "수조갯수 : " +allwtTankCnt +"\"}],");
		
		// �닔議� �젙蹂대�� Json �삎�깭濡� �뙆�떛
		for(int i=1; i<getWtRec.size(); i++)			
		{
			repairDAO retCounter = new repairDAO();
			String resCnt = retCounter.retRepSeq(FarmID,  getWtRec.get(i).getTankId());		

			result.append("[{\"value\":\"" + "수조번호  : " + getWtRec.get(i).getTankId() + "\"},");
			result.append("{\"value\":\"" + "수조상태  : " + getWtRec.get(i).getState() + "\"},");
			if(getWtRec.get(i).getYrCode()  == null) {
				result.append("{\"value\":\"" + "상태이상  : " + "" + "\"},");
					
			} else {
				result.append("{\"value\":\"" + "상태이상  : " + getWtRec.get(i).getYrCode() + "\"},");
				
			}
	
			result.append("{\"value\":\"" + "물고기종  : " + getWtRec.get(i).getFishId() + "\"},");
			result.append("{\"value\":\"" + "DO : " + getWtRec.get(i).getDoRec()+ "\"},");
			result.append("{\"value\":\"" + "수온 : " + getWtRec.get(i).getWtRec() + "\"},");
			result.append("{\"value\":\"" + "PH : " + getWtRec.get(i).getPhRec() + "\"},");
			result.append("{\"value\":\"" + "암모니아 : " + getWtRec.get(i).getNh4Rec() + "\"},");
			result.append("{\"value\":\"" + "아질산   : " + getWtRec.get(i).getNo2Rec() + "\"},");
			result.append("{\"value\":\"" + "RECSEQ   : " + getWtRec.get(i).getRecSeq() + "\"},");
			result.append("{\"value\":\"" +resCnt + "\"}],");		
		}
		
		result.append("]}");
		
		return result.toString();
		
	}
}
