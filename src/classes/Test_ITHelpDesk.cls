@isTest 
private class Test_ITHelpDesk{
	string strQuery; 
	string strQuerys;
	String searchText;
	static testMethod void  ITHelpDesk(){
		try {
			Schema.DescribeSObjectResult result = Case.SObjectType.getDescribe();
    		Map<ID,Schema.RecordTypeInfo> rtMapByName = result.getRecordTypeInfosById();
    		Map<string,Schema.RecordTypeInfo> rtMapById = result.getRecordTypeInfosByName();
    		TriggerHandler.BY_PASS_CASE_ON_INSERT = true;
    		TriggerHandler.BY_PASS_CASE_ON_UPDATE = true; 
			
			Account accObj = new Account();
            accObj.Name = 'TestAccount1023';
            insert accObj; 
            System.debug(' ##### accObj Id = ' + accObj.Id + ' #####');   
             
            Contact contObj = new Contact();
            contObj.AccountId =  accObj.Id;
            contObj.Email = 'rc1234@test.com';
            contObj.LastName = 'Test Last232';
            contObj.FirstName = 'Test First333';
            insert contObj;
 			System.debug(' ##### contObj Id = ' + contObj.Id + ' #####');
 			
 			List<Case> caseList = new List<Case>();
 			
            Case caseObj = new Case();
           	caseObj.Subject = 'Test Subject';
            caseObj.RecordTypeId = rtMapById.get('IT Helpdesk').getRecordTypeId();
            caseObj.status = 'Open';
            caseObj.Priority='P3';
            caseObj.AccountId = accObj.Id;
            caseObj.Contact_ID__c = contObj.Id;
            caseObj.ContactId = contObj.Id;
            caseObj.Subject = 'Test IT Case';
            caseObj.Description = 'Test Case Desc';
            //insert caseObj;
            caseList.add(caseObj);
            
            Case caseObj1 = new Case();
           	caseObj1.Subject = 'Test Subject';
            caseObj1.RecordTypeId = rtMapById.get('IT Helpdesk').getRecordTypeId();
            caseObj1.status = 'Open';
            caseObj1.Priority='P3';
            caseObj1.AccountId = accObj.Id;
            caseObj1.Contact_ID__c = contObj.Id;
            caseObj1.ContactId = contObj.Id;
            caseObj1.Subject = 'Test IT Case';
            caseObj1.Description = 'Test Case Desc';
            //insert caseObj1;
            caseList.add(caseObj1);
            
            Case caseObj2 = new Case();
           	caseObj2.Subject = 'Test Subject';
            caseObj2.RecordTypeId = rtMapById.get('IT Helpdesk').getRecordTypeId();
            caseObj2.status = 'Open';
            caseObj2.Priority='P3';
            caseObj2.AccountId = accObj.Id;
            caseObj2.Contact_ID__c = contObj.Id;
            caseObj2.ContactId = contObj.Id;
            caseObj2.Subject = 'Test IT Case';
            caseObj2.Description = 'Test Case Desc';
            //insert caseObj2;
            caseList.add(caseObj2);
            
            insert caseList;
            
            CaseComment caseCommentObj = new CaseComment();
            caseCommentObj.ParentId = caseObj.Id;
            caseCommentObj.CommentBody = 'Test 1';
            insert caseCommentObj;
            
            CaseComment caseCommentObj1 = new CaseComment();
            caseCommentObj1.ParentId = caseObj.Id;
            caseCommentObj1.CommentBody = 'Test 2';
            insert caseCommentObj1;
            
            /*CaseHistory caseHistoryObj = new CaseHistory ();
            //caseHistoryObj.Id = caseObj.Id;
            caseHistoryObj.CaseId = caseObj.Id;
            caseHistoryObj.Field = 'Status';
            
            insert caseHistoryObj;
              
            CaseHistory caseHistoryObj1 = new CaseHistory ();
            //caseHistoryObj1.Id = caseObj.Id;
            caseHistoryObj1.CaseId = caseObj.Id;
            insert caseHistoryObj1;*/
            
            Case caseObjUpd = new Case(Id = caseObj.Id);
            caseObjUpd.Status = 'Closed';
            update caseObjUpd;
            
            Test.startTest();
            //ApexPages.currentPage().getParameters().put('parentId', surveyList[0].id);
            //ApexPages.currentPage().getCookies().get(cookieName).getValue()
            //ApexPages.currentPage().getCookies().put('CaseNumber',caseObj1.id);
            
            ApexPages.currentPage().getParameters().put('source','email');
            String case_num='02076376';
            String source= 'email';
            source='wiki';
         
            System.debug(' ##### CASE Id = ' + caseObj.Id + ' #####');	
          	System.debug(' ##### CASE NUMBER = ' + caseObj.CaseNumber + ' #####');	 
       		ITCasesSearchPortal itCaseSearchObj = new ITCasesSearchPortal(new ApexPages.StandardController(caseObj));
            itCaseSearchObj.setSearchText(caseObj.CaseNumber);
         	String caseNumber = [select CaseNumber from Case where Id = : caseObj.Id].CaseNumber;
            System.debug(' ##### SEARCH TEXT = ' + itCaseSearchObj.getSearchText() + ' #####'); 
            itCaseSearchObj.setSearchText(caseNumber);
            try {
          	itCaseSearchObj.search();
          	ApexPages.currentPage().getParameters().put('CaseNumber','case_num');
          	ApexPages.currentPage().getParameters().put('source','email');
           	case_num='02076376';
           	source= 'email';
            
            } catch(Exception e) { System.debug(' ##### NUMBER = ' + e.getLineNumber());}
            itCaseSearchObj.showCaseDetail();
            itCaseSearchObj.caseIdDetail = caseObj.Id;
            itCaseSearchObj.showCaseDetail();
            itCaseSearchObj.backToSearch();
            itCaseSearchObj.backToSearch1();
            ApexPages.currentPage().getParameters().put('source','email');
         	/*itCaseSearchObj.getDetail();
            itCaseSearchObj.getRecent();
            itCaseSearchObj.getCase();
            itCaseSearchObj.edit();
            itCaseSearchObj.detail();
            itCaseSearchObj.view();
            itCaseSearchObj.getResults();*/
            
            ITCasesSearchPortal itCaseSearchObj1 = new ITCasesSearchPortal(new ApexPages.StandardController(caseObj1));
            ITCasesSearchPortal.colorWrapper colorWRObj = new ITCasesSearchPortal.colorWrapper();
            /*
            itCaseSearchObj.getDetail();
		   	itCaseSearchObj.getRecent();
		   	itCaseSearchObj.edit();
		   	itCaseSearchObj.detail();
		  	itCaseSearchObj.getSearchText();
  		   	itCaseSearchObj.getResults();
  		   	itCaseSearchObj.getCase();
  		   	itCaseSearchObj.view();
  		   	itCaseSearchObj.showCaseDetail();
  		   	itCaseSearchObj.backToSearch();
  		   	*/
  		   	ITCasesSearchPortal.CommentWrapper commentObj = new ITCasesSearchPortal.CommentWrapper();
  		   	ITCasesSearchPortal.HistoryWrapper historyObj = new ITCasesSearchPortal.HistoryWrapper();
  		   	Test.stopTest ();
		 } catch(Exception ex) {}
	}
}