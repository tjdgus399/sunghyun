package com.main;

public class StringUtil {
	public String nullToBlank(String str)
	{	// null 입력시 ""(공백)으로 출력
		if(str == null || str.equals("-"))
		{
			str = "";
		}
		
		return str;
	}
	
	public String nullToZero(String str)
	{	// null 입력시 200으로 출력
		if(str == null || str.equals("") || str.equals(".") || str.equals("-"))
		{
			str = "200";
		}
		
		return str;
	}
	
	public String noneToBar(Double str)
	{	// null 입력시 200으로 출력
		if(str == 200)
		{
			return "-";
		}
		return Double.toString(str);
	}
}
