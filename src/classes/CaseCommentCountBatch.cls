global class CaseCommentCountBatch implements Database.Batchable<sObject> {
	public string strQuery{get;set;}
	
	global CaseCommentCountBatch() {
		this.strQuery = null;
	}
	
	public void runBatchProcessManually() { 
		CaseCommentCountBatch objCaseCommentCountBatch = new CaseCommentCountBatch(); 
   		objCaseCommentCountBatch.strQuery =	 'Select (Select ParentId, IsPublished, CreatedById, CreatedBy.Email From CaseComments) From Case ';
   		//where createddate = LAST_N_DAYS:30  order  by  createddate desc 		 
		Database.executeBatch(objCaseCommentCountBatch, 200);
	}
	 
	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator(strQuery);
	}
	
	global void execute(Database.BatchableContext BC, List<sObject> scope) {  
		try {
			List<Case> caseListToUpd = new List<Case>();
			for(sObject result : scope) {
				Case caseObjToUpd = (Case) result;    
		        if(caseObjToUpd != null && caseObjToUpd.CaseComments != null) {	// && caseObjToUpd.CaseComments.size()>0
		        	System.Debug('>>eee>'+ caseObjToUpd.id);
		        	WrCaseCount wrCaseCountObj = new WrCaseCount();
		        	caseObjToUpd.No_of_Private_Comments__c = wrCaseCountObj.noOfPrivateComments;
		        	caseObjToUpd.No_of_Public_Comments__c  = wrCaseCountObj.noOfPublicComments;
		        	caseObjToUpd.Created_by_Agent__c  = wrCaseCountObj.noOfCommentsCreatedByAgent;
		        	caseObjToUpd.Created_by_customer__c  = wrCaseCountObj.noOfPrivateCommentsCreatedByCustomer;
		        	for(CaseComment caseCommentObj : caseObjToUpd.CaseComments) { 
		        		if(caseCommentObj.IsPublished) {
		    				wrCaseCountObj.noOfPublicComments = wrCaseCountObj.noOfPublicComments + 1;
		    			} else {
		    				wrCaseCountObj.noOfPrivateComments = wrCaseCountObj.noOfPrivateComments + 1;
		    			}
		    			System.Debug('>>222222>>>'+ caseCommentObj.CreatedBy.Email);
		    			if(caseCommentObj.CreatedBy.Email != null && caseCommentObj.CreatedBy.Email.split('@')[1].containsIgnoreCase('ringcentral.com')) {
		    				System.Debug('>>222222>>>'+ caseCommentObj.CreatedBy.Email);
		    				wrCaseCountObj.noOfCommentsCreatedByAgent = wrCaseCountObj.noOfCommentsCreatedByAgent + 1;
		    			} else {
		    				wrCaseCountObj.noOfPrivateCommentsCreatedByCustomer = wrCaseCountObj.noOfPrivateCommentsCreatedByCustomer + 1;
		    			}
		        	}
		        	caseObjToUpd.No_of_Private_Comments__c = wrCaseCountObj.noOfPrivateComments;
		        	caseObjToUpd.No_of_Public_Comments__c  = wrCaseCountObj.noOfPublicComments;
		        	caseObjToUpd.Created_by_Agent__c  = wrCaseCountObj.noOfCommentsCreatedByAgent;
		        	caseObjToUpd.Created_by_customer__c  = wrCaseCountObj.noOfPrivateCommentsCreatedByCustomer;
		        	caseListToUpd.add(caseObjToUpd);
		        } 
		    }
		    if(caseListToUpd != null && caseListToUpd.size()>0) {
		    	update caseListToUpd;
		    }		
		} catch(Exception exp) {
			
		}
	}
	
	global void finish(Database.BatchableContext info) {
		try {
		    
		} catch(Exception exp) {
			
		}
	}
	
	public class WrCaseCount {
		public Integer noOfPrivateComments;
		public Integer noOfPublicComments;
		public Integer noOfCommentsCreatedByAgent;
		public Integer noOfPrivateCommentsCreatedByCustomer;
		
		public WrCaseCount() {
			noOfPrivateComments = 0;
			noOfPublicComments = 0;
			noOfCommentsCreatedByAgent = 0;
			noOfPrivateCommentsCreatedByCustomer = 0;
		}
	} 
}