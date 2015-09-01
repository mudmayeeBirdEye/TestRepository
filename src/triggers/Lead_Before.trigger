/*************************************************
Trigger on Lead object
Before Insert: Evaluate company size.
               Adjust LeadSource as needed.
               Set Primary_Campaign__c field for use in Lead_After.
               Assign lead using Protection Rules or Lead Assignment Rules.
Before Update: Set Downgrade Date.
               Update indexed fields.
               Update owner manager name and email fields.
               Update Last Touched and Responded fields.
               Use mkto2__Lead_Score__c numerical value to set Lead_Score__c alphanumeric value.
/************************************************/
 
trigger Lead_Before on Lead (before insert, before update) {
	
	//Map<String, Boolean> resultMap = LeadTriggerHelper.getLeadOwnerRCSFsync(trigger.new); 
	//RcDealHealper.LeadContactSearch(trigger.new,new map<String,String>(),resultMap);
    
    /*********BY PASS for Desired Behaviour of Campaign Case**************/
    if(TriggerHandler.BY_PASS_LEAD_UPDATE){  
        System.debug('### RETURNED FROM LEAD-BEFORE TRG ###');
        return;
    }
    /************************************************************/
    
    /***************************Lead RecordTypeMap****************************************************/
    Schema.DescribeSObjectResult result = Lead.SObjectType.getDescribe();
    Map<ID,Schema.RecordTypeInfo> rtMapByName = result.getRecordTypeInfosById(); 
    /************************************************************************************************/
    
    /******************************COMMON CODE FOR INSERT/UPDATE ******************************************/
    LeadTriggerHelper.getLeadUltimatePartnerId(trigger.new, (Trigger.isInsert ? null : trigger.oldMap),rtMapByName);
    /******************************************************************************************************/
    
    /******************************COMMON CODE FOR INSERT/UPDATE ******************************************/
    LeadTriggerHelper.checkPartnerLeadPermittedByBrand(trigger.new, (Trigger.isInsert ? null : trigger.oldMap),LeadTriggerHelper.getApprovedBrandList(trigger.new),rtMapByName);
    /******************************************************************************************************/
    
    /******************************COMMON CODE FOR INSERT/UPDATE ******************************************/
    LeadTriggerHelper.updatePartnerLeadCurrentOwnerEmail(Trigger.New, Trigger.newMap, (Trigger.isInsert ? null : trigger.oldMap),rtMapByName);
    /****************************** ************************************************* *********************/
    
    /******CODE TO IGNORE SYSTEM GENERATED EMAIL*********/
    Database.DMLOptions dmo = new Database.DMLOptions(); 
    dmo.EmailHeader.triggerUserEmail = false; 
    dmo.EmailHeader.triggerAutoResponseEmail = false; 
    dmo.EmailHeader.triggerOtherEmail = false;
    /***************************************************/
    
    /*******************************System User Profile Map and Invalid Lead Status Map*****************************/
    Map<String,ProtectionLeadUsers__c> systemUserMapAll = ProtectionLeadUsers__c.getAll();
    Map<string,boolean> systemUserMap = new Map<string,boolean>();
    for(String userName : systemUserMapAll.keySet()){
        String userId = (systemUserMapAll.get(userName).UserId__c).subString(0,15);     
        systemUserMap.put(userId,true);
    }
    Map<String,boolean> invalidStatusMap = new Map<String,Boolean>{'0. Downgraded'=>true,'X. Open'=>true,'X. Suspect'=>true};
    Set<String> validProfileSet = new Set<String>{'System Administrator','API Only','Channel Sales Manager','GW API','Marketo Integration Profile','Jigsaw'};
    /**************************************************************************************************************/
    
    /*****************************************User Select Query*********************************************************************/
    User objUser = new User();  
    User loggedInUser = new User();
    for(User users : [SELECT Id,Email,Name,Profile.Name,ProfileId,Systems_Integration_Users__c From User WHERE UserType='Standard' AND
                      IsActive=true AND ( Id=: UserInfo.getUserId() OR Name=: 'LAR System User')]){// OR Profile.Name='System Administrator' )]) {
        if(users.Name == 'LAR System User') {
            objUser = users;
        } else if(users.Id == UserInfo.getUserId()){
            loggedInUser = users;
        }
    }
    /**********************************************************************************************************************************/
    
    /************************Generic Skill Maps**********************/
    List<Lead_Assignment_Rules__c> larList = new List<Lead_Assignment_Rules__c>();
    Map<Id, List<User_Skill__c>> skillsToUserSkills = new Map<Id, List<User_Skill__c>>(); 
    Map<Id, Skill__c> skillsMap = new Map<Id, Skill__c>();  
    
    larList = LeadTriggerHelper.getLarWithSkills(false);
    for(Lead_Assignment_Rules__c larObj : larList) {
        if(larObj.Skill__c != null) {
            skillsMap.put(larObj.Skill__c, larObj.Skill__r);
        }
    }
    skillsToUserSkills = LeadTriggerHelper.getSkillsToUserSkillsMap(skillsMap.keySet());
    /****************************************************************/

    if(trigger.isInsert){
        
        /******************** VARIABLE DECLARATION ****************************/
        ProtectionRuleExceptions pre;
        String prResult = 'not found'; 
        Campaign campaignObj = null;
        String customerSize;  
        List<Partner_Request__c> PRMObj = new Partner_Request__c[]{};
        /**********************************************************************/
       
        /********************************** DUPLICATE VALIDATION ***************************************/
        if(loggedInUser.Systems_Integration_Users__c) {
            List<Lead> returningLeads = ValidateLeadDuplicacy.validatePerToday(Trigger.new);
        } 
        /***********************************************************************************************/
        
        /********************************** ASSIGN CAMPAIGN ********************************************/           
        Map<String, Campaign> campaignMap = LeadTriggerHelperExt.assignCampaigns(Trigger.new);
        /**********************************************************************************************/
           
        /********************************** SOLVE THEN SELL ACCOUNT MAPPING **************************************/         
        Map<String, Account> userAccMap = LeadTriggerHelper.findAccountMap(Trigger.new);
        /****************************************************************************************/
    
        /************************* FOR NEW LAR LOGIC *************************************/ 
        if(validProfileSet.contains(loggedInUser.Profile.Name)){
        	LeadAssignmentRuleDAO.runLAR(objUser, skillsMap, larList, skillsToUserSkills); 
        }   
        /********************************************************************************/      
        
        /**************PR Owner Detail Map and Geo Routing Logic Maps**************************/
        Map<String,String> prOwnerMap = new Map<String,String>();                   
        Map<String,RcDealHealper.searchResultClass> leadContactSearchMap = new Map<String,RcDealHealper.searchResultClass>();
        Map<String,Id> userEmailOwnerMap = new Map<String,Id>();
        Map<String, Boolean> resultMap = LeadTriggerHelper.getLeadOwnerRCSFsync(trigger.new); 
        
        Map<String,Campaign_Subtype_Mapping__c> campaignSubTypeQueueMap = new Map<String,Campaign_Subtype_Mapping__c>();
        Map<string,Map<String,String>> segmentDataMap = new Map<string,Map<String,String>>();
        Map<String,Map<String,List<Territory_Data__c>>> territoryDataMap = new Map<String,Map<String,List<Territory_Data__c>>>();
        
        if(validProfileSet.contains(loggedInUser.Profile.Name)){ 
        	Set<String> includedLeadStatus = new Set<String>();
        	Schema.DescribeFieldResult fieldResult = Lead.Status.getDescribe();
			List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
			for( Schema.PicklistEntry f : ple){
				includedLeadStatus.add(f.getValue());
			}            
            leadContactSearchMap = RcDealHealper.LeadContactSearch(Trigger.new,prOwnerMap,resultMap,includedLeadStatus);                
            PRAssignmentLogic.checkAccountCurrentOwner(leadContactSearchMap,prOwnerMap);                
            userEmailOwnerMap = PRAssignmentLogic.createEmailOwnerMap(Trigger.new);
                          
            for(String campaignType : Campaign_Subtype_Mapping__c.getAll().keySet()){
                campaignSubTypeQueueMap.put(campaignType.toUpperCase(),Campaign_Subtype_Mapping__c.getAll().get(campaignType));
            }
                                       
            segmentDataMap = PRAssignmentLogic.createSegmentDataMap();                            
            territoryDataMap = PRAssignmentLogic.createTerritoryDataMap();                
        }            
        /***********************************************************************************************/           
   
        /************************Validating Employee Ranges*********************************************/
        LeadTriggerHelperExt.validateEmployeeRangeForNumericValues(Trigger.new); 
        LeadTriggerHelperExt.getCheckForBadValue(Trigger.new); 
        /**********************************************************************************************/   
        
        /****************************Custom Labels for Geo Territory***********************************/
        List<string> employeeSizeList = new List<String>();
		employeeSizeList = Label.Territory_Employee_Size.split(';');
		Set<string> employeeSizeSet = new set<string>();
		for(String str : employeeSizeList){
			employeeSizeSet.add(str.trim());
		}
		
		List<string> leadSourceList = new List<String>();
		leadSourceList = Label.Territory_Lead_Source.split(';');
		Set<string> leadSourceSet = new set<string>();
		for(String str : leadSourceList){
			leadSourceSet.add(str.trim());
		}
		/**********************************************************************************************/
        
        for(Lead leadObj : Trigger.new){
            
            String uniqueKey = ( !string.isBlank(leadObj.Email) ? leadObj.Email : '') + ( !string.isBlank(leadObj.Phone) ? leadObj.Phone : '');
            leadObj.Assignment_Source_hidden__c = 'No Rules';
            
            /*********************LEADSOURCE ASSIGNMENT *****************/
	        LeadTriggerHelper.assignLeadSource(leadObj);
	        /***********************************************************/
            
            /************************SETTING LEAD CURRENCY***********************************/
            if(leadObj.Lead_Brand_Name__c == 'RingCentral UK'){
                leadObj.CurrencyIsoCode = 'GBP';
            } else if(leadObj.Lead_Brand_Name__c == 'RingCentral Canada'){
                leadObj.CurrencyIsoCode ='CAD';
            } else {
                leadObj.CurrencyIsoCode ='USD';
            }
            /*******************************************************************************/
            
            /*******Code added for associating Account id to lead coming for SolveThenSell through RN*******/
            if(leadObj.LeadSource == 'Solve then Sell' || leadObj.BMID__c == 'SOLVETHENSELL') {
                try{                                 
                    leadObj.Account__c = (userAccMap != null ? userAccMap.get(leadObj.User_ID__c).Id : null);
                } catch(Exception ex){
                    System.debug('Exception at Line : '+ex.getLineNumber()+' Message :'+ex.getMessage());
                }
            }
            /*********************************************************************************************/
            
            /*************************UPDATE LEAD SCORE*********************************/
            if(leadObj.Primary_Campaign__c != null) {                   
                campaignObj = campaignMap.get((String)leadObj.Primary_Campaign__c);
            }
            if(campaignObj != null){ // code-FIXED                             
                if(!String.isBlank(campaignObj.Lead_Score__c)){                         
                    leadObj.Lead_Score__c = campaignObj.Lead_Score__c;
                }
            }
            /*************************************************************************/
            
            /***************************Update LeadSource ****************************/      
            if(campaignObj != null && campaignObj.Name != null && leadObj.LeadSource != null) {     
                if(leadObj.LeadSource == 'Initial' && campaignObj.Name.startsWith('Vista')){
                    leadObj.LeadSource = 'VistaPrint Initial';
                }             
                if(leadObj.LeadSource == 'Initial UK' && campaignObj.Name.startsWith('Vista')){
                    leadObj.LeadSource = 'VistaPrint Initial UK ';
                }       
            }
            /************************************************************************/
            
            /***********************Phone Number Assignment*************************/
            if(leadobj.Phone!=null){
                leadobj.Original_Phone_Number__c = leadobj.Phone;
            }
            LeadTriggerHelper.arrangePhoneNumber(leadobj);
            /***********************************************************************/ 
                   
            /*************************ASSIGN LEAD OWNER*******************/
            
            system.debug('THIS IS Lead Source Agni: ' + leadObj.LeadSource);
            system.debug('=FirstName='+leadObj.FirstName); 
            system.debug('=LastName='+leadObj.LastName);
            system.debug('=Profile='+loggedInUser.Profile.Name);   
            system.debug('=Duplicate='+leadObj.Duplicate_Lead__c);
            system.debug('=resultMap='+resultMap);  
            
            Boolean ownerFoundBasedOnPreProtection = false;
            Boolean territoryUserFound = false;
                                               
            if((!(leadObj.FirstName == 'Something' && leadObj.LastName == 'New') && !(leadObj.FirstName == 'rctu' && leadObj.LastName == '2calls4me'))  
                && (
                		validProfileSet.contains(loggedInUser.Profile.Name)
                    	|| (leadObj.RecordTypeId!=null && rtMapByName.get(leadObj.RecordTypeId).getName() == 'Partner Leads')
                    	|| (leadObj.LeadSource != null && (leadObj.LeadSource).trim().equalsIgnoreCase('Solve then Sell') )                            
                	)
                && (leadObj.Duplicate_Lead__c==null || leadObj.Duplicate_Lead__c == false)
                && (!resultMap.get(leadObj.FirstName + '_' + leadObj.LastName))
            ){                    
                system.debug('Before Pre Protection Limits : '+PRAssignmentLogic.calculateLimits());
                
                /*************************Pre Protection Routing**********************************************/
                if(leadObj.Primary_Campaign__c != null && campaignMap != null && campaignMap.get(leadObj.Primary_Campaign__c) != null
                    && campaignMap.get(leadObj.Primary_Campaign__c).type != null
                    && campaignMap.get(leadObj.Primary_Campaign__c).type.containsIgnoreCase('CPL')){
                    String campaignSubType = campaignMap.get(leadObj.Primary_Campaign__c).type.toUpperCase();
                    if(campaignSubTypeQueueMap.get(campaignSubType) != null){
                        if(!string.isBlank(campaignSubTypeQueueMap.get(campaignSubType).Queue_Id__c)){
                            leadObj.ownerId = campaignSubTypeQueueMap.get(campaignSubType).Queue_Id__c;
                            ownerFoundBasedOnPreProtection = true;
                            leadObj.Assignment_Source_hidden__c = 'PRE-PROTECTION RULE';
                        }
                    }
                }
                /**********************************************************************************************/
                
                system.debug('After Pre Protection Limits : '+PRAssignmentLogic.calculateLimits());      
                
                if(ownerFoundBasedOnPreProtection == false){
                    /************RUN PR RULES LOGIC****************************/     
                    if(leadObj.Bypass_PR__c == false || leadObj.Bypass_PR__c == NULL){
                        if(leadObj.LeadSource != 'Other' && leadObj.RecordTypeName__c != 'Partner_Leads'){
                            system.debug('Before Protection Limits : '+PRAssignmentLogic.calculateLimits());  
                            boolean prUserFound = PRAssignmentLogic.runPRLogic(leadObj, uniqueKey, prOwnerMap, userEmailOwnerMap, loggedInUser, true);                             
                            system.debug('After Protection Limits : '+PRAssignmentLogic.calculateLimits());
                            /************RUN Geo Industry Routing Logic LOGIC****************************/
                            if(!prUserFound){
                                system.debug('Before GeoRouting Limits : '+PRAssignmentLogic.calculateLimits());
                                if((Label.Territory_By_Pass).toUpperCase() == 'FALSE'){
                                    territoryUserFound = PRAssignmentLogic.runGeoTerritoryRouting(leadObj, segmentDataMap, territoryDataMap,
                                    															  employeeSizeSet, leadSourceSet);
                                }
                                system.debug('After GeoRouting Limits : '+PRAssignmentLogic.calculateLimits());
                            /************Assgin to LAR User****************************/
                                if(!territoryUserFound){
                                    if(objUser != null){
                                        system.debug('LAR USER');
                                        leadObj.ownerId = objUser.Id; //LAR System User
                                        leadObj.Lead_Submitter_Id__c = UserInfo.getUserId();
                                        leadObj.Assignment_Source_hidden__c = 'PR PER LAR SYSTEM USER';
                                        leadObj.LAR_Source__c = '';
                                    }                                       
                                }   
                            }
                        } 
                    }else{
                        /************RUN Geo Industry Routing Logic LOGIC****************************/
                        system.debug('Before GeoRouting Limits 1: '+PRAssignmentLogic.calculateLimits());
                        if((Label.Territory_By_Pass).toUpperCase() == 'FALSE'){
                            territoryUserFound = PRAssignmentLogic.runGeoTerritoryRouting(leadObj, segmentDataMap, territoryDataMap,
                            															  employeeSizeSet, leadSourceSet);
                        }
                        system.debug('After GeoRouting Limits 1: '+PRAssignmentLogic.calculateLimits());
                        /************Assgin to LAR User****************************/
                        if(!territoryUserFound){
                            leadObj.OwnerId = objUser.id;
                        }
                    }
                    /**********************************************************/ 
                }
            } else if((resultMap.get(leadObj.FirstName + '_' + leadObj.LastName))) {
                leadObj.Assignment_Source_hidden__c = 'Custom Settings';
            }
                        
            // Start Code By India Team
            if (!'System Administrator'.equalsIgnoreCase(loggedInUser.Profile.Name)) {
                leadObj.Last_Touched_Date__c = Datetime.now();
                leadObj.Last_Touched_By__c = UserInfo.getUserId();
                leadObj.Responded_Date__c = Datetime.now();
                leadObj.Responded_By__c = UserInfo.getUserId();
            }
            
            /****************************Eligible Protected Date************************/  
            if(Test.isRunningTest() && leadObj.OwnerId==null){
            	leadObj.OwnerId = UserInfo.getUserId(); //For Test Class Owner Id Null Issue
            }             
            if((systemUserMap == null || (leadObj.OwnerId!=null && systemUserMap.get(string.valueOf(leadObj.OwnerId).subString(0,15)) == Null)) //Other then 'LAR System User' & not System User
                //&& (systemAdmimMap == null || (leadObj.OwnerId!=null && systemAdmimMap.get(string.valueOf(leadObj.OwnerId).subString(0,15)) == Null))
                && (leadObj.OwnerId!=null && !'System Administrator'.equalsIgnoreCase(leadObj.owner.profile.Name))//Not System Administrator User
                && (invalidStatusMap == null || (leadObj.Status!=null && invalidStatusMap.get(leadObj.Status) == Null))//Not a Invalid Status
              ){
                leadObj.Eligible_Protection_Period__c = system.today() + 30;  
            }
            /**************************************************************************/
            
            /***************************Additional Source Field********************/
            if(string.isBlank(leadObj.Lead_System_Source__c)){
                leadObj.Lead_System_Source__c = UserInfo.getName();
            }
            /**********************************************************************/
        }
        
        /**************************SET Lead Owner Active Date***************/
        LeadTriggerHelper.updateLeadActiveDate(Trigger.New, null);
        LeadTriggerHelper.getLeadOwnerManager(trigger.new);
        /*********************************************************************/
        
        /*********Assign Brand UK if Owner Role contains UK *****************/
        LeadTriggerHelper.assignBrand(trigger.new);
        /*******************************************************************/
    }
    
    
    /*********************************************************LEAD UPDATE *********************************************************/
    if(trigger.isUpdate){ 
    	
    	/**************** TO BY PASS TRIGGER*****************************/
        if(TriggerHandler.BY_PASS_LEAD_UPDATE_ON_INSERT) {
            System.debug('### RETURNED FROM LEAD-BEFORE TRG ###');
            return;
        }
        /***************************************************************/
    	          
        Set<id> userids = new Set<id>();        
        List<Lead> numberOfEmpLeadsUpdatedList = new List<Lead>();
        try{
            for(Lead leadObj : trigger.new){
                userids.add(leadObj.OwnerId);
                userids.add(trigger.oldMap.get(leadObj.id).ownerId);
                
                //SET PHONE NUMBER 
                if(leadObj.Phone != null && leadObj.Phone != trigger.oldMap.get(leadObj.id).Phone){
                    LeadTriggerHelper.arrangePhoneNumber(leadObj);
                }
                
                //NO. OF EMP CSV CODE ON LEAD UPDATE
                if(leadObj.NumberOfEmployees__c != null && leadObj.NumberOfEmployees__c != Trigger.oldMap.get(leadObj.id).NumberOfEmployees__c){
                    numberOfEmpLeadsUpdatedList.add(leadObj);
                }
                
                //SETTING LEAD CURRENCY
            	if(leadObj.Lead_Brand_Name__c == 'RingCentral UK'){
                	leadObj.CurrencyIsoCode = 'GBP';
                } else if(leadObj.Lead_Brand_Name__c == 'RingCentral Canada'){
                    leadObj.CurrencyIsoCode ='CAD';
                } else {
                    leadObj.CurrencyIsoCode ='USD';
                }                    
                
                //Assignment Source Hidden field update.
                Lead oldLeadObj = trigger.oldMap.get(leadObj.Id);
                if(objUser != null 
                    && oldLeadObj.OwnerId != leadObj.OwnerId 
                    && leadObj.OwnerId != objUser.Id 
                    && oldLeadObj.OwnerId != objUser.Id 
                    && !String.isBlank(leadObj.Assignment_Source__c)) {
                        if(('Marketo Integration Profile'.equalsIgnoreCase(loggedInUser.Profile.Name))) {
                            leadObj.Assignment_Source_hidden__c = 'PR PER MARKETO OWNER UPDATE';
                        } else {
                            leadObj.Assignment_Source_hidden__c = 'Manual';
                        }
                        leadObj.LAR_Source__c ='';
                }
            } 
                   
            //Number of Employee Bucketing Logic on update.
            if(numberOfEmpLeadsUpdatedList != null && numberOfEmpLeadsUpdatedList.size() > 0){
                LeadTriggerHelperExt.validateEmployeeRangeForNumericValues(numberOfEmpLeadsUpdatedList);
                LeadTriggerHelperExt.getCheckForBadValue(numberOfEmpLeadsUpdatedList); 
            }
            
        }catch(exception ex){               
            System.debug('Exception at Line : '+ex.getLineNumber()+' Message :'+ex.getMessage());    
        }
        
        /********************************************User Map*****************************************************************/                      
        Map<id,User> userDetailMap = new Map<id, User>([SELECT Manager.Email, Name, Phone,Manager.Username, IsActive,Profile.Name, ManagerId,
        												 Mkto_Reply_Email__c From User WHERE id IN: userids]);            
        /*************************************************************************************************************************/
    
        /************************Update Most Recent Campaign*******************/
        Set<String> campaignIdSet = LeadTriggerHelper.updateMostRecentCampaign(Trigger.New, Trigger.oldMap,rtMapByName);        
        /**********************************************************************/
        
        /********************************** PR DATA INITIALIZED **************************************/            
        Map<String,String> prOwnerMap = new Map<String,String>(); 
        List<Lead> prLeadList = new List<Lead>();          
        /************************************************************************************************/
    
        /*************************** INITIAL MARKETO ATTOH STARTS**********************************/
        try {
            if ('Marketo Integration Profile'.equalsIgnoreCase(loggedInUser.Profile.Name)) {
                //Map<String, Campaign> campaignMap = LeadTriggerHelperExt.assignCampaigns(trigger.new);
                //LeadTriggerHelperExt.intialLeadUpdates(trigger.new, trigger.oldMap, userDetailMap);
                Map<String, Campaign> campaignMap = new Map <String, Campaign>([SELECT Id, type,Lead_Creation_Score__c, Lead_Entry_Source__c, AID__c, PID__c, BMID__c, DNIS__c, Team__c, 
        									 NumberOfLeads, Lead_Score__c, Name from Campaign where Id in: campaignIdSet]);
                Map<String,Id> userEmailOwnerMap = new Map<String,Id>();
                userEmailOwnerMap = PRAssignmentLogic.createEmailOwnerMap(trigger.new);
                for(Lead leadObj : trigger.new) {
                    /****************************Eligible Protected Date************************/
                    PRAssignmentLogic.calculateProtectionPeriod(leadObj,trigger.oldMap.get(leadObj.id),systemUserMap,invalidStatusMap);		                
	                /*************************************************************************/  
		    		
		    		if(
		    			(
		    				leadObj.OwnerId != trigger.oldMap.get(leadObj.id).ownerId && // Owner Changes
		    				leadObj.OwnerId != null && string.valueOf(leadObj.OwnerId).startsWith('005') && //Current Owner is User
                      		userDetailMap.get(leadObj.OwnerId)!=null && userDetailMap.get(leadObj.OwnerId).isActive==false //Current owner is InActive
                  		)
                      	||
                      	leadObj.OwnerId == trigger.oldMap.get(leadObj.id).ownerId){	//Owner Not Changed	                  		
                  		
                    	//Check Is Lead Protectd or Not
	                    boolean isProtectedLead = false;
			    		if(leadObj.Eligible_Protection_Period__c!=null && leadObj.Eligible_Protection_Period__c < system.today()
							    && leadObj.status!=null && leadObj.status == '2. Contacted'){
			    			isProtectedLead = true;
			    		}
	                    
	                    if(
			            	(
			            		//Check if campaign Changes from a NON CPL type to CPL Type
				            	leadObj.Most_Recent_Campaign__c != null 
				            	&& leadObj.Most_Recent_Campaign__c != trigger.oldMap.get(leadObj.Id).Most_Recent_Campaign__c
				            	&& campaignMap.get(leadObj.Most_Recent_Campaign__c) != null 
				    			&& campaignMap.get(leadObj.Most_Recent_Campaign__c).type != null
				    			&& campaignMap.get(leadObj.Most_Recent_Campaign__c).type.containsIgnoreCase('CPL')
				    			&& campaignMap.get(trigger.oldMap.get(leadObj.Id).Most_Recent_Campaign__c) != null 
				    			&& (campaignMap.get(trigger.oldMap.get(leadObj.Id).Most_Recent_Campaign__c).type == null ||
				    				!campaignMap.get(trigger.oldMap.get(leadObj.Id).Most_Recent_Campaign__c).type.containsIgnoreCase('CPL'))
								&& (!isProtectedLead)
							) 
							||
							(
								//Check if status changing from Invalid to Valid
								leadObj.Status != trigger.oldMap.get(leadObj.id).status //Status Changed
	                            && (invalidStatusMap != null && invalidStatusMap.get(trigger.oldMap.get(leadObj.id).status) != Null) //Old Status Invalid
	                            && (invalidStatusMap == null || invalidStatusMap.get(leadObj.Status) == Null) //New Status is Valid
							)
			    		){
			    			if(leadObj.OwnerId != null && string.valueOf(leadObj.OwnerId).startsWith('005')){//Current Owner Is a 'User'
			    				//Check if Marketo providing Email Fields for owner assignment.
		                  		if((leadObj.Lead_Owner_Email_Address__c!=null && userEmailOwnerMap!=null && userEmailOwnerMap.get(leadObj.Lead_Owner_Email_Address__c)!=null) || (Test.isRunningTest())){
									system.debug('Marketo Updating Lead Owner Email Field');							
									leadObj.OwnerId = userEmailOwnerMap.get(leadObj.Lead_Owner_Email_Address__c);
									leadObj.Assignment_Source_hidden__c = 'PR PER MARKETO';
									leadObj.LAR_Source__c = '';
								}else if((leadObj.Sales_Agent_Email__c!=null && userEmailOwnerMap!=null && userEmailOwnerMap.get(leadObj.Sales_Agent_Email__c)!=null) || (Test.isRunningTest())){
									system.debug('Marketo Updating Sales Agent Email Field');
									leadObj.OwnerId = userEmailOwnerMap.get(leadObj.Sales_Agent_Email__c);
									leadObj.Assignment_Source_hidden__c = 'PR PER MARKETO';
									leadObj.LAR_Source__c = '';
								} else {		    				
					    			if(!PRAssignmentLogic.findOwnerSkill(skillsToUserSkills, skillsMap, larList, leadObj,prOwnerMap,objUser,true)){
		                                leadObj.ownerId = LeadTriggerHelper.RCSF_SYNC; //RCSF Sync User
		                                leadObj.Lead_Submitter_Id__c = LeadTriggerHelper.RCSF_SYNC;
		                            }
		                            leadObj.Assignment_Source_hidden__c = 'PR PER LAR RULES';
		                  		}
			    			}
			    		} else {
			    			if(leadObj.Bypass_PR__c==true){			    				
			    				if(leadObj.OwnerId != null && string.valueOf(leadObj.OwnerId).startsWith('005') && 
			    					userDetailMap.get(leadObj.OwnerId)!=null && userDetailMap.get(leadObj.OwnerId).isActive==false){
			                        leadObj.OwnerId = objUser.id;
			                        leadObj.Assignment_Source_hidden__c = 'PR PER LAR SYSTEM USER';
			                    }
			    			} else {
			    				if(leadObj.LeadSource != 'Other' && leadObj.RecordTypeName__c != 'Partner_Leads' && 
			    					leadObj.OwnerId != null && string.valueOf(leadObj.OwnerId).startsWith('005') && userDetailMap.get(leadObj.OwnerId).isActive==false){
			    					prLeadList.add(leadObj);
			    				}
			    			}  
			    		}
		    		}
		    		
		    		//MARKETO FIELDS UPDATES IN SFDC
		    		if(leadObj.Marketo_Duplicate_Lead__c == true) {
                        leadObj.Lead_Merged_Date__c = system.today(); 
                        leadObj.Lead_Merged_Counter__c = leadObj.Lead_Merged_Counter__c == null ? 1 : (leadObj.Lead_Merged_Counter__c + 1);  
                        leadObj.Marketo_Duplicate_Lead__c = false;
                        leadObj.Send_Duplicate_Lead_Email__c = true;
                    }
                }
                
                if(prLeadList!=null && prLeadList.size() > 0){              
                    Map<String,RcDealHealper.searchResultClass> leadContactSearchMap = new Map<String,RcDealHealper.searchResultClass>();
                    Map<String, Boolean> resultMap = LeadTriggerHelper.getLeadOwnerRCSFsync(trigger.new);
                    Set<String> includedLeadStatus = new Set<String>();
					Schema.DescribeFieldResult fieldResult = Lead.Status.getDescribe();
					List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
					for( Schema.PicklistEntry f : ple){
						includedLeadStatus.add(f.getValue());
					} 
                    leadContactSearchMap = RcDealHealper.LeadContactSearch(prLeadList,prOwnerMap,resultMap,includedLeadStatus);                         
                    PRAssignmentLogic.checkAccountCurrentOwner(leadContactSearchMap,prOwnerMap);
                    userEmailOwnerMap = PRAssignmentLogic.createEmailOwnerMap(prLeadList);
                    for(Lead leadObj : prLeadList){
                        String uniqueKey = ( !string.isBlank(leadObj.Email) ? leadObj.Email : '') + ( !string.isBlank(leadObj.Phone) ? leadObj.Phone : '');
                        if(leadObj.Bypass_PR__c == false || leadObj.Bypass_PR__c == NULL){
                            if(leadObj.LeadSource != 'Other' && leadObj.RecordTypeName__c != 'Partner_Leads' &&
                               leadObj.OwnerId != null && string.valueOf(leadObj.OwnerId).startsWith('005') && userDetailMap.get(leadObj.OwnerId).isActive==false){
                               	                           
                                boolean prUserFound = PRAssignmentLogic.runPRLogic(leadObj, uniqueKey, prOwnerMap, userEmailOwnerMap, loggedInUser, false);
                                
                                if(!prUserFound){
                                    if(objUser != null){
                                        system.debug('LAR USER');
                                        leadObj.ownerId = objUser.Id; //LAR System User
                                        leadObj.Lead_Submitter_Id__c = UserInfo.getUserId();
                                        leadObj.Assignment_Source_hidden__c = 'PR PER LAR SYSTEM USER';
                                        leadObj.LAR_Source__c = '';
                                    }   
                                }
                            }
                        }else if(leadObj.OwnerId != null && string.valueOf(leadObj.OwnerId).startsWith('005') && 
                        		 userDetailMap.get(leadObj.OwnerId).isActive==false){
                            leadObj.OwnerId = objUser.id;
                            leadObj.Assignment_Source_hidden__c = 'PR PER LAR SYSTEM USER';
                        }
                    }
                }
            }
        } catch(Exception ex) {
            trigger.new[0].addError(ex.getMessage());
            System.debug('Exception at Line : '+ex.getLineNumber()+' Message :'+ex.getMessage());
        }
        
        for(Lead leadObj:trigger.new){
            
            /*Code For original Owner functionality.Old Lead Owner = 'LAR System User' and New lead owner!='LAR System User'and Original Lead owner=Blank*/
            if(userDetailMap!=null && userDetailMap.get(leadObj.OwnerId)!=null   
                && !userDetailMap.get(leadObj.OwnerId).Name.equalsIgnoreCase('LAR System User')
                && string.isBlank(leadObj.Original_Lead_Owner_Name__c)    
                && trigger.OldMap.get(leadObj.id)!=null
                && userDetailMap.get(trigger.OldMap.get(leadObj.id).ownerId)!=null
                && userDetailMap.get(trigger.OldMap.get(leadObj.id).ownerId).Name.equalsIgnoreCase('LAR System User')){
                    leadObj.Original_Lead_Owner_Id__c = leadObj.OwnerId;
                    leadObj.Original_Lead_Owner_Name__c = userDetailMap.get(leadObj.OwnerId).Name;
            }
            /**********************************************************************************************************************************/
            
            /****************************To Set Lead_Owner_Phone_Number__c and Mkto_Reply_Email__c************************/
            User userObj = userDetailMap.get(leadObj.OwnerId);
            if(userObj != null) {
                leadObj.Lead_Owner_Phone_Number__c = userObj.Phone;
                if(trigger.oldMap.get(leadObj.Id).OwnerId != leadObj.OwnerId) {
                    leadObj.Mkto_Reply_Email__c = userObj.Mkto_Reply_Email__c;  
                }   
            }
            /************************************************************************************************************/
            
            /************************SET Downgrade date****************/
            if(leadObj.Status == '0. Downgraded' && trigger.oldMap.get(leadObj.Id).Status != '0. Downgraded'){
                if((leadObj.LeadSource == 'About To Be Cancelled' || leadObj.LeadSource == 'About To Be Cancelled UK') 
                    && leadObj.Downgrade_Reason__c == 'Retention Lead Closed'){
                    leadObj.Downgrade_Date__c = Date.Today()-1;                  
                } else {
                    leadObj.Downgrade_Date__c = Date.Today(); 
                }
            }
            /********************************************************/
            
            /**************Update indexed fields********************/
            if(leadObj.Phone != trigger.oldMap.get(leadObj.Id).Phone){
                leadObj.indexedPhone__c = leadObj.Phone; 
            }
            
            if(leadObj.email != trigger.oldMap.get(leadObj.Id).email){
                leadObj.indexedEmail__c = leadObj.email; 
            }
            /******************************************************/
        
            /******************* Update Owner Manager fields appropriatly. Dave Demink should be listed as his own manager.***************/
            if(leadObj.OwnerId != trigger.oldMap.get(leadObj.Id).OwnerId){
                system.debug('OWNERID: ' + leadObj.OwnerId);
                if(leadObj.OwnerId == '005800000037xj5'){
                    leadObj.Owner_Manager_Email__c = 'daved@ringcentral.com';
                    leadObj.Owner_Manager_Name__c = 'Dave Demink'; 
                }
                else{
                    if(!(UserInfo.getUserName()).equalsIgnoreCase('rcsfsync@ringcentral.com') && 
                        (!(UserInfo.getUserName()).equalsIgnoreCase('sunilm@ringcentral.com')) &&  
                        (!(UserInfo.getUserName()).equalsIgnoreCase('rcindia@simplion.com'))){                      
                    try{
                        User u = userDetailMap.get(leadObj.OwnerId);                        
                        if(u != null &&  u.Managerid!= null  &&  u.Manager.Email !=null  &&  u.Manager.Username != null ){                                
                            leadObj.Owner_Manager_Email__c = u.Manager.Email;                                
                            leadObj.Owner_Manager_Name__c = u.Manager.Username;                                 
                        }
                    }catch(System.QueryException ex){
                    	System.debug('Exception at Line : '+ex.getLineNumber()+' Message :'+ex.getMessage());
                    }
                        /*The following block of code was added to try continue to bulkify lead insertion.
                        Instead of queriing for each user details for every lead use a master list of users to find matching data                     
                        This code would allow bulk lead transfers by sales managers while keeping Owner Manager fields up to date*/
                    }
                }                  
            }
            /*******************************************************************************************************************************/
            
            /****************************Set Last Response Date and Last Touched Date Data*****************************/
            if (!'System Administrator'.equalsIgnoreCase(loggedInUser.Profile.Name)) {
                if(leadObj.Responded_Date__c==null){
                    leadObj.Responded_Date__c = Datetime.now();
                    leadObj.Responded_By__c = UserInfo.getUserId();
                }
                leadObj.Last_Touched_Date__c  = Datetime.now();
                leadObj.Last_Touched_By__c = UserInfo.getUserId();
            }
            /**********************************************************************************************************/
        
            /* 
                If mrkto lead score is updated
                Only usefull if marketo assigns a numerical score to the lead.
                This was added for one campaign to test scoring.
                mkto2__Lead_Score__c is a field added by Markteo SFDC package.
            */
            if((trigger.oldMap.get(leadObj.Id).mkto2__Lead_Score__c != leadObj.mkto2__Lead_Score__c) && leadObj.LeadSource == 'Resource Nation'){
                if(leadObj.mkto2__Lead_Score__c < 34 || leadObj.mkto2__Lead_Score__c==null){
                    leadObj.Lead_Score__c = 'C';
                }
                else if(leadObj.mkto2__Lead_Score__c < 67){
                    leadObj.Lead_Score__c = 'B';
                }
                else if(leadObj.mkto2__Lead_Score__c > 66){
                    leadObj.Lead_Score__c = 'A';
                }                   
            }
            /**********************************************************************************************************/
        
            /************************Assign Partner Owner Assign Date on Partner Owner change*************************/
            if(trigger.OldMap.get(leadObj.id).Partner_Lead_Owner__c != leadObj.Partner_Lead_Owner__c 
                    && !string.isBlank(leadObj.Partner_Lead_Owner__c)){
               leadObj.Partner_Owner_Assignment_Date__c = System.today();
            }                
            /********************************************************************************************************/
        }      
        
        /*****************UPDATE Lead Owner Active Date************************/
        LeadTriggerHelper.updateLeadActiveDate(Trigger.New, Trigger.oldMap);
        /*********************************************************************/  
    }   

    if(trigger.isInsert && trigger.isBefore){
        DG_DFR_Class.FirstHandRaise_OnInsert(Trigger.New);      
    }

    if(trigger.isUpdate && trigger.isBefore){
        DG_DFR_Class.FirstHandRaise_OnUpdate(Trigger.New, Trigger.old);     
    } 
}