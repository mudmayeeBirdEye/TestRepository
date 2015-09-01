/******************************************************************************
* Project Name..........: 													  *
* File..................: Severity1_CaseHelperClass  						  *
* Version...............: 1.0 												  *
* Created by............: Simplion Technologies 							  *
* Created Date..........: 30th August 2013 									  *
* Last Modified by......: Simplion Technologies 							  *
* Last Modified Date....: 													  *
* Description...........: This is helper class for Severity1_CaseTrigger      *
******************************************************************************/

public class Severity1_CaseHelperClass {

	// Method for fetching org wide email address for from address
	public static OrgWideEmailAddress getOrgWideAddress() {
		return [SELECT Id, DisplayName, Address FROM OrgWideEmailAddress WHERE DisplayName = 'Business Services' LIMIT 1];
	}
	
	// Method for checking the business logic and sending email
	public static Boolean checkForEmail(Map<Id,Case> triggerMap, Map<Id, Case> oldMapObj){
		
		/* Declaring Variables*/
		Map<Id,Account> caseAccountMap = new Map<Id,Account>();
		// Map to contain account Id, case Id
		Map<Id,Id> caseAccountId =  new Map<Id,Id>();
		List<Exception_And_Notification_History__c> notificationList = new List<Exception_And_Notification_History__c>();
		
		// Fetching record type for Exception_And_Notification_History_c object, Email Notification
		Schema.DescribeSObjectResult resultENH = Exception_And_Notification_History__c.SObjectType.getDescribe();
	    Map<String,Schema.RecordTypeInfo> enhMapByName = resultENH.getRecordTypeInfosByName(); 
		
		// Fetching record type for Case object, Support Case
		Schema.DescribeSObjectResult resultCase = Case.SObjectType.getDescribe();
	    Map<String,Schema.RecordTypeInfo> caseMapByName = resultCase.getRecordTypeInfosByName();
	    
	    // Looping the triggered cases to create Map of <AccountId,CaseId>
	    for(Id thisId : triggerMap.keySet()){
	    	caseAccountId.put(triggerMap.get(thisId).AccountId,thisId);
	    }
	    // Looping the triggered cases to create Map of <CaseId,Account>
	    for(Account thisAccount : [SELECT Current_Owner__c,Current_Owner__r.IsActive,Id,Current_Owner__r.Email,Name 
	    						   FROM Account WHERE Id in: caseAccountId.keySet()]){
			caseAccountMap.put(caseAccountId.get(thisAccount.Id),thisAccount);
	    }
	    	    
		// LoOp over the case list fetched			
		for(Id thisCase : triggerMap.keySet()){
			/* check if the record type is Support-Case,Case severity is Level 1 - Critical,
			Account Current Owner is not null / inactive, If account owner is null / inactive than no action.*/
			if(triggerMap.get(thisCase).RecordTypeId == caseMapByName.get('Support-Case').getRecordTypeId() 
				&& caseAccountMap.get(thisCase).Current_Owner__c != null 
				&& caseAccountMap.get(thisCase).Current_Owner__r.IsActive ==  true
				&& triggerMap.get(thisCase).Case_Severity__c == 'Level 1 - Critical' 
				&& (oldMapObj == null || triggerMap.get(thisCase).get('Case_Severity__c') != oldMapObj.get(thisCase).get('Case_Severity__c'))){
				   	// Inserting records in Exception_And_Notification_History__c object to send an email
				   	Exception_And_Notification_History__c thisNotification = new Exception_And_Notification_History__c();
				   	thisNotification.To_Address_1__c = caseAccountMap.get(thisCase).Current_Owner__r.Email;
				   	thisNotification.Email_Subject__c = 'An account you own has a Severity 1 Case';
				   	thisNotification.Object_Type__c = 'Case';
				   	thisNotification.RecordTypeId = enhMapByName.get('Email Notification').getRecordTypeId();
				   	thisNotification.content_label_01__c = 'SEVERITY1_CASE_TRIGGER_NOTIFICATION';
				   	thisNotification.content_label_02__c = caseAccountMap.get(thisCase).Name;
				   	thisNotification.content_label_03__c = caseAccountMap.get(thisCase).Id;
				   	thisNotification.Reply_To__c = getOrgWideAddress().Address;		   	
				   	notificationList.add(thisNotification);
			   }
		}
		
		// Inserting records
		try{
			insert notificationList;
			system.debug('#### Email Notification - '+notificationList);
			return true;
		}catch(DMLException dmle){
			system.debug('#### Exception encountered - '+dmle);
			return false;
		}
	}
}