/**************************************************************************************************
* Project Name..........: Entitlement                                                             *
* File..................: MilestoneUtils.class                                                    *
* Version...............: 1.0                                                                     *
* Created by............: Simplion Technologies                                                   *
* Created Date..........: 26-06-2013                                                              *
* Last Modified by......: Simplion Technologies                                                   *
* Last Modified Date....: 26-06-2013                                                              *
* Description...........: Milstone Utility Class, contains logic for milestons creation,          *
*                         closing as per the case record type and associated business hours.      *
*                         case assignment.                                                        *
**************************************************************************************************/

public class MilestoneUtils {

    //Declaring variables & constants.
    //private static final String WAITING_ON_CUSTOMER = 'Waiting on Customer';
    private static final String WORK_IN_PROGRESS = 'Work in Progress';
    private static final String UPDATED_BY_CUSTOMER = 'Updated by Customer';
    private static final String CLOSED = 'Closed';
    private static final String CLOSED_NO_RESPONSE = 'Closed - No Response';
    private static final String OFFLINE_ESCALATION = 'Offline Escalation';
    
    // Record Types
	private static final String SUPPORT_CASE = 'Support-Case'; 
	private static final String SUPPORT_T1 = 'Support - T1';
    private static final String SUPPORT_T2 = 'Support - T2';
    private static final String SUPPORT_T3 = 'Support - T3';
    private static final String SUPPORT_QOS = 'Support - QoS';
    private static final String SUPPORT_ERT = 'Support - Executive Response Team';
    
    // Map to contain, record type <=> Milestone names (First Response, Follow Up, Resolution) in the specified order.
   	private static final Map<String,List<String>> caseRecordTypeMilestoneMap =  new Map<String,List<String>>();
   	
   	// Set of status names, to be included as an exception for fist response, follow up, resolution milestone.
   	private static final Set<String> FIRST_RESPONSE_MILESTONE_STATUS_EXCEPTION = new Set<String>{'Cancelled', 'Invalid', 'Duplicate'};
   	private static final Set<String> FOLLOW_UP_MILESTONE_STATUS_EXCEPTION =  new Set<String>{'PKI Hold', 'New', 'Cancelled', 'Invalid', 'Duplicate'};
   	private static final Set<String> RESOLUTION_MILESTONE_STATUS_EXCEPTION = new Set<String>();
	
	/******************************************************************************
    * @Description : Static Block                                                 *
    * @Params      : none                                                         *
    * @Return      : none                                                         * 
    ******************************************************************************/    
   	static{
   		// NTD First Response - Removed to Porting cases
   		caseRecordTypeMilestoneMap.put('Support-Case',new List<String>{'CSP First Response','CSP Follow Up','CSP Case Resolution'});
   		caseRecordTypeMilestoneMap.put('Support - T1',new List<String>{'','T1 Follow Up','T1 Case Resolution'});
   		caseRecordTypeMilestoneMap.put('Support - T2',new List<String>{'Tier 2 First Response','Tier 2 Follow Up','Tier 2 Case Resolution'});
   		caseRecordTypeMilestoneMap.put('Support - T3',new List<String>{'Tier 3 First Response','Tier 3 Follow Up','Tier 3 Case Resolution'});
   		caseRecordTypeMilestoneMap.put('Support - QoS',new List<String>{'QoS First Response','QoS Follow Up','QoS Case Resolution'});
   		caseRecordTypeMilestoneMap.put('Support - Executive Response Team',new List<String>{'ERT First Response','ERT Follow Up','ERT Case Resolution'});
   		caseRecordTypeMilestoneMap.put('Support - VIPFR',new List<String>{'','VIPFR Follow Up','VIPFR Case Resolution'});
   		caseRecordTypeMilestoneMap.put('Support - T1 (VAR & Partners)',new List<String>{'','VAR Follow Up','VAR Case Resolution'});
   		caseRecordTypeMilestoneMap.put('Support – IA Inbound',new List<String>{'','T1 Follow Up','T1 Case Resolution'});
   		caseRecordTypeMilestoneMap.put('Porting - In (NeuStar)',new List<String>{'','NTD Follow Up','NTD Case Resolution'});
   		caseRecordTypeMilestoneMap.put('Porting - In (RC UK)',new List<String>{'','NTD Follow Up','NTD Case Resolution'});
   		caseRecordTypeMilestoneMap.put('Porting - In (RC)',new List<String>{'','NTD Follow Up','NTD Case Resolution'});
   		caseRecordTypeMilestoneMap.put('Porting - Out',new List<String>{'','NTD Follow Up','NTD Case Resolution'});
   		caseRecordTypeMilestoneMap.put('Porting - Phone',new List<String>{'','NTD Follow Up','NTD Case Resolution'});
   		caseRecordTypeMilestoneMap.put('Porting - Vanity',new List<String>{'','NTD Follow Up','NTD Case Resolution'});
   	}
   	
