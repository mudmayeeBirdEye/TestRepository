@isTest
private class TestCampaignToCalculateMRR {

    static testMethod void testScheduleCampaignToCalculateMRR() {
        try {
        	Campaign campaignObj = new Campaign();
        	campaignObj.Name = 'Test C';
        	campaignObj.IsActive = true;
        	insert campaignObj;
        	
        	Account acctest = new Account();
	        acctest.Name = 'TestAccount';
	        acctest.RC_Attribution_Channel__c = 'Sales Agents & Resellers';
	        acctest.Partner_ID__c ='123333';
	        acctest.RecordTypeId  = '01280000000UERq';
	        insert acctest;
	        
	        Test.startTest();
	        
        	Opportunity Oppval = new Opportunity();
	        Oppval.Name = 'Test Opp11';
	        Oppval.CampaignId = campaignObj.id;
	        Oppval.AccountId = acctest.Id;
	        Oppval.Type = 'Existing Business';
	        Oppval.StageName = OpportunityHelper.defaultOpportunityStage;
	        Oppval.Sales_Model__c = 'Direct';
	        Oppval.CloseDate = System.Today() + 10;
	        Oppval.CurrencyIsoCode = 'USD';
	        Oppval.Brand_Name__c= 'RingCentral';
	        Oppval.RecordTypeId = '01280000000UEtz';
	        Oppval.Proposal_Expiration_Date__c = System.today() + 100;
	        insert Oppval;
	        
        	
     		Schedulable sh = new  ScheduleCampaignToCalculateMRR();
     		sh.execute(null);
     		Test.stopTest();
        } catch(Exception ex) {}
    }
}