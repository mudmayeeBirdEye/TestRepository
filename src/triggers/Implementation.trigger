/**************************************************************************************************
* Project Name..........: RingCentral - Self Serve Scheduling                                     *
* File..................: Implementation.trigger                                                  *
* Version...............: 1.0                                                                     *
* Created by............: Simplion Technologies                                                   *
* Created Date..........: 24 June 2013                                                            *
* Last Modified by......: Simplion Technologies                                                   *
* Last Modified Date....:                                                                         * 
* Description...........: Trigger on Implementation object.                                       *
*                         Before Update: Enforce business rules Create and send survey.           *
**************************************************************************************************/

trigger Implementation on Implementation__c (before update, before insert) {
    // Flag to check if trigger is to be executed or not.
    if(TriggerHandler.BY_PASS_IMPLEMENTATION_ON_BEFORE){
        System.debug('### RETURNED FROM IMPLEMENTATION BEFORE TRG ###');
        return;
    }else{
        System.debug('### STILL CONTINUE FROM IMPLEMENTATION BEFORE TRG ###');
        TriggerHandler.BY_PASS_IMPLEMENTATION_ON_BEFORE = true;
    } 
  /* Below logic has been put in place to update the CC Sales Agent and CC Sales Agent Manager field on Implementation Record.
        These fields are to be used to send out reminder emails for Implementation Appointment #implememtationScehduler. */
    Set<Id> accountIdSet = new Set<Id>();
    Set<String> accountIds = new Set<String>();
    Map<Id,Account> accountMap;
    for(Implementation__c implementVal : Trigger.new) {
        if(implementVal != null && implementVal.Account__c != null){
            accountIdSet.add(implementVal.Account__c); 
            accountIds.add(implementVal.Account__c); 
        }   
    }
    if(accountIdSet != null && accountIdSet.size()>0) {
        accountMap = new Map<Id,Account>([SELECT Id, RC_Brand__c, Most_Recent_Opportunity_Owner__r.Email, Most_Recent_Opportunity_Owner__r.Manager.Email, 
                                            (SELECT Account__c, Implementation__c FROM Network_Informations__r) FROM Account WHERE Id IN :accountIdSet]);    
    } 
    for(Implementation__c thisRecord : Trigger.new) {
        /* Code to update the CC Sales Agent and CC Sales Agent Manager field in Implementation Record. */
        if(accountMap != null && thisRecord.Account__c != null && accountMap.get(thisRecord.Account__c) != null){
            // Implementation__c implementationRecord = thisRecord;
            Account accObj = accountMap.get(thisRecord.Account__c);
            thisRecord.CC_Sales_Agent__c = accObj.Most_Recent_Opportunity_Owner__r.Email;
            thisRecord.CC_Sales_Agent_Manager__c = accObj.Most_Recent_Opportunity_Owner__r.Manager.Email;
            /********** ADDED BY VIREN 2nd March 2014 ************/
            String newBrand = (String.isNotBlank(accObj.RC_Brand__c) && accObj.RC_Brand__c.containsIgnoreCase('BT') ? 'BT Business' : thisRecord.Brand__c);
            if(trigger.oldMap == null) {
                thisRecord.Brand__c = newBrand;
            } else {
                String oldBrand = trigger.oldMap.get(thisRecord.Id).Brand__c;
                if(newBrand != oldBrand) {
                    thisRecord.Brand__c = newBrand;
                }
            }
        }
    }
    
  if(Trigger.isInsert){
    
    /*  Creating dummy event, on Implementation Insertion. 
    This event will be used as a dummy event to sent out to schedule the,Initial Implementation Event. */
    /*system.debug('#### calling method to create dummy event.'); 
    //-------------------As/Simplion/3/13/2015-----------------------
    //-------------------shifting below line into implementation after trigger
    ImplementationHelper.createDummyEvent(trigger.new);*/
        
    set<Id> implAccountSet = new set<Id>(); 
    List<String> rcUserIdList =  new List<String>();
    Profile prof = [select Name from Profile where Id = :UserInfo.getProfileId()];
    for(Implementation__c implementObj : trigger.new) {
        if(implementObj.Account__c != null){
            implAccountSet.add(implementObj.Account__c);
        }
        if(implementObj.RC_USER_ID__c != null){
            rcUserIdList.add(implementObj.RC_USER_ID__c);
        }       
        
        if(implementObj.Implementation_Status_2__c != null){
            // To Record the date of  WIP_Timestamp__c when status is changed to Work in Progress.
            if(implementObj.Implementation_Status_2__c.equalsIgnoreCase('Work in Progress') && implementObj.WIP_Status__c != true ){
              implementObj.Implementation_Start_Date__c = System.Now();
              implementObj.WIP_Status__c = true;
              System.debug('#### Implementation_Start_Date - '+ implementObj.Implementation_Start_Date__c);
            }
            // To record the date of Implementation_Close_Date__c when status is changed to Completed.
            if(implementObj.Implementation_Status_2__c.containsIgnoreCase('Completed') || 
               implementObj.Implementation_Status_2__c.equalsIgnoreCase('Account Cancelled') || 
               implementObj.Implementation_Status_2__c.equalsIgnoreCase('No Response') || 
               implementObj.Implementation_Status_2__c.equalsIgnoreCase('Invalid Implementations')){
                
                if(prof.Name.equalsIgnoreCase('System Administrator')){
                    if(implementObj.Implementation_Close_Date__c == null  ){
                        implementObj.Implementation_Close_Date__c = System.Today();
                    }
                }else{
                    implementObj.Implementation_Close_Date__c = System.Today();
                }  
              system.debug('#### Implementation_Close_Date__c - '+implementObj.Implementation_Close_Date__c);
            }
        }
        
    }
    
    /********************************************************************************* 
    * Association of LeadQualification of Account of Implementation                  * 
    * This code is for only creat event                                              * 
    * If multiple LeadQualification present for Account, choose last modified one    * 
    **********************************************************************************/
    if(implAccountSet.size() > 0){
        map<Id,Account> implAccountMAp = new map<Id,Account>([SELECT Id,(SELECT Id FROM Lead_Qualifications__r 
                                            ORDER BY LastModifiedDate DESC LIMIT 1) 
                                            FROM Account  WHERE Id IN :implAccountSet]);
        for(Implementation__c implementObj : trigger.new) {
            if(implAccountMAp != null && implementObj.Account__c != null && implAccountMAp.get(implementObj.Account__c) != null && 
                        implAccountMAp.get(implementObj.Account__c).Lead_Qualifications__r.size() >0) {
                implementObj.Lead_Qualification__c = implAccountMAp.get(implementObj.Account__c).Lead_Qualifications__r[0].id;
            }
        }                               
    }
     
    /* Code for updating the Most Recent Implementation Event Id and Implementation Owner update.
       if Implementation Owner is RCSF Sync and an Initial Implementation already exists, 
       update the Implementation Owner, with the advisor invited to the event. */
    try{
        Map<String,Event> rcUserIdEventMap = new Map<String,Event>();
        Map<String,Event> rcUserIdDummyEventMap = new Map<String,Event>();
        Schema.DescribeSObjectResult r = User.sObjectType.getDescribe();
        String userObjectPrefix = r.getKeyPrefix();
        for(Event thisRecord : [SELECT Id, CustomerId__c, Type, (SELECT RelationId FROM EventRelations ORDER BY LastModifiedDate ASC LIMIT 1) 
                                FROM Event WHERE CustomerId__c IN : rcUserIdList AND IsChild != true order by CreatedDate DESC]){
            if(thisRecord.Type != null && !thisRecord.Type.equalsIgnoreCase('System Use')){
                rcUserIdEventMap.put(thisRecord.CustomerId__c, thisRecord);
            }else if(thisRecord.Type != null && thisRecord.Type.equalsIgnoreCase('System Use')){
                rcUserIdDummyEventMap.put(thisRecord.CustomerId__c, thisRecord);
            }
        }
        
        for(Implementation__c thisRecord : trigger.new){
            system.debug('#### Implementation = '+thisRecord.RC_USER_ID__c+' Related Event = '+rcUserIdEventMap.get(thisRecord.RC_USER_ID__c));
            if(thisRecord.RC_USER_ID__c != null && rcUserIdEventMap != null && rcUserIdEventMap.size() > 0 && rcUserIdEventMap.get(thisRecord.RC_USER_ID__c) != null){
                thisRecord.Most_Recent_Implementation_Event__c = rcUserIdEventMap.get(thisRecord.RC_USER_ID__c).Id;
                if(rcUserIdEventMap.get(thisRecord.RC_USER_ID__c).EventRelations != null && 
                   rcUserIdEventMap.get(thisRecord.RC_USER_ID__c).EventRelations.size() > 0 && 
                   rcUserIdEventMap.get(thisRecord.RC_USER_ID__c).Type != null &&
                   rcUserIdEventMap.get(thisRecord.RC_USER_ID__c).Type.EqualsIgnoreCase('Initial Implementation') && 
                   rcUserIdEventMap.get(thisRecord.RC_USER_ID__c).EventRelations[0].RelationId != null && 
                   String.valueOf(rcUserIdEventMap.get(thisRecord.RC_USER_ID__c).EventRelations[0].RelationId).startsWith(userObjectPrefix)){
                    thisRecord.OwnerId = rcUserIdEventMap.get(thisRecord.RC_USER_ID__c).EventRelations[0].RelationId;
                }
            } else if(thisRecord.RC_USER_ID__c != null && rcUserIdDummyEventMap != null && rcUserIdDummyEventMap.size() > 0 && rcUserIdDummyEventMap.get(thisRecord.RC_USER_ID__c) != null){
                thisRecord.Most_Recent_Implementation_Event__c = rcUserIdDummyEventMap.get(thisRecord.RC_USER_ID__c).Id; 
            }
        }
    }catch(Exception ex){
        system.debug('#### Error at line = '+ex.getLineNumber()+' Message = '+ex.getMessage());
   }
    
    ImplementationHelper.markAsPremiumSupportOIDs(trigger.new);
    ImplementationHelper.assignSalesAgent(trigger.new); 
  }
  
  if(Trigger.isUpdate) {
  List<Profile> salesProfile = [SELECT Name, Id FROM Profile  WHERE Name Like 'Sales %'];
     Set<Id> ids = new Set<Id>();
     for(Profile p : salesProfile) {
       ids.add(p.Id);
     }
     
     Set<Id> contactIdSet = new Set<Id>();
     Set<Id> ownerIdSet = new Set<Id>();
     Profile prof = [select Name from Profile where Id = :UserInfo.getProfileId()];         
     for(Implementation__c implementVal : Trigger.newMap.values()) {
         Implementation__c oldVall = Trigger.oldMap.get(implementVal.Id);                   
        if(implementVal.Implementation_Status_2__c != null){
            // To Record the date of  WIP_Timestamp__c when status is changed to Work in Progress.
            if(implementVal.Implementation_Status_2__c.equalsIgnoreCase('Work in Progress') && implementVal.WIP_Status__c != true ){
             implementVal.Implementation_Start_Date__c = System.Now();
             implementVal.WIP_Status__c = true;
             System.debug('### Implementation_Start_Date - '+ implementVal.Implementation_Start_Date__c);
            }
            
            // To record the date of Implementation_Close_Date__c when status is changed to Completed.
            if( implementVal.Implementation_Status_2__c.containsIgnoreCase('Completed') || 
                implementVal.Implementation_Status_2__c.equalsIgnoreCase('Account Cancelled') || 
                implementVal.Implementation_Status_2__c.equalsIgnoreCase('No Response') || 
                implementVal.Implementation_Status_2__c.equalsIgnoreCase('Invalid Implementations')){   
                
                /*********Add condition to allow administrator set date to past   date - 1/29/2015** condition start********/                                   
                if('System Administrator'.equalsIgnoreCase(prof.Name)){
                    if(implementVal.Implementation_Close_Date__c != oldVall.Implementation_Close_Date__c){                      
                    }else{
                        implementVal.Implementation_Close_Date__c = Date.Today();
                    }               
                }else{
                    implementVal.Implementation_Close_Date__c = Date.Today();
                }
                        system.debug('#### Implementation_Close_Date__c - '+implementVal.Implementation_Close_Date__c);
                
                /********************.............................................******end *****/
            }
        }
    
       if(implementVal != null) {
         if(implementVal.contact__c != null) {
           contactIdSet.add(implementVal.contact__c);
         }
         if(implementVal.OwnerId != null) {
           ownerIdSet.add(implementVal.OwnerId);
         }
         if(implementVal.CreatedById != null) {
           ownerIdSet.add(implementVal.CreatedById);
         }
       }
     }
     
     Map<Id,Implementation__c> implementSurveyMap;
     Map<Id,Implementation__c> rogersImplementSurveyMap;
     Map<Id,Implementation__c> aTTImplementSurveyMap;
     Map<Id,Contact> contactMap;
     Map<Id,User> userMap;
     
     if(contactIdSet != null && contactIdSet.size()>0) {
       contactMap = new Map<Id,Contact>([SELECT id,firstName, email FROM Contact WHERE Id IN :contactIdSet]);
     }
     
     if(ownerIdSet != null && ownerIdSet.size() >0) {
       userMap = new Map<Id,User>([SELECT id, email, managerid, userroleid, IsActive ,name, UserRole.Name, Manager.name, 
       Manager.email FROM User WHERE Id IN : ownerIdSet]);
     }
     
     if(Trigger.newMap.keySet() != null) {
       implementSurveyMap = new Map<Id,Implementation__c>([SELECT Name, (SELECT Name, SurveyType__c FROM Surveys__r 
                     WHERE SurveyType__c = 'Implementation') FROM Implementation__c WHERE Id IN : Trigger.newMap.keySet()]);
       rogersImplementSurveyMap = new Map<Id,Implementation__c>([SELECT Name, (SELECT Name, SurveyType__c FROM Surveys__r 
                     WHERE SurveyType__c = 'Rogers Implementation') FROM Implementation__c WHERE Id IN : Trigger.newMap.keySet()]);
         attImplementSurveyMap = new Map<Id,Implementation__c>([SELECT Name, (SELECT Name, SurveyType__c FROM Surveys__r 
                       WHERE SurveyType__c = 'ATT Implementation') FROM Implementation__c WHERE Id IN : Trigger.newMap.keySet()]);
     } 
     
     List<Survey__c> surveyLst = new List<Survey__c>();   
     
     for(Id implemenId : Trigger.newMap.keySet()) {
        
       Implementation__c oldVal = Trigger.oldMap.get(implemenId);
       Implementation__c newVal = Trigger.newMap.get(implemenId);
        if(oldVal != null && newVal != null) { 
          /*
          Business process rules
          */
          if(UserInfo.getProfileId() != '00e80000000l1hKAAQ' 
            && UserInfo.getProfileId() != '00e80000001C12ZAAS') {
              // if user does not have Sys Admin or SE Manager profile
              if(UserInfo.getProfileId() != '00e80000001C12ZAAS' 
                && UserInfo.getProfileId() != '00e80000001Bw3CAAS'
                && UserInfo.getProfileId() != '00e80000001ONxnAAG'//--------------create 25/11/13 by india team [profile name = Support Manager QA]----/
                && UserInfo.getProfileId() != '00e80000001OOplAAG'//--------------create 25/11/13 by india team [profile name = Support Manager QA(data capture)]----/)
                && UserInfo.getProfileId() != '00e80000001OK9tAAG' ){// ----------create 24/09/2014 by India Team [profile name = GW API]
                  // if user does not have SE Manager or SE profile +Sales Agent a& Manager
                  if(newVal.OwnerId != '00580000003eEhrAAE' &&
                    newVal.OwnerId != '005800000036sJJAAY' &&
                    newVal.OwnerId != UserInfo.getUserId()) {
                   //  if(!UserInfo.getProfileId().contains('00e80000001Bzoq') && !UserInfo.getProfileId().contains('00e80000001Bzov'))
                   //  if new owner is not SE Dispatcher or RCSF Sync
                   if(!ids.contains(UserInfo.getProfileId())) {
                        newVal.addError(' You can only assign Implementations to yourself, SE Dispatcher or RCSF Sync.');
              }  
                  }           
              }
             /*Commented on 11/10/2011*/   
            /*  if(UserInfo.getUserId() != oldVal.OwnerId &&
                 (oldVal.OwnerId != '005800000036sJJAAY' &&
                 oldVal.OwnerId != '00580000003eEhrAAE')){
                    trigger.new[i].addError(' Only the owner of this Implementation can change its owner.');
                }*/
        
                /* // Stops user FROM being able to put implementation back into open pipeline
                if(trigger.new[i].Implementation_Status__c != 'Needed' && trigger.new[i].OwnerId == '005800000036sJJAAY'){
                    trigger.new[i].addError(' Please change ownership before updating status.');
                }
                */
          }
          
          if(((newVal.Implementation_Status__c != '6a. Completed' &&
             oldVal.Implementation_Status__c == '6a. Completed') ||
            (newVal.Implementation_Status__c != '6b. Completed - No Help Needed' &&
             oldVal.Implementation_Status__c == '6b. Completed - No Help Needed') ||
            (newVal.Implementation_Status__c != '6c. Completed - Account Cancelled' &&
             oldVal.Implementation_Status__c == '6c. Completed - Account Cancelled')) &&
            (UserInfo.getProfileId() != '00e80000000l1hKAAQ')) {
                  // if any of the fields available to a rep have been changed after being set to a completed status
                  newVal.addError(' Once a Implementation has been completed you cannot change its status. Please cancel your changes. You can still add a note to this implementation');
          }  
          
          if((newVal.Implementation_Status__c == oldVal.Implementation_Status__c) &&
            newVal.Implementation_Status__c.contains('Completed') && 
            (UserInfo.getProfileId() != '00e80000000l1hKAAQ')) {
              if((newVal.Number_of_Lines_Implemented__c != oldVal.Number_of_Lines_Implemented__c) ||
               (newVal.Was_a_warm_transfer__c != oldVal.Was_a_warm_transfer__c)) {
                  // if any of the fields available to a rep have been changed after being set to a completed status
                  newVal.addError(' Once a Implementation has been completed you cannot change its fields. Please cancel your changes. You can still add a note to this implementation');
              } 
          } 
          
          /*********** Check Network Information*******26 June****  */ 
          
          if(newVal.Implementation_Status__c == '6a. Completed' && 
            newVal.Account__c != null && 
            accountMap != null && 
            accountMap.containskey(newVal.Account__c)) {
            List<Network_Information__c> networkInfoList =  accountMap.get(newVal.Account__c).Network_Informations__r;
            if(networkInfoList == null || networkInfoList.size()== 0) {
              newVal.addError(' Please create a new Network Information record for this account before closing the implementation');  
            }
          }
          
          
          /*
          Create and sent implementation survey
          */
          /*Implementation conditions are changed on March 19, 2012*/
        
          if(newVal.Implementation_Status__c != null 
            //&& oldVal.Implementation_Status__c != null 
             //&& (!oldVal.Implementation_Status__c.equalsIgnoreCase('6a. Completed')) 
             //* ******** add condition  1/29/2015***********//  
            && newVal.Brand__c != null && !'System Administrator'.equalsIgnoreCase(prof.Name))   {
                
              // set Close Date to today
                newVal.Implementation_Close_Date__c = Date.today();
               
              // Establish new Implementation Survey if help was needed
              /*New condition added to diffrenciate b/w [Implementation] AND [ATTImplementation]
              newVal.Brand__c == 'RingCentral' || newVal.Brand__c == 'RingCentral Canada'
              */
              if(newVal.Implementation_Status__c != null && newVal.Brand__c != null 
                //&& newVal.Implementation_Status__c == '6a. Completed'
                && ((oldVal.Implementation_Status__c != '6a. Completed' && newVal.Implementation_Status__c == '6a. Completed') 
            || (oldVal.Implementation_Status_2__c != 'Completed' && newVal.Implementation_Status_2__c == 'Completed'))  
                  && (newVal.Brand__c == 'RingCentral' 
                    || newVal.Brand__c == 'RingCentral Canada'
                   // || newVal.Brand__c == 'BT Business'
                    || newVal.Brand__c.containsIgnoreCase('BT')  
                    || newVal.Brand__c == 'RingCentral UK')) {
                  if(newVal.Contact__c == Null) {
                      newVal.Contact__c.addError('Please SELECT the contact you have been working with before setting the Status to Completed');
                  } else {
                      Integer sCheck;
                      Integer cCheck;
                      try {
                          // check for an existing implementation survey tied to this implementation
                            if( implementSurveyMap != null && (implementSurveyMap.get(newVal.Id).Surveys__r) != null) {
                              sCheck = (implementSurveyMap.get(newVal.Id).Surveys__r).size();
                            }
                          //cCheck = [SELECT count() FROM Implementation__c WHERE ContractId=:newVal.Id AND isprimary = true];
                      } catch(System.Exception e){}
                      
                      if(sCheck == 0) { 
                        try {
                            Survey__c surveyObj = new Survey__c();
                            surveyObj.SurveyType__c = 'Implementation';
                            surveyObj.Account__c = newVal.Account__c;
                            surveyObj.Implementation__c = newVal.Id;
                            //userMap
                            if(userMap != null && userMap.containsKey(newVal.OwnerId)) {
                              User userObj = userMap.get(newVal.OwnerId);
                             // User userObj = [SELECT id, email, managerid, userroleid, name FROM User WHERE id=: newVal.OwnerId];
                             if(userObj != null) {
                    surveyObj.Agent__c = userObj.Id;
                                surveyObj.Agent_Email__c = userObj.email;
                                surveyObj.Agent_Name__c = userObj.name;
                             }
                             // s.Agent_Team__c = [SELECT name FROM UserRole WHERE id=:userObj.UserRoleId].name;
                              surveyObj.Agent_Team__c = userMap.get(newVal.OwnerId).UserRole.Name;
                                                      
                             // User manager = [SELECT id, name, email FROM User WHERE id =:userObj.ManagerId];
                            //  User manager = userMap.get(newVal.OwnerId).Manager
                             if(userMap != null && userMap.get(newVal.OwnerId).Manager.Name != null) {
                                  surveyObj.Agent_Manager_Name__c = userMap.get(newVal.OwnerId).Manager.Name;
                             }
                             if(userMap != null && userMap.get(newVal.OwnerId).Manager.Email != null) {
                                surveyObj.Agent_Manager_Email__c = userMap.get(newVal.OwnerId).Manager.Email;
                             }
                             // s.Agent_Manager_Name__c = manager.Name;
                             // s.Agent_Manager_Email__c = manager.Email;
                            }
                            surveyObj.Contact__c = newVal.Contact__c;
                            if(contactMap != null && surveyObj.Contact__c != null && contactMap.containsKey(surveyObj.Contact__c)) {
                            Contact contactObj = contactMap.get(surveyObj.Contact__c);
                             // Contact contactObj = [SELECT firstName, email FROM Contact WHERE id=: s.Contact__c];
                              surveyObj.contact_email__c = contactObj.email;
                              surveyObj.name = 'Implementation - ' + Datetime.now().format();
                            }
                            //surveyObj.OwnerId = newVal.CreatedById;
                            if(userMap != null && userMap.containsKey(newVal.CreatedById)) {
                               User userObj = userMap.get(newVal.CreatedById);
                               if(userObj != null && userObj.isActive == true) {
                                 surveyObj.OwnerId = newVal.CreatedById;
                               }
                             }
                             surveyLst.add(surveyObj);
                            //insert surveyObj;
                        } catch(Exception ex) {}
                      }
                  } 
                   /* Else condition for ATT Office @ Hand*/
               } else if(newVal.Implementation_Status__c != null && newVal.Brand__c != null 
                 //&& newVal.Implementation_Status__c.equalsIgnoreCase('6a. Completed')
                 && ((oldVal.Implementation_Status__c != '6a. Completed' && newVal.Implementation_Status__c == '6a. Completed') 
              || (oldVal.Implementation_Status_2__c != 'Completed' && newVal.Implementation_Status_2__c == 'Completed'))  
                 && (newVal.Brand__c.equalsIgnoreCase('AT&T Office@Hand') || newVal.Brand__c.equalsIgnoreCase('RingCentral Office@Hand from AT&T'))) {
            if(newVal.Contact__c == null) {
                        newVal.Contact__c.addError('Please SELECT the contact you have been working with before setting the Status to Completed');
            } else {
                        Integer sCheck = 0;
                        Integer cCheck = 0;
                        /*try {   
                          if(attImplementSurveyMap != null && (attImplementSurveyMap.get(newVal.Id).Surveys__r) != null) {
                                sCheck = (attImplementSurveyMap.get(newVal.Id).Surveys__r).size();
                             }
                            // sCheck = [SELECT count() FROM Survey__c WHERE Implementation__c=: newVal.id AND SurveyType__c = 'ATT Implementation'];
                        } catch(System.Exception e){}*/
                       sCheck = 0; 
                      if(sCheck == 0) {
                        try {
                            Survey__c surveyObj = new Survey__c();
                            surveyObj.SurveyType__c = 'ATT Implementation';
                            surveyObj.Account__c = newVal.Account__c;
                            surveyObj.Implementation__c = newVal.Id;
                            if(userMap != null && userMap.containsKey(newVal.OwnerId)) {
                              User userObj = userMap.get(newVal.OwnerId);
                             // User userObj = [SELECT id, email, managerid, userroleid, name FROM User WHERE id=: newVal.OwnerId];
                               // if()
                              surveyObj.Agent__c = userObj.Id;
                              surveyObj.Agent_Email__c = userObj.email;
                              surveyObj.Agent_Name__c = userObj.name;
                             // s.Agent_Team__c = [SELECT name FROM UserRole WHERE id=:userObj.UserRoleId].name;
                              surveyObj.Agent_Team__c = userMap.get(newVal.OwnerId).UserRole.Name;
                                                      
                              if(userMap != null && userMap.get(newVal.OwnerId).Manager.Name != null) {
                                  surveyObj.Agent_Manager_Name__c = userMap.get(newVal.OwnerId).Manager.Name;
                              }
                              if(userMap != null && userMap.get(newVal.OwnerId).Manager.Email != null) {
                                surveyObj.Agent_Manager_Email__c = userMap.get(newVal.OwnerId).Manager.Email;
                              }
                            }
                            
                            surveyObj.Contact__c = newVal.Contact__c;
                            if(contactMap != null && surveyObj.Contact__c != null && contactMap.containsKey(surveyObj.Contact__c)) {
                              Contact contactObj = contactMap.get(surveyObj.Contact__c);
                            //Contact contactObj = [SELECT firstName, email FROM Contact WHERE id=: s.Contact__c];
                              surveyObj.contact_email__c = contactObj.email;
                                surveyObj.name = 'ATT Implementation - ' + Datetime.now().format();
                            }
                             surveyLst.add(surveyObj);
                            //insert surveyObj;
                        } catch(Exception ex) {}
                      }
                  } 
              }     /* Else for Rogers */
              else if(newVal.Implementation_Status__c != null 
              && newVal.Brand__c != null 
              //&& newVal.Implementation_Status__c.equalsIgnoreCase('6a. Completed')
              && ((oldVal.Implementation_Status__c != '6a. Completed' && newVal.Implementation_Status__c == '6a. Completed') 
            || (oldVal.Implementation_Status_2__c != 'Completed' && newVal.Implementation_Status_2__c == 'Completed'))  
              && (newVal.Brand__c.equalsIgnoreCase('Rogers'))) {
                  if(newVal.Contact__c == Null) {
                      newVal.Contact__c.addError('Please SELECT the contact you have been working with before setting the Status to Completed');
                  } else {
                      Integer sCheck;
                      try {   
                         if( rogersImplementSurveyMap != null && (rogersImplementSurveyMap.get(newVal.Id).Surveys__r) != null) {
                              sCheck = (rogersImplementSurveyMap.get(newVal.Id).Surveys__r).size();
                           }
                          //sCheck = [SELECT count() FROM Survey__c WHERE Implementation__c=: newVal.id AND SurveyType__c = 'Rogers Implementation'];
                      }
                      catch(System.Exception e){}
                      
                      if(sCheck == 0) {
                        try {
                            Survey__c surveyObj = new Survey__c();
                            surveyObj.SurveyType__c = 'Rogers Implementation';
                            surveyObj.Account__c = newVal.Account__c;
                            surveyObj.Implementation__c = newVal.Id;
                            
                            if(userMap != null && userMap.containsKey(newVal.OwnerId)) {
                              User userObj = userMap.get(newVal.OwnerId);
                             // User userObj = [SELECT id, email, managerid, userroleid, name FROM User WHERE id=: newVal.OwnerId];
                              surveyObj.Agent__c = userObj.Id;
                              surveyObj.Agent_Email__c = userObj.email;
                              surveyObj.Agent_Name__c = userObj.name;
                             // s.Agent_Team__c = [SELECT name FROM UserRole WHERE id=:userObj.UserRoleId].name;
                              surveyObj.Agent_Team__c = userMap.get(newVal.OwnerId).UserRole.Name;
                                                      
                              if(userMap != null && userMap.get(newVal.OwnerId).Manager.Name != null) {
                                  surveyObj.Agent_Manager_Name__c = userMap.get(newVal.OwnerId).Manager.Name;
                              }
                              if(userMap != null && userMap.get(newVal.OwnerId).Manager.Email != null) {
                                surveyObj.Agent_Manager_Email__c = userMap.get(newVal.OwnerId).Manager.Email;
                              }
                            }
                            
                            surveyObj.Contact__c = newVal.Contact__c;
                            if(contactMap != null && contactMap.containsKey(surveyObj.Contact__c)) {
                              Contact contactObj = contactMap.get(surveyObj.Contact__c);
                           // Contact contactObj = [SELECT firstName, email FROM Contact WHERE id=: s.Contact__c];
                              surveyObj.contact_email__c = contactObj.email;
                              surveyObj.name = 'Rogers Implementation - ' + Datetime.now().format();
                            }
                             surveyLst.add(surveyObj);
                            //insert surveyObj;
                        } catch(Exception ex) { } 
            } 
            }
        }
       }
      }
    }
    if(surveyLst != null && surveyLst.size()>0) {
      try {
        insert surveyLst;
      } catch(DMLException ex) {}
    }
    
   /* for(Implementation__c imp: Trigger.new){
        
    }*/
   }
   
   /*
   * Graduation Score card Implementation Phase Start
   */
   if(Trigger.isUpdate || Trigger.isInsert){
        //map<Id, Account> accountMetricMap = AccountScoreCardHelper.getAccountsWithAccountMetric(accountIds);
        //list<Account_Metric__c> accountMetricList = new list<Account_Metric__c>(); 
      try{
        String strAction = GraduationScoreCardHelper.STR_INSERT;
        if(Trigger.isUpdate){
                strAction = GraduationScoreCardHelper.STR_UPDATE;
        }
        for(Implementation__c imp: Trigger.new){
            system.debug('imp.Implementation_Status_2__c--->'+imp.Implementation_Status_2__c);
            //if(Trigger.oldMap == null ||(Trigger.oldMap.get(imp.Id).Implementation_Status_2__c != imp.Implementation_Status_2__c)){
                GraduationScoreCardHelper.ScoreCardWrapper objScoreCardWrapper = new GraduationScoreCardHelper.ScoreCardWrapper();
                if(Trigger.isUpdate){
                    objScoreCardWrapper = GraduationScoreCardHelper.getImplementationCompletionDetails(imp, Trigger.oldMap.get(imp.Id), strAction);
                }else{
                    objScoreCardWrapper = GraduationScoreCardHelper.getImplementationCompletionDetails(imp, null, strAction);
                }
                system.debug('objScoreCardWrapper.dCompletionRate--->'+objScoreCardWrapper.dCompletionRate);
                imp.Implementation_Phase_Completion_Rate__c = objScoreCardWrapper.dCompletionRate != null ? objScoreCardWrapper.dCompletionRate : 0;
                imp.Account_Graduation_Status__c = 'New';
                /*Account_Metric__c accountMetric = new Account_Metric__c();
                if(accountMetricMap.get(imp.Account__c) != null && accountMetricMap.get(imp.Account__c).Account_Metrics__r.size()>0){
                        accountMetric = accountMetricMap.get(imp.Account__c).Account_Metrics__r[0];
                    }
                */
                if(objScoreCardWrapper.dCompletionRate == 100){
                    if(objScoreCardWrapper.bUpdateAcount){
                        imp.Account_Graduation_Date_0_30__c = objScoreCardWrapper.completionDate != null ? objScoreCardWrapper.completionDate : system.now(); 
                    }
                    imp.Account_Graduation_Status__c = 'Done';
                }
                if(objScoreCardWrapper.dCompletionRate >0 && objScoreCardWrapper.dCompletionRate <100){
                    imp.Account_Graduation_Status__c = 'Implementation Phase';
                }
        }
       }catch(Exception ex){
        system.debug('Error---->'+ex.getMessage());
      }
   }
   /* Graduation Score card Implementation Phase END*/
}