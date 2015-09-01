/**
 * Class AccountHandler
 *
 * Trigger Handler for the Account SObject. This class implements the ITrigger
 * interface to help ensure the trigger code is bulkified and all in one place.
 */
public with sharing class AccountHandler implements TriggerInterface {
    Map < Id, Account > newMap;
    List < Account > newList;
    Map < Id, Account > oldMap;
    list < Account > oldList;
    //--------non static variables-----
    Map < String, Account > mapPartnerIdToAccount = new Map < String, Account > ();
    Map < Id, Integer > counterToPartnerAccount = new Map < Id, Integer > ();
    Map < String, String > serviceAndTypeMap = new Map < String, String > {
        'FAX' => 'Fax',
        'PROFESSIONAL' => 'Professional',
        'OFFICE' => 'Office'
    };

    Map < Id, Contact > AllContactsMap = new Map < Id, Contact > ();
    Group financeGroup;
    List < SObject > allRecordsForUpdate = new List < SObject > ();
    List < Sobject > allRecordsForInsert = new List < Sobject > ();
    List < Sobject > allRecordsForUpsert = new List < Sobject > ();
    List < Sobject > allRecordsForDelete = new List < Sobject > ();
    List < Account > allHeirarchyAccountList = new List<Account>();
    Boolean accountHierachyCalculationEnabled = (AccountHierarchyCustomSetting__c.getInstance('AccountHierarchyInstance') != null && AccountHierarchyCustomSetting__c.getInstance('AccountHierarchyInstance').HierarchyCalculationEnabled__c) ? true : false;




    //-------static variables---------
 
    // Constructor
    public AccountHandler() {}

    /**
     * bulkBefore
     *
     * This method is called prior to execution of a BEFORE trigger. Use this to cache
     * any data required into maps prior execution of the trigger.
     */
    public void bulkBefore() {
        newMap = (Map < id, Account > ) Trigger.newMap;
        oldMap = (Map < id, Account > ) Trigger.oldMap;
        newList = (List < Account > ) Trigger.new;
        oldList = (List < Account > ) Trigger.old;
        // If this a delete trigger Cache a list of Account Id's that are 'in use'
        if (Trigger.isDelete) {


        } else {

            AccountTriggerStaticProperties.userIds = AccountGateway.prepareUserIdSet(newList);
            for (Account accountObj: newList) {
                if (!String.isBlank(accountObj.Partner_ID__c)) {
                    AccountTriggerStaticProperties.AllRecordsPartnerId.add(accountObj.Partner_ID__c);
                }
                if (!String.isBlank(accountObj.Partner_ID__c) && AccountTriggerStaticProperties.accountRecordTypeMapById != null && accountObj.RecordTypeId != null && AccountTriggerStaticProperties.accountRecordTypeMapById.get(accountObj.RecordTypeId).getName() == AccountTriggerStaticProperties.CUSTOMER_ACCOUNT) {
                    AccountTriggerStaticProperties.partnerAndCustomerMap.put(accountObj.Partner_ID__c, accountObj);

                }
                if (!String.isBlank(accountObj.Partner_ID__c) && AccountTriggerStaticProperties.accountRecordTypeMapById != null && accountObj.RecordTypeId != null && AccountTriggerStaticProperties.accountRecordTypeMapById.get(accountObj.RecordTypeId).getName() == AccountTriggerStaticProperties.PARTNER_ACCOUNT) {
                    AccountTriggerStaticProperties.partnerAccountMap.put(accountObj.Partner_ID__c, accountObj);

                }
            }
            System.debug('AllRecordsPartnerId: '+AccountTriggerStaticProperties.AllRecordsPartnerId);
            if (AccountTriggerStaticProperties.AllRecordsPartnerId.size() > 0) {
                AccountTriggerStaticProperties.currentCustomersPartnersListQuery = [SELECT Id, Name, Most_Recent_Implementation_Contact__c,Ultimate_Parent_Account_ID__c, Current_Owner_Email__c, Current_Owner_Name__c, 
                                                                                    Ultimate_Parent_Account_Name__c, Partner_ID__c, Do_Not_Creation_Implementation__c,Ultimate_Parent_Partner_ID__c, Ultimate_Partner_ID__c,
                                                                                    Ultimate_Partner_Name__c, Current_Owner__c,Eligible_for_Refferel_Credit__c, Pay_Referral_Commissions__c, Partner_Sign_Up_Date__c, 
                                                                                    RC_Signup_Date__c,Partner_Customer_Count__c,
                                                                                    (SELECT Id, AccountId, ContactId, Role, IsPrimary, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, IsDeleted 
                                                                                        From AccountContactRoles 
                                                                                        where isPrimary = true)
                                                                                    FROM Account
                                                                                    WHERE Partner_ID__c IN: AccountTriggerStaticProperties.AllRecordsPartnerId and RecordType.Name = : AccountTriggerStaticProperties.PARTNER_ACCOUNT];
            }
            System.debug('currentCustomersPartnersListQuery: '+AccountTriggerStaticProperties.currentCustomersPartnersListQuery);
            if (!AccountTriggerStaticProperties.currentCustomersPartnersListQuery.isEmpty()) {
                for (Account accountObj: AccountTriggerStaticProperties.currentCustomersPartnersListQuery) {
                    mapPartnerIdToAccount.put(accountObj.Partner_ID__c, accountObj);
                    Integer initialCounter = accountObj.Partner_Customer_Count__c != null ? Integer.valueOf(accountObj.Partner_Customer_Count__c) : 0;
                    counterToPartnerAccount.put(accountObj.Id, initialCounter);
                }
            }

            if (Trigger.isUpdate) {
                AccountTriggerStaticProperties.allUpdatedAccountMapQuery = new Map <Id,Account>([SELECT Id, Name, Most_Recent_Implementation_Contact__c, Preferred_Language__c,Ultimate_Parent_Account_ID__c, Current_Owner_Email__c,
                                                                                                    Current_Owner_Name__c,Ultimate_Parent_Account_Name__c, Partner_ID__c, Do_Not_Creation_Implementation__c,Ultimate_Parent_Partner_ID__c, 
                                                                                                    Ultimate_Partner_ID__c,Ultimate_Partner_Name__c, Current_Owner__c,Eligible_for_Refferel_Credit__c, Pay_Referral_Commissions__c, 
                                                                                                    Partner_Sign_Up_Date__c, RC_Signup_Date__c,Partner_Customer_Count__c,
                                                                                                    (SELECT Id, name, email, Preferred_Language__c 
                                                                                                        FROM Contacts order By LastModifiedDate DESC),
                                                                                                    (SELECT Id, AccountId, ContactId, Role,IsPrimary, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, IsDeleted, contact.Preferred_Language__c 
                                                                                                        From AccountContactRoles 
                                                                                                        WHERE isPrimary = true)
                                                                                                    FROM Account
                                                                                                    WHERE Id IN: trigger.newMap.keyset()]);
            }

        }

    }

    public void bulkAfter() {
        newMap = (Map < id, Account > ) Trigger.newMap;
        oldMap = (Map < id, Account > ) Trigger.oldMap;
        newList = (List < Account > ) Trigger.new;
        oldList = (List < Account > ) Trigger.old;
        
        
        //---------------------Moved From Account Before Trigger--------------------------------------------- 
        //-------------This property is being set from account Before trigger function------------------
        if (Trigger.isDelete) {
            
            }else{
            System.debug(' after partnerAccountMap: '+AccountTriggerStaticProperties.partnerAccountMap);    
            if (AccountTriggerStaticProperties.partnerAccountMap.size() > 0) {
                AccountTriggerStaticProperties.currentPartnersCustomerListQuery = [SELECT id, Current_Owner__c, Partner_ID__c, Do_Not_Creation_Implementation__c 
                                                                                    FROM Account WHERE Partner_ID__c IN: AccountTriggerStaticProperties.partnerAccountMap.keySet()
                                                                                    AND RecordType.Name = : AccountTriggerStaticProperties.CUSTOMER_ACCOUNT];
    
            }
            if (AccountTriggerStaticProperties.AllRecordsPartnerId.size() > 0) {
                AccountTriggerStaticProperties.currentCustomersPartnersListInAfterQuery = [SELECT Id, Name, Most_Recent_Implementation_Contact__c,Ultimate_Parent_Account_ID__c, Current_Owner_Email__c, Current_Owner_Name__c, 
                                                                                            Ultimate_Parent_Account_Name__c, Partner_ID__c, Do_Not_Creation_Implementation__c,Ultimate_Parent_Partner_ID__c, Ultimate_Partner_ID__c, 
                                                                                            Ultimate_Partner_Name__c, Current_Owner__c,Eligible_for_Refferel_Credit__c, Pay_Referral_Commissions__c, Partner_Sign_Up_Date__c, 
                                                                                            RC_Signup_Date__c,Partner_Customer_Count__c, 
                                                                                            (SELECT Id, AccountId, ContactId, Role, IsPrimary, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, IsDeleted 
                                                                                                FROM AccountContactRoles 
                                                                                                WHERE isPrimary = true), 
                                                                                            (SELECT Id, name, email, Preferred_Language__c 
                                                                                                FROM contacts order By LastModifiedDate DESC)FROM Account
                                                                                            WHERE Partner_ID__c IN: AccountTriggerStaticProperties.AllRecordsPartnerId and RecordType.Name = : AccountTriggerStaticProperties.PARTNER_ACCOUNT];
            }
            //----------------------Creating a map of all partner accounts with there partner Id as key.
    
            for (Account accObj: AccountTriggerStaticProperties.currentCustomersPartnersListInAfterQuery) {
                AccountTriggerStaticProperties.partnerAccountContactMap.put(accObj.Partner_ID__c, accObj);
            }
            Set < String > closedStagesSet = new Set < String > ();
            // Old Stages
            closedStagesSet.add('4. Closed');
            closedStagesSet.add('8. Closed Won');
            //New Stages
            closedStagesSet.add('7. Closed Won');
    
            Set < String > caseTypeSetForQuery = new Set < String > {
                'Finance', 'Support - T3'
            };
            AccountTriggerStaticProperties.allAccountInAfterQuery = [SELECT Id, No_of_Employees__c, RC_Brand__c, RC_Service_name__c, RC_Tier__c, RC_User_ID__c, Account_Graduation_Date_0_30__c, Graduation_Kit__c,
                                                                        Account_Graduation_Date_61_90__c, Name,Account_Graduation_Date_31_60__c, Implementation_Phase_Completion_Rate__c, Adoption_Phase_Completion_Rate__c,
                                                                        Graduation_Phase_Completion_Rate__c, Most_Recent_Implementation_Contact__c, Preferred_Language__c, RC_Account_Status__c, RC_Account_Number__c,
                                                                        Owner.Email, Owner.Name, Owner.Team__c, Owner.Manager.Name, Owner.Manager.Email, CreatedBy.username,CreatedBy.Name,Ultimate_Parent_Account_ID__c, Current_Owner_Email__c, 
                                                                        Current_Owner_Name__c, Ultimate_Parent_Account_Name__c, Partner_ID__c, Do_Not_Creation_Implementation__c,Ultimate_Parent_Partner_ID__c, Ultimate_Partner_ID__c, 
                                                                        Ultimate_Partner_Name__c, Current_Owner__c,Eligible_for_Refferel_Credit__c, Pay_Referral_Commissions__c, Partner_Sign_Up_Date__c, RC_Signup_Date__c,Partner_Customer_Count__c, 
                                                                        (Select Id, Account.Name, Contact.Email, Contact.phone,Contact.Account.No_of_Employees__c, Contact.FirstName, Contact.LastName, Contact.NumberOfEmployees__c,
                                                                            IsPrimary, Account.No_of_Employees__c, AccountId, ContactId, Role, CreatedDate, CreatedById, LastModifiedDate,LastModifiedById, SystemModstamp, IsDeleted 
                                                                            From AccountContactRoles 
                                                                            where isPrimary = true),
                                                                        (SELECT Id 
                                                                            FROM Surveys__r 
                                                                            WHERE SurveyType__c = 'VAR Customer' limit 1),
                                                                        (SELECT Id, accountId, FirstName, LastName, Email, NumberOfEmployees__c, Preferred_Language__c, Contact_Status__c,Contact_Funnel_Type__c, Phone, Account.Name,
                                                                            Account.No_of_Employees__c, isCustomer__c, People_Segment__c 
                                                                            FROM Contacts Order by LastModifiedDate DESC),
                                                                        (Select Id, Is_Premium_Implementation_Required__c 
                                                                            From Opportunities
                                                                            WHERE Is_Premium_Implementation_Required__c = true AND StageName IN: closedStagesSet AND RecordType.Name = : AccountTriggerStaticProperties.SALES_OPPORTUNITY),
                                                                        (SELECT Id, RecordType.Name, Status 
                                                                            FROM Cases 
                                                                            WHERE RecordType.Name IN: caseTypeSetForQuery ORDER BY CreatedDate DESC),
                                                                        (SELECT Id, Name, Type, AccountId, SlaProcessId, StartDate, Status, BusinessHoursId 
                                                                            FROM Entitlements), 
                                                                        (Select Id, Account_Graduation_Status__c, Account__c, Implementation_Status__c, Implementation_Status_2__c, Implementation_Type__c 
                                                                            FROM Implementations__r ORDER BY CreatedDate DESC), 
                                                                        (SELECT Id, OwnerId, Owner.Email, AccountId 
                                                                            FROM Contracts), 
                                                                        (Select Account_ID__c, Metric_3_value__c, Metric_11_value__c, Metric_18_value__c, Adoption_Phase_Completion_Rate__c,Account_Graduation_Date_31_60__c,
                                                                             Account_Graduation_Date_61_90__c,Graduation_Phase_Completion_Rate__c, Account_Graduation_Status__c,Metric_23_value__c, Metric_27_value__c, 
                                                                             Metric_28_value__c 
                                                                             From Account_Metrics__r order by LastModifiedDate DESC limit 1)
                                                                        FROM Account
                                                                        WHERE Id IN: newMap.keyset()];
            //-----------------As/Simplion/4/7/2015-----------------------------------------------------------------------------------
            //-----------------This functionality is shifted from AccountTriggerHealper Class Constructor and modified and corrected------------------                                                      
            Map < Id, List < AccountContactRole >> accountContactRoleMap = new Map < Id, List < AccountContactRole >> ();
    
            Set < String > partnerAccountIdSet15Digit = new set < String > ();
            set < String > allAccountParentIdSet = new Set < String > ();
    
    
            for (Account accountFrmQuery: AccountTriggerStaticProperties.allAccountInAfterQuery) {
    
                //--------------creating a list of Entiltelments ------------------------
                if (accountFrmQuery.Entitlements != null && accountFrmQuery.Entitlements.size() > 0) {
                    AccountTriggerStaticProperties.EntitlementsList.addAll(accountFrmQuery.Entitlements);
                }
                AccountTriggerStaticProperties.accountContractMap.put(accountFrmQuery.Id, accountFrmQuery.contracts);
                AccountTriggerStaticProperties.allAccountsMapAfterQuery.put(accountFrmQuery.Id, accountFrmQuery);
                //------------This map contains all related opportunities count with account Id as a key
    
                AccountTriggerStaticProperties.premiumImpAccMap.put(accountFrmQuery.id, accountFrmQuery.Opportunities != null ? accountFrmQuery.Opportunities.size() : 0);
                //------------This Map will conatain all contacts with respect of Account Id as key
                AccountTriggerStaticProperties.AllAccountContactMapQuery.put(accountFrmQuery.Id, accountFrmQuery.contacts);
                //------------This Map will contain all AccountContactRoles with respect of Account id as key
                accountContactRoleMap.put(accountFrmQuery.Id, accountFrmQuery.AccountContactRoles);
                System.debug ('Contacts ::'+accountFrmQuery);
                System.debug ('Contacts list::'+accountFrmQuery.contacts);
                for (Contact cont: accountFrmQuery.contacts) {
                    //----------------This map contains all contacts of all accounts with respect to there contact id itself as a key
                    AllContactsMap.put(cont.Id, cont);
                }
    
    
            }
            System.debug('AccountTriggerStaticProperties.allAccountInAfterQuery.size()::'+AccountTriggerStaticProperties.allAccountInAfterQuery.size());
            for (Account newAccount: newList) {
                System.debug('Does is reach here'+newAccount.name);
                if (newAccount.ParentId != null) {
                    System.debug('parent id no null::'+newAccount.ParentId );
                    partnerAccountIdSet15Digit.add('%' + string.valueOf(newAccount.Id).substring(0, 15) + '%');
                    allAccountParentIdSet.add(newAccount.ParentId);
                }
            }
            System.debug('partnerAccountIdSet15Digit>>'+partnerAccountIdSet15Digit.size());
            System.debug('allAccountParentIdSet>>'+allAccountParentIdSet.size());
            if (partnerAccountIdSet15Digit.size() > 0) {
                AccountTriggerStaticProperties.allAccountsByParentDetails = [SELECT id, Name, Parent_Detail__c, Partner_ID__c, Do_Not_Creation_Implementation__c, Ultimate_Parent_Partner_ID__c,
                                                                                Ultimate_Partner_ID__c, Ultimate_Partner_Name__c, Ultimate_Parent_Account_ID__c, Ultimate_Parent_Account_Name__c,
                                                                                Current_Owner__c, Current_Owner_Email__c, Current_Owner_Name__c, Account_Depth__c, parentId, RecordType.Name
                                                                                FROM Account 
                                                                                WHERE parentId != null AND Parent_Detail__c != null AND Parent_Detail__c like: partnerAccountIdSet15Digit];
            }
            if (allAccountParentIdSet.size() > 0) {
                AccountTriggerStaticProperties.allAccountParentByParentIdQuery = new Map < ID, Account > ([SELECT id, Parent_Detail__c, Account_Depth__c 
                                                                                                            FROM Account 
                                                                                                            WHERE ID IN: allAccountParentIdSet]);
            }
    
    
            //------------------As/Simplion/4/30/2015---------------------------------------------------------
            //------------------Optimization required---------------------------------------------------------
            for (Account accountFrmQuery: AccountTriggerStaticProperties.allAccountInAfterQuery) {
                Contact mostRecentCont;
                if (accountFrmQuery.contacts.size() > 0) {
                    mostRecentCont = accountFrmQuery.contacts[0];
                    if (mostRecentCont != null) {
    
                    }
                } else {
                    mostRecentCont = null;
    
                }
                if (accountContactRoleMap.get(accountFrmQuery.Id) != null && accountContactRoleMap.get(accountFrmQuery.Id).size() > 0) {
                    AccountTriggerStaticProperties.PrimaryContactAccountMap.put(accountFrmQuery.Id, AllContactsMap.get(accountContactRoleMap.get(accountFrmQuery.Id)[0].contactId));
                } else {
                    AccountTriggerStaticProperties.PrimaryContactAccountMap.put(accountFrmQuery.Id, mostRecentCont);
                }
            }
    
            financeGroup = [SELECT Id 
                            FROM Group 
                            WHERE Name = 'Finance Queue' AND Type = 'Queue' limit 1];
        }                       

    }

    public void beforeInsert(SObject so) {
        Account acc = (Account) so;
        AccountGateway.setAccountValues(acc, AccountTriggerStaticProperties.allUserMap);
        AccountGateway.accountSharingOnInsert(acc, mapPartnerIdToAccount);
        AccountGateway.setEligibalForReferealCredit(acc, mapPartnerIdToAccount, counterToPartnerAccount);
        AccountGateway.setServiceType(acc, serviceAndTypeMap);

    }

    public void beforeUpdate(SObject oldSo, SObject so) {
        Account acc = (Account) so;
        AccountGateway.setAccountValuesOnUpdate(acc, (Account) oldSo, mapPartnerIdToAccount);
        AccountGateway.updateEligibalForReferealCredit(acc, (Account) oldSo, mapPartnerIdToAccount, counterToPartnerAccount);
        AccountGateway.updateMostRecentImplementationContact(acc, AccountTriggerStaticProperties.allUpdatedAccountMapQuery.get(acc.Id));
        AccountGateway.setServiceType(acc, serviceAndTypeMap);
    }

    /**
     * beforeDelete
     *
     * This method is called iteratively for each record to be deleted during a BEFORE
     * trigger.
     */
    public void beforeDelete(SObject so) {
        Account accObj = (Account) so;
        if (accObj.RC_Account_Status__c == 'Paid' || string.valueOf(accObj.Ultimate_Parent_Account_ID__c).subString(0, 15) == string.valueOf(accObj.id).subString(0, 15)) {
            if (string.valueOf(accObj.Id).subString(0, 15) != string.valueOf(accObj.Ultimate_Parent_Account_ID__c).subString(0, 15)) {
                AccountTriggerStaticProperties.ultimateParentIdSet.add(string.valueOf(accObj.Ultimate_Parent_Account_ID__c).subString(0, 15));
                AccountTriggerStaticProperties.ultimateParentIdSet.add(string.valueOf(accObj.Id).subString(0, 15));
            } else if (string.valueOf(accObj.Id).subString(0, 15) == string.valueOf(accObj.Ultimate_Parent_Account_ID__c).subString(0, 15)) {
                AccountTriggerStaticProperties.ultimateParentIdSet.add(string.valueOf(accObj.Id).subString(0, 15));
            }
        }
    }

    public void afterInsert() {
        List<String> partnersIdForSharing = new List<String>();
        for (Account accObj: newList) {
            if (accObj.ParentId != null) {
                AccountTriggerStaticProperties.allAccountParentAfterQuery.add(accObj);
            }
            AccountTriggerStaticProperties.ultimateParentIdSet.add(string.valueOf(accObj.id).subString(0, 15));
            if (accObj.Ultimate_Parent_Account_ID__c != null) {
                AccountTriggerStaticProperties.ultimateParentIdSet.add(string.valueOf(accObj.Ultimate_Parent_Account_ID__c).subString(0, 15));
            }
        }                                                   
        if (AccountTriggerStaticProperties.accountsListForUpdateForCreditCounter.size() > 0) {
            allRecordsForUpdate.addAll((List < Sobject > ) AccountTriggerStaticProperties.accountsListForUpdateForCreditCounter);
        }
        //--------------As/Simplion/6/4/2015-----------------------------------------------------------------
        Map < string, Account > MapMobNumAccount = AccountGateway.createAccountMobileNumberMap(newList);
        AccountTriggerStaticProperties.lstCarrData = [SELECT Id, Carrier_Wireless_Phone_Number__c 
                                                        FROM Carrier_Data__c
                                                        WHERE Carrier_Wireless_Phone_Number__c != NULL AND Carrier_Wireless_Phone_Number__c IN: MapMobNumAccount.keyset() order by lastmodifiedDate];

        List < Carrier_Data__c > listOfCarrierDataToUpdate = AccountGateway.updateCarrierDataRecordNew(AccountTriggerStaticProperties.lstCarrData, MapMobNumAccount);
        //----------------------------Update the carrier data(In last) --------------------------------------------------------------
        allRecordsForUpdate.addAll((List < Sobject > ) listOfCarrierDataToUpdate);
        //-------------------------------------ends--------------------------------------------------

        //---------As/Simplion/4/30/2015-------------------------------------------------------------
        if (AccountTriggerStaticProperties.currentPartnersCustomerListQuery.size() > 0) {
            List < Account > customersListForUpdates = AccountGateway.updatePartnerCodeOnInsertAndUpdate(AccountTriggerStaticProperties.currentPartnersCustomerListQuery, AccountTriggerStaticProperties.partnerAccountMap);
            allRecordsForUpdate.addAll((List < Sobject > ) customersListForUpdates);
        }

        if (!AccountTriggerStaticProperties.allAccountParentAfterQuery.isEmpty()) {
            AccountGateway.validateAccountHierarchy(newList, AccountTriggerStaticProperties.allAccountsByParentDetails, AccountTriggerStaticProperties.allAccountParentByParentIdQuery);
        }
        //Start calculation of Completion Rate and Completion Date of Graduation Phase of Graduation Score Card 
        //Muds_Simplion 4th June as Account metric will be made only after ac insertion
        /*List < Account_Metric__c > listOfAccountMetricToUpdate = AccountGateway.calculateGraduationCompletionRate(newList, AccountTriggerStaticProperties.allAccountInAfterQuery);
        if (listOfAccountMetricToUpdate.size() > 0) {
            allRecordsForUpdate.addAll((List < Sobject > ) listOfAccountMetricToUpdate);
        }*/

        List < Case > listOfFinanceCaseToInsert = AccountGateway.createFinanceCaseOnInsertAndUpdate(Trigger.New, oldMap, AccountTriggerStaticProperties.allAccountInAfterQuery, financeGroup);
        if (listOfFinanceCaseToInsert != null) {
            allRecordsForInsert.addAll((List < Sobject > ) listOfFinanceCaseToInsert);
        }

		System.debug(' ##### DEBUG = ' + newMap);
       /* List < Lead > leadsListForAccount = AccountGateway.createLeadForAccounts(newMap, oldMap, AccountTriggerStaticProperties.allAccountsMapAfterQuery);
        If(leadsListForAccount.size() > 0) {
            allRecordsForInsert.addAll((List < Sobject > ) leadsListForAccount);
        }*/

        List < Implementation__c > implementationToInsertOnAccountInsert = AccountGateway.createImplementationOnAccountInsert(newMap, oldMap, AccountTriggerStaticProperties.allAccountsMapAfterQuery, AccountTriggerStaticProperties.premiumImpAccMap);
        if (implementationToInsertOnAccountInsert.size() > 0) {
            allRecordsForInsert.addAll((List < Sobject > ) implementationToInsertOnAccountInsert);
        }
        
        if (AccountTriggerStaticProperties.ultimateParentIdSet != null && AccountTriggerStaticProperties.ultimateParentIdSet.size() > 0) {
            for (Account accObj : [SELECT id, Ultimate_Parent_Account_ID__c, Ultimate_Parent_Snapshot__c, Number_of_DL_s__c, Total_DLs__c, RC_Account_Status__c
                                            FROM Account
                                            WHERE NAME != NULL AND RecordType.Name = : AccountTriggerStaticProperties.CUSTOMER_ACCOUNT
                                            AND Ultimate_Parent_Snapshot__c IN: AccountTriggerStaticProperties.ultimateParentIdSet]) {
                
                allHeirarchyAccountList.add(accObj);
            }
            
        }

        if (AccountTriggerStaticProperties.ultimateParentIdSet != null && AccountTriggerStaticProperties.ultimateParentIdSet.size() > 0) {
            if (accountHierachyCalculationEnabled) { // if Custom settings enabled
                List < Account > updateListOfAccount = AccountGateway.calculateAccountHierarchyTotalDLS(AccountTriggerStaticProperties.ultimateParentIdSet,allHeirarchyAccountList);
                if (updateListOfAccount.size() > 0) {
                    allRecordsForUpdate.addAll((List < Sobject > ) updateListOfAccount);
                }
            }
        }
    }

    public void afterUpdate() {
        //---------------------------As/Simplion/4/30/2015--------------------------------------------------------------------
        //------------Prepare ultimateParentIdSet for update event on account-----------------------------------------------
        
        List < Account > paidAccountList = new List < Account > ();
        List<String> partnersIdForSharing = new List<String>();
        List<Account> allParentForSharingDelete = new List<Account>();
        List<String> ultimateParentsIdForSharing = new List<String>();
        for (Account accObj: newList) {
            Account oldAcc = oldMap.get(accObj.Id);
            if ((accObj.ParentId != oldMap.get(accObj.Id).ParentId) || (accObj.RC_Account_Status__c != oldMap.get(accObj.Id).RC_Account_Status__c) || (accObj.Number_of_DL_s__c != oldMap.get(accObj.Id).Number_of_DL_s__c)) {
                AccountTriggerStaticProperties.ultimateParentIdSet.add(string.valueOf(accObj.id).subString(0, 15));
                if (accObj.Ultimate_Parent_Account_ID__c != null) {
                    AccountTriggerStaticProperties.ultimateParentIdSet.add(string.valueOf(accObj.Ultimate_Parent_Account_ID__c).subString(0, 15));
                    AccountTriggerStaticProperties.ultimateParentIdSet.add(string.valueOf(oldMap.get(accObj.Id).Ultimate_Parent_Account_ID__c).subString(0, 15));
                }
            }

            if (accObj.RC_Account_Status__c != null && ('Paid'.equalsIgnoreCase(accObj.RC_Account_Status__c.trim()) || 'Canceled'.equalsIgnoreCase(accObj.RC_Account_Status__c.trim())) && accObj.RC_Account_Status__c != oldMap.get(accObj.id).RC_Account_Status__c) {
                paidAccountList.add(accObj);
            }

            if (accObj.ParentId != null && (accObj.ParentId != oldMap.get(accObj.Id).ParentId)) {
                AccountTriggerStaticProperties.allAccountParentAfterQuery.add(accObj);
            }
        
        //--------------------------As/Simplion/5/29/2015------------------------------------------------------------
        //--------------------------Transfering this code to AccountTrigger After Update event------------------------
            if(!String.isBlank(oldAcc.Partner_ID__c) && oldAcc.Partner_ID__c !=accObj.Partner_ID__c ){
                
                partnersIdForSharing.add(oldAcc.Partner_ID__c); 
            }
                        
        }
        List<Account> ParentsWithUltimateParentValue = [SELECT Ultimate_Parent_Snapshot__c 
                                                            FROM Account  
                                                            WHERE  Partner_ID__c IN :partnersIdForSharing AND RecordType.Name =: AccountTriggerStaticProperties.PARTNER_ACCOUNT];
        for(Account acc : ParentsWithUltimateParentValue){
            ultimateParentsIdForSharing.add(acc.Ultimate_Parent_Snapshot__c);
        }
        allParentForSharingDelete = [SELECT Id 
                                    FROM Account 
                                    WHERE Ultimate_Parent_Snapshot__c IN:ultimateParentsIdForSharing AND RecordType.Name =: AccountTriggerStaticProperties.PARTNER_ACCOUNT];
        List<Group> groupForSharing = [SELECT Id 
                                        FROM group 
                                        WHERE RelatedId IN(SELECT UserRoleId 
                                                            FROM User 
                                                            WHERE UserRoleId  != null 
                                                                AND Contact.Account.Id IN:allParentForSharingDelete
                                                                AND UserRole.PortalRole=: AccountTriggerStaticProperties.EXECUTIVE
                                                                AND Contact.Account.IsPartner=true 
                                                                AND UserRole.PortalType=:AccountTriggerStaticProperties.PARTNER
                                                                AND UserRole.Name!=null)];
        List<AccountShare> sharingRecords = [SELECT Id 
                                                FROM AccountShare 
                                                WHERE UserOrGroupId IN:groupForSharing 
                                                    AND AccountId IN (SELECT Id FROM Account WHERE Partner_id__c IN:partnersIdForSharing 
                                                    AND  RecordTYpe.Name =: AccountTriggerStaticProperties.CUSTOMER_ACCOUNT)];
        if(sharingRecords.size() > 0){
            allRecordsForDelete.addAll((List<Sobject>)sharingRecords);
        }
        List < Account > accountsByParentDetailsAndPartnerType = new List < Account > ();
        if (AccountTriggerStaticProperties.allAccountsByParentDetails.size() > 0) {
            for (Account parentDetailAcc: AccountTriggerStaticProperties.allAccountsByParentDetails) {
                if (parentDetailAcc.RecordType.Name.equalsIgnoreCase(AccountTriggerStaticProperties.PARTNER_ACCOUNT)) {
                    accountsByParentDetailsAndPartnerType.add(parentDetailAcc);

                }
            }
        }
        if (AccountTriggerStaticProperties.accountsListForUpdateForCreditCounter.size() > 0) {
            allRecordsForUpdate.addAll((List < Sobject > ) AccountTriggerStaticProperties.accountsListForUpdateForCreditCounter);
        }
        //Start calculation of Completion Rate and Completion Date of Graduation Phase of Graduation Score Card 
        List < Account_Metric__c > listOfAccountMetricToUpdate = AccountGateway.calculateGraduationCompletionRate(newList, AccountTriggerStaticProperties.allAccountInAfterQuery);
        if (listOfAccountMetricToUpdate.size() > 0) {
            allRecordsForUpdate.addAll((List < Sobject > ) listOfAccountMetricToUpdate);
        }

        List < Case > listOfFinanceCaseToInsert = AccountGateway.createFinanceCaseOnInsertAndUpdate(Trigger.New, oldMap, AccountTriggerStaticProperties.allAccountInAfterQuery, financeGroup);
        if (listOfFinanceCaseToInsert != null) {
            allRecordsForInsert.addAll((List < Sobject > ) listOfFinanceCaseToInsert);
        }

        //----------------As/Simplion/3/13/2015------------------------------------------
        //----------------This code updates all customer accounts of updated partner account if do not create implementation field is changed ------------------------
        List < Account > customersListToUpdateForDoNotCreateImplementation = AccountGateway.updateCustomersOnPartnerUpdate(newList, oldMap, AccountTriggerStaticProperties.currentPartnersCustomerListQuery);
        if (customersListToUpdateForDoNotCreateImplementation.size() > 0) {
            allRecordsForUpdate.addAll((List < Sobject > ) customersListToUpdateForDoNotCreateImplementation);
        }
        List < Account > customersListForUpdates = AccountGateway.updatePartnerCodeOnInsertAndUpdate(AccountTriggerStaticProperties.currentPartnersCustomerListQuery, AccountTriggerStaticProperties.partnerAccountMap);
        if (customersListForUpdates.size() > 0) {
            allRecordsForUpdate.addAll((List < Sobject > ) customersListForUpdates);
        }
        //This code is used for inserting new lead, new implementaion,sending email
        List < Survey__c > surveyListToInsert = AccountGateway.createVARSurveyOnAccountUpdate(newList, oldMap, AccountTriggerStaticProperties.allAccountsMapAfterQuery, AccountTriggerStaticProperties.partnerAccountContactMap);
        if (surveyListToInsert != null && surveyListToInsert.size() > 0) {
            allRecordsForInsert.addAll((List < Sobject > ) surveyListToInsert);
        }
        List < Implementation__c > ImplementationListToUpdate = AccountGateway.changeImplementationForCanceledAccounts(newList, oldMap, AccountTriggerStaticProperties.allAccountsMapAfterQuery);
        if (ImplementationListToUpdate.size() > 0) {
            allRecordsForUpdate.addAll((List < Sobject > ) ImplementationListToUpdate);
        }
        //----------------------------AS/Simplion/5/12/2015-------------------------------------------
        List < Sobject > exceptionAndNotificationList = AccountGateway.sendEmailsForContracts(newList, oldMap, AccountTriggerStaticProperties.accountContractMap);
        if (exceptionAndNotificationList.size() > 0) {
            allRecordsForInsert.addAll((List < Sobject > ) exceptionAndNotificationList);
        }

        List < Lead > leadsForAccountsToInsert = AccountGateway.createLeadOnAccountUpdate(newList, oldMap, AccountTriggerStaticProperties.allAccountsMapAfterQuery);
        if (leadsForAccountsToInsert.size() > 0) {
            allRecordsForInsert.addAll((List < Sobject > ) leadsForAccountsToInsert);
        }

        List < Implementation__c > implementationToInsertOnAccountupdate = AccountGateway.createImplementationForAccounts(newMap, oldMap, AccountTriggerStaticProperties.allAccountsMapAfterQuery, AccountTriggerStaticProperties.premiumImpAccMap);

        if (implementationToInsertOnAccountupdate.size() > 0) {
            allRecordsForInsert.addAll((List < Sobject > ) implementationToInsertOnAccountupdate);
        }
        //----------------------AS/Simplion/5/12/2015---------------------------------------------------------------
        //---------------------taking out the account cleanup process functionality for now only---------------------
        if (AccountTriggerStaticProperties.AllRecordsPartnerId.size() > 0) {
            Set < String > emails = new Set < String > ();
            for (Contact contactObj: AccountTriggerStaticProperties.PrimaryContactAccountMap.values()) {

                if (contactObj != null && contactObj.Email != 'fake@email.com' && contactObj.Email != 'fake@fake.com') {
                    emails.add(contactObj.Email);
                }
            }
            if (emails.size() > 0) {
                List < Contact > suspendedContacts = [SELECT Id, marketingSuspend__c
                                                        FROM Contact 
                                                        WHERE (marketingSuspend__c = false OR marketingSuspend__c = null) AND Email IN: emails AND isDeleted = false];
                List < Lead > suspendedLeads = [SELECT Id, marketingSuspend__c
                                                    FROM Lead 
                                                    WHERE marketingSuspend__c = false AND Email IN: emails AND IsConverted = false AND isDeleted = false];
                for (Contact contactObj: suspendedContacts) {
                    contactObj.marketingSuspend__c = true;
                }
                for (Lead leadObj: suspendedLeads) {
                    leadObj.marketingSuspend__c = true;
                }
                if (suspendedContacts.size() > 0) {
                    allRecordsForUpdate.addAll((List < Sobject > ) suspendedContacts);
                }
                if (suspendedLeads.size() > 0) {
                    allRecordsForUpdate.addAll((List < Sobject > ) suspendedLeads);
                }
            }
        }


        if (paidAccountList != null && paidAccountList.size() > 0) {
            List < Contact > paidAccountRelatedContactsToUpdate = AccountGateway.updatePaidAccountRelatedContacts(paidAccountList, AccountTriggerStaticProperties.allAccountsMapAfterQuery);
            if (paidAccountRelatedContactsToUpdate.size() > 0) {
                allRecordsForUpdate.addAll((List < Sobject > ) paidAccountRelatedContactsToUpdate);
            }

        }
        if (AccountTriggerStaticProperties.allAccountParentAfterQuery != null && !AccountTriggerStaticProperties.allAccountParentAfterQuery.isEmpty()) {
            AccountHierarchyValidation.validateAccountHierarchy(newList, AccountTriggerStaticProperties.allAccountsByParentDetails, AccountTriggerStaticProperties.allAccountParentByParentIdQuery);
        }
        //-------------------AS/Simplion/5/6/2015-------------------------------------------------------
        if (AccountTriggerStaticProperties.ultimateParentIdSet != null && AccountTriggerStaticProperties.ultimateParentIdSet.size() > 0) {
            for (Account accObj : [SELECT id, Ultimate_Parent_Account_ID__c, Ultimate_Parent_Snapshot__c, Number_of_DL_s__c, Total_DLs__c, RC_Account_Status__c
                                            FROM Account
                                            WHERE NAME != NULL AND RecordType.Name = : AccountTriggerStaticProperties.CUSTOMER_ACCOUNT
                                            AND Ultimate_Parent_Snapshot__c IN: AccountTriggerStaticProperties.ultimateParentIdSet]) {
                
                allHeirarchyAccountList.add(accObj);
            }
            
        }
        if (AccountTriggerStaticProperties.ultimateParentIdSet != null && AccountTriggerStaticProperties.ultimateParentIdSet.size() > 0) {
            if (accountHierachyCalculationEnabled) { // if Custom settings enabled
                List < Account > updateListOfAccount = AccountGateway.calculateAccountHierarchyTotalDLS(AccountTriggerStaticProperties.ultimateParentIdSet,allHeirarchyAccountList);
                if (updateListOfAccount.size() > 0) {
                    allRecordsForUpdate.addAll((List < Sobject > ) updateListOfAccount);
                }
            }
        }

    }

    public void afterDelete() {
        if (AccountTriggerStaticProperties.ultimateParentIdSet != null && AccountTriggerStaticProperties.ultimateParentIdSet.size() > 0) {
            for (Account accObj : [SELECT id, Ultimate_Parent_Account_ID__c, Ultimate_Parent_Snapshot__c, Number_of_DL_s__c, Total_DLs__c, RC_Account_Status__c
                                            FROM Account
                                            WHERE NAME != NULL AND RecordType.Name = : AccountTriggerStaticProperties.CUSTOMER_ACCOUNT
                                            AND Ultimate_Parent_Snapshot__c IN: AccountTriggerStaticProperties.ultimateParentIdSet]) {
                
                allHeirarchyAccountList.add(accObj);
            }
            
        }
        if (AccountTriggerStaticProperties.ultimateParentIdSet != null && AccountTriggerStaticProperties.ultimateParentIdSet.size() > 0) {
            if (accountHierachyCalculationEnabled) { // if Custom settings enabled
                List < Account > updateListOfAccount = AccountGateway.calculateAccountHierarchyTotalDLS(AccountTriggerStaticProperties.ultimateParentIdSet,allHeirarchyAccountList);
                if (updateListOfAccount.size() > 0) {
                    allRecordsForUpdate.addAll((List < Sobject > ) updateListOfAccount);
                }
            }
        }
    }

    /**
     * andFinally
     *
     * This method is called once all records have been processed by the trigger. Use this 
     * method to accomplish any final operations such as creation or updates of other records.
     */
    public void beforeFinally() {

    }



    public void afterFinally() {
        //---------------------------As/Simplion/4/8/2015--------------------------------------------------------------------
        //---------------------------DML statement to update all records for this Trigger context----------------------------
        if (allRecordsForInsert.size() > 0) {

            insert allRecordsForInsert;
        }
        if (allRecordsForUpsert.size() > 0) {
            upsert allRecordsForUpsert;
        } 
        if (allRecordsForUpdate.size() > 0) {
            update allRecordsForUpdate;
        }
        if(allRecordsForDelete.size() > 0){
            delete allRecordsForDelete;
        }

    }
}