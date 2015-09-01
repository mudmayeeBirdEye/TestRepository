@isTest
private class Test_ApprovalFuture {
	@isTest(SeeAllData = true)
	static void ApprovalUnit(){
		try{
			set<Id> setApprovalId = new set<Id>();
	    	
	    	/*User testUser = new User(alias = 'u1', email='u1234@testorg.com',emailencodingkey='UTF-8', lastname='Testing', 
								 ProfileId=[SELECT Id FROM Profile LIMIT 1].Id, 
                        		 languagelocalekey='en_US',localesidkey='en_US', country='United States',
                        		 timezonesidkey='America/Los_Angeles', username='u11234@testorg.com', IsActive=true);                   
        	insert testUser;*/
	    	
	    	/*Approval__c appObj = new Approval__c(); 
	    	appObj.Admin_Transection_ID__c = 'Test';
	    	appObj.Level1Approver__c = testUser.Id;
	    	appObj.JustificationandDescription__c = 'Testing';
	    	appObj.Amount__c = 205.00;
	    	appObj.Category__c = 'Account Closed';
	    	appObj.Refund_Type__c = 'Annual Plan';
	    	insert appObj;*/
	    	
	    	List<Approval__c> appObjLst = [select id from Approval__c where RecordType.Name = 'Refund Approval' 
	    									and status__c = 'PendingL2Approval' limit 1];
	    	if(appObjLst != null && appObjLst.size()>0) {
	    		system.debug('#### Approval - '+appObjLst);
				setApprovalId.add(appObjLst[0].id);
				
				Test.startTest();
			 	ApprovalFuture.getApprovalSteps(setApprovalId);
			 	Test.stopTest();
	    	}	 
	   	
		}catch(Exception e){}
  }
}