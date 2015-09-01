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
private class Test_MarketoControllerNew {

    static testMethod void myUnitTest() {
    	Lead leadObj = new Lead();
       	leadObj.LeadSource = 'About To be Cancelled'; 
        leadObj.ATBC_Stage__c = 'WIP';
        leadObj.IsConverted = false;
        leadObj.User_ID__c = UserInfo.getUserId();
        leadObj.FirstName='Virendra';
        leadObj.LastName='Singh';
        leadObj.Company='Simplion';
        leadObj.Email='vps@sss.ss221.com';
        leadObj.Phone='9910106804';
        insert leadObj;
        
        Account accObj = new Account(Name='Simplion', Partner_ID__c='Test12322');
        insert accObj;
        
        Contact contactObj = new Contact(firstName='Virendra', lastname='Singh', marketingSuspend__c=false, accountid=accObj.id, email='virendra.singh@simplion.com', phone='9910106804');
        insert contactObj;
        
       
        apexpages.currentPage().getParameters().put('sfdcId',leadobj.id);
        apexpages.currentPage().getParameters().put('email','vps@sss.ss221.com');              
        
        MarketoControllerNew objMarketo=new MarketoControllerNew();
       	MarketoLeadActivityTypeFilter objMlatf =new MarketoLeadActivityTypeFilter();
       	MarketoLeadActivityTypeFilter.getAllAvailableActivityFilter();
       	MarketoLeadActivityTypeFilter.getDefaultActivityFilter();
       	MarketoLeadActivityTypeFilter.getDefaultSelectedActivityFilter();       	
        objMarketo.objMultiRows.add(objMlatf);
         apexpages.currentPage().getParameters().put('contactId',contactObj.id);
         
       // objMarketo.MoveRight(); 
        //objMarketo.showLeadActivityWithFilter();
       // objMarketo.MoveLeft();
    }
    
    static testMethod void myUnitTest1() {
    	Lead leadObj = new Lead();
       	leadObj.LeadSource = 'About To be Cancelled'; 
        leadObj.ATBC_Stage__c = 'WIP';
        leadObj.IsConverted = false;
        leadObj.User_ID__c = UserInfo.getUserId();
        leadObj.FirstName='Virendra';
        leadObj.LastName='Singh';
        leadObj.Company='Simplion';
        leadObj.Email='vps@sss.ss221.com';
        leadObj.Phone='9910106804';
        insert leadObj;
        
        Account accObj = new Account(Name='Simplion', Partner_ID__c='Test12322');
        insert accObj;
        
        Contact contactObj = new Contact(firstName='Virendra', lastname='Singh', marketingSuspend__c=false, accountid=accObj.id, email='virendra.singh@simplion.com', phone='9910106804');
        insert contactObj;
        
       
        apexpages.currentPage().getParameters().put('contactId',contactObj.id);
        apexpages.currentPage().getParameters().put('email','vps@sss.ss221.com');              
        
        MarketoControllerNew objMarketo=new MarketoControllerNew();
       	MarketoLeadActivityTypeFilter objMlatf =new MarketoLeadActivityTypeFilter();
       	MarketoLeadActivityTypeFilter.getAllAvailableActivityFilter();
       	MarketoLeadActivityTypeFilter.getDefaultActivityFilter();
       	MarketoLeadActivityTypeFilter.getDefaultSelectedActivityFilter();       	
        objMarketo.objMultiRows.add(objMlatf);
         
         
       // objMarketo.MoveRight(); 
        //objMarketo.showLeadActivityWithFilter();
       // objMarketo.MoveLeft();
    }
}