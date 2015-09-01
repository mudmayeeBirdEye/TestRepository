/**************************************************************************************************
* Project Name..........: RingCentral - Self Serve Scheduling                                     *
* File..................: extAppointment.cls                                                      *
* Version...............: 1.0                                                                     *
* Created by............: Simplion Technologies                                                   *
* Created Date..........: 24 June 2013                                                            *
* Last Modified by......: Simplion Technologies                                                   *
* Last Modified Date....:                                                                         *
* Description...........: Controller class for Book,Cancel and Reschedule Appointment pages       *
**************************************************************************************************/
public class extAppointment {
     
    // Declaring Variables
    private Date startDate = date.newInstance(0001, 1, 1);
    public Date objDate {get; set;}
    static String CRLF = '\r\n';
    public String stringobjDate {get; set;}     
    public String Times {get; set;} // variable to contain appointment time
    public String appointmentLength {get; set;} // Variable to contain appointment length
    public String preferredLanguage {get;set;}
    public String associatedContact {get; set;}
    
    public schedulerConfiguration__c brandDetails {get; set;}
    public Contact contactDetails {get; set;}
    public String errorMessage {get; set;}
    public List<Event> eventList {get; set;}
    public static Contact contact {get; set;}
    
    /*Picklist variables*/
    public List<SelectOption> freeSlots {get; set;} // picklist to contain free slot
    public List<SelectOption> avbAppLength {get; set;} // picklist to contain available appointment length
    public List<SelectOption> avbPrefLanguage {get; set;} // picklist to contain available appointment length
    public List<SelectOption> avbTimeZone {get; set;} // picklist to contain different time zone
    public List<SelectOption> avbBrands {get; set;} // picklist to display all the available brands
    public List<SelectOption> avbContacts {get; set;} // picklist to display all the available brands
    public List<SelectOption> avbAdvisors {get; set;} // picklist to display list of all the available advisors.
    public List<SelectOption> avbAdvisorsTest {get; set;} // Test Field.
    //public List<SelectOption> getImplementationTypes {get; set;} // picklist to display all the types of events available.
    
    /*Flag variable to render different components*/
    public Boolean bookError {get; set;}
    public Boolean isImplemented {get; set;}
    public Boolean implementationError {get; set;}
    public Boolean iformdisabled {get; set;}
    public Boolean tformdisabled {get; set;}
    public Boolean dformdisabled {get; set;}
    public Boolean cancelform {get; set;}
    public Boolean errorMsg {get; set;}
    public Boolean errorMsg1 {get; set;}
    public Boolean errorMsg2 {get; set;}
    public Boolean errorMsg3 {get; set;}
    public Boolean menuFlag {get; set;} // Variable to render menu block.
    public Boolean linkFlag {get; set;} // Variable to render appointment link block.
    public Boolean iSchedulerError {get; set;} // Variable to render error message on implementation scheduler page.
    public Boolean appointmentToShow {get; set;} // Variable to render appointment page.
    public Boolean isAdvisorAvailable {get; set;} // Variable to render available advisor block.
    public Boolean isPrefLang {get; set;}// Variable to render preferred language div.
    public Boolean iappLength {get; set;} // Variable to render appointment length div
    public Boolean isTimeZone {get; set;} // Variable to render appointment length div
    
    /*Variable to contain mandatory fields*/
    public String customerId {get; set;} // Variable to contain RC User Id.
    public String brandId {get; set;} // Variable to contain Brand Name.
    public Integer noOfUser {get; set;} // Variable to contain # of user
    public Boolean premiumSupport {get; set;} // Variable to contain premiumSupport Flag.
    public String timeZone {get; set;} //  Variable to contain timeZone.
    public String accountId {get; set;} //  Variable to contain related Account Id.
    public String contactId {get; set;} // Variable to contain related Contact Id.
    public String implementationType {get; set;} // Variable to contain implementaion type
    public String implementationTypeCancel {get; set;} // Variable to contain implementaion type
    public String selectedAdvisor {get; set;}
    public String selectedAdvisorTest {get; set;}
    public String iType {get; set;}
    public Boolean isChangeContact{get;set;}
    public String contactIdChange {get; set;} // Variable to contain related Contact Id.
    
    /* variable for updating of RC Account related to the contact, 
    in case mandatory fields are not available.*/
    //public Account RCAccount {get; set;}
    public String impErrorMsg {get; set;} // Variable to contain error message for Implementation Panel
    // Map to caontain Account, Contact details.
    public Map<Id, Contact> accountContactMap = new Map<Id, Contact>();
    // Contains list of Implementation related to a Customer Id.
    public List<Implementation__c> implementationList = new List<Implementation__c>();
    // Map to contains timeSlot, list of advisors on that time.
    public Map<Id,Set<String>> availableAdvisorsMap = new Map<Id,Set<String>>();
    // Map to contain available advisor details.
    public Map<Id, Advisor__c> advisorMap =  new Map<Id, Advisor__c>();
    // Wrapper object to fetch time slot, and advisor list result.
    public eventSchedulerUtility.timeAdvisorWrapper tawObject = new eventSchedulerUtility.timeAdvisorWrapper();
    // Map to store Appointment number and Appointment Type.
    public Map<Integer, String> appointmentTypeMap =  new Map<Integer, String>{ 0 => 'Initial Implementation',
                                                                                1 => 'Follow-Up Implementation 1',
                                                                                2 => 'Follow-Up Implementation 2',
                                                                                3 => 'Follow-Up Implementation 3',
                                                                                4 => 'Follow-Up Implementation 4',
                                                                                5 => 'Follow-Up Implementation 5'};
    // Contains resource pool depending on, Brand, No of DL's and
    public Resource_Pool__c availableResourcePool = new Resource_Pool__c();
    
