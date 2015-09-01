public class UserRC {
	/********************** RCSF Sync User **********************/
	public static RCSF_Sync__c rcsfSyncUserObj { 
		get {
        	Map<String, RCSF_Sync__c> rcSfSyncConfigurationMap = RCSF_Sync__c.getAll();
        	if(!rcSfSyncConfigurationMap.isEmpty()){
        		System.debug('rcSfSyncConfigurationMap is not emptyy::');
        		rcsfSyncUserObj =  rcSfSyncConfigurationMap.values().get(0);
        	}else {
        		System.debug('rcSfSyncConfigurationMap is empty');
        		rcsfSyncUserObj= new RCSF_Sync__c();
        	}
         	return rcsfSyncUserObj; 
         }
        private set;
    }
    // This method returns the ownerId of user. 
    public static String getRCSFSyncPrimaryOwnerId{
    	get{
    		Map<String, RCSF_Sync__c> rcSfSyncConfigurationMap = RCSF_Sync__c.getAll();
    		if(!rcSfSyncConfigurationMap.isEmpty()){
	        	for(String st:rcSfSyncConfigurationMap.keyset()){
	        		if(rcSfSyncConfigurationMap.get(st).Is_Primary__c){
	        			return rcSfSyncConfigurationMap.get(st).Id__c;
	        		}
	        	}
	        	return rcSfSyncConfigurationMap.values().get(0).Id__c;
    		}else{
    			return null; 
    		}
    	}
    	private set; 
    }
    
    public static Set<String> setOfRCSFUserId{
    	get{
    		Map<String, RCSF_Sync__c> rcSfSyncConfigurationMap = RCSF_Sync__c.getAll();
        	setOfRCSFUserId= new Set<String>();
        	if(!rcSfSyncConfigurationMap.isEmpty()){
	        	for(String st:rcSfSyncConfigurationMap.keyset()){
	        		setOfRCSFUserId.add(rcSfSyncConfigurationMap.get(st).Id__c);
	        	}
        	}
        	return setOfRCSFUserId;
    	}
    	private set;
    }
	public static Set<String> setOfRCSFName{
    	get{
            Map<String, RCSF_Sync__c> rcSfSyncConfigurationMap = RCSF_Sync__c.getAll();
            setOfRCSFName=new Set<String>();
            if(!rcSfSyncConfigurationMap.isEmpty()){
                for(String st:rcSfSyncConfigurationMap.keyset()){
                    setOfRCSFName.add(rcSfSyncConfigurationMap.get(st).name);
                }
            }
            return setOfRCSFName;
        }
        private set;
    }
    
    public static Set<String> setOfRCSFUserName{
    	get{
    		Map<String, RCSF_Sync__c> rcSfSyncConfigurationMap = RCSF_Sync__c.getAll();
    		setOfRCSFUserName=new Set<String>();
    		if(!rcSfSyncConfigurationMap.isEmpty()){
	        	for(String st:rcSfSyncConfigurationMap.keyset()){
	        		setOfRCSFUserName.add(rcSfSyncConfigurationMap.get(st).Username__c);
	        	}
    		}
        	return setOfRCSFUserName;
    	}
    	private set;
    }
    
    public static Set<String> setOfRCSFUserEmail{
    	get{
    		Map<String, RCSF_Sync__c> rcSfSyncConfigurationMap = RCSF_Sync__c.getAll();
    		setOfRCSFUserEmail=new Set<String>();
    		if(!rcSfSyncConfigurationMap.isEmpty()){
	        	for(String st:rcSfSyncConfigurationMap.keyset()){
	        		setOfRCSFUserEmail.add(rcSfSyncConfigurationMap.get(st).Email__c);
	        	}
    		}
        	return setOfRCSFUserEmail;
    	}
    	private set;
    }
    
    public static Boolean compareUserName(String usrName){
    	System.debug('usrName>>>>'+usrName);
    	Map<String, RCSF_Sync__c> rcSfSyncConfigurationMap = RCSF_Sync__c.getAll();
    	System.debug('rcSfSyncConfigurationMap~~~~~~~~~~~~~~~~~~~~~'+rcSfSyncConfigurationMap);
    	if(!rcSfSyncConfigurationMap.isEmpty()){
	    	for(String st:rcSfSyncConfigurationMap.keyset()){
	    		if( usrName.equalsIgnoreCase(rcSfSyncConfigurationMap.get(st).Username__c)){
	    			system.debug('&&&&&&'+rcSfSyncConfigurationMap);
	    			return true;
	    			
	    		}
	    	}
    	}
    	return false; 
    }
	public static Boolean compareName(String name){
    	Map<String, RCSF_Sync__c> rcSfSyncConfigurationMap = RCSF_Sync__c.getAll();
        if(!rcSfSyncConfigurationMap.isEmpty()){
            for(String st:rcSfSyncConfigurationMap.keyset()){
                if( name.equalsIgnoreCase(rcSfSyncConfigurationMap.get(st).name)){
                    return true;
                    system.debug('&&&&&&'+rcSfSyncConfigurationMap);
                }
            }
        }
        return false; 
    }
    
     public static Boolean compareUserEmail(String usrEmail){
     	System.debug('usrEmail>>>'+usrEmail);
    	Map<String, RCSF_Sync__c> rcSfSyncConfigurationMap = RCSF_Sync__c.getAll();
    	System.debug('rcSfSyncConfigurationMap>>'+rcSfSyncConfigurationMap);
    	if(!rcSfSyncConfigurationMap.isEmpty()){
	    	for(String st:rcSfSyncConfigurationMap.keyset()){
	    		if(usrEmail.equalsIgnoreCase(rcSfSyncConfigurationMap.get(st).Email__c)){
	    			return true;
	    		}
	    	}
    	}
    	return false; 
    }
    
     public static Boolean compareUserId(String usrId){
     	System.debug('usrId>>>'+usrId);
    	Map<String, RCSF_Sync__c> rcSfSyncConfigurationMap = RCSF_Sync__c.getAll();
    	System.debug('rcSfSyncConfigurationMap>>'+rcSfSyncConfigurationMap);
    	if(!rcSfSyncConfigurationMap.isEmpty()){
	    	for(String st:rcSfSyncConfigurationMap.keyset()){
	    		if(usrId.equalsIgnoreCase(rcSfSyncConfigurationMap.get(st).Id__c)){
	    			return true;
	    		}
	    	}
    	}
    	return false; 
    }
 /************************  RC Partner User ******************/   
    public static RCPARTNER_Sync__c rcPartnerSyncUserObj { 
		get {
        	Map<String, RCPARTNER_Sync__c> rcPartnerSyncConfigurationMap = RCPARTNER_Sync__c.getAll();
        	if(!rcPartnerSyncConfigurationMap.isEmpty()){
	        	rcPartnerSyncUserObj =  rcPartnerSyncConfigurationMap.values().get(0);
	         	return rcPartnerSyncUserObj; 
        	}else {
        		rcPartnerSyncUserObj= new RCPARTNER_Sync__c();
        		return rcPartnerSyncUserObj;
        	}
         }
        private set;
    } 
    
    // This method returns the ownerId of user. 
    public static String getRCPartnerPrimaryOwnerId{
    	get{
    		Map<String, RCPARTNER_Sync__c> rcPartnerSyncConfigurationMap = RCPARTNER_Sync__c.getAll();
        	if(!rcPartnerSyncConfigurationMap.isEmpty()){
	        	for(String st:rcPartnerSyncConfigurationMap.keyset()){
	        		if(rcPartnerSyncConfigurationMap.get(st).Is_Primary__c){
	        			return rcPartnerSyncConfigurationMap.get(st).Id__c;
	        		}
	        	}
	        	return rcPartnerSyncConfigurationMap.values().get(0).Id__c;
        	}else{
        		return null; 
        	}
    	}
    	private set; 
    }
    
    public static Set<String> setOfRCPartnerUserId{
    	get{
    		Map<String, RCPARTNER_Sync__c> rcPartnerSyncConfigurationMap = RCPARTNER_Sync__c.getAll();
        	setOfRCPartnerUserId= new Set<String>();
        	if(!rcPartnerSyncConfigurationMap.isEmpty()){
	        	for(String st:rcPartnerSyncConfigurationMap.keyset()){
	        		setOfRCPartnerUserId.add(rcPartnerSyncConfigurationMap.get(st).Id__c);
	        	}
        	}
        	return setOfRCPartnerUserId;
    	}
    	private set;
    }
    
    public static Set<String> setOfRCPartnerUserName{
    	get{
    		Map<String, RCPARTNER_Sync__c> rcPartnerSyncConfigurationMap = RCPARTNER_Sync__c.getAll();
    		setOfRCPartnerUserName=new Set<String>();
        	if(!rcPartnerSyncConfigurationMap.isEmpty()){
	        	for(String st:rcPartnerSyncConfigurationMap.keyset()){
	        		setOfRCPartnerUserName.add(rcPartnerSyncConfigurationMap.get(st).Username__c);
	        	}
        	}
        	return setOfRCPartnerUserName;
    	}
    	private set;
    }
    public static Set<String> setOfRCPartnerName{
        get{
            Map<String, RCPARTNER_Sync__c> rcPartnerSyncConfigurationMap = RCPARTNER_Sync__c.getAll();
            setOfRCPartnerName=new Set<String>();
            if(!rcPartnerSyncConfigurationMap.isEmpty()){
                for(String st:rcPartnerSyncConfigurationMap.keyset()){
                    setOfRCPartnerName.add(rcPartnerSyncConfigurationMap.get(st).name);
                }
            }
            return setOfRCPartnerUserName;
        }
        private set;
    }
    
    public static Set<String> setOfRCPartnerUserEmail{
    	get{
    		Map<String, RCPARTNER_Sync__c> rcPartnerSyncConfigurationMap = RCPARTNER_Sync__c.getAll();
    		setOfRCPartnerUserEmail=new Set<String>();
    		if(!rcPartnerSyncConfigurationMap.isEmpty()){
	        	for(String st:rcPartnerSyncConfigurationMap.keyset()){
	        		setOfRCPartnerUserEmail.add(rcPartnerSyncConfigurationMap.get(st).Email__c);
	        	}
    		}
        	return setOfRCPartnerUserEmail;
    	}
    	private set;
    }
    
    public static Boolean compareRCPartnerUserName(String usrName){
    	Map<String, RCPARTNER_Sync__c> rcPartnerSyncConfigurationMap = RCPARTNER_Sync__c.getAll();
    	if(!rcPartnerSyncConfigurationMap.isEmpty()){
	    	for(String st:rcPartnerSyncConfigurationMap.keyset()){
	    		if( usrName.equalsIgnoreCase(rcPartnerSyncConfigurationMap.get(st).Username__c)){
	    			return true;
	    		}
	    	}
    	}
    	return false; 
    }
	public static Boolean compareRCPartnerName(String name){
        Map<String, RCPARTNER_Sync__c> rcPartnerSyncConfigurationMap = RCPARTNER_Sync__c.getAll();
        if(!rcPartnerSyncConfigurationMap.isEmpty()){
            for(String st:rcPartnerSyncConfigurationMap.keyset()){
                if( name.equalsIgnoreCase(rcPartnerSyncConfigurationMap.get(st).name)){
                    return true;
                }
            }
        }
        return false; 
    }
    
     public static Boolean compareRCPartnerUserEmail(String usrEmail){
    	Map<String, RCPARTNER_Sync__c> rcPartnerSyncConfigurationMap = RCPARTNER_Sync__c.getAll();
    	if(!rcPartnerSyncConfigurationMap.isEmpty()){
	    	for(String st:rcPartnerSyncConfigurationMap.keyset()){
	    		if(usrEmail.equalsIgnoreCase(rcPartnerSyncConfigurationMap.get(st).Email__c)){
	    			return true;
	    		}
	    	}
    	}
    	return false; 
    }
    
     public static Boolean compareRCPartnerUserId(String usrId){
    	Map<String, RCPARTNER_Sync__c> rcPartnerSyncConfigurationMap = RCPARTNER_Sync__c.getAll();
    	if(!rcPartnerSyncConfigurationMap.isEmpty()){
	    	for(String st:rcPartnerSyncConfigurationMap.keyset()){
	    		if(usrId.equalsIgnoreCase(rcPartnerSyncConfigurationMap.get(st).Id__c)){
	    			return true;
	    		}
	    	}
    	}
    	return false; 
    }
    
  /**********************Indian Team User **********************/  
    public static India_Team__c indiaTeamUserObj { 
		get {
        	Map<String, India_Team__c> indiaTeamUserConfigurationMap = India_Team__c.getAll();
        	if(!indiaTeamUserConfigurationMap.isEmpty()){
	        	indiaTeamUserObj =  indiaTeamUserConfigurationMap.values().get(0);
	         	return indiaTeamUserObj; 
        	}else {
        		indiaTeamUserObj= new India_Team__c();
        		return indiaTeamUserObj;
        	}
         }
        private set;
    } 
    
     // This method returns the ownerId of user. 
    public static String getIndiaTeamPrimaryOwnerId{
    	get{
    		Map<String, India_Team__c> indiaTeamConfigurationMap = India_Team__c.getAll();
        	if(!indiaTeamConfigurationMap.isEmpty()){
	        	for(String st:indiaTeamConfigurationMap.keyset()){
	        		if(indiaTeamConfigurationMap.get(st).Is_Primary__c){
	        			return indiaTeamConfigurationMap.get(st).Id__c;
	        		}
	        	}
	        	return indiaTeamConfigurationMap.values().get(0).Id__c;
        	}else {
        		return null;
        	}
    	}
    	private set; 
    }
    
    public static Set<String> setOfIndiaTeamUserId{
    	get{
    		Map<String, India_Team__c> indiaTeamConfigurationMap = India_Team__c.getAll();
        	setOfIndiaTeamUserId= new Set<String>();
        	if(!indiaTeamConfigurationMap.isEmpty()){
	        	for(String st:indiaTeamConfigurationMap.keyset()){
	        		setOfIndiaTeamUserId.add(indiaTeamConfigurationMap.get(st).Id__c);
	        	}
        	}
        	return setOfIndiaTeamUserId;
    	}
    	private set;
    }
    
    public static Set<String> setOfIndiaTeamUserName{
    	get{
    		Map<String, India_Team__c> indiaTeamConfigurationMap = India_Team__c.getAll();
    		setOfIndiaTeamUserName=new Set<String>();
    		if(!indiaTeamConfigurationMap.isEmpty()){
	        	for(String st:indiaTeamConfigurationMap.keyset()){
	        		setOfIndiaTeamUserName.add(indiaTeamConfigurationMap.get(st).Username__c);
	        	}
    		}
        	return setOfIndiaTeamUserName;
    	}
    	private set;
    }
    public static Set<String> setOfIndiaTeamName{
        get{
            Map<String, India_Team__c> indiaTeamConfigurationMap = India_Team__c.getAll();
            setOfIndiaTeamName=new Set<String>();
            if(!indiaTeamConfigurationMap.isEmpty()){
                for(String st:indiaTeamConfigurationMap.keyset()){
                    setOfIndiaTeamName.add(indiaTeamConfigurationMap.get(st).name);
                }
            }
            return setOfIndiaTeamName;
        }
        private set;
    }
    public static Set<String> setOfIndiaTeamUserEmail{
    	get{
    		Map<String, India_Team__c> indiaTeamConfigurationMap = India_Team__c.getAll();
    		setOfIndiaTeamUserEmail=new Set<String>();
    		if(!indiaTeamConfigurationMap.isEmpty()){
	        	for(String st:indiaTeamConfigurationMap.keyset()){
	        		setOfIndiaTeamUserEmail.add(indiaTeamConfigurationMap.get(st).Email__c);
	        	}
    		}
        	return setOfIndiaTeamUserEmail;
    	}
    	private set;
    }
    
    public static Boolean compareIndiaTeamUserName(String usrName){
    	Map<String, India_Team__c> indiaTeamConfigurationMap = India_Team__c.getAll();
    	if(!indiaTeamConfigurationMap.isEmpty()){
	    	for(String st:indiaTeamConfigurationMap.keyset()){
	    		if( usrName.equalsIgnoreCase(indiaTeamConfigurationMap.get(st).Username__c)){
	    			return true;
	    		}
	    	}
    	}
    	return false; 
    }
    public static Boolean compareIndiaTeamName(String name){
        Map<String, India_Team__c> indiaTeamConfigurationMap = India_Team__c.getAll();
        if(!indiaTeamConfigurationMap.isEmpty()){
            for(String st:indiaTeamConfigurationMap.keyset()){
                if( name.equalsIgnoreCase(indiaTeamConfigurationMap.get(st).name)){
                    return true;
                }
            }
        }
        return false; 
    }
    
     public static Boolean compareIndiaTeamUserEmail(String usrEmail){
    	Map<String, India_Team__c> indiaTeamConfigurationMap = India_Team__c.getAll();
    	if(!indiaTeamConfigurationMap.isEmpty()){
	    	for(String st:indiaTeamConfigurationMap.keyset()){
	    		if(usrEmail.equalsIgnoreCase(indiaTeamConfigurationMap.get(st).Email__c)){
	    			return true;
	    		}
	    	}
    	}
    	return false; 
    }
    
     public static Boolean compareIndiaTeamUserId(String usrId){
    	Map<String, India_Team__c> indiaTeamConfigurationMap = India_Team__c.getAll();
    	if(!indiaTeamConfigurationMap.isEmpty()){
	    	for(String st:indiaTeamConfigurationMap.keyset()){
	    		if(usrId.equalsIgnoreCase(indiaTeamConfigurationMap.get(st).Id__c)){
	    			return true;
	    		}
	    	}
    	}
    	return false; 
    }
   /**********************Sunil Madan User **********************/ 
    public static Sunil_Madan__c sunilMadanUserObj { 
		get {
        	Map<String,Sunil_Madan__c> sunilMadanUserConfigurationMap = Sunil_Madan__c.getAll();
        	if(!sunilMadanUserConfigurationMap.isEmpty()){
	        	sunilMadanUserObj =  sunilMadanUserConfigurationMap.values().get(0);
	         	return sunilMadanUserObj; 
        	}else {
        		sunilMadanUserObj=new Sunil_Madan__c();
        		return sunilMadanUserObj;
        	}
         }
        private set;
    }
    public static Set<String> setOfSunilMadanUserId{
        get{
            Map<String, Sunil_Madan__c> sunilMadanConfigurationMap = Sunil_Madan__c.getAll();
            setOfSunilMadanUserId= new Set<String>();
            if(!sunilMadanConfigurationMap.isEmpty()){
                for(String st:sunilMadanConfigurationMap.keyset()){
                    setOfSunilMadanUserId.add(sunilMadanConfigurationMap.get(st).Id__c);
                }
            }
            return setOfSunilMadanUserId;
        }
        private set;
    }
    
    public static Set<String> setOfSunilMadanUserName{
        get{
            Map<String, Sunil_Madan__c> sunilMadanConfigurationMap = Sunil_Madan__c.getAll();
            setOfSunilMadanUserName=new Set<String>();
            if(!sunilMadanConfigurationMap.isEmpty()){
                for(String st:sunilMadanConfigurationMap.keyset()){ 
                    setOfSunilMadanUserName.add(sunilMadanConfigurationMap.get(st).Username__c);
                }
            }
            return setOfSunilMadanUserName;
        }
        private set;
    }
    
    public static Set<String> setOfSunilMadanName{
        get{
            Map<String, Sunil_Madan__c> sunilMadanConfigurationMap = Sunil_Madan__c.getAll();
            setOfSunilMadanName=new Set<String>();
            if(!sunilMadanConfigurationMap.isEmpty()){
                for(String st:sunilMadanConfigurationMap.keyset()){
                    setOfSunilMadanName.add(sunilMadanConfigurationMap.get(st).name);
                }
            }
            return setOfSunilMadanName;
        }
        private set;
    }
    
    public static Set<String> setOfSunilMadanUserEmail{
        get{
            Map<String, Sunil_Madan__c> sunilMadanConfigurationMap = Sunil_Madan__c.getAll();
            setOfSunilMadanUserEmail=new Set<String>();
            if(!sunilMadanConfigurationMap.isEmpty()){
                for(String st:sunilMadanConfigurationMap.keyset()){
                    setOfSunilMadanUserEmail.add(sunilMadanConfigurationMap.get(st).Email__c);
                }
            }
            return setOfSunilMadanUserEmail;
        }
        private set;
    }
    
    public static Boolean compareSunilMadanUserName(String usrName){
        Map<String, Sunil_Madan__c> sunilMadanConfigurationMap = Sunil_Madan__c.getAll();
        if(!sunilMadanConfigurationMap.isEmpty()){
            for(String st:sunilMadanConfigurationMap.keyset()){
                if( usrName.equalsIgnoreCase(sunilMadanConfigurationMap.get(st).Username__c)){
                    return true;
                }
            }
        }
        return false; 
    }
    
    public static Boolean compareSunilMadanName(String name){
        Map<String, Sunil_Madan__c> sunilMadanConfigurationMap = Sunil_Madan__c.getAll();
        if(!sunilMadanConfigurationMap.isEmpty()){
            for(String st:sunilMadanConfigurationMap.keyset()){
                if( name.equalsIgnoreCase(sunilMadanConfigurationMap.get(st).name)){
                    return true;
                }
            }
        }
        return false; 
    }
    
     public static Boolean compareSunilMadanUserEmail(String usrEmail){
        Map<String, Sunil_Madan__c> sunilMadanConfigurationMap = Sunil_Madan__c.getAll();
        if(!sunilMadanConfigurationMap.isEmpty()){
            for(String st:sunilMadanConfigurationMap.keyset()){
                if(usrEmail.equalsIgnoreCase(sunilMadanConfigurationMap.get(st).Email__c)){
                    return true;
                }
            }
        }
        return false; 
    }
    
     public static Boolean compareSunilMadanUserId(String usrId){
        Map<String, Sunil_Madan__c> sunilMadanConfigurationMap = Sunil_Madan__c.getAll();
        if(!sunilMadanConfigurationMap.isEmpty()){
            for(String st:sunilMadanConfigurationMap.keyset()){
                if(usrId.equalsIgnoreCase(sunilMadanConfigurationMap.get(st).Id__c)){
                    return true;
                }
            }
        }
        return false; 
    }
    
    /*********************** Specific User ***************************/ 
    
    public static Specific_User__c specificUserObj { 
		get {
        	Map<String,Specific_User__c> specificUserConfigurationMap = Specific_User__c.getAll();
        	if(!specificUserConfigurationMap.isEmpty()){
	        	specificUserObj =  specificUserConfigurationMap.values().get(0);
	         	return specificUserObj; 
        	}else {
        		specificUserObj= new Specific_User__c();
        		return specificUserObj;
        	}
         }
        private set;
    }
    
    // This method returns the ownerId of user. 
    public static String getSpecificUserPrimaryOwnerId{
    	get{
    		Map<String, Specific_User__c> specificUserConfigurationMap = Specific_User__c.getAll();
        	if(!specificUserConfigurationMap.isEmpty()){
	        	for(String st:specificUserConfigurationMap.keyset()){
	        		if(specificUserConfigurationMap.get(st).Is_Primary__c){
	        			return specificUserConfigurationMap.get(st).Id__c;
	        		}
	        	}
	        	return specificUserConfigurationMap.values().get(0).Id__c;
        	}else{
        		return null;
        	}
    	}
    	private set; 
    }
    
    public static Set<String> setOfSpecificUserId{
    	get{
    		Map<String, Specific_User__c> specificUserConfigurationMap = Specific_User__c.getAll();
        	setOfSpecificUserId= new Set<String>();
        	if(!specificUserConfigurationMap.isEmpty()){
	        	for(String st:specificUserConfigurationMap.keyset()){
	        		setOfSpecificUserId.add(specificUserConfigurationMap.get(st).Id__c);
	        	}
        	}
        	return setOfIndiaTeamUserId;
    	}
    	private set;
    }
    
    public static Set<String> setOfSpecificUserName{
    	get{
    		Map<String, Specific_User__c> specificUserConfigurationMap = Specific_User__c.getAll();
    		setOfSpecificUserName=new Set<String>();
        	if(!specificUserConfigurationMap.isEmpty()){
	        	for(String st:specificUserConfigurationMap.keyset()){
	        		setOfSpecificUserName.add(specificUserConfigurationMap.get(st).name);
	        	}
        	}
        	return setOfSpecificUserName;
    	}
    	private set;
    }
    
    public static Set<String> setOfSpecificUserEmail{
    	get{
    		Map<String, Specific_User__c> specificUserConfigurationMap = Specific_User__c.getAll();
    		setOfSpecificUserEmail=new Set<String>();
    		if(!specificUserConfigurationMap.isEmpty()){
	        	for(String st:specificUserConfigurationMap.keyset()){
	        		setOfSpecificUserEmail.add(specificUserConfigurationMap.get(st).Email__c);
	        	}
    		}
        	return setOfSpecificUserEmail;
    	}
    	private set;
    }
     
    public static Boolean compareSpecificUserName(String usrName){
    	Map<String, Specific_User__c> specificUserConfigurationMap = Specific_User__c.getAll();
    	if(!specificUserConfigurationMap.isEmpty()){
	    	for(String st:specificUserConfigurationMap.keyset()){
	    		if( usrName.equalsIgnoreCase(specificUserConfigurationMap.get(st).Email__c)){
	    			return true;
	    		}
	    	}
    	}
    	return false; 
    }
    
     public static Boolean compareSpecificUserEmail(String usrEmail){
    	Map<String, Specific_User__c> specificUserConfigurationMap = Specific_User__c.getAll();
    	if(!specificUserConfigurationMap.isEmpty()){
	    	for(String st:specificUserConfigurationMap.keyset()){
	    		if(usrEmail.equalsIgnoreCase(specificUserConfigurationMap.get(st).Email__c)){
	    			return true;
	    		}
	    	}
    	}
    	return false; 
    }
    
     public static Boolean compareSpecificUserId(String usrId){
    	Map<String, Specific_User__c> specificUserConfigurationMap = Specific_User__c.getAll();
    	if(!specificUserConfigurationMap.isEmpty()){
	    	for(String st:specificUserConfigurationMap.keyset()){
	    		if(usrId.equalsIgnoreCase(specificUserConfigurationMap.get(st).Id__c)){
	    			return true;
	    		}
	    	}
    	}
    	return false; 
    }
    /********************* Returns the profile name for Zuora Sales Agent ********************************/
    public static string getZuoraSalesAgentProfile(){
    	String pName = System.Label.Sales_Agent_zQuote_Profile;
    	return (pName != '' && pName != null ? pName : '' );
    }
}