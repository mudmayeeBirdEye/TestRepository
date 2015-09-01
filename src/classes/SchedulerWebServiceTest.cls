/**************************************************************************************************
* Project Name..........: Implementation Scheduler.                                               *
* File..................: SchedulerWebServiceTest.cls                                             *
* Version...............: 1.0                                                                     *
* Created by............: Simplion Technologies                                                   *
* Created Date..........: 15-06-2013                                                              *
* Last Modified by......: Simplion Technologies                                                   *
* Last Modified Date....: 18-03-2014                                                              *
* Description...........: This is a Test class for SchedulerWebService.class                      *
**************************************************************************************************/

@IsTest
public class SchedulerWebServiceTest{
	
    /******************************************************************************
	* @Description : Controller class                                             *
	* @Params      : void                                                         *
	* @Return      : void                                                         * 
	******************************************************************************/
	public SchedulerWebServiceTest(){
		
		OrgWideEmailAddress oea = new OrgWideEmailAddress();
		oea = [SELECT Id FROM OrgWideEmailAddress LIMIT 1];
		
		BrandOrgwideEmail__c bow = new BrandOrgwideEmail__c();
		bow.Name = 'testAccount';
		bow.OrgWideEmailId__c = oea != null ? oea.Id:null;
		bow.Subject__c = 'testmail';
		insert bow;
		
	}

    /******************************************************************************
	* @Description : Method to test Buffer days.                                  *
	* @Params      : void                                                         *
	* @Return      : void                                                         * 
	******************************************************************************/
    static testMethod void test_getBufferDays(){

        SchedulerWebService.getBufferDaysRequest Request = new SchedulerWebService.getBufferDaysRequest();
        SchedulerWebService.getBufferDaysResponse Response = new SchedulerWebService.getBufferDaysResponse();         

		// Instantiating class to setup test records.
		Test_Utils testRecordClass = new Test_Utils();
		
        // Creating Account
        schedulerConfiguration__c createBrand = new schedulerConfiguration__c();
        createBrand = testRecordClass.createSchedulerConfigurationRecords(new List<schedulerConfiguration__c>{new schedulerConfiguration__c()})[0];

		Test.startTest();
		
        // Testing for Brand Id null
        Request.BrandID = null;
        Request.NumberofUsers = 20;
        Response = SchedulerWebService.getBufferDays(Request);
        //System.assertEquals('Error : Please input a Brand Id.',Response.error_code);

        // Testing for Number of Users null
        Request.BrandID = 'test123';
        Request.NumberofUsers = null;
        Response = SchedulerWebService.getBufferDays(Request);
        //System.assertEquals('Error : Please input Number of Users.',Response.error_code);

        // Testing for positive case
        Request.BrandID = 'test123';
        Request.NumberofUsers = 20;
        Response = SchedulerWebService.getBufferDays(Request);
        //System.assertEquals(5,Response.bufferDays); 

        //Testing for Brand Id not available
        Request.BrandID = 'test1';
        Request.NumberofUsers = 2;
        Response = SchedulerWebService.getBufferDays(Request);
        //System.assertEquals('Error : No Brand exists with Id - test1',Response.error_code);     
        
        Test.stopTest();
    }

    /******************************************************************************
	* @Description : Method to test Fetch Event details.                          *
	* @Params      : void                                                         *
	* @Return      : void                                                         * 
	******************************************************************************/
    // Test Method 2: get Event Details ----Obtain details from existing event
    static testMethod void test_getEventDetails(){

        SchedulerWebService.getEventDetailsRequest Request = new SchedulerWebService.getEventDetailsRequest();
        SchedulerWebService.getEventDetailsResponse Response = new SchedulerWebService.getEventDetailsResponse();

		// Instantiating class to setup test records.
		Test_Utils testRecordClass = new Test_Utils();
        
        /* Setting up test records */
        // Creating test User.
        User testUser1 = new User();                   
		testUser1 = testRecordClass.createUserRecord(new List<User>{new User()})[0];
        // Creating Brand
        schedulerConfiguration__c createBrand = new schedulerConfiguration__c();
        createBrand = testRecordClass.createSchedulerConfigurationRecords(new List<schedulerConfiguration__c>{new schedulerConfiguration__c()})[0];
        // Creating Resource
        Resource_Pool__c resPool = new Resource_Pool__c();
        resPool = testRecordClass.createResourcePoolRecords(new List<Resource_Pool__c>{new Resource_Pool__c()})[0];

        //Calling method to create new event.
        Event event = new Event();
        event = createEventRecord(createBrand.Brand_Id__c, resPool.Id);

		Test.startTest();
		
        //Testing for Event as null         
        Request.EventID = null;         
        Response = SchedulerWebService.getEventDetails(Request);

        //Testing for positive case
        Request.EventID = event.id;         
        Response = SchedulerWebService.getEventDetails(Request);

        //Testing for wrong event Id
        Request.EventID = '00UQ0000003jtUZABC';
        Response = SchedulerWebService.getEventDetails(Request);

		Test.stopTest();
    }

