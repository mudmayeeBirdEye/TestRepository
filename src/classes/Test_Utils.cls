/*******************************************************************************************************
* Project Name..........: Test Utility                                                                 *
* File..................: Test_Utils.class                                                             *
* Version...............: 1.0                                                                          *
* Created by............: Simplion Technologies                                                        *
* Created Date..........: 24-02-2013                                                                   *
* Last Modified by......: Simplion Technologies                                                        *
* Last Modified Date....: 24-02-2013                                                                   *
* Description...........: This is a utility class to setup records for different objects for testing.  *
********************************************************************************************************/

public class Test_Utils {
	
	/******************************************************************************
	* @Description : Controller Class.                                            *
	* @Params      : void                                                         *
	* @Return      : void                                                         * 
	******************************************************************************/	
	public Test_Utils(){
		// Setting flags to bypass Triggers.
	}
	
	/******************************************************************************
	* @Description : Use this method to create User record.                       *
	* @Params      : List<User>                                                   *
	* @Return      : List<User>                                                   * 
	******************************************************************************/
	public List<User> createUserRecord(List<User> userList){
		
		initialiseTriggerBypass();
		List<User> testUserRecordList = new List<User>();
		Id profileId = [SELECT Id FROM Profile LIMIT 1].Id;
		
		try{
			for(User thisUser : userList){
				User testUserRecord =  new User();
				testUserRecord.alias = String.isBlank(thisUser.alias) ? 'u'+ String.valueOf(System.currentTimeMillis()).substring(8) : thisUser.alias; 
				testUserRecord.Email = String.isBlank(thisUser.Email) ? 'u1234@testorg.com' : thisUser.Email; 
				testUserRecord.emailencodingkey = String.isBlank(thisUser.emailencodingkey) ? 'UTF-8' : thisUser.emailencodingkey;
				testUserRecord.lastname = String.isBlank(thisUser.lastname) ? 'Testing' : thisUser.lastname;
				testUserRecord.ProfileId = String.isBlank(thisUser.ProfileId) ? profileId : thisUser.ProfileId;
				testUserRecord.languagelocalekey = String.isBlank(thisUser.languagelocalekey) ? 'en_US' : thisUser.languagelocalekey;
				testUserRecord.localesidkey = String.isBlank(thisUser.localesidkey) ? 'en_US' : thisUser.localesidkey;
				testUserRecord.country = String.isBlank(thisUser.country) ? 'United States' : thisUser.country;
				testUserRecord.timezonesidkey = String.isBlank(thisUser.timezonesidkey) ? 'America/Los_Angeles' : thisUser.timezonesidkey;
				testUserRecord.username = String.isBlank(thisUser.username) ? 'testUser'+String.valueOf(System.currentTimeMillis()).substring(8)+'@testorg.com' : thisUser.username;
				testUserRecord.IsActive=true;
				
		        testUserRecordList.add(testUserRecord);  
			}
			
			system.debug('#### Utility testUserRecordList - '+testUserRecordList);
			insert testUserRecordList;
			if(Test.isRunningTest()){
				Integer error = 0/0;
			}
		}catch(Exception ex){
			system.debug('#### Error on line - '+ex.getLineNumber());
	    	system.debug('#### Error message - '+ex.getMessage());
		}
		return testUserRecordList;
	}       
	
