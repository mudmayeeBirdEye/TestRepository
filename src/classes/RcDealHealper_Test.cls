@isTest
private class RcDealHealper_Test {
    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        String email , phone;
        RcDealHealper helperObj = new RcDealHealper();
        RcDealHealper.searchResultClass searchResult;
        
        List<Segment_Data__c> lstSegment = new List<Segment_Data__c>();
        lstSegment.add(new Segment_Data__c(Attribute_1__c = 'ringcentral.com', Type__c = 'Franchise'));
        insert lstSegment;
        
        List<Lead> lstLeads = new List<Lead>();
        lstLeads.add(new Lead(LastName = 'LName', Email = 'lead1@ringcentral.com', Company= 'Company1', Phone = '1234567890'));
        lstLeads.add(new Lead(LastName = 'LName', Email = 'lead2@simplion.com', Company= 'Company2', Phone = '1234567891'));
        insert lstLeads;
        
        List<Contact> lstContacts = new List<Contact>();
        lstContacts.add(new Contact(LastName = 'LName', Email = 'Contact1@ringcentral.com', Phone = '1234567892'));
        lstContacts.add(new Contact(LastName = 'LName', Email = 'Contact2@simplion.com', Phone = '1234567893'));
        insert lstContacts;
        
        email = 'lead@ringcentral.com';
        phone = '091000010101';
        
  		searchResult = helperObj.LeadContactSearch(email, phone);
  		
  		email = 'lead@simplion.com';
        phone = '191000010101';
        searchResult = helperObj.LeadContactSearch(email, phone);
        
        map<String,String> prOwnerMap = new map<String,String>();
        prOwnerMap.put(lstLeads.get(0).Email + lstLeads.get(0).Phone, lstLeads.get(0).OwnerId);
        prOwnerMap.put(lstLeads.get(1).Email + lstLeads.get(1).Phone, lstLeads.get(1).OwnerId);
        //RcDealHealper.LeadContactSearch(lstLeads, prOwnerMap);
    }
}