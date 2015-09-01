public class PRAssignment {
	/*public ContactWrapperClass cwObject{get;set;}
	public LeadWrapper existingLeads{get;set;}
    LeadTriggerHelper helperObj{get;set;}
    List<Lead> leadList{get;set;}
    public PRAssignment(LeadTriggerHelper helperObj, List<Lead> leadList){
        this.leadList = leadList;
		this.helperObj = helperObj;
    }
    public String findOwnerId(Lead leadObj, Map<Id, Opportunity> activeOppMap, Map<Id, Opportunity> closedOppMap, 
    	Map<Id, Opportunity> downgradedOppMap, LeadWrapper existingLeads, ContactWrapperClass cwObject, Map<Id, Integer> countMap, String campaignName){
        Opportunity mostRecentOpportunity = null;
        Lead existingLead = null;
        if(leadObj.RecordTypeId == OpportunityHelper.getOppRecordTypeMap('Partner Leads')) {
            return leadObj.OwnerId;//(String.isBlank(leadObj.Partner_Owner__c) ? 'not found' : leadObj.Partner_Owner__c);
        } 
        else if(leadObj.LeadSource != null && (leadObj.LeadSource).trim().equalsIgnoreCase('Solve then Sell')){
            if(leadObj.Sales_Agent_User_Lookup__c != null && ((String)leadObj.Sales_Agent_User_Lookup__c).trim().length()>0){
                return (String)leadObj.Sales_Agent_User_Lookup__c;
            }   
        }
        else if(leadObj.LeadSource == 'Referral Programs'){
            try{
                List<Account> acct = new List<Account>(); 
                List<Account> acctEmail = new List<Account>(); 
                List<User> usr = new List<User>(); 
                
                if(leadObj.Sales_Agent_Email__c != null && leadObj.Sales_Agent_Email__c != ''){
                    Map<String, List<User>>  returnMap = helperObj.getUsersPerAgentEmail(leadList);
                    if(returnMap != null && returnMap.get(leadObj.Sales_Agent_Email__c) != null) {
                        usr = returnMap.get(leadObj.Sales_Agent_Email__c);
                    }
                }  
                
                if(leadObj.Referrer_RCUserID__c != null && leadObj.Referrer_RCUserID__c != ''){
                    Map<String, List<Account>>  returnMap = helperObj.getAccountsPerUserIds(leadList);
                    if(returnMap != null && returnMap.get(leadObj.Referrer_RCUserID__c) != null) {
                        acct = returnMap.get(leadObj.Referrer_RCUserID__c);
                    }
                }
                if(leadObj.Referrer_Email__c != null && leadObj.Referrer_Email__c != ''){
                    Map<String, List<Account>>  returnMap = helperObj.getAccountsPerContacts(leadList);
                    if(returnMap != null && returnMap.get(leadObj.Referrer_Email__c) != null) {
                        acctEmail = returnMap.get(leadObj.Referrer_Email__c);
                    }
                }
                
                if(usr.size() > 0){
                    for(User u : usr) {
                        return (String)u.Id;
                    }
                } else if(acct.size() > 0){
                    for(Account a : acct) {
                        return (String)a.Current_Owner__c; 
                    }
                } else if(acctEmail.size() > 0){
                    for(Account a : acctEmail) {
                        return (String)a.Current_Owner__c; 
                    }
                } else {
                    return 'not found';
                }
            } catch (System.Exception e){
                    return 'not found';
            }
        }
        else if(leadObj.LeadSource == 'Vista Print' 
            || campaignName.startsWith('VistaPrint')){
            String CO = findProtectedObjects(leadObj, cwObject, activeOppMap, closedOppMap, downgradedOppMap);
            if(CO != 'NoCurrentOwner'){
                return CO;
            }
            // leadObj.addError('************** '+ CO);
    		Map<Id, Opportunity> mostRecentOpps = new Map<Id, Opportunity>();
    		mostRecentOpps.putAll(closedOppMap);
    		mostRecentOpps.putAll(downgradedOppMap);
    		existingLead = getExistingLead(leadObj, existingLeads);
	    	Id accId = getAccountId(leadObj, cwObject);
			if(accId != null && mostRecentOpps.get(accId) != null ) {
				mostRecentOpportunity = mostRecentOpps.get(accId);
			} 
            if(existingLead == null && mostRecentOpportunity != null 
            	&& (1 == countMap.get(mostRecentOpportunity.OwnerId))){    
                return mostRecentOpportunity.ownerId;           
            }
            else if(existingLead != null && mostRecentOpportunity == null && (1 == countMap.get(existingLead.OwnerId))){
                return existingLead.ownerId;
            } else if(existingLead != null && mostRecentOpportunity != null){
                if((existingLead.CreatedDate < mostRecentOpportunity.CreatedDate) 
                    && (1 == countMap.get(existingLead.OwnerId))){
                    return existingLead.ownerId;
                } else if(1 == countMap.get(mostRecentOpportunity.OwnerId)){
                    return mostRecentOpportunity.ownerId;
                }
            }
            return 'not found';
        }
        else if(leadObj.LeadSource != 'Partner Request'){
            String CO = findProtectedObjects(leadObj, cwObject, activeOppMap, closedOppMap, downgradedOppMap);
            if(CO != 'NoCurrentOwner'){
                return CO;
            }
            /*Map<Id, Opportunity> mostRecentOpps = new Map<Id, Opportunity>();
    		mostRecentOpps.putAll(closedOppMap);
    		mostRecentOpps.putAll(downgradedOppMap);
    		existingLead = getExistingLead(leadObj, existingLeads);
	    	Id accId = getAccountId(leadObj, cwObject);
			if(accId != null && mostRecentOpps.get(accId) != null ) {
				mostRecentOpportunity = mostRecentOpps.get(accId);
			} 
            if(existingLead == null && mostRecentOpportunity != null){  
                return mostRecentOpportunity.ownerId;           
            }
            else if(mostRecentOpportunity == null && existingLead != null){
                return existingLead.ownerId;
            }
            else if(existingLead != null && mostRecentOpportunity != null){
                if(existingLead.CreatedDate < mostRecentOpportunity.CreatedDate){
                    return existingLead.ownerId;
                }
                else {
                    return mostRecentOpportunity.ownerId;
                }
            }*/
            /*Id otherId = getOtherOwnerId(leadObj, closedOppMap, downgradedOppMap, existingLeads, cwObject);
            if(otherId != null) {
            	return String.valueOf(otherId);
            }
        }
        return 'not found';
    }
     public Id getOtherOwnerId(Lead leadObj, Map<Id, Opportunity> closedOppMap, 
    	Map<Id, Opportunity> downgradedOppMap, LeadWrapper existingLeads, ContactWrapperClass cwObject) {
    	Opportunity mostRecentOpportunity = null;
        Lead existingLead = null;
    	Id otherId = null;
    	 Map<Id, Opportunity> mostRecentOpps = new Map<Id, Opportunity>();
    		mostRecentOpps.putAll(closedOppMap);
    		mostRecentOpps.putAll(downgradedOppMap);
    		existingLead = getExistingLead(leadObj, existingLeads);
	    	Id accId = getAccountId(leadObj, cwObject);
			if(accId != null && mostRecentOpps.get(accId) != null ) {
				mostRecentOpportunity = mostRecentOpps.get(accId);
			} 
            if(existingLead == null && mostRecentOpportunity != null){  
                otherId = mostRecentOpportunity.ownerId;           
            }
            else if(mostRecentOpportunity == null && existingLead != null){
                otherId = existingLead.ownerId;
            }
            else if(existingLead != null && mostRecentOpportunity != null){
                if(existingLead.CreatedDate < mostRecentOpportunity.CreatedDate){
                    otherId = existingLead.ownerId;
                }
                else {
                    otherId = mostRecentOpportunity.ownerId;
                }
            }
		return otherId;
    }
    
    public Lead getExistingLead(Lead leadObj, LeadWrapper existingLeads) {
    	Lead existingLead = null;
		if(existingLeads != null) {
			Map<String, Lead> emailLeadMap = existingLeads.emailLead;
			Map<String, Lead> phoneLeadMap = existingLeads.phoneLead;
			if(emailLeadMap != null && emailLeadMap.size() != 0) {
				existingLead = emailLeadMap.get(leadObj.Email);
			}
			if(existingLead == null) {
				if(phoneLeadMap != null && phoneLeadMap.size() != 0) {
    				existingLead = phoneLeadMap.get(leadObj.Phone);
    			}
			}
		}
		return existingLead;
    }
    /*
    public void getPRAssignment(List<Lead> leadList, Map<Id, Campaign> campaignMap) {
    	List<Lead> newLeadList = new List<Lead>();
    	for(Lead leadObj : leadList) {
	    	String campaignName = campaignMap.get(leadObj.Primary_Campaign__c).Name;
	        if((leadObj.LeadSource != 'Partner Request' 
	        	|| leadObj.LeadSource != 'Partner Request'
	        	|| leadObj.LeadSource == 'Vista Print' 
            	|| campaignName.startsWith('VistaPrint'))
            	&& (new ProtectionRuleExceptions(leadObj)).useProtectionRuleCheck()
	        	) {
	        	newLeadList.add(leadObj);
	        }
    	}
		Id rcId = OpportunityHelper.getOppRecordTypeMap('Sales Opportunity');
		ContactWrapperClass cwObject = getOwnerPerContact(newLeadList);
		Map<Id, Opportunity> activeOppMap = getActiveOpportunities(newLeadList, rcId, cwObject);
		Map<Id, Opportunity> closedOppMap = getClosedOpportunities(newLeadList, rcId, cwObject);
		Map<Id, Opportunity> downgradedOppMap = getDowngradedOpportunities(newLeadList, rcId, cwObject);
		LeadWrapper existingLeads = getExistingLeads(newLeadList); 
		Map<Id, Opportunity> mostRecentOpps = new Map<Id, Opportunity>();
		mostRecentOpps.putAll(closedOppMap);
		mostRecentOpps.putAll(downgradedOppMap);
		Set<Id> ownerIds = getOwnerIds(newLeadList, mostRecentOpps, existingLeads, cwObject);
		Map<Id, Integer> countMap = getOppOwnerCount(ownerIds);
    	
    }
    */
    /*private String findProtectedObjects(Lead leadObj, ContactWrapperClass cwObject,
    Map<Id, Opportunity> activeOppMap, Map<Id, Opportunity> closedOppMap, 
    	Map<Id, Opportunity> downgradedOppMap) {
        if(leadObj.LeadSource != 'Partner Request' && leadObj.LeadSource != 'Cisco Resellers Form') {           //NEW CHK for **M
            if(cwObject != null) {
	        	Map<String, Contact> contactToOwnerMap = cwObject.contactToOwnerMap;
	        	// leadObj.addError('********* '+ contactToOwnerMap.size());
        		if(contactToOwnerMap != null && contactToOwnerMap.get(leadObj.Email) != null) {
        			if(contactToOwnerMap.get(leadObj.Email).Account.Current_Owner__r.IsActive) {
	                	return contactToOwnerMap.get(leadObj.Email).Account.Current_Owner__c;
        			}
        		}
        		Opportunity opp = getOpportunity(leadObj, cwObject, activeOppMap, closedOppMap, downgradedOppMap);
        		if(opp != null) {
        			return opp.ownerId;
        		}
            }
    	}
        return 'NoCurrentOwner';                
    }
    public Opportunity getOpportunity(Lead leadObj, ContactWrapperClass cwObject,
    	Map<Id, Opportunity> activeOppMap, Map<Id, Opportunity> closedOppMap, 
    	Map<Id, Opportunity> downgradedOppMap) {
    	Opportunity opp = null;
    	Id accId = getAccountId(leadObj, cwObject);
		if(accId != null && closedOppMap.get(accId) != null ) {
			opp = closedOppMap.get(accId);
		} else if(accId != null && activeOppMap.get(accId) != null ) {
			opp = activeOppMap.get(accId);
		} else if(accId != null && downgradedOppMap.get(accId) != null ) {
			opp = downgradedOppMap.get(accId);
		}
		return opp;
    }
    public Id getAccountId(Lead leadObj, ContactWrapperClass cwObject) {
    	Id accId = null;
    	if(cwObject != null) {
	    	Map<String, Id> emailToAccMap = cwObject.emailToAccMap;
			Map<String, Id> phoneToAccMap = cwObject.emailToAccMap;
			if(emailToAccMap != null && emailToAccMap.size() != 0) {
				accId = emailToAccMap.get(leadObj.Email);
			} else if(phoneToAccMap != null && phoneToAccMap.size() != 0) {
				accId = phoneToAccMap.get(leadObj.Phone);
			}
    	}
    	return accId;
    }
    public class ContactWrapperClass {
    	public Set<Id> accountIds{get;set;}
    	public Map<String, Contact> contactToOwnerMap{get;set;}
    	public Map<String, Id> emailToAccMap{get;set;}
    	public Map<String, Id> phoneToAccMap{get;set;}
    	public ContactWrapperClass(Set<Id> accountIds, Map<String, Contact> contactToOwnerMap, 
    	Map<String, Id> emailToAccMap, Map<String, Id> phoneToAccMap){
    		if(accountIds == null)
    			accountIds = new Set<Id>();
    		this.accountIds = accountIds;
    		if(contactToOwnerMap == null)
    			contactToOwnerMap = new Map<String, Contact>();
    		this.contactToOwnerMap = contactToOwnerMap;
    		if(emailToAccMap == null)
    			emailToAccMap = new Map<String, Id>();
    		this.emailToAccMap = emailToAccMap;
    		if(phoneToAccMap == null)
    			phoneToAccMap = new Map<String, Id>();
    		this.phoneToAccMap = phoneToAccMap;
    	}
    }
    public ContactWrapperClass getOwnerPerContact(List<Lead> leadList) {
    	Map<String, Contact> contactToOwnerMap = new Map<String, Contact>();
    	Map<String, Lead> existingLeadMap = new Map<String, Lead>();
    	Map<String, String> emailToPhoneMap = new Map<String, String>();
    	Map<String, Id> emailToAccMap = new Map<String, Id>();
    	Map<String, Id> phoneToAccMap = new Map<String, Id>();
		Set<String> emails = new Set<String>();
		Set<String> phones = new Set<String>();
		Set<String> phSet = new Set<String>();
		Set<String> ph1Set = new Set<String>();
		for(Lead leadObj : leadList) {
			emailToPhoneMap.put(leadObj.Email, leadObj.Phone);
			emails.add(leadObj.Email);
			phones.add(leadObj.Phone);
			Map<String, String> phoneMap = rearrangePhone(leadObj);
			String num = leadObj.Phone;
			for(String ph : phoneMap.keySet()) {
				phSet.add(ph);
				ph1Set.add(phoneMap.get(ph));
				// num += ' $ ' + ph + ' $ ' + phoneMap.get(ph);
			}
			// leadObj.addError('******* ' +  num );
		}
		Set<Id> accountIds = new Set<Id>();
        for(Contact contactObj : [SELECT Id, Name, AccountId, indexedEmail__c, indexedPhone__c, Email, Phone, 
        Contact.Account.Name, Contact.Account.Current_Owner__c, Contact.Account.Current_Owner__r.IsActive FROM Contact WHERE AccountId != null AND 
            ((indexedEmail__c != null AND indexedEmail__c != '' AND indexedEmail__c IN :emails) 
            	OR (indexedPhone__c != null AND indexedPhone__c != '' AND indexedPhone__c IN:phones ) 
            	OR (indexedPhone__c != null AND indexedPhone__c != '' AND indexedPhone__c IN:phSet) 
            	OR (indexedPhone__c != null AND indexedPhone__c != '' AND indexedPhone__c IN:ph1Set)) 
            AND indexedEmail__c!=null AND indexedPhone__c!=null 
            AND IsDeleted=false LIMIT:Limits.getLimitDMLRows()]) {
            if(contactObj != null) {
                accountIds.add(contactObj.AccountId);
                // setContactIDs.add(c.AccountId);          
                emailToAccMap.put(contactObj.indexedEmail__c, contactObj.AccountId);
                phoneToAccMap.put(contactObj.indexedPhone__c, contactObj.AccountId);
                if(!String.isBlank(contactObj.Account.Current_Owner__c)) {
                    contactToOwnerMap.put(contactObj.Email,contactObj);
                }
            }
        }
        return new ContactWrapperClass(accountIds, contactToOwnerMap, emailToAccMap, phoneToAccMap);
    }
    
    
    public Map<Id, Opportunity> getActiveOpportunities(List<Lead> leadList, Id rcId, ContactWrapperClass cwObject) {
    	Set<Id> accountIds = cwObject.accountIds;
    	Map<Id, Opportunity> accToOppMap = new Map<Id, Opportunity>();
    	for(Opportunity oppObj : [SELECT Id, Name, AccountId, CreatedDate, LastModifiedDate, StageName, OwnerId, Opportunity.Owner.isActive 
            FROM Opportunity WHERE AccountId != NULL AND IsDeleted=false AND ownerId !='005800000036sJJ' 
            AND StageName IN : OpportunityHelper.alteredStages AND Opportunity.Owner.isActive=true 
            AND (RecordTypeId  =: rcId OR RecordTypeId = NULL) 
            AND AccountId IN :accountIds LIMIT:Limits.getLimitDMLRows() ]){
            if(accToOppMap.size() == 0 || accToOppMap.get(oppObj.AccountId) == null){              
                accToOppMap.put(oppObj.AccountId, oppObj);
            } else if(oppObj.CreatedDate > accToOppMap.get(oppObj.AccountId).CreatedDate){
                accToOppMap.put(oppObj.AccountId, oppObj);
            }            
        }
        /*if(activepipeOpportunity != null){
            return activepipeOpportunity.OwnerId;
        } */ 
        /* return accToOppMap;
    }
    public Map<Id, Opportunity> getClosedOpportunities(List<Lead> leadList, Id rcId, ContactWrapperClass cwObject) {
    	Set<Id> accountIds = cwObject.accountIds;
    	Map<Id, Opportunity> accToOppMap = new Map<Id, Opportunity>();
    	for(Opportunity oppObj : [SELECT Id, Name, CreatedDate, LastModifiedDate, StageName, AccountId, OwnerId, Opportunity.Owner.isActive, CloseDate 
            FROM Opportunity WHERE AccountId != NULL AND IsDeleted=false AND ownerId!='005800000036sJJ' 
            AND ownerID!='00580000003dyRn' AND Opportunity.Owner.isActive=true AND StageName IN : OpportunityHelper.closedStagesSet 
            AND Order__c=null AND (RecordTypeId  =: rcId OR RecordTypeId = NULL) 
            AND  AccountId IN :accountIds LIMIT:Limits.getLimitDMLRows()]){                
            if(oppObj.CloseDate > Date.today().addDays(-4)){
                if(accToOppMap.size() == 0 || accToOppMap.get(oppObj.AccountId) == null){              
	                // activepipeOpportunity = o;
	                accToOppMap.put(oppObj.AccountId, oppObj);
            	} else if(oppObj.CloseDate < accToOppMap.get(oppObj.AccountId).CloseDate){
                     accToOppMap.put(oppObj.AccountId, oppObj);
                }
            }           
        }
        return accToOppMap;    
    }
    public Map<Id, Opportunity> getDowngradedOpportunities(List<Lead> leadList, Id rcId, ContactWrapperClass cwObject) {
    	Set<Id> accountIds = cwObject.accountIds;
    	Map<Id, Opportunity> accToOppMap = new Map<Id, Opportunity>();
    	for(Opportunity oppObj : [SELECT Id, Name, CreatedDate, LastModifiedDate, AccountId, StageName, OwnerId, Opportunity.Owner.isActive 
        	FROM Opportunity WHERE AccountId != NULL AND IsDeleted=false AND ownerId!='005800000036sJJ' 
        	AND StageName='0. Downgraded' AND Opportunity.Owner.isActive=true AND (RecordTypeId  =: rcId OR RecordTypeId = NULL) AND AccountId IN :accountIds]){
            if(oppObj.CreatedDate.Date() > Date.Today().addDays(-90)){                   
                if(accToOppMap.size() == 0 || accToOppMap.put(oppObj.AccountId, oppObj) == null){               
                    accToOppMap.put(oppObj.AccountId, oppObj);
                }
                else if(oppObj.CreatedDate > accToOppMap.get(oppObj.AccountId).CreatedDate){
                    accToOppMap.put(oppObj.AccountId, oppObj);
                }
            }           
        }   
        return accToOppMap;    
    }
	public LeadWrapper getExistingLeads(List<Lead> leadList) {
		Map<String, Lead> existingLeadMap = new Map<String, Lead>();
		Set<String> emails = new Set<String>();
		Set<String> phones = new Set<String>();
		Set<String> phSet = new Set<String>();
		Set<String> ph1Set = new Set<String>();
		
		Map<String, Lead> emailLead = new Map<String, Lead>(); 
		Map<String, Lead> phoneLead = new Map<String, Lead>(); 
		
		for(Lead leadObj : leadList) {
			//if(leadObj.indexedEmail__c!=null && leadObj.indexedPhone__c!=null) {
				emails.add(leadObj.Email);
				phones.add(leadObj.Phone);
				Map<String, String> phoneMap = rearrangePhone(leadObj);
				for(String ph : phoneMap.keySet()) {
					phSet.add(ph);
					ph1Set.add(phoneMap.get(ph));
				}
			// }
		}
		
		for (Lead existingl : [SELECT Id, Email, CreatedDate, Status, Downgrade_Reason__c, OwnerId,indexedPhone__c,indexedEmail__c, 
				Lead.Owner.isActive FROM Lead WHERE 
            	((indexedEmail__c != null AND indexedEmail__c != '' AND indexedEmail__c IN :emails) 
            	OR (indexedPhone__c != null AND indexedPhone__c != '' AND indexedPhone__c IN:phones ) 
            	OR (indexedPhone__c != null AND indexedPhone__c != '' AND indexedPhone__c IN:phSet) 
            	OR (indexedPhone__c != null AND indexedPhone__c != '' AND indexedPhone__c IN:ph1Set)) 
            AND indexedEmail__c!=null AND indexedPhone__c!=null 
            AND IsConverted=false AND IsDeleted=false 
            AND LeadSource != 'About To Be Cancelled' 
            AND LeadSource != 'About To Be Cancelled UK' 
            AND (Status='1.5 Call Out' OR Status='2. Contacted' OR Status='0. Downgraded') 
            AND Lead.Owner.isActive=true AND OwnerId!='005800000036sJJ' LIMIT:Limits.getLimitDMLRows() ] ){
            if(existingl.CreatedDate.Date() > Date.Today().addDays(-90)){ 
            	String phone = existingl.indexedPhone__c;
            	String email = existingl.indexedEmail__c;
            	
            	if(emailLead.get(email) == null){
                    emailLead.put(email, existingl);
                } else{
                    if(emailLead.get(email).CreatedDate < existingl.CreatedDate){
                        emailLead.put(email, existingl);  
                    }
                }
            	if(phoneLead.get(phone) == null){
                    phoneLead.put(phone, existingl);
                } else{
                    if(phoneLead.get(phone).CreatedDate < existingl.CreatedDate){
                        phoneLead.put(phone, existingl);  
                    }
                }
            }
        }
        return new LeadWrapper(emailLead, phoneLead);
	}
	public class LeadWrapper {
		public Map<String, Lead> emailLead{get;set;}
		public Map<String, Lead> phoneLead{get;set;}
		public LeadWrapper(Map<String, Lead> emailLead, Map<String, Lead> phoneLead) {
			if(emailLead == null) {
				emailLead = new Map<String, Lead>();
			}
			this.emailLead = emailLead;
			if(phoneLead == null) {
				phoneLead = new Map<String, Lead>();
			}
			this.phoneLead = phoneLead;
		}
	}
    public Map<String, List<Account>> getAccountsPerUserIds(List<Lead> leadList) {
    	Map<String, List<Account>> userToAccountMap = new Map<String, List<Account>>();
        List<String> userIds = new List<String>();
        for(Lead leadObj : leadList) {
            if(leadObj.Referrer_RCUserID__c != null && leadObj.Referrer_RCUserID__c != ''){
                userIds.add(leadObj.Referrer_RCUserID__c);
            }
        }
        for(Account accountObj : [SELECT Id, Current_Owner__c, RC_User_ID__c FROM Account WHERE  
                     RC_User_ID__c != NULL AND Current_Owner__c != null AND Current_Owner__c != '' AND Current_Owner__r.IsActive=true AND RC_User_ID__c IN :userIds]) {
            List<Account> accList = new List<Account>();
            if(userToAccountMap == null) {
                userToAccountMap =  new Map<String, List<Account>>();
            }
            if(userToAccountMap.get(accountObj.RC_User_ID__c) != null) {
                accList= userToAccountMap.get(accountObj.RC_User_ID__c);
            }
            accList.add(accountObj);
            userToAccountMap.put(accountObj.RC_User_ID__c, accList);            
        }
        return userToAccountMap;
    }
    public Set<Id> getOwnerIds(List<Lead> leadList, Map<Id, Opportunity> mostRecentOpps, LeadWrapper existingLeads, ContactWrapperClass cwObject) {
    	Set<Id> ownerIds = new Set<Id>();
    	for(Lead leadObj : leadList) {
	    	Opportunity mostRecentOpportunity = null;
	        Lead existingLead = getExistingLead(leadObj, existingLeads);
	    	Id accId = getAccountId(leadObj, cwObject);
			if(accId != null && mostRecentOpps.get(accId) != null ) {
				mostRecentOpportunity = mostRecentOpps.get(accId);
			} 
			if(existingLead != null)
				ownerIds.add(existingLead.OwnerId);
			if(mostRecentOpportunity != null)
				ownerIds.add(mostRecentOpportunity.OwnerId);
    	}
		return ownerIds;
    }
    public Map<Id, Integer> getOppOwnerCount(Set<Id> ownerIds) {
    	Map<Id, Integer> countMap = new Map<Id, Integer>();
    	for(User_Skill__c userSkill : [SELECT Id, User__c FROM User_Skill__c WHERE Name LIKE '%Vista Print%' AND User__c IN : ownerIds]) {
    		Id ownerId = userSkill.User__c;
    		Integer counter = 0;
    		if(countMap.get(ownerId) != null) {
    			counter = countMap.get(ownerId);
    		}
    		countMap.put(ownerId, ++counter);
    	}
    	return countMap;
    }
    public Map<String, String> rearrangePhone(Lead leadObj) {
    	Map<String, String> phoneMap = new Map<String, String>();
    	String ph1= null;
    	String ph2 = null;
    	if(leadObj.Phone != null){
            if(leadObj.Phone.contains('00000') || leadObj.Phone.contains('(000)')){
                leadObj.phone = null;
                ph1 = null;
                ph2 = null;
            }
            else{
                //if(!leadObj.Phone.startsWith('(')) {
	                ph1 = '1' + leadObj.Phone;
                // } 
                if(leadObj.Phone.length() == 10){
                    ph2 = '(' + leadObj.Phone.substring(0, 3) + ') ' + leadObj.Phone.substring(3, 6) + '-' + leadObj.Phone.substring(6);
                } else {
                    ph2=ph1;
                }   
            }
        }   
        if(ph1 != null) {
        	phoneMap.put(ph1, ph2);
        }
        return phoneMap;
    }*/
}