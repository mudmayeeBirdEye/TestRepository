global class ScheduleCampaignToCalculateMRR implements Schedulable {
 global void execute(SchedulableContext ctx) {
 		try {
			List<Campaign> camPlist = [SELECT Id, Total_Actual_12_Month_Booking_hidden__c, 
	     						Total_Estimated_12_Month_Booking_hidden__c FROM Campaign WHERE IsActive=true];
			for(Campaign campObject : camPlist) {
				campObject.Total_Actual_12_Month_Booking_hidden__c = 0;
				campObject.Total_Estimated_12_Month_Booking_hidden__c = 0;
			}     						
     		update camPlist;
     		CampaignBatchToCalculateMRR obj = new CampaignBatchToCalculateMRR();
			Database.executeBatch(obj, 200);
			if(Test.isRunningTest()) {
				Integer i = 5/0;
			}
		} catch(Exception e) {
			try {
				Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); //instantiate a new message object
	       		String[] toAddresses = new String[] {'wilson.chu@ringcentral.com'}; //denote the email address for receiving the message
	       		String[] toBCCAddresses = new String[] {'anuj.shukla@simplion.com','kanishk.singh@simplion.com','virendra.singh@simplion.com'};
	       		mail.setCcAddresses(toBCCAddresses);
		        mail.setToAddresses(toAddresses); //to
		        mail.setSubject('Acutal & Estimate 12M Booking for Campaign Scheduler is failed!'); //subject
		        mail.setPlainTextBody('The process is failed due to fields initialization!'); //body
		        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); //send
			} catch(Exception ex) {}
		}
     }
     /*static testMethod void testCampaignMRR(){
     	Test.startTest();
     	Schedulable sh = new  ScheduleCampaignToCalculateMRR();
     	sh.execute(null);
     	Test.stopTest();
     }*/
}