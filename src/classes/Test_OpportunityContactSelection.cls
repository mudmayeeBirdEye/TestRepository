/*-----------------------------------------------------------------------------
* Project Name..........: Replace New Oppty Campaign Selection with Contact Selection         
* File..................: Test method of  OpportunityContactRole Class              *
* Version...............: 1.0                                                       *
* Created by............: Simplion Technologies                                     *
* Created Date..........: 07-23-2014                                                *
* Last Modified by......: Simplion Technologies                                     *
* Description...........: This is Testmethod for OpportunityContactSelection class  *
------------------------------------------------------------------------------>*/
@isTest(seeAllData = false)
private class Test_OpportunityContactSelection {
	static testMethod void myUnitOpportunityContactSelection() {
		
	        
	        Schema.DescribeSObjectResult result = Account.SObjectType.getDescribe();
            Map<string,Schema.RecordTypeInfo> rtMapById = result.getRecordTypeInfosByName();
	        
	        Account acctest1 = new Account();
	        acctest1.Name = 'TestAccount';
	        acctest1.RC_Account_Status__c = 'Paid';
	        acctest1.RecordTypeId = rtMapById.get('Partner Account').getRecordTypeID();
	        insert acctest1;
	        
	        Account acctest2 = new Account();
	        acctest2.Name = 'TestAccount';
	        acctest2.RC_Account_Status__c = 'Paid';
	        insert acctest2;
	       
	        Contact objcon = new Contact();
	        objcon.FirstName='test';
	        objcon.LastName ='testl';
	        objcon.AccountId = acctest1.id;
	        objcon.Phone= '4098764563';
	        objcon.email = 'Test123@simplion.com';
	        insert objcon;
	        
	        Contact objcon1 = new Contact();
	        objcon1.FirstName='test';
	        objcon1.LastName ='testl';
	        objcon1.AccountId = acctest1.id;
	        objcon1.Phone= '4098764563';
	        objcon1.email = 'Test12345@simplion.com';
	        insert objcon1;
	        
	        AccountContactRole accountContactRoleObj = new AccountContactRole() ;
			accountContactRoleObj.AccountId = acctest1.Id;
			accountContactRoleObj.ContactId = objcon.Id;
			accountContactRoleObj.IsPrimary = true;
			insert accountContactRoleObj;
	        
	        Order__c orderVal = new  Order__c();
	      	orderVal.Name = '12345678';
	      	insert  orderVal;
		      
	        Opportunity Oppval = new Opportunity();
            Oppval.Name = 'Test Opp';
            Oppval.AccountId = acctest1.Id;
            Oppval.Type = 'Existing Business';
            Oppval.StageName = OpportunityHelper.defaultOpportunityStage;
            Oppval.Sales_Model__c = 'Direct';
            Oppval.CloseDate = System.Today() + 10;
            Oppval.CurrencyIsoCode = 'USD';
            Oppval.Brand_Name__c= 'RingCentral';
            Oppval.OwnerId = Userinfo.getUserId();
            Oppval.Primary_Opportunity_Contact__c= objcon.id;
            insert Oppval;
            
            
         	Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
	       
	       	User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
	                            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
	                            LocaleSidKey='en_US', ProfileId = p.Id,                          
	                            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser11@testorg.com');
	        
	        insert u;
	            
	        
            String strContactId = objcon1.Id;
            String strAccountId = acctest2.Id;
	            
           	ApexPages.currentPage().getParameters().put('accid',acctest1.Id);           
     		ApexPages.currentPage().getParameters().put('conid',objcon.Id);
     		ApexPages.currentPage().getParameters().put('CF00N80000004jUBx_lkid',orderVal.Id);
     		ApexPages.currentPage().getParameters().put('retURL','/006/o');
            ApexPages.StandardController sc1 = new ApexPages.standardController(Oppval);
            OpportunityContactRoleExtension oppConSel = new OpportunityContactRoleExtension(sc1);
            oppConSel.contactIdTemp = 'strContactId';
           	Test.startTest();
           	oppConSel.callDispatcher();
           	oppConSel.getContactLstOnAccountSelection();
           	oppConSel.getContactList(strAccountId);
           	oppConSel.createOpportunity();                  
           	PageReference pgRef = new PageReference('/006/o');
           	ApexPages.currentPage().getParameters().put('retURL',pgRef.getUrl());
           	oppConSel.cancel();
           	Test.stopTest(); 
		
 	}
 	
