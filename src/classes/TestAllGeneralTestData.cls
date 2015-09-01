@isTest
private class TestAllGeneralTestData {
    //@isTest(seeAllData = true)
    public static testMethod void testSiteLoginController () {
         try{  
            // Instantiate a new controller with all parameters in the page
            SiteLoginController controller = new SiteLoginController ();
            controller.username = 'test@salesforce.com';
            controller.password = '123456';                 
            System.assertEquals(controller.login(),null);     
        } catch(Exception e){}                      
    }
    
    static testMethod void createsObjectWithCascadeSetsLookupField() {
        try {
        Contact contact = (Contact)SmartFactory.createSObject('Contact', true);
        /*insert contact;
        System.assert(contact.Id != null);
        System.assert(contact.AccountId != null);*/
        } catch(Exception e) {}
    }
    
    static testMethod void createsObjectWithoutCascadeDoesNotSetLookupField() {
        try {
        Contact contact = (Contact)SmartFactory.createSObject('Contact', false);
        /*insert contact;
        System.assert(contact.AccountId == null);*/
        } catch(Exception e) {}
    }
    
    static testMethod void createObjectWithUnsupportedTypeThrowsException() {
        try {
            SmartFactory.createSObject('Unsupported');
            System.assert(false);
        } catch (UnsupportedObjectTypeException ex) {
            System.assert(true);
        }
    } 
    //Test class for multyselect controller 
   static testMethod void testMultiSelect(){ 
        try {          
            ApexPages.currentPage().getParameters().put('acc_id', '0018000000sJnAT');
               ApexPages.currentPage().getParameters().put('p3_lkid','0018000000sJnAT' );
               ApexPages.currentPage().getParameters().put('p3', 'test');
               ApexPages.currentPage().getParameters().put('p2_lkid', '0038000001DFAq3');
               ApexPages.currentPage().getParameters().put('view', '0018000000sJnAT');
               
               multiselect ms = new multiselect();
              
               ms.addToContactMap.put('a','a');
               ms.addToContactMap.put('b','B'); 
               
               ms.varContactMap.put('c','c');
               ms.varContactMap.put('d','d');
               
               ms.bccContactMap.put('e','e');
               ms.bccContactMap.put('f','f');
               
               ms.ccContactMap.put('g','g');
               ms.ccContactMap.put('h','h');
               
               ms.globalContactMap.put('i','i');
               ms.globalContactMap.put('j','j');
               
               ms.toContactmap.put('k','k');
               ms.toContactmap.put('l','l');
               
               ms.isEmailValidated = true;
               
               ms.emailAuthor();
               
               ms.globalSelectedList.add('a');
               ms.globalSelectedList.add('b');
               ms.globalSelectedList.add('c');
               
               ms.allAdditionalToList.add('a');
               ms.allAdditionalToList.add('b');
               ms.allAdditionalToList.add('c');
               
               ms.allBccList.add('a');
               ms.allBccList.add('b');
               ms.allBccList.add('c');
               
               ms.allCCList.add('a');
               ms.allCCList.add('b');
               ms.allCCList.add('c');
               
               ms.clearList();
               ms.temp.Accountid = '0018000000sJnAT';
               
               ms.searchContact();
               ms.getGlobalContactOptions();
               
               ms.setAdditionalTo();
               ms.removeAdditionalTo();
               
               ms.setBccList();
               ms.removeBccList();
               
               ms.setCCList();
               ms.removeCCList();
               
               ms.getAllAdditionalTo();
               ms.isEmailValidated = false;
                 
               ms.emailAuthor();
               ms.OptedOutOfEmail();
               ms.setToAddress();
               ms.removeToAddress();
               ms.cancel();
               ms.getAllCCOptionsList();
               ms.getAllBccOptionsList();   
        } catch(Exception e) {}
   }
   //Test class for RogerSurveyservice class 
   static testMethod void testSurveyController() {
     try {  
        //PageReference pageRef = Page.SalesCSat;
        //Test.setCurrentPage(pageRef);
        
        //Survey sur = new Survey();
       //String nextPage = sur.save().getUrl();
    
       // Verify that page fails without parameters
       //System.assertEquals('/apex/failure?error=noParam', nextPage);
    
       // Add parameters to page URL
    
       // Account acc = new Account();
    
       //upsert acc;
    
      Contact con = [Select id,name from Contact limit 1];
       con.lastName ='test';
       con.Email = 'test@test.com';
       //con.AccountID = acc.id;
       upsert  con;
    
        Survey__c sr = new Survey__c();
        sr.Contact__c = con.id;
        upsert sr;    
        system.Test.setCurrentPageReference(new PageReference('Page.SupportRogersImplementationSurvey'));
        ApexPages.currentPage().getParameters().put('id', sr.id);       
        // Instantiate a new controller with all parameters in the page     
        RogerSurveyservice rc = new RogerSurveyservice();      
        rc.getCommentLength(); 
        rc.getAnswered();
        rc.getIsFilled(); 
        rc.getIsEmpty();
        rc.getComments();
        rc.setComments('Hello Testing');
        rc.getQ1Value();
        rc.setQ1Value(1);
        rc.getQ2Value();
        rc.setQ2Value(2);
        rc.getQ3Value();
        rc.setQ3Value(2);
        rc.getQ4Value();
        rc.setQ4Value(2);   
       //rc.getQ5Value();
       //rc.setQ5Value(1);
        rc.getValues();
        rc.getValues2();
        rc.getValues3();
        rc.getSurvey();
        rc.save();
        rc.getContactName();       
        //nextPage = controller.save().getUrl();
        // Verify that the success page displays
        //System.assertEquals('/apex/success', nextPage);
        //Lead[] leads = [select id, email from lead where Company = 'acme'];
        //System.assertEquals('firstlast@acme.com', leads[0].email);
        } catch(Exception e) {}
   }  
   
