/**************************************************************************************************
* Project Name..........: Account Metrics Reporting                                               *
* File..................: AccountMetricsReportingController.class                                 *
* Version...............: 1.0                                                                     *
* Created by............: Simplion Technologies                                                   *
* Created Date..........: 11-09-2013                                                              *
* Last Modified by......: Simplion Technologies                                                   *
* Last Modified Date....: 11-09-2013                                                              *
* Description...........: This is a controller class for AccountMetricsReporting page             *
**************************************************************************************************/

public class AccountMetricsReportingController{ 
    
    //Constants
    /*Constant for default filter number*/
    private final Integer FILTER_QUANTITY = 4;
    private final Integer SORT_FIELD_LIMIT = 3;
    /*Constant for Sales Department*/
    private final String SALES = 'Sales';
    /*Constants for owner type select radio*/
    private final String MY_ACCOUNTS = 'My Accounts (Current Owner)';
    private final String MY_TEAM_ACCOUNTS = 'My Team Accounts';
    private final String SPECIFIC_TEAM_ACCOUNTS = 'Specific Team Accounts';
    private final String SPECIFIC_REP_ACCOUNTS = 'Specific Rep Accounts'; 
    /*Constants for report type*/
    private final String STANDARD_REPORT = 'Standard Report';
    private final String CUSTOM_REPORT = 'Custom Report';
    /*Constans for operator value*/
    private final String EQUALS = 'Equals';
    private final String NOT_EQUAL = 'Not Equal to';
    private final String STARTS_WITH = 'Starts With';
    private final String CONTAINS = 'Contains';
    private final String DOES_NOT_CONTAIN = 'Does Not Contain';
    private final String LESS_THAN = 'Less Than';   
    private final String GREATER_THAN = 'Greater Than';
    private final String LESS_EQUALS = 'Less or Equal';
    private final String GREATER_EQUALS = 'Greater or Equal';
    private final String INCLUDE = 'Includes';
    private final String EXCLUDES = 'Excludes';
    /*Constant for maximum filter limit*/
    private final Integer FILTER_LIMIT = 10;
    /*Constant for query limit*/
    private final Integer QUERY_LIMIT = 1000;   
    /**/
    public final String ACCOUNT_BRAND = 'ACCOUNT-Brand';
    public final String ACCOUNT_SERVICE = 'ACCOUNT-Service';
    public final String ACCOUNT_STATUS = 'ACCOUNT-Status';
    /*Map for fieldtype,operator list*/
    public static Map<String,List<String>> OPERATOR_STATIC = new Map<String,List<String>>(); // Map for datatype,operators
    
    //Variables
    public Integer offsetSize = 0; // Contains the offset size
    public Integer filterPos {get; set;}// Contains the filter position, to be used to calculate filter limit
    public Integer currentField {get; set;}
    public String filterValue {get; set;}
    public String fieldValue {get; set;}
    public String operatorValue {get; set;}
    public String value {get; set;}
    public String reportType {get; set;} // Contains report type value
    public String queryRecord; // Contains the final query to fetch records
    public String filterOwner {get; set;} //  Contains Team or reporting user value
    public List<String> listBrandSelected {get; set;} // Contains the list of brands selected
    public List<String> listServiceSelected {get; set;} // Contains the list of service selected
    public List<String> listStatusSelected {get; set;} //Contains the list of status selected
    public List<String> availableField {get; set;}
    public List<String> addFieldsList {get; set;}
    public List<String> removeFieldsList {get; set;}
    public List<String> fieldsSelected = new List<String>();
    public List<String> userId; // Contains list of user id, based on the owner type selected
    public List<String> sortByList{get; set;} // Contains list of sort by fields
    public List<String> standardSortBy;
    public List<SelectOption> availableSelectOption {get; set;}
    public List<SelectOption> selectedSelectOption {get; set;}
    public List<SelectOption> teamSelectOption {get; set;} // List of teams
    public List<SelectOption> repUserSelectOption {get; set;} //  List of reporting user
    public List<SelectOption> sortByOption {get; set;} // List of select option for sort fields
    public List<SelectOption> listBrands {get; set;} // List of account brands
    public List<SelectOption> listService {get; set;}// List of account service
    public List<SelectOption> listStatus {get; set;}// List of account status
    public List<Account_Metric_Reporting_Fields__c> queryResult {get; set;} //List to store Header fields/Query fields
    public List<Account_Metric_Reporting_Fields__c> fieldsList {get; set;} //List to store report fields 
    public Account_Metric_Reporting_Fields__c fieldsType {get; set;}
    public List<Account_Metric__c> mainResult {get; set;} 
    public List<FilterWrapper> filters {get; set;} // filter wrapper for storing values of a row
    public Boolean fieldsError {get; set;} // Boolean flag to render fields error message
    public Boolean filterError {get; set;} // Boolean flag to render filter error message
    public Boolean teamFlag {get; set;} // Boolean flag to render team select list option
    public Boolean repFlag {get; set;} // Boolean flag to render reporting user list option
    public Boolean reportError {get; set;} // Boolean flag to render report error message
    public Boolean isManager {get; set;} // Boolean flag for manager check
    public Boolean standardView {get; set;} // Boolean flag for standard view
    Account_Metric_Record_Limit__c recordObj = Account_Metric_Record_Limit__c.getInstance(); 
    
/******************************************************************************
* @Description - Constructor for controller class                             *
* @params void                                                                *
* @return void                                                                * 
******************************************************************************/ 
    public AccountMetricsReportingController(){
        
        system.debug('#### inside constructor');
        //Calling method to initialise all variables,lists,objects.
        objectInitializer();
        //Setting default owner type as my accounts.
        filterValue = MY_ACCOUNTS;
        //Setting default value for report type
        reportType = STANDARD_REPORT;
        // setting default values for filters upon initialisation.
        FilterWrapper filterObj = null;
        for(Integer i=0; i<FILTER_QUANTITY; i++) {
            filterObj = new FilterWrapper();
            filterObj.index = i;
            filterObj.operatorList = getOperatorValues(filterObj);
            filterObj.valueList = getPicklistVal(filterObj);
            // Logic for rendering the Add Filter button, at the last row
            if(i == FILTER_QUANTITY-1){
                filterObj.filterFlag = true;
            }
            else{
                filterObj.filterFlag = false;
            }
            filters.add(filterObj);
            filterPos = filters.size()-1;
        }
        system.debug('#### filters - '+filters);
        
        //Calling method to fetch fields
        getFields();
        //Calling method to fetch avaiable fields.
        addFields();
        //Calling method to fetch all brands, hardocoded, to populate in picklist
        getAllBrands();
        //Calling method to fetch all service, hardcoded to populate in picklist
        getAllService();
        //Calling method to fetch all status, harcoded to populate in picklist
        getAllStatus();
        //Calling method to check if the logged in user is a manager or not
        isManager = checkManager(userinfo.getuserid());
  }

/*****************************************************************************
* @Description - Method to initialize all variables,List,objects             * 
* @params void                                                               *
* @return void                                                               * 
*****************************************************************************/  
    public void objectInitializer(){
        availableSelectOption =  new List<SelectOption>();
        selectedSelectOption =  new List<SelectOption>();
        repUserSelectOption = new List<SelectOption>();
        teamSelectOption = new List<SelectOption>();
        sortByOption = new List<SelectOption>();
        listBrands = new List<SelectOption>();
        listStatus = new List<SelectOption>();
        listService = new List<SelectOption>();
        userId = new List<String>();
        sortByList = new List<String>();
        listStatusSelected = new List<String>();
        listServiceSelected = new List<String>();
        listBrandSelected = new List<String>();
        standardSortBy = new List<String>();
        addFieldsList = new List<String>();
        removeFieldsList = new List<String>();
        mainResult = new List<Account_Metric__c>();
        queryResult = new List<Account_Metric_Reporting_Fields__c>();
        fieldsList =  new List<Account_Metric_Reporting_Fields__c>();
        filters = new List<FilterWrapper>();
        fieldsError =  true;
        teamFlag =  false;
        reportError = false;
        repFlag =  false;
        standardView = true;
        
        // Adding standard sort by fields
        /*standardSortBy.add('ACCOUNT-Paid date');
        standardSortBy.add('ACCOUNT-Number of Dls');*/
        
    }

/*****************************************************************************
* @Description - Method for getting report Types                             * 
* @params void                                                               *
* @return List<SelectOption>                                                 * 
*****************************************************************************/ 
    public List<SelectOption> getReportTypes() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption(STANDARD_REPORT,STANDARD_REPORT));
        options.add(new SelectOption(CUSTOM_REPORT,CUSTOM_REPORT));        
        return options; 
    }    
    
