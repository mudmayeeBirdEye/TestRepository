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
private class TerritoryTool_Test {

    static testMethod void myUnitTest() {
    	
    	Territory_Data__c dataObj = new Territory_Data__c();
    	dataObj.name = 'TD-0004';
    	dataObj.Segment__c = 'Just me';
    	dataObj.OwnerId = Userinfo.getUserId();
    	dataObj.Alternate_Owner__c = Userinfo.getUserId();
    	dataObj.State_Province__c = 'California';
    	dataObj.Industry__c = 'Healthcare';
    	dataObj.Country__c = 'Canada';
    	dataObj.Postal_Begin__c = 'C';
    	dataObj.Postal_End__c = 'C';
    	insert dataObj;
    	
        Apexpages.currentPage().getParameters().put('territoryname',dataObj.name);
        Apexpages.currentPage().getParameters().put('state',dataObj.State_Province__c);
        Apexpages.currentPage().getParameters().put('ownername', Userinfo.getFirstName());
        Apexpages.currentPage().getParameters().put('alternateownername',Userinfo.getFirstName());
        Apexpages.currentPage().getParameters().put('country','Canada');
        Apexpages.currentPage().getParameters().put('industry',dataObj.Industry__c);
        Apexpages.currentPage().getParameters().put('postalbegin',dataObj.Postal_Begin__c);
        
        TerritorySearchController ctrObj = new TerritorySearchController();
        ctrObj.runSearch();
        
        TerritorySearchLookupPopupController popupCtrObj = new TerritorySearchLookupPopupController();
        popupCtrObj.query = Userinfo.getFirstName();
        popupCtrObj.runQuery();
        
        Apexpages.currentPage().getParameters().put('myParam',dataObj.Id);
        Apexpages.currentPage().getParameters().put('myParam2','');
        Apexpages.currentPage().getParameters().put('myParam3','to');
        popupCtrObj.updateTerritory();
        
        Apexpages.currentPage().getParameters().put('myParam',dataObj.Id+','+dataObj.Id);
        Apexpages.currentPage().getParameters().put('myParam2','');
        Apexpages.currentPage().getParameters().put('myParam3','to');
        popupCtrObj.updateTerritory();
        
        Apexpages.currentPage().getParameters().put('myParam',dataObj.Id);
        Apexpages.currentPage().getParameters().put('myParam2','');
        Apexpages.currentPage().getParameters().put('myParam3','ao');
        popupCtrObj.updateTerritory();
        
        Apexpages.currentPage().getParameters().put('myParam',dataObj.Id+','+dataObj.Id);
        Apexpages.currentPage().getParameters().put('myParam2','');
        Apexpages.currentPage().getParameters().put('myParam3','ao');
        popupCtrObj.updateTerritory();
    }
}