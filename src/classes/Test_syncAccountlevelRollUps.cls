@isTest
private class Test_syncAccountlevelRollUps {

   		public static testmethod void TestsyncAccountlevelRollUps() {
   		
   		EntitlementEnable__c mycs = EntitlementEnable__c.getValues('IsEntitlementsEnabled__c');
		if(mycs == null) {
			mycs = new EntitlementEnable__c();
			mycs.IsEntitlementsEnabled__c = true;
			mycs.Name = 'IsEntitlementsEnabled';
			insert mycs;
		}
     	Account testAccount = new Account(Name = 'TestAccount');
        insert testAccount;
		
		Account accountobj1 = new Account();
		accountobj1.Name = 'TestAccount';
		accountobj1.RC_User_ID__c = 'UID9910106802';
		accountobj1.Partner_ID__c = 'PARTNER002';
		accountobj1.ParentId = testAccount.Id;
		accountobj1.Phone = '9910101111';
		accountobj1.AccountNumber = '991010';
		insert accountobj1;
		    
		Contact contactObj = new Contact();
		contactObj.AccountId = accountobj1.id;
		contactObj.Email = 'Testportaluser@simplion.com';
		contactObj.LastName = 'Test Okta Con portaluser';
		contactObj.Phone = '1234567830';
		insert contactObj;
		/*UserRole objUS = new UserRole();
		objUS.Name = 'test';
		objUS.PortalType ='Partner';
		//objUS.PortalRole ='Executive';
		insert objUS;*/
		Case c = new Case(Subject = 'Test Case with Entitlement ', ContactId = contactObj.id);
		c.AccountId = accountobj1.Id;
		insert c;
		
		User testUser = new User(alias = 'portr', email='portaluser@testorg.com', emailencodingkey='UTF-8', lastname='portaluser',OktaUserPassword__c='ra!nb0w7',
		                         OKTAUserID__c='00u3uty75rWFWAOFWHQJ',  ProfileId=[SELECT Id FROM Profile WHERE Name='RC Partner User Pilot' LIMIT 1].Id, languagelocalekey='en_US',
	                      		 localesidkey='en_US', country='United States',timezonesidkey='America/Los_Angeles',username='portaluser@testorg.com', 
								 ContactId=contactObj.Id, IsActive=true );//UserRoleId=objUS.Id,
		insert testUser;
      
       
      //insert testAccount;
      
		ApexPages.StandardController controller=new ApexPages.StandardController(accountobj1);
		syncAccountLevelRollUps objsyncAccountLevelRollUps =new syncAccountLevelRollUps (controller);
      
		objsyncAccountLevelRollUps.strScheduleName='None';
		objsyncAccountLevelRollUps.massUpdateAccountRollUp();
      
		objsyncAccountLevelRollUps.strScheduleName='allchild';
		objsyncAccountLevelRollUps.massUpdateAccountRollUp();
     
		objsyncAccountLevelRollUps.strScheduleName='Partner';
		objsyncAccountLevelRollUps.massUpdateAccountRollUp();
		objsyncAccountLevelRollUps.setTotalActiveCustomer();
      
		objsyncAccountLevelRollUps.scheduleAllAccountsAgain();
      }
     	
     	
     	
     	
     	
     	/*  enum PortalType { CSPLiteUser, PowerPartner, PowerCustomerSuccess, CustomerSuccess }
		  public static User getPortalUser(PortalType portalType, User userWithRole, Boolean doInsert) {
	        /* Make sure the running user has a role otherwise an exception 
	           will be thrown. */
	       /* if(userWithRole == null) {   
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
	      /*  Profile p = [select id 
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
       public static testmethod void TestsyncAccountlevelRollUps() {
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
			 
			ApexPages.StandardController controller=new ApexPages.StandardController(accObjCustomer);
			syncAccountLevelRollUps objsyncAccountLevelRollUps =new syncAccountLevelRollUps (controller);
	      
			objsyncAccountLevelRollUps.strScheduleName='None';
			objsyncAccountLevelRollUps.massUpdateAccountRollUp();
	      
			objsyncAccountLevelRollUps.strScheduleName='allchild';
			objsyncAccountLevelRollUps.massUpdateAccountRollUp();
	     
			objsyncAccountLevelRollUps.strScheduleName='Partner';
			objsyncAccountLevelRollUps.massUpdateAccountRollUp();
			objsyncAccountLevelRollUps.setTotalActiveCustomer();
	      
			objsyncAccountLevelRollUps.scheduleAllAccountsAgain();
			Test.stopTest();
	  }*/
		
       
}