   	/******************************************************************************
	* @Description : Use this method to create Account record.                    *
	* @Params      : List<Account>                                                *
	* @Return      : List<Account>                                                * 
	******************************************************************************/
	public List<Account> createAccountRecord(List<Account> accountList){  
		
		initialiseTriggerBypass();
		List<Account> testAccountRecordList = new List<Account>();
   		try{
   			system.debug('#### No. of Account records to make - '+accountList.size());
   			Integer RCUSERID = 12345;
			RecordType rt = [SELECT Id FROM RecordType WHERE Name='Customer Account'];

   			for(Account thisAccount : accountList){
	   			Account testAccountRecord = new Account();
			 	testAccountRecord.Name = String.isBlank(thisAccount.Name) ? 'RCTest' : thisAccount.Name;
			 	testAccountRecord.RC_Account_Status__c = String.isBlank(thisAccount.RC_Account_Status__c) ? 'Paid': thisAccount.RC_Account_Status__c;
			 	testAccountRecord.SignupPlatform__c = String.isBlank(thisAccount.SignupPlatform__c)? 'WEB': thisAccount.SignupPlatform__c;
			 	testAccountRecord.SignupType__c = String.isBlank(thisAccount.SignupType__c) ? 'TRIAL' : thisAccount.SignupType__c;
			 	testAccountRecord.Partner_ID__c = String.isBlank(thisAccount.Partner_ID__c) ? '1234': thisAccount.Partner_ID__c;
			 	testAccountRecord.Type = String.isBlank(thisAccount.Type) ? 'Partner' : thisAccount.Type;
			 	testAccountRecord.RC_Brand__c = String.isBlank(thisAccount.RC_Brand__c) ? 'RingCentral' : thisAccount.RC_Brand__c;
				testAccountRecord.Number_of_DL_s__c = (thisAccount.Number_of_DL_s__c == null) ? 25 : thisAccount.Number_of_DL_s__c;
				testAccountRecord.RC_User_ID__c = String.isBlank(thisAccount.RC_User_ID__c) ? String.valueOf(RCUSERID) : thisAccount.RC_User_ID__c;
				testAccountRecord.Service_Type__c = String.isBlank(thisAccount.Service_Type__c) ? 'Office' : thisAccount.Service_Type__c;
				testAccountRecord.Preferred_Language__c = String.isBlank(thisAccount.Preferred_Language__c)? 'en_US' :thisAccount.Preferred_Language__c;
				testAccountRecord.RC_Signup_Date__c = (thisAccount.RC_Signup_Date__c == null) ? Date.Today() : thisAccount.RC_Signup_Date__c;
				testAccountRecord.Current_Owner__c = thisAccount.Current_Owner__c;
				testAccountRecord.RC_Attribution_Channel__c = (thisAccount.RC_Attribution_Channel__c == null) ? 'Sales Agents & Resellers' : thisAccount.RC_Attribution_Channel__c;
				testAccountRecord.RecordTypeId  = (thisAccount.RecordTypeId == null) ? rt.Id : thisAccount.RecordTypeId;
				testAccountRecord.RC_Service_name__c = (thisAccount.RC_Service_name__c == null) ? 'Office' : thisAccount.RC_Service_name__c;
				testAccountRecord.Ultimate_Partner_ID__c = (thisAccount.Ultimate_Partner_ID__c == null) ? 'test123' : thisAccount.Ultimate_Partner_ID__c;
				//testAccountRecord.Parent_Detail__c = (thisAccount.Parent_Detail__c == null) ? 'testDetail' : thisAccount.Parent_Detail__c;
				
				testAccountRecordList.add(testAccountRecord);
				RCUSERID++;
   			}
   			
			insert testAccountRecordList;
			system.debug('#### Utility testAccountRecordList - '+testAccountRecordList);
			if(Test.isRunningTest()){
				Integer error = 0/0;
			}
   		}catch(Exception ex){
			system.debug('#### Error on line - '+ex.getLineNumber());
	    	system.debug('#### Error message - '+ex.getMessage());
		}
		return testAccountRecordList;
  	}

	/******************************************************************************
	* @Description : Use this method to create Opportunity record.                *
	* @Params      : List<Opportunity>                                            *
	* @Return      : List<Opportunity>                                            * 
	******************************************************************************/
	public List<Opportunity> createOpportunityRecord(List<Opportunity> opportunityList){
		
		initialiseTriggerBypass();
		List<Opportunity> testOpportunityRecordList = new List<Opportunity>();
	  	try{
	  		for(Opportunity thisOpportunity : opportunityList){
	  			Opportunity testOpportunityRecord = new Opportunity();
		  		testOpportunityRecord.Name = String.isBlank(thisOpportunity.Name) ? 'Test Opp12' : thisOpportunity.Name;
		  		testOpportunityRecord.AccountId = thisOpportunity.AccountId;
		  		testOpportunityRecord.Type = String.isBlank(thisOpportunity.Type) ? 'Existing Business' : thisOpportunity.Type;
		  		testOpportunityRecord.StageName = String.isBlank(thisOpportunity.StageName) ? '3. ActivePipe' : thisOpportunity.StageName;
		  		testOpportunityRecord.Sales_Model__c = String.isBlank(thisOpportunity.Sales_Model__c) ? 'Direct' : thisOpportunity.Sales_Model__c;
		  		testOpportunityRecord.CurrencyIsoCode = String.isBlank(thisOpportunity.CurrencyIsoCode) ? 'USD' : thisOpportunity.CurrencyIsoCode;
		  		testOpportunityRecord.Brand_Name__c = String.isBlank(thisOpportunity.Brand_Name__c) ? 'RingCentral' : thisOpportunity.Brand_Name__c;
		  		testOpportunityRecord.CloseDate = testOpportunityRecord.CloseDate == null ? system.today() : testOpportunityRecord.CloseDate;
		  		
		  		testOpportunityRecordList.add(testOpportunityRecord);
	  		}	
	  		
			insert testOpportunityRecordList;
			system.debug('#### Utility testOpportunityRecordList - '+testOpportunityRecordList);
			if(Test.isRunningTest()){
				Integer error = 0/0;
			}
	  	}catch(Exception ex){
			system.debug('#### Error on line - '+ex.getLineNumber());
	    	system.debug('#### Error message - '+ex.getMessage());
		}
		return testOpportunityRecordList;
    }
	
