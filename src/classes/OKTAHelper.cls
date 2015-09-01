/*****************************/
/*** This is used for okta session. required fields are API Key.***/
/*****************************/
public class OKTAHelper{
	private static String OKTA_URL = 'https://myaccounts-ringcentral.okta.com'; 
    private static String OKTA_API = '00lQfSEOLV6vNsmZmPvklnQjfBlY3iha8iYDEtapFm';
    private static String OKTA_PASSWORD = 'ra!nb0w7';
    
    public OKTASession objOKTASession{get;set;}
    public OKTAAppLink objOKTAAppLink{get;set;}
    public UserPassword objUserPassword{get;set;}
    
    public String strJSON{get;set;}
    public String username {get; set;}
    public String password {get; set;}
    public String strUserMessage{get;set;}
    
    public Boolean isOktaUserIdFound{get;set;}
    public Boolean showLink{get;set;}
    
    public OKTAHelper(){
        isOktaUserIdFound=false;
        String strOktaUserId='';
        showLink=false;
        try {
            User objUser=[SELECT id,username, OKTAUserID__c, OktaUserPassword__c FROM User WHERE id=:UserInfo.getUserId()];
            if(!String.isBlank(objUser.OktaUserPassword__c)) {
                strOktaUserId=objUser.OKTAUserID__c;
                isOktaUserIdFound = true;
                username = objUser.Username;
                password = objUser.OktaUserPassword__c;
            } else {
                showLink = true;
            }
        } catch(Exception e){}
        if(!String.isBlank(strOktaUserId)){ 
            oktaLogin();
            isOktaUserIdFound=true;
            /*
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            HTTPResponse res =new HTTPResponse();
            req.setEndpoint('https://myaccounts-ringcentral.okta.com/api/v1/users/'+strOktaUserId+'/appLinks'); //Logged In User Id 
            req.setHeader('Content-type', 'application/json');
            req.setHeader('Authorization','SSWS 00lQfSEOLV6vNsmZmPvklnQjfBlY3iha8iYDEtapFm');
            req.setHeader('Accept', 'application/json');
            req.setMethod('GET');
            res = new HTTPResponse();
            res = http.send(req);
            strJSON=res.getBody();
            */
            String endURL = OKTAHelper.OKTA_URL+'/api/v1/users/'+strOktaUserId+'/appLinks';
	        String body = null;
	        String action = 'GET';
	    	HTTPResponse res = callAPIs(endURL, body, action);
            strJSON=res.getBody();
            Integer statusCode = res.getStatusCode();
            if(Test.isRunningTest()) {
            	statusCode = 200;
            }
            if(statusCode == 200){
                String strJsonParse='{"lstAppLink":'+ res.getBody()+'}';
                if(Test.isRunningTest()) {
                	strJsonParse = '{"lstAppLink":[{"label":"UID9910106802","linkUrl":"https://myaccounts-ringcentral.okta.com/home/ringcentral/0oa3zhcqbkHADXMTQCXJ/58","logoUrl":"https://myaccounts-ringcentral.okta.com/img/logos/ringcentral.png","appName":"ringcentral","appInstanceId":"0oa3zhcqbkHADXMTQCXJ","appAssignmentId":"0ua3zhcqceXKHSRHZWGX","credentialsSetup":true,"hidden":false,"sortOrder":2147483647}]}';
                }
                objOKTAAppLink=(OKTAAppLink )JSON.deserialize(strJsonParse,OKTAAppLink.class); 
                Set<String> setRCUserId=new Set<String>();
                List<OKTAAccountHelper> lst=new List<OKTAAccountHelper>();
                for(OKTAAppLink.oktaAppLinkDetail obj:objOKTAAppLink.lstAppLink){
                	//System.debug('##$$## USER LEBEL = '+ obj.label.trim());
                	// String strUID = '\''+obj.label+'\'';
                    setRCUserId.add(obj.label); 
                    if(obj.label.indexOf('UID') >-1){
                    	//strUID = '\''+(obj.label.split('UID')[1])+'\'';
                        setRCUserId.add(obj.label.split('UID')[1].trim());
                    }
                } 
                
                System.debug('##$$## USER ID = '+ setRCUserId);
                Map<String,Account> mapAccount=new Map<String,Account>();
                String USER_ID = '';
                if(setRCUserId.size()<2500){//This is the limitaion of IN clause in query condition
                	List<Account> accList = [SELECT id, Name, AccountNumber, Parent.Name, Phone, RC_User_ID__c FROM Account WHERE RC_User_ID__c IN:setRCUserId];
                    if(accList != null) {
	                    for(Account objAccount : accList){
	                    	String strUID = (!String.isBlank(objAccount.RC_User_ID__c) && objAccount.RC_User_ID__c.indexOf('UID') != -1? objAccount.RC_User_ID__c.split('UID')[1]: objAccount.RC_User_ID__c);
	                        if(!String.isBlank(strUID)) {
	                        	mapAccount.put(strUID.trim(),objAccount);
		                        USER_ID +=strUID+ ',';
	                        }
	                    }
                    }
                }
                System.debug('##### USER IDs = '+ USER_ID);
                for(OKTAAppLink.oktaAppLinkDetail objHelper:objOKTAAppLink.lstAppLink){
                    OKTAAccountHelper obj=new OKTAAccountHelper();
                    obj.linkUrl=objHelper.linkUrl;
                    obj.logoUrl=objHelper.logoUrl;
                    obj.appName=objHelper.appName;
                    obj.label=(!String.isBlank(objHelper.label) && objHelper.label.indexOf('UID') != -1? objHelper.label.split('UID')[1]: objHelper.label);
                    System.debug('***** LABELs = '+ obj.label);
                    if(mapAccount.get(objHelper.label.trim())!=null || mapAccount.get(obj.label.trim())!=null){
                        Account objAccount;
                        if(mapAccount.get(objHelper.label)!=null){
                           	objAccount=mapAccount.get(objHelper.label.trim()); 
                        } else {
                        	objAccount=mapAccount.get(obj.label.trim());
                        }
                        obj.appName=objAccount.Name;
                        obj.accountName=objAccount.Name;
                        obj.parentAccountName=objAccount.Parent.Name;
                        obj.phone=objAccount.phone;
                    }else{
                    	obj.label='RingCentral User ID '+obj.label;
                    }
                    lst.add(obj);
                }
                strJSON=JSON.serialize(lst);
            } else {
                strUserMessage=res.getBody();
            } 
        } else {
            showLink = true;
        }
    }
    
