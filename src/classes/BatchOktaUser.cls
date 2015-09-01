global class BatchOktaUser implements Database.Batchable<sObject>,Database.AllowsCallouts {
	public string strQuery;
	public static String OKTA_URL = 'https://myaccounts-ringcentral.okta.com'; 
 	public static String OKTA_API = '00lQfSEOLV6vNsmZmPvklnQjfBlY3iha8iYDEtapFm';
 	private static String OKTA_PASSWORD = 'Ra!nb0w7';
 	
 	User userObj;
	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator(strQuery);
	}
	
	// To execute the batch process for every partner user 
	global void execute(Database.BatchableContext BC, List<sObject> scope) {  
		try {
			userObj = new User();
       		for(sObject objUsr : scope) {
       	  		userObj =(User)objUsr;
        	}
        	if(userObj.Profile.Name.contains('Full')) {
				getUserInformation(userObj.id);
				getOktaApplicationList();
				getCustomerAccountUserId();
				WrUser userObjOkta = createOktaUser();
				if(userObjOkta != null && userObjOkta.id != null) {
					assignOktaAppToOktaUser(userObjOkta.id);
					userObj.OKTAUserID__c = userObjOkta.id;
					userObj.OktaUserPassword__c = OKTA_PASSWORD;
					update userObj;
					if(mapApplicationIdToAccount != null && mapApplicationIdToAccount.values() != null) {
						update mapApplicationIdToAccount.values();
					}
				}
			}
		} catch(Exception exp) {
			
		}
	}
	
	global void finish(Database.BatchableContext info) {
		try {
		    strQuery = null;
		} catch(Exception exp) {
			
		}
	}
	
	// Get All Okta application list
	set<string> setRCUserId = new set<string>();
	map<string,string> mapLabelIdToApplicationId = new map<string,string>(); 
	public void getOktaApplicationList() {
		string jsonBody;
		string formatJsonString;
		if(!Test.isRunningTest()) {
			jsonBody = callAPIs(OKTA_URL + '/api/v1/apps?filter=status+eq+\"ACTIVE\"&limit=1000',null,'GET');
			formatJsonString = jsonBody.replace('_links','links');
		} else {
			formatJsonString = '[{"id":"0oa3zzaqg5KFOSDKNOAT","name":"ringcentral","label":"UID6505392405","status":"ACTIVE","lastUpdated":"2013-07-27T18:27:47.000Z","created":"2013-04-30T20:50:07.000Z","accessibility":{"selfService":false,"errorRedirectUrl":null},"licensing":{"seatCount":0},"visibility":{"autoSubmitToolbar":false,"hide":{"iOS":false,"web":false},"appLinks":{"login":true}},"features":[],"signOnMode":"BROWSER_PLUGIN","credentials":{"scheme":"EDIT_PASSWORD_ONLY","userNameTemplate":{"template":"6505392405","type":"CUSTOM"}},"settings":{"app":{}},"links":{"logo":[{"name":"medium","href":"https://myaccounts-ringcentral.okta.com/img/logos/ringcentral.png","type":"image/png"}],"appLinks":[{"name":"login","href":"https://myaccounts-ringcentral.okta.com/home/ringcentral/0oa3zzaqg5KFOSDKNOAT/58","type":"text/html"}],"users":{"href":"https://myaccounts-ringcentral.okta.com/api/v1/apps/0oa3zzaqg5KFOSDKNOAT/users"},"deactivate":{"href":"https://myaccounts-ringcentral.okta.com/api/v1/apps/0oa3zzaqg5KFOSDKNOAT/lifecycle/deactivate"},"groups":{"href":"https://myaccounts-ringcentral.okta.com/api/v1/apps/0oa3zzaqg5KFOSDKNOAT/groups"}}}]';
		}
		List<WrApplication> lstWRApplication = (List<WrApplication>)System.Json.deserialize(formatJsonString ,List<WrApplication>.class);
		System.Debug('>>lstWRApplication>>'+ lstWRApplication.size());
		setRCUserId = new set<string>();
		mapLabelIdToApplicationId = new map<string,string>();  
		for(WrApplication wrObj : lstWRApplication) {
			if(wrObj.label.indexOf('UID') > -1){
                setRCUserId.add(wrObj.label.split('UID')[1].trim());
                mapLabelIdToApplicationId.put(wrObj.label.split('UID')[1].trim(),wrObj.id);
            }
		}
		System.Debug('>>setRCUserId>>'+ setRCUserId);
		System.Debug('>>mapLabelIdToApplicationId>>'+ mapLabelIdToApplicationId);
	}
	
	// Get Customer accounts information
	set<string> setUserId = new set<string>();
	map<string,string> mapRCUserIdToAccountNumber = new map<string,string>();
	map<string,Account> mapApplicationIdToAccount = new map<string,Account>();
	public void getCustomerAccountUserId() {
		try {
			setUserId = new set<string>();
			mapRCUserIdToAccountNumber = new map<string,string>();
			if(userObj != null && userObj.contact.Account.Partner_Id__c != null) {
				for(Account accObj : [select RC_User_ID__c,RC_Account_Number__c from Account where RecordType.Name = 'Customer Account' and 
													Partner_Id__c = :userObj.contact.Account.Partner_Id__c
													and Okta_Enabled__c = 'Customer Enabled']) {
					setUserId.add(accObj.RC_User_ID__c);
					mapRCUserIdToAccountNumber.put(accObj.RC_User_ID__c,accObj.RC_Account_Number__c);
					if(mapLabelIdToApplicationId != null && accObj.RC_User_ID__c != null && 
							mapLabelIdToApplicationId.get(accObj.RC_User_ID__c) != null) {
						mapApplicationIdToAccount.put(mapLabelIdToApplicationId.get(accObj.RC_User_ID__c),accObj);
					}
				}								
			}
		} catch(Exception ex) {}
	}
	
	// Get User information
	public void getUserInformation(string userId) {
		try {
			userObj = [select contact.Account.Partner_Id__c,contact.Account.RC_Account_Number__c, firstName, LastName,email, username
							from User where Id = :userId]; //: '005S0000004Rm71''];
		} catch(Exception ex) {}
	}
	
	// Create Okta User
	public WrUser createOktaUser() {
		try {
			string formatJsonString;
			string strbody = '{"profile": { "firstName": "'+ (!string.isBlank(userObj.FirstName) ? userObj.FirstName : null) +'", "lastName": "'+ userObj.LastName +'","email": "'+ userObj.email +'","login": "'+ userObj.username +'"},"credentials": {"password" : {"value": "'+ OKTA_PASSWORD +'"},"recovery_question": { "question": "What is name of your company?","answer": "ringcentral"}}}';
			System.debug('>>>>>1234>>'+ strbody);
			if(!Test.isRunningTest()) {
				string strRtnBody = callAPIs(OKTA_URL + '/api/v1/users?activate=true',strBody,'POST');
				System.debug('>>>>>1235>>'+ strRtnBody);
				formatJsonString = strRtnBody.replace('_links','links').replace('recovery_question','recoveryquestion');
			} else {
				formatJsonString = '{"id":"00uvytzkcpPUKJDNLIUW","status":"ACTIVE","created":"2014-06-18T12:02:13.512Z","activated":"2014-06-18T12:02:14.146Z","statusChanged":"2014-06-18T12:02:14.146Z","lastLogin":null,"lastUpdated":"2014-06-18T12:02:14.146Z","profile":{"firstName":"null","lastName":"TestL18June4","email":"testl18june4@test.com","login":"testl18june4@test.com","mobilePhone":null},"credentials":{"password":{},"recoveryquestion":{"question":"What is name of your company?"}},"links":{"resetPassword":{"href":"https://myaccounts-ringcentral.okta.com/api/v1/users/00uvytzkcpPUKJDNLIUW/lifecycle/reset_password","method":"POST"},"expirePassword":{"href":"https://myaccounts-ringcentral.okta.com/api/v1/users/00uvytzkcpPUKJDNLIUW/lifecycle/expire_password","method":"POST"},"forgotPassword":{"href":"https://myaccounts-ringcentral.okta.com/api/v1/users/00uvytzkcpPUKJDNLIUW/credentials/forgot_password","method":"POST"},"changeRecoveryQuestion":{"href":"https://myaccounts-ringcentral.okta.com/api/v1/users/00uvytzkcpPUKJDNLIUW/credentials/change_recoveryquestion","method":"POST"},"deactivate":{"href":"https://myaccounts-ringcentral.okta.com/api/v1/users/00uvytzkcpPUKJDNLIUW/lifecycle/deactivate","method":"POST"},"changePassword":{"href":"https://myaccounts-ringcentral.okta.com/api/v1/users/00uvytzkcpPUKJDNLIUW/credentials/change_password","method":"POST"}}}';
			}
			System.debug('>>>>>1236>>'+ formatJsonString);
			WrUser wrUserObj = (WrUser)System.Json.deserialize(formatJsonString ,WrUser.class); 
			System.Debug('>>wrUserObj>>'+ wrUserObj);
			return wrUserObj;
		} catch(Exception ex) {
			System.Debug('>>exception >>'+ ex.getMessage());
		}
		return null;
	}
	
	// Assign Okta applications to created user.
	set<string> setApplicationIdToAssign = new set<string>();
	map<string,string> mapApplicationIdToAccountNumber = new map<string,string>();
	public void assignOktaAppToOktaUser(string oktaUserId) {
		System.Debug('>>setUserId>>'+ setUserId);
		mapApplicationIdToAccountNumber = new map<string,string>();
		for(string strObj : setUserId) {
			if(mapLabelIdToApplicationId != null && mapLabelIdToApplicationId.containskey(strObj.trim())) {
				System.Debug('>>111>>');
				setApplicationIdToAssign.add(mapLabelIdToApplicationId.get(strObj));
				mapApplicationIdToAccountNumber.put(mapLabelIdToApplicationId.get(strObj),mapRCUserIdToAccountNumber.get(strObj));
			}
		}
		System.Debug('>>setApplicationIdToAssign>>'+ setApplicationIdToAssign);
		for(string strObj : setApplicationIdToAssign) {
			string rtnBody;
			System.Debug('>>mapApplicationIdToAccountNumber.get(strObj)>>'+ mapApplicationIdToAccountNumber.get(strObj));
			string strBody = '{"id": "'+oktaUserId+'","scope": "USER","credentials": {"userName": "'+mapApplicationIdToAccountNumber.get(strObj)+'","password": { "value": "" }}}';
	        if(!Test.isRunningTest()) {
	        	rtnBody = callAPIs(OKTA_URL + '/api/v1/apps/'+strObj+'/users/'+oktaUserId,strBody,'PUT');
				if(mapApplicationIdToAccount != null && mapApplicationIdToAccount.get(strObj) != null) {
					Account accObjToUpd = mapApplicationIdToAccount.get(strObj);
					if(rtnBody == 'Limit Exception Occured') {
						accObjToUpd.Is_Error_Occured_Okta__c = true;
					} else {
						accObjToUpd.Is_Error_Occured_Okta__c = false;
					}
					mapApplicationIdToAccount.put(strObj,accObjToUpd);
				}
	        }
		}
	}
	
	/*************************************** Application Data structure ******************************************************/
	public class WrApplication {
		string id;
		string name;
		string label;
		string status;
		string lastUpdated;
		string created;
		WRAppLinks links;
		WRAccessibility accessibility;
		WRLicensing licensing;
		string signOnMode;
		List<string> features;
		WRVisibility visibility;
		WRCredentials credentials;
		WRSettings settings;
	}
	
	public class WRAppLinks {
		List<WRLinks> appLinks;
		List<WRLinks> logo;
		WRLinks users;
		WRLinks deactivate;
		WRLinks groups;
		WRLinks metadata;
        WRLinks activate1;
	}
	
	public class WRLinks {
		string href;
		string name;
		string type;
	}
	
	public class WRAccessibility {
		boolean selfService;
		string errorRedirectUrl;
	}
	
	public class WRLicensing {
		string seatCount;
	}
	
	public class WRVisibility {
		string autoSubmitToolbar;
		WRAppLinks1 appLinks;
		WRHide hide;
	}
	
	public class WRHide {
		boolean iOS;
		boolean web;
	}
	
	public class WRAppLinks1 {
		boolean login;
		boolean mc;
        boolean main;
	}
	
	public class WRCredentials {
		string scheme;
		WRUserNameTemplate userNameTemplate;
		string userName;
        WRPassword1 password;
	}
	
	public class WRUserNameTemplate {
		string template;
		string type;
	}
	
	public class WRPassword1 {
        
    }
	
	public class WRSettings {
	   WRAPP app;	
	}
	
	public class WRAPP {
		string audienceRestriction;
		string groupName;
		string groupValueFormat;
		string realm;
		string buttonField;
		string passwordField;
		string usernameField;
		string url;
		string optionalField1Value;
		string optionalField2Value;
		string optionalField3Value;
		string optionalField1;
		string optionalField2;
		string optionalField3;
		string instanceType;
        string customDomain;
        string loginUrl;
        string acsURL;
        string spEntityId;
        string region;
        string sfdcIssuer;
        string sandboxLoginURL;
        string portalID;
        string siteURL;
        string orgID;
        string defaultPage;
	}
	
	/**************************************** User Data structure ************************************************************************/
	public class WrUser {
		string id;
		string status;
		string created;
		string activated;
		string statusChanged;
		string lastLogin;
		string lastUpdated;
		string passwordChanged;
		WRProfile profile;
		WRCredentials1 credentials;
		WRLinks2 links;
	}
	
	public class WRProfile {
		string firstName;
		string lastName;
		string email;
		string login;
		string mobilePhone;
	}
	
	public class WRCredentials1 {
		WRPassword password;
		WRRecoveryQuestion recoveryquestion;
		WRProvider provider;
	}
	
	public class WRPassword {
		string value;
	}
	
	public class WRRecoveryQuestion {
		string question;
	}
	
	public class WRProvider {
		string type;
		string name;
	}
	
	public class WRLinks2 {
		WRActivate resetPassword;
		WRActivate expirePassword;
		WRActivate forgotPassword;
		WRActivate changeRecoveryQuestion;
		WRActivate deactivate;
		WRActivate changePassword;
		WRActivate activate1;
	}
	
	public class WRActivate {
		string href;
		string method;
	}
	
	// General Method to call API's
	public String callAPIs(String endURL, String body, String action) {
		if(Limits.getCallouts() < Limits.getLimitCallouts()) { 
	        Http http = new Http();
	        HttpRequest req = new HttpRequest();
	    	req.setEndpoint(endURL);
	    	if(body != null) {
	    		req.setBody(body);
	    	}
	        req.setHeader('Content-type', 'application/json');
	        req.setHeader('Accept', 'application/json'); 
	        req.setHeader('Authorization','SSWS '+ EnableOkta.OKTA_API);
	        req.setMethod(action);
	        HTTPResponse res =new HTTPResponse();
	        if(!test.isRunningTest())
	        	res = http.send(req);
	        return res.getBody();
		} else {
			return 'Limit Exception Occured';
		}
		return null;
    }
}