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
private class EmployeeAssetTest {

    static testMethod void employeeAssetsBeforeTest() {
       /*
       Select e.Team__c,
        e.SPID__c, e.Location__c, e.Last_Name__c, 
        e.First_Name__c, e.Email__c, e.Division__c, 
        e.Department__c From Employee__c e
       */
       
       Employee__c emp = new Employee__c();
       emp.First_Name__c = 'tuser';
       emp.Last_Name__c = 'lname';
       emp.Email__c ='test@test.com';
       emp.Location__c = 'Noida, India';
       emp.Department__c = 'IT';
       emp.Team__c = 'SE';
       emp.SPID__c = '12454';
       
       insert emp;
       
        Asset__c asst = new Asset__c();
        asst.Asset_Type__c = 'Hardware';
        asst.Sub_Asset_Type__c = 'Computer';
        asst.Manufacturer__c = 'Other';
        asst.Manufacturer_Other__c ='IBM';
        asst.Model__c ='Other';
        asst.Model_Other__c = 'IBM420';
        asst.Location__c ='Home Office';
        asst.Status__c = 'Deployed';
        
        insert asst;
        
        EmployeeAssetJunction__c ea = new EmployeeAssetJunction__c();
        ea.Asset__c = asst.Id;
        ea.Employee_Number__c = emp.Id;
        
        insert ea;
        
         
       
    }
}