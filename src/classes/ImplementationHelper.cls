/**************************************************************************************************
* Project Name..........: RingCentral - Self Serve Scheduling                                     *
* File..................: ImplementationHelper.cls                                                *
* Version...............: 1.0                                                                     *
* Created by............: Simplion Technologies                                                   *
* Created Date..........:                                                                         *
* Last Modified by......: Simplion Technologies                                                   *
* Last Modified Date....:                                                                         * 
* Description...........: Helper class for Trigger on Implementation object.                      *
**************************************************************************************************/

public class ImplementationHelper {

    /**********************************************************************************************
    * @Description :                                                                              *
    * @Params      : void                                                                         *
    * @Return      : List<Implementation__c>                                                      *
    **********************************************************************************************/ 
    public static void markAsPremiumSupportOIDs(List<Implementation__c> implementationList){
        
        Map<Id, String> accOIDMap = new Map<Id, String>();
        Map<String, Offer_Id__c> offerOIDMap = new Map<String, Offer_Id__c>();
        Set<Id> customerAccountIds = new Set<ID>();
        List<Offer_ID__c> offersForUpdate = new List<Offer_ID__c>();
        
        for(Implementation__c impObj : implementationList) {
            customerAccountIds.add( impObj.Account__c );
        }
        
        for(Account accObj : [SELECT OID__c FROM Account WHERE ID IN : customerAccountIds]) {
            if(accObj.OID__c != null) {
                accOIDMap.put( accObj.id , accObj.OID__c.toUpperCase() );
            }       
        }
        
        for(Offer_ID__c offObj : [SELECT isPremiumSupport__c, OID__c FROM Offer_Id__c 
                                  WHERE isPremiumSupport__c = true AND OID__c IN : accOIDMap.values()]){
            
            if( offObj.OID__c != null ) {
                offerOIDMap.put( offObj.OID__c.toUpperCase() ,  offObj );
            }
        }
        
        for( Implementation__c impObj : implementationList ) {
            String OID = accOIDMap.get( impObj.Account__c );
            if(offerOIDMap.get( OID )!= null && offerOIDMap.keySet().contains( OID ) ) {
                impObj.Implementation_Type__c = 'Premium';
            }
        }
    }
    
    /**********************************************************************************************
    * @Description :                                                                              *
    * @Params      : void                                                                         *
    * @Return      : List<Implementation__c>                                                      *
    **********************************************************************************************/
    public static void assignSalesAgent(List<Implementation__c> implementationList) {
        try {
            set<Id> accountIdSet = new set<Id>(); 
            //creating Implementation's Account Id set
            for(Implementation__c impObj : implementationList) {
                if(!string.isBlank(impObj.Account__c)) {
                    accountIdSet.add(impObj.Account__c);
                }
            }
                
            map<Id,account> accountMap = new map<Id,account>([SELECT Most_Recent_Opportunity_Owner__c, Most_Recent_Opportunity_Owner__r.IsActive
                                                              FROM Account WHERE Id IN : accountIdSet]);
            //*********** Assigning Sales Agent to the Opportunity's owner Account ***********************//
            for(Implementation__c impObj : implementationList) {
                if(!string.isBlank(impObj.Account__c) 
                    && accountMap != null && accountMap.get(impObj.Account__c) != null) {
                    if(accountMap.get(impObj.Account__c).Most_Recent_Opportunity_Owner__r.IsActive == true) {
                        impObj.Sales_Agent__c = accountMap.get(impObj.Account__c).Most_Recent_Opportunity_Owner__c;
                    }
                }       
            }
            
        } catch(Exception ex) {}
    }
    
