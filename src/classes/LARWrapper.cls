public class LARWrapper {
	public String folder{get;set;}
	public String customerSize{get;set;}
	public String campaignStr{get;set;}
	public String leadSource{get;set;}
	public String lesStr{get;set;}
	public Opportunity opportunityObj{get;set;}
	public Lead leadObj{get;set;}
	public String assignmentSource{get;set;}
	public String ownerStr{get;set;}
	public string objectName{get;set;}
	public LARWrapper(String folder, String customerSize, String campaignStr, String LeadSource, String lesStr, 
	String assignmentSource, String ownerStr,string objectName) {
		this.folder = folder;
		this.customerSize = customerSize;
		this.campaignStr = campaignStr;
		this.LeadSource = LeadSource;
		this.lesStr = lesStr;
		this.leadObj = leadObj;
		this.opportunityObj = opportunityObj;
		this.assignmentSource = assignmentSource;
		this.ownerStr = ownerStr;
		this.objectName = objectName;
	}
}