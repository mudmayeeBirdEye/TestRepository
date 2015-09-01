public class OktaUserDetail{
	public List<OktaUser> OktaUserList{get;set;}
  //public OktaUser1 OktaUser{get;set;}
	public class OktaUser{
		public String id{get;set;}
		public String firstName{get;set;}
		public String lastName{get;set;}
		public String email{get;set;}
	    public String login{get;set;}
	    public String mobilePhone{get;set;}
		public profileDetail profile{get;set;}
	}
	
	public class profileDetail{
		public String firstName{get;set;}
		public String lastName{get;set;}
		public String email{get;set;}
	    public String login{get;set;}
	    public String mobilePhone{get;set;}
	}
}