/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class Test_ATBCController {

    static testMethod void myUnitTest() {
       
        ATBCController atbcObj = new ATBCController();
        Lead leadObj = new Lead();
        leadObj.LeadSource = 'About To be Cancelled'; 
        leadObj.ATBC_Stage__c = 'WIP';
        leadObj.IsConverted = false;
        leadObj.User_ID__c = UserInfo.getUserId();
        leadObj.FirstName='Virendra';
        leadObj.LastName='Singh';
        leadObj.Company='Simplion';
        leadObj.Email='vps@sss.ss221.com';
        leadObj.Phone='9910106804';
        insert leadObj;
        
        Account acctest2 = new Account();
        acctest2.Name='TestAccount';
        acctest2.RC_User_ID__c = UserInfo.getUserId();
        acctest2.Next_Renewal_Date__c = Date.today() + 10;
        insert acctest2;
        atbcObj.save();
        Set<string> lUser1 = new Set<string>();
        lUser1.add(UserInfo.getUserId());
        atbcObj.getAccounts(lUser1);        
    }
    public static testmethod void Test_ATBCHelper() {
    
       try{
            
            Account acctest2 = new Account();
            acctest2.Name='TestAccount';
            acctest2.RC_User_ID__c = UserInfo.getUserId();
            acctest2.Next_Renewal_Date__c = Date.today() - 10;
            insert acctest2;
            
            Lead leadObj = new Lead();
            leadObj.LeadSource = 'About To be Cancelled'; 
            leadObj.ATBC_Stage__c = 'WIP';
            leadObj.IsConverted = false;
            leadObj.User_ID__c = UserInfo.getUserId();
            leadObj.Account__c = acctest2.id;
            leadObj.FirstName='Virendra';
            leadObj.LastName='Singh';
            leadObj.Company='Simplion';
            leadObj.Email='vps@sss.ss221.com';
            leadObj.Phone='9910106804';
            leadObj.Downgrade_Reason__c ='Not a Decision Maker';
            insert leadObj;
            
            Exception_And_Notification_History__c exceptionObjjj = new Exception_And_Notification_History__c();

            exceptionObjjj.Object_Type__c = 'Exception';
            exceptionObjjj.content_label_01__c = 'File Associated';
            exceptionObjjj.content_label_02__c = 'Line Number';
            exceptionObjjj.content_label_03__c = 'Exception';
            exceptionObjjj.content_label_04__c = 'Get Stack Trace String';
            exceptionObjjj.content_label_05__c = 'Details';
            exceptionObjjj.content_var_01__c ='ATBC Helper';
            exceptionObjjj.File_Associated__c = 'ATBC Helper';
            
            insert  exceptionObjjj;
        
            ATBCHelper objATBCHelper =new ATBCHelper ();
            //system.debug('+++'+leadObj.LastModifiedDate);
            system.debug('+++'+leadObj.Account_Renewal_Date__c);
            system.debug('+++'+leadObj.LastModifiedDate);
            objATBCHelper.startATBC();  
            objATBCHelper.performATBCCleanup();  
            ATBCHelper.performATBCCleanup2();   
        } catch(Exception exp){}
    
    
    
       /* try{
            ATBCHelper objATBCHelper =new ATBCHelper ();
            objATBCHelper.startATBC();      
        } catch(Exception exp){}*/
    }
    public static testMethod void Test_ATBCScheduledMethod(){
         Test.startTest();
         String jobId = System.schedule('ATBC Job',
                                      '0 0 0 3 9 ? 2022',new ATBCScheduledMethod());

         Test.stopTest();   
     
         ATBCScheduledMethod.RNIncidentDataTest RNTest = new ATBCScheduledMethod.RNIncidentDataTest();
         RNTest.testingIncidentData();
         RNTest.testingIncidentData02();
    }
 
}