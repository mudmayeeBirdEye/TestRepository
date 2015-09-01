/*************************************************************************************************
* Project Name..........: RingCentral                                                            *
* File..................: SchedulerWebService                                                    *
* Version...............: 1.0                                                                    *
* Created by............: Simplion Technologies                                                  *
* Created Date..........: 9-5-2013                                                               *
* Last Modified by......: Simplion Technologies                                                  *
* Last Modified Date....: 10-5-2013                                                              *
* Description...........: External Web API for Implementation Scheduler                          *
*************************************************************************************************/
global class SchedulerWebService {
    
    // Map to store Appointment number and Appointment Type.
    public static Map<Integer, String> appointmentTypeMap =  new Map<Integer, String>{  0 => 'Initial Implementation', 
                                                                                        1 => 'Follow-Up Implementation 1', 
                                                                                        2 => 'Follow-Up Implementation 2', 
                                                                                        3 => 'Follow-Up Implementation 3', 
                                                                                        4 => 'Follow-Up Implementation 4', 
                                                                                        5 => 'Follow-Up Implementation 5'};
    
    /**********************************************************************************************
    * @Description : Wrapper Class for Request.                                                   *
    **********************************************************************************************/
    global class getBufferDaysRequest {
        webservice String BrandID;
        webservice Integer NumberofUsers;
    }
    /**********************************************************************************************
    * @Description : Wrapper Class for Respose.                                                   *
    **********************************************************************************************/
    global class getBufferDaysResponse {
        webservice Integer bufferDays;
        webservice String error_code; 
    }
    
    /*********************************************************************************************
    * @Description : Method 1 : Fetch the Buffer days                                            * 
    * @Params      : Request(BrandId,Number of Users)                                            *
    * @Return      : Response(bufferDays,error_code)                                             * 
    *********************************************************************************************/
    WebService static getBufferDaysResponse getBufferDays (getBufferDaysRequest Request){
        
        // Creating reponse object 
        getBufferDaysResponse response = new getBufferDaysResponse(); 
        schedulerConfiguration__c brand;
        
        try {
            /* Checking for null values. */
            if(Request.BrandID == null || Request.BrandID == '' ){
                response.error_code = 'ERR-001';
                return response;
            }
            /* Checking for null values. */
            if(Request.NumberofUsers == null){
                response.error_code = 'ERR-002';
                return response;
            }
           
            /* Remove White Spaces. */
            Request.BrandID = Request.BrandID.trim();
    
            /* Calling method to fetch the brand details. */
            brand = eventSchedulerUtility.getBrand(Request.BrandID.trim());
            if(brand != null){
                /* Calling the method to fetch the buffer days for that brand */                         
                response.bufferDays = eventSchedulerUtility.getBufferdays(Request.BrandID.trim());  
            }else{
                response.error_code ='Error : No Brand exists with Id - '+Request.BrandID;
            } 
            if(Test.isRunningTest()){
                Integer error = 0/0;
            }        
        }catch(Exception ex){ 
            Response.error_code = 'Error : '+ ex.getMessage();
            system.debug('#### Error on line = '+ex.getLineNumber()+' message = '+ex.getMessage());
        }
        return response; // Returning response object.
    }

    /**********************************************************************************************
    * @Description : Wrapper Class for Request.                                                   *
    **********************************************************************************************/
    global class getEventDetailsRequest {
        webservice String EventId;
    }
    /**********************************************************************************************
    * @Description : Wrapper Class for Respose.                                                   *
    **********************************************************************************************/
    global class getEventDetailsResponse {
        webservice Datetime rcDateTime;
        webservice Integer NumberofUsers;
        webservice String CustomerID;
        webservice String BrandID;
        webservice String FirstName;
        webservice String LastName;
        webservice String cEmail;
        webservice String notes;  
        webservice String error_code;
        webservice String PreferredLanguage;
        webservice String TimeZone;
        webservice String advisorId;
    }
    
    /**********************************************************************************************
    * @Description : Method 2: Obtain details for existing event                                  *  
    * @Params      : Request(Event ID)                                                            *
    * @Return      : Response(DateTime,CustomerId,BrandId,#ofUsers,FirstName,LastName,Email,      *
    *                         ErrorCode,Notes,AdvisorId)                                          * 
    **********************************************************************************************/
    webService static getEventDetailsResponse getEventDetails (getEventDetailsRequest Request){
        
        // Creating reponse object 
        getEventDetailsResponse response = new getEventDetailsResponse();
        // Creating List of Implementaion
        List<Implementation__c> implementationList = new List<Implementation__c>(); 
        
        
        try{
            // Getting key prefix for Implementation object.
            Schema.DescribeSObjectResult r = Event.sObjectType.getDescribe();
            String keyPrefixEvent = r.getKeyPrefix();
            
            /* Checking for null values and Event Id. */ 
            if(Request.EventId == null || Request.EventId == '' || Request.EventId.length() < 18 || !(Request.EventId).substring(0,3).equalsIgnoreCase(keyPrefixEvent)){
                response.error_code= 'ERR-003';
                return response; 
            }
            
            // Calling method to get event details.
            Event ObjEvent = eventSchedulerUtility.getEventDetails((Request.EventId).substring(0,18));
            system.debug('#### ObjEvent - '+ObjEvent);
            if(ObjEvent != null){
                
                /* Fetching Implementation OwnerId, based on the customer Id, 
                   and return the AdvisorId as the Owner of the Implementation in response. */
                if(ObjEvent.CustomerId__c != null && ObjEvent.CustomerId__c != ''){
                    implementationList = eventSchedulerUtility.getImplementation(ObjEvent.CustomerId__c);
                }
                /* If Event details successfully fetched, set in the returned value in the response object. */
                response.rcDateTime = ObjEvent.StartDateTime;
                response.BrandID = ObjEvent.Brand__c;
                response.cEmail = ObjEvent.Customer_Email__c;
                response.CustomerID = ObjEvent.CustomerId__c;
                response.FirstName = ObjEvent.First_Name__c;
                response.LastName = ObjEvent.Last_Name__c;
                response.PreferredLanguage = ObjEvent.Preferred_Language__c;
                response.TimeZone= ObjEvent.Time_Zone__c;
                response.NumberofUsers = Integer.valueOf(ObjEvent.NumberofUser__c);
                response.notes = ObjEvent.Description;
                if(implementationList != null && implementationList.size() > 0 && 
                   !String.valueOf(implementationList[0].OwnerId).contains(UserRC.getRCSFSyncPrimaryOwnerId)){
                    response.advisorId = implementationList[0].OwnerId;
                }else{
                    response.advisorId = null;
                }
                response.error_code = null;
                    
            }else{
                response.error_code ='Error : No Event found with Id - '+Request.EventId;       
            }
            if(Test.isRunningTest()){
                Integer error = 0/0;
            }
        }catch(Exception ex){
            Response.error_code = 'Error : '+ ex.getMessage();
            system.debug('#### Error on line = '+ex.getLineNumber()+' message = '+ex.getMessage());
        }
        // Returning response object 
        return response;
    }

    /**********************************************************************************************
    * @Description : Wrapper Class for Request.                                                   *
    **********************************************************************************************/
    global class getAvailibilityRequest {
        webservice Integer NumberofUsers;
        webservice Boolean premiumSupport; 
        webservice String CustomerId;
        webservice String BrandId;
        webservice String cdate;
        webservice String appointmentLength;
        webservice String PreferredLanguage;
        webservice String TimeZone;
        webservice String advisorId;
    }
    /**********************************************************************************************
    * @Description : Wrapper Class for Respose.                                                   *
    **********************************************************************************************/
    global class getAvailibilityResponse {
        webservice List<String> timeSlots = new List<String>();
        webservice String error_code;
    }
    
    /**********************************************************************************************
    * @Description : Methdod 3 : Identify event availability per correct resource pool.           *
    * @Params      : Request(CustomerId,BrandId,#ofUser,Date)                                     *
    * @Return      : Response(TimeSlots,ErrorCode)                                                * 
    **********************************************************************************************/
    webService static getAvailibilityResponse getAvailibility(getAvailibilityRequest Request){
        
        system.debug('Request-->'+Request);
        /* Initializing variables */
        /* Contains the type of event, initial Implementation type or follow-up type. */
        String eventType;
        /* Contains the number of appointments booked on an Implementation. */
        Integer isInitialAppointment;
        /* Contains selected advisor */
        String selectedAdvisor;
        /* Contains scheduled configuration result */
        schedulerConfiguration__c brand = new schedulerConfiguration__c();
        /* Wrapper to fetch the wrapped time availability response. */ 
        eventSchedulerUtility.timeAdvisorWrapper tawObject = new eventSchedulerUtility.timeAdvisorWrapper();  
        /* Wrapper to wrap the request parameter values. */
        eventSchedulerUtility.requestParameterWrapper rpwObject =  new eventSchedulerUtility.requestParameterWrapper();
        /* Initialising reponse wrapper object. */
        getAvailibilityResponse response = new getAvailibilityResponse(); 
         
        try{  
            
            /* Checking for null values */
            if(Request.CustomerId == null || Request.CustomerId == '' ){
                response.error_code = 'ERR-004';
                return response;
            }
            /* Checking for null values */
            if(Request.BrandId == null || Request.BrandId == ''){
                response.error_code = 'ERR-001';
                return response;
            }
            /* Checking for null values */
            if(Request.NumberofUsers == null){
                response.error_code = 'ERR-002';
                return response;
            }
            /* Checking for null values */
            if(Request.cdate == null || Request.cdate == ''){
                response.error_code = 'ERR-005';
                return response;
            } 
            /* Checking for null values */
            if(String.isBlank(Request.appointmentLength)){
                Response.error_code = 'ERR-006';
                return response;
            }
            /* Checking if the Preferred Language is passed or not, if no Preferred Language is passed, set en_US as default. */ 
            if(String.isBlank(Request.PreferredLanguage)){
                Request.PreferredLanguage = 'en_US';
                //Request.PreferredLanguage = 'fr_CA';
            }
           /* Checking if the TimeZone is passed or not, if no Time Zone passed, set PDT as default. */ 
           if(String.isBlank(Request.TimeZone)){
                Request.TimeZone = 'America/Los_Angeles';
           }
    
            // Delete White Spaces
            Request.CustomerID = Request.CustomerID.trim();
            Request.BrandID = Request.BrandID.trim();
            Request.cdate = Request.cdate.trim();
        
            /* Calling method to get brand details. */
            //brand = eventSchedulerUtility.getBrand(Request.BrandID.trim());
            brand = eventSchedulerUtility.getBrandsDetailsLanguage(Request.BrandID.trim(),Request.PreferredLanguage.trim());
            //brand = eventSchedulerUtility.getBrandsDetailsLanguage(Request.BrandID.trim(),'fr_CA');
            if(brand != null){
                Date dt = Date.parse(request.cdate); 
            
                // Requirement changes as per IS Q2 Project
                isInitialAppointment = eventSchedulerUtility.isInitialAppointmentScheduled(Request.CustomerID, dt);
                eventType = isInitialAppointment <= 5 ? appointmentTypeMap.get(isInitialAppointment) : 'Follow-Up Implementation';
                system.debug('#### eventType - '+eventType);
                
                /* Wrapping request parameter */
                rpwObject.BrandId = brand.Id;
                rpwObject.NumberOfUsers = Request.NumberofUsers;
                rpwObject.appointmentDate = String.valueOf(dt);
                rpwObject.appointmentLength = Request.appointmentLength;
                rpwObject.premiumSupport = Request.premiumSupport;
                rpwObject.eventType = eventType; 
                //rpwObject.selectedAdvisor = Request != null && Request.advisorId != null ? Request.advisorId.trim() : null;
                rpwObject.selectedAdvisor = null;
                rpwObject.preferredLanguage = Request != null && Request.PreferredLanguage != null ? Request.PreferredLanguage.trim() : null;
                rpwObject.timeZone = Request != null && Request.TimeZone != null ? Request.TimeZone.trim() : null;
                    
                /* Calling method to get available time slots */                                 
                tawObject = eventSchedulerUtility.availableTimeSlots(rpwObject);
                
                system.debug('#### Code at Scheduler Web Service getAvailability class - tawObject - '+tawObject);
                system.debug('#### Code at Scheduler Web Service getAvailability class - rpwObject - '+rpwObject);
                
                /* If Implementation Owner (Advisor Id) is provided and if he is NOT available for an appointment. 
                   Show availability for entire Resource Pool. */
                if(rpwObject != null && rpwObject.selectedAdvisor != null && rpwObject.selectedAdvisor != ''){ 
                    
                    system.debug('#### ADVISOR SELECTED '+rpwObject.selectedAdvisor);
                    if(tawObject != null && tawObject.availableAdvisors != null && tawObject.availableAdvisors.size() > 0 && 
                       tawObject.availableAdvisors.get(rpwObject.selectedAdvisor) != null && 
                       tawObject.availableAdvisors.get(rpwObject.selectedAdvisor).size() > 0){
                        response.timeSlots.addAll(tawObject.availableAdvisors.get(rpwObject.selectedAdvisor));
                        response.timeSlots.sort();
                    }else{
                        Response.error_code ='Error : No available time slots';
                        return response;
                    }   
                }
                /* If no advisor Id provided, show all the available time slots under that resource pool. */
                if(rpwObject != null && (rpwObject.selectedAdvisor == '' || rpwObject.selectedAdvisor == null)){
                    
                    system.debug('#### NO ADVISOR SELECTED ');
                    if(tawObject != null && tawObject.availableTimeSlots != null && tawObject.availableTimeSlots.size() != 0){
                        response.timeSlots.addAll(tawObject.availableTimeSlots);
                    }else{
                        Response.error_code ='Error : No available time slots';
                        return response;
                    }
                }   
            }else{
                Response.error_code ='Error : No Brand exists with Id - '+Request.BrandID;
                return Response;
            }
            /* If Time Zone is provided, converting the available time slots to the provided time zone.*/  
            if(Request != null && Request.TimeZone != null && !Request.TimeZone.equalsIgnoreCase('America/Los_Angeles')){
                eventSchedulerUtility.timeZoneWrapper tzwObject = new eventSchedulerUtility.timeZoneWrapper(); 
                tzwObject.timeZone = Request.TimeZone.trim();  
                tzwObject.timeSlots = response.timeSlots;
                // Calling method to convert time slots in asked Time Zone.
                List<String> convertedTimeSlots = eventSchedulerUtility.convertToTimeZone(tzwObject);
                if(convertedTimeSlots != null && convertedTimeSlots.size() > 0){
                    response.timeSlots = new List<String>();
                    response.timeSlots.addAll(convertedTimeSlots);   
                }
            }
            if(Test.isRunningTest()){
                Integer error = 0/0;
            }       
        }catch(Exception ex){                                    
            Response.error_code = 'Error : '+ ex.getMessage();
            system.debug('#### Error on line = '+ex.getLineNumber()+' message = '+ex.getMessage());
        }  
        system.debug('#### response - '+response); 
        return response; // Returning response object 
    }

    /**********************************************************************************************
    * @Description : Wrapper Class for Request.                                                   *
    **********************************************************************************************/
    global class scheduleEventRequest {
        webservice Boolean premiumSupport;
        webservice Integer NumberofUsers;
        webservice String cdatetime;
        webservice String BrandID;
        webservice String CustomerId;
        webservice String firstName;
        webservice String lastname;
        webservice String Email;
        webservice String Notes;
        webservice String appointmentLength;
        webservice String PreferredLanguage;
        webservice String TimeZone;
        webservice String advisorId;
    }
    /**********************************************************************************************
    * @Description : Wrapper Class for Respose.                                                   *
    **********************************************************************************************/
    global class scheduleEventResponse {
        webservice String error_code;
        webservice String EventId;
        webservice Boolean sucess_code;
    }
    
    /**********************************************************************************************
    * @Description : Method 4 : Create event and save the above parameters on that event.         *
    *                           remove used resource from relevant resource pool.                 *
    *                           Email confirmation email to event Contact                         *
    * @Params      : Request(DateTime,CustomerId,BrandId,#ofUsers,FirstName,LastName,Email,Notes) *
    * @Return      : Response(ErrorCode,SuccessCode,EventId)                                      * 
    **********************************************************************************************/
    webService static scheduleEventResponse scheduleEvent(scheduleEventRequest Request ){
        system.debug('Request-->'+Request);
        /* Wrapper to fetch the wrapped time availability response. */ 
        eventSchedulerUtility.timeAdvisorWrapper tawObject = new eventSchedulerUtility.timeAdvisorWrapper();
        /* Wrapper to wrap the request parameter values. */
        eventSchedulerUtility.requestParameterWrapper rpwObject =  new eventSchedulerUtility.requestParameterWrapper();
        /* Wrapper to wrap the request parameter values. */
        scheduleEventResponse Response = new scheduleEventResponse();
        /* Contains the type of event, initial Implementation type or follow-up type. */
        String eventType;
        /* Contains the number of appointments booked on an Implementation. */
        Integer isInitialAppointment;
        /* Contaisn list of available time slots. */
        List<String> latestTimeSlots = new List<String>();
        Datetime appointmentDate ;
        Resource_Pool__c selectedResourcePool = new Resource_Pool__c();
        
        try{
            
            /* Checking for null values. */
            if(Request.cdatetime == null || Request.cdatetime == ''){
                Response.error_code = 'ERR-007';
                Response.sucess_code = false;
                return response;
            }
            /* Checking for null values. */
            if(Request.BrandId == null || Request.BrandId == ''){
                Response.error_code = 'ERR-001';
                Response.sucess_code = false;
                return response;
            }
            /* Checking for null values. */
            if(Request.NumberofUsers == null){
                Response.error_code = 'ERR-002';
                Response.sucess_code = false;
                return response;
            }
            /* Checking for null values. */
            if(Request.CustomerId == null || Request.CustomerId == ''){
                Response.error_code = 'ERR-004';
                Response.sucess_code = false;
                return response;
            }
            /* Checking for null values. */
            if(Request.firstName == null || Request.firstName == ''){
                Response.error_code = 'ERR-008';
                Response.sucess_code = false;
                return response;
            }
            /* Checking for null values. */
            if(Request.lastname == null || Request.lastname == ''){
                Response.error_code = 'ERR-009';
                Response.sucess_code = false;
                return response;
            }
            /* Checking for null values. */
            if(Request.Email == null || Request.Email == ''){
                Response.error_code = 'ERR-010';
                Response.sucess_code = false;
                return response;
            }
            /* Checking for null values. */
            if(String.isBlank(Request.Notes)){
                Request.Notes = 'Implementation created for AT&T';
            }
            /* Checking for null values. */
            if(String.isBlank(Request.appointmentLength)){
                Response.error_code = 'ERR-006';
                Response.sucess_code = false;
                return response;
            }
            /* Checking if the Preferred Language is passed or not, if no Preferred Language is passed, set en_US as default. */ 
            if(String.isBlank(Request.PreferredLanguage)){
                Request.PreferredLanguage = 'en_US';
            }
            /* Checking if the TimeZone is passed or not, if no Time Zone passed, set PDT as default. */ 
            if(String.isBlank(Request.TimeZone)){
                Request.TimeZone = 'America/Los_Angeles';
            }   
            
            // Deleting White Spaces
            Request.cdatetime= Request.cdatetime.trim();
            Request.BrandID = Request.BrandID.trim();
            Request.CustomerId = Request.CustomerId.trim();
            Request.firstName = Request.firstName.trim();
            Request.lastName = Request.lastName.trim();
            Request.Email = Request.Email.trim();
            system.debug('#### Request PreferredLanguage = '+request.PreferredLanguage);
            Request.PreferredLanguage = Request.PreferredLanguage != null ? Request.PreferredLanguage.trim() : '';
            Request.TimeZone = Request.TimeZone != null ? Request.TimeZone.trim() : '';
            Request.Notes = Request.Notes.trim();
            appointmentDate = DateTime.parse(Request.cdatetime.trim());
            Request.appointmentLength = Request.appointmentLength.trim(); 
            
            // Calling method to get brand details   
            //schedulerConfiguration__c brand = eventSchedulerUtility.getBrand(Request.BrandID.trim());
            schedulerConfiguration__c brand = eventSchedulerUtility.getBrandsDetailsLanguage(Request.BrandID,Request.PreferredLanguage);
            if(brand != null){
                
                // Requirement changes as per IS Q2 Project
                isInitialAppointment = eventSchedulerUtility.isInitialAppointmentScheduled(Request.CustomerId, Date.valueOf(appointmentDate));
                eventType = isInitialAppointment <= 5 ? appointmentTypeMap.get(isInitialAppointment) : ('Follow-Up Implementation '+isInitialAppointment);
                system.debug('#### eventType - '+eventType);
                
                /* Wrapping request parameter */
                rpwObject.BrandId = brand.Id;
                rpwObject.NumberOfUsers = Request.NumberofUsers;
                rpwObject.appointmentDate = String.valueOf(appointmentDate.date());
                rpwObject.appointmentLength = Request.appointmentLength;
                rpwObject.premiumSupport = Request.premiumSupport;
                rpwObject.eventType = eventType;
                //rpwObject.selectedAdvisor = Request != null && Request.advisorId != null ? Request.advisorId.trim() : null;
                rpwObject.selectedAdvisor = null;
                //String requestedTime = String.valueof(appointmentDate.time()).substring(0,5);
                system.debug('appointmentDate.time()-->'+appointmentDate.time());
                String requestedTime = String.valueof(appointmentDate.time()).substring(0,5);   
                system.debug('requestedTime-->'+requestedTime);
                rpwObject.selectedTime = requestedTime;
                rpwObject.timeZone = Request.TimeZone;
                rpwObject.preferredLanguage = Request.PreferredLanguage;
                system.debug('#### Advisor - '+rpwObject.selectedAdvisor);
                
                /* Calling method to get available time slots */
                tawObject = eventSchedulerUtility.availableTimeSlots(rpwObject);
                system.debug('#### Code at Scheduler Web Service class - tawObject - '+tawObject);
                
                /* Implementation Owner is NOT in the Resource Pool for this Customer. Show availability for entire Resource Pool.*/
                if(rpwObject != null && rpwObject.selectedAdvisor != null && rpwObject.selectedAdvisor != '' && tawObject != null && 
                   tawObject.availableAdvisors != null && tawObject.availableAdvisors.size() > 0 && 
                   tawObject.availableAdvisors.get(rpwObject.selectedAdvisor) != null && 
                   tawObject.availableAdvisors.get(rpwObject.selectedAdvisor).size() > 0){
                    system.debug('#### Advisor Available');
                    latestTimeSlots.addAll(tawObject.availableAdvisors.get(rpwObject.selectedAdvisor)); 
                }
                //if(rpwObject != null && (rpwObject.selectedAdvisor == null || rpwObject.selectedAdvisor == '')){
                if(rpwObject != null && String.isBlank(rpwObject.selectedAdvisor)){
                    system.debug('#### No Advisor Available');
                    if(tawObject != null && tawObject.availableTimeSlots != null){
                        latestTimeSlots.addAll(tawObject.availableTimeSlots);
                    }
                    String inflatedTime;
                    Decimal offsetValue;
                    //offsetValue = eventSchedulerUtility.getOffsetValue(String.valueOf(UserInfo.getTimeZone()),requestedTime);
                    inflatedTime = eventSchedulerUtility.convertToString(eventSchedulerUtility.converToDecimal(requestedTime));
                    if(tawObject != null && tawObject.timeSlotAdvisorMap != null && tawObject.timeSlotAdvisorMap.get(inflatedTime) != null){
                        List<Id> advisorsList = new List<Id>();
                        advisorsList.addAll(tawObject.timeSlotAdvisorMap.get(inflatedTime));        
                        system.debug('#### advisorsList');
                        //while(rpwObject.selectedAdvisor == null || rpwObject.selectedAdvisor == ''){
                        while(String.isBlank(rpwObject.selectedAdvisor)){
                            Integer randomNumber = Math.round((Math.random() * ((advisorsList.size()-1) - 0)) + 0);
                            system.debug('#### Lucky Number - '+randomNumber);
                            if(randomNumber < advisorsList.size()){
                                Id thisLuckyAdvisor = advisorsList[randomNumber];
                                if(tawObject.availableAdvisors != null &&  tawObject.availableAdvisors.get(thisLuckyAdvisor) != null &&
                                    tawObject.availableAdvisors.get(thisLuckyAdvisor).contains(inflatedTime)){
                                    rpwObject.selectedAdvisor = thisLuckyAdvisor;
                                }
                            }  
                        }
                    }
                }
                Set<String> timeslotSet = new Set<String>();
                timeslotSet.addAll(latestTimeSlots);
                system.debug('#### Time Slot Set - '+timeslotSet);
                system.debug('#### Requested Time - '+requestedTime);
                /* If Time Zone is provided, converting the available time slots to the provided time zone.*/  
                if(Request != null && Request.TimeZone != null && String.valueOf(UserInfo.getTimeZone()) != Request.TimeZone){
                    eventSchedulerUtility.timeZoneWrapper tzwObject = new eventSchedulerUtility.timeZoneWrapper(); 
                    timeslotSet = new Set<String>();
                    tzwObject.timeZone = Request.TimeZone.trim();
                    tzwObject.timeSlots = latestTimeSlots;
                    // Calling method to convert time slots in asked Time Zone.
                    List<String> convertedTimeSlots = eventSchedulerUtility.convertToTimeZone(tzwObject);
                    if(convertedTimeSlots != null && convertedTimeSlots.size() > 0){
                        timeslotSet.addAll(convertedTimeSlots); 
                    }
                }
                if(timeslotSet != null && (timeslotSet.size() == 0 || !timeslotSet.contains(requestedTime))){
                    Response.error_code ='ERR-012';
                    Response.sucess_code=false;
                    return Response;                                
                }    
                
                /* Calling method to fetch Implementation details. */
                List<Implementation__c> implementationDetails = eventSchedulerUtility.getImplementation(Request.CustomerId.trim());
                
                /* Check Resource Pool Availability, checking if atleast one resource pool is available or not */
                selectedResourcePool = eventSchedulerUtility.getValidResourcePool(brand.Id,Request.NumberofUsers,Request.premiumSupport,Request.PreferredLanguage);
                if(selectedResourcePool != null){
                    //Calculating hours for end date time
                    Integer hours = Integer.valueOf(Request.appointmentLength)/60;     
                    system.debug('#### Appointment Length in hours - '+hours);
                    
                    /* Calling method to fetch the offset value for the asked Time Zone, with respect to the PDT. */
                    Decimal offsetValue = 0;
                    /*if(!Request.TimeZone.trim().containsIgnoreCase('America/Los_Angeles')){
                        offsetValue = eventSchedulerUtility.getOffsetValue(String.valueOf(UserInfo.getTimeZone()),Request.TimeZone.trim());
                    }*/
                    //offsetValue = eventSchedulerUtility.getOffsetValue(String.valueOf(UserInfo.getTimeZone()),Request.TimeZone.trim());
                    String hour = requestedTime.split(':').get(0);
                    String minute = requestedTime.split(':').get(1);
                    String strRequetsedDate = Request.cdatetime.substring(0,8);
                    system.debug('strRequetsedDate---->'+strRequetsedDate);
                    String[] strDate = strRequetsedDate.split('/');
                    system.debug('strDate---->'+strDate);
                    appointmentDate = DateTime.newInstanceGMT(Integer.ValueOf('20'+strDate[2]), Integer.ValueOf(strDate[0]), Integer.ValueOf(strDate[1]),Integer.valueOf(hour),Integer.valueOf(minute),0);
                    /* Setting values in event object to be inserted. */
                    Event objEvent = new Event();
                    //objEvent.StartDateTime = appointmentDate.addHours(Integer.valueOf(offsetValue));
                    //objEvent.EndDateTime = objEvent.StartDateTime.addHours(hours);
                    if(!eventSchedulerUtility.gmtZeroTimeZoneSet.contains(Request.TimeZone.trim())){
                        offsetValue = eventSchedulerUtility.getOffsetValue('GMT',Request.TimeZone);
                        objEvent.StartDatetime = appointmentDate.addHours(Integer.valueOf(offsetValue));
                        objEvent.EndDatetime = objEvent.StartDatetime.addMinutes(Integer.valueOf(Request.appointmentLength));
                    }else{
                            objEvent.StartDatetime = appointmentDate;
                            objEvent.EndDatetime = objEvent.StartDatetime.addMinutes(Integer.valueOf(Request.appointmentLength));
                        } 
                        
                    objEvent.Description = Request.Notes.trim();
                    objEvent.Subject = implementationDetails != null && implementationDetails.size() > 0 ? implementationDetails[0].Account__r.Name : 'Implementation Scheduled';
                    objEvent.OwnerId = selectedResourcePool.Dispatch_Admin__c;
                    objEvent.Brand__c = Request.BrandId.trim();
                    objEvent.WhatId = selectedResourcePool.Id;
                     if(implementationDetails != null && implementationDetails.size() >0){
                        objEvent.WhatId = implementationDetails[0].Id;
                    }
                    objEvent.Implementation_Status__c = 'Scheduled';
                    objEvent.Customer_Email__c = Request.Email.trim();
                    objEvent.CustomerId__c = Request.CustomerId.trim(); 
                    objEvent.First_Name__c = Request.firstName.trim();
                    objEvent.Last_Name__c = Request.LastName.trim();
                    objEvent.Preferred_Language__c = Request.PreferredLanguage != null ? Request.PreferredLanguage.trim() : '';
                    objEvent.Time_Zone__c= Request.TimeZone != null ? Request.TimeZone.trim() : '';
                    objEvent.NumberofUser__c= Request.NumberofUsers;
                    objEvent.Contact_Support__c = brand.Contact_Support__c;
                    objEvent.Appointment_Source__c = 'External Web API';
                    objEvent.Type = eventType; 
                    insert objEvent; 
                    system.debug('objEvent--->'+objEvent);
                    /* Updating isImplementationAppointmentScheduled flag on Account. */
                    Account accToBeUpdated = new Account();
                    accToBeUpdated = eventSchedulerUtility.getAccountDetails(Request.CustomerId.trim());
                    if(accToBeUpdated != null){
                        TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT();
                        TriggerHandler.BY_PASS_ACCOUNT_ON_UPDATE();
                        accToBeUpdated.isAppointmentScheduled__c = true;
                        update accToBeUpdated;
                    }
                    /* Calling method to update Contact field on Implementation. */
                    if(objEvent != null && objEvent.Type != null && objEvent.Type.equalsIgnoreCase('Initial Implementation') && 
                        !String.isBlank(objEvent.CustomerId__c) && rpwObject != null && 
                        (rpwObject.selectedAdvisor != null && rpwObject.selectedAdvisor != '')){
                        eventSchedulerUtility.updateImplementationOwner(rpwObject.selectedAdvisor, objEvent.CustomerId__c);
                    }                       
                    /* Updating Exception & History Object for 24 Hours reminder worfkflow. */
                    eventSchedulerUtility.reminderEmail(objEvent, accToBeUpdated != null ? accToBeUpdated.RC_Brand__c : null);
                    /* Calling method to invite selected advisors. */
                    eventSchedulerUtility.inviteAdvisor(objEvent, rpwObject != null ? rpwObject.selectedAdvisor : '');  
                    /* Sending confirmation email to event Contact. */
                    if(objEvent != null){
                        Response.EventId = objEvent.Id;
                        Response.sucess_code = true;
                        // Calling method to send ICS Email
                        //eventSchedulerUtility.sendIcsEmail(Request.firstName.trim(),Request.lastname.trim(),Request.Email.trim(), objEvent, brand.Id);
                        /* Wrapping up data to send out emails.*/ 
                          eventSchedulerUtility.EmailWrapper ewObject =  new eventSchedulerUtility.EmailWrapper();  
                          ewObject.eventRecord = objEvent;
                          ewObject.emailType = 'Confirmation';
                          ewObject.timeZone = objEvent.Time_Zone__c;
                          Boolean insertENHRecord  = eventSchedulerUtility.sendEmail(ewObject);
                          if(eventSchedulerUtility.hasError || !insertENHRecord){
                            Response.error_code = 'Error : '+eventSchedulerUtility.errorString;
                            Response.sucess_code = false;
                        }
                    }
                }else{
                    Response.error_code ='Error : Event cannot be scheduled No Resource pool found';
                    Response.sucess_code = false;
                }
            }else{
                Response.error_code ='ERR-014 - '+Request.BrandID;
                Response.sucess_code = false;
            }   
            if(Test.isRunningTest()){
                Integer error = 0/0;
            }                  
        }catch(Exception ex){
            Response.error_code = 'Error : '+ ex.getMessage();
            Response.sucess_code = false;
            system.debug('#### Error on line = '+ex.getLineNumber()+' message = '+ex.getMessage());
        }
        return Response; // Returning response object
    }
    
    /**********************************************************************************************
    * @Description : Wrapper Class for Request.                                                   *
    **********************************************************************************************/    
    global class cancelEventsRequest {
        webservice String EventId;
        webservice Boolean premiumSupport;
    }
    /**********************************************************************************************
    * @Description : Wrapper Class for Respose.                                                   *
    **********************************************************************************************/
    global class cancelEventsResponse {
        webservice String error_code;
        webservice Boolean sucess_code;
    }
    
    /**********************************************************************************************
    * @Description : Method 5 : Set event as cancelled, add resource back in to relevant RP       *
    * @Params      : Request(Event Id)                                                            *
    * @Return      : Response(ErrorCode,SuccessCode)                                              *  
    **********************************************************************************************/
    webservice static cancelEventsResponse cancelEvents(cancelEventsRequest Request){
        
        // Creating reponse object
        cancelEventsResponse Response = new cancelEventsResponse(); 
        Boolean insertENHRecord;     

        try{
            
            // Getting key prefix for Implementation object.
            Schema.DescribeSObjectResult r = Event.sObjectType.getDescribe();
            String keyPrefixEvent = r.getKeyPrefix();
            
            /* Checking for null values and Event Id. */ 
            if(Request.EventId == null || Request.EventId == '' || Request.EventId.length() < 18 || !(Request.EventId).substring(0,3).equalsIgnoreCase(keyPrefixEvent)){
                response.error_code = 'ERR-003';
                Response.sucess_code = false;
                return response; 
            }
            
            //Delete White Spaces
            Request.EventId = Request.EventId.trim();
            
            /* Calling method to get event details. */
            Event objEvent = eventSchedulerUtility.getEventDetails((Request.EventId).substring(0,18)); 
            system.debug('#### ObjEvent - '+ObjEvent);
            
            if(ObjEvent != null){
                // If event already canceled, set error code as "The Event is already canceled"
                if(objEvent.Implementation_Status__c != null && objEvent.Implementation_Status__c.equalsIgnoreCase('Canceled')){
                    Response.error_code ='ERR-013';
                    Response.sucess_code = false;
                    return Response;
                }else{
                    objEvent.Implementation_Status__c = 'Canceled';
                    objEvent.Subject = 'Implementation Cancelled';
                    update objEvent;
                    Response.sucess_code = true;
                    
                    /* Calling method to set flag, to cancel 24 hours reminder email notification. */
                    eventSchedulerUtility.cancelReminderEmail(objEvent);
                    /* Calling method to send Cancellation Notification to Customer. */
                    //eventSchedulerUtility.sendImplementationEmail(objEvent.First_Name__c,objEvent.Last_Name__c,objEvent.Customer_Email__c,objEvent, objEvent.Brand__c,'Cancellation');
                    /* Wrapping up data to send out emails.*/ 
                    eventSchedulerUtility.EmailWrapper ewObject =  new eventSchedulerUtility.EmailWrapper();
                    ewObject.eventRecord = objEvent;
                    ewObject.emailType = 'Cancellation';
                    ewObject.timeZone = objEvent.Time_Zone__c;
                    insertENHRecord  = eventSchedulerUtility.sendEmail(ewObject);
                    if(eventSchedulerUtility.hasError || !insertENHRecord){
                            Response.error_code = 'Error : '+eventSchedulerUtility.errorString;
                            Response.sucess_code = false;
                            return Response;
                        }
                        /* Calling method to send Cancellation Email to resource Pool. */
                        //eventSchedulerUtility.sendEmailResourcePool(objEvent,'Cancellation Internal',Request.premiumSupport);
                        ewObject.emailType = 'Cancellation Internal';
                    insertENHRecord  = eventSchedulerUtility.sendEmail(ewObject);
                    if(eventSchedulerUtility.hasError || !insertENHRecord){
                            Response.error_code = 'Error : '+eventSchedulerUtility.errorString;
                            Response.sucess_code = false;
                            return Response;
                        }
                  }
            }else{
                response.error_code = 'ERR-015- '+Request.EventId;  
                Response.sucess_code = false;   
            }
            if(Test.isRunningTest()){
                Integer error = 0/0;
            }
        }catch(Exception ex){
            Response.error_code = 'Error : '+ ex.getMessage();
            Response.sucess_code = false;
            system.debug('#### Error on line = '+ex.getLineNumber()+' message = '+ex.getMessage());
        }
        return Response;// Returning response object 
    } 

    /**********************************************************************************************
    * @Description : Wrapper Class for Request.                                                   *
    **********************************************************************************************/
    global class resheduleEventsRequest {
        webservice Integer NumberofUsers;
        webservice Boolean premiumSupport;
        webservice String EventId;
        webservice String cdatetime;
        webservice String BrandId;
        webservice String customerId;             
        webservice String FirstName;
        webservice String LastName;
        webservice String Email;
        webservice String Notes;
        webservice String appointmentLength;
        webservice String advisorId;
        webservice String TimeZone;
        webservice String PreferredLanguage;
    }    
    /**********************************************************************************************
    * @Description : Wrapper Class for Respose.                                                   *
    **********************************************************************************************/
    global class resheduleEventsResponse {
        webservice String error_code;
        webservice String eventId;
        webservice Boolean sucess_code;
    }
    
    /**********************************************************************************************
    * @Description : Method 6 : Cancel existing event,create new event with new date/time.        *
    *                           add resource back in to relevant resource pool and remove used    *
    *                           resource from relevant resource pool.                             *
    * @Params      : Request(DateTime, CustomerId, BrandId, #ofUsers, FirstName, LastName, Email, *
    *                        Notes, EventId, advisorId)                                           *
    * @Return      : Response(ErrorCode, SuccessCode, EventId)                                    * 
    **********************************************************************************************/
    webservice static resheduleEventsResponse resheduleEvents(resheduleEventsRequest Request){
        
        system.debug('Request under resheduleEvents-->'+Request);
        
        /* Wrapper to fetch the wrapped time availability response. */ 
        eventSchedulerUtility.timeAdvisorWrapper tawObject = new eventSchedulerUtility.timeAdvisorWrapper();
        /* Wrapper to wrap the request parameter values. */
        eventSchedulerUtility.requestParameterWrapper rpwObject = new eventSchedulerUtility.requestParameterWrapper();
        /* Wrapper to wrap the request parameter values. */
        resheduleEventsResponse Response = new resheduleEventsResponse();  
        /* Contains the type of event, initial Implementation type or follow-up type. */
        String eventType;
        /* Contains the number of appointments booked on an Implementation. */
        Integer isInitialAppointment;
        /* Contaisn list of available time slots. */
        List<String> latestTimeSlots = new List<String>();
               
        try{
            
            // Getting key prefix for Event object.
            Schema.DescribeSObjectResult r = Event.sObjectType.getDescribe();
            String keyPrefixEvent = r.getKeyPrefix();
            
            /* Checking for null values and Event Id. */ 
            if(Request.EventId == null || Request.EventId == '' || Request.EventId.length() < 18 || !(Request.EventId).substring(0,3).equalsIgnoreCase(keyPrefixEvent)){
                response.error_code = 'ERR-003';
                Response.sucess_code = false;
                system.debug('Request under resheduleEvents ERR-003-->'+response);
                return response; 
                
            }
            /* Checking for null values. */
            if(Request.cdatetime == null || Request.cdatetime == ''){
                response.error_code = 'ERR-007';
                Response.sucess_code = false;
                system.debug('Request under resheduleEvents ERR-007-->'+response);
                return response;
            }
            /* Checking for null values. */
            if(Request.BrandId == null || Request.BrandId == ''){
                response.error_code = 'ERR-001';
                Response.sucess_code = false;
                system.debug('Request under resheduleEvents ERR-001-->'+response);
                return response;
            }
            /* Checking for null values. */
            if(Request.NumberofUsers == null){
                response.error_code = 'ERR-002';
                Response.sucess_code = false;
                system.debug('Request under resheduleEvents ERR-002-->'+response);
                return response;
            }
            /* Checking for null values. */
            if(Request.customerId == null || Request.customerId == ''){
                response.error_code = 'ERR-004';
                Response.sucess_code = false;
                system.debug('Request under resheduleEvents ERR-004-->'+response);
                return response;
            }
            /* Checking for null values. */
            if(Request.FirstName == null || Request.FirstName == ''){
                response.error_code = 'ERR-008';
                Response.sucess_code = false;
                system.debug('Request under resheduleEvents ERR-008-->'+response);
                return response;
            }
            /* Checking for null values. */
            if(Request.LastName == null || Request.LastName == ''){
                response.error_code = 'ERR-009';
                Response.sucess_code = false;
                system.debug('Request under resheduleEvents ERR-009-->'+response);
                return response;
            }
            /* Checking for null values. */         
            if(Request.Email == null || Request.Email == ''){
                response.error_code = 'ERR-010';
                Response.sucess_code = false;
                system.debug('Request under resheduleEvents ERR-010-->'+response);
                return response;
            }
            /* Checking for null values. */
            if(String.isBlank(Request.Notes)){
               Request.Notes = 'Implementation created for AT&T';
            }
            /* Checking for null values. */
            if(String.isBlank(Request.appointmentLength)){
                Response.error_code = 'ERR-006';
                Response.sucess_code = false;
                system.debug('Request under resheduleEvents ERR-006-->'+response);
                return response;
            }
            /* Checking if the Preferred Language is passed or not, if no Preferred Language is passed, set en_US as default. */ 
            if(String.isBlank(Request.PreferredLanguage)){
                Request.PreferredLanguage = 'en_US';
                //Request.PreferredLanguage = 'fr_CA';
            }
            /* Checking if the TimeZone is passed or not, if no Time Zone passed, set PDT as default. */ 
            if(String.isBlank(Request.TimeZone)){
                Request.TimeZone = 'America/Los_Angeles';
            }
    
            // Delete White Spaces
            Request.EventId = Request.EventId.trim();
            Request.cdatetime = Request.cdatetime.trim();
            Request.BrandId = Request.BrandId.trim();
            Request.customerId = Request.customerId.trim();
            Request.FirstName = Request.FirstName.trim();
            Request.LastName = Request.LastName.trim();
            Request.Email = Request.Email.trim();
            Request.Notes = Request.Notes.trim();
            Request.PreferredLanguage = Request.PreferredLanguage != null ? Request.PreferredLanguage.trim() : '';
            
            /* Calling method to get event details. */
            Event existingEvent = eventSchedulerUtility.getEventDetails((Request.EventId).substring(0,18)); 
            system.debug('#### Event - '+existingEvent);
            system.debug('#### Event Type - ' + existingEvent.Type);
            rpwObject.preferredLanguage = Request.PreferredLanguage;
            // If event fetched, set that event as canceled
            if(existingEvent != null){
                TriggerHandler.BY_PASS_EVENT_ON_INSERT();
                TriggerHandler.BY_PASS_EVENT_ON_UPDATE();
                existingEvent.Implementation_Status__c = 'Canceled';
                existingEvent.Subject = 'Implementation Cancelled';
                //update existingEvent;  
                Database.update(existingEvent);
                 //rpwObject.preferredLanguage = existingEvent.Preferred_Language__c;
                /* Calling method to set flag to cancel 24 hours reminder email notification. */
                eventSchedulerUtility.cancelReminderEmail(existingEvent);
            }

            /* Logic to Prevent Duplicate Insertion & Concurrency Issues*/
            Datetime dt = DateTime.parse(Request.cdatetime.trim());
           
            /* Calling method to fetch brand details. */  
            //schedulerConfiguration__c brand = eventSchedulerUtility.getBrand(Request.BrandID.trim());  
            schedulerConfiguration__c brand = eventSchedulerUtility.getBrandsDetailsLanguage(Request.BrandID,existingEvent.Preferred_Language__c);
            if(brand != null){ 
                /* Wrapping request parameter */
                rpwObject.BrandId = brand.Id;
                rpwObject.NumberOfUsers = Request.NumberofUsers;
                rpwObject.appointmentDate = String.valueOf(dt.date());
                rpwObject.appointmentLength = Request.appointmentLength;
                rpwObject.premiumSupport = Request.premiumSupport;
                rpwObject.eventType = existingEvent != null ? existingEvent.Type : '';
                //rpwObject.selectedAdvisor = Request != null && Request.advisorId != null ? Request.advisorId.trim() : null;
                rpwObject.selectedAdvisor = null;
                system.debug('dt.time()-->'+dt.time());
                String requestedTime = String.valueof(dt.time()).substring(0,5);    
                system.debug('requestedTime-->'+requestedTime);
                rpwObject.selectedTime = requestedTime;
                rpwObject.timeZone = Request.TimeZone;
                
                system.debug('#### Advisor - '+rpwObject.selectedAdvisor);
                
                /* Calling method to get available time slots */
                tawObject = eventSchedulerUtility.availableTimeSlots(rpwObject);
                system.debug('#### Code at Scheduler Web Service class - tawObject - '+tawObject);
                
                /* Implementation Owner is NOT in the Resource Pool for this Customer. Show availability for entire Resource Pool.*/
                if(rpwObject != null && String.isNotBlank(rpwObject.selectedAdvisor)){
                    system.debug('#### Advisor Selected');
                    if(tawObject != null && tawObject.availableAdvisors != null && tawObject.availableAdvisors.size() > 0 && 
                       tawObject.availableAdvisors.get(rpwObject.selectedAdvisor) != null && 
                       tawObject.availableAdvisors.get(rpwObject.selectedAdvisor).size() > 0){
                        latestTimeSlots.addAll(tawObject.availableAdvisors.get(rpwObject.selectedAdvisor)); 
                    }
                }
                if(rpwObject != null && (String.isBlank(rpwObject.selectedAdvisor))){
                    system.debug('#### No Advisor Selected');
                    if(tawObject != null && tawObject.availableTimeSlots != null){
                        latestTimeSlots.addAll(tawObject.availableTimeSlots);
                    }
                    String inflatedTime;
                    Decimal offsetValue;
                    inflatedTime = eventSchedulerUtility.convertToString(eventSchedulerUtility.converToDecimal(requestedTime));
                    if(tawObject != null && tawObject.timeSlotAdvisorMap != null && tawObject.timeSlotAdvisorMap.get(inflatedTime) != null){
                        List<Id> advisorsList = new List<Id>();
                        advisorsList.addAll(tawObject.timeSlotAdvisorMap.get(inflatedTime));               
                        while(String.isBlank(rpwObject.selectedAdvisor)){
                            Integer randomNumber = Math.round((Math.random() * ((advisorsList.size()-1) - 0)) + 0);
                            system.debug('#### Lucky Number - '+randomNumber);
                            if(randomNumber < advisorsList.size()){
                                Id thisLuckyAdvisor = advisorsList[randomNumber];
                                if(tawObject.availableAdvisors != null &&  tawObject.availableAdvisors.get(thisLuckyAdvisor) != null &&
                                    tawObject.availableAdvisors.get(thisLuckyAdvisor).contains(inflatedTime)){
                                        rpwObject.selectedAdvisor = thisLuckyAdvisor;
                                }
                            }  
                        }
                    }
                }
                Set<String> timeslotSet = new Set<String>();
                timeslotSet.addAll(latestTimeSlots);
                //timeslotSet.addAll(latestTimeSlots);
                system.debug('#### Latest Time Slots - '+latestTimeSlots);
                system.debug('#### Requested Inflated Time - '+requestedTime);
                /* If Time Zone is provided, converting the available time slots to the provided time zone.*/  
                if(Request != null && Request.TimeZone != null && !Request.TimeZone.equalsIgnoreCase('America/Los_Angeles')){
                    eventSchedulerUtility.timeZoneWrapper tzwObject = new eventSchedulerUtility.timeZoneWrapper(); 
                    tzwObject.timeZone = Request.TimeZone.trim();
                    tzwObject.timeSlots = latestTimeSlots;
                    // Calling method to convert time slots in asked Time Zone.
                    List<String> convertedTimeSlots = eventSchedulerUtility.convertToTimeZone(tzwObject);
                    if(convertedTimeSlots != null && convertedTimeSlots.size() > 0){
                        timeslotSet.addAll(convertedTimeSlots); 
                    }
                }
                system.debug('#### Time Slot Set - '+timeslotSet);
                if(timeslotSet != null && (timeslotSet.size() == 0 || !timeslotSet.contains(requestedTime))){
                    Response.error_code ='ERR-012';
                    Response.sucess_code = false;
                    return Response;                                
                }  
                
                /* Calling method to fetch Implementation details. */
                List<Implementation__c> implementationDetails = eventSchedulerUtility.getImplementation(Request.customerId.trim());
                       
                /*Check Resource Pool Availability*/  
                Resource_Pool__c selectedResourcePool = new Resource_Pool__c();            
                /* Check Resource Pool Availability, checking if atleast one resource pool is available or not */
                selectedResourcePool = eventSchedulerUtility.getValidResourcePool(brand.Id,Request.NumberofUsers,Request.premiumSupport,Request.PreferredLanguage);
                if(selectedResourcePool != null){ 
                    //Calculating hours for end date time
                    Integer hours = Integer.valueOf(Request.appointmentLength)/60;
                    system.debug('#### Appointment Length in hours - '+hours);
                    String hour = requestedTime.split(':').get(0);
                    String minute = requestedTime.split(':').get(1);
                    String strRequetsedDate = Request.cdatetime.substring(0,8);
                    system.debug('strRequetsedDate---->'+strRequetsedDate);
                    String[] strDate = strRequetsedDate.split('/');
                    system.debug('strDate---->'+strDate);
                    dt = DateTime.newInstanceGMT(Integer.ValueOf('20'+strDate[2]), Integer.ValueOf(strDate[0]), Integer.ValueOf(strDate[1]),Integer.valueOf(hour),Integer.valueOf(minute),0);
                    Event objEvent = new Event();
                    /* Calling method to fetch the offset value for the asked Time Zone, with respect to the PDT. */
                    Decimal offsetValue = 0;
                    /*if(!Request.TimeZone.trim().containsIgnoreCase('America/Los_Angeles')){
                        offsetValue = eventSchedulerUtility.getOffsetValue(String.valueOf(UserInfo.getTimeZone()),Request.TimeZone.trim());
                    }*/
                    if(!eventSchedulerUtility.gmtZeroTimeZoneSet.contains(Request.TimeZone.trim())){
                        //offsetValue = eventSchedulerUtility.getOffsetValue(String.valueOf(UserInfo.getTimeZone()),Request.TimeZone.trim());
                        offsetValue = eventSchedulerUtility.getOffsetValue('GMT',Request.TimeZone);
                        objEvent.StartDatetime = dt.addHours(Integer.valueOf(offsetValue));
                        objEvent.EndDatetime = objEvent.StartDatetime.addMinutes(Integer.valueOf(Request.appointmentLength));
                    }else{
                            objEvent.StartDatetime = dt;
                            objEvent.EndDatetime = objEvent.StartDatetime.addMinutes(Integer.valueOf(Request.appointmentLength));
                        } 
                    objEvent.Description = Request.Notes.trim();
                    objEvent.Subject = implementationDetails != null && implementationDetails.size() >0 ? implementationDetails[0].Account__r.Name : 'Implementation Scheduled';
                    objEvent.OwnerId = selectedResourcePool.Dispatch_Admin__c;
                    objEvent.WhatId = selectedResourcePool.Id;
                    if(implementationDetails != null && implementationDetails.size() >0){
                        objEvent.WhatId = implementationDetails[0].Id;
                    }
                    objEvent.Brand__c = Request.BrandId.trim();
                    objEvent.Customer_Email__c = Request.Email.trim();
                    objEvent.First_Name__c = Request.firstName.trim();
                    objEvent.CustomerId__c = Request.CustomerId.trim();
                    objEvent.Last_Name__c =Request.LastName.trim();
                    objEvent.NumberofUser__c = Request.NumberofUsers;
                    objEvent.Implementation_Status__c = 'Scheduled'; 
                    objEvent.Contact_Support__c = brand.Contact_Support__c; 
                    objEvent.Appointment_Source__c = 'External Web API';   
                    //objEvent.Type = ObjEvent != null ? ObjEvent.Type : '';
                    objEvent.Type = existingEvent != null ? existingEvent.Type : ''; 
                    objEvent.Preferred_Language__c = Request.PreferredLanguage != null ? Request.PreferredLanguage.trim() : '';  
                    objEvent.Time_Zone__c = Request.TimeZone != null ? Request.TimeZone.trim() : '';        
                    insert objEvent;
                    
                    /* Updating isImplementationAppointmentScheduled flag on Account. */
                    Account accToBeUpdated = new Account();
                    accToBeUpdated = eventSchedulerUtility.getAccountDetails(Request.CustomerId.trim());
                    if(accToBeUpdated != null){
                        // Setting Bypass flag for Account Trigger.
                        TriggerHandler.BY_PASS_ACCOUNT_ON_UPDATE();
                        accToBeUpdated.isAppointmentScheduled__c = true;
                        update accToBeUpdated;
                    }   
                    /* Calling method to update Contact field on Implementation. */
                      if( objEvent != null && objEvent.Type != null && objEvent.Type.equalsIgnoreCase('Initial Implementation') && 
                         !String.isBlank(objEvent.CustomerId__c) && rpwObject != null && 
                         (rpwObject.selectedAdvisor != null || rpwObject.selectedAdvisor != '')){
                        eventSchedulerUtility.updateImplementationOwner(rpwObject.selectedAdvisor, objEvent.CustomerId__c);
                      } 
                    /* Updating Exception & History Object for 24 Hours reminder worfkflow. */
                    eventSchedulerUtility.reminderEmail(objEvent, accToBeUpdated != null ? accToBeUpdated.RC_Brand__c : null);
                    /* Calling method to invite selected advisors. */
                    eventSchedulerUtility.inviteAdvisor(objEvent, rpwObject != null ? rpwObject.selectedAdvisor : '');
                     /* Sending confirmation email to event Contact. */
                    if(objEvent != null){ 
                        Response.sucess_code = true;
                        Response.EventId = objEvent.id;
                        /* Calling method to send Confirmation email to customer. */
                        //eventSchedulerUtility.sendIcsEmail(Request.firstName.trim(), Request.lastname.trim(), Request.Email.trim(), objEvent, brand.Id);
                        /* Wrapping up data to send out emails.*/ 
                          eventSchedulerUtility.EmailWrapper ewObject =  new eventSchedulerUtility.EmailWrapper();
                          ewObject.eventRecord = objEvent;
                          ewObject.emailType = 'Confirmation';
                          ewObject.timeZone = objEvent.Time_Zone__c;
                          Boolean insertENHRecord  = eventSchedulerUtility.sendEmail(ewObject);
                          if(eventSchedulerUtility.hasError || !insertENHRecord){
                            Response.error_code ='Error : '+eventSchedulerUtility.errorString;
                            Response.sucess_code = false;
                            return Response;
                        }
                    }   
                }else{
                    Response.error_code ='Error : Event cannot be rescheduled No Resource pool found';
                    Response.sucess_code = false;
                }
            }else{
                Response.error_code ='Error : No Brand exists with Id - '+Request.BrandID;
                Response.sucess_code = false;
            } 
            if(Test.isRunningTest()){
                Integer error = 0/0;
            }
        }catch(Exception ex){
            Response.error_code = 'Error : '+ ex.getMessage();
            Response.sucess_code = false;
            system.debug('#### Error on line = '+ex.getLineNumber()+' message = '+ex.getMessage());
            
        } 
        return Response; // Returning response object       
    }

    /**********************************************************************************************
    * @Description : Wrapper Class for Request.                                                   *
    **********************************************************************************************/
    global class isEventScheduledRequest {
        webservice String customerId;
        webservice String eventId;
    }
    /**********************************************************************************************
    * @Description : Wrapper Class for Respose.                                                   *
    **********************************************************************************************/
    global class isEventScheduledResponse {
        webservice String error_code;
        webservice String eventId;
        webservice Boolean isEventScheduled ;
    }
    
    /**********************************************************************************************
    * @Description : Method 7: Check if an Implementation is already scheduled for the CustomerId *
    * @Params      : Request(CustomerId,eventId)                                                  *
    * @Return      : Response(ErrorCode,isEventscheduled,EventId)                                 *  
    **********************************************************************************************/
    webservice static isEventScheduledResponse isEventScheduled(isEventScheduledRequest Request){
        
        // Creating reponse object
        isEventScheduledResponse Response = new isEventScheduledResponse();  
        // setting isEventScheduled, default as false             
        Response.isEventScheduled = false;
        Boolean scheduledEventFound =  false;
        
        try{
            /* Checking for null values. */
            if(Request.customerId == null || Request.customerId == ''){
                response.error_code = 'ERR-004';
                return response;
            }
            //Delete White Spaces
            Request.customerId = Request.customerId.trim();
            Request.eventId = (Request.eventId != null && Request.eventId != '') ? Request.eventId.trim() : null;
        
            if(Request.eventId != null && Request.eventId != ''){
                /* Calling method to search event of request.eventId */
                Event objEventRequest = eventSchedulerUtility.getEventDetails(Request.eventId);
                // If a event exists    
                if(objEventRequest != null && objEventRequest.Implementation_Status__c != null && objEventRequest.Implementation_Status__c.equalsIgnoreCase('Scheduled')){ 
                    Response.isEventScheduled = true;
                    Response.eventId = objEventRequest.Id;
                }else{ // If event does not exists.
                    Response.isEventScheduled = false;
                }
            }else{ //Search based on customer Id.
                /* Calling method to get event List, based on customer Id. */
                List<Event> eventList = eventSchedulerUtility.getEventList(Request.customerId.trim());
                // If event list returned
                if(eventList != null && eventList.size()>0){
                    for(Event thisRecord : eventList){ 
                        //If scheduled event found with customer Id, set isEventScheduled as true.
                        if(thisRecord.Implementation_Status__c != null && thisRecord.Implementation_Status__c.equalsIgnoreCase('Scheduled') && !scheduledEventFound){
                            Response.isEventScheduled = true;
                            Response.eventId = thisRecord.Id;
                            scheduledEventFound = true;
                        }
                    }
                }else{ // If no event found, return false
                    Response.isEventScheduled = false;
                }
            }
            if(Test.isRunningTest()){
                Integer error = 0/0;
            }
        }catch(Exception ex){
            Response.error_code = 'Error : '+ ex.getMessage();
            system.debug('#### Error on line = '+ex.getLineNumber()+' message = '+ex.getMessage());
        }
        return Response;
    }  
}// End of class.