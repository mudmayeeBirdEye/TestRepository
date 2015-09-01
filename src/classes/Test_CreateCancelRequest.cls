/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
  */
@isTest
private class Test_CreateCancelRequest {

    static testMethod void myUnitTest() {
        CreateCancelRequestObject.AccountExtnDataTest AccountExtnTest= new CreateCancelRequestObject.AccountExtnDataTest();
        AccountExtnTest.testingAccountData01();
        AccountExtnTest.testingAccountData02();
        AccountExtnTest.testingAccountData03();
        AccountExtnTest.testingAccountData04();
        AccountExtnTest.testingAccountData05();
        AccountExtnTest.testingAccountData06();
        AccountExtnTest.testingAccountData07();
        AccountExtnTest.testingAccountData08();
        AccountExtnTest.testingAccountData09();
        AccountExtnTest.testingAccountData10();
    }
     static testMethod void Test_CreateLeadFromContact() {
        CreateLeadFromContact.AccountExtnDataTest AccountExtnTest= new CreateLeadFromContact.AccountExtnDataTest();
		AccountExtnTest.testingAccountData01();
		AccountExtnTest.testingAccountData02();
		AccountExtnTest.testingAccountData03();
		AccountExtnTest.testingAccountData04();
		AccountExtnTest.testingAccountData05();
		AccountExtnTest.testingAccountData06();
		AccountExtnTest.testingAccountData07();
		AccountExtnTest.testingAccountData08();
		AccountExtnTest.testingAccountData09();
		AccountExtnTest.testingAccountData10();
      
   
    }
}