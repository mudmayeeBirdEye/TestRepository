@isTest
private class DG_DFR_Class_TEST {

    static testMethod void CreateLeadDFR_Test() {
    	TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT();
		TriggerHandler.BY_PASS_ACCOUNT_ON_UPDATE();
		TriggerHandler.BY_PASS_CONTACT_ON_INSERT();
		TriggerHandler.BY_PASS_CONTACT_ON_UPDATE();
		TriggerHandler.BY_PASS_OPPORTUNITY_ON_INSERT();
		TriggerHandler.BY_PASS_OPPORTUNITY_ON_UPDATE();
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
	    
	    //Created as Prospect	
    	Lead l2 = new Lead(
	    	Status = 'X. Open',
	        LeadSource = 'Other', 
	    	State ='CA', 
	    	Phone = '+1.213.111.1111', 
	    	LastName = 'TEST', 
	    	FirstName = 'TEST', 
	    	Company = 'xxAugusto Bisdaxx',
	    	Email = 'aaabisda@aaabisda.net', 
	    	Country = 'USA');
	    
	    listLead.add(l2);
	    
	    //Created as MQL
	    Lead l3 = new Lead(
	    	Status = '1. New',
	        LeadSource = 'Other', 
	    	State ='CA', 
	    	Phone = '+1.213.111.1111', 
	    	LastName = 'TEST', 
	    	FirstName = 'TEST', 
	    	Company = 'xxAugusto Bisdaxx',
	    	Email = 'aaabisda@aaabisda.net', 
	    	Country = 'USA');
	    
	    listLead.add(l3);
	    
	    //Created as Re-New
	    Lead l4 = new Lead(
	    	Status = '.5 Re-New',
	        LeadSource = 'Other', 
	    	State ='CA', 
	    	Phone = '+1.213.111.1111', 
	    	LastName = 'TEST',  
	    	FirstName = 'TEST', 
	    	Company = 'xxAugusto Bisdaxx',
	    	Email = 'aaabisda@aaabisda.net', 
	    	Country = 'USA');
	    
	    listLead.add(l4);
	    
	    //Created as SAL
	   	Lead l5 = new Lead(
	    	Status = '1.5 Call Out',
	        LeadSource = 'Other', 
	    	State ='CA', 
	    	Phone = '+1.213.111.1111', 
	    	LastName = 'TEST',  
	    	FirstName = 'TEST', 
	    	Company = 'xxAugusto Bisdaxx',
	    	Email = 'aaabisda@aaabisda.net', 
	    	Country = 'USA');
	    
	    listLead.add(l5);
	    
	    Lead l6 = new Lead(
	    	Status = 'X. Suspect',
	        LeadSource = 'Other', 
	    	State ='CA', 
	    	Phone = '+1.213.111.1111', 
	    	LastName = 'TEST',  
	    	FirstName = 'TEST', 
	    	Company = 'xxAugusto Bisdaxx',
	    	Email = 'aaabisda@aaabisda.net', 
	    	Country = 'USA');
	    
	    listLead.add(l6);
	    
	   	Lead l7 = new Lead(
	    	Status = 'X. Suspect',
	        LeadSource = 'Other', 
	    	State ='CA', 
	    	Phone = '+1.213.111.1111', 
	    	LastName = 'TEST',  
	    	FirstName = 'TEST', 
	    	Company = 'xxAugusto Bisdaxx',
	    	Email = 'aaabisda@aaabisda.net', 
	    	Country = 'USA');
	    
	    listLead.add(l7);
	    
	    try {
	    	insert listLead;
	    } catch(Exception e) {}
	    //test.startTest();
	   
	    //MQL to Downgraded
	    l1.Status = '0. Downgraded';	    
	    l1.Downgrade_Reason__c = 'No Show';  
	    
	    //Prospect to MQL
	    l2.Status = '1. New';
	    
	    //MQL to SAL
	    l3.Status = '1.5 Call Out';
	    
	    //Re-New to Downgraded;
	    l4.status = '0. Downgraded';
	    l4.Downgrade_Reason__c = 'No Show'; 
	    
	   //SAL to Downgraded;
	    l5.status = '0. Downgraded';
	    l5.Downgrade_Reason__c = 'No Show'; 

	    try {	    
	    	update listLead;
	    } catch(Exception e) {}
	    
	    Test.stopTest();
	    
	    //Convert Lead from Suspect  		
	    Database.LeadConvert lc = new database.LeadConvert();
		lc.setLeadId(l7.Id);		
		lc.setConvertedStatus('2. Contacted');	
		Database.LeadConvertResult result;
		try {	
			result = Database.convertLead(lc);
		} catch(Exception e) {}	
		
    }
    
    
   static testMethod void CreateLeadDFR_Test2() {
   		TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT();
		TriggerHandler.BY_PASS_ACCOUNT_ON_UPDATE();
		TriggerHandler.BY_PASS_CONTACT_ON_INSERT();
		TriggerHandler.BY_PASS_CONTACT_ON_UPDATE();
		TriggerHandler.BY_PASS_OPPORTUNITY_ON_INSERT();
		TriggerHandler.BY_PASS_OPPORTUNITY_ON_UPDATE();
    	Test.startTest();
    	
    	List<Lead> listLead = new List<Lead>();
	    
	    Lead l7 = new Lead(
	    	Status = 'X. Suspect',
	        LeadSource = 'Other', 
	    	State ='CA', 
	    	Phone = '+1.213.111.1111', 
	    	LastName = 'TEST',  
	    	FirstName = 'TEST', 
	    	Company = 'xxAugusto Bisdaxx',
	    	Email = 'aaabisda@aaabisda.net', 
	    	Country = 'USA');
	    	
	    listLead.add(l7);
	    	
	   	Lead l8 = new Lead(
	    	Status = 'X. Suspect',
	        LeadSource = 'Other', 
	    	State ='CA', 
	    	Phone = '+1.213.111.1111', 
	    	LastName = 'TEST',  
	    	FirstName = 'TEST', 
	    	Company = 'xxAugusto Bisdaxx',
	    	Email = 'aaabisda@aaabisda.net', 
	    	Country = 'USA');
	    
	    listLead.add(l8);
	    
	    Lead l9 = new Lead(
	    	Status = 'X. Suspect',
	        LeadSource = 'Other', 
	    	State ='CA', 
	    	Phone = '+1.213.111.1111', 
	    	LastName = 'TEST',  
	    	FirstName = 'TEST', 
	    	Company = 'xxAugusto Bisdaxx',
	    	Email = 'aaabisda@aaabisda.net', 
	    	Country = 'USA');
	    
	    listLead.add(l9);
		    
	    Lead l10 = new Lead(
	    	Status = '1.5 Call Out',
	        LeadSource = 'Other', 
	    	State ='CA', 
	    	Phone = '+1.213.111.1111', 
	    	LastName = 'TEST',  
	    	FirstName = 'TEST', 
	    	Company = 'xxAugusto Bisdaxx',
	    	Email = 'aaabisda@aaabisda.net', 
	    	Country = 'USA');
	    
	    listLead.add(l10);
	    
	    //Created as Prospect	
    	Lead l11 = new Lead(
	    	Status = 'X. Open',
	        LeadSource = 'Other', 
	    	State ='CA', 
	    	Phone = '+1.213.111.1111', 
	    	LastName = 'TEST', 
	    	FirstName = 'TEST', 
	    	Company = 'xxAugusto Bisdaxx',
	    	Email = 'aaabisda@aaabisda.net', 
	    	Country = 'USA');
	    
	    listLead.add(l11);
	    
	    //Created as Prospect	
    	Lead l12 = new Lead(
	    	Status = 'X. Open',
	        LeadSource = 'Other', 
	    	State ='CA', 
	    	Phone = '+1.213.111.1111', 
	    	LastName = 'TEST', 
	    	FirstName = 'TEST', 
	    	Company = 'xxAugusto Bisdaxx',
	    	Email = 'aaabisda@aaabisda.net', 
	    	Country = 'USA');
	    
	    listLead.add(l12);
	    
	   	//Created as Prospect	
    	Lead l13 = new Lead(
	    	Status = 'X. Open',
	        LeadSource = 'Other', 
	    	State ='CA', 
	    	Phone = '+1.213.111.1111', 
	    	LastName = 'TEST', 
	    	FirstName = 'TEST', 
	    	Company = 'xxAugusto Bisdaxx',
	    	Email = 'aaabisda@aaabisda.net', 
	    	Country = 'USA');
	    
	    listLead.add(l13);
	    
	    Lead l14 = new Lead(
	    	Status = 'X. Open',
	        LeadSource = 'Other', 
	    	State ='CA', 
	    	Phone = '+1.213.111.1111', 
	    	LastName = 'TEST', 
	    	FirstName = 'TEST', 
	    	Company = 'xxAugusto Bisdaxx',
	    	Email = 'aaabisda@aaabisda.net', 
	    	Country = 'USA');
	    
	    listLead.add(l14);
	    
	   	Lead l15 = new Lead(
	    	Status = 'X. Open',
	        LeadSource = 'Other', 
	    	State ='CA', 
	    	Phone = '+1.213.111.1111', 
	    	LastName = 'TEST', 
	    	FirstName = 'TEST', 
	    	Company = 'xxAugusto Bisdaxx',
	    	Email = 'aaabisda@aaabisda.net', 
	    	Country = 'USA');
	    
	    listLead.add(l15);
	    
	    try {
	    	insert listLead;
	    } catch(Exception e) {}
	   
	    //Suspect to MQL
	    l7.Status = '1. New';
	    
	    //Suspect to Re-New
	    l8.Status = '.5 Re-New';
	    
	    //Suspect to SAL
	    l9.Status = '1.5 Call Out';
	    
	   	//Prospect to Re-New
	    l11.Status = '.5 Re-New';
	    
	   	//Prospect to SAL
	    l12.Status = '1.5 Call Out';
	    
	   	//Prospect to Downgraded
	    l13.Status = '0. Downgraded';
	    l13.Downgrade_Reason__c = 'No Show'; 
	    
	    try {	    
	    	update listLead;
	    } catch(Exception e) {}
	    
	    Test.stopTest();
	    
	    //Convert Lead from Prospect    		
	    Database.LeadConvert lc = new database.LeadConvert();
		lc.setLeadId(l15.Id);		
		lc.setConvertedStatus('2. Contacted');	
		try {	
			Database.LeadConvertResult result = Database.convertLead(lc);
		} catch(Exception e) {}
		
    }
		
