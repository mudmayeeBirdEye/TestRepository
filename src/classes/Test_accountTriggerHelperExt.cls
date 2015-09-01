@isTest 
private class Test_accountTriggerHelperExt {

  static testMethod void accountTriggerHelperExtUpdate(){
  
  Map<id, User> mapUser = new Map<id, User>();
  List<Account> lstAccount = new List<Account>();
  User testUser = new User(alias = 'u1', email='u1234@testorg.com',emailencodingkey='UTF-8', lastname='Testing123', 
                 ProfileId=[SELECT Id FROM Profile LIMIT 1].Id, 
                             languagelocalekey='en_US',localesidkey='en_US', country='United States',
                             timezonesidkey='America/Los_Angeles', username='u11234@testorg.com', IsActive=true);                   
        insert testUser;
        mapUser.put(testUser.id,testUser);
   
  
  Account accObj0 = new Account();
  accObj0.Name = 'RCTest';
  accObj0.Number_of_DL_s__c = 5;
    
  Account accObj01 = new Account();
    accObj01.Name = 'TestAccount1023';
    accObj01.Number_of_DL_s__c = 5;
    accObj01.RecordTypeId = '01280000000UERq';
    accObj01.Type ='Customer';
    
  Account accObj00 = new Account();
    accObj00.Name = 'TestAccount1023';
    accObj00.Number_of_DL_s__c = 5;
    accObj00.ParentId = accObj01.Id;
    accObj00.RecordTypeId = '01280000000UERq';
    accObj00.Type ='Customer';
    
    Account accObj02 = new Account();
    accObj02.Name = 'TestAccount1023';
    accObj02.Number_of_DL_s__c = 5;
    accObj02.ParentId = accObj01.Id;
    accObj02.RecordTypeId = '01280000000UERq';
    accObj02.Type ='Customer';
    
    List<Account> insertList = new List<Account>{accObj0,accObj01,accObj00,accObj02};
  insert insertList;
  
  Contact contObj = new Contact();
    contObj.AccountId =  accObj0.Id;
    contObj.Email = 'rc1234@test.com';
    contObj.LastName = 'Test Last232';
    contObj.FirstName = 'Test First333';
    insert contObj;
     
    Schema.DescribeSObjectResult result = Account.SObjectType.getDescribe();
  Map<ID,Schema.RecordTypeInfo> rtMapByName = result.getRecordTypeInfosById();
  AccountTriggerHelperExt objAccountTriggerHelperExt = new AccountTriggerHelperExt();
       
    Account accObj = new Account();
    accObj.Name = 'TestAccount1023';
    accObj.Number_of_DL_s__c = 5;
    accObj.ParentId = accObj0.Id;
    accObj.RecordTypeId = '01280000000UERv';
    accObj.Type ='Partner';
    accObj.Partner_ID__c ='1234';
    accObj.Premium_Support_Agent__c = testUser.Id;
    accObj.RC_Account_Status__c = 'office';
    accObj.OwnerId = testUser.Id;
    accObj.Phone = '9856321475';
    accObj.BillingCountry = 'test';
    insert accObj; 
    lstAccount.add(accObj);
    lstAccount.add(accObj01);
    accObj01.Number_of_DL_s__c = 6;
    accObj01.Website = 'gogle.com';
    accObj.Premium_Support_Agent__c = testUser.Id;
    accObj.RC_Account_Status__c = 'office12';
    accObj.Current_Owner__c = testUser.Id;
    accObj01.Partner_ID__c ='1234';
    system.debug('$$$$$$$$$ here we are $$$$$$$$$$$$$$$ ');
    TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT = false;
    TriggerHandler.BY_PASS_ACCOUNT_ON_UPDATE = false;
    update lstAccount;
  AccountTriggerHelperExt.accountRecordTypeInformation(lstAccount, mapUser);
  AccountTriggerHelperExt.updateLastTouchedSalesPerson(lstAccount, testUser);
  //AccountTriggerHelperExt.updateContactStatus(lstAccount);
  //AccountTriggerHelperExt.accountSharingOnUpdate0(lstAccount, mapUser);
}

static testMethod void accountTriggerHelperInsert(){
    List<Account> accountList = new List<Account>();
    Map<id, User> mapUser = new Map<id, User>();
    
    Schema.DescribeSObjectResult result = Account.SObjectType.getDescribe();
  Map<ID,Schema.RecordTypeInfo> rtMapByName = result.getRecordTypeInfosById();
  
   Account acctObj = new Account();
    acctObj.Name = 'TestAccount1';
    acctObj.RecordTypeId = '01280000000UERv';
    acctObj.Type ='Partner';
    acctObj.RC_Account_Status__c = 'office13';
    acctObj.RC_User_ID__c = '6783';
    insert acctObj;
    accountList.add(acctObj);
    acctObj.Partner_ID__c ='1234';
    acctObj.Current_Owner__c = '00580000003SZir';
    update accountList;
   
  Account accObj = new Account();
    accObj.Name = 'TestAccount12';
    accObj.RecordTypeId = '01280000000UERv';
    accObj.Type ='Partner';
    accObj.RC_Account_Status__c = 'office13';
    accObj.RC_User_ID__c = '678';
    insert accObj;
    accountList.add(accObj);
    accObj.Partner_ID__c ='1234';
    acctObj.Current_Owner__c = '00580000003SZir';
    update accountList;
            
    Account objAcc = new Account();
    objAcc.Name = 'TestAccount10234';
    objAcc.RecordTypeId = '01280000000UERq';
    objAcc.Type ='Customer';
    objAcc.Partner_ID__c ='1234';
    objAcc.RC_Account_Status__c = 'office13';
    insert objAcc; 
    accountList.add(objAcc);
    objAcc.RC_Account_Status__c = 'office14';
    acctObj.Current_Owner__c = '00580000003SZir';
    update accountList;
    AccountTriggerHelperExt.accountSharingOnInsert(accountList);
 }
 static testMethod void accountSharingOnUpdate0(){
  Schema.DescribeSObjectResult result = Account.SObjectType.getDescribe();
  Map<ID,Schema.RecordTypeInfo> rtMapByName = result.getRecordTypeInfosById();
  Map<id, User> mapUser = new Map<id, User>();
  Map<Id,Account>oldAccountMap = new Map<Id,Account>();
  List<Account> accList = new List<Account>();
  User testUser = new User(alias = 'u1', email='u1234@testorg.com',emailencodingkey='UTF-8', lastname='Testing12', 
                 ProfileId=[SELECT Id FROM Profile LIMIT 1].Id, 
                             languagelocalekey='en_US',localesidkey='en_US', country='United States',
                             timezonesidkey='America/Los_Angeles', username='u11234@testorg.com', IsActive=true);                   
       insert testUser;
       mapUser.put(testUser.id,testUser);
       
  Account acctObj = new Account();
   acctObj.Name = 'RCTest';
   acctObj.Website = 'https://www.google.co.in/';
   acctObj.Number_of_Locations__c = '1';
   acctObj.NumberOfEmployees = 2;
   acctObj.No_of_Employees__c = '2-9';
   acctObj.Industry = 'Consulting: IT';
   acctObj.Phone = '1234567890';
   acctObj.BillingCountry = 'USA';
   acctObj.Is_the_customer_interested_in_porting__c = 'Yes';
  /* acctObj.Current_Owner__c = '00580000003SZir';
   acctObj.OwnerId = testUser.Id;*/
   acctObj.RC_Account_Number__c = '18377081942';
   acctObj.Service_Type__c = 'office12';
   acctObj.RC_Account_Status__c = 'Trial 7 CC';
   acctObj.Current_Owner__c = testUser.Id;
   insert acctObj;
   accountTriggerHelperExt.oldAccountMap.put(acctObj.id,acctObj);
   accList.add(acctObj);
   acctObj.Industry ='Consulting: Other'; 
   acctObj.Website = 'https://www.gmail.com';
   //update accList;
  
   update acctObj;
   system.debug('@#@#@#@#@323'+accountTriggerHelperExt.oldAccountMap);
   accountTriggerHelperExt.accountSharingOnUpdate0(accList, mapUser);
}
  static testMethod void accountSharingOnUpdate1(){
     Schema.DescribeSObjectResult result = Account.SObjectType.getDescribe();
   Map<ID,Schema.RecordTypeInfo> rtMapByName = result.getRecordTypeInfosById();  
   Map<Id,Account>oldAccountMap = new Map<Id,Account>();
   Map<id, User> mapUser = new Map<id, User>();
   List<Account> accountList = new List<Account>(); 
   Set<String>  setPartnerId  = New Set<String>();
   Map<String,Account> MapPartnerId = new Map<String,Account>();
   User testUser = new User(alias = 'u1', email='u1234@testorg.com',emailencodingkey='UTF-8', lastname='Testing12', 
                 ProfileId=[SELECT Id FROM Profile LIMIT 1].Id, 
                             languagelocalekey='en_US',localesidkey='en_US', country='United States',
                             timezonesidkey='America/Los_Angeles', username='u11234@testorg.com', IsActive=true);                   
        insert testUser;
        mapUser.put(testUser.id,testUser);
  
   Account acctObj = new Account();
     acctObj.Name = 'TestAccount98';
     acctObj.RecordTypeId = '01280000000UERv';
     acctObj.Type ='Partner';
     acctObj.Partner_ID__c ='456';
     acctObj.Current_Owner__c = testUser.id;
     accountList.add(acctObj);
  
   Account accObj1 = new Account();
   	 accObj1.Name = 'TestAccount12';
     accObj1.RecordTypeId = '01280000000UERq';
     accObj1.Type ='Customer';
     accObj1.Partner_ID__c ='098';
     accountList.add(accObj1);
     accountTriggerHelperExt.accountSharingOnUpdate1(accountList);
     accountTriggerHelperExt.accountSharingOnUpdate2(accountList);
  }
  static testmethod void updatePartnerCodeOnInsertAndUpdate(){
     Schema.DescribeSObjectResult result = Account.SObjectType.getDescribe();
   Map<ID,Schema.RecordTypeInfo> rtMapByName = result.getRecordTypeInfosById();  
   Map<id, User> mapUser = new Map<id, User>();
   Map<Id,Account>oldAccountMap = new Map<Id,Account>();
   List<Account> accountList = new List<Account>(); 
   Set<String>  setPartnerId  = New Set<String>();
   Map<String,Account> MapPartnerId = new Map<String,Account>();
   User testUser = new User(alias = 'u1', email='u1234@testorg.com',emailencodingkey='UTF-8', lastname='Testing125', 
                 ProfileId=[SELECT Id FROM Profile LIMIT 1].Id, 
                             languagelocalekey='en_US',localesidkey='en_US', country='United States',
                             timezonesidkey='America/Los_Angeles', username='u11234@testorg.com', IsActive=true);                   
        insert testUser;
        mapUser.put(testUser.id,testUser);
  
     Account acctObj = new Account();
	     acctObj.Name = 'TestAccountss';
	     acctObj.RecordTypeId = '01280000000UERv';
	     acctObj.Type ='Partner';
	     acctObj.Partner_ID__c ='678';
	     acctObj.Current_Owner__c = '00580000003SZir';
	     accountList.add(acctObj);
     
     Account accObj = new Account();
	     accObj.Name = 'TestAccount123';
	     accObj.RecordTypeId = '01280000000UERq';
	     accObj.Type ='Customer';
	     accObj.Partner_ID__c ='678';
	     acctObj.Current_Owner__c = testUser.id;
	     accObj.Service_Type__c = 'Rcoffice';
	     accountList.add(accObj);
	     accountTriggerHelperExt.updatePartnerCodeOnInsertAndUpdate(accountList);
  }
 static testmethod void toggleNumberPorting(){
   Account accObj = new Account();
  accObj.Name = 'RCTest';
  insert accObj;
  
  Case caseObj = new Case();
  caseObj.Subject = 'Test Subject';
  caseObj.status = 'New';
  caseObj.Priority='P3';
  caseObj.AccountId = accObj.Id;
  insert caseObj;
  caseObj.status = 'Closed';
  update caseObj;
  //accountTriggerHelperExt.toggleNumberPorting(accObj);
 }
 static testMethod void accountSharingOnUpdate2(){
   Schema.DescribeSObjectResult result = Account.SObjectType.getDescribe();
  Map<ID,Schema.RecordTypeInfo> rtMapByName = result.getRecordTypeInfosById();  
  Map<id, User> mapUser = new Map<id, User>();
  Map<Id,Account>oldAccountMap = new Map<Id,Account>();
  List<Account> accountList = new List<Account>(); 
   
   Account accObj = new Account();
   accObj.RecordTypeId = '01280000000UERq';
  accObj.Name = 'RCIndiaTest';
  accObj.Do_Not_Creation_Implementation__c =  true;
  accObj.Type = 'Customer';
  accObj.Partner_ID__c = '345';
  insert accObj;
  accObj.Do_Not_Creation_Implementation__c =  false;
  update accObj;
  
  Account acctObj = new Account();
   acctObj.RecordTypeId = '01280000000UERv';
  acctObj.Name = 'RCIndiaTest1';
  acctObj.Do_Not_Creation_Implementation__c = true;
  acctObj.Type = 'Partner';
  acctObj.Partner_ID__c = '345';
  insert acctObj;
  acctObj.Do_Not_Creation_Implementation__c =  false;
  update acctObj;
  accountTriggerHelperExt.accountSharingOnUpdate2(accountList);
 }
 
 static testMethod void calculateAccountHierarchyTotalDLS(){
     List<Account> accountList = new List<Account>();
     Set<String> testid= new Set<String>();
     Account accObj0 = new Account();
     accObj0.Name = 'RCTest';
     accObj0.RC_Account_Status__c ='Paid';
     //accObj0.Ultimate_Parent_Account_ID__c = '001Q000000pyRQk';
     insert accObj0;
     accountList.add(accObj0);
     testid.add(accObj0.Id);
     
     Account accObj = new Account();
     accObj.Name = 'Rctest1';
     accObj.ParentId = accObj0.Id;
     accObj.RC_Account_Status__c ='Paid';
    // accObj.Ultimate_Parent_Account_ID__c = '001Q000000pyRQk';
     insert accObj;
     accountList.add(accObj);
     testid.add(accObj.Id);
     accountTriggerHelperExt.calculateAccountHierarchyTotalDLS(testid);
     
 }
}