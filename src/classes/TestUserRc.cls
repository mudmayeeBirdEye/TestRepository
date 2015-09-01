@isTest 
private class TestUserRc {
	static testMethod void getRCSFSync(){
		
		String getRCSFSyncPrimaryOwnerId = UserRc.getRCSFSyncPrimaryOwnerId;
		String usrName;
		String usrEmail;
		String usrId;
		Map<String, RCSF_Sync__c> rcSfSyncConfigurationMap = RCSF_Sync__c.getAll();
		Map<String, India_Team__c> indiaTeamUserConfigurationMap = India_Team__c.getAll();
		Map<String, RCPARTNER_Sync__c> rcPartnerSyncConfigurationMap = RCPARTNER_Sync__c.getAll();
		Map<String,Specific_User__c> specificUserConfigurationMap = Specific_User__c.getAll();
    	UserRc objUserRc = new UserRc();
    	
    	usrName= 'RCSF Sync';
    	usrEmail= 'rcsfsync@ringcentral.com';
    	RCSF_Sync__c objRCSFSync = new RCSF_Sync__c();
		objRCSFSync.First_Name__c = 'RCSF';
		objRCSFSync.Last_Name__c = 'Sync';
		objRCSFSync.Email__c = 'rcsfsync@ringcentral.com';
		objRCSFSync.Name ='RCSF Sync';
		insert objRCSFSync;
		UserRc.compareUserEmail(usrEmail);
		UserRc.compareUserName(usrName);
		
		Set<String> setOfRCSFUserId = UserRc.setOfRCSFUserId ;
		Set<String> setOfRCSFUserName = UserRc.setOfRCSFUserName;
		Set<String> setOfRCSFUserEmail = UserRc.setOfRCSFUserEmail;
		RCSF_Sync__c rcsfSyncUserObj = UserRc.rcsfSyncUserObj;
		//System.debug('#### RCSF Sync Primary Owner Id - '+UserRC.getRCSFSyncPrimaryOwnerId);
	
	}
		
		static testMethod void getIndiaTeam(){
			Set<String> setOfIndiaTeamUserId = new Set<String>();
			Set<String> setOfIndiaTeamUserName = new Set<String>();
			Set<String> setOfIndiaTeamUserEmail = new Set<String>();
			String usrName;
			String usrEmail;
			String usrId;
			Map<String, India_Team__c> indiaTeamUserConfigurationMap = India_Team__c.getAll();
			
			usrName = 'India Team';
			usrEmail ='rcindiateam@simplion.com';
			
			India_Team__c objIndiaTeam = new India_Team__c();
			objIndiaTeam.Email__c = 'rcindiateam@simplion.com';
			objIndiaTeam.Name = 'India Team';
			insert objIndiaTeam;
	    	UserRc.compareIndiaTeamUserEmail(usrEmail);
	    	UserRc.compareIndiaTeamUserName(usrName);
	    	
	    	System.debug('#### Get All Custom setting values - '+India_Team__c.getAll());
	    	
	    	setOfIndiaTeamUserId = UserRc.setOfIndiaTeamUserId;
			setOfIndiaTeamUserName = UserRc.setOfIndiaTeamUserName;
			setOfIndiaTeamUserEmail = UserRc.setOfIndiaTeamUserEmail;
			String getIndiaTeamPrimaryOwnerId = UserRc.getIndiaTeamPrimaryOwnerId;
	    	India_Team__c indiaTeamUserObj = UserRc.indiaTeamUserObj;
	    	//System.debug('#### India Team Primary Owner Id - '+UserRC.getIndiaTeamPrimaryOwnerId);
   		}
		
