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
@isTest
private class TestPlayGround {

    
    static testmethod void testForGraduationScore(){
    	Test_Utils testUtilsObj = new Test_Utils();
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
			Account accObj = new Account();
		    accObj.Name = 'Rctest1';
		    accObj.RC_Account_Status__c ='Trail';
		    accObj.Service_Type__c = 'Office';
		    accObj.Partner_ID__c = '1234';
		    accObj.recordTypeId = partnerAccRecordTypeId;
		    system.debug('======= accObj.recordTypeId ====== '+ accObj.recordTypeId);
		    accObj.RC_Signup_Date__c = System.Now();
		    accObj.Pay_Referral_Commissions__c = true;
		    accObj.Employees_Override__c = 45;
		    	    
		    
			insert accObj;
			Contact con = new Contact(
			    							LastName ='testCon1',
			    							AccountId = accObj.Id,
			    							Phone = '9971626838',
			    							FirstName = 'TestFirstname',
			    							Email = 'My@mydomain.com'
			    							);
			insert con;	
			Account_Metric__c accMetricObj = new Account_Metric__c();
	        accMetricObj.Peer_Group_ID__c = 101;
	        accMetricObj.Graduation_Phase_Completion_Rate__c = 80;
	        accMetricObj.Metric_1_value__c = 0;
	        accMetricObj.Metric_18_value__c = 0;
	        accMetricObj.Metric_11_value__c = 1;
	        accMetricObj.Account_ID__c = accObj.Id;
	        accMetricObj = testUtilsObj.createAccountMetricRecords(new List<Account_Metric__c>{accMetricObj})[0];
	        Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Support - T3').getRecordTypeId();
	        Case cas = new Case(
	        					status = 'Open',
	        					Subject = 'test',
	        					Priority = 'P3',
	        					Description = 'Test Case Descrption',
	        					RecordTypeId = caseRecordTypeId,
	        					AccountId = accObj.Id
	        					
	        );
	        insert cas;
	        
	        Implementation__c implementationObj =  new Implementation__c();
	        implementationObj.Account__c = accObj.Id;
	        implementationObj.Implementation_Status__c = '6a. Completed';
	        implementationObj.Contact__c = con.Id;
	        implementationObj.Account_Graduation_Status__c = 'Done';
	        
	        implementationObj = testUtilsObj.createImplementationRecords(new List<Implementation__c>{implementationObj})[0];
			Test.startTest();
			accObj.RC_Account_Status__c ='Paid';
			update accObj;
			Test.stopTest();
    }
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
}