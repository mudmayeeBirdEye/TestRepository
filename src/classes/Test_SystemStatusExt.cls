/**************************************************************************************************
* Project Name..........: RingCentral -                                                           *
* File..................: Test_SystemStatusExt                                                    *
* Version...............: 1.0                                                                     *
* Created by............: Simplion Technologies                                                   *
* Created Date..........: 8 September 2014                                                        *
* Description...........: This is a test class for PartnerPortal to make dynamic                  *
**************************************************************************************************/
@isTest
private class Test_SystemStatusExt{
 public static testmethod void MyUnitTest1(){
   try{ 
        System_Status__c sysObj  = new System_Status__c();
        sysObj.IncidentID__c='123';  
        sysObj.Internal_Status__c='open';  
        sysObj.Public_Description__c='Open';  
        sysObj.Region__c = 'US';  
        sysObj.Severity__c ='Level 1';  
        sysObj.Summary__c = 'Test data ';
        insert sysObj ;
        
        System_Status__c sysObj1  = new System_Status__c();
        sysObj1.IncidentID__c='123';  
        sysObj1.Internal_Status__c='open';  
        sysObj1.Public_Description__c='Open';  
        sysObj1.Region__c = 'Uk';  
        sysObj1.Severity__c ='Level 1';  
        sysObj1.Summary__c = 'Test data ';
        insert sysObj1;
        
        System_Status__c sysObj2  = new System_Status__c();
        sysObj2.IncidentID__c='123' ; 
        sysObj2.Internal_Status__c='open';  
        sysObj2.Public_Description__c='Open';  
        sysObj2.Region__c = 'Canada';  
        sysObj2.Severity__c ='Level 1';  
        sysObj2.Summary__c = 'Test data ';
        insert sysObj2 ;
        
        System_Status__c sysObj3  = new System_Status__c();
        sysObj3.IncidentID__c='123' ; 
        sysObj3.Internal_Status__c='Resolved';  
        sysObj3.Public_Description__c='Resolved';  
        sysObj3.Region__c = 'US';  
        sysObj3.Severity__c ='Level 5';  
        sysObj3.Summary__c = 'Test data  data ';
        insert sysObj3;
        
        System_Status__c sysObj4  = new System_Status__c();
        sysObj4.IncidentID__c='123';  
        sysObj4.Internal_Status__c='Resolved';  
        sysObj4.Public_Description__c='Resolved';  
        sysObj4.Region__c = 'UK';  
        sysObj4.Severity__c ='Level 5';  
        sysObj4.Summary__c = 'Test data data  ';
        insert sysObj4 ;
        
        System_Status__c sysObj5  = new System_Status__c();
        sysObj5.IncidentID__c='123';  
        sysObj5.Internal_Status__c='Resolved ';  
        sysObj5.Public_Description__c='Resolved';  
        sysObj5.Region__c = 'Canada';  
        sysObj5.Severity__c ='Level 1';  
        sysObj5.Summary__c = 'Test data data  ';
        insert sysObj5;
        
        System_Status__c sysObj566  = new System_Status__c();
        sysObj566.IncidentID__c='123';  
        sysObj566.Internal_Status__c='Resolved ';  
        sysObj566.Public_Description__c='Resolved';  
        sysObj566.Region__c = 'Canada';  
        sysObj566.Severity__c ='Level 1';  
        sysObj566.Summary__c = 'Test data data  ';
        insert sysObj566;
        
        System_Status__c sysObj56  = new System_Status__c();
        sysObj56.IncidentID__c='123';  
        sysObj56.Internal_Status__c='Resolved ';  
        sysObj56.Public_Description__c='Resolved';  
        sysObj56.Region__c = 'Canada';  
        sysObj56.Severity__c ='Level 1';  
        sysObj56.Summary__c = 'Test data data  ';
        insert sysObj56;
        
        System_Status__c sysObj6  = new System_Status__c();
        sysObj6.IncidentID__c='123';  
        sysObj6.Internal_Status__c='Resolved ';  
        sysObj6.Public_Description__c='Resolved';  
        sysObj6.Region__c = 'Canada';  
        sysObj6.Severity__c ='Level 2';  
        sysObj6.Summary__c = 'Test data data  ';
        insert sysObj6;
        
        System_Status__c sysObj7  = new System_Status__c();
        sysObj7.IncidentID__c='123';  
        sysObj7.Internal_Status__c='Open ';  
        sysObj7.Public_Description__c='Resolved';  
        sysObj7.Region__c = 'Canada';  
        sysObj7.Severity__c ='Level 2';  
        sysObj7.Summary__c = 'Test data data  ';
        insert sysObj7;
        
        System_Status__c sysObj8  = new System_Status__c();
        sysObj8.IncidentID__c='123';  
        sysObj8.Internal_Status__c='Open ';  
        sysObj8.Public_Description__c='Resolved';  
        sysObj8.Region__c = 'Canada';  
        sysObj8.Severity__c ='Level 3';  
        sysObj8.Summary__c = 'Test data data  ';
        insert sysObj8;
        
        System_Status__c sysOb9  = new System_Status__c();
        sysOb9.IncidentID__c='12223';  
        sysOb9.Internal_Status__c='Resolved';  
        sysOb9.Public_Description__c='Open';  
        sysOb9.Region__c = 'US';  
        sysOb9.Severity__c ='Level 3';  
        sysOb9.Summary__c = 'Test data ';
        insert sysOb9 ;
        
        System_Status__c sysObj10  = new System_Status__c();
        sysObj10.IncidentID__c='1223';  
        sysObj10.Internal_Status__c='open';  
        sysObj10.Public_Description__c='Open';  
        sysObj10.Region__c = 'Uk';  
        sysObj10.Severity__c ='Level 4';  
        sysObj10.Summary__c = 'Test data ';
        insert sysObj10;
        
        System_Status__c sysObj11  = new System_Status__c();
        sysObj11.IncidentID__c='12223' ; 
        sysObj11.Internal_Status__c='Resolved ';  
        sysObj11.Public_Description__c='Open';  
        sysObj11.Region__c = 'Canada';  
        sysObj11.Severity__c ='Level 2';  
        sysObj11.Summary__c = 'Test data ';
        insert sysObj11 ;
        
        SystemStatusExt sysExt= new SystemStatusExt();
        
        Test.startTest();
         sysExt.getAllSystemRecords();
         sysExt.getLastSystemStatus();
         sysExt.getListOfSystemStatus();  
        Test.stopTest();
        
    }catch(Exception e){}   
  }
}