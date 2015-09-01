/**************************************************************************************************
* Project Name..........: Account	                                                              *
* File..................: TestAccountTriggerHelper.class                                          *
* Version...............: 1.0                                                                     *
* Created by............: Simplion Technologies                                                   *
* Created Date..........: 06-04-2014                                                              *
* Last Modified by......: Simplion Technologies                                                   *
* Last Modified Date....: 06-04-2014                                                              *
* Description...........: This is a test class for AccountTriggerHelper class.                    *
**************************************************************************************************/

@isTest
private class TestAccountTriggerHelper {
    public static Test_Utils objTest_Utils = new Test_Utils();
    
    private static void setBypassFlagFalse(){
		TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT = false; 
		TriggerHandler.BY_PASS_ACCOUNT_ON_UPDATE =  false;
    }
    
    static testMethod void updateAccountActiveDateWeb(){
       
        TriggerHandler.BY_PASS_LEAD_UPDATE = true;
        
		Account accObj = new Account();
		accObj.Name = 'Test123';
		accObj.SignupType__c = 'TRIAL_30NOCC';
		accObj.RC_Account_Status__c = 'TRIAL';
		accObj.SignupPlatform__c = 'WEB';
		accObj.RC_Service_name__c = 'office123';
		accObj.RC_Activation_Date__c = null;
		accObj.Partner_ID__c = '9852';
		insert accObj;
       
		Contact contactObj = new Contact();
		contactObj.AccountId =  accObj.id;
		contactObj.Email = 'fake@email.com';
		contactObj.LastName = 'TestLast';
		contactObj.Phone='9910106804';
		insert contactObj;
		 
		setBypassFlagFalse();		
		accObj.RC_Service_name__c = 'Office789';
		update accObj;
    }
    
	static testMethod void updateLeadTRIAL_30_NO_CC(){ 
	   Account acctObj = new Account();
	   acctObj.Name = 'Test12';
       acctObj.SignupType__c = 'TRIAL_30NOCC';
       acctObj.RC_Account_Status__c = null;
       acctObj.SignupPlatform__c = 'iphone';
       acctObj.RC_Service_name__c = 'office123';
       acctObj.RC_User_ID__c = '123456';
       acctObj.RC_Brand__c = 'RingCentral';
       insert acctObj;
       
       Contact contactObj = new Contact();
	   contactObj.AccountId =  acctObj.id;
	   contactObj.Email = 'fake@email.com';
	   contactObj.LastName = 'TestLast';
	   contactObj.Phone='9910106804';
	   insert contactObj;
	   
	   setBypassFlagFalse();
	   acctObj.SignupType__c = null;
       acctObj.RC_Account_Status__c = 'Trial 30 no-CC';
       acctObj.SignupPlatform__c = null;
       acctObj.RC_User_ID__c = '1234567';
       acctObj.RC_Service_name__c = 'Office789';
       update acctObj;
	 } 
	
   static testMethod void updateAccountActiveDateMobile(){ 
   	   TriggerHandler.BY_PASS_LEAD_UPDATE = true;
	   Account acctObj = new Account();
	   acctObj.Name = 'Test12';
       acctObj.SignupType__c = 'TRIAL_30NOCC';
       acctObj.RC_Account_Status__c = 'TRIAL';
       acctObj.SignupPlatform__c = 'iphone';
       acctObj.RC_Service_name__c = 'office123';
       acctObj.RC_Account_Status__c = 'paid';
       insert acctObj;
       
       Contact contactObj = new Contact();
	   contactObj.AccountId =  acctObj.id;
	   contactObj.Email = 'fake@email.com';
	   contactObj.LastName = 'TestLast';
	   contactObj.Phone='9910106804';
	   insert contactObj;
	   
	   setBypassFlagFalse();
       acctObj.RC_Service_name__c = 'Office789';
       update acctObj;
       
	 } 
    
