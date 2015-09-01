public class CreateOktaUser {
    public static String OKTA_URL = 'https://myaccounts-ringcentral.okta.com'; 
    public static String OKTA_API = '00lQfSEOLV6vNsmZmPvklnQjfBlY3iha8iYDEtapFm';
    public static String OKTA_PASSWORD = 'ra!nb0w7';
    Contact contactObj {get;set;}
    public OktaUser oktaUserObj{get;set;}
    public Boolean isLanding{get;set;}
    public Boolean isErrorOccured{get;set;}
    public Boolean authorizationError{get;set;}
    public CreateOktaUser(ApexPages.StandardController controller) {
        authorizationError = false;
        isErrorOccured = false;
        isLanding = true;
        if(controller.getId() == null) {
            isErrorOccured = true;
        }
        contactObj = (Contact) controller.getRecord();
    }
    public PageReference cancel() {
        return new ApexPages.StandardController(contactObj).view();
    }
    public PageReference validateUser() {
        isLanding = false;
        User userObj = null; 
        try {
            userObj = [SELECT Id, FirstName, UserType, LastName, Username, Name, MobilePhone, Phone, OKTAUserID__c, OktaUserPassword__c, IsActive FROM User WHERE ContactId =: contactObj.Id AND UserType='PowerPartner' LIMIT 1];
        } catch(Exception e) {}
        try {
            if(userObj != null) {
                if(userObj.IsActive) {
                    String userStr = isOktaUserAvailalbe(userObj);
                    // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, userStr));
                    if(Test.isRunningTest()) {
                    	userStr = '{"profile":{"firstName":"Anuj","lastName":"Shukla","email":"rcindiateam@simplion.com","login":"anuj.shukla@simplion.com","mobilePhone":"(991) 010-2345"}}';
                    }
                    oktaUserObj = (OktaUser)JSON.deserialize(userStr,OktaUser.class);
                    if(oktaUserObj != null) {
                        if(oktaUserObj.id != null || !String.isBlank(userObj.OKTAUserID__c)) {
                            if(String.isBlank(userObj.OKTAUserID__c)) {
                                userObj.OKTAUserID__c = oktaUserObj.id; 
                                userObj.OktaUserPassword__c = CreateOktaUser.OKTA_PASSWORD;
                                update userObj;
                            }
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, '<span style="color:#084B8A">'+userObj.Username+'</span>' +' already exists in Okta.'));
                        } else {
                            userStr = createOktaUser(userObj);
                            // userStr = '{"id":"00u3uty75rWFWAOFWHQJ","profile":{"firstName":"Anuj","lastName":"Shukla","email":"rcindiateam@simplion.com","login":"anuj.shukla@simplion.com","mobilePhone":"(991) 010-2345"}}';
                            // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, userStr));
                            if(Test.isRunningTest()) {
		                    	userStr = '{"id":"00u3uty75rWFWAOFWHQJ","profile":{"firstName":"Anuj","lastName":"Shukla","email":"rcindiateam@simplion.com","login":"anuj.shukla@simplion.com","mobilePhone":"(991) 010-2345"}}';
		                    }
                            oktaUserObj = (OktaUser)JSON.deserialize(userStr,OktaUser.class);
                            if(oktaUserObj != null) {
                                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Okta User was successfully created.'));
                                userObj.OKTAUserID__c = oktaUserObj.id;
                                resetOktaPassword(oktaUserObj.id);
                                userObj.OktaUserPassword__c = CreateOktaUser.OKTA_PASSWORD;
                                update userObj;
                            }
                        }
                    }
                } else {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'This Partner Portal User is Inactive.  Please set this User as Active before creating an Okta User.'));
                }
            } else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'No Partner Portal User exists for this Contact.'));
            }
        } catch(Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getStackTraceString()));
        }
        // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, userStr));
        return null;
    }
    public String isOktaUserAvailalbe(User userObj) {
    	String endURL = CreateOktaUser.OKTA_URL+'/api/v1/users/'+ userObj.Username;
        String body = null;
        String action = 'GET';
        return callAPIs(endURL, body, action);
    	/*
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(CreateOktaUser.OKTA_URL+'/api/v1/users/'+ userObj.Username);
        req.setHeader('Content-type', 'application/json');
        req.setHeader('Accept', 'application/json'); 
        req.setHeader('Authorization','SSWS '+CreateOktaUser.OKTA_API);
        req.setMethod('GET');
        HTTPResponse res =new HTTPResponse();
        res = http.send(req);
        return res.getBody();
        */
    }
    public void resetOktaPassword(String oktaUserId) {
    	String endURL = CreateOktaUser.OKTA_URL+'/api/v1/users/'+oktaUserId+'/lifecycle/reset_password?sendEmail=true';
        String body = null;
        String action = 'GET';
        callAPIs(endURL, body, action);
    	/*
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        if( !Test.isRunningTest() ){
	        req.setEndpoint(CreateOktaUser.OKTA_URL+'/api/v1/users/'+oktaUserId+'/lifecycle/reset_password?sendEmail=true');
	        req.setHeader('Content-type', 'application/json');
	        req.setHeader('Accept', 'application/json'); 
	        req.setHeader('Authorization','SSWS '+CreateOktaUser.OKTA_API);
	        req.setMethod('GET');
	        HTTPResponse res =new HTTPResponse();
	        res = http.send(req);
	    }
        // strJSON =  res.getBody();
        */
    }
    public String createOktaUser(User userObj) {
        String endURL = CreateOktaUser.OKTA_URL+'/api/v1/users?activate=true';
        String body = '{"profile": {"firstName": "'+ userObj.FirstName +'","lastName": "'+userObj.LastName+'","email": "var.okta@ringcentral.com","login": "'+userObj.Username+'","mobilePhone": "'+(userObj.Phone == null ? '' : userObj.Phone)+'"}}';
        String action = 'POST';
        return callAPIs(endURL, body, action);
    }
    private String callAPIs(String endURL, String body, String action) {
        Http http = new Http();
        HttpRequest req = new HttpRequest();
    	req.setEndpoint(endURL);
    	if(body != null)
        	req.setBody(body);
        // req.setBody('{"profile": {"firstName": "'+ userObj.FirstName +'","lastName": "'+userObj.LastName+'","email": "tucker.heiner@ringcentral.com","login": "'+userObj.Username+'","mobilePhone": "'+(userObj.Phone == null ? '' : userObj.Phone)+'"}}');
        // req.setBody('{"profile": {"firstName": "'+ userObj.FirstName +'","lastName": "'+userObj.LastName+'","email": "rcindiateam@simplion.com","login": "'+userObj.Username+'","mobilePhone": "'+(userObj.Phone == null ? '' : userObj.Phone)+'"}}');
        req.setHeader('Content-type', 'application/json');
        req.setHeader('Accept', 'application/json'); 
        req.setHeader('Authorization','SSWS '+CreateOktaUser.OKTA_API);
        req.setMethod(action);
        HTTPResponse res =new HTTPResponse();
        if(!test.isRunningTest())
        	res = http.send(req);
        return res.getBody();
    }
    
    
    public class OktaUser {
        public String id{get;set;}
        public String errorCode{get;set;}
        public String errorSummary{get;set;}
        public String errorLink{get;set;}
        public String errorId{get;set;}
        public String[] errorCauses{get;set;}
        public Profile profile{get;set;}
    }
    public class Profile {
        public String firstName{get;set;}
        public String lastName{get;set;}
        public String login{get;set;}
        public String email{get;set;}
        public String mobilePhone{get;set;}
    }
