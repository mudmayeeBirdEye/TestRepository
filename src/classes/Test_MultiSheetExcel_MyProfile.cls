@isTest
private class Test_MultiSheetExcel_MyProfile {

    @isTest(seealldata = true)
    static  void TestMultiSheetExcelGenerate() {
        try{
            ID uid ='00580000003d9rB';
            PageReference pageRef = Page.MultiSheetExcelGenerate;
            Test.setCurrentPage(pageRef);
        
            ApexPages.currentPage().getParameters().put('userid',uid);
            ApexPages.currentPage().getParameters().put('objtype','Account');
        
            MultiSheetExcelGenerate msg = new MultiSheetExcelGenerate();
            msg.objType= 'Account';
            msg.userid = uid;
            msg.dm = new DataModel(); 
        
            pageRef = Page.MultiSheetExcelGenerate;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('userid',uid);
            ApexPages.currentPage().getParameters().put('objtype','Lead');
            msg = new MultiSheetExcelGenerate();
            msg.objType= 'Lead';
            msg.userid = uid;
            msg.dm = new DataModel(); 
        
            pageRef = Page.MultiSheetExcelGenerate;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('userid',uid);
            ApexPages.currentPage().getParameters().put('objtype','Case');
            msg = new MultiSheetExcelGenerate();
            msg.objType= 'Case';
            msg.userid = uid;
            msg.dm = new DataModel(); 
        
            pageRef = Page.MultiSheetExcelGenerate;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('userid',uid);
            ApexPages.currentPage().getParameters().put('objtype','Contact');
            msg = new MultiSheetExcelGenerate();
            msg.objType= 'Contact';
            msg.userid = uid;
            msg.dm = new DataModel(); 
        
            pageRef = Page.MultiSheetExcelGenerate;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('userid',uid);
            ApexPages.currentPage().getParameters().put('objtype','Opportunity');
            msg = new MultiSheetExcelGenerate();
            msg.objType= 'Opportunity';
            msg.userid = uid;
            msg.dm = new DataModel();
        }catch(exception ex){}
    }
    
     static testMethod void testMyProfilePageController() {     
        
        //1 Create Account
        Schema.DescribeSObjectResult result = Account.SObjectType.getDescribe();
        Map<string,Schema.RecordTypeInfo> rtMapById = result.getRecordTypeInfosByName();
        
        Account acctest1 = new Account();
        acctest1.Name = 'TestAccount';
        acctest1.RC_Account_Status__c = 'Paid';
        acctest1.RecordTypeId =rtMapById.get('Partner Account').getRecordTypeID();        
        insert acctest1;
        
        acctest1.isPartner = true;
        update acctest1;
        
        //2 Create Contact
        Contact objcon = new Contact();
        objcon.FirstName='test';
        objcon.LastName ='testl';
        objcon.AccountId = acctest1.id;
        objcon.Phone= '4098764563';
        objcon.email = 'Test123@simplion.com';
        insert objcon;
        
        //3 Create User
        Profile p = [SELECT Id FROM Profile WHERE Name='RC Partner Modify'];   
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                        UserName='standarduser00001@testorg.com',
                        EmailEncodingKey='UTF-8', LastName='Testing', 
                        LanguageLocaleKey='en_US', 
                        LocaleSidKey='en_US', ProfileId = p.Id,
                        ContactId = objcon.id,               
                        TimeZoneSidKey='America/Los_Angeles');
        insert u;
        
        String randFax = Math.rint(Math.random() * 1000) + '5551234';
        
        system.runAs(u){
            
            MyProfilePageController mpc = new MyProfilePageController ();
            user CurUser = mpc.getuser();
            boolean bEdit= mpc.getIsEdit();
            
            mpc.edit();
            mpc.getUser().Fax = randFax;
            mpc.getUser().Contact.Email = 'e@e.com';
            mpc.save();
            
        }
        
        user UserCheck = [Select id, fax, Contact.Fax, Contact.Id from User where id =: u.Id];
        System.assert(UserCheck.fax == randFax);
        System.assert(UserCheck.Contact.id == objcon.Id);
        
