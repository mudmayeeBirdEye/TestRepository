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
private class Test_ImplementationSurveyController {

    static testMethod void myUnitTest() {
        
   
   Survey__c surveyObj = new Survey__c();
   surveyObj.SurveyType__c = 'ATT Implementation';
   insert surveyObj;
   
   ApexPages.currentPage().getParameters().put('id', surveyObj.id);  
   
        ImplementationSurveyController sur = new ImplementationSurveyController();
         sur.setQ1Value(3);
         sur.setQ2Value(2);
         sur.setQ3Value(4);
         sur.setQ4Value(5);
         sur.setQ6Value(5);
         sur.setQ71Value(4);
         sur.setQ72Value(3);
         sur.setQ73Value(4);
         sur.setQ74Value(2);
   
         sur.setComments('these are my comments');
    
         System.assertEquals(3, sur.getQ1Value());
         System.assertEquals(2, sur.getQ2Value());
         System.assertEquals(4, sur.getQ3Value());
         System.assertEquals(5, sur.getQ4Value());
         System.assertEquals(5, sur.getQ6Value());
         System.assertEquals(4, sur.getQ71Value());
         System.assertEquals(3, sur.getQ72Value());
         System.assertEquals(4, sur.getQ73Value());
         System.assertEquals(2, sur.getQ74Value());
         System.assertEquals('these are my comments', sur.getComments());
    
         sur.getImplementationSurvey();
         sur.setResponseValue();
         sur.getRogersFooter();
         sur.getRogersHeader();
         sur.getThanksMsg();
         sur.getLogo();
         sur.radio2Select();
         sur.radio3Select();
         sur.radio4Select();
         sur.radio6Select();
         List<SelectOption> l1 = sur.getValues3();
         //List<SelectOption> l2 = sur.getValues2();
         //List<SelectOption> l2 = sur.getValues();
         
    
         sur.save(); 
       
        Survey__c surveyObj1 = new Survey__c();
        surveyObj1.SurveyType__c = 'ATT Implementation';
        surveyObj1.Responded__c = 1;
        insert surveyObj1;
       
        ApexPages.currentPage().getParameters().put('id', surveyObj1.id);  
        ImplementationSurveyController sur1 = new ImplementationSurveyController();
        sur1.getAlradyFilled();
        sur1.getQ1();
        
        Survey__c surveyObj2 = new Survey__c();
        surveyObj2.SurveyType__c = 'Implementation';
        insert surveyObj2;
       
        ApexPages.currentPage().getParameters().put('id', surveyObj2.id);  
        ImplementationSurveyController sur2 = new ImplementationSurveyController();
        sur2.getImplementationSurvey();
        sur2.getLogo();
         
        Survey__c surveyObj3 = new Survey__c();
        surveyObj3.SurveyType__c = 'Rogers Implementation';
        insert surveyObj3;
       
        ApexPages.currentPage().getParameters().put('id', surveyObj3.id);  
        ImplementationSurveyController sur3 = new ImplementationSurveyController();
        sur3.getImplementationSurvey();
        sur3.getLogo();
        sur3.getAlradyFilled();
        sur3.getQ1();
        
        
        //TriggerHandler.BY_PASS_IMPLEMENTATION_ON_BEFORE  = true;
        //TriggerHandler.BY_PASS_IMPLEMENTATION_ON_AFTER = true;
        //Testing for Completed Implementation(s)
        Implementation__c testImpl = new Implementation__c();
        testImpl.Name = 'testImpl';
        testImpl.Most_Recent_follow_up_Date__c = date.today();
        testImpl.Porting_Required__c = 'Yes';
        //testImpl.Account__c = objAccount.Id;
        testImpl.Implementation_Status_2__c = 'Completed';
        testImpl.Brand__c = 'BTBrand';
        testImpl.Status_Change_Comment__c ='comment';
        insert testImpl;
        //TriggerHandler.BY_PASS_IMPLEMENTATION_ON_BEFORE  = false;
        //TriggerHandler.BY_PASS_IMPLEMENTATION_ON_AFTER = false;
        
        Survey__c surveyObj4 = new Survey__c();
        surveyObj4.SurveyType__c = '';
        surveyObj4.Implementation__c = testImpl.Id;
        insert surveyObj4;
       
        ApexPages.currentPage().getParameters().put('id', surveyObj4.id);  
        ImplementationSurveyController sur4 = new ImplementationSurveyController();
        sur4.getLogo();
        sur4.isBTBrand();
        
        ApexPages.currentPage().getParameters().put('id', '0000000');  
        ImplementationSurveyController sur5 = new ImplementationSurveyController();
        
        Survey__c surveyObj5 = new Survey__c();
        surveyObj5.SurveyType__c = '';
        insert surveyObj5;
        ApexPages.currentPage().getParameters().put('id', surveyObj5.id);  
        ImplementationSurveyController sur6 = new ImplementationSurveyController();
        delete surveyObj5;
        sur6.save(); 
  
    }
}