@isTest

    public with sharing class TestAccountTriggerSeparated {    
     
        
        static Map<String, sObject> userMap = new  Map<String, sObject>();
        static Map<String, sObject> userMap1 = new  Map<String, sObject>();
        static List<Account> partnerAccountsList = new List<Account>();
        static List<Account> customerAccountsList = new List<Account>();       
        static List<Account> updatableAccounts = new List<Account>();        
        static List<Account> partnerAccountsListUpdate = new List<Account>();
        static List<Account> customerAccountsListUpdate = new List<Account>(); 
        
        
		 /**
		 * This class contains unit tests for validating the behavior of Apex classes
		 * and triggers.
		 *
		 * Unit tests are class methods that verify whether a particular piece
		 * of code is working properly. Unit test methods take no arguments,
		 * commit no data to the database, and are flagged with the testMethod
		 * keyword in the method definition.
		 *
		 * All test methods in an organization are executed whenever Apex code is deployed
		 * to a production organization to confirm correctness, ensure code
		 * coverage, and prevent regressions. All Apex classes are
		 * required to have at least 75% code coverage in order to be deployed
		 * to a production organization. In addition, all triggers must have some code coverage.
		 * 
		 * The @isTest class annotation indicates this class only contains test
		 * methods. Classes defined with the @isTest annotation do not count against
		 * the organization size limit for all Apex scripts.
		 *
		 * See the Apex Language Reference for more information about Testing and Code Coverage.
		 */
		
		    
		    
		     static testmethod void createLeadTest(){
		    	
		        
					Id partnerAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer Account').getRecordTypeId();
				 																							
				   	Profile pro = [SELECT Id FROM Profile WHERE Name='Sales Manager'];
					User u = new User(Alias = 'standt', Email='r@ring.com', 
										EmailEncodingKey='UTF-8', lastName='Sync', firstName= 'RCSF', LanguageLocaleKey='en_US', 
										LocaleSidKey='en_US', ProfileId = pro.Id, Phone ='7896545432',
										TimeZoneSidKey='America/Los_Angeles', UserName='r@ring.com',
										isActive = true);
		         insert u;
		         	RCSF_Sync__c customSetUp = new RCSF_Sync__c(Name= 'RCSF Sync', 
														Username__c = 'r@ring.com', 
														Email__c = 'r@ring.com', 
														Active__c = true, 
														First_Name__c = 'RCSF', 
														Last_Name__c = 'Sync',
														Id__c = 'r@ring.com');
					AccountHierarchyCustomSetting__c customSettingData = new AccountHierarchyCustomSetting__c(Name = 'AccountHierarchyInstance', 
																										HierarchyCalculationEnabled__c= true);	
					insert 	customSetUp;
					insert customSettingData;
					Test.startTest();
					System.runAs(u)	{
						Account accObj = new Account();
					    accObj.Name = 'Rctest1';
					    accObj.RC_Account_Status__c ='Trial 30 CC';
					    accObj.Service_Type__c = 'Office';
					    accObj.Partner_ID__c = '1234';
					    accObj.recordTypeId = partnerAccRecordTypeId;
					    system.debug('======= accObj.recordTypeId ====== '+ accObj.recordTypeId);
					    accObj.RC_Signup_Date__c = System.Now();
					    accObj.Pay_Referral_Commissions__c = true;
					    accObj.Employees_Override__c = 45;
					    	    
					    
						insert accObj;
					     Id p = [select id from profile where name='RC Partner Modify'].id;
					    Contact con = new Contact(
					    							LastName ='testCon1',
					    							AccountId = accObj.Id,
					    							Phone = '9971626838',
					    							FirstName = 'TestFirstname',
					    							Email = 'My@mydomain.com'
					    							);
				        insert con;	
				        AccountTriggerStaticProperties.BY_PASS_ACCOUNT_BEFORE = false;
				        AccountTriggerStaticProperties.BY_PASS_ACCOUNT_AFTER = false;
						accObj.No_of_Employees__c = '12';
						accObj.RC_Tier__c = 'Trial_New';
						accObj.RC_Brand__c = 'RingCentral';
						
						update accObj;
						Test.stopTest();
					}							
				    
		    
		    }
		     static testmethod void createLeadTestWithoutAccount(){
		    	
		        
					Id partnerAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer Account').getRecordTypeId();
					
					Profile pro = [SELECT Id FROM Profile WHERE Name='Sales Manager'];
				    User u = new User(Alias = 'standt', Email='r@ring.com', 
										EmailEncodingKey='UTF-8', lastName='Sync', firstName= 'RCSF', LanguageLocaleKey='en_US', 
										LocaleSidKey='en_US', ProfileId = pro.Id, Phone ='7896545432',
										TimeZoneSidKey='America/Los_Angeles', UserName='r@ring.com',
										isActive = true);
		         insert u;
		         RCSF_Sync__c customSetUp = new RCSF_Sync__c(Name= 'RCSF Sync', 
														Username__c = 'r@ring.com', 
														Email__c = 'r@ring.com', 
														Active__c = true, 
														First_Name__c = 'RCSF', 
														Last_Name__c = 'Sync',
		                                                Id__c = 'r@ring.com');
					AccountHierarchyCustomSetting__c customSettingData = new AccountHierarchyCustomSetting__c(Name = 'AccountHierarchyInstance', 
																										HierarchyCalculationEnabled__c= true);	
					insert 	customSetUp;
					insert customSettingData;
					Test.startTest();
					System.runAs(u)	{
					    Account accObj = new Account();
					    accObj.Name = 'Rctest1noContact';
					    accObj.RC_Account_Status__c ='Paid';
					    accObj.Service_Type__c = 'Professional';
					    accObj.Partner_ID__c = '1234';
					    accObj.recordTypeId = partnerAccRecordTypeId;
					    system.debug('======= accObj.recordTypeId ====== '+ accObj.recordTypeId);
					    accObj.RC_Signup_Date__c = System.Now();
					    accObj.Pay_Referral_Commissions__c = true;
					    accObj.Employees_Override__c = 45;
					    insert accObj;
					    		    
					    
						AccountTriggerStaticProperties.BY_PASS_ACCOUNT_BEFORE = false;
				        AccountTriggerStaticProperties.BY_PASS_ACCOUNT_AFTER = false;
						accObj.No_of_Employees__c = '12';
						accObj.RC_Tier__c = 'Trial_New';
						accObj.RC_Brand__c = 'RingCentral';
						accObj.SignupPlatform__c = 'Web';
						accObj.Service_Type__c = 'Office';
						accObj.RC_Account_Status__c ='Trial 30 CC';
						accObj.SignupType__c  = 'TRIAL_30NOCC';
						update accObj;
						Test.stopTest();
					}
		    
		    }
		    static testmethod void createLeadTestFOrTrail(){
		    	
		        
					Id partnerAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer Account').getRecordTypeId();
					
					Profile pro = [SELECT Id FROM Profile WHERE Name='Sales Manager'];
					
		        	User u = new User(Alias = 'standt', Email='r@ring.com', 
		                          EmailEncodingKey='UTF-8', lastName='Sync', firstName= 'RCSF', LanguageLocaleKey='en_US', 
		                          LocaleSidKey='en_US', ProfileId = pro.Id, Phone ='7896545432',
		                          TimeZoneSidKey='America/Los_Angeles', UserName='r@ring.com',
		                          isActive = true);
		          insert u;
		          
		          
		         RCSF_Sync__c customSetUp = new RCSF_Sync__c(Name= 'RCSF Sync', 
														Username__c = 'r@ring.com', 
														Email__c = 'r@ring.com', 
														Active__c = true, 
														First_Name__c = 'RCSF', 
														Last_Name__c = 'Sync',
		                                                Id__c = 'r@ring.com');
					AccountHierarchyCustomSetting__c customSettingData = new AccountHierarchyCustomSetting__c(Name = 'AccountHierarchyInstance', 
																										HierarchyCalculationEnabled__c= true);	
					insert 	customSetUp;
					insert customSettingData;
					System.runAs(u)	{
						
						Employee__c emp = new Employee__c();
			          	emp.Last_Name__c = 'testEmployeeLast';
			          	emp.user__c = u.id;
			          	emp.Division__c = 'TestDiv';
			          	emp.Email__c = 'r@ring.com';
			          	insert emp;
					    Account accObj = new Account();
					    accObj.Name = 'Rctest1';
					    accObj.RC_Account_Status__c ='trail';
					    accObj.Partner_ID__c = '1234';
					    accObj.recordTypeId = partnerAccRecordTypeId;
					    system.debug('======= accObj.recordTypeId ====== '+ accObj.recordTypeId);
					    accObj.RC_Signup_Date__c = System.Now();
					    accObj.Pay_Referral_Commissions__c = true;
					    accObj.SignupPlatform__c = 'Web';
					    accObj.Employees_Override__c = 45;
					    accObj.RC_User_ID__c = '234567';
					    insert accObj;
						  Id p = [select id from profile where name='RC Partner Modify'].id;
					    Contact con = new Contact(
					    							LastName ='testCon2',
					    							AccountId = accObj.Id,
					    							Phone = '9971626838',
					    							FirstName = 'TestFirstname',
					    							Email = 'r@ring.com',
					    							isCustomer__c = true
					    							);
				        insert con;
				        System.debug('contact for checking~~~~~~~~~~~~'+con);
				        Opportunity opp = new Opportunity();  
					    opp.name = 'testOppoty';
					    opp.AccountId = accObj.id;
					    opp.Forecasted_Users__c = 50;
						opp.StageName = '3. Qualified';
						opp.CloseDate = System.today();	
					    insert opp;			    		    
					    Test.startTest();
						AccountTriggerStaticProperties.BY_PASS_ACCOUNT_BEFORE = false;
				        AccountTriggerStaticProperties.BY_PASS_ACCOUNT_AFTER = false;
						accObj.No_of_Employees__c = '12';
						accObj.SignupPlatform__c = 'Web';
						accObj.RC_User_ID__c = '234567';
						accObj.RC_Tier__c = 'Trial_New';
						accObj.RC_Brand__c = 'RingCentral';
						accObj.RC_Account_Status__c ='Disabled';
						update accObj;
						System.debug('~~~~~~~~~~~~~~~`accObj after opportunity');
						Test.stopTest();
					}
		    
		    }
		    static testmethod void createLeadTestWithoutOpportunity(){
		    	
		        
					Id partnerAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer Account').getRecordTypeId();
					
					Profile pro = [SELECT Id FROM Profile WHERE Name='Sales Manager'];
					
		        	User u = new User(Alias = 'standt', Email='r@ring.com', 
		                          EmailEncodingKey='UTF-8', lastName='Sync', firstName= 'RCSF', LanguageLocaleKey='en_US', 
		                          LocaleSidKey='en_US', ProfileId = pro.Id, Phone ='7896545432',
		                          TimeZoneSidKey='America/Los_Angeles', UserName='r@ring.com',
		                          isActive = true);
		          insert u;
		         RCSF_Sync__c customSetUp = new RCSF_Sync__c(Name= 'RCSF Sync', 
														Username__c = 'r@ring.com', 
														Email__c = 'r@ring.com', 
														Active__c = true, 
														First_Name__c = 'RCSF', 
														Last_Name__c = 'Sync',
		                                                Id__c = 'r@ring.com');
					AccountHierarchyCustomSetting__c customSettingData = new AccountHierarchyCustomSetting__c(Name = 'AccountHierarchyInstance', 
																										HierarchyCalculationEnabled__c= true);	
					insert 	customSetUp;
					insert customSettingData;
					Test.startTest();
					System.runAs(u)	{
					    Account accObj = new Account();
					    accObj.Name = 'Rctest1';
					    accObj.RC_Account_Status__c ='trail';
					    accObj.Partner_ID__c = '1234';
					    accObj.recordTypeId = partnerAccRecordTypeId;
					    system.debug('======= accObj.recordTypeId ====== '+ accObj.recordTypeId);
					    accObj.RC_Signup_Date__c = System.Now();
					    accObj.Pay_Referral_Commissions__c = true;
					    accObj.Employees_Override__c = 45;
					    accObj.RC_User_ID__c = '234567';
					    insert accObj;
						  Id p = [select id from profile where name='RC Partner Modify'].id;
					    Contact con = new Contact(
					    							LastName ='testCon3',
					    							AccountId = accObj.Id,
					    							Phone = '9971626838',
					    							FirstName = 'TestFirstname',
					    							Email = 'My@mydomain.com'
					    							);
				        insert con;
				        		    		    
					    
						AccountTriggerStaticProperties.BY_PASS_ACCOUNT_BEFORE = false;
				        AccountTriggerStaticProperties.BY_PASS_ACCOUNT_AFTER = false;
						accObj.No_of_Employees__c = '12';
						accObj.SignupPlatform__c = 'Web';
						accObj.RC_User_ID__c = '234567';
						accObj.Service_Type__c = 'Office';
						accObj.RC_Account_Status__c ='Disabled';
						accObj.RC_Tier__c = 'Trial_New';
						accObj.RC_Brand__c = 'RingCentral';
						update accObj;
						Test.stopTest();
					} 
		    
		    }
		
        static testMethod void testAccountTrigger_Insert() {
           /************Current logged In user is sales *************
           ***** for setAccountValues(List<Account> accountList,Map<Id, User> userMap)****/  
          Profile p = [SELECT Id FROM Profile WHERE Name='xxSales Agent Inbound']; 
          User u = new User(Alias = 'standt', Email='5555salesuser@random.com', 
                                 EmailEncodingKey='UTF-8', lastName='testsalesUser123',  LanguageLocaleKey='en_US', 
                                 LocaleSidKey='en_US', ProfileId = p.Id, 
                                 TimeZoneSidKey='America/Los_Angeles', UserName='5555salesuser@testorg.com', isActive = true); 
     
          User newUser = new User(Alias = 'standt', Email='rcsfsync@ringcentral.com', 
                                 EmailEncodingKey='UTF-8', lastName='Sync',  LanguageLocaleKey='en_US', 
                                 LocaleSidKey='en_US', ProfileId = p.Id, firstName = 'RCSF',
                                 TimeZoneSidKey='America/Los_Angeles', UserName='rcsfsync@ringcentral.com', isActive = true); 
          insert newUser; 
          
          RCSF_Sync__c customSetUp = new RCSF_Sync__c(Id__c = newUser.id, Name= 'RCSF Sync', Username__c = 'rcsfsync@ringcentral.com', 
          								Email__c = 'rcsfsync@ringcentral.com', Active__c = true, First_Name__c = 'RCSF', Last_Name__c = 'Sync');
  		  AccountHierarchyCustomSetting__c customSettingData = new AccountHierarchyCustomSetting__c(Name = 'AccountHierarchyInstance', HierarchyCalculationEnabled__c= true);		
          insert customSetUp;
          insert customSettingData;
                   
          
          System.runAs(newUser) {
          	  createTestUser();
          	  System.debug ('newUser Data>>'+ newUser.username+ '::' + newUser.email );
          	  AccountTriggerStaticProperties.BY_PASS_ACCOUNT_BEFORE = false;
              AccountTriggerStaticProperties.BY_PASS_ACCOUNT_AFTER = false;              
          	  createPartnerAccounts();        
          	  partnerAccountsList[0].RC_Account_Status__C = 'Trial 7 CC';  
              partnerAccountsList[5].ParentId = partnerAccountsList[3].id;               
              createCustomerAccounts();
              conditionsSetAccountValuesInsert();
              conditionsSetEligibalForReferealCreditInsert(); 
              conditionsChkToCreateLeadForOfficeTrailsInsert();    
          	  insert partnerAccountsList;   
              AccountTriggerStaticProperties.BY_PASS_ACCOUNT_BEFORE = false;
              AccountTriggerStaticProperties.BY_PASS_ACCOUNT_AFTER = false;
              insert customerAccountsList; 
              AccountTriggerStaticProperties.BY_PASS_ACCOUNT_BEFORE = false;
              AccountTriggerStaticProperties.BY_PASS_ACCOUNT_AFTER = false;
              createCustomerHierarchy();
          } 
          
                       
        }     
        
        
        static testMethod void testAccountTrigger_Update() {
           
          RCSF_Sync__c customSetUp = new RCSF_Sync__c(Name= 'RCSF Sync', Username__c = 'rcsfsync@ringcentral.com', 
          								Email__c = 'rcsfsync@ringcentral.com', Active__c = true, First_Name__c = 'RCSF', Last_Name__c = 'Sync');
  		  AccountHierarchyCustomSetting__c customSettingData = new AccountHierarchyCustomSetting__c(Name = 'AccountHierarchyInstance', HierarchyCalculationEnabled__c= true);		
          insert customSetUp;
          insert customSettingData;
           /************Current logged In user is sales *************
           ***** for setAccountValues(List<Account> accountList,Map<Id, User> userMap)****/  
           Profile p = [SELECT Id FROM Profile where name = 'Sales Agent' LIMIT 1]; 
           //Profile pPartner = [select id from profile where name='RC Partner Modify'].id;
           //Account partnerAccountP = createAccountForPartnerContact();
           //Contact c = createContactWithoutAccount(partnerAccount);
           //System.debug('Contact id in update >>'+c);           
           
           //UserRole userRoleObj = [Select id from UserRole where PortalRole = 'Executive' and PortalType = 'Partner' limit 1];
           User u = new User(Alias = 'standt', Email='5555salesuser@random.com', 
                                 EmailEncodingKey='UTF-8', lastName='testsalesUser123', firstName= 'firstName', LanguageLocaleKey='en_US', 
                                 LocaleSidKey='en_US', ProfileId = p.Id, Phone ='7896545432',
                                 TimeZoneSidKey='America/Los_Angeles', UserName='5555salesuser@testorg.com',
                                 isActive = true);  
                                 
           /*User partnerUser = new User(Alias = 'standt', Email='5555partneruser@random.com', 
                                 EmailEncodingKey='UTF-8', lastName='testpartnerUser123', firstName= 'firstName', LanguageLocaleKey='en_US', 
                                 LocaleSidKey='en_US', ProfileId = pPartner.Id, Phone ='1100110011',
                                 TimeZoneSidKey='America/Los_Angeles', UserName='5555partneruser@testorg.com',
                                 isActive = true);      */    
                                 
           User newUser = new User(Alias = 'standt', Email='rcsfsync@ringcentral.com', 
                                 EmailEncodingKey='UTF-8', lastName='Sync',  LanguageLocaleKey='en_US', 
                                 LocaleSidKey='en_US', ProfileId = p.Id, firstName = 'RCSF',
                                 TimeZoneSidKey='America/Los_Angeles', UserName='rcsfsync@ringcentral.com', isActive = true); 
           insert newUser; 
                                  
           insert u;
           //insert partnerUser;
           
           System.runAs(u) {  
           	 
           	  createTestUser();      
              createPartnerAccounts();                
              createCustomerAccounts();               
              //createCustomerHierarchyforUpdation();  
              AccountTriggerStaticProperties.BY_PASS_ACCOUNT_BEFORE = false;
              AccountTriggerStaticProperties.BY_PASS_ACCOUNT_AFTER = false;
              Test.startTest();
              insert partnerAccountsList;  
              //Test.stopTest();            
              AccountTriggerStaticProperties.BY_PASS_ACCOUNT_BEFORE = false;
              AccountTriggerStaticProperties.BY_PASS_ACCOUNT_AFTER = false;
              //Test.startTest();
              insert customerAccountsList;
              //Test.stopTest(); 
              //Test.startTest();
              createEntitlement();
              createContact();             
              //Test.stopTest();            
              conditionssetAccountValuesOnUpdateSingle();              
              conditionsupdateEligibalForReferealCreditUpdate();
              conditionsupdateMostRecentImplementationContactUpdate();
              //Test.startTest();
              AccountTriggerStaticProperties.BY_PASS_ACCOUNT_BEFORE = false;
              AccountTriggerStaticProperties.BY_PASS_ACCOUNT_AFTER = false;  
              update updatableAccounts;  
              Test.stopTest();
              AccountTriggerStaticProperties.BY_PASS_ACCOUNT_BEFORE = false;
              AccountTriggerStaticProperties.BY_PASS_ACCOUNT_AFTER = false;     
              //testFinanceGroup();
              //AccountTriggerStaticProperties.BY_PASS_ACCOUNT_BEFORE = false;
              //AccountTriggerStaticProperties.BY_PASS_ACCOUNT_AFTER = false;              
          }  
           //Test.stopTest();
          //Test.startTest();
          
          //List<Account> deletableAccounts = [Select Id from Account where name like '%TestAccount%' or name like '%TestCustomerAccount%' ];
          //delete deletableAccounts;
         
        }    
        
     
        
     /*  static testMethod void testFinanceGroup() {
        
			Id partnerAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner Account').getRecordTypeId();
			Account accObj0 = new Account();
		    accObj0.Name = 'RCTest';
		    accObj0.recordTypeId = partnerAccRecordTypeId;
		    accObj0.Partner_Sign_Up_Date__c = System.today();
		    accObj0.Partner_ID__c = '1234';
		    accObj0.Current_Owner__c = System.Userinfo.getUserId();
		    //accObj0.Ultimate_Parent_Account_ID__c = '001Q000000pyRQk';
		    insert accObj0;
		    AccountTriggerStaticProperties.BY_PASS_ACCOUNT_BEFORE = false;
            AccountTriggerStaticProperties.BY_PASS_ACCOUNT_AFTER = false;    
		    
		    Account accObj34 = new Account();
		    accObj34.Name = 'RCTest';
		    accObj34.recordTypeId = partnerAccRecordTypeId;
		    accObj34.Partner_Sign_Up_Date__c = System.today();
		    accObj34.Partner_ID__c = '12345';
		    accObj34.Current_Owner__c = System.Userinfo.getUserId();
		   
		    //accObj0.Ultimate_Parent_Account_ID__c = '001Q000000pyRQk';
		    insert accObj34;
		    AccountTriggerStaticProperties.BY_PASS_ACCOUNT_BEFORE = false;
            AccountTriggerStaticProperties.BY_PASS_ACCOUNT_AFTER = false;    
		    //Test.startTest();
		    Account accObj = new Account();
		    accObj.Name = 'Rctest1';
		    accObj.ParentId = accObj0.Id;
		    accObj.RC_Account_Status__c ='Paid';
		    accObj0.Partner_ID__c = '1234';
		    accObj.recordTypeId = partnerAccRecordTypeId;
		    system.debug('======= accObj.recordTypeId ====== '+ accObj.recordTypeId);
		    accObj.RC_Signup_Date__c = System.Now();
		    accObj.Pay_Referral_Commissions__c = true;
		    accObj.Employees_Override__c = 45;
		    //accObj.ParentId = accObj0.Id;
		    //accObj.ZI_No_of_Employees_Range__c = '50';
		    // accObj.No_of_Employees__c = '60';
		    //accObj.TV_No_of_Employees_Range__c = '60';
		    // accObj.Ultimate_Parent_Account_ID__c = '001Q000000pyRQk';
		    insert accObj;
		    AccountTriggerStaticProperties.BY_PASS_ACCOUNT_BEFORE = false;
            AccountTriggerStaticProperties.BY_PASS_ACCOUNT_AFTER = false;    
		     Id p = [select id from profile where name='RC Partner Modify'].id;
		    Contact con = new Contact(LastName ='testCon',AccountId = accObj0.Id);
	        insert con;
	        User user = new User(alias = 'test123', email='test@nemail.com',
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
            localesidkey='en_US', profileid = p, country='United States',IsActive =true,
            ContactId = con.Id,
            timezonesidkey='America/Los_Angeles', username='tester@noema.com');
    
			insert user; 
			
			Group newGroup = new Group();
			newGroup.Name = 'TestNameForopti';
			newGroup.DoesIncludeBosses = false; 
			
			//Insert New Group for Opp Sharing
			insert newGroup;
			
			GroupMember newMember=new GroupMember();
			newMember.GroupId = newGroup.Id;
			newMember.UserOrGroupId= user.Id;
			//System.runAs(new User(Id = Userinfo.getUserId())) {
			    insert newMember;
			//}
			
			accObj.ParentId = accObj34.Id;
			update accObj;
			AccountTriggerStaticProperties.BY_PASS_ACCOUNT_BEFORE = false;
             AccountTriggerStaticProperties.BY_PASS_ACCOUNT_AFTER = false;    
			//Test.stopTest();			
    } */
      
       public static Group createGroup(){
       		 Group groupObj = new Group();
			 groupObj.Name = 'testGroup';			
			 insert groupObj;
			 return groupObj;
			 
			 
       }
      
       public static void createEntitlement(){
       		 Entitlement entitlement = new Entitlement();
			 entitlement.AccountId = partnerAccountsList[0].id;
			 entitlement.StartDate = System.today();
			 entitlement.EndDate = null;
			 entitlement.name = 'Test Entitlement';
			 insert entitlement;
       }
       
       public static void createContact(){
       	
       	     Contact con = new Contact();
       		 con.Description = 'Contact Descritption';
	         con.Email = 'contact@cot.com';
	         con.Contact_Status__c = 'New';
	         con.FirstName = 'Contact FirstName';
	         con.LastName = 'Contact LastName';	         
	         con.MailingCity = 'Contact city';
	         con.MailingCountry = 'Contact country';
	         con.MailingPostalCode = '111111';
	         con.MailingState = 'Contact state' ;
	         con.MailingStreet = 'Contact street';
	         con.Street_2__c = 'Contact street 2';	        
	         con.Phone = '9679671234'; 
	         con.Title = 'Ms';
	         con.Account = partnerAccountsList[0];
	         insert con;
       	
       }
       
       public static void conditionsupdateMostRecentImplementationContactUpdate(){
       		 Contact con = new Contact();
       		 con.Description = 'Contact Descritption';
	         con.Email = 'contact6@cot.com';
	         con.Contact_Status__c = 'New';
	         con.FirstName = 'Contact FirstName';
	         con.LastName = 'Contact LastName6';	         
	         con.MailingCity = 'Contact city';
	         con.MailingCountry = 'Contact country';
	         con.MailingPostalCode = '111111';
	         con.MailingState = 'Contact state' ;
	         con.MailingStreet = 'Contact street';
	         con.Street_2__c = 'Contact street 6';	        
	         con.Phone = '9679671236'; 
	         con.Title = 'Ms';
	         con.Account = partnerAccountsList[6];
	         insert con;	
	         
	         AccountContactRole accountContactRoleObj = new AccountContactRole();
	         accountContactRoleObj.contactId = con.Id;
	         accountContactRoleObj.role = 'RC Admin User';
	         accountContactRoleObj.accountId = partnerAccountsList[6].id;
	         accountContactRoleObj.isPrimary = true;
	         
	         updatableAccounts.add(partnerAccountsList[6]);
       }     
       
       public static Account createAccountForPartnerContact(){
         	Id partnerAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner Account').getRecordTypeId();
		     Account partnerAccObj = new Account();
             partnerAccObj.Name = 'TestAccount createContactWithoutAccount';
             partnerAccObj.Number_of_DL_s__c = 5;          
             partnerAccObj.RecordTypeId = partnerAccRecordTypeId ;
             partnerAccObj.Type ='PARTNER';
             //partnerAccObj.Current_Owner__c = userMap.get('Non-Sales User').id;
             partnerAccObj.Website ='testURL';
             partnerAccObj.Partner_ID__c ='9909';
                //partnerAccObj.Premium_Support_Agent__c = userMap.get('General User').id;
             partnerAccObj.RC_Account_Status__c = 'office';
                //partnerAccObj.IsPartner = true;
                //wAS NONSALES
             partnerAccObj.OwnerId = userMap1.get('Sales User').id;
             partnerAccObj.Phone = '8856321474';
             partnerAccObj.Account_Owner_Phone_Number__c = '8889994441';
             partnerAccObj.BillingCountry = 'testCountry';   
             partnerAccObj.RC_Brand__c = 'RingCentral';
             insert partnerAccObj;  
             return partnerAccObj;       
       	
       }
       
        public static Contact createContactWithoutAccount(Account partnerAccObj){
       		 
                       		
       		 Contact con = new Contact();
       		 con.Description = 'Contact Descritption';
	         con.Email = 'contact@cot.com';
	         con.Contact_Status__c = 'New';
	         con.FirstName = 'Contact FirstName';
	         con.LastName = 'Contact LastName';	         
	         con.MailingCity = 'Contact city';
	         con.MailingCountry = 'Contact country';
	         con.MailingPostalCode = '111111';
	         con.MailingState = 'Contact state' ;
	         con.MailingStreet = 'Contact street';
	         con.Street_2__c = 'Contact street 2';	        
	         con.Phone = '9679671234'; 
	         con.Title = 'Ms';
	         con.Account = partnerAccObj;
	         insert con;	
	         return con;        
       }   
  
      
 
        public static String getUserNamePrefix(){
    
            return UserInfo.getOrganizationId() + System.now().millisecond();
    
        }
        
        static void createPartnerAccounts(){        
            
            Id partnerAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner Account').getRecordTypeId();
                                        
            for (Integer i = 0 ; i < 10 ; i++ ){    
            	System.debug('createPartnerAccounts::'+i);       
                Account partnerAccObj = new Account();
                partnerAccObj.Name = 'TestAccount'+i;
                partnerAccObj.Number_of_DL_s__c = i+5;          
                partnerAccObj.RecordTypeId = partnerAccRecordTypeId ;
                partnerAccObj.Type ='PARTNER';
                partnerAccObj.Current_Owner__c = userMap.get('Non-Sales User').id;
                partnerAccObj.Website ='testURL';
                partnerAccObj.Partner_ID__c =i+''+i+''+i+''+i;
                partnerAccObj.Premium_Support_Agent__c = userMap.get('General User').id;
                partnerAccObj.Partner_Sign_Up_Date__C = date.parse('4/15/2015');
                partnerAccObj.RC_Account_Status__c = 'office';
                //partnerAccObj.IsPartner = true;
                //wAS NONSALES
                /**removing ownerid for grp issue**/
                //partnerAccObj.OwnerId = userMap1.get('Sales User').id;
                partnerAccObj.Phone = '985632147'+i;
                partnerAccObj.Account_Owner_Phone_Number__c = '5555555555';
                partnerAccObj.BillingCountry = 'testCountry';   
                partnerAccObj.RC_Brand__c = 'RingCentral';
                partnerAccountsList.add (partnerAccObj);   
                             
            }     
            
            
            for (Integer i = 0 ; i < partnerAccountsList.size() ; i++ ){
                System.debug ('partnerAccountsList data'+ i + '...'+partnerAccountsList[i].name+ '....'+ partnerAccountsList[i].Phone);
            }          
            
        }
        
        static void createCustomerAccounts(){       
            
            Id customerAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer Account').getRecordTypeId();
                                        
            for (Integer i = 0 ; i < 10 ; i++ ){    
            	System.debug('createCustomerAccounts::'+i);             
                Account customerAccObj = new Account();
                customerAccObj.Name = 'TestCustomerAccount'+i;
                customerAccObj.Number_of_DL_s__c = i+5;      
                customerAccObj.Pay_Referral_Commissions__c  = false; 
                //customerAccObj.RecordTypeId = customerAccRecordTypeId ;
                customerAccObj.Type ='CUSTOMER';            
                customerAccObj.Partner_ID__c =partnerAccountsList[i].Partner_ID__c;
                customerAccObj.Premium_Support_Agent__c = userMap.get('Non-Sales User').id;
                customerAccObj.RC_Account_Status__c = 'Trial 7 CC';
                customerAccObj.OwnerId = userMap.get('Non-Sales User').id;
                customerAccObj.Phone = '985632147'+i;
                customerAccObj.BillingCountry = 'testCountry';
                customerAccObj.RC_Brand__c = 'RingCentral';             
                customerAccountsList.add(customerAccObj);               
            }             
             for (Integer i = 0 ; i < 10 ; i++ ){
                System.debug ('customerAccountsList data'+ i + '...'+customerAccountsList[i].name+ '....'+ customerAccountsList[i].Phone);
            }        
            //return partnerAccountsList;
        }
        
        static void createTestUser(){
        	
        	UserRole userRoleObj = [Select id from UserRole where PortalRole = 'Executive' and PortalType = 'Partner' limit 1];
        	
            User salesTestUser = new User(alias = 'Alias12', email='123testSales@testorg.com',emailencodingkey='UTF-8', lastname='testsalesUser123', 
                                     ProfileId = [SELECT Id FROM Profile LIMIT 1].Id, Phone= '2323232323',
                                     languagelocalekey='en_US',localesidkey='en_US', country='United States',
                                     timezonesidkey='America/Los_Angeles', username=getUserNamePrefix() + '123testSales@testorg.com', IsActive=true ); 
                                     
            User testUser = new User(alias = 'Alias123', email='456testUser@testorg.com',emailencodingkey='UTF-8', lastname='testUser123', 
                                     ProfileId = [SELECT Id FROM Profile LIMIT 1].Id, Phone= '4564564561',
                                     languagelocalekey='en_US',localesidkey='en_US', country='United States',
                                     timezonesidkey='America/Los_Angeles', username= getUserNamePrefix() + '456testUser@testorg.com', IsActive=true);   
            User generalUser = new User(alias = 'Alias111', email='567testUser@testorg.com',emailencodingkey='UTF-8', lastname='testGeneralUser123', 
                                     ProfileId = [SELECT Id FROM Profile LIMIT 1].Id, Phone= '7827827821',
                                     languagelocalekey='en_US',localesidkey='en_US', country='United States',
                                     timezonesidkey='America/Los_Angeles', username= getUserNamePrefix() + '567testUser@testorg.com', IsActive=true);
            User generalUser1 = new User(alias = 'Alias777', email='678testUser@testorg.com',emailencodingkey='UTF-8', lastname='testGeneralUser1', 
                                     ProfileId = [SELECT Id FROM Profile LIMIT 1].Id, Phone= '1001001001',
                                     languagelocalekey='en_US',localesidkey='en_US', country='United States',
                                     timezonesidkey='America/Los_Angeles', username= getUserNamePrefix() + '678testUser@testorg.com', IsActive=true);                                     
                                                 
            insert salesTestUser;   
            insert testUser;
            insert generalUser;
            insert generalUser1;
            userMap.put('Sales User', salesTestUser);
            userMap.put('Non-Sales User', testUser);
            userMap.put('General User', generalUser);          
            userMap.put('General User 1', generalUser1);    
        }
        
        /*static void createTestUser1(){
        	
        	//UserRole userRoleObj = [Select id from UserRole where PortalRole = 'Executive' and PortalType = 'Partner' limit 1];
        	//Contact c = createContactWithoutAccount();
        	
        	
            User salesTestUser = new User(alias = 'Alias12', email='123testSales@testorg.com',emailencodingkey='UTF-8', lastname='testsalesUser123', 
                                     ProfileId = [SELECT Id FROM Profile  LIMIT 1].Id, Phone= '2323232323',
                                     languagelocalekey='en_US',localesidkey='en_US', country='United States',
                                     timezonesidkey='America/Los_Angeles', username=getUserNamePrefix() + '123testSales@testorg.com', IsActive=true); 
                                     
            User testUser = new User(alias = 'Alias123', email='456testUser@testorg.com',emailencodingkey='UTF-8', lastname='testUser123', 
                                     ProfileId = [SELECT Id FROM Profile  LIMIT 1].Id, Phone= '4564564561',
                                     languagelocalekey='en_US',localesidkey='en_US', country='United States',
                                     timezonesidkey='America/Los_Angeles', username= getUserNamePrefix() + '456testUser@testorg.com', IsActive=true);   
            User generalUser = new User(alias = 'Alias111', email='567testUser@testorg.com',emailencodingkey='UTF-8', lastname='testGeneralUser123', 
                                     ProfileId = [SELECT Id FROM Profile  LIMIT 1].Id, Phone= '7827827821',
                                     languagelocalekey='en_US',localesidkey='en_US', country='United States',
                                     timezonesidkey='America/Los_Angeles', username= getUserNamePrefix() + '567testUser@testorg.com', IsActive=true);
            User generalUser1 = new User(alias = 'Alias777', email='678testUser@testorg.com',emailencodingkey='UTF-8', lastname='testGeneralUser1', 
                                     ProfileId = [SELECT Id FROM Profile  LIMIT 1].Id, Phone= '1001001001',
                                     languagelocalekey='en_US',localesidkey='en_US', country='United States',
                                     timezonesidkey='America/Los_Angeles', username= getUserNamePrefix() + '678testUser@testorg.com', IsActive=true);                                     
                                                 
            insert salesTestUser;   
            insert testUser;
            insert generalUser;
            insert generalUser1;
            userMap1.put('Sales User', salesTestUser);
            userMap1.put('Non-Sales User', testUser);
            userMap1.put('General User', generalUser);          
            userMap1.put('General User 1', generalUser1);    
        }*/
   
      
        static void createCustomerHierarchyforUpdation() {
                Id partnerAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner Account').getRecordTypeId();
                
                Account partnerAccObj = new Account();
                partnerAccObj.Name = 'Top Account in hierarchy';                            
                partnerAccObj.RecordTypeId = partnerAccRecordTypeId ;
                partnerAccObj.Type ='PARTNER';
                partnerAccObj.Partner_ID__c ='123456';
                partnerAccObj.Premium_Support_Agent__c = userMap.get('Non-Sales User').id;
                partnerAccObj.RC_Account_Status__c = 'office';
                partnerAccObj.OwnerId = userMap.get('Non-Sales User').id;
                partnerAccObj.Phone = '11111111';
                partnerAccObj.BillingCountry = 'testCountry';
                // values set for setEligibalForReferealCredit insert trigger
                partnerAccObj.Partner_Customer_Count__c = 3;
                partnerAccObj.Partner_Sign_Up_Date__c = date.parse('04/22/2015');
                insert partnerAccObj;
                AccountTriggerStaticProperties.BY_PASS_ACCOUNT_BEFORE = false;
                AccountTriggerStaticProperties.BY_PASS_ACCOUNT_AFTER = false;
                
                Account customerAccObj0 = new Account();
                customerAccObj0.Name = 'Customer Hierarchy account 1';
                customerAccObj0.Number_of_DL_s__c = 5;          
                //customerAccObj.RecordTypeId = customerAccRecordTypeId ;
                customerAccObj0.Type ='CUSTOMER';           
                customerAccObj0.Partner_ID__c ='123456';
                customerAccObj0.Premium_Support_Agent__c = userMap.get('Non-Sales User').id;
                //customerAccObj0.RC_Account_Status__c = 'office';
                customerAccObj0.OwnerId = userMap.get('Non-Sales User').id;
                customerAccObj0.Phone = '22222222';
                customerAccObj0.BillingCountry = 'testCountry';
                customerAccObj0.RC_Account_Status__c = 'Trial';
                customerAccObj0.Pay_Referral_Commissions__c = true;
                customerAccObj0.RC_Signup_Date__c = date.parse('05/10/2015'); 
                customerAccObj0.RC_Brand__c = 'RingCentral';    
                customerAccObj0.RC_Service_Name__c = 'Office';
                customerAccObj0.Number_of_DL_s__c = 2;
                customerAccObj0.Do_Not_Creation_Implementation__c = false;
                customerAccObj0.RC_User_Id__c = 'abcd';
                insert customerAccObj0;
                System.debug('customerAccObj0::::::'+customerAccObj0.RC_User_Id__c);
                AccountTriggerStaticProperties.BY_PASS_ACCOUNT_BEFORE = false;
                AccountTriggerStaticProperties.BY_PASS_ACCOUNT_AFTER = false;
                customerAccObj0.RC_User_Id__c = 'bcde';                
     
                
                Account customerAccObj2 = new Account();
                customerAccObj2.Name = 'Customer Hierarchy account 3';
                customerAccObj2.Number_of_DL_s__c = 5;    
                customerAccObj2.RC_Signup_Date__c = date.parse('05/14/2015');       
                //customerAccObj.RecordTypeId = customerAccRecordTypeId ;
                customerAccObj2.Type ='CUSTOMER';           
                customerAccObj2.Partner_ID__c ='123456';
                customerAccObj2.Premium_Support_Agent__c = userMap.get('Non-Sales User').id;
                //customerAccObj2.RC_Account_Status__c = 'office';
                customerAccObj2.OwnerId = userMap.get('Non-Sales User').id;
                customerAccObj2.Phone = '22222222';
                customerAccObj2.BillingCountry = 'testCountry';
                customerAccObj2.ParentId = customerAccObj0.id;
                customerAccObj2.RC_Service_name__c = 'FAX';
                customerAccObj2.RC_Account_Status__c = 'TEST';
                customerAccObj2.Pay_Referral_Commissions__c = true;
                System.debug('customerAccObj2:::::::'+customerAccObj2.Name);
                insert customerAccObj2;  
                customerAccObj2.BillingCountry = 'testCountry1';
                System.debug('customerAccObj2:::::::'+customerAccObj2.id);
                System.debug('Hierarchy method::'+customerAccObj2.ParentId+ '::'+customerAccObj2.RC_Service_name__c+ '::'+ customerAccObj2.RC_Account_Status__c);
                updatableAccounts.add(customerAccObj2);  
                updatableAccounts.add(customerAccObj0);  
            
        }
        
        static void createCustomerHierarchy() {
        	    System.debug('createCustomerHierarchy Inside ');
                Id partnerAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner Account').getRecordTypeId();
                Id customerAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer Account').getRecordTypeId();
                
                Account partnerAccObj = new Account();
                partnerAccObj.Name = 'Top Account in hierarchy';                            
                partnerAccObj.RecordTypeId = partnerAccRecordTypeId ;
                partnerAccObj.Type ='PARTNER';
                partnerAccObj.Partner_ID__c ='123456';
                partnerAccObj.Premium_Support_Agent__c = userMap.get('Non-Sales User').id;
                partnerAccObj.RC_Account_Status__c = 'office';
                //partnerAccObj.OwnerId = userMap.get('Non-Sales User').id;
                partnerAccObj.Phone = '11111111';
                partnerAccObj.BillingCountry = 'testCountry';
                // values set for setEligibalForReferealCredit insert trigger
                partnerAccObj.Partner_Customer_Count__c = 3;
                partnerAccObj.Partner_Sign_Up_Date__c = date.parse('04/22/2015');
                AccountTriggerStaticProperties.BY_PASS_ACCOUNT_BEFORE = false;
                AccountTriggerStaticProperties.BY_PASS_ACCOUNT_AFTER = false;
                insert partnerAccObj;
                System.debug('partnerAccObj::::::'+partnerAccObj);
                AccountTriggerStaticProperties.BY_PASS_ACCOUNT_BEFORE = false;
                AccountTriggerStaticProperties.BY_PASS_ACCOUNT_AFTER = false;
                
                Account customerAccObj0 = new Account();
                customerAccObj0.Name = 'Customer Hierarchy account 1';
                customerAccObj0.Number_of_DL_s__c = 5;          
                customerAccObj0.RecordTypeId = customerAccRecordTypeId ;
                customerAccObj0.Type ='CUSTOMER';           
                customerAccObj0.Partner_ID__c ='123456';
                //customerAccObj0.Premium_Support_Agent__c = userMap.get('Non-Sales User').id;
                //customerAccObj0.RC_Account_Status__c = 'office';
                //customerAccObj0.OwnerId = userMap.get('Non-Sales User').id;
                customerAccObj0.Phone = '22222222';
                customerAccObj0.BillingCountry = 'testCountry';
                customerAccObj0.RC_Account_Status__c = 'Trial';
                customerAccObj0.Pay_Referral_Commissions__c = true;
                customerAccObj0.RC_Signup_Date__c = date.parse('05/10/2015'); 
                customerAccObj0.RC_Brand__c = 'RingCentral';    
                customerAccObj0.RC_Service_Name__c = 'Office';
                customerAccObj0.Number_of_DL_s__c = 2;
                customerAccObj0.Do_Not_Creation_Implementation__c = false;
                customerAccObj0.RC_User_Id__c = 'abcd';
                System.debug('Yes I have rchd');
                insert customerAccObj0;
                System.debug('customerAccObj0::::::'+customerAccObj0.RC_User_Id__c);
                AccountTriggerStaticProperties.BY_PASS_ACCOUNT_BEFORE = false;
                AccountTriggerStaticProperties.BY_PASS_ACCOUNT_AFTER = false;                
                
                Account customerAccObj1 = new Account();
                customerAccObj1.Name = 'Customer Hierarchy account 2';
                customerAccObj1.Number_of_DL_s__c = 5;          
                //customerAccObj.RecordTypeId = customerAccRecordTypeId ;
                customerAccObj1.Type ='CUSTOMER';           
                customerAccObj1.Partner_ID__c ='123456';
                customerAccObj1.Premium_Support_Agent__c = userMap.get('Non-Sales User').id;
                customerAccObj1.RC_Account_Status__c = 'office';
                customerAccObj1.OwnerId = userMap.get('Non-Sales User').id;
                customerAccObj1.Phone = '22222222';
                customerAccObj1.BillingCountry = 'testCountry';
                customerAccObj1.ParentId = customerAccObj0.id;
                customerAccObj1.RC_Signup_Date__c = date.parse('05/12/2015'); 
                // values set for setEligibalForReferealCredit insert trigger
                customerAccObj1.RC_Account_Status__c = 'Paid';
                customerAccObj1.Pay_Referral_Commissions__c = true;
                insert customerAccObj1;
                System.debug('customerAccObj1:::::::'+customerAccObj1.id);
                AccountTriggerStaticProperties.BY_PASS_ACCOUNT_BEFORE = false;
                AccountTriggerStaticProperties.BY_PASS_ACCOUNT_AFTER = false;
                
                Account customerAccObj2 = new Account();
                customerAccObj2.Name = 'Customer Hierarchy account 3';
                customerAccObj2.Number_of_DL_s__c = 5;    
                customerAccObj2.RC_Signup_Date__c = date.parse('05/14/2015');       
                //customerAccObj.RecordTypeId = customerAccRecordTypeId ;
                customerAccObj2.Type ='CUSTOMER';           
                customerAccObj2.Partner_ID__c ='123456';
                customerAccObj2.Premium_Support_Agent__c = userMap.get('Non-Sales User').id;
                //customerAccObj2.RC_Account_Status__c = 'office';
                customerAccObj2.OwnerId = userMap.get('Non-Sales User').id;
                customerAccObj2.Phone = '22222222';
                customerAccObj2.BillingCountry = 'testCountry';
                customerAccObj2.ParentId = customerAccObj1.id;
                customerAccObj2.RC_Service_name__c = 'FAX';
                customerAccObj2.RC_Account_Status__c = 'TEST';
                customerAccObj2.Pay_Referral_Commissions__c = true;
                System.debug('customerAccObj2:::::::'+customerAccObj2.Name);
                insert customerAccObj2;  
                
                System.debug('customerAccObj2:::::::'+customerAccObj2.id);
                System.debug('Hierarchy method::'+customerAccObj2.ParentId+ '::'+customerAccObj2.RC_Service_name__c+ '::'+ customerAccObj2.RC_Account_Status__c);
                    
            
        }
        
        
       static void conditionsSetAccountValuesInsert(){
             /*************Hierarchy partner at top, followed by 3 customers ************
               ***** for setAccountValues(List<Account> accountList,Map<Id, User> userMap)****/ 
              partnerAccountsList[0].Premium_Support_Agent__c = userMap.get('Non-Sales User').id;            
              // did nt enter acct.RecordTypeId  = rtMapByRecName.get('Customer Account').getRecordTypeId();
              //dne if (acct.Ultimate_Parent_Account_ID__c != NULL) 
              //dne if (objpro.Name.toLowerCase().contains('sales') && !objpro.Name.toLowerCase().contains('engineer')) 
        }
        
       static void conditionsSetEligibalForReferealCreditInsert(){
              //dne exception part rest all covered
              //dne accountSharingOnInsert also covered except the exception
              customerAccountsList[2].Pay_Referral_Commissions__c = true;   
              customerAccountsList[2].RC_Account_Status__c = 'Paid';    
        
      } 
      
      static void conditionsChkToCreateLeadForOfficeTrailsInsert(){
      	      customerAccountsList[4].Service_Type__c = 'Office';
      	      customerAccountsList[4].RC_Account_Status__c = 'Trial 30 CC';
      	      customerAccountsList[4].No_of_Employees__c = '2-9';
      }
      
      static void conditionscreateImplementationOnAccountInsert(){
              customerAccountsList[0].RC_Brand__c = 'RingCentral';
      }
      
      static void conditionssetAccountValuesOnUpdateSingle(){      	
      	
      	    System.debug('partnerAccountsList[0].id '+partnerAccountsList[0].id);
      	    System.debug('partnerAccountsList[1].id '+partnerAccountsList[1].id);
      	    Account partnerAccount = [Select Id,ownerId, Name,website,Current_Owner__c,RC_Account_Number__c, Service_Type__c, Account_Owner_Phone_Number__c, Phone, RC_Account_Status__C, Premium_Support_Agent__c
                                              from Account where id = :partnerAccountsList[0].id limit 1];
            System.debug(' all value partnerAccount '+partnerAccount);                                  
    		partnerAccount.ownerId = userMap.get('General User').Id;
            partnerAccount.website = 'www.testSite.com';
            partnerAccount.Current_Owner__c = null;
            partnerAccount.Service_Type__C = 'Office';
            partnerAccount.RC_Account_Number__c='11111111111';  
            partnerAccount.RC_Account_Status__C = 'Disabled';        
            partnerAccount.Account_Owner_Phone_Number__c = '1515151515';          
            partnerAccount.Phone = '6666666666';             
            
            Account partnerAccount1 = [Select Id,Name,website,Current_Owner__c,RC_Account_Number__c, Service_Type__c
                                              from Account where id = :partnerAccountsList[1].id limit 1];
            System.debug ('userMap.get(General User).Id'+userMap.get('General User').Id);
            partnerAccount1.Current_Owner__c = userMap.get('General User').Id;
            partnerAccount1.Service_Type__C = 'FAX';
            partnerAccount1.Phone = '6666666666'; 
            
            
            Account customerAccount = [Select Id,Name,website,Current_Owner__c,RC_Account_Number__c, Service_Type__c
                                              from Account where id = :customerAccountsList[0].id limit 1];
            System.debug ('userMap.get(General User).Id'+userMap.get('General User').Id);
            customerAccount.Current_Owner__c = userMap.get('General User').Id;
            customerAccount.Service_Type__C = 'FAX';
            customerAccount.Phone = '7777777777';
            customerAccount.Partner_ID__c='3333';
            customerAccount.ParentId = partnerAccount1.Id;
            //List<Account> updatableAccounts = new List<Account>();
            updatableAccounts.add(partnerAccount);
            updatableAccounts.add(partnerAccount1);
            updatableAccounts.add(customerAccount);
           // update updatableAccounts;
            //AccountTriggerStaticProperties.BY_PASS_ACCOUNT_BEFORE = false;
            //AccountTriggerStaticProperties.BY_PASS_ACCOUNT_AFTER = false;        
            System.debug ('Updating customer acc');
      	    //update customerAccount;
      	    AccountTriggerStaticProperties.BY_PASS_ACCOUNT_BEFORE = false;
            AccountTriggerStaticProperties.BY_PASS_ACCOUNT_AFTER = false;        
      	    //dne ck why last condition is still red
      }
      
    
     static void conditionsupdateEligibalForReferealCreditUpdate(){   	    
 
    		Account customerAccount1 = [Select Id,Name,website,Current_Owner__c,RC_Account_Number__c, Service_Type__c, Pay_Referral_Commissions__c
                                              from Account where id = :customerAccountsList[1].id limit 1];
            System.debug ('userMap.get(General User).Id'+userMap.get('General User').Id);
            customerAccount1.Current_Owner__c = userMap.get('General User').Id;
            customerAccount1.Service_Type__C = 'FAX';
            customerAccount1.RC_Account_Status__c = 'Paid';
            customerAccount1.Phone = '7777777777';
            customerAccount1.Partner_ID__c='2222';
            customerAccount1.Pay_Referral_Commissions__c  = true;
            customerAccount1.RC_Signup_date__c = System.now() ;
            //customerAccount1.parentId = partnerAccountsList[5].id;
            //update customerAccount;
            updatableAccounts.add(customerAccount1);            
      }  
      
   

    }