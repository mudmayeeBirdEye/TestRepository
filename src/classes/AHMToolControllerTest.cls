/**************************************************************************************************
* Project Name..........: Account Metrics Reporting                           	                  *
* File..................: AHMToolControllerTest.class                                             *
* Version...............: 1.0 						                                              *
* Created by............: Simplion Technologies                                                   *
* Created Date..........: 11-09-2013 				                                              *
* Last Modified by......: Simplion Technologies 	                                              *
* Last Modified Date....: 11-09-2013 				                                              *
* Description...........: This is a Test class for AHMToolController page                         *
**************************************************************************************************/
@isTest
private class AHMToolControllerTest {

    static testMethod void positiveCases() {
    	
    	// Creating test records for Account
    	Account testAccount = new Account();
        testAccount.name='Test Name';
        testAccount.RC_User_ID__c='5555';
        testAccount.Number_of_DL_s__c=10;    
        testAccount.RC_Brand__c='RingCentral';
        testAccount.RC_Service_name__c = 'Office';
        testAccount.RC_Account_Status__c = 'Canceled';
        
        testAccount.RC_Upgrade_Date__c = dateTime.now();
        insert testAccount; 
        
        //Creating test records for Account Metrics
        Account_Metric__c createTestAccountMetric = new Account_Metric__c();
		createTestAccountMetric.Account_ID__c = testAccount.Id;
		insert createTestAccountMetric;
		
		// Manager User
		User testUser1 = new User(alias = 'u1', email='u1234@testorg.com',emailencodingkey='UTF-8', lastname='Testing', 
								 ProfileId=[SELECT Id FROM Profile LIMIT 1].Id, 
                        		 languagelocalekey='en_US',localesidkey='en_US', country='United States',
                        		 timezonesidkey='America/Los_Angeles', username='u11234@testorg.com', IsActive=true);                   
        insert testUser1;
        
        // Creating sub-ordinate users
        User testUser2 = new User(alias = 'u2', email='u1234@testorg.com',emailencodingkey='UTF-8', lastname='TestingSub', 
								 ProfileId=[SELECT Id FROM Profile LIMIT 1].Id, 
                        		 languagelocalekey='en_US',localesidkey='en_US', country='United States',
                        		 timezonesidkey='America/Los_Angeles', username='u11235@testorg.com', IsActive=true);  
        insert testUser2;
        
        Employee__c empObj = new Employee__c();
    	empObj.User__c = testUser1.Id;
    	empObj.Department__c = 'Sales';
    	empObj.Division__c = 'FARMING C-(650)';
    	empObj.Team__c = 'Managers';
    	insert empObj;
    	
    	Id managerId = empObj.Id;
    	empObj.clear();
    	empObj.User__c = testUser2.Id;
    	empObj.Department__c = 'Sales';
    	empObj.Division__c = 'FARMING C-(650)';
    	empObj.Team__c = 'Managers';
    	empObj.Manager_Employee_Number__c = managerId;
    	insert empObj;
    	
    	// Creating custom setting to store sales division
    	Sales_Employee_Divisions__c sed = new Sales_Employee_Divisions__c();
    	sed.Name = 'FARMING C-(650)';
    	insert sed;
    	
    	EntitlementEnable__c mycs = EntitlementEnable__c.getValues('IsEntitlementsEnabled__c');
		  if(mycs == null) {
		    mycs = new EntitlementEnable__c();
		    mycs.IsEntitlementsEnabled__c = true;
		    mycs.Name = 'IsEntitlementsEnabled';
		    insert mycs;
	  	}
	  	
		Account_Metric_Record_Limit__c setting = new Account_Metric_Record_Limit__c();
		setting.Name = 'Acc Met Limit';
		setting.Number_of_Record__c = 9999;
		insert setting;  	
        
    	/*********** CUSTOM SETTINGS *********/
    	Account_Brand__c accountBrand = new Account_Brand__c(); 
    	accountBrand.Name = 'RingCentral';
    	insert accountBrand;
    	
    	Account_Service__c accountService = new Account_Service__c(); 
    	accountService.Name = 'Office';
    	insert accountService;
    	
    	Account_Status__c accountStatus = new Account_Status__c(); 
    	accountStatus.Name = 'Canceled';
    	insert accountStatus;
    	
    	
    	//Creating test records for Account Metric Reporting custom settings
    	Account_Metric_Reporting_Fields__c amrf = new Account_Metric_Reporting_Fields__c(); 
    	amrf.Name = 'Number of Dls';
    	amrf.Type__c = 'Number';
    	amrf.API_Name__c = 'Account_ID__r.Number_of_DL_s__c';
    	amrf.Object_API_Name__c = 'Account';
    	amrf.IsActive__c = true;
    	insert amrf;
    	
    	amrf = new Account_Metric_Reporting_Fields__c(); 
    	amrf.Name = 'Peer Group';
    	amrf.Type__c = 'Number';
    	amrf.API_Name__c = 'Peer_Group_ID__c';
    	amrf.Object_API_Name__c = 'Account_Metric__c';
    	amrf.IsActive__c = true;
    	insert amrf;
    	
    	amrf = new Account_Metric_Reporting_Fields__c(); 
    	amrf.Name = 'Paid date';
    	amrf.Type__c = 'Date/Time';
    	amrf.API_Name__c = 'Account_ID__r.RC_Upgrade_Date__c';
    	amrf.Object_API_Name__c = 'Account';
    	amrf.IsActive__c = true;
    	insert amrf;
    	
    	amrf = new Account_Metric_Reporting_Fields__c(); 
    	amrf.Name = 'ACCOUNT-Brand';
    	amrf.Type__c = 'Text';
    	//amrf.API_Name__c = 'Account_ID__r.RC_ACCOUNT-Brand__c';
    	amrf.API_Name__c = 'Account_ID__r.RC_Brand__c';
    	amrf.Object_API_Name__c = 'Account';
    	amrf.IsActive__c = true;
    	insert amrf;
    	
    	amrf = new Account_Metric_Reporting_Fields__c(); 
    	amrf.Name = 'Current Owner';
    	amrf.Type__c = 'Lookup';
    	amrf.API_Name__c = 'Account_ID__r.Current_Owner__r.Name';
    	amrf.Object_API_Name__c = 'Account';
    	amrf.IsActive__c = true;
    	insert amrf;
    	
    	amrf = new Account_Metric_Reporting_Fields__c(); 
    	amrf.Name = 'Type';
    	amrf.Type__c = 'Picklist';
    	amrf.API_Name__c = 'Account_ID__r.Type';
    	amrf.Object_API_Name__c = 'Account';
    	amrf.IsActive__c = true;
    	insert amrf;
    	
    	Test.startTest();
    	
    	System.runAs(testUser1) {
    	//Calling Methods
    	AccountMetricsReportingController amrc = new AccountMetricsReportingController();
    	amrc.getFilterItems();
    	amrc.getFieldItems();
    	amrc.fetchRecords();
    	amrc.backMain();
    	amrc.exportToCSV();
    	amrc.exportToExcel();
    	/*Calling add filter 10 times to reach filter limit*/
    	amrc.addFilter();
    	amrc.addFilter();
    	amrc.addFilter();
    	amrc.addFilter();
    	amrc.addFilter();
    	amrc.addFilter();
    	amrc.addFilter();
    	amrc.addFilter();
    	amrc.addFilter();
    	amrc.addFilter();
    	amrc.addFilter();
    	/**************************************************/
    	amrc.resetFilter();
    	amrc.getReportTypes();
    	amrc.reportTypeView();
    	/****************************************Testing for filter type Number***************************************/
    	// assigning values to variable and checking for output (Operator - EQUALS)
    	amrc.filterValue = 'My Team Accounts';
    	amrc.reportType = 'Custom Report';
    	AccountMetricsReportingController.FilterWrapper filter = new AccountMetricsReportingController.FilterWrapper();
    	filter.filterName = 'Peer Group';
    	filter.operator = 'Equals';
    	filter.value = '10';
    	filter.index = 1;
    	amrc.filters.add(filter);
    	amrc.reportTypeView();
    	
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Number','ACCOUNT-Number'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Status','ACCOUNT-Status'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Brand','ACCOUNT-Brand'));
    	
    	// adding fields for report 
    	amrc.addFieldsList = new List<String>();
    	amrc.addFieldsList.add('ACCOUNT-Number');
    	amrc.addFieldsList.add('ACCOUNT-Status');
    	amrc.addFieldsList.add('ACCOUNT-Brand');
    	amrc.addFields();
    	
    	amrc.fetchRecords();
    	amrc.changeDisplayList();
    	amrc.getSobject(filter);
    	
    	amrc.removeFieldsList =  new List<String>();
    	amrc.removeFieldsList.add('ACCOUNT-Number');
    	//amrc.removeFieldsList.add('ACCOUNT-Status');
    	//amrc.removeFieldsList.add('ACCOUNT-Brand');
    	amrc.removeFields();
    	
    	//Check for string input
    	filter.value = '10';
    	amrc.filters.add(filter);
    	amrc.fetchRecords();
    	
    	//Check for null input
    	filter.value = '';
    	amrc.filters.add(filter);
    	amrc.fetchRecords();
    	
    	// assigning values to variable and checking for output (Operator - NOT_EQUAL)
    	amrc.filterValue = 'My Team Accounts';
    	filter = new AccountMetricsReportingController.FilterWrapper();
    	filter.filterName = 'Number of Dls';
    	filter.operator = 'Not Equal to';
    	filter.value = '10';
    	amrc.filters.add(filter);
    	
    	amrc.selectedSelectOption.clear();
    	
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Number','ACCOUNT-Number'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Status','ACCOUNT-Status'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Brand','ACCOUNT-Brand'));
    	
    	amrc.fetchRecords();
    	
    	//Check for null input
    	filter.value = '';
    	amrc.filters.add(filter);
    	amrc.fetchRecords();
    	
    	// assigning values to variable and checking for output (Operator - LESS_THAN)
    	amrc.filterValue = 'My Team Accounts';
    	filter = new AccountMetricsReportingController.FilterWrapper();
    	filter.filterName = 'Number of Dls';
    	filter.operator = 'Less Than';
    	filter.value = '10';
    	amrc.filters.add(filter);
    	
    	amrc.selectedSelectOption.clear();
    	
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Number','ACCOUNT-Number'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Status','ACCOUNT-Status'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Brand','ACCOUNT-Brand'));
    	
    	amrc.fetchRecords();
    	
    	// assigning values to variable and checking for output (Operator - LESS_EQUALS)
    	amrc.filterValue = 'My Team Accounts';
    	filter = new AccountMetricsReportingController.FilterWrapper();
    	filter.filterName = 'Number of Dls';
    	filter.operator = 'Less or Equal';
    	filter.value = '10';
    	amrc.filters.add(filter);
    	
    	amrc.selectedSelectOption.clear();
    	
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Number','ACCOUNT-Number'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Status','ACCOUNT-Status'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Brand','ACCOUNT-Brand'));
    	
    	amrc.fetchRecords();
    	
    	// assigning values to variable and checking for output (Operator - GREATER_THAN)
    	amrc.filterValue = 'My Team Accounts';
    	filter = new AccountMetricsReportingController.FilterWrapper();
    	filter.filterName = 'Number of Dls';
    	filter.operator = 'Greater Than';
    	filter.value = '10';
    	amrc.filters.add(filter);
    	
    	amrc.selectedSelectOption.clear();
    	
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Number','ACCOUNT-Number'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Status','ACCOUNT-Status'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Brand','ACCOUNT-Brand'));
    	
    	amrc.fetchRecords();
    	
    	// assigning values to variable and checking for output (Operator - GREATER_EQUALS)
    	amrc.filterValue = 'My Team Accounts';
    	filter = new AccountMetricsReportingController.FilterWrapper();
    	filter.filterName = 'Number of Dls';
    	filter.operator = 'Greater or Equal';
    	filter.value = '10';
    	amrc.filters.add(filter);
    	
    	amrc.selectedSelectOption.clear();
    	
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Number','ACCOUNT-Number'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Status','ACCOUNT-Status'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Brand','ACCOUNT-Brand'));
    	
    	amrc.fetchRecords();
    	/*************************************************************************************************************/
    	
    	/****************************************Testing for filter type Date/Time ***************************************/
    	// assigning values to variable and checking for output (Operator - EQUALS)
    	amrc.filterValue = 'Specific Team Accounts';
    	filter = new AccountMetricsReportingController.FilterWrapper();
    	filter.filterName = 'Paid date';
    	filter.operator = 'Equals';
    	filter.value = '09/26/2013';
    	filter.ownerAccount.Approval_Date__c = date.today();
    	amrc.filters.add(filter);
    	
    	amrc.selectedSelectOption.clear();
    	
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Number','ACCOUNT-Number'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Status','ACCOUNT-Status'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Brand','ACCOUNT-Brand'));
    	
    	amrc.fetchRecords();
    	amrc.changeDisplayList();
    	
    	//Check for null input
    	filter.value = '';
    	amrc.filters.add(filter);
    	amrc.fetchRecords();
    	
    	// assigning values to variable and checking for output (Operator - NOT_EQUAL)
    	amrc.filterValue = 'My Team Accounts';
    	filter = new AccountMetricsReportingController.FilterWrapper();
    	filter.filterName = 'Paid date';
    	filter.operator = 'Not Equal to';
    	filter.value = '09/26/2013';
    	filter.ownerAccount.Approval_Date__c = date.today();
    	amrc.filters.add(filter);
    	
    	amrc.selectedSelectOption.clear();
    	
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Number','ACCOUNT-Number'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Status','ACCOUNT-Status'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Brand','ACCOUNT-Brand'));
    	
    	amrc.fetchRecords();
    	
    	//Check for null input
    	filter.value = '';
    	amrc.filters.add(filter);
    	amrc.fetchRecords();
    	
    	// assigning values to variable and checking for output (Operator - LESS_THAN)
    	amrc.filterValue = 'My Team Accounts';
    	filter = new AccountMetricsReportingController.FilterWrapper();
    	filter.filterName = 'Paid date';
    	filter.operator = 'Less Than';
    	filter.value = '09/26/2013';
    	filter.ownerAccount.Approval_Date__c = date.today();
    	amrc.filters.add(filter);
    	
    	
    	amrc.selectedSelectOption.clear();
    	
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Number','ACCOUNT-Number'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Status','ACCOUNT-Status'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Brand','ACCOUNT-Brand'));
    	
    	amrc.fetchRecords();
    	
    	// assigning values to variable and checking for output (Operator - LESS_EQUALS)
    	amrc.filterValue = 'My Team Accounts';
    	filter = new AccountMetricsReportingController.FilterWrapper();
    	filter.filterName = 'Paid date';
    	filter.operator = 'Less or Equal';
    	filter.value = '09/26/2013';
    	filter.ownerAccount.Approval_Date__c = date.today();
    	amrc.filters.add(filter);
    	
    	amrc.selectedSelectOption.clear();
    	
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Number','ACCOUNT-Number'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Status','ACCOUNT-Status'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Brand','ACCOUNT-Brand'));
    	
    	amrc.fetchRecords();
    	
    	// assigning values to variable and checking for output (Operator - GREATER_THAN)
    	amrc.filterValue = 'My Team Accounts';
    	filter = new AccountMetricsReportingController.FilterWrapper();
    	filter.filterName = 'Paid date';
    	filter.operator = 'Greater Than';
    	filter.value = '09/26/2013';
    	filter.ownerAccount.Approval_Date__c = date.today();
    	amrc.filters.add(filter);
    	
    	amrc.selectedSelectOption.clear();
    	
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Number','ACCOUNT-Number'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Status','ACCOUNT-Status'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Brand','ACCOUNT-Brand'));
    	
    	amrc.fetchRecords();
    	
    	// assigning values to variable and checking for output (Operator - GREATER_EQUALS)
    	amrc.filterValue = 'My Team Accounts';
    	filter = new AccountMetricsReportingController.FilterWrapper();
    	filter.filterName = 'Paid date';
    	filter.operator = 'Greater or Equal';
    	filter.value = '09/26/2013';
    	filter.ownerAccount.Approval_Date__c = date.today();
    	amrc.filters.add(filter);
    	
    	amrc.selectedSelectOption.clear();
    	
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Number','ACCOUNT-Number'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Status','ACCOUNT-Status'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Brand','ACCOUNT-Brand'));
    	
    	amrc.fetchRecords();
    	/*************************************************************************************************************/
    	
    	/****************************************Testing for filter type Text***************************************/
    	// assigning values to variable and checking for output (Operator - EQUALS)
    	amrc.filterValue = 'Specific Team Accounts';
    	amrc.generateOwnerOption();
    	filter = new AccountMetricsReportingController.FilterWrapper();
    	filter.filterName = 'ACCOUNT-Brand';
    	filter.operator = 'Equals';
    	filter.value = 'RingCentral';
    	amrc.filters.add(filter);
    	
    	
    	amrc.selectedSelectOption.clear();
    	
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Number','ACCOUNT-Number'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Status','ACCOUNT-Status'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Brand','ACCOUNT-Brand'));
    	
    	amrc.fetchRecords();
    	amrc.changeDisplayList();
    	
    	//Check for null input
    	filter.value = '';
    	amrc.filters.add(filter);
    	amrc.fetchRecords();
    	
    	// assigning values to variable and checking for output (Operator - NOT_EQUAL)
    	amrc.filterValue = 'My Team Accounts';
    	filter = new AccountMetricsReportingController.FilterWrapper();
    	filter.filterName = 'ACCOUNT-Brand';
    	filter.operator = 'Not Equal to';
    	filter.value = 'RingCentral';
    	amrc.filters.add(filter);
    	
    	amrc.selectedSelectOption.clear();
    	
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Number','ACCOUNT-Number'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Status','ACCOUNT-Status'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Brand','ACCOUNT-Brand'));
    	
    	amrc.fetchRecords();
    	
    	//Check for null input
    	filter.value = '';
    	amrc.filters.add(filter);
    	amrc.fetchRecords();
    	
    	// assigning values to variable and checking for output (Operator - LESS_THAN)
    	amrc.filterValue = 'My Team Accounts';
    	filter = new AccountMetricsReportingController.FilterWrapper();
    	filter.filterName = 'ACCOUNT-Brand';
    	filter.operator = 'Less Than';
    	filter.value = 'RingCentral';
    	amrc.filters.add(filter);
    	
    	amrc.selectedSelectOption.clear();
    	
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Number','ACCOUNT-Number'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Status','ACCOUNT-Status'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Brand','ACCOUNT-Brand'));
    	
    	amrc.fetchRecords();
    	amrc.selectSortFields();
    	amrc.deselectSortFields();
    	
		Test.stopTest();    	
		}
    	
    	/*************************************************************************************************************/
    }
    
