@isTest
public with sharing class TestNote{
    
    static testMethod void testNotes() {
 
        Profile p = [select id from profile where name='Channel Sales Manager'];  
        User testUser = new User(alias = 'st22', email='standarduserTest22@testorg.com', emailencodingkey='UTF-8', lastname='Testing22', languagelocalekey='en_US',  
        localesidkey='en_US', profileid = p.Id,  timezonesidkey='America/Los_Angeles', username='standarduserTest22@testorg.com'); 
        insert testUser;
        
        System.runAs(testUser) {
                    
                
            Account acctest = new Account();
            acctest.Name = 'TestAccount122';
            acctest.RC_Attribution_Channel__c = 'Sales Agents & Resellers';
            acctest.Partner_ID__c ='123';
            acctest.RecordTypeId  = '01280000000UERq';
            insert acctest;
                    
            Contact contactObj = new Contact();
            contactObj.AccountId =  acctest.id;
            contactObj.Email = 'virendra.singh33@simplion.com';
            contactObj.LastName = 'TestLast';
            insert contactObj;
                    
            Opportunity OppObj = new Opportunity();
            OppObj.Name = 'Test Opp';
            OppObj.AccountId = acctest.Id;
            OppObj.Type = 'Existing Business';
            OppObj.StageName = '3. Qualified';
            OppObj.Sales_Model__c = 'Direct';
            OppObj.CloseDate = System.Today() + 10;
            OppObj.CurrencyIsoCode = 'USD';
            OppObj.Brand_Name__c= 'RingCentral';
            OppObj.RecordTypeId = '01280000000UEtz';
            OppObj.Proposal_Expiration_Date__c = System.today() + 100;
            insert OppObj;
            
            Lead leadObj = new Lead();
            leadObj.FirstName='Virendra22';
            leadObj.LastName='Singh12';
            leadObj.Company='Simplion212';
            leadObj.Email='virendra.singheee@simplion.com';
            leadObj.Phone='9910106801';
            leadObj.LeadSource = 'Inbound Call';
            leadObj.Notes__c = 'Test Notes'; 
            leadObj.Website = 'http://test.com';
            leadObj.NumberOfEmployees = 123;
            leadObj.Industry = 'Test';
            leadObj.NumberOfEmployees__c = '2-19';
            leadObj.Number_of_Locations__c = '2-4';
            leadObj.Agent_Email_Address__c = 'test@test.com';            
            insert leadObj;                            
            
            list<Note> lNoteObj = new list<Note>();
            
            Note noteObj = new Note();
            noteObj.ParentId = leadObj.id;
            noteObj.Body = 'test';
            noteObj.Title= 'Original note from lead';
            lNoteObj.add(noteObj);
            
            Note noteObj2 = new Note();
            noteObj2.ParentId = OppObj.id;
            noteObj2.Body = 'test';
            noteObj2.Title= 'Original note from Opp';
            lNoteObj.add(noteObj2);
            
            insert lNoteObj;
            delete lNoteObj;
        }
            
    }
  

}