/**************************************************************************************************
* Project Name..........: RingCentral -                                                           *
* File..................: Test_SyncAccountWS.cls                                                  *
* Version...............: 1.0                                                                     *
* Created by............: Simplion Technologies                                                   *
* Created Date..........: 31 December 2013                                                        *
* Last Modified by......: Simplion Technologies                                                   *
* Last Modified Date....:                                                                         *
* Description...........: This is a test class for SyncAccountWS class.                           *
**************************************************************************************************/

@isTest
private class Test_SyncAccountWS {
	
	public Account createAccount(){
		Account accountobj1 = new Account();
		accountobj1.Name = 'Test Customer Account'+String.valueOf(System.currentTimeMillis());
		accountobj1.Partner_ID__c = 'PARTNER002';
		accountobj1.Phone = '9910101111';
		accountobj1.AccountNumber = '991010';
		accountobj1.RC_User_ID__c = '21331231';
		insert accountobj1;
		
		return accountobj1;
	}
	
	public EntitlementEnable__c createEntitlementEnable(){
		EntitlementEnable__c mycs = EntitlementEnable__c.getValues('IsEntitlementsEnabled__c');
		  if(mycs == null) {
		    mycs = new EntitlementEnable__c();
		    mycs.IsEntitlementsEnabled__c = true;
		    mycs.Name = 'IsEntitlementsEnabled';
		    insert mycs;
		  }
		  
		  return mycs;
	}
	
	public Contact createContact(Account accountobj1){
		
		Contact contObj = new Contact(); 
		contObj.AccountId =  accountobj1.Id;
		contObj.Email = 'abc2@test.com';
		contObj.LastName = 'Test Last2'+String.valueOf(System.currentTimeMillis());
		contObj.FirstName = 'Test First2'+String.valueOf(System.currentTimeMillis());
		insert contObj;
		
		return contObj;
	}
	
	public User createUser(Contact contObj){
		
		// Creating User record.
		User testUser = new User(alias = 'u1', email='u1234@testorg.com',emailencodingkey='UTF-8', 
								 lastname='Testing'+String.valueOf(System.currentTimeMillis()), 
								 ProfileId='00e80000001OK6k',contactId = contObj.Id,
                        		 languagelocalekey='en_US',localesidkey='en_US', country='United States',
                        		 timezonesidkey='America/Los_Angeles', username='u11234@testorg.com', IsActive=true);                   
        insert testUser;
        
        return testUser;
	}
	
	public Opportunity createOpportunity(Account accountobj1){
		//Inserting opportunity record.
    	Opportunity Oppval = new Opportunity();
        Oppval.Name = 'Test Opp'+String.valueOf(System.currentTimeMillis());
        Oppval.AccountId = accountobj1.Id;
        Oppval.Type = 'Existing Business';
        Oppval.StageName = '3. Qualified';
        Oppval.Sales_Model__c = 'Direct';
        Oppval.CloseDate = System.Today() + 10;
        Oppval.CurrencyIsoCode = 'USD';
        Oppval.Brand_Name__c= 'RingCentral';
        Oppval.RecordTypeId = '01280000000UEtz';
        Oppval.Proposal_Expiration_Date__c = System.today() + 100;
        insert Oppval;
        
        return Oppval;
	}
	
