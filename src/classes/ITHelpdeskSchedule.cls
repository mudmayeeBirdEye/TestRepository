global class ITHelpdeskSchedule implements Schedulable {
	 global void execute(SchedulableContext ctx) {
	 	ITHelpDeskBatch itHelpdeskBatchObj = new ITHelpDeskBatch(); 
  		Database.executeBatch(itHelpdeskBatchObj, 1);
	 }
}