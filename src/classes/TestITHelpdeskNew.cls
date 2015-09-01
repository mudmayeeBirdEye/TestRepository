@isTest(seealldata=false)
private class TestITHelpdeskNew   {
    ///*Test class for the class tHelpdeskTicket
    // created date ------06/17/2014*/

    static testMethod void unitTestHelpdeskTicket() { 
    	 Schema.DescribeSObjectResult acccountResult = Account.SObjectType.getDescribe();
         Map<ID,Schema.RecordTypeInfo> acccountrtMapByName = acccountResult.getRecordTypeInfosById();
         Map<string,Schema.RecordTypeInfo> acccountrtMapById = acccountResult.getRecordTypeInfosByName(); 
         Account acctestt = new Account();
         acctestt.Name='TestAccount11';
         acctestt.RC_Attribution_Channel__c = 'Sales Agents & Resellers';
         acctestt.RecordTypeId = acccountrtMapById.get('Customer Account').getRecordTypeId();
         insert acctestt;
               
         Contact contacObj = new Contact();
         contacObj.AccountId =  acctestt.id;
         contacObj.Email = 'virendra.singh111@simplion.com';
         contacObj.Phone = '9910106804';
         contacObj.LastName = 'TestLast';
         insert contacObj ;
                
         Case casObj = new Case();
         casObj.Subject = 'Test Case';
         casObj.AccountId = acctestt.Id;
         casObj.Contact_ID__c = contacObj.Id;
         insert casObj;
     
         HelpdeskTicket  helDeskTic = new HelpdeskTicket();
         Test.startTest();
         helDeskTic.submitCase();
         Test.stopTest();
   }
   
    //Test Class for the  PurchaseTicket class created on 06/17/2014 
   static testMethod void unitTestPurchaseTicket () {
   	     Schema.DescribeSObjectResult acccountResult = Account.SObjectType.getDescribe();
         Map<ID,Schema.RecordTypeInfo> acccountrtMapByName = acccountResult.getRecordTypeInfosById();
         Map<string,Schema.RecordTypeInfo> acccountrtMapById = acccountResult.getRecordTypeInfosByName();  
         
         Account acctest = new Account();
         acctest.Name='TestAccount11';
         acctest.RC_Attribution_Channel__c = 'Sales Agents & Resellers';
         acctest.Partner_ID__c ='123';
         acctest.RecordTypeId = acccountrtMapById.get('Customer Account').getRecordTypeId();
         insert acctest;
           
         Contact contactObj = new Contact();
         contactObj.AccountId =  acctest.id;
         contactObj.Email = 'virendra.singh111@simplion.com';
         contactObj.Phone = '9910106804';
         contactObj.LastName = 'TestLast';
         insert contactObj;
                
         Case caseObj = new Case();
         caseObj.Subject = 'Test Case';
         caseObj.AccountId = acctest.Id;
         caseObj.Contact_ID__c = contactObj.Id;
         insert caseObj;
         
         PurchaseTicket purTicket = new PurchaseTicket ();
         Test.startTest();
         purTicket.submitCase();
         Test.stopTest();
    }
    
