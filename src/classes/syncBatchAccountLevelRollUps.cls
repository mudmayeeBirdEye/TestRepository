global class syncBatchAccountLevelRollUps implements  Database.Batchable<sObject> {
  
  global syncBatchAccountLevelRollUps (String q) {
  }

  global Database.QueryLocator start(Database.BatchableContext BC){
	 String strQuery='';
	 if(test.isRunningTest()){
        strQuery='Select Total_Cases__c,Total_Contacts__c,Total_Activities__c,(Select Id From Cases),(Select Id From Contacts),(Select Id From OpenActivities) From Account a where name=\'testAccount\' limit 1';
	 } else{
	    strQuery='Select Id From Account'; 
	 }
  	
    return Database.getQueryLocator(strQuery); 
  }

  global void execute(Database.BatchableContext BC, List<sObject> scope){
  	  Set<Id> accIds = new Set<id>();
  	  for (Sobject s : scope) accIds.add(s.id);
  	  Account[] accs = [Select Total_Cases__c,
  	  					Total_Contacts__c,Total_Activities__c,Total_No_Of_Orders__c,
  	  					(Select Id From Cases),
  	  					(Select Id From Contacts),
  	  					(Select Id From OpenActivities) ,
  	  					(Select Id From Orders__r) 
  	  					From Account where id in :accIds order by CreatedDate desc];
  	  List<Account> liAccount=new List<Account>();					
     
   for(Account objAccount : accs) {
   	     
   	    try{
	   	     if((objAccount.Total_Cases__c!=(objAccount.Cases).size())
	   	          || (objAccount.Total_Contacts__c!=(objAccount.Contacts).size())
	   	          || (objAccount.Total_Activities__c!=(objAccount.OpenActivities).size())
	   	          || (objAccount.Total_No_Of_Orders__c!=(objAccount.Orders__r).size()) ){
				         objAccount.Total_Cases__c=(objAccount.Cases).size();
				         objAccount.Total_Contacts__c=(objAccount.Contacts).size();
				         objAccount.Total_Activities__c=(objAccount.OpenActivities).size();
				         objAccount.Total_No_Of_Orders__c=(objAccount.Orders__r).size();
				        
				         liAccount.add(objAccount);
	   	     }
   	    }catch(Exception e){
   	    	 objAccount.Total_Cases__c=(objAccount.Cases).size();
			 objAccount.Total_Contacts__c=(objAccount.Contacts).size();
			 objAccount.Total_Activities__c=(objAccount.OpenActivities).size();
			 objAccount.Total_No_Of_Orders__c=(objAccount.Orders__r).size();
			 liAccount.add(objAccount);
  	 	  }  
      }
	     if(liAccount.size()>0){
	        update liAccount;
	     }
  }


  global void finish(Database.BatchableContext info) {
      //send Greg_H a message about the batch processing completion
      AsyncApexJob a = [SELECT CreatedBy.Email, CreatedBy.Name, CreatedDate, CompletedDate, Id, JobItemsProcessed, NumberOfErrors, Status, TotalJobItems FROM AsyncApexJob WHERE Id =: info.getJobId()]; //query the AsyncApexJob object to retrieve the current job's information. 
      Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); //instantiate a new message object
      //String[] toAddresses = new String[] {a.CreatedBy.Email}; //denote the email address for receiving the message
       
       String[] toAddresses = new String[] {'wilson.chu@ringcentral.com'}; //denote the email address for receiving the message
       String[] toBCCAddresses = new String[] {'anuj.shukla@simplion.com','kanishk.singh@simplion.com','virendra.singh@simplion.com'};
       mail.setCcAddresses(toBCCAddresses);
      mail.setToAddresses(toAddresses); //to
      mail.setSubject('Apex batch_field_aggregation:'+a.Status); //subject
      mail.setPlainTextBody('The batch Apex job created by '+a.CreatedBy.Name+' ('+a.CreatedBy.Email+') processed '+a.TotalJobItems+' batches with '+a.NumberOfErrors+' failures. The process began at '+a.CreatedDate+' and finished at '+a.CompletedDate+'.'); //body
      try {
      Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); //send
      } catch(Exception e) {}
   }
}