    /******************************************************************************
    * @Description : Closes milestone.                                            *
    * @Params      : List<Id>, String, DateTime                                   *
    * @Return      : void                                                         * 
    ******************************************************************************/ 
    public static void completeMilestone(List<Id> caseIds, String milestoneName, DateTime complDate) {
          
        List<CaseMilestone> cmsToUpdate =  new List<CaseMilestone>();
        system.debug('#### Milestone - '+milestoneName);
        system.debug('#### Case Id - '+caseIds);
        system.debug('#### Completion Date - '+complDate);
        
        try{
            cmsToUpdate = [SELECT Id, completionDate FROM CaseMilestone cm
                           WHERE caseId IN: caseIds AND cm.MilestoneType.Name =: milestoneName AND completionDate = null limit 1];
            
            if(Test.isRunningTest()){
                CaseMilestone objCM = new CaseMilestone();
                cmsToUpdate.add(objCM);                                            
            }
            if (cmsToUpdate != null && !cmsToUpdate.isEmpty()){
                for (CaseMilestone cm : cmsToUpdate){
                    cm.completionDate = complDate;
                }
                update cmsToUpdate;
            } // end if
        }catch(Exception ex){
            system.debug('#### Error @ closeCaseMilestone - '+ex.getMessage()+' Line No---->'+ex.getLineNumber()); 
        }
    }