    static testMethod void survey(){  
    	/*TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT = true;
    	TriggerHandler.BY_PASS_ACCOUNT_ON_UPDATE = true;
    	TriggerHandler.BY_PASS_CONTACT_ON_INSERT = true;
    	TriggerHandler.BY_PASS_CONTACT_ON_UPDATE = true;*/
    	//TriggerHandler.BY_PASS_OPPORTUNITY_ON_INSERT = true;
    	//TriggerHandler.BY_PASS_OPPORTUNITY_ON_UPDATE = true;
    	
        List<Account> accountList = new List<Account>();
        Map<Id,Account> newAccountMap = new Map<Id,Account>();
        Account oldAccount;
     	
     	Schema.DescribeSObjectResult result = Account.SObjectType.getDescribe();
        Map<String,Schema.RecordTypeInfo> rtMapByName = result.getRecordTypeInfosByName();
        Schema.RecordTypeInfo rtByName =  rtMapByName.get('Partner Account');
     	
     	Account accInsert = new Account();
        accInsert.Name = 'Test123';
        accInsert.SignupType__c = 'TRIAL_30NOCC';
        accInsert.RC_Account_Status__c = 'TRIAL';
        accInsert.SignupPlatform__c = 'android';
        accInsert.RC_Service_name__c = 'office123';
        accInsert.RC_Activation_Date__c = null;
        accInsert.RecordTypeId =  rtByName.getRecordTypeId() ;
        accInsert.Partner_ID__c = '9852';
        accInsert.RC_Account_Status__c = 'paid';
       	insert accInsert;
       	
     	Contact contactObj = new Contact();
	    contactObj.AccountId =  accInsert.id;
	    contactObj.Email = 'fake@email.com';
	   	contactObj.LastName = 'TestLast';
	    contactObj.Phone='9910106804';
	    insert contactObj;
	    
	    test.startTest();
	    
	    
       	Opportunity  oppObj = new Opportunity ();
        oppObj.name ='test2';
        oppObj.AccountId= accInsert.id;
        oppObj.Sales_Model__c='direct';
        oppObj.Type='New Business';
        oppObj.StageName='Qualified';
        oppObj.CloseDate=System.today();
     	insert oppObj;
     	
     	
     	
        AccountContactRole accountContactRoleObj = new AccountContactRole() ;
		accountContactRoleObj.AccountId = accInsert.Id;
		accountContactRoleObj.ContactId = contactObj.Id;
		accountContactRoleObj.IsPrimary = true;
		insert accountContactRoleObj;
		
       	//setBypassFlagFalse();
       	test.stopTest();
       	
       	accInsert.RC_Service_name__c = 'office789';
       	accInsert.Is_Demo_Account__c = false;
       	accInsert.RC_Activation_Date__c = system.now();
       	accInsert.RC_Attribution_Channel__c = 'Sales Agents & Resellers';
       	update accInsert;
     	
    }
    
    static testMethod void partnerAccount(){

		List<User> userList = new List<User>();
		userList = objTest_Utils.createUserRecord(new List<User>{new User(), new User(), new User()});
		  
     	Schema.DescribeSObjectResult result = Account.SObjectType.getDescribe();
        Map<String,Schema.RecordTypeInfo> rtMapByName = result.getRecordTypeInfosByName();
        Schema.RecordTypeInfo rtByName =  rtMapByName.get('Partner Account');
        
		List<Account> accountList = new List<Account>();
		
		// Parent Account.
		Account accInsert = new Account();
        accInsert.RecordTypeId = rtByName.getRecordTypeId(); //'01280000000UERv';
        accInsert.Current_Owner__c = userList[0].Id;
        accInsert.Ultimate_Partner_ID__c = '992323';
        accInsert.Type = 'Partner';
        accInsert.Partner_ID__c = '15669';
        accInsert.RC_Account_Status__c = 'paid';
        accountList.add(accInsert);
        Account accPartnerObj = new Account();
        accPartnerObj.RecordTypeId = rtByName.getRecordTypeId();
        accountList.add(accPartnerObj);
        Account accCustomerObj = new Account();
        accountList.add(accCustomerObj);
        accountList = objTest_Utils.createAccountRecord(accountList);

        Id parentId = accountList[0].Id;
        
        setBypassFlagFalse();
        accountList[1].Partner_ID__c = parentId;
        accountList[1].Current_Owner__c = userList[1].Id;
        accountList[1].ParentId = parentId;
        
        accountList[2].Partner_ID__c = parentId;
        accountList[2].Current_Owner__c = userList[2].Id;
        accountList[2].ParentId = parentId;
        accountList[2].Ultimate_Partner_ID__c = '999222';
        update accountList;
    }
    
