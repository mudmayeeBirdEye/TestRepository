/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 */
@isTest
private class Test_ITSurveyController {

    static testMethod void myUnitTest() {
        
   
   Survey__c surveyObj = new Survey__c();
   surveyObj.SurveyType__c = 'RC - IT Internal Survey';
   surveyObj.Contact_Email__c ='faks@fake.com';
   insert surveyObj;
   
    ApexPages.currentPage().getParameters().put('id', surveyObj.id);  
   	ITSurveyController its = new ITSurveyController();
   	its.setQ1Value(1);
    its.setQ2Value(2);
    its.setQ3Value(3);
    its.setQ4Value(4);
    its.setQ5Value(5);
    its.setQ6Value(4);
    its.setQ7Value(3);
    its.setQ8Value(2);
    its.setQ9Value(2);
    its.setQ10Value(2);
    its.setQ11Value(2);
    
     System.assertEquals(1, its.getQ1Value());
     System.assertEquals(2, its.getQ2Value());
     System.assertEquals(3, its.getQ3Value());
     System.assertEquals(4, its.getQ4Value());
     System.assertEquals(5, its.getQ5Value());
     System.assertEquals(4, its.getQ6Value());
     System.assertEquals(3, its.getQ7Value());
     System.assertEquals(2, its.getQ8Value());
     System.assertEquals(2, its.getQ9Value());
     System.assertEquals(2, its.getQ10Value());
     System.assertEquals(2, its.getQ11Value());
   
    
    its.setComments('these are my comments');
    System.assertEquals('these are my comments', its.getComments());
    
    its.getITSurvey();
    its.getAlradyFilled();
    its.save();
    its.getThanksMsg();
    its.getValues1();
    its.getValues2();
    its.getValues3();
    
   Survey__c surveyObj1 = new Survey__c();
   surveyObj1.SurveyType__c = 'RC - IT Internal Survey';
   surveyObj1.Contact_Email__c ='faks@fake.com';
   surveyObj1.Responded__c = 1;
   insert surveyObj1;
   
   ApexPages.currentPage().getParameters().put('id', surveyObj1.id);    
   ITSurveyController its1 = new ITSurveyController();
   its1.getAlradyFilled();
   its1.comment = '1';
   for(Integer i= 1;i<2200;i++){
   	its1.comment =  its1.comment + i;
   }
   its1.save();
    
   ApexPages.currentPage().getParameters().put('id', '11111111111');  
   ITSurveyController its2 = new ITSurveyController(); 
   
    }
}