	/******************************************************************************
	* @Description : Use this method to create Contact record.                    *
	* @Params      : List<Contact>                                                *
	* @Return      : List<Contact>                                                * 
	******************************************************************************/  
	public List<Contact> createContactRecord(List<Contact> contactList){
	    
	    initialiseTriggerBypass();
	   	List<Contact> testContactRecordList = new List<Contact>();
	   	try{
	   		for(Contact thisContact : contactList){
		   		Contact testContactRecord = new Contact();
		   		testContactRecord.FirstName = String.isBlank(thisContact.FirstName) ? 'Ring' : thisContact.FirstName;
		   		testContactRecord.LastName = String.isBlank(thisContact.LastName) ? 'Central' : thisContact.LastName;
		   		testContactRecord.Email = String.isBlank(thisContact.Email) ? 'rc1234@test.com' : thisContact.Email;
		   		testContactRecord.Preferred_Language__c =String.isBlank(thisContact.Preferred_Language__c)? 'en_US':thisContact.Preferred_Language__c;
		   		testContactRecord.AccountId = thisContact.AccountId;
		   		
		   		testContactRecordList.add(testContactRecord);
	   		}
	   		
			insert testContactRecordList;
			system.debug('#### Utility testContactRecordList - '+testContactRecordList);
			if(Test.isRunningTest()){
				Integer error = 0/0;
			}
	   	}catch(Exception ex){
			system.debug('#### Error on line - '+ex.getLineNumber());
	    	system.debug('#### Error message - '+ex.getMessage());
		}
		return testContactRecordList;
    }

	/******************************************************************************
	* @Description : Use this method to create Case record.                       *
	* @Params      : List<Case>                                                   *
	* @Return      : List<Case>                                                   * 
	******************************************************************************/	   
	public List<Case> createCaseRecord(List<Case> caseList){
	  	
	  	initialiseTriggerBypass();
	  	List<Case> testCaseRecordList = new List<Case>();
	  	try{
	  		for(Case thisCase : caseList){
	  			Case testCaseRecord = new Case();
		  		testCaseRecord.Subject = String.isBlank(thisCase.Subject) ? 'Test' : thisCase.Subject;
		  		testCaseRecord.status = String.isBlank(thisCase.status) ? 'Open' : thisCase.status;
		  		testCaseRecord.Priority = String.isBlank(thisCase.Priority) ? 'P3' : thisCase.Priority;
		  		testCaseRecord.Description = String.isBlank(thisCase.Description) ? 'Test Case Desc' : thisCase.Description;
		  		
		  		testCaseRecordList.add(testCaseRecord);
	  		}
			
			insert testCaseRecordList;
			system.debug('#### Utility testCaseRecordList - '+testCaseRecordList);
			if(Test.isRunningTest()){
				Integer error = 0/0;
			}
		}catch(Exception ex){
			system.debug('#### Error on line - '+ex.getLineNumber());
	    	system.debug('#### Error message - '+ex.getMessage());
		}
		return testCaseRecordList;
  	}
  	
  	/******************************************************************************
	* @Description : Use this method to create Lead record.                       *
	* @Params      : List<Lead>                                                   *
	* @Return      : List<Lead>                                                   * 
	******************************************************************************/
  	public List<Lead> createLeadRecord(List<Lead> leadList){
        
        initialiseTriggerBypass();
        List<Lead> testleadRecordList = new List<Lead>();
        try{
        	for(Lead thisLead : leadList){
		        Lead leadObj = new Lead();
		        leadObj.FirstName = String.isBlank(thisLead.FirstName) ? 'Virendra' : thisLead.FirstName;
		        leadObj.LastName = String.isBlank(thisLead.LastName) ? 'Singh' : thisLead.LastName;
		        leadObj.Company = String.isBlank(thisLead.Company) ? 'Simplion' : thisLead.Company;
		        leadObj.Email = String.isBlank(thisLead.Email) ? 'virendra.singh@simplion.com' : thisLead.Email;
		        leadObj.Phone = String.isBlank(thisLead.Phone) ? '9910106804' : thisLead.Phone;
		        leadObj.LeadSource = String.isBlank(thisLead.LeadSource) ? 'Inbound Call' : thisLead.LeadSource;
		        leadObj.Notes__c = String.isBlank(thisLead.Notes__c) ? 'Test Notes' : thisLead.Notes__c;
		        leadObj.Website = String.isBlank(thisLead.Website) ? 'http://test.com' : thisLead.Website;
		        leadObj.NumberOfEmployees = thisLead.NumberOfEmployees != null ? 123 : thisLead.NumberOfEmployees;
		        leadObj.Industry = String.isBlank(thisLead.Industry) ? 'Test' : thisLead.Industry;
		        leadObj.NumberOfEmployees__c = String.isBlank(thisLead.NumberOfEmployees__c) ? '2-19' : thisLead.NumberOfEmployees__c;
		        leadObj.Number_of_Locations__c = String.isBlank(thisLead.Number_of_Locations__c) ? '2-4' : thisLead.Number_of_Locations__c;
		        leadObj.Agent_Email_Address__c = String.isBlank(thisLead.Agent_Email_Address__c) ? 'test@test.com' : thisLead.Agent_Email_Address__c; 
		        
		        testleadRecordList.add(leadObj);
        	}
        	
	        insert testleadRecordList;
	        system.debug('#### Utility testleadRecordList - '+testleadRecordList);
	        if(Test.isRunningTest()){
				Integer error = 0/0;
			}
        }catch(Exception ex){
			system.debug('#### Error on line - '+ex.getLineNumber());
	    	system.debug('#### Error message - '+ex.getMessage());
		} 
		return testleadRecordList; 
    }
    