        /*
            
        // Modify the test to query for a portal user that exists in your org
        User existingPortalUser = [SELECT id, profileId, userRoleId FROM User WHERE UserRoleId <> null AND UserType='Standard' AND isActive=true LIMIT 1];
        //User existingPortalUser = [SELECT id, profileId, userRoleId FROM User WHERE UserRoleId <> null AND UserType='CustomerSuccess' LIMIT 1];
        System.assert(existingPortalUser != null, 'This test depends on an existing test portal user to run');
        
        String randFax = Math.rint(Math.random() * 1000) + '5551234';
        
        System.runAs(existingPortalUser) {
            MyProfilePageController controller = new MyProfilePageController();
            System.assertEquals(existingPortalUser.Id, controller.getUser().Id, 'Did not successfully load the current user');
         //   System.assert(controller.isEdit == false, 'isEdit should default to false');
           // controller.edit();
           // System.assert(controller.isEdit == true);
            
            controller.cancel();
           // System.assert(controller.isEdit == false);
            
            controller.getUser().Fax = randFax;
            controller.save();
            //System.assert(controller.isEdit == false);
        }
        
        // verify that the user and contact were updated
        existingPortalUser = [Select id, fax, Contact.Fax from User where id =: existingPortalUser.Id];
        System.assert(existingPortalUser.fax == randFax);
        //System.assert(existingPortalUser.Contact.fax == randFax);
        
        
        */
        
    }
     static testMethod void TestPriceCodesCsvHandler() {
        PriceCodesCsvhnadler obj=new PriceCodesCsvhnadler();
    }
    public static testMethod void ProtectionRuleExceptions(){
        try {
            ProtectionRuleExceptions pre ;
            Lead lTest1 = new Lead();
            Boolean bFireProtectionRules;
            lTest1.firstname = 'firstname';
            lTest1.lastname = 'lastname';
            lTest1.company = 'leadcompany';
            lTest1.phone = '9874569877';
            lTest1.phone = '9874569877';
            //lTest1.email = 'fake@email.com';
            lTest1.email = 'test@te.com';
            lTest1.Lead_Brand_Name__c = 'Rogers';
            insert lTest1;
            
            pre = new ProtectionRuleExceptions(lTest1);
            bFireProtectionRules = pre.useProtectionRuleCheck();
           // Boolean brandCheck = pre.brandCheck();
           // Boolean emailCheck = pre.fakeEmailCheck();
         //   Boolean leadSourceCheck = pre.leadSourceCheck();
            
            Lead lTest2 = new Lead();
            lTest2.firstname = 'firstname';
            lTest2.lastname = 'lastname';
            lTest2.company = 'leadcompany';
            lTest2.phone = '9874569877';
            lTest2.phone = '9874569877';
            lTest2.email = 'fake@fake.com';
            lTest2.Lead_Brand_Name__c = 'AT&T Office@Hand';
            insert lTest2;
            
            pre = new ProtectionRuleExceptions(lTest2);
            bFireProtectionRules = pre.useProtectionRuleCheck();
          //  brandCheck = pre.brandCheck();
         //   emailCheck = pre.fakeEmailCheck();
         //   leadSourceCheck = pre.leadSourceCheck();
        } catch(Exception e){}
    }
    static testMethod void testRocketLeadUpload() {
        // Create a new email, envelope object and Attachment
       Messaging.InboundEmail email = new Messaging.InboundEmail();
       Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
       Messaging.InboundEmail.Textattachment inAtt = new Messaging.InboundEmail.Textattachment();
       Messaging.InboundEmail.Binaryattachment inBtt = new Messaging.InboundEmail.Binaryattachment();
    
       email.subject = 'test';
       env.fromAddress = 'user@acme.com';
    
       // set the body of the attachment
       inAtt.body = 'VPlast,VPfirst,999@test.com,123 happy drive,apt 234,san jose,IL,95128,US,4085556666,6508885555,StandardTollFreeNumberOffer,jesse@jimmyjack.com*EOL*';
       inAtt.fileName = 'attach.csv';
       inAtt.mimeTypeSubType = 'plain/txt';
    
       email.textAttachments = new Messaging.inboundEmail.Textattachment[] {inAtt }; 
    
       // call the class and test it with the data in the testMethod
       RocketLeadUpload emailServiceObj = new RocketLeadUpload();
       //Counter__c c=[select value__c from Counter__c where name='Partner'];
       emailServiceObj.handleInboundEmail(email, env );

       
       inAtt.body = 'VPlast1,VPfirst1,999@test.com,123 happy drive,san jose,,IL,95128,UK,4085556666,6508885555,StandardTollFreeNumberOffer,jesse1@jimmyjack.com*EOL*';
       email.textAttachments = new Messaging.inboundEmail.Textattachment[] {inAtt };
       emailServiceObj.handleInboundEmail(email, env );    
       
       inAtt.body = 'VPlast2,VPfirst2,999@test.com,123 happy drive,,floor5,san jose,IL,95128,US,4085556666,6508885555,WebsiteDashboardOffer,jesse2@jimmyjack.com*EOL*';
       email.textAttachments = new Messaging.inboundEmail.Textattachment[] {inAtt };
       emailServiceObj.handleInboundEmail(email, env );
       
       inAtt.body = 'VPlast3,VPfirst3,999@test.com,123 happy drive,floor5,,san jose,IL,95128,US,4085556666,6508885555,jesse2@jimmyjack.com*EOL*';
       email.textAttachments = new Messaging.inboundEmail.Textattachment[] {inAtt };

       
       inAtt.body = 'VPlast3,VPfirst3,999@test.com,123 happy drive,floor5,san jose,,IL,95128,US,4085556666,6508885555,jesse2@jimmyjack.com*EOL*';
       email.textAttachments = new Messaging.inboundEmail.Textattachment[] {inAtt };

       
       inBtt.body = blob.valueOf('VPlast,VPfirst,999@test.com,123 happy drive,apt 234,san jose,IL,95128,US,4085556666,6508885555,StandardTollFreeNumberOffer,jesse@jimmyjack.com*EOL*');
       inBtt.fileName = 'attach.csv';
        
       email.binaryAttachments = new Messaging.inboundEmail.Binaryattachment[] {inBtt }; 
    

       emailServiceObj.handleInboundEmail(email, env );

       
       inBtt.body = blob.valueOf('VPlast1,VPfirst1,999@test.com,123 happy drive,san jose,,IL,95128,US,4085556661,6508885551,jesse1@jimmyjack.com*EOL*');
       email.binaryAttachments = new Messaging.inboundEmail.Binaryattachment[] {inBtt };

           inBtt.body = blob.valueOf(',Valued Customer,999@test.com,123 happy drive,,floor5,san jose,IL,95128,US,4085556662,6508885552,jesse2@jimmyjack.com*EOL*');
       email.binaryAttachments = new Messaging.inboundEmail.Binaryattachment[] {inBtt };

       
       inBtt.body = blob.valueOf(',Valued Customer,999@test.com,123 happy drive,floor5,,san jose,IL,95128,US,4085556663,6508885553,jesse3@jimmyjack.com*EOL*');
       email.binaryAttachments = new Messaging.inboundEmail.Binaryattachment[] {inBtt };
       inBtt.body = blob.valueOf(',Valued Customer,999@test.com,123 happy drive,floor5,san jose,,IL,95128,US,4085556664,6508885554,jesse4@jimmyjack.co.uk*EOL*');
       email.binaryAttachments = new Messaging.inboundEmail.Binaryattachment[] {inBtt };
       inBtt.body = blob.valueOf(',Valued Customer,999@test.com,123 happy drive,floor5,san jose,,IL,95128,US,444085556666,446508885555,jesse5@jimmyjack.com*EOL*');
       email.binaryAttachments = new Messaging.inboundEmail.Binaryattachment[] {inBtt };

    }   
    
}