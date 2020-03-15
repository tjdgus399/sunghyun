package com.growInfo;

public class growInfoDTO {
	// 변수 객체
	private int fishId;			// 정보식별 ID
	private int farmId;			// 양식장 ID
	private String fishName;	// 양식정보 이름
	private	String State;		// 상태(정상이하 위험(RM), 정상이상 위험(YM), 정상(G), 정상이상 경고(Y), 정상이상 위험(R))
	private double DOMax;		// 해당 상태 용존산소 최대치
	private double DOMin;		// 해당 상태 용존산소 최소치
	private double WTMax;		// 해당 상태 수온 최대치
	private double WTMin;		// 해당 상태 수온 최소치
	private double psuMax;		// 해당 상태 염도 최대치
	private double psuMin;		// 해당 상태 염도 최소치
	private double pHMax;		// 해당 상태 산도 최대치
	private double pHMin;		// 해당 상태 산도 최소치
	private double NH4Max;		// 해당 상태 암모니아 최대치
	private double NH4Min;		// 해당 상태 암모니아 최소치
	private double NO2Max;		// 해당 상태아질산 최대치
	private double NO2Min;		// 해당 상태아질산 최소치
	private String regDate;		// 정보등록일
	private String regId;		// 정보등록자
	private String lastUptdate;	// 최종수정일
	private String lastUptId;	// 최종수정자
	private String remark;		// 비고
	private int groupCode;		// 정보 그룹 코드
	
	// getter/setter
	public int getFishId() {
		return fishId;
	}
	public void setFishId(int fishId) {
		this.fishId = fishId;
	}
	public int getFarmId() {
		return farmId;
	}
	public void setFarmId(int farmId) {
		this.farmId = farmId;
	}
	public String getFishName() {
		return fishName;
	}
	public void setFishName(String fishName) {
		this.fishName = fishName;
	}
	public String getState() {
		return State;
	}
	public void setState(String state) {
		State = state;
	}
	public double getDOMax() {
		return DOMax;
	}
	public void setDOMax(double dOMax) {
		DOMax = dOMax;
	}
	public double getDOMin() {
		return DOMin;
	}
	public void setDOMin(double dOMin) {
		DOMin = dOMin;
	}
	public double getWTMax() {
		return WTMax;
	}
	public void setWTMax(double wTMax) {
		WTMax = wTMax;
	}
	public double getWTMin() {
		return WTMin;
	}
	public void setWTMin(double wTMin) {
		WTMin = wTMin;
	}
	public double getPsuMax() {
		return psuMax;
	}
	public void setPsuMax(double psuMax) {
		this.psuMax = psuMax;
	}
	public double getPsuMin() {
		return psuMin;
	}
	public void setPsuMin(double psuMin) {
		this.psuMin = psuMin;
	}
	public double getpHMax() {
		return pHMax;
	}
	public void setpHMax(double pHMax) {
		this.pHMax = pHMax;
	}
	public double getpHMin() {
		return pHMin;
	}
	public void setpHMin(double pHMin) {
		this.pHMin = pHMin;
	}
	public double getNH4Max() {
		return NH4Max;
	}
	public void setNH4Max(double nH4Max) {
		NH4Max = nH4Max;
	}
	public double getNH4Min() {
		return NH4Min;
	}
	public void setNH4Min(double nH4Min) {
		NH4Min = nH4Min;
	}
	public double getNO2Max() {
		return NO2Max;
	}
	public void setNO2Max(double nO2Max) {
		NO2Max = nO2Max;
	}
	public double getNO2Min() {
		return NO2Min;
	}
	public void setNO2Min(double nO2Min) {
		NO2Min = nO2Min;
	}
	public String getRegDate() {
		return regDate;
	}
	public void setRegDate(String regDate) {
		this.regDate = regDate;
	}
	public String getRegId() {
		return regId;
	}
	public void setRegId(String regId) {
		this.regId = regId;
	}
	public String getLastUptdate() {
		return lastUptdate;
	}
	public void setLastUptdate(String lastUptdate) {
		this.lastUptdate = lastUptdate;
	}
	public String getLastUptId() {
		return lastUptId;
	}
	public void setLastUptId(String lastUptId) {
		this.lastUptId = lastUptId;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
	public int getGroupCode() {
		return groupCode;
	}
	public void setGroupCode(int groupCode) {
		this.groupCode = groupCode;
	}
}
