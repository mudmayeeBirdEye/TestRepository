@isTest 
    public class TestLeadQualificationVARPartner {
     static testMethod void myUnitTestPartnerLeadView() {
        try {
            Account acctest = new Account();
            acctest.Name='TestAccount';
            acctest.RC_Attribution_Channel__c='Sales Agents & Resellers';
            acctest.Partner_ID__c ='123';
            acctest.RecordTypeId  = '01280000000UERq';
            insert acctest;
            
            Test.startTest();     
            
            Contact contactObj = new Contact(); 
            contactObj.AccountId =  acctest.id;
            contactObj.Email = 'test123@test.com';
            contactObj.LastName = 'TestLast';
            insert contactObj;
            
         	Case caseObj = new Case();
         	caseObj.Partner_Lead_FirstName__c='test1';
         	caseObj.Partner_Lead_LastName__c ='test13';
         	caseObj.Partner_Lead_Phone__c = '498746455';
         	caseObj.Partner_Lead_Email__c  = 'abc@simplion.com';
         	caseObj.Partner_Lead_Title__c = 'Abcz';
         	caseObj.Partner_Lead_Phone_Alternate__c    ='409873636';
         	insert caseObj;
           
            Opportunity Oppval2 = new Opportunity();
            Oppval2.Name = 'Test Opp2';
            Oppval2.AccountId = acctest.Id;
            Oppval2.Type = 'Existing Business';
            Oppval2.StageName = '3. ActivePipe';
            Oppval2.Sales_Model__c = 'Direct';
            Oppval2.CloseDate = System.Today() + 10;
            Oppval2.CurrencyIsoCode = 'USD';
            Oppval2.Brand_Name__c= 'RingCentral';
            Oppval2.RecordTypeId = '01280000000UEtu';
            insert Oppval2;
            
            Test.stopTest();    
            
            Lead_Qualification__c leadQualObj1 = new Lead_Qualification__c();
            leadQualObj1.Account__c = acctest.id;
            leadQualObj1.CompanyInfo__c = 'test1';
            leadQualObj1.Decision_Maker_First_Name__c ='Test2';
            leadQualObj1.Decision_Maker_Email__c = 'sin@gmail.com';
            leadQualObj1.Explain_the_Lead_s_Need__c ='Old PBX/ Replace an outdated solution';
            leadQualObj1.Has_this_Lead_purchased_services_before__c='true';
            leadQualObj1.Have_copy_of_current_phone_bill__c ='true';
            leadQualObj1.How_many_phones_are_needed__c ='20-30';
            leadQualObj1.Internet_Download_Speed_in_kBps__c='56kbps';
            leadQualObj1.What_type_of_services_has_Lead_purchased__c='Managed Services';
            leadQualObj1.Timeframe__c ='3 to 6 months';
            leadQualObj1.When_will_contract_expire__c='Unknown';
            leadQualObj1.Decision_Maker_Business_Title__c='Lead';
            leadQualObj1.Decision_Maker_Alternate_Phone__c='67445678';
            insert leadQualObj1;
            
            Lead_Qualification__c leadQualObj = new Lead_Qualification__c();
            leadQualObj.Account__c = acctest.id;
            leadQualObj.CompanyInfo__c = 'test1';
            leadQualObj.Decision_Maker_First_Name__c ='Test2';
            leadQualObj.Decision_Maker_Email__c = 'sin@gmail.com';
            leadQualObj.Explain_the_Lead_s_Need__c ='Old PBX/ Replace an outdated solution';
            leadQualObj.Has_this_Lead_purchased_services_before__c='true';
            leadQualObj.Have_copy_of_current_phone_bill__c ='true';
            leadQualObj.How_many_phones_are_needed__c ='20-30';
            leadQualObj.Internet_Download_Speed_in_kBps__c='56kbps';
            leadQualObj.What_type_of_services_has_Lead_purchased__c='Managed Services';
            leadQualObj.Timeframe__c ='3 to 6 months';
            leadQualObj.When_will_contract_expire__c='Unknown';
            leadQualObj.Decision_Maker_Business_Title__c='Lead';
            leadQualObj.Decision_Maker_Alternate_Phone__c='67445678';
            insert leadQualObj;
            
            Lead leadObj = new Lead(FirstName= 'AbcTest',LastName='Last11', Company='Company11', Phone='34556221', Email='lead@triggertest11.com');
            insert leadObj;
            
            Lead_Qualification__c leadQualObj2 = new Lead_Qualification__c();
            leadQualObj2.Account__c = acctest.id;
            leadQualObj2.CompanyInfo__c = 'test1';
            leadQualObj2.Decision_Maker_First_Name__c ='Test2';
            leadQualObj2.Decision_Maker_Email__c = 'sin@gmail.com';
            leadQualObj2.Explain_the_Lead_s_Need__c ='Old PBX/ Replace an outdated solution';
            leadQualObj2.Has_this_Lead_purchased_services_before__c='true';
            leadQualObj2.Have_copy_of_current_phone_bill__c ='true';
            leadQualObj2.How_many_phones_are_needed__c ='20-30';
            leadQualObj2.Internet_Download_Speed_in_kBps__c='56kbps';
            leadQualObj2.What_type_of_services_has_Lead_purchased__c='Managed Services';
            leadQualObj2.Timeframe__c ='3 to 6 months';
            leadQualObj2.When_will_contract_expire__c='Unknown';
            leadQualObj2.Decision_Maker_Business_Title__c='Lead';
            leadQualObj1.Decision_Maker_Alternate_Phone__c='67445678';
            insert leadQualObj2;
        
            ApexPages.currentPage().getParameters().put('Id','strId');
            Apexpages.currentPage().getParameters().put('retURL','rtrl');
            
                   
            ApexPages.currentPage().getParameters().put('Id',Oppval2.id);             
            LeadQualificationViewpartner leadQualView = new LeadQualificationViewpartner();
            ApexPages.currentPage().getParameters().put('param1',leadQualObj.id);
            leadQualView.loadLeadQualDet();
            leadQualView.Cancel();
            leadQualView.loadupdatedLeadQual();
            leadQualView.getLeadQualList();
            leadQualView.getHasPurchasedBefore();
            leadQualView.getIsUnderContract();
            leadQualView.getHavePhoneBill();
            leadQualView.getDecisionMaker();
            leadQualView.updateLeadQual();
            leadQualView.getContactInfo();
            leadQualView.loadLeadQualBasicDet();                         
            leadQualView.isValidEmail('true'); 
            leadQualView.clearPickListValue(); 
            leadQualView.isEmpty('')  ;                                                    
            leadQualView.backToDetail();
                                   
            ApexPages.currentPage().getParameters().put('Id',acctest.id);
            ApexPages.currentPage().getParameters().put('retURL',ApexPages.currentPage().getUrl());
            LeadQualificationViewpartner leadQualView1 = new LeadQualificationViewpartner();
            leadQualView1.editLeadQualDet();
            leadQualView1.Cancel();
            leadQualView1.loadupdatedLeadQual();
            leadQualView1.updateLeadQual();
            leadQualView1.getLeadQualList();
            leadQualView1.getHasPurchasedBefore();
            leadQualView1.getIsUnderContract();
            leadQualView1.getHavePhoneBill();
            leadQualView1.getDecisionMaker();
            leadQualView1.getContactInfo();  
            leadQualView1.loadLeadQualBasicDet();             
            leadQualView1.isValidEmail('true');  
            leadQualView1.clearPickListValue();
            leadQualView1.isEmpty('')  ;    
            leadQualView1.backToDetail();            
            
            ApexPages.currentPage().getParameters().put('Id',leadObj.id);
            ApexPages.currentPage().getParameters().put('retURL',ApexPages.currentPage().getUrl());
            LeadQualificationViewpartner leadQualView2 = new LeadQualificationViewpartner();
            leadQualView2.editLeadQualDet();
            leadQualView2.Cancel();
            leadQualView2.loadupdatedLeadQual();
            leadQualView2.getLeadQualList();
            leadQualView2.getHasPurchasedBefore();
            leadQualView2.getIsUnderContract();
            leadQualView2.getHavePhoneBill();
            leadQualView2.getDecisionMaker();
            leadQualView2.updateLeadQual();
            leadQualView2.getContactInfo();
            leadQualView2.loadLeadQualBasicDet();                                       
            leadQualView2.isValidEmail('true'); 
            leadQualView2.clearPickListValue();  
            leadQualView2.isEmpty('')  ;                                                              
            leadQualView2.backToDetail();                 
            
            ApexPages.currentPage().getParameters().put('Id',caseObj.id);
            ApexPages.currentPage().getParameters().put('retURL',ApexPages.currentPage().getUrl());
            LeadQualificationViewpartner leadQualView22 = new LeadQualificationViewpartner();
            leadQualView22.editLeadQualDet();
            leadQualView22.Cancel();
            leadQualView22.loadupdatedLeadQual();
            leadQualView22.getLeadQualList();
            leadQualView22.getHasPurchasedBefore();
            leadQualView22.getIsUnderContract();
            leadQualView22.getHavePhoneBill();
            leadQualView22.getDecisionMaker();
            leadQualView22.updateLeadQual();
            leadQualView22.getContactInfo();
            leadQualView22.loadLeadQualBasicDet();                                       
            leadQualView22.isValidEmail('true'); 
            leadQualView22.clearPickListValue();  
            leadQualView22.isEmpty('')  ;                                                              
            leadQualView22.backToDetail();  
            
            ApexPages.currentPage().getParameters().put('Id',contactObj.id);
            ApexPages.currentPage().getParameters().put('retURL',ApexPages.currentPage().getUrl());
            LeadQualificationViewpartner leadQualView23 = new LeadQualificationViewpartner();
            leadQualView23.editLeadQualDet();
            leadQualView23.Cancel();
            leadQualView23.loadupdatedLeadQual();
            leadQualView23.getLeadQualList();
            leadQualView23.getHasPurchasedBefore();
            leadQualView23.getIsUnderContract();
            leadQualView23.getHavePhoneBill();
            leadQualView23.getDecisionMaker();
            leadQualView23.updateLeadQual();
            leadQualView23.getContactInfo();
            leadQualView23.loadLeadQualBasicDet();                                       
            leadQualView23.isValidEmail('true'); 
            leadQualView23.clearPickListValue();  
            leadQualView23.isEmpty('')  ;                                                              
            leadQualView23.backToDetail();  
             
            ApexPages.currentPage().getParameters().put('Id',leadQualObj.id);
            ApexPages.currentPage().getParameters().put('retURL',ApexPages.currentPage().getUrl());
            LeadQualificationViewpartner leadQualView24 = new LeadQualificationViewpartner();
            leadQualView24.editLeadQualDet();
            leadQualView24.Cancel();
            leadQualView24.loadupdatedLeadQual();
            leadQualView24.getLeadQualList();
            leadQualView24.getHasPurchasedBefore();
            leadQualView24.getIsUnderContract();
            leadQualView24.getHavePhoneBill();
            leadQualView24.getDecisionMaker();
            leadQualView24.updateLeadQual();
            leadQualView24.getContactInfo();
            leadQualView24.loadLeadQualBasicDet();                                       
            leadQualView24.isValidEmail('true'); 
            leadQualView24.clearPickListValue();  
            leadQualView24.isEmpty('')  ;                                                              
            leadQualView2.backToDetail();  
             
             
             
        } catch(Exception ex) {}
    }
}