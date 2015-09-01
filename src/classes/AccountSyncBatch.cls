/*
*
----- USAGE -----
String qry = 'select id,Total_Contacts__c,Total_Cases__c,Total_Active_Customers__c,RecordType.name,Partner_id__c from Account';
AccountSyncBatch asb = new AccountSyncBatch(qry);
Database.executeBatch(asb);
*
*
*/

global class AccountSyncBatch implements  Database.Batchable<sObject> {
	String qry;
	
	global AccountSyncBatch (String q) {
		qry = q;
	}

	global Database.QueryLocator start(Database.BatchableContext BC){
		return Database.getQueryLocator(qry);
	}

	global void execute(Database.BatchableContext BC, List<sObject> scope){
		Account acc = null;
		Set<Id> accIds = new Set<Id>();
		Set<String> partIds = new Set<String>();
		for(sObject s : scope) {
			acc = (Account)s;
			accIds.add(acc.id);
			if(acc.RecordType.name == 'Partner Account') {
				partIds.add(acc.Partner_Id__c);
			}
		}
		
		//List<AggregateResult> con_count = [Select AccountId,count(id) from Contact where AccountId IN : accIds group by AccountId];
		Map<Id,Integer> map1 = new Map<Id,Integer>();
		for(AggregateResult ar : [Select AccountId,count(id) total from Contact where AccountId IN : accIds group by AccountId]) {
			map1.put((Id)ar.get('AccountId'), (Integer)ar.get('total'));
		}
		
		Map<Id,Integer> map2 = new Map<Id,Integer>();
		for(AggregateResult ar : [Select AccountId,count(id) total from Case where AccountId IN : accIds group by AccountId]) {
			map2.put((Id)ar.get('AccountId'), (Integer)ar.get('total'));
		}
		
		Map<String,Integer> map3 = new Map<String,Integer>();
		for(AggregateResult ar : [select Partner_Id__c,count(Id) total from Account where RecordType.name = 'Customer Account' and Partner_Id__c IN : partIds group by Partner_Id__c]) {
			map3.put((String)ar.get('Partner_Id__c'), (Integer)ar.get('total'));
		}
		
		System.debug('######################33-'+map3);
		
		for(sObject s : scope) {
			acc = (Account)s;
			acc.Total_Contacts__c = (map1.get(acc.id)==null)?0:map1.get(acc.id);
			acc.Total_Cases__c = (map2.get(acc.id)==null)?0:map2.get(acc.id);
			if(acc.RecordType.name == 'Partner Account') {
				acc.Total_Active_Customers__c = (map3.get(acc.Partner_Id__c)==null)?0:map3.get(acc.Partner_Id__c);
			}
		}
						
		//List<AggregateResult> case_count = [Select AccountId,count(id) from Contact where AccountId =: acc.id group by AccountId];
		//List<AggregateResult> acc_count = [select Id,count(Id) from Account where RecordType.name = 'Customer Account' and Partner_Id__c =: acc.Partner_id__c group by Id];
		/*acc.Total_Contacts__c = [Select count() from Contact where AccountId =: acc.id];
		acc.Total_Cases__c = [Select count() from Case where AccountId =: acc.id];
		if(acc.RecordType.name == 'Partner Account') {
			acc.Total_Active_Customers__c = [select count() from Account where RecordType.name = 'Customer Account' and Partner_Id__c =: acc.Partner_id__c];
		}*/
		
		
		
		
	  	update scope;
	}


	global void finish(Database.BatchableContext BC){
	
	}

}