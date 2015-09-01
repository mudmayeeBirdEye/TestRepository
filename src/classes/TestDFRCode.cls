@isTest
private class TestDFRCode {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT();
        TriggerHandler.BY_PASS_LEAD_UPDATE_ON_INSERT();
        TriggerHandler.BY_PASS_CONTACT_ON_INSERT();
        
        test.StartTest();
        Lead leadObj = new Lead(lastName = 'Test LName', Company = 'Test Company', Email = 'testlead@testlead.com', Phone = '9013038181', Status = 'X. Suspect');
        insert leadObj;
        
        leadObj.Status = '2. Contacted';
        leadObj.BMID__c = '5MISTAKES';
        
        update leadObj;
        
        //Convert Lead
        
        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setLeadId(leadObj.id);
        
        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted = true LIMIT 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);
        
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        System.assert(lcr.isSuccess());
        
        TriggerHandler.RESET_VARIABLES();
        
        Contact contactObj = new Contact();
        contactObj.Id = lcr.getContactId();
        contactObj.BMID__c = '20PLUSFT2012';
        update contactObj;
        test.stopTest();
    }
}