	public Lead createLead(){
		//Inserting Lead record.
        Lead leadObj = new Lead();
        leadObj.FirstName = 'FName';
        leadObj.Email= 'abc2@test.com';
        leadObj.LastName = 'LastName'; 
        leadObj.Company  ='TestCompany';
        leadObj.phone = '21331231';
        leadObj.Downgrade_Reason__c  = 'Not Enough Info';
        leadObj.User_ID__c ='12345';
        leadObj.Website = 'test.com';
        leadObj.NumberOfEmployees = 5;
        leadObj.Industry = 'Consulting: IT';
        leadObj.NumberOfEmployees__c='2-19';
        leadObj.Number_of_Locations__c ='2-4'; 
        leadObj.LeadSource = 'Data.com';
        leadObj.Status ='2. Contacted';
        leadObj.Isconverted = false;
        //leadObj.Account__c
		insert leadObj;
		
		return leadObj;
	}
	// Test method for positive cases.
    static testMethod void TestSyncAccountWS() {
	    	try{
	    		
	    		Test_SyncAccountWS testClassObject = new Test_SyncAccountWS();
		        //Setting up records database.
		        EntitlementEnable__c mycs = EntitlementEnable__c.getValues('IsEntitlementsEnabled__c');
		        mycs = testClassObject.createEntitlementEnable();
		        Account accountobj1 = new Account();
		        accountobj1 = testClassObject.createAccount();
		        Contact contObj = new Contact(); 
		        contObj = testClassObject.createContact(accountobj1);
		        User testUser = new User();
		        testUser = testClassObject.createUser(contObj);
		        
		        SyncAccountWS syncAcc = new SyncAccountWS();
		        SyncAccountWS.syncAcctInputParam syncparam = new SyncAccountWS.syncAcctInputParam();
		        syncparam.In_RCUserID = '21331231';
		        syncparam.In_RCPrimaryNumber = '21331231';
		        syncparam.In_FirstName = '21331231';
		        syncparam.In_LastName = 'LastName';
		        syncparam.In_ContactEmail = 'abc2@test.com';
		        syncparam.In_Company = 'test';
		        syncparam.In_Contactphone = '21331231';
		        syncparam.In_RCBRAND = '21331231';
		        syncparam.In_SERVICENAME = '21331231';
		        syncparam.In_TIERNAME = '21331231';
		        syncparam.In_SignupPlatform = 'test';
		        syncparam.proc_AccountId = accountobj1.Id;
		        syncparam.In_RCPrimaryNumber = '991010';
		        syncparam.In_Attribute_Value_01 = '21331231';
		        syncparam.In_Attribute_Key_02 = '21331231';
		        syncparam.In_Attribute_Value_02 = '21331231';
		        syncparam.In_Attribute_Key_03 = '21331231';
		        syncparam.In_Attribute_Value_03 = '21331231';
		        syncparam.In_Attribute_Key_04 = '21331231';
		        syncparam.In_Attribute_Value_04 = '21331231';
		        syncparam.In_Attribute_Key_05 = '21331231';
		        syncparam.In_Attribute_Value_05 = '21331231';
		        
		        test.startTest();
		        SyncAccountWS.synAccountNew(syncparam);
		        SyncAccountWS.handleRetrun(syncparam);
		        SyncAccountWS.handleCreateUser(syncparam);
		        SyncAccountWS.contactHavingUserRecord(syncparam);
		        SyncAccountWS.accountMatchingContactEmail(syncparam);
		        SyncAccountWS.accountMatchingContactEmail(syncparam);
		        SyncAccountWS.handleCreateContact(syncparam);
		        SyncAccountWS.handleCreateAccount(syncparam);
		        SyncAccountWS.handleConverLead(syncparam);
		        SyncAccountWS.handleUpdateAccount(syncparam);
		        SyncAccountWS.searchLeadByEmail(syncparam);
		        SyncAccountWS.searchContactByMail(syncparam);
		        SyncAccountWS.searchOppertunityByOID(syncparam);
		        SyncAccountWS.synAccountCreateUser(syncparam);
		        Test.stopTest();
		    }catch(Exception ex){
	    		system.debug('#### Error @ - '+ex.getMessage());
	    	}
    }//End of positive method.
    
    // Test method for positive cases.
    static testMethod void TestSyncAccountWS1() {
	    	try{
	    		
	    		Test_SyncAccountWS testClassObject = new Test_SyncAccountWS();
		        //Setting up records database.
		        EntitlementEnable__c mycs = EntitlementEnable__c.getValues('IsEntitlementsEnabled__c');
		        mycs = testClassObject.createEntitlementEnable();
		        Account accountobj1 = new Account();
		        accountobj1 = testClassObject.createAccount();
		        Contact contObj = new Contact(); 
		        contObj = testClassObject.createContact(accountobj1);
		        User testUser = new User();
		        testUser = testClassObject.createUser(contObj);
		        
		        SyncAccountWS syncAcc = new SyncAccountWS();
		        SyncAccountWS.syncAcctInputParam syncparam = new SyncAccountWS.syncAcctInputParam();
		        syncparam.In_RCUserID = '21331231';
		        syncparam.In_RCPrimaryNumber = '21331231';
		        syncparam.In_FirstName = '21331231';
		        syncparam.In_LastName = 'LastName';
		        syncparam.In_ContactEmail = 'abc22@test.com';
		        syncparam.In_Company = 'test';
		        syncparam.In_Contactphone = '21331231';
		        syncparam.In_RCBRAND = '21331231';
		        syncparam.In_SERVICENAME = '21331231';
		        syncparam.In_TIERNAME = '21331231';
		        syncparam.In_SignupPlatform = 'test';
		        syncparam.proc_AccountId = accountobj1.Id;
		        syncparam.In_RCPrimaryNumber = '991010';
		        syncparam.In_Attribute_Value_01 = '21331231';
		        syncparam.In_Attribute_Key_02 = '21331231';
		        syncparam.In_Attribute_Value_02 = '21331231';
		        syncparam.In_Attribute_Key_03 = '21331231';
		        syncparam.In_Attribute_Value_03 = '21331231';
		        syncparam.In_Attribute_Key_04 = '21331231';
		        syncparam.In_Attribute_Value_04 = '21331231';
		        syncparam.In_Attribute_Key_05 = '21331231';
		        syncparam.In_Attribute_Value_05 = '21331231';
		        
		        test.startTest();
		        SyncAccountWS.synAccountNew(syncparam);
		        Test.stopTest();
		    }catch(Exception ex){
	    		system.debug('#### Error @ - '+ex.getMessage());
	    	}
    }//End of positive method.
    