    static testMethod void positiveCases1() {
    	
    	// Creating test records for Account
    	Account testAccount = new Account();
        testAccount.name='Test Name';
        testAccount.RC_User_ID__c='5555';
        testAccount.Number_of_DL_s__c=10;    
        testAccount.RC_Brand__c='RingCentral';
        testAccount.RC_Service_name__c = 'Office';
        testAccount.RC_Account_Status__c = 'Canceled';
        
        testAccount.RC_Upgrade_Date__c = dateTime.now();
        insert testAccount; 
        
        //Creating test records for Account Metrics
        Account_Metric__c createTestAccountMetric = new Account_Metric__c();
		createTestAccountMetric.Account_ID__c = testAccount.Id;
		insert createTestAccountMetric;
		
		// Manager User
		User testUser1 = new User(alias = 'u1', email='u1234@testorg.com',emailencodingkey='UTF-8', lastname='Testing', 
								 ProfileId=[SELECT Id FROM Profile LIMIT 1].Id, 
                        		 languagelocalekey='en_US',localesidkey='en_US', country='United States',
                        		 timezonesidkey='America/Los_Angeles', username='u11234@testorg.com', IsActive=true);                   
        insert testUser1;
        
        // Creating sub-ordinate users
        User testUser2 = new User(alias = 'u2', email='u1234@testorg.com',emailencodingkey='UTF-8', lastname='TestingSub', 
								 ProfileId=[SELECT Id FROM Profile LIMIT 1].Id, 
                        		 languagelocalekey='en_US',localesidkey='en_US', country='United States',
                        		 timezonesidkey='America/Los_Angeles', username='u11235@testorg.com', IsActive=true);  
        insert testUser2;
        
        Employee__c empObj = new Employee__c();
    	empObj.User__c = testUser1.Id;
    	empObj.Department__c = 'Sales';
    	empObj.Division__c = 'FARMING C-(650)';
    	empObj.Team__c = 'Managers';
    	insert empObj;
    	
    	Id managerId = empObj.Id;
    	empObj.clear();
    	empObj.User__c = testUser2.Id;
    	empObj.Department__c = 'Sales';
    	empObj.Division__c = 'FARMING C-(650)';
    	empObj.Team__c = 'Managers';
    	empObj.Manager_Employee_Number__c = managerId;
    	insert empObj;
    	
    	EntitlementEnable__c mycs = EntitlementEnable__c.getValues('IsEntitlementsEnabled__c');
			  if(mycs == null) {
			    mycs = new EntitlementEnable__c();
			    mycs.IsEntitlementsEnabled__c = true;
			    mycs.Name = 'IsEntitlementsEnabled';
			    insert mycs;
		  	}
		  	
		
		Account_Metric_Record_Limit__c setting = new Account_Metric_Record_Limit__c();
		setting.Name = 'Acc Met Limit';
		setting.Number_of_Record__c = 9999;
		insert setting;   	
        
    	/*********** CUSTOM SETTINGS *********/
    	Account_Brand__c accountBrand = new Account_Brand__c(); 
    	accountBrand.Name = 'RingCentral';
    	insert accountBrand;
    	
    	Account_Service__c accountService = new Account_Service__c(); 
    	accountService.Name = 'Office';
    	insert accountService;
    	
    	Account_Status__c accountStatus = new Account_Status__c(); 
    	accountStatus.Name = 'Canceled';
    	insert accountStatus;
    	
    	
    	//Creating test records for Account Metric Reporting custom settings
    	Account_Metric_Reporting_Fields__c amrf = new Account_Metric_Reporting_Fields__c(); 
    	amrf.Name = 'Number of Dls';
    	amrf.Type__c = 'Number';
    	amrf.API_Name__c = 'Account_ID__r.Number_of_DL_s__c';
    	amrf.Object_API_Name__c = 'Account';
    	amrf.IsActive__c = true;
    	insert amrf;
    	
    	amrf = new Account_Metric_Reporting_Fields__c(); 
    	amrf.Name = 'Peer Group';
    	amrf.Type__c = 'Number';
    	amrf.API_Name__c = 'Peer_Group_ID__c';
    	amrf.Object_API_Name__c = 'Account_Metric__c';
    	amrf.IsActive__c = true;
    	insert amrf;
    	
    	amrf = new Account_Metric_Reporting_Fields__c(); 
    	amrf.Name = 'Paid date';
    	amrf.Type__c = 'Date/Time';
    	amrf.API_Name__c = 'Account_ID__r.RC_Upgrade_Date__c';
    	amrf.Object_API_Name__c = 'Account';
    	amrf.IsActive__c = true;
    	insert amrf;
    	
    	amrf = new Account_Metric_Reporting_Fields__c(); 
    	amrf.Name = 'ACCOUNT-Brand';
    	amrf.Type__c = 'Text';
    	//amrf.API_Name__c = 'Account_ID__r.RC_ACCOUNT-Brand__c';
    	amrf.API_Name__c = 'Account_ID__r.RC_Brand__c';
    	amrf.Object_API_Name__c = 'Account';
    	amrf.IsActive__c = true;
    	insert amrf;
    	
    	amrf = new Account_Metric_Reporting_Fields__c(); 
    	amrf.Name = 'Current Owner';
    	amrf.Type__c = 'Lookup';
    	amrf.API_Name__c = 'Account_ID__r.Current_Owner__r.Name';
    	amrf.Object_API_Name__c = 'Account';
    	amrf.IsActive__c = true;
    	insert amrf;
    	
    	amrf = new Account_Metric_Reporting_Fields__c(); 
    	amrf.Name = 'Type';
    	amrf.Type__c = 'Picklist';
    	amrf.API_Name__c = 'Account_ID__r.Type';
    	amrf.Object_API_Name__c = 'Account';
    	amrf.IsActive__c = true;
    	insert amrf;
    	
    	Test.startTest();
    	
    	System.runAs(testUser1) {
    	//Calling Methods
    	AccountMetricsReportingController amrc = new AccountMetricsReportingController();
    	amrc.getFilterItems();
    	amrc.getFieldItems();
    	amrc.fetchRecords();
    	amrc.backMain();
    	amrc.exportToCSV();
    	amrc.exportToExcel();
    	/*Calling add filter 10 times to reach filter limit*/
    	amrc.addFilter();
    	amrc.addFilter();
    	amrc.addFilter();
    	amrc.addFilter();
    	amrc.addFilter();
    	amrc.addFilter();
    	amrc.addFilter();
    	amrc.addFilter();
    	amrc.addFilter();
    	amrc.addFilter();
    	amrc.addFilter();
    	/**************************************************/
    	amrc.resetFilter();
    	
    	/****************************************Testing for filter type Number***************************************/
    	amrc.filterValue = 'My Team Accounts';
    	AccountMetricsReportingController.FilterWrapper filter = new AccountMetricsReportingController.FilterWrapper();
    	
    	// assigning values to variable and checking for output (Operator - LESS_EQUALS)
    	amrc.filterValue = 'My Team Accounts';
    	filter = new AccountMetricsReportingController.FilterWrapper();
    	filter.filterName = 'Number of Dls';
    	filter.operator = 'Less or Equal';
    	filter.value = '10';
    	amrc.filters.add(filter);
    	
    	amrc.selectedSelectOption.clear();
    	
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Number','ACCOUNT-Number'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Status','ACCOUNT-Status'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Brand','ACCOUNT-Brand'));
    	
    	amrc.fetchRecords();
    	
    	// assigning values to variable and checking for output (Operator - GREATER_THAN)
    	amrc.filterValue = 'My Team Accounts';
    	filter = new AccountMetricsReportingController.FilterWrapper();
    	filter.filterName = 'Number of Dls';
    	filter.operator = 'Greater Than';
    	filter.value = '10';
    	amrc.filters.add(filter);
    	
    	amrc.selectedSelectOption.clear();
    	
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Number','ACCOUNT-Number'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Status','ACCOUNT-Status'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Brand','ACCOUNT-Brand'));
    	
    	amrc.fetchRecords();
    	
    	// assigning values to variable and checking for output (Operator - GREATER_EQUALS)
    	amrc.filterValue = 'My Team Accounts';
    	filter = new AccountMetricsReportingController.FilterWrapper();
    	filter.filterName = 'Number of Dls';
    	filter.operator = 'Greater or Equal';
    	filter.value = '10';
    	amrc.filters.add(filter);
    	
    	amrc.selectedSelectOption.clear();
    	
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Number','ACCOUNT-Number'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Status','ACCOUNT-Status'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Brand','ACCOUNT-Brand'));
    	
    	amrc.fetchRecords();
    	/*************************************************************************************************************/
    	
    	/****************************************Testing for filter type Date/Time ***************************************/
    	// assigning values to variable and checking for output (Operator - EQUALS)
    	amrc.filterValue = 'Specific Team Accounts';
    	filter = new AccountMetricsReportingController.FilterWrapper();
    	filter.filterName = 'Paid date';
    	filter.operator = 'Equals';
    	filter.value = '09/26/2013';
    	filter.ownerAccount.Approval_Date__c = date.today();
    	amrc.filters.add(filter);
    	
    	amrc.selectedSelectOption.clear();
    	
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Number','ACCOUNT-Number'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Status','ACCOUNT-Status'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Brand','ACCOUNT-Brand'));
    	
    	amrc.fetchRecords();
    	amrc.changeDisplayList();
    	
    	//Check for null input
    	filter.value = '';
    	filter.ownerAccount.Approval_Date__c = null;
    	amrc.filters.add(filter);
    	amrc.fetchRecords();
    	
    	// assigning values to variable and checking for output (Operator - NOT_EQUAL)
    	amrc.filterValue = 'My Team Accounts';
    	filter = new AccountMetricsReportingController.FilterWrapper();
    	filter.filterName = 'Paid date';
    	filter.operator = 'Not Equal to';
    	filter.value = '09/26/2013';
    	filter.ownerAccount.Approval_Date__c = date.today();
    	amrc.filters.add(filter);
    	
    	amrc.selectedSelectOption.clear();
    	
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Number','ACCOUNT-Number'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Status','ACCOUNT-Status'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Brand','ACCOUNT-Brand'));
    	
    	amrc.fetchRecords();
    	
    	//Check for null input
    	filter.value = '';
    	amrc.filters.add(filter);
    	amrc.fetchRecords();
    	
    	// assigning values to variable and checking for output (Operator - LESS_THAN)
    	amrc.filterValue = 'My Team Accounts';
    	filter = new AccountMetricsReportingController.FilterWrapper();
    	filter.filterName = 'Paid date';
    	filter.operator = 'Less Than';
    	filter.value = '09/26/2013';
    	filter.ownerAccount.Approval_Date__c = date.today();
    	amrc.filters.add(filter);
    	
    	
    	amrc.selectedSelectOption.clear();
    	
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Number','ACCOUNT-Number'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Status','ACCOUNT-Status'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Brand','ACCOUNT-Brand'));
    	
    	amrc.fetchRecords();
    	
    	// assigning values to variable and checking for output (Operator - LESS_EQUALS)
    	amrc.filterValue = 'My Team Accounts';
    	filter = new AccountMetricsReportingController.FilterWrapper();
    	filter.filterName = 'Paid date';
    	filter.operator = 'Less or Equal';
    	filter.value = '09/26/2013';
    	filter.ownerAccount.Approval_Date__c = date.today();
    	amrc.filters.add(filter);
    	
    	amrc.selectedSelectOption.clear();
    	
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Number','ACCOUNT-Number'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Status','ACCOUNT-Status'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Brand','ACCOUNT-Brand'));
    	
    	amrc.fetchRecords();
    	
    	// assigning values to variable and checking for output (Operator - GREATER_THAN)
    	amrc.filterValue = 'My Team Accounts';
    	filter = new AccountMetricsReportingController.FilterWrapper();
    	filter.filterName = 'Paid date';
    	filter.operator = 'Greater Than';
    	filter.value = '09/26/2013';
    	filter.ownerAccount.Approval_Date__c = date.today();
    	amrc.filters.add(filter);
    	
    	amrc.selectedSelectOption.clear();
    	
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Number','ACCOUNT-Number'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Status','ACCOUNT-Status'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Brand','ACCOUNT-Brand'));
    	
    	amrc.fetchRecords();
    	
    	// assigning values to variable and checking for output (Operator - GREATER_EQUALS)
    	amrc.filterValue = 'My Team Accounts';
    	filter = new AccountMetricsReportingController.FilterWrapper();
    	filter.filterName = 'Paid date';
    	filter.operator = 'Greater or Equal';
    	filter.value = '09/26/2013';
    	filter.ownerAccount.Approval_Date__c = date.today();
    	amrc.filters.add(filter);
    	
    	amrc.selectedSelectOption.clear();
    	
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Number','ACCOUNT-Number'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Status','ACCOUNT-Status'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Brand','ACCOUNT-Brand'));
    	
    	amrc.fetchRecords();
    	/*************************************************************************************************************/
    	
    	/****************************************Testing for filter type Text***************************************/
    	// assigning values to variable and checking for output (Operator - EQUALS)
    	amrc.filterValue = 'Specific Rep Accounts';
    	amrc.generateOwnerOption();
    	
    	filter = new AccountMetricsReportingController.FilterWrapper();
    	filter.filterName = 'ACCOUNT-Brand';
    	filter.operator = 'Equals';
    	filter.value = 'RingCentral';
    	amrc.filters.add(filter);
    	
    	
    	amrc.selectedSelectOption.clear();
    	
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Number','ACCOUNT-Number'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Status','ACCOUNT-Status'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Brand','ACCOUNT-Brand'));
    	
    	amrc.fetchRecords();
    	amrc.changeDisplayList();
    	
    	//Check for null input
    	filter.value = '';
    	amrc.filters.add(filter);
    	amrc.fetchRecords();
    	
    	// assigning values to variable and checking for output (Operator - NOT_EQUAL)
    	amrc.filterValue = 'My Team Accounts';
    	filter = new AccountMetricsReportingController.FilterWrapper();
    	filter.filterName = 'ACCOUNT-Brand';
    	filter.operator = 'Not Equal to';
    	filter.value = 'RingCentral';
    	amrc.filters.add(filter);
    	
    	amrc.selectedSelectOption.clear();
    	
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Number','ACCOUNT-Number'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Status','ACCOUNT-Status'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Brand','ACCOUNT-Brand'));
    	
    	amrc.fetchRecords();
    	
    	//Check for null input
    	filter.value = '';
    	amrc.filters.add(filter);
    	amrc.fetchRecords();
    	
    	// assigning values to variable and checking for output (Operator - LESS_THAN)
    	amrc.filterValue = 'My Team Accounts';
    	filter = new AccountMetricsReportingController.FilterWrapper();
    	filter.filterName = 'ACCOUNT-Brand';
    	filter.operator = 'Less Than';
    	filter.value = 'RingCentral';
    	amrc.filters.add(filter);
    	
    	amrc.selectedSelectOption.clear();
    	
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Number','ACCOUNT-Number'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Status','ACCOUNT-Status'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Brand','ACCOUNT-Brand'));
    	
    	amrc.fetchRecords();
    	
    	// assigning values to variable and checking for output (Operator - LESS_EQUALS)
    	amrc.filterValue = 'My Team Accounts';
    	filter = new AccountMetricsReportingController.FilterWrapper();
    	filter.filterName = 'ACCOUNT-Brand';
    	filter.operator = 'Less or Equal';
    	filter.value = 'RingCentral';
    	amrc.filters.add(filter);
    	
    	amrc.selectedSelectOption.clear();
    	
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Number','ACCOUNT-Number'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Status','ACCOUNT-Status'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Brand','ACCOUNT-Brand'));
    	
    	amrc.fetchRecords();
    	
    	// assigning values to variable and checking for output (Operator - GREATER_THAN)
    	amrc.filterValue = 'My Team Accounts';
    	filter = new AccountMetricsReportingController.FilterWrapper();
    	filter.filterName = 'ACCOUNT-Brand';
    	filter.operator = 'Greater Than';
    	filter.value = 'RingCentral';
    	amrc.filters.add(filter);
    	
    	amrc.selectedSelectOption.clear();
    	
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Number','ACCOUNT-Number'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Status','ACCOUNT-Status'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Brand','ACCOUNT-Brand'));
    	
    	amrc.fetchRecords();
    	
    	// assigning values to variable and checking for output (Operator - GREATER_EQUALS)
    	amrc.filterValue = 'My Team Accounts';
    	filter = new AccountMetricsReportingController.FilterWrapper();
    	filter.filterName = 'ACCOUNT-Brand';
    	filter.operator = 'Greater or Equal';
    	filter.value = 'RingCentral';
    	amrc.filters.add(filter);
    	
    	amrc.selectedSelectOption.clear();
    	
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Number','ACCOUNT-Number'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Status','ACCOUNT-Status'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Brand','ACCOUNT-Brand'));
    	
    	amrc.fetchRecords();
    	
    	// assigning values to variable and checking for output (Operator - CONTAINS)
    	amrc.filterValue = 'My Team Accounts';
    	filter = new AccountMetricsReportingController.FilterWrapper();
    	filter.filterName = 'ACCOUNT-Brand';
    	filter.operator = 'Contains';
    	filter.value = 'test';
    	amrc.filters.add(filter);
    	
    	amrc.selectedSelectOption.clear();
    	
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Number','ACCOUNT-Number'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Status','ACCOUNT-Status'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Brand','ACCOUNT-Brand'));
    	
    	amrc.fetchRecords();
    	
    	// assigning values to variable and checking for output (Operator - DOES_NOT_CONTAIN)
    	amrc.filterValue = 'My Team Accounts';
    	filter = new AccountMetricsReportingController.FilterWrapper();
    	filter.filterName = 'ACCOUNT-Brand';
    	filter.operator = 'Does Not Contain';
    	filter.value = 'test';
    	amrc.filters.add(filter);
    	
    	amrc.selectedSelectOption.clear();
    	
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Number','ACCOUNT-Number'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Status','ACCOUNT-Status'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Brand','ACCOUNT-Brand'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Service','ACCOUNT-Service'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Status','ACCOUNT-Status'));
    	
    	amrc.fetchRecords();
    	
    	// assigning values to variable and checking for output (Operator - INCLUDE)
    	// for Brand
    	amrc.filterValue = 'My Team Accounts';
    	filter = new AccountMetricsReportingController.FilterWrapper();
    	filter.filterName = 'ACCOUNT-Brand';
    	filter.operator = 'Includes';
    	filter.value = 'test';
    	amrc.filters.add(filter);
    	amrc.selectedSelectOption.clear();
    	
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Number','ACCOUNT-Number'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Status','ACCOUNT-Status'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Brand','ACCOUNT-Brand'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Service','ACCOUNT-Service'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Status','ACCOUNT-Status'));
    	
    	amrc.fetchRecords();
    	
    	// assigning values to variable and checking for output (Operator - EXCLUDES)
    	amrc.filterValue = 'My Team Accounts';
    	filter = new AccountMetricsReportingController.FilterWrapper();
    	filter.filterName = 'ACCOUNT-Brand';
    	filter.operator = 'Excludes';
    	filter.value = 'test';
    	amrc.filters.add(filter);
    	
    	amrc.selectedSelectOption.clear();
    	
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Number','ACCOUNT-Number'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Status','ACCOUNT-Status'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Brand','ACCOUNT-Brand'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Service','ACCOUNT-Service'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Status','ACCOUNT-Status'));
    	
    	amrc.fetchRecords();
    	
    	// assigning values to variable and checking for output (Operator - STARTS_WITH)
    	amrc.filterValue = 'My Team Accounts';
    	filter = new AccountMetricsReportingController.FilterWrapper();
    	filter.filterName = 'ACCOUNT-Brand';
    	filter.operator = 'Starts With';
    	filter.value = 'test';
    	amrc.filters.add(filter);
    	
    	amrc.selectedSelectOption.clear();
    	
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Number','ACCOUNT-Number'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Status','ACCOUNT-Status'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Brand','ACCOUNT-Brand'));
    	
    	amrc.fetchRecords();
    	/*************************************************************************************************************/
 		
 		/****************************************Testing for filter type Lookup***************************************/
    	// assigning values to variable and checking for output (Operator - EQUALS)
    	amrc.filterValue = 'Specific Team Accounts';
    	filter = new AccountMetricsReportingController.FilterWrapper();
    	filter.filterName = 'Current Owner';
    	filter.operator = 'Equals';
    	filter.ownerAccount.Current_Owner__c = testUser1.Id;
    	amrc.filters.add(filter);
    	
    	amrc.selectedSelectOption.clear();
    	
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Number','ACCOUNT-Number'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Status','ACCOUNT-Status'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Brand','ACCOUNT-Brand'));
    	Test.stopTest();
    	amrc.fetchRecords();
    	
    	filter.ownerAccount.Current_Owner__c = null;
    	amrc.filters.add(filter);
    	
    	amrc.fetchRecords();
    	}
    	
    	/*************************************************************************************************************/
    }
    
