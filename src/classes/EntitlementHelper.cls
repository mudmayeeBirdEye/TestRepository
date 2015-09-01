/**************************************************************************************************
* Project Name..........: Entitlement                                                             *
* File..................: EntitlementHelper.class                                                 *
* Version...............: 1.0                                                                     *
* Created by............: Simplion Technologies                                                   *
* Created Date..........: 26-06-2014                                                              *
* Last Modified by......: Simplion Technologies                                                   *
* Last Modified Date....: 26-06-2014                                                              *
* Description...........: Entitlement Helper Class, contains logic for entitlement creation,      *
*                         case assignment.                                                        *
**************************************************************************************************/

public class EntitlementHelper {
	
	// Declaring Variable & Constants
	private static final String BUSINESS_HOURS_BASIC = 'Support - Basic';
	private static final String BUSINESS_HOURS_STANDARD = 'Support Office Standard';
	private static final String BUSINESS_HOURS_PREMIUM = 'Support - Office Premium';
	private static final String SLA_WEB_SUPPORT_CASES = 'Web Support - Support Cases';
	private static final String SUPPORT_T2 = 'Support - T2';
	private static final String SUPPORT_T3 = 'Support - T3';
	private static final String CUSTOMER_PORTAL_USER = 'Customer Portal User';
	private static final String EXPIRED = 'Expired';
	private static final String GENERAL_SUPPORT_QUEUE = 'General Support Queue';
	private static final String SUPPORT_CASE = 'Support-Case';
	private static final String CASE_ASSIGNED = 'Case Assigned';
	private static final String DEFAULT_ENTITLEMENT = 'Default';
	
	
	public static Profile portalProfile = null;
	
	Map<String, Entitlement_Account_Configuration__c> entitlementAccountConfig = new Map<String, Entitlement_Account_Configuration__c>(); 
	
	// Static Block
	static {
		if(portalProfile == null) {
			portalProfile = [SELECT Id, Name FROM Profile WHERE Name =: CUSTOMER_PORTAL_USER limit 1];
		}
	}
	
	/******************************************************************************
	* @Description : Check if the user is Portal User or not.                     *
	* @Params      : void                                                         *
	* @Return      : Boolean                                                      * 
	******************************************************************************/
	public static Boolean isPortalUser() {
		return (UserInfo.getProfileId() == portalProfile.Id ? true :false);
	}
	
	/******************************************************************************
	* @Description : Check if the entitlement enabled or not.                     *
	* @Params      : void                                                         *
	* @Return      : Boolean                                                      * 
	******************************************************************************/	
	//-----------------------As/Simplion/4/6/2015---------------------------------------------
	public static EntitlementEnable__c entitlementCustomSettingInfo{get{
		if(entitlementCustomSettingInfo != null){
			return entitlementCustomSettingInfo;
		}else{
			entitlementCustomSettingInfo = EntitlementEnable__c.getInstance('IsEntitlementsEnabled');
			return entitlementCustomSettingInfo;
		}
	}set;}
	
	public static Boolean IsEntitlementsEnabled() {
		Map<String, Boolean> statusMap = new Map<String, Boolean>();
		try {
			// ---------------------------------------------------------------------------------- eugenebasianomutya - enhancement
			// for( String status : EntitlementEnable__c.getAll().keySet()) {
			//	EntitlementEnable__c entitlementEnabled = EntitlementEnable__c.getAll().get(status);
			//	statusMap.put(entitlementEnabled.Name, entitlementEnabled.IsEntitlementsEnabled__c);
			//}
			
			for(EntitlementEnable__c e: EntitlementEnable__c.getall().values()){
				statusMap.put(e.Name, e.IsEntitlementsEnabled__c);
			}
			// ---------------------------------------------------------------------------------- eugenebasianomutya - enhancement
			
			
		} catch(Exception e) {return false;}
		return (statusMap.get('IsEntitlementsEnabled') == null ? false : statusMap.get('IsEntitlementsEnabled'));
	}
	
	/******************************************************************************
	* @Description : Method to create Account to Entitlement Map.                 *
	* @Params      : Set<Id>                                                      *
	* @Return      : Map<Id, Entitlement>                                         * 
	******************************************************************************/	
	public static Map<Id, Entitlement> createAccountEntitlementMap(Set<Id> accountIds){
		Map<Id, Entitlement> accountToEntitlementMap = new Map<Id, Entitlement>();
		for(Entitlement entObj :[SELECT Id, Name, Type, AccountId, SlaProcessId, StartDate, Status, BusinessHoursId 
								 FROM Entitlement 
								 WHERE AccountId IN: accountIds]) {
			if(entObj.Status != EXPIRED){
				accountToEntitlementMap.put(entObj.accountId, entObj);
			}
		}
		return accountToEntitlementMap;
	}