/*****************************************************************************
* @Description - Method for getting filter 1 - Owner Type.                   * 
* @params void                                                               *
* @return List<SelectOption>                                                 * 
*****************************************************************************/ 
    public List<SelectOption> getFilterItems() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption(MY_ACCOUNTS,MY_ACCOUNTS));
        if(isManager == true){ 
            options.add(new SelectOption(MY_TEAM_ACCOUNTS,MY_TEAM_ACCOUNTS)); 
            options.add(new SelectOption(SPECIFIC_TEAM_ACCOUNTS,SPECIFIC_TEAM_ACCOUNTS)); 
            options.add(new SelectOption(SPECIFIC_REP_ACCOUNTS,SPECIFIC_REP_ACCOUNTS));
        }
        return options; 
    }
    
/*****************************************************************************
* @Description - Method for getting filter items 2.1 - Field values.         * 
* @params void                                                               *
* @return List<SelectOption>                                                 * 
*****************************************************************************/
    public List<SelectOption> getFieldItems(){
        try{
            // Calling method to fetch field from custom setting.
            List<SelectOption> options = new List<SelectOption>();
            //List<Account_Metric_Reporting_Fields__c> fieldsList = getFields();
            options.add(new SelectOption('None','--None--')); 
            for(Account_Metric_Reporting_Fields__c thisField : fieldsList){
                if(thisField.Name != 'ACCOUNT-Current Owner')        
                    options.add(new SelectOption(thisField.Name,thisField.Name)); 
            }
            return options;
        }catch(Exception e){
            fieldsError =  true;
            filterError = false;
            reportError = false;
            system.debug('#### Exception 188 - '+e.getMessage());
            ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.WARNING,'No records found, Please modify your filter criteria.'));
            return null;
        }
    }

/*****************************************************************************
* @Description - Method to get  filter items 2.2-Fill operator drop-down.    *
* @params void                                                               *
* @return List<SelectOption>                                                 * 
*****************************************************************************/  
    public List<SelectOption> getOperatorValues(FilterWrapper fw) {
        
        try{
            //Calling method to initialize operator map.
            initializeOperator();
            String fieldType;
            List<SelectOption> options = new List<SelectOption>();
            if(fw.fieldType != null){
                fieldType = OPERATOR_STATIC.get((fw.fieldType).capitalize()) != NULL ? (fw.fieldType).capitalize() : 'Default';
            }
            else{
                fieldType = 'Default';
            }
            options.add(new SelectOption('', '--None--'));
            system.debug('#### fieldType - '+fieldType);
            system.debug('#### OPERATOR_STATIC - '+OPERATOR_STATIC);
            
            /**For Exceptional case of brand, status,service**/
            if(fw.filterName == ACCOUNT_BRAND ){ 
                fieldType = 'Mutli-Picklist';
            }
            if(fw.filterName == ACCOUNT_SERVICE ){ 
                fieldType = 'Mutli-Picklist';
            }
            if(fw.filterName == ACCOUNT_STATUS ){ 
                fieldType = 'Mutli-Picklist';
            }
            for(String thisString : OPERATOR_STATIC.get(fieldType.capitalize())){
                options.add(new SelectOption(thisString, thisString));
            }
            return options;
            
        }catch (Exception e){
            fieldsError =  true;
            filterError = false;
            reportError = false;
            system.debug('#### Exception 246 - '+e.getMessage());
            ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.WARNING,'No matching result found, please modify your search criteria.') );
            return null;
        }
    }

/*****************************************************************************
* @Description - Method to route according to report type                    *
* @params void                                                               *
* @return void                                                               * 
*****************************************************************************/
public void reportTypeView(){
    if(reportType == CUSTOM_REPORT){
        standardView = false;
        addFieldsList.clear();
        removeFieldsList.clear();
        selectedSelectOption.clear();
        sortByOption.clear();
        getFields();
        //addFields();     
        //selectSortFields();
    }else{
        standardView = true;
        getFields();
    }
}

