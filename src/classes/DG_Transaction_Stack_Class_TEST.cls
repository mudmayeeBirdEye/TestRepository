@isTest
private class DG_Transaction_Stack_Class_TEST {
	
	static{
		TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT();
		TriggerHandler.BY_PASS_ACCOUNT_ON_UPDATE();
		TriggerHandler.BY_PASS_OPPORTUNITY_ON_INSERT();
		TriggerHandler.BY_PASS_OPPORTUNITY_ON_UPDATE();
	}

    static testMethod void Log_TS_OnLeadUpdate_Test() {
        Test.startTest();
    	
    	List<Lead> listLead = new List<Lead>();		
		
		//Created as MQL
    	Lead l1 = new Lead(
	    	Status = '1. New',
	        LeadSource = 'Other', 
	    	State ='CA', 
	    	Phone = '+1.213.111.1111', 
	    	LastName = 'TEST', 
	    	FirstName = 'TEST', 
	    	Company = 'xxAugusto Bisdaxx',
	    	Email = 'aaabisda@aaabisda.net', 
	    	Country = 'USA');
	    	
	    listLead.add(l1);
	    
	    try {
    		insert listLead;
    	} catch(exception e) {}
    	
    	Test.StopTest();
    	
    	try {
    		l1.BMID__c = 'TEST BMID';
    		update listLead;
    	} catch(exception e) {}
    	
    	TriggerHandler.RESET_VARIABLES();
    	
    }
    
    static testMethod void Log_TS_OnContactUpdate() {
        Test.startTest();
    	
        Account a = new Account();
        a.Name = 'Test Aug Account 123';

    	try {
    		insert a;
    	} catch(exception e) {}                
        
        Contact c = new Contact();
        c.LastName = 'ABLast';
        c.AccountId = a.id;
        c.email='AugTest@augtest.com';
        
        try {
    		insert c;
    	} catch(exception e) {}
    	
    	try {
    		c.BMID__c = 'TEST_BMID';
    		update c;
    	} catch(exception e) {}
    	
        TriggerHandler.RESET_VARIABLES();
    }
    
    static testMethod void Update_TS_OnLeadConvert() {
        Test.startTest();
    	    	
		Lead l1 = new Lead(
    	Status = '1. New',
        LeadSource = 'Other', 
    	State ='CA', 
    	Phone = '+1.213.111.1111', 
    	LastName = 'TEST', 
    	FirstName = 'TEST', 
    	Company = 'xxAugusto Bisdaxx',
    	Email = 'aaabisda@aaabisda.net', 
    	Country = 'USA');
    	
    	try {
    		insert l1;
    	} catch(exception e) {}
    	
    	try {
    		l1.BMID__c = 'TEST BMID';
    		update l1;
    	} catch(exception e) {}
    	
	    Test.stopTest();
	    
	    //Convert Lead
    	Database.LeadConvert lc = new database.LeadConvert();
		lc.setLeadId(l1.Id);		
		lc.setConvertedStatus('2. Contacted');		
		try {
			Database.LeadConvertResult result = Database.convertLead(lc);
		} catch(Exception e) {}
		TriggerHandler.RESET_VARIABLES();
    }    
    
}