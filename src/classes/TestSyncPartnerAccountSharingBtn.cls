@isTest
private class TestSyncPartnerAccountSharingBtn {
	
	enum PortalType { CSPLiteUser, PowerPartner, PowerCustomerSuccess, CustomerSuccess }
    
    static testmethod void usertest() {
        User pu = getPortalUser(PortalType.PowerPartner, null, true);
        System.assert([select isPortalEnabled 
                         from user 
                        where id = :pu.id].isPortalEnabled,
                      'User was not flagged as portal enabled.');       
        
        System.RunAs(pu) {
            System.assert([select isPortalEnabled 
                             from user 
                            where id = :UserInfo.getUserId()].isPortalEnabled, 
                          'User wasnt portal enabled within the runas block. ');
        }
       
        User portaluser = [select Contact.AccountId from User where Id = :pu.id];
        Account accObjCustomer = [select id from Account where RecordType.Name = 'Customer Account' and Partner_ID__c = '12344' limit 1];
        Test.startTest();
        SyncPartnerAccountSharingBtn syncShareBtnObj = new SyncPartnerAccountSharingBtn();
        SyncPartnerAccountSharingBtn.sharePartnerAccount('', portaluser.Contact.AccountId);
        SyncPartnerAccountSharingBtn.sharePartnerAccount('12344', portaluser.Contact.AccountId);
        SyncPartnerAccountSharingBtn.sharePartnerAccount('12344', accObjCustomer.id);
        Test.stopTest();
    }
    
    public static User getPortalUser(PortalType portalType, User userWithRole, Boolean doInsert) {
        /* Make sure the running user has a role otherwise an exception 
           will be thrown. */
        if(userWithRole == null) {   
            if(UserInfo.getUserRoleId() == null) {
                UserRole r = new UserRole(name = 'TEST ROLE');
                Database.insert(r);
                
                userWithRole = new User(alias = 'hasrole', email='userwithrole@roletest1.com', userroleid = r.id,
                                    emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                                    localesidkey='en_US', profileid = UserInfo.getProfileId(), 
                                    timezonesidkey='America/Los_Angeles', username='userwithrole@testorg.com');
            } else {
                userWithRole = new User(Id = UserInfo.getUserId(), UserRoleId = UserInfo.getUserRoleId());
            }
            
            System.assert(userWithRole.userRoleId != null, 
                          'This test requires the target org to have at least one UserRole created. Please create a user role in this organization and try again.');
        }

        Account a;
        Contact c;
        System.runAs(userWithRole) {
			Schema.DescribeSObjectResult result = Account.SObjectType.getDescribe();
    	    Map<string,Schema.RecordTypeInfo> rtMapById = result.getRecordTypeInfosByName();
    	    
    	    Account accObj2 = new Account();
	        accObj2.Name = 'Test Account Parent ';
	        accObj2.Partner_ID__c = '12345';
	        accObj2.RecordTypeId = rtMapById.get('Partner Account').getRecordTypeID(); 
	        insert accObj2;	
            
            a = new Account();
            a.Name = 'Test Account';
        	a.Partner_ID__c = '12344';
        	a.ParentId = accObj2.id;
        	a.RecordTypeId = rtMapById.get('Partner Account').getRecordTypeID(); 
            Database.insert(a);
        
	        Account accObj1 = new Account();
	        accObj1.Name = 'Test Account Customer';
	        accObj1.Partner_ID__c = '12344';
	        accObj1.RecordTypeId = rtMapById.get('Customer Account').getRecordTypeID(); 
	        insert accObj1;
            
            c = new Contact(AccountId = a.id, lastname = 'lastname');
            Database.insert(c);
        }
        
        /* Get any profile for the given type.*/
        Profile p = [select id 
                      from profile 
                     where usertype = :portalType.name() 
                     limit 1];   
        
        String testemail = 'puser000@amamama.com';
        User pu = new User(profileId = p.id, username = testemail, email = testemail, 
                           emailencodingkey = 'UTF-8', localesidkey = 'en_US', 
                           languagelocalekey = 'en_US', timezonesidkey = 'America/Los_Angeles', 
                           alias='cspu', lastname='lastname', contactId = c.id);
        
        if(doInsert) {
            Database.insert(pu);
        }
        return pu;
    }
    
	/****************************************************************************************************************************************/    
    