    /******************************************************************************
	* @Description : Method to test Calendar Availability.                        *
	* @Params      : void                                                         *
	* @Return      : void                                                         * 
	******************************************************************************/
    static testMethod void test_getAvailibility(){

        SchedulerWebService.getAvailibilityRequest Request = new SchedulerWebService.getAvailibilityRequest();
        SchedulerWebService.getAvailibilityResponse Response = new SchedulerWebService.getAvailibilityResponse();

		// Instantiating class to setup test records.
		Test_Utils testRecordClass = new Test_Utils();
        
        /* Setting up test records */
        // Creating test User.
        User testUser1 = new User();                   
		testUser1 = testRecordClass.createUserRecord(new List<User>{new User()})[0];
        // Creating Brand
        schedulerConfiguration__c createBrand = new schedulerConfiguration__c();
        createBrand = testRecordClass.createSchedulerConfigurationRecords(new List<schedulerConfiguration__c>{new schedulerConfiguration__c()})[0];
        // Creating Resource
        Resource_Pool__c resPool = new Resource_Pool__c();
        resPool = testRecordClass.createResourcePoolRecords(new List<Resource_Pool__c>{new Resource_Pool__c()})[0];
        resPool.Brand_Name__c = createBrand.Id;
        resPool.Dispatch_Admin__c = testUser1.Id;   
        update resPool;
        //Creating Advisor
        User testUser2 = new User();      
        testUser2 = testRecordClass.createUserRecord(new List<User>{new User()})[0];             
        
        Advisor__c advisor = new Advisor__c();
        advisor.Advisor_Name__c = testUser2.Id;
        advisor.Resource_Pool__c = resPool.Id;
        advisor.Preferred_Language__c = 'en_US';
        insert advisor; 
        
        //Creating Time Slots   
        List<Time__c> listTimeSlots = new List<Time__c>();
        //Monday    
        Time__c timeSlot1 = new Time__c();
        timeSlot1.Advisor_Name__c = advisor.id;
        listTimeSlots.add(timeSlot1);
        
        //Tuesday
        Time__c timeSlot2 = new Time__c();
        timeSlot2.Advisor_Name__c = advisor.id;
        listTimeSlots.add(timeSlot2);
        
        //Wednesday
        Time__c timeSlot3 = new Time__c();
        timeSlot3.Advisor_Name__c = advisor.id;
        listTimeSlots.add(timeSlot3);
         
        //Thursday
        Time__c timeSlot4 = new Time__c();
        timeSlot4.Advisor_Name__c = advisor.id;
        listTimeSlots.add(timeSlot4);
        
        //Friday
        Time__c timeSlot5 = new Time__c();
        timeSlot5.Advisor_Name__c = advisor.id;
        listTimeSlots.add(timeSlot5);
        
        //Saturday
        Time__c timeSlot6 = new Time__c();
        timeSlot6.Advisor_Name__c = advisor.id;
        listTimeSlots.add(timeSlot6);
        
        //Sunday
        Time__c timeSlot7 = new Time__c();
        timeSlot7.Advisor_Name__c = advisor.id;
        listTimeSlots.add(timeSlot7);
        
        
        listTimeSlots = testRecordClass.createTimeSlotRecords(listTimeSlots);

        //Calling method to create new event.
        Event event = new Event();
        event = createEventRecord(createBrand.Brand_Id__c, resPool.Id);

		Test.startTest();
		
        //Creating date - Date format : 06/20/2013      
        string strConvertedDate ;
        Datetime GMTDate = DateTime.Now();
        strConvertedDate = GMTDate.format('MM/dd/yyyy','English (United States)');
        strConvertedDate =strConvertedDate;

        //Testing for positive case with a valid advisor Id, and availability.
        Request.CustomerID = '1234';
        Request.BrandID= 'test123'; 
        Request.NumberofUsers= 20; 
        Request.cdate = strConvertedDate;
        Request.appointmentLength = '60';
        Request.premiumSupport = false;
        Request.advisorId = testUser2.Id;
        Request.preferredLanguage='en_US';
    	Request.timeZone = 'America/LosAngeles';
        Response = SchedulerWebService.getAvailibility(Request);
        
        //Testing for positive case with a valid advisor Id, and no availability.
        Request.CustomerID = '1234';
        Request.BrandID= 'test123'; 
        Request.NumberofUsers= 20; 
        Request.cdate = strConvertedDate;
        Request.appointmentLength = '60';
        Request.premiumSupport = false;
        Request.advisorId = testUser1.Id;
        Request.preferredLanguage='en_US';
    	Request.timeZone = 'America/LosAngeles';
        Response = SchedulerWebService.getAvailibility(Request);
        
        //Testing for positive case with blank advisor Id.
        Request.CustomerID = '1234';
        Request.BrandID= 'test123'; 
        Request.NumberofUsers= 20; 
        Request.cdate = strConvertedDate;
        Request.appointmentLength = '60';
        Request.premiumSupport = false;
        Request.advisorId = null;
        Request.preferredLanguage='en_US';
    	Request.timeZone = 'America/LosAngeles';
        Response = SchedulerWebService.getAvailibility(Request);

        // Testing for Brand Id null
        Request.CustomerID = '1234';
        Request.BrandID= null; 
        Request.NumberofUsers= 20; 
        Request.cdate = strConvertedDate;
        Request.appointmentLength = '60';
        Request.premiumSupport = false;   
        Request.preferredLanguage='en_US';
    	Request.timeZone = 'America/LosAngeles'; 
        Response = SchedulerWebService.getAvailibility(Request);

        //Testing for Number of Users null
        Request.CustomerID = '1234';
        Request.BrandID= 'test123'; 
        Request.NumberofUsers= null; 
        Request.cdate = strConvertedDate ; 
        Request.appointmentLength = '60';
        Request.premiumSupport = false;      
        Request.preferredLanguage='en_US';
    	Request.timeZone = 'America/LosAngeles';
        Response = SchedulerWebService.getAvailibility(Request);

        //Testing for Brand Id not existing       
        Request.CustomerID = '1234';
        Request.BrandID= 'test1'; 
        Request.NumberofUsers= 20; 
        Request.cdate = strConvertedDate;    
        Request.appointmentLength = '60';
        Request.premiumSupport = false;     
        Request.preferredLanguage='en_US';
    	Request.timeZone = 'America/LosAngeles'; 
        Response = SchedulerWebService.getAvailibility(Request);

        //Testing for no resource pool present
        Request.CustomerID = '1234';
        Request.BrandID= 'test123'; 
        Request.NumberofUsers= 15; 
        Request.cdate = strConvertedDate;        
        Request.appointmentLength = '60';
        Request.premiumSupport = false;  
        Request.preferredLanguage='en_US';
    	Request.timeZone = 'America/LosAngeles';
        Response = SchedulerWebService.getAvailibility(Request);

        //Testing for date null
        Request.CustomerID = '005XXXXXXXXXXXXXXX';
        Request.BrandID= 'test123'; 
        Request.NumberofUsers= 15; 
        Request.cdate = null;    
        Request.appointmentLength = '60';
        Request.premiumSupport = false;      
        Request.preferredLanguage='en_US';
    	Request.timeZone = 'America/LosAngeles';
        Response = SchedulerWebService.getAvailibility(Request);

        //Testing for customer id null
        Request.CustomerID = '1234';
        Request.BrandID = 'test123'; 
        Request.NumberofUsers = 15; 
        Request.cdate = strConvertedDate;
        Request.appointmentLength = null;
        Request.premiumSupport = false;        
        Request.preferredLanguage='en_US';
    	Request.timeZone = 'America/LosAngeles';  
        Response = SchedulerWebService.getAvailibility(Request);
        
        //Testing for appointment length null
        Request.CustomerID = null;
        Request.BrandID= 'test123'; 
        Request.NumberofUsers= 15; 
        Request.cdate = strConvertedDate;
        Request.appointmentLength = '60';
        Request.premiumSupport = false;        
        Request.preferredLanguage='en_US';
    	Request.timeZone = 'America/LosAngeles';  
        Response = SchedulerWebService.getAvailibility(Request);
        
        Test.stopTest();
    }

