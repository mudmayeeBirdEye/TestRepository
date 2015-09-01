/**
 * This class contains unit tests for validating the behavior of Apex class 'GeneratePdfController'.
 * 
 */
@isTest
private class GeneratePdfControllerTest {

    /*static testMethod void generatePdfControllerMethod() {
        List<zqu__Quote__c> qList = new List<zqu__Quote__c>();
        Test.startTest();
        Account acctest12 = new Account();
        acctest12.Name='TestAccount12';
        acctest12.RC_Attribution_Channel__c = 'National Accounts';
        acctest12.Partner_ID__c ='123';
        acctest12.RecordTypeId  = '01280000000UERq';
        TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT();
        insert acctest12;
        Contact objContact= new Contact(FirstName='Test', LastName='Contact', Phone='9910101023');
        objContact.AccountId=acctest12.id;
        objContact.email='rajesh.kumar@simplion.com';
        TriggerHandler.BY_PASS_CONTACT_ON_INSERT();
        insert objContact; 
        Opportunity Oppval12 = new Opportunity();
        Oppval12.Name = 'Test Opp12';
        Oppval12.AccountId = acctest12.Id;
        Oppval12.Type = 'Existing Business';
        Oppval12.StageName = '3. ActivePipe';
        Oppval12.Sales_Model__c = 'Direct';
        Oppval12.CloseDate = System.Today() + 10;
        Oppval12.CurrencyIsoCode = 'USD';
        Oppval12.Brand_Name__c= 'RingCentral';
        Oppval12.RecordTypeId = '01280000000UEtu';
        TriggerHandler.BY_PASS_OPPORTUNITY_ON_INSERT();
        insert Oppval12;
        system.debug('@@@@@@@@@ opp Brand_Name__c '+Oppval12.Brand_Name__c);
        system.debug('@@@@@@@@@ opp ID '+Oppval12.Id);
        zqu__Quote__c qobj = new zqu__Quote__c();
        qobj.Name ='Test Name12';
        qobj.zqu__Opportunity__c = Oppval12.id;
        qobj.QuoteType__c= 'Quote';
        qList.add(qobj);
        insert qList; 
        system.debug('@@@@@@@@@ '+qobj.id);
        system.debug('@@@@@@@@@ quote Brand_Name__c '+qobj.Brand_Name__c);
        //qList = [SELECT id,Brand_Name__c,QuoteType__c FROM zqu__Quote__c limit 5];
        string sfSession = userInfo.getSessionId();     
        PageReference pageRef = Page.QuotePdf;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('SURL', 'https://cs30.salesforce.com/services/Soap/u/10.0/00Dn0000000Cq4Q');
        ApexPages.currentPage().getParameters().put('SID',sfSession);
        ApexPages.currentPage().getParameters().put('QID',qList[0].id);
        ApexPages.currentPage().getParameters().put('brand','US');
        ApexPages.currentPage().getParameters().put('Qtype',qList[0].QuoteType__c);
        GeneratePdfController controllers = new GeneratePdfController();
        controllers.strSessionId = 'kjasdfo123943-2';
        controllers.confirm();
        
        ApexPages.currentPage().getParameters().put('SURL', 'https://cs30.salesforce.com/services/Soap/u/10.0/00Dn0000000Cq4Q');
        ApexPages.currentPage().getParameters().put('SID',sfSession);
        ApexPages.currentPage().getParameters().put('QID',qList[0].id);
        ApexPages.currentPage().getParameters().put('brand','');
        ApexPages.currentPage().getParameters().put('Qtype','');
        GeneratePdfController controllers1 = new GeneratePdfController();
        controllers1.strSessionId = 'kjasdfo123943-2';
        controllers1.confirm();
        test.stopTest();
        
    }*/
}