/**************************************************************************************************
* Project Name..........: Medallia                                                                *
* File..................: ScheduleMedalliaFetchSurveyBatch.class                                  *
* Version...............: 1.0                                                                     *
* Created by............: Simplion Technologies                                                   *
* Created Date..........: 03/28/2014 11:00 PM                                                     *
* Last Modified by......: Simplion Technologies                                                   *
* Last Modified Date....: 03/28/2014 11:00 PM                                                     *
* Description...........: This is a class to schedule Medallia Fetch Survey batch class.          *
**************************************************************************************************/

global class ScheduleMedalliaFetchSurveyBatch implements Schedulable {

	/******************************************************************************
	* @Description : Execute method to schedule the batch.                        *
	* @Params      : SchedulableContext                                           *
	* @Return      : void                                                         * 
	******************************************************************************/
	global void execute(SchedulableContext SC) {
      MedalliaFetchSurveyBatch mfsbObj = new MedalliaFetchSurveyBatch();
      database.executebatch(mfsbObj,50); 
   }
}