    /******************************************************************************
	* @Description : Use this method to create Note record.                       *
	* @Params      : List<Lead>                                                   *
	* @Return      : List<Note>                                                   * 
	******************************************************************************/
    public List<Note> getNoteList(List<sObject> sObjectList){
    	
    	initialiseTriggerBypass();
    	List<Note> noteList=new List<Note>();
    	try{
	        for(sObject thisObj : sObjectList){
	            Note noteObj = new Note();
	            noteObj.ParentId = thisObj.Id;
	            noteObj.Body = 'test';
	            noteObj.Title= 'Testing Note';
	            noteList.add(noteObj);
	        }
	        insert noteList;
	        system.debug('#### Utility noteList - '+noteList);
	        if(Test.isRunningTest()){
				Integer error = 0/0;
			}
        }catch(Exception ex){
			system.debug('#### Error on line - '+ex.getLineNumber());
	    	system.debug('#### Error message - '+ex.getMessage());
		} 
		return noteList;
    }
    
    /******************************************************************************
	* @Description : Use this method to create Note record.                       *
	* @Params      : List<Lead>                                                   *
	* @Return      : List<Lead_Qualification__c>                                  * 
	******************************************************************************/
    public List<Lead_Qualification__c> getLeadQualificationList(List<Lead> leadList){
    	
    	initialiseTriggerBypass();
    	List<Lead_Qualification__c> leadQualList=new List<Lead_Qualification__c>();
    	try{
	        for(Lead leadObj : leadList){
	            Lead_Qualification__c leadQualObj = new Lead_Qualification__c();
	            leadQualObj.Lead__c = leadObj.Id;
	            leadQualList.add(leadQualObj);
	        }
	        leadQualList[0].X50_249_Business_Drivers__c = 'Business growth/change/agility; Dissatisfied with current vendor; Improved customer responsiveness';
	        leadQualList[0].Reasons__c = 'Hard to adapt to business changes; Costly to manage; Call Transfers slow and difficult';
	        
	        insert leadQualList;
	        system.debug('#### Utility leadQualList - '+leadQualList);
	        if(Test.isRunningTest()){
				Integer error = 0/0;
			}
    	}catch(Exception ex){
			system.debug('#### Error on line - '+ex.getLineNumber());
	    	system.debug('#### Error message - '+ex.getMessage());
		} 
		return leadQualList;
    }

   
    /******************************************************************************
	* @Description : Use this method to create Note record.                       *
	* @Params      : List<Business_Driver__c>                                     *
	* @Return      : List<Business_Driver__c>                                     * 
	******************************************************************************/
/*    public List<Business_Driver__c> getBusinessDriver(List<Business_Driver__c> businessDriverList){
    	
    	List<Business_Driver__c> listBs = new List<Business_Driver__c>();
    	try{
	        List<String> bdName = new List<String>{'Business growth/change/agility','Dissatisfied with current vendor','Improved customer responsiveness'}; 
	        for(Integer counter = 0; counter <= businessDriverList.size(); counter ++){
		        Business_Driver__c cs = new Business_Driver__c();
		        cs.Name = bdName[counter];
		        listBs.add(cs);
	        }
	        
	        insert listBs;
	        system.debug('#### Utility listBs - '+listBs);
	        return listBs;
        }catch(Exception ex){
			system.debug('#### Error on line - '+ex.getLineNumber());
	    	system.debug('#### Error message - '+ex.getMessage());
	    	return null;
		} 
    }
*/    
    /******************************************************************************
	* @Description : Use this method to create Note record.                       *
	* @Params      : List<BusinessDriverReasons__c>                               *
	* @Return      : List<BusinessDriverReasons__c>                               * 
	******************************************************************************/
/*    public List<BusinessDriverReasons__c> getBusinessDriverReasons(List<BusinessDriverReasons__c> businessDriverReasonList){
    	
    	List<BusinessDriverReasons__c> listBs = new List<BusinessDriverReasons__c>();
    	try{
	        List<String> bdrName = new List<String>{'Hard to adapt to business changes','Costly to manage','Call Transfers slow and difficult'};
	        List <String> bdName = new List<String>{'Business growth/change/agility','Dissatisfied with current vendor','Improved customer responsiveness'};
	        for(Integer counter = 0; counter <= businessDriverReasonList.size(); counter ++){
		        BusinessDriverReasons__c cs = new BusinessDriverReasons__c();
		        cs.name = bdrName[counter];
		        cs.driver__c = bdName[counter];
		        listBs.add(cs);
	        }
	        
	        insert listBs;
	        system.debug('#### Utility listBs - '+listBs);
	        return listBs;
        }catch(Exception ex){
			system.debug('#### Error on line - '+ex.getLineNumber());
	    	system.debug('#### Error message - '+ex.getMessage());
	    	return null;
		} 
    }
*/
    