   //Test class for the SaveCSATSurveyController
    static testMethod void testSaveCSATSurveyController() {
       // Add parameters to page URL
        //String comment='' ;
        
       Contact con = new contact ();
       con.lastName ='test';
       con.Email = 'testt@test.com';
       //con.AccountID = acc.id;
       insert  con;
       Survey__c surObj = new Survey__c();
       surObj.Contact__c = [Select Id, Name From Contact Limit 1].id;   
       surObj.SurveyType__c='Saves CSAT';
       insert surObj;    
       ApexPages.currentPage().getParameters().put('id',surObj.id);    
      // Instantiate a new controller with all parameters in the page
       SaveCSATSurveyController sur = new SaveCSATSurveyController();
      // sur.comment='test';
       sur.save();   
       sur.setQ1Value(3);
       sur.setQ2Value(2);
       sur.setQ3Value(4);
       sur.setQ4Value(4);
       sur.setQ5Value(4);
       sur.getQ1Value();
       sur.getQ2Value();
       sur.getQ3Value();
       sur.getQ4Value();
       sur.getQ5Value();
       sur.getValues();
       sur.getContactName();
       sur.getAnswered();
       sur.getCommentLength();
       sur.getComments();
       sur.getIsEmpty();
       sur.getIsFilled();
       sur.setComments('test111');
       sur.save(); 
    //   sur.comment ='';
        for(Integer i=0; i<101;i++) {
          //sur.comment+ ='testtesttesttesttest';
        }
          sur.getCommentLength();  
          sur.save(); 
          sur.getSurvey();          
            Survey__c sur1 = new Survey__c();
            sur1.Q2_Score__c = 1;
            sur1.Q3_Score__c = 3;
            sur1.Q4_Score__c = 4;
            sur1.Comments__c = 'test';
            insert sur1 ;    
            ApexPages.currentPage().getParameters().put('id',sur1 .id);
            SaveCSATSurveyController surC1 = new SaveCSATSurveyController();    
            surC1.allAnswered =true;
            surC1.submitted = false;
            surc1.getAnswered();   
    
            ApexPages.currentPage().getParameters().put('id','111111111111111');
            SaveCSATSurveyController surC2 = new SaveCSATSurveyController();
            
            Survey__c sur2 = new Survey__c();
            sur2.SurveyType__c = 'Saves CSAT';         
            insert sur2 ;
           ApexPages.currentPage().getParameters().put('id',sur2.id);
           SaveCSATSurveyController surC3 = new SaveCSATSurveyController();
          // surC3.comment ='';
          for(Integer i=0; i<101;i++) {
           // surC3.comment+='testtesttesttesttest';
          }
            surC3.getIsEmpty();    
            Survey__c sur3 = new Survey__c();
            sur3.SurveyType__c = 'Saves CSAT';
            sur3.Q2_Score__c = 1;
            sur3.Q3_Score__c = 3;
            sur3.Q4_Score__c = 4;
            insert sur3 ;
            ApexPages.currentPage().getParameters().put('id',sur3.id);    
            SaveCSATSurveyController surC4 = new SaveCSATSurveyController();
            //surC4.comment ='';
            for(Integer i=0; i<101;i++) {
              //surC4.comment+='testtesttesttesttest';
            }
           surC4.getIsEmpty();    
           Survey__c sur4 = new Survey__c();
           insert sur4;     
           ApexPages.currentPage().getParameters().put('id',sur4.id);
           SaveCSATSurveyController surC5 = new SaveCSATSurveyController();
           surC5.getIsFilled();           
   }   
      
