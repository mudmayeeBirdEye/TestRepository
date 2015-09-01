@isTest
private class TestVarLocatorController {
	
	public class MockTestVARLocator implements HttpCalloutMock {
      public HTTPResponse respond(HTTPRequest req) {
	        HttpResponse res = new HttpResponse();
	        res.setHeader('Content-Type', 'application/json');
	        res.setBody('{"postalCodes":[{"distance":"0","adminCode1":"MB","postalCode":"R3T","countryCode":"CA","lng":-97.15309756405091,"placeName":"Winnipeg (Fort Garry NE / University of Manitoba)","lat":49.81427639319218,"adminName1":"Manitoba"},{"distance":"3.94044","adminCode1":"MB","postalCode":"R2M","countryCode":"CA","lng":-97.11472926019883,"placeName":"Winnipeg (St. Vital North)","lat":49.83963957509273,"adminName1":"Manitoba"},{"distance":"5.248","adminCode1":"MB","postalCode":"R2N","countryCode":"CA","lng":-97.09726224297253,"placeName":"Winnipeg (St. Vital SW)","lat":49.78379962709415,"adminName1":"Manitoba"},{"distance":"5.26844","adminCode1":"MB","postalCode":"R3Y","countryCode":"CA","lng":-97.21470720034621,"placeName":"Winnipeg (Fort Garry West)","lat":49.788511553830475,"adminName1":"Manitoba"},{"distance":"5.44807","adminCode1":"MB","postalCode":"R3M","countryCode":"CA","lng":-97.16651871851269,"placeName":"Winnipeg (River Heights Central)","lat":49.86250383540526,"adminName1":"Manitoba"}]}');
	        res.setStatusCode(200);
	        res.setStatus('Ok');
	        return res;
	    }
	}
	
    static testMethod void testVarLocator(){
        Account acc = new Account(name = 'hotel plaza',BillingCity='noida',BillingPostalCode='122001',
        							Var_Locator__c=true,recordTypeId=OpportunityHelper.getOppRecordTypeMap('Partner Account'),
        							BillingCountry='india',Website='www.parkplaza.com',Account_Owner_Phone_Number__c='7838310237',
        							Contact_Email__c='parkplaza@plaza.com');
        insert acc;
        
        Account acc1 = new Account(name = 'hotel plaza',BillingCity='noida',BillingPostalCode='R3T',
        							Var_Locator__c=true,recordTypeId=OpportunityHelper.getOppRecordTypeMap('Partner Account'),
        							BillingCountry='USA',Website='www.parkplaza.com',Account_Owner_Phone_Number__c='7838310237',
        							Contact_Email__c='parkplaza@plaza.com');
        insert acc1;
        
        Account acc2 = new Account(name = 'hotel plaza',BillingCity='noida',BillingPostalCode='R3T',
        							Var_Locator__c=true,recordTypeId=OpportunityHelper.getOppRecordTypeMap('Partner Account'),
        							BillingCountry='UK',Website='www.parkplaza.com',Account_Owner_Phone_Number__c='7838310237',
        							Contact_Email__c='parkplaza@plaza.com');
        insert acc2;
        
        Account acc3 = new Account(name = 'hotel plaza',BillingCity='noida',BillingPostalCode='R3T',
        							Var_Locator__c=true,recordTypeId=OpportunityHelper.getOppRecordTypeMap('Partner Account'),
        							BillingCountry='Canada',Website='www.parkplaza.com',Account_Owner_Phone_Number__c='7838310237',
        							Contact_Email__c='parkplaza@plaza.com');
        insert acc3;
        
        VarLocatorController myct = new VarLocatorController();
        Test.startTest();  
        myct.newSearchForParners();
        myct.pin= '122001';
        myct.searchPartners() ;
        myct.callClearMapValues();
        myct.listOfAddresses.clear(); 
        myct.listOfAddresses.size() ;
        myct.getTravelItems();
        myct.getCountryItems();
        Test.setMock(HttpCalloutMock.class, new MockTestVARLocator());
        myct.pin = '';
        myct.getZipCodesInRadius();
        myct.pin = '122001';
        myct.getZipCodesInRadius();
        myct.selectedCountry = 'UK';
        myct.pin = '122001';
        myct.getZipCodesInRadius();
        myct.selectedCountry = 'CA';
        myct.pin = '122001';
        myct.getZipCodesInRadius();
        VarLocatorController.WRJsonOutPutMiles obj1 = new VarLocatorController.WRJsonOutPutMiles();
        VarLocatorController.WRZips obj2 = new VarLocatorController.WRZips();
        VarLocatorController.WRRows obj3 = new VarLocatorController.WRRows();
        VarLocatorController.WRElement obj4 = new VarLocatorController.WRElement();
     	VarLocatorController.WRVAalues obj5 = new VarLocatorController.WRVAalues();
      	VarLocatorController.WRNeighborZips obj6 = new VarLocatorController.WRNeighborZips();
      	VarLocatorController.WRMessage obj7 = new VarLocatorController.WRMessage();
        Test.stopTest();   
    }
}