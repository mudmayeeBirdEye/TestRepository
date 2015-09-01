public class PortingESBHelper {
	private static final String PortingInNeuStar = 'Porting - In (NeuStar)';
    private static final String PortingInRC = 'Porting - In (RC)';
    private static final String PortingInTelus = 'Porting - In (TELUS)';
    private static final String PortingInRCUK = 'Porting - In (RC UK)';
    private static final String PortingIn  = 'Porting - In';
    private static final String PortingVanity  = 'Porting - Vanity';
	/**************************
	*This method is used to validate the input accepting for RCESB user only.
	*@param caseList(trigger.new) 
	*@param rtMapByName(schema describe)
	**************************/
	public static void validateOnBeforeInsertEvent(List<Case> caseList, Map<ID,Schema.RecordTypeInfo> rtMapByName) {
		for(Case caseObj : caseList) {
        	caseObj.IsUpdatePermitted__c = true;
            Boolean isNeuStarCase = (caseObj.RecordTypeId != null && rtMapByName.get(caseObj.RecordTypeId ).getName() == 'Porting - In (NeuStar)' ? true : false);
			Boolean isPortingRcCase = (caseObj.RecordTypeId != null &&  rtMapByName.get(caseObj.RecordTypeId ).getName() == 'Porting - In (RC)' ? true : false);
			Boolean isPortingTelusCase = (caseObj.RecordTypeId != null &&  rtMapByName.get(caseObj.RecordTypeId ).getName() == 'Porting - In (TELUS)' ? true : false);
			Boolean isPortingRcUKCase = (caseObj.RecordTypeId != null &&  rtMapByName.get(caseObj.RecordTypeId ).getName() == 'Porting - In (RC UK)' ? true : false);
            
            Boolean RCESB_USER = (UserInfo.getName() == 'RCESB' ? true : false);
            if(isNeuStarCase || isPortingRcCase || isPortingTelusCase || isPortingRcUKCase) {
                if(!RCESB_USER) {
                    caseObj.IsUpdatePermitted__c = false;
                }
            }
        }
	}
	/**************************
	* This method is used to validate the input accepting for RCESB/Support Manager Parting, Support Agent Porting users only.
	*@param caseList(trigger.new) 
	*@param oldCaseMap(trigger.oldMap)
	*@param rtMapById(schema for care record type ids)
	*@param rtMapByName(schema describe for case record type names)
	*@param prof(user profile)
	**************************/
	public static void validateOnBeforeUpdateEvent(List<Case> caseList, Map<Id, Case> oldCaseMap, 
		Map<ID,Schema.RecordTypeInfo> rtMapByName, Map<string,Schema.RecordTypeInfo> rtMapById, Profile prof) {
        for(Case caseObj : caseList) {
            caseObj.IsUpdatePermitted__c = true;
            Case oldCaseObj = oldCaseMap.get(caseObj.Id);
            Boolean isNeuStarCase = (caseObj.RecordTypeId != null && rtMapByName.get(caseObj.RecordTypeId ).getName() == 'Porting - In (NeuStar)' ? true : false);
			Boolean isPortingRcCase = (caseObj.RecordTypeId != null &&  rtMapByName.get(caseObj.RecordTypeId ).getName() == 'Porting - In (RC)' ? true : false);
			Boolean isPortingTelusCase = (caseObj.RecordTypeId != null &&  rtMapByName.get(caseObj.RecordTypeId ).getName() == 'Porting - In (TELUS)' ? true : false);
			Boolean isPortingRcUKCase = (caseObj.RecordTypeId != null &&  rtMapByName.get(caseObj.RecordTypeId ).getName() == 'Porting - In (RC UK)' ? true : false);
			
			Boolean SYSTEM_ADMIN = (prof.Name == 'System Administrator' ? true : false);
			Boolean SUPPORT_AGENT_PORTING = (prof.Name == 'Support Agent - Porting' ? true : false);
			Boolean SUPPORT_MANAGER_PORTING = (prof.Name == 'Support Manager - Porting' ? true : false);
			Boolean RCESB_USER = (UserInfo.getName() == 'RCESB' ? true : false);
			
            /**************************** Change of Status, Reject Reason or Estimated completion date ***************************/
            
                if((caseObj.Status!= oldCaseObj.Status) 
                    || (caseObj.Porting_Reject_Reason__c !=  oldCaseObj.Porting_Reject_Reason__c)
                    || (caseObj.Porting_Estimated_Completion_Date__c != oldCaseObj.Porting_Estimated_Completion_Date__c)) {
		            if(isNeuStarCase) {
		            	if(!RCESB_USER) {
		            		caseObj.IsUpdatePermitted__c = false;
		            	}
                	} else if(isPortingRcCase || isPortingTelusCase || isPortingRcUKCase ) {
                		if(RCESB_USER || SYSTEM_ADMIN || SUPPORT_AGENT_PORTING || SUPPORT_MANAGER_PORTING) {
	                		caseObj.Porting_last_status_change_date__c = System.now();
		            	} else {
		            		caseObj.IsUpdatePermitted__c = false;
		            	}
                	}
            	}
            /**************************** ********************************************************************** ***************************/
            if(isNeuStarCase 
            	&& (oldCaseObj.Convert_to_Internal_Porting__c != caseObj.Convert_to_Internal_Porting__c)) {
            	if(RCESB_USER || SYSTEM_ADMIN || SUPPORT_AGENT_PORTING || SUPPORT_MANAGER_PORTING) {
	            		if(caseObj.Convert_to_Internal_Porting__c != null 
	            			&& (caseObj.Convert_to_Internal_Porting__c == 'Porting - In (RC)')) {
	                        caseObj.RecordTypeId = rtMapById.get('Porting - In (RC)').getRecordTypeId();  //'012S00000008ssB';   	// Change record type to "Porting - In (RC)"
	                    }
                    caseObj.IsUpdatePermitted__c = true;
            	} else {
            		caseObj.IsUpdatePermitted__c = false;
            	}
            }
        
            /**************************** ********************************************************************** ***************************/
            
            if(isNeuStarCase 
            	 && (oldCaseObj.isLastCaseCommentPublic__c != caseObj.isLastCaseCommentPublic__c 
                 || oldCaseObj.Last_Case_Comment__c != caseObj.Last_Case_Comment__c 
                 || oldCaseObj.Last_Public_Comment__c != caseObj.Last_Public_Comment__c 
                 || oldCaseObj.Last_Public_Comment_Timestamp__c != caseObj.Last_Public_Comment_Timestamp__c) && 
                (!RCESB_USER && !SYSTEM_ADMIN && !SUPPORT_AGENT_PORTING && !SUPPORT_MANAGER_PORTING)) {
                    caseObj.IsUpdatePermitted__c = false;
            } 
        }
	}
	/**************************
	*This method is used to validate the fields for creating NeuStar/Porting - In RC/Prting - RC UK cases.
	*@param caseList(trigger.new) 
	*@param rtMapByName(schema describe)
	*@param oldCaseMap(trigger.oldMap)
	**************************/
	public static void validateOnAfterUpdateEvent(List<Case> caseList,  Map<Id, Case> oldCaseMap, Map<ID,Schema.RecordTypeInfo> rtMapByName) {
		for(Case newCaseObj : caseList) {
          	Case oldCaseObj = oldCaseMap.get(newCaseObj.Id);
          	Boolean isNeuStarCase = (rtMapByName.get(newCaseObj.RecordTypeId ).getName() == 'Porting - In (NeuStar)' ? true : false);
          	Boolean isPortingRcCase = (rtMapByName.get(newCaseObj.RecordTypeId ).getName() == 'Porting - In (RC)' ? true : false);
          	Boolean isPortingTelusCase = (rtMapByName.get(newCaseObj.RecordTypeId ).getName() == 'Porting - In (TELUS)' ? true : false);
          	Boolean isPortingRcUKCase = (rtMapByName.get(newCaseObj.RecordTypeId ).getName() == 'Porting - In (RC UK)' ? true : false);
          	
          	Boolean RCESB_USER = (UserInfo.getName() == 'RCESB' ? true : false);
			if(isNeuStarCase || isPortingRcCase || isPortingTelusCase || isPortingRcUKCase){
        		Boolean errorOccured = false;
				if(newCaseObj.RC_Porting_Order_ID__c == null) {
                	newCaseObj.RC_Porting_Order_ID__c.addError('Porting Order Id must not be blank.');
                	errorOccured = true;
                }
               	if(String.isBlank(newCaseObj.RC_User_Id__c)) {
					newCaseObj.RC_User_Id__c.addError('User Id must not be blank in associate Account.');
					errorOccured = true;
               	}
               	if(newCaseObj.Status == null) {
					newCaseObj.Status.addError('Status can not be none.');
					errorOccured = true;
               	}
               	if(newCaseObj.Porting_last_status_change_date__c == null) {
                   newCaseObj.Porting_last_status_change_date__c.addError('Porting last status change date can not be empty');
                   errorOccured = true;
               	}
               	if(!isNeuStarCase 
               		&& newCaseObj.Status == 'Rejected' 
               		&& newCaseObj.Porting_Reject_Reason__c == null) {
					newCaseObj.Porting_Reject_Reason__c.addError('Porting Reason is missing.');	
					errorOccured = true;
               	}
               	if(!isNeuStarCase 
               		&& newCaseObj.Status == 'Transfer Date Confirmed' 
               		&& newCaseObj.Porting_Estimated_Completion_Date__c == null) {
               		newCaseObj.Porting_Estimated_Completion_Date__c.addError('Porting Estimated Completion Date is Missing.');
               		errorOccured = true;
               	}
               	if(isNeuStarCase && (newCaseObj.Porting_last_status_change_date__c < oldCaseObj.Porting_last_status_change_date__c)) {
               		newCaseObj.Porting_last_status_change_date__c.addError('Porting Last Status can not be past date.');
               		errorOccured = true;
               	} 
               	Boolean updateESB = false;
               	/*if((newCaseObj.status != oldCaseObj.status 
              		|| newCaseObj.Porting_Reject_Reason__c != oldCaseObj.Porting_Reject_Reason__c)
              		&& rtMapByName.get(newCaseObj.RecordTypeId ).getName() == 'Porting - In'
          		) { 
          			if(!errorOccured) {
          				updateESB = true;
                   	}
          		}*/
				if((newCaseObj.Porting_last_status_change_date__c != oldCaseObj.Porting_last_status_change_date__c)
              		&& (rtMapByName.get(newCaseObj.RecordTypeId ).getName() == 'Porting - In (RC)' 
              		|| rtMapByName.get(newCaseObj.RecordTypeId ).getName() == 'Porting - In (TELUS)' 
              		|| rtMapByName.get(newCaseObj.RecordTypeId ).getName() == 'Porting - In (RC UK)')
          		) { 
          			System.Debug('>>>222>>>');
          			if(!errorOccured && !RCESB_USER) {
          				updateESB = true;
                   	}
          		}
          		if(updateESB) {
          			if(!Test.isRunningTest()) {
          				RC_ESB_PortingOrderHelper.updatePortingOrder(newCaseObj.id);
          			}
          		}
           }
		}
	}
	/********************************************************************************************************
    * @Description : Method to fill Porting Case contact if on case insert/Update its empty                 *
    * @Params      : List of Case(Trigger.new)                                                              *
    * @param       : rtMapByName(schema describe)                                                           * 
    * @Return      : void                                                                                   * 
    * @Added By    : Simplion Technologies                                                                  *
    ********************************************************************************************************/
    public static void populatePrimaryContactForPortingCase(List<Case> caseList, Map<ID,Schema.RecordTypeInfo> rtMapByName){
        Set<Id> accountIdSet = new Set<Id>();
        Map<Id,Id> accountToContactMap = new Map<Id,Id>();
        
        
        for(Case caseObj : caseList){
            if((rtMapByName.get( caseObj.RecordTypeId ).getName() == PortingIn 
            || rtMapByName.get( caseObj.RecordTypeId ).getName() == PortingInNeuStar
            || rtMapByName.get( caseObj.RecordTypeId ).getName() == PortingInRC
            || rtMapByName.get( caseObj.RecordTypeId ).getName() == PortingInRCUK
            || rtMapByName.get( caseObj.RecordTypeId ).getName() == PortingVanity)
            && (caseObj.ContactId == NULL )
            ){
                if(caseObj.AccountId != NULL){
                    accountIdSet.add(caseObj.AccountId);
                }       
            }
        }
        List<AccountContactRole> accountContactRoleList = [SELECT AccountId, Contact.Name,Contact.FirstName,Contact.LastName,isPrimary,Role,Contact.Email,
                                                Contact.Phone,ContactId FROM AccountContactRole WHERE AccountId IN: accountIdSet AND IsPrimary = true];
        for(AccountContactRole acr : accountContactRoleList){
            accountToContactMap.put(acr.AccountId,acr.ContactId);   
        }
        
        for(Case caseObj : caseList){                                   
            if(caseObj.AccountId != NULL && accountToContactMap != NULL && accountToContactMap.containsKey(caseObj.AccountId) && accountToContactMap.get(caseObj.AccountId) != NULL){
                caseObj.ContactId = accountToContactMap.get(caseObj.AccountId);
            }    
        }
    }
}