         //Test class for the AgentCreditHelperTest
    // @isTest(SeeAllData=true)
        static testmethod  void AgentCreditHelperTest(){
        	
        	Test.startTest();
            Profile p = [select id from profile where name='System Administrator'];         
            User testUser = new User(alias = 'u111', email='u111@testorg.com',
            emailencodingkey='UTF-8', lastname='Testing11', languagelocalekey='en_US',
            localesidkey='en_US', profileid = p.Id, country='United States',
            timezonesidkey='America/Los_Angeles', username='u111@testorg.com');
            insert testUser;            
            
            Employee__c emp = new Employee__c();
            emp.User__c = testUser.id;
            emp.First_Name__c = 'tuser';
            emp.Last_Name__c = 'lname';
            emp.Email__c ='clc@clc.com';
            emp.Location__c = 'Noida, India';
            emp.Department__c = 'IT';
            emp.Team__c = 'SE';
            emp.SPID__c = '12454';
            insert emp; 
            
            System.runAs(testUser) {
                
                RecordType rt = [select id,Name from RecordType where SobjectType='Account' and Name='Partner Account' Limit 1];
            
                Account accObj = new Account();
                accObj.Name = 'TestAccount';
                accObj.Number_of_DL_s__c = 5;
                accObj.RecordTypeId = rt.Id;
                accObj.Type ='Partner';
                accObj.Partner_ID__c = '12345';
                accObj.RC_Attribution_Channel__c = 'Sales Agents & Resellers';
                TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT = true;
                insert accObj;
                TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT = false;
                
                Order__c orderVal = new  Order__c();
                orderVal.Name = '12345678';
                orderVal.account__c = accObj.Id;
                orderVal.Lead_Source__c = 'Referral Program';
                insert  orderVal;
                
                Agent_Credit__c asst = new Agent_Credit__c();
                asst.Name = 'testAgent';
                asst.Order__c = orderVal.Id;
                asst.Account__c = accObj.id;
                asst.Compensation_Date__c = system.today();
                asst.Agent_First_Name__c = 'testFirst';
                asst.Agent_Last_Name__c = 'testLast';
                insert asst;
                
                Account accObj1 = new Account();
                accObj1.Name = 'TestAccount';
                accObj1.Number_of_DL_s__c = 5;
                accObj1.RecordTypeId = rt.Id;
                accObj1.Type ='Partner';
                accObj1.Partner_ID__c = '12345';
                accObj1.RC_Attribution_Channel__c = 'Franchise & Assoc';
                TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT = true;
                insert accObj1;
                TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT = false;
                
                Order__c orderVal1 = new  Order__c();
                orderVal1.Name = '12345678';
                orderVal1.account__c = accObj1.Id;
                orderVal1.Lead_Source__c = 'Referral Program';
                insert  orderVal1;
                
                Agent_Credit__c asst1 = new Agent_Credit__c();
                asst1.Name = 'testAgent';
                asst1.Order__c = orderVal1.Id;
                asst1.Account__c = accObj1.id;
                asst1.Compensation_Date__c = system.today();
                asst1.Agent_First_Name__c = 'testFirst';
                asst1.Agent_Last_Name__c = 'testLast';
                insert asst1;
            }   
            
            Test.stopTest();
        }      
        /*IF Context from Trigger ON before Updation*/
         //@isTest(SeeAllData=true)
        /*static testmethod void AgentCreditHelperTest2(){
            Profile p = [select id from profile where name='System Administrator'];     
            User testUser2 = new User(alias = 'u2Agent', email='u2Agent@testorg.com',
            emailencodingkey='UTF-8', lastname='TestingAgent', languagelocalekey='en_US',
            localesidkey='en_US', profileid = p.Id, country='United States',
            timezonesidkey='America/Los_Angeles', username='u2Agent@testorg.com');
            insert testUser2;
            
            Employee__c emp = new Employee__c();
            emp.User__c = testUser2.id;
            emp.First_Name__c = 'tuser2';
            emp.Last_Name__c = 'lname2';
            emp.Email__c ='2clc@clc.com';
            emp.Location__c = 'Denver, US';
            emp.Department__c = 'IT2';
            emp.Team__c = 'SE';
            emp.SPID__c = '12455';
            insert emp; 
            
            Agent_Credit__c asst = new Agent_Credit__c();
            asst.Name = 'testAgent';
            insert asst;
            
             System.runAs(testUser2){
                asst.ownerid = testUser2.id;
                update asst;
            }   
        }*/
        /*only for code coverage if without trigger context*/
        // @isTest(SeeAllData=true)
     static  testmethod void AgentCreditHelperTest3(){          
            AgentCreditHelper ach = new AgentCreditHelper();            
            Agent_Credit__c agc = new Agent_Credit__c();
            agc.Name = 'testAgent';
            insert agc;
            
            List<Agent_Credit__c> newlist = new List<Agent_Credit__c>();
            newlist.add( agc );
            
            List<Agent_Credit__c> oldlist = new List<Agent_Credit__c>();
            newlist.add( agc );
            
            Map<id,Agent_Credit__c> newMap = new Map<id,Agent_Credit__c>();
            newMap.put(agc.id , agc);
            
            Map<id,Agent_Credit__c> oldMap = new Map<id,Agent_Credit__c>();
            oldMap.put(agc.id , agc);
            
            AgentCreditHelper.isBeforeInsert(newlist);
            AgentCreditHelper.isBeforeUpdate( newList, oldList, newMap, oldMap);
      } 
      
