/*............Test class for the PartnerRequestRedirect class 
   created date ------05/22/2014 ...........................  */

@isTest()
private class TestPartnerRequest {
	static testMethod void testRequestResellerDirect() {
		Schema.DescribeSObjectResult result = Account.SObjectType.getDescribe();
    	Map<string,Schema.RecordTypeInfo> rtMapById = result.getRecordTypeInfosByName();
		Account accObj = new Account();
        accObj.Name = 'TestAccount';
        accObj.Number_of_DL_s__c = 5;
        accObj.RecordTypeId = rtMapById.get('Partner Account').getRecordTypeID();
        accObj.Type ='Partner';
        accObj.Partner_ID__c = '12345';
        accObj.RC_Attribution_Channel__c = 'Sales Agents & Resellers';
        accObj.PartnerStatus__c = 'Declined';
        TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT = true;                                      
        insert accObj;  
        TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT = false;
		
		Partner_Request__c prm = new Partner_Request__c();   
		prm.Partner_First_Name__c = 'Testloki';
		prm.Partner_Last_Name__c = 'lokie';
		prm.Partner_Phone__c = '9910106803';    
		prm.Partner_City__c = 'ca';
		prm.Partner_Email_Address__c = 'virendra.singh@simplion.com';  
		prm.Partner_Company_Name__c = 'simplio';
		prm.Partner_Country__c = 'united state';
		prm.Partner_Address1__c = 'fgf';
		prm.Partner_Zip__c = '02904';
		prm.Partner_Type__c = 'Franchisor';
		prm.Partner_Request_Source__c = 'National Accounts';
		prm.DSR_USER__c = UserInfo.getUserId(); 		
		insert prm;
		
		prm.Partner_Company_Name__c = accObj.Name;
		update prm;
		
		Partner_Request__c prm1 = new Partner_Request__c();        
		prm1.Partner_First_Name__c = 'Testloki';
		prm1.Partner_Last_Name__c = 'lokie';
		prm1.Partner_Phone__c = '9910106803';
		prm1.Partner_City__c = 'ca';  
		prm1.Partner_Email_Address__c = 'virendra.singh@simplion.com';  
		prm1.Partner_Company_Name__c = 'simplio';
		prm1.Partner_Country__c = 'united state';
		prm1.Partner_Address1__c = 'fgf';   
		prm1.Partner_Zip__c = '02904';
		prm1.Partner_Type__c = 'Franchisor';
		prm1.Partner_Request_Source__c = 'National Accounts';
		prm1.DSR_USER__c = UserInfo.getUserId(); 
		prm1.Partner_Company_Name__c = accObj.Name;		
		insert prm1;

		Lead leadObj = new Lead();
		leadObj.FirstName = 'Testloki';
		leadObj.LastName = 'lokie';
		leadObj.Company = 'Simplion';
		leadObj.Email = 'virendra.singh@simplion.com';
		leadObj.Phone = '9910106804';
		leadObj.Country = 'United States';
		leadObj.State = 'California';
		leadObj.City = 'ca';
		leadObj.PostalCode = '02904';
		leadObj.Street = 'ah';
		insert leadObj;

		//Insert and get Id  of Lead object  
		Contact contactObj = new Contact();
		contactObj.Email = 'virendra.singh1111@simplion.com';
		contactObj.Phone = '9910106803';
		contactObj.Company__c = 'simplio';
		contactObj.LastName = 'TestLaast';
		contactObj.FirstName = 'FirsLaast';
		contactObj.MailingCountry = 'United States';
		contactObj.MailingCity = 'ca';
		contactObj.MailingStreet = 'ca';
		contactObj.MailingState = 'California';
		contactObj.MailingPostalCode = '02904';
		insert contactObj;
		//Insert and get Id  of Contact object                                 
		ApexPages.currentPage().getParameters().put('contactId', contactObj.Id);
		ApexPages.currentPage().getParameters().put('leadId', leadObj.Id);
		PartnerRequestRedirect partREqRedir = new PartnerRequestRedirect();
		try {
			partREqRedir.redirectToPartnerRequest();
			ApexPages.currentPage().getParameters().put('contactId', contactObj.Id);
			ApexPages.currentPage().getParameters().put('leadId', null);
			partREqRedir = new PartnerRequestRedirect();
			partREqRedir.redirectToPartnerRequest();
		} catch (exception ex) {}
	}
}