/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 */
@isTest(seeAlldata=true)
private class TestHelperCaseDispatch {
	
	static void insertCS(){
		List<Case_Dispatch__c> settingList = new List<Case_Dispatch__c>();
        settingList.add(new Case_Dispatch__c(Name='CS1',Product_Assistance__c='Company Settings',Tier__c='Fax,Pro',Operator__c='<=',Total_Account_DL_s__c=20,Queue__c='General Support Queue', VIP_Queue__c='General Support Queue', VIP__c = true));
        settingList.add(new Case_Dispatch__c(Name='CS2',Product_Assistance__c='Company Settings',Tier__c='Office',Operator__c='<=',Total_Account_DL_s__c=20,Queue__c='General Support Queue', VIP_Queue__c='General Support Queue', VIP__c = false));
        settingList.add(new Case_Dispatch__c(Name='CS3',Product_Assistance__c='Company Settings',Tier__c='Office',Operator__c='<',Total_Account_DL_s__c=20,Queue__c='General Support Queue', VIP_Queue__c='General Support Queue', VIP__c = true));
        settingList.add(new Case_Dispatch__c(Name='CS4',Product_Assistance__c='Company Settings',Tier__c='Office',Operator__c='==',Total_Account_DL_s__c=20,Queue__c='General Support Queue', VIP_Queue__c='General Support Queue', VIP__c = false));
        settingList.add(new Case_Dispatch__c(Name='CS5',Product_Assistance__c='Company Settings',Tier__c='Office',Operator__c='!=',Total_Account_DL_s__c=20,Queue__c='General Support Queue', VIP_Queue__c='General Support Queue', VIP__c = true));
        settingList.add(new Case_Dispatch__c(Name='CS6',Product_Assistance__c='Company Settings',Tier__c='Office',Operator__c='>',Total_Account_DL_s__c=20,Queue__c='General Support Queue', VIP_Queue__c='General Support Queue', VIP__c = true));
        settingList.add(new Case_Dispatch__c(Name='CS7',Product_Assistance__c='Company Settings',Tier__c='Office',Operator__c='>=',Total_Account_DL_s__c=20,Queue__c='General Support Queue', VIP_Queue__c='General Support Queue', VIP__c = true));
        insert settingList;
	}
	
