/**
 * This class contains unit tests for validating the behavior of Apex classe 'SupportPortalAdvCaseDetail'
*/
@isTest
private class TestSupportPortalCaseDetail {
    static testMethod void testCreateCase() {
     try {  
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
        acctest.RecordTypeId = rtMapByName.get('Customer Account').getRecordTypeId();
        acctest.RC_Service_name__c = 'FAX';
        acctest.RC_Brand__c = 'BTCloudPhone';
        insert acctest; 
            
        Contact contObj = new Contact();
        contObj.AccountId =  acctest.Id;
        contObj.Email = 'abc2@test.com';
        contObj.LastName = 'Test Last2';
        contObj.FirstName = 'Test First2';
        insert contObj;
        
        BusinessHours businessObj = [Select b.WednesdayStartTime, b.WednesdayEndTime, b.TuesdayStartTime, 
                                            b.TuesdayEndTime, b.ThursdayStartTime, b.ThursdayEndTime, b.SundayStartTime, 
                                            b.SundayEndTime, b.SaturdayStartTime, b.SaturdayEndTime, b.Name, b.MondayStartTime, 
                                            b.MondayEndTime, b.Id, b.FridayStartTime, b.FridayEndTime From BusinessHours b
                                            where Name = 'Support - Basic']; // where Name = 'Support - Basic'
        
        Entitlement entObj6 = new Entitlement();
        entObj6.AccountId = acctest.id;
        entObj6.Name = 'Test Ent6';
        entObj6.BusinessHoursId = businessObj.Id;
        insert entObj6;
        
        Test.startTest();
        
        Case caseObj = new Case();   
        caseObj.AccountId = acctest.Id;
        caseObj.ContactId = contObj.id;
        caseObj.Subject = 'Test Case';
        caseObj.Description = 'Test Case Desc';
        caseObj.EntitlementId = entObj6.id;
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
        
        SupportPortalAdvCaseDetail createcaseObj1 = new SupportPortalAdvCaseDetail(new ApexPages.StandardController(caseObj));
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
     
    static testMethod void testCreateCase1() {
     try {
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
        acctest.RecordTypeId = rtMapByName.get('Customer Account').getRecordTypeId();
        acctest.RC_Service_name__c = 'FAX';
        acctest.RC_Brand__c = 'BTCloudPhone';
        insert acctest; 
            
        Contact contObj = new Contact();
        contObj.AccountId =  acctest.Id;
        contObj.Email = 'abc2@test.com';
        contObj.LastName = 'Test Last2';
        contObj.FirstName = 'Test First2';
        insert contObj;
        
        BusinessHours businessObj = [Select b.WednesdayStartTime, b.WednesdayEndTime, b.TuesdayStartTime, 
                                            b.TuesdayEndTime, b.ThursdayStartTime, b.ThursdayEndTime, b.SundayStartTime, 
                                            b.SundayEndTime, b.SaturdayStartTime, b.SaturdayEndTime, b.Name, b.MondayStartTime, 
                                            b.MondayEndTime, b.Id, b.FridayStartTime, b.FridayEndTime From BusinessHours b
                                            where Name = 'Support - Office Premium']; // where Name = 'Support - Basic'
        
        Entitlement entObj7 = new Entitlement();
        entObj7.AccountId = acctest.id;
        entObj7.Name = 'Test Ent7';
        entObj7.BusinessHoursId = businessObj.Id;
        insert entObj7;
        
        Test.startTest();
        
        Case caseObj2 = new Case();
        caseObj2.AccountId = acctest.Id;
        caseObj2.ContactId = contObj.id;
        caseObj2.Subject = 'Test Case2';
        caseObj2.Description = 'Test Case Desc2';
        caseObj2.EntitlementId = entObj7.id;
        insert caseObj2;
        
        System.debug('>>caseObj2>'+caseObj2);
        
        SupportPortalAdvCaseDetail createcaseObj2 = new SupportPortalAdvCaseDetail(new ApexPages.StandardController(caseObj2));
        createcaseObj2.getCaseDetail();
   
        Test.stopTest();    
     } catch(Exception ex) {}
 }
    static testMethod void testCreateCase2() {
        try {
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
            acctest.RecordTypeId = rtMapByName.get('Customer Account').getRecordTypeId();
            acctest.RC_Service_name__c = 'FAX';
            acctest.RC_Brand__c = 'BTCloudPhone';
            insert acctest; 
                
            Contact contObj = new Contact();
            contObj.AccountId =  acctest.Id;
            contObj.Email = 'abc2@test.com';
            contObj.LastName = 'Test Last2';
            contObj.FirstName = 'Test First2';
            insert contObj;
            
            BusinessHours businessObj = [Select b.WednesdayStartTime, b.WednesdayEndTime, b.TuesdayStartTime, 
                                                b.TuesdayEndTime, b.ThursdayStartTime, b.ThursdayEndTime, b.SundayStartTime, 
                                                b.SundayEndTime, b.SaturdayStartTime, b.SaturdayEndTime, b.Name, b.MondayStartTime, 
                                                b.MondayEndTime, b.Id, b.FridayStartTime, b.FridayEndTime From BusinessHours b
                                                where Name = 'Support Office Standard']; // where Name = 'Support - Basic'
            
            Entitlement entObj8 = new Entitlement();
            entObj8.AccountId = acctest.id;
            entObj8.Name = 'Test Ent8';
            entObj8.BusinessHoursId = businessObj.Id;
            insert entObj8; 
            
            Test.startTest();
            
            Case caseObj1 = new Case();
            caseObj1.AccountId = acctest.Id;
            caseObj1.ContactId = contObj.id;
            caseObj1.Subject = 'Test Case1';
            caseObj1.Description = 'Test Case Desc1';
            caseObj1.EntitlementId = entObj8.id;
            insert caseObj1;
            
            SupportPortalAdvCaseDetail createcaseObj2 = new SupportPortalAdvCaseDetail(new ApexPages.StandardController(caseObj1));
            createcaseObj2.getCaseDetail();
            
            Test.stopTest();    
         } catch(Exception ex) {
            system.debug('@@@@@@@'+ex.getMessage());
         }
     }
}