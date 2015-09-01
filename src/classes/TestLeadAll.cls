@isTest
private class TestLeadAll {

    public static testMethod void testConvertLead() {
		try {
			Lead leadObj = new Lead();
    		leadObj.FirstName='Virendra';
            leadObj.LastName='Singh';
            leadObj.Company='Simplion';
            leadObj.Email='virendra.singh@simplion.com';
            leadObj.Phone='9910106804';
            leadObj.LeadSource = 'Inbound Call';
            leadObj.Notes__c = 'Test Notes'; 
            leadObj.Website = 'http://test.com';
            leadObj.NumberOfEmployees = 123;
         	leadObj.Industry = 'Test';
            leadObj.NumberOfEmployees__c = '2-19';
            leadObj.Number_of_Locations__c = '2-4';
    	 	leadObj.Agent_Email_Address__c = 'test@test.com';            
    	 	insert leadObj;
            
            Note noteObj = new Note();
            noteObj.ParentId = leadObj.id;
            noteObj.Body = 'test';
            noteObj.Title= 'Original note from lead';
            insert noteObj;
            
            Lead_Qualification__c leadQualObj1 = new Lead_Qualification__c();
            leadQualObj1.Lead__c = leadObj.id;
            insert leadQualObj1;
            
            Lead_Qualification__c leadQualObj2 = new Lead_Qualification__c();
            leadQualObj2.Lead__c = leadObj.id;
            insert leadQualObj2;
            
            Account acctest = new Account();
	        acctest.Name='TestAccount';
	        acctest.RC_Attribution_Channel__c = 'Sales Agents & Resellers';
	        acctest.Partner_ID__c ='123';
	        acctest.RecordTypeId  = '01280000000UERq';
	        insert acctest;
		                
	        Contact contactObj = new Contact();
	        contactObj.AccountId =  acctest.id;
	        contactObj.Email = 'virendra.singh@simplion.com';
	        contactObj.Phone = '9910106804';
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
	        Oppval.RecordTypeId = '01280000000UEtz';
	        Oppval.Proposal_Expiration_Date__c = System.today() + 100;
	        insert Oppval;
     
            Test.startTest();
            
            ApexPages.StandardController sc = new ApexPages.standardController(leadObj);
       
            ApexPages.currentPage().getParameters().put('id', leadObj.id);
    		//ConvertLeadOptimize convertLeadOptObj = new ConvertLeadOptimize(sc);
    		ConvertLeadOptimize convertLeadOptObj = new ConvertLeadOptimize();
    		
    		convertLeadOptObj.getListInitialCategoryItems();
			convertLeadOptObj.updateLeadCategory();
			ApexPages.currentPage().getParameters().put('retURL','http://test.com');
			convertLeadOptObj.GoBack();
    		
    		convertLeadOptObj.createNew = true;
    		convertLeadOptObj.convertAndMerge();
    		ApexPages.currentPage().getParameters().put('param1', leadQualObj1.id);
    		convertLeadOptObj.loadLeadQualDet();
    
    		Test.stopTest();
    		
		} catch(Exception ex) {}
	}
	
	
	public static testMethod void testConvertLead1() {
		try {
	        Lead leadObj1 = new Lead();
    		leadObj1.FirstName='Virendra';
            leadObj1.LastName='Singh';
            leadObj1.Company='Simplion';
            leadObj1.Email='virendra.singh@simplion.com';
            leadObj1.LeadSource = 'Inbound Call';
            leadObj1.Website = 'http://test.com';
            leadObj1.NumberOfEmployees = 123;
         	leadObj1.Industry = 'Test';
            leadObj1.NumberOfEmployees__c = '2-19';
            leadObj1.Number_of_Locations__c = '2-4';
    	 	leadObj1.Agent_Email_Address__c = 'test@test.com';  
            insert leadObj1;
            
            Lead_Qualification__c leadQualObj1 = new Lead_Qualification__c();
            leadQualObj1.Lead__c = leadObj1.id;
            insert leadQualObj1;
            
            Lead_Qualification__c leadQualObj2 = new Lead_Qualification__c();
            leadQualObj2.Lead__c = leadObj1.id;
            insert leadQualObj2;
            
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
	        Oppval.StageName = OpportunityHelper.defaultOpportunityStage;
	        Oppval.Sales_Model__c = 'Direct';
	        Oppval.CloseDate = System.Today() + 10;
	        Oppval.CurrencyIsoCode = 'USD';
	        Oppval.Brand_Name__c= 'RingCentral';
	        Oppval.RecordTypeId = '01280000000UEtz';
	        Oppval.Proposal_Expiration_Date__c = System.today() + 100;
	        insert Oppval;
       
            Test.startTest();
            
      	    ApexPages.StandardController sc1 = new ApexPages.standardController(leadObj1);
            
        	ApexPages.currentPage().getParameters().put('id', leadObj1.id);
    		//ConvertLeadOptimize convertLeadOptObj1 = new ConvertLeadOptimize(sc1);
    		ConvertLeadOptimize convertLeadOptObj1 = new ConvertLeadOptimize();
    		//convertLeadOptObj1.createNew = true; 
    		convertLeadOptObj1.leadObj.Account__c = acctest.id;
    		convertLeadOptObj1.convertAndMerge();
    		ApexPages.currentPage().getParameters().put('param1', leadQualObj1.id);
    		convertLeadOptObj1.loadLeadQualDet();
    		
    		convertLeadOptObj1.getOpportunities();
    		convertLeadOptObj1.getCreateNew();
    		convertLeadOptObj1.getl(); 
			convertLeadOptObj1.getstrDebug();
			convertLeadOptObj1.getnotAnswered();
			convertLeadOptObj1.getMatchNotFound();
			convertLeadOptObj1.getMatchFound();
			convertLeadOptObj1.getMultipleSelected();
			
    		Test.stopTest();
    		
		} catch(Exception ex) {}
	}
	
	
	public static testMethod void testConvertLead2() {
		try {
		    Lead leadObj2 = new Lead();
    		leadObj2.FirstName='Virendra';
            leadObj2.LastName='Singh';
            leadObj2.Company='Simplion';
            leadObj2.Phone='9910106804';
            leadObj2.email = 'fake@email.com';
            leadObj2.LeadSource = 'Inbound Call';
            leadObj2.Website = 'http://test.com';
            leadObj2.NumberOfEmployees = 123;
         	leadObj2.Industry = 'Test';
            leadObj2.NumberOfEmployees__c = '2-19';
            leadObj2.Number_of_Locations__c = '2-4';
    	 	leadObj2.Agent_Email_Address__c = 'test@test.com';  
            insert leadObj2; 
            
            Lead_Qualification__c leadQualObj1 = new Lead_Qualification__c();
            leadQualObj1.Lead__c = leadObj2.id;
            insert leadQualObj1;
            
            Lead_Qualification__c leadQualObj2 = new Lead_Qualification__c();
            leadQualObj2.Lead__c = leadObj2.id;
            insert leadQualObj2;
            
            Account acctest = new Account();
	        acctest.Name='TestAccount';
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
	        Oppval.StageName = OpportunityHelper.defaultOpportunityStage;
	        Oppval.Sales_Model__c = 'Direct';
	        Oppval.CloseDate = System.Today() + 10;
	        Oppval.CurrencyIsoCode = 'USD';
	        Oppval.Brand_Name__c= 'RingCentral';
	        Oppval.RecordTypeId = '01280000000UEtz';
	        Oppval.Proposal_Expiration_Date__c = System.today() + 100;
	        insert Oppval;
            
            Test.startTest();
            
            ApexPages.StandardController sc2 = new ApexPages.standardController(leadObj2);
       	
    		ApexPages.currentPage().getParameters().put('id', leadObj2.id);
    		//ConvertLeadOptimize convertLeadOptObj2 = new ConvertLeadOptimize(sc2);
    		ConvertLeadOptimize convertLeadOptObj2 = new ConvertLeadOptimize();
    		//convertLeadOptObj2.createNew = true;
    		convertLeadOptObj2.accountList[0].selected = true;
    		convertLeadOptObj2.convertAndMerge();
    		ApexPages.currentPage().getParameters().put('param1', leadQualObj1.id);
    		convertLeadOptObj2.loadLeadQualDet();
    		
    		Test.stopTest();
    		
		} catch(Exception ex) {}
	}
	@isTest(seeAlldata = true) 
	public static void testLeadQual() {
		try {
			
	        Test.startTest();
	        
			Account acctest = new Account();
	        acctest.Name='TestAccount';
	        acctest.RC_Attribution_Channel__c='Sales Agents & Resellers';
	        acctest.Partner_ID__c ='123';
	        acctest.RecordTypeId  = '01280000000UERq';
	        insert acctest;
	        
	        Contact contactObj = new Contact();
	        contactObj.AccountId =  acctest.id;
	        contactObj.Email = 'test123@test.com';
	        contactObj.FirstName = 'FirstName';
	        contactObj.LastName = 'TestLast';
	        contactObj.Phone = '1234567890';
	        insert contactObj;
	       
	        Opportunity Oppval2 = new Opportunity();
	        Oppval2.Name = 'Test Opp2';
	        Oppval2.AccountId = acctest.Id;
	        Oppval2.Type = 'Existing Business';
	        Oppval2.StageName = OpportunityHelper.defaultOpportunityStage;
	        Oppval2.Sales_Model__c = 'Direct';
	        Oppval2.CloseDate = System.Today() + 10;
	        Oppval2.CurrencyIsoCode = 'USD';
	        Oppval2.Brand_Name__c= 'RingCentral';
	        Oppval2.RecordTypeId = '01280000000UEtu';
	        insert Oppval2;
	        
			
			Lead_Qualification__c leadQualObj = new Lead_Qualification__c();
			leadQualObj.Opportunity__c = Oppval2.id;
			leadQualObj.CompanyInfo__c = 'test';
			insert leadQualObj;
			
			Lead_Qualification__c leadQualObj1 = new Lead_Qualification__c();
			leadQualObj1.Account__c = acctest.id;
			leadQualObj1.CompanyInfo__c = 'test1';
			insert leadQualObj1;
			
			Lead leadObj = new Lead(LastName='Last11', Company='Company11', Phone='34556221', Email='lead@triggertest11.com');
            insert leadObj;
            
            Lead_Qualification__c leadQualObj2 = new Lead_Qualification__c();
			leadQualObj2.Lead__c = leadObj.id;
			leadQualObj2.CompanyInfo__c = 'test2';
			insert leadQualObj2;
      	
			ApexPages.currentPage().getParameters().put('Id',Oppval2.id);	
			LeadQualificationView leadQualView = new LeadQualificationView();
			ApexPages.currentPage().getParameters().put('param1',leadQualObj.id);
			leadQualView.loadLeadQualDet();
			leadQualView.editLeadQualDet();
			leadQualView.unselectclick();
			leadQualView.getunSelectedValues();
			leadQualView.getSelectedValues();
			leadQualView.redirectLeadQualificUser();
			leadQualView.dependentReasons();
			leadQualView.selectclick();
			leadQualView.cancel();
			leadQualView.editLeadQualDet();
			leadQualView.updateLeadQual();
			leadQualView.showMoreInfoBudget();
			leadQualView.checkInputFieldLength();
			leadQualView.backToDetail();
			leadQualView.getDecisionMaker();
			leadQualView.initialiseTriggerBypass();
			leadQualView.SaveDriverResons(leadQualObj2);
			leadQualView.saveUsagesLevelvalues(leadQualObj2);
			leadQualView.saveFeaturesRequestdByCustomerValues(leadQualObj2);
			leadQualView.saveCallFlowModelValues(leadQualObj2);
			leadQualView.saveCurrentSystemInfovalues(leadQualObj2);
			List<SelectOption> listoption0 = leadQualView.getAllCurrentSystemInfoValues;
			List<SelectOption> listoption = leadQualView.getFeaturesRequestdByCustomerValues;
			Map<Integer,String> map1 = leadQualView.getCallFlowModelValues2;
			Map<Integer,LeadQualificationView.ModelValueBindingsClass> map2 = leadQualView.getCallFlowModelValuesMap;
			List<SelectOption> listoption1 = leadQualView.getBusinessAgilityResons;
			List<SelectOption> listoption2 = leadQualView.getBusinessresponsivenessResons;
			List<SelectOption> listoption3 = leadQualView.getBusinessVendorResons;
			List<SelectOption> listoption4 = leadQualView.getUsagesLevelValues;
			LeadQualificationView.LeadQualParentInfoClass LQPIC = new LeadQualificationView.LeadQualParentInfoClass();
			LQPIC.emploees = 'employee';
			List<string> lststr = LQPIC.employeeRange;
			LQPIC.neededPhones = 'neededPhones';
			List<string> lststr1 = LQPIC.Industry;
			List<string> lststr2 = LQPIC.numberOfLocations;
			LQPIC.selectedEmployeeRange = 'selectedEmployeeRange';
			LQPIC.selectedIndustry = 'selectedIndustry';
			LQPIC.selectedLocations = 'selectedLocations';
			LQPIC.website = 'www.test.com';
			leadQualView.leadQualificationObj = new Lead_Qualification__c(CompanyInfo__c='testcompany');
			leadQualView.checkInputFieldLength();
			leadQualView.leadQualificationObj = new Lead_Qualification__c(Pain__c='testpain');
			leadQualView.checkInputFieldLength();
			leadQualView.leadQualificationObj = new Lead_Qualification__c(Pain_Impact__c='testpainImpact');
			leadQualView.checkInputFieldLength();
			leadQualView.leadQualificationObj = new Lead_Qualification__c(Gain__c='testGain');
			leadQualView.checkInputFieldLength();
			leadQualView.leadQualificationObj = new Lead_Qualification__c(Gain_Impact__c='testGainImpact');
			leadQualView.checkInputFieldLength();
			leadQualView.leadQualificationObj = new Lead_Qualification__c(Ideal_Solution__c='testIdealSolution');
			leadQualView.checkInputFieldLength();
			leadQualView.leadQualificationObj = new Lead_Qualification__c(Benefits__c='testBenefits');
			leadQualView.checkInputFieldLength();
			leadQualView.leadQualificationObj = new Lead_Qualification__c(Next_Steps_questions__c='testNextStepsquestions');
			leadQualView.checkInputFieldLength();
			leadQualView.leadQualificationObj = new Lead_Qualification__c(Other_Explanation__c='testOtherExplanation');
			leadQualView.checkInputFieldLength();
			leadQualView.leadQualificationObj = new Lead_Qualification__c(Need__c='testNeed');
			leadQualView.checkInputFieldLength();
			leadQualView.leadQualificationObj = new Lead_Qualification__c(of_employees_in_org__c='testofemployeesinorg');
			leadQualView.checkInputFieldLength();
			leadQualView.leadQualificationObj = new Lead_Qualification__c(How_many_phones_to_start__c='testHowmanyphonestostart');
			leadQualView.checkInputFieldLength();
			leadQualView.leadQualificationObj = new Lead_Qualification__c(Other_Notes__c='testOther_Notes');
			leadQualView.checkInputFieldLength();
			leadQualView.leadQualificationObj = new Lead_Qualification__c(Decision_on_Large_Projects__c='testDecision_on_Large_Projects');
			leadQualView.checkInputFieldLength();
			leadQualView.leadQualificationObj = new Lead_Qualification__c(More_Info_on_Budgeted__c='testMore_Info_on_Budgeted');
			leadQualView.checkInputFieldLength();
			leadQualView.leadQualificationObj = new Lead_Qualification__c(ContractAdditionalInfo__c='testContractAdditionalInfo');
			leadQualView.checkInputFieldLength();
			leadQualView.leadQualificationObj = new Lead_Qualification__c(CurrentSystemAdditionalInfo__c='testCurrentSystemAdditionalInfo');
			leadQualView.checkInputFieldLength();
			leadQualView.leadQualificationObj = new Lead_Qualification__c(TimeframeAdditionalInfo__c='testTimeframeAdditionalInfo');
			leadQualView.checkInputFieldLength();
			leadQualView.leadQualificationObj = new Lead_Qualification__c(Decision_makers_Additional_Information__c='testDecision_makers_Additional_Information');
			leadQualView.checkInputFieldLength();
			leadQualView.leadQualificationObj = new Lead_Qualification__c(Prospect_Need__c='testProspect_Need');
			leadQualView.checkInputFieldLength();
			
			ApexPages.currentPage().getParameters().put('Id',acctest.id);
			ApexPages.currentPage().getParameters().put('retURL',ApexPages.currentPage().getUrl());
			LeadQualificationView leadQualView1 = new LeadQualificationView();
			leadQualView1.editLeadQualDet();
			leadQualView1.updateLeadQual();
			leadQualView1.backToDetail();
			LeadQualificationView.Model_Usage_featureDependencyClass MUFD = new LeadQualificationView.Model_Usage_featureDependencyClass();
			MUFD.isUsageLevel = false;
			List<String> lstStrg = MUFD.childList;
			MUFD.ParentName = 'ParentName';
			leadQualView.getDependencyList.trim();
			
			ApexPages.currentPage().getParameters().put('Id',leadObj.id);
			ApexPages.currentPage().getParameters().put('retURL',ApexPages.currentPage().getUrl());
			
			Lead leadObj12 = new Lead();
			
			Contact contactObj1 = new Contact();
	        contactObj1.AccountId =  acctest.id;
	        contactObj1.Email = 'test123@test.com';
	        contactObj1.FirstName = 'FirstName';
	        contactObj1.LastName = 'TestLast';
	        contactObj1.Phone = '1234567890';
	        insert contactObj1;
			
			LeadQualificationView leadQualView2 = new LeadQualificationView();
			leadQualView2.editLeadQualDet();
			leadQualView2.updateLeadQual();
			leadQualView2.backToDetail();
			leadQualView2.getContactInfo();
			
			Test.stopTest();	
		} catch(Exception ex) {}
	}
	