	/******************************************************************************
	* @Description : Method to create Entitlements for new Account.               *
	* @Params      : List<Account>, Map<Id, Account>                              *
	* @Return      : List<Entitlement>                                            * 
	******************************************************************************/
	public static List<Entitlement> createEntitlements(List<Account> accountList, Map<Id, Account> oldMap) {
		
		// Fetching map of all configured SLA Process.
		Map<Id, SlaProcess> slaProcessMap = getSLAProcessMap();
		// Fetching map of all configured Business hours.
		Map<Id, BusinessHours> businessHrsMap = getBusinessHoursMap();
		// Map to contain Account, No.of Entitlement attached to it.
		Map<Id, Integer> entOnAccount = new Map<Id, Integer>();
		// Map to contain AccountId, Entitlement.
		Map<Id, Entitlement> accountToEntitlementMap = new Map<Id, Entitlement>(); 
		// Map to contain AccountId, List<Entitlements>.
		Map<Id, List<Entitlement>> accountToEntitlementListMap = new Map<Id, List<Entitlement>>();
		Set<Id> accountIds = new Set<Id>();
		List<Entitlement> entitlements = new List<Entitlement>();
		Account oldAccountObj = null;
		
		// Fetching map of Account, related entitlement.
		Map<String, List<Entitlement_Account_Configuration__c>> entitlmentAccountConfig = fetchEntitlementConfiguration();
		Map<Id,Id> accountSLAIdMap =  new Map<Id,Id>(); 
		
		system.debug('#### entitlmentAccountConfig - '+entitlmentAccountConfig);
		for(Account accObj : accountList) {
			accountIds.add(accObj.Id);
			if(!String.isBlank(accObj.RC_Brand__c) && entitlmentAccountConfig != null && entitlmentAccountConfig.get(accObj.RC_Brand__c) != null){
				for(Entitlement_Account_Configuration__c thisRecord : entitlmentAccountConfig.get(accObj.RC_Brand__c)){
					if( !String.isBlank(accObj.RC_Service_name__c) && accObj.RC_Brand__c == thisRecord.RC_Brand__c && accObj.RC_Service_name__c == thisRecord.Service_Name__c){
					    	
						if(isNumberOfDLsNullOrLessEqualOne(accObj.Number_of_DL_s__c,thisRecord.Number_of_DLs__c) ){
							system.debug('#### low range');
							accountSLAIdMap.put(accObj.Id, thisRecord.SLA_Process__c);
						}
						if(isNumberOfDLsMidRange(accObj.Number_of_DL_s__c,thisRecord.Number_of_DLs__c) ){
							system.debug('#### mid range');
							accountSLAIdMap.put(accObj.Id, thisRecord.SLA_Process__c);
						}
						if(isNumberOfDLsHighRange(accObj.Number_of_DL_s__c,thisRecord.Number_of_DLs__c) ){
							system.debug('#### high range');
							accountSLAIdMap.put(accObj.Id, thisRecord.SLA_Process__c);
						}	
					}
				}
			}
		}
		for(Entitlement entObj :[SELECT Id, Name, Type, AccountId, SlaProcessId, StartDate, Status, BusinessHoursId 
		                         FROM Entitlement 
		                         WHERE AccountId IN: accountIds]) {
		                         	
			List<Entitlement> entList = new List<Entitlement>();
			if(accountToEntitlementListMap.get(entObj.accountId) != null){
				entList = accountToEntitlementListMap.get(entObj.accountId);
			}
			entList.add(entObj);
			accountToEntitlementListMap.put(entObj.accountId, entList);
		}
		
		
		for(Account accObj : accountList) {
			if(accountToEntitlementListMap != null && accountToEntitlementListMap.size() != 0 && accountToEntitlementListMap.get(accObj.Id) != null) {
				for(Entitlement entObj : accountToEntitlementListMap.get(accObj.Id)) {
					String entName = '';
					if(accountSLAIdMap.get(accObj.Id)!=null && slaProcessMap.get(accountSLAIdMap.get(accObj.Id))!=null){
						entName = accObj.Name + ' - '+slaProcessMap.get(accountSLAIdMap.get(accObj.Id)).Name;
					}
					if(entObj.Name.EqualsIgnoreCase(entName) && (entObj.Status != EXPIRED)) {
						accountToEntitlementMap.put(accObj.Id, entObj);
						Integer counter = entOnAccount.get(accObj.Id);
						if(counter == null){
							counter = 0;
						}
						entOnAccount.put(accObj.Id, ++counter);	
					}
				}
			}
		}
		
		entitlements = createAccountEntitlement(accountList, oldMap, accountToEntitlementMap);
		if(entitlements.size() != 0) {
			List<Entitlement> createList = new List<Entitlement>();
			List<Entitlement> updateList = new List<Entitlement>();
			for(Entitlement entObj : entitlements) {
				if(entObj.id != null){
					updateList.add(entObj);
				} else{
					createList.add(entObj);
				}
			}
			if(!updateList.isEmpty()) {
				update updateList;
			}
			if(!createList.isEmpty()) {
				insert createList;
			}
			/*if(!entitlements.isEmpty()) {
				upsert entitlements;
			}*/
		}
		return entitlements;
	}
	// Web Support - Support Cases
	/******************************************************************************
	* @Description : Fetch all Active SLA Process.                                *
	* @Params      : void                                                         *
	* @Return      : List<SlaProcess>                                             * 
	******************************************************************************/
	public static List<SlaProcess> getSLAProcess() {
		return [SELECT Id, Name FROM SlaProcess WHERE IsActive=true];
	}

