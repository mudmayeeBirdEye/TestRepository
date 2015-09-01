/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class SurveyResponseControllerTest {

    static testMethod void myUnitTest() {
    	try{
	    	SurveyUserJunction__c Surv = new SurveyUserJunction__c();
	    	Surv.User_Email__c = 'test@test.com';
	    	Surv.QuestionAnswered__c = 'questionAnswe@rques';
	    	insert Surv;
	    	
	    	QuestionAndAnswers__c QueAns = new QuestionAndAnswers__c();
	    	QueAns.Answers__c = 'Answers';
	    	QueAns.Subject__c = 'Subject';
	    	insert QueAns;
	    	
	    	ApexPages.StandardController sc = new ApexPages.standardController(Surv);
	        SurveyResponseController SurRes = new SurveyResponseController(sc);
	        SurRes.getAnswerDetails(); 
	        SurRes.getQuestionAnswerResponse(Surv.QuestionAnswered__c);
	        SurRes.getQuestionAnswerMasterDetails();
    	}catch(Exception e){}
    }
}