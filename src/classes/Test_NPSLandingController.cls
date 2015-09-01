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
private class Test_NPSLandingController {

    static testMethod void myUnitTest() {
        
        Account accObj = new Account(Name='Simplion', Partner_ID__c='Test12322'); // Service_Type__c = 'Fax'
        insert accObj; 
        Contact contactObj = new Contact(firstName='Virendra', lastname='Singh', marketingSuspend__c=false, accountid=accObj.id, email='virendra.singh@simplion.com', phone='9910106804');
        insert contactObj;
        
        ApexPages.StandardController objContrl = new ApexPages.StandardController(contactObj); 
        NPSLandingController nps = new NPSLandingController(objContrl);
        nps.initCheck();
        
        //accObj.RC_Brand__c ='AT&T';
        //update accObj;
        
        ApexPages.currentPage().getParameters().put('conId',contactObj.id);
        //apexpages.currentpage().getparameters().put('Survey','Fax');
        ApexPages.StandardController objContrl1 = new ApexPages.StandardController(contactObj); 
        NPSLandingController nps1 = new NPSLandingController(objContrl);
        nps1.initCheck();
    }
}