    //Test method for the Batch class of ITHelpDeskBatch Created on 06/17/2014 
     static testMethod void unitITHelpDeskBatch() { 
        try {
        	 TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT = true;
        	 TriggerHandler.BY_PASS_CONTACT_ON_INSERT = true;
        	 Schema.DescribeSObjectResult acccountResult = Account.SObjectType.getDescribe();
             Map<ID,Schema.RecordTypeInfo> acccountrtMapByName = acccountResult.getRecordTypeInfosById();
             Map<string,Schema.RecordTypeInfo> acccountrtMapById = acccountResult.getRecordTypeInfosByName(); 
        	 //TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT = true;
        	 string profileId = [SELECT Id FROM profile WHERE Name = 'IT Helpdesk Portal User' limit 1].id;
             Test.startTest();
             /*IT_Helpdesk_Locations__c csobj = new IT_Helpdesk_Locations__c();
             csobj.Name = 'Noida, India';
             insert csobj; */ 
                
             Account acc = new Account();
             acc.Name = 'RC Internal';
             acc.RecordTypeId = acccountrtMapById.get('Customer Account').getRecordTypeId();
             insert acc;
             
             /*Employee__c emp = new Employee__c();
             emp.First_Name__c = 'tuser1';
             emp.Last_Name__c = 'lname1';
             emp.Email__c ='clc1@clc.com';
             //emp.Location__c = csobj.Name;
             emp.Department__c = 'IT';
             emp.Team__c = 'SE';
             emp.SPID__c = '7413';
             insert emp;*/
             
             Schema.DescribeSObjectResult result = Contact.SObjectType.getDescribe();
             Map<string,Schema.RecordTypeInfo> rtMapByName =  result.getRecordTypeInfosByName();    
                   
             Contact conObj = new Contact();
             conObj.AccountId =  acc.id;
             conObj.Email = 'virendra.singh111@simplion.com';
             conObj.Phone = '9910106804';
             conObj.LastName = 'TestLast11';
             //conObj.Employee__c = emp.id;
             conObj.RecordTypeId = rtMapByName.get('Internal Employee').getRecordTypeID();
             insert conObj;
             
             /*Contact conObj1 = new Contact();
             conObj1.AccountId =  acc.id;
             conObj1.Email = 'virendra.singh1111@simplion.com';
             conObj1.Phone = '9910106804';
             conObj1.LastName = 'TestLast111';
             conObj1.RecordTypeId = rtMapByName.get('Internal Employee').getRecordTypeID();
             insert conObj1;
             
             User userObj = new User();
        	 userObj.FirstName = 'Test123';
             userObj.email = 'virendra.singh1111@simplion.com';
             userObj.emailencodingkey = 'UTF-8';
             userObj.lastname = 'TestLast111';
             userObj.languagelocalekey = 'en_US';
             userObj.localesidkey = 'en_US';
             userObj.profileid = profileId;
             userObj.contactId = conObj1.Id;
             userObj.timezonesidkey = 'America/Los_Angeles';
             userObj.username = userObj.email + '.portal';
         	 userObj.communityNickname = 'testCom'; 
             userObj.alias = 'Testa';
		     insert userObj;*/    
             
             ITHelpDeskBatch itHelpDesBatc = new ITHelpDeskBatch();
             Database.executeBatch(itHelpDesBatc,1);
             Test.stopTest();
          } catch(exception ex){}
     }
     
     static testMethod void unitITHelpDeskBatch1() { 
        try {
        	 TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT = true;
        	 TriggerHandler.BY_PASS_CONTACT_ON_INSERT = true;
        	 Schema.DescribeSObjectResult acccountResult = Account.SObjectType.getDescribe();
             Map<ID,Schema.RecordTypeInfo> acccountrtMapByName = acccountResult.getRecordTypeInfosById();
             Map<string,Schema.RecordTypeInfo> acccountrtMapById = acccountResult.getRecordTypeInfosByName(); 
        	 //TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT = true;
        	 string profileId = [SELECT Id FROM profile WHERE Name = 'IT Helpdesk Portal User' limit 1].id;
             Test.startTest();
             /*IT_Helpdesk_Locations__c csobj = new IT_Helpdesk_Locations__c();
             csobj.Name = 'Noida, India';
             insert csobj; */ 
                
             Account acc = new Account();
             acc.Name = 'RC Internal';
             acc.RecordTypeId = acccountrtMapById.get('Customer Account').getRecordTypeId();
             insert acc;
             
             /*Employee__c emp = new Employee__c();
             emp.First_Name__c = 'tuser1';
             emp.Last_Name__c = 'lname1';
             emp.Email__c ='clc1@clc.com';
             //emp.Location__c = csobj.Name;
             emp.Department__c = 'IT';
             emp.Team__c = 'SE';
             emp.SPID__c = '7413';
             insert emp;*/
             
             Schema.DescribeSObjectResult result = Contact.SObjectType.getDescribe();
             Map<string,Schema.RecordTypeInfo> rtMapByName =  result.getRecordTypeInfosByName();    
                   
             /*Contact conObj = new Contact();
             conObj.AccountId =  acc.id;
             conObj.Email = 'virendra.singh111@simplion.com';
             conObj.Phone = '9910106804';
             conObj.LastName = 'TestLast11';
             //conObj.Employee__c = emp.id;
             conObj.RecordTypeId = rtMapByName.get('Internal Employee').getRecordTypeID();
             insert conObj;*/
             
             Contact conObj1 = new Contact();
             conObj1.AccountId =  acc.id;
             conObj1.Email = 'virendra.singh1111@simplion.com';
             conObj1.Phone = '9910106804';
             conObj1.LastName = 'TestLast111';
             conObj1.RecordTypeId = rtMapByName.get('Internal Employee').getRecordTypeID();
             insert conObj1;
             
             User userObj = new User();
        	 userObj.FirstName = 'Test123';
             userObj.email = 'virendra.singh1111@simplion.com';
             userObj.emailencodingkey = 'UTF-8';
             userObj.lastname = 'TestLast111';
             userObj.languagelocalekey = 'en_US';
             userObj.localesidkey = 'en_US';
             userObj.profileid = profileId;
             userObj.contactId = conObj1.Id;
             userObj.timezonesidkey = 'America/Los_Angeles';
             userObj.username = userObj.email + '.portal';
         	 userObj.communityNickname = 'testCom'; 
             userObj.alias = 'Testa';
		     insert userObj;    
             
             ITHelpDeskBatch itHelpDesBatc = new ITHelpDeskBatch();
             Database.executeBatch(itHelpDesBatc,1);
             Test.stopTest();
          } catch(exception ex){}
     }
     
