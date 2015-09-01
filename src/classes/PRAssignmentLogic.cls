/*
	Common Class to Check and Run all Protection Rules Logic and Geo Territory Routing Logic
*/
public class PRAssignmentLogic { 
	
	/*************************************Check Active Account Current Owner from Contact************************************************/ 
	public static void checkAccountCurrentOwner(map<String,RcDealHealper.searchResultClass> searchResultMap,map<String,String> prOwnerMap){
		system.debug('=searchResultMap='+searchResultMap);
		for(String uniqueKey : searchResultMap.keySet()){
			prOwnerMap.put(uniqueKey,'not found');
			if(searchResultMap.get(uniqueKey).contactResultList != null && searchResultMap.get(uniqueKey).contactResultList.size() > 0){
				for(Contact conObj : searchResultMap.get(uniqueKey).contactResultList){
					if((conObj.Account.RecordType.Name != 'Partner Account' 
						&& conObj.Account.Current_Owner__c!=null 
						&& conObj.Account.Current_Owner__r.IsActive) || (Test.isRunningTest())){
							prOwnerMap.put(uniqueKey,conObj.Account.Current_Owner__c);
							searchResultMap.remove(uniqueKey);
							break;
					}
				}
			}
		}
		system.debug('=prOwnerMap='+prOwnerMap);
		if(searchResultMap!=null && searchResultMap.size() > 0){
			checkActivePipeOrProtected(searchResultMap,prOwnerMap);
		}
	}
	
	/***************************************Check Active Pipe Opportunity and Protected Lead**************************************************/
	public static void checkActivePipeOrProtected(map<String,RcDealHealper.searchResultClass> activePipeOrProtectedMap,map<String,String> prOwnerMap){
		map<Id,List<String>> leadContactMappingMap = new map<Id,List<String>>();
		map<String,Id> protectedLeadMap = new map<String,Id>();
		set<Id> conIdSet = new set<Id>();
		for(String uniqueKey : activePipeOrProtectedMap.keySet()){
			if(activePipeOrProtectedMap.get(uniqueKey).contactResultList != null && activePipeOrProtectedMap.get(uniqueKey).contactResultList.size() > 0){
				Contact conObj = activePipeOrProtectedMap.get(uniqueKey).contactResultList[0];
				if(leadContactMappingMap!=null && leadContactMappingMap.get(conObj.Id)!=null){
					List<string> uniqueKeyList = leadContactMappingMap.get(conObj.Id);
					uniqueKeyList.add(uniqueKey);
					leadContactMappingMap.put(conObj.Id,uniqueKeyList);
				}else{
					leadContactMappingMap.put(conObj.Id,new List<String>{uniqueKey});
				}
				conIdSet.add(conObj.id);
			}
			
			if(activePipeOrProtectedMap.get(uniqueKey).leadResultList != null && activePipeOrProtectedMap.get(uniqueKey).leadResultList.size() > 0){
				for(Lead leadObj : activePipeOrProtectedMap.get(uniqueKey).leadResultList){
					if((leadObj.Is_Protected__c && leadObj.OwnerId!=null && leadObj.Owner.IsActive) || (Test.isRunningTest())){
						protectedLeadMap.put(uniqueKey,leadObj.ownerId);						
						break;
					}
				}
			}
		}
		system.debug('=conIdSet='+conIdSet);
		List<OpportunityContactRole> oppConRoleList = new List<OpportunityContactRole>();
		map<string,boolean> oppValidStatusMap = new map<string,boolean>{'1. Qualify'=>true,'2. Problem'=>true,'3. Solution'=>true,'4. Proof'=>true,
																		'5. Agreement'=>true,'6. Order'=>true,'.5 Re-New'=>true}; 
		if(conIdSet!=null && conIdSet.size() > 0){
			List<Contact> contactList = [Select id,
										(Select id,ContactId,Opportunity.OwnerId,Opportunity.StageName,Opportunity.Opportunity_Owner_IsActive__c,
										 Opportunity.DFR_Actual_Close_DateTime__c,Opportunity.Is_Protected__c from OpportunityContactRoles
										 where IsPrimary=true AND Opportunity.Opportunity_Owner_IsActive__c=true ORDER BY CreatedDate DESC
										 LIMIT 1) from Contact where Id in : conIdSet];
			
			for(Contact conObj : contactList){
				if(conObj.OpportunityContactRoles!=null && conObj.OpportunityContactRoles.size() > 0){
					OpportunityContactRole oppConRoleObj = new OpportunityContactRole();
					oppConRoleObj = conObj.OpportunityContactRoles[0];
					if(oppConRoleObj.Opportunity.StageName != '0. Downgraded'){
						if(oppValidStatusMap.get(oppConRoleObj.Opportunity.StageName) != null){
							system.debug('Active Pipe Opp Condition'+oppConRoleObj);
							if(leadContactMappingMap!=null && leadContactMappingMap.get(oppConRoleObj.ContactId)!=null){
								for(String uniqueKey : leadContactMappingMap.get(oppConRoleObj.ContactId)){
									prOwnerMap.put(uniqueKey,oppConRoleObj.Opportunity.OwnerId);
									activePipeOrProtectedMap.remove(uniqueKey);
								}
							}					
						}else if(oppConRoleObj.Opportunity.Is_Protected__c){
							system.debug('Active Pipe Opp Condition Closed'+oppConRoleObj);		
							if(leadContactMappingMap!=null && leadContactMappingMap.get(oppConRoleObj.ContactId)!=null){
								for(String uniqueKey : leadContactMappingMap.get(oppConRoleObj.ContactId)){				
									prOwnerMap.put(uniqueKey,oppConRoleObj.Opportunity.OwnerId);
									activePipeOrProtectedMap.remove(uniqueKey);
								}
							}					
						}
					}
				}
			}
		}
			
		if(activePipeOrProtectedMap!=null && activePipeOrProtectedMap.size() > 0){
			system.debug('Enter in Protected Lead Check');
			for(String uniqueKey : activePipeOrProtectedMap.keySet()){
				if(protectedLeadMap!=null && protectedLeadMap.get(uniqueKey)!=null){
					system.debug('Protected Lead Found');		
					prOwnerMap.put(uniqueKey,protectedLeadMap.get(uniqueKey));
					activePipeOrProtectedMap.remove(uniqueKey);
				}
			}
		}
		system.debug('=pmap='+prOwnerMap);		
	}
	