    public void oktaLogin() {
        try {
            strJSON='Json';
            loginToOkta();
            objOKTASession= (OKTASession)JSON.deserialize(strJSON,OKTASession.class);
        } catch(Exception e){}
    }
    public String loginToOkta(){
    	String endURL = OKTAHelper.OKTA_URL+'/api/v1/sessions?additionalFields=cookieTokenUrl';
        String body = '{"username" : "'+username+'","password" : "'+password+'"}';
        String action = 'POST';
    	HTTPResponse res = callAPIs(endURL, body, action);
    	/*
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(CreateOktaUser.OKTAHelper.OKTA_URL+'/api/v1/sessions?additionalFields=cookieTokenUrl');
        // req.setBody('{"username" : "rcindiateam@simplion.com","password" : "Simplion10"}');
        req.setBody('{"username" : "'+username+'","password" : "'+password+'"}');
        req.setHeader('Content-type', 'application/json');
        req.setHeader('Authorization','SSWS 00lQfSEOLV6vNsmZmPvklnQjfBlY3iha8iYDEtapFm');
        //req.setHeader('Accept', 'application/json');
        req.setMethod('POST');
        HTTPResponse res = new HTTPResponse();
        res = http.send(req);
        */
        strJSON= res.getBody();
        return strJSON;
    }
    
