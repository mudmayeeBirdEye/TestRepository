/**************************************
****Test class for the PartnerRequestRedirect class**** 
****created date ------09/07/2014 ********************
**************************************/
@isTest
private class TestSystemStatusControllerSite{
 static testMethod void unitTestSystemStatusControllerSite(){
        SystemStatusControllerSite objSystemStatusControllerSite =new SystemStatusControllerSite();
        RCSiteSetup__c objRCSiteName= (RCSiteSetup__c)SmartFactory.createSObject('RCSiteSetup__c', true);
        objRCSiteName.RCSiteName__c='rcsupport';
        upsert objRCSiteName;
     
        objSystemStatusControllerSite =new SystemStatusControllerSite();
        objRCSiteName.Brand_Filter__c='Brand:US';
        upsert objRCSiteName;
        objSystemStatusControllerSite =new SystemStatusControllerSite();
     
        objRCSiteName.Brand_Filter__c='Brand:UK';
        upsert objRCSiteName;
        objSystemStatusControllerSite =new SystemStatusControllerSite();
     
        objRCSiteName.Brand_Filter__c='Brand:CAN';
        upsert objRCSiteName;
        objSystemStatusControllerSite =new SystemStatusControllerSite();
     
        objRCSiteName.Brand_Filter__c='Brand:US';
        upsert objRCSiteName;
    
        System_Status__c obj=(System_Status__c)SmartFactory.createSObject('System_Status__c', true);
        obj.Region__c='US';
        upsert obj;
    
        objSystemStatusControllerSite =new SystemStatusControllerSite();
        obj.Public_Description__c='test';
        upsert obj;
        objSystemStatusControllerSite =new SystemStatusControllerSite();
     }
   }