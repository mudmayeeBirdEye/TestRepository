@isTest
public class testsyncBatchAccountLevelRollUps{
    static testmethod void test() {
   
    String strQuery='Select Total_Cases__c,Total_Contacts__c,Total_Activities__c,(Select Id From Cases),(Select Id From Contacts),(Select Id From OpenActivities) From Account a where account limit 1';
    
    Account testAccount = new Account(Name = 'testAccount');
    insert testAccount;
     Test.StartTest();
     syncBatchAccountLevelRollUps obj=new syncBatchAccountLevelRollUps(strQuery);
     
     Test.StopTest();
     Database.executeBatch(obj,100);
    }
  }