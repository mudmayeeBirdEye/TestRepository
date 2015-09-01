@isTest
private class Test_Survey_Signup {

     static testMethod void VARCustomerSurveyControllertest() {
        
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
      surveyObj1.SurveyType__c = 'VAR Customer';
      surveyObj1.Name = 'Test Impl';
      surveyObj1.Contact__c = contObj.Id;
      surveyObj1.Contact_Email__c = 'test@test.com';
      insert surveyObj1;
      
      Survey__c surveyObj2 = new Survey__c();
      surveyObj2.SurveyType__c = 'Sales1';
      surveyObj2.Name = 'Test Impl';
      surveyObj2.Contact__c = contObj.Id;
      surveyObj2.Contact_Email__c = 'test@test.com';
      insert surveyObj2;
      
      Test.startTest();
      
      VARCustomerSurveyController csatsurvey2 = new VARCustomerSurveyController();
      ApexPages.currentPage().getParameters().put('id', surveyObj1.id);
        VARCustomerSurveyController csatsurvey1 = new VARCustomerSurveyController();
        csatsurvey1.getValues1();
        csatsurvey1.getValues2();
        csatsurvey1.getValues3();
        csatsurvey1.getValues4();
        csatsurvey1.getValues5();
        csatsurvey1.save();
        csatsurvey1.answer1 = '1.00';
        csatsurvey1.answer2 = '2.00';
        csatsurvey1.answer31 = '2.00';
        csatsurvey1.answer32 = 'Yes';
        csatsurvey1.showdealerExpCall();
        csatsurvey1.answer33 = '3.00';
        //csatsurvey1.answer34 = '3.00';
        //csatsurvey1.surveyObj.X4_Survey__c = 'Yes';
        csatsurvey1.answer5 = '3.00';
        csatsurvey1.surveyObj.Comments__c = 'Test Comment';
        csatsurvey1.save();
        csatsurvey1.setResponseValue();
        csatsurvey1.checkSurveyAlreadyFilled();
        new VARCustomerSurveyController();
        ApexPages.currentPage().getParameters().put('id', surveyObj2.id);
        VARCustomerSurveyController csatsurvey3 = new VARCustomerSurveyController();
        Test.stopTest();
    
    }
    static testMethod void UploadTabImage_Test() {
      Folder dummyFolder=[Select id from Folder where name='Intranet Tab Images'];
      Document dummyDocument = new Document();
      dummyDocument.name = 'Default';
      dummyDocument.body = Blob.valueOf('Unit Test Document Body');
      dummyDocument.folderId=dummyFolder.Id;
      insert dummyDocument;
       Intranet_Main_Tab__c temp = new Intranet_Main_Tab__c();
    temp.IsDisabled__c = false;
    temp.Name ='Home';
    temp.IsPublic__c = true;
    temp.Position_Type__c ='Top';
    temp.Content__c = '';
    insert temp;
    Test.startTest();
      ApexPages.currentPage().getParameters().put('id', temp.id);
      
      ApexPages.StandardController sc = new ApexPages.StandardController(temp);  
       
      UploadTabImage uploadImageTest = new UploadTabImage(sc);
      uploadImageTest.uploadImage();  
      
      uploadImageTest.strFilename = 'test'; 
      uploadImageTest.uploadImage();  
      
      //uploadImageTest.getFileExtension('a.jpg');
      uploadImageTest.onEdit(); 
      
      uploadImageTest.objThumbanailDocument.body = Blob.valueOf('test');
      uploadImageTest.objThumbanailDocument.Name ='a.jpg';
      uploadImageTest.uploadImage();    
      Test.stopTest();          
   
    }
    static testMethod void SignUpLinksDemoTest() {
      TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT = true;
        TriggerHandler.BY_PASS_Approver_Trigger = true;
        TriggerHandler.BY_PASS_OPPORTUNITY_ON_INSERT = true;
        TriggerHandler.BY_PASS_OPPORTUNITY_ON_UPDATE = true;
    
  try{    SignUpLink__c signUpObj1 = new SignUpLink__c(Name='Signup001 Fax',
      List_Order__c=1,
      SignUpURL__c='http://www.ringcentral.com/' ,
      SAFID__c='Signup002',
      CurrencyType__c='US' ,
      SignType__c=1,SignUp_Link_Type__c = 'Customer',
      Status__c='Current');
      
      SignUpLink__c signUpObj2 = new SignUpLink__c(Name='Signup002 Mobile',
      List_Order__c=2,
      SignUpURL__c='http://www.ringcentral.com/' ,
      SAFID__c='Signup003',
      CurrencyType__c='CAN' ,
      SignType__c=1,SignUp_Link_Type__c = 'Customer',
      Status__c='Retired');
      
      SignUpLink__c signUpObj3 = new SignUpLink__c(Name='Signup003 Office',
      List_Order__c=3,
      SignUpURL__c='http://www.ringcentral.com/' ,
      SAFID__c='Signup004',
      CurrencyType__c='UK' ,SignUp_Link_Type__c = 'Customer',
      SignType__c=1,
      Status__c='Retired');
      
      SignUpLink__c signUpObj4 = new SignUpLink__c(Name='Signup004 Fax',
      List_Order__c=4,
      SignUpURL__c='http://www.ringcentral.com/' ,
      SAFID__c='Signup004',
      CurrencyType__c='UK' ,SignUp_Link_Type__c = 'Customer',
      SignType__c=0,
      Status__c='Retired');
      
      insert signUpObj1;
      insert signUpObj2;
      insert signUpObj3;
      insert signUpObj4;
    
      Offer_Id__c offer1 = new Offer_Id__c (
      Promotion_Name__c='offer001',
      List_Order__c=1,
      Description__c='offer003',
      OID__c='offer004',
      Tier_Type__c= 1,
      ProductName__c=signUpObj1.Id);
      Offer_Id__c offer2 = new Offer_Id__c (
      Promotion_Name__c='offer002',
      List_Order__c=2,
      Description__c='offer003',
      OID__c='offer004',
      Tier_Type__c=1,
      ProductName__c=signUpObj2.Id);
      Offer_Id__c offer3 = new Offer_Id__c (
      Promotion_Name__c='offer003',
      List_Order__c=3,
      Description__c='offer003',
      OID__c='offer004',
      Tier_Type__c=1,
      ProductName__c=signUpObj3.Id);
      Offer_Id__c offer4 = new Offer_Id__c (
      Promotion_Name__c='offer004',
      List_Order__c=4,
      Description__c='offer003',
      OID__c='offer004',
      Tier_Type__c=1,
      ProductName__c=signUpObj4.Id);
      
      insert offer1;
      insert offer2;
      insert offer3;
      insert offer4;
    
    Account accObj = new Account();
    accObj.Name = 'Test Account1';
    insert accObj;  
    
    Opportunity opp0 = new Opportunity();
    /*id, name, StageName, brand_name__c, tier_name__c, pid__c,ad__c,adgrpid__c,afn__c,aid__c,bmid__c,kid__c,oid__c,
                product__c,rckw__c,rcmt__c,sid__c,CampaignId, Partner_ID__c*/
    
    opp0.Name ='test';
    opp0.StageName ='3. ActivePipe';
    opp0.CloseDate = System.today()+ 3;
    opp0.Partner_ID__c = '111';
    opp0.AID__c = '222';
    opp0.BMID__c = '333';
    opp0.PID__c ='444';
    opp0.AccountId = accObj.id;
    
    insert opp0;
    
    Test.startTest();
    
    ApexPages.currentPage().getParameters().put('id', opp0.id); 
    SignUpLinksDemo suDemo0 = new SignUpLinksDemo(null);
    suDemo0.doSAve();
    Opportunity opp1 = new Opportunity();
    /*id, name, StageName, brand_name__c, tier_name__c, pid__c,ad__c,adgrpid__c,afn__c,aid__c,bmid__c,kid__c,oid__c,
                product__c,rckw__c,rcmt__c,sid__c,CampaignId, Partner_ID__c*/
    
    opp1.Name ='test';
    opp1.StageName ='3. ActivePipe';
    opp1.CloseDate = System.today()+ 3;
    opp1.Partner_ID__c = '111';
    opp1.AID__c = '222';
    opp1.BMID__c = '333';
    opp1.PID__c ='';
    opp1.AccountId = accObj.id;
    
    insert opp1;
    
    Campaign campaignObj = new Campaign(Name='TestCampaign',
    DNIS__c='Test006',
    AID__c='Test007',
    PID__c='Test008',
    BMID__c='Test009');
    insert campaignObj;
    
    
    ApexPages.currentPage().getParameters().put('id', opp1.id); 
    SignUpLinksDemo suDemo1 = new SignUpLinksDemo(null);
    suDemo1.setSelectedValue('');
    suDemo1.getTrialItems();
    //suDemo1.strRedenderdValue = 'false';
    suDemo1.doSAve();
    suDemo1.setTabName('US');
    suDemo1.getTabName();
    
    Opportunity opp2 = new Opportunity();
    /*id, name, StageName, brand_name__c, tier_name__c, pid__c,ad__c,adgrpid__c,afn__c,aid__c,bmid__c,kid__c,oid__c,
                product__c,rckw__c,rcmt__c,sid__c,CampaignId, Partner_ID__c*/
    
    opp2.Name ='test';
    opp2.StageName ='3. ActivePipe';
    opp2.CloseDate = System.today() + 3;
    opp2.Partner_ID__c = '111';
    opp2.AID__c = '222';
    opp2.BMID__c = '';
    opp2.PID__c ='444';
    opp2.CampaignId = campaignObj.id;
    opp2.AccountId = accObj.id;
    insert opp2;
    
    Test.stopTest();
    
    ApexPages.currentPage().getParameters().put('id', opp2.id); 
    SignUpLinksDemo suDemo2 = new SignUpLinksDemo(null);
    //suDemo2.strRedenderdValue = 'false';
    suDemo2.doSAve();
    suDemo2.setSelectedValueOffering(signUpObj1.id);
    suDemo2.getStrRedenderdValue();
    suDemo2.setStrRedenderdValue('false');
    suDemo2.getSelectedValueOffering();
    suDemo2.setSelectedValueRetired(signUpObj2.id);
    suDemo2.getSelectedValueRetired();
    suDemo2.getStrImageUrl();
    suDemo2.setStrImageUrl('tset');
    suDemo2.setSelectPartnerOffer(signUpObj3.id) ;
    suDemo2.getBlnSignUpType();
    suDemo2.setBlnSignUpType(true);
    suDemo2.getServiceItemsOfferingUS();
    suDemo2.getServiceItemsRetiredUS();
    suDemo2.getServiceItemsOfferingCAN();
    suDemo2.getServiceItemsRetiredCAN();
    suDemo2.getServiceItemsOfferingUK();
    suDemo2.getServiceItemsRetiredUK();
    suDemo2.getPartnerOffer();
    suDemo2.getPartnerOfferItems();
    suDemo2.getSelectTrial();
    suDemo2.getPartnerID();
    suDemo2.getBMID();
    suDemo2.getAID();
    suDemo2.getPID();
    suDemo2.getSPID();
    suDemo2.getPromotion();
    suDemo2.getOPPID();
    suDemo2.getSAFID();
    suDemo2.getIsNotAvailable();
    suDemo2.getStrUrl();
    suDemo2.setStrUrl('www.google.com');
    suDemo2.getSelectTrial();
    suDemo2.doSearch();
    suDemo2.getStrSignUpId();
    suDemo2.setStrSignUpId(signUpObj4.id);
    suDemo2.createParam('test','test','test');
    
    Campaign campaignObj2 = new Campaign(Name='TestCampaign',
    DNIS__c='Test007',
    AID__c='Test008',
    PID__c='Test009',
    BMID__c='Test090');
    
    insert campaignObj2;
    
    Opportunity opp4 = new Opportunity();
    
    opp4.Name ='test';
    opp4.StageName ='3. ActivePipe';
    opp4.CloseDate = System.today() + 3;
    /*opp4.Partner_ID__c = '';
    opp4.AID__c = '';
    opp4.BMID__c = '';
    opp4.PID__c ='';*/
    opp4.CampaignId = campaignObj2.id;
    opp4.AccountId = accObj.id;
    insert opp4;
    
      ApexPages.currentPage().getParameters().put('id', opp4.id); 
    SignUpLinksDemo suDemo4 = new SignUpLinksDemo(null);
      //suDemo4.SelectedValue = signUpObj1.id;
      suDemo4.getSelectedValue();
      //suDemo4.strRedenderdValue = 'true';
      suDemo4.doSAve();
      //suDemo4.strRedenderdValue = 'false';
      suDemo4.doSAve();
      suDemo4.selectTab();
      suDemo4.resetAll();
      
  } catch (exception e){}
    
    /*setBlnSignUpType(true);
    setSelectedValue(signUpObj1.id);
    setSelectedValueOffering(signUpObj2.id);*/
    
  
    }
    static testMethod void SalesSurveyControllertest() {
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
      surveyObj1.SurveyType__c = 'Sales';
      surveyObj1.Name = 'Test Impl';
      surveyObj1.Contact__c = contObj.Id;
      surveyObj1.Contact_Email__c = 'test@test.com';
      insert surveyObj1;
      
      Survey__c surveyObj2 = new Survey__c();
      surveyObj2.SurveyType__c = 'Sales1';
      surveyObj2.Name = 'Test Impl';
      surveyObj2.Contact__c = contObj.Id;
      surveyObj2.Contact_Email__c = 'test@test.com';
      insert surveyObj2;
      
      Test.startTest();
      
      SalesSurveyController csatsurvey2 = new SalesSurveyController();
      ApexPages.currentPage().getParameters().put('id', surveyObj1.id);
        SalesSurveyController csatsurvey1 = new SalesSurveyController();
        csatsurvey1.getValues1();
        csatsurvey1.getValues2();
        csatsurvey1.getValues3();
        csatsurvey1.getValues4();
        csatsurvey1.getValues5();
        csatsurvey1.save();
        csatsurvey1.answer1 = '1.00';
        csatsurvey1.answer2 = '2.00';
        csatsurvey1.answer31 = '2.00';
        csatsurvey1.answer32 = 'Yes';
        csatsurvey1.answer33 = '3.00';
        //csatsurvey1.answer34 = '3.00';
        //csatsurvey1.surveyObj.X4_Survey__c = 'Yes';
        csatsurvey1.answer5 = '3.00';
        csatsurvey1.surveyObj.Comments__c = 'Test Comment';
        csatsurvey1.save();
        csatsurvey1.setResponseValue();
        csatsurvey1.checkSurveyAlreadyFilled();
        new SalesSurveyController();
        ApexPages.currentPage().getParameters().put('id', surveyObj2.id);
        SalesSurveyController csatsurvey3 = new SalesSurveyController();
        Test.stopTest();
    
    }
    static testMethod void RCSupportControllerUKtest() {
        RCSupportControllerUK objRCSupportController=new RCSupportControllerUK();
        RCSiteSetup__c objRCSiteName= (RCSiteSetup__c)SmartFactory.createSObject('RCSiteSetup__c', true);
        objRCSiteName.RCSiteName__c='rcsupport';
        upsert objRCSiteName;

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
        objRCSupportController.getCaseURL();
        ApexPages.CurrentPage().getParameters().put('retUrl','service=1&brand=Ringcentral&token=test');
        ApexPages.CurrentPage().getParameters().put('brand','RC_UK');
        objRCSupportController.getCaseURL();
        
        ApexPages.CurrentPage().getParameters().put('token','test');
        objRCSupportController.getCaseURL();
     
        ApexPages.CurrentPage().getParameters().put('token','PFK8fqxUQZ3qw1nIWm0gVoPE1O1xEhiRFh0X3n0PxvEIzdYo+J2ihXuaSvfrFoOGXg5uqTH8KYo/2oohN5A7wQ==');
        objRCSupportController.getCaseURL();
       
        objRCSupportController.localeSetting();
        objRCSupportController.getURLCategory();
        //objRCSupportController.createURL('http://ringcentral.force.com/rcsupport', '','');
        objRCSupportController.getPage('http://ringcentral.force.com/rcsupport?id=test/');
  
    }
    static testMethod void RCSupportControllerFaxtest() {
        RCSupportControllerFax objRCSupportController = new RCSupportControllerFax();
        RCSiteSetup__c objRCSiteName= (RCSiteSetup__c)SmartFactory.createSObject('RCSiteSetup__c', true);
        objRCSiteName.RCSiteName__c='rcsupport';
        upsert objRCSiteName;

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
        objRCSupportController.getCaseURL();
        ApexPages.CurrentPage().getParameters().put('retUrl','service=1&brand=Ringcentral&token=test');
        ApexPages.CurrentPage().getParameters().put('brand','RC_UK');
        objRCSupportController.getCaseURL();
        
        ApexPages.CurrentPage().getParameters().put('token','test');
        objRCSupportController.getCaseURL();
     
        ApexPages.CurrentPage().getParameters().put('token','PFK8fqxUQZ3qw1nIWm0gVoPE1O1xEhiRFh0X3n0PxvEIzdYo+J2ihXuaSvfrFoOGXg5uqTH8KYo/2oohN5A7wQ==');
        objRCSupportController.getCaseURL();
       
        objRCSupportController.localeSetting();
        objRCSupportController.getURLCategory();
        //objRCSupportController.createURL('http://ringcentral.force.com/rcsupport', '','');
        objRCSupportController.getPage('http://ringcentral.force.com/rcsupport?id=test/');
  
    }
}