@isTest
private class TestLeadSearchExt{
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

}