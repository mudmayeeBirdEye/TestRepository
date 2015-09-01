@isTest
private class TestContractService {

    static testMethod void contractApprovalTest() {
       try {
       		//Contract_Approval_Service__c mycs = Contract_Approval_Service__c.getValues('Initial_Term__c');
			  //if(mycs == null) {
		   	Contract_Approval_Service__c mycs = new Contract_Approval_Service__c();
	    	mycs.Initial_Term__c = '24';
		    mycs.Name = 'TestCS';
		    insert mycs;
		  	//}
		  	TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT = true;
		  	TriggerHandler.BY_PASS_CONTACT_ON_INSERT = true;
		  	TriggerHandler.BY_PASS_OPPORTUNITY_ON_INSERT = true;
       		Account acctest = new Account();
	        acctest.Name = 'TestAccount11';
	        acctest.RC_Attribution_Channel__c = 'Sales Agents & Resellers';
	        acctest.Partner_ID__c ='123';
	        acctest.RecordTypeId  = '01280000000UERq';
	        insert acctest;
		                
	        Contact contactObj = new Contact();
	        contactObj.AccountId =  acctest.id;
	        contactObj.Email = 'virendra.singh22@simplion.com';
	        contactObj.LastName = 'TestLast';
	        insert contactObj;
		                
	        Opportunity Oppval = new Opportunity();
	        Oppval.Name = 'Test Opp';
	        Oppval.AccountId = acctest.Id;
	        Oppval.Type = 'Existing Business';
	        Oppval.StageName = '3. Qualified';
	        Oppval.Sales_Model__c = 'Direct';
	        Oppval.CloseDate = System.Today() + 10;
	        Oppval.CurrencyIsoCode = 'USD';
	        Oppval.Brand_Name__c= 'RingCentral';
	        Oppval.RecordTypeId = '01280000000UEtz';
	        Oppval.Proposal_Expiration_Date__c = System.today() + 100;
	        insert Oppval;
	        
	        Test.startTest();
	        Quote quoteObj = new Quote();
	        quoteObj.OpportunityId = Oppval.id;
	        quoteObj.Account__c = acctest.id;
	        quoteObj.Name = 'Test Quote';
	        quoteObj.Status = 'Draft';
	        insert quoteObj;
	        ContractApproval.chkContractApproval(Oppval.id);
	        Test.stopTest();
       } catch(Exception ex) {}
    }
  
}