    public static Boolean toExecute;
    /******************************************************************************
    * Constructor for controller class                                            *
    * @params void                                                                *
    * @return void                                                                *
    ******************************************************************************/
    public extAppointment() {
        try{
        // Calling method for initialization.
        objectInitializer();
        //Fetching time zone value for logged in user
        //timeZone = System.now().format('z');
        //grab contact Id from the query strings parameters of url.
        contactId = ApexPages.currentPage().getParameters().get('contactId');
        //grab customer Id from the query strings parameters of url.
        customerId = ApexPages.currentPage().getParameters().get('rcUserId');
        //grab iType from the query strings parameters of url.
        iType = ApexPages.currentPage().getParameters().get('iType');
        if(iType != null && iType.equals('0')){
            implementationType = 'Initial Implementation';
        }else if(iType != null){
            implementationType = 'Follow-Up Implementation '+iType;
        }
        
        /* Debug Logs */
        system.debug('#### timeZone at Constructor - '+timeZone);
        system.debug('#### customerId at Constructor - '+customerId);
        system.debug('#### Implementation Type - '+implementationType);
        system.debug('#### iType - '+iType);
        
        //Checking if contactId is available or not
        if(contactId != null && !contactId.equalsIgnoreCase('null') && contactId != ''){
            
            getAllBrands();// Calling method to fetch all the available brands
            contactDetails = getContact(contactId);// Calling method to fetch contact details
            accountContactMap = getAccountsContact(contactDetails.AccountId);
            //Checking if any Account is associated to contact or not.
            if(accountId != null){
                // Check for null values for mandatory fields
                if(String.isBlank(customerId) || String.isBlank(brandId) || (noOfUser == null || noOfUser == 0)){
                    impErrorMsg = 'Required field(s) missing.';
                    menuFlag = true;
                    linkFlag = false;
                }else {
                    setBrandDetails();
                }
                
                system.debug('#### customerId fetched from getContacts method - '+customerId);
                // Calling method to fetch available advisors
                    
                // Calling method to fetch all available contacts.
                getAllContacts(accountId);
                avbPrefLanguage = getPreferedLanguage();
                fetchAvailableAdvisors();
                //Fetch events related to the customer Id
                if(customerId != null){
                    // Calling utility method to fetch event details
                    eventList = eventSchedulerUtility.getEventList(customerId); 
                    // Calling utility method to fetch Implementation Details.
                    implementationList = eventSchedulerUtility.getImplementation(customerId);
                    // If not event details fetched, display the below validation error message.
                    if(eventList != null && eventList.size() > 0){
                    }else{
                        isImplemented = false;
                        implementationError = true;
                        if(errorMessage == null){
                            errorMsg2 = true;
                            errorMessage = 'Event not found. The UserID which was used to create the Event may be different from the UserID on the Account.';
                        }
                    }
                }else{
                    errorMessage = 'No Customer Id associated with Contact.';
                    bookError = true;
                    dformdisabled = false;
                    errorMsg2 = true;
                }
                
                //Checking if implementation status 2 field is completed for any of the associated implementation
                isImplementationCompleted();
                
            }else{
                errorMessage = 'No associated Account found.';
                iSchedulerError = true;
                bookError = true;
                dformdisabled = false;
                linkFlag =  false;
                menuFlag =  false;
            }
        }else{
            errorMessage = 'No associated Contact found.';
            iSchedulerError = true;
            bookError = true;
            dformdisabled = false;
            linkFlag =  false;
            menuFlag =  false;
        }
        system.debug('#### Error Message @ Constructor - '+errorMessage);
    }catch(Exception ex){
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,ex.getMessage()+'-----Line--->'+ex.getLineNumber()));
        errorMsg = true;
        errorMessage = 'ResourcePool is not available.';
    }
  } 
   
  
  public list<schedulerConfiguration__c> getBrandsList(){
    
    return [SELECT Name,Id,Brand_Id__c,Contact_Support__c,Buffer_Days__c
                                                     FROM schedulerConfiguration__c
                                                     WHERE Name =: brandId.trim() and Preferred_Language__c =:preferredLanguage limit 1];
  } 
   
  public void setBrandDetails(){
        setDefaultValues(brandId);
        system.debug('#### brandId = '+brandId);
        system.debug('#### Time Zone = '+timezone);
        system.debug('#### Preferred Language = '+preferredLanguage);
                    
        List<schedulerConfiguration__c> brandList = getBrandsList();
        bookError = false; // Render component to show error message, [booking screen]
        dformdisabled = true; // Disable booking component, [booking screen]
        errorMsg2 = false; // Render component to show error message, [cancel screen]                
        system.debug('brandList--->'+brandList);
               if(brandList.size()== 0){
                        bookError = true; // Render component to show error message, [booking screen]
                        dformdisabled = false; // Disable booking component, [booking screen]
                        errorMsg2 = true; // Render component to show error message, [cancel screen]
                        errorMessage = 'Brand associated with the Contact has been deleted or doesn\'t exist.';
               }else{
                        brandDetails = brandList[0];
                        if(contactDetails != null && brandDetails != null){
                            availableResourcePool = eventSchedulerUtility.getValidResourcePool(brandDetails.Id,Integer.valueOf(contactDetails.Account_Number_of_DLs__c),premiumSupport,preferredLanguage);
                        }
               }
  }
  
  public map<String,String> mapLanguage = new map<String,String>();
  public List<SelectOption> getPreferedLanguage() {
      system.debug('inside getPreferedLanguage');
    // isChangeContact=false;
      List<SelectOption> options = new List<SelectOption>();
        try { 
            //contactId=null;
            contactId = ApexPages.currentPage().getParameters().get('contactId');
            system.debug('####$1 contactId - '+ contactId);
            contactIdChange = associatedContact;
            system.debug('####$2 contactIdChange - '+ contactIdChange);
            if(contactIdChange != null){
            contactId = contactIdChange;    
            } 
            system.debug('####$3 contactId - '+ contactId);
            contactDetails = getContact(contactId);// Calling method to fetch contact details
            String selLanguage=null;
            String AccId=null;
            //isChangeContact=false;
            //selLanguage = contactDetails.Preferred_Language__c;
            AccId = contactDetails.AccountId;
        try{
            //getAllContacts(AccId);
             //contactDetails = getContact(contactId);
           //accountContactMap = getAccountsContact(AccId);
          //  boolean flag; 
            if(accountContactMap != null){
                for(Contact thisContact : accountContactMap.Values()){
                    system.debug('####$ fetching all contacts - '+thisContact);
                    system.debug('####$ thisContact.AccountContactRoles.size - ' + thisContact.AccountContactRoles.size());
                    if(thisContact.id == associatedContact){
                        selLanguage = thisContact.Preferred_Language__c;
                         if(thisContact.AccountContactRoles.size()>0){     
                            system.debug('####$ thisContact.AccountContactRoles.size - ' + thisContact.AccountContactRoles.size());
                         for(AccountContactRole acRole : thisContact.AccountContactRoles){
                            system.debug('####$ fetching all contacts acRole -> '+acRole);
                             if(acRole.ContactId == associatedContact && acRole.isPrimary == true ){
                            //if(acRole.ContactId == associatedContact && acRole.isPrimary == true ){
                               //isChangeContact=true;
                              // flag=true;
                               system.debug('####$1 isChangeContact - '+ isChangeContact);
                               system.debug('####$ acRole.ContactId - '+ acRole.ContactId);
                               system.debug('####$ contactId - '+contactId);
                               system.debug('####$ acRole.isPrimary - '+ acRole.isPrimary);
                             }else{
                                //isChangeContact=false;
                                //flag=false;
                            //  system.debug('####$2 isChangeContact - '+ isChangeContact);  
                            }
                         }
                    }
                }      
            }         
            }
            
        /*   if(flag == false ){
                isChangeContact=false;  
            }  */
            system.debug('####$ isChangeContact - '+ isChangeContact); 
        }catch(Exception ex){
            system.debug('#### Exception @ getAllContacts - '+ex.getMessage());
        } 
            

            options.add(new SelectOption('en_US','English(US)'));
            options.add(new SelectOption('fr_CA','French (CA)'));
            options.add(new SelectOption('en_GB','English(UK)'));
            mapLanguage.put('en_US','English(US)');
            mapLanguage.put('fr_CA','French (CA)');
            mapLanguage.put('en_GB','English(UK)');
                if(contactDetails != null && selLanguage != null){
                     preferredLanguage = selLanguage;
                     system.debug('####$ preferredLanguage - '+ preferredLanguage);
                }else{
                    preferredLanguage = 'en_US';
                }
                setBrandDetails();
        } catch(Exception ex) {}
        return options;
    }
    
  
  public List<SelectOption> getTimeZone() {
      system.debug('#### inside getTimeZone');
      // //isChangeContact=true;
      List<SelectOption> options = new List<SelectOption>();
        try {  
            contactIdChange=null;
            contactIdChange = associatedContact;
            system.debug('####$2 contactIdChange - '+ contactIdChange);
            if(contactIdChange != null){
            contactId = contactIdChange;    
            } 
            system.debug('####$3 contactId - '+ contactId);
            contactDetails = getContact(contactId);// Calling method to fetch contact details
             String strTimeZone = UserInfo.getTimeZone() + '';
            system.debug('####$1 strTimeZone - '+ strTimeZone);
            options.add(new SelectOption('America/Los_Angeles','America/Los_Angeles'));
            options.add(new SelectOption('America/Denver','America/Denver'));
            options.add(new SelectOption('Europe/London','Europe/London')); 
                if(strTimeZone != null){
                     timeZone = strTimeZone;
                     system.debug('####$ timeZone - '+ timeZone);
                }
        } catch(Exception ex) {}
        return options;
    }
    /*****************************************************************************
    * @Description : Method to initialise objects and variable.                  *
    * @Params      : void                                                        *
    * @Return      : void                                                        *
    *****************************************************************************/
    public void objectInitializer(){
        tformdisabled=false; // Flag to render component after, successfull booking.
        dformdisabled=true; // Booking component.
        cancelform=false; // Cancel component.
        isImplemented = true; // Re-Schedule component.
        iappLength =  false; // Appointment length component.
        isPrefLang = true; // Preferred language component.
        isTimeZone = false; // Time Zone component.
        iformdisabled = false; // Available Slots.
        contact = new Contact(); // initialising contact object.
        //brandDetails = new schedulerConfiguration__c();
        menuFlag = false; // Flag to render missing field error block.
        linkFlag = true; // Flag to render appoinment link flag.
        iSchedulerError =  false; // Flag to render error message component on implementation scheduler page.
        appointmentToShow = true; // Flag to render render appointment page.
        isAdvisorAvailable = false;// Flag to render available advisor block.
        advisorMap = fetchAdvisors();// Calling method to fetch and store advisor details as a map.
        // Display the advisor block, only for the profiles set in the custom setting.
        Set<String> availableProfiles = new Set<String>();
        /* Calling method to fetch the values from the Implementation Scheduler custom setting.*/
        availableProfiles = fetchProfileCustomSetting();
        system.debug('#### (UserInfo.getTimeZone()=====>  '+UserInfo.getTimeZone());
        system.debug('#### Available Profiles in Custom Setting - '+availableProfiles);
        system.debug('#### User Profile - '+UserInfo.getProfileId());
        ////isChangeContact=true;
        avbPrefLanguage = new List<SelectOption>();
        avbPrefLanguage = getPreferedLanguage(); 
        
        avbTimeZone = new List<SelectOption>();
        avbTimeZone=getTimeZone();
                  
        if(availableProfiles != null && availableProfiles.size() > 0 && availableProfiles.contains(UserInfo.getProfileId())){
            isAdvisorAvailable = true;
        }
    }
    
    /**********************************************************************************************
    * @Description : Method to display picklist for event types.                                  *
    * @Params      : void                                                                         *
    * @Return      : List<SelectOption>                                                           *
    **********************************************************************************************/
    public List<SelectOption> getImplementationTypes(){
        
        List<String> implementationTypes =  new List<String>();
        List<SelectOption> eventOptions = new List<SelectOption>();
        
        if(eventList != null){
            for(Event thisRecord : eventList){
                if(thisRecord.Type != null){
                    implementationTypes.add(thisRecord.Type);
                }   
            }
        }
        implementationTypes.sort();
        for(String thisRecord : implementationTypes){
            eventOptions.add(new SelectOption(thisRecord,thisRecord));  
        }
        return eventOptions;
    }
    
    /**********************************************************************************************
    * @Description : Utility class to fetch contact details                                       *
    * @Params      : contact Id                                                                   *
    * @Return      : void                                                                         *
    **********************************************************************************************/
    public Contact getContact(String contactId){
        try{
            contact = [ SELECT Id,Preferred_Language__c,Account_Brand__c,Account_Number_of_DLs__c,AccountId,FirstName,LastName,Email,Name,User_Id__c,
                        Account.RC_Brand__c,Account.Number_of_DL_s__c,Account.RC_User_ID__c,Account.Entitled_to_Premium_Support__c,
                        Account.Name
                        FROM Contact
                        WHERE Id =: contactId.trim() LIMIT 1];
            brandId = contact.Account_Brand__c;
            //premiumSupport = contact.Account.Entitled_to_Premium_Support__c != null ? contact.Account.Entitled_to_Premium_Support__c : false;
            premiumSupport = false;
            customerId = String.isBlank(customerId) ? contact.Account.RC_User_ID__c:customerId;
            noOfUser = Integer.valueOf(contact.Account.Number_of_DL_s__c)== 0 ? null : Integer.valueOf(contact.Account.Number_of_DL_s__c);
            accountId = contact.AccountId;
            system.debug('#### accountId - '+accountId +' , CONTACT Id = ' + contactId);
            if(accountId == null){
                errorMessage = 'No associated Account found.';
                iSchedulerError = true;
                bookError = true;
                dformdisabled = false;
                linkFlag =  false;
                menuFlag =  false;
                return null;
            }
            system.debug('#### toExecute - '+toExecute);
            if(toExecute != null && toExecute){
                Integer error = 0/0;
            }
            return contact;
        }catch(Exception e){
            errorMessage = 'No associated Contact found.';
            bookError = true;
            dformdisabled = false;
            return null;
        }
    }
    
    /**********************************************************************************************
    * @Description : Utility class to fetch contact details for an Account.                       *
    * @Params      : Id                                                                           *
    * @Return      : List<Contact>                                                                *
    **********************************************************************************************/
    public Map<Id,Contact> getAccountsContact(Id accountId){
        return (new Map<Id,Contact>([SELECT Id,Preferred_Language__c,(Select Id, AccountId, ContactId, Role, IsPrimary From AccountContactRoles where isPrimary=true and AccountId =: accountId),Name, Account.Most_Recent_Implementation_Contact__c, Email, FirstName,
        LastName, Account_Number_of_DLs__c
        FROM Contact
        WHERE AccountId =: accountId order by LastModifiedDate desc]));
    }
    
    /**********************************************************************************************
    * @Description : Method to fetch all the available brands.                                    *
    * @Params      : void                                                                         *
    * @Return      : void                                                                         *
    **********************************************************************************************/
    public void getAllBrands(){
        avbBrands = new List<SelectOption>();
        avbBrands.add(new SelectOption('',''));
        for(schedulerConfiguration__c thisBrand : [SELECT Id,Name FROM schedulerConfiguration__c]){
            //system.debug('#### fetching all brands - '+thisBrand);
            avbBrands.add(new SelectOption(thisBrand.Name,thisBrand.Name));
        }
    }
    
    /**********************************************************************************************
    * @Description : Method to fetch all the available brands.                                    *
    * @Params      : void                                                                         *
    * @Return      : void                                                                         *
    **********************************************************************************************/
    public void getAllContacts(Id accountId){
        try{
            accountContactMap = getAccountsContact(accountId);
            avbContacts = new List<SelectOption>();
            //avbContacts.add(new SelectOption('',''));
            String primaryAssociatedContact = null;
            String mostRecentContact = null;
            String recentModifiedContact = null;
            boolean isRecentUpdated = true;
            if(accountContactMap != null){
                for(Contact thisContact : accountContactMap.Values()){
                    //system.debug('#### fetching all contacts - '+thisContact);
                    avbContacts.add(new SelectOption(thisContact.Id,thisContact.Name+' - '+thisContact.Email));
                    if(isRecentUpdated){
                    	recentModifiedContact = thisContact.Id;
                    	isRecentUpdated = false;
                    }
                     mostRecentContact = thisContact.Account.Most_Recent_Implementation_Contact__c;
                    if(thisContact.AccountContactRoles.size()>0){                    
                    for(AccountContactRole acRole : thisContact.AccountContactRoles){
                        if(acRole.IsPrimary){
                            //associatedContact = acRole.ContactId;
                            primaryAssociatedContact = acRole.ContactId;
                        }else{
                            //associatedContact = thisContact.Account.Most_Recent_Implementation_Contact__c;
                           
                        }
                    /*if(contactId != null){
                        associatedContact = contactId;
                    }else{
                        associatedContact = thisContact.Account.Most_Recent_Implementation_Contact__c;
                    }*/
                    }
                    }
                }
                
                if(primaryAssociatedContact != null){
                    associatedContact = primaryAssociatedContact;
                }else if(mostRecentContact != null){
                    associatedContact = mostRecentContact;
                }else{
                	associatedContact = recentModifiedContact;
                }
            }
        }catch(Exception ex){
            system.debug('#### Exception @ getAllContacts - '+ex.getMessage());
        }
    }
    
    
    
    /**********************************************************************************************
    * @Description : Method to display list of available advisors, as per the time slot.          *
    * @Params      : void                                                                         *
    * @Return      : void                                                                         *
    **********************************************************************************************/
    public void fetchAvailableAdvisors(){
        
        avbAdvisors = new List<SelectOption>(); 
        avbAdvisorsTest =  new List<SelectOption>();
        avbAdvisors.add(new SelectOption('','-- None --'));
        system.debug('availableResourcePool---->'+availableResourcePool);
        /* Calling method to fetch resource pool resources/advisors */
        eventSchedulerUtility.advisorRequestWrapper arwObject = new eventSchedulerUtility.advisorRequestWrapper();
            if(availableResourcePool != null && availableResourcePool.Id != null){// && arwObject != null){
                arwObject.ResourcePoolId = availableResourcePool.Id;  
            }else{
                errorMsg = true;
                errorMessage = 'ResourcePool is not available.';
            }
        
       // arwObject.preferredLanguage = 'en_US';
        arwObject.preferredLanguage = preferredLanguage;
        
        try{
            if(availableResourcePool != null && eventSchedulerUtility.getAvailableAdvisors(arwObject) != null){
                for(Advisor__c thisRecord : eventSchedulerUtility.getAvailableAdvisors(arwObject)){
                    avbAdvisors.add(new SelectOption(thisRecord.Advisor_Name__c,thisRecord.Advisor_Name__r.Name));
                }
            }
            system.debug('#### tawObject - '+tawObject);
            system.debug('#### tawObject - '+tawObject);
            system.debug('#### availableAdvisorsMap - '+tawObject.availableAdvisors);
          /*  if(tawObject.availableAdvisors != null){
                availableAdvisorsMap = tawObject.availableAdvisors;
            }else{
                errorMsg = true;
                errorMessage = 'Advisors are not available.';
            }*/
            /*
            if(availableAdvisorsMap != null && Times != null && availableAdvisorsMap.get(Times) != null){
                for(Id thisRecord : availableAdvisorsMap.get(Times)){
                    if(advisorMap != null && advisorMap.get(thisRecord) != null){
                        avbAdvisorsTest.add(new SelectOption(thisRecord,advisorMap.get(thisRecord).Advisor_Name__r.Name));
                    }
                }
                isAdvisorAvailable =  true;
            }
            */
        }catch(Exception ex){
            system.debug('#### Exception @ fetchAvailableAdvisors - '+ex.getMessage());
            errorMsg = true;
            errorMessage = 'Advisors are not available.';
            
        }
    }
    /**********************************************************************************************
    * @Description : This class fetches list of Time Zone & Appointment Length.                   *
    * @Params      : void                                                                         *
    * @Return      : pagereference                                                                *
    **********************************************************************************************/
    public PageReference getPreferedLangMethod(){
    	isChangeContact=false;
    	errorMsg = false;
    	iappLength = false;
    	isPrefLang = false;
        isTimeZone = false;
        stringobjDate='';
    	errorMessage = '';
    	preferredLanguage = accountContactMap.get(associatedContact).Preferred_Language__c;
    	system.debug('preferredLanguage--->'+preferredLanguage);
    	system.debug('brandId--->'+brandId);
    	if(accountContactMap.get(associatedContact).AccountContactRoles.size()>0){
    		AccountContactRole accConRole = accountContactMap.get(associatedContact).AccountContactRoles;
    		if(accConRole.isPrimary){
    			//isChangeContact=true;
    		}
    	}
    	List<schedulerConfiguration__c> brandList = getBrandsList();
    	system.debug('brandList  --->'+brandList);
        if(brandList.size()>0){
        }else{
        	if(isChangeContact==false && preferredLanguage!=null){
	            errorMessage = 'Brand associated with the Preferred Language [ '+mapLanguage.get(preferredLanguage)+' ] has been deleted or doesn\'t exist.';
	            errorMsg = true;
	            //iformdisabled=false;
	            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, errorMessage);
	            ApexPages.addMessage(myMsg);
	            return null;
        	}
        }
        avbPrefLanguage = new List<SelectOption>();
        avbPrefLanguage = getPreferedLanguage();
         
        avbTimeZone = new List<SelectOption>();
        avbTimeZone=getTimeZone();
        
        
        return null;
    }
    /**********************************************************************************************
    * @Description : This class fetches list of Time Zone & Appointment Length.                   *
    * @Params      : void                                                                         *
    * @Return      : pagereference                                                                *
    **********************************************************************************************/
    public pagereference AppointmentLength(){
        List<schedulerConfiguration__c> brandList = getBrandsList();
        if(brandList.size()>0){
            brandDetails = brandList[0];
        }else{
             errorMessage = 'Brand associated with the Preferred Language [ '+mapLanguage.get(preferredLanguage)+' ] has been deleted or doesn\'t exist.';
            errorMsg = true;
            iformdisabled=false;
            return null;
        }
        errorMsg  = false;
        errorMsg1 = false;
        iformdisabled = false;
        iappLength = true;
        isPrefLang = true;
        isTimeZone = true;
        system.debug('#### customerId 208 - '+customerId);
        
        // Check for null date
        if(stringobjDate==null || stringobjDate==''){
            errorMsg = true;
            errorMessage = 'Appointment Date cannot be blank.';
            iappLength = false;
            isPrefLang = false;
            isTimeZone = false;
            return null;
        }
        
        //Parsing the string date into date object.
        try{
            system.debug('stringobjDate---->'+stringobjDate);
       // String dateFormat = stringobjDate,replaceAll('/','-');
       String[] strDate = stringobjDate.split('/');
       // objDate = Date.parse(stringobjDate);
        //DateTime gmtDateTime= DateTime.newInstanceGMT(Integer.ValueOf(strDate[2]), Integer.ValueOf(strDate[0]), Integer.ValueOf(strDate[1]),0,0,0);
        objDate = Date.newInstance(Integer.ValueOf(strDate[2]), Integer.ValueOf(strDate[0]), Integer.ValueOf(strDate[1]));
        //objDate = gmtDateTime.date();
        System.debug('objDate------>'+objDate);
        Date todayDate = date.TODAY();
        //Checking if the appointment date is for past date.
        if(brandDetails != null && objDate < todayDate.addDays(Integer.valueOf(brandDetails.Buffer_Days__c))){
            errorMsg =true;
            errorMessage = 'Please select an active date from the calendar.';
            iformdisabled=false;
            return null;
        }
        }catch(Exception ex){
            system.debug(ex);
        }
        //Checking if appointment date is lying on weekends or not.
        if(calculateDayOfDate(objDate) =='Saturday'|| calculateDayOfDate(objDate) =='Sunday'){
            errorMsg =true;
            errorMessage = 'Please select day other than Saturday / Sunday.';
            iformdisabled=false;
            return null;
        }
        else{
            avbAppLength = new List<SelectOption>();
            avbAppLength.add(new SelectOption('60','60'));
            /*avbAppLength.add(new SelectOption('30','30'));*/
            avbAppLength.add(new SelectOption('90','90'));
            avbAppLength.add(new SelectOption('120','120'));
       
         return null;
        }
    }
    
    /**********************************************************************************************
    * @Description : This class fetches the available time slot                                   *
    * @Params      : void                                                                         *
    * @Return      : pagereference                                                                *
    **********************************************************************************************/
    public pagereference AvailabletimeSlot(){
        List<schedulerConfiguration__c> brandList = getBrandsList();
        if(brandList.size()>0){
            brandDetails = brandList[0];
        }else{
            errorMessage = 'Brand associated with the Preferred Language [ '+mapLanguage.get(preferredLanguage)+' ] has been deleted or doesn\'t exist.';
            errorMsg = true;
            iformdisabled=false;
            return null;
        }
        selectedAdvisor = null;
        system.debug('#### (UserInfo.getTimeZone()=====>  '+UserInfo.getTimeZone());
        //system.debug('GMT == PST deifference---->'+eventSchedulerUtility.getOffsetValue('GMT','PST'));
       // system.debug('GMT == PDT deifference---->'+eventSchedulerUtility.getOffsetValue('GMT','PDT'));
       // system.debug('PST == PDT deifference---->'+eventSchedulerUtility.getOffsetValue('PST','PDT'));
       //  system.debug('PST == MST deifference---->'+eventSchedulerUtility.getOffsetValue('PST','MST'));
         
        //eventSchedulerUtility.timeAdvisorWrapper tawObject = new eventSchedulerUtility.timeAdvisorWrapper();
        // Wrapper to wrap the request parameter values.
        eventSchedulerUtility.requestParameterWrapper rpwObject =  new eventSchedulerUtility.requestParameterWrapper();
        // Contains the type of event, initial Implementation type or follow-up type.
        String eventType;
        // Contains the number of appointments booked on an Implementation.
        Integer isInitialAppointment;
        // Initialising picklist variable.
        freeSlots = new List<SelectOption>();
        // Setting flags for rendering/displaying component.
        iformdisabled = true;
        errorMsg = false;
        errorMsg1 = false;
        // Fetching current system context time zone.
        //timeZone = System.now().format('z');
        List<String> convertedTimeSlots = new List<String>();
        
        system.debug('$$$$ brandDetails.Id - '+brandDetails.Id);
        system.debug('$$$$ # of DL - '+Integer.valueOf(contactDetails.Account_Number_of_DLs__c));
        system.debug('$$$$ Date - '+string.valueOf(objDate));
        system.debug('$$$$ appointmentLength - '+appointmentLength);
        system.debug('$$$$ premiumSupport - '+premiumSupport);
        system.debug('$$$$ customerId - '+customerId);
        system.debug('$$$$ timeZone - '+timeZone);
        system.debug('$$$$ selectedAdvisor - '+selectedAdvisor);
        system.debug('$$$$ implementation type if any from reschedule - '+implementationType);
        
        try{
            // Requirement changes as per IS Q2 Project
            if(customerId != null && objDate != null){
                isInitialAppointment = eventSchedulerUtility.isInitialAppointmentScheduled(customerId, Date.valueOf(String.valueOf(objDate)));
                eventType = isInitialAppointment <= 5 ? appointmentTypeMap.get(isInitialAppointment) : ('Follow-Up Implementation '+isInitialAppointment);
                system.debug('#### appointmentTypeMap - '+appointmentTypeMap);
                system.debug('#### eventType - '+eventType);
            }
            
            /* Wrapping request parameter */ 
            rpwObject.BrandId = brandDetails.Id;
            rpwObject.NumberOfUsers = Integer.valueOf(contactDetails.Account_Number_of_DLs__c);
            rpwObject.appointmentDate = string.valueOf(objDate);
            rpwObject.appointmentLength = appointmentLength;
            system.debug('#### preferredLanguage - '+preferredLanguage);
            rpwObject.preferredLanguage = preferredLanguage; 
            rpwObject.premiumSupport = premiumSupport;
            rpwObject.eventType = eventType;
            rpwObject.selectedAdvisor = selectedAdvisor;
            rpwObject.timeZone = timeZone;
            
            // Fetching available time slots
            tawObject = eventSchedulerUtility.availableTimeSlots(rpwObject);
            system.debug('#### tawObject - '+tawObject);
            system.debug('#### selected advisor - '+selectedAdvisor);
            
            if(tawObject != null){
                /* If advisor selected, fetch his available time slots. 
                   If no time slot avilable, display proper error message. */
                if(selectedAdvisor != null && selectedAdvisor != '' && tawObject != null && 
                    tawObject.availableAdvisors != null && tawObject.availableAdvisors.size() > 0){
                    
                    if(tawObject.availableAdvisors.get(selectedAdvisor) == null || 
                       (tawObject.availableAdvisors.get(selectedAdvisor) != null && tawObject.availableAdvisors.get(selectedAdvisor).size() == 0)){
                        errorMessage = 'There are no time slots available for the selected advisor. Please select a different advisor or a different date.';
                        errorMsg = true;
                        iformdisabled=false;
                        return null;
                    }
                    if(tawObject.availableAdvisors.get(selectedAdvisor) != null){
                        List<String> timeSlots = new List<String>();
                        timeSlots.addAll(tawObject.availableAdvisors.get(selectedAdvisor));
                        timeSlots.sort();
                        // Calling method to convert list of timeslot in displayable format.
                        freeSlots = convertTimeslot(timeSlots);
                        system.debug('freeSlots --->'+freeSlots);
                         system.debug('timeSlots --->'+timeSlots);
                        convertedTimeSlots.addAll(timeSlots);
                    }
                /* If no advisor selected, fetch all available time slots under selected resource pool.
                   If no time slot avilable, display proper error message. */
                }else{
                    if(tawObject != null && tawObject.availableTimeSlots != null){
                        if(tawObject.availableTimeSlots.size() == 0){
                            errorMessage = 'There are no time slots available on the specified date, for that length of time. Please select a different date.';
                            errorMsg = true;
                            iformdisabled=false;
                            return null;
                        }
                        freeSlots = convertTimeslot(tawObject.availableTimeSlots);
                        convertedTimeSlots.addAll(tawObject.availableTimeSlots);
                    }
                }
                
                system.debug('#### Time Zone = '+timeZone);
                system.debug('#### Converted Time Slots = '+convertedTimeSlots);
                
                /* If Time Zone is provided, converting the available time slots to the provided time zone.*/  
                //!timeZone.equalsIgnoreCase('America/Los_Angeles') &&
                if((timeZone != null && String.valueOf(UserInfo.getTimeZone()) != timeZone) && 
                    convertedTimeSlots != null && convertedTimeSlots.size() > 0){
                    eventSchedulerUtility.timeZoneWrapper tzwObject = new eventSchedulerUtility.timeZoneWrapper(); 
                    tzwObject.timeZone = timeZone;
                    tzwObject.timeSlots = convertedTimeSlots;
                    // Calling method to convert time slots in asked Time Zone.
                    system.debug('#### Selected Time Zone = '+timeZone);
                    freeSlots = new List<SelectOption>(); 
                    freeSlots = convertTimeslot(eventSchedulerUtility.convertToTimeZone(tzwObject));    
                }
                for(SelectOption thisRecord : freeSlots){
                    system.debug('#### Free Slots to be Displayed in UI = '+thisRecord);
                }
            }else{
                errorMessage = 'There are no time slots available on the specified date.';
                errorMsg = true;
                iformdisabled=false;    
            }
        }catch(Exception ex){
            system.debug('#### Error at line - '+ex.getLineNumber()+' == '+ex.getMessage());
        }
        return null;
    }
    
    /**********************************************************************************************
    * @Description : This class creates the event and sends an confirmation email                 *
    * @Params      : void                                                                         *
    * @Return      : pagereference                                                                *
    **********************************************************************************************/
    public pagereference Onsave(){
        List<schedulerConfiguration__c> brandList = getBrandsList();
        if(brandList.size()>0){
            brandDetails = brandList[0];
        }else{
            errorMessage = 'Brand associated with the Preferred Language [ '+mapLanguage.get(preferredLanguage)+' ] has been deleted or doesn\'t exist.';
            errorMsg = true;
            iformdisabled=false;
            return null;
        }
        // Contains decimal off set value;
        Decimal offsetValue = 0;
        String hour = Times.split(':').get(0);
        String minute = Times.split(':').get(1);
        String second = '00';
        String stringDate;
        //stringDate = String.valueof(objDate)+' '+ hour + ':' + minute +  ':' + second ;
        //Datetime myDate = datetime.valueOf(stringDate);
        //Datetime myDate =  DateTime.newInstance(objDate, Time.newInstance(Integer.valueOf(hour), Integer.valueOf(minute), 0, 0));
        Datetime myDate =  DateTime.newInstanceGMT(objDate.Year(),objDate.Month(),objDate.Day(),Integer.valueOf(hour), Integer.valueOf(minute), 0);
        Event eventobj = new Event();
        system.debug('offsetValue--- myDate----->'+myDate);
        /*if(!timeZone.containsIgnoreCase('Europe/London')){
            offsetValue = eventSchedulerUtility.getOffsetValue('GMT',timeZone);
            eventobj.StartDatetime = myDate.addHours(Integer.valueOf(offsetValue));
            system.debug('StartDatetime- After------->'+eventobj.StartDatetime);
            eventobj.EndDatetime = eventobj.StartDatetime.addMinutes(Integer.valueOf(appointmentLength));
            system.debug('EndDatetime- After------->'+eventobj.EndDatetime);
        }else{
            
            eventobj.StartDatetime = myDate;
            system.debug('StartDatetime--inisde else------>'+eventobj.StartDatetime);
            eventobj.EndDatetime = eventobj.StartDatetime.addMinutes(Integer.valueOf(appointmentLength));
            system.debug('EndDatetime--inside else------>'+eventobj.EndDatetime);
            
        } */
        
          offsetValue = eventSchedulerUtility.getOffsetValue('GMT',timeZone);
            eventobj.StartDatetime = myDate.addHours(Integer.valueOf(offsetValue));
            system.debug('StartDatetime- After------->'+eventobj.StartDatetime);
            eventobj.EndDatetime = eventobj.StartDatetime.addMinutes(Integer.valueOf(appointmentLength));
            system.debug('EndDatetime- After------->'+eventobj.EndDatetime);
            
        // Contains the type of event, initial Implementation type or follow-up type.
        String eventType;
        // Contains the number of appointments booked on an Implementation.
        Integer isInitialAppointment;
        // Contains latest time slots.
        List<String> latestTimeSlots =  new List<String>();
        
        Set<String> timeslotSet = new Set<String>();
        Integer cpuLimitStart = Limits.getCpuTime();
        system.debug('#### Code @ OnSave method - UserInfo.getTimeZone() - '+UserInfo.getTimeZone());
        system.debug('#### Code @ OnSave method - timeZone - '+timeZone);
        system.debug('#### Code @ OnSave method - Customer Id - '+customerId);
        system.debug('#### Code @ OnSave method - Selected Date - '+objDate);
        system.debug('#### Code @ OnSave method - Implementation Type from Reschedule - '+implementationType);
        
        try{
            if(Times != ''){
                if(customerId != null){
                    eventList = eventSchedulerUtility.getEventList(customerId);
                    system.debug('#### CPU Time Elapsed = '+(Limits.getCpuTime()- cpuLimitStart));
                    cpuLimitStart = Limits.getCpuTime();
                    if(eventList == null){
                        isImplemented = false;
                        implementationError = true;
                        if(errorMessage == null){
                            errorMsg2 = true;
                            errorMessage = 'Event not found.  The UserID which was used to create the Event may be different from the UserID on the Account.';
                            return null;
                        }
                    }
                }
                
                // Requirement changes as per IS Q2 Project
                if(customerId != null && objDate != null){
                    isInitialAppointment = eventSchedulerUtility.isInitialAppointmentScheduled(customerId, Date.valueOf(String.valueOf(objDate)));
                    eventType = isInitialAppointment <= 5 ? appointmentTypeMap.get(isInitialAppointment) : ('Follow-Up Implementation '+isInitialAppointment);
                    system.debug('#### eventType - '+eventType);
                    system.debug('#### CPU Time Elapsed = '+(Limits.getCpuTime()- cpuLimitStart));
                    cpuLimitStart = Limits.getCpuTime();
                }
                
                // Getting available timeslots to avoid duplicate creation of event
                eventSchedulerUtility.timeAdvisorWrapper tawObject = new eventSchedulerUtility.timeAdvisorWrapper();
                eventSchedulerUtility.requestParameterWrapper rpwObject =  new eventSchedulerUtility.requestParameterWrapper();
                rpwObject.BrandId = brandDetails.Id;
                rpwObject.appointmentDate = string.valueOf(objDate);
                rpwObject.appointmentLength = appointmentLength;
                rpwObject.preferredLanguage = preferredLanguage;
                rpwObject.eventType = eventType; 
                rpwObject.premiumSupport = premiumSupport;
                rpwObject.NumberOfUsers = Integer.valueOf(contactDetails.Account_Number_of_DLs__c);
                rpwObject.selectedAdvisor = selectedAdvisor;
                rpwObject.selectedTime = Times;
                rpwObject.timeZone = timeZone;
                
                /* Calling method for fetch available time slots */
                tawObject = eventSchedulerUtility.availableTimeSlots(rpwObject);
                system.debug('#### Time Advisor Wrapper Object - '+tawObject);
                system.debug('#### CPU Time Elapsed = '+(Limits.getCpuTime()- cpuLimitStart));
                cpuLimitStart = Limits.getCpuTime();
                
                /* Logic to check for selected advisor availability,
                in case no advisor selected invite random advisor to the event */
                if(selectedAdvisor == '' || selectedAdvisor == null){
                    system.debug('#### No Advisor selected');
                    system.debug('#### Selected Time = '+rpwObject.selectedTime);
                    Set<String> availableTimeSlotsSet = new Set<String>(); 
                    availableTimeSlotsSet.addAll(tawObject.availableTimeSlots);
                    
                    /* If Time Zone is provided, converting the available time slots to the provided time zone.*/  
                    //!timeZone.equalsIgnoreCase('America/Los_Angeles') &&
                    if((timeZone != null && String.valueOf(UserInfo.getTimeZone()) != timeZone) && 
                        tawObject != null && tawObject.availableTimeSlots != null && tawObject.availableTimeSlots.size() > 0){
                        
                        eventSchedulerUtility.timeZoneWrapper tzwObject = new eventSchedulerUtility.timeZoneWrapper(); 
                        tzwObject.timeZone = timeZone;
                        tzwObject.timeSlots = tawObject.availableTimeSlots;
                        availableTimeSlotsSet = new Set<String>(); 
                        availableTimeSlotsSet.addAll(eventSchedulerUtility.convertToTimeZone(tzwObject));   
                        system.debug('#### Available Time Slots Set = '+availableTimeSlotsSet);
                    }
                    
                    if(tawObject == null || ((tawObject != null && tawObject.availableTimeSlots.size() == 0) || 
                        (rpwObject != null && rpwObject.selectedTime != null && !availableTimeSlotsSet.contains(rpwObject.selectedTime)))){
                        errorMessage = 'There are no time slots available on the specified date, for that length of time. Please select a different date.';
                        errorMsg = true;
                        iformdisabled=false;
                        return null;
                    }else{
                        latestTimeSlots = tawObject.availableTimeSlots; 
                        String inflatedTime;
                        //offsetValue = eventSchedulerUtility.getOffsetValue(timeZone,String.valueOf(UserInfo.getTimeZone()));
                        if(!timeZone.containsIgnoreCase('America/Los_Angeles')){
                            offsetValue = eventSchedulerUtility.getOffsetValue('GMT',timeZone);
                        }
                        //inflatedTime = eventSchedulerUtility.convertToString(eventSchedulerUtility.converToDecimal(Times)+offsetValue);
                        inflatedTime = eventSchedulerUtility.convertToString(eventSchedulerUtility.converToDecimal(Times));
                        
                        system.debug('#### Code @ OnSave method - inflatedTime - '+inflatedTime);
                        system.debug('#### Code @ OnSave method - tawObject - '+tawObject);
                        //system.debug('#### Code @ OnSave method - tawObject.timeSlotAdvisorMap.size() - '+tawObject.timeSlotAdvisorMap.size());
                        //system.debug('#### Code @ OnSave method - tawObject.timeSlotAdvisorMap.get(inflatedTime) - '+tawObject.timeSlotAdvisorMap.get(inflatedTime));
                        //system.debug('#### Code @ OnSave method - selectedAdvisor - '+selectedAdvisor);
                        //system.debug('#### Code @ OnSave method - Math.random()1 - '+Math.random());
                        if(tawObject != null && tawObject.timeSlotAdvisorMap != null &&
                            tawObject.timeSlotAdvisorMap.size() > 0 && tawObject.timeSlotAdvisorMap.get(inflatedTime) != null){
                                
                                List<Id> advisorsList = new List<Id>();
                                advisorsList.addAll(tawObject.timeSlotAdvisorMap.get(inflatedTime));
                                while(String.isBlank(selectedAdvisor)){
                                    Integer randomNumber = Math.round((Math.random() * ((advisorsList.size()-1) - 0)) + 0);
                                    //system.debug('#### Code @ OnSave method - Math.random()2 - '+Math.random());
                                    //system.debug('#### Lucky Number - '+randomNumber);
                                    if(randomNumber < advisorsList.size()){
                                        Id thisLuckyAdvisor = advisorsList[randomNumber];
                                        if(tawObject.availableAdvisors != null &&  tawObject.availableAdvisors.get(thisLuckyAdvisor) != null &&
                                            tawObject.availableAdvisors.get(thisLuckyAdvisor).contains(inflatedTime)){
                                            selectedAdvisor = thisLuckyAdvisor;
                                        }
                                        //system.debug('#### Lucky Number with selectedAdvisor - '+selectedAdvisor);
                                    }   
                                }
                                system.debug('#### CPU Time Elapsed = '+(Limits.getCpuTime()- cpuLimitStart));
                                cpuLimitStart = Limits.getCpuTime();
                        }
                    }
                }else{
                    eventSchedulerUtility.timeZoneWrapper tzwObject = new eventSchedulerUtility.timeZoneWrapper(); 
                    tzwObject.timeZone = timeZone;
                    tzwObject.timeSlots = tawObject.availableTimeSlots;
                    if(!isAdvisorAvailable(tzwObject, Times, selectedAdvisor)){
                        errorMessage ='The selected Advisor is no longer available for selected time. Please select a different time slot or different date.';
                        errorMsg = true;
                        iformdisabled=false;
                        return null;
                    }
                }
                
                system.debug('#### tawObject - '+tawObject);
                system.debug('#### Selected Advisor - '+selectedAdvisor);
                system.debug('#### Latest Time Slot before Scheduling Event - '+latestTimeSlots);
                
                //Create date for Start Date in appointment
                Id Dispatcherid = availableResourcePool != null ? availableResourcePool.Dispatch_Admin__c : null;
                /*Logic to Insert Appointment*/
                
                eventobj.Description__c = 'Implementation Appointment';// hardcoded change later
                //eventobj.Subject ='Implementation Scheduled';
                eventobj.Subject = (contactDetails != null && contactDetails.Account != null && contactDetails.Account.Name != null) ? 
                                    contactDetails.Account.Name : 'Implementation Scheduled';
                eventobj.OwnerId = Dispatcherid ;//Resource pool dispatcher's ID
                /*eventobj.OwnerId = selectedAdvisor ;//Resource pool dispatcher's ID
                if(String.isBlank(selectedAdvisor)){
                    eventobj.OwnerId = Dispatcherid;
                }
                */
                eventobj.Brand__c = brandDetails != null ? brandDetails.Brand_Id__c : null;
                eventobj.WhatId = availableResourcePool != null ? availableResourcePool.Id : null;
                eventobj.Implementation_Status__c ='Scheduled';
                eventobj.CustomerId__c = customerId;
                /*Setting Contacts Details*/
                eventobj.First_Name__c = accountContactMap.get(associatedContact) != null ? accountContactMap.get(associatedContact).FirstName : contactDetails.FirstName;
                eventobj.Last_Name__c = accountContactMap.get(associatedContact) != null ? accountContactMap.get(associatedContact).LastName : contactDetails.LastName;
                eventobj.Customer_Email__c = accountContactMap.get(associatedContact) != null ? accountContactMap.get(associatedContact).Email : contactDetails.Email;
                eventobj.NumberofUser__c = accountContactMap.get(associatedContact) != null ? accountContactMap.get(associatedContact).Account_Number_of_DLs__c : contactDetails.Account_Number_of_DLs__c;
                eventobj.Contact_Support__c = '1111';// To be implemented
                eventobj.Appointment_Source__c = 'Internal Tool';
                eventobj.Type = implementationType != null ? implementationType : eventType; 
                eventobj.Preferred_Language__c = preferredLanguage;
              // eventobj.Customer_Email__c = accountContactMap.get(associatedContact) != null ? accountContactMap.get(associatedContact).Preferred_Language__c : contactDetails.Preferred_Language__c;
                eventobj.Time_Zone__c = timeZone;
                insert eventobj;
                
                // Calling method to update isImplementationAppointmentScheduled flag on Account after Initial Implementation Update.
                updateAccount(contactDetails.AccountId);
                // Calling method to update Contact field on Implementation.
                if(eventobj != null && eventobj.Type != null && eventobj.Type.equalsIgnoreCase('Initial Implementation')){
                    updateImplementationOwner(selectedAdvisor);
                    system.debug('#### CPU Time Elapsed = '+(Limits.getCpuTime()- cpuLimitStart));
                    cpuLimitStart = Limits.getCpuTime();
                }
                updateImplementation(accountContactMap.get(associatedContact).Id);
                system.debug('#### CPU Time Elapsed = '+(Limits.getCpuTime()- cpuLimitStart));
                cpuLimitStart = Limits.getCpuTime();
                // Updating Exception & History Object for 24 Hours reminder worfkflow.
                eventSchedulerUtility.reminderEmail(eventobj, brandDetails != null ? brandDetails.Name : null);
                system.debug('#### CPU Time Elapsed = '+(Limits.getCpuTime()- cpuLimitStart));
                cpuLimitStart = Limits.getCpuTime();
                // Calling method to invite selected advisors.
                eventSchedulerUtility.inviteAdvisor(eventobj, selectedAdvisor);
                system.debug('#### CPU Time Elapsed = '+(Limits.getCpuTime()- cpuLimitStart));
                cpuLimitStart = Limits.getCpuTime();
                
                if(eventobj!=null){
                    //eventSchedulerUtility.sendIcsEmail(eventobj.First_Name__c,eventobj.Last_Name__c,eventobj.Customer_Email__c,eventobj,brandDetails.Id);
                    /* Wrapping up data to send out emails.*/ 
                    eventSchedulerUtility.EmailWrapper ewObject =  new eventSchedulerUtility.EmailWrapper();  
                    ewObject.eventRecord = eventobj;
                    ewObject.emailType = 'Confirmation';  
                    ewObject.timezone = timeZone;
                    try{
                    Boolean insertENHRecord  = eventSchedulerUtility.sendEmail(ewObject);
                        if(eventSchedulerUtility.hasError || !insertENHRecord){
                            errorMessage = 'Event has been scheduled, but couldn\'t send out Confirmation Email. ';
                            errorMsg = true;
                            iformdisabled = false;
                        }else{
                            tformdisabled = true;
                            dformdisabled = false;
                        }
                    }catch(Exception ex){
                        System.debug('#### Exception at insert Exception - '+ex.getMessage()+'    LineNo'+ex.getLineNumber());
                    }
                }
            }
        }catch(Exception ex){
            System.debug('#### Exception at Onsave method - '+ex.getMessage());
        }
        return null;
    }
    
    /**********************************************************************************************
    * @Description : This class calculates Day of Date and shows error message to contact if      *
    *                selected date is lying on weekends.                                          *
    * @Params      : Appointment Date (Date Object)                                               *
    * @Return      : String                                                                       *
    **********************************************************************************************/
    public String calculateDayOfDate(Date DateObj)  {
        List<String> listDay = new List<String>{'Saturday' , 'Sunday' , 'Monday' , 'Tuesday' , 'Wednesday' , 'Thursday' , 'Friday'};
        Date selectedDate = DateObj;
        Integer remainder = Math.mod(startDate.daysBetween(selectedDate) , 7);
        String dayValue = listDay.get(remainder);
        return  dayValue;
    }
    
    /**********************************************************************************************
    * @Description : This class is for rescheduling events                                        *
    * @Params      : void                                                                         *
    * @Return      : String                                                                       *
    **********************************************************************************************/
    public pagereference Reschedule(){
        
        Event objEvent = null;
        PageReference page = null;
        String iType;
        if(implementationType != null && implementationType.contains('Initial Implementation')){
            iType = '0';    
        }else if(implementationType != null && implementationType.contains('Follow-Up Implementation')){
            iType = (implementationType.replace('Follow-Up Implementation', '')).trim();
        }
        system.debug('#### Event List in Reschedule - '+eventList);
        system.debug('#### Implementation Type - '+implementationType);
        system.debug('#### iType - '+iType);
        
        try{
            if(eventList != null){
                for(Event thisEvent : eventList){
                    if(implementationType == thisEvent.Type){
                        objEvent = new Event();
                        objEvent.Id = thisEvent.Id;
                        objEvent.Implementation_Status__c='Canceled';
                        objEvent.Subject = 'Implementation Cancelled';
                    }
                }
            }
            system.debug('#### Event to be updated - '+objEvent);
            
            if(objEvent != null){
                // Setting flag to cancel 24 hours reminder email notification.
                update objEvent;
                eventSchedulerUtility.cancelReminderEmail(objEvent);
                page = new PageReference('/apex/bookIAppointment?contactId='+contactId+'&rcUserId='+customerId+'&iType='+iType);
                page.setRedirect(true);
                return page;
            }else{
                implementationError = true;
                system.debug('#### error message 213 - '+errorMessage);
                errorMessage = 'Couldn\'t find any '+(implementationType != null ? implementationType+' type ' : '')+'Event to Re-Schedule.';
                system.debug('#### error message - '+errorMessage);
            }
        }catch(Exception ex){
            system.debug('#### Error at Reschedule() - '+ex.getMessage()); 
        }
        return page;
    }
    
    /**********************************************************************************************
    * @Description : This class is for cancelling events                                          *
    * @Params      : void                                                                         *
    * @Return      : PageReference                                                                *
    **********************************************************************************************/
    public PageReference cancelEvent(){
        
        Event objEvent = null;
        Boolean insertENHRecord;
        system.debug('#### Event List in Cancel - '+eventList);
        system.debug('#### Implementation Type Cancel - '+implementationType);
        
        try{
            if(eventList != null){
                for(Event thisEvent : eventList){
                    if(implementationType == thisEvent.Type ){
                        objEvent =  new Event();
                        objEvent.Id = thisEvent.Id;
                        objEvent.Implementation_Status__c='Canceled';
                        objEvent.Subject = 'Implementation Cancelled';
                        cancelform = true;
                    }
                }
            }
            if(objEvent != null){
                update objEvent;
            }else{
                errorMessage = 'The Event has expired or is already canceled.';
                errorMsg2=true;
                return null;
            }
            
            Event eventDetails = eventSchedulerUtility.getEventDetails(objEvent.Id);
            // Setting flag to cancel 24 hours reminder email notification.
            eventSchedulerUtility.cancelReminderEmail(eventDetails);
            //Send Cancellation Notification to Customer
            //eventSchedulerUtility.sendImplementationEmail(eventDetails.First_Name__c,eventDetails.Last_Name__c,eventDetails.Customer_Email__c,eventDetails,eventDetails.Brand__c,'Cancellation');
            /* Wrapping up data to send out emails.*/ 
            eventSchedulerUtility.EmailWrapper ewObject =  new eventSchedulerUtility.EmailWrapper();
            ewObject.eventRecord = eventDetails;
            ewObject.emailType = 'Cancellation';
            ewObject.timeZone = eventDetails.Time_Zone__c;
            insertENHRecord  = eventSchedulerUtility.sendEmail(ewObject);
            if(eventSchedulerUtility.hasError || !insertENHRecord){
                errorMessage = 'Event has been cancelled, but couldn\'t send out Cancellation (External) Email. ';
                errorMsg2=true;
            }
            
            // Send Cancellation to resource Pool
            //eventSchedulerUtility.sendEmailResourcePool(eventDetails,'Cancellation Internal',premiumSupport);
            ewObject.emailType = 'Cancellation Internal';
            insertENHRecord  = eventSchedulerUtility.sendEmail(ewObject);
            if(eventSchedulerUtility.hasError || !insertENHRecord){
                errorMessage = 'Event has been cancelled, but couldn\'t send out Cancellation (Internal) Email. ';
                errorMsg2=true;
            }
        }catch(Exception ex){
            system.debug('#### Error on line = '+ex.getLineNumber()+' message = '+ex.getMessage());
            cancelform=true;
        }
        return null;
    }
    
    /**********************************************************************************************
    * @Description : This class is for on click of close                                          *
    * @Params      : void                                                                         *
    * @Return      : pagereference                                                                *
    **********************************************************************************************/
    public PageReference close(){
        PageReference page = new PageReference('/'+contactId) ;
        page.setRedirect(true);
        return page;
    }
    
    public pageReference ToSchedule(){
        appointmentToShow = false;
        return null;
    }
    
    /**********************************************************************************************
    * @Description : This class is for opening schedule appointment page                          *
    * @Params      : void                                                                         *
    * @Return      : pagereference                                                                *
    **********************************************************************************************/
    public PageReference ScheduleAppointment(){
        PageReference page = new PageReference('/apex/bookIAppointment?contactId='+contactId+'&rcUserId='+customerId) ;
        page.setRedirect(true);
        return page;
    }
    
    /**********************************************************************************************
    * @Description : This class is for opening re-schedule appointment page                       *
    * @Params      : void                                                                         *
    * @Return      : pagereference                                                                *
    **********************************************************************************************/
    public PageReference ReScheduleAppointment(){
        PageReference page = new PageReference('/apex/rescheduleAppointment?contactId='+contactId+'&rcUserId='+customerId) ;
        page.setRedirect(true);
        return page;
    }
    
    /**********************************************************************************************
    * @Description : This class is for opening cancel appointment page                            *
    * @Params      : void                                                                         *
    * @Return      : pagereference                                                                *
    **********************************************************************************************/
    public PageReference CancelAppointment(){
        PageReference page = new PageReference('/apex/Cancel_IAppointment?contactId='+contactId+'&rcUserId='+customerId) ;
        page.setRedirect(true);
        return page;
    }
    
    /**********************************************************************************************
    * @Description : This class is for opening home appointment page                              *
    * @Params      : void                                                                         *
    * @Return      : pagereference                                                                *
    **********************************************************************************************/
    public PageReference HomePage(){
        PageReference page = new PageReference('/apex/Implementation_Scheduler?contactId='+contactId+'&rcUserId='+customerId) ;
        page.setRedirect(true);
        return page;
    }
    
    /**********************************************************************************************
    * @Description : This class is to check if mandatory fields are entered or not                *
    * @Params      : void                                                                         *
    * @Return      : pagereference                                                                *
    **********************************************************************************************/
    public pageReference checkMandatoryFields(){
        
        PageReference page = null;
        try{
            Account RCAccount = new Account();
            RCAccount.Id = accountId;
            RCAccount.RC_Brand__c = brandId;
            RCAccount.Number_of_DL_s__c = noOfUser;
            if(RCAccount.Id != null){
                update RCAccount;
            }
            
            system.debug('#### Code @ checkMandatoryFields - Customer Id - '+customerId);
            system.debug('#### Code @ checkMandatoryFields - Brand Id - '+brandId);
            system.debug('#### Code @ checkMandatoryFields - Number of User - '+noOfUser);
            
            if(String.isBlank(customerId) || String.isBlank(brandId) || (noOfUser == null || noOfUser == 0)){
                impErrorMsg = 'Required field(s) missing.';
                menuFlag = true;
                linkFlag = false;
            }else {
                impErrorMsg = null;
                menuFlag = false;
                linkFlag = true;
            }
            
            page = new PageReference('/apex/Implementation_Scheduler?contactId='+contactId+'&rcUserId='+customerId) ;
            page.setRedirect(true);
        }catch(Exception ex){
            system.debug('#### Error on line = '+ex.getLineNumber()+' message = '+ex.getMessage());
        }
        return page;
    }
    
    /**********************************************************************************************
    * @Description : Method to check if any implementation related to the account, doesn't have   *
    *                Implementation_Status_2__c as completed                                      *
    * @Params      : void                                                                         *
    * @Return      : Boolean                                                                      *
    **********************************************************************************************/
    public Boolean isImplementationCompleted(){
        
        List<Implementation__c> implementationlist = new List<Implementation__c>();
        
        try{
            if(contactDetails != null){
                implementationlist = [SELECT Id,Implementation_Status_2__c FROM Implementation__c
                                      WHERE Implementation_Status_2__c  = 'Completed' AND Account__c =: contactDetails.AccountId];
                
                String currentURL = URL.getCurrentRequestUrl().toExternalForm();
                system.debug('#### page url - '+currentURL);
                
                if(implementationlist != null && implementationlist.size() > 0){
                    if(currentURL.containsIgnoreCase('book')){
                        errorMessage = 'Implementation cannot be scheduled. One or more Implementation(s) of associated Account is Completed.';
                    }
                    if(currentURL.containsIgnoreCase('cancel')){
                        errorMessage = 'Implementation cannot be cancelled. One or more Implementation(s) of associated Account is Completed.';
                    }
                    if(currentURL.containsIgnoreCase('reschedule')){
                        errorMessage = 'Implementation cannot be re-scheduled. One or more Implementation(s) of associated Account is Completed.';
                    }
                    bookError = true;
                    dformdisabled = false;
                    return true;
                }
            }
        }catch(Exception ex){
            system.debug('#### Error on line = '+ex.getLineNumber()+' message = '+ex.getMessage());
        }
        return false;
    }
    
    /**********************************************************************************************
    * @Desciription : Method to create map of Id, Advisors.                                       *
    * @Params       : void                                                                        *
    * @Return       : Map<Id, Advisors>                                                           *
    **********************************************************************************************/
    public Map<Id, Advisor__c> fetchAdvisors(){
        Map<Id, Advisor__c> advisorMap = new Map<Id, Advisor__c>();
        for(Advisor__c thisRecord : [SELECT Id, Name, Advisor_Name__r.FirstName, Advisor_Name__r.LastName,Advisor_Name__r.Name, Advisor_Name__c
                                     FROM Advisor__c]){
            advisorMap.put(thisRecord.Advisor_Name__c, thisRecord);
        }
        return advisorMap;
    }
    
    /**********************************************************************************************
    * @Desciription : Method to update contact field on associated Implementation record.         *
    * @Params       : Id                                                                          *
    * @Return       : void                                                                        *
    **********************************************************************************************/
    public void updateImplementation(Id associatedContact){
        // Updating Contact field on Implementation.
        if(implementationList != null){
            for(Implementation__c implementation : implementationList){
                implementation.Contact__c = associatedContact;
            }
            try{
                update implementationList;
            }catch(Exception ex){
                system.debug('#### Error on line = '+ex.getLineNumber()+' message = '+ex.getMessage());
            }
        }
    }
    
    /**********************************************************************************************
    * @Desciription : Method to update owner field on associated Implementation record.           *
    *                 Initial Implementation Advisor will be the owner of the Implementation.     *
    * @Params       : Id                                                                          *
    * @Return       : void                                                                        *
    **********************************************************************************************/
    public void updateImplementationOwner(Id initialAdvisor){
        // Updating Contact field on Implementation.
        if(implementationList != null){
            for(Implementation__c thisRecord : implementationList){
                if(thisRecord.Owner != null && thisRecord.Owner.Name != null && 
                   thisRecord.Owner.Name.equalsIgnoreCase('RCSF Sync')){
                    thisRecord.OwnerId = initialAdvisor;
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
    * @Desciription : Method to update isImplementationAppointmentScheduled field,                *
    *                 on associated Account record.                                               *
    * @Params       : void                                                                        *
    * @Return       : Map<Id, Advisors>                                                           *
    **********************************************************************************************/
    public void updateAccount(Id accountContactId){
        
        // Bypassing Account Trigger.
        TriggerHandler.BY_PASS_ACCOUNT_ON_UPDATE();
        
        // Updating isImplementationAppointmentScheduled flag on Account after Initial Implementation Update.
        Account accToBeUpdated = new Account();
        accToBeUpdated.Id = accountContactId;
        accToBeUpdated.isAppointmentScheduled__c =  true;
        accToBeUpdated.Last_Reminder_Date__c = null;
        accToBeUpdated.Last_Reminder_Date_1__c = null;
        accToBeUpdated.Last_Reminder_Date_2__c = null;
        accToBeUpdated.Last_Reminder_Date_3__c = null;
        update accToBeUpdated;
    }
    
    /**********************************************************************************************
    * @Desciription : Convert timeslots in displayable format.                                    *
    * @Params       : void                                                                        *
    * @Return       : Map<Id, Advisors>                                                           *
    **********************************************************************************************/
    public List<SelectOption> convertTimeslot(List<String> timeSlots){
        
        List<SelectOption> freeSlots = new List<SelectOption>();
        for(String thisRecord : timeSlots){
            system.debug('#### 1111 Time slot received = '+thisRecord);
        }
        for(String setTime : timeSlots){
            system.debug('#### 1111 Inside for = '+setTime);
            String pstTime = setTime.substring(0,2);
            if(Integer.valueOf(pstTime) < 12){
                freeSlots.add(new SelectOption(setTime,setTime+ ' AM'));
            }
            else if(Integer.valueOf(pstTime) == 12){
                freeSlots.add(new SelectOption(setTime,setTime+ ' PM'));
            }
            else if(Integer.valueOf(pstTime) == 24){
                freeSlots.add(new SelectOption(setTime,'00:00 AM'));
            }
            else{
                freeSlots.add(new SelectOption(setTime,(Integer.valueOf(pstTime)-12) < 10 ? '0'+(Integer.valueOf(pstTime)-12)+setTime.substring(2,5)+' PM' : (Integer.valueOf(pstTime)-12)+setTime.substring(2,5)+' PM'));
            }
        }
        for(SelectOption thisRecord : freeSlots){
            system.debug('#### Free convertTimeslot = '+thisRecord);
        }
        return freeSlots;
    }
    
    /**********************************************************************************************
    * @Description  : Method to check if available advisor is available.                          *
    * @Params       : timeAdvisorWrapper, String, Id                                              *
    * @Return       : Boolean                                                                     *
    **********************************************************************************************/
    public Boolean isAdvisorAvailable(eventSchedulerUtility.timeZoneWrapper tzwObject, String selectedTime,Id selectedAdvisor){
        system.debug('#### Code @ isAdvisorAvailable - Time Zone Wrapper - '+tzwObject);
        system.debug('#### Code @ isAdvisorAvailable - Selected Time - '+selectedTime);
        system.debug('#### Code @ isAdvisorAvailable - Selected Advisor - '+selectedAdvisor);
        Set<String> availableTimeSlotsSet = new Set<String>(); 
        /* If Time Zone is provided, converting the available time slots to the provided time zone.*/  
        //!timeZone.equalsIgnoreCase('America/Los_Angeles') &&
        if(tzwObject != null && tzwObject.Timezone != null && tzwObject.timeSlots != null && tzwObject.timeSlots.size() > 0){
            
            availableTimeSlotsSet.addAll(eventSchedulerUtility.convertToTimeZone(tzwObject));   
            system.debug('#### Available Time Slots Set = '+availableTimeSlotsSet);
        }
        
        if(availableTimeSlotsSet != null && availableTimeSlotsSet.size() > 0 && availableTimeSlotsSet.contains(selectedTime)){
            return true;
        }else{
            return false;
        }
    }
    
    /***********************************************************************************************
    * @Description  : Method to fetch profile names from custom setting, to make the advisor list  *
    *                 visible only for these profiles.                                             *
    * @Params       : timeAdvisorWrapper, String, Id                                               *
    * @Return       : Boolean                                                                      *
    ***********************************************************************************************/
    public Set<String> fetchProfileCustomSetting(){
        Set<String> availableProfiles = new Set<String>();
        if(Implementation_Scheduler__c.getValues('Profiles') != null && Implementation_Scheduler__c.getValues('Profiles').Values__c != null){
            availableProfiles.addAll(Implementation_Scheduler__c.getValues('Profiles').Values__c.split(',',0));
        }
        return availableProfiles;
    }
    
    /***********************************************************************************************
    * @Description  : Method to set default values.                                                *
    * @Params       : String                                                                       *
    * @Return       : Void                                                                         *
    ***********************************************************************************************/
    public void setDefaultValues(String brandName){
        //system.debug('#### Brand Name for Default Values = '+brandName);
        if(!String.isBlank(brandName) && (brandName.equalsIgnoreCase('BT Cloud Phone') || brandName.equalsIgnoreCase('BT Business'))){
           // timeZone = 'Europe/London';
          //  preferredLanguage = 'en_GB';    
        }     
    }
}// End of class