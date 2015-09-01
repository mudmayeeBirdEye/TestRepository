@istest
Private class testSyncPartAccUpdSharRulSch{
static testmethod void unitSyncPartAccUpdSharRulSch() {
   try{
    Test.startTest();
     String CRON_EXP = '0 0 0 3 9 ? 2022';
     String jobId = System.schedule('syncPartnerAccountUpdateSh_'+System.Now(),CRON_EXP, new syncPartnerAccountUpdateSharingRuleSch());
     //CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered,NextFireTime  FROM CronTrigger WHERE id = :jobId];
     
     Test.stopTest();
  }catch(Exception e){}
   }
 }