/**
 * Class AccountGateway 
 *
 * Provides finder methods for accessing data in the Account object.
 */
public without sharing class AccountGateway {
    //------------------This method prepare UserIdSet -------------------------
    public static Set < Id > prepareUserIdSet(List < Account > accountList) {
        Set < Id > IdsSet = new Set < Id > ();
        for (Account accObj: accountList) {
            if (!String.isBlank(accObj.OwnerId)) {
                IdsSet.add(accObj.OwnerId);
            }
            if (!String.isBlank(accObj.Premium_Support_Agent__c)) {
                IdsSet.add(accObj.Premium_Support_Agent__c);
            }
            if (!String.isBlank(accObj.Current_Owner__c)) {
                IdsSet.add(accObj.Current_Owner__c);
            }
        }
        return IdsSet;
    }
    //--------------Method to set account values for Before Account trigger---------------------------
    public static void setAccountValues(Account acct, Map < Id, User > userMap) {
        Profile objpro = AccountTriggerStaticProperties.currentLoggedInProfile;
        User userObj = objpro.Users[0];
        if (acct.Type == AccountTriggerStaticProperties.PARTNER) {
            acct.RecordTypeId = AccountTriggerStaticProperties.accountRecordTypeMapByName.get('Partner Account').getRecordTypeId();
            if (String.isBlank(acct.RC_User_ID__c)) {
                acct.RC_User_ID__c = acct.Partner_ID__c;
                System.debug('~~~~~~~~~~~~~~~~~~~~~~acct.RC_User_ID__c' + acct.RC_User_ID__c);
            }
        } else {
            acct.RecordTypeId = AccountTriggerStaticProperties.accountRecordTypeMapByName.get('Customer Account').getRecordTypeId();
        }
        if (acct.Premium_Support_Agent__c != null && userMap != null && userMap.containskey(acct.Premium_Support_Agent__c)) {
            acct.Agent_Email_Address__c = userMap.get(acct.Premium_Support_Agent__c).Email;
        }
        if (acct.OwnerId != null && userMap != null && userMap.containskey(acct.OwnerId)) {
            acct.Account_Owner_Phone_Number__c = userMap.get(acct.OwnerId).Phone;
        }
        if (acct.Phone != null && acct.BillingCountry != null) {
            acct.Original_Phone_Number__c = acct.Phone;
            acct.Phone = ValidationUtility.validatePhoneNumber(acct.Phone, acct.BillingCountry);
        }
        if (acct.Ultimate_Parent_Account_ID__c != NULL) {
            acct.Ultimate_Parent_Snapshot__c = String.valueOf(acct.Ultimate_Parent_Account_ID__c).substring(0, 15);
        }
        //-----------------This code set sales person values if this record is created by any sales person except sales engineers
        if (objpro.Name.toLowerCase().contains('sales') && !objpro.Name.toLowerCase().contains('engineer')) {
            acct.LastTouchedbySalesID__c = userObj.Id;
            acct.LastTouchedbySalesFirstName__c = userObj.FirstName;
            acct.LastTouchedbySalesLastName__c = userObj.LastName;
            acct.LastTouchedbySalesEmail__c = userObj.Email;
            acct.LastTouchedbySalesPhone__c = userObj.Phone;
        }

    }


    //-----------------------------------------New Optimized-----------------------------------------
    public static void accountSharingOnInsert(Account accountObj, Map < String, Account > mapPartnerIdToAccount) {

        if (accountObj.Partner_ID__c != null && accountObj.Partner_ID__c != '' && mapPartnerIdToAccount != null && mapPartnerIdToAccount.get(accountObj.Partner_ID__c) != null) {
            Account objAccount = mapPartnerIdToAccount.get(accountObj.Partner_ID__c);
            accountObj.Do_Not_Creation_Implementation__c = objAccount.Do_Not_Creation_Implementation__c;
            accountObj.Partner_Account_Name__c = objAccount.name;
            accountObj.Ultimate_Partner_ID__c = objAccount.Ultimate_Parent_Partner_ID__c;
            accountObj.Ultimate_Partner_Name__c = objAccount.Ultimate_Parent_Account_Name__c;
            accountObj.Current_Owner__c = objAccount.Current_Owner__c;
            accountObj.Current_Owner_Name__c = objAccount.Current_Owner_Name__c;
            accountObj.Current_Owner_Email__c = objAccount.Current_Owner_Email__c;
        }

    }

    //--------------------------------------New Optimized---------------------------------------------
    public static void setEligibalForReferealCredit(Account accObj, Map < String, Account > partnerIdToAccountMap, Map < Id, Integer > counterToPartnerAccount) {

        if (    (accObj.RecordTypeId != null && AccountTriggerStaticProperties.accountRecordTypeMapById.get(accObj.RecordTypeId).getName() == AccountTriggerStaticProperties.CUSTOMER_ACCOUNT) && 
                (accObj.Partner_ID__c != null && !String.isBlank(accObj.RC_Account_Status__c)) && 
                accObj.Pay_Referral_Commissions__c == true && 
                accObj.RC_Account_Status__c.equalsIgnoreCase('Paid') && 
                (partnerIdToAccountMap != null && partnerIdToAccountMap.get(accObj.Partner_ID__c) != null)) {
                    
            Account partnerAccountObj = partnerIdToAccountMap.get(accObj.Partner_ID__c);
            Integer counter = counterToPartnerAccount.get(partnerAccountObj.Id);
            if (partnerAccountObj != null && counter < 5 && partnerAccountObj.Partner_Sign_Up_Date__c != null && 
                accObj.RC_Signup_Date__c != null && 
                (partnerAccountObj.Partner_Sign_Up_Date__c.daysBetween(accObj.RC_Signup_Date__c.date())) < 185) {
                    
                accObj.Eligible_for_Refferel_Credit__c = true;
                counter = counter + 1;
                counterToPartnerAccount.put(partnerAccountObj.Id, counter);
                partnerAccountObj.Partner_Customer_Count__c = counter;
                AccountTriggerStaticProperties.accountsListForUpdateForCreditCounter.add(partnerAccountObj);
            }
        }
    }


    //---------------------------As/Simplion/9/24/2014----------------------------------------
    //----------------------------New Optimized----------------------------------------------
    public static void setServiceType(Account currentAccount, Map < String, String > serviceAndTypeMap) {
        //---------------------------------As/Simplion/10/16/2014 start--------------------------------------------------------------------------
        //--------------------------------Service Type mapping as per service Name for account with Account status = 'test'---------------
        String serviceName = '';
        if (!String.isBlank(currentAccount.RC_Service_name__c) && !String.isBlank(currentAccount.RC_Account_Status__c)) {
            serviceName = currentAccount.RC_Service_name__c.toUpperCase();
            if (currentAccount.RC_Account_Status__c.toUpperCase().equals('TEST')) {

                currentAccount.Service_Type__c = serviceName.contains('OFFICE') ? 
                                                    serviceAndTypeMap.get('OFFICE') : 
                                                    (serviceName.contains('PROFESSIONAL') ||serviceName.startsWith('PRO')) ? 
                                                        serviceAndTypeMap.get('PROFESSIONAL') : 
                                                        serviceName.contains('FAX') ? 
                                                            serviceAndTypeMap.get('FAX') : 
                                                            currentAccount.Service_Type__c;
            }
        }
    }
    //------------------Method of before update----------------------------------------------------------
    //-----------------------------New Optimized--------------------------------------------
    public static void setAccountValuesOnUpdate(Account accObj, Account oldaccObj, Map < String, Account > MapPartnerId) {

        if (accObj.Website != oldaccObj.Website || accObj.Number_of_Locations__c != oldaccObj.Number_of_Locations__c || 
            accObj.NumberOfEmployees != oldaccObj.NumberOfEmployees || accObj.No_of_Employees__c != oldaccObj.No_of_Employees__c || 
            accObj.Industry != oldaccObj.Industry || accObj.Is_the_customer_interested_in_porting__c != oldaccObj.Is_the_customer_interested_in_porting__c) {
            //------------------------------------------------------------------------------------------------------------
            accObj.Customer_Profile_Last_modified_Date__c = System.now();
        }
        if (accObj.Current_Owner__c != null && (oldaccObj.Current_Owner__c != accObj.Current_Owner__c) && (!UserInfo.getFirstName().containsIgnoreCase('RCSF'))) {
            User CO = AccountTriggerStaticProperties.allUserMap.get(accObj.Current_Owner__c);
            accObj.Current_Owner_Name__c = CO.Name;
            accObj.Current_Owner_Email__c = CO.Email;
        }
        if (oldaccObj.Current_Owner__c != null && accObj.Current_Owner__c == null) {
            accObj.Current_Owner_Name__c = null;
            accObj.Current_Owner_Email__c = null;
        }
        
        System.debug('allUserMap >>'+AccountTriggerStaticProperties.allUserMap);
        // If owner id is changed and old Account_Owner_Phone_Number__c value is different from new record owner phone value
        if (AccountTriggerStaticProperties.allUserMap != null && oldaccObj.OwnerId != null && accObj.OwnerId != null && 
            ((oldaccObj.OwnerId != accObj.OwnerId) || 
            (oldaccObj.Account_Owner_Phone_Number__c != AccountTriggerStaticProperties.allUserMap.get(accObj.OwnerId).phone))) {
            
            accObj.Account_Owner_Phone_Number__c = AccountTriggerStaticProperties.allUserMap.get(accObj.OwnerId).Phone;
        }
        //----If RC_Account_Number__c value is not null and starts with 1 and have 11 digits
        if (accObj.RC_Account_Number__c != null && accObj.RC_Account_Number__c.length() == 11 && accObj.RC_Account_Number__c.startsWith('1')) {
            accObj.RC_Account_Number__c = accObj.RC_Account_Number__c.substring(1);
        }

        //--If service type is of office and RC_Account_Status__c is changed and not null and have any value in Trial 7 CC
        //  ,Trial 30 CC, Trial 30 no-CC, Trial (other) and new value is Disabled
        if (!string.isBlank(accObj.Service_Type__c) && accObj.Service_Type__c.containsIgnoreCase('Office') && 
            oldaccObj.RC_Account_Status__c != accObj.RC_Account_Status__c && !string.isBlank(oldaccObj.RC_Account_Status__c) && 
            !string.isBlank(accObj.RC_Account_Status__c) && (oldaccObj.RC_Account_Status__c.equalsIgnoreCase('Trial 7 CC') || 
            oldaccObj.RC_Account_Status__c.equalsIgnoreCase('Trial 30 CC') || oldaccObj.RC_Account_Status__c.equalsIgnoreCase('Trial 30 no-CC') || 
            oldaccObj.RC_Account_Status__c.equalsIgnoreCase('Trial (other)')) && accObj.RC_Account_Status__c.equalsIgnoreCase('Disabled')) {
            //-------------------------------------------------------------------------------------------------------------------------------------
            accObj.Hardware_Return_Pending__c = true;
            accObj.Trial_De_activation_Date__c = System.today();
        }
        //--If phone is not null and changed and billingCountry is not null and changed
        if (accObj.Phone != null && accObj.billingCountry != null) {
            if (accObj.Phone != oldaccObj.Phone || accObj.billingCountry != oldaccObj.billingCountry) {
                accObj.Phone = ValidationUtility.validatePhoneNumber(accObj.Phone, accObj.BillingCountry);
            }
        }
        String OldPartnerIdvalue = oldaccObj.Partner_ID__c;
        //---IF partner Id is changed of customer account
        if ((AccountTriggerStaticProperties.accountRecordTypeMapById.get(accObj.RecordTypeId).getName() == AccountTriggerStaticProperties.CUSTOMER_ACCOUNT) && 
            accObj.Partner_ID__c != null && (OldPartnerIdvalue != accObj.Partner_ID__c) && MapPartnerId != null && 
            MapPartnerId.get(accObj.Partner_ID__c) != null) {
                
            Account partnerAcc = MapPartnerId.get(accObj.Partner_ID__c);
            accObj.Do_Not_Creation_Implementation__c = partnerAcc.Do_Not_Creation_Implementation__c;
            accObj.Partner_Account_Name__c = partnerAcc.name;
            accObj.Ultimate_Partner_ID__c = partnerAcc.Ultimate_Parent_Partner_ID__c;
            accObj.Ultimate_Partner_Name__c = partnerAcc.Ultimate_Parent_Account_Name__c;
            accObj.Current_Owner__c = partnerAcc.Current_Owner__c;
            accObj.Current_Owner_Name__c = partnerAcc.Current_Owner_Name__c;
            accObj.Current_Owner_Email__c = partnerAcc.Current_Owner_Email__c;
        }
        // copy Ultimate_Parent_Snapshot__c value from Ultimate_Parent_Account_ID__c if and only if it is not blank
        if (accObj.Ultimate_Parent_Account_ID__c != NULL) {
            accObj.Ultimate_Parent_Snapshot__c = String.valueOf(accObj.Ultimate_Parent_Account_ID__c).substring(0, 15);
        }
        //-----------------This code set sales person values if this record is edited by any sales person except sales engineers
        Profile objpro = AccountTriggerStaticProperties.currentLoggedInProfile;
        User userObj = objpro.Users[0];
        if (objpro.Name.toLowerCase().contains('sales') && !objpro.Name.toLowerCase().contains('engineer')) {
            accObj.LastTouchedbySalesID__c = userObj.Id;
            accObj.LastTouchedbySalesFirstName__c = userObj.FirstName;
            accObj.LastTouchedbySalesLastName__c = userObj.LastName;
            accObj.LastTouchedbySalesEmail__c = userObj.Email;
            accObj.LastTouchedbySalesPhone__c = userObj.Phone;
        }



    }
    //-------------------------New Optimized-----------------------------------------------------------------
    //-------------------------Method to set value of Eligible_for_Refferel_Credit__c of account--------------
    public static void updateEligibalForReferealCredit(Account accObj, Account oldAcc, Map < String, Account > partnerIdToAccountMap, Map < Id, Integer > counterToPartnerAccount) {
        if (    (accObj.RecordTypeId != null && AccountTriggerStaticProperties.accountRecordTypeMapById.get(accObj.RecordTypeId).getName() == AccountTriggerStaticProperties.CUSTOMER_ACCOUNT) && 
                accObj.Partner_ID__c != null && 
                ((!String.isBlank(accObj.RC_Account_Status__c) && accObj.RC_Account_Status__c.equalsIgnoreCase('Paid') && oldAcc.RC_Account_Status__c != accObj.RC_Account_Status__c) && 
                    (oldAcc.Pay_Referral_Commissions__c != accObj.Pay_Referral_Commissions__c && accObj.Pay_Referral_Commissions__c == true)) && 
                partnerIdToAccountMap != null && partnerIdToAccountMap.get(accObj.Partner_ID__c) != null) {
            //----------------------------------------------------------------------------------------------------------------------------

            Account partnerAccountObj = partnerIdToAccountMap.get(accObj.Partner_ID__c);
            Integer counter = counterToPartnerAccount.get(partnerAccountObj.Id);
            if ((!'Suspended'.equalsIgnoreCase(oldAcc.RC_Account_Status__c) && !'Canceled'.equalsIgnoreCase(oldAcc.RC_Account_Status__c))) {
                if (partnerAccountObj != null && counter < 5 && partnerAccountObj.Partner_Sign_Up_Date__c != null && 
                    accObj.RC_Signup_Date__c != null && 
                    (partnerAccountObj.Partner_Sign_Up_Date__c.daysBetween(accObj.RC_Signup_Date__c.date())) < 185) {
                        
                    accObj.Eligible_for_Refferel_Credit__c = true;
                    counter = counter + 1;
                    counterToPartnerAccount.put(accObj.Id, counter);
                    partnerAccountObj.Partner_Customer_Count__c = counter;
                    AccountTriggerStaticProperties.accountsListForUpdateForCreditCounter.add(partnerAccountObj);
                }
            }
        }
    }


    public static void updateMostRecentImplementationContact(Account newAcc, Account objAccount) {
        if (objAccount.AccountContactRoles.size() > 0) {
            for (AccountContactRole objACR: objAccount.AccountContactRoles) {
                if (objACR != null && objACR.ContactId != Null && objACR.isPrimary) {
                    newAcc.Most_Recent_Implementation_Contact__c = objACR.ContactId;
                    newAcc.Preferred_Language__c = objACR.contact.Preferred_Language__c;
                }
            }
        }
        if (newAcc.Most_Recent_Implementation_Contact__c == null) {
            newAcc.Preferred_Language__c = 'en_US';
        }
    }


    //--------------------As/Simplion/4/6/2015-----------------------------------------------------------------
    //---------------------This code is to create a set of phone number with country code and without country code-------------------
    //---------------------New Optimized-------------------------------------------------------------------
    public static Map < string, Account > createAccountMobileNumberMap(List < Account > newList) {
        Map < string, Account > MapMobNumAccount = new Map < string, Account > ();
        for (Account objAcc: newList) {
            String originalPhoneNumber = objAcc.Account_Mobile_Number__c;
            if (!String.isBlank(originalPhoneNumber)) {
                String formatPhoneWithCode = AccountGateway.formatPhoneNumberWithCode(originalPhoneNumber);
                String formatPhoneWithoutCode = AccountGateway.formatPhoneNumberWithoutCode(originalPhoneNumber);
                MapMobNumAccount.put(formatPhoneWithCode.trim(), objAcc);
                MapMobNumAccount.put(formatPhoneWithoutCode.trim(), objAcc);
            }
        }
        return MapMobNumAccount;
    }

    //--------------------------------------As/Simplion/5/26/2015----------------------------------------------------
    //--------------------------------------New Optimized------------------------------------------------------------
    //--------------------------------------These methods are transfered from HelperUtils class to here starts- -----------------------
    public static List < Carrier_Data__c > updateCarrierDataRecordNew(List < Carrier_Data__c > lstCarrDat, Map < String, Account > MapMobNumAccount) {
        List < Carrier_Data__c > updateCarrData = new List < Carrier_Data__c > ();
        for (Carrier_Data__c objCarrData: lstCarrDat) {
            String originalPhoneNumber = objCarrData.Carrier_Wireless_Phone_Number__c;
            String formatPhoneWithCode = AccountGateway.formatPhoneNumberWithCode(originalPhoneNumber);
            String formatPhoneWithoutCode = AccountGateway.formatPhoneNumberWithoutCode(originalPhoneNumber);

            Account accountObj = MapMobNumAccount.get(formatPhoneWithCode);
            if (accountObj != null) {
                objCarrData.Account__c = accountObj.Id;
                updateCarrData.add(objCarrData);
            } else {
                accountObj = MapMobNumAccount.get(formatPhoneWithoutCode);
                if (accountObj != null) {
                    objCarrData.Account__c = accountObj.Id;
                    updateCarrData.add(objCarrData);
                }
            }
        }
        return updateCarrData;
    }


    //--------------------------------New Optimized------------------------------------------------------------------
    public static List < Account > updatePartnerCodeOnInsertAndUpdate(List < Account > customerAccountList, Map < String, Account > partnerAccMap) {
        List < Account > customersListForUpdates = new List < Account > ();
        for (Account customerAccount: customerAccountList) {
            if (partnerAccMap.containsKey(customerAccount.Partner_ID__c) && customerAccount.Current_Owner__c != partnerAccMap.get(customerAccount.Partner_ID__c).Current_Owner__c) {
                customerAccount.Current_Owner__c = partnerAccMap.get(customerAccount.Partner_ID__c).Current_Owner__c;
                customerAccount.Current_Owner_Name__c = partnerAccMap.get(customerAccount.Partner_ID__c).Current_Owner_Name__c;
                customerAccount.Current_Owner_Email__c = partnerAccMap.get(customerAccount.Partner_ID__c).Current_Owner_Email__c;
                customersListForUpdates.add(customerAccount);
            }
        }
        return customersListForUpdates;
    }

    //--------------------------------New Optimized------------------------------------------------------------------
    public Static void validateAccountHierarchy(List < Account > lstAccount, List < Account > allAccountsByParentDetails, Map < ID, Account > mapParentAccount) {
        Set < ID > customerParent = new Set < ID > ();
        Map < Id, List < Integer >> mapDepth = new Map < Id, List < Integer >> ();
        String strQueryCondition = '';
        for (Account objAccount: allAccountsByParentDetails) {
            if (objAccount.Parent_Detail__c != null && objAccount.Parent_Detail__c != '') {
                String strParentDetail = objAccount.Parent_Detail__c;
                List < String > lst = strParentDetail.split(',');
                for (String objString: lst) {
                    if (objString != null && objString != '') {
                        List < String > lst2 = objString.split('-');
                        if (lst2.size() == 2) {
                            if (mapDepth.get(lst2.get(1)) != null) {
                                mapDepth.get(lst2.get(1)).add(Integer.valueOf(lst2.get(0)));
                            } else {
                                mapDepth.put(lst2.get(1), new List < Integer > {
                                    Integer.valueOf(lst2.get(0))
                                });
                            }
                        }
                    }
                }
            }
        }

        for (Account objAccount: lstAccount) {
            if (objAccount.ParentId != null) {
                Account objParentAccount = mapParentAccount.get(objAccount.ParentId);
                if (objParentAccount != null && ((objParentAccount.Account_Depth__c + 1) > 4)) {
                    objAccount.addError('This account cannot be added to hierarchy(' + (objParentAccount.Account_Depth__c + 1) + '), as it exceeds to hierarchy limit(4).'); // cant create parent
                } else if (objParentAccount != null) {
                    if (mapDepth.get(objAccount.id) != null) {
                        List < Integer > lstDepth = mapDepth.get(objAccount.id);
                        lstDepth.sort();
                        Integer maxChild = lstDepth.size() > 0 ? lstDepth.get(lstDepth.size() - 1) : 0;

                        if ((maxChild + objParentAccount.Account_Depth__c + 1) > 4) {
                            objAccount.addError('This account cannot be added to hierarchy(' + (maxChild + objParentAccount.Account_Depth__c + 1) + '), as it exceeds to hierarchy limit(4)'); // cant create child
                        }
                    }
                }
            }
        }

    }

    //----------------------------As/Simplion/5/6/2015---------------------------------------
    //OPtimized and we have removed an argument from this method
    public static List < Account_Metric__c > calculateGraduationCompletionRate(List < Account > newAccountList, List < Account > allAccountInAfterQuery) {
        list < Account_Metric__c > accountMetricList = new list < Account_Metric__c > ();
        map < Id, Account > mapAccounts = new map < Id, Account > ();
        //-------------------As/Simplion/5/6/2015----------------------------------------------------------------
        //-------------------Creating map of accounts with the account metric data and Support - T3 case type data
        //Map<Id, Account>accountMap = AccountScoreCardHelper.getAccountsWithAccountMetric(trigger.newMap().keyset());
		
        Map < Id, Account > accountMap = new Map < Id, Account > ();
        List <
        case >listofSupportT3Case = new List < Case > ();
        Map < Id, Account > accountAndCaseListMapForSupportT3 = new Map < Id, Account > ();
        for (Account accountByQuery: allAccountInAfterQuery) {
        	System.debug(accountByQuery.Cases+'~~~~~~~~~~~~~~~~~~~account.Cases.');
			System.debug(accountByQuery.Account_Metrics__r+'~~~~~~~~~~~~~~~~~~~account.Cases.');
            accountMap.put(accountByQuery.Id, accountByQuery);
            for (Case cas: accountByQuery.cases) {
                if (cas.RecordType.Name.equalsIgnoreCase('Support - T3') && (cas.Status != 'Closed' && cas.Status != 'Closed - No Response' && cas.Status != 'Duplicate' && cas.Status != 'Cancelled')) {
                    accountAndCaseListMapForSupportT3.put(accountByQuery.Id, accountByQuery);
                    break;
                }
            }
        }

        for (Account objAccount: newAccountList) {
            Decimal dCompletionRate = 0;
				
            if (!accountAndCaseListMapForSupportT3.isEmpty() && accountAndCaseListMapForSupportT3.get(objAccount.Id) != null) {
                Account account = accountAndCaseListMapForSupportT3.get(objAccount.Id);
                if (account.Cases.size() > 0) {
                    dCompletionRate = dCompletionRate + AccountTriggerStaticProperties.ACCOUNT_METRIC_12DOT50;
                }
                if (account.Account_Metrics__r.size() > 0) {
                    dCompletionRate = dCompletionRate + getGraduationCompRateAccountMetric(account.Account_Metrics__r[0]);
                }
            }
            dCompletionRate = dCompletionRate + getGraduationCompRateAccount(objAccount);
            //setAccountGraduationStatus(objAccount);
            if (accountMap != null && accountMap.get(objAccount.Id) != null && accountMap.get(objAccount.Id).Account_Metrics__r.size() > 0) {
                Account_Metric__c accountMetric = accountMap.get(objAccount.Id).Account_Metrics__r[0];
                if (accountMap.get(objAccount.Id).Implementations__r.size() > 0) {
                    Implementation__c impl = accountMap.get(objAccount.Id).Implementations__r[0];
                    if (impl.Account_Graduation_Status__c == 'Done') {
                        accountMetric.Account_Graduation_Status__c = 'Adoption/Maturity Phase';
                    }
                    if (impl.Account_Graduation_Status__c == 'Implementation Phase') {
                        accountMetric.Account_Graduation_Status__c = 'Implementation Phase';
                    }
                }
                accountMetric.Graduation_Phase_Completion_Rate__c = dCompletionRate;
                if (accountMetric.Adoption_Phase_Completion_Rate__c >= 75) {
                    //accountMetric.Account_Graduation_Date_31_60__c = system.now();
                    accountMetric.Account_Graduation_Status__c = 'Graduation Phase';
                }
                if (accountMetric.Graduation_Phase_Completion_Rate__c >= 75) {
                    accountMetric.Account_Graduation_Date_61_90__c = system.now();
                    accountMetric.Account_Graduation_Status__c = 'Done';
                }
                accountMetricList.add(accountMetric);
            }
        }
        return accountMetricList;
    }


    public static Decimal getGraduationCompRateAccountMetric(Account_Metric__c objAccMetric) {
        Decimal dGraduationCompleteionRate = 0;
        if (objAccMetric.Metric_3_value__c != null && objAccMetric.Metric_3_value__c > 1) {
            dGraduationCompleteionRate = AccountTriggerStaticProperties.ACCOUNT_METRIC_12DOT50;
        }
        if (objAccMetric.Metric_28_value__c != null && objAccMetric.Metric_28_value__c < 1) {
            dGraduationCompleteionRate = dGraduationCompleteionRate + 50;
        }
        return dGraduationCompleteionRate;
    }

    public static Decimal getGraduationCompRateAccount(Account objAccount) {
        Decimal dGraduationCompleteionRate = 0;
        system.debug('objAccount.Graduation_Kit__c-->' + objAccount.Graduation_Kit__c);
        if (objAccount.Graduation_Kit__c == true) {
            dGraduationCompleteionRate = dGraduationCompleteionRate + AccountTriggerStaticProperties.ACCOUNT_METRIC_12DOT50;
        }
        if (objAccount.Current_Owner_Email__c != null && objAccount.Current_Owner_Email__c != 'sfdchelp@ringcentral.com' && objAccount.Current_Owner_Email__c != 'rcsfsync@ringcentral.com') {
            dGraduationCompleteionRate = dGraduationCompleteionRate + AccountTriggerStaticProperties.ACCOUNT_METRIC_12DOT50;
        } else if (objAccount.Number_of_DL_s__c < 250 && (objAccount.Current_Owner_Email__c == 'sfdchelp@ringcentral.com' || objAccount.Current_Owner_Email__c == 'rcsfsync@ringcentral.com')) {
            dGraduationCompleteionRate = dGraduationCompleteionRate + AccountTriggerStaticProperties.ACCOUNT_METRIC_12DOT50;
        }
        return dGraduationCompleteionRate;
    }

    //--------------As/simplion/5/4/2015-------------------------------------------------------------
    //-------------This function created cases on account insert on basis of certain condittions
    //----------------New Optimized---------------------------------------------------------------
    public static List < Case > createFinanceCaseOnInsertAndUpdate(List < Account > newList, Map < Id, Account > oldMap, List < Account > allAccountQueryAfter, Group financeGroup) {
        List < Case > casetoinsert = new List < Case > ();
        Map < Id, Integer > mapAccountIdToNumberOfFinanceCase = new Map < Id, Integer > ();
        String financeGrpId = '';
        if (financeGroup != null) {
            financeGrpId = financeGroup.Id;
        }
        for (Account accObjByQuery: allAccountQueryAfter) {
            mapAccountIdToNumberOfFinanceCase.put(accObjByQuery.id, 0);
            if (accObjByQuery.cases != null) {
                for (
                case cas:
                    accObjByQuery.cases) {
                    if (cas.RecordType.Name.equalsIgnoreCase('Finance')) {
                        mapAccountIdToNumberOfFinanceCase.put(accObjByQuery.id, 1);
                        break;

                    }
                }

            }
        }
        for (Account accObjNew: newList) {
            if (accObjNew.Active_Invoice_Approval__c != NULL && mapAccountIdToNumberOfFinanceCase != NULL && mapAccountIdToNumberOfFinanceCase.get(accObjNew.Id) == 0 && accObjNew.RC_Account_Status__c == 'Paid') {
                Boolean isCreateCase = true;
                if (Trigger.isUpdate) {
                    if (oldMap.get(accObjNew.id).RC_Account_Status__c != accObjNew.RC_Account_Status__c && oldMap.get(accObjNew.id).Active_Invoice_Approval__c == null) {
                        isCreateCase = true;
                    } else {
                        isCreateCase = false;
                    }
                }
                if (isCreateCase) {
                    Case caseObj = new Case();
                    caseObj.Status = 'New';
                    caseObj.Subject = 'New Customer Tracking for Finance';
                    caseObj.OwnerId = financeGrpId;
                    caseObj.AccountId = accObjNew.Id;
                    caseObj.RecordTypeId = AccountTriggerHelperExt.caseRecordTypeMapByName.get('Finance').getRecordTypeId();
                    casetoinsert.add(caseObj);
                }
            }
        }
        return casetoinsert;
    }

    //------------------------AS/Simplion/5/13/2015------------------------------------------------------- 
    //------------------------New Optimised--------------------------------------------------------------------
    //-------------Method is depreceted because no contact on account insert and fake lead is being deleted from lead trigger---
   /* public static List < Lead > createLeadForAccounts(Map < Id, Account > newMap, Map < Id, Account > oldMap, Map < Id, Account > accountsMapAfterQuery) {
        List < Lead > leadsListForAccount = new List < Lead > ();
        Map < Id, List < Contact >> contactMap = new Map < Id, List < Contact >> ();
        System.debug('accountsMapAfterQuery>>>'+accountsMapAfterQuery.size());
        for (Account accByQuery: accountsMapAfterQuery.values()) {
        	System.debug('value of accByQuery>>>'+accByQuery);
            Account newAccount = newMap.get(accByQuery.Id);
            System.debug('value of newAccount>>>'+newAccount);
            contactMap.put(accByQuery.Id, accByQuery.contacts);
            System.debug('AccountGateway.chkToCreateLeadForOfficeTrails(newMap.get(accByQuery.Id), accountsMapAfterQuery)'+AccountGateway.chkToCreateLeadForOfficeTrails(newMap.get(accByQuery.Id), accountsMapAfterQuery));
            if (AccountGateway.chkToCreateLeadForOfficeTrails(newAccount, accountsMapAfterQuery)) {
                System.debug ('Would it ever reach here');
                Lead newLead = new Lead();
                Contact contactObj = new Contact();
                if (accByQuery.AccountContactRoles != null && accByQuery.AccountContactRoles.size() > 0) {
                    contactObj = accByQuery.AccountContactRoles[0].Contact;
                } else if (contactMap != null && contactMap.containsKey(accByQuery.Id) && contactMap.get(accByQuery.Id).size()>0) {
                    contactObj = contactMap.get(accByQuery.Id)[0];

                }
                System.debug(contactObj+'~~~~~~~~~~~~~~~~~~~~contactObj in gatway');
                if (contactObj != null) {
                    newLead.Phone = contactObj.Phone;
                    newLead.LastName = (String.isBlank(contactObj.LastName) ? newAccount.Name : contactObj.LastName);
                    newLead.FirstName = contactObj.FirstName;
                    newLead.Email = (String.isBlank(contactObj.Email) ? 'fake@email.com' : contactObj.Email);
                    newLead.Account_Status__c = newAccount.RC_Account_Status__c;
                    newLead.Account_Number__c = newAccount.RC_Account_Number__c;
                    newLead.User_ID__c = newAccount.RC_User_ID__c;
                    newLead.Lead_Tier_Name__c = newAccount.RC_Tier__c;
                    newLead.RC_Service_name__c = newAccount.RC_Service_name__c;
                    newLead.Lead_Brand_Name__c = newAccount.RC_Brand__c;
                    newLead.Company = newAccount.Name;
                    newLead.Status = 'Open - Not Contacted';
                    newLead.Account__c = newAccount.id;
                    newLead.LeadSource = 'Office Trials';
                    if (contactObj.NumberOfEmployees__c != null) {
                        newLead.NumberOfEmployees__c = contactObj.NumberOfEmployees__c;
                    } else if (newAccount.No_of_Employees__c != null) {
                        newLead.NumberOfEmployees__c = newAccount.No_of_Employees__c;
                    }

                } else {
                    newLead.Email = 'fake@fake.com';
                    newLead.LastName = 'fakeLead';
                    newLead.Company = newAccount.Name;
                    if (newAccount != null && newAccount.No_of_Employees__c != null) {
                        newLead.NumberOfEmployees__c = newAccount.No_of_Employees__c;
                    }
                }
                String sUrlRewrite = System.URL.getSalesforceBaseUrl().getHost();
                System.Debug('>>>sUrlRewrite>>>' + sUrlRewrite);
                //sUrlRewrite = 'https://' + sUrlRewrite.substring(0,sUrlRewrite.indexOf('.')-1) + 'salesforce.com' + '/' + newAccount.id;
                sUrlRewrite = 'https://' + sUrlRewrite + '/' + newAccount.id;
                newLead.Description = 'Office Free Trial Account Signup - Link to Account ' + sUrlRewrite;
                leadsListForAccount.add(newLead);
            }

        }
        return leadsListForAccount;

    }*/


    //---------------------------------New Optimised----------------------------------------------------
    public static List < Implementation__c > createImplementationOnAccountInsert(Map < Id, Account > newMap, Map < Id, Account > oldMap, Map < Id, Account > accountsMapAfterQuery, Map < Id, Integer > premiumImpAccMap) {
        List < Implementation__c > implementationToInsertList = new List < Implementation__c > ();
        Map < Id, Implementation__c > accountImplementationMap = new Map < Id, Implementation__c > ();
        Map < String, Integer > accountAndImplementationTrailCountMap = new Map < String, Integer > ();
        Map < String, Integer > accountAndImplementationCountMap = new Map < String, Integer > ();
        Map < Id, List < Contact >> contactMap = new Map < Id, List < Contact >> ();
        Account oldAccount;
        for (Account accByQuery: accountsMapAfterQuery.values()) {
            contactMap.put(accByQuery.Id, accByQuery.contacts);
            //accountImplementationMap.put(accByQuery.Id,accByQuery.Implementations__r);
            accountAndImplementationCountMap.put(accByQuery.Id, accByQuery.Implementations__r.size());
            Integer trailImpCounter = 0;
            for (Implementation__c impl: accByQuery.Implementations__r) {
                if (impl.Implementation_Type__c.equalsIgnoreCase('Trial Account')) {
                    trailImpCounter++;
                    accountAndImplementationTrailCountMap.put(accByQuery.Id, trailImpCounter);
                }
            }

        }

        for (Account newAcc: newMap.values()) {

            if (!String.isBlank(newAcc.RC_Brand__c) && AccountTriggerStaticProperties.RING_CENTRAL.equalsIgnoreCase(newAcc.RC_Brand__c.trim())) {
                System.debug('Hello11');
                if (AccountGateway.toCreateImplementationOnInsOrUpdRing(newAcc, accountAndImplementationCountMap) || (AccountGateway.toCreateImplementationOnInsOrUpdOfficeTrials(newAcc, accountAndImplementationTrailCountMap))) {
                    System.debug('Hello12');
                    Implementation__c impObj = new Implementation__c();
                    impObj.Type__c = AccountTriggerStaticProperties.IMP_NEW;
                    if (!String.isBlank(newAcc.RC_Account_Status__c) && newAcc.RC_Account_Status__c.containsIgnoreCase(AccountTriggerStaticProperties.TRIAL)) {
                        System.debug('Hello13');
                        impObj.Implementation_Type__c = AccountTriggerStaticProperties.TRIAL_ACCOUNT;
                    }
                    if (premiumImpAccMap != null && premiumImpAccMap.get(newAcc.Id) != null && premiumImpAccMap.get(newAcc.Id) > 0) {
                        System.debug('Hello14');
                        impObj.Implementation_Type__c = AccountTriggerStaticProperties.PREMIUM;
                    }
                    accountImplementationMap.put(newAcc.Id, impObj);
                }
            } else if (!String.isBlank(newAcc.RC_Brand__c) && newAcc.RC_Brand__c.trim().containsIgnoreCase(AccountTriggerStaticProperties.TELUS) && AccountGateway.tocreateImplemetationOnInsorUpdForTELUS(newAcc, accountAndImplementationCountMap)) {
                System.debug('Hello15');
                Implementation__c impObj = new Implementation__c();
                impObj.Type__c = AccountTriggerStaticProperties.IMP_NEW;
                if (!String.isBlank(newAcc.RC_Account_Status__c) && newAcc.RC_Account_Status__c.toUpperCase().contains(AccountTriggerStaticProperties.TRIAL)) {
                    System.debug('Hello16');
                    impObj.Implementation_Type__c = AccountTriggerStaticProperties.TRIAL_ACCOUNT;
                }
                if (premiumImpAccMap != null && premiumImpAccMap.get(newAcc.Id) != null && premiumImpAccMap.get(newAcc.Id) > 0) {
                    System.debug('Hello17');
                    impObj.Implementation_Type__c = AccountTriggerStaticProperties.PREMIUM;
                }
                accountImplementationMap.put(newAcc.Id, impObj);
            } else {
                System.debug('Hello18');
                if (AccountTriggerHelper.toCreateImplementationOnInsOrUpd(newAcc)) {
                    System.debug('Hello19');
                    Implementation__c impObj = new Implementation__c();
                    impObj.Type__c = AccountTriggerStaticProperties.IMP_NEW;
                    if (premiumImpAccMap != null && premiumImpAccMap.get(newAcc.Id) != null && premiumImpAccMap.get(newAcc.Id) > 0) {
                        System.debug('Hello20');
                        impObj.Implementation_Type__c = AccountTriggerStaticProperties.PREMIUM;
                    }
                    accountImplementationMap.put(newAcc.Id, impObj);
                }
            }
        }
        System.debug('UserRC.rcsfSyncUserObj.name<<<<'+UserRC.rcsfSyncUserObj.Username__c);
        System.debug('UserCustomSettingHelper.getRCSFSync(UserRC.rcsfSyncUserObj>>>'+UserCustomSettingHelper.getRCSFSync(UserRC.rcsfSyncUserObj.Username__c) );
        if (UserCustomSettingHelper.getRCSFSync(UserRC.rcsfSyncUserObj.Username__c) != null) {

            System.debug('Hello21'+accountImplementationMap);
            for (Id accountId: accountImplementationMap.keySet()) {
                Account thisAccount = accountsMapAfterQuery.get(accountId);
                if (thisAccount != null) {
                    String name = thisAccount.Name;
                    String str = thisAccount.Name + ' - ' + Datetime.now().format();
                    Integer strLength = (str).length();
                    if (strLength > 80) {
                        Integer dateLength = (' - ' + Datetime.now().format()).length();
                        name = (thisAccount.Name).substring(0, (80 - dateLength));
                    }
                    Implementation__c imp = new Implementation__c();
                    if (accountImplementationMap.get(thisAccount.Id) != null) {
                        imp = accountImplementationMap.get(thisAccount.Id);
                    }
                    imp.Name = name + ' - ' + Datetime.now().format();
                    imp.office_service_change_date__c = Date.today();
                    imp.Account__c = thisAccount.Id;
                    imp.Brand__c = thisAccount.RC_Brand__c;
                    imp.Tier__c = thisAccount.RC_Tier__c;
                    imp.Service__c = thisAccount.RC_Service_Name__c;
                    // Logic for setting the owner Id.
                    if (UserRC.getRCSFSyncPrimaryOwnerId != null) {
                        imp.OwnerId = UserRC.getRCSFSyncPrimaryOwnerId;
                    } else {
                        imp.OwnerId = Userinfo.getUserId();
                    }
                    imp.Account_Signup_Date__c = thisAccount.RC_Signup_Date__c;
                    imp.Contact__c = (contactMap == null || contactMap.get(thisAccount.Id).size() == 0 ? null : contactMap.get(thisAccount.Id)[0].Id);

                    implementationToInsertList.add(imp);
                }
            }
        }
        return implementationToInsertList;
    }


    public static List < Account > updateCustomersOnPartnerUpdate(List < Account > accList, Map < Id, Account > oldMap, List < Account > customerAccByQueryList) {
        List < Account > customersForUpdateList = new List < Account > ();
        Map < string, Account > partnerMapWithDoNotCreateImpValueChange = new Map < string, Account > ();
        for (Account objAcc: accList) {

            Account partnerAccountB4 = oldMap.get(objAcc.id);
            if ((partnerAccountB4.Do_Not_Creation_Implementation__c != objAcc.Do_Not_Creation_Implementation__c) && objAcc.Partner_Id__c != null // objAcc.RecordTypeId == '01280000000UERv' 
            &&
            AccountTriggerStaticProperties.accountRecordTypeMapById.get(objAcc.RecordTypeId).getName().equalsIgnoreCase(AccountTriggerStaticProperties.PARTNER_ACCOUNT)) {
                partnerMapWithDoNotCreateImpValueChange.put(objAcc.Partner_Id__c, objAcc);
            }
        }
        Map < String, List < Account >> MapToPartnerLstCustomer = new Map < String, List < Account >> ();
        for (Account customerAccByQuery: customerAccByQueryList) {
            if (partnerMapWithDoNotCreateImpValueChange.containsKey(customerAccByQuery.Partner_Id__c)) {
                if (customerAccByQuery.Do_Not_Creation_Implementation__c != partnerMapWithDoNotCreateImpValueChange.get(customerAccByQuery.Partner_Id__c).Do_Not_Creation_Implementation__c) {
                    customerAccByQuery.Do_Not_Creation_Implementation__c = partnerMapWithDoNotCreateImpValueChange.get(customerAccByQuery.Partner_Id__c).Do_Not_Creation_Implementation__c;
                    customersForUpdateList.add(customerAccByQuery);
                }
            }
        }
        return customersForUpdateList;
    }

    public static List < Survey__c > createVARSurveyOnAccountUpdate(List < Account > newList, Map < Id, Account > oldMap, Map < Id, Account > allAccntsMapAfterQuery, Map < String, Account > partnerAccntContactMap) {
        List < Survey__c > surveyListTOInsert = new List < Survey__c > ();
        String SALES_AGENT_RESELLERS = 'Sales Agents & Resellers';
        for (Account newAcc: newList) {
            Account oldAccount = oldMap.get(newAcc.Id);
            if (newAcc.Is_Demo_Account__c == false && 
                (!String.isBlank(newAcc.RC_Attribution_Channel__c) && SALES_AGENT_RESELLERS.equalsIgnoreCase(newAcc.RC_Attribution_Channel__c)) && 
                oldAccount.RC_Activation_Date__c == null && newAcc.RC_Activation_Date__c != null) {
                    
                if (allAccntsMapAfterQuery != null && allAccntsMapAfterQuery.get(newAcc.id) != null && 
                    allAccntsMapAfterQuery.get(newAcc.id).Surveys__r != null && allAccntsMapAfterQuery.get(newAcc.id).Surveys__r.size() == 0 && 
                    partnerAccntContactMap != null && !String.isBlank(newAcc.Partner_ID__c) && partnerAccntContactMap.get(newAcc.Partner_ID__c) != null && 
                    partnerAccntContactMap.get(newAcc.Partner_ID__c).contacts != null) {
                        
                    List < Contact > partnerAccountContactList = partnerAccntContactMap.get(newAcc.Partner_ID__c).contacts;
                    Survey__c survObj = new Survey__c();
                    survObj.SurveyType__c = 'VAR Customer';
                    survObj.Account__c = newAcc.Id;
                    survObj.Agent__c = newAcc.OwnerId;
                    survObj.Agent_Email__c = allAccntsMapAfterQuery.get(newAcc.id).Owner.Email;
                    survObj.Agent_Name__c = allAccntsMapAfterQuery.get(newAcc.id).Owner.Name;
                    survObj.Agent_Team__c = allAccntsMapAfterQuery.get(newAcc.id).Owner.Team__c;
                    survObj.Agent_Manager_Name__c = allAccntsMapAfterQuery.get(newAcc.id).Owner.Manager.Name;
                    survObj.Agent_Manager_Email__c = allAccntsMapAfterQuery.get(newAcc.id).Owner.Manager.Email;
                    survObj.Name = 'VAR Customer' + ' - ' + Datetime.now().format();
                    if (allAccntsMapAfterQuery.get(newAcc.id).AccountContactRoles != null && allAccntsMapAfterQuery.get(newAcc.id).AccountContactRoles.size() > 0) {
                        AccountContactRole accountContactRoleObj = allAccntsMapAfterQuery.get(newAcc.id).AccountContactRoles;
                        if (partnerAccountContactList != null && partnerAccountContactList.size() > 0) {
                            if (!String.isBlank(accountContactRoleObj.Contact.Email)) {
                                string emaildomain = (accountContactRoleObj.Contact.Email).split('@')[1];
                                boolean domainMatches = false;
                                for (Contact contactObj: partnerAccountContactList) {
                                    if (!string.isBlank(contactObj.email) && contactObj.email.split('@')[1] == emaildomain) {
                                        domainMatches = true;
                                        break;
                                    }
                                }
                                if (!domainMatches) {
                                    survObj.Contact__c = accountContactRoleObj.Contact.id;
                                    survObj.Contact_Email__c = accountContactRoleObj.Contact.Email;

                                }
                            }
                        }
                    } else if (allAccntsMapAfterQuery.get(newAcc.id).Contacts != null && allAccntsMapAfterQuery.get(newAcc.id).Contacts.size() > 0) {
                        List < Contact > contList = allAccntsMapAfterQuery.get(newAcc.id).Contacts;
                        if (partnerAccountContactList != null && partnerAccountContactList.size() > 0) {
                            for (Contact contactObjAcc: contList) {
                                if (!string.isBlank(contactObjAcc.Email)) {
                                    string emaildomain = (contactObjAcc.Email).split('@')[1];
                                    boolean domainMatches = false;
                                    for (Contact contactPartnerObj: partnerAccountContactList) {
                                        if (!string.isBlank(contactPartnerObj.email) && contactPartnerObj.email.split('@')[1] == emaildomain) {
                                            domainMatches = true;
                                            break;
                                        }
                                    }
                                    if (!domainMatches) {
                                        survObj.Contact__c = contactObjAcc.id;
                                        survObj.Contact_Email__c = contactObjAcc.Email;

                                    }
                                }
                            }
                        }
                    }
                    if (survObj != null) {
                        surveyListTOInsert.add(survObj);
                    }
                }
            }
        }
        return surveyListTOInsert;
    }


    public static List < Implementation__c > changeImplementationForCanceledAccounts(List < Account > newList, Map < Id, Account > oldMap, Map < Id, Account > allAccountsAfterQuery) {
        List < Implementation__c > implementationListToUpdate = new List < Implementation__c > ();
        for (Account newAcc: newList) {
            Account oldAccount = oldMap.get(newAcc.Id);
            if (AccountTriggerStaticProperties.CANCELED.equalsIgnoreCase(newAcc.RC_account_Status__c) && 
                !AccountTriggerStaticProperties.CANCELED.equalsIgnoreCase(oldAccount.RC_Account_Status__c)) {

                for (Implementation__c thisImplementation: allAccountsAfterQuery.get(newAcc.Id).Implementations__r) {
                    //Updated by India Team for Case#02405558 on 25/04/2014
                    if (!AccountTriggerStaticProperties.implementationStatusSetOnAccount.contains(thisImplementation.Implementation_Status_2__c)) {

                        thisImplementation.Implementation_Status_2__c = AccountTriggerStaticProperties.COMPLETED_ACCOUNT_CANCELLED;
                        implementationListToUpdate.add(thisImplementation);
                    }
                }
            }
        }
        return implementationListToUpdate;
    }


    public static List < Sobject > sendEmailsForContracts(List < Account > newList, map < Id, Account > oldMap, Map < Id, List < Contract >> AcctContractMap) {
        List < Exception_And_Notification_History__c > ExceptionAndNotificationList = new List < Exception_And_Notification_History__c > ();
        for (Account newAccount: newList) {
            Account oldAccount = oldMap.get(newAccount.Id);
            if (oldAccount.RC_Activation_Date__c == null && oldAccount.RC_Activation_Date__c != newAccount.RC_Activation_Date__c && 
                AccountTriggerStaticProperties.RC_OFFICE.equalsIgnoreCase(newAccount.RC_Service_name__c)) {

                if (AcctContractMap != null && AcctContractMap.containsKey(newAccount.Id)) {
                    for (Contract thisContract: AcctContractMap.get(newAccount.Id)) {
                        if (thisContract != null) {
                            Exception_And_Notification_History__c exeNotificationObj = new Exception_And_Notification_History__c();
                            exeNotificationObj.Sender_Display_Name__c = 'SFDC Account Alert';
                            exeNotificationObj.Email_Subject__c = 'Please review this Account Contract';
                            exeNotificationObj.To_Address_1__c = thisContract.Owner.Email;
                            exeNotificationObj.Reply_To__c = UserRC.rcsfSyncUserObj.Email__c;
                            exeNotificationObj.Object_Type__c = 'Account';
                            exeNotificationObj.content_label_01__c = 'SFDC_ACCOUNT_CONTRACT_NOTIFICATION';
                            exeNotificationObj.content_var_01__c = thisContract.Id;
                            exeNotificationObj.RecordTypeId = ExceptionAndNotificationHelper.getRcId('Email Notification');
                            ExceptionAndNotificationList.add(exeNotificationObj);
                        }
                    }
                }
            }
        }
        return (List < Sobject > ) ExceptionAndNotificationList;
    }


    public static List < Lead > createLeadOnAccountUpdate(List < Account > newList, Map < Id, Account > oldMap, Map < Id, Account > accountsMapAfterQuery) {
        List < Lead > bucketLeadList = new List < Lead > ();
        Map < Id, List < Contact >> contactMap = new Map < Id, List < Contact >> ();
        Map < Id, Lead > accountLeadMap = new Map < Id, Lead > ();
        Account oldAccount;
        for (Account accByQuery: accountsMapAfterQuery.values()) {
            contactMap.put(accByQuery.Id, accByQuery.contacts);
        }

        for (Account accByQuery: accountsMapAfterQuery.values()) {
            oldAccount = oldMap.get(accByQuery.Id);
            Lead newLead = new Lead();
            Contact contactObj;
            if (accByQuery.AccountContactRoles != null && accByQuery.AccountContactRoles.size() > 0) {
                contactObj = accByQuery.AccountContactRoles[0].Contact;
            } else if (contactMap != null && contactMap.containsKey(accByQuery.Id) && contactMap.get(accByQuery.Id).size() > 0) {
                contactObj = contactMap.get(accByQuery.Id)[0];

            }
            if (contactObj != null) {
                newLead.Phone = contactObj.Phone;
                newLead.LastName = (String.isBlank(contactObj.LastName) ? accByQuery.Name : contactObj.LastName);
                newLead.LastName = contactObj.LastName;
                newLead.FirstName = contactObj.FirstName;
                newLead.Email = (String.isBlank(contactObj.Email) ? 'fake@email.com' : contactObj.Email);
                newLead.Email = contactObj.Email;
                newLead.Account_Status__c = accByQuery.RC_Account_Status__c;
                newLead.Account_Number__c = accByQuery.RC_Account_Number__c;
                newLead.User_ID__c = accByQuery.RC_User_ID__c;
                newLead.Lead_Tier_Name__c = accByQuery.RC_Tier__c;
                newLead.RC_Service_name__c = accByQuery.RC_Service_name__c;
                newLead.Lead_Brand_Name__c = accByQuery.RC_Brand__c;
                newLead.Company = accByQuery.Name;
                newLead.Status = 'Open - Not Contacted';
                newLead.Partner_Company_Name__c = 'TBD';
                newLead.Account__c = accByQuery.id;
                if (contactObj.NumberOfEmployees__c != null) {
                    newLead.NumberOfEmployees__c = contactObj.NumberOfEmployees__c;
                } else if (contactObj.Account.No_of_Employees__c != null) {
                    newLead.NumberOfEmployees__c = contactObj.Account.No_of_Employees__c;
                }

            } else {
                newLead.Email = 'fake@fake.com';
                newLead.LastName = 'fakeLead';
                newLead.Company = accByQuery.Name;
                newLead.Partner_Company_Name__c = 'TBD';
                if (accByQuery != null && accByQuery.No_of_Employees__c != null) {
                    newLead.NumberOfEmployees__c = accByQuery.No_of_Employees__c;
                }
            }

            accountLeadMap.put(accByQuery.Id, newLead);
        }
        for (Account newAcc: newList) {
            Lead newLead = accountLeadMap.get(newAcc.Id);
            oldAccount = oldMap.get(newAcc.Id);
            System.debug(newAcc+'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~``newAcc');
            System.debug(oldAccount+'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~``oldAccount');
            if (!String.isBlank(newAcc.SignupType__c)) {
                if ((String.isBlank(newAcc.SignupPlatform__c) || 
                    ((!String.isBlank(newAcc.SignupPlatform__c) && AccountTriggerStaticProperties.WEB.equalsIgnoreCase(newAcc.SignupPlatform__c.trim())))) && 
                    AccountTriggerStaticProperties.TRIAL_30NOCC.equalsIgnoreCase(newAcc.SignupType__c.trim()) && newLead != null) {

                    newLead.LeadSource = AccountTriggerStaticProperties.TRIAL_30d_NO_CC_WEB;
                } else if (!String.isBlank(newAcc.SignupPlatform__c) && !String.isBlank(AccountTriggerStaticProperties.mobLeadSources.get(newAcc.SignupPlatform__c.trim())) && (AccountTriggerStaticProperties.TRIAL_30NOCC.equalsIgnoreCase(newAcc.SignupType__c.trim()) || AccountTriggerStaticProperties.TRIAL_NOCC.equalsIgnoreCase(newAcc.SignupType__c.trim())) && newLead != null) {
                    newLead.LeadSource = AccountTriggerStaticProperties.TRIAL_30d_NO_CC_MOB;
                }
                if (!String.isBlank(newAcc.RC_Account_Status__c) && !AccountTriggerStaticProperties.DWH_SYNC_PENDING.equalsIgnoreCase(newAcc.RC_Account_Status__c.trim()) && newAcc.RC_Account_Status__c.containsIgnoreCase(AccountTriggerStaticProperties.TRIAL)) {

                    bucketLeadList.add(newLead);
                }
            } else if (String.isBlank(newAcc.SignupType__c) && String.isBlank(newAcc.SignupPlatform__c) && 
                    (!String.isBlank(newAcc.RC_Account_Status__c) && AccountTriggerStaticProperties.TRIAL_30_NO_CC.equalsIgnoreCase(newAcc.RC_Account_Status__c.trim())) && 
                    oldMap != null && (String.isBlank(oldAccount.RC_Account_Status__c) || !AccountTriggerStaticProperties.TRIAL_30_NO_CC.equalsIgnoreCase(oldAccount.RC_Account_Status__c.trim()))) {

                if (newLead != null) {
                    newLead.LeadSource = AccountTriggerStaticProperties.TRIAL_30d_NO_CC_WEB;
                    bucketLeadList.add(newLead);
                }
            } else if (((oldAccount.RC_Account_Status__c != newAcc.RC_Account_Status__c) || (oldAccount.Service_Type__c != newAcc.Service_Type__c)) && 
                    accountsMapAfterQuery.get(newAcc.Id).Opportunities.size() == 0) {

                newLead.LeadSource = 'Office Trials';
                String sUrlRewrite = System.URL.getSalesforceBaseUrl().getHost();
                sUrlRewrite = 'https://' + sUrlRewrite + '/' + newAcc.id;
                newLead.Description = 'Office Free Trial Account Signup - Link to Account ' + sUrlRewrite;
                bucketLeadList.add(newLead);
            } else if (!String.isBlank(newAcc.RC_Account_Status__c) && !String.isBlank(oldAccount.RC_Account_Status__c) && 
                    AccountTriggerStaticProperties.DISABLED.equalsIgnoreCase(newAcc.RC_Account_Status__c.trim())) {
                        System.debug('Inside my if else check----');
                if (accountsMapAfterQuery != null && accountsMapAfterQuery.get(newAcc.Id) != null && 
                    contactMap != null && contactMap.get(newAcc.Id) != null && accountsMapAfterQuery.get(newAcc.Id).RC_User_ID__c != null) {

                    newLead = null;
                    if ((oldAccount.RC_Account_Status__c.containsIgnoreCase(AccountTriggerStaticProperties.TRIAL))) {

                        newLead = new Lead(
                        FirstName = contactMap.get(newAcc.Id)[0].FirstName,
                        LastName = contactMap.get(newAcc.Id)[0].LastName,
                        Company = newAcc.Name,
                        Email = contactMap.get(newAcc.Id)[0].Email,
                        Phone = contactMap.get(newAcc.Id)[0].Phone,
                        LeadSource = AccountTriggerStaticProperties.CANCELLED_TRIAL,
                        Lead_Score__c = 'B',
                        timezone__c = newAcc.Timezone__c,
                        Industry = newAcc.Industry,
                        User_ID__c = accountsMapAfterQuery.get(newAcc.Id).RC_User_ID__c,
                        Partner_Company_Name__c = 'TBD');
                        bucketLeadList.add(newLead);

                    }
                }
            }
        }
        return bucketLeadList;
    }


    //---------------------------As/Simplion/5/12/2015-------------------------------------------
    //--------------Pending method for implementation functionality
    public static List < Implementation__c > createImplementationForAccounts(Map < Id, Account > newMap, Map < Id, Account > oldMap, Map < Id, Account > accountsMapAfterQuery, Map < Id, Integer > premiumImpAccMap) {
        List < Implementation__c > implementationListToInsert = new List < Implementation__c > ();
        Map < Id, Implementation__c > accountImplementationMap = new Map < Id, Implementation__c > ();
        Map < String, Integer > accountAndImplementationTrailCountMap = new Map < String, Integer > ();
        Map < String, Integer > accountAndImplementationCountMap = new Map < String, Integer > ();
        Map < Id, List < Contact >> contactMap = new Map < Id, List < Contact >> ();
        String BT_BUSINESS = '';
        BT_BUSINESS = RcDealHealper.getBTBrand();
        Account oldAccount;
        Account newAccount;
        for (Account accByQuery: accountsMapAfterQuery.values()) {
            contactMap.put(accByQuery.Id, accByQuery.contacts);
            accountAndImplementationCountMap.put(accByQuery.Id, accByQuery.Implementations__r.size());
            Integer trailImpCounter = 0;
            for (Implementation__c impl: accByQuery.Implementations__r) {
                if (impl.Implementation_Type__c.equalsIgnoreCase('Trial Account')) {
                    trailImpCounter++;
                    accountAndImplementationTrailCountMap.put(accByQuery.Id, trailImpCounter);
                }
            }
        }
        for (Account thisAccount: newMap.values()) {
            if (AccountTriggerStaticProperties.accountRecordTypeMapById.get(thisAccount.RecordTypeId).getName() == AccountTriggerStaticProperties.CUSTOMER_ACCOUNT) {
                oldAccount = oldMap.get(thisAccount.Id);
                newAccount = thisAccount;
                if (!String.isBlank(thisAccount.RC_Brand__c) && AccountTriggerStaticProperties.RING_CENTRAL.equalsIgnoreCase(thisAccount.RC_Brand__c.trim())) {
                    Integer oldDL = (oldAccount.Number_of_DL_s__c == null ? 0 : Integer.valueOf(oldAccount.Number_of_DL_s__c));
                    Integer newDL = (thisAccount.Number_of_DL_s__c == null ? 0 : Integer.valueOf(thisAccount.Number_of_DL_s__c));

                    if ((oldDL != newDL) || (oldAccount.RC_Service_name__c != thisAccount.RC_Service_name__c) || 
                        (oldAccount.RC_User_ID__c != thisAccount.RC_User_ID__c) || (oldAccount.RC_Account_Status__c != thisAccount.RC_Account_Status__c)) {
                        
                        if (AccountGateway.toCreateImplementationOnInsOrUpdRing(thisAccount, accountAndImplementationCountMap) || 
                            (AccountGateway.toCreateImplementationOnInsOrUpdOfficeTrials(thisAccount, accountAndImplementationTrailCountMap) && 
                            (oldAccount.RC_Account_Status__c != thisAccount.RC_Account_Status__c))) {
                                
                            Implementation__c impObj = new Implementation__c();
                            impObj.Type__c = AccountTriggerStaticProperties.IMP_NEW;
                            if (!String.isBlank(thisAccount.RC_Account_Status__c) && (thisAccount.RC_Account_Status__c.containsIgnoreCase(AccountTriggerStaticProperties.TRIAL))) {
                                impObj.Implementation_Type__c = AccountTriggerStaticProperties.TRIAL_ACCOUNT;
                            }
                            if (premiumImpAccMap != null && premiumImpAccMap.get(thisAccount.Id) != null && premiumImpAccMap.get(thisAccount.Id) > 0) {
                                impObj.Implementation_Type__c = AccountTriggerStaticProperties.PREMIUM;
                            }
                            accountImplementationMap.put(thisAccount.Id, impObj);
                        }
                    }
                } else if (!String.isBlank(thisAccount.RC_Brand__c) && thisAccount.RC_Brand__c.trim().containsIgnoreCase(AccountTriggerStaticProperties.TELUS) && 
                        AccountGateway.tocreateImplemetationOnInsorUpdForTELUS(thisAccount, accountAndImplementationCountMap)) {

                    if ((oldAccount.RC_Service_name__c != thisAccount.RC_Service_name__c) || (oldAccount.RC_User_ID__c != thisAccount.RC_User_ID__c) || 
                        (oldAccount.RC_Account_Status__c != thisAccount.RC_Account_Status__c) || 
                        ((oldAccount.RC_Brand__c != thisAccount.RC_Brand__c) && (String.isBlank(oldAccount.RC_Brand__c) || 
                            !oldAccount.RC_Brand__c.trim().containsIgnoreCase(AccountTriggerStaticProperties.TELUS)))) {

                        Implementation__c impObj = new Implementation__c();
                        impObj.Type__c = AccountTriggerStaticProperties.IMP_NEW;
                        if (!String.isBlank(thisAccount.RC_Account_Status__c) && thisAccount.RC_Account_Status__c.toUpperCase().contains(AccountTriggerStaticProperties.TRIAL)) {
                            impObj.Implementation_Type__c = AccountTriggerStaticProperties.TRIAL_ACCOUNT;
                        }
                        if (premiumImpAccMap != null) {
                            if (premiumImpAccMap.get(thisAccount.Id) != null && premiumImpAccMap.get(thisAccount.Id) > 0) {
                                impObj.Implementation_Type__c = AccountTriggerStaticProperties.PREMIUM;
                            }
                        }
                        accountImplementationMap.put(thisAccount.Id, impObj);
                    }

                } else if (!String.isBlank(thisAccount.RC_Brand__c) && 
                        (thisAccount.RC_Brand__c.trim().containsIgnoreCase(AccountTriggerStaticProperties.BT_CLOUD_PHONE) || thisAccount.RC_Brand__c.trim().containsIgnoreCase(BT_BUSINESS)) && 
                        AccountTriggerHelper.tocreateImplemetationOnInsorUpdForBT(thisAccount, accountAndImplementationCountMap)) {

                    if ((oldAccount.RC_User_ID__c != thisAccount.RC_User_ID__c) || 
                        (oldAccount.RC_Account_Status__c != thisAccount.RC_Account_Status__c) || 
                        ((oldAccount.RC_Brand__c != thisAccount.RC_Brand__c) && (String.isBlank(oldAccount.RC_Brand__c) || 
                            !oldAccount.RC_Brand__c.trim().containsIgnoreCase(AccountTriggerStaticProperties.BT_CLOUD_PHONE) || 
                            !oldAccount.RC_Brand__c.trim().containsIgnoreCase(BT_BUSINESS)))) {

                        Implementation__c impObj = new Implementation__c();
                        impObj.Type__c = AccountTriggerStaticProperties.IMP_NEW;
                        if (!String.isBlank(thisAccount.RC_Account_Status__c) && thisAccount.RC_Account_Status__c.toUpperCase().contains(AccountTriggerStaticProperties.TRIAL)) {
                            impObj.Implementation_Type__c = AccountTriggerStaticProperties.TRIAL_ACCOUNT;
                        }
                        if (premiumImpAccMap != null) {
                            if (premiumImpAccMap.get(thisAccount.Id) != null && premiumImpAccMap.get(thisAccount.Id) > 0) {
                                impObj.Implementation_Type__c = AccountTriggerStaticProperties.PREMIUM;
                            }
                        }
                        accountImplementationMap.put(thisAccount.Id, impObj);
                    }
                } else if (AccountTriggerHelper.toCreateImplementationOnUpd(thisAccount, oldAccount, accountAndImplementationCountMap)) {
                    Implementation__c impObj = new Implementation__c();
                    impObj.Type__c = AccountTriggerStaticProperties.IMP_NEW;
                    if (!String.isBlank(thisAccount.RC_Account_Status__c) && 
                        (thisAccount.RC_Account_Status__c.containsIgnoreCase(AccountTriggerStaticProperties.TRIAL))) {
                            
                        impObj.Implementation_Type__c = AccountTriggerStaticProperties.TRIAL_ACCOUNT;
                    }
                    if (premiumImpAccMap != null) {
                        if (premiumImpAccMap.get(thisAccount.Id) != null && premiumImpAccMap.get(thisAccount.Id) > 0) {
                            impObj.Implementation_Type__c = AccountTriggerStaticProperties.PREMIUM;
                        }
                    }
                    accountImplementationMap.put(thisAccount.Id, impObj);
                }
            }
        }

        if (UserCustomSettingHelper.getRCSFSync(UserRC.rcsfSyncUserObj.username__c) != null) {
            for (Id accountId: accountImplementationMap.keySet()) {
                Account thisAccount = newMap.get(accountId);
                if (thisAccount != null) {
                    String name = thisAccount.Name;
                    String str = thisAccount.Name + ' - ' + Datetime.now().format();
                    Integer strLength = (str).length();
                    if (strLength > 80) {
                        Integer dateLength = (' - ' + Datetime.now().format()).length();
                        name = (thisAccount.Name).substring(0, (80 - dateLength));
                    }
                    Implementation__c imp = new Implementation__c();
                    if (accountImplementationMap.get(thisAccount.Id) != null) {
                        imp = accountImplementationMap.get(thisAccount.Id);
                    }
                    imp.Name = name + ' - ' + Datetime.now().format();
                    imp.office_service_change_date__c = Date.today();
                    imp.Account__c = thisAccount.Id;
                    imp.Brand__c = thisAccount.RC_Brand__c;
                    imp.Tier__c = thisAccount.RC_Tier__c;
                    imp.Service__c = thisAccount.RC_Service_Name__c;
                    if (UserRC.getRCSFSyncPrimaryOwnerId != null) {
                        imp.OwnerId = UserRC.getRCSFSyncPrimaryOwnerId;
                    } else {
                        imp.OwnerId = Userinfo.getUserId();
                    }
                    imp.Account_Signup_Date__c = thisAccount.RC_Signup_Date__c;
                    if (contactMap != null && contactMap.size() > 0 && contactMap.get(thisAccount.Id) != null && contactMap.get(thisAccount.Id).size() > 0) {
                        imp.Contact__c = contactMap.get(thisAccount.Id)[0].Id;
                    } else {
                        imp.Contact__c = null;
                    }
                    implementationListToInsert.add(imp);
                }
            }
        }
        return implementationListToInsert;
    }

    //--------------------------As/Simplion/4/9/2015------------------------------------------------------------------
    //---------------------------This method is rewritten for updateRelatedContactAccount method and optimized to reduce SOQL and CPU time--------------------
    //---------------------------New Optimized----------------------------------------------------------------------------- 
    public static List < Contact > updatePaidAccountRelatedContacts(list < Account > lsttAcc, Map < Id, Account > allAccountsMap) {
        List < Contact > paidAccountRelatedContactsToUpdate = new List < Contact > ();
        for (Account paidAccount: lsttAcc) {
            for (Contact cont: allAccountsMap.get(paidAccount.Id).contacts) {
                if (!String.isBlank(paidAccount.RC_Account_Status__c) && 'Paid'.equalsIgnoreCase(paidAccount.RC_Account_Status__c.trim())) {

                    if (cont.isCustomer__c != True || !cont.Contact_Status__c.equalsIgnoreCase('Closed Won') || !cont.Contact_Funnel_Type__c.equalsIgnoreCase('Customer') || !cont.People_Segment__c.equalsIgnoreCase('Customer')) {
                        cont.isCustomer__c = True;
                        cont.Contact_Status__c = 'Closed Won';
                        cont.Contact_Funnel_Type__c = 'Customer';
                        cont.People_Segment__c = 'Customer';
                        paidAccountRelatedContactsToUpdate.add(cont);
                    }
                } else if (!String.isBlank(paidAccount.RC_Account_Status__c) && 'Canceled'.equalsIgnoreCase(paidAccount.RC_Account_Status__c.trim())) {
                    if (cont.isCustomer__c != False || !cont.Contact_Status__c.equalsIgnoreCase('Canceled') || !cont.Contact_Funnel_Type__c.equalsIgnoreCase('Winback') || !cont.People_Segment__c.equalsIgnoreCase('Former Customer')) {
                        cont.isCustomer__c = False;
                        cont.Contact_Status__c = 'Canceled';
                        cont.Contact_Funnel_Type__c = 'Winback';
                        cont.People_Segment__c = 'Former Customer';
                        paidAccountRelatedContactsToUpdate.add(cont);
                    }
                }
            }
        }
        return paidAccountRelatedContactsToUpdate;
    }

    //---------------------------------New Optimized----------------------------------------------------
    public static List < Account > calculateAccountHierarchyTotalDLS(Set < String > setOfUltimateParentId,List < Account > accMainList) {
        List < Account > updatedAccountList = new List < Account > ();
        if (setOfUltimateParentId != null && setOfUltimateParentId.size() > 0) {
            map < Id, decimal > parentCounterMap = new map < Id, decimal > ();
            map < Id, List < Account >> childAccountMap = new map < Id, List < Account >> ();
            
            for (Account accObj: accMainList) {
                // Only re-evaluate the hierarchy if it is either Ultimate Parent or any 'Paid' Account.
                if (accObj.RC_Account_Status__c != 'Paid' && string.valueOf(accObj.Ultimate_Parent_Account_ID__c).subString(0, 15) != string.valueOf(accObj.id).subString(0, 15)) {
                    continue;
                }
                Id accountId = null;
                if (accObj.Ultimate_Parent_Account_ID__c != null) {
                    accountId = accObj.Ultimate_Parent_Account_ID__c;
                } else {
                    accountId = accObj.Id;
                }
                if (parentCounterMap != null && parentCounterMap.get(accountId) != null) {
                    decimal counterValue = parentCounterMap.get(accountId);
                    counterValue += (accObj.Number_of_DL_s__c != null ? accObj.Number_of_DL_s__c : 0);
                    parentCounterMap.put(accountId, counterValue);
                    if (childAccountMap != null && childAccountMap.get(accountId) != null) {
                        List < Account > tempList = childAccountMap.get(accountId);
                        tempList.add(accObj);
                        childAccountMap.put(accountId, tempList);
                    } else {
                        childAccountMap.put(accountId, new List < Account > {
                            accObj
                        });
                    }
                } else {
                    parentCounterMap.put(accountId, (accObj.Number_of_DL_s__c != null ? accObj.Number_of_DL_s__c : 0));
                    childAccountMap.put(accountId, new List < Account > {
                        accObj
                    });
                }
            }
            for (Id idValue: childAccountMap.keySet()) {
                for (Account accObj: childAccountMap.get(idValue)) {
                    if (parentCounterMap != null && parentCounterMap.get(idValue) != null) {
                        accObj.Total_DLs__c = parentCounterMap.get(idValue);
                        updatedAccountList.add(accObj);
                    }
                }
            }

        }
        return updatedAccountList;
    }
    //-------------------------------------------Method Ends-------------------------------------------------------------------------      

    //-------------------------------------------Utility Methods----------------------------------------------------------------------
    //------------------------------As/Simplion/5/26/2015------------------------------------------------
    //------------------------------New Optimized-------------------------------------------------------
    public static String formatPhoneNumberWithCode(String originalPhoneNumber) {
        return (originalPhoneNumber.length() == 10 ? '1' + originalPhoneNumber : originalPhoneNumber);
    }
    //------------------------------As/Simplion/5/26/2015------------------------------------------------
    //------------------------------New Optimized-------------------------------------------------------
    public static String formatPhoneNumberWithoutCode(String originalPhoneNumber) {
        return (originalPhoneNumber.length() == 11 ? originalPhoneNumber.substring(1, originalPhoneNumber.length()) : originalPhoneNumber);
    }


    public static boolean toCreateImplementationOnInsOrUpdRing(Account newAccount, Map < String, Integer > mapAccountImplementation1) {
        System.debug('inside toCreateImplementationOnInsOrUpdRing>>'+mapAccountImplementation1);
        System.debug('inside toCreateImplementationOnInsOrUpdRing newAccount'+newAccount.id);
        System.debug('inside toCreateImplementationOnInsOrUpdRing newAccount.RC_Service_Name__c'+newAccount.RC_Service_Name__c);
        System.debug('inside toCreateImplementationOnInsOrUpdRing newAccount.Number_of_DL_s__c'+newAccount.Number_of_DL_s__c);
        System.debug('inside toCreateImplementationOnInsOrUpdRing newAccount.RC_User_Id__c'+newAccount.RC_User_Id__c);
        System.debug('inside toCreateImplementationOnInsOrUpdRing newAccount.RC_Account_Status__c'+newAccount.RC_Account_Status__c);
        System.debug('inside toCreateImplementationOnInsOrUpdRing newAccount.Do_Not_Creation_Implementation__c'+newAccount.Do_Not_Creation_Implementation__c);
        if ((!String.isBlank(newAccount.RC_Service_Name__c) && newAccount.RC_Service_Name__c.trim().containsIgnoreCase('Office')) && 
            (newAccount.Number_of_DL_s__c != null && ((newAccount.Number_of_DL_s__c >= 2) || (newAccount.Number_of_DL_s__c < 2 && newAccount.Partner_ID__c != null))) && 
            (!String.isBlank(newAccount.RC_User_Id__c)) &&
            (newAccount.RC_Account_Status__c != null && (newAccount.RC_Account_Status__c.equalsIgnoreCase('Paid') || newAccount.RC_Account_Status__c.containsIgnoreCase('Trial'))) && 
            (newAccount.Do_Not_Creation_Implementation__c == false)&& 
            (0 == (mapAccountImplementation1.get(newAccount.Id) == null ? 0 : mapAccountImplementation1.get(newAccount.Id)))) {
            
            return true;
        }
        return false;
    }

    public static boolean toCreateImplementationOnInsOrUpd(Account newAccount) {
        if ((!String.isBlank(newAccount.RC_Service_Name__c) && newAccount.RC_Service_Name__c.trim().containsIgnoreCase('Office'))) {
            
            return true;
        }
        return false;
    }

    public static boolean toCreateImplementationOnUpd(Account newAccount, Account oldAccount, Map < String, Integer > mapAccountImplementation1) {
        if ((String.isBlank(oldAccount.RC_Service_Name__c) || !oldAccount.RC_Service_Name__c.trim().containsIgnoreCase('Office')) && 
            (!String.isBlank(newAccount.RC_Service_Name__c) && newAccount.RC_Service_Name__c.trim().containsIgnoreCase('Office')) && 
            (0 == (mapAccountImplementation1.get(newAccount.Id) == null ? 0 : mapAccountImplementation1.get(newAccount.Id)))) {
            
            return true;
        }
        return false;
    }

    public static boolean toCreateImplementationOnInsOrUpdOfficeTrials(Account newAccount, Map < String, Integer > mapAccountImplementation1) {
        if ((!String.isBlank(newAccount.RC_Account_Status__c) && newAccount.RC_Account_Status__c.trim().equalsIgnoreCase('30-Day Office Trial')) && 
            (0 == (mapAccountImplementation1.get(newAccount.Id) == null ? 0 : mapAccountImplementation1.get(newAccount.Id)))) {
            return true;
        }
        return false;
    }

    public static boolean tocreateImplemetationOnInsorUpdForTELUS(Account newAccount, Map < String, Integer > mapAccountImplementation1) {
        if ((!String.isBlank(newAccount.RC_Service_Name__c) && newAccount.RC_Service_Name__c.trim().containsIgnoreCase('Office')) && 
            (!String.isBlank(newAccount.RC_User_Id__c)) && 
            (newAccount.RC_Account_Status__c != null && (newAccount.RC_Account_Status__c.equalsIgnoreCase('Paid') || newAccount.RC_Account_Status__c.containsIgnoreCase('Trial'))) && 
            (newAccount.Do_Not_Creation_Implementation__c != null && newAccount.Do_Not_Creation_Implementation__c == false) && 
            (0 == (mapAccountImplementation1.get(newAccount.Id) == null ? 0 : mapAccountImplementation1.get(newAccount.Id)))) {
            
            return true;
        }
        return false;
    }

    public static boolean tocreateImplemetationOnInsorUpdForBT(Account newAccount, Map < String, Integer > mapAccountImplementation1) {
        if ((!String.isBlank(newAccount.RC_Service_Name__c) && newAccount.RC_Service_Name__c.trim().containsIgnoreCase('Office')) && 
            (!String.isBlank(newAccount.RC_User_Id__c)) && 
            (newAccount.RC_Account_Status__c != null && (newAccount.RC_Account_Status__c.equalsIgnoreCase('Paid'))) && 
            (newAccount.Do_Not_Creation_Implementation__c != null && newAccount.Do_Not_Creation_Implementation__c == false) && 
            (0 == (mapAccountImplementation1.get(newAccount.Id) == null ? 0 : mapAccountImplementation1.get(newAccount.Id)))) {
            
            return true;
        }
        return false;
    }

    public static boolean chkToCreateLeadForOfficeTrails(Account newAccount, map < Id, Account > accountMap) {  
        
        System.debug ('check for all errors~~~~~~~~~~~~~'+accountMap);  
        System.debug(newAccount+'~~~~~~~~~~~~1');
         System.debug( newAccount.id +'~~~~~~~~~~~~2');
          System.debug(String.isNotBlank(newAccount.Service_Type__c)+'~~~~~~~~~~~~3'); 
         //System.debug(newAccount.Service_Type__c.equalsIgnoreCase('Office')+'~~~~~~~~~~~~4');
          System.debug( (String.isNotBlank(newAccount.RC_Account_Status__c))+'~~~~~~~~~~~~5');
          //  System.debug(newAccount.RC_Account_Status__c.trim().equalsIgnoreCase('Trial 30 CC')+'~~~~~~~~~~~~6');
             System.debug( accountMap +'~~~~~~~~~~~~7'); 
              //System.debug( accountMap.get(newAccount.id) +'~~~~~~~~~~~~8' );
               //System.debug( (accountMap.get(newAccount.id).Opportunities )+'~~~~~~~~~~~~9');
                //System.debug( accountMap.get(newAccount.id)+'~~~~~~~~~~~~10');
                 //System.debug( (UserCustomSettingHelper.userRCSFName(accountMap.get(newAccount.id).CreatedBy.username))+'~~~~~~~~~~~~11');
        
        if (newAccount != null && newAccount.id != null && String.isNotBlank(newAccount.Service_Type__c) && 
            newAccount.Service_Type__c.equalsIgnoreCase('Office') && 
            (String.isNotBlank(newAccount.RC_Account_Status__c) && newAccount.RC_Account_Status__c.trim().equalsIgnoreCase('Trial 30 CC')) && 
            accountMap != null && accountMap.get(newAccount.id) != null && (accountMap.get(newAccount.id).Opportunities.size() == 0) &&                     
             (UserCustomSettingHelper.userRCSFName(accountMap.get(newAccount.id).CreatedBy.username))) {              
            return true;
        } else {
            return false;
        }
    }
}