    //Test method for searchContactByMail return true;
    static testMethod void TestSyncAccountWSNegative1() {
    	
    	try{
    		
    		Test_SyncAccountWS testClassObject = new Test_SyncAccountWS();
    		//Inserting Account record.
    		Account accountobj1 = new Account();
    		accountobj1 = testClassObject.createAccount();
    		accountobj1.RC_User_ID__c = null;
    		accountobj1.RC_Sync_Status__c = 'Pending';
    		update accountobj1;
			
			Contact contObj = new Contact(); 
	        contObj = testClassObject.createContact(accountobj1);
			
	    	Opportunity Oppval = new Opportunity();
	    	Oppval = testClassObject.createOpportunity(accountobj1);
		        
	    	SyncAccountWS syncAcc = new SyncAccountWS();
	        SyncAccountWS.syncAcctInputParam syncparam = new SyncAccountWS.syncAcctInputParam();
	        syncparam.In_RCUserID = '21331231';
	        syncparam.In_RCPrimaryNumber = '21331231';
	        syncparam.In_FirstName = '21331231';
	        syncparam.In_LastName = 'LastName';
	        syncparam.In_ContactEmail = 'abc2@test.com';
	        syncparam.In_Company = 'test';
	        syncparam.In_Contactphone = '21331231';
	        syncparam.In_RCBRAND = '21331231';
	        syncparam.In_SERVICENAME = '21331231';
	        syncparam.In_TIERNAME = '21331231';
	        syncparam.In_SignupPlatform = 'test';
	        //syncparam.proc_AccountId = accountobj1.Id;
	        syncparam.In_RCPrimaryNumber = '991010';
	        syncparam.In_Attribute_Value_01 = '21331231';
	        syncparam.In_Attribute_Key_02 = '21331231';
	        syncparam.In_Attribute_Value_02 = '21331231';
	        syncparam.In_Attribute_Key_03 = '21331231';
	        syncparam.In_Attribute_Value_03 = '21331231';
	        syncparam.In_Attribute_Key_04 = '21331231';
	        syncparam.In_Attribute_Value_04 = '21331231';
	        syncparam.In_Attribute_Key_05 = '21331231';
	        syncparam.In_Attribute_Value_05 = '21331231';
	        syncparam.In_OpportunityID = Oppval.Id;
	        
	        
	        test.startTest();
	        	SyncAccountWS.synAccountNew(syncparam);
	        	SyncAccountWS.synAccountCreateUser(syncparam);
	        test.stopTest();
    	}catch(Exception ex){
    		system.debug('#### Exception @ - '+ex.getMessage());
    	}
    }// End of negative 1 method. 	
    