/*****************************************************************************
* @Description - Method to query and fetch records.                          *
* @params void                                                               *
* @return pageReference to result page                                       * 
*****************************************************************************/  
    public pagereference fetchRecords(){
        
        String filterName;
        Date containsDate;
        DateTime StartDateTime;
        DateTime EndDateTime;
        Boolean nullCheckFlag;
        
        try{        
            system.debug('#### - filterValue '+filterValue);
            system.debug('#### - filters - '+filters);
            system.debug('#### - sort by fields - '+sortByOption);
            system.debug('#### - standardView - '+standardView);
            system.debug('#### - listBrandSelected '+listBrandSelected);
            system.debug('#### - selectedSelectOption - '+selectedSelectOption);
            
            List<String> selectedFields = new List<String>();
            PageReference page;
            String queryValue;
            
            /*Getting List of user as per the owner type selected*/
            //My Accounts :  Records related to logged in user.
            if(filterValue == MY_ACCOUNTS){
                userId.add(userinfo.getuserid());
            }
            // My Team Accounts : Records related to logged in user, and the records of the 
            //                    users the logged in user is the manager(check in employee for hierarchy).
            else if(filterValue == MY_TEAM_ACCOUNTS){
                userId.add(userinfo.getuserid());
                try {
                    Employee__c userEmployee = fetchUserEmployeeDetails(userinfo.getuserid());
                    List<Employee__c> userReportingList = [SELECT User__c FROM Employee__c 
                                                           WHERE Manager_Employee_Number__c =: userEmployee.Id AND Is_Active__c =  true AND 
                                                                 User__r.IsActive = true LIMIT 10000];
                                                                 
                    for(Employee__c thisEmployee : userReportingList){
                        userId.add(thisEmployee.User__c);                   
                    }
                } catch(Exception e) {
                    /*
                    fieldsError =  true;
                    ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.INFO, queryRecord) );
                    return null;
                    */
                }
                system.debug('#### user list my team accounts- '+userId);
            }
            //Specific Team Accounts : Records related to the users of the team selected from page.
            else if(filterValue == SPECIFIC_TEAM_ACCOUNTS){
                system.debug('#### filterOwner - '+filterOwner);
                try {
                    Employee__c employeeDetails = fetchUserEmployeeDetails(userinfo.getuserid());
                    List<Employee__c> userReportingList = [SELECT User__c FROM Employee__c 
                                                           WHERE Division__c =: filterOwner AND Is_Active__c = true 
                                                                 AND User__r.IsActive = true limit 10000];
                    //String teamName = [SELECT Team__c FROM user WHERE Id =: userinfo.getuserid()].Team__c;
                    for(Employee__c thisEmployee : userReportingList){
                        userId.add(thisEmployee.User__c);   
                    }
                } catch(Exception e) {}
                system.debug('#### user list specific team - '+userId);
            }
            // Specific Rep Accounts : Records related to the users reporting to the logged in users
            else if(filterValue == SPECIFIC_REP_ACCOUNTS){
                system.debug('#### filterOwner - '+filterOwner);
                try{
                    userId.add(filterOwner);
                }catch(Exception e){
                    system.debug('#### exception 325 - '+e.getMessage());
                }
                system.debug('#### user list specific rep - '+userId);
            }

            // Check if the fields have been selected to query for report or not.
            if(selectedSelectOption.size() > 0){
                //Fetching API Name for fields during run time for filter fields & fields to query
                queryRecord = 'SELECT Id, Name, Account_ID__c, Account_ID__r.Name, Account_ID__r.CurrencyIsoCode,';
                
                for(SelectOption thisOption : selectedSelectOption){
                    if(Account_Metric_Reporting_Fields__c.getInstance(thisOption.getValue()) != null){
                        if(Account_Metric_Reporting_Fields__c.getInstance(thisOption.getValue()).IsActive__c == true){
                            queryRecord = queryRecord+Account_Metric_Reporting_Fields__c.getInstance(thisOption.getValue()).API_Name__c+',';
                        }
                    }
                    selectedFields.add(thisOption.getValue());
                }
                
                system.debug('#### selectedFields - '+selectedFields);
                queryRecord = (queryRecord.trim()).left(queryRecord.length()-1);
                queryRecord = queryRecord+' FROM Account_Metric__c WHERE Account_ID__r.Current_Owner__c IN: userId AND ';
                //queryRecord = queryRecord+' FROM Account_Metric__c WHERE OwnerId IN: userId AND ';
                    
                for(FilterWrapper thisFilter : filters){
                    // If conditon to check if the filter and operator is selected or not
                    if(Account_Metric_Reporting_Fields__c.getInstance(thisFilter.filterName) != null && thisFilter.operator != null){
                        
                        if(Account_Metric_Reporting_Fields__c.getInstance(thisFilter.filterName).IsActive__c == true){
                            
                            // Check for string entered in number field,date field
                            if(Account_Metric_Reporting_Fields__c.getInstance(thisFilter.filterName).Type__c.containsIgnoreCase('Date/Time')){
                                //system.debug('#### date time, filter value - '+thisFilter.value);
                                system.debug('#### date time, filter value - '+thisFilter.ownerAccount.Approval_Date__c);
                                thisFilter.value = String.valueOf(thisFilter.ownerAccount.Approval_Date__c);
                                if(String.isBlank(thisFilter.value)){
                                    //containsDate = null;
                                    //StartDateTime = null;
                                    //EndDateTime = null;
                                    nullCheckFlag = true;
                                    queryValue = null;
                                }
                                else{
                                    containsDate = thisFilter.ownerAccount.Approval_Date__c;
                                    StartDateTime = getActualStartDateTimeObject(containsDate);
                                    EndDateTime = getActualDateEndTimeObject(containsDate);
                                }
                            }
                            if(Account_Metric_Reporting_Fields__c.getInstance(thisFilter.filterName).Type__c.containsIgnoreCase('Text')){
                                system.debug('#### Text - '+thisFilter.value);
                                if(String.isBlank(thisFilter.value)){
                                    nullCheckFlag = true;
                                    queryValue = null;
                                }else{
                                    queryValue = thisFilter.value;
                                }
                            }
                            if(Account_Metric_Reporting_Fields__c.getInstance(thisFilter.filterName).Type__c.containsIgnoreCase('Lookup')){
                                system.debug('#### Lookup - '+thisFilter.ownerAccount.Current_Owner__c);
                                // thisFilter.value = thisFilter.ownerAccount.Current_Owner__r.Name;
                                if(thisFilter.ownerAccount.Current_Owner__c != null){
                                    User currentUser = [SELECT Id,Name FROM User WHERE Id =: thisFilter.ownerAccount.Current_Owner__c AND IsActive =: true];
                                    queryValue = currentUser.Name;
                                }
                                else{
                                    queryValue =  null;
                                    nullCheckFlag = true;
                                }
                                system.debug('#### queryValue - '+queryValue);
                            }
                            if(Account_Metric_Reporting_Fields__c.getInstance(thisFilter.filterName).Type__c.containsIgnoreCase('Checkbox') || 
                               Account_Metric_Reporting_Fields__c.getInstance(thisFilter.filterName).Type__c.containsIgnoreCase('Boolean')){
                                system.debug('#### checkbox - '+thisFilter.value);
                                if(String.isBlank(thisFilter.value)){
                                    queryValue = 'false';
                                }else{
                                    queryValue = thisFilter.value;
                                }
                            }
                            if(Account_Metric_Reporting_Fields__c.getInstance(thisFilter.filterName).Type__c.containsIgnoreCase('Number') || 
                               Account_Metric_Reporting_Fields__c.getInstance(thisFilter.filterName).Type__c.containsIgnoreCase('Currency') ||
                               Account_Metric_Reporting_Fields__c.getInstance(thisFilter.filterName).Type__c.containsIgnoreCase('Percent')){
                                system.debug('#### Number - '+thisFilter.value);
                                //thisFilter.value = String.isBlank(thisFilter.value) ? '0' : thisFilter.value;
                                filterName = thisFilter.filterName;
                                //Integer.valueOf(thisFilter.value);
                                //Decimal.valueOf(thisFilter.value);
                                Decimal.valueOf(String.isBlank(thisFilter.value) ? '0' : thisFilter.value);
                                queryValue = thisFilter.value;
                                /*if(Account_Metric_Reporting_Fields__c.getInstance(thisFilter.filterName).Type__c.containsIgnoreCase('Percent')){
                                    if((Decimal.valueOf(String.isBlank(thisFilter.value) ? '0' : thisFilter.value)) <0 || 
                                        (Decimal.valueOf(String.isBlank(thisFilter.value) ? '0' : thisFilter.value)) > 100){
                                        fieldsError = true;
                                        ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.WARNING,'Invalid value for filter - '+filterName+' ( field type percent : values 0-100% )'));
                                        queryValue = String.valueOf(Decimal.valueOf(thisFilter.value).setScale(2));
                                        system.debug('#### Exception 446 - '+queryValue);
                                        return null;    
                                    }
                                }*/
                                if(String.isBlank(thisFilter.value)){
                                    nullCheckFlag = true;
                                    queryValue = null;
                                }else{  
                                    queryValue = Account_Metric_Reporting_Fields__c.getInstance(thisFilter.filterName).Type__c.containsIgnoreCase('Percent') ? String.valueOf((Decimal.valueOf(thisFilter.value).setScale(2))/100) : thisFilter.value;
                                }
                                system.debug('#### Number queryValue - '+queryValue);
                            }
                            
                            //Coverting the corresponding operator name to proper query field
                            if(thisFilter.operator == EQUALS ){
                                
                                if(nullCheckFlag == true && queryValue == null){
                                    system.debug('#### field null');
                                    queryRecord = queryRecord+Account_Metric_Reporting_Fields__c.getInstance(thisFilter.filterName).API_Name__c+' = NULL AND ';
                                }
                                else if(Account_Metric_Reporting_Fields__c.getInstance(thisFilter.filterName).Type__c.containsIgnoreCase('Date/Time')){
                                    queryRecord = queryRecord+Account_Metric_Reporting_Fields__c.getInstance(thisFilter.filterName).API_Name__c+' >= :StartDateTime AND '+
                                                              Account_Metric_Reporting_Fields__c.getInstance(thisFilter.filterName).API_Name__c+' <= :EndDateTime AND ';
                                }
                                else if(Account_Metric_Reporting_Fields__c.getInstance(thisFilter.filterName).Type__c.containsIgnoreCase('Number') || 
                                        Account_Metric_Reporting_Fields__c.getInstance(thisFilter.filterName).Type__c.containsIgnoreCase('Currency') ||
                                        Account_Metric_Reporting_Fields__c.getInstance(thisFilter.filterName).Type__c.containsIgnoreCase('Checkbox') ||
                                        Account_Metric_Reporting_Fields__c.getInstance(thisFilter.filterName).Type__c.containsIgnoreCase('Boolean') || 
                                        Account_Metric_Reporting_Fields__c.getInstance(thisFilter.filterName).Type__c.containsIgnoreCase('Percent')){
                                    system.debug('#### thisFilter.value - '+thisFilter.value);
                                    queryRecord = queryRecord+Account_Metric_Reporting_Fields__c.getInstance(thisFilter.filterName).API_Name__c+' = '+queryValue+' AND ';
                                }
                                else{
                                    system.debug('#### queryValue default - '+queryValue);
                                    queryRecord = queryRecord+Account_Metric_Reporting_Fields__c.getInstance(thisFilter.filterName).API_Name__c+' = :queryValue AND ';
                                }
                            }else if(thisFilter.operator == NOT_EQUAL){
                                
                                if(nullCheckFlag == true && queryValue == null){
                                    system.debug('#### field null');
                                    queryRecord = queryRecord+Account_Metric_Reporting_Fields__c.getInstance(thisFilter.filterName).API_Name__c+' != NULL AND ';
                                }
                                else if(Account_Metric_Reporting_Fields__c.getInstance(thisFilter.filterName).Type__c.containsIgnoreCase('Date/Time')){
                                    queryRecord = queryRecord+Account_Metric_Reporting_Fields__c.getInstance(thisFilter.filterName).API_Name__c+' <= :StartDateTime AND '+
                                                              Account_Metric_Reporting_Fields__c.getInstance(thisFilter.filterName).API_Name__c+' >= :EndDateTime AND ';
                                }
                                else if(Account_Metric_Reporting_Fields__c.getInstance(thisFilter.filterName).Type__c.containsIgnoreCase('Number') || 
                                        Account_Metric_Reporting_Fields__c.getInstance(thisFilter.filterName).Type__c.containsIgnoreCase('Currency') ||
                                        Account_Metric_Reporting_Fields__c.getInstance(thisFilter.filterName).Type__c.containsIgnoreCase('Checkbox') ||
                                        Account_Metric_Reporting_Fields__c.getInstance(thisFilter.filterName).Type__c.containsIgnoreCase('Boolean') ||
                                        Account_Metric_Reporting_Fields__c.getInstance(thisFilter.filterName).Type__c.containsIgnoreCase('Percent')){
                                    system.debug('#### thisFilter.value - '+thisFilter.value);
                                    queryRecord = queryRecord+Account_Metric_Reporting_Fields__c.getInstance(thisFilter.filterName).API_Name__c+' != '+queryValue+' AND ';
                                }
                                else{
                                    queryRecord = queryRecord+Account_Metric_Reporting_Fields__c.getInstance(thisFilter.filterName).API_Name__c+' != :queryValue AND ';
                                }
                            }
                            else if(thisFilter.operator == CONTAINS){
                                queryValue= String.isBlank(queryValue) ? '%'+queryValue+'%':null;
                                system.debug('#### queryValue - '+queryValue);
                                queryRecord = queryRecord+Account_Metric_Reporting_Fields__c.getInstance(thisFilter.filterName).API_Name__c+' LIKE :queryValue AND ';
                            }
                            else if(thisFilter.operator == DOES_NOT_CONTAIN ){
                                queryValue='%'+queryValue+'%';
                                queryRecord = queryRecord+'(NOT '+Account_Metric_Reporting_Fields__c.getInstance(thisFilter.filterName).API_Name__c+' LIKE :queryValue) AND ';
                            }
                            else if(thisFilter.operator == LESS_THAN ){
                                if(Account_Metric_Reporting_Fields__c.getInstance(thisFilter.filterName).Type__c.containsIgnoreCase('Date/Time')){
                                    queryRecord = queryRecord+Account_Metric_Reporting_Fields__c.getInstance(thisFilter.filterName).API_Name__c+' < :StartDateTime AND ';
                                }
                                else if(Account_Metric_Reporting_Fields__c.getInstance(thisFilter.filterName).Type__c.containsIgnoreCase('Number') || 
                                        Account_Metric_Reporting_Fields__c.getInstance(thisFilter.filterName).Type__c.containsIgnoreCase('Currency') ||
                                        Account_Metric_Reporting_Fields__c.getInstance(thisFilter.filterName).Type__c.containsIgnoreCase('Percent')){
                                    system.debug('#### thisFilter.value (<) - '+thisFilter.value);
                                    queryValue = String.isBlank(queryValue) ? '0':queryValue;
                                    queryRecord = queryRecord+Account_Metric_Reporting_Fields__c.getInstance(thisFilter.filterName).API_Name__c+' < '+queryValue+' AND ';
                                }
                                else{
                                    queryRecord = queryRecord+Account_Metric_Reporting_Fields__c.getInstance(thisFilter.filterName).API_Name__c+' < :queryValue AND ';
                                }
                            }
                            else if(thisFilter.operator == LESS_EQUALS ){
                                if(Account_Metric_Reporting_Fields__c.getInstance(thisFilter.filterName).Type__c.containsIgnoreCase('Date/Time')){
                                    queryRecord = queryRecord+Account_Metric_Reporting_Fields__c.getInstance(thisFilter.filterName).API_Name__c+' <= :StartDateTime AND ';
                                }
                                else if(Account_Metric_Reporting_Fields__c.getInstance(thisFilter.filterName).Type__c.containsIgnoreCase('Number') || 
                                        Account_Metric_Reporting_Fields__c.getInstance(thisFilter.filterName).Type__c.containsIgnoreCase('Currency') || 
                                        Account_Metric_Reporting_Fields__c.getInstance(thisFilter.filterName).Type__c.containsIgnoreCase('Percent')){
                                    system.debug('#### thisFilter.value (<=) - '+thisFilter.value);
                                    queryValue = String.isBlank(queryValue) ? '0':queryValue;
                                    queryRecord = queryRecord+Account_Metric_Reporting_Fields__c.getInstance(thisFilter.filterName).API_Name__c+' <= '+queryValue+' AND ';
                                }
                                else{
                                    queryRecord = queryRecord+Account_Metric_Reporting_Fields__c.getInstance(thisFilter.filterName).API_Name__c+' <= :queryValue AND ';
                                }
                            }
                            else if(thisFilter.operator == GREATER_THAN ){
                                if(Account_Metric_Reporting_Fields__c.getInstance(thisFilter.filterName).Type__c.containsIgnoreCase('Date/Time')){
                                    queryRecord = queryRecord+Account_Metric_Reporting_Fields__c.getInstance(thisFilter.filterName).API_Name__c+' > :StartDateTime AND ';
                                }
                                else if(Account_Metric_Reporting_Fields__c.getInstance(thisFilter.filterName).Type__c.containsIgnoreCase('Number') || 
                                        Account_Metric_Reporting_Fields__c.getInstance(thisFilter.filterName).Type__c.containsIgnoreCase('Currency') ||
                                        Account_Metric_Reporting_Fields__c.getInstance(thisFilter.filterName).Type__c.containsIgnoreCase('Percent')){
                                    system.debug('#### thisFilter.value (>)- '+thisFilter.value);
                                    system.debug('#### queryValue (>) - '+queryValue);
                                    queryValue = String.isBlank(queryValue) ? '0':queryValue;
                                    queryRecord = queryRecord+Account_Metric_Reporting_Fields__c.getInstance(thisFilter.filterName).API_Name__c+' > '+queryValue+' AND ';
                                }
                                else{
                                    queryRecord = queryRecord+Account_Metric_Reporting_Fields__c.getInstance(thisFilter.filterName).API_Name__c+' > :queryValue AND ';
                                }
                            }
                            else if(thisFilter.operator == GREATER_EQUALS ){
                                if(Account_Metric_Reporting_Fields__c.getInstance(thisFilter.filterName).Type__c.containsIgnoreCase('Date/Time')){
                                    queryRecord = queryRecord+Account_Metric_Reporting_Fields__c.getInstance(thisFilter.filterName).API_Name__c+' >= :StartDateTime AND ';
                                }
                                else if(Account_Metric_Reporting_Fields__c.getInstance(thisFilter.filterName).Type__c.containsIgnoreCase('Number') || 
                                        Account_Metric_Reporting_Fields__c.getInstance(thisFilter.filterName).Type__c.containsIgnoreCase('Currency') ||
                                        Account_Metric_Reporting_Fields__c.getInstance(thisFilter.filterName).Type__c.containsIgnoreCase('Percent')){
                                    system.debug('#### thisFilter.value (>=) - '+thisFilter.value);
                                    queryValue = String.isBlank(queryValue) ? '0':queryValue;
                                    queryRecord = queryRecord+Account_Metric_Reporting_Fields__c.getInstance(thisFilter.filterName).API_Name__c+' >= '+queryValue+' AND ';
                                }
                                else{
                                    queryRecord = queryRecord+Account_Metric_Reporting_Fields__c.getInstance(thisFilter.filterName).API_Name__c+' >= :queryValue AND ';
                                }
                            }
                            else if(thisFilter.operator == INCLUDE ){
                                queryValue='%'+queryValue+'%';
                                /********** Handling Exception case for Brand, Service & Account Status **********/
                                //If brand name is selected
                                if(thisFilter.filterName == ACCOUNT_BRAND){
                                    queryRecord +=  Account_Metric_Reporting_Fields__c.getInstance(thisFilter.filterName).API_Name__c+' IN: listBrandSelected AND ';
                                }
                                else if(thisFilter.filterName == ACCOUNT_SERVICE){
                                        System.debug(' ==== SERVICE = ' + listServiceSelected);
                                    queryRecord +=  Account_Metric_Reporting_Fields__c.getInstance(thisFilter.filterName).API_Name__c+' IN: listServiceSelected AND ';
                                }
                                else if(thisFilter.filterName == ACCOUNT_STATUS){
                                    queryRecord +=  Account_Metric_Reporting_Fields__c.getInstance(thisFilter.filterName).API_Name__c+' IN: listStatusSelected AND ';
                                }
                                else{
                                    queryRecord = queryRecord+Account_Metric_Reporting_Fields__c.getInstance(thisFilter.filterName).API_Name__c+' LIKE :queryValue AND ';
                                }
                            }
                            else if(thisFilter.operator == EXCLUDES ){
                                queryValue='%'+queryValue+'%';
                                /********** Handling Exception case for Brand, Service & Account Status **********/
                                //If brand name is selected
                                if(thisFilter.filterName == ACCOUNT_BRAND){
                                    queryRecord +=  Account_Metric_Reporting_Fields__c.getInstance(thisFilter.filterName).API_Name__c+' NOT IN: listBrandSelected AND ';
                                }
                                else if(thisFilter.filterName == ACCOUNT_SERVICE){
                                    queryRecord +=  Account_Metric_Reporting_Fields__c.getInstance(thisFilter.filterName).API_Name__c+' NOT IN: listServiceSelected AND ';
                                }
                                else if(thisFilter.filterName == ACCOUNT_STATUS){
                                    queryRecord +=  Account_Metric_Reporting_Fields__c.getInstance(thisFilter.filterName).API_Name__c+' NOT IN: listStatusSelected AND ';
                                }
                                else{
                                    queryRecord = queryRecord+'(NOT '+Account_Metric_Reporting_Fields__c.getInstance(thisFilter.filterName).API_Name__c+' LIKE :queryValue) AND ';
                                }
                            }
                            else if(thisFilter.operator == STARTS_WITH ){
                                queryValue=queryValue+'%';
                                queryRecord = queryRecord+Account_Metric_Reporting_Fields__c.getInstance(thisFilter.filterName).API_Name__c+' LIKE :queryValue AND ';
                            }
                        }
                    }
                }
                queryRecord = (queryRecord.trim()).left(queryRecord.length()-4);
                system.debug('#### standardView - '+standardView);
                if(sortByOption.size() > 0 || sortByList.size() > 0){
                    
                    List<String> sortByFields = new List<String>();
                    queryRecord += ' ORDER BY '; //+ ' LIMIT :QUERY_LIMIT ';
                    
                    //Creating list of sort by field
                    sortByFields.addAll(sortByList);
                    /*if(standardView ==  true){
                        sortByFields.addAll(standardSortBy);
                    }else{
                        sortByFields.addAll(sortByList);
                    }*/
                    for(String thisOption : sortByFields){
                        queryRecord += Account_Metric_Reporting_Fields__c.getInstance(thisOption).API_Name__c+',';
                    }
                    queryRecord = (queryRecord.trim()).left(queryRecord.length()-1);
                    queryRecord += ' ASC NULLS FIRST Limit ' + Integer.valueOf(recordObj.Number_of_Record__c) + '';
                    
                } else {
                	if((sortByOption.size()+ removeFieldsList.size())> SORT_FIELD_LIMIT){
	                	reportError =  true;
	                	system.debug('#### line 681 - ');
	                	ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.WARNING,'Maximum 2 Sort By fields allowed.'));
	                	return null;
                	}
                    queryRecord += ' ORDER BY LastModifiedDate DESC Limit ' + Integer.valueOf(recordObj.Number_of_Record__c) + '';
                }
                system.debug('#### query - '+queryRecord);
                system.debug('#### USER-ID - '+userId);
                //mainResult = Database.query(queryRecord);
                // Get a query locator
                Database.QueryLocator result = Database.getQueryLocator(queryRecord);
                // Get an iterator
                Database.QueryLocatorIterator resultIterator =  result.iterator();
                // Iterate over the records
                while (resultIterator.hasNext()){
                    mainResult.add((Account_Metric__c)resultIterator.next());
                }
                system.debug('#### mainResult - '+mainResult);
                if(mainResult != null){
                    queryResult = [SELECT Name,API_Name__c,Object_API_Name__c,Type__c, Suggested_Values__c,forSort__c,forStandard__c FROM Account_Metric_Reporting_Fields__c WHERE Name in: selectedFields ORDER BY Name ASC];
                    page = new PageReference('/apex/AccountMetricsResult') ;
                    // page = new PageReference('/apex/TestPage') ;
                    page.setRedirect(false);
                }
            }
            else{
                fieldsError =  true;
                filterError = false;
            	reportError = false;
                ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.WARNING, 'No field selected for report.') );
                system.debug('#### No field exception');
                return null;
            }
            return page;
        }catch(TypeException te){
            fieldsError = true;
            filterError = false;
            reportError = false;
            ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.WARNING,'Invalid value for filter - '+filterName));
            system.debug('#### Exception 646 - '+ te.getMessage());
            return null;
        }
        catch(Exception e){
            fieldsError = true;
            filterError = false;
            reportError = false;
            ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.WARNING,'No records found, Please modify your filter criteria.'));
            //ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.WARNING,e.getMessage()));
            system.debug('#### Exception 653 - '+ e.getMessage());
            return null;
        }
    }

