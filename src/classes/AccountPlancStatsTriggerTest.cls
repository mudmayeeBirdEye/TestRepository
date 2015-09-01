@isTest
private class AccountPlancStatsTriggerTest {

   static testMethod void testTrigger() {
      Account_Plan__c o = new Account_Plan__c();
      insert o;

      System.assertNotEquals(null, o);
   }


}