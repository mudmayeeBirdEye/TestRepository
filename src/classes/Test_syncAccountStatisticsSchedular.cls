/**************************************************************************************************
* Project Name..........: RingCentral -                                                           *
* File..................: Test_syncAccountStatisticsSchedular.cls                                 *
* Version...............: 1.0                                                                     *
* Created by............: Simplion Technologies                                                   *
* Created Date..........: 31 December 2013                                                        *
* Last Modified by......: Simplion Technologies                                                   *
* Last Modified Date....:                                                                         *
* Description...........: This is a test class for syncAccountStatisticsSchedular class.          *
**************************************************************************************************/
@isTest
private class Test_syncAccountStatisticsSchedular {

	static testMethod void TestsyncAccountStatisticsSchedular() {
		Test.startTest();
			Account a = new Account();
			a.name = 'testScheduledApexFromTestMethod';
			insert a;
			// Schedule the test job  
			String jobId = System.schedule('testAccountStatisticsScheduledApex','0 0 0 3 9 ? 2022',new syncAccountStatisticsScheduler());
		Test.stopTest();
    }
}