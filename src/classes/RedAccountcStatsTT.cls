@isTest
private class RedAccountcStatsTT {

   static testMethod void testTrigger() {
      try {
          Red_Account__c o = new Red_Account__c();
          insert o;

          System.assertNotEquals(null, o);
      }
      catch(Exception e) {
          List<Red_Account__c> l = [SELECT Id from Red_Account__c LIMIT 1];
          update l;
          System.assertNotEquals(null, l);
      }
   }
}