    /******************************************************************************
	* @Description : Method to test Create event and save the above parameters on *
	*				 that event; remove used resource from relevant               *
	*				 resource pool-Email event Contact a Confirmation.            *
	* @Params      : void                                                         *
	* @Return      : void                                                         * 
	******************************************************************************/
    static testMethod void test_scheduleEventEqual(){
        SchedulerWebService.scheduleEventRequest Request = new SchedulerWebService.scheduleEventRequest();
        SchedulerWebService.scheduleEventResponse Response = new SchedulerWebService.scheduleEventResponse();
       //SchedulerWebService.resheduleEventsRequest Request = new SchedulerWebService.resheduleEventsRequest();
       // SchedulerWebService.resheduleEventsResponse Response = new SchedulerWebService.resheduleEventsResponse();
        string strConvertedDate ;
        string strDate;
        Datetime GMTDate = DateTime.Now();
        strDate = GMTDate.format('MM/dd/yyyy','English (United States)');
	
		SchedulerWebServiceTest swt =  new SchedulerWebServiceTest();
		
        EmailTemplate eTemp = new EmailTemplate();
        eTemp.Name = 'Test';
        eTemp.folderId = [SELECT AccessType ,Id , Name, NamespacePrefix,Type FROM Folder WHERE Name=:'Support OA Emails' LIMIT 1].id;
        eTemp.Subject = '#datetime# - Test Template';
        eTemp.Encoding = 'UTF-8';
        eTemp.TemplateType = 'Custom';
        eTemp.DeveloperName = 'Test';
        eTemp.IsActive = true;
        eTemp.HtmlValue = '#datetime#,#supportnumber#,#eventid#';
        eTemp.Body = '#datetime#,#supportnumber#,#eventid#';
        System.runAs(new User(Id = Userinfo.getUserId())) {
            insert eTemp;
        }


		// Instantiating class to setup test records.
		Test_Utils testRecordClass = new Test_Utils();
        
        /* Setting up test records */
        // Creating test User.
        User testUser1 = new User();                   
		testUser1 = testRecordClass.createUserRecord(new List<User>{new User()})[0];
        // Creating Brand
        schedulerConfiguration__c createBrand = new schedulerConfiguration__c();
        createBrand.Brand_Id__c = '1010';
        createBrand.Name = 'TestBrand';
        createBrand.Confirmation_Email_Template_Name__c = eTemp.id;
        createBrand = testRecordClass.createSchedulerConfigurationRecords(new List<schedulerConfiguration__c>{createBrand})[0];
        
        // Creating Account Record.
		testRecordClass.createAccountRecord(new List<Account>{new Account(RC_Brand__c = 'TestBrand')});
		
        // Creating Resource
        Resource_Pool__c resPool = new Resource_Pool__c();
        system.debug('#### Test Class createBrand - '+createBrand);
        resPool.Brand_Name__c = createBrand.Id;
        resPool.Dispatch_Admin__c = testUser1.Id;
        resPool = testRecordClass.createResourcePoolRecords(new List<Resource_Pool__c>{resPool})[0];

		//Creating Advisor
        User testUser2 = new User();      
        testUser2 = testRecordClass.createUserRecord(new List<User>{new User()})[0];             
        
        Advisor__c advisor = new Advisor__c();
        advisor.Advisor_Name__c = testUser2.Id;
        advisor.Resource_Pool__c = resPool.Id;
        advisor.Preferred_Language__c = 'en_US';
        insert advisor; 
        
        //Creating Time Slots    
        List<Time__c> listTimeSlots = new List<Time__c>();
        //Monday    
        Time__c timeSlot1 = new Time__c();
        timeSlot1.Advisor_Name__c = advisor.id;
        listTimeSlots.add(timeSlot1);
          
        //Tuesday
        Time__c timeSlot2 = new Time__c();
        timeSlot2.Advisor_Name__c = advisor.id;
        listTimeSlots.add(timeSlot2);
        
        //Wednesday
        Time__c timeSlot3 = new Time__c();
        timeSlot3.Advisor_Name__c = advisor.id;
        listTimeSlots.add(timeSlot3);
         
        //Thursday
        Time__c timeSlot4 = new Time__c();
        timeSlot4.Advisor_Name__c = advisor.id;
        listTimeSlots.add(timeSlot4);
        
        //Friday
        Time__c timeSlot5 = new Time__c();
        timeSlot5.Advisor_Name__c = advisor.id;
        listTimeSlots.add(timeSlot5);
        
        //Saturday
        Time__c timeSlot6 = new Time__c();
        timeSlot6.Advisor_Name__c = advisor.id;
        listTimeSlots.add(timeSlot6);
        
        //Sunday
        Time__c timeSlot7 = new Time__c();
        timeSlot7.Advisor_Name__c = advisor.id;
        listTimeSlots.add(timeSlot7);
        
        listTimeSlots = testRecordClass.createTimeSlotRecords(listTimeSlots);      
		system.debug('#### listTimeSlots - '+listTimeSlots);
		
		Test.startTest();
		
        // Checking for positive case, with valid advisor Id.
        strConvertedDate = strDate+' '+'08:00 AM';
        Request.cdatetime = strConvertedDate ;
        Request.BrandID = '1010'; 
        Request.NumberofUsers = 20;
        Request.CustomerId = '12345';
        Request.firstName = 'test1';
        Request.lastname = 'test2';
        Request.Email = 'test@test.com';
        Request.Notes = 'This is a test event'; 
        Request.appointmentLength = '60';
        Request.premiumSupport = false;
        Request.advisorId = null;
        Request.preferredLanguage='en_US';
    	Request.timeZone = 'America/LosAngeles';
        Response = SchedulerWebService.scheduleEvent(Request); 
        
        Request.cdatetime = strDate+' '+'09:00 AM';
		Request.advisorId = testUser2.Id;
		Response = SchedulerWebService.scheduleEvent(Request); 
        
        Request.cdatetime = strDate+' '+'10:00 AM';
        Request.advisorId = testUser1.Id;
        Response = SchedulerWebService.scheduleEvent(Request); 
        
        Request.cdatetime = strDate+' '+'11:00 AM';
        Request.advisorId = testUser1.Id;
        Request.NumberofUsers = 10;
        Response = SchedulerWebService.scheduleEvent(Request); 
        
		system.debug('#### sucess_code - '+Response.sucess_code);
        system.debug('#### error_code - '+Response.error_code);    

        // Testing for available time slot already booked
        strConvertedDate =strDate+' '+'08:00 AM';
        Request.cdatetime=strConvertedDate ;
        Request.BrandID = '1010'; 
        Request.NumberofUsers= 20;
        Request.CustomerId= '1111';
        Request.firstName = 'test1';
        Request.lastname = 'test2';
        Request.Email = 'test@test.com';
        Request.Notes = 'This is a test event'; 
        Request.appointmentLength = '60';
        Request.premiumSupport = false;      
        Request.preferredLanguage='en_US';
    	Request.timeZone = 'America/LosAngeles';   
        Response = SchedulerWebService.scheduleEvent(Request);  
       // Response = SchedulerWebService.resheduleEvents(Request);   
        
        system.debug('#### sucess_code - '+Response.sucess_code);
        system.debug('#### error_code - '+Response.error_code);    

        //for criteria '>' 
        resPool.clear();
        resPool.Brand_Name__c = createBrand.Id;
        resPool.Dispatch_Admin__c = testUser1.Id;
        resPool.Criteria__c = '>';
        resPool = testRecordClass.createResourcePoolRecords(new List<Resource_Pool__c>{resPool})[0];

        //Creating Advisor
        advisor.clear();
        advisor.Advisor_Name__c = testUser2.id;
        advisor.Resource_Pool__c = resPool.id;
        insert advisor;
        
        //Creating Time Slots
        List<Time__c> listTime3 = new List<Time__c>();
        //Monday    
        timeSlot1.clear();
        timeSlot1.Advisor_Name__c = advisor.id;
        timeSlot1.Day__c = 'Monday';
        timeSlot1.Start_Time__c = '05:00';
        timeSlot1.End_Time__c = '17:00';
        listTime3.add(timeSlot1);

        //Tuesday
        timeSlot2.clear();
        timeSlot2.Advisor_Name__c = advisor.id;
        timeSlot2.Day__c = 'Tuesday';
        timeSlot2.Start_Time__c = '05:00';
        timeSlot2.End_Time__c = '17:00';
        listTime3.add(timeSlot2);
        
        //Wednesday
        timeSlot3.clear();
        timeSlot3.Advisor_Name__c = advisor.id;
        timeSlot3.Day__c = 'Wednesday';
        timeSlot3.Start_Time__c = '05:00';
        timeSlot3.End_Time__c = '17:00';
        listTime3.add(timeSlot3);
         
        //Thursday
        timeSlot4.clear();
        timeSlot4.Advisor_Name__c = advisor.id;
        timeSlot4.Day__c = 'Thursday';
        timeSlot4.Start_Time__c = '05:00';
        timeSlot4.End_Time__c = '17:00';
        listTime3.add(timeSlot4);
        
        //Friday
        timeSlot5.clear();
        timeSlot5.Advisor_Name__c = advisor.id;
        timeSlot5.Day__c = 'Friday';
        timeSlot5.Start_Time__c = '05:00';
        timeSlot5.End_Time__c = '17:00';
        listTime3.add(timeSlot5);
		
        //Saturday
        timeSlot5.clear();
        timeSlot5.Advisor_Name__c = advisor.id;
        timeSlot5.Day__c = 'Saturday';
        timeSlot5.Start_Time__c = '05:00';
        timeSlot5.End_Time__c = '17:00';
        listTime3.add(timeSlot5);
        
        //Sunday
        timeSlot5.clear();
        timeSlot5.Advisor_Name__c = advisor.id;
        timeSlot5.Day__c = 'Sunday';
        timeSlot5.Start_Time__c = '05:00';
        timeSlot5.End_Time__c = '17:00';
        listTime3.add(timeSlot5);

        listTime3 = testRecordClass.createTimeSlotRecords(listTime3); 
        
        strConvertedDate =strDate+' '+'10:00 AM';
        Request.cdatetime=strConvertedDate;
        Request.BrandID= '1010'; 
        Request.NumberofUsers= 25;
        Request.CustomerId= '1111';
        Request.firstName = 'test1';
        Request.lastname = 'test2';
        Request.Email = 'test@test.com';
        Request.Notes = 'This is a test event';    
        Request.appointmentLength = '60';
        Request.premiumSupport = false;  
        Request.preferredLanguage='en_US';
    	Request.timeZone = 'America/LosAngeles';    
        Response = SchedulerWebService.scheduleEvent(Request);
        //Response = SchedulerWebService.resheduleEvents(Request);         
        
        system.debug('#### sucess_code - '+Response.sucess_code);
        system.debug('#### error_code - '+Response.error_code); 

        //Testing for null date-time
        Request.cdatetime = null;
        Request.BrandID= '1010'; 
        Request.NumberofUsers= 20;
        Request.CustomerId= '1111';
        Request.firstName = 'test1';
        Request.lastname = 'test2';
        Request.Email = 'test@test.com';
        Request.Notes = 'This is a test event';
        Request.appointmentLength = '60';
        Request.premiumSupport = false;
        Request.preferredLanguage='en_US';
    	Request.timeZone = 'America/LosAngeles';
        Response = SchedulerWebService.scheduleEvent(Request);
        //Response = SchedulerWebService.resheduleEvents(Request);         
        
        system.debug('#### sucess_code - '+Response.sucess_code);
        system.debug('#### error_code - '+Response.error_code); 

        //Testing for null brand id
        Request.cdatetime = strConvertedDate ;
        Request.BrandID= null; 
        Request.NumberofUsers= 20;
        Request.CustomerId= '1111';
        Request.firstName = 'test1';
        Request.lastname = 'test2';
        Request.Email = 'test@test.com';
        Request.Notes = 'This is a test event';
        Request.appointmentLength = '60';
        Request.premiumSupport = false;
        Request.preferredLanguage='en_US';
    	Request.timeZone = 'America/LosAngeles';
        Response = SchedulerWebService.scheduleEvent(Request); 
        //Response = SchedulerWebService.resheduleEvents(Request);  
        
        system.debug('#### sucess_code - '+Response.sucess_code);
        system.debug('#### error_code - '+Response.error_code);       

        // Testing for null first name  
        Request.cdatetime = strConvertedDate;
        Request.BrandID= '1010'; 
        Request.NumberofUsers= 20;
        Request.CustomerId= '1111';
        Request.firstName = null;
        Request.lastname = 'test2';
        Request.Email = 'test@test.com';
        Request.Notes = 'This is a test event';
        Request.appointmentLength = '60';
        Request.premiumSupport = false;
        Request.preferredLanguage='en_US';
    	Request.timeZone = 'America/LosAngeles';
        Response = SchedulerWebService.scheduleEvent(Request);
        //Response = SchedulerWebService.resheduleEvents(Request);        
        
        system.debug('#### sucess_code - '+Response.sucess_code);
        system.debug('#### error_code - '+Response.error_code);  

        // Testing for null last name
        Request.cdatetime = strConvertedDate ;
        Request.BrandID= '1010'; 
        Request.NumberofUsers= 20;
        Request.CustomerId= '1111';
        Request.firstName = 'test1';
        Request.lastname = null;
        Request.Email = 'test@test.com';
        Request.Notes = 'This is a test event';
        Request.appointmentLength = '60';
        Request.premiumSupport = false;
        Request.preferredLanguage='en_US';
    	Request.timeZone = 'America/LosAngeles';
        Response = SchedulerWebService.scheduleEvent(Request);
       // Response = SchedulerWebService.resheduleEvents(Request);         
        
        system.debug('#### sucess_code - '+Response.sucess_code);
        system.debug('#### error_code - '+Response.error_code); 

        //Testing for null email
        Request.cdatetime =strConvertedDate ;
        Request.BrandID= '1010'; 
        Request.NumberofUsers= 20;
        Request.CustomerId= '1111';
        Request.firstName = 'test1';
        Request.lastname = 'test2';
        Request.Email = null;
        Request.Notes = 'This is a test event';
        Request.appointmentLength = '60';
        Request.premiumSupport = false;
        Request.preferredLanguage='en_US';
    	Request.timeZone = 'America/LosAngeles';
        Response = SchedulerWebService.scheduleEvent(Request);
        //Response = SchedulerWebService.resheduleEvents(Request);   
        
        system.debug('#### sucess_code - '+Response.sucess_code);
        system.debug('#### error_code - '+Response.error_code);       

        //Testing for null notes
        Request.cdatetime = strConvertedDate ;
        Request.BrandID= '1010'; 
        Request.NumberofUsers= 20;
        Request.CustomerId= '1111';
        Request.firstName = 'test1';
        Request.lastname = 'test2';
        Request.Email = 'test@test.com';
        Request.Notes = null;
        Request.appointmentLength = '60';
        Request.premiumSupport = false;
        Request.preferredLanguage='en_US';
    	Request.timeZone = 'America/LosAngeles';
        Response = SchedulerWebService.scheduleEvent(Request); 
        //Response = SchedulerWebService.resheduleEvents(Request);     
        
        system.debug('#### sucess_code - '+Response.sucess_code);
        system.debug('#### error_code - '+Response.error_code);    

        //Testing if number of users is null
        Request.cdatetime=strConvertedDate ;
        Request.BrandID= '1010'; 
        Request.NumberofUsers= null;
        Request.CustomerId= '1111';
        Request.firstName = 'test1';
        Request.lastname = 'test2';
        Request.Email = 'test@test.com';
        Request.Notes = 'This is a test event';      
        Request.appointmentLength = '60';
        Request.premiumSupport = false;  
        Request.preferredLanguage='en_US';
    	Request.timeZone = 'America/LosAngeles';  
        Response = SchedulerWebService.scheduleEvent(Request);
        //Response = SchedulerWebService.resheduleEvents(Request);    
        
        system.debug('#### sucess_code - '+Response.sucess_code);
        system.debug('#### error_code - '+Response.error_code);      

        //Testing if the customer id is null
        Request.cdatetime=strConvertedDate ;
        Request.BrandID= '1010'; 
        Request.NumberofUsers= 15;
        Request.CustomerId= null;
        Request.firstName = 'test1';
        Request.lastname = 'test2';
        Request.Email = 'test@test.com';
        Request.Notes = 'This is a test event';     
        Request.appointmentLength = '60';
        Request.premiumSupport = false;   
        Request.preferredLanguage='en_US';
    	Request.timeZone = 'America/LosAngeles';  
        Response = SchedulerWebService.scheduleEvent(Request);
       // Response = SchedulerWebService.resheduleEvents(Request);   
        
        system.debug('#### sucess_code - '+Response.sucess_code);
        system.debug('#### error_code - '+Response.error_code);       

        // Testing if appointment length is null
        Request.cdatetime=strConvertedDate ;
        Request.BrandID= '1010'; 
        Request.NumberofUsers= 20;
        Request.CustomerId= '1111';
        Request.firstName = 'test1';
        Request.lastname = 'test2';
        Request.Email = 'test@test.com';
        Request.Notes = 'This is a test event';  
        Request.appointmentLength = null;
        Request.premiumSupport = false; 
        Request.preferredLanguage='en_US';
    	Request.timeZone = 'America/LosAngeles';       
        Response = SchedulerWebService.scheduleEvent(Request);
      //  Response = SchedulerWebService.resheduleEvents(Request);     
        
        system.debug('#### sucess_code - '+Response.sucess_code);
        system.debug('#### error_code - '+Response.error_code);     
        
        // Testing if Brand Id doesn't exists
        Request.cdatetime=strConvertedDate ;
        Request.BrandID= '1011'; 
        Request.NumberofUsers= 20;
        Request.CustomerId= '1111';
        Request.firstName = 'test1';
        Request.lastname = 'test2';
        Request.Email = 'test@test.com';
        Request.Notes = 'This is a test event';  
        Request.appointmentLength = '60';
        Request.premiumSupport = false;      
        Request.preferredLanguage='en_US';
    	Request.timeZone = 'America/LosAngeles';  
        Response = SchedulerWebService.scheduleEvent(Request);
       // Response = SchedulerWebService.resheduleEvents(Request);         
        
        system.debug('#### sucess_code - '+Response.sucess_code);
        system.debug('#### error_code - '+Response.error_code); 
        
        Test.stoptest();                            
    }
    
    
	/******************************************************************************
	* @Description : Method to test Create event and save the above parameters on *
	*				 that event; remove used resource from relevant               *
	*				 resource pool-Email event Contact a Confirmation.            *
	* @Params      : void                                                         *
	* @Return      : void                                                         * 
	******************************************************************************/
    static testMethod void scheduleEventGreaterEqual(){
    	
    	SchedulerWebService.scheduleEventRequest Request = new SchedulerWebService.scheduleEventRequest();
        SchedulerWebService.scheduleEventResponse Response = new SchedulerWebService.scheduleEventResponse();
        string strConvertedDate ;
        string strDate;
        Datetime GMTDate = DateTime.Now();
        strDate = GMTDate.format('MM/dd/yyyy','English (United States)');
	
		SchedulerWebServiceTest swt =  new SchedulerWebServiceTest();
		
        EmailTemplate eTemp = new EmailTemplate();
        eTemp.Name = 'Test';
        eTemp.folderId = [SELECT AccessType ,Id , Name, NamespacePrefix,Type FROM Folder WHERE Name=:'Support OA Emails' LIMIT 1].id;
        eTemp.Subject = '#datetime# - Test Template';
        eTemp.Encoding = 'UTF-8';
        eTemp.TemplateType = 'Custom';
        eTemp.DeveloperName = 'Test';
        eTemp.IsActive = true;
        eTemp.HtmlValue = '#datetime#,#supportnumber#,#eventid#';
        eTemp.Body = '#datetime#,#supportnumber#,#eventid#';
        System.runAs(new User(Id = Userinfo.getUserId())) {
            insert eTemp;
        }


		// Instantiating class to setup test records.
		Test_Utils testRecordClass = new Test_Utils();
        
        /* Setting up test records */
        // Creating test User.
        User testUser1 = new User();                   
		testUser1 = testRecordClass.createUserRecord(new List<User>{new User()})[0];
        // Creating Brand
        schedulerConfiguration__c createBrand = new schedulerConfiguration__c();
        createBrand.Brand_Id__c = '1010';
        createBrand.Confirmation_Email_Template_Name__c = eTemp.id;
        createBrand = testRecordClass.createSchedulerConfigurationRecords(new List<schedulerConfiguration__c>{createBrand})[0];
    	
    	// Resource Pool for criteria '>=' 
        Resource_Pool__c resPool = new Resource_Pool__c();
        resPool.Brand_Name__c = createBrand.Id;
        resPool.Dispatch_Admin__c = testUser1.Id;
        resPool.Criteria__c = '>=';
        resPool = testRecordClass.createResourcePoolRecords(new List<Resource_Pool__c>{resPool})[0];

        //Creating Advisor
        Advisor__c advisor = new Advisor__c();
        advisor.Advisor_Name__c = testUser1.id;
        advisor.Resource_Pool__c = resPool.id;
        advisor.Preferred_Language__c = 'en_US';
        insert advisor; 
        
        //Creating Time Slots   
        List<Time__c> listTime2 = new List<Time__c>();
        //Monday    
        Time__c timeSlot1 = new Time__c();
        timeSlot1.Advisor_Name__c = advisor.id;
        timeSlot1.Day__c = 'Monday';
        timeSlot1.Start_Time__c = '05:00';
        timeSlot1.End_Time__c = '17:00';
        listTime2.add(timeSlot1);
          
        //Tuesday
        Time__c timeSlot2 = new Time__c();
        timeSlot2.Advisor_Name__c = advisor.id;
        timeSlot2.Day__c = 'Tuesday';
        timeSlot2.Start_Time__c = '05:00';
        timeSlot2.End_Time__c = '17:00';
        listTime2.add(timeSlot2);
        
        //Wednesday
        Time__c timeSlot3 = new Time__c();
        timeSlot3.Advisor_Name__c = advisor.id;
        timeSlot3.Day__c = 'Wednesday';
        timeSlot3.Start_Time__c = '05:00';
        timeSlot3.End_Time__c = '17:00';
        listTime2.add(timeSlot3);
         
        //Thursday
        Time__c timeSlot4 = new Time__c();
        timeSlot4.Advisor_Name__c = advisor.id;
        timeSlot4.Day__c = 'Thursday';
        timeSlot4.Start_Time__c = '05:00';
        timeSlot4.End_Time__c = '17:00';
        listTime2.add(timeSlot4);
        
        //Friday
        Time__c timeSlot5 = new Time__c();
        timeSlot5.Advisor_Name__c = advisor.id;
        timeSlot5.Day__c = 'Friday';
        timeSlot5.Start_Time__c = '05:00';
        timeSlot5.End_Time__c = '17:00';
        listTime2.add(timeSlot5);
        
        //Saturday
        Time__c timeSlot6 = new Time__c();
        timeSlot6.Advisor_Name__c = advisor.id;
        timeSlot6.Day__c = 'Saturday';
        timeSlot6.Start_Time__c = '05:00';
        timeSlot6.End_Time__c = '17:00';
        listTime2.add(timeSlot6);
        
        //Sunday
        Time__c timeSlot7 = new Time__c();
        timeSlot7.Advisor_Name__c = advisor.id;
        timeSlot7.Day__c = 'Sunday';
        timeSlot7.Start_Time__c = '05:00';
        timeSlot7.End_Time__c = '17:00';
        listTime2.add(timeSlot7);
        
        listTime2 = testRecordClass.createTimeSlotRecords(listTime2);   
        
        Test.startTest();
        
	        strConvertedDate =strDate+' '+'09:00 AM';
	        Request.cdatetime=strConvertedDate ;
	        Request.BrandID= '1010'; 
	        Request.NumberofUsers= 20;
	        Request.CustomerId= '1111';
	        Request.firstName = 'test1';
	        Request.lastname = 'test2';
	        Request.Email = 'test@test.com';
	        Request.Notes = 'This is a test event';  
	        Request.appointmentLength = '60';
	        Request.premiumSupport = false;  
	        Request.preferredLanguage='en_US';
    		Request.timeZone = 'America/LosAngeles';      
	        Response = SchedulerWebService.scheduleEvent(Request); 
	        
	        system.debug('#### sucess_code - '+Response.sucess_code);
	        system.debug('#### error_code - '+Response.error_code);
        
        Test.stopTest();
    }
    
