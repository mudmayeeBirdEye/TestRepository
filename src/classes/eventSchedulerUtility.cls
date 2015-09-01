/**************************************************************************************************
 * Project Name..........: RingCentral                                                            *
 * File..................: eventSchedulerUtility                                                  *
 * Version...............: 1.0                                                                    *
 * Created by............: Simplion Technologies                                                  *
 * Created Date..........: 15-5-2013                                                              *
 * Last Modified by......: Simplion Technologies                                                  *
 * Last Modified Date....: 15-5-2013                                                              *
 * Description...........: This class will serve the need for common query                        *  
 *                            and method needed in the scheduler application                      *
 **************************************************************************************************/
global class eventSchedulerUtility { 
  
    // Declaring variables
    static String CRLF = '\r\n';
    public static final String IMPLEMENTATION_FOLLOW_UP = 'Implementation Follow-Up';
    public static Boolean hasError{get; set;}
    public static String errorString{get; set;}  
    public static OrgWideEmailAddress fromAddress = new OrgWideEmailAddress();
    public static String subject{get; set;}
    public static List<String> eventTypeList = new List<String>{'Initial Implementation','Follow-Up Implementation',
                                                                'Follow-Up Implementation 1','Follow-Up Implementation 2',
                                                                'Follow-Up Implementation 3','Follow-Up Implementation 4',
                                                                'Follow-Up Implementation 5'};
                                                                
    public static set<String> gmtZeroTimeZoneSet = new set<String>{'Africa/Casablanca','Europe/Dublin','Europe/Lisbon','Europe/London','GMT'};
    public static set<String> preferredSelectedLanguage = new set<String>{'en_US','en_GB'};
    private static final String CONFIRMATION = 'Confirmation';
    private static final String CANCELLATION_INTERNAL = 'Cancellation Internal';
     /*********************************************************************************************
     * @Description : Get Account Details for the input RC User Id.                               *
     * @Params      : Id <Account>                                                                *
     * @Return      : Account                                                                     * 
     *********************************************************************************************/
    public static Account getAccountDetails(String RCUserId){ 
        try{
            return ([SELECT Id, RC_User_ID__c, isAppointmentScheduled__c, RC_Brand__c FROM Account WHERE RC_User_ID__c =: RCUserId]);    
        }catch(Exception ex){
            system.debug('#### Error on line = '+ex.getLineNumber()+' message = '+ex.getMessage());
            return null;    
        }
    }
    
     /*********************************************************************************************
     * @Description : Get the List of Events for Salesforce Id Event                              * 
     * @Params      : Id <Event Id>                                                               *
     * @Return      : Event                                                                       * 
     *********************************************************************************************/
    public static Event getEventDetails(Id EventId){    
        
        // Declaring variables and resetting error
        resetError();
        List<Event> eventList = new List<Event>();
        Event eventRecord;
        
        try{
            //Query to fetch the event from salesforce, based on the input Event Id
            eventList = [SELECT Customer_Email__c,CustomerId__c ,Subject, StartDateTime,Id ,EndDateTime, Description,Preferred_Language__c,Time_Zone__c,
                               Appointment_Source__c,Last_Name__c,First_Name__c,NumberofUser__c,Brand__c,Implementation_Status__c,
                               Contact_Support__c,Type,IsChild
                         FROM Event 
                         WHERE Id =: EventId];
            if(eventList != null && eventList.size() > 0){
                eventRecord = eventList[0];
            }
        }catch(Exception ex){
            system.debug('#### Error on line = '+ex.getLineNumber()+' message = '+ex.getMessage());
        }    
        return eventRecord;
    }

     /*********************************************************************************************
     * @Description : Get the List of Events for a customer                                       * 
     * @Params      : Customer Id - xxxx                                                          *
     * @Return      : List of Events                                                              * 
     *********************************************************************************************/
    public static List<Event> getEventList(String customerId){

        // Declaring variables and resetting error
        resetError();
        List<Event> lstEvent;
        String custId = customerId;

        try{
            // Query to get the list of events for a customer Id        
            lstEvent= new List<Event>([SELECT Customer_Email__c,CustomerId__c ,Subject, StartDateTime,Id ,EndDateTime, Description,Preferred_Language__c,Time_Zone__c,
                                        Appointment_Source__c,Last_Name__c,First_Name__c,NumberofUser__c,Brand__c,Implementation_Status__c,
                                        Contact_Support__c,Type,IsChild FROM Event 
                                        WHERE (Implementation_Status__c != 'Canceled' AND
                                              CustomerId__c =: custId AND 
                                              StartDateTime >= TODAY AND
                                              IsChild = false)
                                       order by LastModifiedDate Desc]);
        }catch(Exception ex){
            system.debug('#### Error on line = '+ex.getLineNumber()+' message = '+ex.getMessage());
        }                                            
        return lstEvent;        
    }

     /*********************************************************************************************
     * @Description : Get the Brand details for xxxx Brand                                        *  
     * @Params      : Brand Id - xxxx                                                             *
     * @Return      : Scheduler_Configuration                                                     * 
     *********************************************************************************************/
    public static schedulerConfiguration__c getBrand(String brandId){

        // Declaring variables and resetting error
        resetError();
        List<schedulerConfiguration__c> schedulerConfigList; 
        schedulerConfiguration__c brandDetails;
        
        try{
            // Query to fecth the brand details based on the brand Id - xxxx
            schedulerConfigList = [SELECT s.Name, s.Id,s.Brand_Id__c,s.Rescheduling_Email_Template_Internal__c, 
                                            s.Rescheduling_Email_Template_Customer__c,s.Reminder_E_mail_Template_Name__c,
                                            s.Confirmation_Email_Template_Name__c, s.Cancellation_Email_Template_Internal__c,
                                            s.Cancellation_Email_Template_Customer__c,Contact_Support__c  
                                   FROM schedulerConfiguration__c s
                                   WHERE Brand_Id__c =: brandId LIMIT 1];
            if(schedulerConfigList != null && schedulerConfigList.size() > 0){
                brandDetails = schedulerConfigList[0];  
            }
            system.debug('#### Brand Details = '+brandDetails);                      
        }catch(Exception ex){
            system.debug('#### Error on line = '+ex.getLineNumber()+' message = '+ex.getMessage());
        }     
        return brandDetails;   
    }

 /*********************************************************************************************
     * @Description : Get the Brand details for xxxx Brand with respect to Preferred Languag      *  
     * @Params      : Brand Id - xxxx                                                             *
     * @Return      : Scheduler_Configuration                                                     * 
     *********************************************************************************************/
    public static schedulerConfiguration__c getBrandsDetailsLanguage(String brandId, String preferredLanguage){
         resetError();
        List<schedulerConfiguration__c> schedulerConfigList; 
        schedulerConfiguration__c brandDetails;
        try{
        schedulerConfigList = [SELECT s.Name, s.Id,s.Brand_Id__c,s.Rescheduling_Email_Template_Internal__c, 
                                            s.Rescheduling_Email_Template_Customer__c,s.Reminder_E_mail_Template_Name__c,
                                            s.Confirmation_Email_Template_Name__c, s.Cancellation_Email_Template_Internal__c,
                                            s.Cancellation_Email_Template_Customer__c,Contact_Support__c  
                                   FROM schedulerConfiguration__c s
                                     WHERE Brand_Id__c =: brandId and Preferred_Language__c =:preferredLanguage limit 1];
                                     
           if(schedulerConfigList != null && schedulerConfigList.size() > 0){
                brandDetails = schedulerConfigList[0];  
            }
            system.debug('#### Brand Details = '+brandDetails);                      
        }catch(Exception ex){
            system.debug('#### Error on line = '+ex.getLineNumber()+' message = '+ex.getMessage());
        }     
        return brandDetails; 
  }
    /*********************************************************************************************
    * @Description : Get the Brand details for Salesforce Brand Id                               *  
    * @Params      : Brand Id - xxxx                                                             *
    * @Return      : Scheduler_Configuration                                                     *  
    *********************************************************************************************/
    public static schedulerConfiguration__c getBrandId(String Id){

        // Declaring variables and resetting error
        resetError();
        schedulerConfiguration__c sc = new schedulerConfiguration__c();
        try{
            //Query to fetch the brand details based on the salesforce Id
            sc = [SELECT s.Name, s.Id,s.Brand_Id__c,s.Rescheduling_Email_Template_Internal__c, s.Rescheduling_Email_Template_Customer__c,
                 s.Reminder_E_mail_Template_Name__c,s.Confirmation_Email_Template_Name__c, s.Cancellation_Email_Template_Internal__c,
                 s.Cancellation_Email_Template_Customer__c,s.Contact_Support__c
                 FROM schedulerConfiguration__c s
                 WHERE Id =:Id ];

            // if no brand fetched, set error as "No Brand Exists with ID"
            if(sc == null){
                setError('No Brand exists with Id - '+id);
                return null;
            }
            return sc;                           
        }catch(Exception ex){
            setError('No Brand exists with Id - '+id);
            system.debug('#### Error on line - '+ex.getLineNumber());
            system.debug('#### Error message - '+ex.getMessage());
            return null;
        }             
    }  

    /*********************************************************************************************
    * @Description : Get buffer days for the brand                                               *  
    * @Params      : Brand Id - xxxx                                                             *
    * @Return      : Integer value, buffer days                                                  * 
    *********************************************************************************************/  
    public static Integer getBufferdays(String BrandID){

        // Declaring variables and resetting error
        resetError();
        List<schedulerConfiguration__c> lstschedulerConfiguration = new List<schedulerConfiguration__c>();
        Integer bufferDays = 0;
        
        try{
            // Query to fetch the buffer day for the brand
            lstschedulerConfiguration = [SELECT Buffer_Days__c FROM schedulerConfiguration__c WHERE Brand_Id__c =: BrandID];
            if(lstschedulerConfiguration != null && lstschedulerConfiguration[0].Buffer_Days__c != null){
                bufferDays = Integer.valueOf(lstschedulerConfiguration[0].Buffer_Days__c);
            }
        }catch(Exception ex){
            setError('No Brand exists with Id - '+BrandID);
            system.debug('#### Error on line = '+ex.getLineNumber()+' message = '+ex.getMessage());
        } 
        return bufferDays;
    }   

    /*********************************************************************************************
    * @Description : Method to fetch Org Wide Email Address.                                     * 
    * @Params      : Id                                                                          *
    * @Return      : OrgWideEmailAddress                                                         * 
    *********************************************************************************************/
    public static OrgWideEmailAddress getOrgWideAddress(Id emailId) {
        return [SELECT Id, DisplayName, Address FROM OrgWideEmailAddress WHERE Id=:emailId];
    }


    /*********************************************************************************************
    * @Description : Gets valid Email Template                                                   *
    * @Params      : BrandID,Email Type                                                          *
    * @Return      : Template Id                                                                 * 
    *********************************************************************************************/
    //public static Id getValidEmailTemplate(String brandId,String EmailType ){
    public static Id getValidEmailTemplate(String brandId,String EmailType,String preferredLanguage){
        // Declaring variables and resetting error
        resetError();
        Id emailTemplateId;
        /*if(preferredSelectedLanguage.contains(preferredLangauage)){
            preferredLangauage = 'en_US';
        }*/
        
        try{
            // Query to fetch email template
            schedulerConfiguration__c sc = [SELECT Cancellation_Email_Template_Customer__c,Cancellation_Email_Template_Internal__c,
                                            Confirmation_Email_Template_Name__c,Reminder_E_mail_Template_Name__c,
                                            Rescheduling_Email_Template_Customer__c,Rescheduling_Email_Template_Internal__c
                                            FROM schedulerConfiguration__c 
                                            WHERE (Brand_Id__c=:brandId or Id = :brandId) AND Preferred_Language__c =:preferredLanguage LIMIT 1];

            // Checking for the template type and setting the template accordingly
            if(EmailType == 'Confirmation')     
                emailTemplateId = sc.Confirmation_Email_Template_Name__c;
            if(EmailType == 'Cancellation')     
                emailTemplateId = sc.Cancellation_Email_Template_Customer__c;
            if(EmailType == 'Cancellation Internal')     
                emailTemplateId = sc.Cancellation_Email_Template_Internal__c;  
            if(EmailType == 'Reminder')     
                emailTemplateId = sc.Reminder_E_mail_Template_Name__c;
            if(EmailType == 'Rescheduling Customer')     
                emailTemplateId = sc.Rescheduling_Email_Template_Customer__c; 
            if(EmailType == 'Rescheduling Internal')     
                emailTemplateId = sc.Rescheduling_Email_Template_Internal__c;                  

        }catch(Exception ex){
            setError('No template available for Brand Id - '+ brandId);
            system.debug('#### Error on line - '+ex.getLineNumber());
            system.debug('#### Error message - '+ex.getMessage());
        }
        return emailTemplateId;
    }

    /*********************************************************************************************
    * @Description : Gets available time slots                                                   *
    * @Params      : BrandID,NumberofUsers,cdate,apptLength,premSupport,                         *
    * @Return      : List<String> availableTime                                                  * 
    *********************************************************************************************/
    public static TimeAdvisorWrapper availableTimeSlots(RequestParameterWrapper rpwObject){
        
        /* Declaring variables and resetting error */
        List<String> error = new List<String>();
        List<Id> ResourcesId = new List<Id>();
        List<Event> listCombinedEvents = new List<Event>();
        Set<String> availableTime = new Set<String>();
        String ctime;
        Date dateCon = Date.valueOf(rpwObject.appointmentDate);
        system.debug('dateCon---->'+dateCon);
        // Variable contains resource pool admin.   
        Resource_Pool__c dAdmin = new Resource_Pool__c();
        // Resetting error funtion.
        resetError();
        
        /* Creating return-arguments wrapper objects. */
        TimeAdvisorWrapper tawObject =  new TimeAdvisorWrapper();
        TimeAdvisorMapWrapper tamwObject = new TimeAdvisorMapWrapper();
        EventDetailsWrapper edwObject =  new EventDetailsWrapper();
        gatsmParamWrapper gatsmParamWrapperObject = new gatsmParamWrapper();
        gatsParamWrapper gatsParamWrapperObject =  new gatsParamWrapper();
        
        Map<String,Set<Id>> advTimeSlotCopy = new Map<String,Set<Id>>();
        
        Map<Id, Set<String>> advisorTimeSlotMap =  new Map<Id, Set<String>>();
        // Creating map to store time slot and list of events associated with that time slot
        Map<String,List<Event>> TimeToEventsMap = new Map<String,List<Event>>();    
        
        /* Time Slot responses*/
        List<String> availableTimeSlots = new List<String>();
        
        try{
            // Converting to datetime to fetch the day of the week
            Datetime dt = DateTime.newInstance(dateCon, Time.newInstance(0, 0, 0, 0));
            String dayOfWeek = dt.format('EEEE');
            system.debug('#### Date = '+dt+' Day = '+dayOfWeek);
            //System.debug(' #### BRAND ID FOUND IN INTERNAL TOOL ### ' + rpwObject.BrandId);
            /* Calling method to fetch valid resource pool */
            dAdmin = eventSchedulerUtility.getValidResourcePool(rpwObject.BrandId, rpwObject.NumberOfUsers, rpwObject.premiumSupport,rpwObject.preferredLanguage);
            //checking for error in fetching the ressult
            if(eventSchedulerUtility.hasError){
                return null;
            }    
    
            /* Calling method to fetch all the time available */
            advisorTimeWrapper atwObject = new advisorTimeWrapper(); 
            atwObject.arwObject.ResourcePoolId = dAdmin.Id;
            atwObject.dayOfWeek = dayOfWeek;
            atwObject.eventType = rpwObject.eventType;
            atwObject.arwObject.preferredLanguage = rpwObject.preferredLanguage;
            atwObject.arwObject.timeZone = rpwObject.timeZone;
            List<Time__c> advTimeList = eventSchedulerUtility.advisorTimeList(atwObject);
            // Checking for error in fetching the result
            if(eventSchedulerUtility.hasError){
                return null;
            }       
    
            /*Calling method to convert all the time in sets of time slot*/
            //tamwObject = eventSchedulerUtility.timeSlots(advTimeList, rpwObject.appointmentLength); 
            tamwObject = eventSchedulerUtility.timeSlots(advTimeList, rpwObject.appointmentLength,rpwObject.timeZone);
            /* Calling method to fetch resource pool resources/advisors */
            advisorRequestWrapper arwObject = new advisorRequestWrapper();
            arwObject.ResourcePoolId = dAdmin.Id;
            arwObject.preferredLanguage = rpwObject.preferredLanguage; 
            arwObject.timeZone = rpwObject.timeZone;
            
            ResourcesId = eventSchedulerUtility.getResourcePoolResources(arwObject);
            //Checking for error in fetching the result
            if(eventSchedulerUtility.hasError){
                setError('No Advisors in the Resource Pool.');
                return null;
            }
            ResourcesId.add(dAdmin.Dispatch_Admin__c);                   
            //system.debug('#### ResourcesId - '+ResourcesId);
            
            /* Calling method to fetch List of All types of Events
                - If date and time are selected, get events specific to them.
                - Else get all the event for that date.
             */
             //system.debug('#### rpwObject '+ rpwObject);
             //system.debug('#### rpwObject.selectedTime '+ rpwObject.selectedTime);
              
            if(rpwObject != null && rpwObject.selectedTime != null){
                datetime dateTimeSelected;
                Decimal offsetValue = 0;
                //dateTimeSelected = datetime.valueOf(rpwObject.appointmentDate +' '+ rpwObject.selectedTime+':00');
                Date apDate = Date.valueOf(rpwObject.appointmentDate);
                String hour = rpwObject.selectedTime.split(':').get(0);
                system.debug('hour-------->'+hour);
                String minute = rpwObject.selectedTime.split(':').get(1);
                //dateTimeSelected = datetime.valueOf(rpwObject.appointmentDate +' '+ rpwObject.selectedTime+':00');
                dateTimeSelected =  DateTime.newInstanceGMT(apDate.Year(),apDate.Month(),apDate.Day(),Integer.valueOf(hour), Integer.valueOf(minute), 0);
               if(!rpwObject.timeZone.containsIgnoreCase('Europe/London')){
                  if(!rpwObject.timeZone.containsIgnoreCase('America/Los_Angeles') && rpwObject.timeZone.containsIgnoreCase('Europe/London')){
                    offsetValue = eventSchedulerUtility.getOffsetValue('America/Los_Angeles','Europe/London');
                    }
                    if(!rpwObject.timeZone.containsIgnoreCase('America/Los_Angeles') && rpwObject.timeZone.containsIgnoreCase('America/Denver')){
                        //offsetValue = eventSchedulerUtility.getOffsetValue('America/Los_Angeles','America/Denver');
                    }
               
                    dateTimeSelected = dateTimeSelected.addHours(Integer.valueOf(offsetValue));
                     //system.debug('#### Select Date Time system mode = '+dateTimeSelected);
                    
                     offsetValue = eventSchedulerUtility.getOffsetValue('GMT',rpwObject.timeZone);
                     dateTimeSelected = dateTimeSelected.addHours(Integer.valueOf(offsetValue));
              }
               
                //system.debug('#### Select Date Time system mode  After===> '+dateTimeSelected);
                fesParamWrapper fpw = new fesParamWrapper(); 
                fpw.selectedDateTime = dateTimeSelected;
                fpw.appointmentLength = rpwObject.appointmentLength;
                fpw.ResourcesId = ResourcesId;
                edwObject = fetchEventsSpecific(fpw);
                //system.debug('#### Specific Event '+edwObject);
            }else{
                //edwObject = fetchAllTypesOfEvents(dateCon, ResourcesId);
                edwObject = fetchAllTypesOfEvents(dateCon, ResourcesId, rpwObject.preferredLanguage);
                //system.debug('#### All Event '+edwObject);
            }
            //system.debug('#### rpwObject '+ rpwObject);
            //system.debug('#### rpwObject.selectedTime '+ rpwObject.selectedTime);
            //system.debug('#### edwObject - '+edwObject);
            
            /* Calling method to fetch Time to Events Map */
            TimeToEventsMap = filterTimeSlots(tamwObject,edwObject != null ? edwObject.eventList : new List<Event>(),dateCon,rpwObject);
            //system.debug('#### TimeToEventsMap - '+TimeToEventsMap);
            
            if(rpwObject.selectedAdvisor != null && rpwObject.selectedAdvisor != ''){
                    /* Calculating the time slot per advisor */
                    gatsmParamWrapperObject.advisorTimeSlotMap = tamwObject != null ? tamwObject.advisorTimeSlotMap : null;
                    gatsmParamWrapperObject.eventInviteeMap = edwObject != null ? edwObject.eventInviteeMap : null;
                    gatsmParamWrapperObject.TimeToEventsMap = TimeToEventsMap;
                
                    advisorTimeSlotMap = getAdvisorTimeSlotMap(gatsmParamWrapperObject);
                    system.debug('#### advisorTimeSlotMap - '+advisorTimeSlotMap);
            }else{
                
                     /* Calculating all the available time slot */
                    gatsParamWrapperObject.dAdmin = dAdmin;
                    gatsParamWrapperObject.tamwObject = tamwObject; 
                    gatsParamWrapperObject.TimeToEventsMap = TimeToEventsMap; 
                    
                    availableTimeSlots = getAvailableTimeSlots(gatsParamWrapperObject);
                    system.debug('#### availableTimeSlots - '+availableTimeSlots);
                    
                     /* Calculating the time slot per advisor */
                    gatsmParamWrapperObject.advisorTimeSlotMap = tamwObject != null ? tamwObject.advisorTimeSlotMap : null;
                    gatsmParamWrapperObject.eventInviteeMap = edwObject != null ? edwObject.eventInviteeMap : null;
                    gatsmParamWrapperObject.TimeToEventsMap = TimeToEventsMap;
                    
                    advisorTimeSlotMap = getAdvisorTimeSlotMap(gatsmParamWrapperObject); 
                    system.debug('#### advisorTimeSlotMap - '+advisorTimeSlotMap);
            }
            
            /* Wrapping and Returning time slot responses*/         
            tawObject.availableTimeSlots = availableTimeSlots;
            tawObject.availableAdvisors = advisorTimeSlotMap;
            tawObject.timeSlotAdvisorMap = tamwObject != null ? tamwObject.timeSlotAdvisorMap : new Map<String, Set<Id>>();
            
            system.debug('#### tawObject - '+tawObject);
            return tawObject; 
      } catch(Exception ex){
        system.debug('#### Error on line - '+ex.getLineNumber());
        system.debug('#### Error message - '+ex.getMessage());
        return null;
      }               
    }  

    /*********************************************************************************************
    * @Description : Read the Events Object and return a well-formed iCal String.                *  
    * @Params      : FirstName,LastName,Email,Event                                              *
    * @Return      : String Wrap(result, 75);                                                    * 
    *********************************************************************************************/
    public static String getiattachment(String FirstName, String LastName ,String cEmail,Event eventobj) {
        try{
            System.debug('##### OBJECT = '+(fromAddress == null ? ' NULL INPUT ' : fromAddress.DisplayName));
            resetError();
            DateTime StartDateTime =eventobj.StartDateTime ; 
            DateTime EndDateTime  = eventobj.EndDateTime;
    
            String dtstamp = 'DTSTAMP:' + Datetime.Now().format('yyyyMMdd\'T\'HHmmss\'Z\'') + CRLF;
            String result = 'BEGIN:VCALENDAR' + CRLF + 'VERSION:2.0' + CRLF;
            result += 'METHOD:PUBLISH' + CRLF;
            result += 'BEGIN:VEVENT' + CRLF;
            result += dtstamp;
            result += Schedule(false, StartDateTime,EndDateTime); 
            if(subject!=null){
                result += SetField('SUMMARY:',subject);
            }else{
                result += SetField('SUMMARY:', 'Scheduled Appointment by '+FirstName+' '+LastName+ ': Implementation');
            }
            result += SetField('LOCATION:', '');
            result += 'TRANSP:OPAQUE' + CRLF + 'X-MICROSOFT-CDO-BUSYSTATUS:OOF' + CRLF;
            result += Reminder();
            result += 'SUMMARY:Implementation Appointment';  
            result += SetField(' DESCRIPTION:', 'Scheduled Appointment by '+FirstName+' '+LastName+ ': Implementation');
            result += 'ATTENDEE;ROLE=REQ-PARTICIPANT;PARTSTAT=TENTATIVE;CN="' + FirstName + '":MAILTO:' + cEmail+' ';
            // result += 'ATTENDEE;ROLE=REQ-PARTICIPANT;PARTSTAT=TENTATIVE;CN="IMPLEMENTATION USER":MAILTO:shivanath.d@simplion.com' + CRLF;
            result += 'ORGANIZER;CN="'+(fromAddress!=null?fromAddress.DisplayName:'')+'":MAILTO:'+(fromAddress!=null?fromAddress.Address:'')+ '' + CRLF; 
            result += 'END:VEVENT' + CRLF;
            result += 'END:VCALENDAR' + CRLF;
            return Wrap(result, 75);
        }catch(Exception ex){
            system.debug('#### Error on line - '+ex.getLineNumber());
            system.debug('#### Error message - '+ex.getMessage());
            return null;
        }  
    }

    /*********************************************************************************************
    * @Description : Set the Schedule and return result                                          *
    * @Params      : IsAllDayEvent, StartDateTime, EndDateTime                                   *
    * @Return      : result;                                                                     * 
    *********************************************************************************************/
    private static String Schedule(Boolean IsAllDayEvent, Datetime StartDateTime, Datetime EndDateTime) {
        String result;
        if (IsAllDayEvent) {
            //result = 'DTSTART;VALUE=DATE:' + StartDateTime.format('yyyyMMdd',System.Userinfo.getTimeZone().toString()) + CRLF;
            result = 'DTSTART;VALUE=DATE:' +  StartDateTime.formatGmt('yyyyMMdd') + CRLF;
            result += 'DTEND;VALUE=DATE:' + EndDateTime.AddDays(1).formatGmt('yyyyMMdd') + CRLF;
        }
        else {
            result = 'DTSTART:' +  StartDateTime.formatGmt('yyyyMMdd\'T\'HHmmss\'Z\'') + CRLF;
            result += 'DTEND:' + EndDateTime.formatGmt('yyyyMMdd\'T\'HHmmss\'Z\'') + CRLF;
        }
        return result;
    }

    /*********************************************************************************************
    * @Description : Sets the escape format for the recived field                                * 
    * @Params      : fieldName, fieldValue                                                       *
    * @Return      : fieldName+fieldValue                                                        * 
    *********************************************************************************************/
    private static String SetField(String fieldName, String fieldValue) {
        if (fieldValue != null && fieldValue != '') {
            return fieldName + Escape(fieldValue) + CRLF;
        }
        return '';  
    }

    /*********************************************************************************************
    * @Description : Sets the reminder alerts                                                    *
    * @Params      : ReminderDateTime, StartDateTime                                             *
    * @Return      : string                                                                      *  
    *********************************************************************************************/
    private static String Reminder() {
        return 'BEGIN:VALARM' + CRLF + 'TRIGGER:-PT10M' + CRLF + 'ACTION:DISPLAY' + CRLF + 'DESCRIPTION:Reminder' + CRLF + 'END:VALARM' + CRLF;
    }

    /*********************************************************************************************
    * @Description : Get a string and return this wrapped                                        *
    * @Params      : original, width                                                             *
    * @Return      : original                                                                    * 
    *********************************************************************************************/
    private static String Wrap(String original, Integer width) {
        return original;
    }

    /*********************************************************************************************
    * @Description : Get a string and return this as eascaped string                             *
    * @Params      : original                                                                    *
    * @Return      : original escaped                                                            * 
    *********************************************************************************************/
    private static String Escape(String original) {
        return original.replace('\n','\\n').replace('\r','');
    }

    /*********************************************************************************************
    * @Description : Reset error object                                                          * 
    * @Params      : none                                                                        *
    * @Return      : none                                                                        *   
    *********************************************************************************************/
    private static void resetError(){
        hasError = false;
        errorString = '';
    }

    /*********************************************************************************************
    * @Description : Set error object                                                            *
    * @Params      : none                                                                        *
    * @Return      : none                                                                        *   
    *********************************************************************************************/
    private static void setError(String message){
        hasError = true;
        errorString = message;
    }

    /*********************************************************************************************
    * @Description : Get resource pool id & return list of Advisor User Id resources             *
    * @Params      : Resource Pool Id                                                            * 
    * @Return      : List<id>                                                                    *  
    *********************************************************************************************/
    public static List<Id> getResourcePoolResources(advisorRequestWrapper arwObject){
        resetError();  
        List<Id> resourceId = new List<Id>();
        try{
            for(Advisor__c advisor: [SELECT Id, Advisor_Name__c, Preferred_Language__c
                                     FROM Advisor__c 
                                     WHERE Resource_Pool__c =: arwObject.ResourcePoolId AND Advisor_Name__r.IsActive = true AND
                                     Preferred_Language__c includes (:arwObject.preferredLanguage)]){
                resourceId.add(advisor.Advisor_Name__c);
            }
            system.debug('#### resourceId - '+resourceId);
            //if no advisor fetched, set error message as "No Advisor available for Resource Pool Id"
            if(resourceId.size() == 0){
                setError('No Advisors in the Resource Pool.');
                return null;
            }                    
            return resourceId;
        }catch(Exception ex){          
            setError('No Advisors in the Resource Pool.');
            system.debug('#### Error on line - '+ex.getLineNumber());
            system.debug('#### Error message - '+ex.getMessage());
            return null;
        }
    }

    /*********************************************************************************************
    * @Description : Get resource pool id and return list of Advisor Id resources                *
    * @Params      : Resource Pool Id                                                            *
    * @Return      : List<id>                                                                    * 
    *********************************************************************************************/
    public static List<Id> getResourcePoolResourcesId (advisorRequestWrapper arwObject){
        resetError();  
        List<Id> resourceId = new List<Id>();
        try{
            system.debug('#### Code at getResourcePoolResourcesId - '+arwObject.ResourcePoolId);
            system.debug('#### Code at getResourcePoolResourcesId - '+arwObject.preferredLanguage);
            for(Advisor__c advisor: [SELECT Id,Advisor_Name__c ,Preferred_Language__c 
                                     FROM Advisor__c 
                                     WHERE Resource_Pool__c =: arwObject.ResourcePoolId AND Advisor_Name__r.IsActive = true AND 
                                           Resource_Pool__r.Dispatch_Admin__r.IsActive = true AND Preferred_Language__c includes (:arwObject.preferredLanguage)]){  
                resourceId.add(advisor.Id);
            }
            //if no advisor fetched, set error message as "No Advisor available for Resource Pool Id"
            if(resourceId.size() == 0){
                setError('No Advisor/Dispatch Admin available for Resource Pool.');
                return null;
            }                    
            return resourceId;
        }catch(Exception ex){           
            setError('No Advisor/Dispatch Admin available for Resource Pool.');
            system.debug('#### Error on line - '+ex.getLineNumber());
            system.debug('#### Error message - '+ex.getMessage());
            return null;
        }
    }

    /*********************************************************************************************
    * @Description : Get valid resource pool and return resource pool.                           *
    * @Params      : Brand Id, Number of users                                                   *
    * @Return      : Resource_Pool__c                                                            * 
    *********************************************************************************************/
    public static Resource_Pool__c getValidResourcePool(String BrandID,Integer NumberofUsers,Boolean premSupport, String preferredLanguage){
        resetError();
        //Assuming there are 5 Conditions
        List<Resource_Pool__c>  equal = new List<Resource_Pool__c>();
        List<Resource_Pool__c>  greaterThanOrEqual = new List<Resource_Pool__c>();
        List<Resource_Pool__c>  greaterThan = new List<Resource_Pool__c>();
        List<Resource_Pool__c>  LesserThanOrEqual = new List<Resource_Pool__c>();
        List<Resource_Pool__c>  LesserThan = new List<Resource_Pool__c>();
        
         system.debug('####$$$ All values - '+BrandID +'-' +NumberofUsers +'-'+premSupport +'-'+preferredLanguage +'-');
         

        Resource_Pool__c validResourcePool = new Resource_Pool__c(); 
        List<Resource_Pool__c>  rpList = new List<Resource_Pool__c>();        

        try{
                rpList = [SELECT Active__c,Brand_Name__c,Resource_Pool_Email__c,Criteria__c,Preferred_Language__c,
                                                     Dispatch_Admin__c,Id,Name,No_of_User_DLs__c,Premium_Support__c 
                                                     FROM Resource_Pool__c
                                                     WHERE Brand_Name__c =: BrandID and Active__c = true and Preferred_Language__c =:preferredLanguage
                                                     ORDER BY No_of_User_DLs__c ASC];
                  system.debug('####$$$ rpList - ' + rpList + ' Size-->'+rpList.size());
                if(rpList.size() == 0){
                    setError('No Resource Pool found.' );
                    return null;
                }
    
            for(Resource_Pool__c rp:rpList){
    
                if(rp.premium_Support__c == true && premSupport == true){
                    validResourcePool = rp;
                }
                else{
                    if(rp.Criteria__c == '=' && rp.premium_Support__c == false)
                        equal.add(rp);
                    if(rp.Criteria__c == '>=' && rp.premium_Support__c == false)
                        greaterThanOrEqual.add(rp);
                    if(rp.Criteria__c == '>' && rp.premium_Support__c == false)
                        greaterThan.add(rp);
                    if(rp.Criteria__c == '<=' && rp.premium_Support__c == false)
                        LesserThanOrEqual.add(rp);
                    if(rp.Criteria__c == '<' && rp.premium_Support__c == false)
                        LesserThan.add(rp);
                }
            }  
    
            system.debug('#### premSupport - '+premSupport);
            if(premSupport != true){
                // priority is give to The above order
                if(equal.size()>0){
                    for(Resource_Pool__c rp: equal){
                        if(NumberofUsers == Integer.valueOf(rp.No_of_User_DLs__c))
                            validResourcePool = rp;
    
                    }
                }
                if(validResourcePool != null && greaterThanOrEqual.size()>0){
                    for(Resource_Pool__c rp: greaterThanOrEqual){
                        if(NumberofUsers >= Integer.valueOf(rp.No_of_User_DLs__c))
                            validResourcePool = rp;
                    }
                }
                if(validResourcePool != null && greaterThan.size()>0){
                    for(Resource_Pool__c rp: greaterThan){
                        if(NumberofUsers > Integer.valueOf(rp.No_of_User_DLs__c))
                            validResourcePool = rp;
                    }
                }
                /*For Lesser than we need to use additional logic,Since the list is sorted, 
                   the most probable resource pool will be at the end of the list*/
                List<Resource_Pool__c> LesserList = new List<Resource_Pool__c>();
                if(validResourcePool != null && LesserThanOrEqual.size()>0){
                    for(Resource_Pool__c rp: LesserThanOrEqual){
                        if( Integer.valueOf(NumberofUsers) <= rp.No_of_User_DLs__c )
                            LesserList.add(rp);
                    }
                    if(LesserList.size()>0)
                        validResourcePool = LesserList[LesserList.size()-1];
                }
                if(validResourcePool != null && LesserThan.size()>0){
                    LesserList.clear();
                    for(Resource_Pool__c rp: LesserThan){
                        if( Integer.valueOf(NumberofUsers) < rp.No_of_User_DLs__c )
                            LesserList.add(rp);
                    }
                    if(LesserList.size()>0){
                        validResourcePool = LesserList[LesserList.size()-1];
                    }
                }
            }
    
            system.debug('#### validResourcePool - '+validResourcePool);
            if(validResourcePool.Id ==  null){
                setError('Invalid Resource Pool configuration.');
                return null;
            }                   
        }catch(Exception ex){
            setError('No Resource Pool found.');
            system.debug('#### Error on line - '+ex.getLineNumber());
            system.debug('#### Error message - '+ex.getMessage());
            return null;     
        }  
        return validResourcePool; // If it returns null ; Throw a invalid resource pool configuration exception 
    }

    /*********************************************************************************************
    * @Description : Get all the available time list of an advisor                               *
    * @Params      : Resource Pool Id, Day of week                                               *
    * @Return      : List<Time__c>                                                               * 
    *********************************************************************************************/
    public static List<Time__c> advisorTimeList(advisorTimeWrapper atwObject){
        
        resetError();
        List<Time__c> advisorTimeList = new List<Time__c>();
        system.debug('#### Code @ advisorTimeList : Resource Pool Id - '+atwObject.arwObject.ResourcePoolId);
        system.debug('#### Code @ advisorTimeList : Day - '+atwObject.dayOfWeek);
        system.debug('#### Code @ advisorTimeList : Event Type - '+atwObject.eventType);
        try{
            //List<id> advisorUserIdList = eventSchedulerUtility.getResourcePoolResources(ResourcePoolId);
            /* Calling method to fetch resource pool resources/advisors */
            advisorRequestWrapper arwObject = new advisorRequestWrapper();
            arwObject.ResourcePoolId = atwObject.arwObject.ResourcePoolId;
            arwObject.preferredLanguage = atwObject.arwObject.preferredLanguage;
            arwObject.timeZone = atwObject.arwObject.timeZone;
            
            List<Id> advisorUserIdList = eventSchedulerUtility.getResourcePoolResourcesId(arwObject);
            if(advisorUserIdList == null){
                setError('No Advisors in the Resource Pool.');
                return null;
            }
            System.debug('#### List of advisors fetched for - Resource Pool = '+atwObject.arwObject.ResourcePoolId+' Advisors = '+advisorUserIdList);
            String implementationType = atwObject.eventType != null && atwObject.eventType.startsWith('Follow-Up Implementation') ? 'Follow-Up Implementation' : 'Initial Implementation';
            System.debug('#### Implementation is of Type - '+implementationType);
            
            advisorTimeList = [ SELECT Start_Time__c, End_Time__c,Day__c, Advisor_Name__c, Advisor_Name__r.Advisor_Name__r.Id
                                FROM Time__c 
                                WHERE Advisor_Name__c IN: advisorUserIdList AND Day__c =: atwObject.dayOfWeek AND 
                                      availableFor__c includes (:implementationType)];
            if(advisorTimeList == null || advisorTimeList.size() == 0){
                setError('No Time Slot available for Advisor.');
                return null;
            }                                 
            return advisorTimeList;  
        }catch(Exception ex){
            setError('No Resource Pool found.');
            system.debug('#### Error on line - '+ex.getLineNumber());
            system.debug('#### Error message - '+ex.getMessage());
            return null;     
        }         
    }

    /*********************************************************************************************
    * @Description : Convert time list of an advisor,breaking the list into slots.               *
    * @Params      : List<Time__c>                                                               *
    * @Return      : Map<String,List<Id>>                                                        * 
    *********************************************************************************************/
    //public static TimeAdvisorMapWrapper timeSlots(List<Time__c> timeList, String apptLength){
      public static TimeAdvisorMapWrapper timeSlots(List<Time__c> timeList, String apptLength, String timeZone){  
        system.debug('#### Code @ timeSlots : Appointment Length - '+apptLength);
        system.debug('#### Code @ timeSlots : timeList - '+timeList);
        
        TimeAdvisorMapWrapper tamwObject = new TimeAdvisorMapWrapper();
        Map<String,Set<Id>> timeSlots = new Map<String,Set<Id>>();
        Map<Id, Set<String>> advisorTimeSlotMap =  new Map<Id, Set<String>>(); 
        Map<Decimal, Decimal> SETMap = new Map<Decimal, Decimal>();
        String convSlot;
        resetError();
        
        try{
            
            String strOffset = System.now().format('Z');
            String strOffsetHours = strOffset.substring(0,3);
            String strOffsetPST = System.now().format('Z','America/Los_Angeles');
            String strOffsetHoursPST = strOffsetPST.substring(0,3);
            //Decimal strOffsetHoursDiff = Decimal.valueOf(strOffsetHours) - Decimal.valueOf(strOffsetHoursPST);
            Decimal strOffsetHoursDiff = 0;
            strOffsetHoursDiff = eventSchedulerUtility.getOffsetValue(timeZone,'America/Los_Angeles');
           /*if(!timeZone.containsIgnoreCase('America/Los_Angeles') && timeZone.containsIgnoreCase('Europe/London')){
                strOffsetHoursDiff = eventSchedulerUtility.getOffsetValue('GMT','America/Los_Angeles');
            }
            if(!timeZone.containsIgnoreCase('America/Los_Angeles') && timeZone.containsIgnoreCase('America/Denver')){
                strOffsetHoursDiff = eventSchedulerUtility.getOffsetValue('America/Denver','America/Los_Angeles');
            }*/
            
            system.debug('#### Offset Hours Difference 111111---> '+strOffsetHoursDiff);
            
            //SETMap = parsingEvents(timeList, strOffsetHoursDiff);
            
            for(Time__c timeLooper : timeList){
                Decimal startTime  = Decimal.valueOf(timeLooper.Start_Time__c.substring(0,2)) + (Decimal.valueOf(timeLooper.Start_Time__c.substring(3,5))/60);
                startTime = startTime + strOffsetHoursDiff; 
                system.debug('#### Start Time in TimeSlots - '+startTime);
                /* Validation Check, to put time slots between 08:00 AM ~ 05:00 PM */
                //startTime < 8.0 || startTime < 17.0
                if(true){ 
                    Decimal endTime  = Decimal.valueOf(timeLooper.End_Time__c.substring(0,2)) + (Decimal.valueOf(timeLooper.End_Time__c.substring(3,5))/60);
                    endTime = endTime + strOffsetHoursDiff;
                    system.debug('#### End Time in TimeSlots - '+endTime); 
                    Decimal slotDiff = endTime - startTime; 
                    system.debug('###### Start Time and End Time difference - '+slotDiff);
        
                    if(slotDiff > 0){
        
                        // Setting end time, according to the appointment length
                        // endTime = endTime-Decimal.valueOf(apptLength)/60;   
                        Decimal lengthEndDate = startTime + Decimal.valueOf(apptLength)/60;
                        system.debug('###### Aprroximated start time after adding the appointment length - '+lengthEndDate);                  
                        while(startTime < endTime && lengthEndDate <= endTime){
        
                            // logic to add :30 mins to the time slot                            
                            Decimal diff = startTime-startTime.intValue();
                            Integer minutes = (diff * 60).intValue();
                            //convSlot = (startTime< 10? '0' : '')+startTime.intValue()+(minutes!=0?':'+minutes:':00'); 
                            convSlot = (startTime< 10? '0' : '')+startTime.intValue()+':00'; 
                            system.debug('#### Time Slot after conversion - '+convSlot); 
        
                            // Creating Map<String, Set<Id>> == Map<TimeSlot, Set of Advisors>.
                            if(timeSlots.get(convSlot)!=null)
                                timeSlots.get(convSlot).add(timeLooper.Advisor_Name__r.Advisor_Name__r.Id);
                            else
                                timeSlots.put(convSlot,new Set<Id>{timeLooper.Advisor_Name__r.Advisor_Name__r.Id});  
                            
                            // Creating Map<Id, Set<String>> == Map<Advisors, Set of TimeSlot>.
                            if(advisorTimeSlotMap.get(timeLooper.Advisor_Name__r.Advisor_Name__r.Id)!=null)
                                advisorTimeSlotMap.get(timeLooper.Advisor_Name__r.Advisor_Name__r.Id).add(convSlot);
                            else
                                advisorTimeSlotMap.put(timeLooper.Advisor_Name__r.Advisor_Name__r.Id,new Set<String>{convSlot});
                            
                            startTime = startTime+1;
                            //startTime = startTime+.50;
                            system.debug('###### startTime outside while - '+startTime);
                            lengthEndDate = startTime + Decimal.valueOf(apptLength)/60; 
                            system.debug('###### lengthEndDate inwhile - '+lengthEndDate);
                        }                   
                    }
                }
            }               
            System.debug('#### time slots - '+timeSlots);
            if(timeSlots.size() == 0){
                setError('No Time Slot available.');
            }
            tamwObject.timeSlotAdvisorMap = timeSlots; 
            tamwObject.advisorTimeSlotMap = advisorTimeSlotMap;
            return tamwObject;
        }catch(Exception ex){
            setError('No Resource Pool found.');
            system.debug('#### Error on line - '+ex.getLineNumber());
            system.debug('#### Error message - '+ex.getMessage());
            return null;     
        }  
    }
    
     /*********************************************************************************************
     * @Description : Tells if a scheduled event is associated with an Implementation.            *
     * @Params      : String, Date                                                                *
     * @Return      : Boolean                                                                     * 
     *********************************************************************************************/
     public static Integer isInitialAppointmentScheduled(String rcUserId, Date appointmentDate){
        
        List<Event> eventList =  new List<Event>();
        
        try{
            eventList = getImplementationEvent(rcUserId, appointmentDate) ;
            system.debug('#### Events fetched for Customer Id in isInitialAppointmentScheduled method - '+eventList);
            return((eventList != NULL && eventList.size() > 0) ? eventList.size() : 0); 
        }catch(Exception ex){
            system.debug('#### Error on line - '+ex.getLineNumber());
            system.debug('#### Error message - '+ex.getMessage());
            return 0;   
        }
     }
     
     /*********************************************************************************************
     * @Description : Fetches Implementation based on RC User Id.                                 *
     * @Params      : String                                                                      *
     * @Return      : List<Implementation__c>                                                     * 
     *********************************************************************************************/
     public static List<Implementation__c> getImplementation(String rcUserId){
        try{
             return([SELECT Id, Contact__c, Account__r.Current_Owner__c, OwnerId, Owner.Name, Account__r.Name,Account__r.RC_Brand__c 
                     FROM Implementation__c WHERE RC_USER_ID__c =: rcUserId]);                  
        }catch(Exception ex){
            system.debug('#### Error on line - '+ex.getLineNumber());
            system.debug('#### Error message - '+ex.getMessage());
            return null;    
        }
     }
     
     /*********************************************************************************************
     * @Description : Fetches events associated to an Implementation on a particular date.        *
     * @Params      : List<Implementation__c>, Date                                               *
     * @Return      : List<Event>                                                                 * 
     *********************************************************************************************/
     public static List<Event> getImplementationEvent(String rcUserId, Date appointmentDate){
            system.debug('#### rcUserId - '+rcUserId);
        try{
            return([SELECT Id FROM Event WHERE CustomerId__c =: rcUserId AND Implementation_Status__c != 'Canceled' AND 
                                               IsChild != true AND Type != 'System Use']);  
        }catch(Exception ex){
            system.debug('#### Error on line - '+ex.getLineNumber());
            system.debug('#### Error message - '+ex.getMessage());
            return null;    
        }
     }
     
     /*********************************************************************************************
     * @Description : Inserts record in Exception and Notification History object,                *
     *                for 24 hours reminder.                                                      *
     * @Params      : Event                                                                       *
     * @Return      : void                                                                        * 
     *********************************************************************************************/
     public static void reminderEmail(Event insertedEvent, String brandName){
        
        Schema.DescribeSObjectResult d = Schema.SObjectType.Exception_And_Notification_History__c;
        Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
        Schema.RecordTypeInfo rtByName =  rtMapByName.get('Email Notification');
        
        Exception_And_Notification_History__c reminderMail =  new Exception_And_Notification_History__c();
        
        if(insertedEvent.Id != null){
            reminderMail.RecordTypeId = rtByName.getRecordTypeId();
            reminderMail.To_Address_1__c = insertedEvent.Customer_Email__c;
            reminderMail.Object_Type__c = 'Event';
            reminderMail.isEmailSent__c = true;
            reminderMail.Record_Id__c = insertedEvent.Id;
            reminderMail.Email_Date_01__c = insertedEvent.StartDatetime;
            reminderMail.content_label_01__c = 'Reminder';
            reminderMail.content_label_02__c = insertedEvent.Brand__c;
            //reminderMail.content_label_03__c = (insertedEvent.StartDatetime).format(getDateFormat(brandName)+' K:mm a, z' ,System.Userinfo.getTimeZone().toString());
            reminderMail.content_label_03__c = (insertedEvent.StartDatetime).format(getDateFormat(brandName)+' h:mm a, z' ,insertedEvent.Time_Zone__c);
            
            insert reminderMail;            
        }
     }
     
     /*********************************************************************************************
     * @Description : Update record in Exception and Notification History object,                 *
     *                for cancelling 24 hours reminder on Time based queue.                       *
     * @Params      : Event                                                                       *
     * @Return      : void                                                                        * 
     *********************************************************************************************/
     public static void cancelReminderEmail(Event updateEvent){
        
        Schema.DescribeSObjectResult d = Schema.SObjectType.Exception_And_Notification_History__c;
        Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
        Schema.RecordTypeInfo rtByName =  rtMapByName.get('Email Notification');
        
        List<Exception_And_Notification_History__c> notificationRecord = new List<Exception_And_Notification_History__c>();
        notificationRecord = [SELECT isEmailSent__c FROM Exception_And_Notification_History__c 
                              WHERE Record_Id__c =: updateEvent.Id AND RecordTypeId =: rtByName.getRecordTypeId()];
        for(Exception_And_Notification_History__c thisRecord: notificationRecord){
            thisRecord.isEmailSent__c = false;  
        }
        if(notificationRecord != null && notificationRecord.size() > 0){
            update notificationRecord;
        }   
     }
     
     /*********************************************************************************************
     * @Description : Get available advisors details.                                             *
     * @Params      : Resource_Pool__c                                                            *
     * @Return      : List<Advisor_                                                               * 
     *********************************************************************************************/
     public static List<Advisor__c>  getAvailableAdvisors(advisorRequestWrapper arwObject){
        system.debug('#### Advisor Request Wrapper = '+arwObject);
        System.debug(' ######## PREFFERED LANGUAGE #### ' + arwObject.preferredLanguage);
        if(!String.isBlank(arwObject.preferredLanguage)) {
            return([SELECT Id, Advisor_Name__c, Advisor_Name__r.Name, Preferred_Language__c  
                FROM Advisor__c 
                WHERE Resource_Pool__c =: arwObject.ResourcePoolId AND Advisor_Name__r.IsActive = true AND
                      Preferred_Language__c includes (:arwObject.preferredLanguage)]);
        }
        return([SELECT Id, Advisor_Name__c, Advisor_Name__r.Name, Preferred_Language__c  
                FROM Advisor__c 
                WHERE Resource_Pool__c =: arwObject.ResourcePoolId AND Advisor_Name__r.IsActive = true]);
     }

     /*********************************************************************************************
     * @Description : Get advisor time slot map.                                                  *
     * @Params      : Map<String,List<Event>>, Map<Id, Set<String>>                               *
     * @Return      : Map<Id, Set<String>>                                                        * 
     *********************************************************************************************/  
     public static Map<Id, Set<String>> getAdvisorTimeSlotMap(gatsmParamWrapper gatsmParamWrapperObject){
        
        /* Unwrapping the wrapper class. */
        Map<String,List<Event>> TimeToEventsMap = gatsmParamWrapperObject.TimeToEventsMap;
        Map<Id, Set<String>> advisorTimeSlotMap = gatsmParamWrapperObject.advisorTimeSlotMap;
        Map<Id,Set<Id>> eventInviteeMap = gatsmParamWrapperObject.eventInviteeMap;
        String selectedTime = gatsmParamWrapperObject.selectedTime;
        
        system.debug('#### Code @ getAdvisorTimeSlotMap - TimeToEventsMap - '+TimeToEventsMap);
        system.debug('#### Code @ getAdvisorTimeSlotMap - advisorTimeSlotMap - '+advisorTimeSlotMap);
        system.debug('#### Code @ getAdvisorTimeSlotMap - eventInviteeMap - '+eventInviteeMap);
        
        if(TimeToEventsMap != null){
            for(String thisRecord : TimeToEventsMap.keySet()){
                 /* The below if condition has a special function. 
                This has been used to reduce the time taken by the code to calculate the available timeslots.
                It was found that, to check for the concurrency of scheduling an event, this method was called
                again to, verify if any event has not been scheduled from back or from other system. On more analysis
                we could see that there was no need to traverse through all the events, but only those events that come
                under the selected time slots. #cpuTimeLimitException
             */
                 if((selectedTime != null && selectedTime.equalsIgnoreCase(thisRecord)) || String.isBlank(selectedTime)){
                    for(Event thisEvent : TimeToEventsMap.get(thisRecord)){
                        if(advisorTimeSlotMap != null && advisorTimeSlotMap.size() > 0 && advisorTimeSlotMap.get(thisEvent.OwnerId) != null &&  
                           advisorTimeSlotMap.get(thisEvent.OwnerId).contains(thisRecord)){
                            advisorTimeSlotMap.get(thisEvent.OwnerId).remove(thisRecord);
                        }
                        if(eventInviteeMap != null && eventInviteeMap.get(thisEvent.Id) != null){
                            system.debug('#### invitee event - '+eventInviteeMap.get(thisEvent.Id));
                            for(Id thisId : eventInviteeMap.get(thisEvent.Id)){ 
                                if(advisorTimeSlotMap.get(thisId) != null && advisorTimeSlotMap.get(thisId).contains(thisRecord)){
                                    advisorTimeSlotMap.get(thisId).remove(thisRecord);                              
                                }
                            }
                        }  
                    }
                }
            }
        }
        return advisorTimeSlotMap;      
     }
     
     /*********************************************************************************************
     * @Description : Get available time slot.                                                    *
     * @Params      : TimeAdvisorMapWrapper, Map<String,List<Event>>                              *
     * @Return      : List<String>                                                                * 
     *********************************************************************************************/ 
     public static List<String> getAvailableTimeSlots(gatsParamWrapper gatsParamWrapperObject){
        
        /* Unwrapping the wrapper parameter. */
        TimeAdvisorMapWrapper tamwObject = gatsParamWrapperObject.tamwObject;
        Map<String,List<Event>> TimeToEventsMap = gatsParamWrapperObject.TimeToEventsMap;
        Resource_Pool__c dAdmin = gatsParamWrapperObject.dAdmin;
        String selectedTime = gatsParamWrapperObject.selectedTime;
        
        /* Map contains TimeSlots,No. of Slots */
        Map<String,Integer> numberOfSlotsforTime =  new Map<String,Integer>();
        /* Map contains a copy of timeSlot, Set of advisor's Id*/
        Map<String,Set<Id>> timeSlotAdvisorMap = new Map<String,Set<Id>>();
        /* Set contains the final avaiable times. */
        Set<String> FinalAvailableTimes = new Set<String>();
        
        List<String> ltimeSlot = new List<String>();
        if(tamwObject != null && tamwObject.timeSlotAdvisorMap != null && tamwObject.timeSlotAdvisorMap.keyset() != null){
            
            system.debug('#### TimeToEventsMap - '+TimeToEventsMap);
            system.debug('#### advisorTimeSlotMap - '+tamwObject.advisorTimeSlotMap);
            system.debug('#### timeSlotAdvisorMap - '+tamwObject.timeSlotAdvisorMap);
        
            ltimeSlot.addAll(tamwObject.timeSlotAdvisorMap.keyset());
            ltimeSlot.sort();
            
            timeSlotAdvisorMap = tamwObject.timeSlotAdvisorMap;
            FinalAvailableTimes = (tamwObject == null && tamwObject.timeSlotAdvisorMap == null ? new Set<String>() : tamwObject.timeSlotAdvisorMap.keyset());
        }
        
        /*Calculating the No. of appointment slots available or booked as per the advisor availability */
        for(String timeSlot : ltimeSlot){ 
            /* The below if condition has a special function. 
              This has been used to reduce the time taken by the code to calculate the available timeslots.
              It was found that, to check for the concurrency of scheduling an event, this method was called
              again to, verify if any event has not been scheduled from back or from other system. On more analysis
              we could see that there was no need to traverse through all the events, but only those events that come
              under the selected time slots. #cpuTimeLimitException 
           */
           system.debug('##### SELECTED TIME #### ' + selectedTime);
            if((selectedTime != null && selectedTime.equalsIgnoreCase(timeSlot)) || String.isBlank(selectedTime)){
                Integer slotsAvailable = 0;
                system.debug('##### TIMESLOT TO TIME #### ' + TimeToEventsMap.get(timeSlot) + ', TIME = ' + timeSlot);
                system.debug('##### TIMESLOT TO TIME #### ' + TimeToEventsMap);
                if( timeSlot != null && TimeToEventsMap != null && TimeToEventsMap.size() > 0 && TimeToEventsMap.get(timeSlot) != null){
                    for(Event thisEvent : TimeToEventsMap.get(timeSlot)){
                        if( thisEvent.Appointment_Source__c != null && thisEvent.Appointment_Source__c.equalsIgnoreCase('Calendar') &&
                            timeSlotAdvisorMap != null && timeSlotAdvisorMap.size() > 0 && timeSlotAdvisorMap.get(timeSlot) != null &&  
                            timeSlotAdvisorMap.get(timeSlot).contains(thisEvent.OwnerId)){
                            
                            system.debug('#### Event Calculation : Advisor Personal Calendar Event - '+thisEvent);
                            slotsAvailable++;
                            numberOfSlotsforTime.put(timeSlot,slotsAvailable);
                            system.debug('#### Latest Slot Available 1111- '+timeSlot+' == '+slotsAvailable);
                            /*
                            if(timeSlotAdvisorMap != null && timeSlotAdvisorMap.size() > 0 && timeSlotAdvisorMap.get(timeSlot) != null &&  
                               timeSlotAdvisorMap.get(timeSlot).contains(thisEvent.OwnerId)){
                                timeSlotAdvisorMap.get(timeSlot).remove(thisEvent.OwnerId);
                            }
                            */
                        }
                        if(thisEvent.Appointment_Source__c != null && 
                           thisEvent.Appointment_Source__c.equalsIgnoreCase('Calendar') && 
                           thisEvent.OwnerId == dAdmin.Dispatch_Admin__c && !(timeSlotAdvisorMap != null && timeSlotAdvisorMap.size() > 0 && timeSlotAdvisorMap.get(timeSlot) != null &&  
                            timeSlotAdvisorMap.get(timeSlot).contains(thisEvent.OwnerId))){
                            system.debug('#### Event Calculation : Dispatch Admin Personal Calendar Event - '+thisEvent);
                            slotsAvailable++;
                            numberOfSlotsforTime.put(timeSlot,slotsAvailable);
                            system.debug('#### Latest Slot Available 2222- '+timeSlot+' == '+slotsAvailable);
                        }
                        if(thisEvent.Appointment_Source__c != null && !thisEvent.Appointment_Source__c.equalsIgnoreCase('Calendar')){
                            system.debug('#### Event Calculation : Non Calendar Event - '+thisEvent);
                            slotsAvailable++;
                            numberOfSlotsforTime.put(timeSlot,slotsAvailable);
                            system.debug('#### Latest Slot Available 3333- '+timeSlot+' == '+slotsAvailable);
                        }
                    } 
                }   
            system.debug('#### Latest Slot Available - '+timeSlot+' == '+slotsAvailable);
            }
        }
        
        system.debug('#### Advisor per Time Slot Map - '+timeSlotAdvisorMap);
        /*  
        for(String thisRecord : timeSlotAdvisorMap.keySet()){
            if(thisRecord == '15:00'){
                system.debug('#### Advisors for time = '+thisRecord+' are = '+timeSlotAdvisorMap.get(thisRecord));
            }
        }
        */
        system.debug('#### Slots Available per Time Map - '+numberOfSlotsforTime);
        /*
        for(String thisRecord : numberOfSlotsforTime.keySet()){
            if(thisRecord == '15:00'){
                system.debug('#### Time Slots for time = '+thisRecord+' are = '+numberOfSlotsforTime.get(thisRecord));
            }
        }
        */
        
        /* Criteria for deciding the number of appointment, you can book for a particular time slot, 
               We check if the number of events related to a particular time slot is '>=' to the 
               number of advisors available for that particular time slots. 
                    - TimeToEventsMap = (TimeSlot <-> Events)
                    - advTimeSlot = (TimeSlot <-> Advisors) */ 
        system.debug('######## TIMESLOT LIST ##### ' + ltimeSlot);
        system.debug('######## numberOfSlotsforTime LIST ##### ' + numberOfSlotsforTime);
        system.debug('######## TIMESLOT LIST ##### ' + timeSlotAdvisorMap);
        for(String timeSlot : ltimeSlot){                       
            if( !(numberOfSlotsforTime.isEmpty()) && timeSlot != null && timeSlotAdvisorMap != null && timeSlotAdvisorMap.size() > 0 &&
                  numberOfSlotsforTime.get(timeSlot) != null && timeSlotAdvisorMap.get(timeSlot) != null && FinalAvailableTimes != null && 
                  FinalAvailableTimes.contains(timeSlot)){
                        
                /*Comparing the number of slots booked vs. the number of advisors for that time slot, 
                  to decide the availability of a time slot.*/
                if(numberOfSlotsforTime.get(timeSlot) >= (timeSlotAdvisorMap.get(timeSlot).size())){
                    system.debug('#### Time slot to remove - '+timeSlot);                           
                    FinalAvailableTimes.remove(timeSlot);  
                    //system.debug('#### timeSlotAdvisorMap - '+timeSlotAdvisorMap);              
                }
            }
        }
        system.debug('#### FinalAvailableTimes - '+FinalAvailableTimes);  
        list<String> avTime = new List<String>();
        avTime.addAll(FinalAvailableTimes);            
        avTime.sort();  
        
        return avTime;
     }
    
     /*********************************************************************************************
     * @Description : Filter time slots.                                                          *
     * @Params      : TimeAdvisorMapWrapper, List<Event>, Date                                    *
     * @Return      : Map<String,List<Event>>                                                     * 
     *********************************************************************************************/  
     public static Map<String,List<Event>> filterTimeSlots(TimeAdvisorMapWrapper tamwObject,List<Event> listCombinedEvents, Date dateCon, RequestParameterWrapper rpwObject){
        
        system.debug('#### Code @ filterTimeSlots - Time Advisor Wrapper Object - '+tamwObject);
        system.debug('#### Code @ filterTimeSlots - List of Events - '+listCombinedEvents);
        system.debug('#### Code @ filterTimeSlots - Date - '+dateCon);
        system.debug('#### Code @ filterTimeSlots - Requested Parameter - '+rpwObject);
        
        DateTime requestedStartDateTime = Datetime.newInstance(dateCon.year(), dateCon.month(),dateCon.day()+1, 00, 00, 00);
        // Map contains Time - Event Map.
        Map<String,List<Event>> TimeToEventsMap = new Map<String,List<Event>>();
        
        if(tamwObject != null && tamwObject.timeSlotAdvisorMap != null){
            // Adding records to the Map<Timeslot,Event List> to remove for duplicate time slots
            List<String> ltimeSlot = new list<String>();
            ltimeSlot.addAll(tamwObject.timeSlotAdvisorMap.keyset());
            ltimeSlot.sort();
            
            for(String timeSlot : ltimeSlot){
                system.debug('timeSlot under Filtermethods - '+timeSlot);
                /*Decimal tSlot = 0;
                if(!timeSlot.equalsIgnoreCase('00:00')){
                    tSlot = Decimal.valueOf(timeSlot.substring(0,2)) + (Decimal.valueOf(timeSlot.substring(3,5))/60);
                }*/
                
                If(gmtZeroTimeZoneSet.contains(String.valueOf(UserInfo.getTimeZone()))){
                    //Decimal difference = getOffsetValue('GMT',rpwObject.timeZone);
                    ////timeSlot = convertToString(converToDecimal(timeSlot)+difference);
                }
                system.debug('timeSlot after Conversion - '+timeSlot);
                            
                Decimal tSlot = Decimal.valueOf(timeSlot.substring(0,2)) + (Decimal.valueOf(timeSlot.substring(3,5))/60);
                
                tSlot = (tSlot == 24.0) ? 0.0 : tSlot;
                system.debug('####su time slot - '+tSlot); 
    
                for(Event thisEvent : listCombinedEvents){  
                    system.debug(timeSlot + ' thisEvent inside filterTome ----> '+thisEvent);
                    Decimal difference = getOffsetValue(rpwObject.timeZone,'GMT');
                    /*Decimal differenceGMTtoDenver = getOffsetValue('America/Denver','GMT');
                    Decimal differenceGMTtoLos = getOffsetValue('America/Los_Angeles','GMT');
                    if(rpwObject.timeZone.contains('America/Denver')){
                        thisEvent.StartDateTime = thisEvent.StartDateTime.addHours(Integer.ValueOf(differenceGMTtoDenver));
                        system.debug('#### (thisEvent.StartDateTime===== Denver-->  '+thisEvent.StartDateTime);
                        thisEvent.EndDateTime = thisEvent.EndDateTime.addHours(Integer.ValueOf(differenceGMTtoDenver));
                        system.debug('#### thisEvent.EndDateTime Denver========>  '+thisEvent.EndDateTime);
                    }
                    if(rpwObject.timeZone.contains('America/Los_Angeles')){
                        thisEvent.StartDateTime = thisEvent.StartDateTime.addHours(Integer.ValueOf(differenceGMTtoLos));
                        system.debug('#### (thisEvent.StartDateTime===== Los-->  '+thisEvent.StartDateTime);
                        thisEvent.EndDateTime = thisEvent.EndDateTime.addHours(Integer.ValueOf(differenceGMTtoLos));
                        system.debug('#### thisEvent.EndDateTime Los========>  '+thisEvent.EndDateTime);
                    }*/
                    thisEvent.StartDateTime = thisEvent.StartDateTime.addHours(Integer.ValueOf(difference));
                    thisEvent.EndDateTime = thisEvent.EndDateTime.addHours(Integer.ValueOf(difference));
                    system.debug('#### (thisEvent.StartDateTime).dateTime Only() - '+thisEvent.StartDateTime);
                    system.debug('#### (thisEvent.EndDateTime).dateTime Only() - '+thisEvent.EndDateTime);
                    Decimal stDecimal = 0;
                    Decimal etDecimal = 0;
                    /* If the time requested date falls between the start date & end date, 
                         then the start time = 00:00 & end time  = 24:00 */
                    //if((thisEvent.StartDateTime).date() < dateCon && dateCon < (thisEvent.EndDateTime).date()){
                    if((thisEvent.StartDateTime).dateGMT() < dateCon && dateCon < (thisEvent.EndDateTime).dateGMT()){
                        stDecimal = 0;
                        etDecimal = 24;
                        system.debug('#### 1');
                    }
                    /* If the requested date falls on the start date but is less than end date,
                         then the start time = starttime & end time = 24:00 */
                    //if((thisEvent.StartDateTime).date() <= dateCon && dateCon < (thisEvent.EndDateTime).date()){
                    if((thisEvent.StartDateTime).dateGMT() <= dateCon && dateCon < (thisEvent.EndDateTime).dateGMT()){
                        //If(gmtZeroTimeZoneSet.contains(String.valueOf(UserInfo.getTimeZone()))){
                            stDecimal = thisEvent.IsAllDayEvent != true ? Decimal.valueOf(String.valueOf(thisEvent.StartDateTime.timeGmt()).substring(0,2)) + 
                                        (Decimal.valueOf(String.valueOf(thisEvent.StartDateTime.timeGmt()).substring(3,5))/60) : 0;
                        etDecimal = 24;
                        system.debug('#### 2');
                    }
                    /* If the requested date falls on the end date but is greater than start date,
                         then the start time = 00:00 & end time = end time */
                    //if((thisEvent.StartDateTime).date() < dateCon && dateCon <= (thisEvent.EndDateTime).date()){
                    if((thisEvent.StartDateTime).dateGMT() < dateCon && dateCon <= (thisEvent.EndDateTime).dateGMT()){
                        stDecimal = 0;
                        //If(gmtZeroTimeZoneSet.contains(String.valueOf(UserInfo.getTimeZone()))){
                            etDecimal = thisEvent.IsAllDayEvent != true ? Decimal.valueOf(String.valueOf(thisEvent.EndDateTime.timeGmt()).substring(0,2)) + 
                                        (Decimal.valueOf(String.valueOf(thisEvent.EndDateTime.timeGmt()).substring(3,5))/60) : 24;
                       system.debug('#### 3');
                    }
                    /* If the startdate and enddate are same.. i.e., one day event */
                    //if((thisEvent.StartDateTime).date() == dateCon && dateCon == (thisEvent.EndDateTime).date()){
                    if((thisEvent.StartDateTime).dateGMT() == dateCon && dateCon == (thisEvent.EndDateTime).dateGMT()){
                        //If(gmtZeroTimeZoneSet.contains(String.valueOf(UserInfo.getTimeZone()))){
                            stDecimal = thisEvent.IsAllDayEvent != true ? Decimal.valueOf(String.valueOf(thisEvent.StartDateTime.timeGmt()).substring(0,2)) + 
                                        (Decimal.valueOf(String.valueOf(thisEvent.StartDateTime.timeGmt()).substring(3,5))/60) : 0;
                                        
                            system.debug(tSlot + ' =tSlot ==>'+'stDecimal===>'+stDecimal);
                            
                            etDecimal = thisEvent.IsAllDayEvent != true ? Decimal.valueOf(String.valueOf(thisEvent.EndDateTime.timeGmt()).substring(0,2)) + 
                                        (Decimal.valueOf(String.valueOf(thisEvent.EndDateTime.timeGmt()).substring(3,5))/60) : 24;
                             system.debug(tSlot + ' =tSlot ==>'+'etDecimal===>'+etDecimal);
                                        
                        system.debug('#### 4');
                        system.debug('#### Event StartDateTime - '+(thisEvent.StartDateTime.time()));
                        system.debug('#### Decimal.valueOf(String.valueOf(thisEvent.StartDateTime.time()).substring(0,2)) - '+Decimal.valueOf(String.valueOf(thisEvent.StartDateTime.timeGmt()).substring(0,2)));
                        system.debug('#### Decimal.valueOf(String.valueOf(thisEvent.StartDateTime.time()).substring(3,5))/60 - '+Decimal.valueOf(String.valueOf(thisEvent.StartDateTime.timeGmt()).substring(3,5))/60);
                        system.debug('#### Event EndDateTime - '+(thisEvent.EndDateTime.time()));
                        
                        system.debug('#### Decimal.valueOf(String.valueOf(thisEvent.EndDateTime.time()).substring(0,2)) - '+(Decimal.valueOf(String.valueOf(thisEvent.EndDateTime.timeGmt()).substring(0,2))));
                        
                        system.debug('#### Decimal.valueOf(String.valueOf(thisEvent.EndDateTime.time()).substring(3,5))/60 - '+(Decimal.valueOf(String.valueOf(thisEvent.EndDateTime.timeGmt()).substring(3,5))/60));
                    }
                    
                    /* Adding special consideration for BT Time Zone. */
                    if(thisEvent.StartDateTime == requestedStartDateTime){
                        stDecimal = 0.0;
                        etDecimal = 1.0;    
                    }
                    system.debug('####su start time slot - '+stDecimal);                   
                    system.debug('####su end time slot - '+etDecimal);  
                    
                    system.debug('#### timeslot Condition Match - '+tSlot +' >= '+stDecimal + ' < ' +etDecimal);  
    
                    // logic to check if the time slot or the appointment length lies between the scheduled event time                                          
                    if((tSlot >= stDecimal && tSlot < etDecimal) || (tSlot <= stDecimal && tSlot+Decimal.valueOf(rpwObject.appointmentLength)/60 > stDecimal)){
                    //if(tSlot >= stDecimal && tSlot < etDecimal ){
                            system.debug('#### time slot to remove - '+timeSlot);  
                            if(TimeToEventsMap.get(timeSlot)!=null){
                                TimeToEventsMap.get(timeSlot).add(thisEvent);
                            }
                            else{
                                TimeToEventsMap.put(timeSlot,new List<Event>{thisEvent});   
                            }                         
                    }
                    
                    system.debug('#### Time To Events Map Inside- '+TimeToEventsMap);
                    /*if(rpwObject.timeZone.contains('America/Denver')){
                        thisEvent.StartDateTime = thisEvent.StartDateTime.addHours(-(Integer.ValueOf(differenceGMTtoDenver)));
                        system.debug('#### (thisEvent.StartDateTime Denver=====>  '+thisEvent.StartDateTime);
                        thisEvent.EndDateTime = thisEvent.EndDateTime.addHours(-(Integer.ValueOf(differenceGMTtoDenver)));
                        system.debug('#### thisEvent.EndDateTime Denver========>  '+thisEvent.EndDateTime);
                    }
                    if(rpwObject.timeZone.contains('America/Los_Angeles')){
                        thisEvent.StartDateTime = thisEvent.StartDateTime.addHours(-(Integer.ValueOf(differenceGMTtoLos)));
                        system.debug('#### (thisEvent.StartDateTime===== Los-->  '+thisEvent.StartDateTime);
                        thisEvent.EndDateTime = thisEvent.EndDateTime.addHours(-(Integer.ValueOf(differenceGMTtoLos)));
                        system.debug('#### thisEvent.EndDateTime Los========>  '+thisEvent.EndDateTime);
                    }*/
                    thisEvent.StartDateTime = thisEvent.StartDateTime.addHours(-Integer.ValueOf(difference));
                    thisEvent.EndDateTime = thisEvent.EndDateTime.addHours(-Integer.ValueOf(difference));   
                } 
                
                                                                                            
            }   
        } 
        system.debug('#### Time To Events Map - '+TimeToEventsMap);
        return TimeToEventsMap;
     }
    
     /*********************************************************************************************
     * @Description : Method to fetch all types of events.                                        *
     * @Params      : Date, List<Id>                                                              *
     * @Return      : EventDetailsWrapper                                                         * 
     *********************************************************************************************/ 
     //public static EventDetailsWrapper fetchAllTypesOfEvents(Date dateCon, List<Id> ResourcesId){
       public static EventDetailsWrapper fetchAllTypesOfEvents(Date dateCon, List<Id> ResourcesId, String PreferredLanguage){ 
        // Contains map of event, users invited to the events.
        Map<Id,Set<Id>> eventInviteeMap = new Map<Id,Set<Id>>(); 
        // Contains finals List of Events.
        List<Event> listCombinedEvents =  new List<Event>();
        // Wrapper object for returning response.
        EventDetailsWrapper edwObject =  new EventDetailsWrapper();
        
        DateTime requestedStartDateTime = Datetime.newInstance(dateCon.year(), dateCon.month(),dateCon.day()+1, 00, 00, 00);
        DateTime requestedEndDateTime = Datetime.newInstance(dateCon.year(), dateCon.month(),dateCon.day()+1, 02, 00, 00);
        /* Fetching list of all events associated to resource pool and advisors,
         and store start time and end time of all the available event. */
        //dateCon = requestedStartDateTime.Date();
        List<Event> listRespAdvEvent = new List<Event>();
        Set<Event> setRespAdvEvent = new Set<Event>();
        Set<Id> setEventId = new Set<Id>();
        listRespAdvEvent = [SELECT Id,StartDateTime,EndDateTime,IsAllDayEvent,OwnerId,Appointment_Source__c
                            FROM Event 
                            WHERE (Implementation_Status__c !='Canceled') AND OwnerId IN :ResourcesId AND Preferred_Language__C =:PreferredLanguage 
                                    AND IsChild != true AND
                                    ((StartDateTime <=: requestedStartDateTime AND EndDateTime >=: dateCon) OR ActivityDate =: dateCon)   
                            ORDER BY LastModifiedDate Desc];
        setRespAdvEvent.addAll(listRespAdvEvent);
        
        for(Event ev : listRespAdvEvent){
            setEventId.add(ev.Id);
        }

        /* Logic to fetch advisors invited to a implementation event, and have accepted it.
           This would count the advisor as booked. Hence blocking the time slot for that 
           particular advisor. */
        List<String> listInviteeEventId = new List<String>();
        for(EventRelation thisEventRelation : [SELECT EventId,Id,RelationId,Status FROM EventRelation 
                                               //WHERE RelationId IN: ResourcesId AND Status != 'Declined']){
                                               WHERE EventId IN: setEventId AND Status != 'Declined']){
            listInviteeEventId.add(thisEventRelation.EventId);
            if(eventInviteeMap.get(thisEventRelation.EventId) != null)
                eventInviteeMap.get(thisEventRelation.EventId).add(thisEventRelation.RelationId);
            else
                eventInviteeMap.put(thisEventRelation.EventId,new Set<Id>{thisEventRelation.RelationId});
        }

        //Fetching event details for child events and filtering out the event already fetched for recource pool or advisors.
        List<Event> inviteeEvents = new List<Event>();
        if(listInviteeEventId.size() > 0){
            inviteeEvents = [ SELECT Id,StartDateTime,EndDateTime,IsAllDayEvent,OwnerId,Appointment_Source__c 
                              FROM Event 
                              WHERE (Id IN :listInviteeEventId AND Implementation_Status__c !='Canceled') AND Preferred_Language__C =:PreferredLanguage
                                     AND ((StartDateTime <=: requestedStartDateTime AND EndDateTime >=: dateCon) OR ActivityDate =: dateCon) 
                                     AND IsChild != true 
                              ORDER BY LastModifiedDate Desc];
            // Removing events already fetched initially to avoid duplicacy.                  
            for(Event thisEvent : inviteeEvents){
                setRespAdvEvent.remove(thisEvent);
            }
            // Adding all child events,invitee events to the main events list.
            if(inviteeEvents.size() > 0){
                listCombinedEvents.addAll(inviteeEvents);
            }
        }
        // Adding ressource pool and advisors events to the main events list. 
        if(setRespAdvEvent.size() > 0){
            listCombinedEvents.addAll(setRespAdvEvent);
        }
        
        edwObject.eventList = listCombinedEvents;
        edwObject.eventInviteeMap = eventInviteeMap;
        return edwObject;
     }
    
    /*********************************************************************************************
     * @Description : Method to fetch all types of events.                                        *
     * @Params      : Date, List<Id>                                                              *
     * @Return      : EventDetailsWrapper                                                         * 
     *********************************************************************************************/ 
     public static EventDetailsWrapper fetchEventsSpecific(fesParamWrapper fpw){
        
        Integer appointmentLength = Integer.valueOf(fpw.appointmentLength)/60;
        system.debug('#### Appointment Length = '+fpw.appointmentLength);
        system.debug('#### Start Date Time = '+fpw.selectedDateTime);
        system.debug('#### End Date Time = '+fpw.selectedDateTime.addHours(appointmentLength));
        // Wrapper object for returning response.
        EventDetailsWrapper edwObject =  new EventDetailsWrapper();
        /* Fetching list of all events associated to resource pool and advisors, for selected date-time. */
        List<Event> listRespAdvEvent = new List<Event>();
        listRespAdvEvent = [SELECT Id,StartDateTime,EndDateTime,IsAllDayEvent,OwnerId,Appointment_Source__c
                            FROM Event 
                            WHERE (Implementation_Status__c !='Canceled') AND OwnerId IN : fpw.ResourcesId AND IsChild != true AND
                                    //(StartDateTime =: fpw.selectedDateTime AND EndDateTime =: fpw.selectedDateTime.addHours(appointmentLength))
                                    (StartDateTime =: fpw.selectedDateTime or (StartDateTime <: fpw.selectedDateTime AND EndDateTime >: fpw.selectedDateTime))// or (EndDateTime >: fpw.selectedDateTime AND EndDateTime <=: fpw.selectedDateTime.addHours(appointmentLength)))//AND EndDateTime =: fpw.selectedDateTime.addHours(appointmentLength))   
                            ORDER BY LastModifiedDate Desc];    
        edwObject.eventList = listRespAdvEvent;
        
        set<Id> eventIds = new set<Id>();
        for(Event ev : listRespAdvEvent){
            eventIds.add(ev.Id);
        }
        Map<Id,Set<Id>> eventInviteeMap = new Map<Id,Set<Id>>();
        for(EventRelation thisEventRelation : [SELECT EventId,Id,RelationId,Status FROM EventRelation 
                                               WHERE EventId IN: eventIds AND Status != 'Declined']){
            
            if(eventInviteeMap.get(thisEventRelation.EventId) != null)
                eventInviteeMap.get(thisEventRelation.EventId).add(thisEventRelation.RelationId);
            else
                eventInviteeMap.put(thisEventRelation.EventId,new Set<Id>{thisEventRelation.RelationId});
        }
        
        edwObject.eventInviteeMap = eventInviteeMap;
        
        
        return edwObject;
     }
      
    /**************************************************************************************************
    * @Desciription : Method to invite Users to Event.                                                *
    * @Params       : Event, String                                                                   *
    * @Return       : void                                                                            * 
    **************************************************************************************************/
    public static void inviteAdvisor(Event eventRecord, String selectedAdvisor){
        
        Database.DMLOptions dlo = new Database.DmlOptions();
        dlo.EmailHeader.triggerOtherEmail = true;
        dlo.EmailHeader.triggerUserEmail = true;
        
        if(!String.isBlank(selectedAdvisor) && eventRecord != null){
            EventRelation inviteeObject =  new EventRelation(EventId = eventRecord.Id, RelationId = selectedAdvisor);
            //Insert the attendees using database.insert(attendees list, dmlOption);
            database.insert(inviteeObject, dlo);
        }
    }
    
    /**************************************************************************************************
    * @Desciription : Method to parse time slot list.                                                 *
    * @Params       : List<Time__c>, Decimal                                                          *
    * @Return       : Map<Decimal, Decimal>                                                           * 
    **************************************************************************************************/
    public static Map<Decimal, Decimal> parsingEvents(List<Time__c> availableTimeRecords, Decimal strOffsetHoursDiff){
        
        // SET = Start End Time.
        Map<Decimal, Decimal> SETMap = new Map<Decimal, Decimal>();
        Set<Decimal> startTimeSet = new Set<Decimal>();
        List<Decimal> startTimeList =  new List<Decimal>();
        Map<Decimal, Decimal> combinedSETMap = new Map<Decimal, Decimal>();
        
        Decimal startTimeKeyStorage;
        
        for(Time__c thisRecord : availableTimeRecords){
            Decimal startTime  = Decimal.valueOf(thisRecord.Start_Time__c.substring(0,2)) + (Decimal.valueOf(thisRecord.Start_Time__c.substring(3,5))/60);
            startTime = startTime + strOffsetHoursDiff; 
            system.debug('#### Start Time in TimeSlots - '+startTime); 
            Decimal endTime  = Decimal.valueOf(thisRecord.End_Time__c.substring(0,2)) + (Decimal.valueOf(thisRecord.End_Time__c.substring(3,5))/60);
            endTime = endTime + strOffsetHoursDiff;
            system.debug('#### End Time in TimeSlots - '+endTime); 
            
            SETMap.put(startTime,endTime);  
            startTimeSet.add(startTime);
        }
        
        startTimeList.addAll(startTimeSet);
        startTimeList.sort();
        system.debug('#### startTimeList - '+startTimeList);
        system.debug('#### SETMap - '+SETMap);
        for(Decimal thisRecord : startTimeList){
            if(startTimeKeyStorage != null && combinedSETMap != null && SETMap != null && 
                (combinedSETMap.get(startTimeKeyStorage) == thisRecord)){
                combinedSETMap.put(startTimeKeyStorage, SETMap.get(thisRecord));        
            }else{
                startTimeKeyStorage = thisRecord;   
                combinedSETMap.put(thisRecord, SETMap.get(thisRecord));
            }       
        }
        
        system.debug('#### Combined Start and End Time Map - '+combinedSETMap);
        return combinedSETMap;  
    }
     
    /**************************************************************************************************
    * @Desciription : Convert Time Slots to respective Time Slots.                                    *
    * @Params       : timeZoneWrapper                                                                 *
    * @Return       :                                                                                 * 
    **************************************************************************************************/
    public static List<String> convertToTimeZone(timeZoneWrapper tzwObject){
        system.debug('#### tzwObject - Time Slots = '+tzwObject.timeSlots);
        system.debug('#### tzwObject - Time Zone = '+tzwObject.timeZone);
        List<String> timeZoneSlots = new List<String>();
        Decimal offsetHoursDiff = 0;
        if(tzwObject != null && tzwObject.timeSlots != null && tzwObject.timeSlots.size() > 0){
            for(String thisRecord : tzwObject.timeSlots){
                
                timeZoneSlots.add(convertToString(converToDecimal(thisRecord)+offsetHoursDiff));        
            }   
        }
        
        return timeZoneSlots;
    }
    
    /**************************************************************************************************
    * @Desciription : Get Offset value. (Hour difference between PDT and ased timezone)               *
    * @Params       : String                                                                          *
    * @Return       : Decimal                                                                         * 
    **************************************************************************************************/
    public static Decimal getOffsetValue(String baseTimeZone, String timeZone){
        String strOffsetRequested = System.now().format('Z',timeZone);
        system.debug('#### Weird 111111----> = '+strOffsetRequested);
        String strOffsetRequestedHours = strOffsetRequested.substring(0,3);
        system.debug('#### Weird 22222-----> = '+strOffsetRequestedHours);
        String strOffsetLoggedInUser = System.now().format('Z', baseTimeZone);
        system.debug('#### Weird 33333-----> = '+strOffsetLoggedInUser);
        String strOffsetLoggedInUserHours = strOffsetLoggedInUser.substring(0,3);
        system.debug('#### Weird 55555-----> = '+strOffsetLoggedInUserHours);
        //String strOffsetPST = System.now().format('Z','America/Los_Angeles');
        //String strOffsetHoursPST = strOffsetPST.substring(0,3);
        Decimal offsetHoursDiff = Decimal.valueOf(strOffsetLoggedInUserHours) - Decimal.valueOf(strOffsetRequestedHours);   
         system.debug('#### offsetHoursDiff 55555-----> = '+offsetHoursDiff);
        return offsetHoursDiff;
    }
     
     /*********************************************************************************************
     * @Description : Wrapper class for storing available time slots and available advisors.      *
     *********************************************************************************************/
     public class TimeAdvisorWrapper{
        public List<String> availableTimeSlots;
        public Map<Id,Set<String>> availableAdvisors;
        public Map<String, Set<Id>> timeSlotAdvisorMap;

        public timeAdvisorWrapper(){
            availableTimeSlots = new List<String>();
            availableAdvisors = new Map<Id,Set<String>>();
            timeSlotAdvisorMap = new Map<String, Set<Id>>();     
        }
     }
     
     /*********************************************************************************************
     * @Description : Wrapper class for Map<String,Set<Id>>, Map<Id,Set<String>>.                 *
     *********************************************************************************************/
     public class TimeAdvisorMapWrapper{
        public Map<Id, Set<String>> advisorTimeSlotMap;
        public Map<String, Set<Id>> timeSlotAdvisorMap;
        
        public timeAdvisorMapWrapper(){
            advisorTimeSlotMap = new Map<Id, Set<String>>();
            timeSlotAdvisorMap = new Map<String, Set<Id>>();    
        }
     }
     
     /*********************************************************************************************
     * @Description : Wrapper class for availableTimeSlot request parameter.                      *
     *********************************************************************************************/
     public class RequestParameterWrapper{
        public String BrandId;
        public String appointmentDate;
        public String appointmentLength;
        public String eventType;
        public String selectedAdvisor;
        public String preferredLanguage;
        public String timeZone;
        public Boolean premiumSupport;
        public Integer NumberOfUsers;
        public String selectedTime;
     }
     
     /*********************************************************************************************
     * @Description : Wrapper class for eventDetails                                              *
     *********************************************************************************************/
     public class EventDetailsWrapper{
        public List<Event> eventList;
        public Map<Id,Set<Id>> eventInviteeMap; 
        
        public eventDetailsWrapper(){
            eventList = new List<Event>();
            eventInviteeMap =  new Map<Id, Set<Id>>();   
        }
     }
     
     /*********************************************************************************************
     * @Description : Wrapper class for timeZoneConversion                                        *
     *********************************************************************************************/
     public class timeZoneWrapper{
        public List<String> timeSlots;
        public String timeZone;
        
        public timeZoneWrapper(){ timeSlots = new List<String>(); } 
     }
     
     /*********************************************************************************************
     * @Description : Wrapper class for timeZoneConversion                                        *
     *********************************************************************************************/
     public class advisorRequestWrapper{
        public Id ResourcePoolId; 
        public String preferredLanguage;
        public String timeZone;
     }
     
     /*********************************************************************************************
     * @Description : Wrapper class for Advisor Time Wrapper                                      *
     *********************************************************************************************/
     public class advisorTimeWrapper{
        public String dayOfWeek;
        public String eventType;        
        public advisorRequestWrapper arwObject = new advisorRequestWrapper();
     }
     
      /*********************************************************************************************
     * @Description : Wrapper class for sending Email                                             *
     *********************************************************************************************/
     public class EmailWrapper{
        public Event eventRecord;
        public String emailType;
        public Boolean premiumSupport = false;
        public String timeZone;
     }
 
     /*********************************************************************************************
     * @Description : Wrapper class for getAdvisorTimeSlotMap parameters.                         *
     *********************************************************************************************/
     public class gatsmParamWrapper{
        public Map<String,List<Event>> TimeToEventsMap;
        public Map<Id, Set<String>> advisorTimeSlotMap; 
        public Map<Id,Set<Id>> eventInviteeMap; 
        public String selectedTime;
     }
   
     /*********************************************************************************************
     * @Description : Wrapper class for getAvailableTimeSlot parameters.                          *
     *********************************************************************************************/
     public class gatsParamWrapper{
        public TimeAdvisorMapWrapper tamwObject;
        public Map<String,List<Event>> TimeToEventsMap;
        public Resource_Pool__c dAdmin;
        public String selectedTime;
     }
     
     /*********************************************************************************************
     * @Description : Wrapper class for fetchEventsSpecific parameters.                           *
     *********************************************************************************************/
      public class fesParamWrapper{
        public DateTime selectedDateTime;
        public String appointmentLength; 
        public List<Id> ResourcesId = new List<Id>();
      }
      
    /*********************************************************************************************
    * @Description : Method to get template details.                                             *
    * @Params      : Id <templateId>                                                             *
    * @Return      : EmailTemplate                                                               *  
    *********************************************************************************************/   
     public static EmailTemplate getTemplateDetails(Id emailTemplateId){
        List<EmailTemplate> emailTemplateList;
        emailTemplateList = [SELECT Id, Body, Subject, HtmlValue FROM EmailTemplate WHERE Id =: emailTemplateId AND IsActive = true];
        
        return (emailTemplateList != null && emailTemplateList.size() > 0 ? emailTemplateList[0] : null);
     } 
     
    /*********************************************************************************************
    * @Description : Read the Events Object and send                                             *
    *                1.) Confirmation Email with ICS attachment                                  *
    *                2.) Cancellation External Email                                             *
    *                3.) Cancellation Internal Email to the Resource Pool.                       *
    * @Params      : Event, BrandId, Type                                                        *
    * @Return      : Boolean <True/False on success Email>                                       *  
    *********************************************************************************************/
    public static boolean sendEmail(EmailWrapper ewObject){
        
        // Declaring variables and resetting error
        system.debug('EmailWrapper at sendEmail-->'+ewObject);
        resetError();  
        Exception_And_Notification_History__c enhObject = new Exception_And_Notification_History__c();    
        Resource_Pool__c validResourcePool = new Resource_Pool__c();
        Event eventobj = ewObject != null ? ewObject.eventRecord : null;
        String emailType = ewObject != null ? ewObject.emailType : null;
        Boolean premiumSupport = ewObject != null ? ewObject.premiumSupport : false;
        
        if(eventobj != null && emailType != null){
            try{  
                // Fetching email tempgetValidEmailTemplatelate for a brand.
                //Id emailTemplateId = getValidEmailTemplate(eventobj.Brand__c,emailType, ewObject.);
                Id emailTemplateId = getValidEmailTemplate(eventobj.Brand__c,emailType,eventobj.Preferred_Language__c);
                system.debug('### emailTemplateId' + emailTemplateId);
                if(emailTemplateId == null){
                    setError('No email template configured for Brand Id - '+ eventobj.Brand__c);
                    return false;
                }   
                EmailTemplate emailTemplateObject = getTemplateDetails(emailTemplateId);
                if(emailTemplateObject == null){
                    setError('Configured email template for the brand '+eventobj.Brand__c+' doesn\'t exists.');
                    return false;
                }
                // Fetching OrgWideEmailAddressId form custom setting as per the brand.
                //schedulerConfiguration__c brand = getBrand(eventobj.Brand__c);
                schedulerConfiguration__c brand = getBrandsDetailsLanguage(eventobj.Brand__c, eventobj.Preferred_Language__c);
                if(brand != null && BrandOrgwideEmail__c.getInstance(brand.Name) != null){
                    fromAddress.Id = BrandOrgwideEmail__c.getInstance(brand.Name).OrgWideEmailId__c;
                    fromAddress = getOrgWideAddress(fromAddress.Id);
                    subject = BrandOrgwideEmail__c.getInstance(brand.Name).Subject__c;
                }
                /* Fetching valid resource pool for a brand depending on the number of users, 
                   to send out the Internal Cancellation Email. */      
                if(emailType.equalsIgnoreCase(CANCELLATION_INTERNAL)){
                    validResourcePool = getValidResourcePool(brand.Id, Integer.valueOf(eventobj.NumberofUser__c),premiumSupport,eventobj.Preferred_Language__c);  
                    // Checking for error in fetching the result                           
                    if(eventSchedulerUtility.hasError){                                
                        return false;
                    }
                }  
                
                //String templateBody = emailTemplateObject.Body;
                System.debug('~~~~~~~~~~~~~~~~~~~~~~~~~'+emailTemplateObject); 
                String templateBody = emailTemplateObject.HtmlValue;
                /* Logic to replace datetime,support number and event Id in email template - TEXT. */
                //system.debug('### email template'+templateBody+','+eventobj.StartDateTime +','+brand.Name+','+eventobj.Contact_Support__c+','+eventobj.Id+','+System.Userinfo.getTimeZone().toString()+'end.');
                //templateBody = templateBody.replace('#datetime#',(eventobj.StartDateTime).format(getDateFormat(brand.Name)+' K:mm a, z' ,System.Userinfo.getTimeZone().toString()));
                templateBody = templateBody.replace('#datetime#',(eventobj.StartDateTime).format(getDateFormat(brand.Name)+' h:mm a, z' ,ewObject.timeZone));
                templateBody = templateBody.replace('#supportnumber#', (String.isBlank(eventobj.Contact_Support__c) ? ' ' : eventobj.Contact_Support__c));
                templateBody = templateBody.replace('#eventid#', eventobj.Id); 
                templateBody = templateBody.replace('#firstName#', eventobj.First_Name__c);
                templateBody = templateBody.replace('#lastName#', eventobj.Last_Name__c);
                                        
                system.debug('#### Plain Text Body - '+templateBody);
                /* Logic to replace datetime in subject. */
                String templateSubject = emailTemplateObject.Subject;
                //templateSubject = templateSubject.replace('#datetime#',(eventobj.StartDateTime).format(getDateFormat(brand.Name)+' K:mm a, z' ,System.Userinfo.getTimeZone().toString()));
                templateSubject = templateSubject.replace('#datetime#',(eventobj.StartDateTime).format(getDateFormat(brand.Name)+' h:mm a, z' ,ewObject.timeZone));
                
                Schema.DescribeSObjectResult d = Schema.SObjectType.Exception_And_Notification_History__c;
                Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName(); 
                
                /* Setting the Exception And Notification History object to compose the email. */
                enhObject.Email_Body__c = templateBody;
                enhObject.Email_Subject__c = templateSubject;
                enhObject.Record_Id__c = eventobj.Id;
                enhObject.RecordTypeId = rtMapByName.get('Email Notification').getRecordTypeId();
                enhObject.Reply_To__c = emailType.equalsIgnoreCase(CANCELLATION_INTERNAL) ? validResourcePool.Resource_Pool_Email__c : eventobj.Customer_Email__c;
                enhObject.content_label_01__c = emailType;
                enhObject.content_label_02__c = brand.Name;
                
                enhObject.content_label_03__c = eventobj.First_Name__c+' '+eventobj.Last_Name__c;
                enhObject.Preferred_Language__c = eventobj.Preferred_Language__c;
                
                //enhObject.content_label_04__c = (eventobj.StartDateTime).format(getDateFormat(brand.Name)+' K:mm a, z' ,ewObject.timeZone);
                enhObject.content_label_04__c = (eventobj.StartDateTime).format(getDateFormat(brand.Name)+' h:mm a, z' ,ewObject.timeZone);
                
                //enhObject.content_label_04__c = String.valueOf(eventobj.StartDateTime)+' '+Timezone.getTimeZone(ewObject.timeZone);
                if(emailType.equalsIgnoreCase(CONFIRMATION)){
                    enhObject.Attachment__c = getiattachment(eventobj.First_Name__c,eventobj.Last_Name__c,eventobj.Customer_Email__c,eventobj);
                    //enhObject.ICS__c = getiattachment(eventobj.First_Name__c,eventobj.Last_Name__c,eventobj.Customer_Email__c,eventobj);
                }
                
                insert enhObject; 
                return true;
            }catch(Exception ex){
                system.debug('#### Error on line = '+ex.getLineNumber()+' message = '+ex.getMessage()); 
                setError(ex.getMessage());
            }
        }
        return false;
    }
    
   /**********************************************************************************************
    * @Desciription : Method to update owner field on associated Implementation record.           *
    *                 Initial Implementation Advisor will be the owner of the Implementation.     *
    * @Params       : Id                                                                          *
    * @Return       : void                                                                        *
    **********************************************************************************************/
    public static void updateImplementationOwner(Id initialAdvisor, String customerId){
      
      // Contains list of Implementation related to a Customer Id.
      List<Implementation__c> implementationList = new List<Implementation__c>();
      implementationList = getImplementation(customerId);
        // Updating Contact field on Implementation.
        if(implementationList != null){
            for(Implementation__c thisRecord : implementationList){
              system.debug('#### Implementation Record - '+thisRecord);
              system.debug('#### Implementation Record Owner - '+thisRecord.Owner.Name);
              system.debug('#### Implementation Record - '+thisRecord.Owner.Name.equalsIgnoreCase('RCSF Sync'));
              
                if(thisRecord.Owner != null && thisRecord.Owner.Name != null && 
                   thisRecord.Owner.Name.equalsIgnoreCase('RCSF Sync')){
                  thisRecord.OwnerId = initialAdvisor;
                  system.debug('#### Implementation New Owner Id - '+initialAdvisor);
                }  
            }
            try{
                update implementationList;
            }catch(Exception ex){
                system.debug('#### Error on line = '+ex.getLineNumber()+' message = '+ex.getMessage());
            }
        }
    }
    
    /**********************************************************************************************
    * @Description : Utility class to fetch contact details                                       *
    * @Params      : contact Id                                                                   *
    * @Return      : void                                                                         *
    **********************************************************************************************/
    public static List<Contact> getContact(String contactId){
      List<Contact> contactDetailsList = new List<Contact>();
        contactDetailsList = [ SELECT Id,Account_Brand__c,Account_Number_of_DLs__c,AccountId,FirstName,LastName,Email,Name,User_Id__c,
                       Account.RC_Brand__c,Account.Number_of_DL_s__c,Account.RC_User_ID__c,Account.Entitled_to_Premium_Support__c,
                       Account.Name
                       FROM Contact
                       WHERE Id =: contactId.trim()];
    return contactDetailsList;
    }
    
    /**********************************************************************************************
    * @Description : Method to convert String Time in Decimal value.                              *
    * @Params      : String                                                                       *
    * @Return      : Decimal                                                                      *
    **********************************************************************************************/
    public static Decimal converToDecimal(String stringTime){
        Decimal decimaltime = Decimal.valueOf(stringTime.substring(0,2)) + (Decimal.valueOf(stringTime.substring(3,5))/60); 
        return decimaltime;
    }
    
    /**********************************************************************************************
    * @Description : Method to convert Decimal Time to String value.                              *
    * @Params      : Decimal                                                                      *
    * @Return      : String                                                                       *
    **********************************************************************************************/
    public static String convertToString(Decimal decimalTime){
        Decimal difference = decimalTime-decimalTime.intValue();
        Integer minutes = (difference * 60).intValue();
        String stringTime = (Math.abs(decimalTime)< 10? '0' : '')+Math.abs(decimalTime.intValue())+(minutes!=0?':'+Math.abs(minutes):':00');
        return stringTime;
    }
    
    /*********************************************************************************************
     * @Description : Method to fetch the date format as per the brand from the custom setting.   *
     * @Params      : String                                                                      *
     * @Return      : String                                                                      * 
     *********************************************************************************************/
    public static String getDateFormat(String brandName){
        
        Map<String, Brand_Date_Format_Mapping__c> brandDateFormatMap = Brand_Date_Format_Mapping__c.getAll();   
        String defaultFormat = 'MM/dd/yyyy';
        system.debug('#### Brand Name - '+brandName);
        system.debug('#### Brand Date Format Map - '+brandDateFormatMap); 
        
        if(brandName != null && brandDateFormatMap != null && brandDateFormatMap.get(brandName) != null){ 
            system.debug('#### Brand Date Format Map 1- '+brandDateFormatMap); 
            system.debug('#### Brand Date Format Map 2- '+brandDateFormatMap.get(brandName).Date_Format__c);
            return brandDateFormatMap.get(brandName).Date_Format__c;    
             
        }else{
            return defaultFormat;
        }
    }
     
}//End of class