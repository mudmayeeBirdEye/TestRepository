/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 */
@isTest
private class TestauthCreateMigrationRequest {

    static testMethod void Test_authCreateMigrationRequest(){
     
        Account  objAccount= new Account(Name='Test ATT Account');
        objAccount.Partner_id__c='123456Test12345';
        objAccount.RC_User_ID__c='12345';
        TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT = true;
        insert objAccount;
        TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT = false;
            
        Contact objContact= new Contact(FirstName='Test', LastName='Contact', Phone='9910101023');
        objContact.AccountId=objAccount.id;
        objContact.email='testopp@testopp.com';
        TriggerHandler.BY_PASS_CONTACT_ON_INSERT = true;
        insert objContact; 
        TriggerHandler.BY_PASS_CONTACT_ON_INSERT = false;
            
        Test.startTest();
  
        authCreateMigrationRequest.authUserInputParam vauthUserInputParam=new authCreateMigrationRequest.authUserInputParam ();
        vauthUserInputParam.In_RCUserID=objAccount.RC_User_ID__c;
        vauthUserInputParam.In_RCPrimaryNumber='';
        vauthUserInputParam.In_ContactMail= objContact.email;
        authCreateMigrationRequest.createMigrationRequest(vauthUserInputParam);
        
        Case caseObj = new Case(ContactId=objContact.Id, AccountId=objAccount.id,Subject='Test',status='Open',Priority='P3',Description='Test Description');
        TriggerHandler.BY_PASS_CASE_ON_INSERT = true;
        insert caseObj;     
        TriggerHandler.BY_PASS_CASE_ON_INSERT = false;
        
        Case objCase=[Select id,Status from Case where AccountId=:objAccount.id and ContactId=:objContact.id LIMIT 1];
        objCase.status='closed';
        TriggerHandler.BY_PASS_CASE_ON_UPDATE = true;
        update objCase;
        TriggerHandler.BY_PASS_CASE_ON_UPDATE = false;
        authCreateMigrationRequest.createMigrationRequest(vauthUserInputParam);
            
        Test.stopTest();
       
        vauthUserInputParam.In_RCUserID='test12345';
        vauthUserInputParam.In_RCPrimaryNumber='';
        vauthUserInputParam.In_ContactMail= objContact.email;
       
        authCreateMigrationRequest.createMigrationRequest(vauthUserInputParam);
    }
}