/*****************************************************************************
* @Description - Method to reset filters                                     *
* @params void                                                               *
* @return pageReference to home page                                         * 
*****************************************************************************/  
    public PageReference resetFilter(){ 
        PageReference page = new PageReference('/apex/AHMTool') ;
        page.setRedirect(true);
        return page;        
    }

/*****************************************************************************
* @Description - Method to go back to main AHM Tool screen                   *
* @params void                                                               *
* @return pageReference to home page                                         * 
*****************************************************************************/  
    public PageReference backMain(){
        PageReference page = new PageReference('/apex/AHMTool') ;
        page.setRedirect(true);
        return page;
    }
    
/*****************************************************************************
* @Description - Method to render page as csv                                *
* @params void                                                               *
* @return pageReference to CSV result page                                   * 
*****************************************************************************/
    public PageReference exportToCSV(){
        PageReference page = new PageReference('/apex/AHMExportCSV') ;
        page.setRedirect(false);
        return page;
    }
/*****************************************************************************
* @Description - Method to render page as Excel                              *
* @params void                                                               *
* @return pageReference to CSV result page                                   * 
*****************************************************************************/
    public PageReference exportToExcel(){
        PageReference page = new PageReference('/apex/AccountMetricsResultCSV') ;
        page.setRedirect(false);
        return page;
    }   
