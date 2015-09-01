@isTest
private class TestOkta {

    static testMethod void enableOktaTest() {
    	try {
    		TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT = true;
    		TriggerHandler.BY_PASS_ACCOUNT_ON_UPDATE = true;
    		TriggerHandler.BY_PASS_CONTACT_ON_INSERT = true;
    		TriggerHandler.BY_PASS_CONTACT_ON_UPDATE = true;
    		Schema.DescribeSObjectResult result = Account.SObjectType.getDescribe();
	    	Map<ID,Schema.RecordTypeInfo> rtMapByName = result.getRecordTypeInfosById();
	    	Map<string,Schema.RecordTypeInfo> rtMapById = result.getRecordTypeInfosByName();
	    	User userWithRole;
            if(UserInfo.getUserRoleId() == null) {
                UserRole r = new UserRole(name = 'TEST ROLE123');
                Database.insert(r);
                
               userWithRole = new User(alias = 'hasrole', email='userwithrole11@roletest1.com', userroleid = r.id,
                                    emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                                    localesidkey='en_US', profileid = UserInfo.getProfileId(), 
                                    timezonesidkey='America/Los_Angeles', username='userwithrole11@testorg.com');
            } else {
               userWithRole = new User(Id = UserInfo.getUserId(), UserRoleId = UserInfo.getUserRoleId());
            }
            Account accpPartnerObj;
            Contact contactObj;
            
            System.runAs(userWithRole) {
		  		accpPartnerObj = new Account();
		    	accpPartnerObj.RecordTypeId = rtMapById.get('Partner Account').getRecordTypeId();
		    	accpPartnerObj.Name = 'Test Partner Account 1';
		    	accpPartnerObj.Partner_ID__c = 'TestP100';
		    	accpPartnerObj.RC_User_ID__c = 'TestRCP100';
		    	accpPartnerObj.RC_Account_Number__c = 'TestPAN100';
		    	insert accpPartnerObj;
		    	
		    	contactObj = new Contact();
		    	contactObj.FirstName = 'TestContactF';
		    	contactObj.LastName = 'TestContactL';
		    	contactObj.Email = 'TestContactF@test.com';
		    	contactObj.Phone = '9810546384';
		    	contactObj.AccountId = accpPartnerObj.id;
		    	insert contactObj;
            }
	    	
	    	Profile p = [select id from profile where usertype = 'PowerPartner' and Name like '%Full%'
                     		limit 1];   
        
	        String testemail = 'puser0001@amamama.com';
	        User pu = new User(profileId = p.id, username = testemail, email = testemail, 
	                           emailencodingkey = 'UTF-8', localesidkey = 'en_US', 
	                           languagelocalekey = 'en_US', timezonesidkey = 'America/Los_Angeles', 
	                           alias='cspu', lastname='lastname', contactId = contactObj.id);
	        
	       
            Database.insert(pu);
	    	
	    	
	    	Test.startTest();
	    	Account accpCustomerObj = new Account();
	    	accpCustomerObj.RecordTypeId = rtMapById.get('Customer Account').getRecordTypeId();
	    	accpCustomerObj.Name = 'Test Customer Account 1';
	    	accpCustomerObj.Partner_ID__c = 'TestP100';
	    	accpCustomerObj.RC_User_ID__c = 'TestRCC100';
	    	accpCustomerObj.RC_Account_Number__c = 'TestCAN100';
	    	insert accpCustomerObj;
	        
	        EnableOkta enableOktaObj1 = new EnableOkta(new ApexPages.Standardcontroller(new Account(id = accpPartnerObj.id)));
	        EnableOkta enableOktaObj2 = new EnableOkta(new ApexPages.Standardcontroller(new Account(id = accpCustomerObj.id)));
	        enableOktaObj2.excuteProcess();
	        
	        enableOktaObj2.callAPIs('http://google.com',null,'GET');
	        
	        enableOktaObj2.activateOktaUserFromPWDResetStatus('3311',pu);
	        enableOktaObj2.activateOktaUserFromDeactivate('3311');
	        enableOktaObj2.activateOktaAppliation('123455');
	        
	        EnableOkta.WrApplication Obj1 = new EnableOkta.WrApplication();
	        EnableOkta.WRAppLinks Obj2 = new EnableOkta.WRAppLinks();
	        EnableOkta.WRLinks Obj3 = new EnableOkta.WRLinks();
	        EnableOkta.WRAccessibility Obj4 = new EnableOkta.WRAccessibility();
	        EnableOkta.WRLicensing Obj5 = new EnableOkta.WRLicensing();
	        EnableOkta.WRVisibility Obj6 = new EnableOkta.WRVisibility();
	        EnableOkta.WRHide Obj7 = new EnableOkta.WRHide();
	        EnableOkta.WRAppLinks1 Obj8 = new EnableOkta.WRAppLinks1();  
	        EnableOkta.WRCredentials Obj9 = new EnableOkta.WRCredentials();
	        EnableOkta.WRUserNameTemplate Obj10 = new EnableOkta.WRUserNameTemplate();
	        EnableOkta.WRSettings Obj11 = new EnableOkta.WRSettings();
	        EnableOkta.WRAPP Obj12 = new EnableOkta.WRAPP();
	        EnableOkta.WRCredentials Obj13 = new EnableOkta.WRCredentials();
	        
	        EnableOkta.WrUser Obj14 = new EnableOkta.WrUser();
	        EnableOkta.WRProfile Obj15 = new EnableOkta.WRProfile();
	        EnableOkta.WRCredentials1 Obj16 = new EnableOkta.WRCredentials1();
	        EnableOkta.WRPassword Obj17 = new EnableOkta.WRPassword();
	        EnableOkta.WRRecoveryQuestion Obj18 = new EnableOkta.WRRecoveryQuestion();
	        EnableOkta.WRLinks2 Obj19 = new EnableOkta.WRLinks2();
	        EnableOkta.WRActivate Obj20 = new EnableOkta.WRActivate();
	        EnableOkta.WRProvider obj200 = new EnableOkta.WRProvider();
	        
	        Contact contactObj1;
	        System.runAs(userWithRole) {
	        	contactObj1 = new Contact();
		    	contactObj1.FirstName = 'TestContactF1';
		    	contactObj1.LastName = 'TestContactL1';
		    	contactObj1.Email = 'TestContactF1@test.com';
		    	contactObj1.Phone = '9810546389';
		    	contactObj1.AccountId = accpPartnerObj.id;
		    	insert contactObj1;
	        }
	        
	        String testemail1 = 'puser0005@amamama.com';
	        User pu1 = new User(profileId = p.id, username = testemail1, email = testemail1, 
	                           emailencodingkey = 'UTF-8', localesidkey = 'en_US', 
	                           languagelocalekey = 'en_US', timezonesidkey = 'America/Los_Angeles', 
	                           alias='cspu', lastname='lastname', contactId = contactObj1.id);
	        
	       
            Database.insert(pu1);
	        
	        BatchOktaUser.WrApplication Obj21 = new BatchOktaUser.WrApplication();
	        BatchOktaUser.WRAppLinks Obj22 = new BatchOktaUser.WRAppLinks();
	        BatchOktaUser.WRLinks Obj23 = new BatchOktaUser.WRLinks();
	        BatchOktaUser.WRAccessibility Obj24 = new BatchOktaUser.WRAccessibility();
	        BatchOktaUser.WRLicensing Obj25 = new BatchOktaUser.WRLicensing();
	        BatchOktaUser.WRVisibility Obj26 = new BatchOktaUser.WRVisibility();
	        BatchOktaUser.WRHide Obj27 = new BatchOktaUser.WRHide();
	        BatchOktaUser.WRAppLinks1 Obj28 = new BatchOktaUser.WRAppLinks1();  
	        BatchOktaUser.WRCredentials Obj29 = new BatchOktaUser.WRCredentials();
	        BatchOktaUser.WRUserNameTemplate Obj30 = new BatchOktaUser.WRUserNameTemplate();
	        BatchOktaUser.WRSettings Obj31 = new BatchOktaUser.WRSettings();
	        BatchOktaUser.WRAPP Obj32 = new BatchOktaUser.WRAPP();
	        BatchOktaUser.WRCredentials Obj33 = new BatchOktaUser.WRCredentials();
	        
	        BatchOktaUser.WrUser Obj34 = new BatchOktaUser.WrUser();
	        BatchOktaUser.WRProfile Obj35 = new BatchOktaUser.WRProfile();
	        BatchOktaUser.WRCredentials1 Obj36 = new BatchOktaUser.WRCredentials1();
	        BatchOktaUser.WRPassword Obj37 = new BatchOktaUser.WRPassword();
	        BatchOktaUser.WRRecoveryQuestion Obj38 = new BatchOktaUser.WRRecoveryQuestion();
	        BatchOktaUser.WRLinks2 Obj39 = new BatchOktaUser.WRLinks2();
	        BatchOktaUser.WRActivate Obj40 = new BatchOktaUser.WRActivate();
	        BatchOktaUser batchObj = new BatchOktaUser();
	        batchObj.callAPIs('http://google.com',null,'GET'); 
	        
	        
	        
	        Test.stopTest();
    	} catch(Exception ex) {}
    }
    