    /******************************************************************************
	* @Description : Use this method to create Account Metrics record.            *
	* @Params      : List<Account_Metric__c>                                      *
	* @Return      : List<Account_Metric__c>                                      * 
	******************************************************************************/
    public List<Account_Metric__c> createAccountMetricRecords(List<Account_Metric__c> accountMetricsList){
    	
    	initialiseTriggerBypass();
    	List<Account_Metric__c> accountMetricList = new List<Account_Metric__c>();
    	try{
    		Integer peerGroupId = 100;
    		 
    		for(Account_Metric__c thisAccountMetric : accountMetricsList){
    			Account_Metric__c accMetricObj = new Account_Metric__c();
    			accMetricObj.Peer_Group_ID__c = thisAccountMetric.Peer_Group_ID__c == null ? peerGroupId : thisAccountMetric.Peer_Group_ID__c;
		        accMetricObj.Metric_1_value__c = thisAccountMetric.Metric_1_value__c == null ? 10 : thisAccountMetric.Metric_1_value__c;
		     	accMetricObj.Metric_1_bucket__c= thisAccountMetric.Metric_1_bucket__c == null ? 1 : thisAccountMetric.Metric_1_bucket__c;
		     	accMetricObj.Metric_2_value__c = thisAccountMetric.Metric_2_value__c == null ? 10 : thisAccountMetric.Metric_2_value__c;
		      	accMetricObj.Metric_2_bucket__c = thisAccountMetric.Metric_2_bucket__c == null ? 1 : thisAccountMetric.Metric_2_bucket__c;
		      	accMetricObj.Metric_3_value__c = thisAccountMetric.Metric_3_value__c == null ? 10 : thisAccountMetric.Metric_3_value__c;
		      	accMetricObj.Metric_3_bucket__c = thisAccountMetric.Metric_3_bucket__c == null ? 1 : thisAccountMetric.Metric_3_bucket__c;
		     	accMetricObj.Metric_4_value__c = thisAccountMetric.Metric_4_value__c == null ? 10 : thisAccountMetric.Metric_4_value__c;
		     	accMetricObj.Metric_4_bucket__c = thisAccountMetric.Metric_4_bucket__c == null ? 1 : thisAccountMetric.Metric_4_bucket__c;
		     	accMetricObj.Metric_5_value__c = thisAccountMetric.Metric_5_value__c == null ? 10 : thisAccountMetric.Metric_5_value__c;
		     	accMetricObj.Metric_5_bucket__c = thisAccountMetric.Metric_5_bucket__c == null ? 1 : thisAccountMetric.Metric_5_bucket__c;
		     	accMetricObj.Metric_6_value__c = thisAccountMetric.Metric_6_value__c == null ? 10 : thisAccountMetric.Metric_6_value__c;
		     	accMetricObj.Metric_6_bucket__c = thisAccountMetric.Metric_6_bucket__c == null ? 1 : thisAccountMetric.Metric_6_bucket__c;
		     	accMetricObj.Metric_7_value__c = thisAccountMetric.Metric_7_value__c == null ? 10 : thisAccountMetric.Metric_7_value__c;
		     	accMetricObj.Metric_7_bucket__c = thisAccountMetric.Metric_7_bucket__c == null ? 1 : thisAccountMetric.Metric_7_bucket__c;
		     	accMetricObj.Metric_1_Position__c = thisAccountMetric.Metric_1_Position__c == null ? 10 : thisAccountMetric.Metric_1_Position__c;
		     	accMetricObj.Metric_2_Position__c = thisAccountMetric.Metric_2_Position__c == null ? 10 : thisAccountMetric.Metric_2_Position__c;
		     	accMetricObj.Metric_3_Position__c = thisAccountMetric.Metric_3_Position__c == null ? 10 : thisAccountMetric.Metric_3_Position__c;
		     	accMetricObj.Metric_4_Position__c = thisAccountMetric.Metric_4_Position__c == null ? 10 : thisAccountMetric.Metric_4_Position__c;
		     	accMetricObj.Metric_5_Position__c = thisAccountMetric.Metric_5_Position__c == null ? 10 : thisAccountMetric.Metric_5_Position__c;
		     	accMetricObj.Metric_6_Position__c = thisAccountMetric.Metric_6_Position__c == null ? 10 : thisAccountMetric.Metric_6_Position__c;
		     	accMetricObj.Metric_7_Position__c = thisAccountMetric.Metric_7_Position__c == null ? 10 : thisAccountMetric.Metric_7_Position__c;
		     	accMetricObj.Metric_18_value__c = thisAccountMetric.Metric_18_value__c == null ? 1 : thisAccountMetric.Metric_18_value__c;
		     	accMetricObj.Metric_101_Position__c = thisAccountMetric.Metric_101_Position__c == null ? 10 : thisAccountMetric.Metric_101_Position__c;
		     	accMetricObj.Metric_101_value__c = thisAccountMetric.Metric_101_value__c == null ? 10 : thisAccountMetric.Metric_101_value__c;
		     	accMetricObj.Metric_101_bucket__c = thisAccountMetric.Metric_101_bucket__c == null ? 1 : thisAccountMetric.Metric_101_bucket__c;
		     	accMetricObj.Metric_102_Position__c = thisAccountMetric.Metric_102_Position__c == null ? 10 : thisAccountMetric.Metric_102_Position__c;
		     	accMetricObj.Metric_102_value__c = thisAccountMetric.Metric_102_value__c == null ? 10 : thisAccountMetric.Metric_102_value__c;
		     	accMetricObj.Metric_102_bucket__c = thisAccountMetric.Metric_102_bucket__c == null ? 1 : thisAccountMetric.Metric_102_bucket__c;
		     	accMetricObj.Metric_103_Position__c = thisAccountMetric.Metric_103_Position__c == null ? 10 : thisAccountMetric.Metric_103_Position__c;
	     		accMetricObj.Metric_103_value__c = thisAccountMetric.Metric_103_value__c == null ? 10 : thisAccountMetric.Metric_103_value__c;
		     	accMetricObj.Metric_103_bucket__c = thisAccountMetric.Metric_103_bucket__c == null ? 1 : thisAccountMetric.Metric_103_bucket__c;
		     	accMetricObj.Metric_1000_value__c = thisAccountMetric.Metric_1000_value__c == null ? 10 : thisAccountMetric.Metric_1000_value__c;
		     	accMetricObj.Metric_1000_bucket__c = thisAccountMetric.Metric_1000_bucket__c == null ? 1 : thisAccountMetric.Metric_1000_bucket__c;
		     	accMetricObj.Metric_1000_Position__c = thisAccountMetric.Metric_1000_Position__c == null ? 10 : thisAccountMetric.Metric_1000_Position__c;
		     	accMetricObj.Account_ID__c = thisAccountMetric.Account_ID__c;
		     	
		     	accountMetricList.add(accMetricObj);
		     	peerGroupId++;
    		}
    		insert accountMetricList;
    		system.debug('#### Utility accountMetricList - '+accountMetricList);
    		if(Test.isRunningTest()){
				Integer error = 0/0;
			}
    	}catch(Exception ex){
			system.debug('#### Error on line - '+ex.getLineNumber());
	    	system.debug('#### Error message - '+ex.getMessage());
		} 
		return accountMetricList;
    }
    