    static testMethod void myUnitTest() {
    	Test.startTest();
        // TO DO: implement unit test
        insertCS();
        Account acctest = new Account();
        acctest.Name = 'TestAccount';
        acctest.Number_of_DL_s__c = 21;
        acctest.RC_Tier__c = 'Fax'; 
        TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT();
        insert acctest; 
        TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT = false;
        
        Contact contObj = new Contact();
        contObj.AccountId =  acctest.Id;
        contObj.Email = 'abc2@test.com';
        contObj.LastName = 'Test Last2';
        contObj.FirstName = 'Test First2';
        TriggerHandler.BY_PASS_CONTACT_ON_INSERT();
        insert contObj;
        TriggerHandler.BY_PASS_CONTACT_ON_INSERT = false;
        Case caseObj = new Case();
        caseObj.Account = acctest;
        caseObj.Product_Assistance__c = 'Company Settings';
        caseObj.Subject = 'Test Case';
        caseObj.Description = 'Test Case Desc';
        insert caseObj;
        
        ID ProfileID = [Select id from Profile where name = 'Customer Portal User'].id;
        User loginUser = new User( email='test-user@fakeemail.com', contactid = contObj.id, profileid = profileid, 
                UserName='test-user@fakeemail.com', alias='tuser1', CommunityNickName='tuser1', 
		TimeZoneSidKey='America/New_York', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', 
		LanguageLocaleKey='en_US', FirstName = 'Test', LastName = 'User' );
        insert loginUser;
        HelperCaseDispatch.assignQueue(caseObj, loginUser);
        Test.stopTest();
        
    }
    static testMethod void myUnitTest1() {
    	Test.startTest();
        // TO DO: implement unit test
        insertCS();
        Account acctest = new Account();
        acctest.Name = 'TestAccount';
        acctest.Number_of_DL_s__c = 21;
        acctest.RC_Tier__c = 'office';
        
		TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT();
        insert acctest; 
        TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT = false;

        Contact contObj = new Contact();
        contObj.AccountId =  acctest.Id;
        contObj.Email = 'abc2@test.com';
        contObj.LastName = 'Test Last2';
        contObj.FirstName = 'Test First2';
        TriggerHandler.BY_PASS_CONTACT_ON_INSERT();
        insert contObj;
        TriggerHandler.BY_PASS_CONTACT_ON_INSERT = false;
        Case caseObj = new Case();
        caseObj.Account = acctest;
        caseObj.Product_Assistance__c = 'Company Settings';
        caseObj.Subject = 'Test Case';
        caseObj.Description = 'Test Case Desc';
        insert caseObj;
        ID ProfileID = [ Select id from Profile where name = 'Customer Portal User'].id;
        User loginUser = new User( email='test-user@fakeemail.com', contactid = contObj.id, profileid = profileid, 
                UserName='test-user@fakeemail.com', alias='tuser1', CommunityNickName='tuser1', 
		TimeZoneSidKey='America/New_York', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', 
		LanguageLocaleKey='en_US', FirstName = 'Test', LastName = 'User' );
        insert loginUser;
        HelperCaseDispatch.assignQueue(caseObj, loginUser);
        Test.stopTest();
    }
    static testMethod void myUnitTest2() {
        // TO DO: implement unit test
        Test.startTest();
        insertCS();
        Account acctest = new Account();
        acctest.Name = 'TestAccount';
        acctest.Number_of_DL_s__c = 21;
        acctest.RC_Tier__c = 'office';
        TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT();
        insert acctest; 
        TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT = false; 
        Contact contObj = new Contact();
        contObj.AccountId =  acctest.Id;
        contObj.Email = 'abc2@test.com';
        contObj.LastName = 'Test Last2';
        contObj.FirstName = 'Test First2';
        TriggerHandler.BY_PASS_CONTACT_ON_INSERT();
        insert contObj;
        TriggerHandler.BY_PASS_CONTACT_ON_INSERT = false;
        Case caseObj = new Case();
        caseObj.Account = acctest;
        caseObj.Product_Assistance__c = 'Company Settings';
        caseObj.Subject = 'Test Case';
        caseObj.Description = 'Test Case Desc';
        insert caseObj;
        ID ProfileID = [ Select id from Profile where name = 'Customer Portal User'].id;
        User loginUser = new User( email='test-user@fakeemail.com', contactid = contObj.id, profileid = profileid, 
                UserName='test-user@fakeemail.com', alias='tuser1', CommunityNickName='tuser1', 
		TimeZoneSidKey='America/New_York', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', 
		LanguageLocaleKey='en_US', FirstName = 'Test', LastName = 'User' );
        insert loginUser;
        HelperCaseDispatch.assignQueue(caseObj, loginUser);
        Test.stopTest();
    }
    static testMethod void myUnitTest3() {
        // TO DO: implement unit test
        Test.startTest();
        insertCS();
        Account acctest = new Account();
        acctest.Name = 'TestAccount';
        acctest.Number_of_DL_s__c = 19;
        acctest.RC_Tier__c = 'office';
        TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT();
        insert acctest; 
        TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT = false; 
        Contact contObj = new Contact();
        contObj.AccountId =  acctest.Id;
        contObj.Email = 'abc2@test.com';
        contObj.LastName = 'Test Last2';
        contObj.FirstName = 'Test First2';
        TriggerHandler.BY_PASS_CONTACT_ON_INSERT();
        insert contObj;
        TriggerHandler.BY_PASS_CONTACT_ON_INSERT = false;
        Case caseObj = new Case();
        caseObj.Account = acctest;
        caseObj.Product_Assistance__c = 'Company Settings';
        caseObj.Subject = 'Test Case';
        caseObj.Description = 'Test Case Desc';
        insert caseObj;
        ID ProfileID = [Select id from Profile where name = 'Customer Portal User'].id;
        User loginUser = new User( email='test-user@fakeemail.com', contactid = contObj.id, profileid = profileid, 
                UserName='test-user@fakeemail.com', alias='tuser1', CommunityNickName='tuser1', 
		TimeZoneSidKey='America/New_York', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', 
		LanguageLocaleKey='en_US', FirstName = 'Test', LastName = 'User' );
        insert loginUser;
        HelperCaseDispatch.assignQueue(caseObj, loginUser);
        Test.stopTest();
    }
    static testMethod void myUnitTest4() {
        // TO DO: implement unit test
        Test.startTest();
        insertCS();
        Account acctest = new Account();
        acctest.Name = 'TestAccount';
        TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT();
        insert acctest; 
        TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT = false; 
        Contact contObj = new Contact();
        contObj.AccountId =  acctest.Id;
        contObj.Email = 'abc2@test.com';
        contObj.LastName = 'Test Last2';
        contObj.FirstName = 'Test First2';
        TriggerHandler.BY_PASS_CONTACT_ON_INSERT();
        insert contObj;
        TriggerHandler.BY_PASS_CONTACT_ON_INSERT = false;
        Case caseObj = new Case();
        caseObj.Account = acctest;
        caseObj.Product_Assistance__c = 'Company Settings';
        caseObj.Subject = 'Test Case';
        caseObj.Description = 'Test Case Desc';
        insert caseObj;
        ID ProfileID = [ Select id from Profile where name = 'Customer Portal User'].id;
        User loginUser = new User( email='test-user@fakeemail.com', contactid = contObj.id, profileid = profileid, 
                UserName='test-user@fakeemail.com', alias='tuser1', CommunityNickName='tuser1', 
		TimeZoneSidKey='America/New_York', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', 
		LanguageLocaleKey='en_US', FirstName = 'Test', LastName = 'User' );
        insert loginUser;
        HelperCaseDispatch.assignQueue(caseObj, loginUser);
        Test.stopTest();
    }
    static testMethod void myUnitTest5() {
        // TO DO: implement unit test
        Test.startTest();
        insertCS();
        Account acctest = new Account();
        acctest.Name = 'TestAccount';
        acctest.Number_of_DL_s__c = 20;
        acctest.RC_Tier__c = 'test tier';
        TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT();
        insert acctest; 
        TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT = false; 
        Contact contObj = new Contact();
        contObj.AccountId =  acctest.Id;
        contObj.Email = 'abc2@test.com';
        contObj.LastName = 'Test Last2';
        contObj.FirstName = 'Test First2';
        TriggerHandler.BY_PASS_CONTACT_ON_INSERT();
        insert contObj;
        TriggerHandler.BY_PASS_CONTACT_ON_INSERT = false;
        Case caseObj = new Case();
        caseObj.Account = acctest;
        caseObj.Product_Assistance__c = 'Company Settings';
        caseObj.Subject = 'Test Case';
        caseObj.Description = 'Test Case Desc';
        insert caseObj;
        ID ProfileID = [ Select id from Profile where name = 'Customer Portal User'].id;
        User loginUser = new User( email='test-user@fakeemail.com', contactid = contObj.id, profileid = profileid, 
                UserName='test-user@fakeemail.com', alias='tuser1', CommunityNickName='tuser1', 
		TimeZoneSidKey='America/New_York', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', 
		LanguageLocaleKey='en_US', FirstName = 'Test', LastName = 'User' );
        insert loginUser;
        HelperCaseDispatch.assignQueue(caseObj, loginUser);
        Test.stopTest();
    }
    
