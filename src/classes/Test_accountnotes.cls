/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class Test_accountnotes {

    static testMethod void myUnitTest() {
        try{
        	
        Account a = new Account();
        a.Name = 'TestbyAA';
        a.RC_User_ID__c = '345';
        TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT();
        insert a;
                
        Contact c = new Contact();
        c.LastName = 'contactLast';
        c.AccountId = [SELECT id FROM Account WHERE name=: a.Name].id;
        c.email='test@rc.com';
        
        try{
        	insert c;	
        }catch (Exception exp){
        	
        }        
		Test.startTest();
        Opportunity o = new Opportunity();
        o.Name = 'TestaOpp';
        o.AccountId = c.AccountId;
        o.Type = 'New Business';
        o.CloseDate = Date.today();
        o.StageName = '3. ActivePipe';
        o.OwnerId = '005800000036sJJ';
        o.RC_User_ID__c = '345';
        o.Date_Submitted__c = Datetime.now();
        TriggerHandler.BY_PASS_ACCOUNT_ON_UPDATE();
		TriggerHandler.BY_PASS_OPPORTUNITY_ON_INSERT();
		insert o;
        //TriggerHandler.RESET_VARIABLES();
        
        Implementation__c imp = new Implementation__c();
        imp.Name = 'testImp';
        imp.Account__c = a.Id;
        imp.Implementation_Status__c = 'Contacted';
        insert imp;
        
        Contract contract = new Contract();
        contract.AccountId = a.Id;
        insert contract;
       
        Case cs = new Case();        
        cs.AccountId = a.Id;     
        insert cs;

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
        try {
	        n3.ParentId = c.Id;
	        insert n3;        	
        }catch (Exception exp){
        	
        }

        
        Note n4 = new Note();
        n4.Title = 'n4';
        n4.Body = 'n4';
        n4.ParentId = imp.Id;
        insert n4;      
        Test.stopTest();                
        Event event1 = new Event(subject='testEvent1', whatId = imp.Id, StartDateTime = DateTime.now(), DurationInMinutes = 10);
        insert event1;

        Event event2 = new Event(subject='testEvent2', whatId = a.Id, StartDateTime = DateTime.now(), DurationInMinutes = 10);
        insert event2;
        
        Task t1 = new Task(subject='testTask1', whatId = imp.Id, ActivityDate = Date.Today());        
        insert t1;                      
        
        Task t2 = new Task(subject='testTask2', whatId = a.Id, ActivityDate = Date.Today());
        insert t2;
        
        ApexPages.currentPage().getParameters().put('id', a.Id);
        ApexPages.StandardController sc = new ApexPages.standardController(a);
        accountnotes an = new accountnotes(sc);
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
        
        ApexPages.currentPage().getParameters().put('caseID', cs.Id);
        Case getCase = an.getSelectedCase();   
             
        ApexPages.currentPage().getParameters().put('userid', '111');        
        an = new accountnotes(sc); 
              
        }catch(exception ex){}
    }
	static testMethod void Test_AccountUpdateSharingRule() {
	        
			Account a = new Account();
	        a.Name = 'TestbyAA';
	        a.Partner_ID__c = '1234567654321234511';
	        a.RecordTypeId = '01280000000UERqAAO';
	        a.RC_User_ID__c = '345';
	        TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT();
	        insert a;
		  	Id AccountIds='0018000000pwihc';
		 	String partnerid='1234567654321234511';
		 	Id recordTypeId='01280000000UERqAAO';
		 	Set<Id> groupOruserid = new Set<Id>();
		 	AccountUpdateSharingRule.deleteOldSharingRuleForAccount(AccountIds,partnerid,recordTypeId);
	        AccountUpdateSharingRule.deleteOldPrtnerSharingRuleForAccount(AccountIds, partnerid, recordTypeId, groupOruserid);
	 }
	 static testMethod void Test_Approvaldefaults(){
	        Approvaldefaults app = new Approvaldefaults(null);
	        //app.actapprovalObject();
	} 
}