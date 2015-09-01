public class CampaignWrapper {
	public String CAM_AID{get;set;}
	public String CAM_BMID{get;set;}
	public String CAM_PID{get;set;}
	public String CAM_PRIMARY{get;set;}
	public Boolean IS_PARTNER_LEAD{get;set;} 
	public String CAM_DNIS{get;set;}
	public CampaignWrapper(String CAM_AID, String CAM_BMID, String CAM_PID, String CAM_PRIMARY, Boolean IS_PARTNER_LEAD) {
		this.CAM_AID = CAM_AID;
		this.CAM_BMID = CAM_BMID;
		this.CAM_PID = CAM_PID;
		this.CAM_PRIMARY = CAM_PRIMARY;
		this.IS_PARTNER_LEAD = IS_PARTNER_LEAD;
	}
	public CampaignWrapper(String CAM_AID, String CAM_BMID, String CAM_PID, String CAM_DNIS,String CAM_PRIMARY, Boolean IS_PARTNER_LEAD) {
		this.CAM_AID = CAM_AID;
		this.CAM_BMID = CAM_BMID;
		this.CAM_PID = CAM_PID;
		this.CAM_DNIS = CAM_DNIS;
		this.CAM_PRIMARY = CAM_PRIMARY;
		this.IS_PARTNER_LEAD = IS_PARTNER_LEAD;
	}
}