/*****************************************************************************
* @Description - Method to add new filter row                                *
* @params void                                                               *
* @return void                                                               * 
*****************************************************************************/
    public void addFilter() {
        try{
            if(filters.size() == FILTER_LIMIT){
                filterError = true;
                fieldsError = false;
                ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.WARNING, 'Maximum 10 limit for filter reached.') );
                return;
            }
            FilterWrapper filterObj = new FilterWrapper();
            filterObj.index = filters.size();
            filterObj.valueList = getPicklistVal(filterObj);
            filterObj.operatorList = getOperatorValues(filterObj);
            filters.add(filterObj);
            filterPos = filterPos+1;
        }catch(Exception e){
            fieldsError =  true;
            filterError = false;
            reportError = false;
            system.debug('#### Exception 720 - '+e.getMessage());
            ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.WARNING,'No records found, Please modify your filter criteria.'));
        }
    }

/*****************************************************************************
* @Description - Method for selecting values for field type Checkbox         *
*                DateTime,Picklist                                           *
* @params filterWrapper                                                      *
* @return List<SelectOption>                                                 * 
*****************************************************************************/    
    public List<SelectOption> getPicklistVal(FilterWrapper fw) {
        try{
            system.debug('#### Line 307 field Type - '+fw.fieldType);
            List<SelectOption> options = new List<SelectOption>();
            // Generating picklist values for fields
            if(fw != null && fw.fieldType == 'Picklist') {
                options.add(new SelectOption('', '--None--'));
                if(Account_Metric_Reporting_Fields__c.getInstance(fw.filterName) != null ){
                    return getPickValues(getSobject(fw), Account_Metric_Reporting_Fields__c.getInstance(fw.filterName).API_Name__c, '--None--');
                }
                return null;
            } 
            // Generating Checkbox picklist for Checkbox type field
            else if(fw != null && (fw.fieldType == 'Checkbox' || fw.fieldType == 'Boolean' )) {
                String suggestedValue = Account_Metric_Reporting_Fields__c.getInstance(fw.filterName).Suggested_Values__c;
                if(!String.isBlank(suggestedValue)) {
                    options.add(new SelectOption('0', '--None--'));
                    for(String value : suggestedValue.split(',')) {
                        options.add(new SelectOption(value, (value == '1'?'Yes': 'No')));
                    }
                } else {
                    options.add(new SelectOption('', '--None--'));
                    options.add(new SelectOption('true', 'Yes'));
                    options.add(new SelectOption('false', 'No'));
                }
            }
            return options;
        }catch(Exception e){
            fieldsError =  true;
            filterError = false;
            reportError = false;
            system.debug('#### Exception 760 - '+e.getMessage());
            ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.WARNING,'No records found, Please modify your filter criteria.'));
            return null;
        }
    }
    
