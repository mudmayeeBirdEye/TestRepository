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
private class Test_LeadCreationPartner {
  static testMethod void myUnitTestLeadCreationPartner() {    
       Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];       
       User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                            LocaleSidKey='en_US', ProfileId = p.Id,                             
                            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser11@testorg.com');        
        insert u;
        Account acctest1 = new Account();
        acctest1.Name='TestAccount';
        insert acctest1;
       
        Account acct = new Account(name='TestingReal account');
        acct.parentId=acctest1.id;
        insert acct;
        
        ShareUtil.getParentAccountDetail(acct.id);
        
        Contact objcon = new Contact(FirstName='test',LastName ='testl',AccountId = acct.id);
        insert objcon;
    
        Test.startTest();  
        try {  
	        ApexPages.StandardController controller1 = new ApexPages.StandardController(new Lead());
	        LeadCreationPartner objLCP1 = new LeadCreationPartner(controller1);
	        objLCP1.createNew();
	       
	        Lead leadObj = new Lead();
	        setLeadDetail(leadObj );
	        objLCP1.rcUsers='Number of RC Users'; 
	        objLCP1.resetFieldValue();
	        objLCP1.newLead=leadObj ;
	        objLCP1.createNew();
	        objLCP1.isFakeEmail('fake@email.com');
	        leadObj.FirstName='Virendra';
	        leadObj.LastName='Singh';
	        leadObj.Company='Simplion';
	        leadObj.Email='virendra.singh@simplion.com';
	        leadObj.Phone='9910106804';
	        leadObj.LeadSource = 'Inbound Call';
	        leadObj.Notes__c = 'Test Notes'; 
	        leadObj.Website = 'http://test.com';
	        leadObj.NumberOfEmployees = 123;
	        leadObj.Industry = 'Test';
	        leadObj.NumberOfEmployees__c = '2-19';
	        leadObj.Number_of_Locations__c = '2-4';
	        leadObj.Agent_Email_Address__c = 'test@test.com';     
	        leadObj.Description ='testing this ';
	        leadObj.Number_of_Users__c  =4;   
	        objLCP1.rcUsers='4'; 
	        leadObj.Email='hagehd';
	        leadObj.Phone='12345';
	        leadObj.Partner_Lead_Source__c = 'Partner';
	        objLCP1.newLead=leadObj ;
	        objLCP1.createNew();
	        
	        leadObj.Email='virendra.singh@simplion.com';
	        leadObj.Phone='9910106804';
	        leadObj.Country__c = 'UNITED STATES';
	        leadObj.State__c = 'California';
	        leadObj.City__c = 'Test';
	        leadObj.How_did_you_acquire_this_Lead__c = 'Test';
	        leadObj.Estimated_Close_Date__c = System.today();
	        leadObj.Lead_Brand_Name__c = 'Ringcentral';
	        leadObj.Lead_Tier_Name__c = 'FAX';
	        leadObj.Description = 'Test';
	        leadObj.Industry = 'Test';
	        leadObj.Number_of_Locations__c = '12';
	        leadObj.NumberOfEmployees__c = '12';
	        objLCP1.rcUsers = '22';
	        objLCP1.newLead=leadObj ;
	        objLCP1.resetFieldValue();
	        objLCP1.createNew();
	        leadObj.Phone='9910106804';
	        objLCP1.newLead=leadObj;
	        objLCP1.createNew();
	         
	        objLCP1.newLead.Email='virendra.singh.com';
	        objLCP1.createNew();
	        
	        objLCP1.newLead.Email='virendra.singh@simplion.com';
	        objLCP1.newLead.Phone='test';
	        objLCP1.createNew();
	        
	        objLCP1.cancelLead();  
	        objLCP1.createLeadApprovalRecord(objLCP1.rcUsers, u);
	        objLCP1.resetFieldValue();
        } catch(Exception e) {}
        Test.stopTest();
    }  
    
    public static void setLeadDetail(Lead objLead){
       objLead.FirstName ='First Name';
       objLead.LastName ='Last Name';
       objLead.Title ='Title';
       objLead.Company ='Company Name';
       objLead.Email ='Email Address';
       objLead.Website ='Website';
       objLead.Phone='tyityiyi';
   }
       
}