	/******************************************************************************
	* @Description : Create SLA Process Map      .                                *
	* @Params      : void                                                         *
	* @Return      : Map<String, SlaProcess>                                      * 
	******************************************************************************/
	public static Map<Id, SlaProcess> getSLAProcessMap() {
		Map<Id, SlaProcess> slaProcessMap = new Map<Id, SlaProcess>();
		for(SlaProcess slaProcess : getSLAProcess()) { 
			slaProcessMap.put(slaProcess.Id, slaProcess);
		}
		return slaProcessMap;
	}
	
	/******************************************************************************
	* @Description : Fetch all Active Business Hours.                             *
	* @Params      : void                                                         *
	* @Return      : List<BusinessHours>                                          * 
	******************************************************************************/
	public static List<BusinessHours> getBusinessHours() {
		return [SELECT Id, Name FROM BusinessHours WHERE IsActive=true];
	}
	
	/******************************************************************************
	* @Description : Create Business Hours Map   .                                *
	* @Params      : void                                                         *
	* @Return      : Map<String, BusinessHours>                                   * 
	******************************************************************************/
	public static Map<Id, BusinessHours> getBusinessHoursMap() {
		Map<Id, BusinessHours> nameToHoursMap = new Map<Id, BusinessHours>();  
		for(BusinessHours businessHrs : getBusinessHours()) {
			nameToHoursMap.put(businessHrs.Id, businessHrs);
		}
		return nameToHoursMap;
	}

	/******************************************************************************
	* @Description : Check if Account has been changed or not.                    *
	* @Params      : Account, Account                                             *
	* @Return      : Boolean                                                      * 
	******************************************************************************/	
	private static Boolean isChanged(Account newAccount, Account oldAccount) {
		/*
		if(oldAccount == null || newAccount.Number_of_DL_s__c != oldAccount.Number_of_DL_s__c) {
			return true;
		}
		*/
		return true;
	}
	
	/******************************************************************************
	* @Description : Get attached entitlement for the provided Account Id.        *
	* @Params      : Id                                                           *
	* @Return      : List<Entitlement>                                            * 
	******************************************************************************/
	public static List<Entitlement> getEntitlement(Id accountId) {
		try{	
			if(accountId != null) {
				Account accountObj = [SELECT Id, Name, RC_Service_name__c, RC_Brand__c, Number_of_DL_s__c, 
									         (SELECT Id, Name, Type, AccountId, SlaProcessId, StartDate, Status, BusinessHoursId FROM Entitlements) 
							          FROM Account 
							          WHERE Id =: accountId];
				if(accountObj != null) {
					String expectedEntitleName = accountObj.Name + ' - ' + SLA_WEB_SUPPORT_CASES;
					Boolean alreadyAssociated = false;
					for(Entitlement entObj : accountObj.Entitlements) {
						if(entObj.Name.containsIgnoreCase(expectedEntitleName) && (entObj.Status != 'Expired')) {
							return new List<Entitlement>{entObj};
						}
					}
					return createEntitlements(new List<Account>{accountObj}, null);
				}
			}
		}catch(Exception ex){
			system.debug('#### Error @ getEntitlement - '+ex.getMessage());
		}
		return null;
	}

	/******************************************************************************
	* @Description : Close Milestone attached to the Case.                        *
	* @Params      : List<Case>, Map<Id, Case>                                    *
	* @Return      : void                                                         * 
	******************************************************************************/	
	public static void closeCaseAssignedMilestone(List<Case> caseList, Map<Id, Case> oldCaseMap) {
		
	    List<Id> updateCases = new List<Id>();
	    Set<Id> accountIds = new Set<Id>();
	    Map<Id, Entitlement> accountToEntitlementMap = new Map<Id, Entitlement>();
	    List<Entitlement> entitlementListUpdate =  new List<Entitlement>();  
	    Group queue = [SELECT Id FROM Group WHERE Name =: GENERAL_SUPPORT_QUEUE limit 1];
	    
	    for(Case caseObj : caseList) {
	    	accountIds.add(caseObj.AccountId);	
	    }
	    accountToEntitlementMap = createAccountEntitlementMap(accountIds);
	    for(Case caseObj : caseList) {
	       if(OpportunityHelper.getOppRecordTypeMap(SUPPORT_CASE) == caseObj.RecordTypeId && caseObj.Case_Assignment_Timestamp__c == null) {
				Case oldCaseObj = oldCaseMap.get(caseObj.Id);
				if(queue != null && (oldCaseObj.ownerId  == queue.Id) && oldCaseObj.OwnerId != caseObj.OwnerId) {
					updateCases.add(caseObj.Id);
				}
	       }
	    }
	    if(!updateCases.isEmpty())
	    	MilestoneUtils.completeMilestone(updateCases, CASE_ASSIGNED , System.now());
	}

