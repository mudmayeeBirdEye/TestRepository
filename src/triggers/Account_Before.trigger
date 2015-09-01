/*************************************************
Trigger on Account object
Before Update: Update Current Owner Name and Email fields as needed.
Before Insert & Update: Format RC Account Number by removing the the 1 from the front of US numbers.              
/************************************************/

trigger Account_Before on Account(before insert, before update, before delete) {
    // Flag to check if trigger is to be executed or not.
    if (TriggerHandler.BY_PASS_ACCOUNT_ON_BEFORE) {
        System.debug('### RETURNED FROM ACCOUNT BEFORE TRG ###');
        return;
    } else {
        System.debug('### STILL CONTINUE FROM ACCOUNT BEFORE TRG ###');
        TriggerHandler.BY_PASS_ACCOUNT_ON_BEFORE = true;
    }
    //---------------------------------As/Simplion/10/16/2014 ends--------------------------------------------------------------------------    
    //----This flags are removed as we have implemented flags on top which are flag for explicit entry
    /*if (TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT || TriggerHandler.BY_PASS_ACCOUNT_ON_UPDATE) {
        System.debug('### RETURNED FROM ACCOUNT INSERT TRG ###');
        return;
    } else {
        System.debug('### STILL CONTINUE FROM ACCOUNT INSERT TRG ###');
    }*/

    Schema.DescribeSObjectResult result = Account.SObjectType.getDescribe();
    Map < ID, Schema.RecordTypeInfo > rtMapByName = result.getRecordTypeInfosById();
    Map < ID, Schema.RecordTypeInfo > rtMapById = result.getRecordTypeInfosById();
    
    if (!Trigger.isDelete){
            
    AccountTriggerHelperExt.userIds = AccountTriggerHelperExt.prepareUserIdSet(trigger.new); 
    
    for(Account accountObj:Trigger.new){
        if(!String.isBlank(accountObj.Partner_ID__c)){
            AccountTriggerHelperExt.AllRecordsPartnerId.add(accountObj.Partner_ID__c);
        }
        if(!String.isBlank(accountObj.Partner_ID__c) && rtMapByName != null && accountObj.RecordTypeId != null && rtMapByName.get(accountObj.RecordTypeId ).getName() == AccountTriggerHelperExt.CUSTOMER_ACCOUNT) {  
            AccountTriggerHelperExt.partnerAndCustomerMap.put(accountObj.Partner_ID__c,accountObj);
            
        }
        if(!String.isBlank(accountObj.Partner_ID__c) && rtMapByName != null && accountObj.RecordTypeId != null && rtMapByName.get(accountObj.RecordTypeId ).getName() == AccountTriggerHelperExt.PARTNER_ACCOUNT) {  
            AccountTriggerHelperExt.partnerAccountMap.put(accountObj.Partner_ID__c,accountObj); 
            
        }
    }
    if(AccountTriggerHelperExt.AllRecordsPartnerId.size() >0){
        AccountTriggerHelperExt.currentCustomersPartnersListQuery = [SELECT Id,Name,Most_Recent_Implementation_Contact__c,
                                        (Select Id, AccountId, ContactId, Role, IsPrimary, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, IsDeleted From AccountContactRoles where isPrimary=true),
                                        Ultimate_Parent_Account_ID__c,Current_Owner_Email__c,Current_Owner_Name__c,Ultimate_Parent_Account_Name__c,Partner_ID__c,Do_Not_Creation_Implementation__c,
                                        Ultimate_Parent_Partner_ID__c,Ultimate_Partner_ID__c,Ultimate_Partner_Name__c,Current_Owner__c,
                                        Eligible_for_Refferel_Credit__c,Pay_Referral_Commissions__c,Partner_Sign_Up_Date__c,RC_Signup_Date__c,
                                        Partner_Customer_Count__c FROM Account 
                                        WHERE  Partner_ID__c IN:AccountTriggerHelperExt.AllRecordsPartnerId and RecordType.Name =: AccountTriggerHelperExt.PARTNER_ACCOUNT] ;
            System.debug ('Chk currentCustomersPartnersListQuery '+AccountTriggerHelperExt.currentCustomersPartnersListQuery.size());                     
        
    }
                                    
                                       
                
    /*if (!Trigger.isDelete) {
        Set < Id > userIds = AccountTriggerHelperExt.prepareUserIdSet(trigger.new);
        AccountTriggerHelperExt.allUserMap = new Map<Id,User>([SELECT Phone, Email,FirstName, LastName, Name FROM User WHERE Id IN :userIds]);
        AccountTriggerHelperExt.allUserMap = AccountTriggerHelperExt.allUserMap;   
    }*/
     }
    if (Trigger.isInsert) {
        //Changed method name
        AccountTriggerHelperExt.setAccountValues(trigger.new, AccountTriggerHelperExt.allUserMap);
        
        AccountTriggerHelperExt.accountSharingOnInsert(trigger.new);
        /*-----For Updation  of customer count on Partner Account ------------*/
        //------As/Simplion/3/13/2015------------------------------------------
        //----------------------Removed and send to after trigger
        //AccountTriggerHelperExt.updateCreditCounter(trigger.new, null);
        AccountTriggerHelperExt.setEligibalForReferealCredit(trigger.new);  
        AccountTriggerHelperExt.setServiceType(trigger.new);
        
    }

    if (trigger.isUpdate) { 
        
                                        
        AccountTriggerHelperExt.allUpdatedAccountQuery = [SELECT Id,Name,Most_Recent_Implementation_Contact__c, Preferred_Language__c,
                                    (Select Id, AccountId, ContactId, Role, IsPrimary, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, IsDeleted,contact.Preferred_Language__c From AccountContactRoles where isPrimary=true),
                                    (select Id,name,email,Preferred_Language__c from Contacts ORDER By LastModifiedDate DESC)
                                    Ultimate_Parent_Account_ID__c,Current_Owner_Email__c,Current_Owner_Name__c,Ultimate_Parent_Account_Name__c,Partner_ID__c,Do_Not_Creation_Implementation__c,
                                    Ultimate_Parent_Partner_ID__c,Ultimate_Partner_ID__c,Ultimate_Partner_Name__c,Current_Owner__c,
                                    Eligible_for_Refferel_Credit__c,Pay_Referral_Commissions__c,Partner_Sign_Up_Date__c,RC_Signup_Date__c,
                                    Partner_Customer_Count__c FROM Account 
                                    WHERE  Id IN : trigger.newMap.keyset()] ;   
        AccountTriggerHelperExt.oldAccountMap = trigger.oldMap;
        //AccountTriggerHelperExt.updateAccountInformation(trigger.new, AccountTriggerHelperExt.allUserMap);
        AccountTriggerHelperExt.setAccountValuesOnUpdate(trigger.newMap,trigger.oldMap); 
        //Removed this method as it is not in use and we have shifted its code in above method
        //AccountTriggerHelperExt.accountSharingOnUpdate2(trigger.new);
        /*-----For Updation  of customer count on Partner Account ------------*/
        //------As/Simplion/3/13/2015------------------------------------------
        //------This line has been moved into account after insert-------FYI
        AccountTriggerHelperExt.updateEligibalForReferealCredit(trigger.new,trigger.oldMap);
        //AccountTriggerHelperExt.updateCreditCounter(trigger.new, trigger.oldmap);
        AccountTriggerHelperExt.updateMostRecentImplementationContact(trigger.newMap);
        AccountTriggerHelperExt.setServiceType(trigger.new);
        
    }

    if (trigger.isInsert || trigger.isUpdate) {
        //------This line has been moved into account after insert-------FYI
        //AccountTriggerHelperExt.updatePartnerCodeOnInsertAndUpdate(trigger.new);
        
        //---------------------------------As/Simplion/10/16/2014 ends--------------------------------------------------------------------------        
        /**Start calculation of Completion Rate and Completion Date of Graduation Phase of Graduation Score Card */
        //GraduationScoreCardHelper.calculateGraduationCompletionRate(trigger.new, trigger.oldMap); 
    }

    /********** For Account Hierarchy Total DLS Field updation *********
     * @Description : updating the Account's Hierarchy with total num- *
     *              : -ber of DLs.                                     *
     * @updatedBy   : India team                                       *
     * @updateDate  : 23/07/2014                                       *
     *******************************************************************/
    if (Trigger.isDelete) {
        for (Account accObj: Trigger.old) {
            // Only re-evaluate the hierarchy if either Ultimate Parent is being deleted or any 'Paid' Account is deleted.
            if (accObj.RC_Account_Status__c == 'Paid' || string.valueOf(accObj.Ultimate_Parent_Account_ID__c).subString(0, 15) == string.valueOf(accObj.id).subString(0, 15)) {
                if (string.valueOf(accObj.Id).subString(0, 15) != string.valueOf(accObj.Ultimate_Parent_Account_ID__c).subString(0, 15)) {
                    AccountTriggerHelperExt.ultimateParentIdSet.add(string.valueOf(accObj.Ultimate_Parent_Account_ID__c).subString(0, 15));
                    AccountTriggerHelperExt.ultimateParentIdSet.add(string.valueOf(accObj.Id).subString(0, 15));
                } else if (string.valueOf(accObj.Id).subString(0, 15) == string.valueOf(accObj.Ultimate_Parent_Account_ID__c).subString(0, 15)) {
                    AccountTriggerHelperExt.ultimateParentIdSet.add(string.valueOf(accObj.Id).subString(0, 15));
                }
            }
        }
        
    }
    /************End of For Account Hierarchy Total DLS Field updation**************************************/

    /*******************************************************************
     * @Description.: updating the Account's lastTouchbySalesAgent     *
     * @updatedBy...: India team                                       *
     * @updateDate..: 19/03/2014                                       *
     * @Case Number.: 02432238                                         *
     *******************************************************************/
    /*********************************************Case:02432238 Start's here *****************************************/
    //-------------This below code is modified and moved into before insert and update specific code 
    /*try {
        User userObj = (AccountTriggerHelperExt.allUserMap != null ? AccountTriggerHelperExt.allUserMap.get(UserInfo.getUserId()) : null); // [SELECT Id, FirstName, Lastname, Name, Email, Phone, ProfileId FROM User WHERE Id =: UserInfo.getUserId()];
        Profile objpro = [SELECT Name, Id FROM Profile WHERE Id = : UserInfo.getProfileId()];
        if (objpro.Name.toLowerCase().contains('sales') && !objpro.Name.toLowerCase().contains('engineer')) {
            AccountTriggerHelperExt.userAssignmentOnAccount(trigger.new, userObj);
        }
    } catch (Exception Ex) {
        system.debug('#### Error on line - ' + ex.getLineNumber());
        system.debug('#### Error message - ' + ex.getMessage());
    }*/
    /******************************************Case:02432238 End's here*************************************************/
    //------As/Simplion/3/13/2015------------------------------------------
    //------Below commented code has been moved into account after update-------FYI
    /*if (trigger.isUpdate) {
        system.debug('=========3' + trigger.oldMap);
        AccountTriggerHelperExt.updateContactStatus(trigger.new);
    }*/
}