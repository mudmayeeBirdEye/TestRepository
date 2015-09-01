public class AccountTriggerHelperExt {

    //VARIABLE DECLARATION
    private static final String PARTNER = 'Partner'; 
    private static final String CUSTOMER = 'Customer';
    public  static final String CUSTOMER_ACCOUNT = 'Customer Account';
    public static final String PARTNER_ACCOUNT = 'Partner Account'; 
    public static final String SALES_OPPORTUNITY = 'Sales Opportunity';
    private static final String CLOSED = 'Closed';
    private static Map<Id, List<Case>> caseAccountMap = new Map<Id, List<Case>>();
 
    //Declaring Updated Account Map and Older Account Map. 
    public static Profile currentLoggedInProfile{get{
        if(currentLoggedInProfile != null){
            return currentLoggedInProfile;
        }else{
            currentLoggedInProfile = [SELECT Id,Name,(SELECT Id,Name,FirstName,LastName,Email,Phone FROM Users where Id= : Userinfo.getUserId() Limit 1) FROM Profile Where Id = : Userinfo.getProfileId() LIMIT 1];
            return currentLoggedInProfile;
        }
    }set;}
    //------------------------New property/as/simplion/------------------------------
    public static Set < Id > userIds = new set<Id>();
    public static set<String> AllRecordsPartnerId = new set<String>();
    public static List<Account> allNewAccountMapQuery = new List<Account>();
    public static List<Account> accountsListForUpdateForCreditCounter = new List<Account>();
    public static Map<Id,User> allUserMap{get{
        if(allUserMap != null){
            return allUserMap;
        }
        else{
            allUserMap = new Map<Id,User>([SELECT Phone, Email,FirstName, LastName, Name FROM User WHERE Id IN :AccountTriggerHelperExt.userIds]);
            return allUserMap;
        }
    }set;}
    
    public static Map < String, Schema.RecordTypeInfo > caseRecordTypeMapByName{
        get{
            if(caseRecordTypeMapByName != null){
                return caseRecordTypeMapByName;
            }else{
                Schema.DescribeSObjectResult result = Case.SObjectType.getDescribe();
                caseRecordTypeMapByName = result.getRecordTypeInfosByName();
                return caseRecordTypeMapByName;
            }
        }set;
    }
    public static Map<Id,SlaProcess> SlaProcessMap{
        get{
            if(SlaProcessMap != null){
                return SlaProcessMap;
            }else{
                return new Map<Id,SlaProcess>([SELECT Id, Name FROM SlaProcess WHERE IsActive=true]);   
            }
        }set;
    }  
    public static Map<Id,BusinessHours> businessHrsMap{
        get{
            if(businessHrsMap != null){
                return businessHrsMap;
            }else{
                return new Map<Id,BusinessHours>([SELECT Id, Name FROM BusinessHours WHERE IsActive=true]); 
            }
        }set;
    } 
    public static Map<String,Account> partnerAndCustomerMap = new Map<String,Account>(); 
    public static Map<String,Account> partnerAccountMap = new Map<String,Account>();
    public static List<Account>  currentCustomersPartnersListQuery = new List<Account>();
    public static List<Account>  currentPartnersCustomerListQuery = new List<Account>();
    public static List<Account>  allUpdatedAccountQuery = new List<Account>();
    public static List<Account> allAccountParentAfterQuery = new List<Account>();
    public static Set<string> ultimateParentIdSet = new Set<string>(); // used for Account Hierarchy Total DLS Field updation
    //----------------------New property with correct name
    public static Schema.DescribeSObjectResult result = Account.SObjectType.getDescribe();
    public static Map<ID,Schema.RecordTypeInfo> rtMapById = result.getRecordTypeInfosById();
    public static Map<Id,Account> oldAccountMap = new Map<Id,Account>();
    
    public static Map<ID,Schema.RecordTypeInfo> rtMapByName = result.getRecordTypeInfosById();
    
    public static Map<String,Schema.RecordTypeInfo> rtMapByRecName = result.getRecordTypeInfosByName();
    public static List<Entitlement> EntitlementsList = new List<Entitlement>();
    //---------------AS/Simplion/4/9/2015------------------------------------------------------
    //--------------Removed this property as this is now deprecated----------------------------
    //private static final Boolean byPass = [SELECT IsTmtTriggersDisabled__c FROM User WHERE Id=: UserInfo.getUserId()].IsTmtTriggersDisabled__c;

    public static Set<Id> prepareUserIdSet(List<Account> accountList) {
        Set<Id> IdsSet = new Set<Id>();
        for(Account accObj : accountList) {
            if(!String.isBlank(accObj.OwnerId)) {
                System.debug('enters owner');
                IdsSet.add(accObj.OwnerId);
            }
            if(!String.isBlank(accObj.Premium_Support_Agent__c)) {
                System.debug('enters premium support');
                IdsSet.add(accObj.Premium_Support_Agent__c);
            }
            if(!String.isBlank(accObj.Current_Owner__c)) {
                System.debug('enters current owner');
                IdsSet.add(accObj.Current_Owner__c);
            }
        }
        System.debug('IdsSet:'+IdsSet);
        return IdsSet;
    }

    /* Utility Method */
    /****************************************************************************
     * @Description - Queries User object and fetches relevant details.          * 
     * @params Set<User>                                                        *
     * @return Map<Id,User>                                                      * 
     *****************************************************************************/
     
     //---------------------As/Simplion/5/26/2015-----------------------------------------------
     //--Deprecation----------------------------------------------------------------------------
    /*
    public static Map<Id, User> getUsers(Set<Id> usersIds) {
        Map<Id,User> userMap = new Map<Id,User>();
        try {
            userMap = new Map<Id,User>([SELECT Phone, Email,FirstName, LastName, Name FROM User WHERE Id IN :usersIds]);
        } catch(Exception e) {}
        return userMap;
    }
    /*
    /*****************************************************************************
     * @Description - Method to update Account information                        * 
     * @params List<Account>, Map<Id,user>                                        *
     * @return void                                                               * 
     *****************************************************************************/     
    //---------------------As/Simplion/5/26/2015-----------------------------------------------
     //--Deprecation----------------------------------------------------------------------------
     /* 
    public static void accountRecordTypeInformation(List<Account> accountList,Map<Id, User> userMap) {

        System.debug('no.of queries got executed accountPhone'+limits.getqueries());
        try{    
            for(Account acct : accountList){
                if(acct.Type == PARTNER){
                    acct.RecordTypeId  = rtMapByRecName.get('Partner Account').getRecordTypeId();
                    //acct.RecordTypeId ='01280000000UERv';
                }else{
                    acct.RecordTypeId  = rtMapByRecName.get('Customer Account').getRecordTypeId();
                    // acct.RecordTypeId ='01280000000UERq';
                }
                if(acct.Premium_Support_Agent__c != null && userMap != null && userMap.containskey(acct.Premium_Support_Agent__c)) {
                    acct.Agent_Email_Address__c =  userMap.get(acct.Premium_Support_Agent__c).Email;
                    System.debug('In email check~~~~~~~~~~~~~~~');    
                }
                if(acct.OwnerId != null && userMap != null && userMap.containskey(acct.OwnerId)) {
                    acct.Account_Owner_Phone_Number__c = userMap.get(acct.OwnerId).Phone;
                }
                if(acct.Phone!=null && acct.BillingCountry!=null){  
                    acct.Original_Phone_Number__c = acct.Phone;                                     
                    acct.Phone = ValidationUtility.validatePhoneNumber(acct.Phone,acct.BillingCountry);
                }
            }
        } catch(Exception e) {
            System.debug('accountRecordTypeInformation @ '+e.getlineNumber());
            System.debug('#### accountRecordTypeInformation '+e.getMessage()); 
        }
    }
    */
    
    //-------------------New Optimised------------------------------------------------
    public static void setAccountValues(List<Account> accountList,Map<Id, User> userMap) {

        System.debug('no.of queries got executed accountPhone'+limits.getqueries());
        try{    
            for(Account acct : accountList){
                if(acct.Type == PARTNER){
                    acct.RecordTypeId  = rtMapByRecName.get('Partner Account').getRecordTypeId();
                    if(String.isBlank(acct.RC_User_ID__c)) {   
                        System.debug('chk inside setAccountValues if RC user id is blank');                     
                        acct.RC_User_ID__c = acct.Partner_ID__c;
                        System.debug('entered in setAccountValues '+ acct.RC_User_ID__c);
                    }
                    //acct.RecordTypeId ='01280000000UERv';
                }else{
                    System.debug('chk in setAccountValues if account type is customer');
                    acct.RecordTypeId  = rtMapByRecName.get('Customer Account').getRecordTypeId();
                    // acct.RecordTypeId ='01280000000UERq';
                }
                if(acct.Premium_Support_Agent__c != null && userMap != null && userMap.containskey(acct.Premium_Support_Agent__c)) {
                    acct.Agent_Email_Address__c =  userMap.get(acct.Premium_Support_Agent__c).Email;
                    System.debug('In email check~~~~~~~~~~~~~~~');    
                }
                if(acct.OwnerId != null && userMap != null && userMap.containskey(acct.OwnerId)) {
                    acct.Account_Owner_Phone_Number__c = userMap.get(acct.OwnerId).Phone;
                }
                if(acct.Phone!=null && acct.BillingCountry!=null){  
                    acct.Original_Phone_Number__c = acct.Phone;                                     
                    acct.Phone = ValidationUtility.validatePhoneNumber(acct.Phone,acct.BillingCountry);
                }
                System.debug('~~~~~~~~~~~~~~~acct.Ultimate_Parent_Account_ID__c~~~~~'+acct.Ultimate_Parent_Account_ID__c);
                if (acct.Ultimate_Parent_Account_ID__c != NULL) { 
                    acct.Ultimate_Parent_Snapshot__c = String.valueOf(acct.Ultimate_Parent_Account_ID__c).substring(0, 15);
                }
                //-----------------This code set sales person values if this record is created by any sales person except sales engineers
                Profile objpro = AccountTriggerHelperExt.currentLoggedInProfile;
                User userObj = objpro.Users[0];
                if (objpro.Name.toLowerCase().contains('sales') && !objpro.Name.toLowerCase().contains('engineer')) {
                    System.debug('chk in setAccountValues if current logged in profile is sales');
                    AccountTriggerHelperExt.userAssignmentOnAccount(trigger.new, userObj);
                }
            }
        } catch(Exception e) {
            System.debug('accountRecordTypeInformation @ '+e.getlineNumber());
            System.debug('#### accountRecordTypeInformation '+e.getMessage()); 
        }
    }
    
    /*********************************************************************************
     * @Description - Method to populate partner Account name on Customer's Account   * 
     * @params List<Account>, Map<Id,Schema.RecordTypeInfo>                           *
     * @return void                                                                   * 
     *********************************************************************************/      
    //-----------------------------------------New Optimized-----------------------------------------
    public static void accountSharingOnInsert(List<Account> accountList) {
        System.debug('no.of queries got executed updateCurrentOwner'+limits.getqueries());
        try{
            
            Map<String,Account> mapPartnerIdToAccount = new Map<String,Account>();
            List<Account> lstAcc = AccountTriggerHelperExt.currentCustomersPartnersListQuery;
            if(!lstAcc.isEmpty()){

                for(Account accountObj :lstAcc) {
                    mapPartnerIdToAccount.put(accountObj.Partner_ID__c,accountObj);
                }
            }
            for(Account accountObj : accountList) {
                if(accountObj.Partner_ID__c != null && accountObj.Partner_ID__c != '' && mapPartnerIdToAccount != null && 
                        mapPartnerIdToAccount.get(accountObj.Partner_ID__c) != null) {
                    Account objAccount = mapPartnerIdToAccount.get(accountObj.Partner_ID__c);
                    accountObj.Do_Not_Creation_Implementation__c = objAccount.Do_Not_Creation_Implementation__c;
                    accountObj.Partner_Account_Name__c           =  objAccount.name;  
                    accountObj.Ultimate_Partner_ID__c            =  objAccount.Ultimate_Parent_Partner_ID__c;
                    accountObj.Ultimate_Partner_Name__c          =  objAccount.Ultimate_Parent_Account_Name__c;
                    accountObj.Current_Owner__c                  =  objAccount.Current_Owner__c;
                    accountObj.Current_Owner_Name__c             =  objAccount.Current_Owner_Name__c;
                    accountObj.Current_Owner_Email__c            =  objAccount.Current_Owner_Email__c;
                }
            }

        } catch(exception ex){
            System.debug('Exception accountSharingOnInsert @@'+ex.getlineNumber());
            System.debug('Exception accountSharingOnInsert'+ex.getMessage());
        }
    }
    /*********************************************************************************
     * @Description - Method to update current owner name, email                      * 
     * @params List<Account>, Map<Id,Schema.RecordTypeInfo>                           *
     * @return void                                                                   * 
     *********************************************************************************/      
    //-----------------------------New Optimized--------------------------------------------
    public static void setAccountValuesOnUpdate(Map<Id,Account> newMap, Map<Id, Account> oldMap) {
        Map<String,Account> MapPartnerId = new Map<String,Account>();
        //system.debug('-------------------------------------------'+ setPartnerId);    
        for(Account partnerAcc:AccountTriggerHelperExt.currentCustomersPartnersListQuery){
            MapPartnerId.put(partnerAcc.Partner_ID__c,partnerAcc);
        }
        try{
            
                for(Account accObj :newMap.values()){
                    Account oldaccObj = oldMap.get(accObj.ID);
                    if( accObj.Website != oldaccObj.Website  ||
                            accObj.Number_of_Locations__c != oldaccObj.Number_of_Locations__c ||
                            accObj.NumberOfEmployees != oldaccObj.NumberOfEmployees ||
                            accObj.No_of_Employees__c != oldaccObj.No_of_Employees__c  ||
                            accObj.Industry != oldaccObj.Industry ||
                            accObj.Is_the_customer_interested_in_porting__c != oldaccObj.Is_the_customer_interested_in_porting__c) {
                        //------------------------------------------------------------------------------------------------------------
                        accObj.Customer_Profile_Last_modified_Date__c  = System.now();
                        System.debug('#######'+accObj.Customer_Profile_Last_modified_Date__c);
                    }
                    System.debug ('Before Condition 1, accObj.Current_Owner__c'+accObj.Current_Owner__c + ' oldaccObj.Current_Owner__c'+
                                oldaccObj.Current_Owner__c+ ' UserInfo.getFirstName()'+UserInfo.getFirstName());
                    //update current owner name, email
                    // IF current owner is not null and current owner is changed and loggedIn User is not  RCSF user
                    System.debug ('UserInfo Data: '+ UserInfo.getFirstName());
                    if(accObj.Current_Owner__c != null && (oldaccObj.Current_Owner__c != accObj.Current_Owner__c)&& (! UserInfo.getFirstName().containsIgnoreCase('RCSF'))){
                        System.debug ('Aftr Condition 1');
                        User CO = allUserMap.get(accObj.Current_Owner__c);
                        accObj.Current_Owner_Name__c = CO.Name;
                        accObj.Current_Owner_Email__c = CO.Email;        
                    }
                    System.debug ('Before Condition 2');
                    if(oldaccObj.Current_Owner__c != null && accObj.Current_Owner__c == null){
                        System.debug ('After Condition 2');
                        // if current owner was removed
                        accObj.Current_Owner_Name__c = null;
                        accObj.Current_Owner_Email__c = null;                               
                    }
                    // If owner id is changed and old Account_Owner_Phone_Number__c value is different from new record owner phone value
                    System.debug ('allUserMap' + allUserMap);
                    System.debug ('oldaccObj.OwnerId ' + oldaccObj.OwnerId);
                    System.debug ('accObj.OwnerId  '+ accObj.OwnerId);
                    System.debug ('oldaccObj.Account_Owner_Phone_Number__c  '+oldaccObj.Account_Owner_Phone_Number__c);
                    System.debug ('allUserMap.get(accObj.OwnerId).phone  '+allUserMap.get(accObj.OwnerId).phone);
                    System.debug ('accObj.Account_Owner_Phone_Number__c  '+accObj.Account_Owner_Phone_Number__c);
                    System.debug ('allUserMap.get(accObj.OwnerId).Phone  '+allUserMap.get(accObj.OwnerId).Phone);                
                    if(allUserMap != null && oldaccObj.OwnerId != null && accObj.OwnerId != null && 
                            ((oldaccObj.OwnerId != accObj.OwnerId) ||
                                    (oldaccObj.Account_Owner_Phone_Number__c != allUserMap.get(accObj.OwnerId).phone))) {
                        accObj.Account_Owner_Phone_Number__c = allUserMap.get(accObj.OwnerId).Phone;       
                    }
                    //----If RC_Account_Number__c value is not null and starts with 1 and have 11 digits
                    if(accObj.RC_Account_Number__c != null && accObj.RC_Account_Number__c.length() == 11 && accObj.RC_Account_Number__c.startsWith('1')){
                        accObj.RC_Account_Number__c = accObj.RC_Account_Number__c.substring(1);
                    }
                    
                    //--If service type is of office and RC_Account_Status__c is changed and not null and have any value in Trial 7 CC
                    //  ,Trial 30 CC, Trial 30 no-CC, Trial (other) and new value is Disabled
                    if(!string.isBlank(accObj.Service_Type__c) && accObj.Service_Type__c.containsIgnoreCase('Office') 
                        && oldaccObj.RC_Account_Status__c != accObj.RC_Account_Status__c && !string.isBlank(oldaccObj.RC_Account_Status__c) 
                        && !string.isBlank(accObj.RC_Account_Status__c) && 
                        (oldaccObj.RC_Account_Status__c.equalsIgnoreCase('Trial 7 CC') || oldaccObj.RC_Account_Status__c.equalsIgnoreCase('Trial 30 CC') ||
                            oldaccObj.RC_Account_Status__c.equalsIgnoreCase('Trial 30 no-CC') || oldaccObj.RC_Account_Status__c.equalsIgnoreCase('Trial (other)'))
                            && accObj.RC_Account_Status__c.equalsIgnoreCase('Disabled')) {
                        //-------------------------------------------------------------------------------------------------------------------------------------
                        accObj.Hardware_Return_Pending__c = true;
                        accObj.Trial_De_activation_Date__c = System.today();  
                    }
                    //--If phone is not null and changed and billingCountry is not null and changed
                    if(accObj.Phone!=null && accObj.billingCountry!=null){
                        if(accObj.Phone!=oldaccObj.Phone || accObj.billingCountry!=oldaccObj.billingCountry){                                         
                            accObj.Phone = ValidationUtility.validatePhoneNumber(accObj.Phone,accObj.BillingCountry);
                        }
                    }
                    String OldPartnerIdvalue = oldaccObj.Partner_ID__c;
                    //---IF partner Id is changed of customer account
                    System.debug ('rtMapById.get(accObj.RecordTypeId ).getName()' + rtMapById.get(accObj.RecordTypeId ).getName());
                    System.debug ('accObj.Partner_ID__c' + accObj.Partner_ID__c);
                    System.debug ('OldPartnerIdvalue '+ OldPartnerIdvalue);
                    System.debug ('MapPartnerId  '+MapPartnerId);
                    System.debug ('MapPartnerId.get(accObj.Partner_ID__c)  '+MapPartnerId.get(accObj.Partner_ID__c));                
                   
                   
                    
                    if((rtMapById.get(accObj.RecordTypeId ).getName() == CUSTOMER_ACCOUNT) &&  accObj.Partner_ID__c != null && 
                            (OldPartnerIdvalue != accObj.Partner_ID__c) && MapPartnerId != null && 
                            MapPartnerId.get(accObj.Partner_ID__c) != null) {
                        Account partnerAcc = MapPartnerId.get(accObj.Partner_ID__c);
                        accObj.Do_Not_Creation_Implementation__c =  partnerAcc.Do_Not_Creation_Implementation__c;
                        accObj.Partner_Account_Name__c           =  partnerAcc.name;  
                        accObj.Ultimate_Partner_ID__c            =  partnerAcc.Ultimate_Parent_Partner_ID__c;
                        accObj.Ultimate_Partner_Name__c          =  partnerAcc.Ultimate_Parent_Account_Name__c;
                        accObj.Current_Owner__c                  =  partnerAcc.Current_Owner__c;
                        accObj.Current_Owner_Name__c             =  partnerAcc.Current_Owner_Name__c;
                        accObj.Current_Owner_Email__c            =  partnerAcc.Current_Owner_Email__c;
                    }
                    // copy Ultimate_Parent_Snapshot__c value from Ultimate_Parent_Account_ID__c if and only if it is not blank
                    if (accObj.Ultimate_Parent_Account_ID__c != NULL) {
                        accObj.Ultimate_Parent_Snapshot__c = String.valueOf(accObj.Ultimate_Parent_Account_ID__c).substring(0, 15);
                    }
                    //-----------------This code set sales person values if this record is edited by any sales person except sales engineers
                    Profile objpro = AccountTriggerHelperExt.currentLoggedInProfile;
                    User userObj = objpro.Users[0];
                    if (objpro.Name.toLowerCase().contains('sales') && !objpro.Name.toLowerCase().contains('engineer')) {
                        AccountTriggerHelperExt.userAssignmentOnAccount(trigger.new, userObj);
                    }
                }
            
        }catch(Exception e){
            System.debug('Exception accountSharingOnUpdate0 @@'+e.getlineNumber());
            System.debug('Exception accountSharingOnUpdate0'+e.getMessage());
        }
    }
    
    //---------------------------As/Simplion/9/24/2014----------------------------------------
    //----------------------------New Optimized----------------------------------------------
    public static void setServiceType(List<Account> newList){
        
        //---------------------------map to maintain serviceName and serviceType Mappings--------- 
        Map<String,String> serviceAndTypeMap = new Map <String,String>{
                'FAX' => 'Fax',
                'PROFESSIONAL' => 'Professional',
                'OFFICE' => 'Office'
        };
        //---------------------------------As/Simplion/10/16/2014 start--------------------------------------------------------------------------
        //--------------------------------Service Type mapping as per service Name for account with Account status = 'test'---------------
        String serviceName = '';
        for (Account currentAccount: newList) {
            if (!String.isBlank(currentAccount.RC_Service_name__c) && !String.isBlank(currentAccount.RC_Account_Status__c)) {
                serviceName = currentAccount.RC_Service_name__c.toUpperCase();
                if (currentAccount.RC_Account_Status__c.toUpperCase().equals('TEST')) {

                    currentAccount.Service_Type__c = serviceName.contains('OFFICE') ? serviceAndTypeMap.get('OFFICE') : (serviceName.contains('PROFESSIONAL') || serviceName.startsWith('PRO')) ? serviceAndTypeMap.get('PROFESSIONAL') : serviceName.contains('FAX') ? serviceAndTypeMap.get('FAX') : currentAccount.Service_Type__c;
                }
            }
        }
    }
    
        /*********************************************************************************
     * @Description - Method to update current owner name, email                      * 
     * @params List<Account>, Map<Id,Schema.RecordTypeInfo>                           *
     * @return void                                                                   * 
     *********************************************************************************/      
     //---------------------As/Simplion/5/26/2015-----------------------------------------------
     //--Deprecation----------------------------------------------------------------------------
    /*
    public static void accountSharingOnUpdate0(List<Account> accList, Map<Id, User> userMap) {
        try{
            
                for(Account accObj :accList){
                    Account oldaccObj = oldAccountMap.get(accObj.ID);
                    if( accObj.Website != oldaccObj.Website  ||
                            accObj.Number_of_Locations__c != oldaccObj.Number_of_Locations__c ||
                            accObj.NumberOfEmployees != oldaccObj.NumberOfEmployees ||
                            accObj.No_of_Employees__c != oldaccObj.No_of_Employees__c  ||
                            accObj.Industry != oldaccObj.Industry ||
                            accObj.Is_the_customer_interested_in_porting__c != oldaccObj.Is_the_customer_interested_in_porting__c) {
                        accObj.Customer_Profile_Last_modified_Date__c  = System.now();
                        System.debug('#######'+accObj.Customer_Profile_Last_modified_Date__c);
                    }
                    //update current owner name, email
                    if(accObj.Current_Owner__c != null){
                        if((oldaccObj.Current_Owner__c != accObj.Current_Owner__c) &&
                         //!UserRc.compareUserName(UserInfo.getName()) 
                         (! UserInfo.getFirstName().containsIgnoreCase('RCSF'))){
                            User CO = usermap.get(accObj.Current_Owner__c);
                            accObj.Current_Owner_Name__c = CO.Name;
                            accObj.Current_Owner_Email__c = CO.Email;               
                        }       
                    }
                    if(oldaccObj.Current_Owner__c != null && accObj.Current_Owner__c == null){
                        // if current owner was removed
                        accObj.Current_Owner_Name__c = null;
                        accObj.Current_Owner_Email__c = null;                               
                    }

                    if(userMap != null && oldaccObj.OwnerId != null && accObj.OwnerId != null && 
                            ((oldaccObj.OwnerId != accObj.OwnerId) ||
                                    (oldaccObj.Account_Owner_Phone_Number__c != userMap.get(accObj.OwnerId).phone))) {
                        accObj.Account_Owner_Phone_Number__c = userMap.get(accObj.OwnerId).Phone;       
                    }
                }
            

            Set<ID> accIds = new Set<ID>();
            for(Account accObj :accList){
                if(accObj.RC_Account_Number__c != null){
                    if(accObj.RC_Account_Number__c.length() == 11 && accObj.RC_Account_Number__c.startsWith('1')){
                        accObj.RC_Account_Number__c = accObj.RC_Account_Number__c.substring(1); 
                    }
                }
                accIds.add(accObj.id);
            }
            ImplementationMethods im = new ImplementationMethods();
            for(Account newAccount : accList) {
                Account oldAccount = oldAccountMap.get(newAccount.id);
                if(im.chkToHardwareRtnOnDeactivation(newAccount,oldAccount)) {
                    newAccount.Hardware_Return_Pending__c = true;
                    newAccount.Trial_De_activation_Date__c = System.today();  
                }
                if(newAccount.Phone!=null && newAccount.billingCountry!=null){
                    if(newAccount.Phone!=oldAccount.Phone || newAccount.billingCountry!=oldAccount.billingCountry){                                         
                        newAccount.Phone = ValidationUtility.validatePhoneNumber(newAccount.Phone,newAccount.BillingCountry);
                    }
                }
            }
            List<Account> accountList =[SELECT Id, Name, (SELECT c.Id, c.status FROM Cases c WHERE c.recordtype.name LIKE '%Porting%' OR c.recordtype.name LIKE '%porting%') 
                                        FROM Account WHERE ID in : accIds];
            for(Account acctObj : accountList){
                List<case> caseList = acctObj.getSObjects('Cases'); 
                caseAccountMap.put(acctObj.Id, caseList); 
            }
           
            accountSharingOnUpdate1(accList);
        }catch(Exception e){
            System.debug('Exception accountSharingOnUpdate0 @@'+e.getlineNumber());
            System.debug('Exception accountSharingOnUpdate0'+e.getMessage());
        }
    }*/
    /*********************************************************************************
     * @Description - Method to update current owner name, email                      * 
     * @params List<Account>, Map<Id,Account>[trigger.oldMap]                         *
     * @return void                                                                   * 
     *********************************************************************************/   
    //---------------------As/Simplion/5/26/2015-----------------------------------------------
    //--Deprecation----------------------------------------------------------------------------
     /*
    public static void accountSharingOnUpdate1(List<Account> accountList) {
        try {
            Set<String> setPartnerId  = New Set<String>();
            Map<String,Account> MapPartnerId = new Map<String,Account>();
            //system.debug('-------------------------------------------'+ setPartnerId);    
            for(Account partnerAcc:AccountTriggerHelperExt.currentCustomersPartnersListQuery){
                MapPartnerId.put(partnerAcc.Partner_ID__c,partnerAcc);
            }
            //system.debug('--------------------------------------------'+MapPartnerId);
            for(Account objAcc : accountList) {
                String OldPartnerIdvalue = oldAccountMap.get(objAcc.Id).Partner_ID__c;
                if((rtMapByName.get(objAcc.RecordTypeId ).getName() == CUSTOMER_ACCOUNT) &&  objAcc.Partner_ID__c != null && 
                        (OldPartnerIdvalue != objAcc.Partner_ID__c) && MapPartnerId != null && 
                        MapPartnerId.get(objAcc.Partner_ID__c) != null) {
                    //System.Debug('>>>!!!>>');         
                    objAcc.Current_Owner__c  = MapPartnerId.get(objAcc.Partner_ID__c).Current_Owner__c;
                    
                    //System.Debug('>>>!!!>>'+ objAcc.Current_Owner__c);
                }
            }
        } catch(Exception  e){
            System.debug('Exception accountSharingOnUpdate1 @@'+e.getlineNumber());
            System.debug('Exception accountSharingOnUpdate1'+e.getMessage());
        }
    }*/
    /*********************************************************************************
     * @Description - Method to update current owner name, email                      * 
     * @params List<Account>, Map<Id,Account>[trigger.oldMap]                         *
     * @return void                                                                   * 
     *********************************************************************************/
    //---------------------As/Simplion/5/26/2015-----------------------------------------------
    //--Deprecation----------------------------------------------------------------------------
    /*
    public static void accountSharingOnUpdate2(Map<Id,Account> newMap,Map<Id,Account> oldMap) {
        Map<String,Account> mapPartnerIdToAccount = new Map<String,Account>();
        try{
            Set<String> setPartnerId = new Set<String>();
            
            for(Account newAccount : newMap.values()){
                Account oldAccount = oldMap.get(newAccount.id);
                    if(((newAccount.Partner_ID__c != null)&&(newAccount.Partner_ID__c != ''))
                            &&(newAccount.Type == CUSTOMER) // objAcc.RecordTypeId == '01280000000UERq'
                            &&(rtMapByName != null && newAccount.RecordTypeId != null && rtMapById.get(newAccount.RecordTypeId ).getName() == CUSTOMER_ACCOUNT)
                            &&(oldAccount.Partner_ID__c != newAccount.Partner_ID__c)) {
                        setPartnerId.add(newAccount.Partner_ID__c);
                        System.debug('$$$$$$$$$$$'+setPartnerId);
                    }
            }       
            
            List<Account> lstAcc = [SELECT name,Partner_ID__c,Do_Not_Creation_Implementation__c,Ultimate_Parent_Partner_ID__c,Ultimate_Partner_ID__c,Ultimate_Partner_Name__c,
                                    Ultimate_Parent_Account_ID__c,Ultimate_Parent_Account_Name__c,Current_Owner__c,Current_Owner_Email__c,Current_Owner_Name__c FROM Account 
                                    WHERE  Partner_ID__c IN:setPartnerId AND type ='Partner'];
                                 
            for(Account partnerAcc:newMap.values()) {
                mapPartnerIdToAccount.put(partnerAcc.Partner_ID__c,partnerAcc);
            }
            
            //***************************** code for populating partner Account name on Customer's Account *************
            for(Account objAcc : newMap.values()) { 
                System.debug('@@@@@@@@@@@@ update 1');
                if(((objAcc.Partner_ID__c != null)&&(objAcc.Partner_ID__c != ''))
                        &&(objAcc.Type == 'Customer') ////objAcc.RecordTypeId == '01280000000UERq'
                        &&(rtMapByName != null && objAcc.RecordTypeId != null && rtMapByName.get(objAcc.RecordTypeId ).getName() == CUSTOMER_ACCOUNT)) {
                    System.debug('################ update 2');
                    if(mapPartnerIdToAccount != null && mapPartnerIdToAccount.containsKey(objAcc.Partner_ID__c)){
                        System.debug('################ update 3');
                        objAcc.Do_Not_Creation_Implementation__c = mapPartnerIdToAccount.get(objAcc.Partner_ID__c).Do_Not_Creation_Implementation__c;
                        objAcc.Partner_Account_Name__c = mapPartnerIdToAccount.get(objAcc.Partner_ID__c).name;
                        objAcc.Ultimate_Partner_ID__c = mapPartnerIdToAccount.get(objAcc.Partner_ID__c).Ultimate_Parent_Partner_ID__c;
                        objAcc.Ultimate_Partner_Name__c = mapPartnerIdToAccount.get(objAcc.Partner_ID__c).Ultimate_Parent_Account_Name__c;
                        if(!TriggerHandler.BY_PASS_ACCOUNT_ON_UPDATE){ 
                            System.debug('################ update 4');
                            objAcc.Current_Owner__c = mapPartnerIdToAccount.get(objAcc.Partner_ID__c).Current_Owner__c;
                            objAcc.Current_Owner_Name__c = mapPartnerIdToAccount.get(objAcc.Partner_ID__c).Current_Owner_Name__c;
                            objAcc.Current_Owner_Email__c = mapPartnerIdToAccount.get(objAcc.Partner_ID__c).Current_Owner_Email__c;
                        }
                    }   
                }
            }
        }catch(exception ex){
            System.debug('Exception accountSharingOnUpdate2 @@'+ex.getlineNumber());
            System.debug('Exception accountSharingOnUpdate2'+ex.getMessage());
        }
        
    }*/
    //----------------------------------------New Optimized-------------------------------------------------
    //----------------------------------------As/Simplion/5/7/2015---------------------------------------------------------------------
    //-------------------This code updates all customer accounts of current partner account if do not create implementation is changed---
    public static List<Account> updateCustomersOnPartnerUpdate(List<Account> accList,Map<Id,Account> oldMap,List<Account> customerAccByQueryList){ 
        List<Account> customersForUpdateList = new List<Account>();
        try{
            Map<string,Account> partnerMapWithDoNotCreateImpValueChange = new Map<string,Account>();
            for(Account objAcc : accList) {
                
                    Account partnerAccountB4 = oldMap.get(objAcc.id);
                    System.debug(AccountTriggerHelperExt.rtMapById.get(objAcc.RecordTypeId).getName().equalsIgnoreCase(AccountTriggerHelperExt.PARTNER_ACCOUNT)+'~~~~~~~~~~~~~~~~AccountTriggerHelperExt.rtMapById.get(objAcc.RecordTypeId).getName().equalsIgnoreCase(AccountTriggerHelperExt.PARTNER_ACCOUNT');
                    if((partnerAccountB4.Do_Not_Creation_Implementation__c != objAcc.Do_Not_Creation_Implementation__c) 
                            && objAcc.Partner_Id__c != null // objAcc.RecordTypeId == '01280000000UERv' 
                           &&  AccountTriggerHelperExt.rtMapById.get(objAcc.RecordTypeId).getName().equalsIgnoreCase(AccountTriggerHelperExt.PARTNER_ACCOUNT)
                    ) {
                        partnerMapWithDoNotCreateImpValueChange.put(objAcc.Partner_Id__c,objAcc);
                    }
            }
            Map<String,List<Account>> MapToPartnerLstCustomer = new Map<String,List<Account>>();
             for(Account customerAccByQuery : customerAccByQueryList){
                if(partnerMapWithDoNotCreateImpValueChange.containsKey(customerAccByQuery.Partner_Id__c)){
                    if(customerAccByQuery.Do_Not_Creation_Implementation__c != partnerMapWithDoNotCreateImpValueChange.get(customerAccByQuery.Partner_Id__c).Do_Not_Creation_Implementation__c ){
                        customerAccByQuery.Do_Not_Creation_Implementation__c = partnerMapWithDoNotCreateImpValueChange.get(customerAccByQuery.Partner_Id__c).Do_Not_Creation_Implementation__c;
                        customersForUpdateList.add(customerAccByQuery);
                    }
                }
                
            }
        }catch(exception ex){
            System.debug('Exception lstPartnerChildCustomer @@'+ex.getlineNumber());
            System.debug('Exception lstPartnerChildCustomer'+ex.getMessage());  
        }
        return customersForUpdateList;
    }
    //-------------------------New Optimized-----------------------------------------------------------------
    //-------------------------Method to set value of Eligible_for_Refferel_Credit__c of account--------------
    public static void updateEligibalForReferealCredit(List<Account> accList,Map<Id,Account> oldMap) {
                map<string,Account> partnerIdToAccountMap = new map<string,Account>();
                Map<Id,Integer> counterToPartnerAccount = new Map<Id,Integer>();
                System.debug('~~~~~~~~~~~~~~~~~~~~~~~~~~~~AccountTriggerHelperExt.currentCustomersPartnersListQuery'+AccountTriggerHelperExt.currentCustomersPartnersListQuery);
                for(Account accObj : AccountTriggerHelperExt.currentCustomersPartnersListQuery) {
                    partnerIdToAccountMap.put(accObj.Partner_ID__c,accObj);
                    Integer initialCounter = accObj.Partner_Customer_Count__c != null ? Integer.valueOf(accObj.Partner_Customer_Count__c) : 0;
                    counterToPartnerAccount.put(accObj.Id,initialCounter); 
                    System.debug('~~~~~~~~counterToPartnerAccount  on update'+counterToPartnerAccount);
                }
             for(Account accObj : accList){
                System.debug('rtMapById.get(accObj.RecordTypeId).getName()'+ rtMapById.get(accObj.RecordTypeId).getName());
                System.debug('accObj.RecordTypeId' + accObj.RecordTypeId);
                System.debug('accObj.Partner_ID__c'+accObj.Partner_ID__c);
                System.debug('accObj.RC_Account_Status__c'+accObj.RC_Account_Status__c);
                System.debug('oldMap.get(accObj.id).RC_Account_Status__c'+oldMap.get(accObj.id).RC_Account_Status__c);
                System.debug('oldMap'+oldMap);
                System.debug('oldMap.get(accObj.id).Pay_Referral_Commissions__c'+oldMap.get(accObj.id).Pay_Referral_Commissions__c);
                System.debug('accObj.Pay_Referral_Commissions__c'+accObj.Pay_Referral_Commissions__c);
                System.debug('partnerIdToAccountMap'+partnerIdToAccountMap);
                System.debug('partnerIdToAccountMap.get(accObj.Partner_ID__c)'+partnerIdToAccountMap.get(accObj.Partner_ID__c));
                
                if(
                    (accObj.RecordTypeId != null && rtMapById.get(accObj.RecordTypeId).getName() == 'Customer Account') &&
                        accObj.Partner_ID__c != null && 
                        ((!String.isBlank(accObj.RC_Account_Status__c) && accObj.RC_Account_Status__c.equalsIgnoreCase('Paid') && oldMap != null && oldMap.get(accObj.id).RC_Account_Status__c != accObj.RC_Account_Status__c) &&
                        (oldMap.get(accObj.id).Pay_Referral_Commissions__c != accObj.Pay_Referral_Commissions__c && accObj.Pay_Referral_Commissions__c == true)) &&
                        partnerIdToAccountMap != null && partnerIdToAccountMap.get(accObj.Partner_ID__c) != null) {
                    //----------------------------------------------------------------------------------------------------------------------------
                    
                    Account partnerAccountObj = partnerIdToAccountMap.get(accObj.Partner_ID__c);
                    Integer counter = counterToPartnerAccount.get(partnerAccountObj.Id);
                    if(oldMap != null && (!'Suspended'.equalsIgnoreCase(oldMap.get(accObj.id).RC_Account_Status__c) 
                        && !'Canceled'.equalsIgnoreCase(oldMap.get(accObj.id).RC_Account_Status__c))){
                        if(partnerAccountObj != null && counter < 5 &&
                            partnerAccountObj.Partner_Sign_Up_Date__c != null && accObj.RC_Signup_Date__c != null &&
                            (partnerAccountObj.Partner_Sign_Up_Date__c.daysBetween(accObj.RC_Signup_Date__c.date())) < 185) {
                                accObj.Eligible_for_Refferel_Credit__c  = true; 
                                counter = counter+1;
                                counterToPartnerAccount.put(accObj.Id,counter);
                                System.debug('~~~~~~~~~~~~~~~~~~counterToPartnerAccount on update~~~~~'+counterToPartnerAccount);
                                partnerAccountObj.Partner_Customer_Count__c = counter;
                                System.debug('~~~~~~~~~~~~~~~~~~partnerAccountObj on update~~~~~'+partnerAccountObj);
                                accountsListForUpdateForCreditCounter.add(partnerAccountObj);
                                
                            
                        }
                    } 
                }
             }
             
        
    }
    //--------------------------------------New Optimized---------------------------------------------
     public static void setEligibalForReferealCredit(List<Account> accList) {
        try {
                map<string,Account> partnerIdToAccountMap = new map<string,Account>();
                Map<Id,Integer> counterToPartnerAccount = new Map<Id,Integer>();
                for(Account accObj : AccountTriggerHelperExt.currentCustomersPartnersListQuery) {
                    partnerIdToAccountMap.put(accObj.Partner_ID__c,accObj);
                    Integer initialCounter = accObj.Partner_Customer_Count__c != null ? Integer.valueOf(accObj.Partner_Customer_Count__c) : 0;
                    counterToPartnerAccount.put(accObj.Id,initialCounter); 
                    System.debug('~~~~~~~~counterToPartnerAccount  '+counterToPartnerAccount);
                }
                 for(Account accObj : accList){
                   if(
                        (accObj.RecordTypeId != null && rtMapById.get(accObj.RecordTypeId).getName() == AccountTriggerHelperExt.CUSTOMER_ACCOUNT) &&
                        (accObj.Partner_ID__c != null && !String.isBlank(accObj.RC_Account_Status__c)) &&
                        accObj.Pay_Referral_Commissions__c == true && 
                        accObj.RC_Account_Status__c.equalsIgnoreCase('Paid')&&
                        (partnerIdToAccountMap != null && partnerIdToAccountMap.get(accObj.Partner_ID__c) != null)) {
                            
                            Account partnerAccountObj = partnerIdToAccountMap.get(accObj.Partner_ID__c);
                            Integer counter = counterToPartnerAccount.get(partnerAccountObj.Id);
                            if(partnerAccountObj != null && counter < 5 &&
                               partnerAccountObj.Partner_Sign_Up_Date__c != null && accObj.RC_Signup_Date__c != null &&
                               (partnerAccountObj.Partner_Sign_Up_Date__c.daysBetween(accObj.RC_Signup_Date__c.date())) < 185) {
                                accObj.Eligible_for_Refferel_Credit__c  = true; 
                                counter = counter +1;
                                counterToPartnerAccount.put(partnerAccountObj.Id,counter); 
                                partnerAccountObj.Partner_Customer_Count__c = counter;
                                System.debug('~~~~~~~~~~~~~~~~~~partnerAccountObj~~~~~'+partnerAccountObj);
                                accountsListForUpdateForCreditCounter.add(partnerAccountObj);
                                
                            }
                        }
                 }
             
        } catch(Exception ex) {
            System.debug('Exception accountSharingOnInsert @@'+ex.getlineNumber());
            System.debug('Exception accountSharingOnInsert'+ex.getMessage());
            new TriggerException('Exception occured at AccountGatewayClass|| updateEligibalForReferealCredit()');
        }
    }  
    //--------------------------------------New Optimized--------------------------------------------- 
    public static void updateMostRecentImplementationContact(Map<Id,Account> newMap){
        try{
            for(Account objAccount : AccountTriggerHelperExt.allUpdatedAccountQuery){
                system.debug('####$ objAccount'+ objAccount);
                system.debug('####$ newMap.get (objAccount.Id).Most_Recent_Implementation_Contact__c'+ newMap.get(objAccount.Id).Most_Recent_Implementation_Contact__c);
                if(objAccount.AccountContactRoles.size()>0){
                    for(AccountContactRole objACR : objAccount.AccountContactRoles) {
                        if(objACR!=null && objACR.ContactId != Null && objACR.isPrimary){
                            newMap.get(objAccount.Id).Most_Recent_Implementation_Contact__c = objACR.ContactId;
                            newMap.get(objAccount.Id).Preferred_Language__c  = objACR.contact.Preferred_Language__c;
                            //system.debug('####$ newMap.get(objAccount.Id).Most_Recent_Implementation_Contact__c ' + newMap.get(objAccount.Id).Most_Recent_Implementation_Contact__c);
                        }
                    }
                }
                System.debug('~~~~~~~~~~~~~~~~~~~~~~~~~~~~Most_Recent_Implementation_Contact__c---'+newMap.get(objAccount.Id).Most_Recent_Implementation_Contact__c);
                if(newMap.get(objAccount.Id).Most_Recent_Implementation_Contact__c == null){
                    newMap.get(objAccount.Id).Preferred_Language__c = 'en_US';
                    System.debug('~~~~~~~~~~~~~~~~~~~~~~~~~~~~Preferred_Language__c---'+newMap.get(objAccount.Id).Preferred_Language__c);
                    //system.debug('####$ newMap.get(objAccount.Id).Preferred_Language__c ' + newMap.get(objAccount.Id).Preferred_Language__c);
                }
                
            }
        }catch(Exception e){
             System.debug('Exception updateMostRecentImplementationContact @@'+e.getlineNumber());
            System.debug('Exception updateMostRecentImplementationContact'+e.getMessage());
        }
    }
    
    //--------------------------------New Optimized------------------------------------------------------------------
    public static List<Account> updatePartnerCodeOnInsertAndUpdate(List<Account> customerAccountList,Map<String,Account> partnerAccMap ) {
        List<Account> customersListForUpdates = new List<Account>();
        try {
            
            for(Account customerAccount : customerAccountList) {
                if(partnerAccMap.containsKey(customerAccount.Partner_ID__c) && customerAccount.Current_Owner__c != partnerAccMap.get(customerAccount.Partner_ID__c).Current_Owner__c){
                            customerAccount.Current_Owner__c = partnerAccMap.get(customerAccount.Partner_ID__c).Current_Owner__c;
                            customerAccount.Current_Owner_Name__c = partnerAccMap.get(customerAccount.Partner_ID__c).Current_Owner_Name__c;
                            customerAccount.Current_Owner_Email__c = partnerAccMap.get(customerAccount.Partner_ID__c).Current_Owner_Email__c;
                            customersListForUpdates.add(customerAccount);
                }   
            }
            
        } catch(exception e){ 
            System.debug('Exception updatePartnerCodeOnIsertAndUpdate @@'+e.getlineNumber());
            System.debug('Exception updatePartnerCodeOnIsertAndUpdate'+e.getMessage());
        }
        return customersListForUpdates;
    }

   //--------------------------This method is used outside of account trigger-----------------
    /**************************************************************************
     *@Discription............: updating the Last touch sales person field    *
     *@Param..................: List<Account>,User                            *
     *@Return.................: void                                          *
     *@Last Modified by.......: 10-03-2014                                    *
     *@Last Modified Date.....: 10-03-2014                                    *  
     **************************************************************************/    
    public static void updateLastTouchedSalesPerson(List<Account> accountList, User userObj) {
        userAssignmentOnAccount(accountList, userObj);
        if(accountList != null && accountList.size() != 0) {
            TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT();
            TriggerHandler.BY_PASS_ACCOUNT_ON_UPDATE();
            try {update accountList;} catch(Exception e) {System.debug('### WE GOT EXCEPTION ### ' + e.getMessage());}
        }
    }
    /*************************************************************************/

    /**************************************************************************
     *@Discription............: Assigning the login User Value to account     *
     *                          Last touch by salesperson                     *
     *@Param..................: List<sObject>,String                          *
     *@Return.................: List<sObject>                                 *
     *@Last Modified by.......: 10-03-2014                                    *
     *@Last Modified Date.....: 10-03-2014                                    *  
     **************************************************************************/    
     //---------------New Optimized-----------------------------------------------------
    public static void userAssignmentOnAccount(List<Account> accountList, User userObj){
        for(Account accountObj : accountList){
            if(userObj != null) {
                //system.debug('accountObj======='+accountObj);
                system.debug('userObj test======='+userObj);
                accountObj.LastTouchedbySalesID__c = userObj.Id;
                accountObj.LastTouchedbySalesFirstName__c = userObj.FirstName;
                accountObj.LastTouchedbySalesLastName__c = userObj.LastName;
                accountObj.LastTouchedbySalesEmail__c = userObj.Email;
                accountObj.LastTouchedbySalesPhone__c = userObj.Phone;
            }
        }
    }
    /**************************************************************************/
    
    /*************************************************************************************
    * @Description - Method to RollUp # of DL to all Parents and childs on Account on   *
    *                Insert/Update                                                      *
    * @params      -                                                                    *
    * @return      -                                                                    *
    ************************************************************************************/
    //---------------------------------New Optimized----------------------------------------------------
    public static List<Account> calculateAccountHierarchyTotalDLS(Set<String> setOfUltimateParentId){
         List<Account> updatedAccountList = new List<Account>();
         if(setOfUltimateParentId!=null && setOfUltimateParentId.size() > 0){
            map<Id,decimal> parentCounterMap = new map<Id,decimal>();
            map<Id,List<Account>> childAccountMap = new map<Id,List<Account>>();
            system.debug('==setOfUltimateParentId=='+setOfUltimateParentId);
            List<Account> accMainList = new List<Account>();
            for(List<Account> accList : [SELECT id,Ultimate_Parent_Account_ID__c,RC_Account_Status__c, Ultimate_Parent_Snapshot__c, Number_of_DL_s__c,Total_DLs__c FROM Account
                                    WHERE NAME != NULL AND RecordType.Name =: CUSTOMER_ACCOUNT AND (Ultimate_Parent_Snapshot__c IN : setOfUltimateParentId )]){
                accMainList.addAll(accList);                            
            }
            system.debug('==accMainList=='+accMainList.size()+'=='+accMainList);
            for(Account accObj : accMainList){
                // Only re-evaluate the hierarchy if it is either Ultimate Parent or any 'Paid' Account.
                if(accObj.RC_Account_Status__c != 'Paid' && string.valueOf(accObj.Ultimate_Parent_Account_ID__c).subString(0,15) != string.valueOf(accObj.id).subString(0,15)){
                    system.debug(' ==Continue- Eneter== ');
                    continue;
                }
                system.debug(' ==Continue- Exit == ');
                Id accountId = null;
                if(accObj.Ultimate_Parent_Account_ID__c!=null){
                    accountId = accObj.Ultimate_Parent_Account_ID__c;
                } else {
                    accountId = accObj.Id;
                }
                if(parentCounterMap!=null && parentCounterMap.get(accountId)!=null){
                    decimal counterValue = parentCounterMap.get(accountId);
                    counterValue+=(accObj.Number_of_DL_s__c!=null ? accObj.Number_of_DL_s__c : 0);
                    parentCounterMap.put(accountId,counterValue);
                    if(childAccountMap!=null && childAccountMap.get(accountId)!=null){
                        List<Account> tempList = childAccountMap.get(accountId);
                        tempList.add(accObj);
                        childAccountMap.put(accountId,tempList);
                    } else {
                        childAccountMap.put(accountId,new List<Account>{accObj});
                    }
                } else {
                    parentCounterMap.put(accountId,(accObj.Number_of_DL_s__c!=null ? accObj.Number_of_DL_s__c : 0));
                    childAccountMap.put(accountId,new List<Account>{accObj});
                }           
            }
            
            
            
            for(Id idValue : childAccountMap.keySet()){
                for(Account accObj : childAccountMap.get(idValue)){
                    if(parentCounterMap!=null && parentCounterMap.get(idValue)!=null){
                        accObj.Total_DLs__c = parentCounterMap.get(idValue);
                        updatedAccountList.add(accObj);
                    }               
                }
            }
            
        }
        return updatedAccountList;
    }
    //-----------Deprecated-------------------------------------------------------------------------
    //------------commenting this functionality as this functionality is shifted in updatePaidAccountRelatedContacts functtion below--------------------
    //-----------------------As/Simplion/5/7/2015-----------------------------------------
    //----------This method is final optimized and ready to move to production---------------
    public static List<Contact> updateContactStatus(List<Account> accountList,Map<Id,Contact> allContactsOfNewAccount){
        Map<Id,String> accIdMapByStatus = new Map<Id,String>();
        List<Contact> lstOfContactsToUpdate = new List<Contact>();
        try{
            for(Account acc : accountList){
                if('Paid'.equalsIgnoreCase(acc.RC_Account_Status__c) || 'Cancelled'.equalsIgnoreCase(acc.RC_Account_Status__c)){
                    accIdMapByStatus.put(acc.id,acc.RC_Account_Status__c);
                }
            }
            
            for(Contact conObj : allContactsOfNewAccount.values()){
                String upcomingStatus = accIdMapByStatus.get(conObj.AccountId);
                if('Paid'.equalsIgnoreCase(upcomingStatus)) {
                    conObj.Contact_Status__c = 'Closed Won';
                    conObj.Contact_Funnel_Type__c = 'Customer';
                    lstOfContactsToUpdate.add(conObj);
                    
                }else if('Cancelled'.equalsIgnoreCase(upcomingStatus)){
                    conObj.Contact_Status__c = 'Cancelled';
                    lstOfContactsToUpdate.add(conObj);
                }
            }
             
        }catch(Exception ex){
            system.debug('Exception==========='+ex.getStackTraceString());
        }
        return lstOfContactsToUpdate;
    }
   
}