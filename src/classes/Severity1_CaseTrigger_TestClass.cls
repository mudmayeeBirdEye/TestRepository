/******************************************************************************
* Project Name..........: 													  *
* File..................: Severity1_CaseTrigger_TestClass  					  *
* Version...............: 1.0 												  *
* Created by............: Simplion Technologies 							  *
* Created Date..........: 30th August 2013 									  *
* Last Modified by......: Simplion Technologies 							  *
* Last Modified Date....: 													  *
* Description...........: Test class for Severity1_CaseTrigger                *
******************************************************************************/
@isTest
private class Severity1_CaseTrigger_TestClass {
    static testMethod void myUnitTest() {
		try {
    		//*Creating Test Data
		    User testUser = new User(alias = 'u1', email='vineet.kumar@simplion.com',emailencodingkey='UTF-8', lastname='Testing22', 
		                              ProfileId = Userinfo.getProfileId(), 
		                              languagelocalekey='en_US',localesidkey='en_US', country='United States',
		                              timezonesidkey='America/Los_Angeles', username='u112345@testorg.com', IsActive=true);                   
		    insert testUser;
		    
		    // Fetching record type for Account, Customer Account
			Schema.DescribeSObjectResult resultAccount = Account.SObjectType.getDescribe();
		    Map<String,Schema.RecordTypeInfo> accountMapByName = resultAccount.getRecordTypeInfosByName();
			        
		    //Creating Test Account
			Account createTestAccount =  new Account();
			createTestAccount.RecordTypeId = accountMapByName.get('Customer Account').getRecordTypeId();
			createTestAccount.Name = 'testAccount';
			createTestAccount.Current_Owner__c = testUser.Id;
			createTestAccount.Number_of_DL_s__c = 11;
			insert createTestAccount;
			
			//Creating Test Contact
			Contact testContact = new Contact();
			testContact.AccountId = createTestAccount.id;
		    testContact.firstName='first name';
		    testContact.LastName='last name5';
		    testContact.email ='vineet.kumar@simplion.com';
		    testContact.Phone = '9810546384';
		    testContact.CurrencyIsoCode = 'USD';
		    insert testContact;
				
		    // Fetching record type for Case object, Support Case
			Schema.DescribeSObjectResult resultCase = Case.SObjectType.getDescribe();
		    Map<String,Schema.RecordTypeInfo> caseMapByName = resultCase.getRecordTypeInfosByName();
		    Test.startTest();
		    //Testing for positve case
		    Case testCase = new Case(); 
		    testCase.RecordTypeId = caseMapByName.get('Support-Case').getRecordTypeId();
		    testCase.Status = 'New';
		    testCase.Origin = 'Email';
		    testCase.AccountId = createTestAccount.Id;
		    testCase.Subject = 'Test Case';
		    testCase.Description = 'This is a test case';
		    //testCase.Support_Disposition_Level_1__c = 'Mobile Apps';
		    //testCase.Support_Disposition_Level_2__c = 'Outage';
		    testCase.ContactId = testContact.Id;
		    testCase.Case_Severity__c = 'Level 1 - Critical';
	        insert testCase;
    		Test.stopTest();	
    	} catch(Exception ex) {}
    }
}