/*****************************************************************************
* @Description - Method to build a picklist of values based upon the         *
*                passed information                                          *
* @params filterWrapper                                                      *
* @return List<SelectOption>                                                 * 
*****************************************************************************/
    public List<selectOption> getPickValues(Sobject object_name, String field_name, String first_val) {
        
        system.debug('#### object_name - '+object_name);
        system.debug('#### field_name - '+field_name);
        system.debug('#### first_val - '+first_val);
        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
        try{
            if (first_val != null) { //if there is a first value being provided
                options.add(new selectOption('', first_val)); //add the first option
            }
            Schema.sObjectType sobject_type = object_name.getSObjectType(); //grab the sobject that was passed
            Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); //describe the sobject
            Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); //get a map of fields for the passed sobject
            List<Schema.PicklistEntry> pick_list_values = new List<Schema.PicklistEntry>();
            system.debug('#### field_map - '+field_map);
            if(field_map.get(field_name) != null){
                pick_list_values = field_map.get(field_name).getDescribe().getPickListValues();
            } 
            else{
                filterError = true;
                fieldsError =  false;
                ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.WARNING,'Field with API Name '+field_name+' can\'t be found.'));
            }
            //grab the list of picklist values for the passed field on the sobject
            for (Schema.PicklistEntry a : pick_list_values) { //for all values in the picklist list
                options.add(new selectOption(a.getValue(), a.getValue())); //add the value and label to our final list
            }
            return options; //return the List
        }catch(Exception e){
            fieldsError = true;
            filterError = false;
            reportError = false;
            ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.WARNING,'No records found, Please modify your filter criteria.'));
            system.debug('#### Exception 803 - '+ e.getMessage());
            return options;
        }
    }
    
/*****************************************************************************
* @Description - Method to render filter row on change of values             *
* @params void                                                               *
* @return pageReference to home page                                         * 
*****************************************************************************/
    public pageReference changeDisplayList() {
        try{
            system.debug('#### currentField - '+currentField);
            if(currentField != null){
                if(Account_Metric_Reporting_Fields__c.getInstance(filters[currentField].filterName) != null){
                    filters[currentField].fieldType = Account_Metric_Reporting_Fields__c.getInstance(filters[currentField].filterName).Type__c;
                }
                else{
                    filters[currentField].fieldType =  null;
                }
                filters[currentField].operator = null;
                filters[currentField].value = null;
                filters[currentField].operatorList = getOperatorValues(filters[currentField]);
                filters[currentField].valueList = getPicklistVal(filters[currentField]);
            System.debug('####'+filters[currentField]);
            }   
            return null;
        }catch(Exception e){
            fieldsError = true;
            filterError = false;
            reportError = false;
            ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.WARNING,'No records found, Please modify your filter criteria.'));
            system.debug('#### Exception 833 - '+ e.getMessage());
            return null;
        }
    }
    
/*****************************************************************************
* @Description - Method for available fields for reporting                   *
* @params void                                                               *
* @return void                                                               * 
*****************************************************************************/
    public void addFields(){
        try{
            system.debug('#### selected fields to add - '+addFieldsList);
            Set<String> addFieldsSet = new Set<String>();
            for(SelectOption thisOption : selectedSelectOption){
                addFieldsList.add(thisOption.getLabel());
            }
            
            //List<Account_Metric_Reporting_Fields__c> fieldsList = getFields();
            Set<String> fieldSet = new Set<String>(); 
            for(Account_Metric_Reporting_Fields__c thisfield : fieldsList){
                fieldSet.add(thisfield.Name);
            }
            
            system.debug('#### fieldSet - '+fieldSet);
            if(addFieldsList != null){
                addFieldsSet.addAll(addFieldsList);
                system.debug('#### addFieldsSet - '+addFieldsSet);
                selectedSelectOption.clear();
                for(String thisString : addFieldsSet){
                    fieldSet.remove(thisString);
                    selectedSelectOption.add(new SelectOption(thisString,thisString));
                    selectedSelectOption.sort();
                }           
            }
            system.debug('#### fieldSet after removal - '+fieldSet);
            availableSelectOption.clear();
            for(String thisString : fieldSet){
                availableSelectOption.add(new SelectOption(thisString,thisString));
                availableSelectOption.sort();
            }
        }catch(Exception e){
            fieldsError =  true;
            filterError = false;
            reportError = false;
            system.debug('#### Exception 876 - '+e.getMessage());
            ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.WARNING,'No records found, Please modify your filter criteria.'));
        }
    }
 
