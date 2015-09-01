/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 */
@isTest
private class Test_RCSupportAdvCaseCreate {
  
  static{
    List<Portals_List__c> lstPortal = new List<Portals_List__c>();
    lstPortal.add(new Portals_List__c(Name = 'success.ringcentral.com', Brand__c = 'RC US'));
    insert lstPortal;
    
    List<Product_Assistance_List__c> lstProductAss = new List<Product_Assistance_List__c>();
    lstProductAss.add(new Product_Assistance_List__c(Name = 'Company Settings', Portal__c = 'RC US, RC CA, RC UK, BT'));
    insert lstProductAss;
    
    TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT = true;
      TriggerHandler.BY_PASS_ACCOUNT_ON_UPDATE = true;
      TriggerHandler.BY_PASS_CONTACT_ON_INSERT = true;
      TriggerHandler.BY_PASS_CONTACT_ON_UPDATE = true;
      TriggerHandler.BY_PASS_CASE_ON_INSERT = true;
      TriggerHandler.BY_PASS_CASE_ON_UPDATE = true;
  }
  
  static testMethod void myUnitTest1() {
        try {
          TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT = true;
          TriggerHandler.BY_PASS_ACCOUNT_ON_UPDATE = true;
          TriggerHandler.BY_PASS_CONTACT_ON_INSERT = true;
          TriggerHandler.BY_PASS_CONTACT_ON_UPDATE = true;
          TriggerHandler.BY_PASS_CASE_ON_INSERT = true;
          TriggerHandler.BY_PASS_CASE_ON_UPDATE = true;
          
          EntitlementEnable__c mycs = EntitlementEnable__c.getValues('IsEntitlementsEnabled__c');
        if(mycs == null) {
          mycs = new EntitlementEnable__c();
          mycs.IsEntitlementsEnabled__c = true;
          mycs.Name = 'IsEntitlementsEnabled';
          insert mycs;
        }
        
        Account acctest = new Account();
            acctest.Name = 'TestAccount';
            acctest.RecordTypeId  = '01280000000UERq';
            insert acctest; 
            
            List<Contact> lstCont = new List<Contact>();
            Contact contObj = new Contact();
            contObj.AccountId =  acctest.Id;
            contObj.Email = 'abc2@test.com';
            contObj.LastName = 'Test Last2';
            contObj.FirstName = 'Test First2';
            contObj.Phone_Ext__c = Double.valueOf('1234');
            lstCont.add(contObj);
            
            Contact contObj1 = new Contact();
            contObj1.AccountId =  acctest.Id;
            contObj1.FirstName = 'Manish';
            contObj1.LastName = 'Singh';
            contObj1.Email = 'manish@simplon.com';
            contObj1.Phone= '1234567891';
            contObj1.Phone_Ext__c= Double.valueOf('1234');
            lstCont.add(contObj1);
        
        insert lstCont;
        
        Case caseObj = new Case();
            caseObj.AccountId = acctest.Id;
            caseObj.ContactId = contObj.id;
            caseObj.Subject = 'Test Case';
            caseObj.Description = 'Test Case Desc';
            insert caseObj;
            
            List<CaseComment> lstcasecomment  = new List<CaseComment>();
            CaseComment casecommentObj1 = new CaseComment();
            casecommentObj1.CommentBody = 'Test';
            casecommentObj1.ParentId = caseObj.id;
            lstcasecomment.add(casecommentObj1);
            
            CaseComment casecommentObj2 = new CaseComment();
            casecommentObj2.CommentBody = 'Test1';
            casecommentObj2.ParentId = caseObj.id;
            lstcasecomment.add(casecommentObj2);
            insert lstcasecomment;
            
            List<Attachment> lstAtt = new List<Attachment>();
            Attachment attachObj = new  Attachment();
            attachObj.ParentId = caseObj.id;
            attachObj.Name = 'testAttachment';  
            attachObj.body = Blob.valueOf('dkjghdksgjdshgdkh');
            //insert attachObj;
            lstAtt.add(attachObj);
            
            Attachment attachObj1 = new  Attachment();
            attachObj1.Name = 'testAttachment';  
            attachObj1.body = Blob.valueOf('dkjghdksgjdshgdkh');
            attachObj1.ParentId = caseObj.id;
            lstAtt.add(attachObj1);
            insert lstAtt;
            
            Portal_Cases_Record_Types__c cs1 = new Portal_Cases_Record_Types__c();
            cs1.Name = 'Support - T1';
            insert cs1;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Customer Portal User']; 
       
       User LoginUser = new User(ContactId = lstCont[0].Id, Alias = 'standt', Email='standarduser@testorg.com',  EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                     LocaleSidKey='en_US', ProfileId = p.Id,TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.com');
            insert LoginUser;
             System.runAs(LoginUser) {
               Test.startTest();
              RCSupportAdvCaseCreate createcaseObj1 = new RCSupportAdvCaseCreate(new ApexPages.StandardController(new Case()));
              createcaseObj1.loginUser = LoginUser;
              system.debug('loginUser========='+loginUser);
              createcaseObj1.ConDetail.FirstName = 'Manish';
          createcaseObj1.ConDetail.LastName = 'Singh';
          createcaseObj1.ConDetail.Email = 'manish@simplion.com';
          createcaseObj1.ConDetail.Phone = '1234567891';
          createcaseObj1.ConDetail.Phone_Ext__c = Double.valueOf('1122');
          createcaseObj1.selectedViewOptions1 ='All Open Cases';
          createcaseObj1.PhoneExt = '1122';
          createcaseObj1.actionType ='Previous';
            createcaseObj1.getcaseSeverityItemsValues();
              createcaseObj1.getproductAssistanceItemsValues();
              createcaseObj1.showArticleList();
              createcaseObj1.attachment = attachObj1;
              createcaseObj1.fileSize = (1024 * 1024);
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
              createcaseObj1.getcaseSeverityItemsValues();
              createcaseObj1.setPortalQuestion();
              createcaseObj1.assistanceChange();
              
             
              ApexPages.currentPage().getParameters().put('parentId', caseObj.id);
              RCSupportAdvCaseCreate createcaseObj2 = new RCSupportAdvCaseCreate(new ApexPages.StandardController(new Case()));
              createcaseObj2.ConDetail.FirstName = 'Manish';
          createcaseObj2.ConDetail.LastName = 'Singh';
          createcaseObj2.ConDetail.Email = 'manish@simplion.com';
          createcaseObj2.ConDetail.Phone = '1234567891';
          createcaseObj2.ConDetail.Phone_Ext__c =  Double.valueOf('2211');
              createcaseObj2.createCase();
              createcaseObj2.SummitCase();
              
              Test.stopTest();
               
             }
            
        } catch(Exception ex) {
          system.Debug('>>ex>>'+ex.getMessage());
        }
    }
    
     static testMethod void myUnitTest2() {
       try {
         EntitlementEnable__c mycs = EntitlementEnable__c.getValues('IsEntitlementsEnabled__c');
        if(mycs == null) {
          mycs = new EntitlementEnable__c();
          mycs.IsEntitlementsEnabled__c = true;
          mycs.Name = 'IsEntitlementsEnabled';
          insert mycs;
        }
        
            Account acctest = new Account();
            acctest.Name = 'TestAccount';
            acctest.RecordTypeId  = '01280000000UERq';
            insert acctest; 
            
            List<Contact>   lstCont = new List<Contact>();  
            Contact contObj = new Contact();
            contObj.AccountId =  acctest.Id;
            contObj.Email = 'abc2@test.com';
            contObj.LastName = 'Test Last2';
            contObj.FirstName = 'Test First2';
            contObj.Phone_Ext__c = Double.valueOf('123');
            //insert contObj;
            lstCont.add(contObj);
            
            Contact contObj1 = new Contact();
            contObj1.AccountId =  acctest.Id;
            contObj1.FirstName = 'Manish';
            contObj1.LastName = 'Singh';
            contObj1.Email = 'manish@simplon.com';
            contObj1.Phone= '1234567891';
            contObj1.Phone_Ext__c = Double.valueOf('1234');
            lstCont.add(contObj1);
            insert lstCont;
            
            Case caseObj = new Case();
            caseObj.AccountId = acctest.Id;
            caseObj.ContactId = contObj.id;
            caseObj.Subject = 'Test Case';
            caseObj.Description = 'Test Case Desc';
            insert caseObj;
            
            Portal_Cases_Record_Types__c cs1 = new Portal_Cases_Record_Types__c();
            cs1.Name = 'Support - T1';
            insert cs1;
            
            List<CaseComment> lstCC = new List<CaseComment>();
            CaseComment casecommentObj1 = new CaseComment();
            casecommentObj1.CommentBody = 'Test';
            casecommentObj1.ParentId = caseObj.id;
            lstCC.add(casecommentObj1);
            
            CaseComment casecommentObj2 = new CaseComment();
            casecommentObj2.CommentBody = 'Test1';
            casecommentObj2.ParentId = caseObj.id;
            lstCC.add(casecommentObj2);
            insert lstCC;
            List<Attachment> lstAtt = new List<Attachment>();
            
            Attachment attachObj = new  Attachment();
            attachObj.ParentId = caseObj.id;
            attachObj.Name = 'testAttachment';  
            attachObj.body = Blob.valueOf('dkjghdksgjdshgdkh');
            lstAtt.add(attachObj);
           
            Attachment attachObj1 = new  Attachment();
            attachObj1.Name = 'testAttachment';  
            attachObj1.body = Blob.valueOf('dkjghdksgjdshgdkh');
            lstAtt.add(attachObj1);
            insert lstAtt;
           
            Test.startTest();
            RCSupportAdvCaseCreate createCaseObjDummy = new RCSupportAdvCaseCreate();
          
          RCSupportAdvCaseCreate createcaseObj3 = new RCSupportAdvCaseCreate(new ApexPages.StandardController(new Case())); 
          createcaseObj3.setPortalQuestion();
          
            createcaseObj3.selectedProduct = 'Test2';
            createcaseObj3.selectedProduct2 = 'Test3';
            createcaseObj3.selectedProduct3 = 'Test4';
            createcaseObj3.setPortalQuestion();
            createcaseObj3.assistanceChange();   
            Test.stopTest();
       } catch(Exception ex) {} 
     }

    static testMethod void myUnitTest() {
          EntitlementEnable__c mycs = EntitlementEnable__c.getValues('IsEntitlementsEnabled__c');
        if(mycs == null) {
          mycs = new EntitlementEnable__c();
          mycs.IsEntitlementsEnabled__c = true;
          mycs.Name = 'IsEntitlementsEnabled';
          insert mycs;
        }
        
        Account acctest = new Account(RC_Brand__c = 'test');
            acctest.Name = 'TestAccount';
            acctest.RecordTypeId  = '01280000000UERq';
            insert acctest; 
            
            List<Contact> lstCont = new List<Contact>();
            
            Contact contObj = new Contact();
            contObj.AccountId =  acctest.Id;
            contObj.Email = 'abc2@test.com';
            contObj.LastName = 'Test Last2';
            contObj.FirstName = 'Test First2';
            contObj.Phone_Ext__c = Integer.valueOf('1234');
            lstCont.add(contObj);
            
            Contact contObj1 = new Contact();
            contObj1.AccountId =  acctest.Id;
            contObj1.FirstName = 'Manish';
            contObj1.LastName = 'Singh';
            contObj1.Email = 'manish@simplion.com';
            contObj1.Phone= '1234567891';
            contObj1.Phone_Ext__c = Integer.valueOf('1234');
            lstCont.add(contObj1);
        
        insert lstCont;
        
        Case caseObj = new Case();
            caseObj.AccountId = acctest.Id;
            caseObj.ContactId = contObj.id;
            caseObj.Subject = 'Test Case';
            caseObj.Description = 'Test Case Desc';
            insert caseObj;
            
            List<CaseComment> lstcasecomment  = new List<CaseComment>();
            CaseComment casecommentObj1 = new CaseComment();
            casecommentObj1.CommentBody = 'Test';
            casecommentObj1.ParentId = caseObj.id;
            lstcasecomment.add(casecommentObj1);
            
            CaseComment casecommentObj2 = new CaseComment();
            casecommentObj2.CommentBody = 'Test1';
            casecommentObj2.ParentId = caseObj.id;
            lstcasecomment.add(casecommentObj2);
            insert lstcasecomment;
            
            Portal_Cases_Record_Types__c cs1 = new Portal_Cases_Record_Types__c();
            cs1.Name = 'Support - T1';
            insert cs1;
            
        Profile p = [SELECT Id FROM Profile WHERE Name='Customer Portal User']; 
       
       User LoginUser = new User( ContactId = lstCont[1].Id ,FirstName = 'Manish',LastName = 'Singh',Alias = 'standt', Email='manish@simplion.com',  
                      EmailEncodingKey='UTF-8',  LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id,
                      TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.com');
            insert LoginUser;
             System.runAs(LoginUser) {
               Test.startTest();
              ApexPages.currentPage().getParameters().put('parentId', caseObj.id);
              RCSupportAdvCaseCreate createcaseObj1 = new RCSupportAdvCaseCreate(new ApexPages.StandardController(new Case()));
             
              system.debug('loginUser========='+loginUser);
              createcaseObj1.ConDetail.FirstName = 'Manish';
          createcaseObj1.ConDetail.LastName = 'Singh';
          createcaseObj1.ConDetail.Email = 'manish@simplion.com';
          createcaseObj1.ConDetail.Phone = '12345679999';
          createcaseObj1.ConDetail.Phone_Ext__c = Double.valueOf('1134');
          createcaseObj1.PhoneExt = '1122';
          createcaseObj1.selectedViewOptions1 = 'All Open Cases';
          createcaseObj1.selectedProduct = 'test';
          createcaseObj1.selectedProduct2  = 'test';
          createcaseObj1.selectedProduct3 = 'test';
          createcaseObj1.setPortalQuestion();
          createcaseObj1.createCase();
          createcaseObj1.SummitCase();
          createcaseObj1.assistanceChange();
          createcaseObj1.showArticleList();
          Test.stopTest();
               
             }
    }
}