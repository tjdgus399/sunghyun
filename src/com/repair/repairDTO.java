package com.repair;

public class repairDTO {
	// 변수 객체
	private int repairSeq;			// 조치seq
	private int recSeq;				// 기록seq
	private String tankId;				// 수조ID
	private int farmId;			// 양식장ID
	private int fishId;				// 양식정보ID
	private String state;			// 상태
	private String yrCode;			// 이상코드명
	private String sensorDate;		// 측정일시
	private String repairId;		// 조치자ID
	private String repairContents;	// 조치내용
	private String regDate;			// 정보등록일
	private String regId;			// 정보등록자
	private String lastUptdate;		// 최종수정일
	private String lastUptId;		// 최종수정자
	private String remark;			// 비고
	
	// getter/setter
	public int getRepairSeq() {
		return repairSeq;
	}
	public void setRepairSeq(int repairSeq) {
		this.repairSeq = repairSeq;
	}
	public int getRecSeq() {
		return recSeq;
	}
	public void setRecSeq(int recSeq) {
		this.recSeq = recSeq;
	}
	public String getTankId() {
		return tankId;
	}
	public void setTankId(String tankId) {
		this.tankId = tankId;
	}
	public int getFarmId() {
		return farmId;
	}
	public void setFarmId(int farmId) {
		this.farmId = farmId;
	}
	public int getFishId() {
		return fishId;
	}
	public void setFishId(int fishId) {
		this.fishId = fishId;
	}
	public String getState() {
		return state;
	}
	public void setState(String state) {
		this.state = state;
	}
	public String getYrCode() {
		return yrCode;
	}
	public void setYrCode(String yrCode) {
		this.yrCode = yrCode;
	}
	public String getSensorDate() {
		return sensorDate;
	}
	public void setSensorDate(String sensorDate) {
		this.sensorDate = sensorDate;
	}
	public String getRepairId() {
		return repairId;
	}
	public void setRepairId(String repairId) {
		this.repairId = repairId;
	}
	public String getRepairContents() {
		return repairContents;
	}
	public void setRepairContents(String repairContents) {
		this.repairContents = repairContents;
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
}