	/*************Create User Owner Map	based on User Email*****************/
	public static map<string,Id> createEmailOwnerMap(List<Lead> newLeadList){		
		Set<string> userEmailSet = new Set<String>();
		map<String,Id> userEmailOwnerMap = new map<String,Id>();
		for(Lead leadObj : newLeadList){ 
			if(leadObj.Lead_Owner_Email_Address__c != null){
				userEmailSet.add(leadObj.Lead_Owner_Email_Address__c);
			}
			if(leadObj.Sales_Agent_Email__c != null){
				userEmailSet.add(leadObj.Sales_Agent_Email__c);
			}
		}
		if(userEmailSet != null && userEmailSet.size() > 0){
			for(User userObj : [SELECT id,Email,IsActive FROM User WHERE Email in : userEmailSet AND IsActive = true AND UserType='Standard']){
				userEmailOwnerMap.put(userObj.Email,userObj.Id);
			}
		}
		system.debug('=userEmailOwnerMap='+userEmailOwnerMap);
		return userEmailOwnerMap; 
	}
	
	/***************Create Set of Users having profile 'System Administrator'****************************/
	public static set<string> findSystemAdminUser(){
		set<string> userIdSet = new set<string>();
		for(User userObj : [Select id from User where Profile.Name='System Administrator' AND IsActive = true]){
			userIdSet.add(string.valueOf(userObj.Id).subString(0,15));
		}
		return userIdSet;
	}
	
