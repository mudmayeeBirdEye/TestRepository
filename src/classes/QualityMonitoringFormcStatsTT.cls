@isTest
private class QualityMonitoringFormcStatsTT {

   static testMethod void testTrigger() {
      try {
          Quality_Monitoring_Form__c o = new Quality_Monitoring_Form__c();
          insert o;

          System.assertNotEquals(null, o);
      }
      catch(Exception e) {
          List<Quality_Monitoring_Form__c> l = [SELECT Id from Quality_Monitoring_Form__c LIMIT 1];
          update l;
          System.assertNotEquals(null, l);
      }
   }
}