    static testMethod void myUnitTest6() {
        // TO DO: implement unit test
        Test.startTest();
        insertCS();
        Account acctest = new Account();
        acctest.Name = 'TestAccount';
        acctest.Number_of_DL_s__c = 21;
        acctest.RC_Tier__c = 'test';
        TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT();
        insert acctest; 
        TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT = false; 
        Contact contObj = new Contact();
        contObj.AccountId =  acctest.Id;
        contObj.Email = 'abc2@test.com';
        contObj.LastName = 'Test Last2';
        contObj.FirstName = 'Test First2';
        TriggerHandler.BY_PASS_CONTACT_ON_INSERT();
        insert contObj;
        TriggerHandler.BY_PASS_CONTACT_ON_INSERT = false;
        Case caseObj = new Case();
        //caseObj.Account = acctest;
        caseObj.Product_Assistance__c = 'Company Settings';
        caseObj.Subject = 'Test Case';
        caseObj.Description = 'Test Case Desc';
        insert caseObj;
        
        ID ProfileID = [ Select id from Profile where name = 'Customer Portal User'].id;
        User loginUser = new User( email='test-user@fakeemail.com', contactid = contObj.id, profileid = profileid, 
                UserName='test-user@fakeemail.com', alias='tuser1', CommunityNickName='tuser1', 
		TimeZoneSidKey='America/New_York', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', 
		LanguageLocaleKey='en_US', FirstName = 'Test', LastName = 'User' );
        insert loginUser;
        caseObj.OwnerId = userInfo.getUserId();
        update caseObj;
        HelperCaseDispatch.assignQueue(caseObj, loginUser);
        Test.stopTest();
    }
    
}