@isTest
private class TriggerHandler_Test {
	static testMethod void testUseCases() {
		TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT();
		TriggerHandler.BY_PASS_ACCOUNT_ON_UPDATE();
		TriggerHandler.BY_PASS_CONTACT_ON_INSERT();
		TriggerHandler.BY_PASS_CONTACT_ON_UPDATE();
		TriggerHandler.BY_PASS_OPPORTUNITY_ON_INSERT();
		TriggerHandler.BY_PASS_OPPORTUNITY_ON_UPDATE();
		TriggerHandler.RESET_VARIABLES();
	}
}