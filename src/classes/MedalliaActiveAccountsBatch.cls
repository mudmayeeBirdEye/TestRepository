/**************************************************************************************************
* Project Name..........: Medallia                                                                *
* File..................: MedalliaActiveAccountsBatch.class                                       *
* Version...............: 1.0                                                                     *
* Created by............: Simplion Technologies                                                   *
* Created Date..........: 24-02-2013                                                              *
* Last Modified by......: Simplion Technologies                                                   *
* Last Modified Date....: 24-02-2013                                                              *
* Description...........: This is a batch class to fetch Acounts active for 90 days,              *
*                         create Medallia Survey records to send the records to Medallia server,  *
*                         which will send out the surveys to the end users                        *
**************************************************************************************************/

global class MedalliaActiveAccountsBatch implements Database.Batchable<sObject> {

	// Declaring constant variables
	private String RC_ACCOUNT_STATUS = 'Paid'; 
	private String ACCOUNT_TYPE = 'Customer';
	private String SERVICE_TYPE = 'Office';
	private String SURVEY_TYPE = 'New Customer (after 90 days)';
	private Date TODAYDATE = Date.Today();
	private Date STARTDATE = TODAYDATE.addDays(-90);
	private Date ENDDATE = TODAYDATE.addDays(-95);
	private Integer NO_OF_DLS = 2;
	
	// Declaring variables
	
	// List to contain Database result.
    private	Database.SaveResult[] srList;
	// Preparing list of Account fields to query.
	private List<String> accountFieldsToQuery =  new List<String>{
		'Id',
		'CreatedDate',
		'AnnualRevenue',
		'Name',
		'Owner.Name',
		'Service_Type__c',
		'Industry',
		'MRR__c',
		'Number_of_DL_s__c',
		'NumberOfEmployees',
		'Number_Of_Locations__c',
		'BillingCountry',
		'Partner_ID__c',
		'Payment_Plan__c',
		'Phone',
		'Type',
		'Account_Owner_Manager_Name__c',
		'Account_Owner_Manager_Email__c',
		'Current_Owner__c',
        'Current_Owner_Email__c',
        'Current_Owner_Manager_Email__c',
		'RC_Account_Status__c',
        'RC_Brand__c',
		'RC_Account_Number__c',
		'RC_Service_name__c',
		'RC_Tier__c',
		'RC_User_ID__c',
		'RC_Signup_Date__c',
		'RC_Activation_Date__c',
		'RC_Attribution_Channel__c',
		'Most_Recent_Implementation_Contact__c',
		'Most_Recent_Opportunity_Manager_Email__c',
		'Most_Recent_Opportunity_Owner_Email__c',
		'Most_Recent_Opportunity_Contact__c',
		'Most_Recent_Opportunity_Contact__r.FirstName',
		'Most_Recent_Opportunity_Contact__r.LastName',
		'Most_Recent_Opportunity_Contact__r.Email',
		'Most_Recent_Opportunity_Contact__r.Phone'
	};
	
	// Preparing List of Implementation fields.
	private List<String> implementationFieldsToQuery =  new List<String>{
		'Id',
		'Account__c',
		'Contact__r.Id',
		'Contact__r.FirstName',
		'Contact__r.LastName',
		'Contact__r.Email',
		'Contact__r.Phone'
	};
	
	/******************************************************************************
	* @Description : Start method to execute the query for batch.                 *
	* @Params      : Database.BatchableContext                                    *
	* @Return      : Database.querylocator                                        * 
	******************************************************************************/ 
	global Database.querylocator start(Database.BatchableContext BC){
		
		system.debug('#### today date - '+TODAYDATE);
		system.debug('#### start date - '+STARTDATE);
		system.debug('#### end date - '+ENDDATE);
	
        try{
	        String query = 'SELECT ';
	        for(String thisField : accountFieldsToQuery){
	        	query = query + thisField+',';
	        }
	        
	        String nestedQuery = 'SELECT ';
	        for(String thisField : implementationFieldsToQuery){
	        	nestedQuery =  nestedQuery + thisField + ',';
	        }
	        nestedQuery = (nestedQuery.trim()).left(nestedQuery.length()-1);
	        query = query + '('+ nestedQuery;
			query = query + ' FROM Implementations__r ORDER BY LastModifiedDate DESC LIMIT 1)'+	
	        			    ' FROM Account '+
	        			    ' WHERE RC_Account_Status__c =: RC_ACCOUNT_STATUS AND'+ 
	        			    	  ' Type =: ACCOUNT_TYPE AND'+
	        			          ' Service_Type__c =: SERVICE_TYPE AND'+
	        			          ' isProcessedMedallia__c != true AND'+
	        			          ' Number_of_DL_s__c >=: NO_OF_DLS AND'+
	        			          ' DAY_ONLY(RC_Signup_Date__c) <=: STARTDATE AND'+ 
	        			          ' DAY_ONLY(RC_Signup_Date__c) >=: ENDDATE';
       	 	system.debug('#### query - '+query);    
       	 	
        	return Database.getQueryLocator(query);
			
        }catch(Exception ex){
        	system.debug('#### Error on line - '+ex.getLineNumber());
	    	system.debug('#### Error message - '+ex.getMessage());
	    	return null;
        }
    }
    
    /************************************************************************************************
	* @Description : Execute method to map Account queried fields to Medallia Survey Object fields, *
	*                before inserting it into the object.                                           *
	* @Params      : Database.BatchableContext, List<sObject>                                       *
	* @Return      : void                                                                           * 
	*************************************************************************************************/ 
    global void execute(Database.BatchableContext BC, List<sObject> scope){
    	
    	// List to contain Medallia Records, to be inserted in Medallia Survey object.
    	List<Medallia_Survey__c> listMedalliaRecordsTobeInserted = new List<Medallia_Survey__c>();
    	// List to contain Account record, with processed flag as checked.
    	List<Account> listAccountTobeUpdated = new List<Account>();
    	// List of Account Id's
    	List<String> accountIdList = new List<String>();
    	// List of Most Recent Opportunity Contact.
    	List<String> mostRecentOpptyContactList = new List<String>();
    	// Map of Account,Primary Contact Details
    	Map<Id,AccountContactRole> accountPrimaryContactMap = new Map<Id,AccountContactRole>(); 
    	// Map of Id,Most Recent Opportunity Contact role.
    	Map<Id,OpportunityContactRole> opportunityContactRoleMap =  new Map<Id,OpportunityContactRole>(); 
    	// Map to contain Account Id, Implementation.
		Map<Id,Implementation__c> accountImplementationMap = new Map<Id,Implementation__c>();
    	
    	try{
    		
    		// Fetching list of Account Id's.
			for(sObject thisRecord : scope){
				// Casting the sObject into Account object.
	    		Account accountRecord = (Account)thisRecord;	
	    		accountIdList.add(accountRecord.Id);
	    		mostRecentOpptyContactList.add(accountRecord.Most_Recent_Opportunity_Contact__c);
	    		
	    		// Chaffing out the relationship result for Implementation.
				Implementation__c implementationRecord = new Implementation__c();
				List<Implementation__c> implementationList = new List<Implementation__c>();
				implementationList = accountRecord.getSobjects('Implementations__r');
				system.debug('#### implementationList - '+implementationList);
				implementationRecord = implementationList == null ? null : implementationList[0];
				accountImplementationMap.put(accountRecord.Id,implementationRecord);
			}
			
			// Creating Map of Account,Primary Contact Details.
			for(AccountContactRole thisACR : [SELECT AccountId, Contact.Name,Contact.FirstName,Contact.LastName,isPrimary,Role,Contact.Email,
													 Contact.Phone,ContactId 
										      FROM AccountContactRole 
										      WHERE AccountId IN: accountIdList AND IsPrimary = true
			                                  		ORDER BY LastModifiedDate ASC]){
			                                  	
				accountPrimaryContactMap.put(thisACR.AccountId,thisACR);	
			}
			
			// Creating Map of Most Recent Oppty Contact Id, Contact details.
			for(OpportunityContactRole thisOpptyContactRole : [SELECT ContactId,IsPrimary, Role FROM OpportunityContactRole WHERE ContactId IN: mostRecentOpptyContactList]){
					opportunityContactRoleMap.put(thisOpptyContactRole.ContactId,thisOpptyContactRole);
			}
    		
	    	for(sObject thisRecord : scope){
	    		String owner = null;
	    		// Casting the sObject into Account object.
	    		Account accountRecord = (Account)thisRecord;
	    		
	    		// Mapping the fields on Medallia Survey objects with that of the 90 days Active Account fetched, before creating the record.
	    		Medallia_Survey__c medalliaRecordTobeInserted = new Medallia_Survey__c();
	    		
	    		String primaryContact = null;
	    		String mostRecentContact = null;
	    		String implementationContact = null;
	    		
	    		AccountContactRole acrObj = accountPrimaryContactMap.get(accountRecord.Id);
	    		// Condition A
	    		if(acrObj != null && acrObj.IsPrimary) {
	    			primaryContact = acrObj.ContactId;
	    		}
	    		// Condition B
	    		if(accountRecord.Most_Recent_Opportunity_Contact__c != null) {
	    			mostRecentContact = accountRecord.Most_Recent_Opportunity_Contact__c;
	    		}
	    		// Condition C [This condition for next phase updates]
	    		if(accountRecord.Most_Recent_Implementation_Contact__c != null) {
	    			implementationContact = accountRecord.Most_Recent_Implementation_Contact__c;
	    		}
    			if(primaryContact == mostRecentContact) {
    				mostRecentContact = null;
    			}
	    		if(primaryContact == implementationContact) {
	    			implementationContact = null; 
	    		}
	    		if(mostRecentContact == implementationContact) {
	    			implementationContact = null;
	    		}
	    		if(primaryContact != null || mostRecentContact != null || implementationContact != null) {
	    			
	    			// Checking the isProcessed flag as true, to avoid duplicate processing of records in Medallia Survey object.
		    		accountRecord.isProcessedMedallia__c = true;
	    			
		    		medalliaRecordTobeInserted.SurveyType__c = SURVEY_TYPE;
					medalliaRecordTobeInserted.Account_AnnualRevenue__c = accountRecord.AnnualRevenue != null ? String.valueOf(accountRecord.AnnualRevenue) : '';	    		
		    		medalliaRecordTobeInserted.Account_SFDC_ID__c =  accountRecord.Id;
					medalliaRecordTobeInserted.Account_Name__c = accountRecord.Name;
					medalliaRecordTobeInserted.Account_Number__c = accountRecord.RC_Account_Number__c;
					medalliaRecordTobeInserted.Account_Owner__c = accountRecord.Owner.Name;
					medalliaRecordTobeInserted.Account_Owner_Manager__c = accountRecord.Account_Owner_Manager_Name__c;
					medalliaRecordTobeInserted.Account_Owner_Manager_Email__c = accountRecord.Account_Owner_Manager_Email__c;
					medalliaRecordTobeInserted.Account_Status__c = accountRecord.RC_Account_Status__c;
					medalliaRecordTobeInserted.Account_Brand__c = accountRecord.RC_Brand__c;
					medalliaRecordTobeInserted.Account_Current_Owner__c = accountRecord.Current_Owner__c; 
					medalliaRecordTobeInserted.Account_Current_Owner_Email__c = accountRecord.Current_Owner_Email__c; 
					medalliaRecordTobeInserted.Account_Current_Owner_Manager_Email__c = accountRecord.Current_Owner_Manager_Email__c;
					medalliaRecordTobeInserted.Account_Recent_Opportunity_Manager_Email__c = accountRecord.Most_Recent_Opportunity_Manager_Email__c;
					medalliaRecordTobeInserted.Account_Recent_Opportunity_Owner_Email__c = accountRecord.Most_Recent_Opportunity_Owner_Email__c;
					medalliaRecordTobeInserted.Account_Number_of_DL_s__c = accountRecord.Number_of_DL_s__c != null ? String.valueOf(accountRecord.Number_of_DL_s__c) : '';
					medalliaRecordTobeInserted.Account_Service_name__c = accountRecord.RC_Service_name__c;
					medalliaRecordTobeInserted.Account_Service_Type__c = accountRecord.Service_Type__c;
					medalliaRecordTobeInserted.Account_Tier__c = accountRecord.RC_Tier__c;
					medalliaRecordTobeInserted.Account_User_Id__c = accountRecord.RC_User_ID__c;
					medalliaRecordTobeInserted.Account_Industry__c = accountRecord.Industry;
					medalliaRecordTobeInserted.Account_Signup_Date__c = accountRecord.RC_Signup_Date__c;
					medalliaRecordTobeInserted.Account_Activation_Date__c = accountRecord.RC_Activation_Date__c;
					medalliaRecordTobeInserted.Account_MRR__c = accountRecord.MRR__c;
					medalliaRecordTobeInserted.Account_Number_of_Employees__c = accountRecord.NumberOfEmployees != null ? String.valueOf(accountRecord.NumberOfEmployees) : '';
					medalliaRecordTobeInserted.Account_Number_of_Locations__c = accountRecord.Number_Of_Locations__c;
					medalliaRecordTobeInserted.Account_Billing_Country__c = accountRecord.BillingCountry;
					medalliaRecordTobeInserted.Account_Partner_ID__c = accountRecord.Partner_ID__c;
					medalliaRecordTobeInserted.Account_Payment_Plan__c = accountRecord.Payment_Plan__c;
					medalliaRecordTobeInserted.Account_Attribution_Channel__c = accountRecord.RC_Attribution_Channel__c;
					medalliaRecordTobeInserted.Account_Phone__c = accountRecord.Phone;
					medalliaRecordTobeInserted.Account_Partner_Name__c = accountRecord.Partner_Account_Name__c;
					medalliaRecordTobeInserted.Account_Type__c = accountRecord.Type;
					
					// Mapping Primary Contact fields.
					if(!accountPrimaryContactMap.isEmpty() && accountPrimaryContactMap.get(accountRecord.Id) != null && accountPrimaryContactMap.containskey(accountRecord.Id)){
						//medalliaRecordTobeInserted.Admin_Contact_ID__c = accountPrimaryContactMap.get(accountRecord.Id).ContactId;
						medalliaRecordTobeInserted.Admin_Contact_ID__c = primaryContact;
						medalliaRecordTobeInserted.Admin_FirstName__c = accountPrimaryContactMap.get(accountRecord.Id).Contact.FirstName; //Primary Contact
						medalliaRecordTobeInserted.Admin_LastName__c = accountPrimaryContactMap.get(accountRecord.Id).Contact.LastName; //Primary Contact
						medalliaRecordTobeInserted.Admin_isPrimary__c = accountPrimaryContactMap.get(accountRecord.Id).isPrimary; //Primary Contact
						medalliaRecordTobeInserted.Admin_Role__c = accountPrimaryContactMap.get(accountRecord.Id).Role; //Primary Contact
						medalliaRecordTobeInserted.Admin_Email__c = accountPrimaryContactMap.get(accountRecord.Id).Contact.Email; //Primary Contact
						medalliaRecordTobeInserted.Admin_Phone__c = accountPrimaryContactMap.get(accountRecord.Id).Contact.Phone; //Primary Contact
					}
					
					// Mapping Most Recent Opportunity Contact fields.
					//medalliaRecordTobeInserted.Sales_Contact_ID__c = accountRecord.Most_Recent_Opportunity_Contact__c;
					medalliaRecordTobeInserted.Sales_Contact_ID__c = mostRecentContact;
					medalliaRecordTobeInserted.Sales_FirstName__c = accountRecord.Most_Recent_Opportunity_Contact__r.FirstName;
					medalliaRecordTobeInserted.Sales_LastName__c = accountRecord.Most_Recent_Opportunity_Contact__r.LastName;
					if(!opportunityContactRoleMap.isEmpty() && opportunityContactRoleMap.get(accountRecord.Most_Recent_Opportunity_Contact__c) != null && opportunityContactRoleMap.containskey(accountRecord.Id)){
						medalliaRecordTobeInserted.Sales_isPrimary__c = opportunityContactRoleMap.get(accountRecord.Most_Recent_Opportunity_Contact__c).isPrimary;
						medalliaRecordTobeInserted.Sales_Role__c = opportunityContactRoleMap.get(accountRecord.Most_Recent_Opportunity_Contact__c).Role;
					}
					medalliaRecordTobeInserted.Sales_Email__c = accountRecord.Most_Recent_Opportunity_Contact__r.Email;
					medalliaRecordTobeInserted.Sales_Phone__c = accountRecord.Most_Recent_Opportunity_Contact__r.Phone;
					
					// Mapping Implementation Contact fields.
					if(!accountImplementationMap.isEmpty() && accountImplementationMap.get(accountRecord.Id) != null && accountImplementationMap.containskey(accountRecord.Id)){
						//medalliaRecordTobeInserted.Implementation_Contact_ID__c = accountImplementationMap.get(accountRecord.Id).Contact__r.Id;
						medalliaRecordTobeInserted.Implementation_Contact_ID__c = implementationContact;
						medalliaRecordTobeInserted.Implementation_Email__c = accountImplementationMap.get(accountRecord.Id).Contact__r.Email;
						medalliaRecordTobeInserted.Implementation_FirstName__c = accountImplementationMap.get(accountRecord.Id).Contact__r.FirstName;
						//medalliaRecordTobeInserted.Implementation_isPrimary__c = accountImplementationMap.get(accountRecord.Id).Contact__r.isPrimary;
						//medalliaRecordTobeInserted.Implementation_Role = accountImplementationMap.get(accountRecord.Id).Contact__r.Role;
						medalliaRecordTobeInserted.Implementation_LastName__c = accountImplementationMap.get(accountRecord.Id).Contact__r.LastName;
						medalliaRecordTobeInserted.Implementation_Phone__c = accountImplementationMap.get(accountRecord.Id).Contact__r.Phone;
						medalliaRecordTobeInserted.Implementation_SFDC_ID__c = accountImplementationMap.get(accountRecord.Id).Id;
					}
					
					//Adding the mapped records to the Medallia Survey Object list to be inserted.
		    		listMedalliaRecordsTobeInserted.add(medalliaRecordTobeInserted);
		    		//Adding the Account records to the Account Object list to be updated.
		    		listAccountTobeUpdated.add(accountRecord);
	    		}
	    	}
	    	
	    	// List empty check on the Medallia Survey object List, before performing the insert DML.
	    	if(!listMedalliaRecordsTobeInserted.isEmpty()){
	    		srList = Database.insert(listMedalliaRecordsTobeInserted, false);
	    	}
	    	// List empty check on the Account object List, before performing the update DML.
	    	if(!listAccountTobeUpdated.isEmpty()){
	    		update listAccountTobeUpdated;
	    	}
    		// Calling Send Email method of Helper Class, to notify in case of any failure of batch processing.
    		MedalliaSurveyHelper.sendEmailForErrors(srList,SURVEY_TYPE);
    		
    	}catch(Exception ex){
	    	system.debug('#### Error on line - '+ex.getLineNumber());
	    	system.debug('#### Error message - '+ex.getMessage());
	    }
	}
	
	/******************************************************************************
	* @Description : Finish method to send Email with list of failed records.     *
	* @Params      : Database.BatchableContext                                    *
	* @Return      : void                                                         * 
	******************************************************************************/
	global void finish(Database.BatchableContext BC){}
}// End of Class