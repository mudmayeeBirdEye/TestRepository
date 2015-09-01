global class OpportunityForecastBatch implements Database.Batchable<sObject>, Database.Stateful {
	public string strQuery {get;set;}
	public Date monthLastDate {get;set;} 
	public string strOppListUpd {get;set;}
	
	global OpportunityForecastBatch() { 
		this.strQuery = ''; 
		this.monthLastDate = system.today();
		this.strOppListUpd = '';
	}
	
	public void runBatchProcessManually() {
		try {
			OpportunityForecastBatch objOppForecastBatch = new OpportunityForecastBatch(); 
   			objOppForecastBatch.strQuery = 'SELECT Id, CloseDate FROM Opportunity ' +
										'WHERE StageName NOT IN (\'0. Downgraded\',\'8. Closed Won\',\'7. Closed Won\') '  +
								 		'and CloseDate < Today ';
	    	Database.executeBatch(objOppForecastBatch, 200);	
		} catch(Exception ex) {}  
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		monthLastDate = getMonthLastDate();
		return Database.getQueryLocator(strQuery);
	}
	
	global void execute(Database.BatchableContext BC, List<sObject> scope) {
		List<Opportunity> oppListToSetClosedDate = new List<Opportunity>();
		for(sObject result : scope) {
			Opportunity OppObj = (Opportunity) result;    
	        if(OppObj.CloseDate != null && OppObj.CloseDate < System.Today()) {
	        	OppObj.CloseDate = monthLastDate;
	        	oppListToSetClosedDate.add(OppObj);
	        	/*System.Debug('>>>SSS>>>'+ OppObj.Id + '--' + OppObj.CloseDate);
	        	if(strOppListUpd == '' || strOppListUpd == null) {
					strOppListUpd = OppObj.Id + '--' + OppObj.CloseDate;
				} else {
					strOppListUpd = strOppListUpd + '\n' + OppObj.Id + '--' + OppObj.CloseDate;
				}*/
	        } 
	    }
	    if(oppListToSetClosedDate != null && oppListToSetClosedDate.size()>0) {
	    	try {
	    		update oppListToSetClosedDate;	
	    	} catch(Exception ex) {}
	    }
	}
	
	global void finish(Database.BatchableContext info) {
		try {
			/*Document docObj = new Document();
			docObj.Name = 'Opp Forecast  Log #' + + System.now() + '# ' + Math.random();    
			docObj.Body = Blob.valueOf('Opp Forecast \n'+ strOppListUpd); 
			docObj.ContentType = 'text/plain';
			docObj.FolderId = [select Id from Folder where type = 'Document' and developerName = 'Opportunity_Forecast_CloseDate_Logs' limit 1 ].Id;
			docObj.Type = 'txt';
			insert docObj;*/
			this.strQuery = ''; 
			this.monthLastDate = system.today();
			this.strOppListUpd = '';	
		} catch(Exception ex) {}
	}
	
	static Date getMonthLastDate() {
		Date firstDayOfMonth = System.today().toStartOfMonth();
		Date lastDayOfMonth = firstDayOfMonth.addDays(Date.daysInMonth(firstDayOfMonth.year(), firstDayOfMonth.month()) - 1);
		return lastDayOfMonth;
	}
}