	//Test Class
    public static testMethod void unitTestSearchEXt() { 

            try {
                TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT = true;
                TriggerHandler.BY_PASS_ACCOUNT_ON_UPDATE = true;
                TriggerHandler.BY_PASS_CONTACT_ON_INSERT = true;
                TriggerHandler.BY_PASS_CONTACT_ON_UPDATE = true;
                TriggerHandler.BY_PASS_OPPORTUNITY_ON_INSERT = true;
                TriggerHandler.BY_PASS_OPPORTUNITY_ON_UPDATE = true;
                
                User user1 = new User(alias = 'newUser1', email='newuser1@simplion.com.test',
                emailencodingkey='UTF-8', lastname='Testing1', 
                languagelocalekey='en_US', localesidkey='en_US', profileid = Userinfo.getProfileId(),
                timezonesidkey='America/Los_Angeles', username= System.now().millisecond() + 'newuser1@simplion.com.test');
                insert user1;
                
                User user2 = new User(alias = 'newUser2', email='newuser2@simplion.com.test',
                emailencodingkey='UTF-8', lastname='Testing2', 
                languagelocalekey='en_US', localesidkey='en_US', profileid = Userinfo.getProfileId(),
                timezonesidkey='America/Los_Angeles', username= System.now().millisecond() + 'newuser2@simplion.com.test');
                insert user2;
                
                Employee__c emp1 = new Employee__c(User__c = user1.Id, Division__c = 'Sales', Extension__c ='119911');
                insert emp1;
                Employee__c emp2 = new Employee__c(User__c = user2.Id, Division__c = 'Sales', Extension__c ='119911');
                insert emp2;
                
                 
                Campaign campObj1 = new Campaign(Name='TestCampaign',Protected_Campaign__c=true, AID__c='test0121' );
                insert campObj1;
                Campaign campObj2 = new Campaign(Name='TestCampaign',Protected_Campaign__c=true, DNIS__c='8667340469' );
                insert campObj2;
                Lead leadObjNew = new Lead(firstName='Singh', lastname = 'Virendra', company='Simplion', email='virendra.singh@simplion.com', phone='9910106804');
                insert leadObjNew;
          
                Account accObj = new Account(name='Simplion', Current_Owner__c=user1.Id);
                insert accObj;
                
                Account accObj1 = new Account(name='Technologies', Current_Owner__c=user2.Id);
                insert accObj1;
                
                Contact contactObj1 = new Contact(firstName='Virendra1', lastname='Singh1', accountId=accObj1.Id, email='virendra1.singh@simplion.com', phone='9910103404');
                insert contactObj1;
                
                Contact contactObj = new Contact(firstName='Virendra', lastname='Singh', accountId=accObj.Id, email='virendra.singh@simplion.com', phone='9910106804');
                insert contactObj;
                
                Opportunity oppObj = new Opportunity(name='Simplion',account=accObj,type='New Business',sales_model__c='Direct',CloseDate=Date.Today(), StageName = OpportunityHelper.defaultOpportunityStage);
                insert oppObj;
                
                Opportunity oppObj1 = new Opportunity(name='Technologies',account=accObj1,type='New Business',sales_model__c='Direct',CloseDate=Date.Today(), StageName = OpportunityHelper.defaultOpportunityStage);
                insert oppObj1;
                
                OpportunityContactRole oppContactRoleObj = new OpportunityContactRole(OpportunityId=oppObj.Id, ContactId=contactObj.Id);
                insert oppContactRoleObj;
                OpportunityContactRole oppContactRoleObj1 = new OpportunityContactRole(OpportunityId=oppObj1.Id, ContactId=contactObj1.Id);
                insert oppContactRoleObj1;
                
                CampaignMember campaignMemObj1 = new CampaignMember(ContactId=contactObj.Id, LeadId=leadObjNew.Id, CampaignId=campObj1.Id);
                insert campaignMemObj1;
                CampaignMember campaignMemObj2 = new CampaignMember(ContactId=contactObj1.Id, LeadId=leadObjNew.Id, CampaignId=campObj2.Id);
                insert campaignMemObj2;
                
                ApexPages.currentPage().getParameters().put('dnis','8667340469');
                ApexPages.currentPage().getParameters().put('ani','6504724063');
                
                System.Test.startTest();
                
                Lead leadObj = new Lead();
                ApexPages.StandardController sc = new ApexPages.standardController(leadObj);
                LeadSearchExtension ui = new LeadSearchExtension(sc);
        
                leadObj.FirstName='Virendra';
                leadObj.LastName='Singh';
                leadObj.Company='Simplion';
                leadObj.Email='virendra.singh@simplion.com';
                leadObj.Phone='9910106804';
                ui.setNewLead(leadObj); 
                ui.search();
                          
                ui.createEmployeeMap(new Set<Id>{user1.Id, user2.Id});
               
                ui.getOwnerId(String.valueOf(user1.Id));
                String conditionalStr = ' AccountId != null ';
                
                ui.findContactList(conditionalStr);       
                List<Id> accountIds = new List<Id>();
                accountIds.add(accObj.Id);
                accountIds.add(accObj1.Id);
                conditionalStr = ' AccountId IN:accountIds '//(\''+accountIds+'\')' 
                                    + ' AND (Opportunity.RecordType.Name = \'Sales Opportunity\' OR RecordTypeId = NULL)';
                ui.findOpportunitiesPerAccounts(conditionalStr, accountIds);                                  
                ui.addOpp(oppObj, contactObj);
                ui.addOppNoContact(oppObj1, contactObj1);
                List<Opportunity> oppList = new List<Opportunity>();
                oppList.add(oppObj);
                oppList.add(oppObj1);
                List<Contact> contactList = new List<Contact>();
                contactList.add(contactObj1);
                contactList.add(contactObj);
                ui.findContactToAccountMap(contactList);
                ui.oppPerContacts(contactList);
                ui.findOppPerAccountId(oppList);
                ui.findContactToAccountMap(null);
                ui.findContactPerOppRoles(null, null);
                ui.findExistingLeads(null);
                ui.findContactList(null);
                ui.findContactList('');
                ui.findOpportunitiesPerAccounts(null, null);
                ui.findOpportunitiesPerCompanyName(null);
                ui.findOpportunitiesPerCompanyName(' Name=\'Simplion\' ');
                ui.oppPerContacts(contactList);
                
                ui.isValidEmail('$%%@!@#.4343');
                ui.cancel();
                
                leadObj = new Lead();
                leadObj.FirstName='';
                leadObj.LastName='';
                leadObj.Company='';
                leadObj.Email='';
                leadObj.Phone='';
                ui.setNewLead(leadObj);
                ui.search();        
                
                ui.getOppResults();
                ui.getOppNoOCResults();
                ui.getPartnerOppResults();
                ui.getUnprotectedResults();
                ui.getLeadResults();
                ui.getEmptyField();
                ui.getSearched();
                ui.getEmptySearch();
                ui.getEmailNotFormated();
                ui.getSearchFirst();
                ui.getOpportunities(); 
                ui.getOpportunitiesNoCO();
                ui.getParterOpportunities();
                ui.getUnprotectedOpportunities();
                ui.getLeadList();          
                ui.getUnProtectedLeadResults();
                ui.getProtectedLeadResults();
                ui.getagentEmailChk();
                ui.getdnisChk();
                ui.getPhoneNotFormated();
                ui.getunprotectedLeadList();
                ui.getprotectedLeadList();
                ui.getnewLead();
       
                ui.createNew();
                
                leadObj = new Lead();
                leadObj.FirstName='';
                leadObj.LastName='';
                leadObj.Company='Simplion';
                leadObj.Email='virendra.singh@simplion.com';
                leadObj.Phone='9910106804';
                ui.setNewLead(leadObj);        
                ui.search();        
                ui.createNew();
                
                leadObj = new Lead();
                leadObj.FirstName='Virendra';
                leadObj.LastName='Singh';
                leadObj.Company='';
                leadObj.Email='virendra.singh@simplion.com';
                leadObj.Phone='9910106804';
                ui.setNewLead(leadObj);   
                ui.search();
                ui.createNew();
                
                leadObj = new Lead();
                leadObj.FirstName='Virendra';
                leadObj.LastName='Singh';
                leadObj.Company='Simplion';
                leadObj.Email='virendra.singh@simplion.com';
                leadObj.Phone='';
                ui.setNewLead(leadObj);        
                ui.search();
                ui.createNew();
                
                ui.oppPerContactRoles();
                Contact[] contactListNew = ui.findContactList(' ');
                ui.oppPerContacts(contactListNew);
                ui.prepareLeadList('');
                
                leadObj = new Lead();
                leadObj.FirstName='Virendra';
                leadObj.LastName='Singh';
                leadObj.Company='Simplion';
                leadObj.Email='';
                leadObj.Phone='9910106804';
                ui.setNewLead(leadObj);        
                ui.search();
                
                leadObj = new Lead();
                leadObj.FirstName='';
                leadObj.LastName='';
                leadObj.Company='';
                leadObj.Email='virendra.singh@simplion.com';
                leadObj.Phone='9910106804';
                ui.setNewLead(leadObj);        
                ui.search();
                
                leadObj = new Lead();
                leadObj.FirstName='';
                leadObj.LastName='';
                leadObj.Company='Simplion';
                leadObj.Email='virendra.singh@simplion.com';
                leadObj.Phone='';
                ui.setNewLead(leadObj);        
                ui.search();
                
                leadObj = new Lead();
                leadObj.FirstName='Virendra';
                leadObj.LastName='Singh';
                leadObj.Company='';
                leadObj.Email='virendra.singh@simplion.com';
                leadObj.Phone='';
                ui.setNewLead(leadObj);        
                ui.search();
                
                leadObj = new Lead();
                leadObj.FirstName='';
                leadObj.LastName='';
                leadObj.Company='Simplion';
                leadObj.Email='';
                leadObj.Phone='9910106804';
                ui.setNewLead(leadObj);        
                ui.search(); 
                
                leadObj = new Lead();
                leadObj.FirstName='Virendra';
                leadObj.LastName='Singh';
                leadObj.Company='';
                leadObj.Email='';
                leadObj.Phone='9910106804';
                ui.setNewLead(leadObj);        
                ui.search(); 
                
                leadObj = new Lead();
                leadObj.FirstName='Virendra';
                leadObj.LastName='Singh';
                leadObj.Company='Simplion';
                leadObj.Email='';
                leadObj.Phone='';
                ui.setNewLead(leadObj);        
                ui.search(); 
                
                leadObj = new Lead();
                leadObj.FirstName='Virendra';
                leadObj.LastName='';
                leadObj.Company='Simplion';
                leadObj.Email='';
                leadObj.Phone='9910106804';
                ui.setNewLead(leadObj);        
                ui.search(); 
                
                leadObj = new Lead();
                leadObj.Company='';
                leadObj.Email='';
                leadObj.FirstName='Virendra';
                leadObj.LastName='Singh';
                leadObj.Phone='9910106804';
                ui.setNewLead(leadObj);        
                ui.search();           
                
                leadObj = new Lead();
                leadObj.FirstName='Virendra';
                leadObj.LastName='Singh';
                leadObj.Company='Simplion';
                leadObj.Email='';
                leadObj.Phone='';
                ui.setNewLead(leadObj);
                ui.search(); 
                
                leadObj = new Lead();
                leadObj.FirstName='';
                leadObj.LastName='';
                leadObj.Company='';
                leadObj.Phone='';
                leadObj.Email='virendra.singh@simplion.com';
                ui.setNewLead(leadObj);
                ui.search(); 
                
                leadObj = new Lead();
                leadObj.FirstName='';
                leadObj.LastName='';
                leadObj.Company='';
                leadObj.Email='';
                leadObj.Phone='9910106804';
                ui.setNewLead(leadObj);
                ui.search();
                
                leadObj = new Lead();
                leadObj.FirstName='';
                leadObj.LastName='';
                leadObj.Company='';
                leadObj.Email='';
                leadObj.Phone='9912342323';
                ui.setNewLead(leadObj);
                ui.search();  
                
                leadObj = new Lead();
                leadObj.FirstName='';
                leadObj.LastName='';
                leadObj.Email='';
                leadObj.Phone='';
                leadObj.Company='Simplion';
                ui.setNewLead(leadObj);
                ui.search(); 
                
                leadObj = new Lead();
                leadObj.FirstName='Virendra';
                leadObj.LastName='Singh';
                leadObj.Company='';
                leadObj.Email='';
                leadObj.Phone='';
                ui.setNewLead(leadObj);
                ui.search(); 
                
                leadObj = new Lead();
                leadObj.FirstName='';
                leadObj.LastName='';
                leadObj.Company='';
                leadObj.Email='';
                leadObj.Phone='';
                ui.setNewLead(leadObj); 
                ui.checkInputFieldLength();       
                ui.createNew();     
                
                leadObj = new Lead();
                leadObj.FirstName='Virendra';
                leadObj.LastName='Singh';
                leadObj.Company='Simplion';
                leadObj.Email='virendra.singh@simplion.com';
                leadObj.Phone='1234';
                ui.setNewLead(leadObj);        
                ui.createNew(); 
                
                leadObj = new Lead();
                ApexPages.currentPage().getParameters().put('dnis','8775843307');
                leadObj.FirstName='Virendra';
                leadObj.LastName='Singh';
                leadObj.Company='Simplion';
                leadObj.Email='virendra.singh@simplion.com';
                leadObj.Phone='9910106804';
                ui.setNewLead(leadObj);        
                ui.createNew(); 
                
                leadObj = new Lead();
                ApexPages.currentPage().getParameters().put('dnis','8772343307');
                leadObj.LastName='Singh';
                leadObj.Company='Simplion';
                leadObj.Email='virendra.singh@simplion.com';
                leadObj.Phone='9910106804';
                leadObj.Notes__c = 'this is our QA';
                ui.setNewLead(leadObj);        
                ui.createNew(); 
                Database.LeadConvert lc = new database.LeadConvert();
                lc.setLeadId(leadObj.id);
                
                leadObj = new Lead();
                leadObj.FirstName='Virendra';
                leadObj.LastName='Singh';
                leadObj.Company='Simplion';
                leadObj.Email='virendra.singh@simplion.com';
                leadObj.Phone='9910106804';
                ui.setNewLead(leadObj); 
                ui.search();
                
                leadObj = new Lead();
                leadObj.FirstName ='First Name';
                leadObj.LastName ='Last Name';
                leadObj.Title ='Title';
                leadObj.Company ='Company Name';
                leadObj.Email ='Email Address';
                leadObj.Website ='Website';
                leadObj.Phone = '9910106804';
                leadObj.Website ='Website';
                leadObj.CompanyInfo__c ='What do you guys do? What do you use now? Tell me about how much your paying?';
                leadObj.Pain_Impact__c ='What else?';
                leadObj.Gain_Impact__c ='What else?';
                ui.setNewLead(leadObj);
                ui.numOfEmployees = 'empl';
                ui.search();
                
                ui.getcampaignName();
                ui.getcampaignDescription();
                ui.getFieldsChangedAfterSearch();
                ui.resetSearchfirst();
                
                System.Test.stopTest(); 
            } catch(Exception ex) { }
    }
    
