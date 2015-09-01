global class ContractApproval {
	webService static boolean chkContractApproval (string opportunityId){
		try {
			if(opportunityId != null && opportunityId != '') {
				Contract_Approval_Service__c caCSObj = Contract_Approval_Service__c.getInstance(); 
				List<Opportunity> oppObjList = [select id,accountId,(Select Status From Quotes where Initial_Term_months__c >= : caCSObj.Initial_Term__c 
												and (status = 'Active' OR status = 'Accepted')
												order by lastmodifieddate desc limit 1) from opportunity where Id = :opportunityId limit 1];
				
				List<Account> accobjActiveList;
				if(oppObjList != null && oppObjList[0].accountId != null) {
					accobjActiveList = new List<Account>();
					accobjActiveList = [select id,(Select Status From Quotes__r 
											 where (status = 'Active' OR status = 'Accepted') 
											 and Initial_Term_months__c >= : caCSObj.Initial_Term__c  limit 1) 
											 from Account where Id = :oppObjList[0].accountId limit 1];
				}
				if(accobjActiveList != null && accobjActiveList[0].Quotes__r != null && accobjActiveList[0].Quotes__r.size()>0) {
					return true;
				} else if(oppObjList != null && oppObjList[0].Quotes != null && oppObjList[0].Quotes.size()>0) {
					return true;
				}						 
			}
		} catch(Exception ex) {}
		return false;
	}
}