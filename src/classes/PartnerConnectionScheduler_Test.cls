/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 */
@isTest
private class PartnerConnectionScheduler_Test {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        Test.StartTest();
        Test_Utils tutilsObj = new Test_Utils();
        tutilsObj.initialiseTriggerBypass();
        List<Case> lstDemoCases = new List<Case>();
        lstDemoCases.add(new Case(Type = 'VoIP Device Return', Status = 'Closed', RecordTypeId = '01280000000UF6K'));
        lstDemoCases.add(new Case(Type = 'VoIP Device Return', Status = 'Closed', RecordTypeId = '01280000000UF6K'));
        lstDemoCases.add(new Case(Type = 'VoIP Device Return', Status = 'Closed', RecordTypeId = '01280000000UF6K'));
        insert lstDemoCases;
        
        List<Device__c> lstDemoDevice = new List<Device__c>();
        lstDemoDevice.add(new Device__c(Case__c = lstDemoCases.get(0).Id));
        lstDemoDevice.add(new Device__c(Case__c = lstDemoCases.get(1).Id));
        lstDemoDevice.add(new Device__c(Case__c = lstDemoCases.get(2).Id));
        insert lstDemoDevice;
        
        tutilsObj.deInitialiseTriggerBypass();
        PartnerConnectionScheduler obj= new PartnerConnectionScheduler();
     	obj.execute(null);
        Test.StopTest();
    }
}