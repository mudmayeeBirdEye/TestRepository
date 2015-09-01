@isTest
private class Test_PortingESBHelper {

    static testMethod void myUnitTest() {
    	try{
			Schema.DescribeSObjectResult result = Case.SObjectType.getDescribe();
    		Map<ID,Schema.RecordTypeInfo> rtMapByName = result.getRecordTypeInfosById();
			Map<string,Schema.RecordTypeInfo> rtMapById = result.getRecordTypeInfosByName(); 
			
			User testUser = [select Id,Name FROM User Where Name= 'RCESB']; 
    		System.runAs(testUser){
    			Test.startTest();
	    		Account accObj = new Account();
		       	accObj.Name = 'testName';
		       	accObj.RC_User_ID__c = '123456';
		       	TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT(); 
		       	insert accObj;
		       	TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT = false;
		       	Contact contObj = new Contact();
		       	contObj.LastName = 'testLast';
	       		contObj.AccountId = accObj.id;
		       	contObj.email='test@rc112.com';
		       	TriggerHandler.BY_PASS_CONTACT_ON_INSERT();
		       	insert contObj;
		       	TriggerHandler.BY_PASS_CONTACT_ON_INSERT=false;
			   	Case caseObj = new Case();
		       	Id recordTypeId = rtMapById.get('Porting - In (NeuStar)').getRecordTypeId();
		       	caseObj.RecordTypeId = recordTypeId;
		       	caseObj.Subject = 'Test Case ';
		       	caseObj.Status = 'New';
		       	caseObj.AccountId = accObj.id;
		       	caseObj.ContactId = contObj.id;
		       	caseObj.RC_Porting_Order_ID__c = 5.00;
		       	TriggerHandler.BY_PASS_CASE_ON_INSERT();
		       	insert caseObj;
		       	TriggerHandler.BY_PASS_CASE_ON_INSERT = false;
		       	caseObj.IsUpdatePermitted__c = false;
		    	caseObj.Porting_last_status_change_date__c = date.parse('9/10/2013');
		    	caseObj.Status ='Open';
		    	caseObj.Convert_to_Internal_Porting__c = 'Porting - In (RC)';
		    	Test_Utils tutilsss = new Test_Utils();
		       	tutilsss.initialiseTriggerBypass();
		    	update caseObj;
		    	caseObj.RC_Porting_Order_ID__c = null;
		    	caseObj.Porting_last_status_change_date__c = date.parse('8/10/2013');
		    	update caseObj;
		    	tutilsss.deInitialiseTriggerBypass();
		    	/*Case caseObj3 = new Case();
		       	Id recordTypeId3 = rtMapById.get('Porting - In (NeuStar)').getRecordTypeId();
		       	caseObj3.RecordTypeId = recordTypeId3;
		       	caseObj3.Subject = 'Test Case ';
		       	caseObj3.Status = 'New';
		       	caseObj3.AccountId = accObj.id;
		       	caseObj3.ContactId = contObj.id;
		       	caseObj3.RC_Porting_Order_ID__c = 5.00;
		       	insert caseObj3;
		       	caseObj3.Status = 'Rejected';
		       	caseObj3.RC_Porting_Order_ID__c = null;
		    	caseObj3.Porting_last_status_change_date__c = date.parse('8/10/2013');
		    	update caseObj3;*/
	    		
	    		Case caseObj1 = new Case();
		       	Id recordTypeId1 = rtMapById.get('Porting - In (RC)').getRecordTypeId();
		       	caseObj1.RecordTypeId = recordTypeId1;
		       	caseObj1.Subject = 'Test Case ';
		       	caseObj1.Status = 'New';
		       	caseObj1.AccountId = accObj.id;
		       	caseObj1.ContactId = contObj.id;
		       	caseObj1.RC_Porting_Order_ID__c = 5.00;
		       	TriggerHandler.BY_PASS_CASE_ON_INSERT();
		       	insert caseObj1;
		       	TriggerHandler.BY_PASS_CASE_ON_INSERT = false;
				caseObj1.RC_Porting_Order_ID__c = 1.00;//Porting_last_status_change_date__c
		    	caseObj1.Porting_last_status_change_date__c = date.parse('9/10/2013');
		    	caseObj1.Status ='Open';
		       	tutilsss.initialiseTriggerBypass();
		    	update caseObj1;
		    	caseObj1.Status = 'Transfer Date Confirmed';
		    	caseObj1.Porting_Estimated_Completion_Date__c = null;
		    	update caseObj1;
		    	tutilsss.deInitialiseTriggerBypass();
		    	Test.stopTest();
		    	/*caseObj1.Status = 'Rejected' ;
		    	caseObj1.Porting_Reject_Reason__c = null;
		    	update caseObj1;*/
		    	
		    	
    		}
    	}catch(exception ex){}
    }
      static testMethod void myUnitTest2() {
      	try{
      		Test_Utils tutils = new Test_Utils();
      		Schema.DescribeSObjectResult result = Case.SObjectType.getDescribe();
    		Map<ID,Schema.RecordTypeInfo> rtMapByName = result.getRecordTypeInfosById();
			Map<string,Schema.RecordTypeInfo> rtMapById = result.getRecordTypeInfosByName(); 
			User testUser = [select Id,Name FROM User Where Name= 'RCESB'];
			Test.startTest();
    		System.runAs(testUser){
				Account accObj = new Account();
		       	accObj.Name = 'testName';
		       	accObj.RC_User_ID__c = '123456';
		       	TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT();
		       	insert accObj;
		       	TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT = false;
		       	Contact contObj = new Contact();
		       	contObj.LastName = 'testLast';
	       		contObj.AccountId = accObj.id;
		       	contObj.email='test@rc112.com';
		       	TriggerHandler.BY_PASS_CONTACT_ON_INSERT();
		       	insert contObj;
		       	TriggerHandler.BY_PASS_CONTACT_ON_INSERT=false;
		       	Case caseObj2 = new Case();
		       	Id recordTypeId4 = rtMapById.get('Porting - In (RC)').getRecordTypeId();
		       	caseObj2.RecordTypeId = recordTypeId4;
		       	caseObj2.Subject = 'Test Case ';
		       	caseObj2.Status = 'New';
		       	caseObj2.AccountId = accObj.id;
		       	caseObj2.ContactId = contObj.id;
		       	caseObj2.RC_Porting_Order_ID__c = 5.00;
		       	TriggerHandler.BY_PASS_CASE_ON_INSERT();
		       	insert caseObj2;
		       	TriggerHandler.BY_PASS_CASE_ON_INSERT = false;
		       	caseObj2.Status = 'Rejected' ;
		    	caseObj2.Porting_Reject_Reason__c = null;
		    	tutils.initialiseTriggerBypass();
		    	update caseObj2;
		    	tutils.deInitialiseTriggerBypass();
      		
    		}
    		Test.stopTest();
      	
      	}catch(exception ex){}
      		
      }
       static testMethod void myUnitTest3() {
      	try{
	      		Test_Utils tutils = new Test_Utils();
	      		Schema.DescribeSObjectResult result = Case.SObjectType.getDescribe();
	    		Map<ID,Schema.RecordTypeInfo> rtMapByName = result.getRecordTypeInfosById();
				Map<string,Schema.RecordTypeInfo> rtMapById = result.getRecordTypeInfosByName(); 
				User testUser = [select Id,Name FROM User Where Name= 'RCESB'];
				Test.startTest();
	    		System.runAs(testUser){
    			Account accObj = new Account();
		       	accObj.Name = 'testName';
		       	accObj.RC_User_ID__c = '123456';
		       	TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT();
		       	insert accObj;
		       	TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT = false;
		       	Contact contObj = new Contact();
		       	contObj.LastName = 'testLast';
	       		contObj.AccountId = accObj.id;
		       	contObj.email='test@rc112.com';
		       	TriggerHandler.BY_PASS_CONTACT_ON_INSERT();
		       	insert contObj;
		       	TriggerHandler.BY_PASS_CONTACT_ON_INSERT=false;
		       	Case caseObj2 = new Case();
		       	Id recordTypeId4 = rtMapById.get('Porting - In (RC)').getRecordTypeId();
		       	caseObj2.RecordTypeId = recordTypeId4;
		       	caseObj2.Subject = 'Test Case ';
		       	caseObj2.Status = 'New';
		       	caseObj2.AccountId = accObj.id;
		       	caseObj2.ContactId = contObj.id;
		       	caseObj2.RC_Porting_Order_ID__c = 5.00;
		       	TriggerHandler.BY_PASS_CASE_ON_INSERT();
		       	insert caseObj2;
		       	TriggerHandler.BY_PASS_CASE_ON_INSERT = false;
		       	caseObj2.Status = 'Transfer Date Confirmed' ;
                caseObj2.Porting_Estimated_Completion_Date__c = null; 
                tutils.initialiseTriggerBypass();  
                update caseObj2; 
                tutils.deInitialiseTriggerBypass(); 		
    		}
    		Test.stopTest();
      	}catch(exception ex){}
      }
      static testMethod void myUnitTest4() {
      	try{
      		Test_Utils tutils = new Test_Utils();
      		Schema.DescribeSObjectResult result = Case.SObjectType.getDescribe();
    		Map<ID,Schema.RecordTypeInfo> rtMapByName = result.getRecordTypeInfosById();
			Map<string,Schema.RecordTypeInfo> rtMapById = result.getRecordTypeInfosByName(); 
			User testUser = [select Id,Name FROM User Where Name= 'RCESB'];
			Test.startTest();
    		System.runAs(testUser){
    			Account accObj = new Account();
		       	accObj.Name = 'testName';
		       	accObj.RC_User_ID__c = '123456';
		       	TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT();
		       	insert accObj;
		       	TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT = false;
		       	Contact contObj = new Contact();
		       	contObj.LastName = 'testLast';
	       		contObj.AccountId = accObj.id;
		       	contObj.email='test@rc112.com';
		       	TriggerHandler.BY_PASS_CONTACT_ON_INSERT();
		       	insert contObj;
		       	TriggerHandler.BY_PASS_CONTACT_ON_INSERT=false;
		       	Case caseObj2 = new Case();
		       	Id recordTypeId4 = rtMapById.get('Porting - In (RC)').getRecordTypeId();
		       	caseObj2.RecordTypeId = recordTypeId4;
		       	caseObj2.Subject = 'Test Case ';
		       	caseObj2.Status = 'New';
		       //	caseObj2.AccountId = accObj.id;
		       //	caseObj2.ContactId = contObj.id;
		       	caseObj2.RC_Porting_Order_ID__c = 5.00;
		       	TriggerHandler.BY_PASS_CASE_ON_INSERT();
		       	insert caseObj2;
		       	TriggerHandler.BY_PASS_CASE_ON_INSERT = false;
		       	caseObj2.Status = null ;
                tutils.initialiseTriggerBypass();  
                update caseObj2; 
                tutils.deInitialiseTriggerBypass(); 
                  		
    		}
      		Test.stopTest();
      	}catch(exception ex){}
      		
      }
      static testMethod void myUnitTest5() {
      	try{
      		Schema.DescribeSObjectResult result = Case.SObjectType.getDescribe();
    		Map<ID,Schema.RecordTypeInfo> rtMapByName = result.getRecordTypeInfosById();
			Map<string,Schema.RecordTypeInfo> rtMapById = result.getRecordTypeInfosByName(); 
			Test_Utils tutils = new Test_Utils();
    		
    			Account accObj = new Account();
		       	accObj.Name = 'testName';
		       	accObj.RC_User_ID__c = '123456';
		       	TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT();
		       	insert accObj;
		       	TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT = false;
		       	Contact contObj = new Contact();
		       	contObj.LastName = 'testLast';
	       		contObj.AccountId = accObj.id;
		       	contObj.email='test@rc112.com';
		       	TriggerHandler.BY_PASS_CONTACT_ON_INSERT();
		       	insert contObj;
		       	TriggerHandler.BY_PASS_CONTACT_ON_INSERT=false;
		       	Test.startTest();
		       	Case caseObj2 = new Case();
		       	Id recordTypeId4 = rtMapById.get('Porting - In (NeuStar)').getRecordTypeId();
		       	caseObj2.RecordTypeId = recordTypeId4;
		       	caseObj2.Subject = 'Test Case ';
		       	caseObj2.Status = 'New';
		       	caseObj2.AccountId = accObj.id;
		       	caseObj2.ContactId = contObj.id;
		       	caseObj2.RC_Porting_Order_ID__c = 5.00;
		       	caseObj2.Last_Case_Comment__c = 'test';
		       	caseObj2.Porting_Estimated_Completion_Date__c = date.parse('9/10/2013');
		       	TriggerHandler.BY_PASS_CASE_ON_INSERT();
		       	insert caseObj2;
		       	TriggerHandler.BY_PASS_CASE_ON_INSERT = false;
		       	caseObj2.Last_Case_Comment__c = '123test';
		       	caseObj2.Status = 'open';
		       	caseObj2.Porting_Estimated_Completion_Date__c = date.parse('11/10/2013');
		       	tutils.initialiseTriggerBypass();  
                update caseObj2; 
                tutils.deInitialiseTriggerBypass(); 
                Test.stopTest();  		
    		
      	
      	}catch(exception ex){}
      		
      }
}