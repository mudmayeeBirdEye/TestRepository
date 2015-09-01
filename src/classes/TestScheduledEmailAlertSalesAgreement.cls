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
private class TestScheduledEmailAlertSalesAgreement {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        
      	TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT = true;
		TriggerHandler.BY_PASS_OPPORTUNITY_ON_INSERT = true;
     	Account acc = new Account();
     	acc.Name = 'Test Acc';
     	insert acc;
      
	    Opportunity opp = new Opportunity();
	    opp.name ='test';
	    opp.StageName ='test';
	    opp.CloseDate = system.today()+16;
	    opp.AccountId = acc.id;
	    insert opp;
      
  	    Quote q1 = new Quote();
       //q.OpportunityId =[SELECT id FROM Opportunity LIMIT 1].id;
       q1.name='test';
  		q1.OpportunityId =opp.id;
      	q1.End_Date__c = system.today()-1;
      	q1.Status = 'Active';
      	q1.Start_Date__c = system.today()-25;
      	q1.Auto_Renewal__c=true;
  		q1.Term_months__c='12';
      	insert q1;
      	
      	Employee__c emp1 = new Employee__c();
        emp1.First_Name__c = 'tuser1';
        emp1.Last_Name__c = 'lname1';
        emp1.Email__c ='clc@clc1.com';
        emp1.Location__c = 'Noida, India';
        emp1.Department__c = 'IT';
        emp1.Team__c = 'SE';
        emp1.SPID__c = '124541';
        emp1.User__c = userinfo.getUserId();
        //emp1.Manager_Employee_Number__c = '123';
        insert emp1;
      	
      	Employee__c emp = new Employee__c();
        emp.First_Name__c = 'tuser';
        emp.Last_Name__c = 'lname';
        emp.Email__c ='clc@clc.com';
        emp.Location__c = 'Noida, India';
        emp.Department__c = 'IT';
        emp.Team__c = 'SE';
        emp.SPID__c = '12454';
        emp.User__c = userinfo.getUserId();
        emp.Manager_Employee_Number__c = emp1.id;
        insert emp;
       
     
       Test.startTest(); 
      
       Account acc1 = new Account();
       acc1.RC_User_ID__c = '100';
       acc1.Name = 'Test acc1';
       insert acc1;
      
    	
      	
      	TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT = false;
		TriggerHandler.BY_PASS_OPPORTUNITY_ON_INSERT = false;
    
        Scheduled_Email_Alert_Sales_Agreement sh = new  Scheduled_Email_Alert_Sales_Agreement();
      	sh.execute(null);
      	
 		 Test.stopTest();
     
    // ID mid = '5008000000G3laL';
     
    // sh.getManagerEmail(mid);               
    }
    
     static testMethod void myUnitTest1() {
        // TO DO: implement unit test
        
      	TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT = true;
		TriggerHandler.BY_PASS_OPPORTUNITY_ON_INSERT = true;
     	Account acc = new Account();
     	acc.Name = 'Test Acc';
     	insert acc;
      
	    Opportunity opp = new Opportunity();
	    opp.name ='test';
	    opp.StageName ='test';
	    opp.CloseDate = system.today()+16;
	    opp.AccountId = acc.id;
	    insert opp;
      
  	    Quote q1 = new Quote();
       //q.OpportunityId =[SELECT id FROM Opportunity LIMIT 1].id;
       q1.name='test';
  		q1.OpportunityId =opp.id;
      	q1.End_Date__c = system.today()-1;
      	q1.Status = 'Active';
      	q1.Start_Date__c = system.today()-25;
      	q1.Auto_Renewal__c=false;
  		q1.Term_months__c='12';
      	insert q1;
     
       Test.startTest(); 
      
       Account acc1 = new Account();
       acc1.RC_User_ID__c = '100';
       acc1.Name = 'Test acc1';
       insert acc1;
      
    	
      	
      	TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT = false;
		TriggerHandler.BY_PASS_OPPORTUNITY_ON_INSERT = false;
    
        Scheduled_Email_Alert_Sales_Agreement sh = new  Scheduled_Email_Alert_Sales_Agreement();
      	sh.execute(null);
      	
 		 Test.stopTest();
     
    // ID mid = '5008000000G3laL';
     
    // sh.getManagerEmail(mid);
    
               
  
    }
}