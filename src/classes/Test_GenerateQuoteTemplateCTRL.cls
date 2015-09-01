@isTest
private class Test_GenerateQuoteTemplateCTRL {

    static testMethod void myUnitTest() {
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
            
            
            
            Merge_Fields_Mapping__c mc1 = new Merge_Fields_Mapping__c(name='Account',Display_Name__c='Account',Dependency__c='Opportunity',
                                                                Dependent_Relationship_Name__c='AccountId');
            Merge_Fields_Mapping__c mc2 = new Merge_Fields_Mapping__c(name='Contact',Display_Name__c='Contact',Dependency__c='RC_Quote__c',
                                                                Dependent_Relationship_Name__c='Contact__c');
            Merge_Fields_Mapping__c mc3 = new Merge_Fields_Mapping__c(name='Line_Item__c',Display_Name__c='Line Items',Dependency__c='RC_Quote__c',
                                                                Order_By__c='Order__c');
            Merge_Fields_Mapping__c mc4 = new Merge_Fields_Mapping__c(name='Opportunity',Display_Name__c='Opportunity',Dependency__c='RC_Quote__c',
                                                                Dependent_Relationship_Name__c='Opportunity__c');
            Merge_Fields_Mapping__c mc5 = new Merge_Fields_Mapping__c(name='RC_Product_Line_Item__c',Display_Name__c='RC Product Line Item',Dependency__c='Line_Item__c',
                                                                Dependent_Relationship_Name__c='RC_Product_Line_Item__c');
            Merge_Fields_Mapping__c mc6 = new Merge_Fields_Mapping__c(name='RC_Product__c',Display_Name__c='RC Product',Dependency__c='RC_Product_Line_Item__c',
                                                                Dependent_Relationship_Name__c='RC_Product__c');                                                    
            Merge_Fields_Mapping__c mc7 = new Merge_Fields_Mapping__c(name='RC_Quote__c',Display_Name__c='Quote');
            List<Merge_Fields_Mapping__c> mergeCustomSettingsList = new List<Merge_Fields_Mapping__c>{mc1,mc2,mc3,mc4,mc5,mc6,mc7};
            insert mergeCustomSettingsList;
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
            
            RC_Quote__c objQuote = new RC_Quote__c();
            objQuote.Agreement_Status__c = 'test';
            objQuote.Approved_Status__c = 'ets';
            objQuote.Contact__c = c.Id;
            insert objQuote;
                           
            RC_Quote_Template__c objRCQuoteTemplate = new RC_Quote_Template__c();
            objRCQuoteTemplate.Brand__c = 'RingCentral';
            objRCQuoteTemplate.Name = 'test';
            objRCQuoteTemplate.Description__c = 'test123';
            objRCQuoteTemplate.Type__c = 'test';
            objRCQuoteTemplate.RC_Quote__c = objQuote.Id;
            objRCQuoteTemplate.Opportunity__c = oppval.Id;
            
            insert objRCQuoteTemplate;
            
            TemplateSections__c objTS = new TemplateSections__c();
            objTS.Content_1__c = 'This 123 is my place where I can work {!Line_Item__c.Name} and to show the progress {!Line_Item__c.email}. so whats are your thoughts.';
            objTS.Content_2__c = 'This 123 is my place where I can work {!RC_Product_Line_Item__c.Name} and to show the progress {!RC_Product_Line_Item__c.email}. so whats are your thoughts.';
            objTS.Content_3__c = 'This 123 is my place where I can work {!RC_Product__c.Name} and to show the progress {!RC_Product__c.email}. so whats are your thoughts.';
            objTS.Content_4__c = 'This 123 is my place where I can work {!Contact.Name} and to show the progress {!Account.email}. so whats are your thoughts.';
            objTS.Content_5__c = 'This 123 is my place where I can work {!Opportunity.Name} and to show the progress {!RC_Quote__c.email}. so whats are your thoughts.';
            
            insert objTS;
            
            TemplateSections__c templateSecObj = new TemplateSections__c(Name='testSection',Content_1__c='testDatatestDatatestDatatestData',Description__c='testDescription');
            insert templateSecObj;
            
            TemplateSectionJunction__c objTSJ = new TemplateSectionJunction__c();
            objTSJ.Position__c =12.00;
            objTSJ.RC_Quote_Template__c = objRCQuoteTemplate.id;
            objTSJ.Template_Section__c = objTS.id;
            insert objTSJ;
            GenerateQuoteTemplateCTRL.strStaticCondition = '';
            GenerateQuoteTemplateCTRL.strStaticItem = '';
            GenerateQuoteTemplateCTRL.strStaticCondition = '';
            GenerateQuoteTemplateCTRL.strStaticTerm = '';
            ApexPages.currentPage().getParameters().put('quoteid',quoteObj.Id);
            ApexPages.currentPage().getParameters().put('opptyid',Oppval.Id);
            String previewId ='';
            string str ='hi';
            ApexPages.StandardController controller = new ApexPages.StandardController(objRCQuoteTemplate);
            GenerateQuoteTemplateCTRL objGQT = new GenerateQuoteTemplateCTRL(controller);
            objGQT.addTemplateSection();
            //objGQT.selectedSection ='a4AS0000000CcBeMAK';
            objGQT.selectedSection = templateSecObj.Id;
           
            //objGQT.prepareSectionList();
            objGQT.prepareDynamicPreview(previewId);
            objGQT.onPreview();
            objGQT.addTemplateSection();
            objGQT.saveTemplate();
            objGQT.deleteTemplateSection();   
            test.stopTest();
    }
}