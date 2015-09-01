public class CampaignAssignmentHelper {
	public static String PARTNER_CAMPAIGN_NAME = 'Partner Lead Campaign';
	public static Map<String, Campaign> findCampaings(List<CampaignWrapper> campaignWrapperList) {
        Map<String, Campaign> criteriaToCamapaignMap = new Map<String, Campaign>(); 
    	Set<String> aidSet = new Set<String>();
    	Set<String> pidSet = new Set<String>();
    	Set<String> bmidSet = new Set<String>();
    	Set<String> partnerLead = new Set<String>();  
    	
    	Boolean IS_PARTNER_LEADAvailable = false;
    	Set<String> associatedCampIds = new Set<String>();
    	for(CampaignWrapper wrapperObj : campaignWrapperList) {
            if(wrapperObj.CAM_AID != '' && wrapperObj.CAM_AID != null) {
                aidSet.add(wrapperObj.CAM_AID);
            }
            if(wrapperObj.CAM_PID != '' && wrapperObj.CAM_PID != null) {
                pidSet.add(wrapperObj.CAM_PID);
            }
            if(wrapperObj.CAM_BMID != '' && wrapperObj.CAM_BMID != null) {
                bmidSet.add(wrapperObj.CAM_BMID);
            }
            if(wrapperObj.IS_PARTNER_LEAD) {
                IS_PARTNER_LEADAvailable = true;
                partnerLead.add(PARTNER_CAMPAIGN_NAME);
            }
            if(wrapperObj.CAM_PRIMARY != null) {
	         	associatedCampIds.add(wrapperObj.CAM_PRIMARY);
	        }
        }
        String conditionStr = '';
        if(bmidSet.size() != 0) {
        	conditionStr += (conditionStr != '' ? ' OR ' : '') + ' (BMID__c != null AND BMID__c IN:bmidSet)';
        }
        if(pidSet.size() != 0) {
        	conditionStr += (conditionStr != '' ? ' OR ' : '') + ' (PID__c != null AND PID__c IN:pidSet)';
        }
        if(aidSet.size() != 0) {
        	conditionStr += (conditionStr != '' ? ' OR ' : '') + ' (AID__c != null AND AID__c IN:aidSet)';
        }
        if(IS_PARTNER_LEADAvailable == true) {
           conditionStr += (conditionStr != '' ? ' OR ' : '') + ' (Name=\''+ PARTNER_CAMPAIGN_NAME+'\')';
        } 
        if(associatedCampIds.size() != 0) {
        	conditionStr += (conditionStr != '' ? ' OR ' : '') + ' (Id IN:associatedCampIds)';
        }
        if(conditionStr != '') {
        	conditionStr = ' WHERE (' + conditionStr;
        	conditionStr += ' OR Name=\'Default Campaign\' ) AND IsActive = true';
        } else {
        	conditionStr = ' WHERE Name=\'Default Campaign\'  AND IsActive = true ';  
        }
        String query = 'SELECT Id, type,Lead_Creation_Score__c, Lead_Entry_Source__c, AID__c, PID__c, BMID__c, DNIS__c, Team__c, NumberOfLeads, Lead_Score__c, Name FROM Campaign ' + conditionStr + ' ORDER BY LastModifiedDate ASC';
        System.debug('### QUERY: '+query);
        try {               
        	String names = '';            
            List<Campaign> campaignList = Database.query(query);
            for(Campaign campObj : campaignList) {
            	if(campObj.Name == PARTNER_CAMPAIGN_NAME) {
            		String key = ignoreCase(PARTNER_CAMPAIGN_NAME);
            		criteriaToCamapaignMap.put(key, campObj);
            	}
            	if(campObj.Name == 'Default Campaign') {
            		// criteriaToCamapaignMap.put('DEFAULT_CAMPAIGN', campObj);
            		String key = ignoreCase('DEFAULT_CAMPAIGN');
            		criteriaToCamapaignMap.put(key, campObj);
            	}
            	/** CREATING BMID/PID/AID BASED CAMPAIGN SEARCH **/
            	if(!String.isBlank(campObj.BMID__c) && !String.isBlank(campObj.PID__c) && !String.isBlank(campObj.AID__c)) {
            		//criteriaToCamapaignMap.put(campObj.BMID__c+'-'+campObj.PID__c+'-'+campObj.AID__c, campObj);
            		String key = ignoreCase(campObj.BMID__c+'-'+campObj.PID__c+'-'+campObj.AID__c);
            		criteriaToCamapaignMap.put(key, campObj);
            	}
            	if(!String.isBlank(campObj.BMID__c) && !String.isBlank(campObj.PID__c) ) {
            		//criteriaToCamapaignMap.put(campObj.BMID__c+'-'+campObj.PID__c, campObj);
            		String key = ignoreCase(campObj.BMID__c+'-'+campObj.PID__c);
            		criteriaToCamapaignMap.put(key, campObj);
            	}
            	if(!String.isBlank(campObj.BMID__c)) {
            		// criteriaToCamapaignMap.put(campObj.BMID__c, campObj);
            		String key = ignoreCase(campObj.BMID__c);
            		criteriaToCamapaignMap.put(key, campObj);
            	} 
            	names += '{Name= '+campObj.Name + ',Id= ' + campObj.Id + '}, ';
            	// criteriaToCamapaignMap.put((String)campObj.Id, campObj);
            	String key = ignoreCase((String)campObj.Id);
            	criteriaToCamapaignMap.put(key, campObj);
            }
            System.debug('## CAMPAIGNS FOUND = [ '+names+' ]');
            // leadList[0].addError('## campaigns = ' + names);
        } catch(Exception e) {
           //  leadList.get(0).addError(e);
            // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getStackTraceString()));
        } 
        return criteriaToCamapaignMap;
	}
	
	//New Combination Search Code for BMID,PID,AID and DNIS.
	public static Map<String, Campaign> findCampaingsLogic(List<CampaignWrapper> campaignWrapperList) {
        Map<String, Campaign> criteriaToCamapaignMap = new Map<String, Campaign>(); 
    	Set<String> aidSet = new Set<String>();
    	Set<String> pidSet = new Set<String>();
    	Set<String> bmidSet = new Set<String>();
    	Set<String> dnisSet = new Set<String>();
    	Set<String> partnerLead = new Set<String>();    	
    	Boolean IS_PARTNER_LEADAvailable = false;
    	Set<String> associatedCampIds = new Set<String>();
    	for(CampaignWrapper wrapperObj : campaignWrapperList) {
            if(wrapperObj.CAM_AID != '' && wrapperObj.CAM_AID != null) {
                aidSet.add(wrapperObj.CAM_AID);
            }
            if(wrapperObj.CAM_PID != '' && wrapperObj.CAM_PID != null) {
                pidSet.add(wrapperObj.CAM_PID);
            }
            if(wrapperObj.CAM_BMID != '' && wrapperObj.CAM_BMID != null) {
                bmidSet.add(wrapperObj.CAM_BMID);
            }
            if(wrapperObj.CAM_DNIS != '' && wrapperObj.CAM_DNIS != null) {
                dnisSet.add(wrapperObj.CAM_DNIS);
            }
            if(wrapperObj.IS_PARTNER_LEAD) {
                IS_PARTNER_LEADAvailable = true;
                partnerLead.add(PARTNER_CAMPAIGN_NAME);
            }
            /*if(wrapperObj.CAM_PRIMARY != null) {
	         	associatedCampIds.add(wrapperObj.CAM_PRIMARY);
	        }*/
        }
        String conditionStr = '';
        if(bmidSet.size() != 0) {
        	conditionStr += (conditionStr != '' ? ' OR ' : '') + ' (BMID__c != null AND BMID__c IN:bmidSet)';
        }
        if(pidSet.size() != 0) {
        	conditionStr += (conditionStr != '' ? ' OR ' : '') + ' (PID__c != null AND PID__c IN:pidSet)';
        }
        if(aidSet.size() != 0) {
        	conditionStr += (conditionStr != '' ? ' OR ' : '') + ' (AID__c != null AND AID__c IN:aidSet)';
        }
        if(dnisSet.size() != 0) {
        	conditionStr += (conditionStr != '' ? ' OR ' : '') + ' (DNIS__c != null AND DNIS__c IN:dnisSet)';
        }
        if(IS_PARTNER_LEADAvailable == true) {
           conditionStr += (conditionStr != '' ? ' OR ' : '') + ' (Name=\''+ PARTNER_CAMPAIGN_NAME+'\')';
        } 
        /*if(associatedCampIds.size() != 0) {
        	conditionStr += (conditionStr != '' ? ' OR ' : '') + ' (Id IN:associatedCampIds)';
        }
        if(conditionStr != '') {
        	conditionStr = ' WHERE (' + conditionStr;
        	conditionStr += ' OR Name=\'Default Campaign\' ) AND IsActive = true';
        } else {
        	conditionStr = ' WHERE Name=\'Default Campaign\'  AND IsActive = true ';  
        }*/
        //String query = 'SELECT Id, Lead_Creation_Score__c, Lead_Entry_Source__c, AID__c, PID__c, BMID__c, DNIS__c, Team__c, NumberOfLeads, Lead_Score__c, Name FROM Campaign WHERE ' + conditionStr + ' ORDER BY LastModifiedDate ASC';
        String query = 'SELECT Id, type,Lead_Creation_Score__c, Lead_Entry_Source__c, AID__c, PID__c, BMID__c, DNIS__c, Team__c, NumberOfLeads, Lead_Score__c, Name FROM Campaign ';
        if(!string.isBlank(conditionStr)){
        	query+= ' WHERE ' + conditionStr + ' ORDER BY LastModifiedDate ASC ';
        } else {
        	query+= ' ORDER BY LastModifiedDate ASC ';
        } 
        System.debug('### QUERY: '+query);
        try {               
        	String names = '';            
            List<Campaign> campaignList = Database.query(query);
            for(Campaign campObj : campaignList) {
            	if(campObj.Name == PARTNER_CAMPAIGN_NAME) {
            		String key = ignoreCase(PARTNER_CAMPAIGN_NAME);
            		criteriaToCamapaignMap.put(key, campObj);
            	}
            	/*if(campObj.Name == 'Default Campaign') {
            		// criteriaToCamapaignMap.put('DEFAULT_CAMPAIGN', campObj);
            		String key = ignoreCase('DEFAULT_CAMPAIGN');
            		criteriaToCamapaignMap.put(key, campObj);
            	}*/
            	/** CREATING BMID/PID/AID BASED CAMPAIGN SEARCH **/
            	if(!String.isBlank(campObj.DNIS__c)) {
            		//criteriaToCamapaignMap.put(campObj.BMID__c+'-'+campObj.PID__c+'-'+campObj.AID__c, campObj);
            		String key = ignoreCase(campObj.DNIS__c);
            		criteriaToCamapaignMap.put(key, campObj);
            	}
            	if(!String.isBlank(campObj.BMID__c) && !String.isBlank(campObj.PID__c) && !String.isBlank(campObj.AID__c)) {
            		//criteriaToCamapaignMap.put(campObj.BMID__c+'-'+campObj.PID__c+'-'+campObj.AID__c, campObj);
            		String key = ignoreCase(campObj.BMID__c+'-'+campObj.PID__c+'-'+campObj.AID__c);
            		criteriaToCamapaignMap.put(key, campObj);
            	}
            	if(!String.isBlank(campObj.BMID__c) && !String.isBlank(campObj.PID__c) ) {
            		//criteriaToCamapaignMap.put(campObj.BMID__c+'-'+campObj.PID__c, campObj);
            		String key = ignoreCase(campObj.BMID__c+'-'+campObj.PID__c);
            		criteriaToCamapaignMap.put(key, campObj);
            	}
            	if(!String.isBlank(campObj.BMID__c)) {
            		// criteriaToCamapaignMap.put(campObj.BMID__c, campObj);
            		String key = ignoreCase(campObj.BMID__c);
            		criteriaToCamapaignMap.put(key, campObj);
            	} 
            	names += '{Name= '+campObj.Name + ',Id= ' + campObj.Id + '}, ';
            	// criteriaToCamapaignMap.put((String)campObj.Id, campObj);
            	String key = ignoreCase((String)campObj.Id);
            	criteriaToCamapaignMap.put(key, campObj);
            }
            System.debug('## CAMPAIGNS FOUND = [ '+names+' ]');
            // leadList[0].addError('## campaigns = ' + names);
        } catch(Exception e) {
           //  leadList.get(0).addError(e);
            // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getStackTraceString()));
        } 
        return criteriaToCamapaignMap;
	}
	//End of new Logic.	
	
	private static String ignoreCase(String input) {
		return input.toUpperCase();
	}
	public static Campaign getLeadCampaign(CampaignWrapper wrapperObj, Map<String, Campaign> criteriaToCamapaignMap) {
		String key = 'DEFAULT_CAMPAIGN';
		Boolean campaignFound = false;
		if(!String.isBlank(wrapperObj.CAM_PRIMARY)) {
			key = ignoreCase(wrapperObj.CAM_PRIMARY);
			campaignFound = (criteriaToCamapaignMap.get(key) == null ? false : true);
		}
		if(!String.isBlank(wrapperObj.CAM_BMID) && !String.isBlank(wrapperObj.CAM_PID) && !String.isBlank(wrapperObj.CAM_AID)) {
    		key = ignoreCase(wrapperObj.CAM_BMID+'-'+wrapperObj.CAM_PID+'-'+wrapperObj.CAM_AID);
    		campaignFound = (criteriaToCamapaignMap.get(key) == null ? false : true);
    	} 
    	if(campaignFound == false && (!String.isBlank(wrapperObj.CAM_BMID) && !String.isBlank(wrapperObj.CAM_PID)) ) {
    		key = ignoreCase(wrapperObj.CAM_BMID+'-'+wrapperObj.CAM_PID);
    		campaignFound = (criteriaToCamapaignMap.get(key) == null ? false : true);
    	} 
    	if(campaignFound == false && (!String.isBlank(wrapperObj.CAM_BMID))) {
    		key = ignoreCase(wrapperObj.CAM_BMID);
    		campaignFound = (criteriaToCamapaignMap.get(key) == null ? false : true);
    	} 
    	/************ OVERRIDING EVERY SEARCH FOR PARTNER LEADS ****************/
    	if(wrapperObj.IS_PARTNER_LEAD) {
    		key = ignoreCase(PARTNER_CAMPAIGN_NAME);
    		campaignFound = (criteriaToCamapaignMap.get(key) == null ? false : true);
    	}
    	if(campaignFound == false) {
            key = ignoreCase('DEFAULT_CAMPAIGN');
    	}
    	// leadObj.addError('## KEY = ' + key);
    	System.debug('## KEY TO FIND CAMPAIGN = '+ key);
		return criteriaToCamapaignMap.get(ignoreCase(key)); 
	}
	
	//New Combination Search Code for BMID,PID,AID and DNIS.
	public static Campaign getLeadCampaignLogic(CampaignWrapper wrapperObj, Map<String, Campaign> criteriaToCamapaignMap) {		
		String key = 'DEFAULT_CAMPAIGN';
		Boolean campaignFound = false;
		/*if(!String.isBlank(wrapperObj.CAM_PRIMARY)) {
			key = ignoreCase(wrapperObj.CAM_PRIMARY);
			campaignFound = (criteriaToCamapaignMap.get(key) == null ? false : true);
		}*/
		if(!String.isBlank(wrapperObj.CAM_DNIS)) {
    		key = ignoreCase(wrapperObj.CAM_DNIS);
    		campaignFound = (criteriaToCamapaignMap.get(key) == null ? false : true);
    	} 
		if(campaignFound == false && !String.isBlank(wrapperObj.CAM_BMID) && !String.isBlank(wrapperObj.CAM_PID) && !String.isBlank(wrapperObj.CAM_AID)) {
    		key = ignoreCase(wrapperObj.CAM_BMID+'-'+wrapperObj.CAM_PID+'-'+wrapperObj.CAM_AID);
    		campaignFound = (criteriaToCamapaignMap.get(key) == null ? false : true);
    	} 
    	if(campaignFound == false && (!String.isBlank(wrapperObj.CAM_BMID) && !String.isBlank(wrapperObj.CAM_PID)) ) {
    		key = ignoreCase(wrapperObj.CAM_BMID+'-'+wrapperObj.CAM_PID);
    		campaignFound = (criteriaToCamapaignMap.get(key) == null ? false : true);
    	} 
    	if(campaignFound == false && (!String.isBlank(wrapperObj.CAM_BMID))) {
    		key = ignoreCase(wrapperObj.CAM_BMID);
    		campaignFound = (criteriaToCamapaignMap.get(key) == null ? false : true);
    	} 
    	/************ OVERRIDING EVERY SEARCH FOR PARTNER LEADS ****************/
    	if(wrapperObj.IS_PARTNER_LEAD) {
    		key = ignoreCase(PARTNER_CAMPAIGN_NAME);
    		campaignFound = (criteriaToCamapaignMap.get(key) == null ? false : true);
    	}
    	/*if(campaignFound == false) {
            key = ignoreCase('DEFAULT_CAMPAIGN');
    	}*/
    	// leadObj.addError('## KEY = ' + key);
    	System.debug('## KEY TO FIND CAMPAIGN = '+ key);
		return criteriaToCamapaignMap.get(ignoreCase(key));
	}
	//End of new Logic.
}