		static testMethod void getRCPARTNERSync(){
		Set<String> setOfRCPartnerUserId = new Set<String>();
		Set<String> setOfRCPartnerUserName = new Set<String>();
		Set<String> setOfRCPartnerUserEmail = new Set<String>();
		
		String usrName;
		String usrEmail;
		String usrId;
		Map<String, RCPARTNER_Sync__c> rcPartnerSyncConfigurationMap = RCPARTNER_Sync__c.getAll();
		
    	usrName = null;
		usrName = 'RCPARTNER Sync';
		usrEmail = 'bizserv.crm@ringcentral.com';
		RCPARTNER_Sync__c objRCPARTNERSync = new RCPARTNER_Sync__c();
		objRCPARTNERSync.First_Name__c = 'RCSF';
		objRCPARTNERSync.Last_Name__c = 'Sync';
		objRCPARTNERSync.Active__c = true;
		objRCPARTNERSync.Email__c = 'bizserv.crm@ringcentral.com';
		objRCPARTNERSync.Name = 'RCPARTNER Sync';
		insert objRCPARTNERSync;
    	UserRc.compareRCPartnerUserName(usrName);
    	UserRc.compareRCPartnerUserEmail(usrEmail);
    	
    	RCPARTNER_Sync__c rcPartnerSyncUserObj = UserRc.rcPartnerSyncUserObj;
		setOfRCPartnerUserId = UserRc.setOfRCPartnerUserId;
		setOfRCPartnerUserName = UserRc.setOfRCPartnerUserName;
		setOfRCPartnerUserEmail = UserRc.setOfRCPartnerUserEmail;
		String getRCPartnerPrimaryOwnerId = UserRc.getRCPartnerPrimaryOwnerId;
    //	System.debug('#### RC Partner Primary Owner Id - '+UserRC.getRCPartnerPrimaryOwnerId);
    	
		}
		
		static testMethod void getSpecificUser(){
		Set<String> setOfSpecificUserId = new Set<String>();
		Set<String> setOfSpecificUserName = new Set<string>();
		Set<String> setOfSpecificUserEmail = new Set<String>();
		String usrName;
		String usrEmail;
		String usrId;
    	usrName = null;
    	Map<String,Specific_User__c> specificUserConfigurationMap = Specific_User__c.getAll();
    	
		usrEmail = 'sunilm@ringcentral.com';
		usrName = 'Sunil Madan';
		Specific_User__c objSpecificUser = new Specific_User__c();
		objSpecificUser.Name = 'Sunil Madan';
		objSpecificUser.Email__c = 'sunilm@ringcentral.com';
		insert objSpecificUser;
    	UserRc.compareSpecificUserName(usrName);
    	UserRc.compareSpecificUserEmail(usrEmail);
    	
    	Sunil_Madan__c sunilMadanUserObj = UserRc.sunilMadanUserObj;
		setOfSpecificUserId = UserRc.setOfSpecificUserId;
		setOfSpecificUserName = UserRc.setOfSpecificUserName;
		setOfSpecificUserEmail = UserRc.setOfSpecificUserEmail;
		String getSpecificUserPrimaryOwnerId = UserRc.getSpecificUserPrimaryOwnerId;
		Specific_User__c specificUserObj = UserRc.specificUserObj;
    	//System.debug('#### Specific User Primary Owner Id - '+UserRC.getSpecificUserPrimaryOwnerId);
    	//System.debug('#### Specific User Primary Owner Id - '+UserRC.getSpecificUserPrimaryOwnerId);
		}
		
    	static testMethod void getId(){
		String usrName;
		String usrEmail;
		String usrId;
    	usrName = null;
    	Map<String, India_Team__c> indiaTeamUserConfigurationMap = India_Team__c.getAll();
    	Map<String, RCPARTNER_Sync__c> rcPartnerSyncConfigurationMap = RCPARTNER_Sync__c.getAll();
    	Map<String,Specific_User__c> specificUserConfigurationMap = Specific_User__c.getAll();
    	
    	UserRc.compareSpecificUserId( usrId);
    	UserRc.getZuoraSalesAgentProfile();
    	UserRc.compareRCPartnerUserId(usrId);
    	UserRc.compareUserId(usrId);
    	UserRc.compareIndiaTeamUserId(usrId);
    	UserRC objUserRc =  new UserRC();
     }
     