    /**********************************************************************************************
    * @Description : Creating dummy event, on Implementation Insertion.                           *
    *                This event will be used as a dummy event to sent out to schedule the,        *
    *                Initial Implementation Event.                                                *
    * @Params      : void                                                                         *
    * @Return      : List<Implementation__c> : Contains list of Implementation from Trigger.New   *
    **********************************************************************************************/
    public static Map<Id, Id> createDummyEvent(List<Implementation__c> implementationList){
        
        system.debug('#### Incoming Implementation - '+implementationList);
        List<Event> eventList =  new List<Event>();
        List<Id> contactIdList = new List<Id>();
        Map<String, String> brandMap = new Map<String, String>();
        Map<Id, Contact> contactMap = new Map<Id, Contact>();
        Map<Id, Id> mappingImpToEvent = new Map<Id, Id>();
        
        try{
            // Fetch list of all the Contact Ids.
            for(Implementation__c thisRecord : implementationList){
                if(thisRecord.Contact__c != null){
                    contactIdList.add(thisRecord.Contact__c);
                }   
            }
            // Calling method to get contact details.
            contactMap = getContactDetails(contactIdList);
            // Calling method to get map for <BrandName, BrandId>
            brandMap = getBrandMap();
            for(Implementation__c thisRecord : implementationList){
                /*Logic to Insert Appointment*/
                Event eventobj = new Event();
                eventobj.StartDatetime = System.Now();
                eventobj.EndDatetime = System.Now().addMinutes(60);
                eventobj.Description__c = 'Initial Dummy Implementation Event';
                eventobj.Subject ='Initial Dummy Implementation Event';
                eventobj.OwnerId = UserRC.getRCSFSyncPrimaryOwnerId;
                eventobj.Brand__c = brandMap != null ? brandMap.get(thisRecord.Brand__c) : '';
                eventobj.WhatId = thisRecord.Id;
                eventobj.Implementation_Status__c = 'Scheduled';
                eventobj.CustomerId__c = thisRecord.RC_USER_ID__c;
                /*Setting Contacts Details*/
                eventobj.First_Name__c = contactMap != null && contactMap.get(thisRecord.Contact__c) != null ? 
                                         contactMap.get(thisRecord.Contact__c).FirstName : '';
                eventobj.Last_Name__c = contactMap != null && contactMap.get(thisRecord.Contact__c) != null ? 
                                        contactMap.get(thisRecord.Contact__c).LastName : '';
                eventobj.Customer_Email__c = contactMap != null && contactMap.get(thisRecord.Contact__c) != null ? 
                                             contactMap.get(thisRecord.Contact__c).Email : '';
                                             
                eventobj.Preferred_Language__c = contactMap != null && contactMap.get(thisRecord.Contact__c) != null ? 
                                             contactMap.get(thisRecord.Contact__c).Preferred_Language__c : '';                               
                eventobj.NumberofUser__c = thisRecord.Number_of_DL_s__c;
                eventobj.Contact_Support__c = '1111';
                eventobj.Appointment_Source__c = 'Internal Tool';
                eventobj.Type = 'System Use'; 
                eventList.add(eventobj); 
            }   
            
            if(eventList != null && eventList.size() > 0){
                system.debug('eventList-->'+eventList);
                insert eventList;
            }
            
            for(Event ev : eventList){
                system.debug('ev-->'+ev);
                mappingImpToEvent.put(ev.WhatId, ev.Id);
            }
        }catch(Exception ex) {}
        
        return mappingImpToEvent;
    }
    
    /**********************************************************************************************
    * @Description : This method creates a Map of <BrandName, BrandId>.                           *
    * @Params      : void                                                                         *
    * @Return      : Map<String, String>                                                          *
    **********************************************************************************************/
    public static Map<String, String> getBrandMap() {
        Map<String, String> brandMap =  new Map<String, String>();
        for(schedulerConfiguration__c thisRecord : [SELECT Name, Brand_Id__c FROM schedulerConfiguration__c]){
            if(thisRecord.Name != null && thisRecord.Brand_Id__c != null){
                brandMap.put(thisRecord.Name, thisRecord.Brand_Id__c);
            }   
        }
        system.debug('#### Brand Map - '+brandMap);
        return brandMap;
    }
     
    /**********************************************************************************************
    * @Description : This method creates a Map of <ContactId, Contact>                            *
    * @Params      : List<Id>                                                                     *
    * @Return      : Map<Id, Contact>                                                             *
    **********************************************************************************************/
    public static Map<Id, Contact> getContactDetails(List<Id> contactIdList) {
        Map<Id, Contact> contactMap = new Map<Id, Contact>();
        system.debug('#### contactIdList - '+ contactIdList);
        for(Contact thisRecord : [SELECT Id, FirstName, LastName,Preferred_Language__c, Email FROM Contact WHERE Id IN: contactIdList]){
            contactMap.put(thisRecord.Id, thisRecord);  
        }
        system.debug('#### Contact Map - '+contactMap);
        return contactMap;
    }
}