    static testMethod void createImplementationForChange(){ 
    	Test.startTest();
    		Test_Utils testUtilsObject =  new Test_Utils();
    		testUtilsObject.initialiseTriggerBypass();
			Account acctObj = new Account();
		   	acctObj.Name = 'Test12';
		   	acctObj.RC_Brand__c = 'RingCentral';
		   	acctObj.Number_of_DL_s__c = 2;
		   	acctObj.RC_Service_name__c = 'office123';
		   	acctObj.RC_User_ID__c = '1234';
	       	acctObj.RC_Account_Status__c = null;
	       	insert acctObj;
	       
	       	Contact contactObj = new Contact();
		   	contactObj.AccountId =  acctObj.id;
		   	contactObj.Email = 'fake@email.com';
		   	contactObj.LastName = 'TestLast';
		   	contactObj.Phone='9910106804';
		   	insert contactObj;
		   
		   
		   	List<Implementation__c> implementationAccount = new List<Implementation__c>();
		   	implementationAccount = [SELECT Id FROM Implementation__c WHERE Account__c =: acctObj.Id];
		   	if(implementationAccount != null && !implementationAccount.isEmpty()){
				delete implementationAccount;
		   	}
		   
		   	// Change Account Status.
		   	//setBypassFlagFalse();
		   	acctObj.RC_Brand__c = 'RingCentral';
		   	acctObj.Number_of_DL_s__c = 2;
		   	acctObj.RC_Service_name__c = 'Office789';
		   	acctObj.RC_User_ID__c = '12345';
	       	acctObj.RC_Account_Status__c = 'Trial 30 no-CC';
	       	update acctObj;
	       
	       	List<Implementation__c> implementationAccountd = new List<Implementation__c>();
		   	implementationAccountd = [SELECT Id FROM Implementation__c WHERE Account__c =: acctObj.Id];
		   	if(implementationAccountd != null && !implementationAccountd.isEmpty()){
				delete implementationAccountd;
		   	}
		   
	       	// Change for Telus Account.
	       	setBypassFlagFalse();
			acctObj.RC_Brand__c = 'Telus';
			acctObj.RC_Account_Status__c = '30-Day Office Trial';
			acctObj.Do_Not_Creation_Implementation__c = false;
			update acctObj;
		Test.stopTest();
    }
    
     static testMethod void createImplementationForServiceChange(){ 
	   
       Account acctObj = new Account();
	   acctObj.Name = 'Test12';
	   acctObj.RC_Brand__c = 'TestBrand';
	   acctObj.Number_of_DL_s__c = 2;
	   acctObj.RC_Service_name__c = null;
	   acctObj.RC_User_ID__c = '1234';
       acctObj.RC_Account_Status__c = null;
       acctObj.RC_Service_name__c = 'Paid';
       acctObj.Service_Type__c = 'Paid';
       insert acctObj;
       
       Contact contactObj = new Contact();
	   contactObj.AccountId =  acctObj.id;
	   contactObj.Email = 'fake@email.com';
	   contactObj.LastName = 'TestLast';
	   contactObj.Phone='9910106804';
	   insert contactObj;
     	
       List<Implementation__c> implementationAccountd = new List<Implementation__c>();
	   implementationAccountd = [SELECT Id FROM Implementation__c WHERE Account__c =: acctObj.Id];
	   if(implementationAccountd != null && !implementationAccountd.isEmpty()){
			delete implementationAccountd;
	   }
	   
	   setBypassFlagFalse();
	   acctObj.RC_Service_name__c = 'Office';
	   acctObj.RC_Account_Status__c = 'Canceled';
	   acctObj.Service_Type__c = 'Office';
	   //acctObj.RC_Account_Status__c = 'Trial';
	   update acctObj;
     }
    
