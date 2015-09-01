@isTest
private class Test_classNew {

    static testmethod void Test_CampaignBatchToCalculateMRR() {
   
	     Test.StartTest();
	     CampaignBatchToCalculateMRR obj=new CampaignBatchToCalculateMRR();
	     //obj.execute(obj, 200);
	     ID batchprocessid= Database.executeBatch(obj,200);
	     Test.StopTest();
   
	}
	
	static testmethod void testSetTabOrder() {
		SetTabOrder obj = new SetTabOrder();
	}
	
	public static testmethod void Test_ATBCHelper() {
			Account acctest2 = new Account();
	        acctest2.Name='TestAccount';
	        acctest2.RC_User_ID__c = UserInfo.getUserId();
	        acctest2.Next_Renewal_Date__c = Date.today() + 10;
	        insert acctest2;
	        
	        Lead leadObj = new Lead();
	       	leadObj.LeadSource = 'About To be Cancelled'; 
	        leadObj.ATBC_Stage__c = 'WIP';
	        leadObj.IsConverted = false;
	        leadObj.User_ID__c = UserInfo.getUserId();
	        leadObj.Account__c = acctest2.id;
	        leadObj.FirstName='Virendra';
	        leadObj.LastName='Singh';
	        leadObj.Company='Simplion';
	        leadObj.Email='vps@sss.ss221.com';
	        leadObj.Phone='9910106804';
	        leadObj.Downgrade_Reason__c ='Not a Decision Maker';
	        insert leadObj;
        
	      	ATBCHelper objATBCHelper =new ATBCHelper ();
	      	//system.debug('+++'+leadObj.LastModifiedDate);
	      	system.debug('+++'+leadObj.Account_Renewal_Date__c);
	      	system.debug('+++'+leadObj.LastModifiedDate);
	 		objATBCHelper.startATBC();	
			objATBCHelper.performATBCCleanup(); 	
	}
	
