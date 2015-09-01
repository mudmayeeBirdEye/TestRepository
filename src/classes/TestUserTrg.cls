/*******************************************************************************************************
* Project Name..........: TestUserTrg                                                                  *
* File..................: TestUserTrg.class                                                            *
* Version...............: 1.0                                                                          *
* Created by............: eugenebasianomutya                                                           *
* Created Date..........: 01-04-2015                                                                   *
* Last Modified by......: eugenebasianomutya                                                           *
* Last Modified Date....: 01-04-2015                                                                   *
* Description...........: This is a utility class to for UserTrg trigger.                              *
********************************************************************************************************/

@isTest
public with sharing class TestUserTrg {

    static testMethod void myUnitTest(){
    
        //1 Create Account
        //2 Create Contact
        //3 Create User
        
        
        //1 Create Account
        Schema.DescribeSObjectResult result = Account.SObjectType.getDescribe();
        Map<string,Schema.RecordTypeInfo> rtMapById = result.getRecordTypeInfosByName();
        
        Account acctest1 = new Account();
        acctest1.Name = 'TestAccount';
        acctest1.RC_Account_Status__c = 'Paid';
        acctest1.RecordTypeId =rtMapById.get('Partner Account').getRecordTypeID();        
        insert acctest1;
        
        acctest1.isPartner = true;
        update acctest1;
        
        //2 Create Contact
        Contact objcon = new Contact();
        objcon.FirstName='test';
        objcon.LastName ='testl';
        objcon.AccountId = acctest1.id;
        objcon.Phone= '4098764563';
        objcon.email = 'Test123@simplion.com';
        insert objcon;     
        
        //3 Create User
        Profile p = [SELECT Id,UserType FROM Profile WHERE Name='RC Partner Modify – Full']; 
           
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                        UserName='standarduser00001@testorg.com',
                        EmailEncodingKey='UTF-8', LastName='Testing', 
                        LanguageLocaleKey='en_US', 
                        LocaleSidKey='en_US', ProfileId = p.Id,
                        ContactId = objcon.id,           
                        TimeZoneSidKey='America/Los_Angeles');
        
        
        insert(u);
        
        system.debug('USER TYPE>>>>>' + u.UserType);
        
        system.debug('==>'+[Select id,userType from User where id =: u.id]);
        
    }
}