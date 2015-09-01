/**************************************************************************************************
* Project Name..........: Case # 22728120                                                         *
* File..................: ApprovalFuture.class                                                    *
* Version...............: 1.0                                                                     *
* Created by............: Simplion Technologies                                                   *
* Created Date..........: 01-10-2014                                                              *
* Last Modified by......: Simplion Technologies                                                   *
* Last Modified Date....: 01-10-2014                                                              *
* Description...........: This class sets the current approver custom field with the,             *
*						  latest AssignedTo value from the Approval History.                      *
**************************************************************************************************/

global class ApprovalFuture {
	@future 
	/**********************************************************************************************
	* @Description - Future method to fetch Approval Steps, method created as future,             *
	*				 because query on Process Instance returns value only on future method.       *                                     
	* @params Set<Id>, set of approval Id's                                                       *
	* @return void                                                                                * 
	**********************************************************************************************/
 	public static void getApprovalSteps(set<Id> setApprovalId) {  
 		
 		
 		try{
	 		// Contains list of Process Instance,Workitems,Steps,StepsandWorkitems records.	
	 		List<ProcessInstance> processList = new List<ProcessInstance>();
	 		processList = [SELECT TargetObjectId,
	 							 (SELECT OriginalActorId, ActorId, CreatedDate,OriginalActor.Name FROM Workitems order by createddate desc limit 1),
								 (SELECT StepStatus, OriginalActorId, ActorId,OriginalActor.Name ,CreatedDate FROM Steps order by createddate desc limit 1),
								 (SELECT StepStatus, OriginalActorId, ActorId, CreatedDate,OriginalActor.Name FROM StepsAndWorkitems order by createddate desc limit 1)
						   FROM ProcessInstance 
						   WHERE TargetObjectId IN :setApprovalId order by createddate asc];
			System.Debug('###1'+ processList);									
	     	System.Debug('###1'+ processList[0]);
	      	System.Debug('###2'+ processList[0].Workitems);
	      	System.Debug('###3'+ processList[0].Steps);
	      	System.Debug('###4'+ processList[0].StepsAndWorkitems);
	      	
	      	// Map <Target Object Id,AssignedTo Name>
	      	Map<Id,string> currentApproverMap = new Map<Id,string>();
	      	Map<Id,string> StatusMap = new Map<Id,string>();
	      
	      	for(ProcessInstance processObj : processList) {
	      		System.Debug('###processObj'+ processObj);
	      		System.Debug('###processObj'+ processObj.Workitems);
	      		if(processObj.Workitems != null && processObj.Workitems.size()>0) {// if PENDING for approval.....
	      			currentApproverMap.put(processObj.TargetObjectId,processObj.Workitems[0].OriginalActor.Name);
	      		}else if(processObj.StepsAndWorkitems != null && processObj.StepsAndWorkitems.size()>0) { // For already APPROVED OR REJECTED Records....
	      			currentApproverMap.put(processObj.TargetObjectId,processObj.StepsAndWorkitems[0].OriginalActor.Name);
	      		}
	      	}
	      	System.Debug('###5'+ currentApproverMap);
      		
	      	//Traverses over all the approval id's, and find its match in Map, 
	      	//if match found, set the current approver field.
	      	List<Approval__c> lstApprovalUpd = new List<Approval__c>();
	      	if(currentApproverMap != null) {
		      	for(Id idObj : setApprovalId) {
		      		if(currentApproverMap.get(idObj) != null) {
			      		Approval__c objUpd = new Approval__c(id = idObj);
			      		objUpd.Current_Approver__c = currentApproverMap.get(idObj);
			      		lstApprovalUpd.add(objUpd); 
		      		} 
		      	}
	 		}  
	      	if(lstApprovalUpd.size()>0) {
	      		TriggerHandler.BY_PASS_Approver_Trigger = true;
	      		update lstApprovalUpd;
	      	}
      	}catch(Exception ex){
      		system.debug('#### Exception - '+ex.getMessage());
      	}
 	}
}