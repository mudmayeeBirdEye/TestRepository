@isTest
private class Test_OpportunityDiscoveryController {
	static void createData(){
   		  RCSF_Sync__c csObj = new RCSF_Sync__c();
          csObj.Name = 'Test 1';
          csObj.Active__c = true;
          csObj.Id__c = UserInfo.getUserId();
          csObj.Is_Primary__c = true;
          insert csObj; 
          
          Account acctest = new Account();
          acctest.Name='TestAccount';
          acctest.RC_Attribution_Channel__c = 'Sales Agents & Resellers';
          acctest.Partner_ID__c ='123';
          acctest.RecordTypeId  = '01280000000UERq';
          insert acctest;
          
          Opportunity Oppval = new Opportunity();
          Oppval.Name = 'Test Opp1';
          Oppval.AccountId = acctest.Id;
          Oppval.Type = 'Existing Business';
          Oppval.StageName = '3. Qualified';
          Oppval.Sales_Model__c = 'Direct';
          Oppval.CloseDate = System.Today() + 100;
          Oppval.CurrencyIsoCode = 'USD';
          Oppval.Brand_Name__c= 'RingCentral';
          Oppval.RecordTypeId = '01280000000UEtz';
          Oppval.Proposal_Expiration_Date__c = System.today() + 100;
          insert Oppval;
	}
    static testMethod void pageLoadWithLeadQual() {
    	  Test.startTest();
          createData();
          Test.stopTest();
          Opportunity opp = [select Id,name from Opportunity where name = 'Test Opp1'];
          OpportunityDiscoveryController obj = new OpportunityDiscoveryController(new ApexPages.StandardController(new Opportunity(Id = opp.Id)));
          obj.showEdit();
          obj.hideEdit();
          obj.save();
    }
    static testMethod void pageLoadWithoutLeadQual() {
          Test.startTest();
          createData();
          Test.stopTest();
          Lead_Qualification__c lq = new Lead_Qualification__c();
          Opportunity opp = [select Id,name from Opportunity where name = 'Test Opp1'];
          lq.Opportunity__c = opp.Id;
          insert lq;
          OpportunityDiscoveryController obj = new OpportunityDiscoveryController(new ApexPages.StandardController(new Opportunity(Id = opp.Id)));
          obj.showEdit();
          obj.hideEdit();
          obj.save();
    }
    static testMethod void pageLoadWithoutOpp() {
          Test.startTest();
          createData();
          Test.stopTest();
          Lead_Qualification__c lq = new Lead_Qualification__c();
          Opportunity opp = [select Id,name from Opportunity where name = 'Test Opp1'];
          lq.Opportunity__c = opp.Id;
          insert lq;
          OpportunityDiscoveryController obj = new OpportunityDiscoveryController(new ApexPages.StandardController(new Opportunity()));
          obj.showEdit();
          obj.hideEdit();
          
    }
}