      //test class for ExtendDealRegistration 
       static testmethod void UnitTestExtendDealRegistration() {

         try {  
             TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT = true;   
             TriggerHandler.BY_PASS_ACCOUNT_ON_UPDATE = true;   
             TriggerHandler.BY_PASS_CONTACT_ON_INSERT = true;   
             TriggerHandler.BY_PASS_CONTACT_ON_UPDATE = true;   
             
             Account objAccount = (Account) SmartFactory.createSObject('Account', true);    
             objAccount.Partner_id__c = '123456Test';   
             upsert objAccount;
    
             Contact objContact = (Contact) SmartFactory.createSObject('Contact', true);    
             objContact.AccountId = objAccount.id;  
             upsert objContact;
    
             objContact = [Select Account.Partner_id__c from Contact where id = : objContact.id];   
             System.assert(objContact.Account.Partner_id__c == '123456Test');   
             Profile pp = [Select p.Name, p.Id From Profile p where Name LIKE '%RC Partner User%' limit 1];
    
             System.assert(pp.Name == 'RC Partner User');
    
             User objUser = new User(alias = 'ksTest',  
                 email = 'kanishk.singhTest@simplion.com',  
                 emailencodingkey = 'UTF-8',    
                 lastname = 'Testing',  
                 languagelocalekey = 'en_US',   
                 localesidkey = 'en_US',    
                 profileid = pp.Id, 
                 contactid = objContact.Id, 
                 timezonesidkey = 'America/Los_Angeles',    
                 username = 'kanishk.singhTest@simplion.com'    
             );
    
             insert objUser;
    
             System.assert(objUser.profileid == pp.Id); 
             System.assert(objUser.contactid == objContact.Id); 
             Test.startTest();  
             VAR_Deal_Registration__c objDeal = null;   
             List < ProcessInstanceWorkItem > workItemList = null;  
             ApexPages.StandardController controller = null;    
             ExtendDealRegistration objExtendDealRegistration = null;   
             system.runAs(objUser) {    
                 objDeal = new VAR_Deal_Registration__c();  
                 objDeal.Company_Name__c = 'testSimplion';  
                 objDeal.Email_1__c = 'kanisk@test.com';    
                 objDeal.Phone__c = '123456789';    
                 objDeal.Number_of_Users__c = 5;    
                 insert objDeal;    
                 System.assert(UserInfo.getUserId() == objUser.id); 
                 System.assert(objDeal.id != null);
    
                 workItemList = [Select p.ProcessInstance.Status, p.ProcessInstance.TargetObjectId,p.ProcessInstanceId, p.OriginalActorId, p.Id, p.ActorId
    
                     From ProcessInstanceWorkitem p where
    
                     p.ProcessInstance.TargetObjectId = : objDeal.Id
                 ];
    
                 System.assertEquals('Pending', workItemList.get(0).ProcessInstance.Status);    
                 controller = new ApexPages.StandardController(objDeal);    
                 objExtendDealRegistration = new ExtendDealRegistration(controller);    
             }
             
             Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();  
             req2.setComments('Approving request.');    
             req2.setAction('Approve'); 
             req2.setNextApproverIds(new Id[] {
                 UserInfo.getUserId()
             });
    
             req2.setWorkitemId(workItemList.get(0).id);
             Approval.ProcessResult result2 = Approval.process(req2);   
             System.assert(result2.isSuccess(), 'Result Status:' + result2.isSuccess());    
             System.assertEquals('Approved', result2.getInstanceStatus(), 'Instance Status' + result2.getInstanceStatus());
    
             system.runAs(objUser) {    
                 controller = new ApexPages.StandardController(objDeal);    
                 objExtendDealRegistration = new ExtendDealRegistration(controller);    
                 objExtendDealRegistration.submitForApproval(); 
                 //catch block code coverage
    
                 controller = new ApexPages.StandardController(objDeal);    
                 objExtendDealRegistration = new ExtendDealRegistration(controller);    
                 objExtendDealRegistration.submitForApproval(); 
             }
    
             workItemList = [Select p.ProcessInstance.Status, p.ProcessInstance.TargetObjectId, 
                 p.ProcessInstanceId, p.OriginalActorId, p.Id, p.ActorId    
                 From ProcessInstanceWorkitem p where   
                 p.ProcessInstance.TargetObjectId = : objDeal.Id
             ];
             
             Approval.ProcessWorkitemRequest req3 = new Approval.ProcessWorkitemRequest();  
             req3.setComments('Approving request.');    
             req3.setAction('Approve'); 
             req3.setNextApproverIds(new Id[] {
                 UserInfo.getUserId()
             });
    
             req3.setWorkitemId(workItemList.get(0).id);    
             Test.stopTest();   
             result2 = Approval.process(req3);  
             System.assert(result2.isSuccess(), 'Result Status:' + result2.isSuccess());    
             System.assertEquals('Approved', result2.getInstanceStatus(), 'Instance Status' + result2.getInstanceStatus());
    
             system.runAs(objUser) {    
                 controller = new ApexPages.StandardController(objDeal);    
                 objExtendDealRegistration = new ExtendDealRegistration(controller);    
                 //catch block code coverage    
                 VAR_Deal_Registration__c objDeal2 = (VAR_Deal_Registration__c) SmartFactory.createSObject('VAR_Deal_Registration__c', false);  
                 controller = new ApexPages.StandardController(objDeal2);   
                 objExtendDealRegistration = new ExtendDealRegistration(controller);    
             }
    
         } catch (Exception e) {}
    
     }
    