    /******************************************************************************
	* @Description : Method to test Create event and save the above parameters on *
	*				 that event; remove used resource from relevant               *
	*				 resource pool-Email event Contact a Confirmation.            *
	* @Params      : void                                                         *
	* @Return      : void                                                         * 
	******************************************************************************/
    static testMethod void scheduleEventLessEquals(){
    	
    	SchedulerWebService.scheduleEventRequest Request = new SchedulerWebService.scheduleEventRequest();
        SchedulerWebService.scheduleEventResponse Response = new SchedulerWebService.scheduleEventResponse();
        string strConvertedDate ;
        string strDate;
        Datetime GMTDate = DateTime.Now();
        strDate = GMTDate.format('MM/dd/yyyy','English (United States)');
	
		SchedulerWebServiceTest swt =  new SchedulerWebServiceTest();
		
        EmailTemplate eTemp = new EmailTemplate();
        eTemp.Name = 'Test';
        eTemp.folderId = [SELECT AccessType ,Id , Name, NamespacePrefix,Type FROM Folder WHERE Name=:'Support OA Emails' LIMIT 1].id;
        eTemp.Subject = '#datetime# - Test Template';
        eTemp.Encoding = 'UTF-8';
        eTemp.TemplateType = 'Custom';
        eTemp.DeveloperName = 'Test';
        eTemp.IsActive = true;
        eTemp.HtmlValue = '#datetime#,#supportnumber#,#eventid#';
        eTemp.Body = '#datetime#,#supportnumber#,#eventid#';
        System.runAs(new User(Id = Userinfo.getUserId())) {
            insert eTemp;
        }


		// Instantiating class to setup test records.
		Test_Utils testRecordClass = new Test_Utils();
        
        /* Setting up test records */
        // Creating test User.
        User testUser1 = new User();                   
		testUser1 = testRecordClass.createUserRecord(new List<User>{new User()})[0];
        // Creating Brand
        schedulerConfiguration__c createBrand = new schedulerConfiguration__c();
        createBrand.Brand_Id__c = '1010';
        createBrand.Confirmation_Email_Template_Name__c = eTemp.id;
        createBrand = testRecordClass.createSchedulerConfigurationRecords(new List<schedulerConfiguration__c>{createBrand})[0];
    	
		//Resource Pool for criteria '<=' 
        Resource_Pool__c resPool = new Resource_Pool__c();
        resPool.Brand_Name__c = createBrand.Id;
        resPool.Dispatch_Admin__c = testUser1.Id;
        resPool.Criteria__c = '<=';
        resPool = testRecordClass.createResourcePoolRecords(new List<Resource_Pool__c>{resPool})[0];

        //Creating Advisor
        Advisor__c advisor = new Advisor__c();
        advisor.Advisor_Name__c = testUser1.id;
        advisor.Resource_Pool__c = resPool.id;
        advisor.Preferred_Language__c = 'en_US';
        insert advisor;
        
        //Creating Time Slots   
        List<Time__c> listTime4 = new List<Time__c>();
        //Monday    
        Time__c timeSlot1 = new Time__c();
        timeSlot1.Advisor_Name__c = advisor.id;
        timeSlot1.Day__c = 'Monday';
        timeSlot1.Start_Time__c = '05:00';
        timeSlot1.End_Time__c = '17:00';
        listTime4.add(timeSlot1);
          
        //Tuesday
        Time__c timeSlot2 = new Time__c();
        timeSlot2.Advisor_Name__c = advisor.id;
        timeSlot2.Day__c = 'Tuesday';
        timeSlot2.Start_Time__c = '05:00';
        timeSlot2.End_Time__c = '17:00';
        listTime4.add(timeSlot2);
        
        //Wednesday
        Time__c timeSlot3 = new Time__c();
        timeSlot3.Advisor_Name__c = advisor.id;
        timeSlot3.Day__c = 'Wednesday';
        timeSlot3.Start_Time__c = '05:00';
        timeSlot3.End_Time__c = '17:00';
        listTime4.add(timeSlot3);
         
        //Thursday
        Time__c timeSlot4 = new Time__c();
        timeSlot4.Advisor_Name__c = advisor.id;
        timeSlot4.Day__c = 'Thursday';
        timeSlot4.Start_Time__c = '05:00';
        timeSlot4.End_Time__c = '17:00';
        listTime4.add(timeSlot4);
        
        //Friday
        Time__c timeSlot5 = new Time__c();
        timeSlot5.Advisor_Name__c = advisor.id;
        timeSlot5.Day__c = 'Friday';
        timeSlot5.Start_Time__c = '05:00';
        timeSlot5.End_Time__c = '17:00';
        listTime4.add(timeSlot5);
        
        //Saturday
        Time__c timeSlot6 = new Time__c();
        timeSlot6.Advisor_Name__c = advisor.id;
        timeSlot6.Day__c = 'Saturday';
        timeSlot6.Start_Time__c = '05:00';
        timeSlot6.End_Time__c = '17:00';
        listTime4.add(timeSlot6);
        
        //Sunday
        Time__c timeSlot7 = new Time__c();
        timeSlot7.Advisor_Name__c = advisor.id;
        timeSlot7.Day__c = 'Sunday';
        timeSlot7.Start_Time__c = '05:00';
        timeSlot7.End_Time__c = '17:00';
        listTime4.add(timeSlot7);
        
        listTime4 = testRecordClass.createTimeSlotRecords(listTime4); 
        
		Test.startTest();	     
	        strConvertedDate =strDate+' '+'01:00 PM';
	        Request.cdatetime=strConvertedDate ;
	        Request.BrandID= '1010'; 
	        Request.NumberofUsers= 20;
	        Request.CustomerId= '1111';
	        Request.firstName = 'test1';
	        Request.lastname = 'test2';
	        Request.Email = 'test@test.com';
	        Request.Notes = 'This is a test event';   
	        Request.appointmentLength = '60';
	        Request.premiumSupport = false;   
	        Request.preferredLanguage='en_US';
    		Request.timeZone = 'America/LosAngeles';    
	        Response = SchedulerWebService.scheduleEvent(Request);       
	        
	        system.debug('#### sucess_code - '+Response.sucess_code);
	        system.debug('#### error_code - '+Response.error_code);  
    	Test.stopTest();
    }
    
