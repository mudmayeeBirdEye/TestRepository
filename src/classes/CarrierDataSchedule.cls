global class CarrierDataSchedule implements Schedulable {
	global void execute(SchedulableContext ctx) {
     	CarrierDataBatch carrierDataObj = new CarrierDataBatch(); 
   		carrierDataObj.strQuery = 'SELECT Carrier_Wireless_Phone_Number__c FROM Carrier_Data__c WHERE Carrier_Wireless_Phone_Number__c != null ' +
   									' and Account__c = null ';		 
		
		List<AsyncApexJob> carrierDataJobs = new List<AsyncApexJob>([SELECT Status, ApexClass.Name FROM AsyncApexJob  
        												 		WHERE ApexClass.Name = 'CarrierDataBatch' and 
        												 		status IN ('Processing', 'Queued', 'Preparing') Limit 1]);
		if(carrierDataJobs != null && carrierDataJobs.size() == 0) {
		    Database.executeBatch(carrierDataObj,200);
		} 		
 	}
}