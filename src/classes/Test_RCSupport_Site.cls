@isTest
private class Test_RCSupport_Site {

    
        static testMethod void RCSupportControllerCA2012test() {
        RCSupportControllerCA2012 objRCSupportController=new RCSupportControllerCA2012();
        RCSiteSetup__c objRCSiteName= (RCSiteSetup__c)SmartFactory.createSObject('RCSiteSetup__c', true);
        objRCSiteName.RCSiteName__c='rcsupport';
        upsert objRCSiteName;

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
    }
    static testMethod void RCSupportControllerCAtest() {
        // TO DO: implement unit test
        
        RCSupportControllerCA objRCSupportController = new RCSupportControllerCA();
        RCSiteSetup__c objRCSiteName= (RCSiteSetup__c)SmartFactory.createSObject('RCSiteSetup__c', true);
        objRCSiteName.RCSiteName__c='rcsupport';
        upsert objRCSiteName;
		Test.startTest();
        PageReference pageRef = new PageReference('/apex/RCSupportHome');
        Test.setCurrentPageReference(pageRef);
       
        objRCSupportController.getAuthToken(); 
        objRCSupportController.getBrandFilter();
        objRCSupportController.getCacheMaxAge();
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
        // objRCSupportController.getIdeaURL();
        objRCSupportController.getCaseURL();
        ApexPages.CurrentPage().getParameters().put('retUrl','service=1&brand=Ringcentral&token=test');
        ApexPages.CurrentPage().getParameters().put('brand','RC_UK');
        // objRCSupportController.getIdeaURL();
        objRCSupportController.getCaseURL();
        
        ApexPages.CurrentPage().getParameters().put('token','test');
        // objRCSupportController.getIdeaURL();
        objRCSupportController.getCaseURL();
     
        ApexPages.CurrentPage().getParameters().put('token','PFK8fqxUQZ3qw1nIWm0gVoPE1O1xEhiRFh0X3n0PxvEIzdYo+J2ihXuaSvfrFoOGXg5uqTH8KYo/2oohN5A7wQ==');
        // objRCSupportController.getIdeaURL(); 
        objRCSupportController.getCaseURL();
       
        // objRCSupportController.getIdeaURL(); 
        // objRCSupportController.updateUserProfile();
        // objRCSupportController.getCommunityId();

        objRCSupportController.localeSetting();
        objRCSupportController.getURLCategory();
       // objRCSupportController.createURL('http://ringcentral.force.com/rcsupport', '','');
        objRCSupportController.getPage('http://ringcentral.force.com/rcsupport?id=test/');
        Test.StopTest();
    }
    static testMethod void RCSupportAdvCaseDetailtest() {
        // TO DO: implement unit test
        
     	try {
     		Account acctest = new Account();
	     	acctest.Name = 'TestAccount';
	     	acctest.RecordTypeId  = '01280000000UERq';
	     	insert acctest; 
		        
	        Contact contObj = new Contact();
		    contObj.AccountId =  acctest.Id;
		    contObj.Email = 'abc2@test.com';
		    contObj.LastName = 'Test Last2';
		    contObj.FirstName = 'Test First2';
	      	insert contObj;
	      	
	      	Case caseObj = new Case();
	      	caseObj.AccountId = acctest.Id;
	      	caseObj.ContactId = contObj.id;
	      	caseObj.Subject = 'Test Case';
	      	caseObj.Description = 'Test Case Desc';
	      	insert caseObj;
	      	
	      	CaseComment casecommentObj1 = new CaseComment();
	      	casecommentObj1.CommentBody = 'Test';
	      	casecommentObj1.ParentId = caseObj.id;
	      	insert casecommentObj1;
	      	
	      	CaseComment casecommentObj2 = new CaseComment();
	      	casecommentObj2.CommentBody = 'Test1';
	      	casecommentObj2.ParentId = caseObj.id;
	      	insert casecommentObj2;
	      	
	      	Attachment attachObj = new  Attachment();
	      	attachObj.ParentId = caseObj.id;
	      	attachObj.Name = 'testAttachment';  
	      	attachObj.body = Blob.valueOf('dkjghdksgjdshgdkh');
	      	insert attachObj;
	      	
	      	Attachment attachObj1 = new  Attachment();
	      	attachObj1.Name = 'testAttachment';  
	      	attachObj1.body = Blob.valueOf('dkjghdksgjdshgdkh');
	      	
	      	Test.startTest();
	      	RCSupportAdvCaseDetail createcaseObj1 = new RCSupportAdvCaseDetail(new ApexPages.StandardController(caseObj));
	      	createcaseObj1.commentDesc = 'New Comment';
	      	createcaseObj1.addCaseComment();
	      	createcaseObj1.sentToClone();
	      	createcaseObj1.attachFile();
	      	createcaseObj1.attachment = attachObj1;
	      	createcaseObj1.attachFile();
	      	createcaseObj1.deleteAttachment();
	      	createcaseObj1.deleteAttachId = attachObj.id;
	      	createcaseObj1.deleteAttachment();
	      	Test.stopTest();	
     	} catch(Exception ex) {}
    }
    static testMethod void RCSupportAdvCaseCreatetest() {
     	try {
     		Account acctest = new Account();
	     	acctest.Name = 'TestAccount';
	     	acctest.RecordTypeId  = '01280000000UERq';
	     	insert acctest; 
		        
	        Contact contObj = new Contact();
		    contObj.AccountId =  acctest.Id;
		    contObj.Email = 'abc2@test.com';
		    contObj.LastName = 'Test Last2';
		    contObj.FirstName = 'Test First2';
	      	insert contObj;
	      	
	      	Case caseObj = new Case();
	      	caseObj.AccountId = acctest.Id;
	      	caseObj.ContactId = contObj.id;
	      	caseObj.Subject = 'Test Case';
	      	caseObj.Description = 'Test Case Desc';
	      	insert caseObj;
	      	
	      	CaseComment casecommentObj1 = new CaseComment();
	      	casecommentObj1.CommentBody = 'Test';
	      	casecommentObj1.ParentId = caseObj.id;
	      	insert casecommentObj1;
	      	
	      	CaseComment casecommentObj2 = new CaseComment();
	      	casecommentObj2.CommentBody = 'Test1';
	      	casecommentObj2.ParentId = caseObj.id;
	      	insert casecommentObj2;
	      	
	      	Attachment attachObj = new  Attachment();
	      	attachObj.ParentId = caseObj.id;
	      	attachObj.Name = 'testAttachment';  
	      	attachObj.body = Blob.valueOf('dkjghdksgjdshgdkh');
	      	insert attachObj;
	      	
	      	Attachment attachObj1 = new  Attachment();
	      	attachObj1.Name = 'testAttachment';  
	      	attachObj1.body = Blob.valueOf('dkjghdksgjdshgdkh');
	      	Test.StartTest();
	      	RCSupportAdvCaseCreate createcaseObj1 = new RCSupportAdvCaseCreate(new ApexPages.StandardController(new Case()));
	      	createcaseObj1.getcaseSeverityItemsValues();
	      	createcaseObj1.getproductAssistanceItemsValues();
	      	createcaseObj1.showArticleList();
	      	createcaseObj1.attachment = attachObj1;
	      	createcaseObj1.createCase();
	      	createcaseObj1.sortCaseList(); 
	      	createcaseObj1.selectSortValue = 'Case_Status';
	      	createcaseObj1.sortCaseList();
	      	createcaseObj1.searchCase();
	      	createcaseObj1.getcaseList1();
	      	createcaseObj1.selectSearchValue = 'Contact_Name';
	      	createcaseObj1.inputSearchValue = 'Test First2 Test Last2';
	      	createcaseObj1.searchCase();
	      	createcaseObj1.selectSearchValue = 'Case_Number';
	      	createcaseObj1.inputSearchValue = 'Test First2 Test Last2';
	      	createcaseObj1.searchCase();
	      	createcaseObj1.selectSearchValue = 'Subject';
	      	createcaseObj1.inputSearchValue = 'Test First2 Test Last2';
	      	createcaseObj1.searchCase();
	      	createcaseObj1.selectSearchValue = 'Severity_Level';
	      	createcaseObj1.inputSearchValue = 'Test First2 Test Last2';
	      	createcaseObj1.searchCase();
	      	ApexPages.currentPage().getParameters().put('parentId', caseObj.id);
	      	RCSupportAdvCaseCreate createcaseObj2 = new RCSupportAdvCaseCreate(new ApexPages.StandardController(new Case()));
	      	Test.stopTest();
	      	//createcaseObj2.actionType = 'Next';
	      	//createcaseObj2.getCasesPgItr();
	      	//createcaseObj2.actionType = 'Previous';
	      	//createcaseObj2.getCasesPgItr();
     	} catch(Exception ex) {}
    }
     static testMethod void RCSiteLoginControllertest() {
    	Profile guestUserProf  = [select id from profile where name ='RCPartner Profile'];
    	User su = new User(firstname='testGuest', lastname='testGuestLN', alias = 'testgst', email='testGuest@ringcentral.com', 
            emailencodingkey='UTF-8', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = guestUserProf.Id, 
            timezonesidkey='America/Los_Angeles', username='testGuest@test.com');
        insert su;
        System.runAs(su) {
        	Test.startTest();
        	ApexPages.currentPage().getCookies().put('oktaUserSessionId',new Cookie('oktaUserSessionId',null,null,0,false));
        	RCSiteLoginController rcSiteLoginObj = new RCSiteLoginController();
        	rcSiteLoginObj.forgotPassword();
        	rcSiteLoginObj.changePassword();
        	rcSiteLoginObj.login();
        	Test.stopTest();
        }
    }
}