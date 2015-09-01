@isTest 
private class TestUserCustomSettingHelper {
	static testMethod void userCustomSetting(){
		Boolean boolResult;
		String strName = 'RCSF Sync';
		String strNameOrIdOrEmail;
		Set<String> strSetNameOrId = new Set<String>();
		Map<string,RCSF_Sync__c> mapOfRCSF ;
		Map<id, User> mapUser = new Map<id, User>();
		Map<string,RCPARTNER_Sync__c> mapOfRCPartner ;
		Map<string,Specific_User__c> mapOfSpecificUser ;
		Map<String,India_Team__c> mapIndiaTeam;
		Map<String,RCSF_Sync__c> mapRCUser = new Map<String,RCSF_Sync__c>();
		Map<String,RCPARTNER_Sync__c> mapRCPARTNER = new Map<String,RCPARTNER_Sync__c>();
		Map<String,Specific_User__c> mapRCUserSpecificUser = new Map<String,Specific_User__c>();
		
		UserCustomSettingHelper objUserCustomSettingHelper = new UserCustomSettingHelper();
		
		RCSF_Sync__c objRCSFSync = new RCSF_Sync__c();
		objRCSFSync.First_Name__c = 'RCSF';
		objRCSFSync.Last_Name__c = 'Sync';
		objRCSFSync.Email__c = 'rcsfsync@ringcentral.com';
		objRCSFSync.Name ='RCSF Sync';
		insert objRCSFSync;
		
		UserCustomSettingHelper.userRCSFName(strName);
		
		strName = null;
		strName = 'RCPARTNER Sync';
		RCPARTNER_Sync__c objRCPARTNERSync = new RCPARTNER_Sync__c();
		objRCPARTNERSync.First_Name__c = 'RCSF';
		objRCPARTNERSync.Last_Name__c = 'Sync';
		objRCPARTNERSync.Active__c = true;
		objRCPARTNERSync.Email__c = 'rcsfsync@ringcentral.com';
		objRCPARTNERSync.Name = 'RCPARTNER Sync';
		insert objRCPARTNERSync;
		
		UserCustomSettingHelper.userRCSFName(strName);
		
		strName = null;
		strName = 'Sunil Madan';
		Specific_User__c objSpecificUser = new Specific_User__c();
		objSpecificUser.Name = 'Sunil Madan';
		insert objSpecificUser;
		
		UserCustomSettingHelper.userRCSFName(strName);
		
		strName = null;
		strName = 'India Team';
		India_Team__c objIndiaTeam = new India_Team__c();
		objIndiaTeam.Name = 'India Team';
		insert objIndiaTeam;
		
		User testUser = new User(alias = 'RCSFSync',FirstName='RCSF', email='rcsfsync@ringcentral.com',emailencodingkey='UTF-8', lastname='Sync', 
								 ProfileId=[SELECT Id FROM Profile LIMIT 1].Id, 
                        		 languagelocalekey='en_US',localesidkey='en_US', country='United States',
                        		 timezonesidkey='America/Los_Angeles', username='u11234@testorg.com', IsActive=true);                   
        insert testUser;
        mapUser.put(testUser.id,testUser);
		
		UserCustomSettingHelper.userRCSFName(strName);
	}
	static testMethod void userCustomSettingId(){
		Set<String> strSetNameOrId = new Set<String>();
		Map<String,RCSF_Sync__c> mapRCUser = new Map<String,RCSF_Sync__c>();
		Map<String,RCPARTNER_Sync__c> mapRCPARTNER = new Map<String,RCPARTNER_Sync__c>();
		Map<String,Specific_User__c> mapRCUserSpecificUser = new Map<String,Specific_User__c>();
		
		String strNameOrIdOrEmail = 'RCSF Sync';
		RCSF_Sync__c objRCSFSync = new RCSF_Sync__c();
		objRCSFSync.First_Name__c = 'RCSF';
		objRCSFSync.Last_Name__c = 'Sync';
		objRCSFSync.Email__c = 'rcsfsync@ringcentral.com';
		objRCSFSync.Name ='RCSF Sync';
		insert objRCSFSync;
		UserCustomSettingHelper.getRCSFSync(strNameOrIdOrEmail);
		
		strNameOrIdOrEmail = null;
		strNameOrIdOrEmail = 'RCPARTNER Sync';
		RCPARTNER_Sync__c objRCPARTNERSync = new RCPARTNER_Sync__c();
		objRCPARTNERSync.First_Name__c = 'RCSF';
		objRCPARTNERSync.Last_Name__c = 'Sync';
		objRCPARTNERSync.Active__c = true;
		objRCPARTNERSync.Email__c = 'rcsfsync@ringcentral.com';
		objRCPARTNERSync.Name = 'RCPARTNER Sync';
		insert objRCPARTNERSync;
		UserCustomSettingHelper.getRCSFSync(strNameOrIdOrEmail);
		
		strNameOrIdOrEmail = null;
		strNameOrIdOrEmail = 'Sunil Madan';
		Specific_User__c objSpecificUser = new Specific_User__c();
		objSpecificUser.Name = 'Sunil Madan';
		insert objSpecificUser;
		UserCustomSettingHelper.getRCSFSync(strNameOrIdOrEmail);
		
		strNameOrIdOrEmail = null;
		strNameOrIdOrEmail = 'India Team';
		India_Team__c objIndiaTeam = new India_Team__c();
		objIndiaTeam.Name = 'India Team';
		insert objIndiaTeam;
		UserCustomSettingHelper.getRCSFSync(strNameOrIdOrEmail);
	}
	