    static testMethod void testLeadSearchExtension1() {
        try {
            System.Test.startTest();
            ApexPages.currentPage().getParameters().put('dnis','8775843307');   
            Lead leadObj = new Lead();
            ApexPages.StandardController sc = new ApexPages.standardController(leadObj);
            LeadSearchExtension ui = new LeadSearchExtension(sc);
            
            leadObj = new Lead();
            leadObj.FirstName='Virendra';
            leadObj.LastName='Singh';
            leadObj.Company='Simplion';
            leadObj.Email='vps@sss.ss221.com';
            leadObj.Phone='9910106804';
            leadObj.LeadSource = 'Inbound Call';
            ui.setNewLead(leadObj);
            ui.search();
            //ui.errorMsg = 'CompanyInfo';
            leadObj.Notes__c = 'Test Note';         
            ui.createNew(); 
            
            leadObj = new Lead();
            leadObj.FirstName='Virendra11';
            leadObj.LastName='Singh11';
            leadObj.Company='Simplion11';
            leadObj.Email='virendra.singhsimplion.com';
            leadObj.Phone='9910106804';
            ui.setNewLead(leadObj); 
            ui.search();
            
            leadObj = new Lead();
            leadObj.FirstName='Virendra11';
            leadObj.LastName='Singh11';
            leadObj.Company='Simplion11';
            leadObj.Email='virendra.singhsimplion.com';
            leadObj.Phone='9910106804';
            leadObj.LeadSource = 'Inbound Call';
            ui.setNewLead(leadObj); 
            ui.createNew();
            
            leadObj = new Lead();
            leadObj.FirstName='Virendra11';
            leadObj.LastName='Singh11';
            leadObj.Company='Simplion11';
            leadObj.Email='virendra.singhs@implion.com';
            leadObj.Phone='9910';
            ui.setNewLead(leadObj); 
            ui.search();
            
            //leadObj = new Lead();
            //leadObj.Email='virendra.singh1@simplion.com'; 
            //ui.setNewLead(leadObj); 
            //ui.search();
            
            leadObj = new Lead();
            leadObj.FirstName='Virendra11';
            leadObj.LastName='Singh11';
            leadObj.Company='Simplion11';
            leadObj.Email='virendra.singhs@implion.com';
            leadObj.Phone='9910';
            leadObj.LeadSource = 'Inbound Call';
            ui.setNewLead(leadObj);
            ui.createNew();
            
            leadObj = new Lead();
            leadObj.FirstName='Virendra11';
            leadObj.LastName='Singh11';
            leadObj.Company='Simplion11';
            leadObj.Email='virendra.singhs@implion.com';
            leadObj.Phone='9910323232';
            leadObj.LeadSource = 'Inbound Call';
            ui.setNewLead(leadObj); 
            ui.createNew();
            
            leadObj = new Lead();
            leadObj.FirstName='Virendra11';
            leadObj.LastName='Singh11';
            leadObj.Company='Simplion11';
            leadObj.Email='virendra.singhs@implion.com';
            leadObj.Phone='9910323232';
            leadObj.LeadSource = 'Inbound Call';
            leadObj.Agent_Email_Address__c  = 'test@test.com';
            leadObj.Employees_Override__c = '10-49';
            leadObj.Notes__c = 'testNote';
            
            Lead_Qualification__c leadObj1 = new Lead_Qualification__c();
            leadObj1.CompanyInfo__c = 'CompanyInfo';
            leadObj1.Pain__c = 'pain';
            leadObj1.Pain_Impact__c = 'pain impact';
            leadObj1.Gain__c = 'gain';
            leadObj1.Gain_Impact__c = 'gain impact';
            leadObj1.Ideal_Solution__c = 'idea solution';
            leadObj1.Benefits__c = 'benefit';
            leadObj1.Next_Steps_questions__c = 'next step question';
            leadObj1.Need__c = 'need';
            leadObj1.Other_Explanation__c = 'other explanation';
            leadObj1.of_employees_in_org__c = 'no of employee';
            leadObj1.Other_Notes__c = 'other notes';
            leadObj1.Decision_on_Large_Projects__c = 'decision on large'; 
            leadObj1.More_Info_on_Budgeted__c = 'more info';
            leadObj1.ContractAdditionalInfo__c = 'contract info';
            leadObj1.CurrentSystemAdditionalInfo__c = 'Current SAInfo';
            leadObj1.TimeframeAdditionalInfo__c = 'time FAInfo';
            leadObj1.Decision_makers_Additional_Information__c = 'decision MAInfo';
            ui.setNewLead(leadObj);            
            ui.search(); 
            ui.createNew();
            leadObj.Email = 'virendra@singhs@implion.com';
            ui.createNew();
            leadObj.Email = 'virendrasinghs1@implion.com';
            ui.searchedem = 'sdfsdf';
            ui.createNew();          
              
            ui.selectclick();
            ui.unselectclick();
            ui.getunSelectedValues();
            ui.getSelectedValues();
            ui.dependentReasons();
            ui.leadQualificationObj = leadObj1;
            //ui.leadQualificationObj = new Lead_Qualification__c(CompanyInfo__c='testcompany');
            ui.checkInputFieldLength();
            ui.claimLeadOwnership();
            ui.redirectPartnerUser();
            ui.getShowCreateLeadButton();
            ui.getShowUnprotectedLeadsList(); 
            ui.checkInputFieldLength();
            ui.getDependencyList.trim();
            ApexPages.currentPage().getParameters().put('modelValue','ModelValue');
            LeadSearchExtension.Model_Usage_featureDependencyClass ModUsFe = new LeadSearchExtension.Model_Usage_featureDependencyClass();
            ModUsFe.isUsageLevel = false;
            List<String> lstStrg = ModUsFe.childList;
			ModUsFe.ParentName = 'ParentName';
            
            List<SelectOption> listoption = ui.getBusinessAgilityResons;
            List<SelectOption> listoption1 = ui.getBusinessresponsivenessResons;
            List<SelectOption> listoption2 = ui.getBusinessVendorResons;
            Map<Integer,String> map1 = ui.getCallFlowModelValues2;
            List<SelectOption> listoption3 = ui.getAllCurrentSystemInfoValues;
            List<SelectOption> listoption5 = ui.getFeaturesRequestdByCustomerValues;
            List<SelectOption> listoption6 = ui.getUsagesLevelValues;
            ui.SaveDriverResons(leadObj1);
            ui.saveCurrentSystemInfovalues(leadObj1);
            ui.saveCallFlowModelValues(leadObj1);
            ui.saveFeaturesRequestdByCustomerValues(leadObj1);
            ui.saveUsagesLevelvalues(leadObj1);
            ui.getDecisionMaker();
            ui.showMoreInfoBudget();
            ui.getShowClaimOnwernship();
            //insert leadObj;
            ApexPages.currentPage().getParameters().put('claimedLeadId',leadObj.Id);           
            ui.claimLeadOwnership(); 
            
            ui.searchedem = 'virendrasinghs1@implion.com';
            ui.dnis = '8775843307';
            leadObj.Agent_Email_Address__c = ''; 
            ui.createNew(); 
            
            ui.dnis = '';
            leadObj.Agent_Email_Address__c = 'test@test.com'; 
            ui.leadQualificationObj = new Lead_Qualification__c(CompanyInfo__c='testcompany');
            ui.createNew();
            ui.leadQualificationObj = new Lead_Qualification__c(Pain__c='testpain');
            ui.checkInputFieldLength();
            ui.leadQualificationObj = new Lead_Qualification__c(Pain_Impact__c='testpainImpact');
            ui.checkInputFieldLength();
            ui.leadQualificationObj = new Lead_Qualification__c(Gain__c='testGain');
            ui.checkInputFieldLength();
            ui.leadQualificationObj = new Lead_Qualification__c(Gain_Impact__c='testGainImpact');
            ui.checkInputFieldLength();
            ui.leadQualificationObj = new Lead_Qualification__c(Ideal_Solution__c='testIdealSolution');
            ui.checkInputFieldLength();
            ui.leadQualificationObj = new Lead_Qualification__c(Benefits__c='testBenefits');
            ui.checkInputFieldLength();
            ui.leadQualificationObj = new Lead_Qualification__c(Next_Steps_questions__c='testNextStepsquestions');
            ui.checkInputFieldLength();
            ui.leadQualificationObj = new Lead_Qualification__c(Other_Explanation__c='testOtherExplanation');
            ui.checkInputFieldLength();
            ui.leadQualificationObj = new Lead_Qualification__c(Need__c='testNeed');
            ui.checkInputFieldLength();
            ui.leadQualificationObj = new Lead_Qualification__c(of_employees_in_org__c='testofemployeesinorg');
            ui.checkInputFieldLength();
            ui.leadQualificationObj = new Lead_Qualification__c(How_many_phones_to_start__c='testHowmanyphonestostart');
            ui.checkInputFieldLength();
            ui.leadQualificationObj = new Lead_Qualification__c(Other_Notes__c='testOther_Notes');
            ui.checkInputFieldLength();
            ui.leadQualificationObj = new Lead_Qualification__c(Decision_on_Large_Projects__c='testDecision_on_Large_Projects');
            ui.checkInputFieldLength();
            ui.leadQualificationObj = new Lead_Qualification__c(More_Info_on_Budgeted__c='testMore_Info_on_Budgeted');
            ui.checkInputFieldLength();
            ui.leadQualificationObj = new Lead_Qualification__c(ContractAdditionalInfo__c='testContractAdditionalInfo');
            ui.checkInputFieldLength();
            ui.leadQualificationObj = new Lead_Qualification__c(CurrentSystemAdditionalInfo__c='testCurrentSystemAdditionalInfo');
            ui.checkInputFieldLength();
            ui.leadQualificationObj = new Lead_Qualification__c(TimeframeAdditionalInfo__c='testTimeframeAdditionalInfo');
            ui.checkInputFieldLength();
            ui.leadQualificationObj = new Lead_Qualification__c(Decision_makers_Additional_Information__c='testDecision_makers_Additional_Information');
            ui.checkInputFieldLength();
            ui.leadQualificationObj = new Lead_Qualification__c(Prospect_Need__c='testProspect_Need');
            ui.checkInputFieldLength();
            
            System.Test.stopTest();               
        } catch(Exception ex) { }  
    }