    static testMethod void upListAccount(){
    	
    	List<Account> accountList = new List<Account>();
    	accountList = objTest_Utils.createAccountRecord(new List<Account>{new Account(), new Account()});
    	
    	List<Account> accountListnew = new List<Account>();
        Account accInsert = new Account();
        accInsert.ParentId = accountList[0].Id;
        accInsert.RC_User_ID__c = '12321';
        accInsert.RC_Account_Status__c = 'paid';
        accountListnew.add(accInsert);
        accountListnew = objTest_Utils.createAccountRecord(accountListnew);

        setBypassFlagFalse();
        accountListnew[0].ParentId = accountList[1].Id;
        update accountList;
    }

    static testMethod void clear(){
    	
        Account acctObj = new Account();
        acctObj.Name = 'Test12';
        acctObj.RC_Brand__c = 'TestBrand';
        acctObj.Number_of_DL_s__c = 2;
        acctObj.RC_Service_name__c = null;
        acctObj.RC_User_ID__c = '1234';
        acctObj.RC_Account_Status__c = 'paid';
        acctObj.RC_Service_name__c = 'Paid';
        acctObj.Service_Type__c = 'Paid';
        insert acctObj;
    	
    	Contract con = new Contract();
    	con.BillingCity = 'BillingCity';
    	con.AccountId = acctObj.Id;
    	insert con;
    	
    	AccountTriggerHelper.sendEmails(con);
    	AccountTriggerHelper.survey();
        AccountTriggerHelper.deinitalize();
    }
    
    static testMethod void testImplementationMethod(){
    	
    	List<Account> accountForImplementation =  new List<Account>();
    	
    	// Telus Implementation.
		Account acctObjTelus = new Account();
		acctObjTelus.RC_Brand__c = 'Telus';
		acctObjTelus.RC_Account_Status__c = '30-Day Office Trial';
		acctObjTelus.Do_Not_Creation_Implementation__c = false;
		accountForImplementation.add(acctObjTelus);
		
		// Ring Central Implementation.
		Account acctObjRC = new Account();
		acctObjRC.RC_Brand__c = 'RingCentral';
       	acctObjRC.RC_Account_Status__c = '30-Day Office Trial';
       	acctObjRC.Do_Not_Creation_Implementation__c = false;
       	accountForImplementation.add(acctObjRC);
       	
       	// No Brand as such.
       	Account acctObj = new Account();
   		acctObj.RC_Brand__c = 'TestBrand';
       	acctObj.RC_Account_Status__c = '30-Day Office Trial';
       	acctObj.Do_Not_Creation_Implementation__c = false;
       	accountForImplementation.add(acctObj);
       	
       	accountForImplementation = objTest_Utils.createAccountRecord(accountForImplementation);
    }
    
	 static testMethod void testAccountDisabled(){ 
		Account acctObj = new Account();
		acctObj.Name = 'Test12';
		acctObj.RC_Brand__c = 'RingCentral';
		acctObj.Number_of_DL_s__c = 2;
		acctObj.RC_Service_name__c = null;
		acctObj.RC_User_ID__c = '1234';
		acctObj.RC_Account_Status__c = 'Trial';
		acctObj.Service_Type__c = null;
		acctObj.RC_Activation_Date__c =  null;
		insert acctObj;
       
		Contact contactObj = new Contact();
		contactObj.AccountId =  acctObj.id;
		contactObj.Email = 'fake@email.com';
		contactObj.LastName = 'TestLast';
		contactObj.Phone='9910106804';
		insert contactObj;
	   
		Opportunity  oppObj = new Opportunity ();
        oppObj.name ='test2';
        oppObj.AccountId= acctObj.id;
        oppObj.Sales_Model__c='direct';
        oppObj.Type='New Business';
        oppObj.StageName='Qualified';
        oppObj.CloseDate=System.today();
     	insert oppObj;
     		   
	   	Contract contarctObj = new Contract();
		contarctObj.AccountId = acctObj.Id;
		contarctObj.Status = 'Draft';
		contarctObj.Opportunity__c = oppObj.Id; 
		insert contarctObj;
	   
		setBypassFlagFalse();
		acctObj.RC_Brand__c = 'Telus';
		acctObj.Number_of_DL_s__c = 3;
		acctObj.RC_Service_name__c = 'RC Office';
		acctObj.RC_User_ID__c = '12345';
		acctObj.RC_Account_Status__c = 'Disabled';
		acctObj.Do_Not_Creation_Implementation__c = false;
		acctObj.Service_Type__c = 'Office';
		acctObj.RC_Activation_Date__c =  system.now();
		acctObj.Is_Demo_Account__c = false;
		acctObj.RC_Attribution_Channel__c = 'Sales Agents & Resellers';
		update acctObj;
	 } 
	 
