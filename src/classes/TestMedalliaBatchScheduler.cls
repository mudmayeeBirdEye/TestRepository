/**************************************************************************************************
* Project Name..........: Medallia                                                                *
* File..................: TestMedalliaBatchScheduler.class                                        *
* Version...............: 1.0                                                                     *
* Created by............: Simplion Technologies                                                   *
* Created Date..........: 03/28/2014 11:00 PM                                                     *
* Last Modified by......: Simplion Technologies                                                   *
* Last Modified Date....: 03/28/2014 11:00 PM                                                     *
* Description...........: This is a test class for schedule Medallia batch classes.               *
**************************************************************************************************/

@isTest
private class TestMedalliaBatchScheduler {

    /******************************************************************************
	* @Description : Method to setup test records.                                *
	* @Params      : void                                                         *
	* @Return      : void                                                         * 
	******************************************************************************/
	static void recordSetup(){
		Test_Utils testRecordClass = new Test_Utils();
		
		try{
			// Creating Account Record.
	    	List<Account> testAccountList = new List<Account>();
	    	Account accountRecord = new Account();
	    	accountRecord.type = 'Customer';
	    	accountRecord.RC_Signup_Date__c = Date.Today().addDays(-92);
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
	    	
	    	testAccountList[0].Current_Owner__c = testContactList[0].Id;
	    	update testAccountList[0];
	    	system.debug('#### testAccount - '+testAccountList);
	    	
    	}catch(Exception ex){
			system.debug('#### Error on line - '+ex.getLineNumber());
	    	system.debug('#### Error message - '+ex.getMessage());
		}
	}

    static testMethod void medalliaFetchSurvey() {
		
		Test.StartTest();
			ScheduleMedalliaFetchSurveyBatch smfsb = new ScheduleMedalliaFetchSurveyBatch();
			String sch = '0 0 4 * * ?'; 
			system.schedule('Test Medallia Fetch Survey', sch, smfsb); 
		Test.stopTest();

    }
    
    static testMethod void medalliaActiveAccount() {
    	
    	recordSetup();
    	Test.StartTest();
			ScheduleMedalliaActiveAccountBatch smaab = new ScheduleMedalliaActiveAccountBatch();
			String sch = '0 0 1 * * ?'; 
			system.schedule('Test Medallia Active Acount', sch, smaab); 
		Test.stopTest();
    
    }
}