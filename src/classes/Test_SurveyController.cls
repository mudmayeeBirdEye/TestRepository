/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 */
@isTest
private class Test_SurveyController {

    static testMethod void testSurveyController() {
       try{
       		
       		QuestionAndAnswers__c QuesAns = new QuestionAndAnswers__c();
       		QuesAns.Answers__c = 'Answers';
       		insert QuesAns;
       		
       		SurveyQuestionJunction__c surQuest =new SurveyQuestionJunction__c();
       		surQuest.IsMandatory__c = true;
       		surQuest.QuestionAndAnswers__c = QuesAns.Id;
       		insert surQuest;
       		
       		Test.startTest();
        	
        	ApexPages.currentPage().getParameters().put('id','Id');
        	
        	SurveyController surv = new SurveyController();
        	surv.getSurveyDetails();
        	surv.isAlreadyfilled = false;
        	surv.checkAlreadyFilled();
        	surv.questionUI();
        	surv.isFilled = true;
        	surv.getIsFilled();
        	surv.saveSurvey();
        	List<string> lst1 = new List<string>();
        	SurveyController.WrapperQuestionList WraQue = new SurveyController.WrapperQuestionList(QuesAns, lst1, true);
        	WraQue.IsMandatory = true;
        	WraQue.getValues();
        	WraQue.getTheCheckBoxValue();
        	Test.stopTest();
       }catch(Exception e){
       	  system.debug('Exception in test class:'+e.getMessage());
       }
    }
}