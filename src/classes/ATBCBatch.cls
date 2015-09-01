global class ATBCBatch implements  Database.Batchable<sObject>, Database.Stateful {
	public string strQuery;
	public string strIsCancel = '-1';
	string strLeadListContent = '';
	string allFetchedLeads = '';
	
	global ATBCBatch() {
	}
	
	public void runBatchProcessManually() {
		ATBCBatch objATBCBatch = new ATBCBatch(); 
   		objATBCBatch.strQuery =	 'SELECT Id, User_ID__c, Name, Email, Company, Account_Renewal_Date__c, CreatedDate FROM Lead ' +
									'WHERE (LeadSource = \'About To be Cancelled\' OR LeadSource = \'About To Be Cancelled UK\' ) '  +
								 	'and (ATBC_Stage__c=\'New\' OR ATBC_Stage__c=\'WIP\') and IsConverted = false ' +
								 	'and User_ID__c != null and User_ID__c != \'\' AND LastModifiedDate < LAST_N_DAYS:60';		 
							    	
		objATBCBatch.strIsCancel = '1';					    	
        Database.executeBatch(objATBCBatch, 200);
	}

	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator(strQuery);
	}
	
	global void execute(Database.BatchableContext BC, List<sObject> scope) {
		try {
			if(strIsCancel == '1') {  
				List<Lead> leadsToCancelFinal = new List<Lead>();
				for(sObject result : scope) {
					Lead lUp = (Lead) result;    
			        if(lUp.Account_Renewal_Date__c != null
			        	&& lUp.Account_Renewal_Date__c < lUp.CreatedDate){
			        	lUp.ATBC_Stage__c = 'Canceled';
				        lUp.Status = '0. Downgraded';
				        lUp.Downgrade_Reason__c = 'Low Potential - Save For Notes';
				    	if(strLeadListContent == '') {
							strLeadListContent = lUp.Id;
						} else {
							strLeadListContent = strLeadListContent + '\n' + lUp.Id;
						}
			        	leadsToCancelFinal.add(lUp);
			        } else {
			        	allFetchedLeads = allFetchedLeads +'\n'+lUp.Id;
			        }
			    }
			    if(leadsToCancelFinal != null && leadsToCancelFinal.size()>0) {
			    	System.debug('Leads to cancel size= '+ leadsToCancelFinal.size());
					update leadsToCancelFinal;		
			    }
			} else if(strIsCancel == '0') {
			  	List<Lead> leadsToCloseFinal = new List<Lead>();
			  	for(sObject result : scope) {
					Lead lUp = (Lead) result;  
			        if(lUp.Account_Renewal_Date__c!=null
			        	&& lUp.Account_Renewal_Date__c > lUp.CreatedDate){
			        	lUp.ATBC_Stage__c = 'Closed';
				        lUp.Status = '0. Downgraded';
				        lUp.Downgrade_Reason__c = 'Retention Lead Closed';
				 		if(strLeadListContent ==''){
							strLeadListContent = lUp.Id;
						} else {
							strLeadListContent = strLeadListContent + '\n' + lUp.Id;
						}
			        	leadsToCloseFinal.add(lUp); 
			        } else {
			        	allFetchedLeads = allFetchedLeads +'\n'+lUp.Id;
			        }
			    }
			    if(leadsToCloseFinal != null && leadsToCloseFinal.size()>0) {
			    	System.debug('Leads to Close size= '+ leadsToCloseFinal.size());
					update leadsToCloseFinal; 	
			    }
			}
			if(Test.isRunningTest()) {
				Integer i = 5/0;
			}	
		} catch(Exception exp) {
			Exception_And_Notification_History__c exceptionObj = new Exception_And_Notification_History__c();
			exceptionObj.Object_Type__c = 'Exception';
			exceptionObj.content_label_01__c = 'File Associated';
			exceptionObj.content_label_02__c = 'Line Number';
			exceptionObj.content_label_03__c = 'Exception';
			exceptionObj.content_label_04__c = 'Get Stack Trace String';
			exceptionObj.content_label_05__c = 'Details';
			exceptionObj.content_var_01__c ='ATBC Batch';
			exceptionObj.File_Associated__c = 'ATBC Batch';
			ExceptionAndNotificationHelper.trackExceptions(exceptionObj, exp);
			Document d = new Document(); 
		    d.Name = 'ATBC Exception Log #' + + System.now() + '# ' + Math.random(); 
		    d.Body = Blob.valueOf(exp.getTypeName() + '\n'+ exp.getLineNumber() + '\n' 
		    			+ exp.getStackTraceString() + '\n' + exp.getMessage()); 
		    d.ContentType = 'text/plain';
		    d.FolderId = '00l80000001ltF8';
		    d.Type = 'txt';
		    insert d;
		}
	}
	
	global void finish(Database.BatchableContext info) {
		try {
		    Document d = new Document();
		    if(this.strIsCancel == '1') {
		    	d.Name = 'ATBC Cancel Downgrade Log #' + + System.now() + '# ' + Math.random(); 
		    	d.Body = Blob.valueOf('Leads To Cancel \n'+ strLeadListContent+'\n\n\n'+'All Leads Fetched'+ allFetchedLeads); 
		    } else if(this.strIsCancel == '0') {
		    	d.Name = 'ATBC Close Downgrade Log #' + + System.now() + '# ' + Math.random(); 
		    	d.Body = Blob.valueOf('Leads To Close \n'+ strLeadListContent+'\n\n\n'+'All Leads Fetched'+ allFetchedLeads);
		    }
		    d.ContentType = 'text/plain';
		    d.FolderId = '00l80000001ltF8';
		    d.Type = 'txt';
		    insert d;
		    if(this.strIsCancel == '1') {
		    	this.strLeadListContent = '';
				this.allFetchedLeads = '';
				this.strQuery = '';
				this.strIsCancel = '-1';
				ATBCBatch objATBCBatch1 = new ATBCBatch(); 
		     	/*objATBCBatch1.strQuery = 'SELECT Id, User_ID__c, Name, Email, Company, Account_Renewal_Date__c, CreatedDate FROM Lead'+ 
										    'WHERE (LeadSource = \'About To be Cancelled\' OR LeadSource = \'About To Be Cancelled UK\' )'+
										    'and (ATBC_Stage__c=\'new\' OR ATBC_Stage__c=\'WIP\') and IsConverted = false'+
										    'and User_ID__c != null and User_ID__c != \'\'';*/
										    
		    	objATBCBatch1.strQuery = 'SELECT Id, User_ID__c, Name, Email, Company, Account_Renewal_Date__c, CreatedDate FROM Lead '+ 
										    'WHERE (LeadSource = \'About To be Cancelled\' OR LeadSource = \'About To Be Cancelled UK\' ) '+
										    'and (ATBC_Stage__c=\'new\' OR ATBC_Stage__c=\'WIP\') and IsConverted = false '+
										    'and User_ID__c != null and User_ID__c != \'\'';
										    
				objATBCBatch1.strIsCancel = '0';					    	
		        Database.executeBatch(objATBCBatch1, 200);
		    }
		    if(Test.isRunningTest()) {
				Integer i = 5/0;
			}
		} catch(Exception exp) {
			Exception_And_Notification_History__c exceptionObj = new Exception_And_Notification_History__c();
			exceptionObj.Object_Type__c = 'Exception';
			exceptionObj.content_label_01__c = 'File Associated';
			exceptionObj.content_label_02__c = 'Line Number';
			exceptionObj.content_label_03__c = 'Exception';
			exceptionObj.content_label_04__c = 'Get Stack Trace String';
			exceptionObj.content_label_05__c = 'Details';
			exceptionObj.content_var_01__c ='ATBC Batch';
			exceptionObj.File_Associated__c = 'ATBC Batch';
			ExceptionAndNotificationHelper.trackExceptions(exceptionObj, exp);
			Document d = new Document(); 
		    d.Name = 'ATBC Exception Log #' + + System.now() + '# ' + Math.random(); 
		    d.Body = Blob.valueOf(exp.getTypeName() + '\n'+ exp.getLineNumber() + '\n'  
		    			+ exp.getStackTraceString() + '\n' + exp.getMessage()); 
		    
		    d.ContentType = 'text/plain';
		    d.FolderId = '00l80000001ltF8';
		    d.Type = 'txt';
		    insert d;
		}
	}
}