     //Test method for the Batch class of ITHelpDeskBatch Created on 06/17/2014 
     static testMethod void unitITHelpDeskSchedule() { 
        try {
        	 Schema.DescribeSObjectResult acccountResult = Account.SObjectType.getDescribe();
             Map<ID,Schema.RecordTypeInfo> acccountrtMapByName = acccountResult.getRecordTypeInfosById();
             Map<string,Schema.RecordTypeInfo> acccountrtMapById = acccountResult.getRecordTypeInfosByName(); 
             Test.startTest();
                
             Account acc = new Account();
             acc.Name = 'RC Internal';
             acc.RecordTypeId = acccountrtMapById.get('Customer Account').getRecordTypeId();
             insert acc;
             
            
             
             Schema.DescribeSObjectResult result = Contact.SObjectType.getDescribe();
             Map<string,Schema.RecordTypeInfo> rtMapByName =  result.getRecordTypeInfosByName();    
                   
             Contact conObj = new Contact();
             conObj.AccountId =  acc.id;
             conObj.Email = 'virendra.singh222@simplion.com';
             conObj.Phone = '9910106804';
             conObj.LastName = 'TestLast';
             //conObj.Employee__c = emp.id;
             conObj.RecordTypeId = rtMapByName.get('Internal Employee').getRecordTypeID();
             insert conObj;
             
             Test.stopTest();
             
             ITHelpdeskSchedule itHelpSc = new ITHelpdeskSchedule();
             itHelpSc.execute(null);
             
          } catch(exception ex){}
    }
    
    static testMethod void testCommunitiesLanding() {
    	CommunitiesLandingController obj = new CommunitiesLandingController();
    	obj.forwardToStartPage();
    }
    
