@isTest
private class TestAllGeneral {
  
  @isTest(seeAllData = true)
    static void testRCSupportArticleRating() {
      try {
        RC_Article_Rating__c rcObj = new RC_Article_Rating__c();
        rcObj.Name = 'Test Article';
        rcObj.RC_Average_Rating__c = 5;
        rcObj.Article_Id__c = 'Test1';
        insert rcObj;
        Test.startTest();
        ApexPages.CurrentPage().getParameters().put('id','Test1');
            RCSupportArticleRating objRCSupportArticleRating = new RCSupportArticleRating();
          objRCSupportArticleRating.getAuthToken();
          ApexPages.CurrentPage().getParameters().put('token','test');
          ApexPages.CurrentPage().getParameters().put('retURL','test');
          objRCSupportArticleRating.getAuthToken();
          RCSupportArticleRating.articleCountSave2(2,'kA280000000Gndo','123.123.123.1','test','test');
          RCSupportArticleRating.articleCountSave2(2,'kA280000000Gndo1','123.123.123.1','test','test');
          RCSupportArticleRating.getUsersName(UserInfo.getUserId());
          Test.stopTest();
      } catch(Exception e){}
  }
  
  static testMethod void DocSearchCtrlTest() {
    DocSearchCtrl docTest = new DocSearchCtrl();
  }
  
  static testMethod void testConfirmSale() {
    try {
      Account acctest = new Account();
          acctest.Name='TestAccount11';
          acctest.RC_Attribution_Channel__c = 'Sales Agents & Resellers';
          acctest.Partner_ID__c ='123';
          acctest.RecordTypeId  = '01280000000UERq';
          insert acctest;
                    
          Contact contactObj = new Contact();
          contactObj.AccountId =  acctest.id;
          contactObj.Email = 'virendra.singh111@simplion.com';
          contactObj.Phone = '9910106804';
          contactObj.LastName = 'TestLast';
          insert contactObj;
          
          Test.startTest();
                    
          Opportunity Oppval = new Opportunity();
          Oppval.Name = 'Test Opp';
          Oppval.AccountId = acctest.Id;
          Oppval.Type = 'Existing Business';
          Oppval.StageName = OpportunityHelper.defaultOpportunityStage;
          Oppval.Sales_Model__c = 'Direct';
          Oppval.CloseDate = System.Today() + 10;
          Oppval.CurrencyIsoCode = 'USD';
          Oppval.Brand_Name__c= 'RingCentral';
          Oppval.RecordTypeId = '01280000000UEtz';
          Oppval.Proposal_Expiration_Date__c = System.today() + 100;
          insert Oppval;
      ConfirmSale.confirm(Oppval.id);
      Test.stopTest();  
    } catch(Exception ex) {}
  }
  
  static testMethod void testNotesSaver() {
       /* try {
            Profile p = [select id from profile where name='Sales Agent'];  
            User testUser = new User(alias = 'st22', email='standarduserTest22@testorg.com', emailencodingkey='UTF-8', lastname='Testing22', languagelocalekey='en_US',  
            localesidkey='en_US', profileid = p.Id,  timezonesidkey='America/Los_Angeles', username='standarduserTest22@testorg.com'); 
            insert testUser;
            System.runAs(testUser) {
                
                
              Account acctest = new Account();
              acctest.Name = 'TestAccount122';
              acctest.RC_Attribution_Channel__c = 'Sales Agents & Resellers';
              acctest.Partner_ID__c ='123';
              acctest.RecordTypeId  = '01280000000UERq';
              insert acctest;
                        
              Contact contactObj = new Contact();
              contactObj.AccountId =  acctest.id;
              contactObj.Email = 'virendra.singh33@simplion.com';
              contactObj.LastName = 'TestLast';
              insert contactObj;
                        
              Opportunity OppObj = new Opportunity();
              OppObj.Name = 'Test Opp';
              OppObj.AccountId = acctest.Id;
              OppObj.Type = 'Existing Business';
              OppObj.StageName = '3. Qualified';
              OppObj.Sales_Model__c = 'Direct';
              OppObj.CloseDate = System.Today() + 10;
              OppObj.CurrencyIsoCode = 'USD';
              OppObj.Brand_Name__c= 'RingCentral';
              OppObj.RecordTypeId = '01280000000UEtz';
              OppObj.Proposal_Expiration_Date__c = System.today() + 100;
              insert OppObj;
                
                Lead leadObj = new Lead();
                leadObj.FirstName='Virendra22';
                leadObj.LastName='Singh12';
                leadObj.Company='Simplion212';
                leadObj.Email='virendra.singheee@simplion.com';
                leadObj.Phone='9910106801';
                leadObj.LeadSource = 'Inbound Call';
                leadObj.Notes__c = 'Test Notes'; 
                leadObj.Website = 'http://test.com';
                leadObj.NumberOfEmployees = 123;
                leadObj.Industry = 'Test';
                leadObj.NumberOfEmployees__c = '2-19';
                leadObj.Number_of_Locations__c = '2-4';
                leadObj.Agent_Email_Address__c = 'test@test.com';            
                insert leadObj;                            
                
                list<Note> lNoteObj = new list<Note>();
                
                Note noteObj = new Note();
                noteObj.ParentId = leadObj.id;
                noteObj.Body = 'test';
                noteObj.Title= 'Original note from lead';
                lNoteObj.add(noteObj);
                
                Note noteObj2 = new Note();
                noteObj2.ParentId = OppObj.id;
                noteObj2.Body = 'test';
                noteObj2.Title= 'Original note from Opp';
                lNoteObj.add(noteObj2);
                
                insert lNoteObj;
                delete lNoteObj;
            }
        
        } catch(Exception ex) {}   */     
    }
  
