global class EscalateERTTeam {
	 webService static String escalateToERT(Id caseId) {
	 string strMessage;	
     Case caseObj = new Case();
     try {
     	caseObj = [select Support_ERT_Esc_Count__c,RecordTypeId,RecordType.Name,OwnerId,Owner.Name,status 
     				from case where Id = :caseId];
 	 	System.Debug('>>33>>'+ caseObj.RecordType.Name);	
     	System.Debug('>>44>>'+ caseObj.Owner.Name);
     	if(caseObj != null && caseObj.status != null && caseObj.Status == 'Closed') {
     		strMessage = 'Closed Case can not be escalated to ERT Team.';
     	} else if(caseObj.RecordType.Name != null && caseObj.RecordType.Name == 'Support - Executive Response Team' &&
     			caseObj.OwnerId != null && caseObj.Owner.Name == 'ERT Team') {
     		strMessage = 'Case is already escalated to ERT Team.';	
     	} else {
     		List<Group> groupERT = [select Id from Group where DeveloperName = 'ERT_Team'];
	     	List<RecordType> recordTypeERT = [Select Id,name From RecordType where SobjectType ='Case'  
	     										and DeveloperName = 'Support_Executive_Response_Team'];
	 		if(recordTypeERT != null && recordTypeERT.size()>0 && groupERT != null && groupERT.size()>0) {
	 			caseObj.RecordTypeId = recordTypeERT[0].id;																
	 			caseObj.OwnerId = groupERT[0].Id;
	 			caseObj.Support_ERT_Esc_Count__c = caseObj.Support_ERT_Esc_Count__c == null?0:caseObj.Support_ERT_Esc_Count__c;	
	 			caseObj.Support_ERT_Esc_Count__c = caseObj.Support_ERT_Esc_Count__c + 1;
	 			caseObj.Support_Escalate_To__c = 'Support - Executive Response Team';
	 	     	update 	caseObj;
		     	strMessage = 'Case is successfully escalated to ERT Team.'; 
	 		}	
     	}			
     } catch(Exception ex) {
     	strMessage = 'Case cannot be escalated to ERT Team due to some problem occured.';
     } 
     return strMessage ;
    }
    
   /* @isTest(SeeAllData = true)
    static void testERTCASE(){
    	EscalateERTTeam ertObj = new EscalateERTTeam();
    	
    	try {
    		Test.startTest();
    		Account acctest = new Account();
	        acctest.Name='TestAccount22';
	        acctest.RecordTypeId  = '01280000000UERq';
	        insert acctest; 
	        
	        Contact contObj = new Contact();
		    contObj.AccountId =  acctest.Id;
		    contObj.Email = 'abc22@test.com';
		    contObj.LastName = 'Test Last22';
	      	insert contObj;
	      	
	    	Case caseObj = new Case();
	    	caseObj.AccountId = acctest.Id;
	    	caseObj.ContactId = contObj.Id;
	    	insert caseObj;	
	    	Test.stopTest();
	    	EscalateERTTeam.escalateToERT(caseObj.Id);
    	} catch(Exception ex) {
    		
    	}
    }*/
}