    public static testMethod void testConvertLead3() {
        try {
            Lead leadObj = new Lead();
            leadObj.FirstName='Virendra';
            leadObj.LastName='Singh';
            leadObj.Company='Simplion';
            leadObj.Email='virendra.singh@simplion.com';
            leadObj.Phone='9910106804';
            leadObj.LeadSource = 'Inbound Call';
            leadObj.Notes__c = 'Test Notes'; 
            leadObj.Website = 'http://test.com';
            leadObj.NumberOfEmployees = 123;
            leadObj.Industry = 'Test';
            leadObj.NumberOfEmployees__c = '2-19';
            leadObj.Number_of_Locations__c = '2-4';
            leadObj.Agent_Email_Address__c = 'test@test.com';            
            insert leadObj;
            
            Note noteObj = new Note();
            noteObj.ParentId = leadObj.id;
            noteObj.Body = 'test';
            noteObj.Title= 'Original note from lead';
            insert noteObj;
            
            Lead_Qualification__c leadQualObj1 = new Lead_Qualification__c();
            leadQualObj1.Lead__c = leadObj.id;
            insert leadQualObj1;
            
            Lead_Qualification__c leadQualObj2 = new Lead_Qualification__c();
            leadQualObj2.Lead__c = leadObj.id;
            insert leadQualObj2;
            
            Account acctest = new Account();
            acctest.Name='TestAccount';
            acctest.RC_Attribution_Channel__c = 'Sales Agents & Resellers';
            acctest.Partner_ID__c ='123';
            acctest.RecordTypeId  = '01280000000UERq';
            insert acctest;
                        
            Contact contactObj = new Contact();
            contactObj.AccountId =  acctest.id;
            contactObj.Email = 'virendra.singh@simplion.com';
            contactObj.Phone = '9910106804';
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
            
            ApexPages.StandardController sc = new ApexPages.standardController(leadObj);
       
            ApexPages.currentPage().getParameters().put('id', leadObj.id);
            //ConvertPartnerLead convertLeadOptObj = new ConvertPartnerLead(sc);
            ConvertPartnerLead convertLeadOptObj = new ConvertPartnerLead();
            
            convertLeadOptObj.getListInitialCategoryItems();
            convertLeadOptObj.updateLeadCategory();
            ApexPages.currentPage().getParameters().put('retURL','http://test.com');
            convertLeadOptObj.GoBack();
            
            convertLeadOptObj.createNew = true;
            convertLeadOptObj.convertAndMerge();
            ApexPages.currentPage().getParameters().put('param1', leadQualObj1.id);
    
            Test.stopTest();
            
        } catch(Exception ex) {}
    }
    