 	/******************************************************************************
	* @Description : Method to test Create event and save the above parameters on *
	*				 that event; remove used resource from relevant               *
	*				 resource pool-Email event Contact a Confirmation.            *
	* @Params      : void                                                         *
	* @Return      : void                                                         * 
	******************************************************************************/
    static testMethod void scheduleEventLess(){   
    
    	SchedulerWebService.scheduleEventRequest Request = new SchedulerWebService.scheduleEventRequest();
        SchedulerWebService.scheduleEventResponse Response = new SchedulerWebService.scheduleEventResponse();
        string strConvertedDate ;
        string strDate;
        Datetime GMTDate = DateTime.Now();
        strDate = GMTDate.format('MM/dd/yyyy','English (United States)');
	
		SchedulerWebServiceTest swt =  new SchedulerWebServiceTest();
		
        EmailTemplate eTemp = new EmailTemplate();
        eTemp.Name = 'Test';
        eTemp.folderId = [SELECT AccessType ,Id , Name, NamespacePrefix,Type FROM Folder WHERE Name=:'Support OA Emails' LIMIT 1].id;
        eTemp.Subject = '#datetime# - Test Template';
        eTemp.Encoding = 'UTF-8';
        eTemp.TemplateType = 'Custom';
        eTemp.DeveloperName = 'Test';
        eTemp.IsActive = true;
        eTemp.HtmlValue = '#datetime#,#supportnumber#,#eventid#';
        eTemp.Body = '#datetime#,#supportnumber#,#eventid#';
        System.runAs(new User(Id = Userinfo.getUserId())) {
            insert eTemp;
        }


		// Instantiating class to setup test records.
		Test_Utils testRecordClass = new Test_Utils();
        
        /* Setting up test records */
        // Creating test User.
        User testUser1 = new User();                   
		testUser1 = testRecordClass.createUserRecord(new List<User>{new User()})[0];
        // Creating Brand
        schedulerConfiguration__c createBrand = new schedulerConfiguration__c();
        createBrand.Brand_Id__c = '1010';
        createBrand.Confirmation_Email_Template_Name__c = eTemp.id;
        createBrand = testRecordClass.createSchedulerConfigurationRecords(new List<schedulerConfiguration__c>{createBrand})[0];
        
    	//Resource Pool for criteria '<' 
        Resource_Pool__c resPool = new Resource_Pool__c();
        resPool.Brand_Name__c = createBrand.Id;
        resPool.Dispatch_Admin__c = testUser1.Id;
        resPool.Criteria__c = '<';
        resPool = testRecordClass.createResourcePoolRecords(new List<Resource_Pool__c>{resPool})[0];

        //Creating Advisor
        Advisor__c advisor =  new Advisor__c();
        advisor.Advisor_Name__c = testUser1.id;
        advisor.Resource_Pool__c = resPool.id;
        advisor.Preferred_Language__c = 'en_US';
        insert advisor;
        
        //Creating Time Slots   
        List<Time__c> listTime5 = new List<Time__c>();
        //Monday    
        Time__c timeSlot1 = new Time__c();
        timeSlot1.Advisor_Name__c = advisor.id;
        timeSlot1.Day__c = 'Monday';
        timeSlot1.Start_Time__c = '05:00';
        timeSlot1.End_Time__c = '17:00';
        listTime5.add(timeSlot1);
          
        //Tuesday
        Time__c timeSlot2 = new Time__c();
        timeSlot2.Advisor_Name__c = advisor.id;
        timeSlot2.Day__c = 'Tuesday';
        timeSlot2.Start_Time__c = '05:00';
        timeSlot2.End_Time__c = '17:00';
        listTime5.add(timeSlot2);
        
        //Wednesday
        Time__c timeSlot3 = new Time__c();
        timeSlot3.Advisor_Name__c = advisor.id;
        timeSlot3.Day__c = 'Wednesday';
        timeSlot3.Start_Time__c = '05:00';
        timeSlot3.End_Time__c = '17:00';
        listTime5.add(timeSlot3);
        
        //Thursday
        Time__c timeSlot4 = new Time__c();
        timeSlot4.Advisor_Name__c = advisor.id;
        timeSlot4.Day__c = 'Thursday';
        timeSlot4.Start_Time__c = '05:00';
        timeSlot4.End_Time__c = '17:00';
        listTime5.add(timeSlot4);
        
        //Friday
        Time__c timeSlot5 = new Time__c();
        timeSlot5.Advisor_Name__c = advisor.id;
        timeSlot5.Day__c = 'Friday';
        timeSlot5.Start_Time__c = '05:00';
        timeSlot5.End_Time__c = '17:00';
        listTime5.add(timeSlot5);
        
        //Saturday
        Time__c timeSlot6 = new Time__c();
        timeSlot6.Advisor_Name__c = advisor.id;
        timeSlot6.Day__c = 'Saturday';
        timeSlot6.Start_Time__c = '05:00';
        timeSlot6.End_Time__c = '17:00';
        listTime5.add(timeSlot6);
        
        //Sunday
        Time__c timeSlot7 = new Time__c();
        timeSlot7.Advisor_Name__c = advisor.id;
        timeSlot7.Day__c = 'Sunday';
        timeSlot7.Start_Time__c = '05:00';
        timeSlot7.End_Time__c = '17:00';
        listTime5.add(timeSlot7);
        
        listTime5 = testRecordClass.createTimeSlotRecords(listTime5);
        
        Test.startTest();
	        // Testing for positive case
	        strConvertedDate =strDate+' '+'05:00 AM';
	        Request.cdatetime=strConvertedDate ;
	        Request.BrandID= '1010'; 
	        Request.NumberofUsers= 15;
	        Request.CustomerId= '1111';
	        Request.firstName = 'test1';
	        Request.lastname = 'test2';
	        Request.Email = 'test@test.com';
	        Request.Notes = 'This is a test event'; 
	        Request.appointmentLength = '60';
	        Request.premiumSupport = false;    
	        Request.preferredLanguage='en_US';
    		Request.timeZone = 'America/LosAngeles';     
	        Response = SchedulerWebService.scheduleEvent(Request);    
	        
	        system.debug('#### sucess_code - '+Response.sucess_code);
	        system.debug('#### error_code - '+Response.error_code); 
        
        Test.stopTest();
    }
    