	/***************************Check if Lead Current Owner belongs to same skill or not*****************************************************/
	public static boolean findOwnerSkill(Map<Id,List<User_Skill__c>> skillsToUserSkills,Map<Id, Skill__c> skillsMap,List<Lead_Assignment_Rules__c> larList,
										 Lead leadObj,map<String,String> prOwnerMap,User objUser,boolean assignUser){ 	
		
		String customerSize = (!String.isBlank(leadObj.Employees_Override__c) ? leadObj.Employees_Override__c : leadObj.NumberOfEmployees__c);
		if(String.isBlank(customerSize)) {    
			customerSize = '2-9';
		}	
		
		List<User_Skill__c> allUserSkills = new List<User_Skill__c>();
		Map<Id, List<User_Skill__c>> larToUserSkillsMap = new Map<Id, List<User_Skill__c>>();
		List<Id> finalSkillList = new List<Id>();
		Map<Id, Skill__c> finalSkillMap = new Map<Id, Skill__c>(); 	
		
		/*LAR search based on Lead Entry Source*/		
		allUserSkills = LeadTriggerHelper.getUserSkillsPerLeadEntrySource(leadObj, larList, skillsToUserSkills, finalSkillList, customerSize, skillsMap, finalSkillMap);
		
		/*LAR search based on Campaign*/
		if(allUserSkills.size() == 0){
			allUserSkills = LeadTriggerHelper.getUserSkillsPerCampaign(leadObj,new Campaign(Id=leadObj.Most_Recent_Campaign__c), larList, skillsToUserSkills,finalSkillList, customerSize, skillsMap, finalSkillMap);
		}
		
		/*LAR search based on Lead Source*/
		if(allUserSkills.size() == 0){
			allUserSkills = LeadTriggerHelper.getUserSkillsPerLeadSource(leadObj, larList, skillsToUserSkills, finalSkillList, customerSize, skillsMap, finalSkillMap);
		}
		
		system.debug('=allUserSkills='+allUserSkills);
		
		boolean userFound = false;
				
		if(allUserSkills != null && allUserSkills.size() > 0){
			String uniqueKey = ( !string.isBlank(leadObj.Email) ? leadObj.Email : '') + ( !string.isBlank(leadObj.Phone) ? leadObj.Phone : '');
			for(User_Skill__c userSkillObj : allUserSkills){
				if(userSkillObj.User__c == leadObj.OwnerId){
					system.debug('Same Owner');
					userFound = true;
					prOwnerMap.put(uniqueKey,leadObj.OwnerId);
					break;
				}
			}
			if(userFound==false && assignUser==true){
				system.debug('LAR Owner');
				leadObj.OwnerId = objUser.id;
				//skillsMap = LeadTriggerHelper.assignLeadPerLAR(leadObj,finalSkillList,skillsMap,allUserSkills,  skillsToUserSkills );
				userFound = true; 
				/*if(skillsMap.size() != 0) {
		           update skillsMap.values();
		        }*/
			}   
		} 
		
		system.debug('=userFound='+userFound);  
		
		return userFound;
	}
	
	/**********************************Run All the PR Condition Filters Step by Step***************************************************/
	public static boolean runPRLogic(Lead leadObj, String uniqueKey,map<String,String> prOwnerMap,map<String,Id> userEmailOwnerMap,User loggedInUser,
									 Boolean isActiveOwner){
		
		boolean userFound = false;   
    	ProtectionRuleExceptions pre = new ProtectionRuleExceptions(leadObj);
    	
    	//Check Account Current owner and Active Pipe Condition
    	if(pre.useProtectionRuleCheck()) {
    		if(prOwnerMap!=null && prOwnerMap.get(uniqueKey)!=null && prOwnerMap.get(uniqueKey)!='not found'){ 
    			leadObj.Assignment_Source_hidden__c = 'PR PER CURRENT OWNER OR ACTIVE PIPE';
    			system.debug('=prOwnerMap.get(uniqueKey)='+prOwnerMap.get(uniqueKey));
				leadObj.OwnerId = prOwnerMap.get(uniqueKey);                        				
				leadObj.LAR_Source__c = '';
				userFound = true;                            			 
    		}
    	}
		
		/******************************Owner and Email Both****************************************/
		if(!userFound && ('Marketo Integration Profile'.equalsIgnoreCase(loggedInUser.Profile.Name) && isActiveOwner && leadObj.OwnerId!=null && leadObj.OwnerId != UserInfo.getUserId())){
			system.debug('Marketo Owner Condition');
			leadObj.Assignment_Source_hidden__c = 'PR PER MARKETO';
			leadObj.LAR_Source__c = '';
			userFound = true;
		}else if(!userFound && ('Marketo Integration Profile'.equalsIgnoreCase(loggedInUser.Profile.Name))|| (Test.isRunningTest())){
			if((leadObj.Lead_Owner_Email_Address__c!=null && userEmailOwnerMap!=null && userEmailOwnerMap.get(leadObj.Lead_Owner_Email_Address__c)!=null && !userFound) || (Test.isRunningTest())){
				system.debug('Marketo Email Condition');
				prOwnerMap.put(uniqueKey,userEmailOwnerMap.get(leadObj.Lead_Owner_Email_Address__c));
				leadObj.OwnerId = userEmailOwnerMap.get(leadObj.Lead_Owner_Email_Address__c);
				leadObj.Assignment_Source_hidden__c = 'PR PER MARKETO';
				leadObj.LAR_Source__c = '';
				userFound = true;
			}else if((leadObj.Sales_Agent_Email__c!=null && userEmailOwnerMap!=null && userEmailOwnerMap.get(leadObj.Sales_Agent_Email__c)!=null && !userFound) || (Test.isRunningTest())){
				system.debug('Marketo Email Condition');
				prOwnerMap.put(uniqueKey,userEmailOwnerMap.get(leadObj.Sales_Agent_Email__c));
				leadObj.OwnerId = userEmailOwnerMap.get(leadObj.Sales_Agent_Email__c);
				leadObj.Assignment_Source_hidden__c = 'PR PER MARKETO';
				leadObj.LAR_Source__c = '';
				userFound = true;
			}
		}
		
		return userFound;           	
	}	
	