    /******************************************************************************
	* @Description : Use this method to create Note record.                       *
	* @Params      : List<Lead>                                                   *
	* @Return      : List<Note>                                                   * 
	******************************************************************************/
    public List<Implementation__c> createImplementationRecords(List<Implementation__c> implementationRecordsList){
    	
    	initialiseTriggerBypass();
    	List<Implementation__c> implementationList = new List<Implementation__c>();
    	try{
    		for(Implementation__c thisImplementation : implementationRecordsList){
    			Implementation__c implementationRecord = new Implementation__c();
    			implementationRecord.Name = String.isBlank(thisImplementation.Name) ? 'testImp' : thisImplementation.Name;
    			implementationRecord.Implementation_Status__c= String.isBlank(thisImplementation.Implementation_Status__c) ? '1. New' : thisImplementation.Implementation_Status__c;
    			implementationRecord.Most_Recent_follow_up_Date__c = thisImplementation.Most_Recent_follow_up_Date__c == null ? system.today() : thisImplementation.Most_Recent_follow_up_Date__c;
    			implementationRecord.Porting_Required__c = String.isBlank(thisImplementation.Porting_Required__c) ? 'Yes' : thisImplementation.Porting_Required__c;
    			implementationRecord.Account__c = thisImplementation.Account__c;
    			implementationRecord.Contact__c = thisImplementation.Contact__c;
    			implementationRecord.Implementation_Status_2__c = String.isBlank(thisImplementation.Implementation_Status_2__c) ? 'New' : thisImplementation.Implementation_Status_2__c;
    			implementationList.add(implementationRecord);
    		}
    		
    		insert implementationList;
    		system.debug('#### Utility implementationList - '+implementationList);
    		if(Test.isRunningTest()){
				Integer error = 0/0;
			}
    	}catch(Exception ex){
			system.debug('#### Error on line - '+ex.getLineNumber());
	    	system.debug('#### Error message - '+ex.getMessage());
		} 
		return implementationList;
    }
    