 	static testMethod void myUnitOpportunityContactSelection1() {
		
			
			Schema.DescribeSObjectResult result = Account.SObjectType.getDescribe();
            Map<string,Schema.RecordTypeInfo> rtMapById = result.getRecordTypeInfosByName();
	        
	        Account acctest1 = new Account();
	        acctest1.Name = 'TestAccount';
	        acctest1.RecordTypeId = rtMapById.get('Partner Account').getRecordTypeID();
	        insert acctest1;
	        
	        Account acctest2 = new Account();
	        acctest2.Name = 'TestAccount';
	        insert acctest2;
	        
	        Contact objcon = new Contact();
	        objcon.FirstName='test';
	        objcon.LastName ='testl';
	        objcon.AccountId = acctest1.id;
	        objcon.Phone= '4098764563';
	        objcon.email = 'Test1223453@simplion.com';
	        insert objcon;
	        
	        Contact objcon1 = new Contact();
	        objcon1.FirstName='test';
	        objcon1.LastName ='testl';
	        objcon1.AccountId = acctest2.id;
	        objcon1.Phone= '4098764563';
	        objcon1.email = 'Test11234523@simplion.com';
	        insert objcon1;
	        
	        AccountContactRole accountContactRoleObj = new AccountContactRole() ;
			accountContactRoleObj.AccountId = acctest2.Id;
			accountContactRoleObj.ContactId = objcon.Id;
			accountContactRoleObj.IsPrimary = true;
			insert accountContactRoleObj;
	        
	        Order__c orderVal = new  Order__c();
	      	orderVal.Name = '12345678';
	      	insert  orderVal;
	      	
	      	Campaign campObj1 = new Campaign(Name='TestCampaign',Protected_Campaign__c=true ,Lead_Creation_Score__c='300', IsActive=true, 
			AID__c='test0121' );
	        
	        insert campObj1;
		      
	        Opportunity Oppval = new Opportunity();
            Oppval.Name = 'Test Opp';
            Oppval.AccountId = acctest1.Id;
            Oppval.Type = 'Existing Business';
            Oppval.StageName = OpportunityHelper.defaultOpportunityStage;
            Oppval.Sales_Model__c = 'Direct';
            Oppval.CloseDate = System.Today() + 10;
            Oppval.CurrencyIsoCode = 'USD';
            Oppval.Brand_Name__c= 'RingCentral';
            Oppval.OwnerId = Userinfo.getUserId();
            Oppval.Primary_Opportunity_Contact__c= objcon.id;
            insert Oppval;
			
			ApexPages.currentPage().getParameters().put('CF00N80000004jUBx_lkid',orderVal.Id);
			ApexPages.currentPage().getParameters().put('campid',campObj1.Id);
            ApexPages.StandardController sc1 = new ApexPages.standardController(Oppval);
            OpportunityContactRoleExtension oppConSel = new OpportunityContactRoleExtension(sc1); 
            OpportunityContactRoleExtension.ContactWrapper ConWrap = new OpportunityContactRoleExtension.ContactWrapper();
            ConWrap.setAsPrimary = false;
            ConWrap.strEmail = 'test@test.com';
            ConWrap.strFLame = 'TestFName';
            ConWrap.strFName = 'TestLName';
            ConWrap.strLeadScore = 'LeadScore';
            ConWrap.strPhoneNumber = '1234567890';
            String strAccountId = acctest1.Id;
            String strContactId = objcon.Id;
           	Test.startTest();
           	oppConSel.callDispatcher();
           	oppConSel.getContactLstOnAccountSelection();
           	oppConSel.contactIdTemp = 'strContactId';
           	oppConSel.getContactList(strAccountId);
	        
           	oppConSel.createOpportunity();                  
           	PageReference pgRef = new PageReference('/006/o');
           	ApexPages.currentPage().getParameters().put('retURL',pgRef.getUrl());
           	oppConSel.cancel();
           	Test.stopTest(); 
	
		
		
	}
}