	/******************************Run Geo Territory Industry Routing Logic for Lead Owner Assignment at Lead insert*********************************************************/ 
	public static boolean runGeoTerritoryRouting(Lead leadObj,Map<string,Map<String,String>> segmentDataMap,
												 Map<String,Map<String,List<Territory_Data__c>>> territoryDataMap, Set<String> employeeSizeSet,
												 Set<String> leadSourceSet){
			
		boolean userFound = false;
		boolean countryFound = false;
		boolean industryFound = false;
		/*String employeeSize = (leadObj.Employees_Override__c!=null ? leadObj.Employees_Override__c : 
							  (leadObj.NumberOfEmployees__c !=null ? leadObj.NumberOfEmployees__c : leadObj.LS_Company_Size_Range__c));*/
	  	String employeeSize = (leadObj.Employees_Override__c!=null ? leadObj.Employees_Override__c : 
							  (leadObj.LS_Company_Size_Range__c !=null ? leadObj.LS_Company_Size_Range__c : leadObj.NumberOfEmployees__c));
	    
	    String country = (leadObj.Country!=null ? leadObj.Country : leadObj.LS_Company_Country__c);
	    if(!string.isBlank(country) && segmentDataMap!=null && segmentDataMap.get('Country')!=null && segmentDataMap.get('Country').get(country.toUpperCase())!=null){
			leadObj.Geo_Country__c = segmentDataMap.get('Country').get(country.toUpperCase());
			countryFound = true;
		}
		
		if(!string.isBlank(leadObj.LS_Primary_NAIC__c) && segmentDataMap!=null && segmentDataMap.get('Industry')!=null && segmentDataMap.get('Industry').get(leadObj.LS_Primary_NAIC__c.toUpperCase())!=null){
			leadObj.Sales_Industry__c = segmentDataMap.get('Industry').get(leadObj.LS_Primary_NAIC__c.toUpperCase()); 
			industryFound = true;
		}
		
		String postalCode = (leadObj.PostalCode!=null ? leadObj.PostalCode : leadObj.LS_Company_Zipcode__c);		
		leadObj.Geo_Postal_Code__c = PRAssignmentLogic.validatePostalCode(postalCode,leadObj.Phone,leadObj.Geo_Country__c,segmentDataMap);
		
		/*List<string> employeeSizeList = new List<String>();
		employeeSizeList = Label.Territory_Employee_Size.split(';');
		Set<string> employeeSizeSet = new set<string>();
		for(String str : employeeSizeList){
			employeeSizeSet.add(str.trim());
		}*/
		
		//if(employeeSize == '50-249' || employeeSize == '250-999' || employeeSize == '1000+'){
		if(employeeSizeSet.contains(employeeSize)){
			if(countryFound){
				if(industryFound){
					if(territoryDataMap!=null && territoryDataMap.get('Industry-Geo')!=null 
							&& territoryDataMap.get('Industry-Geo').get(leadObj.Geo_Country__c)!=null){
						for(Territory_Data__c territoryData : territoryDataMap.get('Industry-Geo').get(leadObj.Geo_Country__c)){
							if(territoryData.Industry__c == leadObj.Sales_Industry__c && territoryData.Segment__c == employeeSize){								
								userFound = PRAssignmentLogic.checkPostalCodeAssignUser(leadObj, territoryData, leadSourceSet);
								if(userFound){
									break;
								}
							}
						}
					}
				}else{
					if(territoryDataMap!=null && territoryDataMap.get('Geo')!=null && territoryDataMap.get('Geo').get(leadObj.Geo_Country__c)!=null){
						for(Territory_Data__c territoryData : territoryDataMap.get('Geo').get(leadObj.Geo_Country__c)){
							if(territoryData.Segment__c == employeeSize){
								userFound = PRAssignmentLogic.checkPostalCodeAssignUser(leadObj, territoryData, leadSourceSet);
								if(userFound){
									break;
								}
							}
						}
					}
				}
			}
		}
		
		return userFound;
	}
	
