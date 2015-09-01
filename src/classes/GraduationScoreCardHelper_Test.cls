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
private class GraduationScoreCardHelper_Test {

    static testMethod void GraduationScoreCardHelperTest() {
        
        GraduationScoreCardHelper objGraduationScoreCardHelper = new GraduationScoreCardHelper();
        List<Account> listAccount =  getAccountTestRecords();
        insert listAccount;
        List<Implementation__c> listImpl = getImplementationTestRecords(listAccount[1].Id);
    	insert listImpl;
    	
    	System.assertNotEquals(null,GraduationScoreCardHelper.getImplementationCompletionDetails(listImpl[0], null, GraduationScoreCardHelper.STR_INSERT));
    	System.assertNotEquals(null,GraduationScoreCardHelper.getImplementationCompletionDetails(listImpl[1], listImpl[0], GraduationScoreCardHelper.STR_UPDATE));
    	System.assertNotEquals(null,GraduationScoreCardHelper.getImplementationCompletionDetails(listImpl[0], listImpl[1], GraduationScoreCardHelper.STR_UPDATE));
    	
    	GraduationScoreCardHelper.updateAccountOnImplementationDeletion(listImpl);
    	List<Account_Metric__c> listAccountMetring = getAccountMetricTestRecords(listAccount[0].Id, listAccount[1].Id);
    	insert listAccountMetring;
    	GraduationScoreCardHelper.adopGradCompRateOnAccountMetric(listAccountMetring, null);
    	
    	Map<Id, Account_Metric__c> mapMetric = new Map<Id, Account_Metric__c>();
        mapMetric.put(listAccountMetring[0].Id,listAccountMetring[0]);
        mapMetric.put(listAccountMetring[1].Id,listAccountMetring[1]);
    	
    	GraduationScoreCardHelper.adopGradCompRateOnAccountMetric(listAccountMetring, mapMetric);
    	
    	mapMetric.put(listAccountMetring[1].Id,listAccountMetring[0]);
        mapMetric.put(listAccountMetring[0].Id,listAccountMetring[1]);
    	
    	GraduationScoreCardHelper.adopGradCompRateOnAccountMetric(listAccountMetring, mapMetric);
    	GraduationScoreCardHelper.calculateCompletionOnAccountMetricDeletion(listAccountMetring);
    	
    	List<Case> listCAse = getCaseList(listAccount[0].Id);
    	insert listCase;
    	Map<Id, Case> mapCase = new Map<Id, Case>();
    	mapCase.put(listCase[0].Id, listCase[0]);
    	GraduationScoreCardHelper.calculateGraduationCompletionRateOverCase(listCAse,mapCase);
    	listAccountMetring[0].Metric_23_value__c = null;
    	listAccountMetring[1].Metric_23_value__c = 12;
    	GraduationScoreCardHelper.checkValuesAdoption(listAccountMetring[0],listAccountMetring[1]);
    	
    	listAccountMetring[0].Metric_23_value__c = 2;
    	listAccountMetring[1].Metric_23_value__c = 12;
    	GraduationScoreCardHelper.checkValuesAdoption(listAccountMetring[0],listAccountMetring[1]);
    	
    	listAccountMetring[0].Metric_18_value__c = null;
    	listAccountMetring[1].Metric_18_value__c = 12;
    	GraduationScoreCardHelper.checkValuesAdoption(listAccountMetring[0],listAccountMetring[1]);
    	
    	listAccountMetring[0].Metric_18_value__c = 2;
    	listAccountMetring[1].Metric_18_value__c = 12;
    	GraduationScoreCardHelper.checkValuesAdoption(listAccountMetring[0],listAccountMetring[1]);
    	
    	listAccountMetring[0].Metric_27_value__c = null;
    	listAccountMetring[1].Metric_27_value__c = 12;
    	GraduationScoreCardHelper.checkValuesAdoption(listAccountMetring[0],listAccountMetring[1]);
    	
    	listAccountMetring[0].Metric_27_value__c = 2;
    	listAccountMetring[1].Metric_27_value__c = 12;
    	GraduationScoreCardHelper.checkValuesAdoption(listAccountMetring[0],listAccountMetring[1]);
    	
    	listAccountMetring[0].Metric_11_value__c = null;
    	listAccountMetring[1].Metric_11_value__c = 12;
    	GraduationScoreCardHelper.checkValuesAdoption(listAccountMetring[0],listAccountMetring[1]);
    	
    	listAccountMetring[0].Metric_11_value__c = 2;
    	listAccountMetring[1].Metric_11_value__c = 12;
    	GraduationScoreCardHelper.checkValuesAdoption(listAccountMetring[0],listAccountMetring[1]);
    	
    	listAccountMetring[0].Metric_18_value__c = 12;
    	listAccountMetring[1].Metric_18_value__c = null;
    	GraduationScoreCardHelper.checkValuesAdoption(listAccountMetring[0],listAccountMetring[1]);
    	
    	listAccountMetring[0].Metric_27_value__c = 12;
    	listAccountMetring[1].Metric_27_value__c = NULL;
    	GraduationScoreCardHelper.checkValuesAdoption(listAccountMetring[0],listAccountMetring[1]);
    	
    	listAccountMetring[0].Metric_11_value__c = 12;
    	listAccountMetring[1].Metric_11_value__c = null;
    	GraduationScoreCardHelper.checkValuesAdoption(listAccountMetring[0],listAccountMetring[1]);
    	
    	listAccountMetring[0].Metric_3_value__c=null;
    	listAccountMetring[1].Metric_3_value__c=12;
    	GraduationScoreCardHelper.checkValuesGraduation(listAccountMetring[0],listAccountMetring[1]);
    	
    	listAccountMetring[0].Metric_3_value__c=2;
    	listAccountMetring[1].Metric_3_value__c=12;
    	GraduationScoreCardHelper.checkValuesGraduation(listAccountMetring[0],listAccountMetring[1]);
    	
    	listAccountMetring[0].Metric_28_value__c=null;
    	listAccountMetring[1].Metric_28_value__c=12;
    	GraduationScoreCardHelper.checkValuesGraduation(listAccountMetring[0],listAccountMetring[1]);
    	
    	listAccountMetring[0].Metric_28_value__c=2;
    	listAccountMetring[1].Metric_28_value__c=12;
    	GraduationScoreCardHelper.checkValuesGraduation(listAccountMetring[0],listAccountMetring[1]);
    	
    	listImpl[0].Account__c = null;
    	listImpl[1].Account__c = null;
    	GraduationScoreCardHelper.updateAccountOnImplementationDeletion(listImpl);
    	
    	listAccount[0].Graduation_Kit__c = true;
    	GraduationScoreCardHelper.getGraduationCompRateAccount(listAccount[0]);
    	
    	listAccount[0].Current_Owner_Email__c = 'abc@cc.com';
    	GraduationScoreCardHelper.getGraduationCompRateAccount(listAccount[0]);
    	
    	listAccount[0].Current_Owner_Email__c = 'sfdchelp@ringcentral.com';
    	listAccount[0].Number_of_DL_s__c=5;
    	GraduationScoreCardHelper.getGraduationCompRateAccount(listAccount[0]);
    }
    