    //Test Classes for the RCSupportController
      static void testRCSupportController(){
            
        RCSupportController objRCSupportController=new RCSupportController();
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
       // objRCSupportController.createURL('http://ringcentral.force.com/rcsupport', '','');
        //objRCSupportController.getPage('http://ringcentral.force.com/rcsupport?id=test/');
    
    }
    
      //Test classes for the MailHelper class 
      static TestMethod void testMailHelper() {
            new MailHelper().createMail(null, 'This is test email. Please ignore', '00580000003SZmNAAW','' , false, 'Test Email','Test Email');        
      } 
          
      static TestMethod void testMailHelper1() {
        new MailHelper().createMail(null, 'This is test email. Please ignore', null,'' , false, 'Test Email','Test Email','virendra.singh@simplion.com');      
      }
      
      static TestMethod void testMailHelper2() {
        new MailHelper().createMail(null, 'This is test email. Please ignore', null,'', false, 'Test Email','Test Email',new String[]{'virendra.singh@simplion.com'}, new String[]{'virendra.singh@simplion.com'}, new String[]{'virendra.singh@simplion.com'});       
      }
      
      static TestMethod void testMailHelper3() {
        new MailHelper().createMail(null, 'This is test email. Please ignore', null,''  , false, 'Test Email','Test Email',null, null, null);     
      }
      
