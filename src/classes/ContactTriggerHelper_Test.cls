/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class ContactTriggerHelper_Test {

    static testMethod void myUnitTest() {
    	List<Contact> lstContacts = new List<Contact>();
    	
    	Folder fd = [SELECT Id FROM Folder WHERE Name='LeadSourceMap' LIMIT 1];
        Blob blbObj = Blob.valueOf('NumberOfEmployees__c,#,50-100,#,50-249,#,#EOL#');
        Document doc = new Document(Name='No_Employee_Mapping', Body=blbObj ,folderId=fd.Id,isPublic=true,type='csv' );
        insert doc;
        
        List<Contact_Field_Map__c> lstContactFieldMap = new List<Contact_Field_Map__c>();
        lstContactFieldMap.add(new Contact_Field_Map__c(Name ='1', Api_Name__c = 'numberofemployees__c'));
        insert lstContactFieldMap;
    	
    	lstContacts.add(new Contact(FirstName = 'A', LastName = 'B', Email = 'ab@test.com', NumberOfEmployees__c = '2'));
    	lstContacts.add(new Contact(FirstName = 'C', LastName = 'D', Email = 'cd@test.com', NumberOfEmployees__c = '50-100'));
    	lstContacts.add(new Contact(FirstName = 'E', LastName = 'F', Email = 'ef@test.com', NumberOfEmployees__c = '500 - 1'));
    	insert lstContacts;    	
        // TO DO: implement unit test    
    }
    
      static testMethod void updateContactOnAccount(){
        	
           List<Account> accountListt = new List<Account>();       	
           Account acctObjj = new Account();
	       acctObjj.Name = 'Test12';
		   acctObjj.Number_of_DL_s__c = 2;
		   acctObjj.RC_Service_name__c = 'office123';
	       acctObjj.RC_Account_Status__c = 'Paid';
	       accountListt.add(acctObjj);
	       //insert acctObjj;
          
           Account acctObjj1 = new Account();
	       acctObjj1.Name = 'Test122';
		   acctObjj1.Number_of_DL_s__c = 3;
		   acctObjj1.RC_Service_name__c = 'office1233';
	       acctObjj1.RC_Account_Status__c = 'Canceled';
	       accountListt.add(acctObjj1);
	       insert accountListt;
	       
	       List<contact> lstconn = new list<contact>();
	       Contact contactObj = new Contact();
	       contactObj.LastName= 'TEst1';
	       contactObj.AccountId =  acctObjj.id;
	       contactObj.isCustomer__c=True;
	       contactObj.Contact_Status__c='Closed Won';
	       contactObj.Contact_Funnel_Type__c='Customer';
	       contactObj.People_Segment__c='Customer';
	       lstconn.add(contactObj);
	       //insert contactObj;
	       
	       Contact contactObjj1 = new Contact();
	       contactObjj1.LastName= 'TEst2';	       
	       contactObjj1.AccountId =  acctObjj1.id;
	       contactObjj1.isCustomer__c=False;
	       contactObjj1.Contact_Status__c='Winback';
	       contactObjj1.Contact_Funnel_Type__c='Former Customer';
	       contactObjj1.People_Segment__c='Canceled';
	       lstconn.add(contactObjj1);
	      // insert contactObjj1;
	       
	       ContactTriggerHelper.updateContactOnAccount(lstconn);
	       //List<Contact> contList = new List<Contact>(); 	       
	      /* contList = [select id,LastName,AccountId, isCustomer__c,Contact_Status__c ,RCService_ContactStatus__c,
	                                  People_Segment_c__c from Contact where Id =: acctObjj.Id];*/
	                              
	      // insert contList; 
          
      }
    
}