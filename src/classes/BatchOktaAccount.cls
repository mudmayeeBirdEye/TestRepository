global class BatchOktaAccount implements Database.Batchable<sObject>,Database.AllowsCallouts {
	public string strQuery;
	public static String OKTA_URL = 'https://myaccounts-ringcentral.okta.com'; 
 	public static String OKTA_API = '00lQfSEOLV6vNsmZmPvklnQjfBlY3iha8iYDEtapFm';
 	private static String OKTA_PASSWORD = 'Ra!nb0w7';
 	public Account accountObj;
 	Account partnerAccount;
 	map<Id,User> mapUserToUpd = new map<Id,User>();
 	boolean flagToCreateApplication;
 	
 	global Database.QueryLocator start(Database.BatchableContext BC) {
 		strQuery = 'select id, recordType.Name, Partner_Id__c, RC_User_ID__c, RC_Account_Number__c ' + 
 						' from Account where Is_Error_Occured_Okta__c = true and RecordType.Name = \'Customer Account\' ';
		return Database.getQueryLocator(strQuery); 
	}
	
	// To execute the batch for account with have error occurred check true 
	global void execute(Database.BatchableContext BC, List<sObject> scope) {  
		try {
			accountObj = new Account();
       		for(sObject objSOject : scope) {
       	  		accountObj =(Account)objSOject;
        	}
        	if(accountObj.recordType.Name == 'Customer Account' && !string.isBlank(accountObj.Partner_Id__c)
					&& !string.isBlank(accountObj.RC_User_ID__c) && !string.isBlank(accountObj.RC_Account_Number__c)) {
        		partnerAccount = [select Okta_Enabled__c from Account where Partner_Id__c = :accountObj.Partner_Id__c limit 1];
				getAllOktaUser();
				getUsersOnPartnerAccount(partnerAccount.id);
				prepareUserListToCreateOnOkta();
				flagToCreateApplication = checkApplicationExist();
				System.debug('>>>flag1>>' + flagToCreateApplication);  
				excuteProcess();
        	}
		} catch(Exception exp) {}
	}
	
	global void finish(Database.BatchableContext info) {
		try {
		    strQuery = null;
		} catch(Exception exp) {}
	}
	
	// To execute/start the process
	public void excuteProcess() {
		try {
			system.Debug('>>>>setUserName>'+setUserName);
			system.Debug('>>>>applicationId>'+applicationId);
			if(!flagToCreateApplication) {
				System.debug('>>>flag1>>' + flagToCreateApplication);
				createOktaApplication();
			}  else if(mapapplicationIDToApplicationStatus != null && applicationId != null && 
					mapapplicationIDToApplicationStatus.get(applicationId) == 'INACTIVE') {
				activateOktaAppliation(applicationId);	
			}
			
			if(setUserName != null && setUserName.size()>0 && !string.isBlank(applicationId)) {  
				for(string strObj : setUserName) {
					System.Debug('>>>Limit 1>>>' + Limits.getCallouts());
					System.Debug('>>>Limit 2>>>'+ Limits.getLimitCallouts());
					if(setUserNameToCreateOkta != null && !setUserNameToCreateOkta.contains(strObj)) {
						System.Debug('>>>>1235>>>');
						System.Debug('>>>Status>>>'+ mapOktaLoginToStatus.get(strObj));
						if(setAppAssignedUserId != null && !setAppAssignedUserId.contains(mapOktaLoginToOktaId.get(strObj))) {
							if(mapOktaLoginToStatus.get(strObj) == 'DEPROVISIONED') {
								activateOktaUserFromDeactivate(mapOktaLoginToOktaId.get(strObj));
								activateOktaUserFromPWDResetStatus(mapOktaLoginToOktaId.get(strObj),mapLoginNameToUser.get(strObj));
							} else if(mapOktaLoginToStatus.get(strObj) != 'ACTIVE') {
								activateOktaUserFromPWDResetStatus(mapOktaLoginToOktaId.get(strObj),mapLoginNameToUser.get(strObj));
							}
							assignOktaApplication(mapOktaLoginToOktaId.get(strObj));
						}
					} else {
						System.Debug('>>>>1236>>>');
						WrUser wrUserRtn = createOktaUser(mapLoginNameToUser.get(strObj));
						if(wrUserRtn != null && wrUserRtn.id != null) {
							assignOktaApplication(wrUserRtn.id);
						}
					}
				}
			}
			List<Account> lstAccountToUpd = new List<Account>();
			accountObj.Okta_Enabled__c = 'Customer Enabled';
			partnerAccount.Okta_Enabled__c = 'Partner Enabled';
			//accountObj.Is_Error_Occured_Okta__c = false; 
			lstAccountToUpd.add(accountObj);
			lstAccountToUpd.add(partnerAccount);
			TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT = true;
			TriggerHandler.BY_PASS_ACCOUNT_ON_UPDATE = true;
			if(lstAccountToUpd.size()>0) {
				update lstAccountToUpd;			
			}
			if(mapUserToUpd != null && mapUserToUpd.values() != null) {
				if(!Test.isRunningTest()) {
					update mapUserToUpd.values();
				}
			}
		} catch(Exception ex) {
			System.Debug('>>>12345>>>'+ ex.getMessage());
		}
	}
	
	// Get All Okta User(Active Or Deactivated)
	map<string,string> mapOktaLoginToOktaId = new map<string,string>();
	map<string,string> mapOktaLoginToStatus = new map<string,string>();
	public void getAllOktaUser() {
		try {
			string formatJsonString;
			mapOktaLoginToOktaId = new map<string,string>();
			mapOktaLoginToStatus = new map<string,string>();
			if(!Test.isRunningTest()) {
				//string strRtnBody = callAPIs(OKTA_URL + '/api/v1/users?filter=status+eq+\"ACTIVE\"',NULL,'GET');
				// ALL Okta User(Not Deactivated User)
				string strRtnBody = callAPIs(OKTA_URL + '/api/v1/users',NULL,'GET');
				formatJsonString = strRtnBody.replace('_links','links').replace('recovery_question','recoveryquestion');
			} else {
				formatJsonString = '[{"id":"00u2pfo17aFANLNGWUQK","status":"ACTIVE","created":"2013-02-26T17:30:30.000Z","activated":null,"statusChanged":null,"lastLogin":"2014-01-21T22:40:00.000Z","lastUpdated":"2014-04-14T08:40:14.000Z","profile":{"firstName":"Okta","lastName":"Admin","email":"jgazarik@okta.com","login":"oktaadmin@okta.com","mobilePhone":null},"credentials":{"password":{},"recoveryquestion":{"question":"Your maternal grandmother\'s maiden name?"}},"links":{"resetPassword":{"href":"https://myaccounts-ringcentral.okta.com/api/v1/users/00u2pfo17aFANLNGWUQK/lifecycle/reset_password","method":"POST"},"expirePassword":{"href":"https://myaccounts-ringcentral.okta.com/api/v1/users/00u2pfo17aFANLNGWUQK/lifecycle/expire_password","method":"POST"},"forgotPassword":{"href":"https://myaccounts-ringcentral.okta.com/api/v1/users/00u2pfo17aFANLNGWUQK/credentials/forgot_password","method":"POST"},"changeRecoveryQuestion":{"href":"https://myaccounts-ringcentral.okta.com/api/v1/users/00u2pfo17aFANLNGWUQK/credentials/change_recoveryquestion","method":"POST"},"deactivate":{"href":"https://myaccounts-ringcentral.okta.com/api/v1/users/00u2pfo17aFANLNGWUQK/lifecycle/deactivate","method":"POST"},"changePassword":{"href":"https://myaccounts-ringcentral.okta.com/api/v1/users/00u2pfo17aFANLNGWUQK/credentials/change_password","method":"POST"}}}]';
			}
			System.debug('>>>>rtnJsonBody>>'+ formatJsonString);
			List<WrUser> lstWrUser = (List<WrUser>)System.Json.deserialize(formatJsonString ,List<WrUser>.class);
			System.debug('>>>>lstWrUser>>'+ lstWrUser);
			for(WrUser wrUserObj : lstWrUser) {
				mapOktaLoginToOktaId.put(wrUserObj.profile.login,wrUserObj.id);
				mapOktaLoginToStatus.put(wrUserObj.profile.login,wrUserObj.status);
			}
			
			//System.debug('>>>>mapOktaLoginToOktaId>>'+ mapOktaLoginToOktaId);
			//System.debug('>>>>mapOktaLoginToStatus>>'+ mapOktaLoginToStatus);
			
			formatJsonString = null;
			lstWrUser = new List<WrUser>();
			
			if(!Test.isRunningTest()) {
				// Only Deactivated User
				string strRtnBody = callAPIs(OKTA_URL + '/api/v1/users?filter=status+eq+\"DEPROVISIONED\"',NULL,'GET');
				formatJsonString = strRtnBody.replace('_links','links').replace('recovery_question','recoveryquestion').replace('activate','activate1');
				formatJsonString = formatJsonString.replace('activate1d','activated');
			} else {
				formatJsonString = '[{"id":"00u2pfo17aFANLNGWUQK","status":"ACTIVE","created":"2013-02-26T17:30:30.000Z","activated":null,"statusChanged":null,"lastLogin":"2014-01-21T22:40:00.000Z","lastUpdated":"2014-04-14T08:40:14.000Z","profile":{"firstName":"Okta","lastName":"Admin","email":"jgazarik@okta.com","login":"oktaadmin@okta.com","mobilePhone":null},"credentials":{"password":{},"recoveryquestion":{"question":"Your maternal grandmother\'s maiden name?"}},"links":{"resetPassword":{"href":"https://myaccounts-ringcentral.okta.com/api/v1/users/00u2pfo17aFANLNGWUQK/lifecycle/reset_password","method":"POST"},"expirePassword":{"href":"https://myaccounts-ringcentral.okta.com/api/v1/users/00u2pfo17aFANLNGWUQK/lifecycle/expire_password","method":"POST"},"forgotPassword":{"href":"https://myaccounts-ringcentral.okta.com/api/v1/users/00u2pfo17aFANLNGWUQK/credentials/forgot_password","method":"POST"},"changeRecoveryQuestion":{"href":"https://myaccounts-ringcentral.okta.com/api/v1/users/00u2pfo17aFANLNGWUQK/credentials/change_recoveryquestion","method":"POST"},"deactivate":{"href":"https://myaccounts-ringcentral.okta.com/api/v1/users/00u2pfo17aFANLNGWUQK/lifecycle/deactivate","method":"POST"},"changePassword":{"href":"https://myaccounts-ringcentral.okta.com/api/v1/users/00u2pfo17aFANLNGWUQK/credentials/change_password","method":"POST"}}}]';
			}
			System.debug('>>>>rtnJsonBody>>'+ formatJsonString);
			lstWrUser = (List<WrUser>)System.Json.deserialize(formatJsonString ,List<WrUser>.class);
			System.debug('>>>>lstWrUser>>'+ lstWrUser);
			for(WrUser wrUserObj : lstWrUser) {
				mapOktaLoginToOktaId.put(wrUserObj.profile.login,wrUserObj.id);
				mapOktaLoginToStatus.put(wrUserObj.profile.login,wrUserObj.status);
			}
			System.debug('>>>>mapOktaLoginToOktaId>>'+ mapOktaLoginToOktaId);
			System.debug('>>>>mapOktaLoginToStatus>>'+ mapOktaLoginToStatus);
		} catch(Exception ex) {}
	}
	
	// Get All Partner Users on Partner Account with Profile contains FULL.
	set<String> setUserName = new set<String>();
	map<string,User> mapLoginNameToUser = new map<string,User>();
	public void getUsersOnPartnerAccount(string partnerAccountId) {
		try {
			for(User userObj :  [select id,username,firstname,lastname,email 
									from User where IsActive = true and Contact.AccountId = :partnerAccountId and profile.Name like '%Full%']) {
				setUserName.add(userObj.username);
				mapLoginNameToUser.put(userObj.username,userObj);
			}
		} catch(Exception ex) {}
	}
	
	// Prepare List of partners users for which Okta Uses needs to create
	set<string> setUserNameToCreateOkta = new set<string>();
	public void prepareUserListToCreateOnOkta() {
		try {
			if(setUserName != null && setUserName.size()>0) {
				for(string strObj : setUserName) {
					if(mapOktaLoginToOktaId != null && !mapOktaLoginToOktaId.containsKey(strObj)) {
						setUserNameToCreateOkta.add(strObj);
					}
				}
			}
			System.Debug('>>>>1234>>>'+setUserNameToCreateOkta);
		} catch(Exception ex) {}
	}
	
	// To check is application already exist on Okta or not
	public boolean checkApplicationExist() {
		try {
			getOktaApplicationList();
			System.Debug('>>>@@>>>' + mapLabelIdToApplicationId);
			System.Debug('>>>@@@>>>' + accountObj.RC_User_ID__c); 
			if(setRCUserId != null && setRCUserId.size()>0 && accountObj.RC_User_ID__c != null && setRCUserId.contains(accountObj.RC_User_ID__c)) {
				System.Debug('>>>@@@@>>>');
				applicationId = mapLabelIdToApplicationId.get(accountObj.RC_User_ID__c);
				prepareUserListAssignedToApplication();
				return true;
			}
		} catch(Exception ex) {
		
		}
		return false;
	}
	
	// Prepare list of Okta user for application is already assigned
	set<string> setAppAssignedUserId = new set<string>();
	public void prepareUserListAssignedToApplication() {
		setAppAssignedUserId = new set<string>();
		string strRtnBody; 
		if(!Test.isRunningTest()) {
			strRtnBody = callAPIs(OKTA_URL + '/api/v1/apps/'+ applicationId +'/users',null,'GET');
		} else {
			strRtnBody = '[{"id": "00uw4n2yebSZPWGCGMMF","externalId": null,"created": "2014-06-27T07:32:52.000Z","lastUpdated": "2014-06-27T07:36:58.000Z","scope": "USER","status": "ACTIVE","statusChanged": "2014-06-27T07:32:52.000Z","passwordChanged": null,"syncState": "DISABLED","lastSync": null,"credentials": {"userName": "TestC27JuneAN 4"},"profile": {},"links": {"app": {"href": "https://myaccounts-ringcentral.okta.com/api/v1/apps/0oaw4ne9y4COFMUPPYLU"},"user": {"href": "https://myaccounts-ringcentral.okta.com/api/v1/users/00uw4n2yebSZPWGCGMMF"}}}]';
		}
		if(strRtnBody != null) {
			System.Debug('>>>>strRtnBody>'+ strRtnBody);
			string formatJsonString = strRtnBody.replace('_links','links');
			List<WrUserApp> wrUserAppLstObj =  (List<WrUserApp>)System.Json.deserialize(formatJsonString ,List<WrUserApp>.class);
			System.Debug('>>>>wrUserAppObj>>'+ wrUserAppLstObj);
			if(wrUserAppLstObj != null && wrUserAppLstObj.size() >0) {
				for(WrUserApp wrUserAppObj : wrUserAppLstObj) {
					setAppAssignedUserId.add(wrUserAppObj.id);
				}
			}
		}
	}
	
	// Get All Okta Application List 
	set<string> setRCUserId = new set<string>();
	map<string,string> mapLabelIdToApplicationId = new map<string,string>(); 
	map<string,string> mapapplicationIDToApplicationStatus = new map<string,string>();
	public void getOktaApplicationList() {
		try {
			string jsonBody;
			string formatJsonString;
			if(!Test.isRunningTest()) {
				//jsonBody = callAPIs(OKTA_URL + '/api/v1/apps?filter=status+eq+\"ACTIVE\"&limit=1000',null,'GET');
				jsonBody = callAPIs(OKTA_URL + '/api/v1/apps?limit=1000',null,'GET');
                formatJsonString = jsonBody.replace('_links','links').replace('activate','activate1');
                formatJsonString = formatJsonString.replace('activate1d','activated').replace('deactivate1','deactivate');
				System.Debug('>>>>formatJsonString>'+ formatJsonString);
			} else {
				formatJsonString = '[{"id":"0oa3zzaqg5KFOSDKNOAT","name":"ringcentral","label":"UID TestRCC100","status":"ACTIVE","lastUpdated":"2013-07-27T18:27:47.000Z","created":"2013-04-30T20:50:07.000Z","accessibility":{"selfService":false,"errorRedirectUrl":null},"licensing":{"seatCount":0},"visibility":{"autoSubmitToolbar":false,"hide":{"iOS":false,"web":false},"appLinks":{"login":true}},"features":[],"signOnMode":"BROWSER_PLUGIN","credentials":{"scheme":"EDIT_PASSWORD_ONLY","userNameTemplate":{"template":"6505392405","type":"CUSTOM"}},"settings":{"app":{}},"links":{"logo":[{"name":"medium","href":"https://myaccounts-ringcentral.okta.com/img/logos/ringcentral.png","type":"image/png"}],"appLinks":[{"name":"login","href":"https://myaccounts-ringcentral.okta.com/home/ringcentral/0oa3zzaqg5KFOSDKNOAT/58","type":"text/html"}],"users":{"href":"https://myaccounts-ringcentral.okta.com/api/v1/apps/0oa3zzaqg5KFOSDKNOAT/users"},"deactivate":{"href":"https://myaccounts-ringcentral.okta.com/api/v1/apps/0oa3zzaqg5KFOSDKNOAT/lifecycle/deactivate"},"groups":{"href":"https://myaccounts-ringcentral.okta.com/api/v1/apps/0oa3zzaqg5KFOSDKNOAT/groups"}}}]';
			}
			List<WrApplication> lstWRApplication = (List<WrApplication>)System.Json.deserialize(formatJsonString ,List<WrApplication>.class);
			//System.Debug('>>lstWRApplication>>'+ lstWRApplication.size());
			setRCUserId = new set<string>();
			mapLabelIdToApplicationId = new map<string,string>();
			mapapplicationIDToApplicationStatus = new map<string,string>();    
			for(WrApplication wrObj : lstWRApplication) {
				if(wrObj.label.indexOf('UID') > -1){
	                setRCUserId.add(wrObj.label.split('UID')[1].trim());
	                mapLabelIdToApplicationId.put(wrObj.label.split('UID')[1].trim(),wrObj.id);
	                mapapplicationIDToApplicationStatus.put(wrObj.id.trim(),wrObj.status);
	            }
			}
			System.Debug('>>setRCUserId>>'+ setRCUserId);
			System.Debug('>>mapLabelIdToApplicationId>>'+ mapLabelIdToApplicationId);
			System.Debug('>>mapapplicationIDToApplicationStatus>>'+ mapapplicationIDToApplicationStatus);
		} catch(Exception ex) {
			System.Debug('>>ex>>'+ ex.getMessage());
		} 
	}
	
	// To create an Okta application with customer account details
	string applicationId;
	private void createOktaApplication() {
		applicationId = '';
		string strFormatJson;
		string strbody = '{"name":"ringcentral","label":"UID '+ accountObj.RC_User_ID__c +'","signOnMode":"SAML_2_0","settings":{"app":{"'+
		'createNewFolder":null,"pushGroupsWithSAML":null,"folderPermission":null,"siteURL":"test","parentFolderId":null,"parentFolderPath":null,'+
		'"groupFilter":null}},"credentials": {"scheme": "EDIT_PASSWORD_ONLY","userNameTemplate": {"type": "CUSTOM","template":"'+ accountObj.RC_Account_Number__c +'"}}}';
		System.Debug('>>>strbody>>>'+ strbody);
		if(!Test.isRunningTest()) {
			string strRtnJsonBody = callAPIs(OKTA_URL + '/api/v1/apps', strbody, 'POST');
			system.debug('>>strRtnJsonBody>>>'+ strRtnJsonBody);
			strFormatJson = strRtnJsonBody.replace('_links','links');
			system.debug('>>strFormatJson>>>'+ strFormatJson);
		} else {
			strFormatJson = '{"id":"0oavytzk2nKNELDPDURP","name":"ringcentral","label":"UID TestRCC100","status":"ACTIVE","lastUpdated":"2014-06-18T11:38:04.206Z","created":"2014-06-18T11:38:04.036Z","accessibility":{"selfService":false,"errorRedirectUrl":null},"licensing":{"seatCount":0},"visibility":{"autoSubmitToolbar":false,"hide":{"iOS":false,"web":false},"appLinks":{"login":true}},"features":[],"signOnMode":"BROWSER_PLUGIN","credentials":{"scheme":"EDIT_PASSWORD_ONLY","userNameTemplate":{"template":"TestAN18June C2","type":"CUSTOM"}},"settings":{"app":{}},"links":{"logo":[{"name":"medium","href":"https://myaccounts-ringcentral.okta.com/img/logos/ringcentral.png","type":"image/png"}],"appLinks":[{"name":"login","href":"https://myaccounts-ringcentral.okta.com/home/ringcentral/0oavytzk2nKNELDPDURJ/58","type":"text/html"}],"users":{"href":"https://myaccounts-ringcentral.okta.com/api/v1/apps/0oavytzk2nKNELDPDURJ/users"},"deactivate":{"href":"https://myaccounts-ringcentral.okta.com/api/v1/apps/0oavytzk2nKNELDPDURJ/lifecycle/deactivate"},"groups":{"href":"https://myaccounts-ringcentral.okta.com/api/v1/apps/0oavytzk2nKNELDPDURJ/groups"}}}';
		}
		WrApplication wrAppObj = (WrApplication)System.Json.deserialize(strFormatJson,WrApplication.class);
		system.debug('>>wrAppObj>>>'+ wrAppObj);
		if(wrAppObj != null && wrAppObj.id != null) {
			applicationId = wrAppObj.id;
		}
	} 
	
	// To create an Okta User
	private WrUser createOktaUser(User userObj) {
	    string formatJsonString;
		string strbody = '{"profile": { "firstName": "'+ (!string.isBlank(userObj.FirstName) ? userObj.FirstName : null) +'", "lastName": "'+ userObj.LastName +'","email": "'+ userObj.email +'","login": "'+ userObj.username +'"},"credentials": {"password" : {"value": "'+OKTA_PASSWORD+'"},"recovery_question": { "question": "What is name of your company?","answer": "ringcentral"}}}';
		System.debug('>>>>>1234>>'+ strbody);
		if(!Test.isRunningTest()) {
			string strRtnBody = callAPIs(OKTA_URL + '/api/v1/users?activate=true',strBody,'POST');
			if(strRtnBody != null) {
				System.debug('>>>>>1235>>'+ strRtnBody);
				formatJsonString = strRtnBody.replace('_links','links').replace('recovery_question','recoveryquestion');
				System.debug('>>>>>1236>>'+ formatJsonString);
				WrUser wrUserObj = (WrUser)System.Json.deserialize(formatJsonString ,WrUser.class);
				userObj.OKTAUserID__c = wrUserObj.id;
				userObj.OktaUserPassword__c = OKTA_PASSWORD;
				mapUserToUpd.put(userObj.id,userObj);
				return wrUserObj;
			} 
		} else {
			formatJsonString = '{"id":"00uvytzkcpPUKJDNLIUW","status":"ACTIVE","created":"2014-06-18T12:02:13.512Z","activated":"2014-06-18T12:02:14.146Z","statusChanged":"2014-06-18T12:02:14.146Z","lastLogin":null,"lastUpdated":"2014-06-18T12:02:14.146Z","profile":{"firstName":"null","lastName":"TestL18June4","email":"testl18june4@test.com","login":"testl18june4@test.com","mobilePhone":null},"credentials":{"password":{},"recoveryquestion":{"question":"What is name of your company?"}},"links":{"resetPassword":{"href":"https://myaccounts-ringcentral.okta.com/api/v1/users/00uvytzkcpPUKJDNLIUW/lifecycle/reset_password","method":"POST"},"expirePassword":{"href":"https://myaccounts-ringcentral.okta.com/api/v1/users/00uvytzkcpPUKJDNLIUW/lifecycle/expire_password","method":"POST"},"forgotPassword":{"href":"https://myaccounts-ringcentral.okta.com/api/v1/users/00uvytzkcpPUKJDNLIUW/credentials/forgot_password","method":"POST"},"changeRecoveryQuestion":{"href":"https://myaccounts-ringcentral.okta.com/api/v1/users/00uvytzkcpPUKJDNLIUW/credentials/change_recoveryquestion","method":"POST"},"deactivate":{"href":"https://myaccounts-ringcentral.okta.com/api/v1/users/00uvytzkcpPUKJDNLIUW/lifecycle/deactivate","method":"POST"},"changePassword":{"href":"https://myaccounts-ringcentral.okta.com/api/v1/users/00uvytzkcpPUKJDNLIUW/credentials/change_password","method":"POST"}}}';
			WrUser wrUserObj = (WrUser)System.Json.deserialize(formatJsonString ,WrUser.class);
			userObj.OKTAUserID__c = wrUserObj.id;
			userObj.OktaUserPassword__c = OKTA_PASSWORD;
			mapUserToUpd.put(userObj.id,userObj);
			return wrUserObj;
		}
		return null;
	}
	
	// To assign an Okta User to application ID
	public void assignOktaApplication(string oktaUserId) {
		string strBody = '{"id": "'+oktaUserId+'","scope": "USER","credentials": {"userName": "'+accountObj.RC_Account_Number__c+'","password": { "value": "" }}}';
		if(!Test.isRunningTest()) {
			callAPIs(OKTA_URL + '/api/v1/apps/'+applicationId+'/users/'+oktaUserId,strBody,'PUT');
		}
	}
	
	// To activate an Okta User from Password Reset status to active
	public void activateOktaUserFromPWDResetStatus(string oktaUserId,User userObj) {
		string strbody = '{"profile": { "firstName": "'+ (!string.isBlank(userObj.FirstName) ? userObj.FirstName : null) +'", "lastName": "'+ userObj.LastName +'","email": "'+ userObj.email +'","login": "'+ userObj.username +'"},"credentials": {"password" : {"value": "'+OKTA_PASSWORD+'"},"recovery_question": { "question": "What is name of your company?","answer": "ringcentral"}}}';
		if(!Test.isRunningTest()) {
			callAPIs(OKTA_URL + '/api/v1/users/'+ oktaUserId,strbody,'PUT');
		}
	}
	
	// To activate an Okta User from deactivate status to password reset
	public void activateOktaUserFromDeactivate(string oktaUserId) {
		if(!Test.isRunningTest()) {
			callAPIs(OKTA_URL + '/api/v1/users/'+ oktaUserId +'/lifecycle/activate?sendEmail=false',null,'POST');
		}
	}
	
	// To activate Okta application from Inactive status
	public void activateOktaAppliation(string oktaApplicationID) {
		if(!Test.isRunningTest()) {
			callAPIs(OKTA_URL + '/api/v1/apps/'+ oktaApplicationID +'/lifecycle/activate',null,'POST');
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
	
	/**************************************** App/User Data structure ************************************************************************/
	
	public class WrUserApp {
		string id;
		string externalId;
		string created;
		string lastUpdated;
		string scope;
		string status;
		string statusChanged;
		string passwordChanged;
		string syncState;
		string lastSync;
		WRCredentialsApp credentials;
		WRProfileApp profile;
		WRLinksApp links;
	}
	
	public class WRProfileApp {
		string firstName;
		string lastName;
		string email;
		string login;
		string mobilePhone;
	}
	
	public class WRCredentialsApp {
		string userName;
	}
	
	public class WRLinksApp {
		WRHrefApp app;
		WRHrefApp user;
	}
	
	public class WRHrefApp {
		string href;
	}
	
	// General Method to call API's
	public String callAPIs(String endURL, String body, String action) {
		if(Limits.getCallouts() < Limits.getLimitCallouts()) {
			accountObj.Is_Error_Occured_Okta__c = false; 
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
			accountObj.Is_Error_Occured_Okta__c = true;
		}
		return null; 
    }
}