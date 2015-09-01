/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 */
@isTest
private class Test_confirmationedgelead {

    static testMethod void myUnitTest() {
        confirmationedgelead ed = new confirmationedgelead();
        ed.testingEdgeData011();
    }
    
     static testMethod void testcleanchatterctr(){
        cleanchatterctr RNTest = new cleanchatterctr();
        // RNTest.testingIncidentData02();
    }
   
    static testMethod void testCloseCase(){
        CloseCase.CloseDataTest CloseCaseTest= new CloseCase.CloseDataTest();
        CloseCaseTest.testingCloseData01();
        CloseCaseTest.testingCloseData02();
        CloseCaseTest.testingCloseData03();
    }
}