    /******************************************************************************
	* @Description : Set event as cancelled.                                      *
	*                Add resource back in to relevant resource pool               *
	* @Params      : void                                                         *
	* @Return      : void                                                         * 
	******************************************************************************/
    static testMethod void test_CancelEvents(){
        SchedulerWebService.cancelEventsRequest Request = new SchedulerWebService.cancelEventsRequest();
        SchedulerWebService.cancelEventsResponse Response = new SchedulerWebService.cancelEventsResponse();
        
        EmailTemplate eTemp = new EmailTemplate();
        eTemp.Name = 'Test';
        eTemp.folderId = [SELECT AccessType ,Id , Name, NamespacePrefix,  Type FROM Folder WHERE Name=:'Support OA Emails' LIMIT 1].id;
        eTemp.Subject = '#datetime# - Test Template';
        eTemp.Encoding = 'UTF-8';
        eTemp.TemplateType = 'Custom';
        eTemp.DeveloperName = 'Test';
        eTemp.IsActive = true;
        eTemp.HtmlValue = '#datetime#,#supportnumber#,#eventid#';
        eTemp.Body = '#datetime#,#supportnumber#,#eventid#';
        eTemp.IsActive = true;
        System.runAs(new User(Id = Userinfo.getUserId())) {
            insert eTemp;
        }
        
        /* Setting up test records */
        // Instantiating class to setup test records.
		Test_Utils testRecordClass = new Test_Utils();
		
        // Creating test User.
        User testUser1 = new User();                   
		testUser1 = testRecordClass.createUserRecord(new List<User>{new User()})[0];
        // Creating Brand
        schedulerConfiguration__c createBrand = new schedulerConfiguration__c();
        createBrand.Brand_Id__c='2222';
        createBrand.Cancellation_Email_Template_Customer__c= eTemp.id;
        createBrand.Cancellation_Email_Template_Internal__c= eTemp.id;
        createBrand.Confirmation_Email_Template_Name__c= eTemp.id; 
        createBrand.Reminder_E_mail_Template_Name__c= eTemp.id;
        createBrand.Rescheduling_Email_Template_Customer__c= eTemp.id;
        createBrand.Rescheduling_Email_Template_Internal__c= eTemp.id; 
        createBrand = testRecordClass.createSchedulerConfigurationRecords(new List<schedulerConfiguration__c>{createBrand})[0];
        // Creating Resource
        Resource_Pool__c resPool = new Resource_Pool__c();
        resPool.Brand_Name__c = createBrand.Id;
        resPool.Dispatch_Admin__c = testUser1.Id;
        resPool.No_of_User_DLs__c = 5;
        resPool = testRecordClass.createResourcePoolRecords(new List<Resource_Pool__c>{resPool})[0];

		//Creating Advisor
        User testUser2 = new User();      
        testUser2 = testRecordClass.createUserRecord(new List<User>{new User()})[0];             
        
        Advisor__c advisor = new Advisor__c();
        advisor.Advisor_Name__c = testUser2.Id;
        advisor.Resource_Pool__c = resPool.Id;
        advisor.Preferred_Language__c = 'en_US';
        insert advisor; 
        
        SchedulerWebServiceTest swt =  new SchedulerWebServiceTest();
        
        //Calling method to create new event.
        Event event = new Event();
        event = createEventRecord(createBrand.Brand_Id__c, resPool.Id);
        
        String eventId = event.Id;

		Test.startTest();
        //Testing positive case
        Request.EventId = event.Id;
        Request.premiumSupport =  false;
        Response = SchedulerWebService.cancelEvents(Request);   

        //Testing when event id is null
        Request.EventId = null;
        Response = SchedulerWebService.cancelEvents(Request);         

        //Trying to cancel the event again
        Request.EventId = event.id;
        Response = SchedulerWebService.cancelEvents(Request);   
        
        // Trying to cancel the event, that doesn't exist anymore.
        delete event;
        Request.EventId = eventId;
        Response = SchedulerWebService.cancelEvents(Request); 
        
		Test.stopTest();
    }