    //Test method for searchContactByMail return true;
    static testMethod void TestSyncAccountWSNegative12() {
    	
    	try{
    		
    		Test_SyncAccountWS testClassObject = new Test_SyncAccountWS();
    		//Inserting Account record.
    		Account accountobj1 = new Account();
    		accountobj1 = testClassObject.createAccount();
    		accountobj1.RC_User_ID__c = null;
    		accountobj1.RC_Sync_Status__c = 'Pending';
    		update accountobj1;
			
			Contact contObj = new Contact(); 
	        contObj = testClassObject.createContact(accountobj1);
			
	    	Opportunity Oppval = new Opportunity();
	    	Oppval = testClassObject.createOpportunity(accountobj1);
		        
	    	SyncAccountWS syncAcc = new SyncAccountWS();
	        SyncAccountWS.syncAcctInputParam syncparam = new SyncAccountWS.syncAcctInputParam();
	        syncparam.In_RCUserID = '21331231';
	        syncparam.In_RCPrimaryNumber = '21331231';
	        syncparam.In_FirstName = '21331231';
	        syncparam.In_LastName = 'LastName';
	        syncparam.In_ContactEmail = 'abc22@test.com';
	        syncparam.In_Company = 'test';
	        syncparam.In_Contactphone = '21331231';
	        syncparam.In_RCBRAND = '21331231';
	        syncparam.In_SERVICENAME = '21331231';
	        syncparam.In_TIERNAME = '21331231';
	        syncparam.In_SignupPlatform = 'test';
	        //syncparam.proc_AccountId = accountobj1.Id;
	        syncparam.In_RCPrimaryNumber = '991010';
	        syncparam.In_Attribute_Value_01 = '21331231';
	        syncparam.In_Attribute_Key_02 = '21331231';
	        syncparam.In_Attribute_Value_02 = '21331231';
	        syncparam.In_Attribute_Key_03 = '21331231';
	        syncparam.In_Attribute_Value_03 = '21331231';
	        syncparam.In_Attribute_Key_04 = '21331231';
	        syncparam.In_Attribute_Value_04 = '21331231';
	        syncparam.In_Attribute_Key_05 = '21331231';
	        syncparam.In_Attribute_Value_05 = '21331231';
	        syncparam.In_OpportunityID = Oppval.Id;
	        
	        test.startTest();
	        	SyncAccountWS.synAccountNew(syncparam);
	        test.stopTest();
	        
    	}catch(Exception ex){
    		system.debug('#### Exception @ - '+ex.getMessage());
    	}
    }// End of negative 12 method. 
    
    //Test method for searchContactByMail return false;
    static testMethod void TestSyncAccountWSNegative2() {
    	
    	try{
    		
    		Test_SyncAccountWS testClassObject = new Test_SyncAccountWS();
    		//Inserting Account record.
    		Account accountobj1 = new Account();
    		accountobj1 = testClassObject.createAccount();
    		accountobj1.RC_User_ID__c = null;
    		accountobj1.RC_Sync_Status__c = null;
    		accountobj1.RecordTypeId ='01280000000UERq';
    		update accountobj1;
    		
			Contact contObj = new Contact(); 
	        contObj = testClassObject.createContact(accountobj1);
	        
	    	Opportunity Oppval = new Opportunity();
	    	Oppval = testClassObject.createOpportunity(accountobj1);
		        
	    	SyncAccountWS syncAcc = new SyncAccountWS();
	        SyncAccountWS.syncAcctInputParam syncparam = new SyncAccountWS.syncAcctInputParam();
	        syncparam.In_RCUserID = '21331231';
	        syncparam.In_RCPrimaryNumber = '21331231';
	        syncparam.In_FirstName = '21331231';
	        syncparam.In_LastName = 'LastName';
	        syncparam.In_ContactEmail = 'abc2@test.com';
	        syncparam.In_Company = 'test';
	        syncparam.In_Contactphone = '21331231';
	        syncparam.In_RCBRAND = '21331231';
	        syncparam.In_SERVICENAME = '21331231';
	        syncparam.In_TIERNAME = '21331231';
	        syncparam.In_SignupPlatform = 'test';
	        //syncparam.proc_AccountId = accountobj1.Id;
	        syncparam.In_RCPrimaryNumber = '991010';
	        syncparam.In_Attribute_Value_01 = '21331231';
	        syncparam.In_Attribute_Key_02 = '21331231';
	        syncparam.In_Attribute_Value_02 = '21331231';
	        syncparam.In_Attribute_Key_03 = '21331231';
	        syncparam.In_Attribute_Value_03 = '21331231';
	        syncparam.In_Attribute_Key_04 = '21331231';
	        syncparam.In_Attribute_Value_04 = '21331231';
	        syncparam.In_Attribute_Key_05 = '21331231';
	        syncparam.In_Attribute_Value_05 = '21331231';
	        syncparam.In_OpportunityID = Oppval.Id;
	        
	        test.startTest();
	        	SyncAccountWS.synAccountNew(syncparam);
	        test.stopTest();
    	}catch(Exception ex){
    		system.debug('#### Exception @ - '+ex.getMessage());
    	}
    }// End of negative method 2.
    