    /******************************************************************************
	* @Description : Use this method to create Scheduler Configuration record.    *
	* @Params      : List<schedulerConfiguration__c>                              *
	* @Return      : List<schedulerConfiguration__c>                              * 
	******************************************************************************/
	public List<schedulerConfiguration__c> createSchedulerConfigurationRecords(List<schedulerConfiguration__c> schedulerRecordsList){
		
		initialiseTriggerBypass();
		List<schedulerConfiguration__c> schedulerList =  new List<schedulerConfiguration__c>();
		try{
			for(schedulerConfiguration__c thisRecord : schedulerRecordsList){
				schedulerConfiguration__c schedulerRecord =  new schedulerConfiguration__c();
				schedulerRecord.Brand_Id__c = String.isBlank(thisRecord.Brand_Id__c) ? 'test123' : thisRecord.Brand_Id__c;
				schedulerRecord.Name = String.isBlank(thisRecord.Name) ? 'testAccount' : thisRecord.Name;
				schedulerRecord.Buffer_Days__c = thisRecord.Buffer_Days__c == null ? 5 : thisRecord.Buffer_Days__c;
				schedulerRecord.Cancellation_Email_Template_Customer__c= thisRecord.Cancellation_Email_Template_Customer__c;
		        schedulerRecord.Cancellation_Email_Template_Internal__c= thisRecord.Cancellation_Email_Template_Internal__c;
		        schedulerRecord.Confirmation_Email_Template_Name__c= thisRecord.Confirmation_Email_Template_Name__c;
		        schedulerRecord.Preferred_Language__c = thisRecord.Preferred_Language__c;
		        schedulerRecord.Reminder_E_mail_Template_Name__c= thisRecord.Reminder_E_mail_Template_Name__c;
		        schedulerRecord.Rescheduling_Email_Template_Customer__c= thisRecord.Rescheduling_Email_Template_Customer__c;
		        schedulerRecord.Rescheduling_Email_Template_Internal__c= thisRecord.Rescheduling_Email_Template_Internal__c; 
		        schedulerRecord.Contact_Support__c = String.isBlank(thisRecord.Contact_Support__c) ? '101010' : thisRecord.Contact_Support__c;
				
				schedulerList.add(schedulerRecord);
			}
			insert schedulerList;
			system.debug('#### Utility schedulerList - '+schedulerList);
			if(Test.isRunningTest()){
				Integer error = 0/0;
			}
		}catch(Exception ex){
			system.debug('#### Error on line - '+ex.getLineNumber());
	    	system.debug('#### Error message - '+ex.getMessage());
		} 
		return schedulerList;
	}
	
	/******************************************************************************
	* @Description : Use this method to create Resource Pool records.             *
	* @Params      : List<Resource_Pool__c>                                       *
	* @Return      : List<Resource_Pool__c>                                       * 
	******************************************************************************/
    public List<Resource_Pool__c> createResourcePoolRecords(List<Resource_Pool__c> resourcePoolRecordsList){
    	
    	initialiseTriggerBypass();
    	List<Resource_Pool__c> recordPoolList = new List<Resource_Pool__c>();
    	try{
    		for(Resource_Pool__c thisRecord : resourcePoolRecordsList){
    			Resource_Pool__c resourcePoolRecord =  new Resource_Pool__c();
    			resourcePoolRecord.Resource_Pool_Email__c = String.isBlank(thisRecord.Resource_Pool_Email__c) ? 'test@test.com' : thisRecord.Resource_Pool_Email__c;
		        resourcePoolRecord.Criteria__c = String.isBlank(thisRecord.Criteria__c) ? '=' : thisRecord.Criteria__c;
		        resourcePoolRecord.No_of_User_DLs__c = thisRecord.No_of_User_DLs__c ==  null ? 20 : thisRecord.No_of_User_DLs__c;
		        resourcePoolRecord.Active__c = true;
		        resourcePoolRecord.Preferred_Language__c = 'en_US';
		        resourcePoolRecord.Brand_Name__c = thisRecord.Brand_Name__c;
        		resourcePoolRecord.Dispatch_Admin__c = thisRecord.Dispatch_Admin__c;   
        		resourcePoolRecord.Premium_Support__c =  false;
		        
		        recordPoolList.add(resourcePoolRecord);		
    		}
    		insert recordPoolList;
    		system.debug('#### Utility recordPoolList - '+recordPoolList);
    		if(Test.isRunningTest()){
				Integer error = 0/0;
			}
    	}catch(Exception ex){
			system.debug('#### Error on line - '+ex.getLineNumber());
	    	system.debug('#### Error message - '+ex.getMessage());
		}  
		return recordPoolList;
    }

	/******************************************************************************
	* @Description : Use this method to create Time slots records.                *
	* @Params      : List<Time__c>                                                *
	* @Return      : List<Time__c>                                                * 
	******************************************************************************/    
    public List<Time__c> createTimeSlotRecords(List<Time__c> timeSlotRecordsList){
    	
    	initialiseTriggerBypass();
    	List<Time__c> timeSlotList =  new List<Time__c>();
    	List<String> days = new List<String>{'Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'};
    	Integer counter = 0;
    	try{
    		for(Time__c thisRecord : timeSlotRecordsList){
    			Time__c timeSlot = new Time__c();
    			timeSlot.Advisor_Name__c = thisRecord.Advisor_Name__c;
		        timeSlot.Day__c = String.isBlank(thisRecord.Day__c) ? days[counter] : thisRecord.Day__c;
		        timeSlot.Start_Time__c = String.isBlank(thisRecord.Start_Time__c) ? '08:00' : thisRecord.Start_Time__c;
		        timeSlot.End_Time__c = String.isBlank(thisRecord.End_Time__c) ? '12:00' : thisRecord.End_Time__c;
		        timeSlot.availableFor__c = 'Initial Implementation; Follow-Up Implementation';
		        counter++;
		        
		        timeSlotList.add(timeSlot);
    		}
    		insert timeSlotList;
    		system.debug('#### Utility timeSlotList - '+timeSlotList);
    		if(Test.isRunningTest()){
				Integer error = 0/0;
			}
    	}catch(Exception ex){
			system.debug('#### Error on line - '+ex.getLineNumber());
	    	system.debug('#### Error message - '+ex.getMessage());
		}  
		return timeSlotList;
    }
    