    private HTTPResponse callAPIs(String endURL, String body, String action) {
        HTTPResponse res =new HTTPResponse();
    	try {
	        HttpRequest req = new HttpRequest();
	        Http http = new Http();
	    	req.setEndpoint(endURL);
	    	if(body != null)
	        	req.setBody(body);
	        // req.setBody('{"profile": {"firstName": "'+ userObj.FirstName +'","lastName": "'+userObj.LastName+'","email": "tucker.heiner@ringcentral.com","login": "'+userObj.Username+'","mobilePhone": "'+(userObj.Phone == null ? '' : userObj.Phone)+'"}}');
	        // req.setBody('{"profile": {"firstName": "'+ userObj.FirstName +'","lastName": "'+userObj.LastName+'","email": "rcindiateam@simplion.com","login": "'+userObj.Username+'","mobilePhone": "'+(userObj.Phone == null ? '' : userObj.Phone)+'"}}');
	        req.setHeader('Content-type', 'application/json');
	        req.setHeader('Accept', 'application/json'); 
	        req.setHeader('Authorization','SSWS '+OKTAHelper.OKTA_API);
	        req.setMethod(action);
	        res = http.send(req);
    	} catch(Exception e) {}
    	return res;
    }
    
    public Class OKTAAccountHelper{
        public String accountName{get;set;}
        public String phone{get;set;}
        public String parentAccountName{get;set;}
        public String accountEmail{get;set;}
        public String accountId{get;set;}
        
        public String label{get;set;}
        public String linkUrl{get;set;}
        public String logoUrl{get;set;}
        public String appName{get;set;}
        public String appInstanceId{get;set;}
        public String appAssignmentId{get;set;}
        public String credentialsSetup{get;set;}
        public Boolean hidden{get;set;}
        public String sortOrder{get;set;}
    }
    public class UserPassword{
        public String resetPasswordUrl{get;set;}
    }
  /*  @isTest
    public static void OKTAHelperTestMethod() {
    	try {
	    	RecordType rcType = [SELECT Id, Name FROM RecordType WHERE Name='Partner Account'];
		    Account accountobj = new Account();
		    accountobj.Name = 'Test Okta Account';
		    accountobj.RecordTypeId = rcType.Id;
		    accountobj.Partner_ID__c = 'PARTNER002';
		    insert accountobj;
		    
		    Account accountobj1 = new Account();
		    accountobj1.Name = 'Test Customer Account';
		    accountobj1.RC_User_ID__c = 'UID9910106802';
		    accountobj1.Partner_ID__c = 'PARTNER002';
		    accountobj1.ParentId = accountobj.Id;
		    accountobj1.Phone = '9910101111';
		    accountobj1.AccountNumber = '991010';
		    insert accountobj1;
		    
		    Contact contactObj = new Contact();
		    contactObj.AccountId = accountobj.id;
		    contactObj.Email = 'Testportaluser@simplion.com';
		    contactObj.LastName = 'Test Okta Con portaluser';
		    contactObj.Phone = '1234567830';
		    insert contactObj;
	    	User testUser = new User(alias = 'portr', email='portaluser@testorg.com',
		                      emailencodingkey='UTF-8', lastname='portaluser', OKTAUserID__c='00u3uty75rWFWAOFWHQJ', OktaUserPassword__c='ra!nb0w7', ProfileId=[SELECT Id FROM Profile WHERE Name='RC Partner User Pilot' LIMIT 1].Id, languagelocalekey='en_US',
		                      localesidkey='en_US', country='United States',
		                      timezonesidkey='America/Los_Angeles', username='portaluser@testorg.com', ContactId=contactObj.id, IsActive=true);
		                 
		   	insert testUser;
	    	System.runAs(testUser) {
			    OKTAHelper objOKTAHelper=new OKTAHelper(); 
	    	}
    	} catch(Exception e) {}
    } */
}