    //Test method for searchContactByMail return false;
    static testMethod void TestSyncAccountWSNegative22() {
    	
    	try{
    		
    		Test_SyncAccountWS testClassObject = new Test_SyncAccountWS();
    		//Inserting Account record.
    		Account accountobj1 = new Account();
    		accountobj1 = testClassObject.createAccount();
    		accountobj1.RC_User_ID__c = null;
    		accountobj1.RC_Sync_Status__c = null;
    		accountobj1.RecordTypeId ='01280000000UERq';
    		update accountobj1;
    		
			Contact contObj = new Contact(); 
	        contObj = testClassObject.createContact(accountobj1);
	        
	    	Opportunity Oppval = new Opportunity();
	    	Oppval = testClassObject.createOpportunity(accountobj1);
		        
	    	SyncAccountWS syncAcc = new SyncAccountWS();
	        SyncAccountWS.syncAcctInputParam syncparam = new SyncAccountWS.syncAcctInputParam();
	        syncparam.In_RCUserID = '21331231';
	        syncparam.In_RCPrimaryNumber = '21331231';
	        syncparam.In_FirstName = '21331231';
	        syncparam.In_LastName = 'LastName';
	        syncparam.In_ContactEmail = 'abc22@test.com';
	        syncparam.In_Company = 'test';
	        syncparam.In_Contactphone = '21331231';
	        syncparam.In_RCBRAND = '21331231';
	        syncparam.In_SERVICENAME = '21331231';
	        syncparam.In_TIERNAME = '21331231';
	        syncparam.In_SignupPlatform = 'test';
	        //syncparam.proc_AccountId = accountobj1.Id;
	        syncparam.In_RCPrimaryNumber = '991010';
	        syncparam.In_Attribute_Value_01 = '21331231';
	        syncparam.In_Attribute_Key_02 = '21331231';
	        syncparam.In_Attribute_Value_02 = '21331231';
	        syncparam.In_Attribute_Key_03 = '21331231';
	        syncparam.In_Attribute_Value_03 = '21331231';
	        syncparam.In_Attribute_Key_04 = '21331231';
	        syncparam.In_Attribute_Value_04 = '21331231';
	        syncparam.In_Attribute_Key_05 = '21331231';
	        syncparam.In_Attribute_Value_05 = '21331231';
	        syncparam.In_OpportunityID = Oppval.Id;
	        
	        test.startTest();
	        	SyncAccountWS.synAccountNew(syncparam);
	        test.stopTest();
    	}catch(Exception ex){
    		system.debug('#### Exception @ - '+ex.getMessage());
    	}
    }// End of negative method 22.
    
    //Test method for searchLeadByEmail return true;
    static testMethod void TestSyncAccountWSNegative3() {
    	
    	try{
    		
    		Test_SyncAccountWS testClassObject = new Test_SyncAccountWS();
    		//Inserting Account record.
    		Account accountobj1 = new Account();
    		accountobj1 = testClassObject.createAccount();
    		accountobj1.RC_User_ID__c = null;
    		update accountobj1;
			
	    	//Inserting opportunity record.
	    	Opportunity Oppval = new Opportunity();
	    	Oppval = testClassObject.createOpportunity(accountobj1);
	        
	        //Inserting Lead record.
	        Lead leadObj = new Lead();
	        leadObj = testClassObject.createLead();
		        
	    	SyncAccountWS syncAcc = new SyncAccountWS();
	        SyncAccountWS.syncAcctInputParam syncparam = new SyncAccountWS.syncAcctInputParam();
	        syncparam.In_RCUserID = '21331231';
	        syncparam.In_RCPrimaryNumber = '21331231';
	        syncparam.In_FirstName = '21331231';
	        syncparam.In_LastName = 'LastName';
	        syncparam.In_ContactEmail = 'abc2@test.com';
	        syncparam.In_Company = 'test';
	        syncparam.In_Contactphone = '21331231';
	        syncparam.In_RCBRAND = '21331231';
	        syncparam.In_SERVICENAME = '21331231';
	        syncparam.In_TIERNAME = '21331231';
	        syncparam.In_SignupPlatform = 'test';
	        //syncparam.proc_AccountId = accountobj1.Id;
	        syncparam.In_RCPrimaryNumber = '991010';
	        syncparam.In_Attribute_Value_01 = '21331231';
	        syncparam.In_Attribute_Key_02 = '21331231';
	        syncparam.In_Attribute_Value_02 = '21331231';
	        syncparam.In_Attribute_Key_03 = '21331231';
	        syncparam.In_Attribute_Value_03 = '21331231';
	        syncparam.In_Attribute_Key_04 = '21331231';
	        syncparam.In_Attribute_Value_04 = '21331231';
	        syncparam.In_Attribute_Key_05 = '21331231';
	        syncparam.In_Attribute_Value_05 = '21331231';
	        syncparam.In_OpportunityID = Oppval.Id;
	        
	        test.startTest();
	        	SyncAccountWS.synAccountNew(syncparam);
	        test.stopTest();
    	}catch(Exception ex){
    		system.debug('#### Exception @ - '+ex.getMessage());
    	}
    }// End of negative method 3.
    
