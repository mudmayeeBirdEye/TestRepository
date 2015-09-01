@isTest
private class TestImplementationMethod {
	public static testmethod void testImplementationMethods() {
		Map<id, User> mapUser = new Map<id, User>();
		User testUser = new User(alias = 'u1', email='u1234@testorg.com',emailencodingkey='UTF-8', FirstName='testName',lastname='Testing123', 
								 ProfileId=[SELECT Id FROM Profile LIMIT 1].Id, 
                        		 languagelocalekey='en_US',localesidkey='en_US', country='United States',
                        		 timezonesidkey='America/Los_Angeles', username='u11234@testorg.com', IsActive=true);                   
        insert testUser;
        mapUser.put(testUser.id,testUser);
        
         RecordType rt = [SELECT Id FROM RecordType WHERE Name='Partner Account'];
         
	    Account acctest = new Account();
	    acctest.Name = 'TestAccount';
	    acctest.RC_Attribution_Channel__c = 'Sales Agents & Resellers';
	    acctest.OwnerId = testUser.id;
	    system.debug(' acctest.OwnerId ==> '+ acctest.OwnerId);
	    acctest.Partner_ID__c ='123';
	    acctest.BMID__c = '211';
	    acctest.PID__c = '442';
	    acctest.AID__c = '111';
	    acctest.RC_Account_Number__c =  '11';
	    acctest.RC_Account_Status__c = 'Paid';
	    acctest.Do_Not_Creation_Implementation__c = false;
	    acctest.RC_Service_Name__c = 'Office';
	    acctest.RC_User_Id__c = 'Test701';
	    acctest.Number_of_DL_s__c = 11;
	    acctest.RC_Brand__c = 'Test';
	    acctest.RC_Tier__c = 'Test';
	    acctest.RC_Signup_Date__c = System.today();
	    acctest.RecordTypeId  = rt.Id;
	   // acctest.AccountContactRoles = 'TestAccount';
	    //acctest.AccountContactRole = '';
	    insert acctest;
	    
	    Account accObj = new Account();
	    accObj.Name = 'TestAccount1';
	    accObj.RC_Attribution_Channel__c = 'Sales Agents & Resellers';
	    accObj.OwnerId = testUser.id;
	    system.debug(' accObj.OwnerId ==> '+ accObj.OwnerId);
	    accObj.Partner_ID__c ='1231';
	    accObj.BMID__c = '2111';
	    accObj.PID__c = '4421';
	    accObj.AID__c = '1111';
	    accObj.RC_Account_Number__c =  '111';
	    accObj.RC_Account_Status__c = 'Test1';
	    accObj.Do_Not_Creation_Implementation__c = false;
	    accObj.RC_Service_Name__c = 'Office';
	    accObj.RC_User_Id__c = 'Test7011';
	    accObj.Number_of_DL_s__c = 11;
	    accObj.RC_Brand__c = 'Test1';
	    accObj.RC_Tier__c = 'Test1';
	    accObj.RC_Signup_Date__c = System.today();
	    accObj.RecordTypeId  = rt.Id;
	    //accObj.AccountContactRole = '';
	    insert accObj;
	    
	    Contact contactObj = new Contact();
	    contactObj.AccountId =  acctest.id;
	    contactObj.FirstName = 'RCtest';
	    contactObj.Email = 'test123@test.com';
	    contactObj.LastName = 'TestLast';
	    contactObj.Phone ='9632255698';
	    contactObj.Company__c ='Rc Test';
	    contactObj.NumberOfEmployees__c = '67';
	    insert contactObj;
	    
	    Lead leadObj2 = new Lead();
		leadObj2.FirstName='Virendra';
        leadObj2.LastName='Singh';
        leadObj2.Company='Simplion';
        leadObj2.Phone='9910106804';
        leadObj2.email = 'fake@email.com';
        leadObj2.LeadSource = 'Inbound Call';
        leadObj2.Website = 'http://test.com';
        leadObj2.NumberOfEmployees = 123;
     	leadObj2.Industry = 'Test';
        leadObj2.NumberOfEmployees__c = '2-19';
        leadObj2.Number_of_Locations__c = '2-4';
	 	leadObj2.Agent_Email_Address__c = 'test@test.com';  
        insert leadObj2; 
        
        AccountContactRole accountContactRoleObj = new AccountContactRole() ;
		accountContactRoleObj.AccountId = acctest.Id;
		accountContactRoleObj.ContactId = contactObj.Id;
		
		//accountContactRoleObj.AccountContactRoles
		insert accountContactRoleObj;
		
		Implementation__c impObj = new Implementation__c();
		
        impObj.Name = 'testImp';
        impObj.Account__c = acctest.Id;
        impObj.Implementation_Status__c = 'Contacted';
        //insert impObj;
        System.debug('Implementattion'+impObj);
		 
		//accObj
		Test.startTest();
		ImplementationMethods impM = new ImplementationMethods();
		//impM.a	
		//impM.allowImplemenation(acctest);	
		//impM.createImplementations(acctest, 'test');
		
		Map<String,RCSF_Sync__c> mapRCUser = new map<String,RCSF_Sync__c>();
		Map<id,Contact> contact_map = new Map<id, Contact>([Select ID, FirstName,Phone,LastName,Email, Name From Contact WHERE AccountId =: acctest.Id Limit 100]);
		contact_map.put( acctest.Id,contactObj);
		System.debug('Contact >>>'+contact_map);
		Map<Id, Implementation__c> accountImplementationMap = new Map<id, Implementation__c>();
		Map<Id, Lead> newAccountLeadMap =  new Map<Id, Lead>([Select ID,Account__r.Id From Lead  WHERE Account__r.Id =: acctest.Id Limit 100]);
		Map<String,Integer> mapAccountImplementation1 = new Map<String, Integer>();
		List<Contact> contactPartnerList = new List<Contact>([Select ID, Phone, Email, AccountId, LastName, FirstName, Name From Contact  WHERE AccountId =: acctest.Id limit 100]);
		
		impM.createImplementations(acctest, contact_map, impObj);
		//impM.createImplementations(acctest, contact_map, 'Rctest');
	 	
     	Lead l = [Select Id From Lead Limit 1];
	 
		Map<id, Account> accountMap = new Map<id, Account>([Select Id, Name, RC_Account_Number__c, Partner_ID__c, RC_Account_Status__c, RC_Tier__c,
     									BMID__c, PID__c,AID__c, Do_Not_Creation_Implementation__c,RC_Service_Name__c, Owner.Name ,Owner.Email,
     									Owner.Team__c, Owner.Manager.Name,Owner.Manager.Email,No_of_Employees__c,(Select AccountId, ContactId, Contact.Email, Contact.Phone, Contact.LastName, Account.Name, Account.No_of_Employees__c From AccountContactRoles),
        								(Select AccountId, id, Email, Phone, LastName,FirstName  From Contacts), RC_User_Id__c, Number_of_DL_s__c, RC_Brand__c From Account Where id =: acctest.id ]);
      	
      	//impM.createLead( acctest, l);
	 	impM.createLead(acctest, contact_map,l);
	 	
      	impM.createLeadOfficeTrail(acctest,accountMap);
	 	impM.createAccountLead(newAccountLeadMap, accountMap, contact_map);
	 	System.debug('Account lead'+newAccountLeadMap); 
	 	//impM.createAccountImplementation(acctest, contact_map, impObj.Clone());
		//impM.createAccountImplementation(accountImplementationMap, accountMap, contact_map);
		mapAccountImplementation1.put(acctest.Id, 0);
	 	impM.getContactAccountMap(accountMap);
	 	//impM.createVARSurveyOnAccountActivation(acctest, accountMap);
	 	//impM.toCreateImplementationOnInsOrUpdOfficeTrials(acctest);
	 	impM.tocreateImplemetationOnInsorUpdForTELUS(acctest, mapAccountImplementation1);
	 	impM.createVARSurveyOnAccountActivation(acctest,accountMap, contactPartnerList);
	 	//map<String,Integer> mapAccountImplementation1 = new Map<String,Integer>();
	 
	 	impM.toCreateImplementationOnInsOrUpdRing(acctest, mapAccountImplementation1);
	 	//impM.toCreateImplementationOnUpd(acctest, accObj);
	 	impM.toCreateImplementationOnUpd(acctest, accObj, mapAccountImplementation1);
	 	impM.chkToHardwareRtnOnDeactivation(acctest, accObj);
	 	impM.toCreateImplementationOnInsOrUpdOfficeTrials(acctest, mapAccountImplementation1);
	 	delete accountContactRoleObj;
	 	accountMap = new Map<id, Account>([Select Id, Name, RC_Account_Number__c, Partner_ID__c, RC_Account_Status__c, RC_Tier__c,
     									BMID__c, PID__c,AID__c, Do_Not_Creation_Implementation__c,RC_Service_Name__c, Owner.Name ,Owner.Email,
     									Owner.Team__c, Owner.Manager.Name,Owner.Manager.Email,No_of_Employees__c,(Select AccountId, ContactId, Contact.Email, Contact.Phone, Contact.LastName, Account.Name, Account.No_of_Employees__c From AccountContactRoles),
        								(Select AccountId, id, Email, Phone, Account.Name, Account.No_of_Employees__c,LastName,FirstName From Contacts), RC_User_Id__c, Number_of_DL_s__c, RC_Brand__c From Account Where id =: acctest.id ]);
      	
	 	impM.createLeadOfficeTrail(acctest,accountMap);
	 	//impM.createVARSurveyOnAccountActivation(acctest, accountMap);
	 	impM.createVARSurveyOnAccountActivation(acctest,accountMap, contactPartnerList);
	 	
	 	Test.stopTest();
	 }
}