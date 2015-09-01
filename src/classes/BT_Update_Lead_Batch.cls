global class BT_Update_Lead_Batch implements  Database.Batchable<sObject>, Database.Stateful  {
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		return null;
	}
	global void execute(Database.BatchableContext BC, List<sObject> scope) {
		List<Lead> lstLeadsToUpdate = new List<Lead>();
		if(scope != null){
			for(sObject result : scope) {
				Lead leadObj = (Lead) result;
				lstLeadsToUpdate.add(leadObj);
			}
		}
		if(lstLeadsToUpdate != null && lstLeadsToUpdate.size() > 0){
			update lstLeadsToUpdate;
		}
	}
	
	global void finish(Database.BatchableContext info) {
		system.debug('Batch finish');
	}
}