    public static testMethod void testConvertLead4() {
        try {
            Lead leadObj1 = new Lead();
            leadObj1.FirstName='Virendra';
            leadObj1.LastName='Singh';
            leadObj1.Company='Simplion';
            leadObj1.Email='virendra.singh@simplion.com';
            leadObj1.LeadSource = 'Inbound Call';
            leadObj1.Website = 'http://test.com';
            leadObj1.NumberOfEmployees = 123;
            leadObj1.Industry = 'Test';
            leadObj1.NumberOfEmployees__c = '2-19';
            leadObj1.Number_of_Locations__c = '2-4';
            leadObj1.Agent_Email_Address__c = 'test@test.com';  
            insert leadObj1;
            
            Lead_Qualification__c leadQualObj1 = new Lead_Qualification__c();
            leadQualObj1.Lead__c = leadObj1.id;
            insert leadQualObj1;
            
            Lead_Qualification__c leadQualObj2 = new Lead_Qualification__c();
            leadQualObj2.Lead__c = leadObj1.id;
            insert leadQualObj2;
            
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
       
            Test.startTest();
            
            ApexPages.StandardController sc1 = new ApexPages.standardController(leadObj1);
            
            ApexPages.currentPage().getParameters().put('id', leadObj1.id);
            //ConvertPartnerLead convertLeadOptObj1 = new ConvertPartnerLead(sc1);
            ConvertPartnerLead convertLeadOptObj1 = new ConvertPartnerLead();
            //convertLeadOptObj1.createNew = true; 
            convertLeadOptObj1.leadObj.Account__c = acctest.id;
            convertLeadOptObj1.convertAndMerge();
            ApexPages.currentPage().getParameters().put('param1', leadQualObj1.id);
            
            convertLeadOptObj1.getOpportunities();
            convertLeadOptObj1.getCreateNew();
            convertLeadOptObj1.getl(); 
            convertLeadOptObj1.getstrDebug();
            convertLeadOptObj1.getnotAnswered();
            convertLeadOptObj1.getMatchNotFound();
            convertLeadOptObj1.getMatchFound();
            convertLeadOptObj1.getMultipleSelected();
            
            Test.stopTest();
            
        } catch(Exception ex) {}
    }
    
   
    public static testMethod void testConvertLead5() {
        try {
            Lead leadObj2 = new Lead();
            leadObj2.FirstName='Virendra';
            leadObj2.LastName='Singh';
            leadObj2.Company='Simplion';
            leadObj2.Phone='9910106804';
            leadObj2.email = 'fake@email.com';
            leadObj2.LeadSource = 'Inbound Call';
            leadObj2.Website = 'http://test.com';
            leadObj2.NumberOfEmployees = 123;
            leadObj2.Industry = 'Test';
            leadObj2.NumberOfEmployees__c = '2-19';
            leadObj2.Number_of_Locations__c = '2-4';
            leadObj2.Agent_Email_Address__c = 'test@test.com';  
            insert leadObj2; 
            
            Lead_Qualification__c leadQualObj1 = new Lead_Qualification__c();
            leadQualObj1.Lead__c = leadObj2.id;
            insert leadQualObj1;
            
            Lead_Qualification__c leadQualObj2 = new Lead_Qualification__c();
            leadQualObj2.Lead__c = leadObj2.id;
            insert leadQualObj2;
            
            Account acctest = new Account();
            acctest.Name='TestAccount';
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
            Oppval.StageName = '3. Qualified';
            Oppval.Sales_Model__c = 'Direct';
            Oppval.CloseDate = System.Today() + 10;
            Oppval.CurrencyIsoCode = 'USD';
            Oppval.Brand_Name__c= 'RingCentral';
            Oppval.RecordTypeId = '01280000000UEtz';
            Oppval.Proposal_Expiration_Date__c = System.today() + 100;
            insert Oppval;
            
            Test.startTest();
            
            ApexPages.StandardController sc2 = new ApexPages.standardController(leadObj2);
        
            ApexPages.currentPage().getParameters().put('id', leadObj2.id);
            //ConvertPartnerLead convertLeadOptObj2 = new ConvertPartnerLead(sc2);
            ConvertPartnerLead convertLeadOptObj2 = new ConvertPartnerLead();
            //convertLeadOptObj2.createNew = true;
            convertLeadOptObj2.accountList[0].selected = true;
            convertLeadOptObj2.convertAndMerge();
            ApexPages.currentPage().getParameters().put('param1', leadQualObj1.id);
            
            Test.stopTest();
            
        } catch(Exception ex) {}
    }
    
 	static testMethod void testLeadSearchController() {
 		Test.startTest();
 	 	Lead leadObj = new Lead();
        ApexPages.StandardController sc = new ApexPages.standardController(leadObj);
        LeadSearchController ui = new LeadSearchController(sc);
        Test.stopTest();
     }
    
