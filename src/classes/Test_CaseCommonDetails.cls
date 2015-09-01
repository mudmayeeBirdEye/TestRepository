/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 */
@isTest
private class Test_CaseCommonDetails {    

    static testMethod void Test_CaseCommentDetails() {
		CaseCommentDetails.CaseCommentDataTest CaseCommentTest= new CaseCommentDetails.CaseCommentDataTest();
		CaseCommentTest.testingCaseData01();
		CaseCommentTest.testingCaseData02(); 
    }
    static testMethod void Test_CaseHighlighter(){
		try{
			Test_Utils tutilss = new Test_Utils();
            tutilss.initialiseTriggerBypass();
      		Account objAccount1= (Account)SmartFactory.createSObject('Account', true);
            objAccount1.RC_User_ID__c='RC'+Math.random();
      		upsert objAccount1;
     		Red_Account__c objRedAcc= (Red_Account__c)SmartFactory.createSObject('Red_Account__c', true);
            objRedAcc.EscalatedAccount__c=objAccount1.id;
            objRedAcc.Status__c='Inprogress';
      		upsert objRedAcc;
     		Case cas1 = new Case( Type = 'VoIP Device Back Order');
            upsert cas1;
  			ApexPages.StandardController controller=new ApexPages.Standardcontroller(cas1);
  			CaseHighlighter objCaseHighlighter=new CaseHighlighter(controller);
  			tutilss.deInitialiseTriggerBypass();
		}catch(Exception e){}  
	}
   static void caseAttachContactTestMethod() {   
		try{
			list<contact> ListContact=new list<contact>();
			Account accountObj = new Account();
			accountObj.Name = 'RC Internal';
			insert accountObj;
			Contact conObjTest = new Contact();
			conObjTest.LastName='Test Name';
			conObjTest.Email='rcindia@simplion.com';
			conObjTest.Phone='1234567890';
			conObjTest.AccountId=accountObj.id;
			ListContact.add(conObjTest);
			Contact conObjTest1=new Contact();
			conObjTest1.LastName='Test Name';
			conObjTest1.Email='Virendra.Singh@simplion.com';
			conObjTest1.Phone='1234567890';
			conObjTest1.AccountId=accountObj.id;
			ListContact.add(conObjTest1);
			insert ListContact;
			
			RecordType rTypeObject = new RecordType();
			rTypeObject = [SELECT  Name,Id, DeveloperName, SobjectType  FROM RecordType where name=:'IT Helpdesk' and SobjectType='case'];
			
			Case caseObjectTest=new Case();
			caseObjectTest.Description = 'myPlainText';
			caseObjectTest.Priority = 'Low';
			caseObjectTest.Origin = 'Email';
			caseObjectTest.Status = 'New';
			caseObjectTest.SuppliedEmail ='rcindia@simplion.com';
			caseObjectTest.SuppliedPhone ='1234567890';
			caseObjectTest.SuppliedName ='Test Name';
			caseObjectTest.Subject = 'Test Subject';
			caseObjectTest.RecordTypeid=rTypeObject.id;
			//insert caseObjectTest;
			/*******************Test Case Record without Supplied Email**************/
			Case caseObjectTest1=new Case();
			caseObjectTest1.Description = 'myPlainText';
			caseObjectTest1.Priority = 'Low';
			caseObjectTest1.Origin = 'Email';
			caseObjectTest1.Status = 'New';
			caseObjectTest1.Subject = 'Test Subject';
			caseObjectTest1.RecordTypeid=rTypeObject.id;
		   // insert caseObjectTest1;
			List<case>  testCaseList=new  List<case>();
			testCaseList.add(caseObjectTest);
			testCaseList.add(caseObjectTest1);
			insert testCaseList;
			Schema.DescribeSObjectResult testmapresult = Case.SObjectType.getDescribe();
			Map<ID,Schema.RecordTypeInfo> testrtMapByName = testmapresult.getRecordTypeInfosById();
			Test.startTest(); 
			CaseITHelpDeskHelper objCLS_AttachContactToCase=new CaseITHelpDeskHelper ();
			objCLS_AttachContactToCase.checkContact(testCaseList,testrtMapByName);
			Test.stopTest();
		}catch(Exception e){}
    }
	static void caseAttachContactTestMethod1() {
        try {
            Account accountObj = new Account(); 
            accountObj.Name = 'RC Internal';
            insert accountObj;
            
            RecordType rTypeObject = new RecordType();
            rTypeObject = [SELECT  Name,Id, DeveloperName, SobjectType  FROM RecordType where name=:'IT Helpdesk' and SobjectType='case'];
            
            Case caseObjectTest=new Case();
            caseObjectTest.Description = 'myPlainText';
            caseObjectTest.Priority = 'Low';
            caseObjectTest.Origin = 'Email';
            caseObjectTest.Status = 'New';
            caseObjectTest.SuppliedEmail ='rcindia@simplion.com';
            caseObjectTest.SuppliedPhone ='1234567890';
            caseObjectTest.SuppliedName ='Test Name';
            caseObjectTest.Subject = 'Test Subject';
            caseObjectTest.RecordTypeid=rTypeObject.id;
            insert caseObjectTest;
            
            List<case>  testCaseList=new  List<case>();
            testCaseList.add(caseObjectTest);
            Schema.DescribeSObjectResult testmapresult = Case.SObjectType.getDescribe();
            Map<ID,Schema.RecordTypeInfo> testrtMapByName = testmapresult.getRecordTypeInfosById();
            Test.startTest(); 
            CaseITHelpDeskHelper objCLS_AttachContactToCase=new CaseITHelpDeskHelper ();
            objCLS_AttachContactToCase.checkContact(testCaseList,testrtMapByName);
            Test.stopTest();
        } catch(Exception ex) {}
    } 
    static testMethod void Test_CancelCase(){
        CancelCase.CancelDataTest CancelCaseTest= new CancelCase.CancelDataTest();
		CancelCaseTest.testingCancelData01();
		CancelCaseTest.testingCancelData02();
		CancelCaseTest.testingCancelData03();
    }  
    static testMethod void myUnitTest() {
         Lead  r = new Lead();   
       r.FirstName='testabc';
       r.lastName ='testxyz';
       r.Leadsource ='abcd';
       r.Agent_Email_Address__c ='xyz';
       r.Phone='123654789';
       r.Email='Test@Test.com';
       ApexPages.StandardController sc = new ApexPages.standardController(r);
       CaseSolveSellLeadController rc = new CaseSolveSellLeadController(sc);
       rc.saveLead();
       rc.searchLeads();
       rc.testingEdgeData011();
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
    static testMethod void Test_ChangePasswordController() {
        // Instantiate a new controller with all parameters in the page
        ChangePasswordController controller = new ChangePasswordController();
        controller.oldPassword = '123456';
        controller.newPassword = 'qwerty1'; 
        controller.verifyNewPassword = 'qwerty1';                
        
        System.assertEquals(controller.changePassword(),null);                           
    } 
    static Account returnAccount() {
        Account acc = new Account(RC_account_number__c = '234', Name = 'TELUS House Account');
        Test_Utils tutils = new Test_Utils();
        tutils.initialiseTriggerBypass();
        insert acc;
        tutils.deInitialiseTriggerBypass();
        return acc;
    }
	Public Static testmethod Void findMissingAccountTestMethod(){
		Account acc = returnAccount();
		Case cas1 = new Case(Subject = 'test Case', Description='test description', Case_Account_Number__c = '1234' );
		Case cas2 = new Case(Subject = 'test Case', Description='test description', Case_Account_Number__c = '234' );
		Case cas3 = new Case(Subject = 'test Case', Description='test description', Case_Account_Number__c = '2346743' );
		Case cas4 = new Case(Subject = 'test Case', Description='test description',AccountId = acc.id);		
		
		List<Case> caseList = new List<Case>{cas1,cas2,cas3,cas4};
		Test_Utils tutils = new Test_Utils();
        tutils.initialiseTriggerBypass();
        insert caseList;
        tutils.deInitialiseTriggerBypass();
        CaseITHelpDeskHelper.findMissingAccount(caseList);
        
	}
}