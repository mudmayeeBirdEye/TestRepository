@isTest
private class Test_ATBCBatch_AssetController {
	@isTest
	static void testBatchATBC() {
		try {
			Account acctest = new Account();
	        acctest.Name = 'TestAccount100';
	        acctest.Next_Renewal_Date__c = System.today() - 10;
	        acctest.RecordTypeId  = '01280000000UERq';
	        insert acctest;
	        
	        System.Debug('>>>ss1>>'+ acctest.Next_Renewal_Date__c );
	        
	        Account acctest1 = new Account();
	        acctest1.Name = 'TestAccount101';
	        acctest1.Next_Renewal_Date__c = System.today() + 10;
	        acctest1.RecordTypeId  = '01280000000UERq';
	        insert acctest1;
	        
	        System.Debug('>>>ss2>>'+ acctest1.Next_Renewal_Date__c );
			
			Lead leadObj2 = new Lead();
    		leadObj2.FirstName='TestLead123';
            leadObj2.LastName='TestLead123LN';
            leadObj2.Company='TestLead123CN';
            leadObj2.Phone='9911112222';
            leadObj2.email = 'testLead123@test.com';
            leadObj2.LeadSource = 'About To Be Cancelled UK';
            leadObj2.ATBC_Stage__c = 'New';
            leadObj2.Account__c = acctest.id;
            leadObj2.User_ID__c = 'TestLead111';
            insert leadObj2;
            
            System.Debug('>>>ss3>>'+leadObj2.Account_Renewal_Date__c); 
            
            Lead leadObj1 = new Lead();
    		leadObj1.FirstName='TestLead124';
            leadObj1.LastName='TestLead124LN';
            leadObj1.Company='TestLead124CN';
            leadObj1.Phone='9911112224';
            leadObj1.email = 'testLead124@test.com';
            leadObj1.LeadSource = 'About To be Cancelled';
            leadObj1.ATBC_Stage__c = 'New';
            leadObj1.Account__c = acctest1.id;
            leadObj1.User_ID__c = 'TestLead113';
            insert leadObj1; 
            
            System.Debug('>>>ss4>>'+leadObj1.Account_Renewal_Date__c);
            
            Test.StartTest();
		   	ATBCBatch atbcBatchObj = new ATBCBatch();
		   	atbcBatchObj.strQuery =	 'SELECT Id, User_ID__c, Name, Email, Company, Account_Renewal_Date__c, CreatedDate FROM Lead ' +
										'WHERE (LeadSource = \'About To be Cancelled\' OR LeadSource = \'About To Be Cancelled UK\' ) '  +
								 		'and (ATBC_Stage__c=\'New\' OR ATBC_Stage__c=\'WIP\') and IsConverted = false ' +
								 		'and User_ID__c != null and User_ID__c != \'\'';		 
			atbcBatchObj.strIsCancel = '1';	
	   		ID batchprocessid = Database.executeBatch(atbcBatchObj);
	   		Test.StopTest();
      } catch(Exception ex) {}
	}
	static testMethod void TestAssetController() {
        try{
        	Asset__c asst = new Asset__c();
	        asst.Asset_Type__c = 'Hardware';
	        asst.Sub_Asset_Type__c = 'Computer';
	        asst.Manufacturer__c = 'Other';
	        asst.Manufacturer_Other__c ='IBM';
	        asst.Model__c ='Other';
	        asst.Model_Other__c = 'IBM420';
	        asst.Location__c ='Home Office';
	        asst.Status__c = 'Deployed';
	        insert asst;
	       
	       test.startTest();
		      PageReference pageRef = Page.AssetClientPage;    
		      Test.setCurrentPageReference(pageRef);  
		      ApexPages.StandardController controller = new  ApexPages.StandardController ( asst );
		      ApexPages.currentPage().getParameters().put('retURL', controller.getid());
		      AssetController ac = new AssetController(controller);
		      ac.callDispatcher();
		   test.stopTest();
        }catch(exception ex){}
 		
 	
    }
    static testMethod void VistaPrintLeadTest() {
    	try{
    			test.startTest();
			   Messaging.InboundEmail email = new Messaging.InboundEmail();
			   Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
			   Messaging.InboundEmail.Textattachment inAtt = new Messaging.InboundEmail.Textattachment();
			   Messaging.InboundEmail.Binaryattachment inBtt = new Messaging.InboundEmail.Binaryattachment();
	
			   email.subject = 'test';
			   env.fromAddress = 'user@acme.com';
			
			   // set the body of the attachment
			   inAtt.body = 'VPlast,VPfirst,999,123 happy drive,apt 234,san jose,IL,95128,US,4085556666,6508885555,StandardTollFreeNumberOffer,jesse@jimmyjack.com*EOL*';
			   inAtt.fileName = 'attach.csv';
			   inAtt.mimeTypeSubType = 'plain/txt';
			
			   email.textAttachments = new Messaging.inboundEmail.Textattachment[] {inAtt }; 
	
			   // call the class and test it with the data in the testMethod
			   VistaPrintLead emailServiceObj = new VistaPrintLead();
			   //Counter__c c=[select value__c from Counter__c where name='Partner'];
			   emailServiceObj.handleInboundEmail(email, env );
			   //Counter__c c2=[select value__c from Counter__c where name='Partner'];
			  // system.assert(c2.value__c > c.value__c);
			   
			   inAtt.body = 'VPlast1,VPfirst1,999,123 happy drive,san jose,,IL,95128,UK,4085556666,6508885555,StandardTollFreeNumberOffer,jesse1@jimmyjack.com*EOL*';
			   email.textAttachments = new Messaging.inboundEmail.Textattachment[] {inAtt };
			  // emailServiceObj.handleInboundEmail(email, env );	   
	   
			   inAtt.body = 'VPlast2,VPfirst2,999,123 happy drive,,floor5,san jose,IL,95128,US,4085556666,6508885555,WebsiteDashboardOffer,jesse2@jimmyjack.com*EOL*';
			   email.textAttachments = new Messaging.inboundEmail.Textattachment[] {inAtt };
			   emailServiceObj.handleInboundEmail(email, env );
			   
			   inAtt.body = 'VPlast3,VPfirst3,999,123 happy drive,floor5,,san jose,IL,95128,US,4085556666,6508885555,jesse2@jimmyjack.com*EOL*';
			   email.textAttachments = new Messaging.inboundEmail.Textattachment[] {inAtt };
			   //emailServiceObj.handleInboundEmail(email, env );
			   
		   	   inAtt.body = 'VPlast3,VPfirst3,999,123 happy drive,floor5,san jose,,IL,95128,US,4085556666,6508885555,jesse2@jimmyjack.com*EOL*';
			   email.textAttachments = new Messaging.inboundEmail.Textattachment[] {inAtt };
			   //emailServiceObj.handleInboundEmail(email, env );
			
			   
			//   inAtt.body = ',Valued Customer,999,123 happy drive,,floor5,san jose,,IL,95128,US,4085556666,6508885555,jesse4@jimmyjack.com*EOL*';
			//   email.textAttachments = new Messaging.inboundEmail.Textattachment[] {inAtt };
			//   emailServiceObj.handleInboundEmail(email, env );	
			   
			   ///////////////////////////// binary tests
			   
			   inBtt.body = blob.valueOf('VPlast,VPfirst,999,123 happy drive,apt 234,san jose,IL,95128,US,4085556666,6508885555,StandardTollFreeNumberOffer,jesse@jimmyjack.com*EOL*');
			   inBtt.fileName = 'attach.csv';
			   //inBtt.mimeTypeSubType = 'plain/txt';
	
			   email.binaryAttachments = new Messaging.inboundEmail.Binaryattachment[] {inBtt }; 
			
			   // call the class and test it with the data in the testMethod
			   // VistaPrintLead emailServiceObj = new VistaPrintLead();
			   emailServiceObj.handleInboundEmail(email, env );
		
			   
			   inBtt.body = blob.valueOf('VPlast1,VPfirst1,999,123 happy drive,san jose,,IL,95128,US,4085556661,6508885551,jesse1@jimmyjack.com*EOL*');
			   email.binaryAttachments = new Messaging.inboundEmail.Binaryattachment[] {inBtt };
			   //emailServiceObj.handleInboundEmail(email, env );	   
			   
			   	   inBtt.body = blob.valueOf(',Valued Customer,999,123 happy drive,,floor5,san jose,IL,95128,US,4085556662,6508885552,jesse2@jimmyjack.com*EOL*');
			   email.binaryAttachments = new Messaging.inboundEmail.Binaryattachment[] {inBtt };
			   //emailServiceObj.handleInboundEmail(email, env );	
			   
			   	   	   inBtt.body = blob.valueOf(',Valued Customer,999,123 happy drive,floor5,,san jose,IL,95128,US,4085556663,6508885553,jesse3@jimmyjack.com*EOL*');
			   email.binaryAttachments = new Messaging.inboundEmail.Binaryattachment[] {inBtt };
			   //emailServiceObj.handleInboundEmail(email, env );
			   
			//   	   	   inBtt.body = blob.valueOf(',Valued Customer,999,123 happy drive,floor5,san jose,,IL,95128,US,4085556666,6508885555,jesse2@jimmyjack.com*EOL*');
			//   email.binaryAttachments = new Messaging.inboundEmail.Binaryattachment[] {inBtt };
			//   emailServiceObj.handleInboundEmail(email, env );
			   
			   
			   	   	   inBtt.body = blob.valueOf(',Valued Customer,999,123 happy drive,floor5,san jose,,IL,95128,US,4085556664,6508885554,jesse4@jimmyjack.co.uk*EOL*');
			   email.binaryAttachments = new Messaging.inboundEmail.Binaryattachment[] {inBtt };
			  // emailServiceObj.handleInboundEmail(email, env );
			   
			   	   	   inBtt.body = blob.valueOf(',Valued Customer,999,123 happy drive,floor5,san jose,,IL,95128,US,444085556666,446508885555,jesse5@jimmyjack.com*EOL*');
			   email.binaryAttachments = new Messaging.inboundEmail.Binaryattachment[] {inBtt };
	   		//emailServiceObj.handleInboundEmail(email, env );
	   		test.stopTest();
    		
    	}catch(exception e){}
	}	
	public static testmethod void TestsyncAccountlevelRollUps() {
   		
   		EntitlementEnable__c mycs = EntitlementEnable__c.getValues('IsEntitlementsEnabled__c');
		if(mycs == null) {
			mycs = new EntitlementEnable__c();
			mycs.IsEntitlementsEnabled__c = true;
			mycs.Name = 'IsEntitlementsEnabled';
			insert mycs;
		}
     	Account testAccount = new Account(Name = 'TestAccount');
        insert testAccount;
		
		Account accountobj1 = new Account();
		accountobj1.Name = 'TestAccount';
		accountobj1.RC_User_ID__c = 'UID9910106802';
		accountobj1.Partner_ID__c = 'PARTNER002';
		accountobj1.ParentId = testAccount.Id;
		accountobj1.Phone = '9910101111';
		accountobj1.AccountNumber = '991010';
		insert accountobj1;
		    
		Contact contactObj = new Contact();
		contactObj.AccountId = accountobj1.id;
		contactObj.Email = 'Testportaluser@simplion.com';
		contactObj.LastName = 'Test Okta Con portaluser';
		contactObj.Phone = '1234567830';
		insert contactObj;
		
		Case c = new Case(Subject = 'Test Case with Entitlement ', ContactId = contactObj.id); 
		c.AccountId = accountobj1.Id;
		insert c;
		test.startTest();
		/*User testUser = new User(alias = 'portr', email='portaluser@testorg.com', emailencodingkey='UTF-8', lastname='portaluser',OktaUserPassword__c='ra!nb0w7',
		                         OKTAUserID__c='00u3uty75rWFWAOFWHQJ',  ProfileId=[SELECT Id FROM Profile WHERE Name='RC Partner User Pilot' LIMIT 1].Id, languagelocalekey='en_US',
	                      		 localesidkey='en_US', country='United States',timezonesidkey='America/Los_Angeles',username='portaluser@testorg.com', 
								 ContactId=contactObj.Id, IsActive=true );//UserRoleId=objUS.Id,
		insert testUser;*/
      
       
      //insert testAccount;
      
		ApexPages.StandardController controller=new ApexPages.StandardController(accountobj1);
		syncAccountLevelRollUps objsyncAccountLevelRollUps =new syncAccountLevelRollUps (controller);
      
		objsyncAccountLevelRollUps.strScheduleName='None';
		objsyncAccountLevelRollUps.massUpdateAccountRollUp();
      
		objsyncAccountLevelRollUps.strScheduleName='allchild';
		objsyncAccountLevelRollUps.massUpdateAccountRollUp();
     
		objsyncAccountLevelRollUps.strScheduleName='Partner';
		objsyncAccountLevelRollUps.massUpdateAccountRollUp();
		objsyncAccountLevelRollUps.setTotalActiveCustomer();
      
		objsyncAccountLevelRollUps.scheduleAllAccountsAgain();
		test.stopTest();
      }
}