    static testMethod void positiveCases2() {
    	
    	// Creating test records for Account
    	Account testAccount = new Account();
        testAccount.name='Test Name';
        testAccount.RC_User_ID__c='5555';
        testAccount.Number_of_DL_s__c=10;    
        testAccount.RC_Brand__c='RingCentral';
        testAccount.RC_Service_name__c = 'Office';
        testAccount.RC_Account_Status__c = 'Canceled';
        
        testAccount.RC_Upgrade_Date__c = dateTime.now();
        insert testAccount; 
        
        //Creating test records for Account Metrics
        Account_Metric__c createTestAccountMetric = new Account_Metric__c();
		createTestAccountMetric.Account_ID__c = testAccount.Id;
		insert createTestAccountMetric;
		
		// Manager User
		User testUser1 = new User(alias = 'u1', email='u1234@testorg.com',emailencodingkey='UTF-8', lastname='Testing', 
								 ProfileId=[SELECT Id FROM Profile LIMIT 1].Id, 
                        		 languagelocalekey='en_US',localesidkey='en_US', country='United States',
                        		 timezonesidkey='America/Los_Angeles', username='u11234@testorg.com', IsActive=true);                   
        insert testUser1;
        
        // Creating sub-ordinate users
        User testUser2 = new User(alias = 'u2', email='u1234@testorg.com',emailencodingkey='UTF-8', lastname='TestingSub', 
								 ProfileId=[SELECT Id FROM Profile LIMIT 1].Id, 
                        		 languagelocalekey='en_US',localesidkey='en_US', country='United States',
                        		 timezonesidkey='America/Los_Angeles', username='u11235@testorg.com', IsActive=true);  
        insert testUser2;
        
        Employee__c empObj = new Employee__c();
    	empObj.User__c = testUser1.Id;
    	empObj.Department__c = 'Sales';
    	empObj.Division__c = 'FARMING C-(650)';
    	empObj.Team__c = 'Managers';
    	insert empObj;
    	
    	Id managerId = empObj.Id;
    	empObj.clear();
    	empObj.User__c = testUser2.Id;
    	empObj.Department__c = 'Sales';
    	empObj.Division__c = 'FARMING C-(650)';
    	empObj.Team__c = 'Managers';
    	empObj.Manager_Employee_Number__c = managerId;
    	insert empObj;
        
        EntitlementEnable__c mycs = EntitlementEnable__c.getValues('IsEntitlementsEnabled__c');
			  if(mycs == null) {
			    mycs = new EntitlementEnable__c();
			    mycs.IsEntitlementsEnabled__c = true;
			    mycs.Name = 'IsEntitlementsEnabled';
			    insert mycs;
		  	}
		
		
		Account_Metric_Record_Limit__c setting = new Account_Metric_Record_Limit__c();
		setting.Name = 'Acc Met Limit';
		setting.Number_of_Record__c = 9999;
		insert setting;  	
        
    	/*********** CUSTOM SETTINGS *********/
    	Account_Brand__c accountBrand = new Account_Brand__c(); 
    	accountBrand.Name = 'RingCentral';
    	insert accountBrand;
    	
    	Account_Service__c accountService = new Account_Service__c(); 
    	accountService.Name = 'Office';
    	insert accountService;
    	
    	Account_Status__c accountStatus = new Account_Status__c(); 
    	accountStatus.Name = 'Canceled';
    	insert accountStatus;
    	
    	
    	//Creating test records for Account Metric Reporting custom settings
    	Account_Metric_Reporting_Fields__c amrf = new Account_Metric_Reporting_Fields__c(); 
    	amrf.Name = 'Number of Dls';
    	amrf.Type__c = 'Number';
    	amrf.API_Name__c = 'Account_ID__r.Number_of_DL_s__c';
    	amrf.Object_API_Name__c = 'Account';
    	amrf.IsActive__c = true;
    	insert amrf;
    	
    	amrf = new Account_Metric_Reporting_Fields__c(); 
    	amrf.Name = 'Peer Group';
    	amrf.Type__c = 'Number';
    	amrf.API_Name__c = 'Peer_Group_ID__c';
    	amrf.Object_API_Name__c = 'Account_Metric__c';
    	amrf.IsActive__c = true;
    	insert amrf;
    	
    	amrf = new Account_Metric_Reporting_Fields__c(); 
    	amrf.Name = 'Paid date';
    	amrf.Type__c = 'Date/Time';
    	amrf.API_Name__c = 'Account_ID__r.RC_Upgrade_Date__c';
    	amrf.Object_API_Name__c = 'Account';
    	amrf.IsActive__c = true;
    	insert amrf;
    	
    	amrf = new Account_Metric_Reporting_Fields__c(); 
    	amrf.Name = 'ACCOUNT-Brand';
    	amrf.Type__c = 'Text';
    	//amrf.API_Name__c = 'Account_ID__r.RC_ACCOUNT-Brand__c';
    	amrf.API_Name__c = 'Account_ID__r.RC_Brand__c';
    	amrf.Object_API_Name__c = 'Account';
    	amrf.IsActive__c = true;
    	insert amrf;
    	
    	amrf = new Account_Metric_Reporting_Fields__c(); 
    	amrf.Name = 'ACCOUNT-Service';
    	amrf.Type__c = 'Text';
    	amrf.API_Name__c = 'Account_ID__r.RC_Service_name__c';
    	amrf.Object_API_Name__c = 'Account';
    	amrf.IsActive__c = true;
    	insert amrf;
    	
    	amrf = new Account_Metric_Reporting_Fields__c(); 
    	amrf.Name = 'ACCOUNT-Status';
    	amrf.Type__c = 'Text';
    	amrf.API_Name__c = 'Account_ID__r.RC_Account_Status__c';
    	amrf.Object_API_Name__c = 'Account';
    	amrf.IsActive__c = true;
    	insert amrf;
    	
    	amrf = new Account_Metric_Reporting_Fields__c(); 
    	amrf.Name = 'Current Owner';
    	amrf.Type__c = 'Lookup';
    	amrf.API_Name__c = 'Account_ID__r.Current_Owner__r.Name';
    	amrf.Object_API_Name__c = 'Account';
    	amrf.IsActive__c = true;
    	insert amrf;
    	
    	amrf = new Account_Metric_Reporting_Fields__c(); 
    	amrf.Name = 'Type';
    	amrf.Type__c = 'Picklist';
    	amrf.API_Name__c = 'Account_ID__r.Type';
    	amrf.Object_API_Name__c = 'Account';
    	amrf.IsActive__c = true;
    	insert amrf;
    	
    	amrf = new Account_Metric_Reporting_Fields__c(); 
    	amrf.Name = 'Boolean Field';
    	amrf.Type__c = 'Boolean';
    	amrf.API_Name__c = 'Metric_8_value__c';
    	amrf.Object_API_Name__c = 'Account_Metric__c';
    	amrf.IsActive__c = true;
    	insert amrf;
    	
    	amrf = new Account_Metric_Reporting_Fields__c(); 
    	amrf.Name = 'DLs canceled in 30 Days';
    	amrf.Type__c = 'Percent';
    	amrf.API_Name__c = 'Metric_4_value__c';
    	amrf.Object_API_Name__c = 'Account_Metric__c';
    	amrf.IsActive__c = true;
    	insert amrf;
    	
    	Test.startTest();
    	
    	System.runAs(testUser1) {
    	//Calling Methods
    	AccountMetricsReportingController amrc = new AccountMetricsReportingController();
    	amrc.getFilterItems();
    	amrc.getFieldItems();
    	amrc.fetchRecords();
    	amrc.backMain();
    	amrc.exportToCSV();
    	amrc.exportToExcel();
    	amrc.resetFilter();
    	
    	/****************************************Testing for filter type Number***************************************/
    	amrc.filterValue = 'My Team Accounts';
    	AccountMetricsReportingController.FilterWrapper filter = new AccountMetricsReportingController.FilterWrapper();
    	
    	//Check for null input
    	filter.ownerAccount.Current_Owner__c = null;
    	amrc.filters.add(filter);
    	amrc.fetchRecords();
    	/*************************************************************************************************************/
 
 		/****************************************Testing for filter type Picklist***************************************/
    	// assigning values to variable and checking for output (Operator - EQUALS)
    	amrc.filterValue = 'My Team Accounts';
    	//filter = new AccountMetricsReportingController.FilterWrapper();
    	amrc.filters[0].filterName = 'Type';
    	amrc.filters[0].operator = 'Equals';
    	amrc.filters[0].value = 'Customer';
    	amrc.filters[0].index = 0;
    	amrc.currentField = 0;
    	//amrc.filters.add(filter);
    	
    	amrc.selectedSelectOption.clear();
    	
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Number','ACCOUNT-Number'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Status','ACCOUNT-Status'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Brand','ACCOUNT-Brand'));
    	
    	amrc.fetchRecords();
    	amrc.changeDisplayList();
    	
    	//Check for null input
    	filter.value = '';
    	amrc.filters.add(filter);
    	amrc.fetchRecords();
    	
    	//Check if filter type not present
    	amrc.filters[0].filterName = 'test';
    	amrc.filters.add(filter);
    	amrc.changeDisplayList();
    	
    	// On 3 Oct
    	
    	amrc.fetchAvailableTeam();
    	/*************************************************************************************************************/
    	/****************************************Testing for filter type Text*****************************************/
    	
    	amrc.filterValue = 'Specific Team Accounts';
    	amrc.generateOwnerOption();
    	amrc.filterOwner = 'FARMING C-(650)';
    	//for service, operator includes
    	filter = new AccountMetricsReportingController.FilterWrapper();
    	filter.filterName = 'ACCOUNT-Service';
    	filter.operator = 'Includes';
    	filter.value = 'test';
    	amrc.filters.add(filter);
    	amrc.selectedSelectOption.clear();
    	
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Number','ACCOUNT-Number'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Status','ACCOUNT-Status'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Brand','ACCOUNT-Brand'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Service','ACCOUNT-Service'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Status','ACCOUNT-Status'));
    	
    	amrc.fetchRecords();
    	
    	//for Status, operator includes
    	filter = new AccountMetricsReportingController.FilterWrapper();
    	filter.filterName = 'ACCOUNT-Status';
    	filter.operator = 'Includes';
    	filter.value = 'test';
    	amrc.filters.add(filter);
    	
    	
    	amrc.selectedSelectOption.clear();
    	
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Number','ACCOUNT-Number'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Status','ACCOUNT-Status'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Brand','ACCOUNT-Brand'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Service','ACCOUNT-Service'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Status','ACCOUNT-Status'));
    	
    	amrc.fetchRecords();
    	
    	amrc.filterValue = 'Specific Rep Accounts';
    	
    	amrc.generateOwnerOption();
    	//for service, operator excludes
    	filter = new AccountMetricsReportingController.FilterWrapper();
    	filter.filterName = 'ACCOUNT-Service';
    	filter.operator = 'Excludes';
    	filter.value = 'test';
    	amrc.filters.add(filter);
    	amrc.selectedSelectOption.clear();
    	
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Number','ACCOUNT-Number'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Status','ACCOUNT-Status'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Brand','ACCOUNT-Brand'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Service','ACCOUNT-Service'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Status','ACCOUNT-Status'));
    	
    	amrc.fetchRecords();
    	
    	//for Status, operator excludes
    	filter = new AccountMetricsReportingController.FilterWrapper();
    	filter.filterName = 'ACCOUNT-Status';
    	filter.operator = 'Excludes';
    	filter.value = 'test';
    	amrc.filters.add(filter);
    	
    	
    	amrc.selectedSelectOption.clear();
    	
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Number','ACCOUNT-Number'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Status','ACCOUNT-Status'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Brand','ACCOUNT-Brand'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Service','ACCOUNT-Service'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Status','ACCOUNT-Status'));
    	
    	amrc.fetchRecords();
    	/*************************************************************************************************************/
    	/****************************************Testing for filter type Boolean***************************************/
    	amrc.filterValue = 'My Team Accounts';
    	filter = new AccountMetricsReportingController.FilterWrapper();
    	filter.filterName = 'Boolean Field';
    	filter.operator = 'Equals';
    	filter.value = '1';
    	amrc.filters.add(filter);
    	amrc.selectedSelectOption.clear();
    	
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Number','ACCOUNT-Number'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Status','ACCOUNT-Status'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Brand','ACCOUNT-Brand'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Service','ACCOUNT-Service'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Status','ACCOUNT-Status'));
    	
    	amrc.fetchRecords();
    	/*************************************************************************************************************/
    	/****************************************Testing for filter type Percent***************************************/
    	amrc.filterValue = 'My Team Accounts';
    	filter = new AccountMetricsReportingController.FilterWrapper();
    	filter.filterName = 'DLs canceled in 30 Days';
    	filter.operator = 'Equals';
    	filter.value = '20';
    	amrc.filters.add(filter);
    	amrc.selectedSelectOption.clear();
    	
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Number','ACCOUNT-Number'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Status','ACCOUNT-Status'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Brand','ACCOUNT-Brand'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Service','ACCOUNT-Service'));
    	amrc.selectedSelectOption.add(new SelectOption('ACCOUNT-Status','ACCOUNT-Status'));
    	