    /*static testMethod void prAssignmentTest() {
		User user1 = new User(alias = 'newUser1', email='newuser1@simplion.com.test',
		emailencodingkey='UTF-8', lastname='Testing1', 
		languagelocalekey='en_US', localesidkey='en_US', profileid = Userinfo.getProfileId(),
		timezonesidkey='America/Los_Angeles', username= System.now().millisecond() + 'newuser1@simplion.com.test');
		insert user1;
        
        User user2 = new User(alias = 'newUser2', email='newuser2@simplion.com.test',
		emailencodingkey='UTF-8', lastname='Testing2', 
		languagelocalekey='en_US', localesidkey='en_US', profileid = Userinfo.getProfileId(),
		timezonesidkey='America/Los_Angeles', username= System.now().millisecond() + 'newuser2@simplion.com.test');
		insert user2;
		
		User user3 = new User(alias = 'newUser3', email='newuser3@simplion.com.test',
		emailencodingkey='UTF-8', lastname='Testing3', 
		languagelocalekey='en_US', localesidkey='en_US', profileid = '00e80000001Bzoq',
		timezonesidkey='America/Los_Angeles', username= System.now().millisecond() + 'newuser3@simplion.com.test');
		insert user3;
		
		Skill__c s1= new Skill__c(Name='Skill1');
		insert s1;
		Skill__c s2= new Skill__c(Name='Skill2');
		insert s2;
		User_Skill__c us1 = new User_Skill__c (Name='us1', User__c=user1.Id, Skill__c=s1.Id);
		insert us1;
		User_Skill__c us2 = new User_Skill__c (Name='us2', User__c=user2.Id, Skill__c=s1.Id);
		insert us2;
        User_Skill__c us3 = new User_Skill__c (Name='us3', User__c=user1.Id, Skill__c=s2.Id);
		insert us3;
		
		List<Lead> leadList = new List<Lead>();
		
		System.runAs(user1) {
			Campaign campObj1 = new Campaign(Name='TestCampaign',Protected_Campaign__c=true
	        , Lead_Creation_Score__c='300', IsActive=true, AID__c='test0121' );
	        insert campObj1;
	        Campaign campObj2 = new Campaign(Name='TestCampaign',Protected_Campaign__c=false
	        , Lead_Creation_Score__c='test', IsActive=true, DNIS__c='test0121' );
	        insert campObj2;
	        Campaign campObj3 = new Campaign(Name='TestCampaign',Protected_Campaign__c=true
	        , Lead_Creation_Score__c='-200', IsActive=true, PID__c='test0121' );
	        insert campObj3;
	        Campaign campObj4 = new Campaign(Name='TestCampaign',Protected_Campaign__c=false
	        , Lead_Creation_Score__c='200.00', IsActive=true, BMID__c='test0121' );
	        insert campObj4;
	        Campaign campObj5 = new Campaign(Name='TestCampaign',Protected_Campaign__c=true
	        , IsActive=true, Lead_Entry_Source__c='ROI Form' );
	        insert campObj5;
	        Campaign campObj6 = new Campaign(Name='Default Campaign',Protected_Campaign__c=true, IsActive=true );
	        insert campObj6;
	        
	        List<Campaign> campList = new List<Campaign>();
	        
	        Campaign campObj7 = new Campaign(Name='Default Campaign',Protected_Campaign__c=true, IsActive=true );
	        campList.add(campObj7);	        
	        
	        Campaign campObj8 = new Campaign(Name='Default Campaign',Protected_Campaign__c=true, IsActive=true );
	        campList.add(campObj8);	       
	        
	        Campaign campObj9 = new Campaign(Name='Default Campaign',Protected_Campaign__c=true, IsActive=true );	
			campList.add(campObj9);       
	        
	        Campaign campObj10 = new Campaign(Name='Default Campaign',Protected_Campaign__c=true, IsActive=true );
	        campList.add(campObj10);
	        
	        insert campList;	       
	             
		     Account accObj1 = new Account(Name='Simplion', Current_Owner__c = user2.Id, RC_User_ID__c = 'Test002', Type= 'Customer');
			 insert accObj1;
			 
			 System.Debug('>>>accObj1>>'+accObj1);
			 
			 Contact contactObj1 = new Contact(firstName='Virendra1', indexedPhone__c='9910103404',indexedEmail__c='virendra.singh@simplion.com', lastname='Singh1', 
			 accountid = accObj1.id, email = 'virendra.singh@simplion.com', phone='9910103404');
		     insert contactObj1;
		     
		     System.Debug('>>>contactObj1>>'+contactObj1+''+contactObj1.account);
	         
	         Opportunity oppObj = new Opportunity(name='Simplion',account=accObj1, type='New Business',sales_model__c='Direct',CloseDate=Date.Today(), StageName= OpportunityHelper.defaultOpportunityStage);
	         insert oppObj;
             
	         Lead leadObj1 = new Lead(firstName='Singh', Title='VP', Lead_Entry_Source__c='ROI Form', LeadSource='Initial', lastname = 'Virendra', 
	         company='Simplion', email='virendra.singh@simplion.com', phone='9910106804');
	         leadList.add(leadObj1);
	        
	         Lead leadObj2 = new Lead(firstName='Singh', Title='VP', AID__C='test0121', Referrer_RCUserID__c='Test002', 
	        					LeadSource='About To Be Cancelled',User_ID__c='Test002', lastname = 'Virendra', 
	         company='Simplion', email='virendra.singh1@simplion.com', phone='0000000000');
	         leadList.add(leadObj2);
	        
	         Lead leadObj3 = new Lead(firstName='Singh', Title='VP', PID__c='test0121', NumberOfEmployees__c ='500+', LeadSource='Vista Print', lastname = 'Virendra', 
	         company='Simplion', email='virendra.singh2@simplion.com', phone='(919)191-9128',indexedEmail__c = 'virendra.singh2@simplion.com',
	         indexedPhone__c = '(919)191-9128' ,Status='1.5 Call Out', IsConverted = false,Primary_Campaign__c = campObj1.Id);
	         leadList.add(leadObj3);
	         
	         Lead leadObj4 = new Lead(firstName='Singh', Title='VP', PID__c='test0121', NumberOfEmployees__c ='500+', LeadSource='Referral Programs', lastname = 'Virendra', 
	         company='Simplion', email='virendra.singh3@simplion.com', phone='(919)191-9129',indexedEmail__c = 'virendra.singh3@simplion.com',
	         indexedPhone__c = '(919)191-9129' ,Status='1.5 Call Out', IsConverted = false,Primary_Campaign__c = campObj1.Id, 
	         Referrer_RCUserID__c ='Test002');
	         leadList.add(leadObj4);
	         
	         Lead leadObj5 = new Lead(firstName='Singh', Title='VP', PID__c='test0121', NumberOfEmployees__c ='500+', LeadSource='Referral Programs', lastname = 'Virendra', 
	         company='Simplion', email='virendra.singh4@simplion.com', phone='(919)191-9124',indexedEmail__c = 'virendra.singh4@simplion.com',
	         indexedPhone__c = '(919)191-9124' ,Status='1.5 Call Out', IsConverted = false, Primary_Campaign__c = campObj1.Id, 
	         Referrer_Email__c = 'virendra.singh@simplion.com');
	         leadList.add(leadObj5);
	         
	         Lead leadObj6 = new Lead(firstName='Singh', Title='VP', PID__c='test0121', NumberOfEmployees__c ='500+', LeadSource='Referral Programs', lastname = 'Virendra', 
	         company='Simplion', email='virendra.singh5@simplion.com', phone='9910106824',indexedEmail__c = 'virendra.singh5@simplion.com',
	         indexedPhone__c = '9910106824' ,Status='1.5 Call Out', IsConverted = false, Primary_Campaign__c = campObj1.Id, 
	         Sales_Agent_Email__c = 'newuser3@simplion.com.test');
	         leadList.add(leadObj6);
	         
	         Lead leadObj7 = new Lead(firstName='Singh', Title='VP', PID__c='test0121', NumberOfEmployees__c ='500+', LeadSource='Solve then Sell', lastname = 'Virendra', 
	         company='Simplion', email='virendra.singh6@simplion.com', phone='(919)191-9125',indexedEmail__c = 'virendra.singh6@simplion.com',
	         indexedPhone__c = '(919)191-9125' ,Status='1.5 Call Out', User_ID__c='Test002', IsConverted = false, Primary_Campaign__c = campObj1.Id, 
	         Sales_Agent_User_Lookup__c = user3.Id);
	         leadList.add(leadObj7);
			  
			 try {
			 	insert leadList;	
			 } catch(Exception ex) { 
			 	System.debug('## PRASSIGNMENT FAILED ## IN TEST METHODS');
			 }          
         }
         
         LeadTriggerHelper helperObj = new LeadTriggerHelper();
         
         
         
         PRAssignment prObj = new PRAssignment(helperObj,leadList);
         PRAssignment.LeadWrapper leadWrObj = new PRAssignment.LeadWrapper(null,null);
         PRAssignment.ContactWrapperClass contactWrObj = new PRAssignment.ContactWrapperClass(null,null,null,null);
         Map<String, List<Account>> accountListToMap = prObj.getAccountsPerUserIds(leadList);
         prObj.rearrangePhone(leadList[0]);
         prObj.rearrangePhone(leadList[1]);
         contactWrObj = prObj.getOwnerPerContact(leadList);
         leadWrObj = prObj.getExistingLeads(leadList);
         
        prObj.getOppOwnerCount(new Set<Id>{us1.Id, us2.Id});
    	PRAssignment prObj2 = new PRAssignment(helperObj, leadList);
		Id rcId = OpportunityHelper.getOppRecordTypeMap('Sales Opportunity');
		prObj2.cwObject = prObj2.getOwnerPerContact(leadList);
		Map<Id, Opportunity> activeOppMap = prObj2.getActiveOpportunities(leadList, rcId, prObj2.cwObject);
		Map<Id, Opportunity> closedOppMap = prObj2.getClosedOpportunities(leadList, rcId, prObj2.cwObject);
		Map<Id, Opportunity> downgradedOppMap = prObj2.getDowngradedOpportunities(leadList, rcId, prObj2.cwObject);
		prObj2.existingLeads = prObj2.getExistingLeads(leadList); 
		Map<Id, Opportunity> mostRecentOpps = new Map<Id, Opportunity>();
		/*mostRecentOpps.putAll(closedOppMap);
		mostRecentOpps.putAll(downgradedOppMap);
		Set<Id> ownerIds = prObj2.getOwnerIds(leadList, mostRecentOpps, prObj2.existingLeads, prObj2.cwObject);
		Map<Id, Integer> countMap = prObj2.getOppOwnerCount(ownerIds);
        LeadTriggerHelper.findCampaign(leadList); 
        Map<String, Campaign> campaignMap = LeadTriggerHelper.assignCampaignToLead(leadList);
		for(Lead leadObj : leadList) {
			String campaignName = campaignMap.get((String)leadObj.Primary_Campaign__c).Name;
        	prObj2.getOtherOwnerId(leadObj, closedOppMap, downgradedOppMap, prObj2.existingLeads, prObj2.cwObject);
        	prObj2.findOwnerId(leadObj, activeOppMap, closedOppMap, downgradedOppMap, prObj2.existingLeads
        	, prObj2.cwObject, countMap, campaignName);
		}*/
		/*mostRecentOpps.putAll(closedOppMap);
		mostRecentOpps.putAll(downgradedOppMap);
		Set<Id> ownerIds = prObj2.getOwnerIds(leadList, mostRecentOpps, prObj2.existingLeads, prObj2.cwObject);
		Map<Id, Integer> countMap = prObj2.getOppOwnerCount(ownerIds);
        Map<String, Campaign> campaignMap = LeadTriggerHelperExt.assignCampaigns(leadList);
		for(Lead leadObj : leadList) {
			if(campaignMap.get((String)leadObj.Primary_Campaign__c) != null){
				String campaignName = campaignMap.get((String)leadObj.Primary_Campaign__c).Name;			
	        	prObj2.getOtherOwnerId(leadObj, closedOppMap, downgradedOppMap, prObj2.existingLeads, prObj2.cwObject);
	        	prObj2.findOwnerId(leadObj, activeOppMap, closedOppMap, downgradedOppMap, prObj2.existingLeads
	        	, prObj2.cwObject, countMap, campaignName);
			}
		}  
    }*/
    
