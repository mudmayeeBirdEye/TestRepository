/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 */
@isTest
private class Test_CarrierDataHelper {

    static testMethod void myUnitTest() {
       Account Acc1 = new Account(Name ='TestAccount 1',Account_Mobile_Number__c ='2552552551');
       Account Acc2 = new Account(Name ='TestAccount 2',Account_Mobile_Number__c ='2512552551');
       Account Acc3 = new Account(Name ='TestAccount 3',Account_Mobile_Number__c ='12511552551');
       insert Acc1;
       insert Acc2;
       insert Acc3;
       Test.startTest();
       Carrier_Data__c CarrData = new Carrier_Data__c(Carrier_Seller_Name__c = 'test Carriar Data ',Carrier_Wireless_Phone_Number__c ='2552552551');
       insert CarrData;
       
       Carrier_Data__c CarrData1 = new Carrier_Data__c(Carrier_Seller_Name__c = 'test Carriar Data ',Carrier_Wireless_Phone_Number__c ='12552552551');
       insert CarrData1;
       
       Set<String> setPhone = new Set<String>();
       setPhone.add('2552552551');
       
       Set<Id> setId = new Set<Id>();
       setId.add(CarrData.Id);
       setId.add(CarrData1.Id);
       
       CarrierDataHelper.getAccountRecords(setPhone,setId);
       
       Test.stopTest();
    }
}