@isTest
private class AgentCreditcStatsTriggerTest {

   static testMethod void testTrigger() {
      Agent_Credit__c o = new Agent_Credit__c();
      insert o;

      System.assertNotEquals(null, o);
   }


}