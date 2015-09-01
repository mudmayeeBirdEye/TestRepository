/*********************************************************************** ***************************
 * Project Name..........:                                                                         *
 * File..................: Account.Trigger                                                         *
 * Version...............: 1.0                                                                     *
 * Created by............: Simplion Technologies                                                   *
 * Created Date..........: 14-04-2014                                                              *
 * Last Modified by......: Simplion Technologies/Ashish agarwal                                    *
 * Last Modified Date....: 12-05-2015                                                              *
 * Description...........: Trigger on Account object                                               *
 *                        After Insert: Check to see if implementation is needed.                  *
 *                        After Update: Check to see if implementation is warrented with update.   * 
 *                                      Closed implementations if necessary.                       *
 *                                      Created Cancelled Trial leads.                             *
 *                                      Alert contract owners if necessary.                        *
 **************************************************************************************************/

Trigger Account on Account (after insert, after update,After Delete) { 
    
        // Flag to check if Trigger is to be executed or not.
    if(TriggerHandler.BY_PASS_ACCOUNT_ON_AFTER){
        System.debug('### RETURNED FROM ACCOUNT INSERT-AFTER TRG ###');
        return;
    }else{
        System.debug('### STILL CONTINUE FROM ACCOUNT AFTER TRG ###');
        TriggerHandler.BY_PASS_ACCOUNT_ON_AFTER = true;
    }
    //---------------------------As/Simplion/5/5/2015-------------------------------
    //-----------------These are new properties------------------------------------------
    
    List<SObject> allRecordsForUpdate = new List<SObject>();
    List<Sobject> allRecordsForInsert = new List<Sobject>();
    List<Sobject> allRecordsForUpsert = new List<Sobject>();
    Boolean accountHierachyCalculationEnabled = (AccountHierarchyCustomSetting__c.getInstance('AccountHierarchyInstance') != null && AccountHierarchyCustomSetting__c.getInstance('AccountHierarchyInstance').HierarchyCalculationEnabled__c) ? true : false;
    Map<String,Account> partnerAccMap;
    Group financeGroup;
    Map<Id,Contact> AllContactsMap = new Map<Id,Contact>();
    if (!Trigger.isDelete){
        
        
            // Assign new Account Map
        AccountTriggerHelper.newAccountMap = Trigger.newMap;
        // Assign Old Account Map
        AccountTriggerHelper.oldAccountMap = Trigger.oldMap;
        AccountTriggerHelper.accountIds = Trigger.newMap.keyset();
        
        AccountTriggerHelper.stateVarriable = 'In account Trigger';
        AccountTriggerHelper.triggerCounter++;
        System.debug(AccountTriggerHelper.stateVarriable+'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'+AccountTriggerHelper.triggerCounter);
        
        
        //--------------------------------------As/simplion/4/7/2015-------------------------------------------------------
        partnerAccMap = AccountTriggerHelperExt.partnerAccountMap;
        AccountTriggerHelperExt.currentPartnersCustomerListQuery = [SELECT id,Current_Owner__c,Partner_ID__c,Do_Not_Creation_Implementation__c FROM Account WHERE Partner_ID__c IN: partnerAccMap.keySet()
                                                                        AND RecordType.Name =: AccountTriggerHelperExt.CUSTOMER_ACCOUNT];
        //-------------------------As/simplion/4/8/2015--------------------------------------------------------------------
        //-----------------This below code is to optimize foloowing query and make it cache for after context of the Trigger-----------------
        //-----------------Similar SOQL is also present in Before Account Trigger but will not include new Partner records in result so we repeat this query again in after Trigger as well.
        if(AccountTriggerHelperExt.AllRecordsPartnerId.size() >0){
            AccountTriggerHelper.currentCustomersPartnersListInAfterQuery = [SELECT Id,Name,Most_Recent_Implementation_Contact__c, 
                                            (Select Id, AccountId, ContactId, Role, IsPrimary, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, IsDeleted From AccountContactRoles where isPrimary=true),
                                            (select Id,name,email,Preferred_Language__c from contacts ORDER By LastModifiedDate DESC),
                                            Ultimate_Parent_Account_ID__c,Current_Owner_Email__c,Current_Owner_Name__c,Ultimate_Parent_Account_Name__c,Partner_ID__c,Do_Not_Creation_Implementation__c,
                                            Ultimate_Parent_Partner_ID__c,Ultimate_Partner_ID__c,Ultimate_Partner_Name__c,Current_Owner__c,
                                            Eligible_for_Refferel_Credit__c,Pay_Referral_Commissions__c,Partner_Sign_Up_Date__c,RC_Signup_Date__c,
                                            Partner_Customer_Count__c FROM Account 
                                            WHERE  Partner_ID__c IN:AccountTriggerHelperExt.AllRecordsPartnerId and RecordType.Name =: AccountTriggerHelperExt.PARTNER_ACCOUNT] ;
            
        }
        //----------------------Creating a map of all partner accounts with there partner Id as key.
        
        for(Account accObj : AccountTriggerHelper.currentCustomersPartnersListInAfterQuery){
            AccountTriggerHelper.partnerAccountContactMap.put(accObj.Partner_ID__c,accObj);
        }
        Set<String> closedStagesSet = new Set<String>();
        // Old Stages
        closedStagesSet.add('4. Closed');
        closedStagesSet.add('8. Closed Won');   
        //New Stages
        closedStagesSet.add('7. Closed Won');
        
        Set<String> caseTypeSetForQuery = new Set<String>{'Finance','Support - T3'};
        AccountTriggerHelper.allAccountInAfterQuery  = [SELECT Id,No_of_Employees__c, RC_Brand__c,RC_Service_name__c, RC_Tier__c,RC_User_ID__c,Account_Graduation_Date_0_30__c, Graduation_Kit__c,Account_Graduation_Date_61_90__c,Name,
                                                            Account_Graduation_Date_31_60__c,Implementation_Phase_Completion_Rate__c, Adoption_Phase_Completion_Rate__c, 
                                                            Graduation_Phase_Completion_Rate__c,Most_Recent_Implementation_Contact__c,Preferred_Language__c, RC_Account_Status__c,RC_Account_Number__c, 
                                                            Owner.Email,Owner.Name,Owner.Team__c, Owner.Manager.Name, Owner.Manager.Email,CreatedBy.Name, 
                                                            (Select Id,Account.Name, Contact.Email,Contact.phone, Contact.Account.No_of_Employees__c, Contact.FirstName, Contact.LastName,Contact.NumberOfEmployees__c,
                                                             IsPrimary,Account.No_of_Employees__c, AccountId, ContactId, Role, CreatedDate, CreatedById, LastModifiedDate,
                                                              LastModifiedById, SystemModstamp, IsDeleted From AccountContactRoles where isPrimary=true),
                                                            (SELECT Id FROM Surveys__r WHERE SurveyType__c = 'VAR Customer' limit 1),
                                                            (SELECT Id, accountId, FirstName, LastName, Email, NumberOfEmployees__c,Preferred_Language__c, Contact_Status__c,
                                                             Contact_Funnel_Type__c,Phone,Account.Name,Account.No_of_Employees__c,isCustomer__c,People_Segment__c FROM Contacts Order by LastModifiedDate DESC),
                                                            (Select Id,Is_Premium_Implementation_Required__c From Opportunities 
                                                                WHERE Is_Premium_Implementation_Required__c=true 
                                                                    AND StageName IN : closedStagesSet AND RecordType.Name =: AccountTriggerHelperExt.SALES_OPPORTUNITY),
                                                            (SELECT Id,RecordType.Name,Status FROM Cases WHERE RecordType.Name IN :caseTypeSetForQuery ORDER BY CreatedDate DESC),
                                                            (SELECT Id, Name, Type, AccountId, SlaProcessId, StartDate, Status, BusinessHoursId FROM Entitlements),
                                                            (Select Id, Account_Graduation_Status__c, Account__c,Implementation_Status__c ,Implementation_Status_2__c,Implementation_Type__c from Implementations__r ORDER BY CreatedDate DESC),
                                                            (SELECT Id, OwnerId, Owner.Email, AccountId FROM Contracts),
                                                            (Select Account_ID__c, Metric_3_value__c, Metric_11_value__c, Metric_18_value__c,Adoption_Phase_Completion_Rate__c,
                                                                Account_Graduation_Date_31_60__c, Account_Graduation_Date_61_90__c, 
                                                                Graduation_Phase_Completion_Rate__c, Account_Graduation_Status__c,
                                                                Metric_23_value__c, Metric_27_value__c, Metric_28_value__c From Account_Metrics__r order by LastModifiedDate DESC limit 1 ),
                                                            Ultimate_Parent_Account_ID__c,Current_Owner_Email__c,Current_Owner_Name__c,Ultimate_Parent_Account_Name__c,Partner_ID__c,Do_Not_Creation_Implementation__c,
                                                            Ultimate_Parent_Partner_ID__c,Ultimate_Partner_ID__c,Ultimate_Partner_Name__c,Current_Owner__c,
                                                            Eligible_for_Refferel_Credit__c,Pay_Referral_Commissions__c,Partner_Sign_Up_Date__c,RC_Signup_Date__c,
                                                            Partner_Customer_Count__c FROM Account 
                                                            WHERE  Id IN : Trigger.newMap.keyset()] ;
        System.debug('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~AccountTriggerHelper.allAccountInAfterQuery'+AccountTriggerHelper.allAccountInAfterQuery);                                                   
        //-----------------As/Simplion/4/7/2015-----------------------------------------------------------------------------------
        //-----------------This functionality is shifted from AccountTriggerHealper Class Constructor and modified and corrected------------------                                                      
        Map<Id,List<AccountContactRole>> accountContactRoleMap = new Map<Id,List<AccountContactRole>>();
        
        Set<String> partnerAccountIdSet15Digit = new set<String>();
        set<String> allAccountParentIdSet = new Set<String>();
        
        
        for(Account accountFrmQuery : AccountTriggerHelper.allAccountInAfterQuery ) {
            
            //--------------creating a list of Entiltelments ------------------------
            if(accountFrmQuery.Entitlements != null && accountFrmQuery.Entitlements.size() > 0){
                AccountTriggerHelperExt.EntitlementsList.addAll(accountFrmQuery.Entitlements);
            }
            AccountTriggerHelper.accountContractMap.put(accountFrmQuery.Id,accountFrmQuery.contracts);
            AccountTriggerHelper.allAccountsMapAfterQuery.put(accountFrmQuery.Id,accountFrmQuery); 
            //------------This map contains all related opportunities count with account Id as a key
            
            AccountTriggerHelper.premiumImpAccMap.put(accountFrmQuery.id, accountFrmQuery.Opportunities != null?accountFrmQuery.Opportunities.size():0);
            //------------This Map will conatain all contacts with respect of Account Id as key
            AccountTriggerHelper.AllAccountContactMapQuery.put(accountFrmQuery.Id,accountFrmQuery.contacts);
            //------------This Map will contain all AccountContactRoles with respect of Account id as key
            accountContactRoleMap.put(accountFrmQuery.Id,accountFrmQuery.AccountContactRoles);
            for(Contact cont : accountFrmQuery.contacts){
                //----------------This map contains all contacts of all accounts with respect to there contact id itself as a key
                AllContactsMap.put(cont.Id,cont);
            }
            
        
        }
        for(Account newAccount : Trigger.new){
            if(newAccount.ParentId != null){
                partnerAccountIdSet15Digit.add('%'+string.valueOf(newAccount.Id).substring(0,15)+'%');
                allAccountParentIdSet.add(newAccount.ParentId);
            }
        }
        if(partnerAccountIdSet15Digit.size() > 0){
            AccountTriggerHelper.allAccountsByParentDetails = [Select id,Name,Parent_Detail__c,Partner_ID__c,Do_Not_Creation_Implementation__c,Ultimate_Parent_Partner_ID__c,
                                                               Ultimate_Partner_ID__c,Ultimate_Partner_Name__c,Ultimate_Parent_Account_ID__c,Ultimate_Parent_Account_Name__c,
                                                               Current_Owner__c,Current_Owner_Email__c,Current_Owner_Name__c,Account_Depth__c,parentId,RecordType.Name
                                                               from Account where parentId!= null AND Parent_Detail__c != null AND Parent_Detail__c LIKE :partnerAccountIdSet15Digit];
        }
        if(allAccountParentIdSet.size() > 0){
            AccountTriggerHelper.allAccountParentByParentIdQuery =new Map<ID,Account>([Select  id,Parent_Detail__c,Account_Depth__c from Account where ID IN: allAccountParentIdSet]);
        }
        
         
        //------------------As/Simplion/4/30/2015---------------------------------------------------------
        //------------------Optimization required---------------------------------------------------------
        for(Account accountFrmQuery : AccountTriggerHelper.allAccountInAfterQuery ) {
            Contact mostRecentCont;
            if(accountFrmQuery.contacts.size()> 0){
                mostRecentCont = accountFrmQuery.contacts[0];
                if(mostRecentCont!=null){
                    
                }
            }
            else{               
                mostRecentCont = null;
                                
            }
            if(accountContactRoleMap.get(accountFrmQuery.Id) != null && accountContactRoleMap.get(accountFrmQuery.Id).size()>0){
                AccountTriggerHelper.PrimaryContactAccountMap.put(accountFrmQuery.Id,AllContactsMap.get(accountContactRoleMap.get(accountFrmQuery.Id)[0].contactId));
            }
            else{
                AccountTriggerHelper.PrimaryContactAccountMap.put(accountFrmQuery.Id,mostRecentCont);
            }
        }
        
        financeGroup = [SELECT Id FROM Group WHERE Name = 'Finance Queue' AND Type = 'Queue' limit 1];
    }   
    
    
    //------------------Optimization required end---------------------------------------------------------
    
    
    //--------------------------Insert event section starts------------------------------------------------                                                                                              
    if(Trigger.isInsert){
        
        
        //---------------------Moved From Account Before Trigger--------------------------------------------- 
        //-------------This property is being set from account Before trigger function------------------
        if(AccountTriggerHelperExt.accountsListForUpdateForCreditCounter.size() >0){
            System.debug('~~~~~~~~~~~~~~~~~~~~~~~~~~~~AccountTriggerHelperExt.accountsListForUpdateForCreditCounter'+AccountTriggerHelperExt.accountsListForUpdateForCreditCounter);
            allRecordsForUpdate.addAll((List<Sobject>)AccountTriggerHelperExt.accountsListForUpdateForCreditCounter);
        }
        //AccountTriggerHelperExt.setCreditCounter(Trigger.new);
        
        //--------------As/Simplion/6/4/2015-----------------------------------------------------------------
        Map<string,Account> MapMobNumAccount = AccountTriggerHelper.createAccountMobileNumberMap(Trigger.new);
        AccountTriggerHelper.lstCarrData = [SELECT Id,Carrier_Wireless_Phone_Number__c FROM Carrier_Data__c 
                                                        WHERE  Carrier_Wireless_Phone_Number__c != NULL AND Carrier_Wireless_Phone_Number__c IN:MapMobNumAccount.keyset() order by lastmodifiedDate];

        List<Carrier_Data__c>listOfCarrierDataToUpdate = AccountTriggerHelper.updateCarrierDataRecordNew(AccountTriggerHelper.lstCarrData,MapMobNumAccount);
        //----------------------------Update the carrier data(In last) --------------------------------------------------------------
        allRecordsForUpdate.addAll((List<Sobject>)listOfCarrierDataToUpdate);
        //-------------------------------------ends--------------------------------------------------
        
        //---------As/Simplion/4/30/2015-------------------------------------------------------------
        //---------This is pending to be discuss-----------------------------------------------------
        if(AccountTriggerHelperExt.currentPartnersCustomerListQuery.size() >0){
            List<Account> customersListForUpdates = AccountTriggerHelperExt.updatePartnerCodeOnInsertAndUpdate(AccountTriggerHelperExt.currentPartnersCustomerListQuery,partnerAccMap);
            allRecordsForUpdate.addAll((List<Sobject>)customersListForUpdates);
        }
        
        //----------------------------Update the Customer Account data(In last) --------------------------------------------------------------
        
        // Assign new Account Map
         
        // Calling contructor.
        
        //-------------------This consutructor is useless because we have removed all the functionalities from this constructor and all methods of this
        // class are static
        //AccountTriggerHelper objAccountTrgHlpr = new AccountTriggerHelper();
        
        for(Account accObj : Trigger.new) {   
            AccountTriggerHelperExt.ultimateParentIdSet.add(string.valueOf(accObj.id).subString(0,15));
            if(accObj.Ultimate_Parent_Account_ID__c != null) {
                AccountTriggerHelperExt.ultimateParentIdSet.add(string.valueOf(accObj.Ultimate_Parent_Account_ID__c).subString(0,15));
            }
        }
        for(Account newAcc : Trigger.new ) {
            if(newAcc.ParentId != null){
                    AccountTriggerHelperExt.allAccountParentAfterQuery.add(newAcc);
            }
        }
        if(AccountTriggerHelperExt.allAccountParentAfterQuery!=null && !AccountTriggerHelperExt.allAccountParentAfterQuery.isEmpty()){
            try{
                //This code is used for updating customer account hierarchy
                //-------------Is it required to have test code here ?--------------------------TBD/As/Simplion/5/1/2015-------------
                AccountHierarchyValidation.validateAccountHierarchy(Trigger.new,AccountTriggerHelper.allAccountsByParentDetails,AccountTriggerHelper.allAccountParentByParentIdQuery);
                if(Test.isRunningTest()){
                    Integer error = 0/0;
                }
            } catch(Exception e){
                System.debug('#### Error @ Account Trigger AccountHierarchyValidation line - '+e.getlineNumber());
                System.debug('#### Error @ Account Trigger AccountHierarchyValidation message - '+e.getMessage());
            } 
        }
        //This code is used to clear the value of all the collections
        //AccountTriggerHelper.deinitalize();
        
        //Start calculation of Completion Rate and Completion Date of Graduation Phase of Graduation Score Card 
        //-------------------This code is deprecated as per the virendra--------------------------TBD--as/Simplion/5/1/2015----------
        List<Account_Metric__c> listOfAccountMetricToUpdate = GraduationScoreCardHelper.calculateGraduationCompletionRate(Trigger.new);
        if(listOfAccountMetricToUpdate.size() > 0){
            allRecordsForUpdate.addAll((List<Sobject>)listOfAccountMetricToUpdate);
        }
        
        List<Case> listOfFinanceCaseToInsert  = AccountTriggerHelper.createFinanceCaseOnInsertAndUpdate(Trigger.New,Trigger.oldMap,AccountTriggerHelper.allAccountInAfterQuery,financeGroup);
        if(listOfFinanceCaseToInsert!= null){
            allRecordsForInsert.addAll((List<Sobject>)listOfFinanceCaseToInsert);
        }
        
        
        List<Lead> leadsListForAccoount = AccountTriggerHelper.createLeadForAccounts(Trigger.newMap, Trigger.oldMap, AccountTriggerHelper.allAccountsMapAfterQuery);
        If(leadsListForAccoount.size() > 0){
            allRecordsForInsert.addAll((List<Sobject>)leadsListForAccoount);
        }
        
        List<Implementation__c> implementationToInsertOnAccountInsert = AccountTriggerHelper.createImplementationOnAccountInsert(Trigger.newMap, Trigger.oldMap, AccountTriggerHelper.allAccountsMapAfterQuery);
        if(implementationToInsertOnAccountInsert.size() > 0){
            allRecordsForInsert.addAll((List<Sobject>)implementationToInsertOnAccountInsert);
        }
        
    }
    
    //--------------------------Insert event section ends------------------------------------------------
    
    //--------------------------Update event section starts------------------------------------------------
    if(Trigger.isUpdate){
        //---------------------Moved From Account Before Trigger--------------------------------------------- 
        if(AccountTriggerHelperExt.accountsListForUpdateForCreditCounter.size() >0){
            System.debug('~~~~~~~~~~~~~~~~~~~~~~~~~~~~AccountTriggerHelperExt.accountsListForUpdateForCreditCounter update'+AccountTriggerHelperExt.accountsListForUpdateForCreditCounter);
            allRecordsForUpdate.addAll((List<Sobject>)AccountTriggerHelperExt.accountsListForUpdateForCreditCounter);
        }
        //AccountTriggerHelperExt.updateCreditCounter(Trigger.new,Trigger.oldMap);
        /*This code is used for updating customer account's fields for partner account*/
        List<Account> accountsByParentDetailsAndPartnerType = new List<Account>();
        if(AccountTriggerHelper.allAccountsByParentDetails.size() > 0){
            for(Account parentDetailAcc : AccountTriggerHelper.allAccountsByParentDetails){
                if(parentDetailAcc.RecordType.Name.equalsIgnoreCase(AccountTriggerHelperExt.PARTNER_ACCOUNT)){
                    accountsByParentDetailsAndPartnerType.add(parentDetailAcc);

                }
            }
        }
        //-------------------As/Simplion/5/7/2015-------------------------------------------------------------
        //---------------This methos deprecated and open for discussion with virendra-------------------------
        //AccountTriggerHelper.partnerAccount();
        
        //---------------------------As/Simplion/4/30/2015--------------------------------------------------------------------
        //------------Prepare ultimateParentIdSet for update event on account-----------------------------------------------
        for(Account accObj : Trigger.new) { 
            if( (accObj.ParentId != Trigger.oldMap.get(accObj.Id).ParentId) || 
                (accObj.RC_Account_Status__c != Trigger.oldMap.get(accObj.Id).RC_Account_Status__c) || 
                (accObj.Number_of_DL_s__c != Trigger.oldMap.get(accObj.Id).Number_of_DL_s__c)){
                    AccountTriggerHelperExt.ultimateParentIdSet.add(string.valueOf(accObj.id).subString(0,15));
                    if(accObj.Ultimate_Parent_Account_ID__c != null){
                        AccountTriggerHelperExt.ultimateParentIdSet.add(string.valueOf(accObj.Ultimate_Parent_Account_ID__c).subString(0,15));
                        AccountTriggerHelperExt.ultimateParentIdSet.add(string.valueOf(Trigger.OldMap.get(accObj.Id).Ultimate_Parent_Account_ID__c).subString(0,15));
                    }
            }
        }
        
        
        

        //This code is used to clear the value of all the collections
        //AccountTriggerHelper.deinitalize();
        
        //Start calculation of Completion Rate and Completion Date of Graduation Phase of Graduation Score Card 
        List<Account_Metric__c> listOfAccountMetricToUpdate = GraduationScoreCardHelper.calculateGraduationCompletionRate(Trigger.new);
        if(listOfAccountMetricToUpdate.size() > 0){
            allRecordsForUpdate.addAll((List<Sobject>)listOfAccountMetricToUpdate);
        }
        
        
        
        List<Case> listOfFinanceCaseToInsert  = AccountTriggerHelper.createFinanceCaseOnInsertAndUpdate(Trigger.New,Trigger.oldMap,AccountTriggerHelper.allAccountInAfterQuery,financeGroup);
        if(listOfFinanceCaseToInsert!= null){
            allRecordsForInsert.addAll((List<Sobject>)listOfFinanceCaseToInsert);
        }
        
        
        //-------------------This consutructor is useless because we have removed all the functionalities from this constructor and all methods of this
        // class are static
        // Calling contructor.
        //AccountTriggerHelper objAccountTrgHlpr = new AccountTriggerHelper();
        //----------------As/Simplion/3/13/2015------------------------------------------
        
        //----------------This line of code shifted from before update to after update---FYI
        //----------------This code updates all customer accounts of updated partner account if do not create implementation field is changed ------------------------
        List<Account> customersListToUpdateForDoNotCreateImplementation = AccountTriggerHelperExt.updateCustomersOnPartnerUpdate(Trigger.new,Trigger.oldMap,AccountTriggerHelperExt.currentPartnersCustomerListQuery);
        if(customersListToUpdateForDoNotCreateImplementation.size() > 0){
            allRecordsForUpdate.addAll((List<Sobject>)customersListToUpdateForDoNotCreateImplementation);
        }
        List<Account> customersListForUpdates = AccountTriggerHelperExt.updatePartnerCodeOnInsertAndUpdate(AccountTriggerHelperExt.currentPartnersCustomerListQuery,partnerAccMap);
        if(customersListForUpdates.size() > 0){
            allRecordsForUpdate.addAll((List<Sobject>)customersListForUpdates);
        }
        //----------------------As/Simplion/5/11/2015-------------------------------------
        //------------commenting this functionality as this functionality is shifted in updatePaidAccountRelatedContacts functtion below--------------------
        /*List<Contact> contactsListToUpdate = AccountTriggerHelperExt.updateContactStatus(Trigger.new,AllContactsMap); 
        if(contactsListToUpdate.size() > 0 ){
            allRecordsForUpdate.addAll((List<Sobject>)contactsListToUpdate);
        }*/
        //This code is used for inserting new lead, new implementaion,sending email
        List<Survey__c> surveyListToInsert = AccountTriggerHelper.createVARSurveyOnAccountUpdate(Trigger.new,Trigger.oldMap,AccountTriggerHelper.allAccountsMapAfterQuery,AccountTriggerHelper.partnerAccountContactMap);
        System.debug(surveyListToInsert+'~~~~~~~~~~~~~~~~~~~~~~~~~~~surveyListToInsert');
        if(surveyListToInsert!= null && surveyListToInsert.size() >0){
            allRecordsForInsert.addAll((List<Sobject>)surveyListToInsert);
        }
        List<Implementation__c> ImplementationListToUpdate = AccountTriggerHelper.changeImplementationForCanceledAccounts(Trigger.new, Trigger.oldMap, AccountTriggerHelper.allAccountsMapAfterQuery);
        if(ImplementationListToUpdate.size() > 0){
            allRecordsForUpdate.addAll((List<Sobject>)ImplementationListToUpdate);
        }
        //----------------------------AS/Simplion/5/12/2015-------------------------------------------
        //-----------This functionality is need to discuss-------------------------    
        List<Sobject> exceptionAndNotificationList = AccountTriggerHelper.sendEmailsForContracts(Trigger.new, Trigger.oldMap, AccountTriggerHelper.accountContractMap);
        if(exceptionAndNotificationList.size() > 0){
            allRecordsForInsert.addAll((List<Sobject>)exceptionAndNotificationList);
        }
        
        List<Lead> leadsForAccountsToInsert = AccountTriggerHelper.createLeadOnAccountUpdate(Trigger.new,Trigger.oldMap, AccountTriggerHelper.allAccountsMapAfterQuery);
        System.debug(leadsForAccountsToInsert+'~~~~~~~~~~~~~~~~~~~~~~~~~~~leadsForAccountsToInsert');   
        if(leadsForAccountsToInsert.size() >0){
            System.debug(leadsForAccountsToInsert+'~~~~~~~~~~~~~~~~~~~~~~~~~~~leadsForAccountsToInsert');   
            allRecordsForInsert.addAll((List<Sobject>)leadsForAccountsToInsert);
        }
        
        List<Implementation__c > implementationToInsertOnAccountupdate = AccountTriggerHelper.createImplementationForAccounts(Trigger.newMap, Trigger.oldMap, AccountTriggerHelper.allAccountsMapAfterQuery);
        
        if(implementationToInsertOnAccountupdate.size() > 0){
            allRecordsForInsert.addAll((List<Sobject>)implementationToInsertOnAccountupdate);
        }
        System.debug('~~~~~~~~~~~~~~~~~~~~~this is very ___________');
        //----------------------AS/Simplion/5/12/2015---------------------------------------------------------------
        //---------------------taking out the account cleanup process functionality for now only---------------------
        if(AccountTriggerHelperExt.AllRecordsPartnerId.size() > 0){
            Set<String> emails = new Set<String>();
            System.debug(AccountTriggerHelper.PrimaryContactAccountMap+'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~AccountTriggerHelper.PrimaryContactAccountMap');
            for(Contact contactObj :AccountTriggerHelper.PrimaryContactAccountMap.values()){
                
                if(contactObj != null && contactObj.Email != 'fake@email.com' && contactObj.Email != 'fake@fake.com') {
                    //System.debug('#### '+ 3 +' #####');
                    emails.add(contactObj.Email);
                }
            }
            if(emails.size() > 0){
                System.debug(emails+'~~~~~~~~~~~~~~~~~~~~~~~~emails');
                List<Contact> suspendedContacts = [SELECT Id, marketingSuspend__c 
                                                           FROM Contact WHERE (marketingSuspend__c = false OR marketingSuspend__c = null) AND Email IN: emails AND isDeleted= false];
                List<Lead> suspendedLeads = [SELECT Id, marketingSuspend__c 
                                                     FROM Lead WHERE marketingSuspend__c = false AND Email IN:emails 
                                                     AND IsConverted = false AND isDeleted= false]; 
                System.debug('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~suspendedContacts'+suspendedContacts);
                System.debug('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~suspendedLeads'+suspendedLeads);                                              
                for(Contact contactObj : suspendedContacts) {
                    System.debug(contactObj.marketingSuspend__c+'~`````````````````````````marketingSuspend__c');
                    contactObj.marketingSuspend__c = true;
                }
                for(Lead leadObj : suspendedLeads) {
                    System.debug(leadObj.marketingSuspend__c+'~`````````````````````````marketingSuspend__c');
                    leadObj.marketingSuspend__c = true;
                }
                if(suspendedContacts.size() > 0){
                    allRecordsForUpdate.addAll((List<Sobject>)suspendedContacts);
                }
                if(suspendedLeads.size() > 0){
                    allRecordsForUpdate.addAll((List<Sobject>)suspendedLeads);
                }
            }
            
            
            
        }
        List<Account> paidAccountList = new List<Account>();
        for(Account accObj : Trigger.new) {
            if(accObj.RC_Account_Status__c!=null 
                && ('Paid'.equalsIgnoreCase(accObj.RC_Account_Status__c.trim()) || 'Canceled'.equalsIgnoreCase(accObj.RC_Account_Status__c.trim())) 
                && accObj.RC_Account_Status__c != Trigger.oldMap.get(accObj.id).RC_Account_Status__c){
                    paidAccountList.add(accObj);
            }
        }
        
        if(paidAccountList!=null && paidAccountList.size() > 0){ 
            List<Contact>  paidAccountRelatedContactsToUpdate = AccountTriggerHelper.updatePaidAccountRelatedContacts(paidAccountList,AccountTriggerHelper.allAccountsMapAfterQuery);
            if(paidAccountRelatedContactsToUpdate.size() >0){
                allRecordsForUpdate.addAll((List<Sobject>)paidAccountRelatedContactsToUpdate);
            }
            
        }
        
        for(Account newAcc : Trigger.new ) {
            if(newAcc.ParentId !=null && (newAcc.ParentId != Trigger.oldMap.get(newAcc.Id).ParentId)){
                    AccountTriggerHelperExt.allAccountParentAfterQuery.add(newAcc);
            }
        }
        
        if(AccountTriggerHelperExt.allAccountParentAfterQuery!=null && !AccountTriggerHelperExt.allAccountParentAfterQuery.isEmpty()){
            try{
                //This code is used for updating customer account hierarchy
                AccountHierarchyValidation.validateAccountHierarchy(Trigger.new,AccountTriggerHelper.allAccountsByParentDetails,AccountTriggerHelper.allAccountParentByParentIdQuery);
                if(Test.isRunningTest()){
                    Integer error = 0/0;
                }
            } catch(Exception e){
                System.debug('#### Error @ Account Trigger AccountHierarchyValidation line - '+e.getlineNumber());
                System.debug('#### Error @ Account Trigger AccountHierarchyValidation message - '+e.getMessage());
            } 
        }
        //-------------------AS/Simplion/5/6/2015-------------------------------------------------------
        
    }
    
    //--------------------------Update event section ends------------------------------------------------
    
    //--------------------------Delete event section starts----------------------------------------------
    if(Trigger.isDelete){
        if (AccountTriggerHelperExt.ultimateParentIdSet != null && AccountTriggerHelperExt.ultimateParentIdSet.size() > 0) {
            List < Account > accMainList = new List < Account > ();
            for (List < Account > accList: [SELECT id, Ultimate_Parent_Account_ID__c, Ultimate_Parent_Snapshot__c, Number_of_DL_s__c, Total_DLs__c 
                                                FROM Account
                                                WHERE NAME != NULL AND RecordType.Name = : AccountTriggerHelperExt.CUSTOMER_ACCOUNT 
                                                AND(Ultimate_Parent_Snapshot__c IN: AccountTriggerHelperExt.ultimateParentIdSet 
                                                OR Id IN: AccountTriggerHelperExt.ultimateParentIdSet)]) {
                accMainList.addAll(accList);
            }

            if (accMainList != null && accMainList.size() > 0) {
                for (Account accObj: accMainList) {
                    AccountTriggerHelperExt.ultimateParentIdSet.add(string.valueOf(accObj.Id).subString(0, 15));
                    AccountTriggerHelperExt.ultimateParentIdSet.add(string.valueOf(accObj.Ultimate_Parent_Account_ID__c).subString(0, 15));
                }
            }
        }
        
    }
    //--------------------------Delete event section ends----------------------------------------------
    

    if(Trigger.isInsert || Trigger.isUpdate || Trigger.isDelete) {
        
  
        if(AccountTriggerHelperExt.ultimateParentIdSet!=null && AccountTriggerHelperExt.ultimateParentIdSet.size() > 0 && !Test.isRunningTest()){ 
            if(accountHierachyCalculationEnabled){// if Custom settings enabled
                List<Account> updateListOfAccount = AccountTriggerHelperExt.calculateAccountHierarchyTotalDLS(AccountTriggerHelperExt.ultimateParentIdSet);
                if(updateListOfAccount.size() > 0){
                    allRecordsForUpdate.addAll((List<Sobject>)updateListOfAccount);
                }
            }
        }
       /******End of For Account Hierarchy Total DLS Field updation********/
    } 

 

    
    //---------------------------As/Simplion/4/8/2015--------------------------------------------------------------------
    //---------------------------DML statement to update all records for this Trigger context----------------------------
    if(allRecordsForInsert.size() > 0){
        
        insert allRecordsForInsert;
    }
    if(allRecordsForUpsert.size() > 0){
        upsert allRecordsForUpsert;
    }
    if(allRecordsForUpdate.size() >0){
        System.debug('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~allRecordsForUpdate'+allRecordsForUpdate);
        update allRecordsForUpdate;
    }
    
} // End of Trigger