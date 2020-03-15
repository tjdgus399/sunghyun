package com.farm;

public class farmDTO {
	// 변수 객체
	private int farmId;			// 양식장ID
	private String farmName;	// 양식장이름
	private String address;		// 양식장주소
	private int tankcnt;		// 양식장의 수조의 수
	private String userId;		// 담당자ID
	private String regDate;		// 정보기록일
	private String regId;		// 정보기록자
	private String lastUptDate;	// 최종수정일
	private String lastUptId;	// 최종수정자
	private String regFromDate; // 등록일 시작
	private String regToDate;	// 등록일 끝
	private String remark;		// 비고
	private String remarkFarmid;  // 전체 관리자가 FARMID를 얻음
	
	// getter/setter
	public String getRemarkFarmid() {
		return remarkFarmid;
	}
	public void setRemarkFarmid(String remarkFarmid) {
		this.remarkFarmid = remarkFarmid;
	}
	public int getFarmId() {
		return farmId;
	}
	public void setFarmId(int farmId) {
		this.farmId = farmId;
	}
	public String getFarmName() {
		return farmName;
	}
	public void setFarmName(String farmName) {
		this.farmName = farmName;
	}
	public String getAddress() {
		return address;
	}
	public void setAddress(String address) {
		this.address = address;
	}
	public int getTankcnt() {
		return tankcnt;
	}
	public void setTankcnt(int tankcnt) {
		this.tankcnt = tankcnt;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
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
	public String getLastUptDate() {
		return lastUptDate;
	}
	public void setLastUptDate(String lastUptDate) {
		this.lastUptDate = lastUptDate;
	}
	public String getLastUptId() {
		return lastUptId;
	}
	public void setLastUptId(String lastUptId) {
		this.lastUptId = lastUptId;
	}
	public String getRegFromDate() {
		return regFromDate;
	}
	public void setRegFromDate(String regFromDate) {
		this.regFromDate = regFromDate;
	}
	public String getRegToDate() {
		return regToDate;
	}
	public void setRegToDate(String regToDate) {
		this.regToDate = regToDate;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
}