    static testMethod void testITHelpDeskPortal() { 
    	try {
    		TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT = true;
    		TriggerHandler.BY_PASS_CASE_ON_INSERT = true;
    		TriggerHandler.BY_PASS_CONTACT_ON_INSERT = true;
    		TriggerHandler.BY_PASS_CASE_ON_INSERT = true;
    		TriggerHandler.BY_PASS_CASE_ON_UPDATE = true;
    		
    		Schema.DescribeSObjectResult caseResult = Case.SObjectType.getDescribe();
            Map<ID,Schema.RecordTypeInfo> casertMapByName = caseResult.getRecordTypeInfosById();
            Map<string,Schema.RecordTypeInfo> casertMapById = caseResult.getRecordTypeInfosByName();
            
            Schema.DescribeSObjectResult acccountResult = Account.SObjectType.getDescribe();
            Map<ID,Schema.RecordTypeInfo> acccountrtMapByName = acccountResult.getRecordTypeInfosById();
            Map<string,Schema.RecordTypeInfo> acccountrtMapById = acccountResult.getRecordTypeInfosByName();
    		
    		Account accObj = new Account();
            accObj.Name = 'RC Internal';
            accObj.RecordTypeId = acccountrtMapById.get('Customer Account').getRecordTypeId();
            accObj.Current_Owner__c = UserInfo.getUserId();
            accObj.OwnerId = UserInfo.getUserId();
            insert accObj; 
            System.debug(' ##### accObj Id = ' + accObj.Id + ' #####');
            
            Employee__c emp = new Employee__c();
         	emp.First_Name__c = 'tuser2';
         	emp.Last_Name__c = 'lname2';
         	emp.Email__c ='rc1234@test.com';
         	emp.Location__c = 'Manila, Philippines';
         	emp.Department__c = 'HR/Legal';
         	emp.Team__c = 'SE';
         	emp.SPID__c = '7419';
         	insert emp;
         	
         	Test.startTest();
         	
         	
             
            Contact contObj = new Contact();
            contObj.AccountId =  accObj.Id;
            contObj.Email = 'rc1234@test.com';
            contObj.LastName = 'Test Last232';
            contObj.FirstName = 'Test First333';
            contObj.Phone = '9856723457';
            contObj.Employee__c = emp.id;
            insert contObj;
            System.debug(' ##### contObj Id = ' + contObj.Id + ' #####');
            
            Profile prof = [SELECT Id FROM Profile WHERE Name = 'IT Helpdesk Portal User' limit 1];
            User testUser = new User();
            testUser.contactId = contObj.Id; 
            testUser.alias = 'u3'; 
            testUser.email='rc1234@test.com';
            testUser.emailencodingkey='UTF-8'; 
            testUser.lastname='RcTestLast'; 
      		testUser.ProfileId = prof.Id; 
            testUser.languagelocalekey='en_US';
            testUser.localesidkey='en_US'; 
            testUser.country='United States';
            testUser.timezonesidkey='America/Los_Angeles'; 
            testUser.username = 'utest@testorg.com'; 
            testUser.IsActive = true;                   
            insert testUser;
            System.debug('####insertuser'+testUser.Id);
            
           Test.stopTest();
            
           system.runAs(testUser) {
           	 Case caseObj = new Case();
            caseObj.Subject = 'Test Subject';
            caseObj.RecordTypeId = casertMapById.get('IT Helpdesk').getRecordTypeId();
            caseObj.status = 'New';
            caseObj.Priority='P3';
            caseObj.AccountId = accObj.Id;
            caseObj.ContactId = contObj.Id;
            caseObj.Description = 'Test Case Desc';
            insert caseObj;
            System.debug('######Caseinsertt'+caseObj.Id);
           
           
            ApexPages.StandardController sc = new ApexPages.StandardController(caseObj);
            ITHelpDeskPortal  helpDesk = new ITHelpDeskPortal();
            ITHelpDeskPortal  helpDesk1 = new ITHelpDeskPortal(sc);
            helpDesk1.searchCaseAndArticles();
            helpDesk1.caseSearchText = 'Test';
            helpDesk1.searchCaseAndArticles();
	       	helpDesk1.getDefaultCasesForLoggedInUser();
	       	Set<string> testSet = new Set<string>();
	       	testSet.add('Test1');
       		testSet.add('Test2');
	       	helpDesk1.callSetIterator(testSet);
	       	helpDesk1.getIsArticleDetailsPage();
	       }
    	} catch(Exception ex) {
    		System.Debug('>>>>1234>>>'+ex.getMessage());
    	}
    }
    
