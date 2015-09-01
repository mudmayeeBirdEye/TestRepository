/**************************************************************************************************
* Project Name..........: Medallia                                                                *
* File..................: TestMedalliaSurveyHelper.class                                          *
* Version...............: 1.0                                                                     *
* Created by............: Simplion Technologies                                                   *
* Created Date..........: 11-03-2013                                                              *
* Last Modified by......: Simplion Technologies                                                   *
* Last Modified Date....: 11-03-2013                                                              *
* Description...........: This is a test class for MedalliaSurveyHelper class.                    *
**************************************************************************************************/
@isTest
private class TestMedalliaSurveyHelper {

	public static Schema.DescribeSObjectResult result = Case.SObjectType.getDescribe();
    public static Map<ID,Schema.RecordTypeInfo> rtMapByName = result.getRecordTypeInfosById();
    public static Map<string,Schema.RecordTypeInfo> rtMapById = result.getRecordTypeInfosByName();
    static List<Opportunity> oppList2 = new List<Opportunity>();
    static List<Case> caseList = new List<Case>();

    /******************************************************************************
	* @Description : Method to setup test records.                                *
	* @Params      : void                                                         *
	* @Return      : void                                                         * 
	******************************************************************************/    
	static void recordSetup(){
		Test_Utils testRecordClass = new Test_Utils();
		try{
			// Creating Test User Records.
			User testUser = testRecordClass.createUserRecord(new List<User>{new User()})[0];
			
			// Creating Account Record.
	    	List<Account> testAccountList = new List<Account>();
	    	Account accountRecord = new Account();
	    	accountRecord.type = 'Customer';
	    	accountRecord.RC_Signup_Date__c = Date.Today().addDays(-92);
	    	accountRecord.Current_Owner__c = testUser.Id;
	    	testAccountList.add(accountRecord);
	    	testAccountList = testRecordClass.createAccountRecord(testAccountList);
	    	system.debug('#### testAccount - '+testAccountList);
	    	
	    	// Creating Contact Record.
	    	List<Contact> testContactList = new List<Contact>();
	    	Contact contactRecord = new Contact();
	    	contactRecord.AccountId = testAccountList[0].Id;
	    	testContactList.add(contactRecord);
	    	testContactList = testRecordClass.createContactRecord(testContactList);
	    	system.debug('#### testContact - '+testContactList);
	    	
	    	// Creating Account Contact Role.
	    	AccountContactRole acrRecord = new AccountContactRole();
	    	acrRecord.AccountId = testAccountList[0].Id;
	    	acrRecord.ContactId = testContactList[0].Id;
	    	acrRecord.IsPrimary =  true;
	    	acrRecord.Role = 'Technical Buyer';
	    	
	    	insert acrRecord;
	    	system.debug('#### acrRecord - '+acrRecord);
	    	
	    	List<Opportunity> oppList = new List<Opportunity>();
	    	Opportunity oppObj1 = new Opportunity(name='Test',Amount=150,AccountId=testAccountList[0].id);
	    	Opportunity oppObj2 = new Opportunity(name='Test2',Amount=150,AccountId=testAccountList[0].id);
	    	oppList.add(oppObj1);
	    	oppList.add(oppObj2);
	    	oppList2 = testRecordClass.createOpportunityRecord(oppList);
	    	
	    	List<Case> caseList1 = new List<Case>();
	    	Case casObj1= new Case(recordTypeId= rtMapById.get('Support - T1').getRecordTypeId(),contactId=testContactList[0].id);
            Case casObj2= new Case(recordTypeId= rtMapById.get('Support - T1').getRecordTypeId(),contactId=testContactList[0].Id);
	    	caseList1.add(casObj1);
	    	caseList1.add(casObj2);
            insert caseList1;
            caseList.addAll(caseList1);
	    	//caseList = testRecordClass.createCaseRecord(caseList1);
            System.debug(caseList+'~~~~~~~~~~~~~~~~~~~~~~~~caseList');
            
            /****************************************************************
             * Section to create OpportunityContactRole                     *
            ****************************************************************/
            List<OpportunityContactRole> oppContactRoleList = new List<OpportunityContactRole>();
            OpportunityContactRole oppContactRole;
            for(Integer i=0 ;i<testContactList.size();i++){
                oppContactRole = new OpportunityContactRole();
                oppContactRole.ContactId = testContactList.get(i).Id;
                oppContactRole.IsPrimary = true;
                oppContactRole.OpportunityId = oppList2.get(i).Id;
                oppContactRole.Role = 'Business User';
                oppContactRoleList.add(oppContactRole);
                
            }
           insert oppContactRoleList;
    	}catch(Exception ex){
			system.debug('#### Error on line - '+ex.getLineNumber());
	    	system.debug('#### Error message - '+ex.getMessage());
		}
	}
    
    static testMethod void signatureMedalliaTest() {
        try{
	    	recordSetup();
	    	system.debug('#### opportunity list - '+oppList2);
	    	Test.startTest();
				MedalliaSurveyHelper.insertSignatureMedalliaSurvey(oppList2);
			Test.stopTest();
			
    	}catch(Exception ex){
			system.debug('#### Error on line - '+ex.getLineNumber());
	    	system.debug('#### Error message - '+ex.getMessage());
		}
    }
    
    static testMethod void supportMedalliaTest() {
        try{
	    	recordSetup();
	    	system.debug('#### opportunity list - '+oppList2);
	    	Test.startTest();
				MedalliaSurveyHelper.insertSupportMedalliaSurvey(caseList, rtMapByName);
			Test.stopTest();
			
    	}catch(Exception ex){
			system.debug('#### Error on line - '+ex.getLineNumber());
	    	system.debug('#### Error message - '+ex.getMessage());
		}
    }
    
    static testMethod void controllerBatchTest() {
    	MedalliaSurveyHelper mshObj = new MedalliaSurveyHelper();
    	mshObj.call90DaysBatch();
    	mshObj.medalliaSurveyRetrieveBatch();
    }
    
}