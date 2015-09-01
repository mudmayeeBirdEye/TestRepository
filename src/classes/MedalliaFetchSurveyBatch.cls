/**************************************************************************************************
* Project Name..........: Medallia                                                                *
* File..................: MedalliaFetchSurveyBatch.class                                          *
* Version...............: 1.0                                                                     *
* Created by............: Simplion Technologies                                                   *
* Created Date..........: 24-02-2013                                                              *
* Last Modified by......: Simplion Technologies                                                   *
* Last Modified Date....: 24-02-2013                                                              *
* Description...........: This is a batch class to fetch survey records from Medallia system.     *
**************************************************************************************************/

global class MedalliaFetchSurveyBatch implements Database.Batchable<List<String>>,Database.AllowsCallouts {
	
	// Declaring variables.
	private String userName;
	private String password;
	private String apiKey;
	private String homeURL;
	private String companyName; 
	private String RECORD_NAME = 'Medallia';
	private Date TODAY_DATE = Date.today();
	private Integer fetchSurveyRecordsIndex = Medallia_Credentials__c.getInstance(RECORD_NAME) == null || Medallia_Credentials__c.getInstance(RECORD_NAME).FetchSurveyRecordIndex__c == null ? 
	                                          0 : Integer.valueOf(Medallia_Credentials__c.getInstance(RECORD_NAME).FetchSurveyRecordIndex__c);
	private String YESTERDAY_DATE = fetchSurveyRecordsIndex == null ? String.valueOf(TODAY_DATE) : String.valueOf(TODAY_DATE.addDays(-1)); // -1FetchSurveyRecordsIndex
	private String CLOSED = 'Closed';
	// List of relationship fields to query.
	public List<String> relationshipFieldsToQuery = new List<String> {
		'b2b_rc_relationship_ltr_eval',
		'b2b_rc_comments_comment',
		'b2b_rc_relationship_continue_eval',
		'b2b_rc_relationship_ease_eval',
		'b2b_rc_relationship_deliver_eval',
		'b2b_rc_relationship_leader_eval',
		'b2b_rc_relationship_product_overall_sat_eval',
		'b2b_rc_relationship_product_ease_eval',
		'b2b_rc_relationship_product_quality_eval',
		'b2b_rc_relationship_product_reliability_eval',
		'b2b_rc_relationship_product_features_eval',
		'b2b_rc_relationship_sales_usage_yn',
		'b2b_rc_relationship_support_usage_yn',
		'b2b_rc_relationship_sales_overall_sat_eval',
		'b2b_rc_relationship_sales_responsiveness_eval',
		'b2b_rc_relationship_sales_select_solutions_eval',
		'b2b_rc_relationship_support_overall_sat_eval',
		'b2b_rc_relationship_support_timeliness_eval',
		'b2b_rc_relationship_support_knowledge_eval',
		'b2b_rc_relationship_resources_documentation_eval',
		'b2b_rc_relationship_resources_website_eval',
		'b2b_rc_relationship_resources_community_eval',
		'b2b_rc_relationship_resources_webinars_eval',
		'b2b_rc_relationship_role_alt',
		'b2b_rc_relationship_contact_yn',
		'b2b_rc_additional_comments_comment'	
	};	
	
	// List of New Customer (After 90 days) fields to query.
	public List<String> newCustomerFieldsToQuery = new List<String> {
		'b2b_rc_sales_ltr_eval',
		'b2b_rc_comments_comment',
		'b2b_rc_sales_sales_overall_sat_eval',
		'b2b_rc_sales_knowledge_eval',
		'b2b_rc_sales_assistance_eval',
		'b2b_rc_sales_expectations_eval',
		'b2b_rc_sales_implemt_overall_sat_eval',
		'b2b_rc_sales_implemt_scheduling_eval',
		'b2b_rc_sales_implemt_communication_eval',
		'b2b_rc_sales_implemt_setup_eval',
		'b2b_rc_sales_implemt_number_transfer_eval',
		'b2b_rc_sales_implemt_resources_eval',
		'b2b_rc_sales_implemt_features_eval',
		'b2b_rc_sales_product_overall_sat_eval',
		'b2b_rc_sales_product_reliability_eval',
		'b2b_rc_sales_product_quality_eval',
		'b2b_rc_sales_product_features_eval',
		'b2b_rc_sales_support_overall_sat_eval',
		'b2b_rc_sales_support_timeliness_eval',
		'b2b_rc_sales_support_knowledge_eval',
		'b2b_rc_relationship_role_alt',
		'b2b_rc_relationship_contact_yn',
		'b2b_rc_additional_comments_comment',
		'b2b_rc_account_number_of_dl_s',
		'b2b_rc_account_service_type', //  Field added as per Xander request on 16 May 2014
		'b2b_rc_account_partner_id',
		//'b2b_rc_account_service_name',
		
		'b2b_rc_account_sfdc_id',
		'b2b_rc_admin_contact_id',
		'b2b_rc_sales_contact_id',
		'b2b_rc_implementation_contact_id',
		'b2b_rc_implementation_sfdc_id'
	};

	// List of Signature Account fields to query.
	public List<String> signatureAccountFieldsToQuery =  new List<String>{
		'b2b_rc_farming_overall_sat_eval',
		'b2b_rc_farming_sales_assistance_eval',
		'b2b_rc_farming_sales_responsiveness_eval',
		'b2b_rc_farming_sales_knowledge_eval',
		'b2b_rc_comments_comment',
		
		'b2b_rc_account_sfdc_id',
		'b2b_rc_admin_contact_id',
		'b2b_rc_sales_contact_id',
		'b2b_rc_opportunity_sfdc_id'
	};
	
	// List of Support fields to query.
	public List<String> supportFieldsToQuery = new List<String>{
		'b2b_rc_support_overall_sat_eval',
		'b2b_rc_support_wait_time_eval',
		'b2b_rc_support_courtesy_respect_eval',
		'b2b_rc_support_knowledge_eval',
		'b2b_rc_support_timeliness_eval',
		'b2b_rc_support_issue_resolved_yn',
		'b2b_rc_comments_comment',
		'b2b_rc_support_website_yn',
		'b2b_rc_support_website_overall_sat_eval',
		'b2b_rc_support_website_comments_comment',
		
		'b2b_rc_account_sfdc_id',
		'b2b_rc_case_sfdc_id',
		'b2b_rc_case_createdby',
		'b2b_rc_case_owner',
		'b2b_rc_case_owner_email',
		'b2b_rc_case_owner_manager',
		'b2b_rc_case_owner_manager_email',
		'b2b_rc_case_call_category'
	};
	
	// List of medallia supported fields
	public List<String> medalliaSupportedFields = new List<String>{
		//'status',
		'surveyid',
		'firstname',
		'lastname',
		'email',
		'creationdate',
		'accepteddate',
		'b2b_rc_phone',
		'b2b_rc_contact_id',
		'b2b_rc_account_role',
		'b2b_rc_contact_type',
		'b2b_rc_isprimary',
		'b2b_rc_survey_status_text'
	};
	
	// List of log fields.
    public List<String> medalliaLogNotesFields = new List<String>{
        'alert_closed_by',
        'alert_date_closed',
        'alert_status',
        'alert_type',
        'alert_ever_escalated',
        'alert_ever_overdue',
        'log_notes'
    };
	
	private String action = 'GET';
	private String outputFormat = 'json';
	private String version = '1';
	
	// Wrapper class for JSON Parsing
	public class JSONColumnsWrapper{
		List<String> columns;
		Integer resultCode;
		List<List<String>> table;
	}
	
	public class JSONColumns{
		JSONColumnsWrapper query;
	}
	
	/******************************************************************************
	* @Description : Controller Class.                                            *
	* @Params      : void                                                         *
	* @Return      :                                                              * 
	******************************************************************************/	
	global MedalliaFetchSurveyBatch(){}
	
	/******************************************************************************
	* @Description : Start method to execute the query for batch.                 *
	* @Params      : Database.BatchableContext                                    *
	* @Return      : Database.querylocator                                        * 
	******************************************************************************/
	global Iterable<List<String>> start(Database.BatchableContext BC){
		
		List<List<String>> emptyObject = new List<List<String>>();
		String mqlQueryStatement;
		 
		try{
			
			system.debug('#### recordName - '+RECORD_NAME);
			
			//Creating MQL query.
			mqlQueryStatement = 'SELECT ';
			for(String thisField : relationshipFieldsToQuery){
				mqlQueryStatement = mqlQueryStatement + thisField+',';
			}
			for(String thisField : newCustomerFieldsToQuery){
				mqlQueryStatement = mqlQueryStatement + thisField+',';
			}
			for(String thisField : signatureAccountFieldsToQuery){
				mqlQueryStatement = mqlQueryStatement + thisField+',';
			}
			for(String thisField : supportFieldsToQuery){
				mqlQueryStatement = mqlQueryStatement + thisField+',';
			}
			for(String thisField : medalliaSupportedFields) {
				mqlQueryStatement = mqlQueryStatement + thisField+','; 
			}
			for(String thisField : medalliaLogNotesFields) {
                mqlQueryStatement = mqlQueryStatement + thisField+','; 
            }
            
            mqlQueryStatement = mqlQueryStatement + ' b2b_rc_survey_type FROM Survey WHERE accepteddate = \''+YESTERDAY_DATE+'\''+' OR ( alert_status = \''+CLOSED+'\' AND alert_date_closed = \''+YESTERDAY_DATE+'\''+')';
            
			//mqlQueryStatement = mqlQueryStatement + ' b2b_rc_survey_type FROM Survey WHERE accepteddate = \''+YESTERDAY_DATE+'\'';
			// mqlQueryStatement = mqlQueryStatement + 'b2b_rc_survey_type FROM Survey WHERE responsedate = \''+YESTERDAY_DATE+'\'';
			system.debug('#### mqlQueryStatement - '+mqlQueryStatement);
			
			String encodedMqlQueryStatement = EncodingUtil.urlEncode(mqlQueryStatement, 'UTF-8');
			
			// system debugs for date.
			system.debug('#### Today\'s Date - '+TODAY_DATE);
			system.debug('#### Index to fetch Survey\'s - '+fetchSurveyRecordsIndex);
			system.debug('#### Yesterday\'s Date - '+YESTERDAY_DATE);
			
			// Setting username,password,apikey,company name,home url values from custom setting.
			if( Medallia_Credentials__c.getInstance(RECORD_NAME) != null ){
				try {
					userName = (Medallia_Credentials__c.getInstance(RECORD_NAME).User_Name__c).trim();
					password = (Medallia_Credentials__c.getInstance(RECORD_NAME).Password__c).trim();
					apiKey = (Medallia_Credentials__c.getInstance(RECORD_NAME).API_Key__c).trim();
					companyName = (Medallia_Credentials__c.getInstance(RECORD_NAME).Company_Name__c).trim();
					homeURL = (Medallia_Credentials__c.getInstance(RECORD_NAME).Home_URL__c).trim();
				} catch(Exception exc) {
					system.debug('#### Error on line - '+exc.getLineNumber());
	    			system.debug('#### Error message - '+exc.getMessage());		
				}
			}	
		
			// Creating end point URL to query the medallia server and fetch the response.
			String queryURL = homeURL+'/'+companyName+'?user='+userName+'&pass='+password+'&query='+encodedMqlQueryStatement+'&output='+outputFormat+'&version='+version+'&apiKey='+apiKey;
			String responseString;
						
			if (Test.isRunningTest()) {
				responseString = '{'+
    								'"query": {'+
        							'"columns": ["b2b_rc_relationship_ltr_eval", "b2b_rc_comments_comment", "b2b_rc_relationship_continue_eval",'+
        							           ' "b2b_rc_relationship_ease_eval", "b2b_rc_relationship_deliver_eval", "b2b_rc_relationship_leader_eval",'+
        							           ' "b2b_rc_relationship_product_overall_sat_eval", "b2b_rc_relationship_product_ease_eval",'+ 
        							           ' "b2b_rc_relationship_product_quality_eval", "b2b_rc_relationship_product_reliability_eval",'+
        							           ' "b2b_rc_relationship_product_features_eval", "b2b_rc_relationship_sales_usage_yn", "b2b_rc_relationship_support_usage_yn",'+ 
        							           ' "b2b_rc_relationship_sales_overall_sat_eval", "b2b_rc_relationship_sales_responsiveness_eval",'+ 
        							           ' "b2b_rc_relationship_sales_select_solutions_eval", "b2b_rc_relationship_support_overall_sat_eval",'+ 
        							           ' "b2b_rc_relationship_support_timeliness_eval", "b2b_rc_relationship_support_knowledge_eval",'+ 
        							           ' "b2b_rc_relationship_resources_documentation_eval", "b2b_rc_relationship_resources_website_eval", '+
        							           ' "b2b_rc_relationship_resources_community_eval", "b2b_rc_relationship_resources_webinars_eval", "b2b_rc_relationship_role_alt",'+
        							           ' "b2b_rc_relationship_contact_yn", "b2b_rc_additional_comments_comment", "b2b_rc_sales_ltr_eval", "b2b_rc_comments_comment",'+ 
        							           ' "b2b_rc_sales_sales_overall_sat_eval", "b2b_rc_sales_knowledge_eval", "b2b_rc_sales_assistance_eval", "b2b_rc_sales_expectations_eval",'+ 
        							           ' "b2b_rc_sales_implemt_overall_sat_eval", "b2b_rc_sales_implemt_scheduling_eval", "b2b_rc_sales_implemt_communication_eval",'+ 
        							           ' "b2b_rc_sales_implemt_setup_eval", "b2b_rc_sales_implemt_number_transfer_eval", "b2b_rc_sales_implemt_resources_eval",'+ 
        							           ' "b2b_rc_sales_implemt_features_eval", "b2b_rc_sales_product_overall_sat_eval", "b2b_rc_sales_product_reliability_eval",'+ 
        							           ' "b2b_rc_sales_product_quality_eval", "b2b_rc_sales_product_features_eval", "b2b_rc_sales_support_overall_sat_eval",'+ 
        							           ' "b2b_rc_sales_support_timeliness_eval", "b2b_rc_sales_support_knowledge_eval", "b2b_rc_relationship_role_alt",'+ 
        							           ' "b2b_rc_relationship_contact_yn", "b2b_rc_additional_comments_comment", "b2b_rc_account_sfdc_id", "b2b_rc_admin_contact_id",'+ 
        							           ' "b2b_rc_sales_contact_id", "b2b_rc_implementation_contact_id", "b2b_rc_farming_overall_sat_eval", "b2b_rc_farming_sales_assistance_eval",'+ 
        							           ' "b2b_rc_farming_sales_responsiveness_eval", "b2b_rc_farming_sales_knowledge_eval", "b2b_rc_comments_comment", "b2b_rc_account_sfdc_id",'+ 
        							           ' "b2b_rc_admin_contact_id", "b2b_rc_sales_contact_id", "b2b_rc_support_overall_sat_eval", "b2b_rc_support_wait_time_eval",'+ 
        							           ' "b2b_rc_support_courtesy_respect_eval", "b2b_rc_support_knowledge_eval", "b2b_rc_support_timeliness_eval", "b2b_rc_support_issue_resolved_yn",'+ 
        							           ' "b2b_rc_comments_comment", "b2b_rc_support_website_yn", "b2b_rc_support_website_overall_sat_eval", "b2b_rc_support_website_comments_comment",'+
        							           ' "b2b_rc_account_sfdc_id", "b2b_rc_case_sfdc_id", "b2b_rc_case_createdby", "b2b_rc_case_owner", "b2b_rc_survey_type", "b2b_rc_survey_status_text", "surveyid",'+
        							           ' "b2b_rc_case_owner_email", "b2b_rc_case_owner_manager", "b2b_rc_case_owner_manager_email",'+
        							           ' "b2b_rc_contact_id", "firstname", "lastname", "email","b2b_rc_phone", "b2b_rc_account_role", "b2b_rc_contact_type", "b2b_rc_isprimary", "accepteddate", "creationdate",'+
        							           ' "b2b_rc_account_number_of_dl_s", "b2b_rc_account_service_type", "alert_closed_by", "alert_date_closed", "alert_status", "alert_type", "alert_ever_escalated", '+
                                               ' "alert_ever_overdue", "log_notes"],'+
        							'"resultCode": 0,'+
        							'"table": ['+
			            						'["","Test Comment","","","","","","","","","","","","","","","","","","","","","","","","","","Test Comment","","","","","","","","","","","","","","","","","","","","","","3",'+
			            						 '"AT&T Office@Hand","","","","","","","","","","Test Comment","","","","","3","8","8","8","0","No","Test Comment","Yes","0","","","","RCESB","Test User","Test.User@ringcentral.com",'+
			            						 '"Randall Balagwis","randallb@ringcentral.com","","315420","Dave","Gwaltney","dave@gwaltneyassoc.com","2014-04-24","2014-04-28","19079806949","","","Support","True","Completed","Support"]'+
        									 ']'+
    									'}'+
									'}';
		    }else{
	        	// Setting up the HTTP request parameters.
				Http http = new Http();
		        HttpRequest req = new HttpRequest();
		    	req.setEndpoint(queryURL);
		        req.setMethod(action);
		        HttpResponse res = new HttpResponse();
		        res = http.send(req);
		        
		        system.debug('#### Status - '+res.getStatus());
        		system.debug('#### Body - '+res.getBody());
        	
		        responseString = res.getBody();
	        }
	        
	        
	        // Deserialising JSON Response into readable format.
	        JSONColumns jsonResult = new JSONColumns();
        	jsonResult = (JSONColumns)JSON.deserialize(responseString,JSONColumns.class);
	        system.debug('#### jsonResult - '+jsonResult);
	        
	        /* Return list of records fetched from the Medallia Server,
	           into the execute method scope for batch processing.*/
	        if(jsonResult.query.resultCode == 0){
	        	return jsonResult.query.table;
	        }
		} catch(Exception ex){
			system.debug('#### Error on line - '+ex.getLineNumber());
	    	system.debug('#### Error message - '+ex.getMessage());
		}
		return emptyObject;
	}
	
	/******************************************************************************
	* @Description : Start method to execute the query for batch.                 *
	* @Params      : Database.BatchableContext, List<sObject>                     *
	* @Return      : void                                                         * 
	******************************************************************************/
	global void execute(Database.BatchableContext BC, List<List<String>> scope){
		
		system.debug('#### Inside batch execute method');
		List<Survey__c> listSurveyToInsert = new List<Survey__c>();
        List<Survey__c> listSurveyToUpsert = new List<Survey__c>();
        List<Id> surveyIds = new List<Id>();
        Map<String, Survey__c> mapSurveyLog = new Map<String, Survey__c>();
        Database.UpsertResult[] srList; // List to contain Database result.
		
		// Collecting all the fields queried into on list.
		List<String> listResponseColumns = new List<String>();
		listResponseColumns.addAll(relationshipFieldsToQuery);
		listResponseColumns.addAll(newCustomerFieldsToQuery);
		listResponseColumns.addAll(signatureAccountFieldsToQuery);
		listResponseColumns.addAll(supportFieldsToQuery);
		listResponseColumns.addAll(medalliaSupportedFields);
		listResponseColumns.addAll(medalliaLogNotesFields);
		listResponseColumns.add('b2b_rc_survey_type');
		
		system.debug('#### listResponseColumns - '+listResponseColumns);
		
		Document d = new Document(); 
		d.Name = 'MEDALLIA - ' + System.now() + '# ' + Math.random(); 
	    d.ContentType = 'text/plain';
	    //d.FolderId = '00ln0000000DgII'; // SB 8
	    d.FolderId = '00l80000001m2Gg'; // Production
	    d.Type = 'txt';
		String Content = '';
		
		try{
			system.debug('#### Number of survey records fetched - '+scope.size());
        	for(Integer counter = 0; counter < scope.size(); counter++){
        		Content +='[';
        		Survey__c surveyRecordsToInsert = new Survey__c();
        		//system.debug('#### Columns size - '+listResponseColumns.size());
        		for(Integer innerCounter = 0; innerCounter < listResponseColumns.size(); innerCounter++ ){
				    
        			Content += '## COUNT = '+innerCounter+', '+listResponseColumns[innerCounter] + ' = ' +validateString(scope[counter][innerCounter]) +'\n';
        			// Fetch Medallia Generated Fields 
        			//system.debug('#### inside for - '+innerCounter+' - '+listResponseColumns[innerCounter] + ', VALUE = ' +validateString(scope[counter][innerCounter]));
        			/**************************** MEDALLIA GENERATED FIELDS *********************************/
					if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_survey_type')){
	        			surveyRecordsToInsert.SurveyType__c = validateString(scope[counter][innerCounter]);
	        			surveyRecordsToInsert.Name = (scope[counter][innerCounter]) + ' response ' + (System.now());
	        		}
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_contact_id') ){
	        			if(!String.isBlank(validateString(scope[counter][innerCounter])) && scope[counter][innerCounter].startsWith('003')){
	        				surveyRecordsToInsert.Contact__c = validateString(scope[counter][innerCounter]);
	        			}
	        		}
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('firstname')){
	        			surveyRecordsToInsert.Contact_First_Name__c = validateString(scope[counter][innerCounter]);
	        		}
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('lastname')){
	        			surveyRecordsToInsert.Contact_Last_Name__c = validateString(scope[counter][innerCounter]);
	        		}
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('email')){
	        			surveyRecordsToInsert.Contact_Email__c = validateString(scope[counter][innerCounter]);
	        		}
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_phone')){
	        			surveyRecordsToInsert.Contact_Phone__c = validateString(scope[counter][innerCounter]);
	        		}
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_account_role')){
	        			surveyRecordsToInsert.Contact_Role__c = validateString(scope[counter][innerCounter]);
	        		}
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_contact_type')){
	        			surveyRecordsToInsert.Contact_Type__c = validateString(scope[counter][innerCounter]);
	        		}
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_isprimary')){
	        			surveyRecordsToInsert.Contact_isPrimary__c = (validateString(scope[counter][innerCounter]) != null && scope[counter][innerCounter].indexOf('true') != -1 ? true : false);
	        		}
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('accepteddate')){
	        			surveyRecordsToInsert.Response_Date__c = (validateString(scope[counter][innerCounter]) != null ? Date.valueOf(scope[counter][innerCounter]) : null);
	        		}
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('creationdate')){
	        			surveyRecordsToInsert.Delivered_Date__c = (validateString(scope[counter][innerCounter]) != null ? Date.valueOf(scope[counter][innerCounter]) : null);
	        		}
	        		
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('surveyid')){
	        			surveyRecordsToInsert.Survey_ID__c = validateString(scope[counter][innerCounter]);
        			}
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_survey_status_text')){
	        			surveyRecordsToInsert.Status__c = validateString(scope[counter][innerCounter]);
	        		}
	        		/*************************************************************/
	        		// Field mapping for Relationship Survey
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_relationship_ltr_eval')){
	        			surveyRecordsToInsert.Likely_to_Recommend_Rel__c = convertToInteger(validateString(scope[counter][innerCounter]));
	        		}
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_comments_comment')){
	        			surveyRecordsToInsert.Comments__c = validateString(scope[counter][innerCounter]);
	        		}
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_relationship_continue_eval')){
	        			surveyRecordsToInsert.Continue_to_Contract_Rel__c = convertToInteger(validateString(scope[counter][innerCounter]));
	        		}
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_relationship_ease_eval')){
	        			surveyRecordsToInsert.Ease_of_doing_Business_Rel__c = convertToInteger(validateString(scope[counter][innerCounter]));
	        		}
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_relationship_deliver_eval')){
	        			surveyRecordsToInsert.Deliver_as_Promised_Rel__c = convertToInteger(validateString(scope[counter][innerCounter]));
	        		}
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_relationship_leader_eval')){
	        			surveyRecordsToInsert.Innovation_Leader_Rel__c = convertToInteger(validateString(scope[counter][innerCounter]));
	        		}
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_relationship_product_overall_sat_eval')){
	        			surveyRecordsToInsert.Overall_Product_Satisfaction_Rel__c = convertToInteger(validateString(scope[counter][innerCounter]));
	        		}
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_relationship_product_ease_eval')){
	        			surveyRecordsToInsert.Ease_of_Use_Rel__c = convertToInteger(validateString(scope[counter][innerCounter]));
	        		}
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_relationship_product_quality_eval')){
	        			surveyRecordsToInsert.Voice_Quality_Rel__c = convertToInteger(validateString(scope[counter][innerCounter]));
	        		}
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_relationship_product_reliability_eval')){
	        			surveyRecordsToInsert.Reliability_of_Service_Rel__c = convertToInteger(validateString(scope[counter][innerCounter]));
	        		}
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_relationship_product_features_eval')){
	        			surveyRecordsToInsert.Features_and_Functionality_Rel__c = convertToInteger(validateString(scope[counter][innerCounter]));
	        		}
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_relationship_sales_usage_yn')){
	        			surveyRecordsToInsert.Sales_Usage_Rel__c = validateString(scope[counter][innerCounter]);
	        		}
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_relationship_support_usage_yn')){
	        			surveyRecordsToInsert.Support_Usage_Rel__c = validateString(scope[counter][innerCounter]);
	        		}
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_relationship_sales_overall_sat_eval')){
	        			surveyRecordsToInsert.Overall_AcctExecutive_Satisfaction_Rel__c = convertToInteger(validateString(scope[counter][innerCounter]));
	        		}
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_relationship_sales_responsiveness_eval')){
	        			surveyRecordsToInsert.Responsiveness_to_Inquiries_Rel__c = convertToInteger(validateString(scope[counter][innerCounter]));
	        		}
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_relationship_sales_select_solutions_eval')){
	        			surveyRecordsToInsert.Help_to_Select_Right_Solution_Rel__c = convertToInteger(validateString(scope[counter][innerCounter]));
	        		}
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_relationship_support_overall_sat_eval')){
	        			surveyRecordsToInsert.Overall_Support_Satisfaction_Rel__c = convertToInteger(validateString(scope[counter][innerCounter]));
	        		}
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_relationship_support_timeliness_eval')){
	        			surveyRecordsToInsert.Timeliness_of_Resolution_Rel__c = convertToInteger(validateString(scope[counter][innerCounter]));
	        		}
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_relationship_support_knowledge_eval')){
	        			surveyRecordsToInsert.Knowledge_and_Technical_Competence_Rel__c = convertToInteger(validateString(scope[counter][innerCounter]));
	        		}
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_relationship_resources_documentation_eval')){
	        			surveyRecordsToInsert.Product_Documentation_Rel__c = convertToInteger(validateString(scope[counter][innerCounter]));
	        		}
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_relationship_resources_website_eval')){
	        			surveyRecordsToInsert.RingCentral_Support_Website_Rel__c = convertToInteger(validateString(scope[counter][innerCounter]));
	        		}
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_relationship_resources_community_eval')){
	        			surveyRecordsToInsert.Online_RingCentral_Community_Rel__c = convertToInteger(validateString(scope[counter][innerCounter]));
	        		}
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_relationship_resources_webinars_eval')){
	        			surveyRecordsToInsert.Training_Webinars_Rel__c = convertToInteger(validateString(scope[counter][innerCounter]));
	        		}
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_relationship_role_alt')){
	        			surveyRecordsToInsert.Role_Rel__c = validateString(scope[counter][innerCounter]);
	        		}
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_relationship_contact_yn')){
	        			surveyRecordsToInsert.RingCentral_Reference_Rel__c = validateString(scope[counter][innerCounter]);
	        		}
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_additional_comments_comment')){
	        			surveyRecordsToInsert.Additional_Comments_Medallia__c = validateString(scope[counter][innerCounter]);
	        		}
	        		
	        		// Field mapping for New Customer Survey
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_sales_ltr_eval')){
	        			surveyRecordsToInsert.sales_ltr_eval__c = convertToInteger(validateString(scope[counter][innerCounter]));
	        		}
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_comments_comment')){
	        			surveyRecordsToInsert.Comments__c = validateString(scope[counter][innerCounter]);
	        		}
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_sales_sales_overall_sat_eval')){
	        			surveyRecordsToInsert.sales_sales_overall_sat_eval__c = convertToInteger(validateString(scope[counter][innerCounter]));
	        		}
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_sales_knowledge_eval')){
	        			surveyRecordsToInsert.sales_knowledge_eval__c = convertToInteger(validateString(scope[counter][innerCounter]));
	        		}
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_sales_assistance_eval')){
	        			surveyRecordsToInsert.sales_assistance_eval__c = convertToInteger(validateString(scope[counter][innerCounter]));
	        		}
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_sales_expectations_eval')){
	        			surveyRecordsToInsert.sales_expectations_eval__c = convertToInteger(validateString(scope[counter][innerCounter]));
	        		}
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_sales_implemt_overall_sat_eval')){
	        			surveyRecordsToInsert.sales_implemt_overall_sat_eval__c = convertToInteger(validateString(scope[counter][innerCounter]));
	        		}
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_sales_implemt_scheduling_eval')){
	        			surveyRecordsToInsert.sales_implemt_scheduling_eval__c = convertToInteger(validateString(scope[counter][innerCounter]));
	        		}
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_sales_implemt_communication_eval')){
	        			surveyRecordsToInsert.sales_implemt_communication_eval__c = convertToInteger(validateString(scope[counter][innerCounter]));
	        		}
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_sales_implemt_setup_eval')){
	        			surveyRecordsToInsert.sales_implemt_setup_eval__c = convertToInteger(validateString(scope[counter][innerCounter]));
	        		}
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_sales_implemt_number_transfer_eval')){
	        			surveyRecordsToInsert.sales_implemt_number_transfer_eval__c = convertToInteger(validateString(scope[counter][innerCounter]));
	        		}
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_sales_implemt_resources_eval')){
	        			surveyRecordsToInsert.sales_implemt_resources_eval__c = convertToInteger(validateString(scope[counter][innerCounter]));
	        		}
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_sales_implemt_features_eval')){
	        			surveyRecordsToInsert.sales_implemt_features_eval__c = convertToInteger(validateString(scope[counter][innerCounter]));
	        		}	
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_sales_product_overall_sat_eval')){
	        			surveyRecordsToInsert.sales_product_overall_sat_eval__c = convertToInteger(validateString(scope[counter][innerCounter]));
	        		}
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_sales_product_reliability_eval')){
	        			surveyRecordsToInsert.sales_product_reliability_eval__c = convertToInteger(validateString(scope[counter][innerCounter]));
	        		}
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_sales_product_quality_eval')){
	        			surveyRecordsToInsert.sales_product_quality_eval__c = convertToInteger(validateString(scope[counter][innerCounter]));
	        		}
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_sales_product_features_eval')){
	        			surveyRecordsToInsert.sales_product_features_eval__c = convertToInteger(validateString(scope[counter][innerCounter]));
	        		}
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_sales_support_overall_sat_eval')){
	        			surveyRecordsToInsert.sales_support_overall_sat_eval__c = convertToInteger(validateString(scope[counter][innerCounter]));
	        		}
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_sales_support_timeliness_eval')){
	        			surveyRecordsToInsert.sales_support_timeliness_eval__c = convertToInteger(validateString(scope[counter][innerCounter]));
	        		}
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_sales_support_knowledge_eval')){
	        			surveyRecordsToInsert.sales_support_knowledge_eval__c = convertToInteger(validateString(scope[counter][innerCounter]));
	        		}
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_relationship_role_alt')){
	        			surveyRecordsToInsert.Role_Rel__c = validateString(scope[counter][innerCounter]);
	        		}
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_relationship_contact_yn')){
	        			surveyRecordsToInsert.RingCentral_Reference_Rel__c = validateString(scope[counter][innerCounter]);
	        		}
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_additional_comments_comment')){
	        			surveyRecordsToInsert.Additional_Comments_Medallia__c = validateString(scope[counter][innerCounter]);
	        		}
	        		/*********** ADDED MORE FIELDS ON 6th March*********/
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_account_sfdc_id')){
	        			if(!String.isBlank(validateString(scope[counter][innerCounter])) && scope[counter][innerCounter].startsWith('001')){
	        				surveyRecordsToInsert.Account__c = validateString(scope[counter][innerCounter]);
	        			}
	        		}
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_admin_contact_id')){
	        			if(!String.isBlank(validateString(scope[counter][innerCounter]))  && scope[counter][innerCounter].startsWith('003')){
	        				surveyRecordsToInsert.Contact_Admin__c = validateString(scope[counter][innerCounter]);
	        			}
	        		}
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_sales_contact_id')){
        				if(!String.isBlank(validateString(scope[counter][innerCounter])) && scope[counter][innerCounter].startsWith('003')){
        					surveyRecordsToInsert.Contact_Sales__c = validateString(scope[counter][innerCounter]);
        				}
	        		}
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_implementation_contact_id')){
	        			if(!String.isBlank(validateString(scope[counter][innerCounter])) && scope[counter][innerCounter].startsWith('003')){
        					surveyRecordsToInsert.Contact_Implementations__c = validateString(scope[counter][innerCounter]);
	        			}
	        		}
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_implementation_sfdc_id')){
	        			if(!String.isBlank(validateString(scope[counter][innerCounter])) && scope[counter][innerCounter].startsWith('a07')){
        					surveyRecordsToInsert.Implementation__c = validateString(scope[counter][innerCounter]);
	        			}
	        		}
	        		/************************************************************/
	        		// Field mapping for Signature Accounts Survey.
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_farming_overall_sat_eval')){
	        			surveyRecordsToInsert.farming_overall_sat_eval__c = convertToInteger(validateString(scope[counter][innerCounter]));
	        		}
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_farming_sales_assistance_eval')){
	        			surveyRecordsToInsert.farming_sales_assistance_eval__c = convertToInteger(validateString(scope[counter][innerCounter]));
	        		}
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_farming_sales_responsiveness_eval')){
	        			surveyRecordsToInsert.farming_sales_responsiveness_eval__c = convertToInteger(validateString(scope[counter][innerCounter]));
	        		}
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_farming_sales_knowledge_eval')){
	        			surveyRecordsToInsert.farming_sales_knowledge_eval__c = convertToInteger(validateString(scope[counter][innerCounter]));
	        		}
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_comments_comment')){
	        			surveyRecordsToInsert.Comments__c = validateString(scope[counter][innerCounter]);
	        		}
	        		
	        		/*********** ADDED MORE FIELDS ON 6th March*********/
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_account_sfdc_id')){
	        			if(!String.isBlank(validateString(scope[counter][innerCounter])) && scope[counter][innerCounter].startsWith('001')){
	        				surveyRecordsToInsert.Account__c = validateString(scope[counter][innerCounter]);
	        			}
	        		}
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_admin_contact_id')){
	        			if(!String.isBlank(validateString(scope[counter][innerCounter])) && scope[counter][innerCounter].startsWith('003')){
	        				surveyRecordsToInsert.Contact_Admin__c = validateString(scope[counter][innerCounter]);
	        			}
	        		}
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_sales_contact_id')){
	        			if(!String.isBlank(validateString(scope[counter][innerCounter])) && scope[counter][innerCounter].startsWith('003')){
        					surveyRecordsToInsert.Contact_Sales__c = validateString(scope[counter][innerCounter]);
	        			}
	        		}
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_opportunity_sfdc_id')){
        				if(!String.isBlank(validateString(scope[counter][innerCounter])) && scope[counter][innerCounter].startsWith('006')){
        					surveyRecordsToInsert.Opportunity__c = validateString(scope[counter][innerCounter]);
        				}
	        		}
	        		/************************************************************/
	        		//Field mapping for Support Survey.
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_support_overall_sat_eval')){
	        			surveyRecordsToInsert.support_overall_sat_eval__c = convertToInteger(validateString(scope[counter][innerCounter]));
	        		}
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_support_wait_time_eval')){
	        			surveyRecordsToInsert.support_wait_time_eval__c = convertToInteger(validateString(scope[counter][innerCounter]));
	        		}
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_support_courtesy_respect_eval')){
	        			surveyRecordsToInsert.support_courtesy_respect_eval__c = convertToInteger(validateString(scope[counter][innerCounter]));
	        		}
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_support_knowledge_eval')){
	        			surveyRecordsToInsert.support_knowledge_eval__c = convertToInteger(validateString(scope[counter][innerCounter]));
	        		}
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_support_timeliness_eval')){
	        			surveyRecordsToInsert.support_timeliness_eval__c = convertToInteger(validateString(scope[counter][innerCounter]));
	        		}
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_support_issue_resolved_yn')){
	        			surveyRecordsToInsert.support_issue_resolved_yn__c = validateString(scope[counter][innerCounter]);
	        		}
	        		/*if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_comments_comment')){
	        			surveyRecordsToInsert.comments_comment__c = validateString(scope[counter][innerCounter]);
	        		}*/
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_support_website_yn')){
	        			surveyRecordsToInsert.support_website_yn__c = validateString(scope[counter][innerCounter]);
	        		}
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_support_website_overall_sat_eval')){
	        			surveyRecordsToInsert.support_website_overall_sat_eval__c = convertToInteger(validateString(scope[counter][innerCounter]));
	        		}
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_support_website_comments_comment')){
	        			surveyRecordsToInsert.support_website_comments_comment__c = validateString(scope[counter][innerCounter]);
	        		}
	        		/*********** ADDED MORE FIELDS ON 6th March*********/
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_account_sfdc_id')){
	        			if(!String.isBlank(validateString(scope[counter][innerCounter])) && scope[counter][innerCounter].startsWith('001')){
	        				surveyRecordsToInsert.Account__c = validateString(scope[counter][innerCounter]);
	        			}
	        		}
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_case_sfdc_id')){
	        			if(!String.isBlank(validateString(scope[counter][innerCounter])) && scope[counter][innerCounter].startsWith('500')){
	        				//surveyRecordsToInsert.Case__c = validateString(scope[counter][innerCounter]);
	        			}
	        		}
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_case_createdby')){
	        			if(!String.isBlank(validateString(scope[counter][innerCounter])) && scope[counter][innerCounter].startsWith('005')) {
	        				surveyRecordsToInsert.Case_CreatedBy__c = validateString(scope[counter][innerCounter]);
	        			}
	        		}
	        		/************************************************************/
	        		/*
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_case_owner')){
	        			if(!String.isBlank(validateString(scope[counter][innerCounter])) && scope[counter][innerCounter].startsWith('005')) {
	        				surveyRecordsToInsert.OwnerId = validateString(scope[counter][innerCounter]);
	        			}	
	        		}
	        		*/
	        		// New Mapping as per Xander's update on 8th April 2014
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_case_owner')){
        				surveyRecordsToInsert.Agent_Name__c = validateString(scope[counter][innerCounter]);
	        		}
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_case_owner_email')){
        				surveyRecordsToInsert.Agent_Email__c = validateString(scope[counter][innerCounter]);
	        		}
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('= b2b_rc_case_owner_manager')){
        				surveyRecordsToInsert.Agent_Manager_Name__c = validateString(scope[counter][innerCounter]);
	        		}
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_case_owner_manager_email')){
        				surveyRecordsToInsert.Agent_Manager_Email__c = validateString(scope[counter][innerCounter]);
	        		}
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_case_call_category')){
        				surveyRecordsToInsert.Call_Category__c = validateString(scope[counter][innerCounter]);
	        		}
	        		// New Mapping/Fields added as per to correct the Medallia and RC reporting mismatch for Surveys.
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_account_number_of_dl_s')){
	        			surveyRecordsToInsert.Snapshot_Number_of_DLs__c = convertToInteger(validateString(scope[counter][innerCounter]));	
	        		}
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_account_service_type')){
	        			surveyRecordsToInsert.Snapshot_Service_Name__c = validateString(String.valueOf(scope[counter][innerCounter]));
	        		}
	        		if(listResponseColumns[innerCounter].equalsIgnoreCase('b2b_rc_account_partner_id')){
	        			surveyRecordsToInsert.Snapshot_Partner_ID__c  = validateString(String.valueOf(scope[counter][innerCounter]));
	        		}
	        		/*****Survey Log fields as per Xander Requirement Mail on 29th May 2014********/
                    if(listResponseColumns[innerCounter].equalsIgnoreCase('alert_status')){
                        surveyRecordsToInsert.Alert_Status__c = validateString(String.valueOf(scope[counter][innerCounter]));
                    }
                    if(listResponseColumns[innerCounter].equalsIgnoreCase('alert_closed_by')){
                        surveyRecordsToInsert.Alert_Closed_By__c = validateString(String.valueOf(scope[counter][innerCounter]));
                    }
                    if(listResponseColumns[innerCounter].equalsIgnoreCase('alert_date_closed')){
                        surveyRecordsToInsert.Alert_Closed_Date_Time__c = validateString(String.valueOf(scope[counter][innerCounter])) != null ? Datetime.valueOf(validateString(String.valueOf(scope[counter][innerCounter])+' 00:00:00')): null;
                    }
                    if(listResponseColumns[innerCounter].equalsIgnoreCase('alert_type')){
                        surveyRecordsToInsert.Alert_Type__c = validateString(String.valueOf(scope[counter][innerCounter]));
                    }
                    if(listResponseColumns[innerCounter].equalsIgnoreCase('alert_ever_escalated')){
                        surveyRecordsToInsert.Alert_Ever_Escalated__c = validateBoolean(String.valueOf(scope[counter][innerCounter]));
                    }
                    if(listResponseColumns[innerCounter].equalsIgnoreCase('alert_ever_overdue')){
                        surveyRecordsToInsert.Alert_Ever_in_Overdue__c = validateBoolean(String.valueOf(scope[counter][innerCounter]));
                    }
                    if(listResponseColumns[innerCounter].equalsIgnoreCase('log_notes')){
                        surveyRecordsToInsert.Log_Notes__c = validateString(String.valueOf(scope[counter][innerCounter]));
                    }
                    /************************* Survey Log fields***********************************/
        		}
        		Content +=']\n';
				listSurveyToInsert.add(surveyRecordsToInsert);
        	}
        	
        	system.debug('#### listSurveyToInsert - '+listSurveyToInsert);
        	d.Body = Blob.valueOf(Content);
        	insert d;
        	// Inserting records fetched from Medallia Server into Survey Object.
        	if(!listSurveyToInsert.isEmpty()){
        		try {
        			for(Survey__c thisSurvey : listSurveyToInsert){
                        if(thisSurvey.Response_Date__c == Date.valueOf(YESTERDAY_DATE+' 00:00:00')){ 
                        	thisSurvey.Alert_Closed_By__c = null;
                            thisSurvey.Alert_Closed_Date_Time__c = null;
                            thisSurvey.Alert_Status__c = null;
                            thisSurvey.Alert_Type__c = null;
                            thisSurvey.Alert_Ever_Escalated__c = false;
                            thisSurvey.Alert_Ever_in_Overdue__c = false;
                            thisSurvey.Log_Notes__c = null;
                            listSurveyToUpsert.add(thisSurvey);
                        }else if(thisSurvey.Alert_Status__c != null && thisSurvey.Alert_Status__c.EqualsIgnoreCase('Closed') && 
                           Date.valueOf(thisSurvey.Alert_Closed_Date_Time__c) == Date.valueOf(YESTERDAY_DATE+' 00:00:00')){
                            if( mapSurveyLog.get(thisSurvey.Survey_ID__c) != null){
                                Survey__c objSurvey = new Survey__c();
                                objSurvey.Id = mapSurveyLog.get(thisSurvey.Survey_ID__c).Id;
                                objSurvey.Alert_Closed_By__c = thisSurvey.Alert_Closed_By__c != null ? thisSurvey.Alert_Closed_By__c : mapSurveyLog.get(thisSurvey.Survey_ID__c).Alert_Closed_By__c;
                                objSurvey.Alert_Closed_Date_Time__c = thisSurvey.Alert_Closed_Date_Time__c != null ? thisSurvey.Alert_Closed_Date_Time__c : mapSurveyLog.get(thisSurvey.Survey_ID__c).Alert_Closed_Date_Time__c;
                                objSurvey.Alert_Status__c = thisSurvey.Alert_Status__c != null ? thisSurvey.Alert_Status__c : mapSurveyLog.get(thisSurvey.Survey_ID__c).Alert_Status__c;
                                objSurvey.Alert_Type__c = thisSurvey.Alert_Type__c != null ? thisSurvey.Alert_Type__c : mapSurveyLog.get(thisSurvey.Survey_ID__c).Alert_Type__c;
                                objSurvey.Alert_Ever_Escalated__c = thisSurvey.Alert_Ever_Escalated__c != null ? thisSurvey.Alert_Ever_Escalated__c : mapSurveyLog.get(thisSurvey.Survey_ID__c).Alert_Ever_Escalated__c;
                                objSurvey.Alert_Ever_in_Overdue__c = thisSurvey.Alert_Ever_in_Overdue__c != null ? thisSurvey.Alert_Ever_in_Overdue__c : mapSurveyLog.get(thisSurvey.Survey_ID__c).Alert_Ever_in_Overdue__c;
                                objSurvey.Log_Notes__c = thisSurvey.Log_Notes__c != null ? thisSurvey.Log_Notes__c : mapSurveyLog.get(thisSurvey.Survey_ID__c).Log_Notes__c;
                                
                            	system.debug('#### listSurveyToUpsert - '+objSurvey.Alert_Closed_By__c); 
                                listSurveyToUpsert.add(objSurvey);
                            	
                            }
                        }
        			}
        			
                    if(listSurveyToUpsert != null){
                        //srList = Database.insert(listSurveyToInsert, false);
                      	srList = Database.upsert(listSurveyToUpsert, false);
                    }
        		} catch(Exception e) {System.debug('############# EXCEPTION TIME #### '+ e.getMessage());} 
        	}
        	
        	system.debug('#### srList - '+srList);
        	
        	// Calling Send Email method of Helper Class, to notify in case of any failure of batch processing.
	    	//MedalliaSurveyHelper.sendEmailForErrors(srList,'Medallia Server Records');
        	
		} catch(Exception ex){
			system.debug('#### Error on line - '+ex.getLineNumber());
	    	system.debug('#### Error message - '+ex.getMessage());
		}	
	}
	
	/******************************************************************************
	* @Description : Start method to execute the query for batch.                 *
	* @Params      : Database.BatchableContext                                    *
	* @Return      : Database.querylocator                                        * 
	******************************************************************************/
	global void finish(Database.BatchableContext BC){}
	
	/*===================================== Utility Methods =====================================*/ 
    /**********************************************************************************************
    * @Description : Utility method to convert values to integer.                                 *
    * @Params      : String                                                                       *
    * @Return      : Integer                                                                      * 
    **********************************************************************************************/
    private Integer convertToInteger(String str) { 
        try {
            if(str != null && Pattern.matches('^[0-9]{1,10}$', str)) {
                return Integer.valueOf(str);
            }
        } catch(Exception e) {
            system.debug('#### Error on Integer Conversion- '+e.getLineNumber());
            system.debug('#### Error message on Integer Conversion - '+e.getMessage());
        }
        return null;
    }
    
    /**********************************************************************************************
    * @Description : Utility method to validate String                                            *
    * @Params      : String                                                                       *
    * @Return      : String                                                                       * 
    **********************************************************************************************/
    private String validateString(String str) {
        return (!String.isBlank(str) && !String.isBlank(str.trim()) ? str.trim() : null);
    }
    
    /**********************************************************************************************
    * @Description : Utility method to validate String                                            *
    * @Params      : String                                                                       *
    * @Return      : Boolean                                                                      * 
    **********************************************************************************************/
    private Boolean validateBoolean(String str) {
    	return((str != null && str.equalsIgnoreCase('Yes')) ? true : false);
        //return (!String.isBlank(str) && !String.isBlank(str.trim()) ? Boolean.valueOf(str.trim()) : false);
    }
    
    /**********************************************************************************************
    * @Description : Utility method to fetch the surveyIds of the incoming surveys,               *
    *                from medallia server.                                                        *
    * @Params      : List<List<String>>                                                           *
    * @Return      : List<Id>                                                                     * 
    **********************************************************************************************/
    private List<Id> fetchSurveyIds(List<List<String>> surveyRecordsFromMedallia,List<String> listResponseColumns){
        
        List<Id> surveyIds = new List<Id>();
        
        for(Integer counter = 0; counter < surveyRecordsFromMedallia.size(); counter++){
            for(Integer innerCounter = 0; innerCounter < listResponseColumns.size(); innerCounter++ ){
                if(listResponseColumns[innerCounter].equalsIgnoreCase('surveyid')){
                    surveyIds.add(validateString(surveyRecordsFromMedallia[counter][innerCounter]));
                }
            }
        }
        return surveyIds;
    }
    
    /**********************************************************************************************
    * @Description : Utility method to create Map of survey records.                              *
    * @Params      : List<Id>                                                                     *
    * @Return      : Map<String, Survey__c>                                                       * 
    **********************************************************************************************/
    private Map<String, Survey__c> getSurveyMap(List<Id> surveyIds){ 
        
        Map<String, Survey__c> mapSurveyLog = new Map<String, Survey__c>();
         
        for(Survey__c thisSurvey : [SELECT Id, s.Survey_ID__c, s.Log_Notes__c, s.Alert_Type__c, s.Alert_Status__c, s.Alert_Ever_in_Overdue__c, 
                                           s.Alert_Ever_Escalated__c, s.Alert_Closed_Date_Time__c, s.Alert_Closed_By__c 
                                    FROM Survey__c s WHERE Survey_ID__c IN: surveyIds]){
                                       
            mapSurveyLog.put(thisSurvey.Survey_ID__c, thisSurvey);              
        }
        return mapSurveyLog;    
    }
}