	 static testMethod void testAccountDisabledRC(){ 
	   Account acctObj = new Account();
	   acctObj.Name = 'Test12';
	   acctObj.RC_Brand__c = 'RingCentral';
	   acctObj.Number_of_DL_s__c = 2;
	   acctObj.RC_Service_name__c = null;
	   acctObj.RC_User_ID__c = '1234';
       acctObj.RC_Account_Status__c = 'Trial';
       acctObj.Service_Type__c = null;
       acctObj.RC_Activation_Date__c =  null;
       insert acctObj;
       
       Contact contactObj = new Contact();
	   contactObj.AccountId =  acctObj.id;
	   contactObj.Email = 'fake@email.com';
	   contactObj.LastName = 'TestLast';
	   contactObj.Phone='9910106804';
	   insert contactObj;
	   
	   setBypassFlagFalse();
	   acctObj.RC_Brand__c = 'Telus';
	   acctObj.Number_of_DL_s__c = 3;
	   acctObj.RC_Service_name__c = 'RC Office';
	   acctObj.RC_User_ID__c = null;
       acctObj.RC_Account_Status__c = 'Disabled';
       acctObj.Do_Not_Creation_Implementation__c = false;
       acctObj.Service_Type__c = 'Office';
       acctObj.RC_Activation_Date__c =  system.now();
       acctObj.Is_Demo_Account__c = false;
       acctObj.RC_Attribution_Channel__c = 'Sales Agents & Resellers';
       update acctObj;
	 }
	 
	   static testMethod void updateRelatedContactAccount(){
           Test.startTest();   
           List<Account> accList = new List<Account>(); 
           Account acctObjj = new Account();
           acctObjj.Name = 'Test12';
           acctObjj.Number_of_DL_s__c = 2;
           acctObjj.RC_Service_name__c = 'office123';
           acctObjj.RC_Account_Status__c = 'Paid';
           accList.add(acctObjj);
           //insert acctObjj;
          
           Account acctObjj1 = new Account();
           acctObjj1.Name = 'Test122';
           acctObjj1.Number_of_DL_s__c = 3;
           acctObjj1.RC_Service_name__c = 'office1233';
           acctObjj1.RC_Account_Status__c = 'Canceled';
           accList.add(acctObjj1);
           //insert acctObjj1;
           
           TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT(); 
           TriggerHandler.BY_PASS_CONTACT_ON_UPDATE();
           insert accList;           
           TriggerHandler.BY_PASS_CONTACT_ON_UPDATE = false;
           TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT = false;
           
           List<Contact> conList = new List<Contact>();
           
           Contact contactObj = new Contact();
           contactObj.LastName= 'TEst1';
           contactObj.AccountId =  acctObjj.id;
           contactObj.isCustomer__c=True;
           contactObj.Contact_Status__c='Closed Won';
           contactObj.Contact_Funnel_Type__c='Customer';
           contactObj.People_Segment__c='Customer'; 
           conList.add(contactObj);
           //insert contactObj;
           
           Contact contactObjj1 = new Contact();
           contactObjj1.LastName= 'TEst2';         
           contactObjj1.AccountId =  acctObjj1.id;
           contactObjj1.isCustomer__c=False;
           contactObjj1.Contact_Status__c='Winback';
           contactObjj1.Contact_Funnel_Type__c='Former Customer';
           contactObjj1.People_Segment__c='Canceled';
           conList.add(contactObjj1);
           //insert contactObjj1;
           
           TriggerHandler.BY_PASS_CONTACT_ON_INSERT();
           TriggerHandler.BY_PASS_CONTACT_ON_UPDATE();
           insert conList;
           AccountTriggerHelper.updateRelatedContactAccount(accList);
           ContactTriggerHelper.updateContactOnAccount(conList);
           TriggerHandler.BY_PASS_CONTACT_ON_UPDATE = false;
           TriggerHandler.BY_PASS_CONTACT_ON_INSERT = false;
           
           test.stopTest(); 
      }
	  
}