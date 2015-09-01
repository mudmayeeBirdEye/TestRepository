/**************************************************************************************************
* Project Name..........: RingCentral - Self Serve Scheduling                                     *
* File..................: Test_ExtAppointment.cls                                                 *
* Version...............: 1.0                                                                     *
* Created by............: Simplion Technologies                                                   *
* Created Date..........: 24 June 2013                                                            *
* Last Modified by......: Simplion Technologies                                                   *
* Last Modified Date....:                                                                         *
* Description...........: Test class for extAppointment                                           *
**************************************************************************************************/
@isTest
private class Test_ExtAppointment {
	
	public static Test_Utils testUtilsObject = new Test_Utils();
	public static extAppointment eaObject;
	public static List<Account> accountList =  new List<Account>();
    public static List<Contact> contactList = new List<Contact>();
    public static List<schedulerConfiguration__c> scList = new List<schedulerConfiguration__c>();
    public static List<Implementation__c> implementationList =  new List<Implementation__c>();
    public static Advisor__c advisorRecord = new Advisor__c();
	
	private static void createImplementationSchedulerCustomSettingRecord(){
		Implementation_Scheduler__c isObject =  new Implementation_Scheduler__c();
		isObject.Name = 'Profiles';
		isObject.Values__c = 'System Administrator';
		
		insert isObject;
	}
	
	private static  Advisor__c createAdvisorRecord(User userRecord, Resource_Pool__c resourcePoolRecord){
		Advisor__c advisor = new Advisor__c();
        advisor.Advisor_Name__c = userRecord.Id;
        advisor.Resource_Pool__c = resourcePoolRecord.Id;
        advisor.Preferred_Language__c = 'en_US';
        insert advisor;
        
        return advisor;
	}
	
	private static void createTestRecords(){
    	
    	/* Contact 3 the best, Account 3 the best */ 
    	
    	TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT();
        	accountList = testUtilsObject.createAccountRecord(new List<Account>{new Account(), 
        																		new Account(Number_of_DL_s__c = 0),
        																		new Account(RC_Brand__c = 'testAccount'),
        																		new Account()});
        TriggerHandler.RESET_VARIABLES();
        TriggerHandler.BY_PASS_CONTACT_ON_INSERT();
        	contactList = testUtilsObject.createContactRecord(new List<Contact>{new Contact(), 
        																	    new Contact(AccountId = accountList[0].Id), 
        																	    new Contact(AccountId = accountList[1].Id),
        																	    new Contact(AccountId = accountList[2].Id),
        																	    new Contact(AccountId = accountList[3].Id)});
        TriggerHandler.RESET_VARIABLES();
        
        // Creating User Record.
    	List<User> userList = testUtilsObject.createUserRecord(new List<User>{new User(), new User()});
        // Creating scheduler configuration record.	
        scList = testUtilsObject.createSchedulerConfigurationRecords(new List<schedulerConfiguration__c>{new schedulerConfiguration__c()}); 
       	// Creating Implementation record.
       	implementationList = testUtilsObject.createImplementationRecords(new List<Implementation__c>{new Implementation__c(Implementation_Status_2__c = 'Completed', Account__c = accountList[0].Id)});
       	// Creating Resource Pool Record.
        List<Resource_Pool__c> resourcePoolList = testUtilsObject.createResourcePoolRecords(new List<Resource_Pool__c>{new Resource_Pool__c(No_of_User_DLs__c = accountList[2].Number_of_DL_s__c, Brand_Name__c = scList[0].Id, Dispatch_Admin__c = userList[1].Id)});
    	// Calling method to create Advisor Record. 
    	advisorRecord = createAdvisorRecord(userList[0], resourcePoolList[0]);	
    	
    	/* debug logs */
    	system.debug('#### Account - '+accountList);
    	system.debug('#### Contact - '+contactList);
    	system.debug('#### Resource Pool - '+resourcePoolList);
    	system.debug('#### User - '+userList);
    	system.debug('#### Brand Configuration - '+scList);
    	system.debug('#### Implementation - '+implementationList);
    	system.debug('#### Advisor - '+advisorRecord);
	}
    
    static testMethod void testOnSave(){
    	
    	// Calling method to create test records.
    	createTestRecords();
    	// Linking a contact.
    	ApexPages.currentPage().getParameters().put('contactId',contactList[3].Id);
    	System.currentPageReference().getParameters().put('rcUserId','12347');
    	
    	List<Time__c> timeList = testUtilsObject.createTimeSlotRecords(new List<Time__c>{new Time__c(Advisor_Name__c = advisorRecord.Id),
    																					 new Time__c(Advisor_Name__c = advisorRecord.Id),
    																					 new Time__c(Advisor_Name__c = advisorRecord.Id),
    																					 new Time__c(Advisor_Name__c = advisorRecord.Id),
    																					 new Time__c(Advisor_Name__c = advisorRecord.Id),
    																					 new Time__c(Advisor_Name__c = advisorRecord.Id),
    																					 new Time__c(Advisor_Name__c = advisorRecord.Id)});
    	
    	/* 1. Calling method, without any time slots configured. */
    	extAppointment objextAppointment = new extAppointment();
    	objextAppointment.stringobjDate = '06/25/2030';	
    	objextAppointment.appointmentLength = '60';
    	objextAppointment.preferredLanguage='en_US';
    	objextAppointment.timeZone = 'America/LosAngeles';
    	objextAppointment.Times = '08:00';
    	objextAppointment.AppointmentLength();
    	objextAppointment.AvailabletimeSlot();
    	objextAppointment.OnSave();
    }
}