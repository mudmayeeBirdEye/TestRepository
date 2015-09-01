@isTest
private class HelperUtils_Test {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        
        List<Account> accLst = new List<Account>();
        accLst.add(new Account(Name = 'Account 1', Account_Mobile_Number__c = '09013038181'));
        insert accLst;
        Carrier_Data__c crrObj = new Carrier_Data__c(Carrier_Wireless_Phone_Number__c = '09013038181');
        insert crrObj;
        
        HelperUtils.updateCarrierDataRecordNew(accLst);
        
    }
}