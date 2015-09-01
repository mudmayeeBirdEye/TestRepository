trigger Implementation_After on Implementation__c (After Insert, After Update) {
	// Flag to check if trigger is to be executed or not.
	if(TriggerHandler.BY_PASS_IMPLEMENTATION_ON_AFTER){
		System.debug('### RETURNED FROM IMPLEMENTATION AFTER TRG ###');
		return;
	}else{
		System.debug('### STILL CONTINUE FROM IMPLEMENTATION AFTER TRG ###');
		TriggerHandler.BY_PASS_IMPLEMENTATION_ON_AFTER = true;
	} 
    if(Trigger.isInsert){
      	system.debug('#### calling method to create dummy event.');
      	//-------------------As/Simplion/3/13/2015----------------------------------
  		Map<Id, Id> mappingImpToEvent = ImplementationHelper.createDummyEvent(trigger.new); 
        Set<id> acc_ids = new Set<id>();
        set<string> userIdSet = new set<string>();

      /*Collectiong related Accounts*/ 

        for(Implementation__c imp: Trigger.new){
            acc_ids.add(Imp.Account__c);
            System.debug('IMPLEMENTATON ID  --->'+imp.id);
            if(!string.isBlank(imp.RC_USER_ID__c)) {
            	userIdSet.add(imp.RC_USER_ID__c);
            }
        }

      /*Fetching Accounts*/     
   	 	Map<id,Account> acct_map = new Map<id,Account>([SELECT id, Initial_Implementation_Event__c, Implementation_Status__c,Implementation_Phase_Completion_Rate__c, Adoption_Phase_Completion_Rate__c, Graduation_Phase_Completion_Rate__c FROM Account Where id IN:acc_ids]);
   		List<Account> acct_list = new List<Account>();
  		Set<Account> s = new Set<Account>();
  		Map<Id, Account> mapAccount = new Map<Id, Account>();
  		map<string,List<Event>> mapImplementationTOEvent = new map<string,List<Event>>();
   		if(userIdSet != null && userIdSet.size()>0) {
   			List<Event> eventListQuery = new List<Event>();
   			if(Test.isRunningTest()) {
   				eventListQuery = [select CustomerId__c from Event where CustomerId__c IN : userIdSet limit 1];
   			} else {
   				eventListQuery = [select CustomerId__c from Event where CustomerId__c IN : userIdSet];
   			}
   			for(Event eventObj : eventListQuery) {
   				if(eventObj.CustomerId__c != null) {
	   				List<Event> eventList = new List<Event>();
	   				if(mapImplementationTOEvent != null && mapImplementationTOEvent.containsKey(eventObj.CustomerId__c)) {
	   					eventList = mapImplementationTOEvent.get(eventObj.CustomerId__c);
	   				}
	   				eventList.add(eventObj);
	   				mapImplementationTOEvent.put(eventObj.CustomerId__c,eventList);
   			    }
   			}
   		}
   	
  		List<Event> eventToUpd = new List<Event>();
  	   	for(Implementation__c imp: Trigger.new){
       		/* Start of Code for Gratuation score card */
       		 /* 1>check the new values to Old values of Implementation
        		2> If find the difference then calculate the completion rate and date in Account Object. 
       	 	***** Closing score card logic here because of it is being moved to Implementation object****	
        	GraduationScoreCardHelper.ScoreCardWrapper objScoreCardWrapper = new GraduationScoreCardHelper.ScoreCardWrapper();
        	objScoreCardWrapper = GraduationScoreCardHelper.getImplementationCompletionDetails(imp, null, GraduationScoreCardHelper.STR_INSERT);
        	
      	   End of Code for Gratuation score card */
      	  
            if(imp.Account__c != null && acct_map !=null && acct_map.get(imp.Account__c) !=null){   
              Account tempAcc = acct_map.get(imp.Account__c);
              system.debug('Most_Recent_Implementation_Event__c=> '+imp.Most_Recent_Implementation_Event__c+' Initial_Implementation_Event__c-->'+tempAcc.Initial_Implementation_Event__c);
              tempAcc.Implementation_Status__c = imp.Implementation_Status__c;
              if(mappingImpToEvent != null && mappingImpToEvent.get(imp.Id) != null){
              	tempAcc.Initial_Implementation_Event__c = mappingImpToEvent.get(imp.Id);
              }
             	/* GRADUATION SCORE CARD - START
              	 * This conditional code is only for Graduation Score Card to Insert 
              	 * completion Rate and Date in Account object.
              	 ***** Closing score card logic here because of it is being moved to Implementation object****
	          	if(objScoreCardWrapper!=null && objScoreCardWrapper.bUpdateAcount){
	          		tempAcc.Implementation_Phase_Completion_Rate__c = objScoreCardWrapper.dCompletionRate != null ? objScoreCardWrapper.dCompletionRate : 0;
		       		if(objScoreCardWrapper.dCompletionRate == 100){
		       			tempAcc.Account_Graduation_Date_0_30__c = objScoreCardWrapper.completionDate != null ? objScoreCardWrapper.completionDate : system.now(); 
		       		}
		       		GraduationScoreCardHelper.setAccountGraduationStatus(tempAcc);
		       	}
       			 GRADUATION SCORE CARD - END */
              s.add(tempAcc);
              mapAccount.put(tempAcc.Id, tempAcc);
            }
            if(!string.isBlank(imp.RC_USER_ID__c) && mapImplementationTOEvent != null && mapImplementationTOEvent.get(imp.RC_USER_ID__c) != null) {
            	List<Event> eventListTOUpd = mapImplementationTOEvent.get(imp.RC_USER_ID__c);
            	for(Event eventObj : eventListTOUpd) {
            		Event evenObj  = new Event(Id = eventObj.id);
            		evenObj.WhatId = imp.Id;
            		eventToUpd.add(evenObj);	
            	}
            }   
        }
        try {
        	 if(!mapAccount.isEmpty()) {
	        	acct_list.addAll(mapAccount.values());
	        	update acct_list;
	        }
	        if(eventToUpd != null && eventToUpd.size()>0) {
	        	update eventToUpd;	
	        }	
        } catch(Exception ex) {}
    }
   
   
   /*for isUpdate*/  
   
   if(Trigger.isUpdate){
   		Implementation__c impl_temp = new  Implementation__c();  
   		Set<id> acc_ids = new Set<id>();
   		Map<Id, Account> mapAccount = new Map<Id, Account>(); 
      	/*Collectiong related Accounts*/ 
   		for(Implementation__c imp: Trigger.new){
        	acc_ids.add(Imp.Account__c);
   		}
   		Map<id,Account> impl_on_acc = new  Map<id,Account>([SELECT (SELECT Implementation_Status__c , id, CreatedDate FROM Implementations__r 
   			ORDER BY CreatedDate DESC Limit 1 ), Implementation_Status__c,Implementation_Phase_Completion_Rate__c, Adoption_Phase_Completion_Rate__c, Graduation_Phase_Completion_Rate__c FROM Account WHERE Id IN: acc_ids ]);
   		System.debug('impl_on_acc'+impl_on_acc);
   		List<Account> accts = new List<Account>();
   		Set<Account> s = new  Set<Account>();
    	for(Implementation__c imp: Trigger.new){
    		
    		 /* Start of Code for Gratuation score card*/
	        /* 	1>check the new values to Old values of Implementation
	         *	2> If find the difference then calculate the completion rate and date in Account Object. 
	         ***** Closing score card logic here because of it is being moved to Implementation object**** 	
	    	GraduationScoreCardHelper.ScoreCardWrapper objScoreCardWrapper = new GraduationScoreCardHelper.ScoreCardWrapper();
	    	If(Trigger.oldMap.get(imp.Id) != null){
	    		Implementation__c objOldImp = Trigger.oldMap.get(imp.Id);
	    		objScoreCardWrapper = GraduationScoreCardHelper.getImplementationCompletionDetails(imp, objOldImp, GraduationScoreCardHelper.STR_UPDATE);
	    	}
	        End of Code for Gratuation score card */
       
        	if(imp.Account__c !=null && impl_on_acc !=null && impl_on_acc.get(imp.Account__c).Implementations__r != null){
        		Implementation__c temp_impl = impl_on_acc.get(imp.Account__c).Implementations__r;
        		System.debug('Implementations On Account -->'+temp_impl);
        		Account acc = new Account();
        		 boolean isAddedAccount = false;
        		if(imp.id == temp_impl.id ){
            		acc =  impl_on_acc.get(imp.Account__c);
            		acc.Implementation_Status__c = imp.Implementation_Status__c;
            		isAddedAccount = true;
            		s.add(acc);
            		//accts.add(acc);
        		} else {
            		acc = impl_on_acc.get(imp.Account__c);
            		acc.Implementation_Status__c = temp_impl.Implementation_Status__c; 
        			s.add(acc);
        			isAddedAccount = true;
            		//accts.add(acc);
        		}
        		
        		if(isAddedAccount){
        			 /* GRADUATION SCORE CARD - START
			         * This conditional code is only for Graduation Score Card to UPDATE 
			      	 * completion Rate and Date in Account object. 
			      	 ***** Closing score card logic here because of it is being moved to Implementation object****
			       	if(objScoreCardWrapper!=null && objScoreCardWrapper.bUpdateAcount){
			       		acc.Implementation_Phase_Completion_Rate__c = objScoreCardWrapper.dCompletionRate!=null?objScoreCardWrapper.dCompletionRate:0;
			       		 system.debug('objScoreCardWrapper.dCompletionRate ======>'+objScoreCardWrapper.dCompletionRate );
			       		if(objScoreCardWrapper.dCompletionRate == 100){
			       			acc.Account_Graduation_Date_0_30__c = objScoreCardWrapper.completionDate != null ? objScoreCardWrapper.completionDate : system.now(); 
			       		}
			       		GraduationScoreCardHelper.setAccountGraduationStatus(acc);
			       	}
			       	 GRADUATION SCORE CARD - END  */ 
		       	
		       		s.add(acc);
		       		mapAccount.put(acc.Id, acc);
		        }    
       		}
     	}
     	/*
     	if(accts != null){
     		accts.addAll(s);
     		TriggerHandler.BY_PASS_ACCOUNT_ON_UPDATE();
     		update accts;
     	}*/
     if(!mapAccount.isEmpty()){
     	system.debug('mapAccount.size in If ======>'+mapAccount.values());
     	//accts.addAll(s);values()
     	accts.addAll(mapAccount.values());
     	TriggerHandler.BY_PASS_ACCOUNT_ON_UPDATE();
     	update accts;
     }
	}
	
	 /*
   * Graduation Score card Implementation Phase Start
   */
   if(Trigger.isUpdate || Trigger.isInsert){
   		Set<String> acc_ids = new Set<String>();
   		
      	/*Collectiong related Accounts*/ 
   		for(Implementation__c imp: Trigger.new){
        	acc_ids.add(imp.Account__c);
   		}
   		map<Id, Account> accountMetricMap = AccountScoreCardHelper.getAccountsWithAccountMetric(acc_ids);
   		list<Account_Metric__c> accountMetricList = new list<Account_Metric__c>(); 
   		String strAction = GraduationScoreCardHelper.STR_INSERT;
   		if(Trigger.isUpdate){
   				strAction = GraduationScoreCardHelper.STR_UPDATE;
   		}
   		for(Implementation__c imp: Trigger.new){
   			GraduationScoreCardHelper.ScoreCardWrapper objScoreCardWrapper = new GraduationScoreCardHelper.ScoreCardWrapper();
   			if(Trigger.isUpdate){
    			objScoreCardWrapper = GraduationScoreCardHelper.getImplementationCompletionDetails(imp, Trigger.oldMap.get(imp.Id), strAction);
   			}else{
   				objScoreCardWrapper = GraduationScoreCardHelper.getImplementationCompletionDetails(imp, null, strAction);
   			}
    		//imp.Implementation_Phase_Completion_Rate__c = objScoreCardWrapper.dCompletionRate != null ? objScoreCardWrapper.dCompletionRate : 0;
       		//imp.Account_Graduation_Status__c = 'New';
       		Account_Metric__c accountMetric = new Account_Metric__c();
       		if(accountMetricMap.get(imp.Account__c) != null && accountMetricMap.get(imp.Account__c).Account_Metrics__r.size()>0){
       				accountMetric = accountMetricMap.get(imp.Account__c).Account_Metrics__r[0];
       			}
       		/*if(objScoreCardWrapper.dCompletionRate == 100){
       			imp.Account_Graduation_Date_0_30__c = objScoreCardWrapper.completionDate != null ? objScoreCardWrapper.completionDate : system.now(); 
       			imp.Account_Graduation_Status__c = 'Done';
       		}*/
       		if(objScoreCardWrapper.dCompletionRate >0 && objScoreCardWrapper.dCompletionRate <100){
       			//imp.Account_Graduation_Status__c = 'Implementation Phase';
       		}
	    	if(accountMetric.Id != null){
	    		accountMetric.Account_Graduation_Status__c = 'New';
	    		if(imp.Implementation_Phase_Completion_Rate__c >0 && imp.Implementation_Phase_Completion_Rate__c <100){
       				accountMetric.Account_Graduation_Status__c = 'Implementation Phase';
       			}
       			if(imp.Implementation_Phase_Completion_Rate__c == 100){
       				accountMetric.Account_Graduation_Status__c = 'Adoption/Maturity Phase';
       			}
       			if(accountMetric.Adoption_Phase_Completion_Rate__c >= 75){
	    			accountMetric.Account_Graduation_Status__c = 'Graduation Phase';
	    		}
	    		if (accountMetric.Graduation_Phase_Completion_Rate__c >= 75){
	    			accountMetric.Account_Graduation_Status__c = 'Done';
	    		}
	    		accountMetricList.add(accountMetric);
	    	}
	    	system.debug('accountMetricList------>'+accountMetricList);
	 	}
   		if(accountMetricList.size()>0){
   			update accountMetricList;
   		}
   }
   /* Graduation Score card Implementation Phase END*/
}