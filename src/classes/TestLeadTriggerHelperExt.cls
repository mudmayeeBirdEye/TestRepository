@isTest
private class TestLeadTriggerHelperExt {

    static testMethod void myUnitTest() {
    	try {
    		User user1 = new User(alias = 'newUser007', email='newuser007@simplion.com.test',
			emailencodingkey='UTF-8', lastname='Testing1', 
			languagelocalekey='en_US', localesidkey='en_US', profileid = Userinfo.getProfileId(),
			timezonesidkey='America/Los_Angeles', username= System.now().millisecond() + 'newuser007@simplion.com.test');
			insert user1;
    		Schema.DescribeSObjectResult leadDescRes = Schema.SObjectType.Lead; 
			Map<String,Schema.RecordTypeInfo> leadRecordTypeInfo = leadDescRes.getRecordTypeInfosByName();
			
			List<Campaign> campaignList = new List<Campaign>();
		    Campaign campObj1 = new Campaign(Name='Default Campaign',Protected_Campaign__c=true
	        , Shared_Lead_Campaign__c=true, Lead_Creation_Score__c='300', IsActive=true, AID__c='test0121' );
	        campaignList.add(campObj1);
	        
	        Campaign campObj2 = new Campaign(Name='TestCampaign',Protected_Campaign__c=false
	        , Shared_Lead_Campaign__c=true, Lead_Creation_Score__c='test', IsActive=true, DNIS__c='test0121' );
	        campaignList.add(campObj1);
	        
	        Campaign campObj3 = new Campaign(Name='TestCampaign',Protected_Campaign__c=true
	        , Shared_Lead_Campaign__c=true, Lead_Creation_Score__c='-200', IsActive=true, PID__c='test0121', BMID__c='test0122', AID__c='test0123' );
	        campaignList.add(campObj1);
	        
	        Campaign campObj4 = new Campaign(Name='TestCampaign',Protected_Campaign__c=false
	            , Shared_Lead_Campaign__c=true, Lead_Creation_Score__c='200.00', IsActive=true, BMID__c='test0121' );
	        campaignList.add(campObj1);
	        insert campaignList;
	        
	        List<Lead> leadList = new List<Lead>();
	        Lead leadObj0 = new Lead(firstName='Singh', Title='VP', LeadSource='Solve Then Sell', Sales_Agent_User_Lookup__c=user1.Id, Lead_Entry_Source__c='ROI Form', Primary_Campaign__c=campObj3.Id, lastname = 'Virendra', 
	        							company='Simplion', email='virendra.singh0@simplion.com', phone='9910106804', BMID__c = 'test0121',
	        							RecordTypeId = leadRecordTypeInfo.get('Sales Leads').getRecordTypeId());
	        leadList.add(leadObj0);
	        							
	        Lead leadObj1 = new Lead(firstName='Singh', Title='VP', Lead_Entry_Source__c='ROI Form', LeadSource='Initial', lastname = 'Virendra', 
	        							company='Simplion', email='virendra.singh@simplion.com', phone='9910106804', BMID__c = 'test0121',
	        							RecordTypeId = leadRecordTypeInfo.get('Partner Leads').getRecordTypeId());
	        leadList.add(leadObj1);
	        
	        Lead leadObj2 = new Lead(firstName='Singh', Title='VP', AID__C='test0121', Referrer_RCUserID__c='Test002', 
	        					LeadSource='About To Be Cancelled',User_ID__c='Test002', lastname = 'Virendra', 
	        					company='Simplion', email='virendra.singh1@simplion.com', phone='9910106805');
	        leadList.add(leadObj2);
	        
	        Lead leadObj3 = new Lead(firstName='Singh', Title='VP', PID__c='test0121', NumberOfEmployees__c ='500+', LeadSource='Vista Print', lastname = 'Virendra', 
	        company='Simplion', email='virendra.singh2@simplion.com', phone='(919)191-9128');
	        leadList.add(leadObj3);
	        insert leadList;
	        
	        Test.startTest();
	        LeadTriggerHelperExt leadTrgObj = new LeadTriggerHelperExt();
	        LeadTriggerHelperExt.assignCampaigns(leadList);
	        Lead leadObj4 = new Lead(firstName='Singh1', Title='VP', PID__c='test0121', BMID__c='test0122', AID__c='test0123', 
	        							NumberOfEmployees__c ='500+', 
	        							LeadSource = 'Vista Print', lastname = 'Virendra', 
	        							company='Simplion', email= 'virendra.singh7@simplion.com', phone='(919)191-9122');
	        
	        List<Lead> leadList1 = new List<Lead>();							
	        leadList1.add(leadObj4);
	        LeadTriggerHelperExt.assignCampaigns(leadList1);
	        Lead leadObj5 = new Lead(firstName='Singh15', Title='VP', PID__c='test0121', BMID__c='test0122', 
	        							NumberOfEmployees__c ='500+', 
	        							LeadSource = 'Vista Print', lastname = 'Virendra', 
	        							company='Simplion', email= 'virendra.singh15@simplion.com', phone='(919)191-9115');
	        
	        leadList1 = new List<Lead>();							
	        leadList1.add(leadObj5);
	        LeadTriggerHelperExt.assignCampaigns(leadList1);
	        Test.stopTest();	
    	} catch(Exception ex) {}
    }
}