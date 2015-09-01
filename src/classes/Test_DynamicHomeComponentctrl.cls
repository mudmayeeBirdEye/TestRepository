/**************************************************************************************************
* Project Name..........: RingCentral -                                                           *
* File..................: Test_DynamicHomeComponentctrl                                           *
* Version...............: 1.0                                                                     *
* Created by............: Simplion Technologies                                                   *
* Created Date..........: 7th October 2014                                                        *
* Description...........: This is a test class for PartnerPortal to be dynamic                    *
* UPDATE
* By:                     eugenebasianomutya
* Date:                   29/04/2015
* Detail:                 Get Folder id so that class can be used to all sandbox
**************************************************************************************************/
@isTest(seeAllData=true)
private class Test_DynamicHomeComponentctrl{
     public static testmethod void unitTest_DynamicHomeComponentctrl(){ 
      
         //Get Folder ID
         Folder f = [Select Id From Folder where Name = 'Public Documents'];    
          
         Document doc = new Document();
         doc.Name = 'PartnerPortalEventsCSV';
         doc.Body = Blob.valueOf('PartnerPortalEventsCSV');
         doc.FolderId = f.Id; 
         insert doc;
         
         Document doc1 = new Document();
         doc1.Name = 'PartnerPortalAnnouncement';
         doc1.Body = Blob.valueOf('PartnerPortalAnnouncement');
         doc1.FolderId = f.Id; 
         insert doc1 ;
         
         Document doc2 = new Document();
         doc2.Name = 'PartnerPortalHomeCmp'; 
         doc2.Body = Blob.valueOf('PartnerPortalHomeCmp');
         doc2.FolderId = f.Id; 
         insert doc2 ;
              
         DynamicHomeComponentctrl dynHomeComp = new DynamicHomeComponentctrl(); 
         String contents='DBLQT';    
         Boolean skipHeaders =true; 
         DynamicHomeComponentctrl.parseCSV(contents, skipHeaders);
         
         Test.startTest();
             Blob csvbody = doc.Body;
             dynHomeComp.getResults();
         Test.stopTest();
    }
 }