    //Test method for searchLeadByEmail return true;
    static testMethod void TestSyncAccountWSNegative32() {
    	
    	try{
    		
    		Test_SyncAccountWS testClassObject = new Test_SyncAccountWS();
    		//Inserting Account record.
    		Account accountobj1 = new Account();
    		accountobj1 = testClassObject.createAccount();
    		accountobj1.RC_User_ID__c = null;
    		update accountobj1;
			
	    	//Inserting opportunity record.
	    	Opportunity Oppval = new Opportunity();
	    	Oppval = testClassObject.createOpportunity(accountobj1);
	        
	        //Inserting Lead record.
	        Lead leadObj = new Lead();
	        leadObj = testClassObject.createLead();
		        
	    	SyncAccountWS syncAcc = new SyncAccountWS();
	        SyncAccountWS.syncAcctInputParam syncparam = new SyncAccountWS.syncAcctInputParam();
	        syncparam.In_RCUserID = '21331231';
	        syncparam.In_RCPrimaryNumber = '21331231';
	        syncparam.In_FirstName = '21331231';
	        syncparam.In_LastName = 'LastName';
	        syncparam.In_ContactEmail = 'abc22@test.com';
	        syncparam.In_Company = 'test';
	        syncparam.In_Contactphone = '21331231';
	        syncparam.In_RCBRAND = '21331231';
	        syncparam.In_SERVICENAME = '21331231';
	        syncparam.In_TIERNAME = '21331231';
	        syncparam.In_SignupPlatform = 'test';
	        //syncparam.proc_AccountId = accountobj1.Id;
	        syncparam.In_RCPrimaryNumber = '991010';
	        syncparam.In_Attribute_Value_01 = '21331231';
	        syncparam.In_Attribute_Key_02 = '21331231';
	        syncparam.In_Attribute_Value_02 = '21331231';
	        syncparam.In_Attribute_Key_03 = '21331231';
	        syncparam.In_Attribute_Value_03 = '21331231';
	        syncparam.In_Attribute_Key_04 = '21331231';
	        syncparam.In_Attribute_Value_04 = '21331231';
	        syncparam.In_Attribute_Key_05 = '21331231';
	        syncparam.In_Attribute_Value_05 = '21331231';
	        syncparam.In_OpportunityID = Oppval.Id;
	        
	        test.startTest();
	        	SyncAccountWS.synAccountNew(syncparam);
	        test.stopTest();
    	}catch(Exception ex){
    		system.debug('#### Exception @ - '+ex.getMessage());
    	}
    }// End of negative method 32.
    