	/******************************************************************************
	* @Description : Fetch Entitlement parameters from Custom Setting.            *
	* @Params      : void                                                         *
	* @Return      : Map<String, List<Entitlement_Account_Configuration__c>>      * 
	******************************************************************************/
	public static Map<String, List<Entitlement_Account_Configuration__c>> fetchEntitlementConfiguration(){
		
		Map<String, List<Entitlement_Account_Configuration__c>> entitlmentAccountConfig =  new Map<String, List<Entitlement_Account_Configuration__c>>();
		
		system.debug('#### Entitlement Parameters - '+Entitlement_Account_Configuration__c.getAll().values());
		
		for(Entitlement_Account_Configuration__c thisRecord : Entitlement_Account_Configuration__c.getAll().values()){
			if(entitlmentAccountConfig.get(thisRecord.RC_Brand__c) != null){
				entitlmentAccountConfig.get(thisRecord.RC_Brand__c).add(thisRecord);	
			}else{
				entitlmentAccountConfig.put(thisRecord.RC_Brand__c, new List<Entitlement_Account_Configuration__c>{thisRecord});	
			}	
		}
		system.debug('#### entitlmentAccountConfig Map - '+entitlmentAccountConfig);
		return entitlmentAccountConfig; 		 
	}

	/******************************************************************************
	* @Description : Create entitlement from different config filters.            *
	* @Params      : List<Account>, Map<Id, Account>, Map<Id, Entitlement>        *
	* @Return      : List<Entitlement>                                            * 
	******************************************************************************/	
	public static List<Entitlement> createAccountEntitlement(List<Account> accountList, Map<Id, Account> oldMap, Map<Id, Entitlement> accountToEntitlementMap){
		
		List<Entitlement> entitlements = new List<Entitlement>();
		try{
			// Fetching map of all configured SLA Process.
			Map<Id, SlaProcess> slaProcessMap = getSLAProcessMap();
			// Fetching map of all configured Business Hours.
			Map<Id, BusinessHours> businessHrsMap = getBusinessHoursMap();
			// Fetching map of Account, related entitlement.
			Map<String, List<Entitlement_Account_Configuration__c>> entitlmentAccountConfig = fetchEntitlementConfiguration();
			
			Account oldAccountObj = null;
		
			for(Account accountObj : accountList) {
				oldAccountObj = (oldMap == null ? null : oldMap.get(accountObj.Id));
				
				if(!String.isBlank(accountObj.RC_Brand__c) && 
				    entitlmentAccountConfig.containsKey(accountObj.RC_Brand__c) && 
				    entitlmentAccountConfig.get(accountObj.RC_Brand__c) != null){
						
						// Creating Entitlement object and assigning values to the fields.
						Entitlement entitlement = new Entitlement();
						entitlement.AccountId = accountObj.Id;
						entitlement.StartDate = System.today();
						entitlement.EndDate = null;
						if(accountToEntitlementMap.get(accountObj.Id) != null) {
							entitlement = accountToEntitlementMap.get(accountObj.Id);
						}
						
						Boolean hasDefault = true;
						for(Entitlement_Account_Configuration__c thisRecord : entitlmentAccountConfig.get(accountObj.RC_Brand__c)){
							entitlement.Type = thisRecord.Type__c;
							system.debug('#### SLa Process Id - '+thisRecord.SLA_Process__c);
							system.debug('#### SLA Process selected - '+slaProcessMap.get(thisRecord.SLA_Process__c));
							
							if(!String.isBlank(accountObj.RC_Service_name__c) && accountObj.RC_Service_name__c.containsIgnoreCase(thisRecord.Service_Name__c)){
								System.debug('#### isNumberOfDLsNullOrLessEqualOne - '+isNumberOfDLsNullOrLessEqualOne(accountObj.Number_of_DL_s__c,thisRecord.Number_of_DLs__c) );
								if(isNumberOfDLsNullOrLessEqualOne(accountObj.Number_of_DL_s__c,thisRecord.Number_of_DLs__c) ){
									system.debug('#### Low Range Value');
									entitlement.SlaProcessId = (slaProcessMap.get(thisRecord.SLA_Process__c) != null ? slaProcessMap.get(thisRecord.SLA_Process__c).Id : null);
									entitlement.BusinessHoursId = ( businessHrsMap.get(thisRecord.Business_Hours__c) != null ?  businessHrsMap.get(thisRecord.Business_Hours__c).Id : null);
									hasDefault = false;
									entitlement.Name = accountObj.Name + ' - ' + (slaProcessMap.get(thisRecord.SLA_Process__c) != null ? 
								                                          slaProcessMap.get(thisRecord.SLA_Process__c).Name : '');
								}
								
								System.debug('#### isNumberOfDLsMidRange - '+isNumberOfDLsMidRange(accountObj.Number_of_DL_s__c,thisRecord.Number_of_DLs__c) );
								if(isNumberOfDLsMidRange(accountObj.Number_of_DL_s__c,thisRecord.Number_of_DLs__c) ){
									system.debug('#### Mid Range Value');
									entitlement.SlaProcessId = (slaProcessMap.get(thisRecord.SLA_Process__c) != null ? slaProcessMap.get(thisRecord.SLA_Process__c).Id : null);
									entitlement.BusinessHoursId = ( businessHrsMap.get(thisRecord.Business_Hours__c) != null ?  businessHrsMap.get(thisRecord.Business_Hours__c).Id : null);
									hasDefault = false;
									entitlement.Name = accountObj.Name + ' - ' + (slaProcessMap.get(thisRecord.SLA_Process__c) != null ? 
								                                          slaProcessMap.get(thisRecord.SLA_Process__c).Name : '');
								}
							
								System.debug('#### isNumberOfDLsHighRange - '+isNumberOfDLsHighRange(accountObj.Number_of_DL_s__c,thisRecord.Number_of_DLs__c) );
								if(isNumberOfDLsHighRange(accountObj.Number_of_DL_s__c,thisRecord.Number_of_DLs__c) ){
									system.debug('#### High Range Value');
									entitlement.SlaProcessId = (slaProcessMap.get(thisRecord.SLA_Process__c) != null ? slaProcessMap.get(thisRecord.SLA_Process__c).Id : null);
									entitlement.BusinessHoursId = ( businessHrsMap.get(thisRecord.Business_Hours__c) != null ?  businessHrsMap.get(thisRecord.Business_Hours__c).Id : null);
									hasDefault = false;
									entitlement.Name = accountObj.Name + ' - ' + (slaProcessMap.get(thisRecord.SLA_Process__c) != null ? 
								                                          slaProcessMap.get(thisRecord.SLA_Process__c).Name : '');
								}
								
								if(hasDefault){
									Entitlement_Account_Configuration__c defaultSetting =  new Entitlement_Account_Configuration__c();
									defaultSetting = Entitlement_Account_Configuration__c.getValues(DEFAULT_ENTITLEMENT); 
									if(defaultSetting != null){
										entitlement.BusinessHoursId = (businessHrsMap.get(defaultSetting.Business_Hours__c) != null ?  
										                               businessHrsMap.get(defaultSetting.Business_Hours__c).Id : null);
										entitlement.SlaProcessId = (slaProcessMap.get(defaultSetting.SLA_Process__c) != null ? 
										                            slaProcessMap.get(defaultSetting.SLA_Process__c).Id : null);
										entitlement.Name = accountObj.Name + ' - ' + (slaProcessMap.get(thisRecord.SLA_Process__c) != null ? 
								                                          slaProcessMap.get(thisRecord.SLA_Process__c).Name : '');
									}
								}
							}
						}	
						entitlements.add(entitlement);	
					}
				}
		}catch(Exception ex){
			System.debug('Exception ------>'+ex.getMessage()+' line Number--->'+ex.getLineNumber());
		}
		System.debug('Entitlements to be inserted ------>'+entitlements);
		return entitlements;	
	}