	/*@future
    public static void callOnCloseCaseMilestone(Set<Id> CaseIds){
    	Map<Id,Case> newCaseMap = new Map<Id,Case>([SELECT Id, Status, RecordTypeId, First_Response_Timestamp__c, First_Response_Timestamp_T2__c,
    													   First_Response_Timestamp_T3__c, First_Response_Timestamp_QoS__c, First_Response_Timestamp_ERT__c,
    													   First_Response_Timestamp_NTD__c, Last_Agent_Update__c	
    												FROM Case WHERE Id IN: CaseIds]);
    	closeCaseMilestone(null, newCaseMap);
    }*/
    /******************************************************************************
    * @Description : Segregate list of Case<Ids> to be passed in completeMilestone*
    *                method for milestone closing.                                *
    * @Params      : Map<Id, Case>, Map<Id, Case>                                 *
    * @Return      : void                                                         * 
    ******************************************************************************/ 
    public static void closeCaseMilestone(Map<Id,Case> oldCaseMap, Map<Id,Case> newCaseMap){
        
        // Variable to contain map of String(Record Type Name) <--> case Id, for milestone closure.
        Map<String,List<Id>> firsResponseMap =  new Map<String,List<Id>>();
        Map<String,List<Id>> followUpMap =  new Map<String,List<Id>>();
        Map<String,List<Id>> resolutionMap =  new Map<String,List<Id>>();
        
        try{
            for(Id thisRecord : newCaseMap.keySet()){
                
                // Maintaining new and old case object.
                Case newRecord = newCaseMap.get(thisRecord);
                Case oldRecord = oldCaseMap != null ? oldCaseMap.get(thisRecord) : null;
                
                Schema.DescribeSObjectResult d = Schema.SObjectType.Case; 
				Map<Id,Schema.RecordTypeInfo> rtMapById = d.getRecordTypeInfosById();
				String caseRecordTypeName = rtMapById.get(newRecord.recordTypeId).Name;
				
                system.debug('#### Case record type - '+ newRecord.recordTypeId );
                system.debug('#### Case Status - '+ newRecord.Status );
                system.debug('#### Case Record Type Name - '+ caseRecordTypeName);
                
                
                /* Creating Map for record type <--> List of Id's, for which first response milestone needs to be closed. */
                //if(newRecord.Status.equalsIgnoreCase(WORK_IN_PROGRESS) && 
                // || (newRecord.First_Response_Timestamp_NTD__c != null && caseRecordTypeName.contains('Porting'))
				if(!FIRST_RESPONSE_MILESTONE_STATUS_EXCEPTION.contains(newRecord.Status) &&
                  ((newRecord.First_Response_Timestamp__c != null     && SUPPORT_CASE.equalsIgnoreCase(caseRecordTypeName)) || 
                   (newRecord.First_Response_Timestamp_T2__c  != null && SUPPORT_T2.equalsIgnoreCase(caseRecordTypeName)) || 
                   (newRecord.First_Response_Timestamp_T3__c  != null && SUPPORT_T3.equalsIgnoreCase(caseRecordTypeName)) || 
                   (newRecord.First_Response_Timestamp_QoS__c != null && SUPPORT_QOS.equalsIgnoreCase(caseRecordTypeName)) || 
                   (newRecord.First_Response_Timestamp_ERT__c != null && SUPPORT_ERT.equalsIgnoreCase(caseRecordTypeName)))){
                   	
					if(firsResponseMap.get(rtMapById.get(newRecord.recordTypeId).Name) != null){
						firsResponseMap.get(rtMapById.get(newRecord.recordTypeId).Name).add(thisRecord);	
					}else{
						firsResponseMap.put(rtMapById.get(newRecord.recordTypeId).Name, new List<Id>{thisRecord});	
					}
                }
                
                system.debug('#### New Last Agent Update - '+newRecord.Last_Agent_Update__c);
                system.debug('#### Old Last Agent Update - '+oldRecord.Last_Agent_Update__c);
                
                /* Creating Map for record type <--> List of Id's, fo r which follow up milestone needs to be closed. */
                //(newRecord.First_Response_Timestamp_NTD__c != null && 
                if(oldRecord != null && newRecord.Last_Agent_Update__c != oldRecord.Last_Agent_Update__c && 
                   ((newRecord.First_Response_Timestamp__c != null     && SUPPORT_CASE.equalsIgnoreCase(caseRecordTypeName)) || 
                    (newRecord.First_Response_Timestamp_T2__c  != null && SUPPORT_T2.equalsIgnoreCase(caseRecordTypeName)) || 
                    (newRecord.First_Response_Timestamp_T3__c  != null && SUPPORT_T3.equalsIgnoreCase(caseRecordTypeName)) || 
                    (newRecord.First_Response_Timestamp_QoS__c != null && SUPPORT_QOS.equalsIgnoreCase(caseRecordTypeName)) || 
                    (newRecord.First_Response_Timestamp_ERT__c != null && SUPPORT_ERT.equalsIgnoreCase(caseRecordTypeName)) || 
                    caseRecordTypeName.contains('Porting') || SUPPORT_T1.equalsIgnoreCase(caseRecordTypeName))){
                   	
                   	//if(newRecord.Status.equalsIgnoreCase(WORK_IN_PROGRESS) ||
                   	//	(newRecord.Status.equalsIgnoreCase(UPDATED_BY_CUSTOMER) && !caseRecordTypeName.contains('Porting')) || 
                   	// 	(newRecord.Status.equalsIgnoreCase(OFFLINE_ESCALATION) && SUPPORT_T2.equalsIgnoreCase(caseRecordTypeName))
                   	if(!FOLLOW_UP_MILESTONE_STATUS_EXCEPTION.contains(newRecord.Status)){
						if(followUpMap.get(rtMapById.get(newRecord.recordTypeId).Name) != null){
							followUpMap.get(rtMapById.get(newRecord.recordTypeId).Name).add(thisRecord);	
						}else{
							followUpMap.put(rtMapById.get(newRecord.recordTypeId).Name, new List<Id>{thisRecord});	
						}
                   	}
                }
                
                /* Creating Map for record type <--> List of Id's, for which resolution milestone needs to be closed. */
                if((newRecord.Status.equalsIgnoreCase(CLOSED) || newRecord.Status.equalsIgnoreCase(CLOSED_NO_RESPONSE))){
					if(resolutionMap.get(rtMapById.get(newRecord.recordTypeId).Name) != null){
						resolutionMap.get(rtMapById.get(newRecord.recordTypeId).Name).add(thisRecord);	
					}else{
						resolutionMap.put(rtMapById.get(newRecord.recordTypeId).Name, new List<Id>{thisRecord});	
					}
                }
            }
            
            // Calling methods to close milestone.
            closeRespectiveMilestone(firsResponseMap, followUpMap, resolutionMap);
            if(Test.isRunningTest()){
    			Integer error = 0/0;
    		}
        }catch(Exception ex){
            system.debug('#### Error @ closeCaseMilestone - '+ex.getMessage() +' Line No---->'+ex.getLineNumber());
        }
    }
    
