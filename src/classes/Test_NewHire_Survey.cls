@isTest
private class Test_NewHire_Survey {

  	static testMethod void RCSupportController2012test() {
        RCSupportController2012 objRCSupportController = new RCSupportController2012();
        RCSiteSetup__c objRCSiteName= (RCSiteSetup__c)SmartFactory.createSObject('RCSiteSetup__c', true);
        objRCSiteName.RCSiteName__c='rcsupport';
        upsert objRCSiteName;
		Test.StartTest();
        PageReference pageRef = new PageReference('/apex/RCSupportHome');
        Test.setCurrentPageReference(pageRef);
       
        objRCSupportController.getAuthToken(); 
        objRCSupportController.getBrandFilter();
        objRCSupportController.getCacheMaxAge();
        objRCSupportController.getCanUserSeeKnowledge();
        objRCSupportController.getCategoryDescriptions();
        objRCSupportController.getCategoryGroupName();
        objRCSupportController.getFramedParam();
        objRCSupportController.getHomeAdText();
        objRCSupportController.getHomeAdTitle();
        objRCSupportController.getHomePage();
        objRCSupportController.getHomeUrl();
        objRCSupportController.getIsAnswerSearch();
        objRCSupportController.getIsArticleDetailsPage();
        objRCSupportController.getIsContact();
        objRCSupportController.getIsContactSupportPage();
        objRCSupportController.getIsCustomArticleListPage();
        objRCSupportController.getIsExternalPage();
        objRCSupportController.getIsHomePage();
        objRCSupportController.getIsProductPage();
        objRCSupportController.getRootCategoryName();

        objRCSupportController.getPage(ApexPages.currentpage().getUrl());
        objRCSupportController.getPageId();
        objRCSupportController.getParentId();
        objRCSupportController.getProductPage();
        objRCSupportController.getProductUrl();
        objRCSupportController.getRootCategoryName();
        objRCSupportController.getSearchPage();
        objRCSupportController.getSearchPageUrl();
        objRCSupportController.getSearchUrl();
        objRCSupportController.getSearchUrl1();
        
        String str2= objRCSupportController.currentArticleType;
        str2= objRCSupportController.currentArticleTypeLabel;
        str2= objRCSupportController.currentCategory;
        str2= objRCSupportController.currentCategoryName;
        str2= objRCSupportController.currentKeyword;
        str2= objRCSupportController.currentPage;
        Integer pageNum= objRCSupportController.currentPageNumber;
        PageReference objpage= objRCSupportController.currentPageReference;
        objRCSupportController.doSearch();
        objRCSupportController.doAdvanceSearch();
       
        str2= objRCSupportController.categoryParameterName; 
        str2= objRCSupportController.keywordParameterName; 
        str2= objRCSupportController.articleTypeParameterName; 
        str2= objRCSupportController.articleTypeLabelParameterName; 
        str2= objRCSupportController.pageNumberParameterName ;
        objRCSupportController.getSiteSetup();
        objRCSupportController.getServiceFilter();
        objRCSupportController.getServiceFilterURL();
        objRCSupportController.getSupportSearchPageUrl();
        objRCSupportController.getIsSearchPage();
        objRCSupportController.cleanKeyword();
        
        ApexPages.currentPage().getParameters().put('emailPage','kanishk.singh@simplion.com');
        String recMail=ApexPages.currentPage().getParameters().put('recMail','kanishk.singh@simplion.com');
        String senderMail=ApexPages.currentPage().getParameters().put('senderMail','kanishk.singh@simplion.com');
        String senderName=ApexPages.currentPage().getParameters().put('sendername','kanishk');
        String strTitle='';
        
        objRCSupportController.emailSend();
        objRCSupportController.getIdeaURL();
        objRCSupportController.getCaseURL();
        ApexPages.CurrentPage().getParameters().put('retUrl','service=1&brand=Ringcentral&token=test');
        ApexPages.CurrentPage().getParameters().put('brand','RC_UK');
        objRCSupportController.getIdeaURL();
        objRCSupportController.getCaseURL();
        
        ApexPages.CurrentPage().getParameters().put('token','test');
        objRCSupportController.getIdeaURL();
        objRCSupportController.getCaseURL();
     
        ApexPages.CurrentPage().getParameters().put('token','PFK8fqxUQZ3qw1nIWm0gVoPE1O1xEhiRFh0X3n0PxvEIzdYo+J2ihXuaSvfrFoOGXg5uqTH8KYo/2oohN5A7wQ==');
        objRCSupportController.getIdeaURL(); 
        objRCSupportController.getCaseURL();
       
        objRCSupportController.getIdeaURL(); 
        objRCSupportController.updateUserProfile();
        objRCSupportController.getCommunityId();

        objRCSupportController.localeSetting();
        objRCSupportController.getURLCategory();
        //objRCSupportController.createURL('http://ringcentral.force.com/rcsupport', '','');
        objRCSupportController.getPage('http://ringcentral.force.com/rcsupport?id=test/');
        Test.StopTest();
    }
    static testMethod void EntitlementHelperTest() {
        // TO DO: implement unit test
     	  try {
     		// EntitlementHelper entitlementObj1 = new EntitlementHelper();
     		/*User su = new User(firstname='testEnttl', lastname='testEnttl', alias = 'Enttl', email='testEnttl@ringcentral.com', 
            emailencodingkey='UTF-8', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = EntitlementHelper.portalProfile.Id, 
            timezonesidkey='America/Los_Angeles', username='testEnttl@test.com');
        	insert su;*/
     		EntitlementEnable__c mycs = EntitlementEnable__c.getValues('IsEntitlementsEnabled__c');
			  if(mycs == null) {
			    mycs = new EntitlementEnable__c();
			    mycs.IsEntitlementsEnabled__c = true;
			    mycs.Name = 'IsEntitlementsEnabled';
			    insert mycs;
		  	}
     		EntitlementHelper.IsEntitlementsEnabled();
     		Schema.DescribeSObjectResult result = Account.SObjectType.getDescribe();
    		Map<string,Schema.RecordTypeInfo> rtMapByName = result.getRecordTypeInfosByName(); 
     		
     		Account acctest = new Account();
	     	acctest.Name = 'TestAccount';
	     	acctest.RecordTypeId  = rtMapByName.get('Customer Account').getRecordTypeId(); //Customer Account
	     	acctest.RC_Service_name__c = 'FAX';
	     	acctest.RC_Brand__c = 'RingCentral';
	     	
	     	Account acctest1 = new Account();
	     	acctest1.Name = 'TestAccount1';
	     	acctest1.RecordTypeId  = rtMapByName.get('Customer Account').getRecordTypeId();
	     	acctest1.RC_Service_name__c = 'Office';
	     	acctest1.RC_Brand__c = 'RingCentral';
	     	acctest.Number_of_DL_s__c = 5;
	     	
	     	Account acctest2 = new Account();
	     	acctest2.Name = 'TestAccount2';
	     	acctest2.RecordTypeId  = rtMapByName.get('Customer Account').getRecordTypeId();
	     	acctest2.RC_Service_name__c = 'Office';
	     	acctest2.RC_Brand__c = 'RingCentral';
	     	acctest2.Number_of_DL_s__c = 20;
	     	
	     	Account acctest3 = new Account();
	     	acctest3.Name = 'TestAccount3';
	     	acctest3.RecordTypeId  = rtMapByName.get('Customer Account').getRecordTypeId();
	     	acctest3.RC_Service_name__c = 'Office';
	     	acctest3.RC_Brand__c = 'RingCentral';
	     	acctest3.Number_of_DL_s__c = 10;
	     	
	     	List<Account> accList = new List<Account>();
	     	accList.add(acctest);
	     	accList.add(acctest1);
	     	accList.add(acctest2);
	     	accList.add(acctest3);
	     	
	     	TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT();
	     	insert accList;
	     	TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT = false;
	     	
	        Contact contObj = new Contact();
		    contObj.AccountId =  acctest.Id;
		    contObj.Email = 'abc2@test.com';
		    contObj.LastName = 'Test Last2';
		    contObj.FirstName = 'Test First2';
		    TriggerHandler.BY_PASS_CONTACT_ON_INSERT();
	      	insert contObj;
	      	TriggerHandler.BY_PASS_CONTACT_ON_INSERT = false;
	      	
	      	
	      	Schema.DescribeSObjectResult result1 = Case.SObjectType.getDescribe();
    		Map<string,Schema.RecordTypeInfo> rtMapByName1 = result1.getRecordTypeInfosByName(); 
	      	Group queue = [Select id from Group where Name = 'General Support Queue' limit 1];
	      	
	      	Test.startTest();
	      	
	      	Case caseObj = new Case();
	      	caseObj.AccountId = acctest.Id;
	      	caseObj.ContactId = contObj.id;
	      	caseObj.Subject = 'Test Case';
	      	caseObj.Description = 'Test Case Desc';
	      	caseObj.RecordTypeId = rtMapByName1.get('Support-Case').getRecordTypeId();
	      	caseObj.OwnerId = queue.Id;
	      	Test_Utils tutilsss = new Test_Utils();
	      	tutilsss.initialiseTriggerBypass();
	      	insert caseObj;
			tutilsss.deInitialiseTriggerBypass();
	      	EntitlementHelper.getSLAProcess();
	      	//EntitlementHelper.isChanged(acctest,acctest);
	      	EntitlementHelper.createEntitlements(accList,null);
	      	List<Entitlement> entitlementList = EntitlementHelper.getEntitlement(accList.get(0).id);
	      	if(entitlementList != null && entitlementList.size() != 0) {
	      		caseObj.EntitlementId = entitlementList.get(0).Id; 
	      	}
	      	caseObj.SlaStartDate = System.now();
    		
	      	CaseComment casecommentObj3 = new CaseComment();
	      	casecommentObj3.CommentBody = 'Test3';
	      	casecommentObj3.IsPublished = true;
	      	casecommentObj3.ParentId = caseObj.id;
	      	TriggerHandler.BY_PASS_CASECOMMENT_ON_INSERT();
	      	insert casecommentObj3;
	      	TriggerHandler.BY_PASS_CASECOMMENT_ON_INSERT = false;
	      	// Profile salesAgentProf = [select id from profile where name='Sales Agent']; 
            
	      	Case caseObjUpdated = caseObj;
	      	//caseObjUpdated.OwnerId = su.Id;
    		EntitlementHelper.closeCaseAssignedMilestone(new List<Case>{caseObjUpdated}, new Map<Id, Case>{caseObj.Id=>caseObj});
    		
    		
	      	Test.stopTest();
	      	
	 	  } catch(Exception ex) {}        
    }
        static testMethod void EscalateERTTeamtest() {
        // TO DO: implement unit test
        
    	EscalateERTTeam ertObj = new EscalateERTTeam();
    	
    	try {
    		Test.startTest();
    		Account acctest = new Account();
	        acctest.Name='TestAccount22';
	        acctest.RecordTypeId  = '01280000000UERq';
	        insert acctest; 
	        
	        Contact contObj = new Contact();
		    contObj.AccountId =  acctest.Id;
		    contObj.Email = 'abc22@test.com';
		    contObj.LastName = 'Test Last22';
	      	insert contObj;
	      	
	    	Case caseObj = new Case();
	    	caseObj.AccountId = acctest.Id;
	    	caseObj.ContactId = contObj.Id;
	    	Test_Utils tutilsss = new Test_Utils();
	    	tutilsss.initialiseTriggerBypass();
	    	insert caseObj;	
	    	tutilsss.deInitialiseTriggerBypass();
	    	Test.stopTest();
	    	EscalateERTTeam.escalateToERT(caseObj.Id);
    	} catch(Exception ex) {
    		
    	}
    
    }
    static testMethod void ImplementationHelperTest() {
             
   			Account acc = new Account();
   			acc.Name ='testAcc';
   			acc.OID__c = 'OID1';
   			insert acc;
   			
   			Implementation__c i = new Implementation__c( name='testImp', Implementation_Status__c = 'Needed' );
   			i.Account__c = acc.id;
   			insert i;
   			
   			offer_ID__c offData = new Offer_ID__c();
   			offData.OID__c = 'OID1';
   			offData.isPremiumSupport__c = true;
   			
   			insert offData;
   			List<Implementation__c> implList = new List<Implementation__c>();
   			Test.startTest();
   			ImplementationHelper.markAsPremiumSupportOIDs(implList);
   			Test.stopTest();
    }
    static testMethod void ITCSATSurveyControllertest() {
        // TO DO: implement unit test
        
    	Account acctest = new Account();
        acctest.Name = 'TestAccount';
        acctest.RecordTypeId  = '01280000000UERq';
        insert acctest; 
        
        Contact contObj = new Contact();
	    contObj.AccountId =  acctest.Id;
	    contObj.Email = 'test@test.com';
	    contObj.LastName = 'Test Last1';
	    contObj.FirstName = 'Test First1';
      	insert contObj;
	      	
    	Survey__c surveyObj1 = new Survey__c();
    	surveyObj1.SurveyType__c = 'IT Helpdesk CSAT';
    	surveyObj1.Name = 'Test Impl';
    	surveyObj1.Contact__c = contObj.Id;
    	surveyObj1.Contact_Email__c = 'test@test.com';
    	insert surveyObj1;
    	
    	Survey__c surveyObj2 = new Survey__c();
    	surveyObj2.SurveyType__c = 'IT Helpdesk CSAT';
    	surveyObj2.Name = 'Test Impl';
    	surveyObj2.Contact__c = contObj.Id;
    	surveyObj2.Contact_Email__c = 'test@test.com';
    	insert surveyObj2;
    	
    	Test.startTest();
    	
    	ITCSATSurveyController itcsatsurvey2 = new ITCSATSurveyController();
	    ApexPages.currentPage().getParameters().put('id', surveyObj1.id);
        ITCSATSurveyController itcsatsurvey1 = new ITCSATSurveyController();
        itcsatsurvey1.getValues1();
        itcsatsurvey1.save();
        itcsatsurvey1.answer1 = '1.00';
        itcsatsurvey1.answer2 = '2.00';
        itcsatsurvey1.answer3 = '2.00';
        itcsatsurvey1.answer4 = '2.00';
        itcsatsurvey1.answer5 = '3.00';
        itcsatsurvey1.answer6 = '3.00';
        itcsatsurvey1.answer7 = 'Test';
        itcsatsurvey1.save();
        itcsatsurvey1.setResponseValue();
        itcsatsurvey1.checkSurveyAlreadyFilled();
        new ITCSATSurveyController();
        ApexPages.currentPage().getParameters().put('id', surveyObj2.id);
        ITCSATSurveyController itcsatsurvey3 = new ITCSATSurveyController();
        
        Test.stopTest();
    
    }
    static testMethod void NewHireTriggerclassTest() {
        // TO DO: implement unit test
        
        RecordType rt=[SELECT Name, NamespacePrefix, Id, DeveloperName, SobjectType  FROM RecordType where SobjectType='case'  AND Name=:'IT New Hire Request'];   
        case cs = new case();
        cs.RecordTypeId=rt.ID;
        cs.Computer_Type__c ='Mac Power User';
        cs.FormSubmitterEmail__c ='test@test.com';
        cs.New_Hire_Services_and_Applications__c ='salesforce;inContact;Desktop required';
        cs.Mobile_Phone_w_Justification__c = 'Andiord';
        cs.Requires_BizServ__c=true;
        cs.Status='New';
        cs.New_Hire_Desk_Phone__c ='IP Phone and Extension;Analog Line and Phone';
        case objCaseDep = new case(Request_Type__c ='Helpdesk', Request_Subtype_1__c ='Hardware');
       
        List<case> cas = new List<case>();
        cas.add(cs);
        Test_Utils tutilsss = new Test_Utils();
        tutilsss.initialiseTriggerBypass();
    	insert cas;
    	tutilsss.deInitialiseTriggerBypass();
        
        Map<id,case> mapTestCaseNew=new Map<id,case>();
        Map<id,case> mapTestCaseOld=new Map<id,case>();
        mapTestCaseNew.put(cs.id,cs);
        mapTestCaseOld.put(cs.id,cs);
        
        NewHireTriggerclass cls = new NewHireTriggerclass();
        NewHireTriggerClass.createNewHireCases(mapTestCaseNew);
        NewHireTriggerClass.newHireupdate(mapTestCaseNew,mapTestCaseOld);
       // NewHireTriggerClass.excludeValues(cs);
        system.assertNotEquals(NewHireTriggerclass.getAssignedChildCases(objCaseDep, cs, 'IT Helpdesk'), null);
    
    }
}