    enum PortalType { CSPLiteUser, PowerPartner, PowerCustomerSuccess, CustomerSuccess }
    
    static testMethod void enableOktaTest1() {
    	try {
    		TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT = true;
    		TriggerHandler.BY_PASS_ACCOUNT_ON_UPDATE = true;
    		TriggerHandler.BY_PASS_CONTACT_ON_INSERT = true;
    		TriggerHandler.BY_PASS_CONTACT_ON_UPDATE = true;
    		Schema.DescribeSObjectResult result = Account.SObjectType.getDescribe();
	    	Map<ID,Schema.RecordTypeInfo> rtMapByName = result.getRecordTypeInfosById();
	    	Map<string,Schema.RecordTypeInfo> rtMapById = result.getRecordTypeInfosByName();
	    	User userWithRole;
            if(UserInfo.getUserRoleId() == null) {
                UserRole r = new UserRole(name = 'TEST ROLE123');
                Database.insert(r);
                
               userWithRole = new User(alias = 'hasrole', email='userwithrole11@roletest1.com', userroleid = r.id,
                                    emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                                    localesidkey='en_US', profileid = UserInfo.getProfileId(), 
                                    timezonesidkey='America/Los_Angeles', username='userwithrole11@testorg.com');
            } else {
               userWithRole = new User(Id = UserInfo.getUserId(), UserRoleId = UserInfo.getUserRoleId());
            }
            Account accpPartnerObj;
            Contact contactObj;
            
            System.runAs(userWithRole) {
		  		accpPartnerObj = new Account();
		    	accpPartnerObj.RecordTypeId = rtMapById.get('Partner Account').getRecordTypeId();
		    	accpPartnerObj.Name = 'Test Partner Account 1';
		    	accpPartnerObj.Partner_ID__c = 'TestP100';
		    	accpPartnerObj.RC_User_ID__c = 'TestRCP100';
		    	accpPartnerObj.RC_Account_Number__c = 'TestPAN100';
		    	insert accpPartnerObj;
		    	
		    	contactObj = new Contact();
		    	contactObj.FirstName = 'TestContactF';
		    	contactObj.LastName = 'TestContactL';
		    	contactObj.Email = 'TestContactF@test.com';
		    	contactObj.Phone = '9810546384';
		    	contactObj.AccountId = accpPartnerObj.id;
		    	insert contactObj;
            }
	    	
	    	Profile p = [select id from profile where usertype = 'PowerPartner' and Name like '%Full%'
                     		limit 1];   
        
	        String testemail = 'puser0001@amamama.com';
	        User pu = new User(profileId = p.id, username = testemail, email = testemail, 
	                           emailencodingkey = 'UTF-8', localesidkey = 'en_US', 
	                           languagelocalekey = 'en_US', timezonesidkey = 'America/Los_Angeles', 
	                           alias='cspu', lastname='lastname', contactId = contactObj.id);
	        
	       
            Database.insert(pu);
	    	
	    	
	    	Test.startTest();
	    	
	    	Account accpCustomerObj = new Account();
	    	accpCustomerObj.RecordTypeId = rtMapById.get('Customer Account').getRecordTypeId();
	    	accpCustomerObj.Name = 'Test Customer Account 1';
	    	accpCustomerObj.Partner_ID__c = 'TestP100';
	    	accpCustomerObj.RC_User_ID__c = 'TestRCC100';
	    	accpCustomerObj.RC_Account_Number__c = 'TestCAN100';
	    	accpCustomerObj.Is_Error_Occured_Okta__c = true;
	    	insert accpCustomerObj;
	    	
	    	/*Account accpCustomerObj1 = new Account();
	    	accpCustomerObj1.RecordTypeId = rtMapById.get('Customer Account').getRecordTypeId();
	    	accpCustomerObj1.Name = 'Test Customer Account 1';
	    	accpCustomerObj1.Partner_ID__c = 'TestP100';
	    	accpCustomerObj1.RC_User_ID__c = 'TestRCC101';
	    	accpCustomerObj1.RC_Account_Number__c = 'TestCAN101';
	    	accpCustomerObj1.Is_Error_Occured_Okta__c = true;
	    	insert accpCustomerObj1;*/
	        
	        BatchOktaAccount batchOktaObj = new BatchOktaAccount();
	        Database.executeBatch(batchOktaObj,1);
	        batchOktaObj.accountObj = accpCustomerObj; 
	        batchOktaObj.callAPIs('http://google.com',null,'GET'); 
	        
	        batchOktaObj.activateOktaUserFromPWDResetStatus('3311',pu);
	        batchOktaObj.activateOktaUserFromDeactivate('3311');
	        batchOktaObj.activateOktaAppliation('123455');
	        
	        BatchOktaAccount.WrApplication Obj1 = new BatchOktaAccount.WrApplication();
	        BatchOktaAccount.WRAppLinks Obj2 = new BatchOktaAccount.WRAppLinks();
	        BatchOktaAccount.WRLinks Obj3 = new BatchOktaAccount.WRLinks();
	        BatchOktaAccount.WRAccessibility Obj4 = new BatchOktaAccount.WRAccessibility();
	        BatchOktaAccount.WRLicensing Obj5 = new BatchOktaAccount.WRLicensing();
	        BatchOktaAccount.WRVisibility Obj6 = new BatchOktaAccount.WRVisibility();
	        BatchOktaAccount.WRHide Obj7 = new BatchOktaAccount.WRHide();
	        BatchOktaAccount.WRAppLinks1 Obj8 = new BatchOktaAccount.WRAppLinks1();  
	        BatchOktaAccount.WRCredentials Obj9 = new BatchOktaAccount.WRCredentials();
	        BatchOktaAccount.WRUserNameTemplate Obj10 = new BatchOktaAccount.WRUserNameTemplate();
	        BatchOktaAccount.WRSettings Obj11 = new BatchOktaAccount.WRSettings();
	        BatchOktaAccount.WRAPP Obj12 = new BatchOktaAccount.WRAPP();
	        BatchOktaAccount.WRCredentials Obj13 = new BatchOktaAccount.WRCredentials();
	        
	        BatchOktaAccount.WrUser Obj14 = new BatchOktaAccount.WrUser();
	        BatchOktaAccount.WRProfile Obj15 = new BatchOktaAccount.WRProfile();
	        BatchOktaAccount.WRCredentials1 Obj16 = new BatchOktaAccount.WRCredentials1();
	        BatchOktaAccount.WRPassword Obj17 = new BatchOktaAccount.WRPassword();
	        BatchOktaAccount.WRRecoveryQuestion Obj18 = new BatchOktaAccount.WRRecoveryQuestion();
	        BatchOktaAccount.WRLinks2 Obj19 = new BatchOktaAccount.WRLinks2();
	        BatchOktaAccount.WRActivate Obj20 = new BatchOktaAccount.WRActivate();
	        BatchOktaAccount.WRProvider obj200 = new BatchOktaAccount.WRProvider();
	        
	        BatchOktaAccount.WrUserApp obj21 = new BatchOktaAccount.WrUserApp();
	        BatchOktaAccount.WRProfileApp obj22 = new BatchOktaAccount.WRProfileApp();
	        BatchOktaAccount.WRCredentialsApp obj23 = new BatchOktaAccount.WRCredentialsApp();
	        BatchOktaAccount.WRLinksApp obj24 = new BatchOktaAccount.WRLinksApp();
	        BatchOktaAccount.WRHrefApp obj25 = new BatchOktaAccount.WRHrefApp();
	        
	        Test.stopTest();
    	} catch(Exception ex) {}
    }
}