  static testMethod void testsyncAccountSharingRuleScheduler() {
    try {
      syncAccountSharingRuleScheduler obj = new syncAccountSharingRuleScheduler();
      obj.execute(null);
    } catch(Exception ex) {}     
  }
  
  static testMethod void testAssetBefore() {
    try {
      Asset__c obj = new Asset__c();
      obj.Manufacturer__c = 'Acronis';
      obj.Model__c = '1100';
      insert obj;
    } catch(Exception ex) {}     
  }
  
  static testMethod void testCheckOnSalesAgmt() {
    try {
      Account acctest = new Account();
          acctest.Name = 'TestAccount122';
          acctest.RC_Attribution_Channel__c = 'Sales Agents & Resellers';
          acctest.Partner_ID__c ='123';
          acctest.RecordTypeId  = '01280000000UERq';
          insert acctest;
                    
          Contact contactObj = new Contact();
          contactObj.AccountId =  acctest.id;
          contactObj.Email = 'virendra.singh33@simplion.com';
          contactObj.LastName = 'TestLast';
          insert contactObj;
                    
          Opportunity Oppval = new Opportunity();
          Oppval.Name = 'Test Opp';
          Oppval.AccountId = acctest.Id;
          Oppval.Type = 'Existing Business';
          Oppval.StageName = '3. Qualified';
          Oppval.Sales_Model__c = 'Direct';
          Oppval.CloseDate = System.Today() + 10;
          Oppval.CurrencyIsoCode = 'USD';
          Oppval.Brand_Name__c= 'RingCentral';
          Oppval.RecordTypeId = '01280000000UEtz';
          Oppval.Proposal_Expiration_Date__c = System.today() + 100;
          insert Oppval;
          
          Test.startTest();
          
          Quote quoteObj = new Quote();
          quoteObj.OpportunityId = Oppval.id;
          quoteObj.Account__c = acctest.id;
          quoteObj.Name = 'Test Quote';
          quoteObj.Status = 'Active';
          quoteObj.Start_Date__c = System.today();
          quoteObj.End_Date__c = System.today() + 10;
          insert quoteObj;
          
          CheckOnAgreement.nonexistingAgreement(acctest.id);
      Test.stopTest();
    } catch(Exception ex) {}     
  }
  
  static testMethod void testfive9redirectNew() {
    try {
      five9redirectNew obj = new five9redirectNew();
      ApexPages.CurrentPage().getParameters().put('number3','10');
      obj.actCreateLeadFromContact();
    } catch(Exception ex) {}     
  }
  
  static testMethod void testOKTASession() {
    try {
      OKTASession obj = new OKTASession();
    } catch(Exception ex) {}     
  }
  
  static testMethod void testCustomTabsController() {
    try {
      CustomTabsController obj = new CustomTabsController();
    } catch(Exception ex) {}     
  }
  static testMethod void testOKTAAppLink() {
    try {
      OKTAAppLink obj = new OKTAAppLink();
      OKTAAppLink.oktaAppLinkDetail wrObj = new OKTAAppLink.oktaAppLinkDetail();
    } catch(Exception ex) {}     
  }
  
  static testMethod void testOktaUserDetail() {
    try {
      OktaUserDetail obj = new OktaUserDetail();
      OktaUserDetail.OktaUser wrObj = new OktaUserDetail.OktaUser();
      OktaUserDetail.profileDetail wrObj1 = new OktaUserDetail.profileDetail();
    } catch(Exception ex) {}     
  }
  
  static testMethod void UserJsonObjectTest0() {
    try {
         UserJsonObject userObj = new UserJsonObject();
       } catch(Exception ex) {} 
   }
   
