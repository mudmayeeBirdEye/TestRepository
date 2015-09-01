global class BT_Update_Contact_Batch implements  Database.Batchable<sObject>, Database.Stateful  {
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		return null;
	}
	global void execute(Database.BatchableContext BC, List<sObject> scope) {
		List<Contact> lstContactsToUpdate = new List<Contact>();
		if(scope != null){
			for(sObject result : scope) {
				Contact contactObj = (Contact) result;
				lstContactsToUpdate.add(contactObj);
			}
		}
		if(lstContactsToUpdate != null && lstContactsToUpdate.size() > 0){
			update lstContactsToUpdate;
		}
	}
	
	global void finish(Database.BatchableContext info) {
		system.debug('Batch finish');
	}
}