     static testMethod void newCustomSeetingCode(){
     	RCSF_Sync__c rcsfSync = new RCSF_Sync__c(Name='TestRCSF',Active__c=true,Email__c='test@test.com',id__c='1234',Is_Primary__c=true,Last_name__c='SYNC',
     												First_name__c='RCSF',Username__c='rcsfSync');
 		insert 	rcsfSync;
 		
 		India_Team__c indiaTeam = new India_Team__c(Name='TestIndia',Active__c=true,Email__c='test@test.com',id__c='1234',Is_Primary__c=true,Last_name__c='Team',
     												First_name__c='India',Username__c='IndiaTeam');
 		insert 	indiaTeam;
 		
 		RCPARTNER_Sync__c rcsfPartnerSync = new RCPARTNER_Sync__c(Name='TestRCSFPartner',Active__c=true,Email__c='test@test.com',id__c='1234',Is_Primary__c=true,Last_name__c='SYNC',
     												First_name__c='RCSFPartner',Username__c='rcsfSyncPartner');
 		insert 	rcsfPartnerSync;
 		
 		Sunil_Madan__c sunilMadan = new Sunil_Madan__c(Name='TestSunil',Active__c=true,Email__c='test@test.com',id__c='1234',Last_name__c='Sunil',
     												First_name__c='RCSFSunil',Username__c='Sunil');
 		insert 	sunilMadan;		
 		
 		Specific_User__c specificUser = new Specific_User__c(Name='TestSpecific',Active__c=true,Email__c='test@test.com',id__c='1234',Is_Primary__c=true,Last_name__c='Test',
     												First_name__c='Specific');
 		insert specificUser;
 		
 		RCSF_Sync__c rcsfSyncUserObj = UserRc.rcsfSyncUserObj;	
 		String str = UserRc.getRCSFSyncPrimaryOwnerId;
 		Set<String> strSet1 = UserRc.setOfRCSFUserId;
 		Set<String> strSet2 = UserRc.setOfRCSFName;	
 		Set<String> strSet3 = UserRc.setOfRCSFUserName;
 		Set<String> strSet4 = UserRc.setOfRCSFUserEmail;	
 		Boolean bol1 = UserRc.compareUserName('rcsfSync');
 		Boolean bol2 = UserRc.compareName('TestRCSF');
 		Boolean bol3 = UserRc.compareUserEmail('test@test.com');
 		Boolean bol4 = UserRc.compareUserId('1234');
 		
 		RCPARTNER_Sync__c rcsfPartnerSyncUserObj = UserRc.rcPartnerSyncUserObj;	
 		String str1 = UserRc.getRCPartnerPrimaryOwnerId;
 		Set<String> strSet5 = UserRc.setOfRCPartnerUserId;
 		Set<String> strSet20 = UserRc.setOfRCPartnerName;
 		Set<String> strSet6 = UserRc.setOfRCPartnerUserName;	
 		Set<String> strSet7 = UserRc.setOfRCPartnerUserEmail; 		
 		Boolean bol5 = UserRc.compareRCPartnerUserName('TestRCSFPartner');
 		Boolean bol6 = UserRc.compareRCPartnerUserEmail('test@test.com');
 		Boolean bol7 = UserRc.compareRCPartnerUserId('1234');
 		Boolean bol71 = UserRc.compareRCPartnerName('TestRCSFPartner');
 		
 		India_Team__c indiaTeamObj = UserRc.indiaTeamUserObj;	
 		String str3 = UserRc.getIndiaTeamPrimaryOwnerId;
 		Set<String> strSet8 = UserRc.setOfIndiaTeamUserId;
 		Set<String> strSet9 = UserRc.setOfIndiaTeamUserName;	
 		Set<String> strSet10 = UserRc.setOfIndiaTeamUserEmail; 
 		Set<String> strSet15 = UserRc.setOfIndiaTeamName; 		
 		Boolean bol8 = UserRc.compareIndiaTeamUserName('TestIndia');
 		Boolean bol9 = UserRc.compareIndiaTeamUserEmail('test@test.com');
 		Boolean bol10 = UserRc.compareIndiaTeamUserId('1234');
 		Boolean bol30 = UserRc.compareIndiaTeamName('TestIndia');
 		
 		Sunil_Madan__c sunilMadanObj = UserRc.sunilMadanUserObj;
 		Set<String> strSet25 = UserRC.setOfSunilMadanUserId;
 		Set<String> strSet26 = UserRc.setOfSunilMadanUserName;
 		Set<String> strSet27 = UserRc.setOfSunilMadanName;
 		Set<String> strSet28 = UserRc.setOfSunilMadanUserEmail;
 		Boolean bol40 = UserRc.compareSunilMadanUserName('Sunil');
 		Boolean bol41 = UserRc.compareSunilMadanUserEmail('test@test.com');
 		Boolean bol42 = UserRc.compareSunilMadanUserId('1234');
 		Boolean bol43 = UserRc.compareSunilMadanName('TestSunil');
 		
 		
 		Specific_User__c specificUserObj = UserRc.specificUserObj;	
 		String str4 = UserRc.getSpecificUserPrimaryOwnerId;
 		Set<String> strSet11 = UserRc.setOfSpecificUserId;
 		Set<String> strSet12 = UserRc.setOfIndiaTeamUserName;	
 		Set<String> strSet13 = UserRc.setOfSpecificUserEmail; 		
 		Boolean bol11 = UserRc.compareSpecificUserName('TestSpecific');
 		Boolean bol12 = UserRc.compareSpecificUserEmail('test@test.com');
 		Boolean bol13 = UserRc.compareSpecificUserId('1234');
 		
 		string testStr = UserRc.getZuoraSalesAgentProfile();	
 					
     }
     
