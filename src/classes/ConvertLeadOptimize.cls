/*************************************************
ConvertLeadOptimize class   
This Class is used by convertLeadVFPage.page which over-rides Convert button for Lead object in SFDC.
Using details of lead this class searches for possible contact matches based on phone and email.
Then it looks at the Accounts associated to those contacts to see if there are any ActivePipe Opportunities.
The page shows agent that there already exists an Account which has the same contact information and if it is protected at all.
Agent can choose to select the matching Account, search for an account they know matchs or create a brand new account.
If merging only a new Opportunity is made which is tied to the existing Account and Contact.
/************************************************/

public with sharing class ConvertLeadOptimize {   
    // Constructor - this only really matters if the autoRun function doesn't work right        
    public Lead leadObj{get;set;}
    List<Account> a = new List<Account>();
    List<Contact> c = new List<Contact>();     
    public Boolean matchFound = false;   
    public Boolean matchNotFound = true;
    public Boolean notAnswered = false; 
    public Boolean showMandatoryFieldPanel{get;set;}// ConvertLead Mandatory field popup Project. Added on 4th April,14
    public String impErrorMsg {get; set;} // Variable to contain error message-Added on 4th April,14
    //code by indiateam
    public Boolean agni = false; 
    public Boolean Lead_Source;
    public Boolean Initial_Category=Null;
    public Boolean Initial;
    public Boolean submit=true;

    
    public Boolean Initial_CategoryFlag = false;    //India Team-Sep02 
    public String strDebug = '';
    
    Account selectedAcc;
    Account acc;
    Contact con;
    Opportunity opp; 
    List<SelectOption> options = new List<SelectOption>();
    public List<cAccount> accountList {get; set;}
    // code added by India team on 23 July 2010
    public List<cOpportunity> opportunityList {get; set;}
    public List<Opportunity> oppList = new List<Opportunity>();
    //code ended India team on 23 July 2010

    Boolean multiple=false;
    public Boolean createNew = false; 
 
     
    public ConvertLeadOptimize() {
    	showMandatoryFieldPanel = false; // ConvertLead Mandatory field popup Project. Added on 4th April,14
        Boolean isLeadDeleted = false;
        try {
        	system.debug('Begining. Tis is lead id: ' + ApexPages.currentPage().getParameters().get('id'));
        	if(accountList == null)	{
       	 		accountList = new List<cAccount>();
        	}
         	// code added by India team on 23 July 2010
         	if(opportunityList == null)	{
            	opportunityList = new List<cOpportunity>();
        	}
        	// code ended by India team on 23 July 2010
  			// New LeadPartnerID__c field is use for seting Partner Id in Account & Opportunity
        	try {
        		leadObj = new Lead();
            	leadObj = [SELECT Id,City,Country,PostalCode,State,Street,Company,Description,Email,FirstName,LastName,Number_of_Users__c,
                    		LeadSource,Name,NumberOfEmployees,OwnerId,Phone,Title,Account_Number__c,Timezone__c, Street_2__c,website,Lead_Brand_Name__c,
                    		industry,phone_ext__c,isconverted,Notes__c, Account__c,Initial_Category__c,User_ID__c, Agent_Email_Address__c,Lead_Tier_Name__c,
                    		Referrer_FName__c,Referrer_LName__c,Referrer_Email__c  , NumberOfEmployees__c , Number_of_Locations__c,Partner_ID__c,
                    		LeadPartnerID__c,InContract__c , Pain__c, Pain_Impact__c, Gain__c, Gain_Impact__c, Ideal_Solution__c, Effective_No_of_Employees_Range__c,
                    		Benefits__c, Next_Steps_questions__c,CompanyInfo__c, RecordTypeName__c, Partner_Lead_Owner__c, Inside_Sales_Rep__c,Employees_Override__c 
                    		FROM Lead WHERE id=:ApexPages.currentPage().getParameters().get('id')];            
       			
       		} catch(Exception e) { 
            	isLeadDeleted = true;
       		}
    
        	if(leadObj.email != null && leadObj.email != 'fake@email.com' && leadObj.phone != null) {	// Condition 1
         		try	{ 
	         		/* Fetching Contacts and related account */
	         		Map<Id, Contact> cMap = new Map<id, Contact>([SELECT Id, Name,Email, AccountId,Phone, Account.Name, Account.RC_User_ID__c, 
	         														Account.RC_Account_Number__c, 
	         														Account.RC_Account_Status__c, Account.Website, Account.NumberOfEmployees, 
	         														Account.Industry, Account.No_of_Employees__c, Account.Number_Of_Locations__c  
	         														FROM Contact WHERE email =: leadObj.email OR phone=: leadObj.phone 
	         														OR (Account.RC_User_ID__c =: leadObj.User_ID__c and Account.RC_User_ID__c != '' 
	         														AND Account.Type='Customer') ]);
	             	System.debug('Contact Map '+cMap);
		         	set<id> accountids = new set<id>();
		         	if(cMap != null) {
		             	for(Id contactid: cMap.keySet()) {
		              		Contact conObj = cMap.get(contactid);
	             	  		/*Code for Customer prpfile*/
	       		 			if(conObj.Account != null) {
			                    if(leadObj.Website != NULL) {                            
			                       conObj.Account.Website = leadObj.Website;
			                    } 
			                    if(leadObj.NumberOfEmployees != NULL){  
			                        conObj.Account.NumberOfEmployees = leadObj.NumberOfEmployees;
			                    }  
			                    if(leadObj.Industry != NULL){                          
			                        conObj.Account.Industry = leadObj.Industry;
			                    } 
			                    /*if(leadObj.NumberOfEmployees__c != NULL){   
			                       conObj.Account.No_of_Employees__c = leadObj.NumberOfEmployees__c;
			                    }*/
			                    /*****New Employee Override Field Update*****/
			                    if(leadObj.Effective_No_of_Employees_Range__c != NULL){   
			                       conObj.Account.No_of_Employees__c = leadObj.Effective_No_of_Employees_Range__c;
			                    } 
			                    /*******************************************/  
			                    if(leadObj.Number_of_Locations__c != NULL){ 
			                        conObj.Account.Number_Of_Locations__c = leadObj.Number_of_Locations__c;
			                    }   
			            		accountList.add(new cAccount(conObj.Account,conObj.Account.RC_User_ID__c,conObj.Account.RC_Account_Number__c,
			            									conObj.Account.RC_Account_Status__c));
			            		accountids.add(conObj.AccountId);       
		            		}   
			          	}
			         } 
			           
			         if(accountids.size() > 0) {
				         /*fetching related Opportunity*/
				         /*RecordType.Name should be add on sand box*/
				         Map<id, Opportunity> oMap = new Map<id, Opportunity>([Select StageName, Opportunity.Owner.Name, Name,Opportunity.Account.Name, 
		         																CreatedDate,Last_Touched_Date__c From Opportunity where 
				         														AccountId IN :accountids AND StageName IN : OpportunityHelper.alteredStages 
				         														AND RecordType.Name ='Sales Opportunity']);
		              	if(oMap != null) {
			             	for(Id oppid: oMap.keySet()) {
				             	Opportunity oppObj =   oMap.get(oppid);
				             	opportunityList.add(new cOpportunity(oppObj,oppObj.Name,oppObj.Owner.Name,oppObj.Account.Name,oppObj.StageName,
				             														oppObj.CreatedDate,oppObj.Last_Touched_Date__c));
			               	}
	            		}   
			         }  
  				} catch(Exception e){
        			/* handle here your exception */
      			}     
    		} else if(leadObj.email != null && leadObj.email != 'fake@email.com' && leadObj.phone == null) {		// Condition 2
       			/*New Opt Code*/
   				try { 
			         /* Fetching Contacts and related account */
		         	Map<Id, Contact> cMap = new Map<id, Contact>([SELECT Id, Name,Email, AccountId,Phone, Account.Name, Account.RC_User_ID__c, 
			         												Account.RC_Account_Number__c, Account.RC_Account_Status__c, Account.Website, 
			         												Account.NumberOfEmployees, Account.Industry, Account.No_of_Employees__c, 
			         												Account.Number_Of_Locations__c  FROM Contact WHERE email =: leadObj.email  
			         												OR (Account.RC_User_ID__c =: leadObj.User_ID__c and Account.RC_User_ID__c != '' 
			         												AND Account.Type='Customer')]);
		         	System.debug('Contact Map '+cMap);
		         	set<id> accountids = new set<id>();
		         	if(cMap != null) {
		             	for(Id contactid: cMap.keySet()) {
		              		Contact conObj = cMap.get(contactid);
			            	/*Code for Customer prpfile*/
			            	if(conObj.Account != null) {
		                    	if(leadObj.Website != NULL){                            
			                       conObj.Account.Website = leadObj.Website;
			                    } 
			                    if(leadObj.NumberOfEmployees != NULL){  
			                        conObj.Account.NumberOfEmployees = leadObj.NumberOfEmployees;
			                    }  
			                    if(leadObj.Industry != NULL){                          
			                        conObj.Account.Industry = leadObj.Industry;
			                    } 
			                    /*if(leadObj.NumberOfEmployees__c != NULL){   
			                       conObj.Account.No_of_Employees__c = leadObj.NumberOfEmployees__c;
			                    }*/
			                    /*****New Employee Override Field Update*****/
			                    if(leadObj.Effective_No_of_Employees_Range__c != NULL){   
			                       conObj.Account.No_of_Employees__c = leadObj.Effective_No_of_Employees_Range__c;
			                    } 
			                    /*******************************************/ 
			                    if(leadObj.Number_of_Locations__c != NULL){ 
			                        conObj.Account.Number_Of_Locations__c = leadObj.Number_of_Locations__c;
			                    } 
			            		accountList.add(new cAccount(conObj.Account,conObj.Account.RC_User_ID__c,conObj.Account.RC_Account_Number__c,
			            									conObj.Account.RC_Account_Status__c));
			             		accountids.add(conObj.AccountId);  
			            	}   
		             	}
	         		} 
			           
		         	if(accountids.size() > 0) {
			         	/*fetching related Opportunity*/
			         	/*RecordType.Name should be add on sand box*/
			         	Map<id, Opportunity> oMap = new Map<id, Opportunity>([Select StageName, Opportunity.Owner.Name, Name,Opportunity.Account.Name, 
			         															CreatedDate,Last_Touched_Date__c, Partner_ID__c 
				         														From Opportunity where AccountId IN :accountids AND 
				         														StageName IN : OpportunityHelper.alteredStages AND (RecordType.Name ='Sales Opportunity' 
				         														OR RecordTypeId = NULL)]);
		             	if(oMap != null) {
		             		for(Id oppid: oMap.keySet()) {
			             		Opportunity oppObj =   oMap.get(oppid);
			             		opportunityList.add(new cOpportunity(oppObj,oppObj.Name,oppObj.Owner.Name,oppObj.Account.Name,oppObj.StageName,
			             								oppObj.CreatedDate,oppObj.Last_Touched_Date__c));
			               	}
			            }   
		         	}  
  				} catch(Exception e) {
        			/* handle here your exception */
      			}     
          		/*End Here*/
        	} else if((leadObj.email == null || leadObj.email == 'fake@email.com') && leadObj.phone != null) {		// Condition 3
        		/*New Opt Code Start here*/
             	try { 
	         		/* Fetching Contacts and related account */
	         		Map<Id, Contact> cMap = new Map<id, Contact>([SELECT Id, Name,Email, AccountId,Phone, Account.Name, Account.RC_User_ID__c, 
	         														Account.RC_Account_Number__c, Account.RC_Account_Status__c, Account.Website, 
	         														Account.NumberOfEmployees, Account.Industry, Account.No_of_Employees__c, 
													         		Account.Number_Of_Locations__c  FROM Contact WHERE phone=: leadObj.phone  
													         		OR (Account.RC_User_ID__c =: leadObj.User_ID__c and Account.RC_User_ID__c != '' 
													         		AND Account.Type='Customer') ]);
	         		System.debug('Contact Map '+cMap);
	         		set<id> accountids = new set<id>();
	         		if(cMap != null) {
	             		for(Id contactid: cMap.keySet()) {
	                 		//accountList.add(new cAccount(acc,acc.RC_User_ID__c,acc.RC_Account_Number__c, acc.RC_Account_Status__c));
	              			Contact conObj = cMap.get(contactid);
	    					/*Code for Customer prpfile*/
	            			if(conObj.Account != null) {
			                    if(leadObj.Website != NULL) {                            
			                       conObj.Account.Website = leadObj.Website;
			                    } 
			                    if(leadObj.NumberOfEmployees != NULL) {  
			                        conObj.Account.NumberOfEmployees = leadObj.NumberOfEmployees;
			                    }  
			                    if(leadObj.Industry != NULL) {                          
			                        conObj.Account.Industry = leadObj.Industry;
			                    } 
			                    /*if(leadObj.NumberOfEmployees__c != NULL) {   
			                       conObj.Account.No_of_Employees__c = leadObj.NumberOfEmployees__c;
			                    }*/
			                    /*****New Employee Override Field Update*****/
			                    if(leadObj.Effective_No_of_Employees_Range__c != NULL) {   
			                       conObj.Account.No_of_Employees__c = leadObj.Effective_No_of_Employees_Range__c;
			                    }  
			                    /*******************************************/ 
			                    if(leadObj.Number_of_Locations__c != NULL) { 
			                        conObj.Account.Number_Of_Locations__c = leadObj.Number_of_Locations__c;
			                    } 
		             			accountList.add(new cAccount(conObj.Account,conObj.Account.RC_User_ID__c,conObj.Account.RC_Account_Number__c,
		             											conObj.Account.RC_Account_Status__c));
		             			accountids.add(conObj.AccountId);  
	            			}   
	             		}
	         		}	 
	         		if(accountids.size() > 0) {
				         /*fetching related Opportunity*/
				         /*RecordType.Name should be add on sand box*/
				         Map<id, Opportunity> oMap = new Map<id, Opportunity>([Select StageName, Opportunity.Owner.Name, Name,Opportunity.Account.Name, 
				         														CreatedDate,Last_Touched_Date__c, Partner_ID__c 
				         														From Opportunity where AccountId IN :accountids AND 
				         														StageName IN : OpportunityHelper.alteredStages AND (RecordType.Name ='Sales Opportunity' 
				         														OR RecordTypeId = NULL )]);
		              	if(oMap != null) {
		             		for(Id oppid: oMap.keySet()) {
			             		Opportunity oppObj =   oMap.get(oppid);
				             	/*Inserting Partner ID*/
				             	oppObj.Partner_ID__c = leadObj.LeadPartnerID__c;
				             	opportunityList.add(new cOpportunity(oppObj,oppObj.Name,oppObj.Owner.Name,oppObj.Account.Name,oppObj.StageName,
				             										oppObj.CreatedDate,oppObj.Last_Touched_Date__c));
			               	}
			            }   
	         		}  
      			} catch(Exception e) {
        			/* handle here your exception */
      			}     
 				/*End Here*/
        	} //code by indiateam - Sep 02
       		strDebug = leadObj.LeadSource + '----' + leadObj.Initial_Category__c;
       		if(leadObj.LeadSource == 'Initial' && leadObj.Initial_Category__c == null) {
           		Initial_CategoryFlag = true;          
       		}
           	if(!accountList.isEmpty()) {
                matchFound = true;
                matchNotFound = false;
            }
            else {
                matchFound = false;
                matchNotFound = true; 
            } 
  			if(!String.isBlank(ApexPages.currentPage().getParameters().get('Id'))) {
				try {
					toShowViewMode = false;
					strId = ApexPages.currentPage().getParameters().get('Id');
					rtrl = Apexpages.currentPage().getParameters().get('retURL'); 
					loadLeadQualBasicDet();
					loadLeadBasicInfo();
				} catch(Exception ex) {}
			}
		} catch(Exception ex) {
            String msg = ex.getMessage();
            msg = 'This lead is already removed or referenced to other lead!';
        	ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, msg));
    	}
	}
       
    /*Code Added by India Team 02 Sep */    
    List<String> listInitialCategory;
	// code for Initial Category, added by India Team
    public List<String>  getListInitialCategoryValues() {
   		List<String> options = new List<String>();
       	Schema.DescribeFieldResult fieldResult = Lead.Initial_Category__c.getDescribe();
       	List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues(); 
   		for( Schema.PicklistEntry f : ple) {
			options.add(f.getValue()); 
       	}
       	listInitialCategory = options;
       	return listInitialCategory;
 	}
    
    String initialCategory; 
    public List<SelectOption> getListInitialCategoryItems() {
    	List<SelectOption> options = new List<SelectOption>();
        listInitialCategory =  getListInitialCategoryValues();
        if(listInitialCategory != null) {
           for(Integer counter=0;counter<listInitialCategory.size();counter++) {       
              options.add(new SelectOption(listInitialCategory.get(counter),listInitialCategory.get(counter)));          
           }        
       }
       return options;
    }    
    
    public String getInitialCategory() {
        return initialCategory;
    }
    
    public void setInitialCategory(String initialCategory) {
        this.initialCategory = initialCategory;
    }
    
    public PageReference updateLeadCategory() {
    	try {
            leadObj.Initial_Category__c = getInitialCategory();
            update leadObj;     
    	} catch (Exception ex){}  
        PageReference pageRef = ApexPages.currentPage();
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    public PageReference GoBack() {
        String previousPage = System.currentPageReference().getParameters().get('retURL');
        PageReference newPage = new PageReference(previousPage);
        newPage.setRedirect(true);
        return newPage;
    }
    /*End */ 
    
    /*
    convertAndMerge() takes the selection by user and compelts the action. 
    First some error checking takes place to make sure only one option was selection and that a selection was made.
    If a account was found by the agent then we convert the lead into that account using the Database.LeadConvert operations.
    If the agent selected on of the accounts we found we convert the lead into that account again with Database.LeadConvert.
    If neither of those options were used then we call the convert() method which creates an new set of Account/Contact/Opporunity.
    */  
    List<Note> noteList = new List<Note>();
    public PageReference convertAndMerge() {
    	TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT();
		TriggerHandler.BY_PASS_ACCOUNT_ON_UPDATE();
		TriggerHandler.BY_PASS_CONTACT_ON_INSERT();
		TriggerHandler.BY_PASS_CONTACT_ON_UPDATE();
		TriggerHandler.BY_PASS_OPPORTUNITY_ON_INSERT();
		TriggerHandler.BY_PASS_OPPORTUNITY_ON_UPDATE();
    	Savepoint sp = null;
    	PageReference pageRef2 = null;
  		try	{
	        sp = Database.setSavepoint();   
           	try {
	            if((leadObj.Company != null && (leadObj.Company).equalsIgnoreCase('PhoneOnly')) 
	                && (leadObj.Name != null && (leadObj.Name).equalsIgnoreCase('Phone Only')) 
	                && (leadObj.Email != null && (leadObj.Email).equalsIgnoreCase('fake@email.com')) ) {
	                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 
                						'Please update the contact details on Company Name, Contact Name, or Email to the appropriate information.'));
	                return ApexPages.currentPage();     
	            }
	        } catch(Exception e) {}
	        List<Account> selectedAccounts = new List<Account>();
	        // Go through the list of Accounts we listed and add the selected ones to a seperate List
	        for(cAccount cAcc : getAccounts()) {
	            if(cAcc.selected == true) {
	                selectedAccounts.add(cAcc.acc);
	            }
	        }
	        
	        // Make sure there has not been more than 1 selection from all three options, return with error
	        if((selectedAccounts.size() > 1) || (selectedAccounts.size() >= 1 && createNew == true) || (selectedAccounts.size() >= 1 && 
	        		leadObj.Account__c != null) || (createNew == true && leadObj.Account__c != null)){
	            multiple = true;
	            notAnswered = false;
	            system.debug('multiple accounts were selected');
	            return ApexPages.currentPage();
	        }           
	        multiple = false;
	        system.debug('multiple accounts were not selected'); 
	         
	        // If there have been no selections made return with error  
	        if(selectedAccounts.isEmpty() && createNew != true && leadObj.Account__c == null) {
	            notAnswered = true;            
	             //India Team 02 Sep
	            if(leadObj.LeadSource == 'Initial' && leadObj.Initial_Category__c == null) {
	                Initial_CategoryFlag = true;
	                return ApexPages.currentPage();
	            }
	            //          
	            return ApexPages.currentPage();
	        }       
	        
	        notAnswered = false;
	         
	        //India Team 02 Sep
	        if(leadObj.LeadSource == 'Initial' && leadObj.Initial_Category__c == null) {
	            Initial_CategoryFlag = true;
	            return ApexPages.currentPage();
	        }
	        //   
	      
	        // If user browsed for an account themseleves
	        if(leadObj.Account__c != null) {    
	            //Get list of Notes before Lead is converted, else this list is gone after lead has been converted
	       	    system.debug('Lead notes size= : ' + leadNotes.size() + 'timezone= '+ strLeadTimeZone);
	            system.debug('this is leadObj.account: ' + leadObj.Account__c);
	            Database.LeadConvert lc = new database.LeadConvert();
	            lc.setLeadId(leadObj.id);
	            lc.setOwnerId(UserInfo.getUserId());
	            lc.setAccountId(leadObj.account__c);            
	            
	            try {
	                Contact c = [SELECT id FROM Contact WHERE AccountId =: leadObj.account__c LIMIT 1]; 
	                lc.setContactId(c.Id);
	            }
	            catch(System.QueryException e) {
	                //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'5'+e.getMessage()));
	                system.debug('there was no contact on the account');
	            }
	            lc.setConvertedStatus(convertStatus.MasterLabel);
             	if(leadObj.RecordTypeName__c == 'Partner_Leads') {
    				PageReference pgRef = convertPartnerLead(lc);
        			return pgRef;
        		}         		
        		
            	Database.LeadConvertResult lcr = Database.convertLead(lc); 
            	System.assert(lcr.isSuccess());  
         		mapLeadTOQualificationUpdate(lcr); 
         		updateExOpportunityContactRole(lcr);        		
	          
	            //Added for passing Support Agent e-mail to Account
	            try {
	             	Account agentMailAcc = new Account(Id = lc.getAccountId());							            
	                agentMailAcc = mapLeadToAccountFields(agentMailAcc);	// updateQualificationVal(leadObj,lc.getAccountId()); 
	                update agentMailAcc;
	            } catch(System.QueryException e) {
	                 ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'6'+e.getMessage()));
	                system.debug('there was an error while passing the Agnet email to Account');
	            }
              	Opportunity newOpp = new Opportunity (id = lcr.getOpportunityId());
	            newOpp = prepareOpportunity(newOpp,'Existing Business');
	            if(noteList != null && noteList.size()>0) {
	            	insert noteList;	
	            }
	          	update newOpp;
	            // send user to newly create Opportunity
	            PageReference pageRef = new ApexPages.StandardController(newOpp).view();                
	            pageRef.setRedirect(true);  
	            TriggerHandler.RESET_VARIABLES();      
	            return pageRef;               
	        }
	        else if(selectedAccounts.size() == 1) {
	            system.debug('Lead notes size= : ' + leadNotes.size());
	            // user has selected one of the accounts we found for them 
	            Account selectedAcc = selectedAccounts.get(0); 
	            Database.LeadConvert lc = new database.LeadConvert();
	            lc.setLeadId(leadObj.id);
	            lc.setOwnerId(UserInfo.getUserId());
	            lc.setAccountId(selectedAcc.Id);
	            try {
	                Contact c = [SELECT id FROM Contact WHERE AccountId =: selectedAcc.Id LIMIT 1]; 
	                lc.setContactId(c.Id);
	            }
	            catch(System.QueryException e) {
	                // ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'7'+e.getMessage()));
	                system.debug('there was no contact on the account');
	            }
	            lc.setConvertedStatus(convertStatus.MasterLabel);
             	if(leadObj.RecordTypeName__c == 'Partner_Leads') {
    				PageReference pgRef = convertPartnerLead(lc);
        			return pgRef;
        		}
        		
            	Database.LeadConvertResult lcr = Database.ConvertLead(lc);
            	System.assert(lcr.isSuccess());   
            	mapLeadTOQualificationUpdate(lcr);  
            	updateExOpportunityContactRole(lcr);        		
		        
         		//	Added for passing Support Agent e-mail to Account
	            try {
	                Account agentMailAcc = new Account(Id = lc.getAccountId());
	                agentMailAcc = mapLeadToAccountFields(agentMailAcc);
	                upsert agentMailAcc;
	            } catch(System.QueryException e) {
                 	ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'8'+e.getMessage()));
	                system.debug('there was an error while passing the Agnet email to Account');
	            }
	            Opportunity newOpp = new Opportunity(id = lcr.getOpportunityId());
	            newOpp = prepareOpportunity(newOpp,'Existing Business');
	            if(noteList != null && noteList.size()>0) {
	            	insert noteList;	
	            }
	            update newOpp;
	            // send user to newly create Opportunity
	            PageReference pageRef = new ApexPages.StandardController(newOpp).view();                
	            pageRef.setRedirect(true);   
	            TriggerHandler.RESET_VARIABLES();     
	            return pageRef;
	        }
	      	pageRef2 = convert();   
      	}/* catch(DMLException exDML) {
           	ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,exDML.getMessage()));  
           //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage())); 
           Database.rollback(sp);
           TriggerHandler.RESET_VARIABLES();
           return ApexPages.currentPage();  
    	} catch(Exception ex) {
           // String errMsg = 'Please check the converting lead again, as it causes the problem in lead conversion.';
      		String errMsg = 'Validation Rule does not allow User to convert Lead.';
           	ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()+ex.getLineNumber()));  
           //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage())); 
           Database.rollback(sp);
           TriggerHandler.RESET_VARIABLES();
           return ApexPages.currentPage();  
      	} */
      	catch(Exception ex){
      		if (ex.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')){
            	ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,ex.getDmlMessage(0)));
        	}else{
        		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
        	} 
        	Database.rollback(sp);
            TriggerHandler.RESET_VARIABLES();
            return ApexPages.currentPage();
      	}
      	TriggerHandler.RESET_VARIABLES();
    	return pageRef2;  
    }
    
    /*
    convert() uses the standard convert database method to create a new set of data.
    Some fields on the contact/opportunity and account that are not currently used are cleared out. 
    */
    public PageReference convert() {  
    	try{  
	        datetime myDT = Datetime.now();
	        date mydate = date.today();
	        if(leadObj.isconverted == false) {
	            system.debug('THIS IS LEAD ID TO CONVERT: ' + leadObj.Id);
	            system.debug('THIS IS LEAD ISCONVERTED: ' + leadObj.isconverted);     
	            Database.LeadConvert lc = new database.LeadConvert();
	            lc.setLeadId(leadObj.Id);
	            lc.setConvertedStatus(convertStatus.MasterLabel);
	         	if(leadObj.RecordTypeName__c == 'Partner_Leads') {
	    			PageReference pgRef = convertPartnerLead(lc);
	        		return pgRef;
	        	}
	        	
                Database.LeadConvertResult lcr = Database.convertLead(lc);
                System.assert(lcr.isSuccess());
                mapLeadTOQualificationUpdate(lcr); 
                updateExOpportunityContactRole(lcr);    
                acc = new Account(Id = lcr.getAccountId());
                con = new contact(Id = lcr.getContactId());
                opp = new  Opportunity(Id = lcr.getOpportunityId());     
	           
	            // Set fields on Contact/Opp/Account to what we want them to be.        
	            con.Description = leadObj.Description;
	            con.Email = leadObj.Email;
	            con.Contact_Status__c = 'New';
	            con.FirstName = leadObj.FirstName;
	            con.LastName = leadObj.LastName;
	            con.LeadSource = leadObj.LeadSource;
	            con.MailingCity = leadObj.City;
	            con.MailingCountry = leadObj.Country;
	            con.MailingPostalCode = leadObj.PostalCode;
	            con.MailingState = leadObj.State;
	            con.MailingStreet = leadObj.Street;
	            con.Street_2__c = leadObj.Street_2__c;
	            con.OwnerId = leadObj.OwnerId;
	            con.Phone = leadObj.Phone;  
	            con.Phone_Ext__c = leadObj.Phone_Ext__c;
	            con.Title = leadObj.Title;
	            con.indexedPhone__c =  leadObj.Phone;
	            con.indexedEmail__c = leadObj.email;
	            
	            opp.Industry__c = leadObj.Industry;
	            opp.Website__c = leadObj.Website;
	            opp.RC_Account_Number__c = leadObj.Account_Number__c;
	            opp = prepareOpportunity(opp,'New Business');
	            
	            if(noteList != null && noteList.size()>0) {
	            	insert noteList;	
	            }
	        	
	        	// Account fields are being set to null because in the beigining we were not using them. This should be reviewed. 
	            acc.Phone = acc.Industry = acc.Description = acc.BillingStreet = null;
	            acc.BillingCity = acc.BillingCountry = acc.BillingPostalCode = acc.BillingState = acc.ShippingCity = null;
	            acc.ShippingCountry= acc.ShippingPostalCode = acc.ShippingState = acc.ShippingStreet =acc.Website = null;
	            acc.NumberOfEmployees = null;
	            
	        	acc.RC_Sync_Status__c = 'Pending'; 
	     
	     	   	/*  Update Customer profile new request  */
	         
	           	acc = mapLeadToAccountFields(acc);
	       
	           	/*if(leadObj.Website != NULL || leadObj.NumberOfEmployees != NULL || leadObj.Industry != NULL || leadObj.NumberOfEmployees__c != NULL 
	           	  || leadObj.Number_of_Locations__c != NULL) {  
	               	acc.Customer_Profile_Last_modified_Date__c = System.now();
	       		}*/
	       		/*****New Employee Override Field Update*****/
	       		if(leadObj.Website != NULL || leadObj.NumberOfEmployees != NULL || leadObj.Industry != NULL || leadObj.Effective_No_of_Employees_Range__c != NULL 
	           	  || leadObj.Number_of_Locations__c != NULL) {  
	               	acc.Customer_Profile_Last_modified_Date__c = System.now();
	       		}  
	       		/*******************************************/ 
	       		try {
	       			update acc;
	            	update con;
	            	update opp;
	       		}  catch(Exception ex) {}                   
	         
	            // send user to newly create Opportunity
	            PageReference pageRef = new ApexPages.StandardController(opp).view();                
	            pageRef.setRedirect(true);        
	            return pageRef;  
	        }
        } catch(Exception ex) {
        	if (ex.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')){
            	ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,ex.getDmlMessage(0)));
        	}else{
        		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
        	}            
        }
        return ApexPages.currentPage();         
    }
    
    public PageReference convertPartnerLead(Database.LeadConvert leadConvertObj) { 
        datetime myDT = Datetime.now();
        date mydate = date.today();
        Id partnerOwnerId = null;
        if(leadObj.isconverted == false) {
        	TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT();
			TriggerHandler.BY_PASS_ACCOUNT_ON_UPDATE();
			TriggerHandler.BY_PASS_CONTACT_ON_INSERT();
			TriggerHandler.BY_PASS_CONTACT_ON_UPDATE();
			TriggerHandler.BY_PASS_OPPORTUNITY_ON_INSERT();
			TriggerHandler.BY_PASS_OPPORTUNITY_ON_UPDATE();   
            system.debug('THIS IS LEAD ID TO CONVERT: ' + leadObj.Id);
            system.debug('THIS IS LEAD ISCONVERTED: ' + leadObj.isconverted); 
            partnerOwnerId = (leadObj.Partner_Lead_Owner__c != null ? leadObj.Partner_Lead_Owner__c : null);  
            system.debug('#### PARTNER LEAD OWNER = : ' + partnerOwnerId); 
            Id leadOwner = leadObj.ownerId;
            Group groupObj = getPartnerQueue();
            if(groupObj != null && leadObj.OwnerId == groupObj.Id) {
                 ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 
                                            'This lead is not owned by a user, you must specify a user for the Owner field.'));
        		return ApexPages.currentPage();
            }
            User objUserDetail= getLoggedInUserDetails();
            // Id userId = 
            Database.LeadConvert lc = new database.LeadConvert();
            lc = leadConvertObj;
            lc.setLeadId(leadObj.id);
            lc.setOwnerId(leadOwner);
            lc.setConvertedStatus(convertStatus.MasterLabel);                        
            try {
                Database.LeadConvertResult lcr = Database.convertLead(lc);
                mapLeadTOQualificationUpdate(lcr);
                updateExOpportunityContactRole(lcr);
                mapOpportunityContactRole(lcr,leadQualificationObj);
                System.assert(lcr.isSuccess());
                acc = new Account(Id = lcr.getAccountId());
                con = new contact(Id = lcr.getContactId());
                opp = new  Opportunity(Id = lcr.getOpportunityId());     
                system.debug('#### PARTNER LEAD OWNER 1 = : ' + acc.OwnerId); 
            } catch(Exception e) {
                system.debug(' partner lead owner,EXCEPTION AT 9 = '+ e.getMessage());
                /*if(e.getMessage().containsIgnoreCase('This Lead has expired')) {
                	ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 
                                            'This Lead has expired. It cannot be edited. Please contact <a style="font-size:12px;" href=mailto:resellers@ringcentral.com>resellers@ringcentral.com</a> if you have any questions.'));
                }*/
                //return ApexPages.currentPage();
                
                if (e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')){
	            	ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,e.getDmlMessage(0)));
	        	}else if(e.getMessage().containsIgnoreCase('This Lead has expired')) {
                	ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 
                                            'This Lead has expired. It cannot be edited. Please contact <a style="font-size:12px;" href=mailto:resellers@ringcentral.com>resellers@ringcentral.com</a> if you have any questions.'));
                }else{
	        		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
	        	} 
                return null;
            }
            // Set fields on Contact/Opp/Account to what we want them to be. 
            con.Description = leadObj.Description;
            con.Email = leadObj.Email;
            con.Contact_Status__c = 'New';
            con.FirstName = leadObj.FirstName;
            con.LastName = leadObj.LastName;
            con.LeadSource = leadObj.LeadSource;
            con.MailingCity = leadObj.City;
            con.MailingCountry = leadObj.Country;
            con.MailingPostalCode = leadObj.PostalCode;
            con.MailingState = leadObj.State;
            con.MailingStreet = leadObj.Street;
            con.Street_2__c = leadObj.Street_2__c;
            system.debug('#### PARTNER LEAD OWNER = 2 : ' + acc.OwnerId); 
            // con.OwnerId = leadObj.OwnerId;
            con.Phone = leadObj.Phone;  
            con.Phone_Ext__c = leadObj.Phone_Ext__c;
            con.Title = leadObj.Title;
            con.indexedPhone__c =  leadObj.Phone;
            con.indexedEmail__c = leadObj.email;
            
            opp.Signup_Link__c = 
            opp.Industry__c = leadObj.Industry;
            opp.Website__c = leadObj.Website;
            opp.RC_Account_Number__c = leadObj.Account_Number__c;
            if(opp.Signup_Link__c == null)
            	opp.Signup_Link__c = objUserDetail.Contact.Account.Signup_Link__c;
            opp = prepareOpportunity(opp,'New Business');
            if(leadObj.Inside_Sales_Rep__c != null) {
            	system.debug('>>>leadObj.Inside_Sales_Rep__c>>>2' + leadObj.Inside_Sales_Rep__c); 
            	opp.Inside_Sales_Rep__c = leadObj.Inside_Sales_Rep__c;
            }
            system.debug('#### PARTNER LEAD OWNER = :3 ' + acc.OwnerId); 
            
            if(noteList != null && noteList.size()>0) {
                insert noteList;    
            }
            
            // Account fields are being set to null because in the beigining we were not using them. This should be reviewed. 
            acc.Phone = acc.Industry = acc.Description = acc.BillingStreet = null;
            acc.BillingCity = acc.BillingCountry = acc.BillingPostalCode = acc.BillingState = acc.ShippingCity = null;
            acc.ShippingCountry= acc.ShippingPostalCode = acc.ShippingState = acc.ShippingStreet =acc.Website = null;
            acc.NumberOfEmployees = null;
            if(leadObj.Inside_Sales_Rep__c != null) {
            	acc.Inside_Sales_Rep__c = leadObj.Inside_Sales_Rep__c;
            }
            if(acc.Signup_Link__c == null)
            	acc.Signup_Link__c = objUserDetail.Contact.Account.Signup_Link__c;
            acc.RC_Sync_Status__c = 'Pending'; 
            system.debug('#### PARTNER LEAD OWNER = : 4 ' + partnerOwnerId); 
            /*  Update Customer profile new request  */
            try {
                if(objUserDetail != null) {
                    if(objUserDetail.Contact.Account.Current_Owner__c != null) {
                        acc.Current_Owner__c =  objUserDetail.Contact.Account.Current_Owner__c;
                        acc.Current_Owner_Name__c  = objUserDetail.Contact.Account.Current_Owner_Name__c;
                        acc.Current_Owner_Email__c = objUserDetail.Contact.Account.Current_Owner_Email__c;
                    }
                }
            } catch(Exception ex) { system.debug('#### PARTNER LEAD OWNER 6 = : ' + acc.OwnerId + ' = ' + ex.getMessage()); }
            acc = mapLeadToAccountFields(acc);
       
            /*if(leadObj.Website != NULL || leadObj.NumberOfEmployees != NULL || leadObj.Industry != NULL || leadObj.NumberOfEmployees__c != NULL 
              || leadObj.Number_of_Locations__c != NULL) {  
                acc.Customer_Profile_Last_modified_Date__c = System.now();
            }*/
             /*****New Employee Override Field Update*****/
            if(leadObj.Website != NULL || leadObj.NumberOfEmployees != NULL || leadObj.Industry != NULL || leadObj.Effective_No_of_Employees_Range__c != NULL 
              || leadObj.Number_of_Locations__c != NULL) {  
                acc.Customer_Profile_Last_modified_Date__c = System.now();
            }  
            /*******************************************/  
            try {
                
            } catch(Exception ex) {system.debug('#### PARTNER LEAD OWNER 88 = : '+ partnerOwnerId+', acc owner=' + acc.OwnerId + ' = ' + ex.getMessage()); }
            try {
                acc.RecordTypeId = OpportunityHelper.getOppRecordTypeMap('Customer Account');
                acc.Partner_ID__c = leadObj.LeadPartnerID__c;
                acc.partner_owner__c = con.partner_owner__c = opp.partner_owner__c = leadObj.Partner_Lead_Owner__c;
               // LeadTriggerHelper.byPassTrgrsAtConvertLead();
                update acc;
                if(partnerOwnerId != null) {
                	System.Debug('>>partnerOwnerId>>>' + partnerOwnerId);
                    ShareUtil.shareAccountToPartner(partnerOwnerId, acc.Id);
                }
                con.RecordTypeId = OpportunityHelper.getOppRecordTypeMap('VAR Visible');
               // LeadTriggerHelper.byPassTrgrsAtConvertLead();
                update con;
                opp.RecordTypeId = OpportunityHelper.getOppRecordTypeMap('VAR Opportunity');
               // LeadTriggerHelper.byPassTrgrsAtConvertLead();
                update opp;     
            }  catch(Exception ex) {
                system.debug('#### PARTNER LEAD OWNER 88 = : ' + acc.OwnerId + ' = ' + ex.getMessage()); 
            }                   
            TriggerHandler.RESET_VARIABLES(); 
            // send user to newly create Opportunity
            PageReference pageRef = new ApexPages.StandardController(opp).view();                
            pageRef.setRedirect(true);        
            return pageRef;  
        }
        return ApexPages.currentPage();         
    }
    
    private User getLoggedInUserDetails() {
    	return [Select id,Contact.AccountId,Contact.Account.Partner_id__c, Contact.Account.Signup_Link__c, Contact.Account.Inside_Sales_Rep__c, 
    	Contact.Account.Current_Owner__c, Contact.Account.Current_Owner_Name__c, Contact.Account.Current_Owner_Email__c 
    	FROM User where Id = :leadObj.Partner_Lead_Owner__c];    //:UserInfo.getUserId()
    }
    
    private Group getPartnerQueue() {
        return [SELECT id,Name, (SELECT Id, UserOrGroupId FROM GroupMembers LIMIT 1) FROM Group WHERE Type='Queue' 
        			AND Name='Partner Lead Reviewer' LIMIT 1];
    }
    
    public List<Note> prepareNoteList(List<Note> noteList,Id parentId) {
    	List<Note> rtnNoteList = new List<Note>();
    	try {
    		for(Note noteToInsert : noteList) {
                Note objNote=new Note();
                objNote.Title = noteToInsert.Title;
                objNote.Body = noteToInsert.Body;
                objNote.ParentId = parentId;
                objNote.IsPrivate = noteToInsert.IsPrivate;
                objNote.OwnerId = leadObj.OwnerId; 
                System.debug('Anuj, \n' + 'new note parent opp id= '+ objNote.ParentId);
                rtnNoteList.add(objNote);
            }	
    	} catch(Exception ex) {}
    	return rtnNoteList;
    }
    
    public List<Note> prepareNoteList(string notebody,Id parentId) {
    	List<Note> rtnNoteList = new List<Note>();
    	try {
    		Note noteObj = new Note(Body= notebody, ParentId = parentId, Title= 'Original note from lead', OwnerId = leadObj.OwnerId);
    		rtnNoteList.add(noteObj);
    	} catch(Exception ex) {}
    	return rtnNoteList;
    }
    
    public Opportunity prepareOpportunity(Opportunity oppObj,string businessType) {
    	Opportunity opp = new Opportunity(Id =oppObj.Id);
    	try {
    	    opp.closedate = Date.today();
            opp.Type = businessType;
            opp.Partner_ID__c = leadObj.LeadPartnerID__c;
            system.debug('description: ' + leadObj.Description);
            system.debug('notes: ' + leadObj.Notes__c);
            if(leadObj.Referrer_FName__c!=null || leadObj.Referrer_LName__c !=null || leadObj.Referrer_Email__c!=null){
                opp.Description =' Referrer FName: ' + (leadObj.Referrer_FName__c == null ? '' : leadObj.Referrer_FName__c)
                              + '\n Referrer LName: ' + (leadObj.Referrer_LName__c == null ? '' : leadObj.Referrer_LName__c)
                               + '\n Referrer Email: ' + (leadObj.Referrer_Email__c == null ? '' : leadObj.Referrer_Email__c)
                               + '\n\n' + (leadObj.Description == null ? '' : leadObj.Description);
            } else {
                opp.Description = leadObj.Description;
            }
            opp.StageName = OpportunityHelper.defaultOpportunityStage;
            opp.Timezone__c = strLeadTimeZone;	//Populate oppirtunity timezone from Lead
            if(leadObj.Agent_Email_Address__c != null)
                opp.Agent_Email_Address__c = leadObj.Agent_Email_Address__c; //Added for passing Support Agent e-mail to Opp
            
            if(leadObj.Notes__c != '' && leadObj.Notes__c != null) {
        		noteList.addALL(prepareNoteList(leadObj.Notes__c,opp.Id));
            }
            if(leadNotes != null && leadNotes.size() >0) {
           		noteList.addALL(prepareNoteList(leadNotes,opp.Id));
            }       
		} catch(Exception ex) {} 
    	return  opp;
    }
    
    List<Note> leadNotes = new List<Note>();
    String strLeadTimeZone;
    LeadStatus convertStatus = new LeadStatus();
    public void loadLeadBasicInfo() {
    	try {
    		if(leadObj != null) {
    			leadNotes = [Select  n.Id, n.Title, n.IsPrivate, n.Body From Note n where n.ParentId =:leadObj.Id ];
    			strLeadTimeZone = [Select Timezone__c From Lead where Id =:leadObj.Id].Timezone__c;
				convertStatus = [Select Id, MasterLabel from LeadStatus where IsConverted= true limit 1];	
    		}
    	} catch(Exception ex) {}
    }
    
    public void mapLeadTOQualificationUpdate(Database.LeadConvertResult leadConvertResult) {
    	try {
    		List<Lead_Qualification__c> leadQalObj = new List<Lead_Qualification__c>();
    		if(leadQualificationObj != null && leadQualificationObj.Id != null) {
    			leadQalObj.add(leadQualificationObj);		
    		}	
    		if(leadQalObj != null && leadQalObj.size()>0 && strId != null) {
    			leadQalObj[0].lead__c = null;
    			leadQalObj[0].Account__c = leadConvertResult.getAccountId();
    			leadQalObj[0].opportunity__c = leadConvertResult.getOpportunityId();
    			leadQalObj[0].contact__c = leadConvertResult.getContactId();
    			update leadQalObj[0];
    			/*List<Lead_Qualification__c> leadQualListToDel = [Select Id From Lead_Qualification__c 
									 								where lead__c =:strId AND ID != :leadQalObj[0].ID
									 								AND Account__c = null AND opportunity__c = null   
									 								order by lastModifiedDate desc];*/
				
				List<Lead_Qualification__c> leadQualListToDel = new List<Lead_Qualification__c>();
				for(WrapperLeadQualification leadQualWrObj : wrLeadQualList) {
					if(leadQualWrObj.leadQualObj.Id != leadQalObj[0].ID && leadQualWrObj.leadQualObj.Account__c == null
						&& leadQualWrObj.leadQualObj.opportunity__c == null && leadQualWrObj.leadQualObj.contact__c == null 
						&& leadQualWrObj.leadQualObj.lead__C == strId) {
						Lead_Qualification__c leadQualObjTODel = new Lead_Qualification__c(Id = leadQualWrObj.leadQualObj.Id);
						leadQualListToDel.add(leadQualObjTODel);	
					}
				} 					 								
				if(leadQualListToDel != null && leadQualListToDel.size()>0) {
					delete leadQualListToDel; 		
				}					 								
			}	
    	} catch(Exception ex) {}
    }
    
     public void updateExOpportunityContactRole(Database.LeadConvertResult leadConvertResult) {
    	try {
    		if(leadConvertResult.getOpportunityId()!=null && leadConvertResult.getContactId()!=null){
	    		OpportunityContactRole oppContactRoleObj = [select id,IsPrimary from OpportunityContactRole where 
	    																opportunityId = :leadConvertResult.getOpportunityId() and
	    																contactId = :leadConvertResult.getContactId()
	    																order by isPrimary DESC limit 1];
				if(oppContactRoleObj != null && oppContactRoleObj.id != null) {
					if(!oppContactRoleObj.IsPrimary){
						oppContactRoleObj.isPrimary = true;
						update oppContactRoleObj;
					}
				}else{
					OpportunityContactRole oppConRoleObj = new OpportunityContactRole(ContactId=leadConvertResult.getContactId(),
																					  OpportunityId=leadConvertResult.getOpportunityId(),
																					  isPrimary=true);
					insert oppConRoleObj;
				}
    		}												
    	} catch(Exception ex) {}
    }
    
    public void mapOpportunityContactRole(Database.LeadConvertResult leadConvertResult, Lead_Qualification__c leadQualObj) {
    	try {
    		if(leadQualObj != null && leadQualObj.Id != null) {
    			if(leadQualObj.Decision_Maker_Partner__c == 'Details Below') {
    				Contact contactObj = new Contact();
    				contactObj.AccountId = leadConvertResult.getAccountId();
    				contactObj.FirstName = leadQualObj.Decision_Maker_First_Name__c;
    				contactObj.LastName = leadQualObj.Decision_Maker_Last_Name__c;
    				contactObj.Email = leadQualObj.Decision_Maker_Email__c;
    				contactObj.Phone = leadQualObj.Decision_Maker_Phone__c;
    				contactObj.Title = leadQualObj.Decision_Maker_Business_Title__c;
    				contactObj.RecordTypeId = OpportunityHelper.getOppRecordTypeMap('VAR Visible');
    				insert contactObj;
    				if(contactObj != null && contactObj.id != null) {
    					OpportunityContactRole oppContactRoleObj = new OpportunityContactRole();
    					oppContactRoleObj.OpportunityId = leadConvertResult.getOpportunityId();
    					oppContactRoleObj.ContactId = contactObj.id;
    					oppContactRoleObj.Role = 'Decision Maker';
    					insert oppContactRoleObj;
    				}
    			} else if(leadQualObj.Decision_Maker_Partner__c == 'Same as Contact') {
    				OpportunityContactRole oppContactRoleObj = [select id from OpportunityContactRole where 
    																opportunityId = :leadConvertResult.getOpportunityId() and
    																contactId = :leadConvertResult.getContactId() limit 1];
    				if(oppContactRoleObj != null && oppContactRoleObj.id != null) {
    					oppContactRoleObj.Role = 'Decision Maker';
    					oppContactRoleObj.isPrimary = true;
						update oppContactRoleObj;
    				}												
				}
    		}
    	} catch(exception ex) {}
    }
    
    public Account mapLeadToAccountFields(Account accountObj) {
    	try {
    		if(!String.isBlank(leadObj.Website)){                           
                accountObj.Website = leadObj.Website;
            } 
            if(leadObj.NumberOfEmployees != null){  
                accountObj.NumberOfEmployees = leadObj.NumberOfEmployees;
            }  
            if(!String.isBlank(leadObj.Industry)){                          
                accountObj.Industry = leadObj.Industry;
            } 
            /*if(!String.isBlank(leadObj.NumberOfEmployees__c)) {   
                accountObj.No_of_Employees__c = leadObj.NumberOfEmployees__c;
            }*/
            /*****New Employee Override Field Update*****/
            if(!String.isBlank(leadObj.Effective_No_of_Employees_Range__c)) {   
                accountObj.No_of_Employees__c = leadObj.Effective_No_of_Employees_Range__c;
            }  
            /*******************************************/ 
            if(!String.isBlank(leadObj.Number_of_Locations__c)) { 
                accountObj.Number_Of_Locations__c = leadObj.Number_of_Locations__c;
            }  
            if(!String.isBlank(leadObj.Agent_Email_Address__c)) {
            	accountObj.Agent_Email_Address__c = leadObj.Agent_Email_Address__c;
            }
    	} catch(Exception ex) {}
    	return accountObj;
    }
 
    public Lead getl() {
      return leadObj;
    }
    
    public void setL(Lead value) {
        this.leadObj = value;
    }
    
    public Boolean getCreateNew(){
        return createNew;
    }
   
    public void setCreateNew(Boolean value){
        this.createNew = value;
    }    
   
    
    public Boolean getMultipleSelected(){
        return multiple;
    }
          
    public Boolean getMatchFound(){
        return matchFound;
    }
    
    public Boolean getMatchNotFound(){
        return matchNotFound;
    }    
    
    public Boolean getnotAnswered(){
        return notAnswered;
    } 
    
     //Team India - Sep 02
    public Boolean getInitial_CategoryFlag(){
        return Initial_CategoryFlag;
    } 
    
    public String getstrDebug (){
        return strDebug ;
    } 
    // 
           

    /* This is the wrapper/container class*/
    public class cAccount {
        public Account acc {get; set;}
        public String userID {get; set;}
        public String primaryNumber {get; set;}
        public String acctStatus {get; set;}
        public Boolean selected {get; set;}
        
        /* Constructor */
        public cAccount(Account a, String uID, String priNum, String accStat){
            acc = a;
            userId = uID;
            primaryNumber = priNum; 
            acctStatus = accStat;
            selected = false;
        }
    }
    
     // code added by India team 
 
     public class cOpportunity {
        public Opportunity opportunity {get; set;}
        public String oppName{get; set;}
        public String  owner{get; set;}
        public String  accountName {get; set;}
        public String  status{get; set;}
        public Datetime lastTouchedDate{get; set;}
        public Datetime createdDate{get; set;}
       // public Boolean selected {get; set;}
        
        /* Constructor */
        public cOpportunity(Opportunity o, String oppNm, String own, String accNm, String stat, Datetime createdDt, Datetime lastTouchedDt) {
            opportunity  = o;
            oppName = oppNm;
            owner = own;
            accountName  = accNm;
            status = stat;
            lastTouchedDate = lastTouchedDt;
            createdDate = createdDt;
            //selected = false;
        }
    }
   // code ended by India team 

    
   
   // code added by India team   
	public List<cOpportunity> getOpportunities(){
        return OpportunityList;
    }
    // code ended by India team 
  
  	public List<cAccount> getAccounts(){
        return accountList;
    }
  
  	public List<WrapperLeadQualification> wrLeadQualList {get;set;}
  	public Lead_Qualification__c leadQualificationObj {get;set;}
  	map<Id,Lead_Qualification__c> mapLeadQual = new map<Id,Lead_Qualification__c>();
  	public string selectedLeadQual {get;set;}
  	public boolean toShowViewMode {get;set;}
  	string strId;
  	string rtrl;
  	public void loadLeadQualBasicDet() {
		try {
			List<Lead_Qualification__c> leadQualList = new List<Lead_Qualification__c>();
			leadQualList = getLeadQualList();
			if(leadQualList != null && leadQualList.size() >0) {
				toShowViewMode = true;
				boolean isALreadySelectedMark = false;
				mapLeadQual = new map<Id,Lead_Qualification__c>();
				for(Lead_Qualification__c leadQualObj : leadQualList) {
					WrapperLeadQualification wrLeadQualObj = new WrapperLeadQualification();
					if(!isALreadySelectedMark) {
						wrLeadQualObj.isSelected = true;
					}
					wrLeadQualObj.leadQualObj = leadQualObj;
					DateTime dtMod = leadQualObj.LastModifiedDate;
                    wrLeadQualObj.strformatDT = dtMod.format('dd/MM/yyyy h:mm:ss a');
					wrLeadQualList.add(wrLeadQualObj); 
					mapLeadQual.put(leadQualObj.Id,leadQualObj);
					isALreadySelectedMark = true;
				}
				for(WrapperLeadQualification wrLeadQualObj :wrLeadQualList) {
					if(wrLeadQualObj.isSelected) {
						leadQualificationObj = wrLeadQualObj.leadQualObj;
						selectedLeadQual = wrLeadQualObj.leadQualObj.id;
					}
				}
			} else {
			  }		
		} catch(Exception ex) {}
	}
	
	public List<Lead_Qualification__c> getLeadQualList() {
		wrLeadQualList = new List<WrapperLeadQualification>();
		leadQualificationObj = new Lead_Qualification__c();
		List<Lead_Qualification__c> leadQualList = new List<Lead_Qualification__c>();
		try {
			if(strId.startsWith('00Q')) {
					leadQualList = [Select Pain__c, Name ,Pain_Impact__c, Opportunity__c, Next_Steps_questions__c, Lead__c, LastModifiedDate,  
									 InContract__c, Ideal_Solution__c, Id, Gain__c, Gain_Impact__c, CreatedDate, CompanyInfo__c, Benefits__c, 
									 Account__c, Account__r.Name,Owner.Name,Lead__r.Name,Opportunity__r.Name, Decision_Maker_Partner__c, 
									 Decision_Maker_Phone__c, Decision_Maker_Last_Name__c, Decision_Maker_First_Name__c, 
									 Decision_Maker_Email__c, Decision_Maker_Business_Title__c, Decision_Maker_Alternate_Phone__c
									 From Lead_Qualification__c where IsDeleted  = false and  Lead__c =:strId  
									 order by lastModifiedDate desc];
			
			}
		} catch(Exception ex) {}
		return leadQualList;	
	}
	
	public PageReference loadLeadQualDet() {
		selectedLeadQual =  Apexpages.currentPage().getParameters().get('param1');
		if(selectedLeadQual != null && mapLeadQual != null && mapLeadQual.get(selectedLeadQual) != null) {
			leadQualificationObj = mapLeadQual.get(selectedLeadQual);
		}
		toShowViewMode = true;
		return null;
	}
  
  	public class WrapperLeadQualification {
		public boolean isSelected {get;set;}
		public Lead_Qualification__c leadQualObj {get;set;}
		public string strformatDT {get;set;}
		public WrapperLeadQualification() {
			isSelected = false;
			leadQualObj = new Lead_Qualification__c();
			strformatDT = null;
		}
	}
	/******************************* Mandatory Fields PopUp for 12M Calculation. Added 24th April,14 By Simplion Technologies - Start**********************************/
	
    /********************************************************************************************************************************************
    * @Description : This method saves the Lead mandatory fields which were filled just before lead conversion. Fields are Forecasted Users,RC -*
    *                Tier, RC Brand.                                              																* 
    * @Params      : void                                 				  																		*
    * @Return      : pageReference                                                         														* 
    ********************************************************************************************************************************************/
    public pageReference saveLeadBeforeConversion(){
    	try{
    		if (leadObj != null) {
	    		update leadObj;
	    		showMandatoryFieldPanel = false;
	    	}
	    	pageReference pgRef = new pageReference('/apex/convertLeadVFPage?id='+leadObj.Id);
	    	pgRef.setRedirect(true);
	    	return pgRef;	
    	}catch(Exception e ){
    		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            return null;
    	}
    }
    /********************************************************************************************************************************************
    * @Description : This method validates Lead before conversion. Its checks if Forecasted Users,RC Tier, RC Brand field are not empty. If they* 
    *                are empty then the method makes showMandatoryFieldPanel boolean to true and popup is shown to user to fill those nullfields*
    * @Params      : void                                 				  																		*
    * @Return      : pageReference                                                         														* 
    ********************************************************************************************************************************************/
    public pageReference validateLeadBeforeConversion()	{
    	
    	showMandatoryFieldPanel = (showMandatoryFieldPanel==false || showMandatoryFieldPanel==null ? false : true); // ConvertLead Mandatory field popup Project. Added on 4th April,14
    	if (leadObj != null) { 
            String foreCastedUsers = String.valueOf(leadObj.Number_of_Users__c);
            String rcBrand = String.valueOf(leadObj.Lead_Brand_Name__c);
            String rcTier = String.valueOf(leadObj.Lead_Tier_Name__c);
            if(leadObj.Lead_Brand_Name__c == NULL || leadObj.Lead_Brand_Name__c==''){
            	leadObj.Lead_Brand_Name__c = 'RingCentral';
            	leadObj.Lead_Tier_Name__c = 'Office';			
            }
            if(String.isBlank(foreCastedUsers) || String.isBlank(rcBrand) || String.isBlank(rcTier) ){
                showMandatoryFieldPanel = true;
                impErrorMsg = 'Required field(s) missing.';
                return null;
            } else if(leadObj.Number_of_Users__c == NULL) {
                showMandatoryFieldPanel = true;
                impErrorMsg = 'Forecasted Users is a mandatory field.';
                return null;
            } else if(leadObj.Lead_Brand_Name__c == NULL || leadObj.Lead_Brand_Name__c=='') {
                showMandatoryFieldPanel = true;
                impErrorMsg = 'RC Brand Name is a mandatory field.';
                if(leadObj != null){
                	leadObj.Lead_Brand_Name__c = 'RingCentral';
                	leadObj.Lead_Tier_Name__c = 'Office';			
                }
                return null;
            } else if(leadObj.Lead_Tier_Name__c == NULL || leadObj.Lead_Tier_Name__c=='') {
                showMandatoryFieldPanel = true;
                impErrorMsg = 'RC Tier is a mandatory field.';
                return null;
            }
            
        }
        return null;
    }
    /******************************* Mandatory Fields PopUp for 12M Calculation. Added 24th April,14 By Simplion Technologies - Ends**********************************/
}