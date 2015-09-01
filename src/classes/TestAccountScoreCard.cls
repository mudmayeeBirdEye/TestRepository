@isTest
private class TestAccountScoreCard {

    static testMethod void myUnitTest() {
    	
    	Test_Utils testUtilsObj = new Test_Utils();
    	try {
    		
    		// Creating test User.
	        User testUser = new User();                   
			testUser = testUtilsObj.createUserRecord(new List<User>{new User()})[0];
		
    		Account acctestRc = new Account();
    		acctestRc.Name='RC Internal';
    		acctestRc.Current_Owner__c = testUser.Id; 
    		Account acctest = new Account();
	        acctest.Name='TestAccount';
	        acctest.Current_Owner__c = testUser.Id;
	        
	        List<Account> accountRecordList =  new List<Account>();
	        accountRecordList.add(acctestRc);
	        accountRecordList.add(acctest);
    		accountRecordList = testUtilsObj.createAccountRecord(accountRecordList);
    		
    		Network_Information__c networkInfo =  new Network_Information__c();
			networkInfo.Account__c = accountRecordList[1].Id;
			networkInfo.Router_New_Router_Make_and_Model__c = 'TestModem';
			networkInfo.Modem_Make_and_Model__c = 'TestModel';
			insert networkInfo;
	        
	        Contact contactObj = new Contact();
	        contactObj.AccountId =  accountRecordList[1].Id;
	        contactObj = testUtilsObj.createContactRecord(new List<Contact>{contactObj})[0];
	    	
	        Account_Metric__c accMetricObj = new Account_Metric__c();
	        accMetricObj.Peer_Group_ID__c = 100;
	        accMetricObj.Account_ID__c = accountRecordList[1].Id;
	        accMetricObj = testUtilsObj.createAccountMetricRecords(new List<Account_Metric__c>{accMetricObj})[0];
	        
	        Implementation__c implementationObj =  new Implementation__c();
	        implementationObj.Account__c = accountRecordList[1].Id;
	        implementationObj.Implementation_Status__c = '6a. Completed';
	        implementationObj.Contact__c = contactObj.Id;
	        implementationObj = testUtilsObj.createImplementationRecords(new List<Implementation__c>{implementationObj})[0];
	        
	        Test.startTest();
		        ApexPages.currentPage().getParameters().put('accid', accountRecordList[1].Id);
		        ApexPages.StandardController sc = new ApexPages.standardController(accountRecordList[1]);
		        AccountMetricExtension accmetricExObj = new AccountMetricExtension(sc);
		        accmetricExObj.inputtxtsearch = 'Test';
		        accmetricExObj.getContactOptions();
		        accmetricExObj.selectedContacts.add(contactObj.id);
		        accmetricExObj.setToAddress();
		        accmetricExObj.removeToAddress();
		        accmetricExObj.setCCList();
		        accmetricExObj.removeCCList();
		        accmetricExObj.getAllCCOptions();
		        accmetricExObj.setAdditionalTo();
		        accmetricExObj.removeAdditionalTo();
		        accmetricExObj.getAllAdditionalTo();
		        accmetricExObj.setBccList();
		        accmetricExObj.removeBccList();
		        accmetricExObj.getAllBccOptions();
		        accmetricExObj.sendMailToCustomerCall();
		        accmetricExObj.exportasPDF();
		        accmetricExObj.redirectToSendMailPage();
		        accmetricExObj.cancel();
		        accmetricExObj.getemailonSearch();
	        Test.stopTest();	
    	}catch(Exception ex) {
    		system.debug('#### Error on line - '+ex.getLineNumber());
	    	system.debug('#### Error message - '+ex.getMessage());
    	}
    }
    
