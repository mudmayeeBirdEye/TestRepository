global class ITHelpDeskBatch implements Database.Batchable<sObject>, Database.Stateful {
    set<Id> setContactIdWithPortalUser = new set<Id>();
    string profileId;
    public map<Id,Id> mapContactIdToUser;
    public ITHelpDeskBatch() {
        profileId = [SELECT Id FROM profile WHERE Name = 'IT Helpdesk Portal User' limit 1].id;
        mapContactIdToUser = new map<Id,Id>();
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        try {
            setContactIdWithPortalUser = new set<Id>();
            mapContactIdToUser = new map<Id,Id>();
            for(User userObj : [select id,contactId from User where Profile.Name = 'IT Helpdesk Portal User' and contactId != null]) { 
                setContactIdWithPortalUser.add(userObj.contactId);
                //mapContactIdToUser.put(userObj.ContactId,userObj.Id);
            }
            //System.debug('mapContactIdToUser'+ mapContactIdToUser);
            string strQuery = 'select id,firstname,lastname,email from contact where RecordType.Name = \'Internal Employee\' and ' +
                                                'Account.Name = \'RC Internal\' and email != null and lastname != null and ' +
                                            	' Id NOT IN :setContactIdWithPortalUser';
            //System.Debug('>>>12347>>>'+ strQuery);                                	
            return Database.getQueryLocator(strQuery);
        } catch(Exception ex) {
        	//system.Debug('>>ex>' + ex.getMessage());
        }
        return null;
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope) {
    	try {
          for(sObject sObj : scope) {
	          Contact contactObj = (Contact)sObj;   
	          createUser(contactObj);
	        }
         	if(Test.isRunningTest()) {
            	Integer intValue = 1/0;
            }
        } catch(Exception ex) {}
    }
    
    global void finish(Database.BatchableContext BC) {
        
    }
    
    private void createUser(Contact contactObj) {
    	try {
    		if(contactObj != null) {
	            Database.DMLOptions dmo = new Database.DMLOptions();
	            dmo.EmailHeader.triggerUserEmail = false;
	         	System.debug('>>>>1237>>'+ contactObj.id);
	            /*if(mapContactIdToUser != null && contactObj.id != null && mapContactIdToUser.containskey(contactObj.id)) {
	            	System.Debug('>>>Inside Update');
	            	User userObj = new User(id = mapContactIdToUser.get(contactObj.id));
	            	userObj.FirstName = !string.isBlank(contactObj.FirstName) ? contactObj.FirstName : '';
		            userObj.email = contactObj.email;
		            userObj.emailencodingkey = 'UTF-8';
		            userObj.lastname = contactObj.lastname;
		            userObj.languagelocalekey = 'en_US';
		            userObj.localesidkey = 'en_US';
		            userObj.profileid = profileId;
		            userObj.timezonesidkey = 'America/Los_Angeles';
		            //userObj.username = userObj.email + '.portal';
		         	userObj.communityNickname = (!string.isBlank(userObj.FirstName) ? userObj.FirstName.substring(0,1) : '')  +  (contactObj.LastName.length() > 33 ? contactObj.LastName.substring(0,33) : contactObj.LastName) + 'portal'; 
		            userObj.alias = (!string.isBlank(userObj.FirstName) ? userObj.FirstName.substring(0,1) : '') + (contactObj.LastName.length() > 4 ? contactObj.LastName.substring(0,4) : contactObj.LastName);
		            userObj.setOptions(dmo);
		            update userObj;
	            } else {*/
	            	User userObj = new User();
	            	userObj.FirstName = !string.isBlank(contactObj.FirstName) ? contactObj.FirstName : '';
		            userObj.email = contactObj.email;
		            userObj.emailencodingkey = 'UTF-8';
		            userObj.lastname = (contactObj.LastName.length() >= 75 ? contactObj.LastName.substring(0,75) : contactObj.lastname) + ' - IT';
		            userObj.languagelocalekey = 'en_US';
		            userObj.localesidkey = 'en_US';
		            userObj.profileid = profileId;
		            userObj.contactId = contactObj.Id;
		            userObj.timezonesidkey = 'America/Los_Angeles';
		            userObj.username = userObj.email + '.portal';
		            string strRandom = string.valueOf(Math.random()).substring(2,3);
		         	userObj.communityNickname = (!string.isBlank(userObj.FirstName) ? userObj.FirstName.substring(0,1) : '')  +  (contactObj.LastName.length() > 32 ? contactObj.LastName.substring(0,32) : contactObj.LastName) + strRandom + 'portal'; 
		            userObj.alias = (!string.isBlank(userObj.FirstName) ? userObj.FirstName.substring(0,1) : '') + (contactObj.LastName.length() > 4 ? contactObj.LastName.substring(0,4) : contactObj.LastName);
		            userObj.setOptions(dmo);
		            insert userObj;
	            //}
	        }
    	} catch(Exception ex) {
    		system.Debug('>>ex>' + ex.getMessage());
		}
        
	}
}