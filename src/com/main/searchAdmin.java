package com.main;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.farm.farmDAO;
import com.farm.farmDTO;

/**
 * Servlet implementation class searchAdmin
 */
@WebServlet("/searchAdmin")
public class searchAdmin extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		request.setCharacterEncoding("euc-kr");
		response.setContentType("text/html; charset=euc-kr;");
		String getFarmId = request.getParameter("FarmID");
		
		if (getFarmId == "init") {
			return;
		} else {
			response.getWriter().write(getSysFarmName(getFarmId));
		}
	}
	
	// 전체 관리자가 로그인 시 가져올 양식장 아이디와 매칭되는 양식장 이름
	public String getSysFarmName(String getFarmId) {
		
		farmDAO farm_list = new farmDAO();
		
		ArrayList<farmDTO> getFarmSysInfoList = farm_list.getFarmSysInfo(getFarmId);
		
		StringBuffer result = new StringBuffer("");
		result.append("{\"result\":[");
		
		for(int i=0; i<getFarmSysInfoList.size(); i++)
		{
			
			result.append("[{\"value\":\"" + getFarmSysInfoList.get(i).getFarmId() + "\"},");
			result.append("{\"value\":\""  + getFarmSysInfoList.get(i).getFarmName() + "\"}],");
		}
		
		result.append("]}");
		return result.toString();
	}


}
