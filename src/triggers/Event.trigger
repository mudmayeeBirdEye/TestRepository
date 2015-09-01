/**************************************************************************************************
* Project Name..........: RingCentral - Self Serve Scheduling                                     *
* File..................: extAppointment.cls                                                      *
* Version...............: 1.0                                                                     *
* Created by............: Simplion Technologies                                                   *
* Created Date..........: 24 June 2013                                                            *
* Last Modified by......: Simplion Technologies                                                   *
* Last Modified Date....:                                                                         * 
* Description...........: Trigger on Task object.                                                 *
*                         After Insert & Update: Throw error if start date is past.               *
*                                                Set Responded and Last Touched fields as needed. *
**************************************************************************************************/
trigger Event on Event (before insert, before update) {
    
    if(TriggerHandler.BY_PASS_EVENT_ON_INSERT || TriggerHandler.BY_PASS_EVENT_ON_UPDATE || TriggerHandler.BY_PASS_EVENT_ON_BEFORE){ 
        System.debug('### RETURNED FROM EVENT INSERT / UPDATE TRG ###');
        return;
    } else {
    	TriggerHandler.BY_PASS_EVENT_ON_BEFORE = true;
        System.debug('### STILL CONTINUE FROM EVENT INSERT / UPDATE TRG ###');
    }
    /*Declaring constants for event types*/
    private final String FOLLOW_UP_IMPLEMENTATION_1 = 'Follow-Up Implementation 1';
    private final String FOLLOW_UP_IMPLEMENTATION_2 = 'Follow-Up Implementation 2';
    private final String FOLLOW_UP_IMPLEMENTATION_3 = 'Follow-Up Implementation 3';
    private final String FOLLOW_UP_IMPLEMENTATION_4 = 'Follow-Up Implementation 4';
    private final String FOLLOW_UP_IMPLEMENTATION_5 = 'Follow-Up Implementation 5';
    private final String INITIAL_IMPLEMENTATION = 'Initial Implementation';
    
    // Get user profile to see if it is an Admin
    Profile prof = [SELECT Name,(SELECT Implementation_Dispatcher__c FROM Users WHERE Id = :UserInfo.getUserId() LIMIT 1) FROM Profile WHERE Id = :UserInfo.getProfileId() ];
    // Query to fetch Implemenatation Dispatcher check box value.
    User userDetails = prof.Users;//[SELECT Implementation_Dispatcher__c FROM User WHERE Id = :UserInfo.getUserId()];
    // Get list of all the users in <Implementation_Lock__c> custom setting that will bypass the Incorrect Status Progression Validation rule.
    //Map<String, Implementation_Lock__c> implementationLockMap =  new Map<String, Implementation_Lock__c>();
    //implementationLockMap = Implementation_Lock__c.getAll();
     
    /*Set of ids for Opportunity & Lead */
    Set<Id> what_ids = new Set<Id>();
    Set<Id> who_ids = new Set<Id>();
    Set<String> useridSet = new Set<String>();
    
    List<Opportunity> opp_list = new List<Opportunity>();
    List<Lead> lead_list = new List<Lead>();
    
    system.debug('trigger.new ===>' + trigger.new);
    
    for(Event e:trigger.new){
        what_ids.add(e.WhatId);
        who_ids.add(e.WhoId);
        if(!String.isBlank(e.CustomerId__c)) {
            useridSet.add(e.CustomerId__c);
        }
    }
    
    system.debug('what_ids ===>' + what_ids);
    system.debug('who_ids ===>' + who_ids);
    system.debug('useridSet ===>' + useridSet);
    
    Map<Id,Opportunity> opp_map = new Map<Id,Opportunity>([SELECT Id,Responded_Date__c,Responded_By__c,Last_Touched_Date__c,Last_Touched_By__c 
                                                           FROM Opportunity WHERE Id IN: what_ids]);
                                                            
    Map<Id, Lead> lead_map = new Map<Id,Lead>([SELECT Id,Responded_Date__c,Responded_By__c,Last_Touched_Date__c,Last_Touched_By__c 
                                               FROM Lead WHERE Id IN: who_ids]);
                                                            
    Map<String,Implementation__c> mapImplementation = new Map<String,Implementation__c>();
    Map<String, Account> mapAccount =  new Map<String, Account>(); 
    if(useridSet != null && useridSet.size()>0) {
        for(Implementation__c implemetationObj : [SELECT RC_USER_ID__c, Account__c,Account__r.Id, Account__r.isAppointmentScheduled__c, 
                                                         Account__r.Last_Reminder_Date__c, Account__r.Last_Reminder_Date_1__c,
                                                         Account__r.Last_Reminder_Date_2__c, Account__r.Last_Reminder_Date_3__c 
                                                  FROM Implementation__c 
                                                  WHERE RC_USER_ID__c IN :useridSet]) {
                                                    
            system.debug('#### Implementation Account - '+implemetationObj.Account__r);
            mapImplementation.put(implemetationObj.RC_USER_ID__c,implemetationObj);
            mapAccount.put(implemetationObj.RC_USER_ID__c,implemetationObj.Account__r);
        }
    }                                                                                                                   
    system.debug('mapImplementation ===> ' + mapImplementation);
    system.debug('mapAccount ===> ' + mapAccount);
    Map<Id,Implementation__c> implementationMapToUpd = new Map<Id,Implementation__c>();
    Map<Id,Implementation__c> implementationMapToUpd1 = new Map<Id,Implementation__c>();
    List<Implementation__c> finalImplementationToUpdate = new List<Implementation__c>();
     
    String implementationKeyPrefix = Schema.getGlobalDescribe().get('Implementation__c').getDescribe().getKeyPrefix();
    system.debug('implementationKeyPrefix ===> ' + implementationKeyPrefix);
    for(Event evet:trigger.new){
        try{
        	system.debug('evet.StartDateTime ===> ' + evet.StartDateTime);
            if(evet.StartDateTime != null){
              if((evet.StartDateTime.Date() < Date.Today()) && trigger.isInsert){
                evet.StartDateTime.addError('Your event start date cannot be past due.');
              }
            }
         }catch(Exception ex){
            evet.StartDateTime.addError('Your event start date cannot be blank.');
            system.debug('Exception ===>' + ex.getMessage());
            system.debug('Exception ===>' + ex.getStackTraceString());
         }
       
        try{
            if(trigger.isInsert){
            	system.debug('evet.CustomerId__c ===>' + evet.CustomerId__c);
                if(mapImplementation != null && !String.isBlank(evet.CustomerId__c) && mapImplementation.get(evet.CustomerId__c) != null) { 
                    
                    Implementation__c implementationObj = new Implementation__c(Id = mapImplementation.get(evet.CustomerId__c).id);
                    implementationObj.Last_Reminder_Date__c = null;
                    implementationObj.Last_Reminder_Date_1__c = null;
                    implementationObj.Last_Reminder_Date_2__c = null;
                    implementationObj.Last_Reminder_Date_3__c = null;
                    implementationObj.No_Show__c = false;
                    implementationObj.Most_Recent_Implementation_Event__c = evet.Id;
                    
                    /* Setting respective flags on Implementation, whenever Initial, Followup1, Followup2 events are scheduled. */
                    system.debug('evet.Type ==== >' + evet.Type);
                    if(evet != null && evet.Type != null && evet.Type.equalsIgnoreCase(INITIAL_IMPLEMENTATION)){
                        system.debug('#### Event Trigger -  Event Type - '+evet.Type);
                        Account impAccUpd = new Account();
                        if(mapAccount != null && !string.isBlank(evet.CustomerId__c) && mapAccount.get(evet.CustomerId__c) != null) {   
                            impAccUpd = mapAccount.get(evet.CustomerId__c);
                            // Updating isImplementationAppointmentScheduled flag on Account after Initial Implementation Update.
                            impAccUpd.isAppointmentScheduled__c =  true;
                            
                            //  Bypassing Account Trigger.
                            TriggerHandler.BY_PASS_ACCOUNT_ON_UPDATE();
                            update impAccUpd;
                        }
                        system.debug('#### Account - '+impAccUpd);
                    }
                    if(evet != null && evet.Type != null && evet.Type.equalsIgnoreCase(FOLLOW_UP_IMPLEMENTATION_1)){
                        system.debug('#### Event Trigger -  Event Type - '+evet.Type);
                        implementationObj.isSecondTrainingScheduled__c =  true;
                    }
                    if(evet != null && evet.Type != null && evet.Type.equalsIgnoreCase(FOLLOW_UP_IMPLEMENTATION_2)){
                        system.debug('#### Event Trigger -  Event Type - '+evet.Type);
                        implementationObj.isThirdTrainingScheduled__c =  true;
                    }
                    if(evet != null && evet.Type != null && evet.Type.equalsIgnoreCase(FOLLOW_UP_IMPLEMENTATION_3)){
                        system.debug('#### Event Trigger -  Event Type - '+evet.Type);
                        implementationObj.isFourthTrainingScheduled__c =  true;
                    }
                    if(evet != null && evet.Type != null && evet.Type.equalsIgnoreCase(FOLLOW_UP_IMPLEMENTATION_4)){
                        system.debug('#### Event Trigger -  Event Type - '+evet.Type);
                        implementationObj.isFifthTrainingScheduled__c =  true;
                    }
                    finalImplementationToUpdate.add(implementationObj);
                    system.debug('finalImplementationToUpdate === ' + finalImplementationToUpdate);
                }
            }
       
        if(trigger.isUpdate){   
            
              /*Date - 16th January 2014 ------------------------------------------------------------------------------
                Below requirement was done for Implementation Scheduler, user OTHER than the owner of the event,
                system admin, users having Implementation Dispatcher checked and calendar specified on custom setting
                should not be able to modify the startdatetime and enddatetime for the event(s).
              -------------------------------------------------------------------------------------------------------*/
              
              /* Contains set of all the calendar(s), not following the custom validation (presently done to skip UK calendars). */
              Boolean implCalFlag;
              Set<String> implCalendar = new Set<String>();
              implCalendar = Implementation_Calendar__c.getAll().keySet();
              system.debug('#### implCalendar - '+implCalendar);
              if(implCalendar != null || implCalendar.size() > 0){
                    system.debug('#### owner Id - '+evet.OwnerId);
                    implCalFlag = implCalendar.contains(String.valueOf(evet.OwnerId).substring(0,15)) ? false : true;
              }
              else{
                    implCalFlag = true;
              }
              
              system.debug('#### implCalFlag - '+implCalFlag);
              Id loggedInUserId = UserInfo.getUserId();
                
                /* Check if the user is other than the owner of the record,system admins,
                   implementation dispatcher checked and calendar names in custom setting.*/
                if(evet.OwnerId != loggedInUserId && !'System Administrator'.equalsIgnoreCase(prof.Name)&& 
                   !userDetails.Implementation_Dispatcher__c && implCalFlag) {
                    
                    if(Trigger.oldMap.get(evet.id).StartDateTime != evet.StartDateTime){
                        evet.StartDateTime.addError('You cannot modify the start date time for this event.');   
                    }
                    if(Trigger.oldMap.get(evet.id).EndDateTime != evet.EndDateTime){
                        evet.EndDateTime.addError('You cannot modify the end date time for this event.');   
                    }
                }
        }
        /* End of custom validation ***************************************************************************/
              
        if(!'System Administrator'.equalsIgnoreCase(prof.Name)) {        
            Opportunity opp =  opp_map.get(evet.WhatId);
            if(opp != null){
                if(opp.Responded_Date__c==null && opp.Responded_By__c==null){
                  opp.Responded_Date__c = Datetime.now();
                  opp.Responded_By__c = UserInfo.getUserId();
                }
                opp.Last_Touched_Date__c  = Datetime.now();
                opp.Last_Touched_By__c = UserInfo.getUserId();
            }
            opp_list.add(opp);        
            Lead lead = lead_map.get(evet.WhoId);
            if(lead != null){
                if(lead.Responded_Date__c==null && lead.Responded_By__c==null){
                  lead.Responded_Date__c = Datetime.now();
                  lead.Responded_By__c = UserInfo.getUserId();
                }
                lead.Last_Touched_Date__c  = Datetime.now();
                lead.Last_Touched_By__c = UserInfo.getUserId();
            }
            lead_list.add(lead);        
        }
        if(mapImplementation != null && !string.isBlank(evet.CustomerId__c) && mapImplementation.get(evet.CustomerId__c) != null) { 
            //if(Trigger.isInsert) {
                evet.WhatId = mapImplementation.get(evet.CustomerId__c).id;
            //} 
            
            if(evet != null && evet.Type != null && !evet.Type.contains('Follow-Up Implementation') && !evet.Type.contains('System Use')){
                Implementation__c implementationObj = new Implementation__c(Id = mapImplementation.get(evet.CustomerId__c).Id);
                implementationObj.Implementation_Status_2__c = 'Scheduled';
                implementationObj.isBypassValidation__c = true;
                system.debug('#### Setting validation flag Implementation - '+implementationObj);
                implementationMapToUpd.put(implementationObj.id,implementationObj);
            }           
        }
        if(mapImplementation != null && !string.isBlank(evet.CustomerId__c) && mapImplementation.get(evet.CustomerId__c) != null && 
            Trigger.isUpdate && Trigger.oldMap.get(evet.id).Implementation_Status__c != 'Canceled' 
                && evet.Implementation_Status__c == 'Canceled' && evet.WhatId != null 
                && string.valueOf(evet.WhatId).substring(0, 3) == implementationKeyPrefix) {
            
            if(evet != null && evet.Type != null && !evet.Type.contains('Follow-Up Implementation') && !evet.Type.contains('System Use')){
                Implementation__c implementationObj = new Implementation__c(Id = mapImplementation.get(evet.CustomerId__c).Id);
                implementationObj.Implementation_Status_2__c = 'On Hold';
                implementationObj.isBypassValidation__c = true;
                system.debug('#### Setting validation flag Implementation - '+implementationObj);
                implementationMapToUpd1.put(implementationObj.id,implementationObj);
            }           
        } 
     } catch(Exception ex){
         evet.addError(ex);
         system.debug('Exception ===>' + ex.getMessage());
         system.debug('Exception ===>' + ex.getStackTraceString());
     }
     
   /*  List<Event> checkEvent = [Select e.StartDateTime, e.EndDateTime, e.CustomerId__c, e.Assigned_To_Manager__c, 
     							e.ActivityDateTime From Event e where e.CustomerId__c  =:evet.CustomerId__c AND e.EndDateTime =:evet.EndDateTime AND e.StartDateTime=:evet.StartDateTime];
     if(checkEvent != null && checkEvent.size() > 0){
     	evet.addError('Event is Already Scheduled for this user for this slot');
     } */
  }
  try{if(opp_list != null && opp_list.size()>0) {update opp_list;}}catch(Exception e){}
  try{if(lead_list != null && lead_list.size()>0){update lead_list;}}catch(Exception e){}
  try {
        if(implementationMapToUpd != null && implementationMapToUpd.values() != null && implementationMapToUpd.values().size()>0) {
            //finalImplementationToUpdate.add(implementationMapToUpd.values());
            update implementationMapToUpd.values();
        }
        if(implementationMapToUpd1 != null && implementationMapToUpd1.values() != null && implementationMapToUpd1.values().size()>0) {
            ///finalImplementationToUpdate.add(implementationMapToUpd1.values());
            update implementationMapToUpd1.values();
        }
        if(finalImplementationToUpdate != null && finalImplementationToUpdate.size() > 0){
            update finalImplementationToUpdate;
        }
        
  } catch(Exception ex) {
      system.debug('Exception ===>' + ex.getMessage());
      system.debug('Exception ===>' + ex.getStackTraceString());
  }
}