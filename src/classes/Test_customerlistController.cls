/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 */
@isTest
private class Test_customerlistController {

    static testMethod void myUnitTest() {
        customerlistController.RNIncidentDataTest RNTest = new customerlistController.RNIncidentDataTest();
        RNTest.testingIncidentData();
        RNTest.testingIncidentData02();
        RNTest.testingIncidentData03();
    }
    static testMethod void Test_chkContactOnAccount() {
        
         chkContactOnAccount.FakeDataTest FakeTest = new chkContactOnAccount.FakeDataTest();
         FakeTest.testingFakeData();
         FakeTest.testingFakeData02();    
    
    }
}