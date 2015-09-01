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
private class extAppointmentTest {
    
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
    private static void createImplementationSchedulerCustomSettingRecord1(){
        Implementation_Scheduler__c isObjectt =  new Implementation_Scheduler__c();
        isObjectt.Name = 'Profiles';
        isObjectt.Values__c = 'Sales Agent';
        
        insert isObjectt;
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
    
        
    static testMethod void testMethodConstructor() {
        
        // Creating custom setting record.
        createImplementationSchedulerCustomSettingRecord();
         
          createImplementationSchedulerCustomSettingRecord1();
        // Calling method to create test records.
        createTestRecords();
        
        // Calling contructor without Contact Id.
        eaObject =  new extAppointment();
        
        // Calling contructor with Contact Id and No Account linked to the Contact.
        ApexPages.currentPage().getParameters().put('contactId',contactList[0].Id);
        eaObject =  new extAppointment();
        
        // Calling contructor with Contact Id and Account linked to the Contact.
        ApexPages.currentPage().getParameters().put('contactId',contactList[1].Id);
        eaObject =  new extAppointment();
        
        // Calling contructor with Contact Id and Account linked to the Contact, with blank RC Brand.
        ApexPages.currentPage().getParameters().put('contactId',contactList[2].Id);
        eaObject =  new extAppointment();
        
        // Calling contructor with Contact Id and Account linked to the Contact, with valid Brand Records.
        ApexPages.currentPage().getParameters().put('contactId',contactList[3].Id);
        eaObject =  new extAppointment();
        
        // Calling contructor with Contact Id and Account linked to the Contact, with RC User Id as null to cover line 166-169.
        accountList[3].RC_User_ID__c =  null;
        TriggerHandler.BY_PASS_ACCOUNT_ON_UPDATE();
            update accountList[3];
        TriggerHandler.RESET_VARIABLES();
        ApexPages.currentPage().getParameters().put('contactId',contactList[4].Id);
        eaObject =  new extAppointment();
        
        // Calling method to reach the exception method.
        extAppointment.toExecute = true;
        eaObject =  new extAppointment();
    }
    
    static testMethod void testMethodConstructor1() {
        
        // Creating custom setting record.
        createImplementationSchedulerCustomSettingRecord();
         
          createImplementationSchedulerCustomSettingRecord1();
        // Calling method to create test records.
        createTestRecords();
        
        // Calling contructor without Contact Id.
        eaObject =  new extAppointment();
        
        // Calling contructor with Contact Id and No Account linked to the Contact.
        ApexPages.currentPage().getParameters().put('contactId',contactList[0].Id);
        eaObject =  new extAppointment();
        
        // Calling contructor with Contact Id and Account linked to the Contact.
        ApexPages.currentPage().getParameters().put('contactId',contactList[1].Id);
        eaObject =  new extAppointment();
        
        // Calling contructor with Contact Id and Account linked to the Contact, with blank RC Brand.
        ApexPages.currentPage().getParameters().put('contactId',contactList[2].Id);
        eaObject =  new extAppointment();
        
        // Calling contructor with Contact Id and Account linked to the Contact, with valid Brand Records.
        ApexPages.currentPage().getParameters().put('contactId',contactList[3].Id);
        eaObject =  new extAppointment();
        
        // Calling contructor with Contact Id and Account linked to the Contact, with RC User Id as null to cover line 166-169.
        accountList[3].RC_User_ID__c =  null;
        TriggerHandler.BY_PASS_ACCOUNT_ON_UPDATE();
            update accountList[3];
        TriggerHandler.RESET_VARIABLES();
        ApexPages.currentPage().getParameters().put('contactId',contactList[4].Id);
        eaObject =  new extAppointment();
        
        // Calling method to reach the exception method.
        extAppointment.toExecute = true;
        eaObject =  new extAppointment();
    }
    
    static testMethod void testMethodNoArguments() {
        eaObject =  new extAppointment();
        eaObject.getImplementationTypes();
        eaObject.close();   
        eaObject.ToSchedule();
        eaObject.ScheduleAppointment();
        eaObject.ReScheduleAppointment();
        eaObject.CancelAppointment();
        eaObject.HomePage();
        eaObject.objectInitializer();
        eaObject.checkMandatoryFields();
       
        //objextAppointment.isImplementationCompleted = true;
        //eaObject.getPreferedLangMethod();
    }
    
    static testMethod void testAppointmentLength(){
        
        // Calling method to create test records.
        createTestRecords();
        // Linking a contact.
        ApexPages.currentPage().getParameters().put('contactId',contactList[3].Id);
        
        extAppointment objextAppointment = new extAppointment();
        // Calling method with no date.
        objextAppointment.AppointmentLength();
        // Calling method with date specified.
        objextAppointment.stringobjDate='06/25/2030';
        objextAppointment.AppointmentLength();
        
        //Checking for saturday and sunday time
        objextAppointment.stringobjDate='06/23/2030';
        objextAppointment.AppointmentLength();
        
        //Checking for past date time
        objextAppointment.stringobjDate='06/23/2013';
        objextAppointment.AppointmentLength();
    }
    
    static testMethod void testAvailabletimeSlot(){
        
        // Calling method to create test records.
        createTestRecords();
        
        // fetchProfileCustomSetting();
        // Linking a contact.
        ApexPages.currentPage().getParameters().put('contactId',contactList[3].Id);
        System.currentPageReference().getParameters().put('rcUserId','12347');
        
        extAppointment objextAppointment = new extAppointment();
        /* 1. Calling method without setting up the time slots. */
        objextAppointment.stringobjDate = '06/25/2030';
        objextAppointment.AppointmentLength();
        objextAppointment.AvailabletimeSlot();
        
        /* 2. Calling method, after setting up the time slots. */
        List<Time__c> timeList = testUtilsObject.createTimeSlotRecords(new List<Time__c>{new Time__c(Advisor_Name__c = advisorRecord.Id),
                                                                                         new Time__c(Advisor_Name__c = advisorRecord.Id),
                                                                                         new Time__c(Advisor_Name__c = advisorRecord.Id),
                                                                                         new Time__c(Advisor_Name__c = advisorRecord.Id),
                                                                                         new Time__c(Advisor_Name__c = advisorRecord.Id),
                                                                                         new Time__c(Advisor_Name__c = advisorRecord.Id),
                                                                                         new Time__c(Advisor_Name__c = advisorRecord.Id)});
        objextAppointment.AvailabletimeSlot();
        
        /* 3. Calling method, after setting up the appointment length. */
        objextAppointment.appointmentLength = '60';
        objextAppointment.preferredLanguage='en_US';
        objextAppointment.timeZone = 'America/LosAngeles';
        objextAppointment.AvailabletimeSlot();
        
        /* 4. Calling method, for a day, on which time slot available, and a invalid Advisor */
        objextAppointment.selectedAdvisor = advisorRecord.Id;
        objextAppointment.AvailabletimeSlot();
        
        /* 5. Calling method, for a day, on which time slot available, and a valid Advisor */
        objextAppointment.selectedAdvisor = advisorRecord.Advisor_Name__c;
        objextAppointment.AvailabletimeSlot();
        objextAppointment.objectInitializer();
        
        /* 6. Calling method, for a day, on which no time slot available*/
        Time__c deleteTime = [SELECT Id FROM Time__c WHERE Day__c = 'Tuesday' LIMIT 1];
        delete deleteTime;
        objextAppointment.AvailabletimeSlot();
    }
    
    static testMethod void testOnSave(){
        
        // Calling method to create test records.
        createTestRecords();
        // Linking a contact.
        ApexPages.currentPage().getParameters().put('contactId',contactList[3].Id);
        System.currentPageReference().getParameters().put('rcUserId','12347');
        
        /* 1. Calling method, without any time slots configured. */
        extAppointment objextAppointment = new extAppointment();
        objextAppointment.stringobjDate = '06/25/2030'; 
        objextAppointment.appointmentLength = '60';
        objextAppointment.preferredLanguage='en_US';
        objextAppointment.timeZone = 'America/LosAngeles';
        objextAppointment.Times = '16:00';
        objextAppointment.AppointmentLength();
         objextAppointment.objectInitializer();
        objextAppointment.objectInitializer();
        objextAppointment.AvailabletimeSlot();
        
        objextAppointment.OnSave();
        
        
    }
    
    static testMethod void testReschedule(){
        
        /* 1. Calling method without any event available. */
        extAppointment objextAppointment = new extAppointment();
        objextAppointment.Reschedule(); 
        
        /* 2. Calling method with event availabe. */
        createTestRecords();
        List<Time__c> timeList = testUtilsObject.createTimeSlotRecords(new List<Time__c>{new Time__c(Advisor_Name__c = advisorRecord.Id),
                                                                                         new Time__c(Advisor_Name__c = advisorRecord.Id),
                                                                                         new Time__c(Advisor_Name__c = advisorRecord.Id),
                                                                                         new Time__c(Advisor_Name__c = advisorRecord.Id),
                                                                                         new Time__c(Advisor_Name__c = advisorRecord.Id),
                                                                                         new Time__c(Advisor_Name__c = advisorRecord.Id),
                                                                                         new Time__c(Advisor_Name__c = advisorRecord.Id)});
        ApexPages.currentPage().getParameters().put('contactId',contactList[3].Id);
        System.currentPageReference().getParameters().put('rcUserId','12347');
        objextAppointment = new extAppointment();
        objextAppointment.stringobjDate = '06/25/2030'; 
        objextAppointment.appointmentLength = '60';
        objextAppointment.preferredLanguage='en_US';
        objextAppointment.timeZone = 'America/LosAngeles';
        objextAppointment.Times = '16:00';
        objextAppointment.AppointmentLength();
        objextAppointment.AvailabletimeSlot();
        objextAppointment.OnSave();
        objextAppointment = new extAppointment();
        objextAppointment.implementationType = 'Initial Implementation';
        objextAppointment.Reschedule(); 
        
    }
    
    static testMethod void testCancelEvent(){
        /* 1. Calling method without any event available. */
        extAppointment objextAppointment = new extAppointment();
        objextAppointment.cancelEvent();
        
        /* 2. Calling method with event availabe. */
        createTestRecords();
        List<Time__c> timeList = testUtilsObject.createTimeSlotRecords(new List<Time__c>{new Time__c(Advisor_Name__c = advisorRecord.Id),
                                                                                         new Time__c(Advisor_Name__c = advisorRecord.Id),
                                                                                         new Time__c(Advisor_Name__c = advisorRecord.Id),
                                                                                         new Time__c(Advisor_Name__c = advisorRecord.Id),
                                                                                         new Time__c(Advisor_Name__c = advisorRecord.Id),
                                                                                         new Time__c(Advisor_Name__c = advisorRecord.Id),
                                                                                         new Time__c(Advisor_Name__c = advisorRecord.Id)});
        ApexPages.currentPage().getParameters().put('contactId',contactList[3].Id);
        System.currentPageReference().getParameters().put('rcUserId','12347');
        objextAppointment = new extAppointment();
        objextAppointment.stringobjDate = '06/25/2030'; 
        objextAppointment.appointmentLength = '60';
        objextAppointment.preferredLanguage='en_US';
        objextAppointment.timeZone = 'America/LosAngeles';
        objextAppointment.Times = '16:00';
        objextAppointment.AppointmentLength();
        objextAppointment.AvailabletimeSlot();
        objextAppointment.OnSave();
        objextAppointment = new extAppointment();
        objextAppointment.implementationType = 'Initial Implementation';
        objextAppointment.cancelEvent();        
    }
    
    static TestMethod void testCheckMandatoryFields(){  
        /* 1. Calling method. */
        extAppointment objextAppointment = new extAppointment(); 
        objextAppointment.checkMandatoryFields();
        
        /* 2. Calling method with event availabe. */
        createTestRecords();
        List<Time__c> timeList = testUtilsObject.createTimeSlotRecords(new List<Time__c>{new Time__c(Advisor_Name__c = advisorRecord.Id),
                                                                                         new Time__c(Advisor_Name__c = advisorRecord.Id),
                                                                                         new Time__c(Advisor_Name__c = advisorRecord.Id),
                                                                                         new Time__c(Advisor_Name__c = advisorRecord.Id),
                                                                                         new Time__c(Advisor_Name__c = advisorRecord.Id),
                                                                                         new Time__c(Advisor_Name__c = advisorRecord.Id),
                                                                                         new Time__c(Advisor_Name__c = advisorRecord.Id)});
        ApexPages.currentPage().getParameters().put('contactId',contactList[3].Id);
        System.currentPageReference().getParameters().put('rcUserId','12347');
        objextAppointment = new extAppointment();
        
        objextAppointment.checkMandatoryFields();
        
        objextAppointment.stringobjDate = '06/25/2030'; 
        objextAppointment.appointmentLength = '60';
        objextAppointment.preferredLanguage='en_US';
        objextAppointment.timeZone = 'America/LosAngeles';
        objextAppointment.Times = '16:00';
        objextAppointment.AppointmentLength();
        objextAppointment.AvailabletimeSlot();
        objextAppointment.OnSave();
        objextAppointment = new extAppointment();
        objextAppointment.implementationType = 'Initial Implementation';
        objextAppointment.cancelEvent();   
    }   
    
    
    static TestMethod void testobjectInitializer(){  
        /* 1. Calling method. */
        extAppointment objextAppointment = new extAppointment(); 
        objextAppointment.objectInitializer();
        
        /* 2. Calling method with event availabe. */
        createTestRecords();
        List<Time__c> timeList = testUtilsObject.createTimeSlotRecords(new List<Time__c>{new Time__c(Advisor_Name__c = advisorRecord.Id),
                                                                                         new Time__c(Advisor_Name__c = advisorRecord.Id),
                                                                                         new Time__c(Advisor_Name__c = advisorRecord.Id),
                                                                                         new Time__c(Advisor_Name__c = advisorRecord.Id),
                                                                                         new Time__c(Advisor_Name__c = advisorRecord.Id),
                                                                                         new Time__c(Advisor_Name__c = advisorRecord.Id),
                                                                                         new Time__c(Advisor_Name__c = advisorRecord.Id)});
        ApexPages.currentPage().getParameters().put('contactId',contactList[3].Id);
        System.currentPageReference().getParameters().put('rcUserId','12347');
        objextAppointment = new extAppointment();
        
        objextAppointment.objectInitializer();
        objextAppointment.preferredLanguage='en_US';
        objextAppointment.timeZone = 'America/LosAngeles';
        objextAppointment.Times = '16:00';
        objextAppointment.AppointmentLength();
        objextAppointment.AvailabletimeSlot();
        objextAppointment.OnSave();
        objextAppointment = new extAppointment();
        objextAppointment.implementationType = 'Initial Implementation';
        objextAppointment.cancelEvent();        
    }   
   /* 
    static TestMethod void testPreferedLangMethod(){  
        
        // Creating custom setting record.
        createImplementationSchedulerCustomSettingRecord();
         
          createImplementationSchedulerCustomSettingRecord1();
        // Calling method to create test records.
        createTestRecords();
        
        // Calling contructor without Contact Id.
        eaObject =  new extAppointment();
        
        ApexPages.currentPage().getParameters().put('contactId',contactList[3].Id);   
        AccountContactRole accConRole  = new AccountContactRole();
        //accConRole.isPrimary = true;
        //accConRole.ContactId= '003V000000HUWn0' ;
        extAppointment objextAppointment  = new extAppointment();
        objextAppointment.getBrandsList();
        //objextAppointment.objectInitializer();
        objextAppointment.getTimeZone();
        objextAppointment.cancelEvent();        
    }   
    
    */
    
     
}