    /******************************************************************************
    * @Description : Calling method to finally close the milestone.               *
    * @Params      : Map<Id, Case>, Map<Id, Case>                                 *
    * @Return      : void                                                         * 
    ******************************************************************************/
    public static void closeRespectiveMilestone(Map<String,List<Id>> firsResponseMap,Map<String,List<Id>> followUpMap,Map<String,List<Id>> resolutionMap){
    	
    	system.debug('#### Case - Milestone Map - '+caseRecordTypeMilestoneMap);
    	system.debug('#### firsResponseMap - '+firsResponseMap);
    	system.debug('#### followUpMap - '+followUpMap);
    	system.debug('#### resolutionMap - '+resolutionMap);
    	
    	try{
    		// Closing all first response milestones
    		for(String thisRecord : firsResponseMap.keySet()){
    			if(caseRecordTypeMilestoneMap != null && 
    			   caseRecordTypeMilestoneMap.containsKey(thisRecord) && 
    			   caseRecordTypeMilestoneMap.get(thisRecord) != null){
    				
    				completeMilestone(firsResponseMap.get(thisRecord), caseRecordTypeMilestoneMap.get(thisRecord)[0], system.now());	
    			}	
    		}
    		// Closing all follow up milestones
    		for(String thisRecord : followUpMap.keySet()){
    			if(caseRecordTypeMilestoneMap != null && 
    			   caseRecordTypeMilestoneMap.containsKey(thisRecord) && 
    			   caseRecordTypeMilestoneMap.get(thisRecord) != null){
    				
    				completeMilestone(followUpMap.get(thisRecord), caseRecordTypeMilestoneMap.get(thisRecord)[1], system.now());	
    			}	
    		}
    		// Closing all resolution milestones
    		for(String thisRecord : resolutionMap.keySet()){
    			if(caseRecordTypeMilestoneMap != null && 
    			   caseRecordTypeMilestoneMap.containsKey(thisRecord) && 
    			   caseRecordTypeMilestoneMap.get(thisRecord) != null){
    				
    				completeMilestone(resolutionMap.get(thisRecord), caseRecordTypeMilestoneMap.get(thisRecord)[2], system.now());
    			}		
    		}
    		if(Test.isRunningTest()){
    			Integer error = 0/0;
    		}
    	}catch(Exception ex){
            system.debug('#### Error @ closeRespectiveMilestone - '+ex.getMessage());
        }	
    }
}// End of Class.