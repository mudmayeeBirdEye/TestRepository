global class CampaignBatchToCalculateMRR implements  Database.Batchable<sObject> {
	String qry;
	Map<Id, Campaign> campObjs = new Map<Id, Campaign>();
	Map<Id, Double> camActualCost = new Map<Id, Double>();
 	Map<Id, Double> camEstimatedCost = new Map<Id, Double>();
 	Map<Id, Campaign> campMap = new Map<Id, Campaign>();
   //List<sObject> sobj { get; set;}

	global CampaignBatchToCalculateMRR () {
	}

	global Database.QueryLocator start(Database.BatchableContext BC){
		return Database.getQueryLocator('SELECT Id, Campaign.id, Actual_12M_Booking__c, X12_Month_Booking__c, StageName  FROM Opportunity WHERE Campaign.isActive=true AND Campaign.id != NULL');
	}
	global void execute(Database.BatchableContext BC, List<sObject> scope){
		System.debug('### 3='+ scope.size());
		Set<Id> oppIds = new Set<Id>();
		Set<Id> campIds = new Set<Id>();
	     	for(sObject aResultScope: scope) {
	     		Opportunity aResult = (Opportunity) aResultScope;
	     		
	     		if(OpportunityHelper.isActiveOpp(aResult.StageName)) {
	     			
	     		}
	     	    // campObjs.put(aResult.id,aResult);
	     	    oppIds.add(aResult.Id);
	     	    campIds.add(aResult.Campaign.Id);
	     		
	     	}
	     	campMap = new Map<Id, Campaign>([SELECT Id, Total_Actual_12_Month_Booking_hidden__c, 
     						Total_Estimated_12_Month_Booking_hidden__c FROM Campaign WHERE Id IN :campIds]);
	     	if(campMap!= null && campMap.size() != 0) {
	     		List<AggregateResult> listOpp1 = [SELECT SUM(Actual_12M_Booking__c) Actual_Cost, Campaign.id CampId FROM Opportunity 
	     	 								WHERE Campaign.isActive=true AND Campaign.id != NULL AND Id IN:oppIds GROUP BY Campaign.id ];
	     	 	for(AggregateResult aResult: listOpp1) {
		     		Double actualCost = Double.valueOf(aResult.get('Actual_Cost') == null || aResult.get('Actual_Cost') == '' 
		     		? 0: aResult.get('Actual_Cost'));
		     		// Double estCost = Double.valueOf(aResult.get('Est_Cost'));
		     		Id camObj = (Id) aResult.get('CampId');
		     		Campaign campObjNew = campMap.get(camObj);
		     			campObjNew.Total_Actual_12_Month_Booking_hidden__c = (campObjNew.Total_Actual_12_Month_Booking_hidden__c != null ?
		     		(campObjNew.Total_Actual_12_Month_Booking_hidden__c + actualCost) : actualCost);
		     	} 
		     	
		     	List<AggregateResult> listOpp2 = [SELECT SUM(X12_Month_Booking__c) Est_Cost, Campaign.id CampId FROM Opportunity 
	     	 										WHERE Campaign.isActive=true AND Campaign.id != NULL AND Id IN:oppIds 
	     	 										AND StageName IN :OpportunityHelper.alteredStages GROUP BY Campaign.id ];
		     	
		     	for(AggregateResult aResult: listOpp2) {
		     		// Double actualCost = Double.valueOf(aResult.get('Actual_Cost'));
		     		Double estCost = Double.valueOf(aResult.get('Est_Cost') == null || aResult.get('Est_Cost') == ''
		     		? 0: aResult.get('Est_Cost'));
		     		Id camObj = (Id) aResult.get('CampId');
		     		Campaign campObjNew = campMap.get(camObj);
		     			campObjNew.Total_Estimated_12_Month_Booking_hidden__c = (campObjNew.Total_Estimated_12_Month_Booking_hidden__c != null ?
		     		(campObjNew.Total_Estimated_12_Month_Booking_hidden__c + estCost) : estCost);
		     	} 
		     	update campMap.values();
	     	}
	     	
	     	
	}
	global void finish(Database.BatchableContext info){
		  //send Greg_H a message about the batch processing completion
      AsyncApexJob a = [SELECT CreatedBy.Email, CreatedBy.Name, CreatedDate, CompletedDate, Id, JobItemsProcessed, NumberOfErrors, Status, TotalJobItems FROM AsyncApexJob WHERE Id =: info.getJobId()]; //query the AsyncApexJob object to retrieve the current job's information. 
      Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); //instantiate a new message object
      String[] toAddresses = new String[] {'wilson.chu@ringcentral.com'}; //denote the email address for receiving the message
      String[] toBCCAddresses = new String[] {'anuj.shukla@simplion.com','kanishk.singh@simplion.com','virendra.singh@simplion.com'};
      mail.setCcAddresses(toBCCAddresses);
      mail.setToAddresses(toAddresses); //to
      mail.setSubject('Apex Campaign_batch_field_aggregation:'+a.Status); //subject
      mail.setPlainTextBody('The batch Apex job created by '+a.CreatedBy.Name+' ('+a.CreatedBy.Email+') processed '+a.TotalJobItems+' batches with '+a.NumberOfErrors+' failures. The process began at '+a.CreatedDate+' and finished at '+a.CompletedDate+'.'); //body
      Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); //send
	}
	/*public static testmethod void test() {
   
     Test.StartTest();
     CampaignBatchToCalculateMRR obj=new CampaignBatchToCalculateMRR();
     Database.executeBatch(obj,200);
     Test.StopTest();
   
   }*/
}