    /******************************************************************************
	* @Description : Cancel existing event.                                       *
	*                Create new event and save parameters to that event.          *
	*                Add resource back in to relevant resource pool.              *
	*                Remove used resource from relevant resource pool.            *
	* @Params      : void                                                         *
	* @Return      : void                                                         * 
	******************************************************************************/
    static testMethod void test_resheduleEvents(){
        SchedulerWebService.resheduleEventsRequest Request = new SchedulerWebService.resheduleEventsRequest();
        SchedulerWebService.resheduleEventsResponse Response = new SchedulerWebService.resheduleEventsResponse();
        Test.startTest();
        /* Setting up test records */
        // Instantiating class to setup test records.
		Test_Utils testRecordClass = new Test_Utils();
		
        // Creating test User.
        User testUser1 = new User();                   
		testUser1 = testRecordClass.createUserRecord(new List<User>{new User()})[0];
        
        SchedulerWebServiceTest swt =  new SchedulerWebServiceTest();
        
        // creating email template
        EmailTemplate eTemp = new EmailTemplate();
        eTemp.Name = 'Test';
        eTemp.folderId = [SELECT AccessType ,Id , Name, NamespacePrefix,  Type FROM Folder WHERE Name=:'Support OA Emails' LIMIT 1].id;
        eTemp.Subject = '#datetime# - Test Template';
        eTemp.Encoding = 'UTF-8';
        eTemp.TemplateType = 'Custom';
        eTemp.DeveloperName = 'Test';
        eTemp.IsActive = true;
        eTemp.HtmlValue = '#datetime#,#supportnumber#,#eventid#';
        eTemp.Body = '#datetime#,#supportnumber#,#eventid#';
        eTemp.IsActive = true;
        System.runAs(new User(Id = Userinfo.getUserId())) {
            insert eTemp;
        }
        
        // Creating Brand
        schedulerConfiguration__c createBrand = new schedulerConfiguration__c();
        createBrand.Brand_Id__c = '2222';
        createBrand.Name = 'TestBrand';
        createBrand.Cancellation_Email_Template_Customer__c = eTemp.id;
        createBrand.Cancellation_Email_Template_Internal__c = eTemp.id;
        createBrand.Confirmation_Email_Template_Name__c = eTemp.id; 
        createBrand.Reminder_E_mail_Template_Name__c = eTemp.id;
        createBrand.Rescheduling_Email_Template_Customer__c = eTemp.id;
        createBrand.Rescheduling_Email_Template_Internal__c = eTemp.id; 
        createBrand = testRecordClass.createSchedulerConfigurationRecords(new List<schedulerConfiguration__c>{createBrand})[0];
        
        // Creating Account Record.
        TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT();
			testRecordClass.createAccountRecord(new List<Account>{new Account(RC_Brand__c = 'TestBrand')});
		TriggerHandler.RESET_VARIABLES();
		
		// Creating Resource
        Resource_Pool__c resPool = new Resource_Pool__c();
        resPool.Brand_Name__c = createBrand.Id;
        resPool.Dispatch_Admin__c = testUser1.Id;
        resPool.No_of_User_DLs__c = 20;
        resPool = testRecordClass.createResourcePoolRecords(new List<Resource_Pool__c>{resPool})[0];

        //Creating Advisor
        User testUser2 = new User();      
        testUser2 = testRecordClass.createUserRecord(new List<User>{new User()})[0];             
        
        Advisor__c advisor = new Advisor__c();
        advisor.Advisor_Name__c = testUser2.Id;
        advisor.Resource_Pool__c = resPool.Id;
        advisor.Preferred_Language__c = 'en_US';
        insert advisor; 
        
        //Creating Time Slots   
        List<Time__c> listTime1 = new List<Time__c>();
        //Monday    
        Time__c timeSlot1 = new Time__c();
        timeSlot1.Advisor_Name__c = advisor.id;
        listTime1.add(timeSlot1);
          
        //Tuesday
        Time__c timeSlot2 = new Time__c();
        timeSlot2.Advisor_Name__c = advisor.id;
        listTime1.add(timeSlot2);
        
        //Wednesday
        Time__c timeSlot3 = new Time__c();
        timeSlot3.Advisor_Name__c = advisor.id;
        listTime1.add(timeSlot3);
         
        //Thursday
        Time__c timeSlot4 = new Time__c();
        timeSlot4.Advisor_Name__c = advisor.id;
        listTime1.add(timeSlot4);
        
        //Friday
        Time__c timeSlot5 = new Time__c();
        timeSlot5.Advisor_Name__c = advisor.id;
        listTime1.add(timeSlot5);
        
        //Saturday
        Time__c timeSlot6 = new Time__c();
        timeSlot6.Advisor_Name__c = advisor.id;
        listTime1.add(timeSlot6);
        
        //Sunday
        Time__c timeSlot7 = new Time__c();
        timeSlot7.Advisor_Name__c = advisor.id;
        listTime1.add(timeSlot7);
        
        listTime1 = testRecordClass.createTimeSlotRecords(listTime1);

        //Calling method to create new event.
        Event event = new Event();
        event = createEventRecord(createBrand.Brand_Id__c, resPool.Id);
        
        //Generating date format
	    String strConvertedDate ;
	    String strDate;
	    Datetime GMTDate = DateTime.Now();
	    strDate = GMTDate.format('MM/dd/yyyy','English (United States)');
	    strConvertedDate = strDate +' '+'08:00 AM';
	
		//Testing for positive case
	    Request.EventId = event.Id;
	    Request.cdatetime = strConvertedDate ;
	    Request.BrandID = createBrand.Brand_Id__c; 
	    Request.NumberofUsers = 20;
	    Request.CustomerId= '12345';
	    Request.firstName = 'test1';
	    Request.lastname = 'test2';
	    Request.Email = 'test@test.com';
	    Request.Notes = 'This is a test event';
	    Request.appointmentLength = '60';
	    Request.premiumSupport = false;
	    Request.preferredLanguage='en_US';
    	Request.timeZone = 'America/LosAngeles';
	    Response = SchedulerWebService.resheduleEvents(Request);
	    
        Test.stopTest();
    } 
	
