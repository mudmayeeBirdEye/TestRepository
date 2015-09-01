@isTest
private class Test_ViewTemplateHelper {

    static testMethod void TestViewTemplateHelper() {
        
        TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT = true;
        TriggerHandler.BY_PASS_ACCOUNT_ON_UPDATE = true;
        TriggerHandler.BY_PASS_CASE_ON_INSERT = true;
        TriggerHandler.BY_PASS_CASE_ON_UPDATE = true;
        TriggerHandler.BY_PASS_OPPORTUNITY_ON_INSERT = true;
        TriggerHandler.BY_PASS_OPPORTUNITY_ON_UPDATE = true;
        TriggerHandler.BY_PASS_CONTACT_ON_INSERT = true;
        TriggerHandler.BY_PASS_CONTACT_ON_UPDATE = true;
        
        Account acctest = new Account();
        acctest.Name = 'TestAccount';
        acctest.RC_Attribution_Channel__c = 'Sales Agents & Resellers';
        acctest.Partner_ID__c ='123';
        acctest.Current_Owner__c = Userinfo.getUserId();
        acctest.RC_User_ID__c = 'test123';
        insert acctest;
        
        Test.startTest();  
        
        Contact c = new Contact();
        c.LastName = 'contactLast1';
        c.AccountId = acctest.Id;   //[SELECT id FROM Account WHERE name=: acctest.Name].id;
        c.email='test11@rc.com';
        c.Phone='1234567890';
        insert c; 
        
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Opportunity; 
        Map<String,Schema.RecordTypeInfo> opportunityRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
        
        Opportunity Oppval = new Opportunity();
        Oppval.Name = 'Test Opp';
        Oppval.AccountId = acctest.Id;
        Oppval.Type = 'Existing Business';
        Oppval.StageName = '3. ActivePipe';
        Oppval.Sales_Model__c = 'Direct';
        Oppval.CloseDate = System.Today() + 10;
        Oppval.CurrencyIsoCode = 'USD';
        Oppval.Brand_Name__c= 'RingCentral';
       // Oppval.RecordTypeId = '01280000000UEtz';
        Oppval.RecordTypeId = opportunityRecordTypeInfo.get('Sales Opportunity').getRecordTypeId();
        Oppval.Agent_Email_Address__c='test@test.com';
        Oppval.RC_User_ID__c = Userinfo.getUserId();
        oppval.OwnerId = Userinfo.getUserId();
        insert Oppval;
        
        Quote quoteObj = new Quote();
        quoteObj.OpportunityId = Oppval.id;
        quoteObj.Account__c = acctest.id;
        quoteObj.Name = 'Test Quote';
        quoteObj.Status = 'Draft';
        insert quoteObj;
        
        RC_Quote_Template__c objRCQuoteTemplate = new RC_Quote_Template__c();
        objRCQuoteTemplate.Brand__c = 'RingCentral';
        insert objRCQuoteTemplate;
        
        ApexPages.currentPage().getParameters().put('quoteid',quoteObj.Id);
        ApexPages.currentPage().getParameters().put('opptyid',Oppval.Id);
        
        ApexPages.StandardController controller = new ApexPages.StandardController(objRCQuoteTemplate);
        ViewTemplateHelper objVTH = new ViewTemplateHelper(controller);
        objVTH.attachContent();
        test.stopTest();
      
    }
}