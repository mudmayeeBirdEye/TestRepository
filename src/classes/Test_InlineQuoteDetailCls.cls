@isTest
private class Test_InlineQuoteDetailCls {

    static testMethod void TestInlineQuoteDetailCl() {
    	
    	try{
    		Test_Utils utilObj = new Test_Utils();
        
	        Account acctest = new Account();
	        acctest.Name = 'TestAccount';
	        acctest.RC_Attribution_Channel__c = 'Sales Agents & Resellers';
	        acctest.Partner_ID__c ='123';
	        //acctest.RecordTypeId  = '01280000000UERq';
	        acctest.Current_Owner__c = Userinfo.getUserId();
	        acctest.RC_User_ID__c = 'test123';
	        insert acctest;
	        
	        
	        Contact c = new Contact();
	        c.LastName = 'contactLast1';
	        c.AccountId = acctest.Id;   //[SELECT id FROM Account WHERE name=: acctest.Name].id;
	        c.email='test11@rc.com';
	        c.Phone='1234567890';
	        insert c;
	        
	        List<Opportunity> OpportunityObjList = new List<Opportunity>();
	        Opportunity Oppval1 = new Opportunity();
	        Oppval1.Name = 'Test Opp';
	        Oppval1.AccountId = acctest.Id;
	        Oppval1.Type = 'Existing Business';
	        Oppval1.StageName = '3. ActivePipe';
	        Oppval1.Sales_Model__c = 'Direct';
	        Oppval1.CloseDate = System.Today() + 10;
	        Oppval1.CurrencyIsoCode = 'USD';
	        Oppval1.Brand_Name__c= 'RingCentral';
	        Oppval1.Agent_Email_Address__c='test@test.com';
	        Oppval1.RC_User_ID__c = Userinfo.getUserId();
	        oppval1.OwnerId = Userinfo.getUserId();
	        oppval1.Total_MRR__c = 50;
	        Oppval1.X12_Month_Booking__c =50;
	        Oppval1.Total_Initial_Amount__c= 60;
	        OpportunityObjList.add(Oppval1);
	        
	         Opportunity Oppval1Obj  = new Opportunity();
	        Oppval1Obj.Name = 'Test Opp';
	        Oppval1Obj.AccountId = acctest.Id;
	        Oppval1Obj.Type = 'Existing Business';
	        Oppval1Obj.StageName = '3. ActivePipe';
	        Oppval1Obj.Sales_Model__c = 'Direct';
	        Oppval1Obj.CloseDate = System.Today() + 10;
	        Oppval1Obj.CurrencyIsoCode = 'USD';
	        Oppval1Obj.Brand_Name__c= 'RingCentral';
	        Oppval1Obj.Agent_Email_Address__c='test@test.com';
	        Oppval1Obj.RC_User_ID__c = Userinfo.getUserId();
	        Oppval1Obj.OwnerId = Userinfo.getUserId();
	        Oppval1Obj.Total_MRR__c = 50;
	        Oppval1Obj.X12_Month_Booking__c =50;
	        Oppval1Obj.Total_Initial_Amount__c= 60;
	         OpportunityObjList.add(Oppval1Obj);
	         insert OpportunityObjList;
	        
	        List<RC_Quote__c> lstRCQ = new List<RC_Quote__c>();
	        RC_Quote__c objQuote1 = new RC_Quote__c();
	        objQuote1.Agreement_Status__c = 'test';
	        objQuote1.Approved_Status__c = 'tets';
	      	objQuote1.Total_Initial_Amount__c = 550;
	      	objQuote1.Approved_Status__c ='Approved';
	        objQuote1.Total_12M_Amount__c =550;
	        objQuote1.Contact__c = c.Id;
	        objQuote1.Initial_Term__c = '24';
	        objQuote1.Valid_Until_Date__c = date.newInstance(2014, 4, 14);
	        objQuote1.Renewal_Term__c ='24';
	        objQuote1.Quote_Type__c = 'Quote';
	        objQuote1.Opportunity__c = OpportunityObjList[0].Id;
	        objQuote1.IsPrimary__c = false;
	        objQuote1.Initial_Term__c = 'test';
	        objQuote1.Total_MRR__c =20;
	        lstRCQ.add(objQuote1);
	       
	        
	        RC_Quote__c objQuote12 = new RC_Quote__c();
	        objQuote12.Agreement_Status__c = 'test1';
	        objQuote12.Approved_Status__c = 'tets1';
	      	objQuote12.Total_Initial_Amount__c = 550;
	      	objQuote12.Approved_Status__c ='Approved';
	        objQuote1.Total_12M_Amount__c =550;
	        objQuote12.Contact__c = c.Id;
	        objQuote12.Initial_Term__c = '24';
	        objQuote12.Valid_Until_Date__c = date.newInstance(2014, 4, 14);
	        objQuote12.Renewal_Term__c ='24';
	        objQuote12.Quote_Type__c = 'Quote';
	        objQuote12.Opportunity__c = OpportunityObjList[1].Id;
	        objQuote12.IsPrimary__c = false;
	        objQuote12.Initial_Term__c = 'test1';
	        objQuote12.Total_MRR__c =20;
	        lstRCQ.add(objQuote12);
	        upsert lstRCQ;
	        
	         RC_Product__c objProct1 = new RC_Product__c();
	         objProct1.Name ='Office Enterprise - Annua12l';
	         objProct1.SKU__c  = 'OF_ENT_AN12';
	         insert objProct1;
	          
	         RC_Product_Line_Item__c objProductLinItm1 = new RC_Product_Line_Item__c();
	         objProductLinItm1.Name = 'test1';
	         objProductLinItm1.RC_Product__c= objProct1.id;
	         insert objProductLinItm1;
	         
	         Line_Item__c objLIC = new Line_Item__c();
	         objLIC.Opportunity__c = OpportunityObjList[0].Id;
	         objLIC.Order__c = 12.00;
	         objLIC.RC_Product_Line_Item__c = objProductLinItm1.Id;
	         insert objLIC; 
	         
	         ApexPages.StandardController controller1 = new ApexPages.StandardController(OpportunityObjList[0]);
	         InlineQuoteDetailCls objIQD1 = new InlineQuoteDetailCls(controller1);
	         lstRCQ[0].IsPrimary__c = true;
	         lstRCQ[1].IsPrimary__c = true;
	         
	         lstRCQ[0].Opportunity__c = OpportunityObjList[0].id;
	         lstRCQ[1].Opportunity__c = OpportunityObjList[0].id;
	         
	         update lstRCQ;
	         ApexPages.StandardController controller2 = new ApexPages.StandardController(OpportunityObjList[0]);
	         objIQD1 = new InlineQuoteDetailCls(controller2);
	         
	         lstRCQ[0].IsPrimary__c = false;
	         lstRCQ[1].IsPrimary__c = false;
	         
	         lstRCQ[0].Opportunity__c = OpportunityObjList[1].id;
	         lstRCQ[1].Opportunity__c = OpportunityObjList[1].id;
	         
	         update lstRCQ;
	         ApexPages.StandardController controller3 = new ApexPages.StandardController(OpportunityObjList[1]);
	         objIQD1 = new InlineQuoteDetailCls(controller3);
    	}catch(Exception Ex){}
    	
    }
   static testMethod void TestInlineQuoteDetailCl1() {
    	
    	try{
    		Test_Utils utilObj = new Test_Utils();
        
	        Account acctest = new Account();
	        acctest.Name = 'TestAccount';
	        acctest.RC_Attribution_Channel__c = 'Sales Agents & Resellers';
	        acctest.Partner_ID__c ='123';
	        //acctest.RecordTypeId  = '01280000000UERq';
	        acctest.Current_Owner__c = Userinfo.getUserId();
	        acctest.RC_User_ID__c = 'test123';
	        insert acctest;
	        
	        
	        Contact c = new Contact();
	        c.LastName = 'contactLast1';
	        c.AccountId = acctest.Id;   //[SELECT id FROM Account WHERE name=: acctest.Name].id;
	        c.email='test11@rc.com';
	        c.Phone='1234567890';
	        insert c;
	        
	        List<Opportunity> OpportunityObjList = new List<Opportunity>();
	        Opportunity Oppval1 = new Opportunity();
	        Oppval1.Name = 'Test Opp';
	        Oppval1.AccountId = acctest.Id;
	        Oppval1.Type = 'Existing Business';
	        Oppval1.StageName = '3. ActivePipe';
	        Oppval1.Sales_Model__c = 'Direct';
	        Oppval1.CloseDate = System.Today() + 10;
	        Oppval1.CurrencyIsoCode = 'USD';
	        Oppval1.Brand_Name__c= 'RingCentral';
	        Oppval1.Agent_Email_Address__c='test@test.com';
	        Oppval1.RC_User_ID__c = Userinfo.getUserId();
	        oppval1.OwnerId = Userinfo.getUserId();
	        oppval1.Total_MRR__c = 50;
	        Oppval1.X12_Month_Booking__c =50;
	        Oppval1.Total_Initial_Amount__c= 60;
	        OpportunityObjList.add(Oppval1);
	        
	         Opportunity Oppval1Obj  = new Opportunity();
	        Oppval1Obj.Name = 'Test Opp';
	        Oppval1Obj.AccountId = acctest.Id;
	        Oppval1Obj.Type = 'Existing Business';
	        Oppval1Obj.StageName = '3. ActivePipe';
	        Oppval1Obj.Sales_Model__c = 'Direct';
	        Oppval1Obj.CloseDate = System.Today() + 10;
	        Oppval1Obj.CurrencyIsoCode = 'USD';
	        Oppval1Obj.Brand_Name__c= 'RingCentral';
	        Oppval1Obj.Agent_Email_Address__c='test@test.com';
	        Oppval1Obj.RC_User_ID__c = Userinfo.getUserId();
	        Oppval1Obj.OwnerId = Userinfo.getUserId();
	        Oppval1Obj.Total_MRR__c = 50;
	        Oppval1Obj.X12_Month_Booking__c =50;
	        Oppval1Obj.Total_Initial_Amount__c= 60;
	         OpportunityObjList.add(Oppval1Obj);
	         insert OpportunityObjList;
	        
	        List<RC_Quote__c> lstRCQ = new List<RC_Quote__c>();
	        RC_Quote__c objQuote1 = new RC_Quote__c();
	        objQuote1.Agreement_Status__c = 'test';
	        objQuote1.Approved_Status__c = 'tets';
	      	objQuote1.Total_Initial_Amount__c = 550;
	      	objQuote1.Approved_Status__c ='Approved';
	        objQuote1.Total_12M_Amount__c =550;
	        objQuote1.Contact__c = c.Id;
	        objQuote1.Initial_Term__c = '24';
	        objQuote1.Valid_Until_Date__c = date.newInstance(2014, 4, 14);
	        objQuote1.Renewal_Term__c ='24';
	        objQuote1.Quote_Type__c = 'Agreement';
	        objQuote1.Opportunity__c = OpportunityObjList[0].Id;
	        objQuote1.IsPrimary__c = false;
	        objQuote1.Initial_Term__c = 'test';
	        objQuote1.Total_MRR__c =20;
	        lstRCQ.add(objQuote1);
	       
	        
	        RC_Quote__c objQuote12 = new RC_Quote__c();
	        objQuote12.Agreement_Status__c = 'test1';
	        objQuote12.Approved_Status__c = 'tets1';
	      	objQuote12.Total_Initial_Amount__c = 550;
	      	objQuote12.Approved_Status__c ='Approved';
	        objQuote1.Total_12M_Amount__c =550;
	        objQuote12.Contact__c = c.Id;
	        objQuote12.Initial_Term__c = '24';
	        objQuote12.Valid_Until_Date__c = date.newInstance(2014, 4, 14);
	        objQuote12.Renewal_Term__c ='24';
	        objQuote12.Quote_Type__c = 'Agreement';
	        objQuote12.Opportunity__c = OpportunityObjList[1].Id;
	        objQuote12.IsPrimary__c = false;
	        objQuote12.Initial_Term__c = 'test1';
	        objQuote12.Total_MRR__c =20;
	        lstRCQ.add(objQuote12);
	        upsert lstRCQ;
	        
	         RC_Product__c objProct1 = new RC_Product__c();
	         objProct1.Name ='Office Enterprise - Annua12l';
	         objProct1.SKU__c  = 'OF_ENT_AN12';
	         insert objProct1;
	          
	         RC_Product_Line_Item__c objProductLinItm1 = new RC_Product_Line_Item__c();
	         objProductLinItm1.Name = 'test1';
	         objProductLinItm1.RC_Product__c= objProct1.id;
	         insert objProductLinItm1;
	         
	         Line_Item__c objLIC = new Line_Item__c();
	         objLIC.Opportunity__c = OpportunityObjList[0].Id;
	         objLIC.Order__c = 12.00;
	         objLIC.RC_Product_Line_Item__c = objProductLinItm1.Id;
	         insert objLIC; 
	         
	         ApexPages.StandardController controller1 = new ApexPages.StandardController(OpportunityObjList[0]);
	         InlineQuoteDetailCls objIQD1 = new InlineQuoteDetailCls(controller1);
	         lstRCQ[0].IsPrimary__c = true;
	         lstRCQ[1].IsPrimary__c = true;
	         
	         lstRCQ[0].Opportunity__c = OpportunityObjList[0].id;
	         lstRCQ[1].Opportunity__c = OpportunityObjList[0].id;
	         
	         update lstRCQ;
	         ApexPages.StandardController controller2 = new ApexPages.StandardController(OpportunityObjList[0]);
	         objIQD1 = new InlineQuoteDetailCls(controller2);
	         
	         lstRCQ[0].IsPrimary__c = false;
	         lstRCQ[1].IsPrimary__c = false;
	         
	         lstRCQ[0].Opportunity__c = OpportunityObjList[1].id;
	         lstRCQ[1].Opportunity__c = OpportunityObjList[1].id;
	         
	         update lstRCQ;
	         ApexPages.StandardController controller3 = new ApexPages.StandardController(OpportunityObjList[1]);
	         objIQD1 = new InlineQuoteDetailCls(controller3);
    	}catch(Exception Ex){}
    	
    }
}