     public static List<Account> getAccountTestRecords(){ 
    	
    	List<Account> listAccount = new List<Account>();
    	Account objAccount = new Account(Name='Test1', Current_Owner_Email__c='abc@test.com',Number_of_DL_s__c=260);
    	
    	listAccount.add(objAccount);
    	
    	Account objAccount1 = new Account(Name='Test2', Current_Owner_Email__c='abc@test.com',Number_of_DL_s__c=20);
    	listAccount.add(objAccount1);
    	
    	//insert listAccount;
    	
    	return listAccount;
    }
    
    public static List<Implementation__c> getImplementationTestRecords(String strAccountId){
    	
    	List<Implementation__c> listImpl = new List<Implementation__c>();
    	Implementation__c objImpl = new Implementation__c();
    	objImpl.Account__c = strAccountId;
    	objImpl.Account_Review__c =  'Overview;Messages;Activity Log;Contacts;Billing;Webinars;Support Portal;Survey';
        objImpl.Company_Numbers_and_Info__c =  'Company Caller ID;Company Address;Add Number;User My Existing Number (Porting)';
        objImpl.Users__c = 'Unassigned Ext;Add Users;Permissions;User Info;Phones & Numbers;Screening, Greeting;& Hold Music;Call Handling and Forwarding;Messages & Notifications;Outbound Caller ID;Outbound Fax Settings';
        objImpl.Phones_Devices__c =  'Phone Serial Number;Phone Nickname;E911';
        objImpl.Groups__c = 'Add Group;Call Queues;Paging;Shared Lines';
        objImpl.Tools__c =  'Mobile App;Softphone;RC Meetings';
    	listImpl.add(objImpl);
    	
    	Implementation__c objImpl1 = new Implementation__c();
    	objImpl1.Account__c = strAccountId;
    	objImpl1.Account_Review__c =  'Overview;Messages;Activity Log;Contacts;Billing;Webinars;Support Portal';
        objImpl1.Company_Numbers_and_Info__c =  'Company Caller ID;Company Address;Add Number';
        objImpl1.Users__c = 'Unassigned Ext;Add Users;Permissions;User Info;Screening, Greeting;& Hold Music;Call Handling and Forwarding;Messages & Notifications;Outbound Caller ID;Outbound Fax Settings';
        objImpl1.Phones_Devices__c =  'Phone Serial Number;Phone Nickname';
        objImpl1.Groups__c = 'Add Group;Call Queues;Paging;';
        objImpl1.Tools__c =  'Mobile App;Softphone;';
    	listImpl.add(objImpl1);
    	
    	//insert listImpl;
    	
    	return listImpl;
    }
    
     public static List<Account_Metric__c> getAccountMetricTestRecords(String strAccountId1, String strAccount2){
    	
    	List<Account_Metric__c> listAccount = new List<Account_Metric__c>();
    	Account_Metric__c objAccount = new Account_Metric__c();
    	objAccount.Account_ID__c = strAccountId1;
    	objAccount.Metric_3_value__c = 12;
    	objAccount.Metric_11_value__c = 1;
    	objAccount.Metric_18_value__c = 2;
    	objAccount.Metric_23_value__c = 2;
    	objAccount.Metric_27_value__c = 1;
    	objAccount.Metric_28_value__c = .5;
    	listAccount.add(objAccount);
    	
    	Account_Metric__c objAccount1 = new Account_Metric__c();
    	objAccount1.Account_ID__c = strAccount2;
    	objAccount1.Metric_3_value__c = 11;
    	objAccount1.Metric_11_value__c = 11;
    	objAccount1.Metric_18_value__c = 22;
    	objAccount1.Metric_23_value__c = 22;
    	objAccount1.Metric_27_value__c = 12;
    	objAccount1.Metric_28_value__c = 1.5;
    	listAccount.add(objAccount1);
    	
    	//insert listAccount;
    	
    	return listAccount;
    }
    
    public static List<Case> getCaseList(String strAccountId){
    	String recTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('Support - T3').RecordTypeId ;
    	List<Case> listCase = new List<Case>();
    	Case objCase = new Case(AccountId=strAccountId, RecordTypeId = recTypeId);
    	listCase.add(objCase);
    	return listCase;
    }
}