/**************************************************************************************************
* Project Name..........: Medallia                                                                *
* File..................: TestMedalliaFetchSurveyBatch.class                                      *
* Version...............: 1.0                                                                     *
* Created by............: Simplion Technologies                                                   *
* Created Date..........: 11-03-2013                                                              *
* Last Modified by......: Simplion Technologies                                                   *
* Last Modified Date....: 11-03-2013                                                              *
* Description...........: This is a test class for MedalliaFetchSurveyBatch batch class.          *
**************************************************************************************************/

@isTest
private class TestMedalliaFetchSurveyBatch {

    static testMethod void myUnitTest() {
        try{
			MedalliaFetchSurveyBatch mfsb = new MedalliaFetchSurveyBatch();
			Database.executeBatch(mfsb);
    	}catch(Exception ex){
			system.debug('#### Error on line - '+ex.getLineNumber());
	    	system.debug('#### Error message - '+ex.getMessage());
		}
    }
}