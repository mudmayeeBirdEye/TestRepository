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
@isTest (SeeAllData=true)
private class PurchaseOrderExtTest {

    static testMethod void myUnitTest1() {
    	    		
 		Employee__c emp = new Employee__c();
        emp.First_Name__c = 'poEmp';
        emp.Last_Name__c = 'POname';
        emp.Email__c ='poclc@clc.com';
        emp.Location__c = 'Noida, India';
        emp.Department__c = 'IT';
        emp.Team__c = 'SE';
        emp.SPID__c = '1245444';
        insert emp;
    	
    	IT_Purchase_Order__c purchaseOrderTest = new IT_Purchase_Order__c();
    	purchaseOrderTest.Status__c = '1. New Request';
    	purchaseOrderTest.Category__c = 'Upgrade';
    	purchaseOrderTest.End_User__c = emp.id;
    	insert purchaseOrderTest;
    	
    	PageReference pageRef = Page.PurchaseDetailsEdit;    
      	pageRef.getParameters().put('clone', '1');
      	Test.setCurrentPageReference( pageRef );  
      	ApexPages.StandardController controller = new  ApexPages.StandardController ( purchaseOrderTest );
        PurchaseOrderExt poe = new PurchaseOrderExt( controller );
        poe.saveOrder();
    }
    
    static testMethod void myUnitTest2() {
    	    		
 		Employee__c emp = new Employee__c();
        emp.First_Name__c = 'poEmp1';
        emp.Last_Name__c = 'POname1';
        emp.Email__c ='poclc@clc1.com';
        emp.Location__c = 'Noida, India';
        emp.Department__c = 'IT';
        emp.Team__c = 'SE';
        emp.SPID__c = '12451444';
        insert emp;
    	
    	IT_Purchase_Order__c purchaseOrderTest = new IT_Purchase_Order__c();
    	purchaseOrderTest.Status__c = '1. New Request';
    	purchaseOrderTest.Category__c = 'Upgrade';
    	purchaseOrderTest.End_User__c = emp.id;
    	insert purchaseOrderTest;

    	PageReference pageRef = Page.PurchaseDetailsEdit;    
      	Test.setCurrentPageReference( pageRef );  
      	ApexPages.StandardController controller = new  ApexPages.StandardController ( purchaseOrderTest );
        PurchaseOrderExt poe = new PurchaseOrderExt( controller );
        poe.saveOrder();
    }
    
    
}