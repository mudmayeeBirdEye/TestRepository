/*************************************************
ImplementationMethods class
This Class is used by Account.trigger.
allowImplementation determinds if the accounts campaign wants an implementation to be created.
createImplementations actually creates an implementation with the information provided.
/************************************************/

public with sharing class ImplementationMethods {
	
	public boolean toCreateImplementationOnInsOrUpdRing(Account newAccount, Map<String,Integer> mapAccountImplementation1) {
		system.Debug('>>$>>>'+newAccount.Do_Not_Creation_Implementation__c);
  		if((!String.isBlank(newAccount.RC_Service_Name__c) && newAccount.RC_Service_Name__c.trim().containsIgnoreCase('Office'))
  				&& (newAccount.Number_of_DL_s__c != null && ((newAccount.Number_of_DL_s__c >= 2) || 
  					  (newAccount.Number_of_DL_s__c < 2 && newAccount.Partner_ID__c != null)))  
  				&& (!String.isBlank(newAccount.RC_User_Id__c)) 
  				//&& (!String.isBlank(newAccount.RC_Tier__c) && newAccount.RC_Tier__c.containsIgnoreCase('Office')) 
  				&& (newAccount.RC_Account_Status__c != null 
      				&& (newAccount.RC_Account_Status__c.equalsIgnoreCase('Paid') 
      			 			||  newAccount.RC_Account_Status__c.containsIgnoreCase('Trial')))
  				&& (/*newAccount.Do_Not_Creation_Implementation__c!= null*/  newAccount.Do_Not_Creation_Implementation__c == false)
  				  
  				&& (0 == (mapAccountImplementation1.get(newAccount.Id)== null? 0: mapAccountImplementation1.get(newAccount.Id)))
  				
  		  ) {
  		  		system.debug('#### 23 create Implementation');
      			return true;	 	
  			}	
  		system.debug('#### 26 do not create Implementation');	
		return false;
	}
	
	public boolean toCreateImplementationOnInsOrUpd(Account newAccount) {
		if((!String.isBlank(newAccount.RC_Service_Name__c) && newAccount.RC_Service_Name__c.trim().containsIgnoreCase('Office'))) {
			system.debug('#### 32 create Implementation');
			return true;	
		}
		system.debug('#### 35 do not create Implementation');	
		return false;
	}
	
	public boolean toCreateImplementationOnUpd(Account newAccount,Account oldAccount,Map<String,Integer> mapAccountImplementation1) {
		if( 
			   (String.isBlank(oldAccount.RC_Service_Name__c) || !oldAccount.RC_Service_Name__c.trim().containsIgnoreCase('Office'))
			&& (!String.isBlank(newAccount.RC_Service_Name__c) && newAccount.RC_Service_Name__c.trim().containsIgnoreCase('Office'))
			&& (0 == (mapAccountImplementation1.get(newAccount.Id)== null? 0: mapAccountImplementation1.get(newAccount.Id)))
		  ) {
		  	system.debug('#### 58 create Implementation');
			return true;	
		}
		system.debug('#### 60 do not create Implementation');	
		return false;
	}
	// Account Status = "30-Day Office Trial" 
	public boolean toCreateImplementationOnInsOrUpdOfficeTrials(Account newAccount,Map<String,Integer> mapAccountImplementation1) {
		if((!String.isBlank(newAccount.RC_Account_Status__c) 
				&& newAccount.RC_Account_Status__c.trim().equalsIgnoreCase('30-Day Office Trial')) 
				&& (0 == (mapAccountImplementation1.get(newAccount.Id)== null? 0: mapAccountImplementation1.get(newAccount.Id)))
			)
				{
			return true;	
		}
		return false;
	}
	
	public boolean tocreateImplemetationOnInsorUpdForTELUS(Account newAccount,Map<String,Integer> mapAccountImplementation1) {
		system.Debug('>>$>>>');
		system.debug('>>newAccount.Do_Not_Creation_Implementation__c>>'+newAccount.Do_Not_Creation_Implementation__c);
  		if((!String.isBlank(newAccount.RC_Service_Name__c) && newAccount.RC_Service_Name__c.trim().containsIgnoreCase('Office'))
  				&& (!String.isBlank(newAccount.RC_User_Id__c)) 
  				&& (newAccount.RC_Account_Status__c != null && (newAccount.RC_Account_Status__c.equalsIgnoreCase('Paid') 
      			 			||  newAccount.RC_Account_Status__c.containsIgnoreCase('Trial')))
  				&& (newAccount.Do_Not_Creation_Implementation__c != null && newAccount.Do_Not_Creation_Implementation__c == false)
  				&& (0 == (mapAccountImplementation1.get(newAccount.Id)== null? 0: mapAccountImplementation1.get(newAccount.Id)))
  		  ) {
  		  		system.debug('#### 23 create Implementation');
      			return true;	 	
  			}	
  		system.debug('#### 26 do not create Implementation');
		return false;
	}
	
	 //*********************************----- Method for implementation BT by simplion 11th dec 2014 -------------*******************/
     
     public boolean tocreateImplemetationOnInsorUpdForBT(Account newAccount,Map<String,Integer> mapAccountImplementation1) {
        //system.Debug('>>$>>>');
        //system.debug('>>newAccount.Do_Not_Creation_Implementation__c>>'+newAccount.Do_Not_Creation_Implementation__c);
        if((!String.isBlank(newAccount.RC_Service_Name__c) && newAccount.RC_Service_Name__c.trim().containsIgnoreCase('Office'))
                && (!String.isBlank(newAccount.RC_User_Id__c)) 
                && (newAccount.RC_Account_Status__c != null && (newAccount.RC_Account_Status__c.equalsIgnoreCase('Paid')))                          
                && (newAccount.Do_Not_Creation_Implementation__c != null && newAccount.Do_Not_Creation_Implementation__c == false)
                && (0 == (mapAccountImplementation1.get(newAccount.Id)== null? 0: mapAccountImplementation1.get(newAccount.Id)))
          ) {
                //system.debug('#### 23 create Implementation');
                return true;        
            }   
        system.debug('#### 26 do not create Implementation');
        return false;
    }
    
	
	/**************** OFFice Trial Lead **************/
	
	public boolean chkToCreateLeadForOfficeTrails(Account newAccount, map<Id,Account> accountMap) {
		if(!String.isBlank(newAccount.Service_Type__c) && newAccount.Service_Type__c.equalsIgnoreCase('Office') && 
			(!String.isBlank(newAccount.RC_Account_Status__c) && newAccount.RC_Account_Status__c.trim().equalsIgnoreCase('Trial 30 CC')) && 
			 accountMap != null && accountMap.get(newAccount.id) != null &&
			 accountMap.get(newAccount.id).Opportunities.size() == 0 &&
			(UserCustomSettingHelper.userRCSFName(accountMap.get(newAccount.id).CreatedBy.Name)) 
   			) {
			return true;	
		} else {
			return false;
		}
	}
	
	public boolean checkTocreateLeadOfficeTrail(Account newAccount,map<Id,Account> accountMap) {
		if(!String.isBlank(newAccount.Service_Type__c) && newAccount.Service_Type__c.equalsIgnoreCase('Office') && 
			(!String.isBlank(newAccount.RC_Account_Status__c) && newAccount.RC_Account_Status__c.trim().equalsIgnoreCase('Trial 30 CC')) && 
				/*(accountMap.get(newAccount.id).CreatedBy.Name == UserRC.rcsfSyncUserObj.name 
					|| accountMap.get(newAccount.id).CreatedBy.Name == UserRC.rcPartnerSyncUserObj.name  
					|| accountMap.get(newAccount.id).CreatedBy.Name == UserRC.indiaTeamUserObj.name)*/
					(UserCustomSettingHelper.userRCSFName(accountMap.get(newAccount.id).CreatedBy.Name))) {
				return true;
		}
		return false;
	}
	
	public Lead createLeadOfficeTrail(Account accObj,Map<Id,Account> accountMap) {
		try {
			Lead leadObj = new Lead();
			leadObj.LeadSource = 'Office Trials';
			leadObj.Account__c = accObj.id;
			system.debug('accountMap.get(accObj.id).AccountContactRoles '+accountMap.get(accObj.id).AccountContactRoles );
			if(accountMap.get(accObj.id).AccountContactRoles != null && accountMap.get(accObj.id).AccountContactRoles.size()>0) {
				AccountContactRole accountContactRoleObj = accountMap.get(accObj.id).AccountContactRoles;
				leadObj.Email = accountContactRoleObj.Contact.Email;
				leadObj.Phone = accountContactRoleObj.Contact.Phone;
				leadObj.LastName = accountContactRoleObj.Contact.LastName;
				leadObj.Company = accountContactRoleObj.Account.name;
				/*******************************Updating Lead number Of Employees field *****************************************/
				system.debug('@@@ >>>. '+accountContactRoleObj.Contact.NumberOfEmployees__c);
				system.debug('@@@ >>>. '+accountContactRoleObj.Account.No_of_Employees__c);
				if(accountContactRoleObj.Contact.NumberOfEmployees__c != null){
					leadObj.NumberOfEmployees__c = accountContactRoleObj.Contact.NumberOfEmployees__c;
				}else if(accountContactRoleObj.Account.No_of_Employees__c != null){
					leadObj.NumberOfEmployees__c = accountContactRoleObj.Account.No_of_Employees__c;
				}
				/************************************************************************/
				String sUrlRewrite = System.URL.getSalesforceBaseUrl().getHost();
				System.Debug('>>>sUrlRewrite>>>'+sUrlRewrite);
				//sUrlRewrite = 'https://' + sUrlRewrite.substring(0,sUrlRewrite.indexOf('.')-1) + 'salesforce.com' + '/' + newAccount.id;
				sUrlRewrite = 'https://' + sUrlRewrite + '/' + accObj.id;
				leadObj.Description = 'Office Free Trial Account Signup - Link to Account '+ sUrlRewrite;
				return leadObj;
			} else if(accountMap.get(accObj.id).contacts != null && accountMap.get(accObj.id).contacts.size()>0) {
				system.debug('@@@ ELSE Part >>>');
				Contact contObj = accountMap.get(accObj.id).contacts.get(0);
				leadObj.Email = contObj.Email;
				leadObj.Phone = contObj.Phone;
				leadObj.LastName = contObj.LastName;
				leadObj.Company = contObj.Account.name; 
				/*******************************Updating Lead number Of Employees field *****************************************/
				if(contObj.NumberOfEmployees__c != null){
					leadObj.NumberOfEmployees__c = contObj.NumberOfEmployees__c;
				}else if(contObj.Account.No_of_Employees__c != null){
					leadObj.NumberOfEmployees__c = contObj.Account.No_of_Employees__c;
				}
				/************************************************************************/
				//leadObj.NumberOfEmployees__c =  contObj.Account.No_of_Employees__c;
				String sUrlRewrite = System.URL.getSalesforceBaseUrl().getHost();
				System.Debug('>>>sUrlRewrite>>>'+sUrlRewrite);
				//sUrlRewrite = 'https://' + sUrlRewrite.substring(0,sUrlRewrite.indexOf('.')-1) + 'salesforce.com' + '/' + newAccount.id;
				sUrlRewrite = 'https://' + sUrlRewrite + '/' + accObj.id;
				leadObj.Description = 'Office Free Trial Account Signup - Link to Account '+ sUrlRewrite;
				return leadObj;
			} else {
				system.debug('### fake Lead Created');
				leadObj.Email = 'fake@fake.com';
				leadObj.LastName = 'fakeLead';
				leadObj.Company = accObj.Name;
				if(accObj != null && accObj.No_of_Employees__c != null) {
					leadObj.NumberOfEmployees__c = accObj.No_of_Employees__c;
				}
				system.debug('### LeadObj'+leadObj);
				return leadObj;
			}
		} catch(Exception ex) {}
		return null;		
	}
	
	/**************** OFFice Trial Lead **************/
	
	/***********************VAR Survey on Account Activation *********************************/
	
	public map<string,Account> getPartnerAccountContactMap(List<Account> accountList) {
		map<string,Account> partneraccountMap = new map<string,Account>();
		try {
			Set<string> partnerIdSet = new set<string>();
			for(Account accobj:accountList) {
				if(accobj.Partner_ID__c != null) {
					partnerIdSet.add(accobj.Partner_ID__c);
				}
			}
			if(partnerIdSet != null && partnerIdSet.size()>0) {
				for(Account accObj : [select Partner_ID__c,(select Id,email from contacts) from account 
										where Partner_ID__c IN :partnerIdSet and RecordType.Name = 'Partner Account']) {					// type = 'Partner'
				 	partneraccountMap.put(accObj.Partner_ID__c,accObj);
				}	
			}
		} catch(Exception ex) {}
		return partneraccountMap;
	}
	
	
	///-------------------------------As/Simplion/5/11/2015----------------------------------------------
	public static List<Survey__c> createVARSurveyOnAccountUpdate(List<Account> newList,Map<Id,Account> oldMap,Map<Id,Account> allAccountsMapAfterQuery,Map<String,Account> partnerAccountContactMap){
		List<Survey__c> surveyListTOInsert = new List<Survey__c> ();
		String SALES_AGENT_RESELLERS = 'Sales Agents & Resellers';
		for(Account newAcc : newList){
			Account oldAccount = oldMap.get(newAcc.Id);
			if(newAcc.Is_Demo_Account__c == false && 
				  	(!String.isBlank(newAcc.RC_Attribution_Channel__c) && SALES_AGENT_RESELLERS.equalsIgnoreCase(newAcc.RC_Attribution_Channel__c)) && 
					oldAccount.RC_Activation_Date__c == null && newAcc.RC_Activation_Date__c != null) { 
					if(allAccountsMapAfterQuery != null && 
					   allAccountsMapAfterQuery.get(newAcc.id) != null && 
					   allAccountsMapAfterQuery.get(newAcc.id).Surveys__r != null && 
					   allAccountsMapAfterQuery.get(newAcc.id).Surveys__r.size() == 0 &&
							partnerAccountContactMap != null && !String.isBlank(newAcc.Partner_ID__c) && 
							partnerAccountContactMap.get(newAcc.Partner_ID__c) != null && 
							partnerAccountContactMap.get(newAcc.Partner_ID__c).contacts != null) {
						System.debug('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~In Surevey test before 1');
						List<Contact> partnerAccountContactList = partnerAccountContactMap.get(newAcc.Partner_ID__c).contacts;  
						Survey__c survObj = new Survey__c();
			      		survObj.SurveyType__c = 'VAR Customer';
			      		survObj.Account__c = newAcc.Id;
			      		survObj.Agent__c = newAcc.OwnerId;
						survObj.Agent_Email__c = allAccountsMapAfterQuery.get(newAcc.id).Owner.Email;
						survObj.Agent_Name__c = allAccountsMapAfterQuery.get(newAcc.id).Owner.Name;
						survObj.Agent_Team__c = allAccountsMapAfterQuery.get(newAcc.id).Owner.Team__c;
						survObj.Agent_Manager_Name__c = allAccountsMapAfterQuery.get(newAcc.id).Owner.Manager.Name;
						survObj.Agent_Manager_Email__c = allAccountsMapAfterQuery.get(newAcc.id).Owner.Manager.Email;
						survObj.Name = 'VAR Customer' +' - ' + Datetime.now().format();	
			      		if(allAccountsMapAfterQuery.get(newAcc.id).AccountContactRoles != null && 
			      				allAccountsMapAfterQuery.get(newAcc.id).AccountContactRoles.size()>0) {
			      			AccountContactRole accountContactRoleObj = allAccountsMapAfterQuery.get(newAcc.id).AccountContactRoles;
			      			if(partnerAccountContactList != null && partnerAccountContactList.size()>0) {
			      				if(!String.isBlank(accountContactRoleObj.Contact.Email)) {
			      					string emaildomain = (accountContactRoleObj.Contact.Email).split('@')[1];
			      					boolean domainMatches = false;
			      					for(Contact contactObj : partnerAccountContactList) {
			      						if(!string.isBlank(contactObj.email) && contactObj.email.split('@')[1] == emaildomain) {
			      							domainMatches = true;
			      							break; 
			      						}
			      					}
			      					if(!domainMatches) {
			      						survObj.Contact__c = accountContactRoleObj.Contact.id;
										survObj.Contact_Email__c = accountContactRoleObj.Contact.Email;
										break;
			      					}
				      			}
			      			}		
			      		}else if(allAccountsMapAfterQuery.get(newAcc.id).Contacts != null && 
			      					allAccountsMapAfterQuery.get(newAcc.id).Contacts.size()>0) {
			      			List<Contact> contList = allAccountsMapAfterQuery.get(newAcc.id).Contacts;
			      			if(partnerAccountContactList != null && partnerAccountContactList.size()>0) {
			      				for(Contact contactObjAcc : contList) {
			      					if(!string.isBlank(contactObjAcc.Email)) {
			      						string emaildomain = (contactObjAcc.Email).split('@')[1];
			      						boolean domainMatches = false;
			      						for(Contact contactPartnerObj : partnerAccountContactList) {
				      						if(!string.isBlank(contactPartnerObj.email) && contactPartnerObj.email.split('@')[1] == emaildomain) {
				      							domainMatches = true;
				      							break; 
				      						}
			      						}
			      						if(!domainMatches) {
				      						survObj.Contact__c = contactObjAcc.id;
											survObj.Contact_Email__c = contactObjAcc.Email;
											break;	
			      						}
			      					}	
			      				}
			      			}
			      		}
			      		if(survObj != null) {
							surveyListTOInsert.add(survObj);    
						}
					}
				}
			}
			return surveyListTOInsert;
	}
	
	public Survey__c createVARSurveyOnAccountActivation(Account accObj,Map<Id,Account> accountMap,list<Contact> contactPartnerList) {
		System.debug('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~In Surevey test1');
		try {
			Survey__c survObj = new Survey__c();
      		survObj.SurveyType__c = 'VAR Customer';
      		survObj.Account__c = accObj.Id;
      		survObj.Agent__c = accObj.OwnerId;
			survObj.Agent_Email__c = accountMap.get(accObj.id).Owner.Email;
			system.debug('accountMap.get(accObj.id).Owner.Email '+accountMap.get(accObj.id).Owner.Email);
			system.debug('accountMap.get(accObj.id).Owner.Name '+accountMap.get(accObj.id).Owner.Name);
			survObj.Agent_Name__c = accountMap.get(accObj.id).Owner.Name;
			survObj.Agent_Team__c = accountMap.get(accObj.id).Owner.Team__c;
			survObj.Agent_Manager_Name__c = accountMap.get(accObj.id).Owner.Manager.Name;
			survObj.Agent_Manager_Email__c = accountMap.get(accObj.id).Owner.Manager.Email;
			survObj.Name = 'VAR Customer' +' - ' + Datetime.now().format();	
      		if(accountMap.get(accObj.id).AccountContactRoles != null && 
      				accountMap.get(accObj.id).AccountContactRoles.size()>0) {
      					System.debug('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~In Surevey test2');
      			AccountContactRole accountContactRoleObj = accountMap.get(accObj.id).AccountContactRoles;
      			if(contactPartnerList != null && contactPartnerList.size()>0) {
      				System.Debug('>>11>>');
      				if(!String.isBlank(accountContactRoleObj.Contact.Email)) {
      					string emaildomain = (accountContactRoleObj.Contact.Email).split('@')[1];
      					boolean domainMatches = false;
      					for(Contact contactObj : contactPartnerList) {
      						if(!string.isBlank(contactObj.email) && contactObj.email.split('@')[1] == emaildomain) {
      							domainMatches = true;
      							break; 
      						}
      					}
      					if(!domainMatches) {
      						survObj.Contact__c = accountContactRoleObj.Contact.id;
							survObj.Contact_Email__c = accountContactRoleObj.Contact.Email;
							return survObj;	
      					}
	      			}
      			}		
      		} 
      		if(accountMap.get(accObj.id).Contacts != null && 
      					accountMap.get(accObj.id).Contacts.size()>0) {
      						System.debug('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~In Surevey test3');
      			List<Contact> contList = accountMap.get(accObj.id).Contacts;
      			if(contactPartnerList != null && contactPartnerList.size()>0) {
      				System.Debug('>>22>>');
      				for(Contact contactObjAcc : contList) {
      					if(!string.isBlank(contactObjAcc.Email)) {
      						string emaildomain = (contactObjAcc.Email).split('@')[1];
      						System.Debug('>>23>>'+emaildomain);
      						boolean domainMatches = false;
      						for(Contact contactPartnerObj : contactPartnerList) {
	      						if(!string.isBlank(contactPartnerObj.email) && contactPartnerObj.email.split('@')[1] == emaildomain) {
	      							System.Debug('>>24>>'+ contactPartnerObj.email);
	      							domainMatches = true;
	      							break; 
	      						}
      						}
      						if(!domainMatches) {
	      						survObj.Contact__c = contactObjAcc.id;
								survObj.Contact_Email__c = contactObjAcc.Email;
								return survObj;	
      						}
      					}	
      				}
      			}
      		}
   		} catch(Exception ex) {
   			System.debug(new TriggerException('Exception in createVARSurveyOnAccountActivation method in Implementation method Class triggered From Account After Trigger !!'));
   		} 
		return null;
	}
	
	/***********************VAR Survey on Account Activation ********************************/
	/*
	allowImplementation takes an Account and using its attribution fields finds the matching campaign.
	It returns the value of the campaigns Create Implementations checkbox
	If no matching campaign is found then we return true to always create an implementation. 
	*/
	
	public Map<Id,Boolean> allImplementationMap(List<Account> accountList) {
		Map<Id,Boolean> allImpMapRtn = new Map<Id,Boolean>();
		map<string,boolean> partnerIdTOAllImpMap = new  map<string,boolean>();
		try {
			set<Id> accountIdSet = new set<Id>();
			set<String> partnerIdSet = new set<string>();
			
			for(Account accObj : accountList) {
				accountIdSet.add(accObj.Id);
				if(accObj.Partner_ID__c != null && accObj.Partner_ID__c != '') {
					partnerIdSet.add(accObj.Partner_ID__c);
				}				
			}
			
			List<Account> accListPartner = new List<Account>(); 
			if(partnerIdSet != null && partnerIdSet.size()>0) {
				RecordType rt = [SELECT Id FROM RecordType WHERE Name = 'Partner Account'];
				accListPartner = [select Id,Do_Not_Creation_Implementation__c,Partner_ID__c from Account 
												where Partner_ID__c IN :partnerIdSet AND RecordTypeId =:rt.Id
												AND Do_Not_Creation_Implementation__c = true AND ID NOT IN :accountIdSet];
			}
			
			for(Account accObj : accListPartner) {
				System.Debug('>>4>>');
				partnerIdTOAllImpMap.put(accObj.Partner_ID__c,accObj.Do_Not_Creation_Implementation__c);
			}
			
			for(Account accObj : accountList) {
				if(partnerIdTOAllImpMap != null && partnerIdTOAllImpMap.size()>0 && accObj.Partner_ID__c != null && accObj.Partner_ID__c != '' && 
					partnerIdTOAllImpMap.containskey(accObj.Partner_ID__c)) {
					System.Debug('>>1>>');	
					boolean allowImp = partnerIdTOAllImpMap.get(accObj.Partner_ID__c); 
					if(allowImp == true) {
						allImpMapRtn.put(accObj.Id,false);
					} else if(allowImp == false) {
						allImpMapRtn.put(accObj.Id,true);
					}
				} else {
					System.Debug('>>2>>');
					allImpMapRtn.put(accObj.Id,true);
				}
			}
			accListPartner = null;									
		} catch(Exception ex) {}
		return allImpMapRtn; 
	}
	
	public Map<Id, Integer> accountToOppMap(Set<Id> accountIds) {
		Map<Id, Integer> premiumImpAccMap = new Map<Id, Integer>();
		try {
			for(Account accObj: [Select (Select Is_Premium_Implementation_Required__c From Opportunities WHERE 
								  Is_Premium_Implementation_Required__c=true AND StageName IN : OpportunityHelper.closedStagesSet AND 
								  recordTypeId =: OpportunityHelper.getOppRecordTypeMap('Sales Opportunity')) From Account 
		  						  WHERE Id IN: accountIds]) {
		  	  		premiumImpAccMap.put(accObj.id, accObj.Opportunities.size());
		  	}
		} catch(Exception e){}
		return premiumImpAccMap; 
	}
	
	/* 
	createImplementations takes in Account and string value of what type of Implementation to create
	*/ 
	public void createImplementations(Account a, Map<Id, Contact> contactMap, Implementation__c imp){
		//imp.Name = a.Name + ' - ' + Datetime.now().format();
		//imp.Name = a.Name + ' - ' + Datetime.now().format();
		// below logic is changed to handle exception raised due to >80 length chars account name
		//Set<String> strSetRCSF = UserCustomSettingHelper.getRCSFSync(UserRC.rcsfSyncUserObj.name);
		if(UserCustomSettingHelper.getRCSFSync(UserRC.rcsfSyncUserObj.name) !=null){
			String name = a.Name;
			String str = a.Name + ' - ' + Datetime.now().format();
			Integer strLength = (str).length();
			if(strLength > 80) {
				Integer dateLength = (' - ' +Datetime.now().format()).length();
				name = (a.Name).substring(0, (80-dateLength));
			}
			imp.Name = name + ' - ' + Datetime.now().format();				
			imp.office_service_change_date__c = Date.today();
			imp.Account__c = a.Id;
			// imp.Type__c = impType;
			imp.Brand__c = a.RC_Brand__c;
			imp.Tier__c = a.RC_Tier__c;
			imp.Service__c = a.RC_Service_Name__c;
			if(UserRC.getRCSFSyncPrimaryOwnerId != null){
				imp.OwnerId = UserRC.getRCSFSyncPrimaryOwnerId;
			}else{
				imp.OwnerId = Userinfo.getUserId();	
			}
			imp.Account_Signup_Date__c = a.RC_Signup_Date__c;
			imp.Contact__c = contactMap != null && contactMap.get(a.Id) != null ? contactMap.get(a.Id).Id : null;
			try {
				insert imp;
			} catch(Exception e) {}
			system.debug('AFTER IMP INSERT, ID: ' + imp.Id);			
		}
	}
	/*
		Created on June 14, 2011
		This method is used for reusablity of the lead assignment logic as per in Account And Contact_After Trigger
    	Here we used to set the lead object's data members on the basis of Account and Contact attributes.
    */
 	public Lead createLead(Account acct, Map<Id, Contact> contactMap, Lead newLead) {
    	Contact c = contactMap.get(acct.Id);
	 	if(c != null) {
	        newLead.Phone = c.Phone;
	        newLead.LastName = c.LastName;
	        newLead.FirstName = c.FirstName;
	        newLead.Email = c.Email;
	        
	        //Populate additional field as mentioned in E-mail on 6/2/2011,while creating Lead 
	        newLead.Account_Status__c = acct.RC_Account_Status__c;
	        newLead.Account_Number__c = acct.RC_Account_Number__c;
	        newLead.User_ID__c = acct.RC_User_ID__c;
	        newLead.Lead_Tier_Name__c = acct.RC_Tier__c;
	        newLead.RC_Service_name__c = acct.RC_Service_name__c;
	        newLead.Lead_Brand_Name__c = acct.RC_Brand__c;
	        // if the resultant email or last name is null or empty, need to fix it with temp values as fake@email.com and account name respectively.
	        //Below two fields are mandatory on Lead object, so need to provice some value is still unpopulated
	        newLead.Email = ( newLead.Email == null || newLead.Email.trim().length() == 0 ? 'fake@email.com' : newLead.Email );
	        newLead.LastName = ( newLead.LastName == null || newLead.LastName.trim().length() == 0 ? acct.Name : newLead.LastName );
	        newLead.Company = acct.Name;
	        newLead.Status = 'Open - Not Contacted';
	         if(c.NumberOfEmployees__c != null){
				system.debug('@@@ c.NumberOfEmployees__c >>> '+c.NumberOfEmployees__c);
				newLead.NumberOfEmployees__c = c.NumberOfEmployees__c ;
			}else if(acct.No_of_Employees__c != null){
				system.debug('@@@ acct.No_of_Employees__c  >>> '+acct.No_of_Employees__c );
				newLead.NumberOfEmployees__c = acct.No_of_Employees__c;
			}
	    }
    	return newLead; 	
    }
	/************************* Canceled trials without hardware return *********************/
	public boolean chkToHardwareRtnOnDeactivation(Account accObjNew, Account accObjOld) {
		if(!string.isBlank(accObjNew.Service_Type__c) && accObjNew.Service_Type__c.containsIgnoreCase('Office') && 
			accObjOld.RC_Account_Status__c != accObjNew.RC_Account_Status__c && 
			!string.isBlank(accObjOld.RC_Account_Status__c) && !string.isBlank(accObjNew.RC_Account_Status__c) && 
			(accObjOld.RC_Account_Status__c.equalsIgnoreCase('Trial 7 CC') || accObjOld.RC_Account_Status__c.equalsIgnoreCase('Trial 30 CC') ||
				 accObjOld.RC_Account_Status__c.equalsIgnoreCase('Trial 30 no-CC') || accObjOld.RC_Account_Status__c.equalsIgnoreCase('Trial (other)'))
			&& accObjNew.RC_Account_Status__c.equalsIgnoreCase('Disabled')) {
			return true;
		} 
		return false;
	}
	/***************************************************************************************/
	
	
	// Optimised method for creating Account Implementation 9th April 2014.
	public void createAccountImplementation(Map<Id, Implementation__c> accountImplementationMap, Map<Id, Account> accountMap,  Map<Id, Contact> contactMap){
		try{
			// below logic is changed to handle exception raised due to >80 length chars account name
			if(UserCustomSettingHelper.getRCSFSync(UserRC.rcsfSyncUserObj.name) !=null){
				
				List<Implementation__c>	bucketImplementaionList =  new List<Implementation__c>();			
				for(Id accountId : accountImplementationMap.keySet()){
					Account thisAccount = accountMap.get(accountId);
					if(thisAccount != null) {
						String name = thisAccount.Name;
						String str = thisAccount.Name + ' - ' + Datetime.now().format();
						Integer strLength = (str).length();
						if(strLength > 80) {
							Integer dateLength = (' - ' +Datetime.now().format()).length();
							name = (thisAccount.Name).substring(0, (80-dateLength));
						}
						Implementation__c imp =  new Implementation__c();
						if(accountImplementationMap.get(thisAccount.Id) != null){
							imp = accountImplementationMap.get(thisAccount.Id);
						}
						imp.Name = name + ' - ' + Datetime.now().format();
						imp.office_service_change_date__c = Date.today();
						imp.Account__c = thisAccount.Id;
						imp.Brand__c = thisAccount.RC_Brand__c;
						imp.Tier__c = thisAccount.RC_Tier__c;
						imp.Service__c = thisAccount.RC_Service_Name__c;
						// Logic for setting the owner Id.
						if(UserRC.getRCSFSyncPrimaryOwnerId != null){
							imp.OwnerId = UserRC.getRCSFSyncPrimaryOwnerId;
						}else{
							imp.OwnerId = Userinfo.getUserId();	
						}
						imp.Account_Signup_Date__c = thisAccount.RC_Signup_Date__c;
						imp.Contact__c = (contactMap == null || contactMap.get(thisAccount.Id) == null ? null : contactMap.get(thisAccount.Id).Id);
	
						bucketImplementaionList.add(imp);
						System.debug('########bucketImplementaionList#####'+bucketImplementaionList);
						
					}
				}
				// Flag for bypassing Trigger
				TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT();
				TriggerHandler.BY_PASS_ACCOUNT_ON_UPDATE();
					
				if(bucketImplementaionList != null && !bucketImplementaionList.isEmpty()){
					insert bucketImplementaionList;
				}
			}
		} catch(Exception e) {
			System.debug('createAccountImplementation @ '+e.getlineNumber());
			System.debug('#### createAccountImplementation '+e.getMessage()); 
		}
	}
	
	// Optimised code to create Account Lead, 9th April 2014
	public Map<Id, Lead> createAccountLead( Map<Id, Lead> mapAccountLead, Map<Id, Account> mapAccount, Map<Id, Contact> contactMap){
		
		Map<Id, Lead> newAccountLeadMap =  new Map<Id, Lead>();
		try{	
			for(Account thisAccount : mapAccount.values()){
				Lead newLead = new Lead();
				if(mapAccountLead.get(thisAccount.Id) != null){
					newLead = mapAccountLead.get(thisAccount.Id);
				}
				if(contactMap != null && !contactMap.isEmpty() && contactMap.containsKey(thisAccount.Id) && contactMap.get(thisAccount.Id) != null){
					Contact contactObj = contactMap.get(thisAccount.Id);
				 	if(contactObj != null) {
				        newLead.Phone = contactObj.Phone;
				        newLead.LastName = contactObj.LastName;
				        newLead.FirstName =contactObj.FirstName;
				        newLead.Email = contactObj.Email;
				        
				        //Populate additional field as mentioned in E-mail on 6/2/2011,while creating Lead.
				        newLead.Account_Status__c = thisAccount.RC_Account_Status__c;
				        newLead.Account_Number__c = thisAccount.RC_Account_Number__c;
				        newLead.User_ID__c = thisAccount.RC_User_ID__c;
				        newLead.Lead_Tier_Name__c = thisAccount.RC_Tier__c;
				        newLead.RC_Service_name__c = thisAccount.RC_Service_name__c;
				        newLead.Lead_Brand_Name__c = thisAccount.RC_Brand__c;
				        if(contactObj.NumberOfEmployees__c != null){
							newLead.NumberOfEmployees__c = contactObj.NumberOfEmployees__c;
						}else if(contactObj.Account.No_of_Employees__c != null){
							newLead.NumberOfEmployees__c = contactObj.Account.No_of_Employees__c;
				        }
				        
		        		/* If the resultant email or last name is null or empty, 
		        		   need to fix it with temp values as fake@email.com and account name respectively.
		         		   Below two fields are mandatory on Lead object, so need to provice some value is still unpopulated */
				        newLead.Email = ( newLead.Email == null || newLead.Email.trim().length() == 0 ? 'fake@email.com' : newLead.Email );
				        newLead.LastName = ( newLead.LastName == null || newLead.LastName.trim().length() == 0 ? thisAccount.Name : newLead.LastName );
				        newLead.Company = thisAccount.Name;
				        newLead.Status = 'Open - Not Contacted';	
				    }
				    newAccountLeadMap.put(thisAccount.Id,newLead);
				}
			}
		}catch (Exception ex){
			System.debug('Error @ createAccountLead line -  '+ex.getlineNumber());
            System.debug('Error @ createAccountLead message - '+ex.getMessage());	
		}
		return newAccountLeadMap;
	}
	
	public  Map<Id, Contact> getContactAccountMap(Map<Id, Account> accountMap) {
		Map<Id, Contact> contactMap = new Map<Id, Contact>();
		try {
			for(Contact contactObj : [SELECT Id, accountId,(Select Id, AccountId, ContactId, Role, IsPrimary From AccountContactRoles where isPrimary=true ), FirstName, LastName, Email, NumberOfEmployees__c, Phone,Account.No_of_Employees__c FROM Contact WHERE accountId IN :accountMap.keySet()]) {
				if(contactMap.get(contactObj.accountId) == null) {
					contactMap.put(contactObj.accountId, contactObj);
				}
			}
		} catch(Exception e) {}
		return contactMap;
	}	
	
	 // OLD METHODS NOT IN USE BELOW.
	 
	 /*
	 public boolean toCreateImplementationOnUpd(Account newAccount,Account oldAccount) {//only used in test method
		if( 
			   (String.isBlank(oldAccount.RC_Service_Name__c) || !oldAccount.RC_Service_Name__c.trim().containsIgnoreCase('Office'))
			&& (!String.isBlank(newAccount.RC_Service_Name__c) && newAccount.RC_Service_Name__c.trim().containsIgnoreCase('Office'))
			     
		  ) {
		  	system.debug('#### 45 create Implementation');
			return true;	
		}
		system.debug('#### 35 do not create Implementation');	
		return false;
	}
	*/
	// Account Status = "30-Day Office Trial" -- End
	
	/*public boolean chkToCreateLeadForOfficeTrails(Account newAccount, map<Id,Account> accountMap) {
		if(toCreateImplementationOnInsOrUpdOfficeTrials(newAccount) 
   			&& accountMap != null && accountMap.get(newAccount.id) != null 
   			&& accountMap.get(newAccount.id).Opportunities.size() == 0) {
			return true;	
		} else {
			return false;
		}
	}
	
	public Lead createLeadOfficeTrail(Account accObj,Map<Id,Account> accountMap) {
		try {
			Lead leadObj = new Lead();
	  	 	leadObj.LeadSource = 'Office Trials';
	  	 	if(accountMap.get(accObj.id).AccountContactRoles != null && accountMap.get(accObj.id).AccountContactRoles.size()>0) {
	  	 		AccountContactRole accountContactRoleObj = accountMap.get(accObj.id).AccountContactRoles;
	  	 		leadObj.Email = accountContactRoleObj.Contact.Email;
	  	 		leadObj.Phone = accountContactRoleObj.Contact.Phone;
	  	 		leadObj.LastName = accountContactRoleObj.Contact.LastName;
	  	 		leadObj.Company = accountContactRoleObj.Account.name; 
	  	 		String sUrlRewrite = System.URL.getSalesforceBaseUrl().getHost();
	  	 		System.Debug('>>>sUrlRewrite>>>'+sUrlRewrite);
	        	//sUrlRewrite = 'https://' + sUrlRewrite.substring(0,sUrlRewrite.indexOf('.')-1) + 'salesforce.com' + '/' + newAccount.id;
	        	sUrlRewrite = 'https://' + sUrlRewrite + '/' + accObj.id;
	  	 		leadObj.Description = 'Office Free Trial Account Signup - Link to Account '+ sUrlRewrite;
	  	 		return leadObj;
	  	 	} else if(accountMap.get(accObj.id).contacts != null && accountMap.get(accObj.id).contacts.size()>0) {
	  	 		Contact contObj = accountMap.get(accObj.id).contacts;
	  	 		leadObj.Email = contObj.Email;
	  	 		leadObj.Phone = contObj.Phone;
	  	 		leadObj.LastName = contObj.LastName;
	  	 		leadObj.Company = contObj.Account.name; 
	  	 		String sUrlRewrite = System.URL.getSalesforceBaseUrl().getHost();
	  	 		System.Debug('>>>sUrlRewrite>>>'+sUrlRewrite);
	        	//sUrlRewrite = 'https://' + sUrlRewrite.substring(0,sUrlRewrite.indexOf('.')-1) + 'salesforce.com' + '/' + newAccount.id;
	        	sUrlRewrite = 'https://' + sUrlRewrite + '/' + accObj.id;
	  	 		leadObj.Description = 'Office Free Trial Account Signup - Link to Account '+ sUrlRewrite;
	  	 		return leadObj;
	  	 	}
		} catch(Exception ex) {}
		return null;		
	}*/
	
	/*
	public boolean toCreateImplementationOnInsOrUpdOfficeTrials(Account newAccount) { // not in used
		if((!String.isBlank(newAccount.RC_Account_Status__c) 
				&& newAccount.RC_Account_Status__c.trim().equalsIgnoreCase('30-Day Office Trial')) 
			)
				{
			return true;	
		}
		return false;
	}
	*/
	/*
	
	public Survey__c createVARSurveyOnAccountActivation(Account accObj,Map<Id,Account> accountMap) {
		try {
			Survey__c survObj = new Survey__c();
      		survObj.SurveyType__c = 'VAR Customer';
      		survObj.Account__c = accObj.Id;
      		survObj.Agent__c = accObj.OwnerId;
      		system.debug('accountMap.get(accObj.id)'+accountMap.get(accObj.id));
			survObj.Agent_Email__c = accountMap.get(accObj.id).Owner.Email;
			survObj.Agent_Name__c = accountMap.get(accObj.id).Owner.Name;
			survObj.Agent_Team__c = accountMap.get(accObj.id).Owner.Team__c;
			survObj.Agent_Manager_Name__c = accountMap.get(accObj.id).Owner.Manager.Name;
			survObj.Agent_Manager_Email__c = accountMap.get(accObj.id).Owner.Manager.Email;
			survObj.Name = 'VAR Customer' +' - ' + Datetime.now().format();	
      		if(accountMap.get(accObj.id).AccountContactRoles != null && 
      				accountMap.get(accObj.id).AccountContactRoles.size()>0) {
      			AccountContactRole accountContactRoleObj = accountMap.get(accObj.id).AccountContactRoles;		
      			survObj.Contact__c = accountContactRoleObj.Contact.id;
				survObj.Contact_Email__c = accountContactRoleObj.Contact.Email;
				return survObj;
      		} else if(accountMap.get(accObj.id).Contacts != null && 
      					accountMap.get(accObj.id).Contacts.size()>0) {
      			Contact contObj = accountMap.get(accObj.id).Contacts;
      			survObj.Contact__c = contObj.id;
				survObj.Contact_Email__c = contObj.Email;
				return survObj;
      		}
   		} catch(Exception ex) {} 
		return null;
	}
	*/
	/*
	public Boolean allowImplemenation(Account a){
		Campaign c;
		
		system.debug('THIS IS Account BMID/PID/AID: ' + a.BMID__c + '/' + a.PID__c + '/' + 'a.AID__c');
		//CHanges has been made after the implementaion of PRM as we are now not having BMID for PRM records
        String PID = a.Partner_ID__c;
        if(PID != null && PID != '') { 
        try {
        	/*a = [select Do_Not_Creation_Implementation__c from Account 
            where Partner_ID__c =: PID and type = 'Partner'];*/
            /*RecordType rt = [SELECT Id FROM RecordType WHERE Name='Partner Account'];
            
            a = [select Do_Not_Creation_Implementation__c from Account where Partner_ID__c =: PID AND RecordTypeId =:rt.Id LIMIT 1];
             system.debug('THIS IS a:' + a);
            if(a != null){
                if(a.Do_Not_Creation_Implementation__c == true)
                {                   
                    return false;
                     system.debug('THIS IS a:' + a);
                }else{
                    return true;
                     system.debug('THIS IS a:' + a);
                }               
            }
        	} catch(Exception e) {}       
        }
  		return true;
	}
	*/
	/*
	public void createImplementations(Account a, String impType){
		Implementation__c imp = new Implementation__c();
		//imp.Name = a.Name + ' - ' + Datetime.now().format();
		//imp.Name = a.Name + ' - ' + Datetime.now().format();
		// below logic is changed to handle exception raised due to >80 length chars account name
		//Set<String> strSetRCSF = UserCustomSettingHelper.getRCSFSync(UserRC.rcsfSyncUserObj.name);
		if(UserCustomSettingHelper.getRCSFSync(UserRC.rcsfSyncUserObj.name) !=null){
			String name = a.Name;
			String str = a.Name + ' - ' + Datetime.now().format();
			Integer strLength = (str).length();
			if(strLength > 80) {
				Integer dateLength = (' - ' +Datetime.now().format()).length();
				name = (a.Name).substring(0, (80-dateLength));
			}
			imp.Name = name + ' - ' + Datetime.now().format();				
			imp.office_service_change_date__c = Date.today();
			imp.Account__c = a.Id;
			imp.Type__c = impType;
			imp.Brand__c = a.RC_Brand__c;
			imp.Tier__c = a.RC_Tier__c;
			imp.Service__c = a.RC_Service_Name__c;
			if(UserRC.getRCSFSyncPrimaryOwnerId != null){
				imp.OwnerId = UserRC.getRCSFSyncPrimaryOwnerId;
			}else{
				imp.OwnerId = Userinfo.getUserId();	
			}
			//if(strSetRCSF != null)
			//	imp.OwnerId = [SELECT Id FROM User WHERE name IN: strSetRCSF].Id;
			imp.Account_Signup_Date__c = a.RC_Signup_Date__c;
			try{
				imp.Contact__c = [SELECT Id FROM Contact WHERE accountId=:a.Id Limit 1].Id;
			}
			catch(System.QueryException e){
			}
			insert imp;
			system.debug('AFTER IMP INSERT, ID: ' + imp.Id);			
		}
	}
	*/
	/*
	public void createImplementations(Account a, Map<Id, Contact> contactMap, String impType) {
		try{
			Implementation__c imp = new Implementation__c();
			//imp.Name = a.Name + ' - ' + Datetime.now().format();
			//imp.Name = a.Name + ' - ' + Datetime.now().format();
			// below logic is changed to handle exception raised due to >80 length chars account name
			//Set<String> strSetRCSF = UserCustomSettingHelper.getRCSFSync(UserRC.rcsfSyncUserObj.name);
			// below logic is changed to handle exception raised due to >80 length chars account name
			if(UserCustomSettingHelper.getRCSFSync(UserRC.rcsfSyncUserObj.name) !=null){
				String name = a.Name;
				String str = a.Name + ' - ' + Datetime.now().format();
				Integer strLength = (str).length();
				if(strLength > 80) {
					Integer dateLength = (' - ' +Datetime.now().format()).length();
					name = (a.Name).substring(0, (80-dateLength));
				}
				imp.Name = name + ' - ' + Datetime.now().format();				
				imp.office_service_change_date__c = Date.today();
				imp.Account__c = a.Id;
				imp.Type__c = impType;
				imp.Brand__c = a.RC_Brand__c;
				imp.Tier__c = a.RC_Tier__c;
				imp.Service__c = a.RC_Service_Name__c;
				//imp.OwnerId = [SELECT Id FROM User WHERE name IN:strSetRCSF ].Id;
				// Logic for setting the owner Id.
				if(UserRC.getRCSFSyncPrimaryOwnerId != null){
					imp.OwnerId = UserRC.getRCSFSyncPrimaryOwnerId;
				}else{
					imp.OwnerId = Userinfo.getUserId();	
				}
				imp.Account_Signup_Date__c = a.RC_Signup_Date__c;
				imp.Contact__c = (contactMap == null || contactMap.get(a.Id) == null ? null : contactMap.get(a.Id).Id);
				insert imp;
				system.debug('AFTER IMP INSERT, ID: ' + imp.Id);	
			}	
		}catch(Exception e) {
			System.debug('createAccountImplementation @ '+e.getlineNumber());
			System.debug('#### createAccountImplementation '+e.getMessage()); 
		}	
	}
	*/
	/*
	public Lead createLead(Account acct, Lead newLead) {
	 	for(Contact c : [SELECT FirstName, LastName, Email,NumberOfEmployees__c,Account.No_Of_Employees__c, Phone FROM Contact WHERE AccountId =: acct.Id LIMIT 1]) {
	        newLead.Phone = c.Phone;
	        newLead.LastName = c.LastName;
	        newLead.FirstName = c.FirstName;
	        newLead.Email = c.Email;
	        if(c.NumberOfEmployees__c!= Null){
				newLead.NumberOfEmployees__c = c.NumberOfEmployees__c;
			}else if(c.Account.No_of_Employees__c != Null){
			   	newLead.NumberOfEmployees__c = c.Account.No_of_Employees__c;
			}
	    }
     	//Populate additional field as mentioned in E-mail on 6/2/2011,while creating Lead 
        newLead.Account_Status__c = acct.RC_Account_Status__c;
        newLead.Account_Number__c = acct.RC_Account_Number__c;
        newLead.User_ID__c = acct.RC_User_ID__c;
        newLead.Lead_Tier_Name__c = acct.RC_Tier__c;
        newLead.RC_Service_name__c = acct.RC_Service_name__c;
        newLead.Lead_Brand_Name__c = acct.RC_Brand__c;
        // if the resultant email or last name is null or empty, need to fix it with temp values as fake@email.com and account name respectively.
        //Below two fields are mandatory on Lead object, so need to provice some value is still unpopulated
        newLead.Email = ( newLead.Email == null || newLead.Email.trim().length() == 0 ? 'fake@email.com' : newLead.Email );
        newLead.LastName = ( newLead.LastName == null || newLead.LastName.trim().length() == 0 ? acct.Name : newLead.LastName );
        
        newLead.Company = acct.Name;
        newLead.Status = 'Open - Not Contacted';
        return newLead;
    }
	*/
}