/*****************************************************************************
* @Description - Method for selected fields for reporting                    *
* @params void                                                               *
* @return void                                                               * 
*****************************************************************************/   
    public void removeFields(){
        try{
            system.debug('#### selected fields to remove - '+removeFieldsList);
            List<String> fieldsList = new List<String>();
            for(SelectOption thisOption : selectedSelectOption){
                fieldsList.add(thisOption.getLabel());
            }
            Set<String> fieldSet = new Set<String>(); 
            for(String thisfield : fieldsList){
                fieldSet.add(thisfield);
            }
    
            system.debug('#### fieldSet - '+fieldSet);
            if(removeFieldsList != null){
                for(String thisString : removeFieldsList){
                    fieldSet.remove(thisString);
                    availableSelectOption.add(new SelectOption(thisString,thisString));
                    availableSelectOption.sort();
                }   
            }
            
            system.debug('#### fieldSet after removal - '+fieldSet);
            selectedSelectOption.clear();
            for(String thisString : fieldSet){
                selectedSelectOption.add(new SelectOption(thisString,thisString));  
                selectedSelectOption.sort();
            }
            sortByList.clear();
            sortByList.addAll(removeFieldsList);
            deselectSortFields();
        }catch(Exception e){
            fieldsError =  true;
            filterError = false;
            reportError = false;
            system.debug('#### Exception 915 - '+e.getMessage());
            ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.WARNING,'No records found, Please modify your filter criteria.'));
        }
    }

/*****************************************************************************
* @Description - Method for selecting sort fields                            *
* @params void                                                               *
* @return void                                                               * 
*****************************************************************************/     

    public void selectSortFields(){
        system.debug('#### removeFieldsList - '+removeFieldsList);
        try{
            if((sortByOption.size()+ removeFieldsList.size())<= SORT_FIELD_LIMIT){
                for(String thisString : removeFieldsList){
                    if(isUnique(sortByOption, thisString))
                        sortByOption.add(new SelectOption(thisString,thisString));
                        sortByList.add(thisString);
                }
                sortByOption.sort();
                system.debug('#### sortByList - '+sortByList);
            }
            else{
                reportError =  true;
                system.debug('#### line 940 - ');
                ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.WARNING,'Maximum 2 Sort By fields allowed.'));
            }
        }catch(Exception e){
            fieldsError =  true;
            filterError = false;
            reportError = false;
            system.debug('#### Exception 947 - '+e.getMessage());
            ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.WARNING,'No records found, Please modify your filter criteria.'));
        }
    }
    private Boolean isUnique(List<SelectOption> sortByOption, String thisString) {
        for(SelectOption option : sortByOption) {
            if(option != null && option.getValue() == thisString) {
                return false;
            }
        }
        return true;
    }
    
/*****************************************************************************
* @Description - Method for de-selecting sort fields                         *
* @params void                                                               *
* @return void                                                               * 
*****************************************************************************/    
    public void deselectSortFields(){
        system.debug('#### sortByList - '+sortByList);
        system.debug('#### sortByOption - '+sortByOption);
        
        try{
            Set<String> sortFields = new Set<String>();
            for(SelectOption thisOption : sortByOption){
                sortFields.add(thisOption.getLabel());
            }
            for(String thisString : sortByList){
                sortFields.remove(thisString);
            }
            sortByOption.clear();
            sortByList.clear();
            for(String thisString : sortFields){
                sortByOption.add(new SelectOption(thisString,thisString));
                sortByOption.sort();
                sortByList.add(thisString);
            }
            system.debug('#### de sortByList - '+sortByList);
        }catch(Exception e){
            fieldsError =  true;
            filterError = false;
            reportError = false;
            system.debug('#### Exception 989 - '+e.getMessage());
            ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.WARNING,'No records found, Please modify your filter criteria.'));
        }
    }
    
/************************************************Utility Methods************************************************/

/*****************************************************************************
* @Description - Method for getting fields details from custom setting       *
* @params void                                                               *
* @return List<Account_Metric_Reporting_Fields__c>                           * 
*****************************************************************************/ 
    public List<Account_Metric_Reporting_Fields__c> getFields(){
        
        List<Account_Metric_Reporting_Fields__c> AMRFields = new List<Account_Metric_Reporting_Fields__c>();
        try{
            AMRFields = [SELECT Name,API_Name__c,Object_API_Name__c,Type__c,IsActive__c ,Suggested_Values__c,
                                forStandard__c,forSort__c
                          FROM Account_Metric_Reporting_Fields__c 
                          WHERE IsActive__c = TRUE ORDER BY Name ASC];
            fieldsList = AMRFields;
            if(standardView ==  true){
                //List<Account_Metric_Reporting_Fields__c> fieldsList = getFields();
                for(Account_Metric_Reporting_Fields__c thisAMRF : fieldsList){
                    if(thisAMRF.forStandard__c ==  true){
                        addFieldsList.add(thisAMRF.Name);
                    }
                    if(thisAMRF.forSort__c ==  true){
                        removeFieldsList.add(thisAMRF.Name);
                    }
                }
            }
            addFields();     
            selectSortFields();               
            return AMRFields;
        }catch(Exception e){
            system.debug('#### exception - '+e.getMessage());
            return AMRFields;
        }
    }
/*****************************************************************************
* @Description - Method for getting different select option based on         *
*                selected owner                                              *
* @params void                                                               *
* @return void                                                               * 
*****************************************************************************/
    public void generateOwnerOption(){
        teamFlag = false;
        repFlag = false;
        if(filterValue == SPECIFIC_TEAM_ACCOUNTS){
            teamFlag =  true;
            //repFlag = false;
            fetchAvailableTeam();
        }
        if(filterValue == SPECIFIC_REP_ACCOUNTS){
            repFlag = true;
            //teamFlag = false;
            fetchAvailableRep();
        }   
    }

/*****************************************************************************
* @Description - Method for getting available team list                      *
* @params void                                                               *
* @return List<String>                                                       * 
*****************************************************************************/
    public void fetchAvailableTeam(){
        try{
            teamSelectOption.clear();
            Employee__c userEmployee = fetchUserEmployeeDetails(userinfo.getuserid());
            system.debug('#### userEmployee - '+userEmployee);
            filterOwner = userEmployee.Division__c;
            AggregateResult[] groupedResults = [SELECT Division__c FROM Employee__c WHERE Department__c =: SALES AND Division__c != null GROUP BY Division__c];
            system.debug('#### groupedResults - '+groupedResults);
            for (AggregateResult ar : groupedResults){
                system.debug('#### Division - '+(String) ar.get('Division__c'));
                if((String) ar.get('Division__c') != null){
                    teamSelectOption.add(new SelectOption((String) ar.get('Division__c'),(String) ar.get('Division__c')));
                }
            }
            system.debug('#### teamSelectOption - '+teamSelectOption);
        }catch(Exception e){
            fieldsError =  true;
            filterError = false;
            reportError = false;
            system.debug('#### Exception 1060 - '+e.getMessage());
            ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.WARNING,'No records found, Please modify your filter criteria.'));
        }
    }
    
/*****************************************************************************
* @Description - Method for getting available reporting user list            *
* @params void                                                               *
* @return List<String>                                                       * 
*****************************************************************************/
    public void fetchAvailableRep(){
        try{
            repUserSelectOption.clear();
            Employee__c userEmployee = fetchUserEmployeeDetails(userinfo.getuserid());
            List<Employee__c> userReportingList = [SELECT User__c,User__r.Name FROM Employee__c 
                                                   WHERE Manager_Employee_Number__c =: userEmployee.Id AND Is_Active__c =  true AND 
                                                         User__r.IsActive = true LIMIT 10000];
                                                         
            for(Employee__c thisEmployee : userReportingList){
                repUserSelectOption.add(new Selectoption(thisEmployee.User__c,thisEmployee.User__r.Name));                  
            }
            system.debug('#### repUserSelectOption - '+repUserSelectOption);        
        }catch(Exception e){
            fieldsError =  true;
            filterError = false;
            reportError = false;
            system.debug('#### Exception 1086 - '+e.getMessage());
            ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.WARNING,'No records found, Please modify your filter criteria.'));
        }
    }

    