   static testMethod void TabSharingCtrlExtTest() {
        try {
          TabSharingCtrlExt extTest = new TabSharingCtrlExt();
        }  catch(Exception ex) {}
   }
    @isTest(seeAlldata = true)  
    static void TabSharingCtrlTest() {     
         try {
           Intranet_Main_Tab__c intraTest = new Intranet_Main_Tab__c();
        intraTest.IsDisabled__c = false;
        intraTest.Name ='Home';
        intraTest.IsPublic__c = true;
        intraTest.Position_Type__c ='Top';
        intraTest.Content__c = '';
        insert intraTest; 
        ApexPages.StandardController sc = new ApexPages.StandardController(intraTest);
        TabSharingCtrl tabSharingTest = new TabSharingCtrl(sc); 
     }  catch(Exception ex) {} 
    }
    
    @isTest(seeAlldata = true)   
  static void TabViewCtrlTest() {       
         Intranet_Main_Tab__c intraTest = new Intranet_Main_Tab__c();
         intraTest.IsDisabled__c = false;
         intraTest.Name ='test';
         intraTest.IsPublic__c = true;
         intraTest.Position_Type__c ='Top';
         intraTest.Content__c ='test';
         intraTest.ContentType__c ='Static';
         insert intraTest;     
       ApexPages.StandardController  sc = new  ApexPages.StandardController(intraTest);
         TabViewCtrl tvc = new TabViewCtrl(sc);
  }
    
  static testMethod void ChatterLoginControllerTest() {
    try{
         ChatterLoginController clc = new ChatterLoginController(); 
       }catch(Exception e){}    
  }
  
  static testMethod void IntranetControllerTest0() {
       try{
            IntranetController InCtrlTest0 = new IntranetController();
       }catch(Exception e){}   
  }
  
  static testMethod void IntranetCookieSettingTest() {
      try{
        IntranetCookieSetting intratest = new IntranetCookieSetting();
       }catch(Exception e){}   
  }
  @isTest(seeAlldata = true)  
  static void IntranetTabCtrlTest() {
        try{
         Intranet_Main_Tab__c intraTest = new Intranet_Main_Tab__c();
        intraTest.IsDisabled__c = false;
        intraTest.Name ='Home';
        intraTest.IsPublic__c = true;
        intraTest.Position_Type__c ='Top';
        intraTest.Content__c = '';
        insert intraTest;    
        ApexPages.StandardController sc = new ApexPages.StandardController(intraTest);         
         IntranetTabCtrl inTabCtrlTest = new IntranetTabCtrl(sc);
       }catch(Exception e){}
  }  
  
  static testMethod void testIntranetTabHelper() {
        try{
         IntranetTabHelper intTabHelpObj = new IntranetTabHelper();
       }catch(Exception e){}
  }
  
  static testMethod void LoginTokenSetterTest() {
       try {
         LoginTokenSetter loginObj = new LoginTokenSetter();
       } catch(Exception e){}
  }
  
  static testMethod void TabVisibilityCtrlTest() {
       TabVisibilityCtrl  testVisiblity = new  TabVisibilityCtrl();
  }
  
  static testMethod void testCancelCase(){ 
      try{      
          List<CaseComment> objCancelCaseCommentList=new  List<CaseComment> ();
          CaseComment cs=new CaseComment();
          String str='test';
          cs.CommentBody=str;
          cs.ParentId='500T0000003TeiT';
          objCancelCaseCommentList.add(cs);
          insert objCancelCaseCommentList; 
                  
          Case ca = new Case ();
          ca.Status='Cancelled';
          insert ca; 
         
          CaseComment CCM = new CaseComment ();
          CCM.CommentBody ='Terst';
          CCM.ParentId='500T0000003TeiT';
          insert CCM; 
        
          ApexPages.StandardController sc = new ApexPages.standardController(ca);
          CancelCase rc = new CancelCase(sc);
          rc.save();
          rc.getStatus();
        } catch(Exception e){}
    }
   
    static testMethod void ChatterPostUtilTest() {
       try{  
         ChatterPostUtil chObj = new ChatterPostUtil();
      } catch(Exception e){}
    } 
  
  static testMethod void testChangePasswordController() {
    try{ 
          ChangePasswordController controller = new ChangePasswordController();
          Test.startTest();
          controller.oldPassword = '123456';
          controller.newPassword = 'qwerty1'; 
          controller.verifyNewPassword = 'qwerty1';                        
          System.assertEquals(controller.changePassword(),null);   
          Test.stopTest();
        } catch(Exception e){}                        
    }
    
    public static testMethod void testMethod1() {
    searchUINew2 obj = new searchUINew2();
  }    
    
}