    static testMethod void DFRConvertLeadFromSuspect() {
    	
    	TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT();
		TriggerHandler.BY_PASS_ACCOUNT_ON_UPDATE();
		TriggerHandler.BY_PASS_CONTACT_ON_INSERT();
		TriggerHandler.BY_PASS_CONTACT_ON_UPDATE();
		TriggerHandler.BY_PASS_OPPORTUNITY_ON_INSERT();
		TriggerHandler.BY_PASS_OPPORTUNITY_ON_UPDATE();
    	
    	Test.startTest();
    	    	
		Lead l1 = new Lead(
    	Status = 'X. Suspect',
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
    	
	    Test.stopTest();
	    
	    //Convert Lead from Suspect
    	Database.LeadConvert lc = new database.LeadConvert();
		lc.setLeadId(l1.Id);		
		lc.setConvertedStatus('2. Contacted');		
		try {
			Database.LeadConvertResult result = Database.convertLead(lc);
		} catch(Exception e) {}
		TriggerHandler.RESET_VARIABLES();
    }
    
    static testMethod void Opportunity_EOL_Test() {
    	TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT();
		TriggerHandler.BY_PASS_ACCOUNT_ON_UPDATE();
		TriggerHandler.BY_PASS_CONTACT_ON_INSERT();
		TriggerHandler.BY_PASS_CONTACT_ON_UPDATE();
		TriggerHandler.BY_PASS_OPPORTUNITY_ON_INSERT();
		TriggerHandler.BY_PASS_OPPORTUNITY_ON_UPDATE();
    	Test.startTest();
    			
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
	        
    	try {	    
	    	insert l1;
	    } catch(Exception e) {}
	    
	    
	    //Convert Lead from SAL    		
	    Database.LeadConvert lc = new database.LeadConvert();
		lc.setLeadId(l1.Id);		
		lc.setConvertedStatus('2. Contacted');	
		Database.LeadConvertResult result;
		
		try {	
			result = Database.convertLead(lc);
		} catch(Exception e) {}		
		
		Test.stopTest();
		
		map<Id, Opportunity> mapOppUpdate = new map<Id, Opportunity>();
		mapOppUpdate.put(result.getOpportunityId(), new Opportunity(Id=result.getOpportunityId(),StageName='7. Closed Won'));
		
		try {
			update mapOppUpdate.values();
		} catch(Exception e) {}
		TriggerHandler.RESET_VARIABLES();
		
    }
    
    static testMethod void DFRAddRemovePrimaryOpportunityContact_Test() {
   		TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT();
		TriggerHandler.BY_PASS_ACCOUNT_ON_UPDATE();
		TriggerHandler.BY_PASS_CONTACT_ON_INSERT();
		TriggerHandler.BY_PASS_CONTACT_ON_UPDATE();
		TriggerHandler.BY_PASS_OPPORTUNITY_ON_INSERT();
		TriggerHandler.BY_PASS_OPPORTUNITY_ON_UPDATE();
    	Test.startTest();
    	
		Lead l1 = new Lead(
    	Status = 'X. Open',
        LeadSource = 'Other', 
    	State ='CA', 
    	Phone = '+1.213.111.1111', 
    	LastName = 'TEST', 
    	FirstName = 'TEST', 
    	Company = 'xxAugusto Bisdaxx',
    	Email = 'aaabisda@aaabisda.net', 
    	Country = 'USA');
    	
    	insert l1;
	    
	    //Convert lead from Prospect
    	Database.LeadConvert lc = new database.LeadConvert();
		lc.setLeadId(l1.Id);		
		lc.setConvertedStatus('2. Contacted');		
		
		Database.LeadConvertResult result;
		
		try {	
			result = Database.convertLead(lc);
		} catch(Exception e) {}
		
		ID OppId = result.getOpportunityId();
		ID ConId = result.getContactId();
				
		map<ID,Opportunity> mapOpp = new map<ID,Opportunity>(); 
		
		//Remove Primary Opportunity Contact
		mapOpp.put(OppId, new Opportunity(Id=OppId, Primary_Opportunity_Contact__c=Null));	
		update 	mapOpp.values();
		
		Test.stopTest();
		
		Demand_Funnel__c d = [Select d.id From Demand_Funnel__c d 
 		where d.Contact__c = :ConId limit 1];
 		
 		try {	
			delete d;
		} catch(Exception e) {}
		
		//Add Primary Opportunity Contact
		mapOpp.put(OppId, new Opportunity(Id=OppId, Primary_Opportunity_Contact__c=ConId));	
		update 	mapOpp.values();
		TriggerHandler.RESET_VARIABLES();
    }
    static testMethod void DFR_ChangeLeadOwner_Test() {
    	TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT();
		TriggerHandler.BY_PASS_ACCOUNT_ON_UPDATE();
		TriggerHandler.BY_PASS_CONTACT_ON_INSERT();
		TriggerHandler.BY_PASS_CONTACT_ON_UPDATE();
		TriggerHandler.BY_PASS_OPPORTUNITY_ON_INSERT();
		TriggerHandler.BY_PASS_OPPORTUNITY_ON_UPDATE();
		
    	Test.startTest();		
		
		map<String,String> mapDFRSystemUsers = DG_DFR_Class.getDFRSystemUsers();
		
		String vUID;
		for (String UID : mapDFRSystemUsers.keySet()){
            vUID = UID;
        }
        
        List<Lead> listLead = new List<Lead>();		
		
		//Created lead created by system users
    	Lead l1 = new Lead(
	    	Status = 'X. Open',
	        LeadSource = 'Other', 
	    	State ='CA', 
	    	Phone = '+1.213.111.1111', 
	    	LastName = 'TEST', 
	    	FirstName = 'TEST', 
	    	Company = 'xxAugusto Bisdaxx',
	    	Email = 'aaabisda@aaabisda.net', 
	    	Country = 'USA',
	    	OwnerId = vUID);
	    	
	    listLead.add(l1);
	    
    	Lead l2 = new Lead(
	    	Status = '1.5 Call Out',
	        LeadSource = 'Other', 
	    	State ='CA', 
	    	Phone = '+1.213.111.1111', 
	    	LastName = 'TEST', 
	    	FirstName = 'TEST', 
	    	Company = 'xxAugusto Bisdaxx',
	    	Email = 'aaabisda@aaabisda.net', 
	    	Country = 'USA',
	    	OwnerId = vUID);
	    
	    listLead.add(l2);
	    	    
	    try {
	    	insert listLead;
	    } catch(Exception e) {}
	    
	    Test.stopTest();
	    
	    //Change Lead Owner from a System User
	    l1.OwnerId = Userinfo.getUserId();	
	    l2.OwnerId = Userinfo.getUserId();			

		try {	
			update listLead;
		} catch(Exception e) {}	
		
    }
      
    static testMethod void populateCohortData_TEST() {
    	TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT();
		TriggerHandler.BY_PASS_ACCOUNT_ON_UPDATE();
		TriggerHandler.BY_PASS_CONTACT_ON_INSERT();
		TriggerHandler.BY_PASS_CONTACT_ON_UPDATE();
		TriggerHandler.BY_PASS_OPPORTUNITY_ON_INSERT();
		TriggerHandler.BY_PASS_OPPORTUNITY_ON_UPDATE();
		
    	Test.startTest();		
		        
        List<Lead> listLead = new List<Lead>();		
		
		//Created lead created by system users
    	Lead l1 = new Lead(
	    	Status = 'X. Open',
	        LeadSource = 'Other', 
	    	State ='CA', 
	    	Phone = '+1.213.111.1111', 
	    	LastName = 'TEST', 
	    	FirstName = 'TEST', 
	    	Company = 'xxAugusto Bisdaxx',
	    	Email = 'aaabisda@aaabisda.net', 
	    	Country = 'USA');
	    	
	    listLead.add(l1);
	    
    	Lead l2 = new Lead(
	    	Status = 'X. Suspect',
	        LeadSource = 'Other', 
	    	State ='CA', 
	    	Phone = '+1.213.111.1111', 
	    	LastName = 'TEST', 
	    	FirstName = 'TEST', 
	    	Company = 'xxAugusto Bisdaxx',
	    	Email = 'aaabisda@aaabisda.net', 
	    	Country = 'USA');
	    
	    listLead.add(l2);
	    	    
	    try {
	    	insert listLead;
	    } catch(Exception e) {}
	    
	    Test.stopTest();

		try {
			l2.Status = 'X. Open';	
			update listLead;
		} catch(Exception e) {}	
		
    }
    
    static testMethod void ScheduleDowngradeContactsAndDFRs_TEST() {
    	Test.startTest();        
	   	ScheduleDowngradeContactsAndDFRs sched = new ScheduleDowngradeContactsAndDFRs();        
	   	Id job_id = System.schedule('test', '0 0 0 30 12 ? 2099', sched);        
	   	System.assertNotEquals(null, job_id);      
	   	Test.stopTest();    
    }
    
    static testMethod void DFR_ContactStatusChange_TEST(){
    	test.startTest();
    	
    	Account testAcc = new Account();		
		testAcc.Name = 'my test account';
		
		insert testAcc;
		
		Contact testContact = new Contact();		
		testContact.FirstName = 'firstname';
		testContact.LastName = 'lastname';
		testContact.Email = 'ab1@ab1.com';		
		testContact.AccountId = testAcc.Id;
		testContact.Contact_Funnel_Type__c = 'Prospect';
		
		insert testContact;
		
		testContact.Contact_Status__c = 'New';
		
		update testContact;
		
		test.stopTest();
		
		testContact.Contact_Status__c = 'Downgraded';
		
		update testContact;

    }
    
    static testMethod void DFR_OpportunityClosed_TEST(){
    	test.startTest();
    	
    	Account testAcc = new Account();		
		testAcc.Name = 'my test account';
		
		insert testAcc;
		
		Opportunity testOpp = new Opportunity();		
		testOpp.Name = 'my test opportunity';
		testOpp.StageName = '3. Qualified';
		testOpp.CloseDate = System.today();		
		testOpp.AccountId = testAcc.Id;
		
		insert testOpp;
		
		Contact testContact = new Contact();		
		testContact.FirstName = 'firstname';
		testContact.LastName = 'lastname';
		testContact.Email = 'ab1@ab1.com';		
		testContact.AccountId = testAcc.Id;
		testContact.Contact_Funnel_Type__c = 'Prospect';
		
		insert testContact;
		
		testContact.Contact_Status__c = 'New';
		
		update testContact;
		
		test.stopTest();
		
		testOpp.StageName = '0. Downgraded';
		testOpp.Downgrade_Reason_Opp__c = 'Unable to Contact';
		testOpp.Sub_Downgrade_Reason__c = 'No Response';
		
		update testOpp;
    }
    
    static testMethod void DFR_AddOpportunityToExistingDFR_TEST(){
    	test.startTest();
    	
    	Account testAcc = new Account();		
		testAcc.Name = 'my test account';
		
		insert testAcc;
				
		Contact testContact = new Contact();		
		testContact.FirstName = 'firstname';
		testContact.LastName = 'lastname';
		testContact.Email = 'ab1@ab1.com';		
		testContact.AccountId = testAcc.Id;
		testContact.Contact_Funnel_Type__c = 'Prospect';
		
		insert testContact;
		
		testContact.Contact_Status__c = 'New';
		
		update testContact;
		
		test.stopTest();
		
		Opportunity testOpp = new Opportunity();		
		testOpp.Name = 'my test opportunity';
		testOpp.StageName = '3. Qualified';
		testOpp.CloseDate = System.today();		
		testOpp.AccountId = testAcc.Id;
		
		insert testOpp;
    }
    
    static testMethod void DowngradeContactsAndDFRs_TEST(){
    	test.startTest();
    	
    	Account testAcc = new Account();		
		testAcc.Name = 'my test account';
		
		insert testAcc;
				
		Contact testContact = new Contact();		
		testContact.FirstName = 'firstname';
		testContact.LastName = 'lastname';
		testContact.Email = 'ab1@ab1.com';		
		testContact.AccountId = testAcc.Id;
		testContact.Contact_Funnel_Type__c = 'Prospect';
		
		insert testContact;
		
		testContact.Contact_Status__c = 'New';
		
		update testContact;
		
		test.stopTest();
		
		new DG_DFR_Class().DowngradeContactsAndDFRs();
    }
    
    //( ### SAL Handoff
    static testMethod void SALHandOff_OnUpdate_TEST() {
    	TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT();
		TriggerHandler.BY_PASS_ACCOUNT_ON_UPDATE();
		TriggerHandler.BY_PASS_CONTACT_ON_INSERT();
		TriggerHandler.BY_PASS_CONTACT_ON_UPDATE();
		TriggerHandler.BY_PASS_OPPORTUNITY_ON_INSERT();
		TriggerHandler.BY_PASS_OPPORTUNITY_ON_UPDATE();
		
    	Test.startTest();
    	
    	User SDRUser;
    	
    	//try{
    		SDRUser = [Select u.id, u.name, u.UserRole.Name, u.UserRoleId, u.Profile.Name, u.ProfileId
	    		From User u	where u.Profile.Name like '%SDR%' and IsActive = True LIMIT 1]; 
    	//}catch(exception e){}
    	
    	system.debug('### SDR Profile: ' + SDRUser.Profile.Name);
		
		//Created as SAL
    	Lead l1 = new Lead(
	    	Status = '1.5 Call Out',
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
	    } catch(Exception e) {}
	    
	    try{
	    	l1.OwnerId = SDRUser.Id;
	    	update l1;
	    } catch(Exception e) {}
	    
	   	try {
	   		system.debug('### Current Profile: ' + UserInfo.getProfileId());
			l1.OwnerId = UserInfo.getUserId();
	    	update l1;
	    } catch(Exception e) {}
	    
    }
    //) ### SAL Handoff
}