     static testMethod void newCustomSeetingCode1(){
     	RCSF_Sync__c rcsfSyncUserObj = UserRc.rcsfSyncUserObj;	
 		String str = UserRc.getRCSFSyncPrimaryOwnerId;
 		Set<String> strSet1 = UserRc.setOfRCSFUserId;
 		Set<String> strSet2 = UserRc.setOfRCSFName;	
 		Set<String> strSet3 = UserRc.setOfRCSFUserName;
 		Set<String> strSet4 = UserRc.setOfRCSFUserEmail;	
 		Boolean bol1 = UserRc.compareUserName('rcsfSync');
 		Boolean bol2 = UserRc.compareName('TestRCSF');
 		Boolean bol3 = UserRc.compareUserEmail('test@test.com');
 		Boolean bol4 = UserRc.compareUserId('1234');
 		
 		RCPARTNER_Sync__c rcsfPartnerSyncUserObj = UserRc.rcPartnerSyncUserObj;	
 		String str1 = UserRc.getRCPartnerPrimaryOwnerId;
 		Set<String> strSet5 = UserRc.setOfRCPartnerUserId;
 		Set<String> strSet20 = UserRc.setOfRCPartnerName;
 		Set<String> strSet6 = UserRc.setOfRCPartnerUserName;	
 		Set<String> strSet7 = UserRc.setOfRCPartnerUserEmail; 		
 		Boolean bol5 = UserRc.compareRCPartnerUserName('TestRCSFPartner');
 		Boolean bol6 = UserRc.compareRCPartnerUserEmail('test@test.com');
 		Boolean bol7 = UserRc.compareRCPartnerUserId('1234');
 		Boolean bol71 = UserRc.compareRCPartnerName('TestRCSFPartner');
 		
 		India_Team__c indiaTeamObj = UserRc.indiaTeamUserObj;	
 		String str3 = UserRc.getIndiaTeamPrimaryOwnerId;
 		Set<String> strSet8 = UserRc.setOfIndiaTeamUserId;
 		Set<String> strSet9 = UserRc.setOfIndiaTeamUserName;	
 		Set<String> strSet10 = UserRc.setOfIndiaTeamUserEmail; 
 		Set<String> strSet15 = UserRc.setOfIndiaTeamName; 		
 		Boolean bol8 = UserRc.compareIndiaTeamUserName('TestIndia');
 		Boolean bol9 = UserRc.compareIndiaTeamUserEmail('test@test.com');
 		Boolean bol10 = UserRc.compareIndiaTeamUserId('1234');
 		Boolean bol30 = UserRc.compareIndiaTeamName('TestIndia');
 		
 		Sunil_Madan__c sunilMadanObj = UserRc.sunilMadanUserObj;
 		Set<String> strSet25 = UserRC.setOfSunilMadanUserId;
 		Set<String> strSet26 = UserRc.setOfSunilMadanUserName;
 		Set<String> strSet27 = UserRc.setOfSunilMadanName;
 		Set<String> strSet28 = UserRc.setOfSunilMadanUserEmail;
 		Boolean bol40 = UserRc.compareSunilMadanUserName('Sunil');
 		Boolean bol41 = UserRc.compareSunilMadanUserEmail('test@test.com');
 		Boolean bol42 = UserRc.compareSunilMadanUserId('1234');
 		Boolean bol43 = UserRc.compareSunilMadanName('TestSunil');
 		
 		
 		Specific_User__c specificUserObj = UserRc.specificUserObj;	
 		String str4 = UserRc.getSpecificUserPrimaryOwnerId;
 		Set<String> strSet11 = UserRc.setOfSpecificUserId;
 		Set<String> strSet12 = UserRc.setOfIndiaTeamUserName;	
 		Set<String> strSet13 = UserRc.setOfSpecificUserEmail; 		
 		Boolean bol11 = UserRc.compareSpecificUserName('TestSpecific');
 		Boolean bol12 = UserRc.compareSpecificUserEmail('test@test.com');
 		Boolean bol13 = UserRc.compareSpecificUserId('1234');
 		
 		UnsupportedObjectTypeException obj = new UnsupportedObjectTypeException();
     }
}