	/******************************************************************************
	* @Description : Method to determine the range of DL's (Lowest range),        *
	*                based on the configuration set in Custom Settings.           *
	* @Params      : Decimal, String                                              *
	* @Return      : Boolean                                                      * 
	******************************************************************************/		
	public static Boolean  isNumberOfDLsNullOrLessEqualOne(Decimal intNumberOfDL, String strNumberOfDls){
		
		if( intNumberOfDL == null){
			return true;
		}
		System.debug('isNumberOfDLsNullOrLessEqualOne--->'+ strNumberOfDls.split('-'));
		if(!String.isBlank(strNumberOfDls) && intNumberOfDL != null && !strNumberOfDls.contains('+')){
			List<String> arrayNumberOfDL = strNumberOfDls.split('-');
			if(intNumberOfDL >= Decimal.valueOf(arrayNumberOfDL.get(0)) && intNumberOfDL <= Decimal.valueOf(arrayNumberOfDL.get(1))){
				return true;
			}
		}
		return false;
	}

	/******************************************************************************
	* @Description : Method to determine the range of DL's (Mid range),           *
	*                based on the configuration set in Custom Settings.           *
	* @Params      : Decimal, String                                              *
	* @Return      : Boolean                                                      * 
	******************************************************************************/	
	public static Boolean  isNumberOfDLsMidRange(Decimal intNumberOfDL, String strNumberOfDls){
		System.debug('isNumberOfDLsMidRange--->'+ strNumberOfDls.split('-'));
		if(!String.isBlank(strNumberOfDls) && intNumberOfDL != null && !strNumberOfDls.contains('+')){
			List<String> arrayNumberOfDL = strNumberOfDls.split('-');
			if(intNumberOfDL>=Decimal.valueOf(arrayNumberOfDL.get(0)) && intNumberOfDL <= Decimal.valueOf(arrayNumberOfDL.get(1))){
				return true;
			}
		}
		return false;
	}

