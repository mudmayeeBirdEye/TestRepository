/* Test Class for Account Plan Trigger*/

@isTest

private class TestTriggers {
    static testMethod void myUnitTest() {
    	try {
		    Account_Plan__c accountPlan = new Account_Plan__c();
		    Account acc = new Account();
		   	accountPlan.Name = acc.Id;
	     
	    	upsert accountPlan; 
    	} catch(Exception e) {}
    }
 }