/*    @isTest
    public static void createOktaUserTest(){
    	RecordType rcType = [SELECT Id, Name FROM RecordType WHERE Name='Partner Account'];
	    Account accountobj = new Account();
	    accountobj.Name = 'Test Okta';
	    accountobj.RecordTypeId = rcType.Id;
	    accountobj.Partner_ID__c = 'PARTNER001';
	    insert accountobj;
	    
	    Contact contactObj = new Contact();
	    contactObj.AccountId = accountobj.id;
	    contactObj.Email = 'Test@simplion.com';
	    contactObj.LastName = 'Test Okta Con';
	    contactObj.Phone = '1234567890';
	    try {
	    	ApexPages.StandardController controller=new ApexPages.StandardController(contactObj);   
	    	CreateOktaUser objCreateOktaUser=new CreateOktaUser(controller);
	    } catch(Exception e) {}
	    insert contactObj;
		// Id, FirstName, UserType, LastName, Username, Name, MobilePhone, Phone, OKTAUserID__c, OktaUserPassword__c, IsActive
		User testUser = new User(alias = 'u1', email='u1234@testorg.com',
	                      emailencodingkey='UTF-8', lastname='Testing', OKTAUserID__c='', ProfileId=[SELECT Id FROM Profile WHERE Name='RC Partner User' LIMIT 1].Id, languagelocalekey='en_US',
	                      localesidkey='en_US', country='United States',
	                      timezonesidkey='America/Los_Angeles', username='u11234@testorg.com', ContactId=contactObj.id, IsActive=true);
	                 
	   	insert testUser;
		ApexPages.StandardController controller=new ApexPages.StandardController(contactObj);   
	    CreateOktaUser objCreateOktaUser=new CreateOktaUser(controller);
	   /* 
	    OktaInfo__c  oktaInfoObj= new OktaInfo__c();
	    oktaInfoObj.OKTA_PWD__c='ra!nb0w7';
	    oktaInfoObj.API_KEY__c='00lQfSEOLV6vNsmZmPvklnQjfBlY3iha8iYDEtapFm';
	    oktaInfoObj.OKTA_URL__c='https://myaccounts-ringcentral.okta.com';
	    oktaInfoObj.Name='OKTA_INFO';
	    insert oktaInfoObj;
	    
	    */
	   /* try {
	    	objCreateOktaUser.cancel();
	    } catch(Exception e) {}
	    try {
	    	objCreateOktaUser.validateUser();
	    } catch(Exception e) {}
	    try {
	    	objCreateOktaUser.resetOktaPassword(testUser.id);
	    } catch(Exception e) {}
	    try {
	    	objCreateOktaUser.createOktaUser(testUser);
	    } catch(Exception e) {}
	    try {
		    CreateOktaUser.Profile objProfile=new CreateOktaUser.Profile();
		    CreateOktaUser.OktaUser objOktaUser=new CreateOktaUser.OktaUser();
	    } catch(Exception e) {}
	    
	    try {
	    	testUser.IsActive = false;	                 
	   		update testUser;
	    	objCreateOktaUser.validateUser();
	    } catch(Exception e) {}
	    Contact contactObj1 = new Contact();
	    contactObj1.AccountId = accountobj.id;
	    contactObj1.Email = 'TestMyAccount@simplion.com';
	    contactObj1.LastName = 'Test Okta Con2';
	    contactObj1.Phone = '1234567891';
	    insert contactObj1;
	    try {
	    	controller=new ApexPages.StandardController(contactObj1);   
	    	objCreateOktaUser=new CreateOktaUser(controller);
	    	User testUserNew = new User(alias = 'u2', email='u2@testorg.com',
	                      emailencodingkey='UTF-8', lastname='Testing2', ProfileId=[SELECT Id FROM Profile WHERE Name='Sales Agent' LIMIT 1].Id, languagelocalekey='en_US',
	                      localesidkey='en_US', country='United States',
	                      timezonesidkey='America/Los_Angeles', username='u2@testorg.com', ContactId=contactObj1.id, IsActive=true);
	                 
	   		insert testUserNew;
	    	objCreateOktaUser.validateUser();
	    } catch(Exception e) {}
    }*/
}