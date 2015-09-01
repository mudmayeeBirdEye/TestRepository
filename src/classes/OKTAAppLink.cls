public class OKTAAppLink{
	public List<oktaAppLinkDetail> lstAppLink{get;set;}
	public class oktaAppLinkDetail{
		public String label{get;set;}
		public String  linkUrl{get;set;}
		public String logoUrl{get;set;}
		public String appName{get;set;}
		public String appInstanceId{get;set;}
		public String appAssignmentId{get;set;}
		public String credentialsSetup{get;set;}
		public Boolean hidden{get;set;}
		public String sortOrder{get;set;}
	}
}