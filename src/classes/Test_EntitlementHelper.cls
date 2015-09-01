/**************************************************************************************************
* Project Name..........: Entitlement                                                             *
* File..................: EntitlementHelper.class                                                 *
* Version...............: 1.0                                                                     *
* Created by............: Simplion Technologies                                                   *
* Created Date..........: 19-06-2014                                                              *
* Last Modified by......: Simplion Technologies                                                   *
* Last Modified Date....: 19-06-2014                                                              *
* Description...........: Test Class for Entitlement Helper.                                      *
**************************************************************************************************/
@isTest
private class Test_EntitlementHelper {
	
	// Creating Test Utils object to create call method and setup test records.
	public static Test_Utils objTestUtils = new Test_Utils();
	
	static testMethod void myUnitTest() {
		
		List<BusinessHours> lstBusinessHours =  new List<BusinessHours>();
		List<SlaProcess> lstSlaProcess =  new List<SlaProcess>();
		
		BusinessHours objBusinessHours = new BusinessHours();
		SlaProcess objSlaProcess = new SlaProcess();
		
		List<Entitlement_Account_Configuration__c> lstEntitlementAccount = new List<Entitlement_Account_Configuration__c>();
		List<Entitlement_Case_ReType_Configuration__c> lstEntitlementCaseReType = new List<Entitlement_Case_ReType_Configuration__c>();
		EntitlementEnable__c enableEntitlement = new EntitlementEnable__c();
		enableEntitlement.IsEntitlementsEnabled__c =  true;
		enableEntitlement.Name = 'IsEntitlementsEnabled';
		insert enableEntitlement;
		
		try{
	    	test.startTest();
	    	lstBusinessHours = [SELECT b.Name, b.Id FROM BusinessHours b];
			if(!lstBusinessHours.isEmpty()){
				objBusinessHours = lstBusinessHours[0];
			}
			
			lstSlaProcess = [SELECT s.Name, s.Id FROM SlaProcess s ];
			if(!lstSlaProcess.isEmpty()){
				objSlaProcess = lstSlaProcess[0];
			}
			
			// Setting up Entitlement Account Configuration record.
	    	lstEntitlementAccount.add(new Entitlement_Account_Configuration__c(Name='RingCentral Mobile', SLA_Process__c=objSlaProcess.Id, RC_Brand__c='RingCentral', Type__c='Web Support', Number_of_DLs__c='0-1', Service_Name__c='Mobile', Business_Hours__c=objBusinessHours.Id)); 
			lstEntitlementAccount.add(new Entitlement_Account_Configuration__c(Name='RingCentral Office', SLA_Process__c=objSlaProcess.Id, RC_Brand__c='RingCentral', Type__c='Web Support', Number_of_DLs__c='0-1', Service_Name__c='Office', Business_Hours__c=objBusinessHours.Id)); 
			lstEntitlementAccount.add(new Entitlement_Account_Configuration__c(Name='RingCentral Office 20+', SLA_Process__c=objSlaProcess.Id, RC_Brand__c='RingCentral', Type__c='Web Support', Number_of_DLs__c='20+', Service_Name__c='Office', Business_Hours__c=objBusinessHours.Id)); 
			lstEntitlementAccount.add(new Entitlement_Account_Configuration__c(Name='RingCentral Office 2-19', SLA_Process__c=objSlaProcess.Id, RC_Brand__c='RingCentral', Type__c='TEST 19', Number_of_DLs__c='2-19', Service_Name__c='Office', Business_Hours__c=objBusinessHours.Id));
			/*
			lstEntitlementAccount.add(new Entitlement_Account_Configuration__c(Name='RingCentral Professional', SLA_Process__c=objSlaProcess.Id, RC_Brand__c='RingCentral', Type__c='Web Support', Number_of_DLs__c='0-1', Service_Name__c='Professional', Business_Hours__c=objBusinessHours.Id)); 
			lstEntitlementAccount.add(new Entitlement_Account_Configuration__c(Name='RingCentral Fax', SLA_Process__c=objSlaProcess.Id, RC_Brand__c='RingCentral', Type__c='Web Support', Number_of_DLs__c='0-1', Service_Name__c='Fax', Business_Hours__c=objBusinessHours.Id)); 
			lstEntitlementAccount.add(new Entitlement_Account_Configuration__c(Name='Test', SLA_Process__c=objSlaProcess.Id, RC_Brand__c='ATS', Type__c='Test Type', Number_of_DLs__c='50+', Service_Name__c='Testing Service', Business_Hours__c='01mQ00000008Pco')); 
			lstEntitlementAccount.add(new Entitlement_Account_Configuration__c(Name='Default', SLA_Process__c=objSlaProcess.Id, Type__c='Default', Business_Hours__c=objBusinessHours.Id));
			lstEntitlementAccount.add(new Entitlement_Account_Configuration__c(Name='RingCentral Office 1 Line', SLA_Process__c=objSlaProcess.Id, RC_Brand__c='RingCentral', Type__c='Web Support', Number_of_DLs__c='0-1', Service_Name__c='Office 1 Line', Business_Hours__c=objBusinessHours.Id)); 
			*/
			insert lstEntitlementAccount;
			
    		Schema.DescribeSObjectResult d = Schema.SObjectType.Case; 
			Map<Id,Schema.RecordTypeInfo> rtMapById = d.getRecordTypeInfosById();
			
			String recordType = '';
			for(String key : rtMapById.keySet()){
				if('Support-Case'.equalsIgnoreCase(String.valueOf(rtMapById.get(key).Name))){
					recordType = String.valueOf(key);
					break;
				}
			}	
	    	
	    	// Setting up Entitlement Case Record Type configuration custom setting records.
	    	lstEntitlementCaseReType.add(new Entitlement_Case_ReType_Configuration__c(SLAProcessId__c=objSlaProcess.Id, Name='Default', Business_Hours_Name__c='Default', Business_Hours_Id__c=objBusinessHours.Id, SLAProcessName__c='Default')); 
			lstEntitlementCaseReType.add(new Entitlement_Case_ReType_Configuration__c(SLAProcessId__c=objSlaProcess.Id, Name='Support-Case', Business_Hours_Name__c='Default', Business_Hours_Id__c=objBusinessHours.Id, SLAProcessName__c='TEST 19')); 
			lstEntitlementCaseReType.add(new Entitlement_Case_ReType_Configuration__c(SLAProcessId__c=lstSlaProcess[1].Id, Name='Support - T1', Business_Hours_Name__c='Default', Business_Hours_Id__c=lstBusinessHours[1].Id, SLAProcessName__c='TEST 19'));
			insert lstEntitlementCaseReType;
	    	
	    	List<Account> accountList = new List<Account> ();
	    	List<Account> newAccountList = new List<Account> ();
	    	List<Entitlement> entitlementList = new List<Entitlement> ();
	    	for(Integer ii = 0;ii<3; ii++){
	    		accountList.add(new Account(Name='AccountName'+ii, Number_of_DL_s__c = 19+ii));
	    	}
	    	accountList = objTestUtils.createAccountRecord(accountList);
	    	
	    	//EntitlementHelper.createEntitlements(accountList, null);
	        
	    	Set<Id> accountIds = new Set<Id>();
	    	Set<String> strAccountIdset = new Set<String>();
	    	for(Account objAccount1 : accountList){
	    		accountIds.add(objAccount1.Id);
	    		strAccountIdset.add(objAccount1.Id);
	    		entitlementList.add(new Entitlement(Name='Ent'+objAccount1.name, AccountId = objAccount1.Id, SlaProcessId=objSlaProcess.Id, BusinessHoursId = objBusinessHours.id));
	    	}
	    	insert entitlementList;
	    	
	    	delete entitlementList[2];
	    	
	    	EntitlementHelper.getEntitlement(accountList[0].Id);
	    	
	    	Group queue = [SELECT Id FROM Group WHERE Name = 'General Support Queue' limit 1];
	    	
			Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
			
	        List<Case> lstCase = new List<Case>();
	        lstCase.add( new Case(Status='Work in Progress', AccountId=accountList[0].Id, EntitlementId=entitlementList[0].Id, RecordTypeId = recordType, ownerId = queue.Id));
	        lstCase.add( new Case(Status='Work in Progress', AccountId=accountList[1].Id, RecordTypeId = rtMapByName.get('Support - T1').RecordTypeId));
	        lstCase.add( new Case(Status='Work in Progress', AccountId=accountList[2].Id, RecordTypeId = rtMapByName.get('Support - T1').RecordTypeId));
	        lstCase.add( new Case(Status='Work in Progress', AccountId=accountList[0].Id, Callback_Contact_ID__c = '1111', RecordTypeId = rtMapByName.get('Support - T2').RecordTypeId));
			/*lstCase.add( new Case(Status='Closed', AccountId=accountList[0].Id, EntitlementId=entitlementList[0].Id)); 
			lstCase.add( new Case(Status='Waiting on Customer', AccountId=accountList[0].Id, EntitlementId=entitlementList[0].Id)); 
			lstCase.add( new Case(Status='Work in Progress', AccountId=accountList[0].Id, EntitlementId=entitlementList[0].Id)); 
			lstCase.add( new Case(Status='Closed', AccountId=accountList[0].Id, EntitlementId=entitlementList[0].Id)); 
			lstCase.add( new Case(Status='Waiting on Customer', AccountId=accountList[0].Id, EntitlementId=entitlementList[0].Id)); 
			lstCase.add( new Case(Status='Closed', AccountId=accountList[0].Id, EntitlementId=entitlementList[0].Id)); 
			lstCase.add( new Case(Status='Waiting on Customer', AccountId=accountList[0].Id, EntitlementId=entitlementList[0].Id)); 
			lstCase.add( new Case(Status='Work in Progress', AccountId=accountList[0].Id, EntitlementId=entitlementList[0].Id)); 
			lstCase.add( new Case(Status='Closed', AccountId=accountList[0].Id, EntitlementId=entitlementList[0].Id)); 
			lstCase.add( new Case(Status='Closed', AccountId=accountList[0].Id, EntitlementId=entitlementList[0].Id));
			*/
			TriggerHandler.BY_PASS_CASE_ON_INSERT();
			insert lstCase;
			EntitlementHelper objEntitlementHelper = new EntitlementHelper();
	        EntitlementHelper.isPortalUser();
	        EntitlementHelper.IsEntitlementsEnabled();
	        //EntitlementHelper.getAccountEntitlement(strAccountIdset);
	        /* Case update time get account IDs*/
	        EntitlementHelper.createAccountEntitlementMap(accountIds);
	        EntitlementHelper.getSLAProcess();
	        EntitlementHelper.getSLAProcessMap();
	        EntitlementHelper.getBusinessHours();
	        EntitlementHelper.getBusinessHoursMap();
	        //EntitlementHelper.isChanged(new Account(), new Account());
	        EntitlementHelper.entitleAssignmentOncase(lstCase,null);
	        EntitlementHelper.closeCaseAssignedMilestone(lstCase, new Map<Id, Case>{lstCase[0].Id => lstCase[0]});
	        EntitlementHelper.fetchEntitlementConfiguration();
	        //EntitlementHelper.createAccountEntitlement(null,null,null);
	        test.stopTest();
        }catch(Exception ex){
    		system.debug('#### Error in Test_EntitlementHelper - Line - '+ex.getLineNumber());
    		system.debug('#### Error in Test_EntitlementHelper - Message - '+ex.getMessage());
    	}
    }
}