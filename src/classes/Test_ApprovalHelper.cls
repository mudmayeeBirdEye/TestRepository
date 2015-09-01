/**************************************************************************************************
* Project Name..........: RingCentral -                                                           *
* File..................: Test_ApprovalHelper                                                     *
* Created by............: Simplion Technologies                                                   *
* Created Date..........: 18th November 2014                                                      *
* Description...........: This is a test class for ApprovalHelper                   			  *
**************************************************************************************************/
@isTest
private class Test_ApprovalHelper {
	
	public static testMethod void claimOwnershipTest(){
	
		Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
		User u1 = new User(Alias = 'newUser', Email='newuser@testorg.com', 
							EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
							LocaleSidKey='en_US', ProfileId = p.Id, 
							TimeZoneSidKey='America/Los_Angeles', UserName='newuser@testorg.com');
		
		insert u1;
		
		//RecordType rt = [select id,Name from RecordType where SobjectType='Account' and Name='Transfer' Limit 1];
		//Map<string, RecordType> recordTypeMap = new Map<string, RecordType>([SELECT  Name, IsActive, Id FROM RecordType  WHERE SobjectType ='Account']);
		
		Schema.DescribeSObjectResult result = Account.SObjectType.getDescribe();
		Map<String,Schema.RecordTypeInfo> rtMapByName = result.getRecordTypeInfosByName();
		Schema.RecordTypeInfo rtByName =  rtMapByName.get('Customer Account');
		List<Account> lstAcc = new List<Account>();
    	Account accObj = new Account();
	    accObj.Name = 'TestAccount';
	    accObj.Number_of_DL_s__c = 5;
	    accObj.Type ='Customer';
	    accObj.RecordTypeId = rtByName.getRecordTypeId();
	    lstAcc.add(accObj);
	    
    	Account accObj1 = new Account();
	    accObj1.Name = 'TestAccount';
	    accObj1.Number_of_DL_s__c = 5;
	    accObj1.Type ='Customer';
	    accObj1.RecordTypeId = rtByName.getRecordTypeId();
	    lstAcc.add(accObj1);
	   // accObj.Partner_ID__c = '12345';
	    TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT = true;
	    insert lstAcc;
	    TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT = false;
	    
	    Schema.DescribeSObjectResult result1 = Approval__c.SObjectType.getDescribe();
		Map<String,Schema.RecordTypeInfo> rtMapByName1 = result1.getRecordTypeInfosByName();
		Schema.RecordTypeInfo rtByName1 =  rtMapByName1.get('Farming Claim Owner');
		
		List<Approval__c> apprList = new List<Approval__c>();
		Approval__c apprl = new Approval__c();
		apprl.Status__c = 'Approved';
		apprl.Transfer_Type__c = 'Referral';
		apprl.Account__c = accObj1.Id;
		apprl.Claiming_Requestor__c = u1.Id;	
		apprl.RecordTypeId = rtByName1.getRecordTypeId();
		apprList.add(apprl);
		
		Approval__c appr = new Approval__c();
		appr.Status__c = 'Approved';
		appr.Transfer_Type__c = 'Internal Transfer';
		appr.Account__c = accObj.Id;
		appr.Claiming_Requestor__c = u1.Id;	
		appr.RecordTypeId = rtByName1.getRecordTypeId();
		apprList.add(appr);
		insert apprList;
		//system.debug('===apprList======='+apprList);
		
		Set<Id> apprvIdSet = new Set<Id>();
		apprvIdSet.add(appr.Id);
		apprvIdSet.add(apprl.Id);
		
		
		ApprovalHelper Aprl = new ApprovalHelper();
		Test.startTest();
		ApprovalHelper.claimOwnership(apprvIdSet);
		Test.stopTest();
		
	}

}