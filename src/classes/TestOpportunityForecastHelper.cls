@isTest
private class TestOpportunityForecastHelper {

    static testMethod void myUnitTest() {
       try {
    		Account acctest = new Account();
	        acctest.Name='TestAccount';
	        acctest.RC_Attribution_Channel__c = 'Sales Agents & Resellers';
	        acctest.Partner_ID__c ='123';
	        acctest.RecordTypeId  = '01280000000UERq';
	        insert acctest;
		                
	        Contact contactObj = new Contact();
	        contactObj.AccountId =  acctest.id;
	        contactObj.Email = 'virendra.singh@simplion.com';
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
	        Test.StartTest();
	        OpportunityForecastHelper.setEndDateOfMonth(Oppval.id);
	        OpportunityForecastHelper.setEndDateOfQuater(Oppval.id);
	        Test.stopTest();
    	} catch(Exception ex) {} 
    }
    
    @isTest(seealldata = true)
	static void testOppBatch() {
		try {
			Account acctest = new Account();
	        acctest.Name = 'TestAccount';
	        acctest.RC_Attribution_Channel__c = 'Sales Agents & Resellers';
	        acctest.Partner_ID__c ='123';
	        acctest.RecordTypeId  = '01280000000UERq';
	        insert acctest;
		                
	        Contact contactObj = new Contact();
	        contactObj.AccountId =  acctest.id;
	        contactObj.Email = 'fake@email.com';
	        contactObj.LastName = 'TestLast';
	        contactObj.Phone='9910106804';
	        insert contactObj;
		                
	        Opportunity Oppval = new Opportunity();
	        Oppval.Name = 'Test Opp';
	        Oppval.AccountId = acctest.Id;
	        Oppval.Type = 'Existing Business';
	        Oppval.StageName = '3. ActivePipe';
	        Oppval.Sales_Model__c = 'Direct';
	        Oppval.CloseDate = System.Today() - 10;
	        Oppval.CurrencyIsoCode = 'USD';
	        Oppval.Brand_Name__c= 'RingCentral';
	        Oppval.RecordTypeId = '01280000000UEtz';
	        Oppval.Proposal_Expiration_Date__c = System.today() + 100;
	        insert Oppval;
	        
	        Test.StartTest();
		   	OpportunityForecastBatch oppBatchObj = new OpportunityForecastBatch();
	   		oppBatchObj.strQuery =	'SELECT Id, CloseDate FROM Opportunity ' +
									'WHERE StageName NOT IN (\'0. Downgraded\',\'8. Closed Won\') '  +
								 	'and CloseDate < Today limit 1';		 
			ID batchprocessid = Database.executeBatch(oppBatchObj);
	   		Test.StopTest();
		} catch(Exception ex) {}
	}
	
	 static testMethod void myUnitTest1() {
 		Test.startTest();
      	String jobId = System.schedule('OpportunityForecastScheduler Job','0 0 0 3 9 ? 2022',new OpportunityForecastScheduler()); 
   		Test.stopTest();
	 }
	 
 	@isTest(seealldata = true)
	static void testOppMethod() {
		try{
			Account accObj = new Account(name='testa');
	        insert accObj;
	        Set<Id> testSet=new  Set<Id>();
	        Map<Id,Opportunity> testMapOldOpp=new Map<Id,Opportunity>();
	        Opportunity oppObj = new Opportunity();
            oppObj.Name = 'TestaOppOwnerD';
            oppObj.AccountId = accObj.Id;
            oppObj.Type = 'New Business';
            oppObj.CloseDate = Date.today();
            oppObj.StageName = '3. Qualified';
            oppObj.OwnerId = '005800000037xj5';
            oppObj.Owner_Manager_Email__c = 'jesse2@ringcentral.com';
            testMapOldOpp.put(oppObj.Id,oppObj);
            insert testMapOldOpp.values();
            Test.startTest();
	        OpportunityMethods om = new OpportunityMethods();
	        om.sendActivePipeLimitEmail(oppObj, 2, 3); 
	        om.updateParentAccount(testMapOldOpp, null);  
	        OpportunityMethods.getAmountByLeadSource();
	        Test.stopTest();     
     	} catch(Exception e){}  
	}
	
	
}