    //Test method for searchAccountByUID return false;
    static testMethod void TestSyncAccountWSNegative4() {
    	
    	try{
    		
    		Test_SyncAccountWS testClassObject = new Test_SyncAccountWS();
    		//Inserting Account record.
    		Account accountobj1 = new Account();
    		accountobj1 = testClassObject.createAccount();
			accountobj1.RC_User_ID__c = null;
			accountobj1.RecordTypeId ='01280000000UERq';
			update accountobj1;
			
			Contact contObj = new Contact(); 
	        contObj = testClassObject.createContact(accountobj1);
			
	    	SyncAccountWS syncAcc = new SyncAccountWS();
	        SyncAccountWS.syncAcctInputParam syncparam = new SyncAccountWS.syncAcctInputParam();
	        syncparam.In_RCUserID = '21331231';
	        syncparam.In_RCPrimaryNumber = '21331231';
	        syncparam.In_FirstName = '21331231';
	        syncparam.In_LastName = 'LastName';
	        syncparam.In_ContactEmail = 'abc2@test.com';
	        syncparam.In_Company = 'test';
	        syncparam.In_Contactphone = '21331231';
	        syncparam.In_RCBRAND = '21331231';
	        syncparam.In_SERVICENAME = '21331231';
	        syncparam.In_TIERNAME = '21331231';
	        syncparam.In_SignupPlatform = 'test';
	        //syncparam.proc_AccountId = accountobj1.Id;
	        syncparam.In_RCPrimaryNumber = '991010';
	        syncparam.In_Attribute_Value_01 = '21331231';
	        syncparam.In_Attribute_Key_02 = '21331231';
	        syncparam.In_Attribute_Value_02 = '21331231';
	        syncparam.In_Attribute_Key_03 = '21331231';
	        syncparam.In_Attribute_Value_03 = '21331231';
	        syncparam.In_Attribute_Key_04 = '21331231';
	        syncparam.In_Attribute_Value_04 = '21331231';
	        syncparam.In_Attribute_Key_05 = '21331231';
	        syncparam.In_Attribute_Value_05 = '21331231';
	        
	        test.startTest();
	        	SyncAccountWS.synAccountNew(syncparam);
	        test.stopTest();
    	}catch(Exception ex){
    		system.debug('#### Exception @ - '+ex.getMessage());
    	}
    }// End of negative method 4.
    
    //Test method for searchAccountByUID return false;
    static testMethod void TestSyncAccountWSNegative42() {
    	
    	try{
    		
    		Test_SyncAccountWS testClassObject = new Test_SyncAccountWS();
    		//Inserting Account record.
    		Account accountobj1 = new Account();
    		accountobj1 = testClassObject.createAccount();
			accountobj1.RC_User_ID__c = null;
			accountobj1.RecordTypeId ='01280000000UERq';
			update accountobj1;
			
			Contact contObj = new Contact(); 
	        contObj = testClassObject.createContact(accountobj1);
			
	    	SyncAccountWS syncAcc = new SyncAccountWS();
	        SyncAccountWS.syncAcctInputParam syncparam = new SyncAccountWS.syncAcctInputParam();
	        syncparam.In_RCUserID = '21331231';
	        syncparam.In_RCPrimaryNumber = '21331231';
	        syncparam.In_FirstName = '21331231';
	        syncparam.In_LastName = 'LastName';
        	syncparam.In_ContactEmail = 'abc22@test.com';
	        syncparam.In_Company = 'test';
	        syncparam.In_Contactphone = '21331231';
	        syncparam.In_RCBRAND = '21331231';
	        syncparam.In_SERVICENAME = '21331231';
	        syncparam.In_TIERNAME = '21331231';
	        syncparam.In_SignupPlatform = 'test';
	        //syncparam.proc_AccountId = accountobj1.Id;
	        syncparam.In_RCPrimaryNumber = '991010';
	        syncparam.In_Attribute_Value_01 = '21331231';
	        syncparam.In_Attribute_Key_02 = '21331231';
	        syncparam.In_Attribute_Value_02 = '21331231';
	        syncparam.In_Attribute_Key_03 = '21331231';
	        syncparam.In_Attribute_Value_03 = '21331231';
	        syncparam.In_Attribute_Key_04 = '21331231';
	        syncparam.In_Attribute_Value_04 = '21331231';
	        syncparam.In_Attribute_Key_05 = '21331231';
	        syncparam.In_Attribute_Value_05 = '21331231';
	        
	        test.startTest();
	        	SyncAccountWS.synAccountNew(syncparam);
	        test.stopTest();
    	}catch(Exception ex){
    		system.debug('#### Exception @ - '+ex.getMessage());
    	}
    }// End of negative method 42.
    
