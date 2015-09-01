/*******************************************************************************************************
* Project Name..........: TestSendEmailForSurvey                                                       *
* File..................: SendEmailForSurvey.class                                                     *
* Version...............: 1.0                                                                          *
* Created by............: eugenebasianomutya                                                           *
* Created Date..........: 10-04-2015                                                                   *
* Last Modified by......: eugenebasianomutya                                                           *
* Last Modified Date....: 10-04-2015                                                                   *
* Description...........: This is a test class to for SendEmailForSurvey class.                        *
********************************************************************************************************/


@isTest
private class TestSendEmailForSurvey {

	static testMethod void myUnitTest(){
		
		string sSurveyId = 'Survey Id';
		string ssurveyTemplateName = 'Survey Template Name';
		
		list<string> sEmailAdd = new list<string>();

		sEmailAdd.add('test1@test.com');
		sEmailAdd.add('test2@test.com');
		sEmailAdd.add('test3@test.com');
		
		SendEmailForSurvey.sendAnEmail(sEmailAdd, sSurveyId, ssurveyTemplateName);
		
	}
	
}