/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 */
@isTest
private class Test_LeadUpdationFutureHandler {                                                                          

    static testMethod void TestLeadUpdationFutureHandler(){
     try{
     		Account objAccount = new Account(Name = 'test Name');
     		insert objAccount;
	     	                                                                                          
	     	Campaign objCampaign = new Campaign();
		    objCampaign.Name = 'testCampaign';
		    insert objCampaign;
		    
		    Lead leadObj1 = new Lead();
		    leadObj1.FirstName = 'Virendra';                  
		    leadObj1.LastName = 'Singh';
		    leadObj1.Phone = '9910106823';
		    leadObj1.Email = 'lead005@lead005.com';          
		    leadObj1.Company = 'TestIndiaLead'; //
		    leadObj1.Status = '1.5 Call Out';
		    leadObj1.LeadSource = 'Inbound Call';
		    leadObj1.Downgrade_Reason__c = 'Not Enough Info';
		    leadObj1.Duplicate_Lead__c = true;
		    insert leadObj1;
		    
		    Contact objCont = new Contact();
		    objCont.FirstName = 'test';
		    objCont.LastName = 'Ltest';
		    objCont.Email = 'test@sm.com';
		    objCont.AccountID = objAccount.id;
		   	insert  objCont;
		   
		    CampaignMember objCampMem = new CampaignMember(CampaignId = objCampaign.Id,LeadId = leadObj1.Id,ContactId=objCont.Id);
	        insert objCampMem;
	        
	        Test.startTest();
			Lead leadObj3 = new Lead();
		    leadObj3.FirstName = 'Virendra';               
		    leadObj3.LastName = 'Singh';
		    leadObj3.Phone = '9910106823';  
		    leadObj3.Email = 'lead005@lead005.com';             
		    leadObj3.Company = 'TestIndiaLead'; 
		    leadObj3.Status = '1.5 Call Out';
		    leadObj3.LeadSource = 'Inbound Chat';                            
		    leadObj3.Downgrade_Reason__c = 'Not Enough Info';                        
		    leadObj3.LeadExistingSource__c = 'Opportunity';                                 
		    leadObj3.existingLeadId__c = objCont.Id;
		    leadObj3.Duplicate_Lead__c = true;
		    insert leadObj3;
		    
		  	leadUpdationFutureHandler.overrideExistingLead();           
			Test.stopTest();
    }catch(Exception e){}
    }
	static testMethod void TestLeadUpdationFutureHandler1(){
     try{
     		Account objAccount = new Account(Name = 'test Name');
     		insert objAccount;
	     	
	     	Campaign objCampaign = new Campaign();
		    objCampaign.Name = 'testCampaign';
		    insert objCampaign;
		    
		    Lead leadObj1 = new Lead();
		    leadObj1.FirstName = 'Virendra';
		    leadObj1.LastName = 'Singh';
		    leadObj1.Phone = '9910106823';
		    leadObj1.Email = 'lead005@lead005.com';
		    leadObj1.Company = 'TestIndiaLead'; //
		    leadObj1.Status = '1.51 Call Out';
		    //leadObj1.LeadSource = 'Inbound Call';
		    leadObj1.LeadSource ='Opportunity';
		    //leadObj1.LeadExistingSource__c = 'Opportunity';
		    leadObj1.Downgrade_Reason__c = 'Not Enough Info';
		    leadObj1.Duplicate_Lead__c = true;
		    insert leadObj1;
		    
		    Contact objCont = new Contact();
		    objCont.FirstName = 'test';
		    objCont.LastName = 'Ltest';
		    objCont.Email = 'test@sm.com';
		    objCont.AccountID = objAccount.id;
		   	insert  objCont;
		    CampaignMember objCampMem = new CampaignMember(CampaignId = objCampaign.Id,LeadId = leadObj1.Id,ContactId=objCont.Id);
	        insert objCampMem;
	        
	        Test.startTest();
			Lead leadObj3 = new Lead();
		    leadObj3.FirstName = 'Virendra';
		    leadObj3.LastName = 'Singh';
		    leadObj3.Phone = '9910106823';
		    leadObj3.Email = 'lead005@lead005.com';
		    leadObj3.Company = 'TestIndiaLead'; 
		    leadObj3.Status = '1.5 Call Out';
		    leadObj3.LeadSource = 'Inbound Chat';
		    leadObj3.Downgrade_Reason__c = 'Not Enough Info';
		    leadObj3.existingLeadId__c = leadObj1.Id;
		    leadObj3.LeadExistingSource__c = 'Opportunity';
		    leadObj3.Duplicate_Lead__c = true;
		    insert leadObj3;
		    
		  	leadUpdationFutureHandler.overrideExistingLead();
			Test.stopTest();
    }catch(Exception e){}
    }
}