@isTest

private class MassPasswordController_Test {
	
	static testMethod void MassPasswordController_TestMethod(){
		Profile adminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' limit 1];
		Profile ssoEnable = [SELECT Id FROM Profile WHERE IsSsoEnabled = true limit 1];
		Profile ssoDisabled = [SELECT Id FROM Profile WHERE IsSsoEnabled = false limit 1];
		
		
		User adminUser = new User(profileId = adminProfile.id, username = 'adminUser@testemail.com', email = 'adminUser@testemail.com',
							  	  emailencodingkey = 'UTF-8', localesidkey = 'en_US',
								  languagelocalekey = 'en_US', timezonesidkey = 'America/Los_Angeles',
								  alias='cspu', lastname='lastname');

		insert adminUser;
		
		User ssoEnabledUser = new User(profileId = ssoEnable.id, username = 'ssoEnabledUser@testemail.com', email = 'ssoEnabledUser@testemail.com',
							  	  emailencodingkey = 'UTF-8', localesidkey = 'en_US',
								  languagelocalekey = 'en_US', timezonesidkey = 'America/Los_Angeles',
								  alias='cspu', lastname='lastname');

		insert ssoEnabledUser;
		
		User ssoDisabledUser = new User(profileId = ssoDisabled.id, username = 'ssoDisabledUser@testemail.com', email = 'ssoDisabledUser@testemail.com',
							  	  emailencodingkey = 'UTF-8', localesidkey = 'en_US',
								  languagelocalekey = 'en_US', timezonesidkey = 'America/Los_Angeles',
								  alias='cspu', lastname='lastname');

		insert ssoDisabledUser;
		
		MassPasswordController ctrl = new MassPasswordController();
		ctrl.newPassword = 'newPassword';
		
		//Admin Check
		ctrl.usernames = adminUser.Username;
		ctrl.updatePassword();
		
		//10 users limit check
		ctrl.usernames = 'user1@simplion.com,user2@simplion.com,user3@simplion.com,user4@simplion.com,user5@simplion.com,user6@simplion.com,user7@simplion.com,user8@simplion.com,user9@simplion.com,user10@simplion.com,user11@simplion.com';
		ctrl.updatePassword();
		
		ctrl.usernames = ssoDisabledUser.Username;
		ctrl.updatePassword();
	}
	
}