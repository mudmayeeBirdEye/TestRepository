/**************************************************************************************************
* Project Name..........: Medallia                                                                *
* File..................: ScheduleMedalliaActiveAccountBatch.class                                *
* Version...............: 1.0                                                                     *
* Created by............: Simplion Technologies                                                   *
* Created Date..........: 03/28/2014 11:00 PM                                                     *
* Last Modified by......: Simplion Technologies                                                   *
* Last Modified Date....: 03/28/2014 11:00 PM                                                     *
* Description...........: This is a class to schedule Medallia Active Account batch class.        *
**************************************************************************************************/

global class ScheduleMedalliaActiveAccountBatch implements Schedulable {
	
	/******************************************************************************
	* @Description : Execute method to schedule the batch.                        *
	* @Params      : SchedulableContext                                           *
	* @Return      : void                                                         * 
	******************************************************************************/
	global void execute(SchedulableContext SC) {
      MedalliaActiveAccountsBatch maabObj = new MedalliaActiveAccountsBatch();
      database.executebatch(maabObj,50); 
   }

}