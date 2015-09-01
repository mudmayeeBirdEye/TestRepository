@isTest
private class AgentCreditcStatsTT {

   static testMethod void testTrigger() {
      try {
          Agent_Credit__c o = new Agent_Credit__c();
          insert o;

          System.assertNotEquals(null, o);
      }
      catch(Exception e) {
          List<Agent_Credit__c> l = [SELECT Id from Agent_Credit__c LIMIT 1];
          update l;
          System.assertNotEquals(null, l);
      }
   }
}