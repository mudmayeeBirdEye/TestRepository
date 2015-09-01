@isTest
private class Test_OpportunityController_Milestone {
	@isTest(seeAllData = true)
	private static void OpportunityControllerTest() {
		try {
    		Campaign camptest = new Campaign();
			camptest.Name = 'TestCampaign';
			camptest.Protected_Campaign__c = true;
			insert camptest;
		        		
			Account acctest = new Account();
	        acctest.Name='TestAccount';
	        acctest.RC_Attribution_Channel__c='Sales Agents & Resellers';
	        acctest.Partner_ID__c ='123';
	        acctest.RecordTypeId  = '01280000000UERq';
	        insert acctest;
		                
	        Contact contactObj = new Contact();
	        contactObj.AccountId =  acctest.id;
	        contactObj.Email = 'test123@test.com';
	        contactObj.LastName = 'TestLast';
	        insert contactObj;
		                
	        Opportunity Oppval = new Opportunity();
	        Oppval.Name = 'Test Opp';
	        Oppval.AccountId = acctest.Id;
	        Oppval.Type = 'Existing Business';
	        Oppval.StageName = OpportunityHelper.defaultOpportunityStage;
	        Oppval.Sales_Model__c = 'Direct';
	        Oppval.CloseDate = System.Today() + 10;
	        Oppval.CurrencyIsoCode = 'USD';
	        Oppval.Brand_Name__c= 'RingCentral';
	        Oppval.RecordTypeId = '01280000000UEtu';
	        Oppval.Proposal_Expiration_Date__c = System.today() + 100;
	        insert Oppval;
	        
	        Test.startTest(); 
	        
	        OpportunityLineItem oppLineItemObj = new OpportunityLineItem();
	        oppLineItemObj.OpportunityId = Oppval.id;
	        oppLineItemObj.Quantity = 10;
	        oppLineItemObj.PricebookEntryId = [select id from PricebookEntry where IsActive = true and CurrencyIsoCode = 'USD' limit 1].id;
	        oppLineItemObj.TotalPrice = 100; 
	        insert oppLineItemObj;
	        
	        
	        
	        ApexPages.currentPage().getParameters().put('Id',Oppval.Id);
	        OpportunityController oppContObj = new OpportunityController(new ApexPages.StandardController(Oppval));
	        
	        Test.stopTest();
	        //oppContObj.attachContent();
	 		
    	} catch(Exception ex) {}	
	}
	public static testMethod void testCompleteMilestoneCase1() {
	  	try {
	  		Schema.DescribeSObjectResult result = Account.SObjectType.getDescribe();
			Map<string,Schema.RecordTypeInfo> rtMapByName = result.getRecordTypeInfosByName(); 
		 	Account acctest5 = new Account();
		    acctest5.Name = 'TestAccount1';
		 	acctest5.RecordTypeId  = rtMapByName.get('Customer Account').getRecordTypeId(); 
		 	acctest5.RC_Service_name__c = 'FAX';
		 	acctest5.RC_Brand__c = 'RingCentral';
		 	insert acctest5; 
		  	
		    Contact contObj5 = new Contact();
		    contObj5.AccountId =  acctest5.Id;
		    contObj5.Email = 'abc2@test5.com';
		    contObj5.LastName = 'Test Last2';
		    contObj5.FirstName = 'Test First2';
		  	insert contObj5;
		  	
		  	Entitlement entObj5 = new Entitlement();
		  	entObj5.AccountId = acctest5.id;
		  	entObj5.Name = 'Test Ent5';
		  	insert entObj5; 
		  	
		  	
		  	Test.startTest();
		  	
		    Contact oContact = [select id from Contact limit 1];
		    String contactId;
		    if (oContact != null)
		      contactId = oContact.Id;
		    
		    Entitlement entl = [select id from Entitlement limit 1];
		    String entlId;
		    if (entl != null)
		      entlId = entl.Id;
		    
		    List<Case> cases = new List<Case>{};
		    if (entlId != null) {
		      Case c = new Case(Subject = 'Test Case with Entitlement ', EntitlementId = entlId, ContactId = contactId);
		      cases.add(c);
		    }
		
			// Insert the Account records that cause the trigger to execute.
		    if(cases.isEmpty()==false) {
		  		insert cases;
		      	List<Id> caseIds = new List<Id>();
		      	for (Case cL : cases) {
		      		
		        	caseIds.add(cL.Id);
		      	}
		      	milestoneUtils.completeMilestone(caseIds, 'First Response', System.now());
		    }
		    Test.stopTest();	
	  	} catch(Exception ex) {}
	}
	 public static testMethod void CreateOktaUsertest() {
    	RecordType rcType = [SELECT Id, Name FROM RecordType WHERE Name='Partner Account'];
	    Account accountobj = new Account();
	    accountobj.Name = 'Test Okta';
	    accountobj.RecordTypeId = rcType.Id;
	    accountobj.Partner_ID__c = 'PARTNER001';
	    insert accountobj;
	    
	    Contact contactObj = new Contact();
	    contactObj.AccountId = accountobj.id;
	    contactObj.Email = 'Test@simplion.com';
	    contactObj.LastName = 'Test Okta Con';
	    contactObj.Phone = '1234567890';
	    insert contactObj;
		User testUser = new User(alias = 'u1', email='u1234@testorg.com',
	                      emailencodingkey='UTF-8', lastname='Testing', OKTAUserID__c='', ProfileId=[SELECT Id FROM Profile WHERE Name='RC Partner User' LIMIT 1].Id, languagelocalekey='en_US',
	                      localesidkey='en_US', country='United States',
	                      timezonesidkey='America/Los_Angeles', username='u11234@testorg.com', ContactId=contactObj.id, IsActive=true);
	                 
	   	insert testUser;
		ApexPages.StandardController controller=new ApexPages.StandardController(contactObj);   
	    CreateOktaUser objCreateOktaUser=new CreateOktaUser(controller);
	    try {
	    	objCreateOktaUser.cancel();
	    } catch(Exception e) {}
	    try {
	    	objCreateOktaUser.validateUser();
	    } catch(Exception e) {}
	    try {
	    	objCreateOktaUser.resetOktaPassword(testUser.id);
	    } catch(Exception e) {}
	    try {
	    	objCreateOktaUser.createOktaUser(testUser);
	    }catch(Exception e) {}
	    try {
		    CreateOktaUser.Profile objProfile=new CreateOktaUser.Profile();
		    CreateOktaUser.OktaUser objOktaUser=new CreateOktaUser.OktaUser();
	    }catch(Exception e) {}
	    
	    try {
	    	testUser.IsActive = false;	                 
	   		update testUser;
	    	objCreateOktaUser.validateUser();
	    }catch(Exception e) {}
	    Contact contactObj1 = new Contact();
	    contactObj1.AccountId = accountobj.id;
	    contactObj1.Email = 'TestMyAccount@simplion.com';
	    contactObj1.LastName = 'Test Okta Con2';
	    contactObj1.Phone = '1234567891';
	    insert contactObj1;
	    try {
	    	 controller=new ApexPages.StandardController(contactObj1);   
	    	 objCreateOktaUser=new CreateOktaUser(controller);
	    	 User testUserNew = new User(alias = 'u2', email='u2@testorg.com',
	                       			 	emailencodingkey='UTF-8', lastname='Testing2', ProfileId=[SELECT Id FROM Profile WHERE Name='Sales Agent' LIMIT 1].Id,
	                       			 	languagelocalekey='en_US',localesidkey='en_US', country='United States',timezonesidkey='America/Los_Angeles', 
	                       			 	username='u2@testorg.com', ContactId=contactObj1.id, IsActive=true);
	                 
	   		insert testUserNew;
	    	objCreateOktaUser.validateUser();
	    }catch(Exception e) {}
    }
    @isTest(SeeAllData=true)
    public static  void TestChatterAccessToken() {
        ChatterAccessToken chatterObj = new ChatterAccessToken();
    }
    public static testMethod void LiveAgentOfflineControllertest() {
		LiveAgentOfflineController liveAgentOfflineCtrlObj = new LiveAgentOfflineController();
		liveAgentOfflineCtrlObj.leadObj.FirstName  = 'TestLead10';
		liveAgentOfflineCtrlObj.leadObj.LastName  = 'TestLeadLast10';
		liveAgentOfflineCtrlObj.leadObj.Email  = 'TestLead10@test.com';
		liveAgentOfflineCtrlObj.leadObj.Phone  = '123456789';
		liveAgentOfflineCtrlObj.leadObj.LeadSource = 'BT WebLead';
		liveAgentOfflineCtrlObj.leadObj.Company = 'Test Company';
		liveAgentOfflineCtrlObj.selectedEmployeeRange = '250-500';
		liveAgentOfflineCtrlObj.leadObj.NumberOfEmployees__c = liveAgentOfflineCtrlObj.selectedEmployeeRange;
		liveAgentOfflineCtrlObj.leadObj.Comments__c = 'Test Comments';	
		liveAgentOfflineCtrlObj.createLead();    
	
    }
}