    	amrc.sortByOption.add(new SelectOption('ACCOUNT-Number','ACCOUNT-Number'));
    	amrc.sortByOption.add(new SelectOption('ACCOUNT-Status','ACCOUNT-Status'));
    	
    	amrc.fetchRecords();
    	
    	// Checking values for duplicate sort by option
    	amrc.sortByOption.add(new SelectOption('ACCOUNT-Number','ACCOUNT-Number'));
    	amrc.sortByOption.add(new SelectOption('ACCOUNT-Status','ACCOUNT-Status'));
    	amrc.sortByOption.add(new SelectOption('ACCOUNT-Status','ACCOUNT-Status'));
    	
    	amrc.sortByList.add('ACCOUNT-Status');
    	
    	// Checking for values not between 0-100
    	filter = new AccountMetricsReportingController.FilterWrapper();
    	filter.filterName = 'DLs canceled in 30 Days';
    	filter.operator = 'Equals';
    	filter.value = '120';
    	amrc.filters.add(filter);
    	
    	amrc.fetchRecords();
    	
    	//Checking for sort field values more than 3
    	amrc.sortByOption.clear();
    	amrc.sortByOption.add(new SelectOption('ACCOUNT-Number','ACCOUNT-Number'));
    	amrc.sortByOption.add(new SelectOption('ACCOUNT-Status','ACCOUNT-Status'));
    	amrc.sortByOption.add(new SelectOption('ACCOUNT-Brand','ACCOUNT-Brand'));
    	amrc.fetchRecords();
    	/*************************************************************************************************************/
    	}
 		Test.stopTest();   	
    }
}