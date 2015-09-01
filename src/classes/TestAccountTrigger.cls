@isTest

    public with sharing class TestAccountTrigger {    
        static Map<String, sObject> userMap = new  Map<String, sObject>();
		static List<Account> partnerAccountsList = new List<Account>();
		static List<Account> customerAccountsList = new List<Account>();       
		static List<Account> updatableAccounts = new List<Account>();
		static RCSF_Sync__c customSetUp;
		static AccountHierarchyCustomSetting__c customSettingData;
		static List<User> userList = new List<User>();
		static Id partnerAccRecordTypeId;
		static Id customerAccRecordTypeId;
		
		static{
			customSetUp = new RCSF_Sync__c(Name= 'RCSF Sync', Username__c = 'rcsfsync@ringcentral.com', 
          								Email__c = 'rcsfsync@ringcentral.com', Active__c = true, First_Name__c = 'RCSF', Last_Name__c = 'Sync');
          	insert customSetUp;
          	customSettingData = new AccountHierarchyCustomSetting__c(Name = 'AccountHierarchyInstance', HierarchyCalculationEnabled__c= true);
          	insert customSettingData;
          	
          	userList.add(new User(alias = 'Alias12', email='123testSales@testorg.com',emailencodingkey='UTF-8', lastname='testsalesUser123', 
                                     ProfileId = [SELECT Id FROM Profile LIMIT 1].Id, Phone= '2323232323',
                                     languagelocalekey='en_US',localesidkey='en_US', country='United States',
                                     timezonesidkey='America/Los_Angeles', username=getUserNamePrefix() + '123testSales@testorg.com', IsActive=true)); 
                                     
            userList.add(new User(alias = 'Alias123', email='456testUser@testorg.com',emailencodingkey='UTF-8', lastname='testUser123', 
                                     ProfileId = [SELECT Id FROM Profile LIMIT 1].Id, Phone= '4564564561',
                                     languagelocalekey='en_US',localesidkey='en_US', country='United States',
                                     timezonesidkey='America/Los_Angeles', username= getUserNamePrefix() + '456testUser@testorg.com', IsActive=true));   
            userList.add(new User(alias = 'Alias111', email='567testUser@testorg.com',emailencodingkey='UTF-8', lastname='testGeneralUser123', 
                                     ProfileId = [SELECT Id FROM Profile LIMIT 1].Id, Phone= '7827827821',
                                     languagelocalekey='en_US',localesidkey='en_US', country='United States',
                                     timezonesidkey='America/Los_Angeles', username= getUserNamePrefix() + '567testUser@testorg.com', IsActive=true));
            userList.add(new User(alias = 'Alias777', email='678testUser@testorg.com',emailencodingkey='UTF-8', lastname='testGeneralUser1', 
                                     ProfileId = [SELECT Id FROM Profile LIMIT 1].Id, Phone= '1001001001',
                                     languagelocalekey='en_US',localesidkey='en_US', country='United States',
                                     timezonesidkey='America/Los_Angeles', username= getUserNamePrefix() + '678testUser@testorg.com', IsActive=true));                                     
                                                 
            insert userList;
            
            userMap.put('Sales User', userList.get(0));
            userMap.put('Non-Sales User', userList.get(1));
            userMap.put('General User', userList.get(2));          
            userMap.put('General User 1', userList.get(3));
            partnerAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner Account').getRecordTypeId();
            customerAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer Account').getRecordTypeId();
            createPartnerAccounts();
            createCustomerAccounts();
            conditionsSetAccountValuesInsert();
          	conditionsSetEligibalForReferealCreditInsert(); 
          	conditionsChkToCreateLeadForOfficeTrailsInsert(); 
		}
        
        
        static testMethod void testAccountTrigger_Insert() {        	
          	resetTriggerByPass();              
      		partnerAccountsList[0].RC_Account_Status__C = 'Trial 7 CC';  
	      	partnerAccountsList[5].ParentId = partnerAccountsList[3].id;               
	      	insert partnerAccountsList;   
	      	resetTriggerByPass();
	      	insert customerAccountsList; 
	      	resetTriggerByPass();
	      	createCustomerHierarchy();
        }     
        
        
        static testMethod void testAccountTrigger_Update() {
	       	  createPartnerAccounts();
	       	  createCustomerAccounts();
	       	  resetTriggerByPass();
	          insert partnerAccountsList;              
	          resetTriggerByPass();
	          insert customerAccountsList; 
	          createEntitlement();
	          createContact();
	          resetTriggerByPass();       
	          conditionssetAccountValuesOnUpdateSingle();
	          conditionsupdateEligibalForReferealCreditUpdate();
	          update updatableAccounts;                
      }   
      
      /*static testMethod void testAccountTrigger_delete() {
      		resetTriggerByPass(); 
      		delete partnerAccountsList;
      		resetTriggerByPass();
      		delete customerAccountsList;
      }*/
      
      public static void resetTriggerByPass(){
      		AccountTriggerStaticProperties.BY_PASS_ACCOUNT_BEFORE = false;
            AccountTriggerStaticProperties.BY_PASS_ACCOUNT_AFTER = false; 
      }
      
       public static void createEntitlement(){
       		 Entitlement entitlement = new Entitlement();
			 entitlement.AccountId = partnerAccountsList[0].id;
			 entitlement.StartDate = System.today();
			 entitlement.EndDate = null;
			 entitlement.name = 'Test Entitlement';
			 insert entitlement;
       }
       
        public static void createContact(){
       		 Contact con = new Contact();
       		 con.Description = 'Contact Descritption';
	         con.Email = 'contact@cot.com';
	         con.Contact_Status__c = 'New';
	         con.FirstName = 'Contact FirstName';
	         con.LastName = 'Contact LastName';	         
	         con.MailingCity = 'Contact city';
	         con.MailingCountry = 'Contact country';
	         con.MailingPostalCode = '111111';
	         con.MailingState = 'Contact state' ;
	         con.MailingStreet = 'Contact street';
	         con.Street_2__c = 'Contact street 2';	        
	         con.Phone = '9679671234'; 
	         con.Title = 'Ms';
	         con.Account = partnerAccountsList[0];
	         insert con;	        
       }     
      
 
        public static String getUserNamePrefix(){
        	return UserInfo.getOrganizationId() + System.now().millisecond();
        }
        
        static void createPartnerAccounts(){ 
            for (Integer i = 0 ; i < 10 ; i++ ){
            	Account partnerAccObj = new Account();
                partnerAccObj.Name = 'TestAccount'+i;
                partnerAccObj.Number_of_DL_s__c = i+5;          
                partnerAccObj.RecordTypeId = partnerAccRecordTypeId ;
                partnerAccObj.Type ='PARTNER';
                partnerAccObj.Current_Owner__c = userMap.get('Non-Sales User').id;
                partnerAccObj.Website ='testURL';
                partnerAccObj.Partner_ID__c =i+''+i+''+i+''+i;
                partnerAccObj.Premium_Support_Agent__c = userMap.get('General User').id;
                partnerAccObj.RC_Account_Status__c = 'office';
                partnerAccObj.OwnerId = userMap.get('Sales User').id;
                partnerAccObj.Phone = '985632147'+i;
                partnerAccObj.Account_Owner_Phone_Number__c = '5555555555';
                partnerAccObj.BillingCountry = 'testCountry';   
                partnerAccObj.RC_Brand__c = 'RingCentral';
                partnerAccountsList.add (partnerAccObj);   
                             
            }     
        }
        
        static void createCustomerAccounts(){       
            for (Integer i = 0 ; i < 10 ; i++ ){    
            	Account customerAccObj = new Account();
                customerAccObj.Name = 'TestCustomerAccount'+i;
                customerAccObj.Number_of_DL_s__c = i+5;      
                customerAccObj.Pay_Referral_Commissions__c  = false; 
                 customerAccObj.Type ='CUSTOMER';            
                customerAccObj.Partner_ID__c =partnerAccountsList[i].Partner_ID__c;
                customerAccObj.Premium_Support_Agent__c = userMap.get('Non-Sales User').id;
                customerAccObj.RC_Account_Status__c = 'Trial 7 CC';
                customerAccObj.OwnerId = userMap.get('Non-Sales User').id;
                customerAccObj.Phone = '985632147'+i;
                customerAccObj.BillingCountry = 'testCountry';
                customerAccObj.RC_Brand__c = 'RingCentral';
                customerAccountsList.add(customerAccObj);               
            }
        }
        
        
      
        static void createCustomerHierarchy() {
        		resetTriggerByPass();
                Account partnerAccObj = new Account();
                partnerAccObj.Name = 'Top Account in hierarchy';                            
                partnerAccObj.RecordTypeId = partnerAccRecordTypeId ;
                partnerAccObj.Type ='PARTNER';
                partnerAccObj.Partner_ID__c ='123456';
                partnerAccObj.Premium_Support_Agent__c = userMap.get('Non-Sales User').id;
                partnerAccObj.RC_Account_Status__c = 'office';
                partnerAccObj.OwnerId = userMap.get('Non-Sales User').id;
                partnerAccObj.Phone = '11111111';
                partnerAccObj.BillingCountry = 'testCountry';
                partnerAccObj.Partner_Customer_Count__c = 3;
                partnerAccObj.Partner_Sign_Up_Date__c = date.parse('04/22/2015');
                insert partnerAccObj;
                resetTriggerByPass();
                
                Account customerAccObj0 = new Account();
                customerAccObj0.Name = 'Customer Hierarchy account 1';
                customerAccObj0.Number_of_DL_s__c = 5;          
                customerAccObj0.Type ='CUSTOMER';           
                customerAccObj0.Partner_ID__c ='123456';
                customerAccObj0.Premium_Support_Agent__c = userMap.get('Non-Sales User').id;
                customerAccObj0.OwnerId = userMap.get('Non-Sales User').id;
                customerAccObj0.Phone = '22222222';
                customerAccObj0.BillingCountry = 'testCountry';
                customerAccObj0.RC_Account_Status__c = 'Trial';
                customerAccObj0.Pay_Referral_Commissions__c = true;
                customerAccObj0.RC_Signup_Date__c = date.parse('05/10/2015'); 
                customerAccObj0.RC_Brand__c = 'RingCentral';    
                customerAccObj0.RC_Service_Name__c = 'Office';
                customerAccObj0.Number_of_DL_s__c = 2;
                customerAccObj0.Do_Not_Creation_Implementation__c = false;
                customerAccObj0.RC_User_Id__c = 'abcd';
                insert customerAccObj0;
                resetTriggerByPass();
                
                Account customerAccObj1 = new Account();
                customerAccObj1.Name = 'Customer Hierarchy account 2';
                customerAccObj1.Number_of_DL_s__c = 5;          
                customerAccObj1.Type ='CUSTOMER';           
                customerAccObj1.Partner_ID__c ='123456';
                customerAccObj1.Premium_Support_Agent__c = userMap.get('Non-Sales User').id;
                customerAccObj1.RC_Account_Status__c = 'office';
                customerAccObj1.OwnerId = userMap.get('Non-Sales User').id;
                customerAccObj1.Phone = '22222222';
                customerAccObj1.BillingCountry = 'testCountry';
                customerAccObj1.ParentId = customerAccObj0.id;
                customerAccObj1.RC_Signup_Date__c = date.parse('05/12/2015'); 
                customerAccObj1.RC_Account_Status__c = 'Paid';
                customerAccObj1.Pay_Referral_Commissions__c = true;
                insert customerAccObj1;
                resetTriggerByPass();
                
                Account customerAccObj2 = new Account();
                customerAccObj2.Name = 'Customer Hierarchy account 3';
                customerAccObj2.Number_of_DL_s__c = 5;    
                customerAccObj2.RC_Signup_Date__c = date.parse('05/14/2015');       
                customerAccObj2.Type ='CUSTOMER';           
                customerAccObj2.Partner_ID__c ='123456';
                customerAccObj2.Premium_Support_Agent__c = userMap.get('Non-Sales User').id;
                customerAccObj2.OwnerId = userMap.get('Non-Sales User').id;
                customerAccObj2.Phone = '22222222';
                customerAccObj2.BillingCountry = 'testCountry';
                customerAccObj2.ParentId = customerAccObj1.id;
                customerAccObj2.RC_Service_name__c = 'FAX';
                customerAccObj2.RC_Account_Status__c = 'TEST';
                customerAccObj2.Pay_Referral_Commissions__c = true;
                insert customerAccObj2;
        }
        
       static void conditionsSetAccountValuesInsert(){
       		partnerAccountsList[0].Premium_Support_Agent__c = userMap.get('Non-Sales User').id;
       }
        
       static void conditionsSetEligibalForReferealCreditInsert(){
              customerAccountsList[2].Pay_Referral_Commissions__c = true;   
              customerAccountsList[2].RC_Account_Status__c = 'Paid';    
        
      } 
      
      static void conditionsChkToCreateLeadForOfficeTrailsInsert(){
      	      customerAccountsList[4].Service_Type__c = 'Office';
      	      customerAccountsList[4].RC_Account_Status__c = 'Trial 30 CC';
      	      customerAccountsList[4].No_of_Employees__c = '2-9';
      }
      
      static void conditionscreateImplementationOnAccountInsert(){
              customerAccountsList[0].RC_Brand__c = 'RingCentral';
      }
      
 static void conditionssetAccountValuesOnUpdateSingle(){      	
      	
      	    System.debug('partnerAccountsList[0].id '+partnerAccountsList[0].id);
      	    System.debug('partnerAccountsList[1].id '+partnerAccountsList[1].id);
      	    Account partnerAccount = [Select Id,ownerId, Name,website,Current_Owner__c,RC_Account_Number__c, Service_Type__c, Account_Owner_Phone_Number__c, Phone, RC_Account_Status__C, Premium_Support_Agent__c
                                              from Account where id = :partnerAccountsList[0].id limit 1];
            System.debug(' all value partnerAccount '+partnerAccount);                                  
    		partnerAccount.ownerId = userMap.get('General User').Id;
            partnerAccount.website = 'www.testSite.com';
            partnerAccount.Current_Owner__c = null;
            partnerAccount.Service_Type__C = 'Office';
            partnerAccount.RC_Account_Number__c='11111111111';  
            partnerAccount.RC_Account_Status__C = 'Disabled';        
            partnerAccount.Account_Owner_Phone_Number__c = '1515151515';          
            partnerAccount.Phone = '6666666666';             
            
            Account partnerAccount1 = [Select Id,Name,website,Current_Owner__c,RC_Account_Number__c, Service_Type__c
                                              from Account where id = :partnerAccountsList[1].id limit 1];
            System.debug ('userMap.get(General User).Id'+userMap.get('General User').Id);
            partnerAccount1.Current_Owner__c = userMap.get('General User').Id;
            partnerAccount1.Service_Type__C = 'FAX';
            partnerAccount1.Phone = '6666666666'; 
            
            
            Account customerAccount = [Select Id,Name,website,Current_Owner__c,RC_Account_Number__c, Service_Type__c
                                              from Account where id = :customerAccountsList[0].id limit 1];
            System.debug ('userMap.get(General User).Id'+userMap.get('General User').Id);
            customerAccount.Current_Owner__c = userMap.get('General User').Id;
            customerAccount.Service_Type__C = 'FAX';
            customerAccount.Phone = '7777777777';
            customerAccount.Partner_ID__c='3333';
            customerAccount.ParentId = partnerAccount1.Id;
            //List<Account> updatableAccounts = new List<Account>();
            updatableAccounts.add(partnerAccount);
            updatableAccounts.add(partnerAccount1);
            updatableAccounts.add(customerAccount);
           // update updatableAccounts;
            //AccountTriggerStaticProperties.BY_PASS_ACCOUNT_BEFORE = false;
            //AccountTriggerStaticProperties.BY_PASS_ACCOUNT_AFTER = false;        
            System.debug ('Updating customer acc');
      	    //update customerAccount;
      	    AccountTriggerStaticProperties.BY_PASS_ACCOUNT_BEFORE = false;
            AccountTriggerStaticProperties.BY_PASS_ACCOUNT_AFTER = false;        
      	    //dne ck why last condition is still red
      }
      
    
     static void conditionsupdateEligibalForReferealCreditUpdate(){   	    
 
    		Account customerAccount1 = [Select Id,Name,website,Current_Owner__c,RC_Account_Number__c, Service_Type__c, Pay_Referral_Commissions__c
                                              from Account where id = :customerAccountsList[1].id limit 1];
            System.debug ('userMap.get(General User).Id'+userMap.get('General User').Id);
            customerAccount1.Current_Owner__c = userMap.get('General User').Id;
            customerAccount1.Service_Type__C = 'FAX';
            customerAccount1.RC_Account_Status__c = 'Paid';
            customerAccount1.Phone = '7777777777';
            customerAccount1.Partner_ID__c='2222';
            customerAccount1.Pay_Referral_Commissions__c  = true;
            //update customerAccount;
            updatableAccounts.add(customerAccount1);            
      }   


    }