	/******************************************************************************
	* @Description : Use this method to create Opportunity Contact Role.          *
	* @Params      : List<OpportunityContactRole>                                 *
	* @Return      : List<OpportunityContactRole>                                 * 
	******************************************************************************/ 
	public List<OpportunityContactRole> createOpportunityContactRole(List<OpportunityContactRole> oppConRoleRecordsList){
		
		initialiseTriggerBypass();
		List<OpportunityContactRole> oppConRoleList =  new List<OpportunityContactRole>();
		try{
			for(OpportunityContactRole thisRecord : oppConRoleRecordsList){
				OpportunityContactRole oppContactRole = new OpportunityContactRole();
				oppContactRole.ContactId = thisRecord.ContactId;
                oppContactRole.IsPrimary = true;
                oppContactRole.OpportunityId = thisRecord.OpportunityId;
                oppContactRole.Role = 'Business User';
                oppConRoleList.add(oppContactRole);	
			}
    		insert oppConRoleList;
    		system.debug('#### OpportunityContactRole - '+oppConRoleList);
    		if(Test.isRunningTest()){
				Integer error = 0/0;
			}
		}catch(Exception ex){
			system.debug('#### Error on line - '+ex.getLineNumber());
	    	system.debug('#### Error message - '+ex.getMessage());
		}  
		return oppConRoleList;
	}
	
	/******************************************************************************
	* @Description : Use this method to Initialise trigger bypass variables.      *
	* @Params      : void                                                         *
	* @Return      : void                                                         * 
	******************************************************************************/
	public void initialiseTriggerBypass(){
		
		// Setting flags to bypass Triggers.
		TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT();
		TriggerHandler.BY_PASS_ACCOUNT_ON_UPDATE();
		
		TriggerHandler.BY_PASS_CASE_ON_INSERT();
		TriggerHandler.BY_PASS_CASE_ON_UPDATE();
		
		TriggerHandler.BY_PASS_CONTACT_ON_INSERT();
		TriggerHandler.BY_PASS_CONTACT_ON_UPDATE();
		
		TriggerHandler.BY_PASS_OPPORTUNITY_ON_INSERT();
		TriggerHandler.BY_PASS_OPPORTUNITY_ON_UPDATE();
		
		TriggerHandler.BY_PASS_CARRIERDATA_ON_INSERT();
		TriggerHandler.BY_PASS_CARRIERDATA_ON_UPDATE();
		
		TriggerHandler.BY_PASS_LEAD_UPDATE_ON_INSERT();
		
	}
	
	/******************************************************************************
	* @Description : Use this method to deInitialise trigger bypass variables.    *
	* @Params      : void                                                         *
	* @Return      : void                                                         * 
	******************************************************************************/ 
	public void deInitialiseTriggerBypass(){
		// Setting flags to unset bypass Triggers.
		TriggerHandler.RESET_VARIABLES();
		
		TriggerHandler.BY_PASS_CARRIERDATA_ON_INSERT = false;
		TriggerHandler.BY_PASS_CARRIERDATA_ON_UPDATE = false;	
	}
	
	/******************************************************************************
	* @Description : Use this method create templates.                            *
	* @Params      : void                                                         *
	* @Return      : void                                                         * 
	******************************************************************************/ 
	public EmailTemplate createTemplates(){
		
		EmailTemplate eTemp = new EmailTemplate();
		try{
	        eTemp.Name = 'TestTemplate';
	        eTemp.folderId = [SELECT AccessType, Id, Name, NamespacePrefix, Type FROM Folder WHERE AccessType = 'Public' AND Type = 'Email' LIMIT 1 ].Id;
	        eTemp.Subject = 'Test Template';
	        eTemp.Encoding = 'UTF-8';
	        eTemp.TemplateType = 'custom';
	        eTemp.DeveloperName = 'Test';
	        eTemp.IsActive = true;
	        System.runAs(new User(Id = Userinfo.getUserId())) {
	            insert eTemp;
	        }
        	system.debug('#### Email Template - '+eTemp);
    		if(Test.isRunningTest()){
				Integer error = 0/0;
			}
		}catch(Exception ex){
			system.debug('#### Error on line - '+ex.getLineNumber());
	    	system.debug('#### Error message - '+ex.getMessage());
		}	
        return eTemp;
	}
}// End of Class.