	/******************************************************************************
	* @Description : Method to determine the range of DL's (High range),          *
	*                based on the configuration set in Custom Settings.           *
	* @Params      : Decimal, String                                              *
	* @Return      : Boolean                                                      * 
	******************************************************************************/	
	public static Boolean  isNumberOfDLsHighRange(Decimal intNumberOfDL, String strNumberOfDls){
		System.debug('isNumberOfDLsHighRange--->'+ strNumberOfDls.split('-'));
		if(!String.isBlank(strNumberOfDls) && intNumberOfDL != null && strNumberOfDls.contains('+')){
			String strNumberOfDL = strNumberOfDls.substring(0, strNumberOfDls.indexOf('+'));
			if(intNumberOfDL >= Decimal.valueOf(strNumberOfDL)){
				return true;
			}
		}
		return false;
	}
	
	//Start Of Entitlement assignment on Case
	/******************************************************************************
	* @Description : Create Map of Account, Associated List of Entitlements.      *
	* @Params      : Set<String>                                                  *
	* @Return      : Map<Id, List<Entitlement>>                                   * 
	******************************************************************************/
	public static Map<Id, List<Entitlement>> getAccountEntitlement(set<String> accountIds) {
		Map<Id, List<Entitlement>> mapAccountToEntitlement = new Map<Id, List<Entitlement>>();
		if(accountIds != null) {
			List<Entitlement> entitlementList= [SELECT Id, Name, Type, AccountId, SlaProcessId, StartDate, Status, BusinessHoursId 
												FROM Entitlement 
												WHERE Status !=: EXPIRED AND AccountId IN: accountIds];      
			for(Entitlement entitleObj: entitlementList){
				if(mapAccountToEntitlement.get(entitleObj.AccountId) != null){
					mapAccountToEntitlement.get(entitleObj.AccountId).add(entitleObj);	
				}else{
					mapAccountToEntitlement.put(entitleObj.AccountId, new List<Entitlement>{entitleObj});	
				}	
			}
		}
		return mapAccountToEntitlement;
	}

	/******************************************************************************
	* @Description : Create Map of Account.                                       *
	* @Params      : Set<String>                                                  *
	* @Return      : Map<Id, Account>                                             * 
	******************************************************************************/	
	public static Map<Id, Account> getCaseAccountsMap(set<String> accountIds) {
		Map<Id, Account> mapAccounts = new Map<Id, Account>();
		if(accountIds != null) {
			mapAccounts = new Map<Id, Account>([SELECT Id, Name, RC_Service_name__c, RC_Brand__c, Number_of_DL_s__c 
												FROM Account 
												WHERE Id IN:accountIds]);
		}
		return mapAccounts;
	}