    public static testMethod void testLeadHighlight(){
    	Campaign campObj = new Campaign(Name='TestCampaign',Protected_Campaign__c=false, Description='This is test campaign'
            , Shared_Lead_Campaign__c=true, Lead_Creation_Score__c='200.00', IsActive=true, BMID__c='test01211' );
            insert campObj;
        Folder fd1 = [SELECT Id FROM Folder WHERE Name='LeadSourceMap' LIMIT 1];     
        String lMap = 'Lead Source,Lead Source Description,Lead Entry Source,Lead Entry Source Description,EOF\n\r'+
			'About To Be Cancelled,Customer whose account is about to be canceled due to expired credit card (US & Canada),ROI Form,Prospect completed the ROI Calculator on ringcentral.com,EOF';
        Blob blbObjNew = Blob.valueOf(lMap);    
        Document doc1 = new Document(Name='LeadSourceMap', Body=blbObjNew ,folderId=fd1.Id,isPublic=true,type='csv' );
        insert doc1;
            
		Folder fd = [SELECT Id FROM Folder WHERE Name='Public Documents' LIMIT 1]; // LeadSourceMap
        Blob blbObj = Blob.valueOf('Count of DOMAIN,DOMAIN,Total\n\r mauiplaycare.com,2');
        Document doc = new Document(Name='Frandata Franchise Executive List2', Body=blbObj ,folderId=fd.Id,isPublic=true,type='csv' );
        insert doc;
            
		try{
         	Lead objLead = new Lead();
         	objLead.email='test@shuttleexpress.com';
         	objLead.LastName = 'test10102014';
         	objLead.Email = 'test10102014@mauiplaycare.com';
         	objLead.Company = 'test10102014';
         	objLead.Phone = '9910102343';
         	objLead.Most_Recent_Campaign__c = campObj.id;
         	objLead.LeadSource = 'About To Be Cancelled';
         	objLead.BMID__c = 'test01211'; 
         	upsert objLead;
         	
         	ApexPages.StandardController controller = new ApexPages.StandardController(objLead);
         	Test.setCurrentPage(Page.LeadHighlighter);
         	ApexPages.currentPage().getParameters().put('id', objLead.id);
         	LeadHighlighter obj=new LeadHighlighter(controller);
     	} catch(Exception e){
     		system.debug('### ' + e.getMessage());
     	}
  	}
  