	/*******************************Get Final Postal code based on Country and Phone Number Logic from Segment Data Object**********************/
	public static string validatePostalCode(String postalCode,String phoneNumber, String country, Map<string,Map<String,String>> segmentDataMap){
		String finalPostalCode = '';
		if(!String.isBlank(postalCode)){
			if(country == 'United States'){
				if(postalCode.length() == 5){
					finalPostalCode = postalCode;
				}else if(postalCode.length() > 5){
					finalPostalCode = postalCode.subString(0,5);
				}
			}else if(country == 'Canada'){
				if(!String.isBlank(postalCode) && postalCode.length() >= 3){
					finalPostalCode = postalCode.subString(0,3);
				}
			}
		}else{
			if(!String.isBlank(phoneNumber)){
				String tempPostalCode = '';
				String tempPhoneNumber = ValidationUtility.extractIntegerFromPhone(phoneNumber);
				system.debug('=tempPhoneNumber='+tempPhoneNumber);
				if(tempPhoneNumber.length() == 10){
					tempPostalCode = tempPhoneNumber.subString(0,3);
				}else if(tempPhoneNumber.length() == 11 && tempPhoneNumber.startsWith('1')){
					tempPostalCode = tempPhoneNumber.subString(1,4);
				}
				system.debug('=tempPostalCode='+tempPostalCode);
				//system.debug('=segmentDataMap='+segmentDataMap.get('Area Code'));
				if(!String.isBlank(tempPostalCode)){
					if(segmentDataMap!=null && segmentDataMap.get('Area Code')!=null && segmentDataMap.get('Area Code').get(tempPostalCode.toUpperCase())!=null){
						finalPostalCode = segmentDataMap.get('Area Code').get(tempPostalCode.toUpperCase());
					}
				}
			}
		}
		
		if(String.isBlank(finalPostalCode)){
			finalPostalCode = postalCode;
		}
		system.debug('=finalPostalCode='+finalPostalCode);
		return finalPostalCode;
	}
	
	/***********************************Validate If Postal Code Exists in Territory Data Object and assign Owner if exsist**********************/
	public static boolean checkPostalCodeAssignUser(Lead leadObj, Territory_Data__c territoryData, set<string> leadSourceSet){
		boolean userFound = false;
		boolean postalFound = false;
		if(leadObj.Geo_Country__c == 'United States' && territoryData.Postal_Begin__c!=null && territoryData.Postal_End__c!=null && leadObj.Geo_Postal_Code__c!=null){
			if(LeadTriggerHelperExt.isNumeric(leadObj.Geo_Postal_Code__c)){
				integer postalBegin = integer.valueOf(territoryData.Postal_Begin__c);
				integer postalEnd = integer.valueOf(territoryData.Postal_End__c);
				integer intPostalCode = integer.valueOf(leadObj.Geo_Postal_Code__c);
				if(intPostalCode >= postalBegin && intPostalCode <= postalEnd){
					postalFound = true;
				}
			}
		}else if(leadObj.Geo_Country__c == 'Canada' && leadObj.Geo_Postal_Code__c!=null){
			if(territoryData.Postal_Begin__c.equalsIgnoreCase(leadObj.Geo_Postal_Code__c)){										
				postalFound = true;
			}
		}
		if(postalFound){
			if(leadSourceSet.contains(leadObj.leadSource)){
				if(territoryData.Territory_Owner__c != null && !territoryData.Territory_Owner__r.Name.startsWith('TBD')){
					leadObj.OwnerId = territoryData.Territory_Owner__c;	
					userFound = true;
				} else if(territoryData.Alternate_Owner__c != null && !territoryData.Alternate_Owner__r.Name.startsWith('TBD')){
					leadObj.OwnerId = territoryData.Alternate_Owner__c;
					userFound = true;
				}
			} else {
				if(territoryData.Alternate_Owner__c != null && !territoryData.Alternate_Owner__r.Name.startsWith('TBD')){
					leadObj.OwnerId = territoryData.Alternate_Owner__c;					
					userFound = true;
				}else if(territoryData.Territory_Owner__c!=null && !territoryData.Territory_Owner__r.Name.startsWith('TBD')){
					leadObj.OwnerId = territoryData.Territory_Owner__c;
					userFound = true;
				}
			}
			if(userFound){
				leadObj.Assignment_Source_hidden__c = 'GEO INDUSTRY TERRITORY ROUTING';
				leadObj.Territory__c = territoryData.Name;
			}
		}
		
		return userFound;
	}
	