    static testMethod void testITHelpdeskAticles() {
    	try {
    		TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT = true;
	        TriggerHandler.BY_PASS_CASE_ON_INSERT = true;
	        TriggerHandler.BY_PASS_CONTACT_ON_INSERT = true;
	        TriggerHandler.BY_PASS_CASE_ON_INSERT = true;
	        TriggerHandler.BY_PASS_CASE_ON_UPDATE = true;
        
        	Schema.DescribeSObjectResult caseResult = Case.SObjectType.getDescribe();
            Map<ID,Schema.RecordTypeInfo> casertMapByName = caseResult.getRecordTypeInfosById();
            Map<string,Schema.RecordTypeInfo> casertMapById = caseResult.getRecordTypeInfosByName();
            
            Schema.DescribeSObjectResult acccountResult = Account.SObjectType.getDescribe();
            Map<ID,Schema.RecordTypeInfo> acccountrtMapByName = acccountResult.getRecordTypeInfosById();
            Map<string,Schema.RecordTypeInfo> acccountrtMapById = acccountResult.getRecordTypeInfosByName();
    		Account accObj = new Account();
            accObj.Name = 'RC Internal';
            accObj.RecordTypeId = acccountrtMapById.get('Customer Account').getRecordTypeId();
            accObj.Current_Owner__c = UserInfo.getUserId();
            accObj.OwnerId = UserInfo.getUserId();
            insert accObj; 
            System.debug(' ##### accObj Id = ' + accObj.Id + ' #####');
            
            Employee__c emp = new Employee__c();
            emp.First_Name__c = 'tuser2';
            emp.Last_Name__c = 'lname2';
            emp.Email__c ='rc1235@test.com';
            emp.Location__c = 'Manila, Philippines';
            emp.Department__c = 'HR/Legal';
            emp.Team__c = 'SE';
            emp.SPID__c = '7420';
            insert emp;
           
            Test.startTest();
             
            Contact contObj = new Contact();
            contObj.AccountId =  accObj.Id;
            contObj.Email = 'rc1235@test.com';
            contObj.LastName = 'Test Last232';
            contObj.FirstName = 'Test First333';
            contObj.Phone = '9856723457';
            contObj.Employee__c = emp.id;
            insert contObj;
            System.debug(' ##### contObj Id = ' + contObj.Id + ' #####');
            
            Profile prof = [SELECT Id FROM Profile WHERE Name = 'IT Helpdesk Portal User' limit 1];
            User testUser = new User();
            testUser.contactId = contObj.Id; 
            testUser.alias = 'u5'; 
            testUser.email='rc1235@test.com';
            testUser.emailencodingkey='UTF-8'; 
            testUser.lastname='RcTestLast'; 
         	testUser.ProfileId = prof.Id; 
            testUser.languagelocalekey='en_US';
            testUser.localesidkey='en_US'; 
            testUser.country='United States';
            testUser.timezonesidkey='America/Los_Angeles'; 
            testUser.username = 'utest3@testorg.com'; 
            testUser.IsActive = true;                   
            insert testUser;
            System.debug('####insertuser'+testUser.Id);
            
            Test.stopTest();
            
            Case caseObj = new Case();
            system.runAs(testUser) {
	            caseObj = new Case();
	            caseObj.Subject = 'Test Subject';
	            caseObj.RecordTypeId = casertMapById.get('IT Helpdesk').getRecordTypeId();
	            caseObj.status = 'New';
	            caseObj.Priority='P3';
	            caseObj.AccountId = accObj.Id;
	            caseObj.ContactId = contObj.Id;
	            caseObj.Description = 'Test Case Desc';
	            insert caseObj;
            }
            
            
    		ApexPages.StandardController sc = new ApexPages.StandardController(caseObj);
    		IT_Helpdesk__kav articleObj = new IT_Helpdesk__kav();
        	articleObj.Title = 'test pasword';
        	articleObj.UrlName = 'test-pasword';
        	articleObj.Language= 'en_US';
        	insert articleObj;
        	System.Debug('>>>>articleObj>>>'+ articleObj);
        	System.Debug('>>>>articleObj>>>'+ articleObj.PublishStatus);
        	articleObj = [SELECT KnowledgeArticleId FROM IT_Helpdesk__kav WHERE Id = :articleObj.Id]; 
        	KbManagement.PublishingService.publishArticle(articleObj.KnowledgeArticleId, true);
        	ITHelpDeskPortal articlesObj = new ITHelpDeskPortal(sc);
        	articlesObj.caseSearchText = 'pasword';
        	articlesObj.searchCaseAndArticles();
    	} catch(Exception ex) {
    		 System.Debug('>>>>1234>>>'+ex.getMessage());
    	}
    }
}