/*****************************************************************************
* @Description - Wrapper class for filter                                    *
*****************************************************************************/    
    public class FilterWrapper {
        public String metricName {get;set;}
        public String metricId {get;set;}
        public String filterName {get; set;}
        public String operator {get; set;}
        public String value {get; set;}
        public Integer index {get; set;}
        public String fieldType {get; set;}
        public String suggestedValues{get;set;}
        public Boolean filterFlag {get; set;}
        public List<SelectOption> operatorList {get; set;}
        public List<SelectOption> valueList {get; set;}
        public Account ownerAccount {get; set;}
        public Date dateValue {get; set;}
        public FilterWrapper(){
            ownerAccount =  new Account();
        }
    }
    
/*****************************************************************************
* @Description - Method to convert input date to start date/time             *
*****************************************************************************/
    public static Datetime getActualStartDateTimeObject(Date objDate){
        Datetime dt=Datetime.newInstance(objDate.year(), objDate.month(), objDate.day(), 0, 0, 0);
        return dt;
    }
    
/*****************************************************************************
* @Description - Method to convert input date to end date/time               *
*****************************************************************************/  
    public static Datetime getActualDateEndTimeObject(Date objDate){
        Datetime dt=Datetime.newInstance(objDate.year(), objDate.month(), objDate.day(), 23, 59, 59);
        return dt;
    }

/*****************************************************************************
* @Description - Method to Initialize operator values                        *
* @params void                                                               *
* @return void                                                               * 
*****************************************************************************/   
    public void initializeOperator(){
        OPERATOR_STATIC.put('Lookup',new List<String>{EQUALS,NOT_EQUAL,STARTS_WITH,CONTAINS,DOES_NOT_CONTAIN,INCLUDE,EXCLUDES});
        OPERATOR_STATIC.put('Picklist',new List<String>{EQUALS,NOT_EQUAL});
        OPERATOR_STATIC.put('Checkbox',new List<String>{EQUALS,NOT_EQUAL});
        OPERATOR_STATIC.put('Boolean',new List<String>{EQUALS,NOT_EQUAL});
        OPERATOR_STATIC.put('Date/Time',new List<String>{EQUALS,NOT_EQUAL,LESS_THAN,GREATER_THAN,LESS_EQUALS,GREATER_EQUALS});
        OPERATOR_STATIC.put('Number',new List<String>{EQUALS,NOT_EQUAL,LESS_THAN,GREATER_THAN,LESS_EQUALS,GREATER_EQUALS});
        OPERATOR_STATIC.put('Percent',new List<String>{EQUALS,NOT_EQUAL,LESS_THAN,GREATER_THAN,LESS_EQUALS,GREATER_EQUALS});
        OPERATOR_STATIC.put('Text',new List<String>{EQUALS,NOT_EQUAL,STARTS_WITH,CONTAINS,DOES_NOT_CONTAIN,INCLUDE,EXCLUDES});
        OPERATOR_STATIC.put('Currency',new List<String>{EQUALS,NOT_EQUAL,LESS_THAN,GREATER_THAN,LESS_EQUALS,GREATER_EQUALS});
        OPERATOR_STATIC.put('Mutli-Picklist',new List<String>{INCLUDE,EXCLUDES});
        OPERATOR_STATIC.put('Default',new List<String>{EQUALS,NOT_EQUAL,STARTS_WITH,CONTAINS,DOES_NOT_CONTAIN,LESS_THAN,GREATER_THAN,LESS_EQUALS,GREATER_EQUALS,INCLUDE,EXCLUDES});
    }

/*****************************************************************************
* @Description - Method to return sObject type of the selected field         *
* @params FilterWrappe                                                       *
* @return Sobject                                                            * 
*****************************************************************************/  
    public Sobject getSobject(FilterWrapper thisFilter){
        try{
            //fieldsType = [SELECT Name,API_Name__c,Object_API_Name__c,Type__c, Suggested_Values__c FROM Account_Metric_Reporting_Fields__c WHERE Name =: thisFilter.filterName];
            fieldsType = Account_Metric_Reporting_Fields__c.getInstance(thisFilter.filterName);
            Sobject sobj = null;
            if(fieldsType.Object_API_Name__c == 'Account') {
                sobj = new Account();
            }else if(fieldsType.Object_API_Name__c == 'Account_Metric__c') {
                sobj = new Account_Metric__c();
            }
            return sobj;
        }catch(Exception e){
            fieldsError =  true;
            filterError = false;
            reportError = false;
            system.debug('#### Exception 814 - '+e.getMessage());
            ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.WARNING,'No records found, Please modify your filter criteria.'));
            return null;
        }
    }

/*****************************************************************************
* @Description - Method to fetch all brands and return as a select option    *
* @params none                                                               *
* @return List<SelectOption>                                                 * 
*****************************************************************************/  
    public List<SelectOption> getAllBrands(){
        try{
            for( String key : Account_Brand__c.getAll().keySet()) {
                listBrands.add(new SelectOption(key,key));
            }
            listBrands.sort();
            return listBrands;
            
        }catch(Exception e){
            fieldsError =  true;
            filterError = false;
            reportError = false;
            system.debug('#### Exception 1192 - '+e.getMessage());
            ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.WARNING,'No records found, Please modify your filter criteria.'));
            return null;
        }
    }

/*****************************************************************************
* @Description - Method to fetch all service and return as a select option   *
* @params none                                                               *
* @return List<SelectOption>                                                 * 
*****************************************************************************/  
    public List<SelectOption> getAllService(){
        try{
            for( String key : Account_Service__c.getAll().keySet()) {
                listService.add(new SelectOption(key,key));
            }
            listService.sort();
            return listService;
        }catch(Exception e){
            fieldsError =  true;
            filterError = false;
            reportError = false;
            system.debug('#### Exception 1214 - '+e.getMessage());
            ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.WARNING,'No records found, Please modify your filter criteria.'));
            return null;
        }   
    }
    
/*****************************************************************************
* @Description - Method to fetch all status and return as a select option    *
* @params none                                                               *
* @return List<SelectOption>                                                 * 
*****************************************************************************/  
    public List<SelectOption> getAllStatus(){
        try{
            for( String key : Account_Status__c.getAll().keySet()) {
                listStatus.add(new SelectOption(key,key));
            }
            listStatus.sort();
            return listStatus;
        }catch(Exception e){
            fieldsError =  true;
            filterError = false;
            reportError = false;
            system.debug('#### Exception 1236 - '+e.getMessage());
            ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.WARNING,'No records found, Please modify your filter criteria.'));
            return null;
        }
    }
    
/*****************************************************************************
* @Description - Method to check of the logged in user is a manager or not   *
* @params Logged-in user Id                                                  *
* @return Boolean (true/false)                                               * 
*****************************************************************************/
    public Boolean checkManager(String userId){
        Employee__c userEmployee = fetchUserEmployeeDetails(userId);
        if(userEmployee != null && userEmployee.isManager__c == true) {
            return true;
        }
        /*try {
            List<Employee__c> userReportingList = new List<Employee__c>(); 
            userReportingList = [SELECT User__c FROM Employee__c 
                                 WHERE Manager_Employee_Number__c =: userEmployee.Id AND Is_Active__c =  true AND 
                                       User__r.IsActive = true AND Department__c =: SALES LIMIT 10000];
            
            Set<String> employeeDivisionSet = Sales_Employee_Divisions__c.getAll().keySet();
            
            // Condition to check for manager
            if((userReportingList.size() > 0 || employeeDivisionSet.contains(userEmployee.Division__c))&& userEmployee.Department__c == SALES){
                return true;
            }
        }catch(Exception e){
            system.debug('#### Exception line 1339');
        }*/
        return false;
    }

/*****************************************************************************
* @Description - Method to fetch team                                        *
* @params void                                                               *
* @return Employee__c                                                        * 
*****************************************************************************/
    public Employee__c fetchUserEmployeeDetails(Id userId){
        try {
            return [SELECT Id,Department__c,Division__c,Team__c, isManager__c FROM Employee__c WHERE User__c =: userId];
        } catch(Exception e){
            system.debug('#### Exception line 1353');
            return null;
        }   
    }
}// End of Class