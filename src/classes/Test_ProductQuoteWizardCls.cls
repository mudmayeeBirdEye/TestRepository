@isTest
private class Test_ProductQuoteWizardCls {
    static testMethod void myUnitTest() {
       try{
            Test_Utils utilObj = new Test_Utils();
            utilObj.initialiseTriggerBypass();
            TriggerHandler.BY_PASS_Approver_Trigger = true;
            Account acctest = new Account();
            acctest.Name = 'TestAccount';
            acctest.RC_Attribution_Channel__c = 'Sales Agents & Resellers';
            acctest.Partner_ID__c ='123';           
            acctest.Current_Owner__c = Userinfo.getUserId();
            acctest.RC_User_ID__c = 'test123';   
            insert acctest; 
            
            Contact conObj = new Contact();
            conObj.LastName = 'contactLast1';
            conObj.AccountId = acctest.Id;  
            conObj.email='test11@rc.com';
            conObj.Phone='1234567890';
            insert conObj;
            
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
            Oppval.Agent_Email_Address__c='test@test.com';
            Oppval.RC_User_ID__c = Userinfo.getUserId();
            oppval.OwnerId = Userinfo.getUserId();
            oppval.RecordTypeId = opportunityRecordTypeInfo.get('Sales Opportunity').getRecordTypeId();
            oppval.Probability = 50;
            oppval.X12_Month_Booking__c = 100;
            insert Oppval;          
            
            List<RC_Product__c> rcProductList = new List<RC_Product__c>();
            List<RC_Product_Line_Item__c> rcProductLineItemList = new List<RC_Product_Line_Item__c>();
            
            
            RC_Product__c objProduct1 = new RC_Product__c();
            objProduct1.Name ='Service1';
            objProduct1.Category__c = 'Service';
            objProduct1.Charge_Term__c = 'Annual';
            objProduct1.Service_Type__c = 'Office';
            objProduct1.SKU__c  = 'SKU1';
            objProduct1.Dependent_SKUs__c = 'SKU2';         
            rcProductList.add(objProduct1);
            
            RC_Product__c objProduct2 = new RC_Product__c();
            objProduct2.Name ='AddOn1';
            objProduct2.Category__c = 'Service';
            objProduct2.Charge_Term__c = 'Monthly';
            objProduct2.Service_Type__c = 'Office';
            objProduct2.Product_Type__c = 'DL';
            objProduct2.SKU__c  = 'SKU2'; 
            rcProductList.add(objProduct2);
            
            RC_Product__c objProduct3 = new RC_Product__c();
            objProduct3.Name ='AddOn1';
            objProduct3.Category__c = 'AddOn';
            objProduct3.Charge_Term__c = 'Annual';
            objProduct3.Service_Type__c = 'Office';
            objProduct3.SKU__c  = 'SKU3';
            objProduct3.Dependent_SKUs__c = 'SKU4';         
            rcProductList.add(objProduct3);
            
            RC_Product__c objProduct4 = new RC_Product__c();
            objProduct4.Name ='AddOn1';
            objProduct4.Category__c = 'AddOn';
            objProduct4.Charge_Term__c = 'Monthly';
            objProduct4.Service_Type__c = 'Office';
            objProduct4.Product_Type__c = 'DL';
            objProduct4.SKU__c  = 'SKU4';
            rcProductList.add(objProduct4);
            
            insert rcProductList;
            
            RC_Product_Line_Item__c objProductLinItm1 = new RC_Product_Line_Item__c();
            objProductLinItm1.Name = 'test1';
            objProductLinItm1.RC_Product__c= objProduct1.id;
            objProductLinItm1.Lower_Limit__c = 0;
            objProductLinItm1.Upper_Limit__c = 10;
            objProductLinItm1.Price__c = 10;
            objProductLinItm1.RC_Currency__c = 'USD';
            objProductLinItm1.isActive__c = true;
            objProductLinItm1.Allowed_Record_Type__c = 'Sales Opportunity';
            objProductLinItm1.Max_Discount__c = 1;          
            rcProductLineItemList.add(objProductLinItm1);
            
            RC_Product_Line_Item__c objProductLinItm2 = new RC_Product_Line_Item__c();
            objProductLinItm2.Name = 'test2';
            objProductLinItm2.RC_Product__c= objProduct2.id;
            objProductLinItm2.Lower_Limit__c = 0;
            objProductLinItm2.Upper_Limit__c = 10;
            objProductLinItm2.Price__c = 10;
            objProductLinItm2.RC_Currency__c = 'USD';
            objProductLinItm2.isActive__c = true;
            objProductLinItm2.Allowed_Record_Type__c = 'Sales Opportunity';
            objProductLinItm2.Max_Discount__c = 1;          
            rcProductLineItemList.add(objProductLinItm2);
            
            RC_Product_Line_Item__c objProductLinItm3 = new RC_Product_Line_Item__c();
            objProductLinItm3.Name = 'test3';
            objProductLinItm3.RC_Product__c= objProduct3.id;
            objProductLinItm3.Lower_Limit__c = 0;
            objProductLinItm3.Upper_Limit__c = 10;
            objProductLinItm3.Price__c = 10;
            objProductLinItm3.RC_Currency__c = 'USD';
            objProductLinItm3.isActive__c = true;
            objProductLinItm3.Allowed_Record_Type__c = 'Sales Opportunity';
            objProductLinItm3.Max_Discount__c = 1;          
            rcProductLineItemList.add(objProductLinItm3);
            
            RC_Product_Line_Item__c objProductLinItm4 = new RC_Product_Line_Item__c();
            objProductLinItm4.Name = 'test4';
            objProductLinItm4.RC_Product__c= objProduct4.id;
            objProductLinItm4.Lower_Limit__c = 0;
            objProductLinItm4.Upper_Limit__c = 10;
            objProductLinItm4.Price__c = 10;
            objProductLinItm4.RC_Currency__c = 'USD';
            objProductLinItm4.isActive__c = true;
            objProductLinItm4.Allowed_Record_Type__c = 'Sales Opportunity';
            objProductLinItm4.Max_Discount__c = 1;          
            rcProductLineItemList.add(objProductLinItm4);
            
            insert rcProductLineItemList;     
            
            /*******First Time when No product and No Quote at Oppotunity Level**********/
            
            ApexPages.currentPage().getParameters().put('oppid',Oppval.Id);   
            ApexPages.currentPage().getParameters().put('response','product'); 
            
            Test.startTest();
            	utilObj.initialiseTriggerBypass();
            	TriggerHandler.BY_PASS_Approver_Trigger = true;
                ProductQuoteWizardCls classobj = new ProductQuoteWizardCls();
                classobj.strProductFamily = 'Service'; 
                classobj.strChargeTerm = 'Annual';
                classobj.strServiceType = 'Office';
                classobj.strProductName = 'Service1';
                classobj.searchProduct();               
                classobj.productWrapperLst[0].bolSelectedProduct = true;                
                classobj.addToCart();
                classobj.parentProductId = objProduct1.Id;
                classobj.childProductId = objProduct1.Id;
                classObj.removeProduct();
                classobj.searchProduct();
                classobj.productWrapperLst[0].bolSelectedProduct = true;
                classobj.addToCart();
                classobj.getDiscountTypeOptns();                
                classobj.wrapperObjMap.get(objProduct1.Id)[0].discount = 2;
                classobj.wrapperObjMap.get(objProduct1.Id)[0].selectedDiscountType = 'USD';
                classobj.parentProductId = objProduct1.Id;
                classobj.childProductId = objProduct1.Id;
                classobj.onChageQuantity();             
                classobj.saveUpdateLineItems();
                classobj.quoteObj.Valid_Until_Date__c = system.today();
                classobj.quoteObj.Contact__c = conObj.Id;
                classobj.quoteObj.Start_Date__c = system.today();
                classobj.quoteObj.End_Date__c = system.today();
                classobj.quoteObj.Initial_Term__c = '12';
                classobj.quoteObj.Renewal_Term__c = '12';
                classobj.saveQuote();
                classObj.editQuote();
                classObj.cancelQuote();             
                classobj.quoteObj.Approved_Status__c = 'Required';              
                classObj.JustificationandDescription = 'test';
                classObj.createApproval();              
                classobj.convertToSales();
                classobj.validateQuote();
                classObj.redirectToOpportunity();
                classObj.redirectToAccount();
                classObj.redirectToApprover();
                classObj.generatePdf();
                classObj.resetSearchFilters();
                classObj.justificationCheckBeforeApproval();
                
                /*******Second Time When Primary Quote and Products Exists at Opportunity Level**********/
            
                //Test_Utils utilObj1 = new Test_Utils();
                //utilObj1.initialiseTriggerBypass();
                ApexPages.currentPage().getParameters().put('oppid',Oppval.Id);  
                ApexPages.currentPage().getParameters().put('quoteId',classobj.quoteObj.Id);   
                ApexPages.currentPage().getParameters().put('response','quote');
                
                ProductQuoteWizardCls classobj1 = new ProductQuoteWizardCls();
                classobj1.strProductFamily = 'AddOn'; 
                classobj1.strChargeTerm = 'Annual';
                classobj1.strServiceType = 'Office';
                classobj1.strProductName = 'AddOn1';
                classobj1.searchProduct();             
                classobj1.productWrapperLst[0].bolSelectedProduct = true;              
                classobj1.addToCart();
                classobj1.parentProductId = objProduct3.Id;
                classobj1.childProductId = objProduct3.Id;
                classObj1.removeProduct();
                classobj1.searchProduct();
                classobj1.productWrapperLst[0].bolSelectedProduct = true;
                classobj1.addToCart();
                classobj1.getDiscountTypeOptns();               
                classobj1.wrapperObjMap.get(objProduct3.Id)[0].discount = 2;
                classobj1.wrapperObjMap.get(objProduct3.Id)[0].selectedDiscountType = 'USD';
                classobj1.parentProductId = objProduct3.Id;
                classobj1.childProductId = objProduct3.Id;
                classobj1.onChageQuantity();                
                classobj1.saveUpdateLineItems();
                classobj1.quoteObj.Valid_Until_Date__c = system.today();
                classobj1.quoteObj.Contact__c = conObj.Id;
                classobj1.quoteObj.Start_Date__c = system.today();
                classobj1.quoteObj.End_Date__c = system.today();
                classobj1.quoteObj.Initial_Term__c = '12';
                classobj1.quoteObj.Renewal_Term__c = '12';
                classobj1.saveQuote();
                classObj1.editQuote();
                classObj1.cancelQuote();               
                classobj1.quoteObj.Approved_Status__c = 'Required';             
                classObj1.JustificationandDescription = 'test'; 
                
                ApexPages.currentPage().getParameters().put('oppid',Oppval.Id);   
                ApexPages.currentPage().getParameters().put('response','product'); 
                ApexPages.currentPage().getParameters().put('quoteId',classobj.quoteObj.Id);
                ProductQuoteWizardCls classobj2 = new ProductQuoteWizardCls();
                classObj2.saveUpdateLineItems();
                
                RC_Quote_Template__c rcQuoteTemplate = new RC_Quote_Template__c(Brand__c='test',type__c='test');
                insert rcQuoteTemplate;
                Test.stopTest();  
                utilObj.initialiseTriggerBypass();
                TriggerHandler.BY_PASS_Approver_Trigger = true;
                ApexPages.currentPage().getParameters().put('oppid',Oppval.Id);   
                ApexPages.currentPage().getParameters().put('response','quote');
                ApexPages.currentPage().getParameters().put('quoteId',''); 
                ProductQuoteWizardCls classobj3 = new ProductQuoteWizardCls();
                classobj3.saveQuote();
                classobj3.quoteObj.Approved_Status__c = 'Not Required';
                classobj3.validateQuote();
                classobj3.quoteObj.Quote_Type__c = 'test';
                //classObj3.generatePdf();              
        }catch(exception e){}
    }
}