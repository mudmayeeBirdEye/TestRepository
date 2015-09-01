public with sharing class RCSiteLoginController {
	public String username {get; set;}
	public String password {get; set;}
   
    public String oldPassword {get; set;}
    public String newPassword {get; set;}
    public String verifyNewPassword {get; set;}        
  
    public RCSiteLoginController () {
    	if(UserInfo.getUserType()=='Guest'){
			deleteOktaSession();
     	} 
    }
    public PageReference login() {
         //String startUrl = System.currentPageReference().getParameters().get('startURL');
          String startUrl ='/home/home.jsp';
          return Site.login(username, password, startUrl);
     }
	public PageReference forgotPassword() {
		boolean success = Site.forgotPassword(username);
		PageReference pr = Page.RCForgotPasswordConfirm;
		pr.setRedirect(true);
      	if (success) {return pr;}
      	return null;
    }
	public PageReference changePassword() {
        return Site.changePassword(newPassword, verifyNewPassword, oldpassword);    
    }     
    public void deleteOktaSession(){
		try {
			if(ApexPages.currentPage().getCookies().get('oktaUserSessionId')!=null){
				String strSessionId= ApexPages.currentPage().getCookies().get('oktaUserSessionId').getValue();
				ApexPages.currentPage().setCookies(new Cookie[]{new Cookie('oktaUserSessionId',null,null,0,false)}); 
               
                Http http = new Http();
                HttpRequest req = new HttpRequest();
                req.setEndpoint('https://myaccounts-ringcentral.okta.com/api/v1/sessions/'+strSessionId);
                req.setHeader('Content-type', 'application/json');
                req.setHeader('Authorization','SSWS 00lQfSEOLV6vNsmZmPvklnQjfBlY3iha8iYDEtapFm');
                req.setMethod('DELETE');
                HTTPResponse res =new HTTPResponse();
                res = http.send(req);
			}
		} catch(Exception e) {}
	}
	/*@isTest
    public static void RCSiteLoginController() {
    	//OKTAExportHelper obj = new OKTAExportHelper();
    	// obj.callAPIs('https://myaccounts-ringcentral.okta.com/api/v1/users', 'Please isgnore', 'GET');
    	Profile guestUserProf  = [select id from profile where name ='RCPartner Profile'];
    	User su = new User(firstname='testGuest', lastname='testGuestLN', alias = 'testgst', email='testGuest@ringcentral.com', 
            emailencodingkey='UTF-8', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = guestUserProf.Id, 
            timezonesidkey='America/Los_Angeles', username='testGuest@test.com');
        insert su;
        System.runAs(su) {
        	ApexPages.currentPage().getCookies().put('oktaUserSessionId',new Cookie('oktaUserSessionId',null,null,0,false));
        	RCSiteLoginController rcSiteLoginObj = new RCSiteLoginController();
        	rcSiteLoginObj.forgotPassword();
        	rcSiteLoginObj.changePassword();
        	rcSiteLoginObj.login();
        }
    	
    }*/
}