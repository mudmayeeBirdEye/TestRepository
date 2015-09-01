global class PartnerConnectionScheduler implements Schedulable{
	global void execute(SchedulableContext ctx) { 
		try {
			PartnerConnectionBatch batchObj = new PartnerConnectionBatch();
			Database.executeBatch(batchObj);
		} catch(Exception ex) {
			system.debug('Exception ==== ' + ex.getMessage());
		} 
	}
}