	static testMethod void userCustomEmail(){
		Set<String> strSetNameOrId = new Set<String>();
		Map<String,RCSF_Sync__c> mapRCUser = new Map<String,RCSF_Sync__c>();
		Map<String,RCPARTNER_Sync__c> mapRCPARTNER = new Map<String,RCPARTNER_Sync__c>();
		Map<String,Specific_User__c> mapRCUserSpecificUser = new Map<String,Specific_User__c>();
		
		String strNameOrIdOrEmail = 'rcsfsync@ringcentral.com';
		RCSF_Sync__c objRCSFSync = new RCSF_Sync__c();
		objRCSFSync.First_Name__c = 'RCSF';
		objRCSFSync.Last_Name__c = 'Sync';
		objRCSFSync.Email__c = 'rcsfsync@ringcentral.com';
		objRCSFSync.Name ='RCSF Sync';
		insert objRCSFSync;
		UserCustomSettingHelper.getRCSFSync(strNameOrIdOrEmail);
		
		strNameOrIdOrEmail = null;
		strNameOrIdOrEmail = 'bizserv.crm@ringcentral.com';
		RCPARTNER_Sync__c objRCPARTNERSync = new RCPARTNER_Sync__c();
		objRCPARTNERSync.First_Name__c = 'RCSF';
		objRCPARTNERSync.Last_Name__c = 'Sync';
		objRCPARTNERSync.Active__c = true;
		objRCPARTNERSync.Email__c = 'bizserv.crm@ringcentral.com';
		objRCPARTNERSync.Name = 'RCPARTNER Sync';
		insert objRCPARTNERSync;
		UserCustomSettingHelper.getRCSFSync(strNameOrIdOrEmail);
		
		strNameOrIdOrEmail = null;
		strNameOrIdOrEmail = 'sunilm@ringcentral.com';
		Specific_User__c objSpecificUser = new Specific_User__c();
		objSpecificUser.Email__c = 'sunilm@ringcentral.com';
		objSpecificUser.Name = 'Sunil Madan';
		insert objSpecificUser;
		UserCustomSettingHelper.getRCSFSync(strNameOrIdOrEmail);
		
		strNameOrIdOrEmail = null;
		strNameOrIdOrEmail = 'rcindiateam@simplion.com';
		India_Team__c objIndiaTeam = new India_Team__c();
		objIndiaTeam.Email__c = 'rcindiateam@simplion.com';
		objIndiaTeam.Name = 'India Team';
		insert objIndiaTeam;
		UserCustomSettingHelper.getRCSFSync(strNameOrIdOrEmail);
	}
	
}