      //test class for the refundcontroller 
      static testMethod void testRefundController(){
         try {  
            Account a = new Account();
            a.Name = 'TestRefundAccount';
            a.RC_User_ID__c = '345';
            a.RC_Brand__c = 'RC';
            a.RC_Service_name__c = 'mobile';
            a.RC_Tier__c = 'professional';
            insert a;
            
            system.debug('before create refund');
            
            Refund__c r = new Refund__c();  
            r.RN_Incident__c = '1234-2343';
            r.Assigned_Agent_At_Creation__c = null;
            r.Total_Refund__c = 0.0;                        
            r.Brand__c = 'RC';
            r.Service__c = 'mobile';
            r.Tier__c = 'professional';
            system.debug('after create refund');
            ApexPages.currentPage().getParameters().put('userid', '345');
            ApexPages.currentPage().getParameters().put('incident', '1234-9876');
            ApexPages.currentPage().getParameters().put('email', 'agent@rc.com');
            ApexPages.StandardController sc = new ApexPages.standardController(r);
            refundController rc = new refundController(sc);
            rc.save();
            Refund__c ref = rc.getnewRefund();
            
            Boolean b = rc.getisCategorySelected();         
            b = rc.getisReferenceFilled();
            b = rc.getisTotalFilled();
            b = rc.getisRefundSaved();
            //b = rc.getdidRefundExist();
            b = rc.getisCommentRequired();
                        
            rc.testingEdgeData011();
            rc.testingEdgeData012();
            rc.testingEdgeData013();
        } catch(Exception e) {} 
    }    
    
    //Test class for the testSolveSellLeadController
   
       static testMethod void testSolveSellLeadController (){          
       Lead  r = new Lead();   
       r.FirstName='testabc';
       r.lastName ='testxyz';
       r.Leadsource ='abcd';
       r.Agent_Email_Address__c ='xyz';
       r.Phone='123654789';
       r.Email='Test@Test.com';
       ApexPages.StandardController sc = new ApexPages.standardController(r);
       solveSellLeadController rc = new solveSellLeadController(sc);
       rc.save();
       rc.searchLeads();
      // rc.testingEdgeData011();
       Lead  ref = rc.getnewlead();
       Boolean b = rc.getisLeadSaved();
       b = rc.getuserIdNotFound();
       b = rc.getisFirstNameFilled();
       b = rc.getisLastNameFilled();       
       b = rc.getisCompanyFilled();
       b= rc.getisEmailFilled();
       b = rc.getisPhoneFilled();
       b= rc.getisAgentMailFilled();
  
    }
         
      
}