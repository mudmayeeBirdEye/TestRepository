@isTest
private class Test_ClassAccount {

	static testMethod void Test_accountsummary() {
		Test.startTest();
		triggerHandler.BY_PASS_ACCOUNT_ON_INSERT = true;
		triggerHandler.BY_PASS_ACCOUNT_ON_INSERT();
		triggerHandler.BY_PASS_ACCOUNT_ON_UPDATE = true;
		triggerHandler.BY_PASS_CASE_ON_UPDATE();
		triggerHandler.BY_PASS_CONTACT_ON_INSERT = true;
		triggerHandler.BY_PASS_CONTACT_ON_INSERT();
		triggerHandler.BY_PASS_CONTACT_ON_UPDATE = true;
		triggerHandler.BY_PASS_CONTACT_ON_UPDATE();
		triggerHandler.BY_PASS_OPPORTUNITY_ON_INSERT = true;
		triggerHandler.BY_PASS_OPPORTUNITY_ON_INSERT();
		triggerHandler.BY_PASS_OPPORTUNITY_ON_UPDATE = true;
		triggerHandler.BY_PASS_OPPORTUNITY_ON_UPDATE();
		
		Account a = new Account();
		a.Name = 'TestbyJesse';
		a.RC_User_ID__c = '345';
		insert a;

		Contact c = new Contact();
		c.LastName = 'contactLast';
		c.AccountId = [SELECT id FROM Account WHERE name=: a.Name].id;
		c.email='test@rc.com';
		try{
			insert c;	
		}catch(Exception exp){

		}

		Opportunity o = new Opportunity();
		o.Name = 'TestaOpp';
		o.AccountId = c.AccountId;
		o.Type = 'New Business';
		o.CloseDate = Date.today();
		o.StageName = '3. ActivePipe';
		o.OwnerId = '005800000036sJJ';
		o.RC_User_ID__c = '345';
		o.Date_Submitted__c = Datetime.now();
		insert o;

		Implementation__c imp = new Implementation__c();
		imp.Name = 'testImp';
		imp.Account__c = a.Id;
		imp.Implementation_Status__c = 'Contacted';
		insert imp;

		Contract contract = new Contract();
		contract.AccountId = a.Id;
		insert contract;

		Note n1 = new Note();
		n1.Title = 'n1';
		n1.Body = 'n1';
		n1.ParentId = a.Id;
		insert n1;

		Note n2 = new Note();
		n2.Title = 'n2';
		n2.Body = 'n2';
		n2.ParentId = o.Id;
		insert n2;      

		Note n3 = new Note();
		n3.Title = 'n3';
		n3.Body = 'n3';
		try{
			n3.ParentId = c.Id;
			insert n3;	                	
		}catch(Exception exp){

		}

		Note n4 = new Note();
		n4.Title = 'n4';
		n4.Body = 'n4';
		n4.ParentId = imp.Id;
		insert n4;      

		Event event1 = new Event(subject='testEvent1', whatId = imp.Id, StartDateTime = DateTime.now(), DurationInMinutes = 10);
		insert event1;

		Event event2 = new Event(subject='testEvent2', whatId = a.Id, StartDateTime = DateTime.now(), DurationInMinutes = 10);
		insert event2;

		Task t1 = new Task(subject='testTask1', whatId = imp.Id, ActivityDate = Date.Today());        
		insert t1;                      

		Task t2 = new Task(subject='testTask2', whatId = a.Id, ActivityDate = Date.Today());
		insert t2;
		Test.stopTest();
		
		ApexPages.currentPage().getParameters().put('userid', a.RC_User_ID__c);

		accountsummary an = new accountsummary();
		String aId = an.getAccountID();
		String aName = an.getAccountName();
		Boolean acctFound = an.getAccountFound();
		Boolean acctNotFound = an.getAccountNotFound();

		ApexPages.currentPage().getParameters().put('noteId', n1.Id);
		Note getNote = an.getSelectedNote();

		ApexPages.currentPage().getParameters().put('eventId', event1.Id);
		Event getEvent = an.getSelectedEvent();

		ApexPages.currentPage().getParameters().put('taskId', t1.Id);
		Task getTask = an.getSelectedTask();

		ApexPages.currentPage().getParameters().put('contractId', contract.Id);
		Contract getContract = an.getSelectedContract();  

		ApexPages.currentPage().getParameters().put('userid', '111');        
		an = new accountsummary();               

	}
	
	static testMethod void Test_Approvaldefaults(){
		Test.startTest();
		Account a = new Account();
		a.Name = 'TestbyAA';
		a.RC_User_ID__c = '345';
		insert a;
		
		Opportunity o = new Opportunity();
		o.Name = 'TestaOpp';
		o.AccountId = a.Id;
		o.Type = 'New Business';
		o.CloseDate = Date.today();
		o.StageName = '3. ActivePipe';
		o.OwnerId = '005800000036sJJ';
		o.RC_User_ID__c = '345';
		o.Date_Submitted__c = Datetime.now();
		insert o;
		Test.stopTest();
		
		Approval__c objApp = new Approval__c();
		string strrecord = [select id from RecordType where SobjectType='Approval__c' AND Name = 'Invoicing Request' limit 1].id;
		objApp.RecordTypeId=strrecord;
		system.debug('objApp.RecordTypeId:'+objApp.RecordTypeId);
		ApexPages.currentPage().getParameters().put('RecordType', strrecord);
		system.debug(ApexPages.currentPage().getParameters().get('RecordType'));
		ApexPages.StandardController stdCont = new ApexPages.StandardController(objApp);
		
		Approvaldefaults app = new Approvaldefaults(stdCont);
		app.actapprovalObject();
		
		//app.actapprovalObject();
	} 
	static testMethod void Test_authUserWS() {

		Account objAccont = new Account();
		//LastName = 'test',RC_User_ID__c = '123456'
		objAccont.Name = 'test';
		objAccont.RC_User_ID__c = '123456';
		insert objAccont;
		Contact c = new Contact();
		c.LastName = 'contactLast';
		c.AccountId = objAccont.Id;//[SELECT id FROM Account WHERE name=: a.Name].id;
		c.email='test@test.com';

		try{
			insert c;	
		}catch (Exception exp){

		} 
		Profile p = [SELECT Id FROM Profile WHERE Name='Customer Portal User']; 
		User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
				EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
				LocaleSidKey='en_US', ProfileId = p.Id,contactId =c.id, 
				TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.com');
		insert u;


		test.startTest();
		authUserWS syncAcc = new authUserWS();
		authUserWS.authUserInputParam syncparam = new authUserWS.authUserInputParam();
		syncparam.In_RCUserID='123456';
		syncparam.In_RCPrimaryNumber='234567';
		syncparam.In_ContactMail ='test@test.com';
		//syncparam.Out_Status ='test';
		syncparam.Out_UserID ='23456';
		syncparam.Out_Password ='test';
		authUserWS.authUser(syncparam);
		test.stopTest();
	}
}