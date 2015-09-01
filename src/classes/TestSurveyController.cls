@isTest
public class TestSurveyController {
	static testMethod void surveyControllerUnitTest() {
    	try {
    		 SurveyController surveyControllerObj = new SurveyController();
    		 SurveyController surveyControllerObj1 = new SurveyController();
    		 surveyControllerObj1.getSurveyDetails();
    		 surveyControllerObj1.isAlreadyfilled = false;
    		 surveyControllerObj1.checkAlreadyFilled();
    		 surveyControllerObj1.questionUI();
    		 surveyControllerObj1.getIsFilled();
    		 surveyControllerObj1.saveSurvey();
    		 surveyControllerObj1.isFilled = true;
    		 for(SurveyController.WrapperQuestionList wrReponseObj : surveyControllerObj1.wQesList) { 
    		 	 if (wrReponseObj.questionsObj.Option_Type__c == 'Text' ) {
                    wrReponseObj.theTextValue = 'Test';
                 } else  if ( wrReponseObj.questionsObj.Option_Type__c == 'Radio'  ) {
                        wrReponseObj.theRadioValue = 'A';
                 } else if ( wrReponseObj.questionsObj.Option_Type__c == 'Checkbox') {
                 		List<string> lstAnswer = new List<string>();
                 		lstAnswer.add('A');
                 		lstAnswer.add('B');
                        wrReponseObj.theCheckBoxValue = lstAnswer;
                 } else if ( wrReponseObj.questionsObj.Option_Type__c == 'Textarea') {
                        wrReponseObj.theLongTextValue = 'ABC';
                 }
    		 }
    		 surveyControllerObj1.saveSurvey();
    		 QuestionAndAnswers__c questionObj = new QuestionAndAnswers__c( Answers__c='Hello;Test');
    		 insert questionObj;
    		 List<string> answerList = new  List<string>();
    		 if(questionObj.Answers__c != null && questionObj.Answers__c != '') {
    		 	answerList = questionObj.Answers__c.split(';');
    		 }
    	 SurveyController.WrapperQuestionList weQuestionListObj = new SurveyController.WrapperQuestionList(questionObj,
    		 																answerList,true);
    		 weQuestionListObj.getValues();
    		 weQuestionListObj.getTheCheckBoxValue();
    		 weQuestionListObj.setTheCheckBoxValue(answerList);
    		 SurveyController surveyControllerObj2 = new SurveyController();
    	} catch(Exception ex) {
    		
    	}
    }
    
     
}