   /* static testMethod void myUnitTest() {
    	Schema.DescribeSObjectResult result = Account.SObjectType.getDescribe();
    	Map<string,Schema.RecordTypeInfo> rtMapById = result.getRecordTypeInfosByName();
    	
    	Account accObj2 = new Account();
        accObj2.Name = 'Test Account Parent ';
        accObj2.Partner_ID__c = '12345';
        accObj2.RecordTypeId = rtMapById.get('Partner Account').getRecordTypeID(); 
        insert accObj2;
        
        Account accObj = new Account();
        accObj.Name = 'Test Account';
        accObj.Partner_ID__c = '12344';
        accObj.ParentId = accObj2.id;
        accObj.RecordTypeId = rtMapById.get('Partner Account').getRecordTypeID(); 
        insert accObj;
        
        Account accObj1 = new Account();
        accObj1.Name = 'Test Account Customer';
        accObj1.Partner_ID__c = '12344';
        accObj1.RecordTypeId = rtMapById.get('Customer Account').getRecordTypeID(); 
        insert accObj1;
       
        
        Test.startTest();
      
        SyncPartnerAccountSharingBtn syncShareBtnObj = new SyncPartnerAccountSharingBtn();
        SyncPartnerAccountSharingBtn.sharePartnerAccount('', accObj.id);
        SyncPartnerAccountSharingBtn.sharePartnerAccount(accObj.Partner_ID__c, accObj.id);
        SyncPartnerAccountSharingBtn.sharePartnerAccount(accObj1.Partner_ID__c, accObj1.id);
        Test.stopTest();
    }*/
    
    /*static testMethod void myUnitTest1() {
    	try {
    		Schema.DescribeSObjectResult result = Account.SObjectType.getDescribe();
    		Map<string,Schema.RecordTypeInfo> rtMapById = result.getRecordTypeInfosByName();
    		//Create portal account owner
			UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
			Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
			User portalAccountOwner1 = new User(
				UserRoleId = portalRole.Id,
				ProfileId = profile1.Id,
				Username = System.now().millisecond() + 'test2@test.com',
			   	Alias = 'batman',
				Email='bruce.wayne@wayneenterprises.com',
				EmailEncodingKey='UTF-8',
				Firstname='Bruce',
				Lastname='Wayne',
				LanguageLocaleKey='en_US',
				LocaleSidKey='en_US',
				TimeZoneSidKey='America/Chicago'
			);
			Database.insert(portalAccountOwner1);
			Test.startTest();
			//Create account
			Account portalAccount1 = new Account(
				Name = 'TestAccount',
				OwnerId = portalAccountOwner1.Id,
        		Partner_ID__c = '12344',
        		RecordTypeId = rtMapById.get('Partner Account').getRecordTypeID() 
       		);
			Database.insert(portalAccount1);
			    	
			//Create contact
			Contact contact1 = new Contact(
			   	FirstName = 'Test',
			    	Lastname = 'McTesty',
				AccountId = portalAccount1.Id,
			    	Email = System.now().millisecond() + 'test@test.com'
			);
			Database.insert(contact1);
    	
			//Create user
			Profile portalProfile = [SELECT Id FROM Profile WHERE Name LIKE '%RC Partner User%' Limit 1];
			User user1 = new User(
				Username = System.now().millisecond() + 'test12345@test.com',
				ContactId = contact1.Id,
				ProfileId = portalProfile.Id,
				Alias = 'test123',
				Email = 'test12345@test.com',
				EmailEncodingKey = 'UTF-8',
				LastName = 'McTesty',
				CommunityNickname = 'test12345',
				TimeZoneSidKey = 'America/Los_Angeles',
				LocaleSidKey = 'en_US',
				LanguageLocaleKey = 'en_US'
			);
			Database.insert(user1);
			
			
        	SyncPartnerAccountSharingBtn syncShareBtnObj = new SyncPartnerAccountSharingBtn();
	        SyncPartnerAccountSharingBtn.sharePartnerAccount('', portalAccount1.id);
	        SyncPartnerAccountSharingBtn.sharePartnerAccount(portalAccount1.Partner_ID__c, portalAccount1.id);
	        //SyncPartnerAccountSharingBtn.sharePartnerAccount(accObj1.Partner_ID__c, accObj1.id);
	        Test.stopTest();
				
    	} catch(Exception ex) {}
    }*/
}