  static testMethod void leadBeforeTestMethod() {
			Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Lead; 
			Map<String,Schema.RecordTypeInfo> LeadRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
			Id rtId = LeadRecordTypeInfo.get('Partner Leads').getRecordTypeId(); 
			
			List<Campaign> campList = new List<Campaign>();
			
            Campaign campObj1 = new Campaign(Name='TestCampaign',Protected_Campaign__c=true
            , Shared_Lead_Campaign__c=true, Lead_Creation_Score__c='300', IsActive=true, AID__c='test0121' );
            //insert campObj1;
            campList.add(campObj1);
            Campaign campObj2 = new Campaign(Name='TestCampaign',Protected_Campaign__c=false
            , Shared_Lead_Campaign__c=true, Lead_Creation_Score__c='test', IsActive=true, DNIS__c='test0121' );
            //insert campObj2;
            campList.add(campObj2);
            Campaign campObj3 = new Campaign(Name='TestCampaign',Protected_Campaign__c=true
            , Shared_Lead_Campaign__c=true, Lead_Creation_Score__c='-200', IsActive=true, PID__c='test0121' );
            //insert campObj3;
            campList.add(campObj3);
            Campaign campObj4 = new Campaign(Name='TestCampaign',Protected_Campaign__c=false
            , Shared_Lead_Campaign__c=true, Lead_Creation_Score__c='200.00', IsActive=true, BMID__c='test0121' );
            //insert campObj4;
            campList.add(campObj4);
            Campaign campObj5 = new Campaign(Name='TestCampaign',Protected_Campaign__c=true
            , Shared_Lead_Campaign__c=true, IsActive=true, Lead_Entry_Source__c='ROI Form' );
            //insert campObj5;
            campList.add(campObj5);
            Campaign campObj6 = new Campaign(Name='Default Campaign', Shared_Lead_Campaign__c=true, Protected_Campaign__c=true, IsActive=true );
            //insert campObj6;
            campList.add(campObj6);
            Campaign campObj7 = new Campaign(Name='Partner Lead Campaign', Shared_Lead_Campaign__c=true, Protected_Campaign__c=true, IsActive=true );
            //insert campObj7;
            campList.add(campObj7);
            
            //List<Campaign> campList = new List<Campaign>();
	        
	        Campaign campObj8 = new Campaign(Name='Default Campaign',Protected_Campaign__c=true, IsActive=true );
	        campList.add(campObj8);	 
	        
	        Campaign campObj9 = new Campaign(Name='Default Campaign',Protected_Campaign__c=true, IsActive=true );	
			campList.add(campObj9);       
	        
	        Campaign campObj10 = new Campaign(Name='Default Campaign',Protected_Campaign__c=true, IsActive=true );
	        campList.add(campObj10);
	        
	        Campaign campObj11 = new Campaign(Name='Default Campaign',Protected_Campaign__c=true, IsActive=true );
	        campList.add(campObj11);	
	        
	        insert campList;	
            
            
            User user1 = new User(alias = 'newUser1', email='newuser1@simplion.com.test',
			emailencodingkey='UTF-8', lastname='Testing1', 
			languagelocalekey='en_US', localesidkey='en_US', profileid = Userinfo.getProfileId(),
			timezonesidkey='America/Los_Angeles', username= System.now().millisecond() + 'newuser1@simplion.com.test');
			insert user1;
            
            User user2 = new User(alias = 'newUser2', email='newuser2@simplion.com.test',
			emailencodingkey='UTF-8', lastname='Testing2', 
			languagelocalekey='en_US', localesidkey='en_US', profileid = Userinfo.getProfileId(),
			timezonesidkey='America/Los_Angeles', username= System.now().millisecond() + 'newuser2@simplion.com.test');
			insert user2;
			
			Skill__c s1= new Skill__c(Name='Skill1');
			insert s1;
			Skill__c s2= new Skill__c(Name='Skill2');
			insert s2;
			User_Skill__c us1 = new User_Skill__c (Name='us1', User__c=user1.Id, Skill__c=s1.Id);
			insert us1;
			User_Skill__c us2 = new User_Skill__c (Name='us2', User__c=user2.Id, Skill__c=s1.Id);
			insert us2;
            User_Skill__c us3 = new User_Skill__c (Name='us3', User__c=user1.Id, Skill__c=s2.Id);
			insert us3;
			
            Lead_Assignment_Rules__c lar1= new Lead_Assignment_Rules__c(Name='LAR1',Lead_Source__c='Inbaound Call', Folder__c='A;',Skill__c=s1.Id);
            Lead_Assignment_Rules__c lar2= new Lead_Assignment_Rules__c(Name='LAR1',Campaign__c=campObj1.Id,Skill__c=s2.Id);
            Lead_Assignment_Rules__c lar3= new Lead_Assignment_Rules__c(Name='LAR1',Campaign__c=campObj2.Id,Skill__c=s1.Id);
            Lead_Assignment_Rules__c lar4= new Lead_Assignment_Rules__c(Name='LAR1',Campaign__c=campObj3.Id,Skill__c=s2.Id);
            Lead_Assignment_Rules__c lar5= new Lead_Assignment_Rules__c(Name='LAR1',Campaign__c=campObj4.Id,Skill__c=s1.Id);
            Lead_Assignment_Rules__c lar6= new Lead_Assignment_Rules__c(Name='LAR1',Campaign__c=campObj5.Id,Skill__c=s2.Id);
            Lead_Assignment_Rules__c lar7= new Lead_Assignment_Rules__c(Name='LAR1',Lead_Source__c='Inbound Call',Skill__c=s1.Id);
            Lead_Assignment_Rules__c lar8= new Lead_Assignment_Rules__c(Name='LAR1',Lead_Source__c='Inbound Call',Skill__c=s2.Id);
            List<Lead_Assignment_Rules__c> larList = new List<Lead_Assignment_Rules__c>();
            larList.add(lar1);
            larList.add(lar2);
            larList.add(lar3);
            larList.add(lar4);
            larList.add(lar5);
            larList.add(lar6);
            larList.add(lar7);
            larList.add(lar8);
            insert larList;
            
            TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT();
			TriggerHandler.BY_PASS_ACCOUNT_ON_UPDATE();
			
			TriggerHandler.BY_PASS_CONTACT_ON_INSERT();
			TriggerHandler.BY_PASS_CONTACT_ON_UPDATE();
			
			TriggerHandler.BY_PASS_OPPORTUNITY_ON_INSERT();
			TriggerHandler.BY_PASS_OPPORTUNITY_ON_UPDATE();
            
            Folder fd = [SELECT Id FROM Folder WHERE Name='Lead Routing' LIMIT 1];
            Blob blbObj1 = Blob.valueOf('FIELD API NAME,LOOK INTO SHEET,OBJECT API NAME,OBJECT FIELD,SCORE RANGE,FOLDER,Status,EOLPrimary_Campaign__c,0,Campaign,Lead_Creation_Score__c,>=500,A,1. New A,EOLTitle,1,Lead,,300-499,B,1. New B,EOL,,,,0-299,C,1. New C,EOL,,,,<0,D,1. New D,EOL,,,,DEFAULT,C,,EOL');
            Document doc1 = new Document(Name='Lead Routing Criteria', Body=blbObj1 ,folderId=fd.Id,isPublic=true,type='csv' ); 
            insert doc1;
            Blob blbObj2 = Blob.valueOf('FIELDS,INCLUDE VALIUES,EXCLUDE VALUES,POINTS,EOLTitle,Director,,300,EOL,Owner,,300,EOL,President,,300,EOL,CEO,,300,EOL,CIO,,300,EOL,CFO,,300,EOL,Chief,,300,EOL,CTO,,300,EOL,VP,,300,EOL,Vice President,,300,EOLphone,,,200,EOLemail,,gmail.com,100,EOL,,yahoo.com,100,EOL,,hotmail.com,100,EOL,,aol.com,100,EOL,,comcast.net,100,EOL,,sbcglobal.net,100,EOL');
            Document doc2 = new Document(Name='Lead Routing Criteria Rules', Body=blbObj2 ,folderId=fd.Id,isPublic=true,type='csv' );
            insert doc2;
            
            Account accObj1 = new Account(Name='Simplion', Current_Owner__c=user2.Id, RC_User_ID__c='Test002',Type='Customer');
	    	insert accObj1;
	    	Contact contactObj1 = new Contact(firstName='Virendra1', indexedPhone__c='9910103404',indexedEmail__c='virendra.singhCon@simplion.com', lastname='Singh1', 
	    	account=accObj1, email='virendra.singhCon@simplion.com', phone='9910103404');
            insert contactObj1;
            
            Opportunity oppObj = new Opportunity();
            oppObj.name='Simplion';
            oppObj.accountid =accObj1.id;
            oppObj.type='New Business';
            oppObj.sales_model__c='Direct';
            oppObj.CloseDate = Date.Today();
            oppObj.StageName= OpportunityHelper.defaultOpportunityStage;
            insert oppObj;
            
            List<Lead> leadList = new List<Lead>();
            Lead leadObj1 = new Lead(firstName='Singh', Title='VP', Lead_Entry_Source__c='ROI Form', LeadSource='Initial', lastname = 'Virendra', 
            company='Simplion', email='virendra.singh@simplion.com', phone='9910106804');
            leadList.add(leadObj1);
            
            Lead leadObj2 = new Lead(firstName='Singh', Title='VP', AID__C='test0121', Referrer_RCUserID__c='Test002', 
            					LeadSource='About To Be Cancelled',User_ID__c='Test002', lastname = 'Virendra', 
            company='Simplion', email='virendra.singh1@simplion.com', phone='9910106805');
            leadList.add(leadObj2);
            
            Lead leadObj3 = new Lead(firstName='Singh', Title='VP', PID__c='test0121', NumberOfEmployees__c ='500+', LeadSource='Vista Print', lastname = 'Virendra', 
            company='Simplion', email='virendra.singh2@simplion.com', phone='(919)191-9128');
            leadList.add(leadObj3);
            
            Lead leadObj4 = new Lead(firstName='Singh', Title='VP', Country='UK', BMID__c='test0121',LeadSource='Solve then Sell',User_ID__c='Test002', lastname = 'Virendra', 
            company='Simplion', email='virendra.singh3@simplion.co.uk', phone='9910106803');
            leadList.add(leadObj4);
            
            Lead leadObj5 = new Lead(firstName='Singh', Title='VP', Five9_DNIS__c='test0121',NumberOfEmployees__c ='20-49', lastname = 'Virendra', 
            company='Simplion', email='virendra.singh4@simplion.com', phone='9910106808');
            leadList.add(leadObj5);
            
            Lead leadObj6 = new Lead(firstName='Singh', Title='VP', lastname = 'Virendra', 
            company='SimplionTest', email='virendra.singh5@simplion.com', phone='9910106809');
            leadList.add(leadObj6);
            
            Lead leadObj7 = new Lead(firstName='Singh', Title='VP', lastname = 'Virendra', LeadSource = 'Referral Programs',
            						Referrer_RCUserID__c='Test002', Sales_Agent_Email__c='newuser2@simplion.com.test', 
            						Referrer_Email__c='virendra.singhCon@simplion.com', 
            						company='SimplionTest', email='virendra.singh6@simplion.com', phone='9910106809');
            leadList.add(leadObj7);
            
            Lead leadObj8 = new Lead(firstName='Singh', Title='VP', lastname = 'Virendra', LeadSource='Inbound Call',
            				company='SimplionTest', email='virendra.singh8@simplion.com', recordTypeId=rtId, phone='9910106203');
            Lead leadObj9 = new Lead(firstName='Singh', Title='VP', lastname = 'Virendra', LeadSource='Inbound Call',
            				company='SimplionTest123', email='virendra.singh9@simplion.com', recordTypeId=rtId, phone='9910106293', Five9_DNIS__c='test0121');
            leadList.add(leadObj9); 
            insert leadList;
            
            leadObj9.Most_Recent_Campaign__c = campObj1.Id;
            update leadObj9;
            leadObj9.Most_Recent_Campaign__c = campObj2.Id;
            update leadObj9;
            
            
            Test.startTest();
            
            try {
            	LeadTriggerHelper.getLarWithSkills(false);
	            //LeadTriggerHelper.findCampaign(leadList);
            } catch(Exception e) {}
            try {
	            //LeadTriggerHelper.getDocuments(leadList);
	        } catch(Exception e) {}
	        try {
	            LeadTriggerHelper.findAccountMap(leadList);
	        } catch(Exception e) {}
            //Map<String, Campaign> campaignMap = LeadTriggerHelper.assignCampaignToLead(leadList);
            Map<String, Campaign> campaignMap = LeadTriggerHelperExt.assignCampaigns(leadList);
            LeadTriggerHelper helperObj = new LeadTriggerHelper();
            try {
           	//helperObj.getAccountsPerContacts(leadList); 
           	} catch(Exception e) {}
           	try {
           	//helperObj.getUsersPerAgentEmail(leadList);
           	} catch(Exception e) {}
           	try {
            //helperObj.getOwnerPerContact(leadList, '9910106809','9910106809');
            } catch(Exception e) {}
            Map<String, String> empToCustomerSizeMap = LeadTriggerHelper.getCustomerSize(leadList);
            Map<String, String> scoreToFolderMap = new Map<String, String>{'>=500'=>'A', '300-499'=>'B', '0-299'=>'C','<0'=>'D','DEFAULT'=>'C'};
            try {
	            //LeadTriggerHelper.calculateFolder(null, 0);
	            //LeadTriggerHelper.calculateFolder(scoreToFolderMap, -100);
	            //LeadTriggerHelper.calculateFolder(scoreToFolderMap, 110);
	            //LeadTriggerHelper.calculateFolder(scoreToFolderMap, 310);
	            //LeadTriggerHelper.calculateFolder(scoreToFolderMap, 600);
            } catch(Exception e) {}
            try {
            Map<String, String> folderToStatusMap = new Map<String, String>{'A'=>'1. New A', 'B'=>'1. New B', 'C'=>'1. New C', 'D'=>'1. New D'};
            //LeadTriggerHelper.calculateStatus(null, '');
            //LeadTriggerHelper.calculateStatus(folderToStatusMap, 'A');
            Map<String, Integer> fieldScore = new Map<String, Integer>{'Title'=>300,'email'=>200,'phone'=>100};
            
            Map<String, Set<String>> includeValuesMap = new Map<String, Set<String>>();
			Map<String, Set<String>> excludeValuesMap = new Map<String, Set<String>>();
			
            //LeadTriggerHelper.folderAssignment(leadList, fieldScore, includeValuesMap, excludeValuesMap, scoreToFolderMap, folderToStatusMap);
             } catch(Exception e) {}
            Map<Id, Skill__c> skillsMap = LeadTriggerHelper.getSkillsMap(new List<Id>{s1.id});
            Map<Id, List<User_Skill__c>> skillsToUserSkills =  LeadTriggerHelper.getSkillsToUserSkillsMap(new Set<Id>{s1.id});
            // LeadTriggerHelper.getUserSkillsPerLeadSource(leadObj, larList, skillsToUserSkills, finalSkillList, customerSize, skillsMap, finalSkillMap);
            
             Lead leadObj11 = new Lead(firstName='Singh', Title='VP', Country='UK', BMID__c='test0121'
             ,LeadSource='Initial', lastname = 'Virendra', 
            company='Simplion', email='virendra.singh3@simplion.co.uk', phone='9910106803');
            Lead leadObj12 = new Lead(firstName='Singh', Title='VP', Country='UK', BMID__c='test0121'
             ,LeadSource='About To Be Cancelled', lastname = 'Virendra', 
            company='Simplion', email='virendra.singh3@simplion.co.uk', phone='9910106803');
            Lead leadObj13 = new Lead(firstName='Singh', Title='VP', Country='UK', BMID__c='test0121'
             ,LeadSource='Vista Print', lastname = 'Virendra', 
            company='Simplion', email='virendra.singh3@simplion.co.uk', phone='9910106803');
            //LeadTriggerHelper.assignLeadSrource(new List<Lead>{leadObj11,leadObj12,leadObj13}); 
            LeadTriggerHelper.assignLeadSource(leadObj11);
            
            Lead leadObj14 = new Lead(firstName='Singh', status='X. Suspect',
            LeadSource='Inbound Call', lastname = 'Virendra', 
            company='Simplion', email='virendra.singh4@simplion.com', phone='9910106803');
            //LeadTriggerHelper.getNonSuspectLeads(new List<Lead>{leadObj14});
            
            List<User_Skill__c> allUserSkills = new List<User_Skill__c>();
            Map<Id, List<User_Skill__c>> larToUserSkillsMap = new Map<Id, List<User_Skill__c>>();
            List<Id> finalSkillList = new List<Id>();
            Map<Id, Skill__c> finalSkillMap = new Map<Id, Skill__c>(); 
            for(Lead leadObj : leadList) {
            	try {
	            	Campaign campaignObj = null;
	            	if(leadObj.Primary_Campaign__c != null) {
		            	campaignObj = campaignMap.get((String)leadObj.Primary_Campaign__c);
		            }
		            String customerSize = empToCustomerSizeMap.get(String.isBlank(leadObj.NumberOfEmployees__c) ? 'DEFAULT' : leadObj.NumberOfEmployees__c);
		            allUserSkills = LeadTriggerHelper.getUserSkillsPerCampaign(leadObj, campaignObj, larList, skillsToUserSkills, 
		            														finalSkillList, customerSize, skillsMap, finalSkillMap);
		            if(allUserSkills.size() == 0){
		            	allUserSkills = LeadTriggerHelper.getUserSkillsPerLeadSource(leadObj, larList, skillsToUserSkills, finalSkillList, 
		            														customerSize, skillsMap, finalSkillMap);
		            }
		            skillsMap = LeadTriggerHelper.assignLeadPerLAR(leadObj,finalSkillList,skillsMap,
								allUserSkills,	skillsToUserSkills );
			 	} catch(Exception e) {}
				LeadTriggerHelper.arrangePhoneNumber(leadObj);
            }
		 	//helperObj.getAccountsPerUserIds(leadList);
		 	LeadTriggerHelper.getLeadOwnerManager(leadList);
		 	LeadTriggerHelper.byPassTrgrsAtConvertLead();
		 	Test.stopTest();
	}
	
	static testMethod void testLeadHelperCustomSetting() {
		try {
			LeadName__c mycs = LeadName__c.getValues('First_Name__c');
		  	if(mycs == null) {
			    mycs = new LeadName__c();
			    mycs.First_Name__c = 'TestFName';
			    mycs.Last_Name__c = 'TestLName';
		    	mycs.Name = 'TestCustomSetting';
	    		insert mycs;
		  	}
			List<Lead> leadList = new List<Lead>();
            Lead leadObj1 = new Lead(firstName='TestFName', Title='VP', Lead_Entry_Source__c='ROI Form', LeadSource='Initial', lastname = 'TestLName', 
            company='Simplion', email='virendra.singh22@simplion.com', phone='9910106804');
            leadList.add(leadObj1);
            
            Lead leadObj2 = new Lead(firstName='Singh', Title='VP', AID__C='test0121', Referrer_RCUserID__c='Test002', 
            					LeadSource='About To Be Cancelled',User_ID__c='Test002', lastname = 'Virendra33', 
            company='Simplion', email='virendra.singh133@simplion.com', phone='9910106805');
            leadList.add(leadObj2);
            insert leadList;
            LeadTriggerHelper.getLeadOwnerRCSFsync(leadList);
		} catch(Exception ex) {}
	}
	
	static testMethod void testTestPRAssignment() {
		TestPRAssignment obj = new TestPRAssignment();
	}
}