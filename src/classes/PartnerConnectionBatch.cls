//--------------------------------As/Simplion/10/16/2014 start-------------------------------------------------
global class PartnerConnectionBatch implements Database.Batchable<Sobject>,Database.AllowsCallouts {
	
	global Iterable<Sobject>  start(Database.BatchableContext bc){
           //--------------------------------As/Simplion/10/16/2014 start------------------------------------------------- 
			List<Case> caseList = new List<Case>();
			    Map<Id,Case> caseMap = new Map<Id,Case>([select Id,Type,Status,RecordTypeId,RecordType.name,
			     							  (select Id,name,Returned_Date__c from Devices__r) 
			     							   from case where Type = 'VoIP Device Return' AND Status = 'Closed' 
			     							   AND RecordType.Name = 'Support - T1 (Shipping)']);
			caseList =    caseMap.values();  		 
			for(Case caseRecord : caseList){
			     			List<Device__c> deviceList = caseRecord.Devices__r;
			     			//-----------Check If any of device don't have return date then remove the case from excecution---------
			     			for(Device__c device : deviceList){
			                    if(device.Returned_Date__c == null){ 
			                        caseMap.remove(caseRecord.Id);
			                        continue;
			                        
			                    }
			     			}
			     		}
			return caseMap.values();	  
    } 
     
    global void execute(Database.BatchableContext bc , List<Sobject> scope){
     	if(scope != null && scope.size() >0){
     		//-----------------------------Close all cases returned from start method of this bathc------------------
     		for(Case caseRecord : (List<Case>)scope){
     			caseRecord.Partner_Case_Status__c = 'Closed';
     		}
     		update scope;		   
     	}
    }
	
    public static void startPartneConnectionBatch(){
        
         Database.executeBatch(new PartnerConnectionBatch());
    }
    global void finish(database.BatchableContext bc){ 
        
        
    }    
}