    //Test method for searchAccountByUID return false;
    static testMethod void TestSyncAccountWSNegative5() {
    	
    	try{
    		
    		Test_SyncAccountWS testClassObject = new Test_SyncAccountWS();
    		//Inserting Account record.
    		Account accountobj1 = new Account();
    		accountobj1 = testClassObject.createAccount();
			accountobj1.RC_User_ID__c = null;
			accountobj1.RecordTypeId ='01280000000UERq';
			update accountobj1;
			
			//Inserting Lead record.
	        Lead leadObj = new Lead();
	        leadObj = testClassObject.createLead();
		        
	    	SyncAccountWS syncAcc = new SyncAccountWS();
	        SyncAccountWS.syncAcctInputParam syncparam = new SyncAccountWS.syncAcctInputParam();
	        syncparam.In_RCUserID = '21331231';
	        syncparam.In_RCPrimaryNumber = '21331231';
	        syncparam.In_FirstName = '21331231';
	        syncparam.In_LastName = 'LastName';
	        syncparam.In_ContactEmail = 'abc2@test.com';
	        syncparam.In_Company = 'test';
	        syncparam.In_Contactphone = '21331231';
	        syncparam.In_RCBRAND = '21331231';
	        syncparam.In_SERVICENAME = '21331231';
	        syncparam.In_TIERNAME = '21331231';
	        syncparam.In_SignupPlatform = 'test';
	        //syncparam.proc_AccountId = accountobj1.Id;
	        syncparam.In_RCPrimaryNumber = '991010';
	        syncparam.In_Attribute_Value_01 = '21331231';
	        syncparam.In_Attribute_Key_02 = '21331231';
	        syncparam.In_Attribute_Value_02 = '21331231';
	        syncparam.In_Attribute_Key_03 = '21331231';
	        syncparam.In_Attribute_Value_03 = '21331231';
	        syncparam.In_Attribute_Key_04 = '21331231';
	        syncparam.In_Attribute_Value_04 = '21331231';
	        syncparam.In_Attribute_Key_05 = '21331231';
	        syncparam.In_Attribute_Value_05 = '21331231';
	        
	        test.startTest();
	        	SyncAccountWS.synAccountNew(syncparam);
	        test.stopTest();
    	}catch(Exception ex){
    		system.debug('#### Exception @ - '+ex.getMessage());
    	}
    }// End of negative method 5.
    
    //Test method for searchAccountByUID return false;
    static testMethod void TestSyncAccountWSNegative52() {
    	
    	try{
    		
    		Test_SyncAccountWS testClassObject = new Test_SyncAccountWS();
    		//Inserting Account record.
    		Account accountobj1 = new Account();
    		accountobj1 = testClassObject.createAccount();
			accountobj1.RC_User_ID__c = null;
			accountobj1.RecordTypeId ='01280000000UERq';
			update accountobj1;
			
			//Inserting Lead record.
	        Lead leadObj = new Lead();
	        leadObj = testClassObject.createLead();
		        
	    	SyncAccountWS syncAcc = new SyncAccountWS();
	        SyncAccountWS.syncAcctInputParam syncparam = new SyncAccountWS.syncAcctInputParam();
	        syncparam.In_RCUserID = '21331231';
	        syncparam.In_RCPrimaryNumber = '21331231';
	        syncparam.In_FirstName = '21331231';
	        syncparam.In_LastName = 'LastName';
	        syncparam.In_ContactEmail = 'abc22@test.com';
	        syncparam.In_Company = 'test';
	        syncparam.In_Contactphone = '21331231';
	        syncparam.In_RCBRAND = '21331231';
	        syncparam.In_SERVICENAME = '21331231';
	        syncparam.In_TIERNAME = '21331231';
	        syncparam.In_SignupPlatform = 'test';
	        //syncparam.proc_AccountId = accountobj1.Id;
	        syncparam.In_RCPrimaryNumber = '991010';
	        syncparam.In_Attribute_Value_01 = '21331231';
	        syncparam.In_Attribute_Key_02 = '21331231';
	        syncparam.In_Attribute_Value_02 = '21331231';
	        syncparam.In_Attribute_Key_03 = '21331231';
	        syncparam.In_Attribute_Value_03 = '21331231';
	        syncparam.In_Attribute_Key_04 = '21331231';
	        syncparam.In_Attribute_Value_04 = '21331231';
	        syncparam.In_Attribute_Key_05 = '21331231';
	        syncparam.In_Attribute_Value_05 = '21331231';
	        
	        test.startTest();
	        	SyncAccountWS.synAccountNew(syncparam);
	        test.stopTest();
    	}catch(Exception ex){
    		system.debug('#### Exception @ - '+ex.getMessage());
    	}
    }// End of negative method 52.
    
}// End of Test Class.