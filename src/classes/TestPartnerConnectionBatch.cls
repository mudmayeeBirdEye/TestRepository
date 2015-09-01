/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 */
@isTest
private class TestPartnerConnectionBatch {

    static testMethod void myUnitTest() {
        Test_Utils tutils = new Test_Utils();
        tutils.initialiseTriggerBypass();
        Account acctest = new Account();
        acctest.Name='TestAccount';
        acctest.RC_Attribution_Channel__c = 'Sales Agents & Resellers';
        acctest.Partner_ID__c ='123';
        acctest.RC_Brand__c = 'TELUS';
        acctest.RecordTypeId  = '01280000000UERq';
        insert acctest;  
        
        System.debug(acctest+'~~~~~~~~~~~~~~~~~~~~acctest');
        
        System.assertEquals('123',acctest.Partner_ID__c);
        System.assertEquals('Sales Agents & Resellers',acctest.RC_Attribution_Channel__c);
        System.debug(acctest.RC_Brand__c+'~~~~~~~~~~~~~~~~~~~~acctest.RC_Brand__c');
        System.assertEquals('TELUS',acctest.RC_Brand__c);
           
        Case case1 = new Case(recordTypeId = TelusExternalSharingHelperCls.rtMapById.get('Support - T1 (Shipping)').getRecordTypeId(),Type='VoIP Device Return',
                              Partner_BAN_ID__c = '12345',Account = acctest,status = 'Closed');
        Case case2 = new Case(recordTypeId = TelusExternalSharingHelperCls.rtMapById.get('Support - T1 (Shipping)').getRecordTypeId(),Type = 'VoIP Device Return',
                              Partner_BAN_ID__c = '1345',Account = acctest,status = 'Closed');
        Case case3 = new Case(recordTypeId = TelusExternalSharingHelperCls.rtMapById.get('Support - T1 (Shipping)').getRecordTypeId(),Type='VoIP Device Return',Account = acctest,status = 'Closed');
        Case case4 = new Case(recordTypeId = TelusExternalSharingHelperCls.rtMapById.get('Support - T1 (Shipping)').getRecordTypeId(),Type = 'VoIP Device Return',Account = acctest,status = 'Closed');
        List<Case> caseList = new List<Case>{case1,case2,case3,case4};
        
        insert caseList;
        
        Device__c dev1 = new Device__c(Instance_ID__c = '12345',Case__c = case1.Id,Returned_Date__c = System.today());
        Device__c dev2 = new Device__c(Instance_ID__c = '12345',Case__c = case2.Id);
        Device__c dev3 = new Device__c(Instance_ID__c = '12345',Case__c = case3.Id,Returned_Date__c = System.today());
        Device__c dev4 = new Device__c(Instance_ID__c = '12345',Case__c = case4.Id);
        List<Device__c> devList = new List<Device__c>{dev1,dev2,dev3,dev4};
        insert devList;
		PartnerConnectionBatch.startPartneConnectionBatch();
    }
}