	static testMethod void testCaseSolveSellLeadController () {
		Lead  r = new Lead(FirstName = 'testabc',lastName ='testxyz',Leadsource ='abcd',Agent_Email_Address__c ='xyz',Phone='123654789',
								Email='Test@Test.com',Downgrade_Reason__c ='Lost to Competition',Company = 'Test LTD');   
		insert r;
		
		Account accObj = new Account();
		accObj.Name = 'Test Account';
		insert accObj;
		
		Contact contObj = new Contact();
		contObj.FirstName = 'Test FName';
		contObj.LastName = 'TestLname';
		contObj.Email = 'Testemail@test.com';
		insert contObj;
		
		Schema.DescribeSObjectResult result = Case.SObjectType.getDescribe();
        Map<string,Schema.RecordTypeInfo> rtMapByName = result.getRecordTypeInfosByName(); 
		Case cs = new Case();  
		cs.RecordTypeId = rtMapByName.get('IT Helpdesk').getRecordTypeId(); 
		cs.Contact_ID__c =  contObj.id;    
        cs.AccountId = accObj.Id;
        cs.Status = 'New';     
        insert cs;
        
        ApexPages.currentPage().getParameters().put('caseid',cs.id);
        ApexPages.StandardController sc = new ApexPages.standardController(r);
        CaseSolveSellLeadController rc = new CaseSolveSellLeadController(sc);
        rc.saveLead();
       	rc.searchLeads();
       	rc.testingEdgeData011();
       	Lead  ref = rc.getnewlead();
       	Boolean b = rc.getisLeadSaved();
       	b = rc.getuserIdNotFound();
       	b = rc.getisFirstNameFilled();
       	b = rc.getisLastNameFilled();       
       	b = rc.getisCompanyFilled();
       	b= rc.getisEmailFilled();
       	b = rc.getisPhoneFilled();
       	b = rc.getisAgentMailFilled();
    }
    static testMethod void Test_ClaimAccount() {
             
        Account a = new Account();
        a.Name = 'TestbyAA';
        a.RC_User_ID__c = '345';
        
        Agent_Credit__c AC = new Agent_Credit__c();
        ac.Name = 'Test';
		ApexPages.currentPage().getParameters().put('userid', '111');    
		ApexPages.currentPage().getParameters().put('id', '111');     
         
		Profile p = [select id from profile where name='Standard User'];  
		User u = new User(alias = 'standt', email='standarduserTest@testorg.com', emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',  
		localesidkey='en_US', profileid = p.Id,  timezonesidkey='America/Los_Angeles', username='standarduserTest@testorg.com'); 
         
		claimAccountctrl CATest = new claimAccountctrl(new ApexPages.StandardController(a));    
		CATest.getAcctID();
		CATest.getNotAcctID();
		CATest.getAccountID();
		CATest.getNotAccountID();
		CATest.actCreateLeadFromContact();
		System.runAs(u) 
		{ 
			//CATest.actCreateLeadFromContact();
		}
    }
        static testMethod void Test_CSATSurveyservice() {
        
	       
	        	Survey__c objSur = new Survey__c();
	        	objSur.Name = 'test Survey';
	        	objSur.SurveyType__c = 'Support CSAT';
	        	insert objSur;
			    ApexPages.currentPage().getParameters().put('id', objSur.id);
			    CSATSurveyservice objCSATSurveyservice = new CSATSurveyservice();
			    
			    
			    
			    objCSATSurveyservice.setQ1Value(3);
			    objCSATSurveyservice.setQ2Value(2);
			    objCSATSurveyservice.setQ3Value(4);
			    objCSATSurveyservice.setQ4Value(5);
			   
			    objCSATSurveyservice.setComments('these are my comments');
			    
			    System.assertEquals(3, objCSATSurveyservice.getQ1Value());
			    System.assertEquals(2, objCSATSurveyservice.getQ2Value());
			    System.assertEquals(4, objCSATSurveyservice.getQ3Value());
			    System.assertEquals(5, objCSATSurveyservice.getQ4Value());
			    System.assertEquals('these are my comments', objCSATSurveyservice.getComments());
			    objCSATSurveyservice.getCommentLength();
			    objCSATSurveyservice.getAnswered(); 
			    objCSATSurveyservice.setQ5Value(4);
			    objCSATSurveyservice.getQ5Value();
			    objCSATSurveyservice.getValues3() ;
			    
			    Boolean a = objCSATSurveyservice.getIsEmpty();
			    Boolean b = objCSATSurveyservice.getIsFilled();
			    List<SelectOption> l1 = objCSATSurveyservice.getValues();
			    List<SelectOption> l2 = objCSATSurveyservice.getValues2();
			   
				objCSATSurveyservice.getSurvey().SurveyType__c='Support CSAT';
				objCSATSurveyservice.save();
				objCSATSurveyservice.getSurvey().SurveyType__c='Implementation';
				objCSATSurveyservice.save();		    
	}
	 static testMethod void Test_CSForce_SearchController() {
     
	  	CSForce_testingutil tu = new CSForce_testingutil();
	  	tu.addData();
	  	CSForce_SearchController sc = new CSForce_SearchController();
	  	sc.tSearch = 'test';
	  	sc.doSearch();
	  	
	  	CSForce_SearchController sc1 = new CSForce_SearchController();
		sc1.doSearch();
	  	System.assert(sc.productsSelect != null);
	  	System.assert(sc.competitorsSelect != null);
  
    }
        static testMethod void Test_DealRegistrationExt() {
        Test_Utils testUtilsObj = new Test_Utils();
      	testUtilsObj.initialiseTriggerBypass();
        Account  objAccount= (Account)SmartFactory.createSObject('Account', true);
		objAccount.Partner_id__c='123456Test12345';
		insert objAccount;
                                      
		Contact objContact= (Contact)SmartFactory.createSObject('Contact', true);
		objContact.AccountId=objAccount.id;
		insert objContact;
             
		objContact=[Select Account.Partner_id__c from Contact where id=:objContact.id];
		System.assert(objContact.Account.Partner_id__c=='123456Test12345');
              
              
		Profile pp = [Select p.Name, p.Id From Profile p where Name LIKE '%RC Partner User%'limit 1];
		System.assert(pp.Name=='RC Partner User');
             
		User objUser= new User(alias = 'ksTest',email='kanishk.singhTest@simplion.com',emailencodingkey='UTF-8',lastname='Testing',languagelocalekey='en_US',
								localesidkey='en_US',profileid = pp.Id,contactid = objContact.Id,timezonesidkey='America/Los_Angeles',username='kanishk.singhTest@simplion.com');
		insert objUser;
               
		System.assert(objUser.profileid ==pp.Id);
		System.assert(objUser.contactid ==objContact.Id);
              
		VAR_Deal_Registration__c  objDeal=null;
		List<ProcessInstanceWorkItem> workItemList=null;
              
		system.runAs(objUser){
		                      	
				VAR_Deal_Registration__c testDeal = new VAR_Deal_Registration__c();
				testDeal.Company_Name__c = 'test';
				testDeal.Phone__c = '123456';
				testDeal.Number_of_Employees__c = '500+';
				testDeal.Number_of_Locations__c = '50+';
				testDeal.Industry__c ='Legal';
				testDeal.Number_of_Users__c = 123;
				testDeal.Description__c ='test';
				testDeal.Contact_1_First_Name__c = 'test';
				testDeal.Contact_1_Last_Name__c = 'test';
				testDeal.Contact_1_Phone__c = '123123123';
				testDeal.Contact_1_Title__c ='Mr.';
				testDeal.Email_1__c = 'a@a.com';
				//testDeal.Registration_Status__c = 'Approved';
				insert testDeal;
				
				ApexPages.currentPage().getParameters().put('id', testDeal.id);
		   		DealRegistrationExt testDealReg = new DealRegistrationExt();
		   		testDeal.Deal_Closed__c = true;
		   		testDealReg.getIsApproved();
		   		testDealReg.onUpdate();
		   		
		   		VAR_Deal_Registration__c testDeal1 = new VAR_Deal_Registration__c();
				testDeal1.Company_Name__c = 'test';
				testDeal1.Phone__c = '123456';
				testDeal1.Number_of_Employees__c = '500+';
				testDeal1.Number_of_Locations__c = '50+';
				testDeal1.Industry__c ='Legal';
				testDeal1.Number_of_Users__c = 123;
				testDeal1.Description__c ='test';
				testDeal1.Contact_1_First_Name__c = 'test';
				testDeal1.Contact_1_Last_Name__c = 'test';
				testDeal1.Contact_1_Phone__c = '123123123';
				testDeal1.Contact_1_Title__c ='Mr.';
				testDeal1.Email_1__c = 'test@test.com';
				testDeal1.DealRegistrationAccount__c= objAccount.id;
				
				insert testDeal1;
		   		ApexPages.currentPage().getParameters().put('id', testDeal1.id);
		   		DealRegistrationExt testDeal1Reg = new DealRegistrationExt();
		   		testDeal1.Deal_Closed__c = false;
		   		testDeal1Reg.getIsApproved();
		   		testDeal1Reg.onUpdate();
		}
    }
    