 	static testMethod void myUnitTest1() {
 		
 		Test_Utils testUtilsObj = new Test_Utils();
     	try {
     		
     		// Creating test User.
	        User testUser = new User();                   
			testUser = testUtilsObj.createUserRecord(new List<User>{new User()})[0];
			
     		Account acctestRc = new Account();
    		acctestRc.Name='TestAccount';
    		acctestRc.Current_Owner__c = testUser.Id; 
    		acctestRc = testUtilsObj.createAccountRecord(new List<Account>{acctestRc})[0];
	        
	        Contact contactObj = new Contact();
	        contactObj.AccountId =  acctestRc.id;
	        contactObj.Email = 'test.test@test.com';
	        contactObj = testUtilsObj.createContactRecord(new List<Contact>{contactObj})[0];
	    	
	        Account_Metric__c accMetricObj = new Account_Metric__c();
	        accMetricObj.Peer_Group_ID__c = 101;
	        accMetricObj.Account_ID__c = acctestRc.Id;
	        accMetricObj = testUtilsObj.createAccountMetricRecords(new List<Account_Metric__c>{accMetricObj})[0];
	        
	        Test.startTest();
		        ApexPages.currentPage().getParameters().put('accid', acctestRc.id);
		        ApexPages.StandardController sc = new ApexPages.standardController(acctestRc);
		        AccountMetricExtensionPDF accmetricExPDFObj = new AccountMetricExtensionPDF(sc);
	        Test.stopTest();			
     	} catch(Exception ex) {
     		system.debug('#### Error on line - '+ex.getLineNumber());
	    	system.debug('#### Error message - '+ex.getMessage());
     	}
     }
     
     static testMethod void myUnitTest2() {
     	
     	Test_Utils testUtilsObj = new Test_Utils();
     	try {
     		
     		// Creating test User.
	        User testUser = new User();                   
			testUser = testUtilsObj.createUserRecord(new List<User>{new User()})[0];
			
     		Account acctestRc = new Account();
    		acctestRc.Name='TestAccount';
    		acctestRc.Current_Owner__c = testUser.Id; 
    		acctestRc = testUtilsObj.createAccountRecord(new List<Account>{acctestRc})[0];
	        
	        Account_Metric__c accMetricObj = new Account_Metric__c();
	        accMetricObj.Peer_Group_ID__c = 101;
	        accMetricObj.Account_ID__c = acctestRc.Id;
	        accMetricObj = testUtilsObj.createAccountMetricRecords(new List<Account_Metric__c>{accMetricObj})[0];
	        
	        Test.startTest();
		        //ApexPages.currentPage().getParameters().put('accid', acctest.id);
		        ApexPages.StandardController sc = new ApexPages.standardController(acctestRc);
		        AccountHealthcardHelper acchealthObj = new AccountHealthcardHelper(sc);
	        Test.stopTest();			
     	} catch(Exception ex) {
     		system.debug('#### Error on line - '+ex.getLineNumber());
	    	system.debug('#### Error message - '+ex.getMessage());
     	}
     }
     
      static testMethod void myUnitTest3() {
     	
     	Test_Utils testUtilsObj = new Test_Utils();
     	try {
     		
     		// Creating test User.
	        User testUser = new User();                   
			testUser = testUtilsObj.createUserRecord(new List<User>{new User()})[0];
			
     		Account acctestRc = new Account();
    		acctestRc.Name='TestAccount';
    		acctestRc.Current_Owner__c = testUser.Id; 
    		acctestRc = testUtilsObj.createAccountRecord(new List<Account>{acctestRc})[0];
	        
	        Account_Metric__c accMetricObj = new Account_Metric__c();
	        accMetricObj.Peer_Group_ID__c = 101;
	        accMetricObj.Metric_1_value__c = 0;
	        accMetricObj.Metric_18_value__c = 0;
	        accMetricObj.Metric_11_value__c = 1;
	        accMetricObj.Account_ID__c = acctestRc.Id;
	        accMetricObj = testUtilsObj.createAccountMetricRecords(new List<Account_Metric__c>{accMetricObj})[0];
	        
	        Test.startTest();
		        ApexPages.currentPage().getParameters().put('accid', acctestRc.Id);
		        ApexPages.StandardController sc = new ApexPages.standardController(acctestRc);
		        AccountMetricExtension accmetricExObj = new AccountMetricExtension(sc);
	        Test.stopTest();			
     	} catch(Exception ex) {
     		system.debug('#### Error on line - '+ex.getLineNumber());
	    	system.debug('#### Error message - '+ex.getMessage());
     	}
     }
}// End of Test Class.