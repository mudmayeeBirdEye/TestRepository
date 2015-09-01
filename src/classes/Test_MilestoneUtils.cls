/**************************************************************************************************
* Project Name..........: Entitlement                                                             *
* File..................: MilestoneUtils.class                                                    *
* Version...............: 1.0                                                                     *
* Created by............: Simplion Technologies                                                   *
* Created Date..........: 19-06-2014                                                              *
* Last Modified by......: Simplion Technologies                                                   *
* Last Modified Date....: 19-06-2014                                                              *
* Description...........: Test Class for Milestone Utility.                                       *
**************************************************************************************************/
@isTest
private class Test_MilestoneUtils {
	
	// Creating Test Utils object to create call method and setup test records.
	public static Test_Utils testObject = new Test_Utils(); 
	
    static testMethod void testPositiveCase1() {
    	try{
    		
    		TriggerHandler.BY_PASS_CASE_ON_INSERT();
    		TriggerHandler.BY_PASS_CASE_ON_UPDATE();
    		
    		List<Case> caseRecordList = testObject.createCaseRecord(new List<Case>{new Case(), new Case()});
    		if(caseRecordList != null){
    			// Testing for First Response Milestones
    			caseRecordList[0].Status = 'Work in Progress';
    			caseRecordList[0].First_Response_Timestamp__c = system.now();
    			caseRecordList[0].RecordTypeId = getCaseRecordTypeId('Support-Case');
    			
    			caseRecordList[1].Status = 'Work in Progress';
    			caseRecordList[1].First_Response_Timestamp__c = system.now();
    			caseRecordList[1].RecordTypeId = getCaseRecordTypeId('Support-Case');
    			update caseRecordList;
    			
    			// Testing for Follow Up Milestones
    			caseRecordList[0].Last_Agent_Update__c = system.now();
    			caseRecordList[1].Last_Agent_Update__c = system.now();
    			update caseRecordList;
    			
    			// Testing for Closed Milestone
    			caseRecordList[0].Status = 'Closed';
    			caseRecordList[1].Status = 'Closed';
    			update caseRecordList;
    		}		
    	}catch(Exception ex){
    		system.debug('#### Error in Test_MilestoneUtils - Line - '+ex.getLineNumber());
    		system.debug('#### Error in Test_MilestoneUtils - Message - '+ex.getMessage());
    	}
    }
    
    private static Id getCaseRecordTypeId(String caseRecordTypeName){
    	Schema.DescribeSObjectResult d = Schema.SObjectType.Case; 
		Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
		
		return rtMapByName.get(caseRecordTypeName).recordTypeId;
    }
}