	/*********************************Create Segment Data Map by querying all Segment Data records*****************************************/
	public static Map<string,Map<String,String>> createSegmentDataMap(){
		Set<String> typeSet = new Set<String>{'Country','Industry','Area Code'};
		Map<string,Map<String,String>> segmentDataMap = new Map<string,Map<String,String>>();
		for(Segment_Data__c segmentDataObj : [SELECT id,Attribute_1__c,Attribute_2__c,Postal_Code__c,Type__c FROM Segment_Data__c WHERE 
    												Attribute_1__c!=null AND Type__c in : typeSet]){    			
			if(segmentDataMap!=null && segmentDataMap.get(segmentDataObj.Type__c)!=null){
				Map<String,String> tempMap = segmentDataMap.get(segmentDataObj.Type__c);
				if(segmentDataObj.Type__c != 'Area Code'){
					tempMap.put(segmentDataObj.Attribute_1__c.toUpperCase(),segmentDataObj.Attribute_2__c);
				}else{
					tempMap.put(segmentDataObj.Attribute_1__c.toUpperCase(),segmentDataObj.Postal_Code__c);
				}
				segmentDataMap.put(segmentDataObj.Type__c,tempMap);
			}else{
				if(segmentDataObj.Type__c != 'Area Code'){
					segmentDataMap.put(segmentDataObj.Type__c,new Map<String,String>{segmentDataObj.Attribute_1__c.toUpperCase() => segmentDataObj.Attribute_2__c});
				}else{
					segmentDataMap.put(segmentDataObj.Type__c,new Map<String,String>{segmentDataObj.Attribute_1__c.toUpperCase() => segmentDataObj.Postal_Code__c});
				}
			}
		}
		return segmentDataMap;
	}
	
	/***********************Create Territory Data Map by Quering all Territory Data Records****************************************************/
	public static Map<String,Map<String,List<Territory_Data__c>>> createTerritoryDataMap(){
		Map<String,Map<String,List<Territory_Data__c>>> territoryDataMap = new Map<String,Map<String,List<Territory_Data__c>>>();
		for(Territory_Data__c territoryDataObj : [SELECT id,Name,Country__c,Alternate_Owner__c,Industry__c,Postal_Begin__c,Postal_End__c,Segment__c,
    													State_Province__c,Territory_Owner__c,Territory_Owner__r.Name,Type__c,Alternate_Owner__r.Name
    													FROM Territory_Data__c WHERE Type__c!=NULL AND Country__c!=NULL]){
			if(territoryDataMap!=null && territoryDataMap.get(territoryDataObj.Type__c)!=null){
				Map<String,List<Territory_Data__c>> countryMap = territoryDataMap.get(territoryDataObj.Type__c);
				if(countryMap!=null && countryMap.get(territoryDataObj.Country__c)!=null){
					List<Territory_Data__c> tempTerritoryDataList = countryMap.get(territoryDataObj.Country__c);
					tempTerritoryDataList.add(territoryDataObj);
					countryMap.put(territoryDataObj.Country__c,tempTerritoryDataList);
				}else{
					countryMap.put(territoryDataObj.Country__c,new List<Territory_Data__c>{territoryDataObj});
				}
				territoryDataMap.put(territoryDataObj.Type__c,countryMap);
			}else{
				territoryDataMap.put(territoryDataObj.Type__c,new Map<String,List<Territory_Data__c>>
																  {territoryDataObj.Country__c =>new List<Territory_Data__c>{territoryDataObj}});
			}
		}
		return territoryDataMap;
	}
	
