global class OpportunityForecastScheduler implements Schedulable {
	
	global void execute(SchedulableContext ctx) { 
		try {
			OpportunityForecastBatch objOppForecastBatch = new OpportunityForecastBatch();
			if(Test.isRunningTest()) {
				objOppForecastBatch.strQuery = 'SELECT Id, CloseDate FROM Opportunity ' +
										'WHERE StageName NOT IN (\'0. Downgraded\',\'8. Closed Won\',\'7. Closed Won\') '  +
								 		'and CloseDate < Today limit 1';
			} else {
				objOppForecastBatch.strQuery = 'SELECT Id, CloseDate FROM Opportunity ' +
										'WHERE StageName NOT IN (\'0. Downgraded\',\'8. Closed Won\',\'7. Closed Won\') '  +
								 		'and CloseDate < Today ';
			}
   	    	Database.executeBatch(objOppForecastBatch, 200);	
		} catch(Exception ex) {} 
	}
}