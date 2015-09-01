/******************************************************************************
* Project Name..........: 													  *
* File..................: RedAccountTrigger_TestClass   					  *
* Version...............: 1.0 												  *
* Created by............: Simplion Technologies 							  *
* Created Date..........: 30th August 2013 									  *
* Last Modified by......: Simplion Technologies 							  *
* Last Modified Date....: 													  *
* Description...........: Test class for RedAccountTrigger                    *
******************************************************************************/
@isTest
private class RedAccountTrigger_TestClass {

    static testMethod void myUnitTest() {
		
		// Fetching record type for Account, Customer Account
		Schema.DescribeSObjectResult resultAccount = Account.SObjectType.getDescribe();
	    Map<String,Schema.RecordTypeInfo> accountMapByName = resultAccount.getRecordTypeInfosByName();
	    
	    /*Creating Test data*/
		//Creating Test User
		User testUser = new User(alias = 'u1', email='vineet.kumar@simplion.com',emailencodingkey='UTF-8', lastname='Testing', 
                                  ProfileId=[SELECT Id FROM Profile LIMIT 1].Id, 
                                  languagelocalekey='en_US',localesidkey='en_US', country='United States',
                                  timezonesidkey='America/Los_Angeles', username='u11234@testorg.com', IsActive=true);                   
        insert testUser;
		
		//Creating Test Account
		Account createTestAccount =  new Account();
		createTestAccount.RecordTypeId = accountMapByName.get('Customer Account').getRecordTypeId();
		createTestAccount.Name = 'testAccount';
		createTestAccount.Current_Owner__c = testUser.Id;
		createTestAccount.Number_of_DL_s__c = 11;
		insert createTestAccount;
		
		/*Testing for positive cases*/
		//Creating Test Account Metrics
		Account_Metric__c createTestAccountMetric = new Account_Metric__c();
		createTestAccountMetric.Metric_28_value__c = 11;
		createTestAccountMetric.Account_ID__c = createTestAccount.Id;
		insert createTestAccountMetric;
		
		//Creating Test custom setting
		Case_Severity_1_Email__c testDefaultEmail = new Case_Severity_1_Email__c();
		testDefaultEmail.Name = 'Default';
		testDefaultEmail.Default_Email__c = 'test@test.com';
		insert testDefaultEmail; 
		
		/*Testing for negative cases*/
		createTestAccount.Current_Owner__c = null;
		update createTestAccount;
		update createTestAccountMetric;
    }
}