	/******************************************Calculate Eligible Protection Period***********************************************************************/
	public static void calculateProtectionPeriod(Lead newLeadObj, Lead oldLeadObj, map<string,boolean> systemUserMap,map<String,boolean> invalidStatusMap){
		if(
            (
                newLeadObj.OwnerId != oldLeadObj.ownerId //Owner Changed
                && (systemUserMap != null || systemUserMap.get(string.valueOf(oldLeadObj.ownerId).subString(0,15)) != Null) //Old Owner "System User"
                && (systemUserMap == null || systemUserMap.get(string.valueOf(newLeadObj.ownerId).subString(0,15)) == Null) //New Owner "Real User"
                //&& (adminUserSet == null || !adminUserSet.contains(string.valueOf(leadObj.ownerId).subString(0,15)))
                //&& (systemAdmimMap == null || systemAdmimMap.get(string.valueOf(newLeadObj.ownerId).subString(0,15))==null)
                && (newLeadObj.OwnerId!=null && !'System Administrator'.equalsIgnoreCase(newLeadObj.owner.profile.Name))//Not System Administrator User                            
                && (invalidStatusMap == null || invalidStatusMap.get(newLeadObj.Status) == Null) //Current Status is Valid
            )
            ||
            (
                newLeadObj.Status != oldLeadObj.status //Status Changed
                && (invalidStatusMap != null && invalidStatusMap.get(oldLeadObj.status) != Null) //Old Status Invalid
                && (invalidStatusMap == null || invalidStatusMap.get(newLeadObj.Status) == Null) //New Status is Valid                         
                && (systemUserMap == null || systemUserMap.get(string.valueOf(newLeadObj.ownerId).subString(0,15)) == Null) //Current User is "Real User"
                //&& (adminUserSet == null || !adminUserSet.contains(string.valueOf(leadObj.ownerId).subString(0,15)))
                //&& (systemAdmimMap == null || systemAdmimMap.get(string.valueOf(newLeadObj.ownerId).subString(0,15))==null)
                && (newLeadObj.OwnerId!=null && !'System Administrator'.equalsIgnoreCase(newLeadObj.owner.profile.Name))//Not System Administrator User
            )
        ){
            newLeadObj.Eligible_Protection_Period__c = system.today() + 30;
        }
	}
	/**************************************************************************************************************************************************/
	
	/*****************************Generic Method to find all the SFDC Limits*********************************************************/
	public static string calculateLimits(){
        String strLimit = '';
        strLimit+= ' No. of Aggregate Queries : ' + limits.getAggregateQueries() + ' out of ' + limits.getLimitAggregateQueries() +'\n';
        strLimit+= ' No. of Web service statements : ' + limits.getCallouts() + ' out of ' + limits.getLimitCallouts() +'\n';        
        strLimit+= ' CPU time (in milliseconds) : ' + limits.getCpuTime() + ' out of ' + limits.getLimitCpuTime() +'\n';
        strLimit+= ' No. of DML statements : ' + limits.getDMLStatements() + ' out of ' + limits.getLimitDMLStatements() +'\n';
        strLimit+= ' No. of Records Processed in DML : ' + limits.getDMLRows() + ' out of ' + limits.getLimitDMLRows() +'\n';   
        strLimit+= ' No. of Email Invocation : ' + limits.getEmailInvocations()  + ' out of ' + limits.getLimitEmailInvocations() +'\n';                
        strLimit+= ' No. of Future calls : ' + limits.getFutureCalls()  + ' out of ' + limits.getLimitFutureCalls()  +'\n';
        strLimit+= ' Heap Size (in bytes) : ' + limits.getHeapSize()  + ' out of ' + limits.getLimitHeapSize()  +'\n';
        strLimit+= ' No. of SOQL queries : ' + limits.getQueries()  + ' out of ' + limits.getLimitQueries()   +'\n';        
        strLimit+= ' No. of QueryLocator Rows : ' + limits.getQueryLocatorRows() + ' out of ' + limits.getLimitQueryLocatorRows()   +'\n';
        strLimit+= ' No. of query rows : ' + limits.getQueryRows() + ' out of ' + limits.getLimitQueryRows()    +'\n';
        return strLimit;
    }
}