    static testMethod void Test_DealRegistrationExtNew() {
    	
    	Test_Utils testUtilsObj = new Test_Utils();
      	testUtilsObj.initialiseTriggerBypass();
        Account  objAccount= (Account)SmartFactory.createSObject('Account', true);
		objAccount.Partner_id__c='123456Test12345';
		insert objAccount;
                                      
		Contact objContact= (Contact)SmartFactory.createSObject('Contact', true);
		objContact.AccountId=objAccount.id;
		insert objContact;
             
		objContact=[Select Account.Partner_id__c from Contact where id=:objContact.id];
		System.assert(objContact.Account.Partner_id__c=='123456Test12345');
              
              
		Profile pp = [Select p.Name, p.Id From Profile p where Name LIKE '%RC Partner User%'limit 1];
		System.assert(pp.Name=='RC Partner User');
             
		User objUser= new User(alias = 'ksTest',email='kanishk.singhTest@simplion.com',emailencodingkey='UTF-8',lastname='Testing',languagelocalekey='en_US',
								localesidkey='en_US',profileid = pp.Id,contactid = objContact.Id,timezonesidkey='America/Los_Angeles',username='kanishk.singhTest@simplion.com');
		insert objUser;
               
		System.assert(objUser.profileid ==pp.Id);
		System.assert(objUser.contactid ==objContact.Id);
              
		VAR_Deal_Registration__c  objDeal=null;
		List<ProcessInstanceWorkItem> workItemList=null;
		
		system.runAs(objUser){
    	
	    	VAR_Deal_Registration__c testDeal = new VAR_Deal_Registration__c();
					testDeal.Company_Name__c = 'test';
					testDeal.Phone__c = '123456';
					testDeal.Number_of_Employees__c = '500+';
					testDeal.Number_of_Locations__c = '50+';
					testDeal.Industry__c ='Legal';
					testDeal.Number_of_Users__c = 123;
					testDeal.Description__c ='test';
					testDeal.Contact_1_First_Name__c = 'test';
					testDeal.Contact_1_Last_Name__c = 'test';
					testDeal.Contact_1_Phone__c = '123123123';
					testDeal.Contact_1_Title__c ='Mr.';
					testDeal.Email_1__c = 'a@a.com';
					//testDeal.Registration_Status__c = 'Approved';
					insert testDeal;
			ApexPages.currentPage().getParameters().put('id', testDeal.id);
	   		DealRegistrationExt testDealReg = new DealRegistrationExt();
	   		
	   		boolean isDealClosed = testDealReg.oldDealClosedValue;
	   		String regAccount = testDealReg.oldDealRegistrationAccountValue;
	   		testDealReg.getIsApproved();   		
	   		testDealReg.onUpdate();
	   		testDealReg.isNullDealRegistration(testDeal);
	   		testDealReg.isChanged(testDeal);
	   		
	   		ChatterException obj = new ChatterException();
		}
    }
}