	static testMethod void test_rescheduleEventNull(){
		
		SchedulerWebService.resheduleEventsRequest Request = new SchedulerWebService.resheduleEventsRequest();
        SchedulerWebService.resheduleEventsResponse Response = new SchedulerWebService.resheduleEventsResponse();
        
        /* Setting up test records */
        // Instantiating class to setup test records.
		Test_Utils testRecordClass = new Test_Utils();
		
        // Creating test User.
        User testUser1 = new User();                   
		testUser1 = testRecordClass.createUserRecord(new List<User>{new User()})[0];
        
        SchedulerWebServiceTest swt =  new SchedulerWebServiceTest();
        
        // creating email template
        EmailTemplate eTemp = new EmailTemplate();
        eTemp.Name = 'Test';
        eTemp.folderId = [SELECT AccessType ,Id , Name, NamespacePrefix,  Type FROM Folder WHERE Name=:'Support OA Emails' LIMIT 1].id;
        eTemp.Subject = '#datetime# - Test Template';
        eTemp.Encoding = 'UTF-8';
        eTemp.TemplateType = 'Custom';
        eTemp.DeveloperName = 'Test';
        eTemp.IsActive = true;
        eTemp.HtmlValue = '#datetime#,#supportnumber#,#eventid#';
        eTemp.Body = '#datetime#,#supportnumber#,#eventid#';
        eTemp.IsActive = true;
        System.runAs(new User(Id = Userinfo.getUserId())) {
            insert eTemp;
        }
        
        // Creating Brand
        schedulerConfiguration__c createBrand = new schedulerConfiguration__c();
        createBrand.Brand_Id__c = '2222';
        createBrand.Name = 'TestBrand';
        createBrand.Cancellation_Email_Template_Customer__c = eTemp.id;
        createBrand.Cancellation_Email_Template_Internal__c = eTemp.id;
        createBrand.Confirmation_Email_Template_Name__c = eTemp.id; 
        createBrand.Reminder_E_mail_Template_Name__c = eTemp.id;
        createBrand.Rescheduling_Email_Template_Customer__c = eTemp.id;
        createBrand.Rescheduling_Email_Template_Internal__c = eTemp.id; 
        createBrand = testRecordClass.createSchedulerConfigurationRecords(new List<schedulerConfiguration__c>{createBrand})[0];
        
        // Creating Account Record.
        TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT();
			testRecordClass.createAccountRecord(new List<Account>{new Account(RC_Brand__c = 'TestBrand')});
		TriggerHandler.RESET_VARIABLES();
		
		// Creating Resource
        Resource_Pool__c resPool = new Resource_Pool__c();
        resPool.Brand_Name__c = createBrand.Id;
        resPool.Dispatch_Admin__c = testUser1.Id;
        resPool.No_of_User_DLs__c = 20;
        resPool = testRecordClass.createResourcePoolRecords(new List<Resource_Pool__c>{resPool})[0];

        //Creating Advisor
        User testUser2 = new User();      
        testUser2 = testRecordClass.createUserRecord(new List<User>{new User()})[0];             
        
        Advisor__c advisor = new Advisor__c();
        advisor.Advisor_Name__c = testUser2.Id;
        advisor.Resource_Pool__c = resPool.Id;
        advisor.Preferred_Language__c = 'en_US';
        insert advisor; 
        
        //Creating Time Slots   
        List<Time__c> listTime1 = new List<Time__c>();
        //Monday    
        Time__c timeSlot1 = new Time__c();
        timeSlot1.Advisor_Name__c = advisor.id;
        listTime1.add(timeSlot1);
          
        //Tuesday
        Time__c timeSlot2 = new Time__c();
        timeSlot2.Advisor_Name__c = advisor.id;
        listTime1.add(timeSlot2);
        
        //Wednesday
        Time__c timeSlot3 = new Time__c();
        timeSlot3.Advisor_Name__c = advisor.id;
        listTime1.add(timeSlot3);
         
        //Thursday
        Time__c timeSlot4 = new Time__c();
        timeSlot4.Advisor_Name__c = advisor.id;
        listTime1.add(timeSlot4);
        
        //Friday
        Time__c timeSlot5 = new Time__c();
        timeSlot5.Advisor_Name__c = advisor.id;
        listTime1.add(timeSlot5);
        
        //Saturday
        Time__c timeSlot6 = new Time__c();
        timeSlot6.Advisor_Name__c = advisor.id;
        listTime1.add(timeSlot6);
        
        //Sunday
        Time__c timeSlot7 = new Time__c();
        timeSlot7.Advisor_Name__c = advisor.id;
        listTime1.add(timeSlot7);
        
        listTime1 = testRecordClass.createTimeSlotRecords(listTime1);
        
		//Calling method to create new event.
        Event event = new Event();
        event = createEventRecord(createBrand.Brand_Id__c, resPool.Id);
        
        //Generating date format
	    String strConvertedDate ;
	    String strDate;
	    Datetime GMTDate = DateTime.Now();
	    strDate = GMTDate.format('MM/dd/yyyy','English (United States)');
	    strConvertedDate = strDate +' '+'08:00 AM';
	    
		//Testing for positive case
	    Request.EventId = event.Id;
	    Request.cdatetime = strConvertedDate ;
	    Request.BrandID = createBrand.Brand_Id__c; 
	    Request.NumberofUsers = 20;
	    Request.CustomerId= '12345';
	    Request.firstName = 'test1';
	    Request.lastname = 'test2';
	    Request.Email = 'test@test.com';
	    Request.Notes = 'This is a test event';
	    Request.appointmentLength = '60';
	    Request.premiumSupport = false;
	    Request.preferredLanguage='en_US';
    	Request.timeZone = 'America/LosAngeles';
	    Response = SchedulerWebService.resheduleEvents(Request);
	    
		//Testing for null date time
        Request.cdatetime = null;
        Response = SchedulerWebService.resheduleEvents(Request);
	
        //Testing for null event id
        Request.EventId = null;
        Response = SchedulerWebService.resheduleEvents(Request);
	
        //Testing for null brand id
        Request.BrandID= null ; 
        Response = SchedulerWebService.resheduleEvents(Request);
	
        //Testing for null number of users
        Request.NumberofUsers= null;
        Response = SchedulerWebService.resheduleEvents(Request);
	
        //Testing for null customer id
        Request.CustomerId= null ;
        Response = SchedulerWebService.resheduleEvents(Request);
	
        //Testing for null first name
        Request.firstName = null;
        Response = SchedulerWebService.resheduleEvents(Request);         
	
        //Testing for null last name
        Request.lastname = null;
        Response = SchedulerWebService.resheduleEvents(Request);         
	
        //Testing for null email
        Request.Email = null;
        Response = SchedulerWebService.resheduleEvents(Request);         
	
        //Testing for null notes
        Request.Notes = null;
        Response = SchedulerWebService.resheduleEvents(Request);         
	        
        //Testing for null appointment length
        Request.appointmentLength = null;
        Response = SchedulerWebService.resheduleEvents(Request);         
	}

    /******************************************************************************
	* @Description : Check to see if an Implementation is already scheduled,      *
	*                for the CustomerID (RCUserID)                                *
	* @Params      : void                                                         *
	* @Return      : void                                                         * 
	******************************************************************************/
    static testMethod void test_isEventScheduled(){

        SchedulerWebService.isEventScheduledRequest Request = new SchedulerWebService.isEventScheduledRequest();
        SchedulerWebService.isEventScheduledResponse Response = new SchedulerWebService.isEventScheduledResponse();
        
        /* Setting up test records */
        // Instantiating class to setup test records.
		Test_Utils testRecordClass = new Test_Utils();
		
        // Creating test User.
        User testUser1 = new User();                   
		testUser1 = testRecordClass.createUserRecord(new List<User>{new User()})[0];
        
        // Creating Brand
        schedulerConfiguration__c createBrand = new schedulerConfiguration__c();
        createBrand.Brand_Id__c='2222';
        createBrand = testRecordClass.createSchedulerConfigurationRecords(new List<schedulerConfiguration__c>{createBrand})[0];
		// Creating Resource
        Resource_Pool__c resPool = new Resource_Pool__c();
        resPool.Brand_Name__c = createBrand.Id;
        resPool.Dispatch_Admin__c = testUser1.Id;
        resPool = testRecordClass.createResourcePoolRecords(new List<Resource_Pool__c>{resPool})[0];

        //Creating Advisor
        User testUser2 = new User();      
        testUser2 = testRecordClass.createUserRecord(new List<User>{new User()})[0];             
        
        Advisor__c advisor = new Advisor__c();
        advisor.Advisor_Name__c = testUser2.Id;
        advisor.Resource_Pool__c = resPool.Id;
        advisor.Preferred_Language__c = 'en_US';
        insert advisor; 

        //Calling method to create new event.
        Event event = new Event();
        event = createEventRecord(createBrand.Brand_Id__c, resPool.Id);
		
		Test.startTest();
		
	        //Testing for positive case with customer Id
	        Request.CustomerId= '1010';
	        Response = SchedulerWebService.isEventScheduled(Request);
	
	        //Testing is customer Id doesn't exists
	        Request.CustomerId= '1111' ;
	        Response = SchedulerWebService.isEventScheduled(Request);            
	
	        //Testing if customer is null
	        Request.CustomerId= null;
	        Response = SchedulerWebService.isEventScheduled(Request);
	        
	        // Testing for positive case with event Id.
	        Request.CustomerId= '1111' ;
			Request.eventId = event.Id;
			Response = SchedulerWebService.isEventScheduled(Request);
			
			// Testing for positive case with event Id no longer existing.
			delete event;
			Request.CustomerId= '1111' ;
			Request.eventId = event.Id;
			Response = SchedulerWebService.isEventScheduled(Request);
        
        Test.stopTest();
    } 
    
    private static Event createEventRecord(String brandName, Id resourcePoolId){
    	
    	Test_Utils testUtilsObject =  new Test_Utils();
        Event event = new Event();
        event.ownerId = system.Userinfo.getUserId();
        event.subject = 'test';
        event.StartDateTime = Datetime.now();
        event.EndDateTime = Datetime.now().addHours(1);
        event.DurationInMinutes = 60;
        event.WhatId = resourcePoolId; 
        event.Brand__c = brandName;
        event.Customer_Email__c = 'test@test.com';
        event.CustomerId__c = '12345';
        event.Description = 'This is a test event';
        event.NumberofUser__c = 20;
        event.First_Name__c = 'Test1';
        event.Last_Name__c = 'Test2';
        event.Type = 'Initial Implementation';
        testUtilsObject.initialiseTriggerBypass();
        	insert event; 
        testUtilsObject.deInitialiseTriggerBypass();
    	
    	return event;
    }   
}// End of Test Class.