	/*******************************************************************************************************
	* @Description : Method to Assign created Entitlement on Cases based on the <record type , business hours>
	*                Contained in Custom Setting.                                                          *
	*				 	- If Entitlement with Business Hours <-> CaseRecordType found,                     *
	*				 	  assign that the case to that Entitlement.                                        *
	*				 	- If no Entitlement found, create a new Entitlement of that Business Hours,        * 
	*				 	  SLA Process and attached it to the Account & Case.                               *
	*				 	- If case escalated i.e., record type changed, find entitlement of                 *
	*				 	  new business hours, if found attach the case to that entitlement.                *
	*				 	- If no entitlement found above, create a new Entitlement of that Business Hours,  *
	*				 	  SLA Process and attached it to the Account & Case.                               *
	* @Params      : List<Case>, String                                                                    *
	* @Return      : void                                                                                  * 
	*******************************************************************************************************/	
	public static void entitleAssignmentOncase(List<Case> caseList, String caseTiggerType){
		
		Entitlement entitleObj =  null;
		Set<String> setAccountIds = new Set<String>();
		List<Entitlement> newEntitlementList = new List<Entitlement>();
		Map<Integer, Case> mapIntegerToCase = new Map<Integer, Case>();
		Map<Integer, Entitlement> mapIntegerToEntitle = new Map<Integer, Entitlement>();
		
		boolean existingEntitlement = false;
		String entitlementId = null;
		// Fetching map of all configured SLA Process.
		Map<Id, SlaProcess> slaProcessMap = getSLAProcessMap();
		
		try{
			// Fetching record type Id.
			Schema.DescribeSObjectResult d = Schema.SObjectType.Case; 
			Map<Id,Schema.RecordTypeInfo> rtMapById = d.getRecordTypeInfosById();
			system.debug('rtMapById--->'+rtMapById);
			
			for(Case caseObj : caseList){
				setAccountIds.add(caseObj.AccountId);
			}
			
			
			
			Map<Id, List<Entitlement>> mapAccountToEntitlement = getAccountEntitlement(setAccountIds);
			Map<Id, Account> mapAccounts = getCaseAccountsMap(setAccountIds);
			
			
			// eugenebasianomutya-------------THESE LINE OF CODES ARE NOT USED
			if(!mapAccounts.isEmpty()){
				for(String mapKey : mapAccounts.keySet()){
					if(mapAccountToEntitlement.get(mapKey) != null){
						for(Entitlement objEntitlement : mapAccountToEntitlement.get(mapKey)){
							 if(objEntitlement.Name.EqualsIgnoreCase(mapAccounts.get(mapKey).Name+' - '+DEFAULT_ENTITLEMENT)){
							 	existingEntitlement = true;
							 	entitlementId = objEntitlement.Id;
							 	break;
							 }
						}
					}
				}
			}
			//eugenebasianomutya -------------THESE LINE OF CODES ARE NOT USED
			
			
			
			 
			
			// eugenebasianomutya------------------------------------------------ This can be a code enhancement:
			
			map<string, Entitlement_Case_ReType_Configuration__c> EntCasRecTyp = Entitlement_Case_ReType_Configuration__c.getall();
			Entitlement_Case_ReType_Configuration__c defaultCaseTypeEntitleConfig = EntCasRecTyp.get(DEFAULT_ENTITLEMENT);
			
			Integer counter = 0;
			for(Case caseObject : caseList){ 
				entitleObj = new Entitlement();
				
				Entitlement_Case_ReType_Configuration__c caseTypeEntitleConfig = EntCasRecTyp.get(string.valueOf(rtMapById.get(caseObject.RecordTypeId).Name)); 
				
			
			//Entitlement_Case_ReType_Configuration__c defaultCaseTypeEntitleConfig = Entitlement_Case_ReType_Configuration__c.getValues(DEFAULT_ENTITLEMENT);
			
			//Integer counter = 0;
			//for(Case caseObject : caseList){ 
			//	entitleObj = new Entitlement();
			//	
			//	Entitlement_Case_ReType_Configuration__c caseTypeEntitleConfig = Entitlement_Case_ReType_Configuration__c.getValues(string.valueOf(rtMapById.get(caseObject.RecordTypeId).Name)); 
			//	system.debug('#### caseTypeEntitleConfig - '+caseTypeEntitleConfig);
			//	system.debug('#### case record type - '+caseObject.RecordType);
			//	system.debug('#### case record type Id - '+caseObject.RecordTypeId);
			//	system.debug('#### case record type Name - '+caseObject.RecordType.Name);
			//	system.debug('#### rtMapById.get(caseObject.RecordTypeId).Name - '+rtMapById.get(caseObject.RecordTypeId).Name);
				
			// eugenebasianomutya------------------------------------------------ This can be a code enhancement:	
				
				
				String accountName;
				if(mapAccounts != null && mapAccounts.get(caseObject.AccountId) != null){
					accountName = mapAccounts.get(caseObject.AccountId).Name;
				}else{
					accountName = '';
				}
					
				if(caseTypeEntitleConfig != null){
					if(mapAccountToEntitlement.get(caseObject.AccountId)!=null){
						Boolean isNewEntitle = true;
						/* If Entitlement found, of the same business hours on Account, attach the case to it. 
						   else Check isNewEntitle flag as true to create a new entitlement.*/
						for(Entitlement objEntitlement : mapAccountToEntitlement.get(caseObject.AccountId)){
							/*Below logic is replaced with slaprocess id check*/
							/*system.debug('#### business hours - '+objEntitlement.BusinessHoursId +' == '+caseTypeEntitleConfig.Business_Hours_Id__c);
								if(objEntitlement.BusinessHoursId == caseTypeEntitleConfig.Business_Hours_Id__c){
									caseObject.EntitlementId = objEntitlement.Id;
									isNewEntitle = false;
									system.debug('#### caseObject.EntitlementId - '+caseObject.EntitlementId);
								}*/
								
								/*Below logic is based on sla process id*/
								system.debug('#### SLAProcess Id - '+objEntitlement.SlaProcessId +' == '+caseTypeEntitleConfig.SLAProcessId__c);
								if(objEntitlement.SlaProcessId == caseTypeEntitleConfig.SLAProcessId__c){
									caseObject.EntitlementId = objEntitlement.Id;
									isNewEntitle = false;
									system.debug('#### caseObject.EntitlementId - '+caseObject.EntitlementId);
								}	
								
						}
						if(isNewEntitle && slaProcessMap.get(caseTypeEntitleConfig.SLAProcessId__c) != null){
	
						/*	entitleObj.Name = accountName + ' - ' + (slaProcessMap.get(caseTypeEntitleConfig.SLAProcessId__c) != null ? 
								                                          slaProcessMap.get(caseTypeEntitleConfig.SLAProcessId__c).Name : DEFAULT_ENTITLEMENT);*/
							entitleObj.Name = accountName + ' - ' + slaProcessMap.get(caseTypeEntitleConfig.SLAProcessId__c).Name;	                                          
							entitleObj.AccountId = caseObject.AccountId;
							entitleObj.StartDate = System.today();
							entitleObj.EndDate = null;
							entitleObj.BusinessHoursId = caseTypeEntitleConfig.Business_Hours_Id__c;
							entitleObj.SlaProcessId = caseTypeEntitleConfig.SLAProcessId__c;
							mapIntegerToCase.put(counter, caseObject);
							mapIntegerToEntitle.put(counter, entitleObj);
							counter++;
						}
					}else{
						/*	
							if(existingEntitlement){
								entitleObj = new Entitlement(Id = entitlementId);
							}
							entitleObj.Name = accountName + ' - ' + (slaProcessMap.get(caseTypeEntitleConfig.SLAProcessId__c) != null ? 
								                                          slaProcessMap.get(caseTypeEntitleConfig.SLAProcessId__c).Name : DEFAULT_ENTITLEMENT);
							*/
							if(slaProcessMap.get(caseTypeEntitleConfig.SLAProcessId__c) != null){
								entitleObj.Name = accountName + ' - ' + slaProcessMap.get(caseTypeEntitleConfig.SLAProcessId__c).Name;                                  
								entitleObj.AccountId = caseObject.AccountId;
								entitleObj.StartDate = System.today();
								entitleObj.EndDate = null;
								entitleObj.BusinessHoursId = caseTypeEntitleConfig.Business_Hours_Id__c;
								entitleObj.SlaProcessId = caseTypeEntitleConfig.SLAProcessId__c;
								mapIntegerToCase.put(counter, caseObject);
								mapIntegerToEntitle.put(counter, entitleObj);
								counter++;
							}
					}
				// create default entitlement in-case no configuration in custom setting. 
				}/* This else part for entitlement insertion on case creation */
				/*As no default entitlement should be created/updated so below logic is commented*/
				/*
				else{
					if(existingEntitlement){
						entitleObj = new Entitlement(Id = entitlementId);
					}
					entitleObj.Name = accountName + ' - ' + (slaProcessMap.get(caseTypeEntitleConfig.SLAProcessId__c) != null ? 
								                                          slaProcessMap.get(caseTypeEntitleConfig.SLAProcessId__c).Name : DEFAULT_ENTITLEMENT);
					entitleObj.AccountId = caseObject.AccountId;
					entitleObj.StartDate = System.today();
					entitleObj.EndDate = null;
					if(defaultCaseTypeEntitleConfig!=null){
						entitleObj.BusinessHoursId = defaultCaseTypeEntitleConfig.Business_Hours_Id__c;
						entitleObj.SlaProcessId = defaultCaseTypeEntitleConfig.SLAProcessId__c;
					}
					mapIntegerToCase.put(counter, caseObject);
					mapIntegerToEntitle.put(counter, entitleObj);
					counter++;
				}*/
				 else{
				 	if(slaProcessMap.get(caseTypeEntitleConfig.SLAProcessId__c) != null){
							entitleObj.Name = accountName + ' - ' + slaProcessMap.get(caseTypeEntitleConfig.SLAProcessId__c).Name;	                                          
							entitleObj.AccountId = caseObject.AccountId;
							entitleObj.StartDate = System.today();
							entitleObj.EndDate = null;
							entitleObj.BusinessHoursId = caseTypeEntitleConfig.Business_Hours_Id__c;
							entitleObj.SlaProcessId = caseTypeEntitleConfig.SLAProcessId__c;
							mapIntegerToCase.put(counter, caseObject);
							mapIntegerToEntitle.put(counter, entitleObj);
							counter++;
				 	}
				 }
			}
			//Insert Entitlement and attach it to the case.
			if(mapIntegerToEntitle != null && !mapIntegerToEntitle.isEmpty()){
				upsert mapIntegerToEntitle.values();
				Integer position = 0;
				for(Case caseObject : caseList){
					if(mapIntegerToEntitle.get(position) != null && mapIntegerToCase.get(position)!=null && 
					   mapIntegerToCase.get(position).AccountId == mapIntegerToEntitle.get(position).AccountId){
						
						caseObject.EntitlementId = mapIntegerToEntitle.get(position).Id;
					}
					position++;
				}
			}
		}catch(Exception ex){
			System.debug('Exception ---->'+ex.getMessage());
		}
	} /* End Of Entitlement assignment on case*/
} // End of Class