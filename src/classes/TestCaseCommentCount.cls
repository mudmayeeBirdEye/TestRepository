@isTest
private class TestCaseCommentCount {

    static testMethod void caseCommentCountTest1() {
        try {
        	EntitlementEnable__c mycs = EntitlementEnable__c.getValues('IsEntitlementsEnabled__c');
			  if(mycs == null) {
			    mycs = new EntitlementEnable__c();
			    mycs.IsEntitlementsEnabled__c = true;
			    mycs.Name = 'IsEntitlementsEnabled';
			    insert mycs;
		  	}
        	Account accountObj = new Account();
        	accountObj.Name = 'Test Account';
        	insert accountObj;
        	Contact contactObj = new Contact();
        	contactObj.Email = 'Test1@test.com';
        	contactObj.FirstName = 'TestFName';
        	contactObj.LastName = 'TestLName';
        	insert contactObj;
        	Test.startTest();
        	Case caseObj = new Case();
        	caseObj.Subject = 'Test Case';
        	caseObj.AccountId = accountObj.Id;
        	caseObj.Contact_ID__c = contactObj.Id;
        	insert caseObj;
        	CaseComment casecommentObj = new CaseComment();
        	casecommentObj.ParentId = caseObj.Id;
        	casecommentObj.CommentBody = 'Test Comment';
        	insert casecommentObj; 
        	casecommentObj.IsPublished = true;
        	 String jobId = System.schedule('CASE Comment JOb',
                                      '0 0 0 3 9 ? 2022',new CaseCommentCountSchedule());
        	update casecommentObj;
        	Test.stopTest();
        	casecommentObj.IsPublished = false;
        	update casecommentObj;
        } catch(Exception ex) {}
    }
    
    static testMethod void caseCommentCountTest2() {
        try {
        	EntitlementEnable__c mycs = EntitlementEnable__c.getValues('IsEntitlementsEnabled__c');
			  if(mycs == null) {
			    mycs = new EntitlementEnable__c();
			    mycs.IsEntitlementsEnabled__c = true;
			    mycs.Name = 'IsEntitlementsEnabled';
			    insert mycs;
		  	}
        	Account accountObj = new Account();
        	accountObj.Name = 'Test Account';
        	insert accountObj;
        	Contact contactObj = new Contact();
        	contactObj.Email = 'Test1@test.com';
        	contactObj.FirstName = 'TestFName';
        	contactObj.LastName = 'TestLName';
        	insert contactObj;
        	Test.startTest();
        	Case caseObj = new Case();
        	caseObj.Subject = 'Test Case';
        	caseObj.AccountId = accountObj.Id;
        	caseObj.Contact_ID__c = contactObj.Id;
        	insert caseObj;
        	CaseComment CaseCommentObj1 = new CaseComment();
        	CaseCommentObj1.IsPublished = true;
        	CaseCommentObj1.ParentId = caseObj.id;
        	CaseCommentObj1.CommentBody = 'Test1';
        	insert CaseCommentObj1;
        	 String jobId = System.schedule('CASE Comment JOb',
                                      '0 0 0 3 9 ? 2022',new CaseCommentCountSchedule());
        	delete CaseCommentObj1;
        	Test.stopTest();
        } catch(Exception ex) {}
    }
    
    static testMethod void caseCommentCountTest3() {
        try {
        	EntitlementEnable__c mycs = EntitlementEnable__c.getValues('IsEntitlementsEnabled__c');
			  if(mycs == null) {
			    mycs = new EntitlementEnable__c();
			    mycs.IsEntitlementsEnabled__c = true;
			    mycs.Name = 'IsEntitlementsEnabled';
			    insert mycs;
		  	}
        	Account accountObj = new Account();
        	accountObj.Name = 'Test Account';
        	insert accountObj;
        	Contact contactObj = new Contact();
        	contactObj.Email = 'Test1@test.com';
        	contactObj.FirstName = 'TestFName';
        	contactObj.LastName = 'TestLName';
        	insert contactObj;
        	Test.startTest();
        	Case caseObj = new Case();
        	caseObj.Subject = 'Test Case';
        	caseObj.AccountId = accountObj.Id;
        	caseObj.Contact_ID__c = contactObj.Id;
        	insert caseObj;
        	CaseComment CaseCommentObj1 = new CaseComment();
        	//CaseCommentObj1.IsPublished = true;
        	CaseCommentObj1.CommentBody = 'Test1';
        	CaseCommentObj1.ParentId = caseObj.Id;
        	insert CaseCommentObj1;
        	 String jobId = System.schedule('CASE Comment JOb',
                                      '0 0 0 3 9 ? 2022',new CaseCommentCountSchedule());
        	delete CaseCommentObj1;
        	Test.stopTest();
        } catch(Exception ex) {}
    }
    
	static testMethod void testCaseCommentCountBatch(){
         Test.startTest();
         String jobId = System.schedule('CASE Comment JOb',
                                      '0 0 0 3 9 ? 2022',new CaseCommentCountSchedule());

         Test.stopTest();    
 	}
}