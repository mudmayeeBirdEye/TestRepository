public with sharing class ValidateLeadDuplicacy {
	private static Id partnerRCTypeId;
    public static List<Lead> validatePerToday(List<Lead> upcomingLeads) {
    	List<Lead> leadObjList = new List<Lead>();
    	List<Lead> newLeadObjs = new List<Lead>();
        Map<String, Id> emailLeadMap = new Map<String, Id>();   
        Map<Id, Id> newToExistingMap = new Map<Id, Id>();                    
        List<String> emails = new List<String>();
        Schema.DescribeSObjectResult result = Lead.SObjectType.getDescribe();
    	Map<string,Schema.RecordTypeInfo> rtMapByName = result.getRecordTypeInfosByName();
        partnerRCTypeId = rtMapByName.get('Partner Leads').getRecordTypeId();
        try {   
	    	for(Lead leadObj : upcomingLeads) {
	    		if(!hasExceptionRules(leadObj)) {
	    			leadObjList.add(leadObj);
	    		}
	    		leadObj.isDuplicate__c = 'false';
	    		leadObj.Duplicate_Lead__c = false;
	    	}
	    	
	        for(Lead leadObj : leadObjList) {
	            emails.add(leadObj.Email);
		        System.debug('####### Lead Object=> '+leadObj.Id);
	        }
	        // finding the duplicated associated to provided emails
	        /*List<Lead> dupLead = [SELECT Id, Email FROM Lead WHERE Email IN: emails AND CreatedDate = TODAY 
	        AND Email != 'fake@email.com' AND Email != 'fake@fake.com' AND Status != '0. Downgraded' 
	        AND isDuplicate__c = 'false' AND IsConverted = false ORDER BY CreatedDate DESC];
	        */
	        List<Lead> dupLead = [SELECT Id, Email FROM Lead WHERE Email IN: emails AND CreatedDate = TODAY 
	        AND Email != 'fake@email.com' AND Email != 'fake@fake.com' AND Status != '0. Downgraded' 
	        AND (Duplicate_Lead__c=null OR Duplicate_Lead__c = false) AND IsConverted = false ORDER BY CreatedDate DESC];
	        
	        
	        for(Lead obj: dupLead) {
	        	if(emailLeadMap.get(obj.Email) == null)
	            	emailLeadMap.put(obj.Email, obj.Id);
	        }
	        // preveting the duplicate leads to be created
	        for(Lead leadObj : leadObjList){
	            if(emailLeadMap.containsKey(leadObj.Email)) {
	                 leadObj.isDuplicate__c = 'true';
	                 leadObj.Duplicate_Lead__c = true;
	                 leadObj.existingLeadId__c = emailLeadMap.get(leadObj.Email);
	                 leadObj.LeadExistingSource__c = 'Lead';
	            } else {
	            	newLeadObjs.add(leadObj);
	            }
	        }
        } catch(Exception e) {}
        if(newLeadObjs.size() != 0) {
        	System.debug('##### => Checking with Status');
        	newLeadObjs = new List<Lead>(validatePerStatus(newLeadObjs));
        }
       
        return newLeadObjs;
    }
    public static List<Lead> validatePerStatus(List<Lead> leadObjList) {
    	List<Lead> newLeadObjs = new List<Lead>();
        Map<String, String> emailLeadMap = new Map<String, String>();                        
        List<String> emails = new List<String>();   
        try {
	        for(Lead leadObj : leadObjList){
	            emails.add(leadObj.Email);
	        }
	        /*List<Lead> dupLead = [SELECT Id, Email FROM Lead WHERE Email IN: emails 
	        AND Email != 'fake@email.com' AND Email != 'fake@fake.com' AND isDuplicate__c = 'false' AND IsConverted = false
	        AND Status IN ('1.5 Call Out','2. Contacted') ORDER BY CreatedDate DESC];
	        */
	        List<Lead> dupLead = [SELECT Id, Email FROM Lead WHERE Email IN: emails 
	        AND Email != 'fake@email.com' AND Email != 'fake@fake.com' AND (Duplicate_Lead__c = null OR Duplicate_Lead__c = false) AND IsConverted = false
	        AND Status IN ('1.5 Call Out','2. Contacted') ORDER BY CreatedDate DESC];
	        for(Lead obj: dupLead) {
	            emailLeadMap.put(obj.Email, obj.Id);
	        }
	        for(Lead leadObj : leadObjList){
	            if(emailLeadMap.containsKey(leadObj.Email)) {
	                 leadObj.isDuplicate__c = 'true';
	                 leadObj.Duplicate_Lead__c = true;
	                 leadObj.existingLeadId__c = emailLeadMap.get(leadObj.Email);
	                 leadObj.LeadExistingSource__c = 'Lead';
	            } else {
	            	newLeadObjs.add(leadObj);
	            }
	        }
        } catch(Exception e) {}
        if(newLeadObjs.size() != 0) {
        	System.debug('##### => Checking with Stages');
        	newLeadObjs = new List<Lead>(validatePerStages(newLeadObjs));
        }
        return newLeadObjs;
    }
    public static List<Lead> validatePerStages(List<Lead> leadObjList) {
    	List<Lead> newLeadObjs = new List<Lead>();
        Map<String, Id> emailLeadMap = new Map<String, Id>();                        
        List<String> emails = new List<String>();
        try {   
	        for(Lead leadObj : leadObjList){
	            emails.add(leadObj.Email);
	        }
	        Map<String, String> contactAcct = new Map<String, String>();
	        Contact[] contactList = [SELECT Id, Name, AccountId, Email, Contact.Account.Name FROM Contact 
	                    WHERE email IN :emails 
	                    AND Email != 'fake@email.com' AND Email != 'fake@fake.com' ORDER BY CreatedDate DESC];
	                    Map<String, String> accts = new Map<String, String>();
	                    for(Contact c : contactList) {
	                        if (c.AccountId != null) {
	                            accts.put(c.AccountId, c.Email);
	                            // if(contactAcct.get(c.AccountId) == null)
	                            contactAcct.put(c.AccountId, c.Id);
	                            // contactAcct.put
	                        }
	                    }
	                    
	        List<Opportunity> oppList = new List<Opportunity>([SELECT Id, Name, AccountId FROM Opportunity 
	                        WHERE AccountId in : accts.keySet() AND StageName IN : OpportunityHelper.alteredStages ORDER BY CreatedDate DESC]);
	        for(Opportunity oppObj : oppList) {
	            if (accts.containsKey(oppObj.AccountId) != null) {
	                String email = accts.get(oppObj.AccountId);
	                if(emailLeadMap.get(email) == null)
	                	emailLeadMap.put(email, contactAcct.get(oppObj.AccountId));
	            }
	        }
	        
	        for(Lead leadObj : leadObjList){
	            if(emailLeadMap.containsKey(leadObj.Email)) {
	                 leadObj.isDuplicate__c = 'true';
	                 leadObj.Duplicate_Lead__c = true;
	                 leadObj.existingLeadId__c = emailLeadMap.get(leadObj.Email);
	                 leadObj.LeadExistingSource__c = 'Opportunity';
	            } else {
	            	System.debug('##### => No rules Followed');
	            	newLeadObjs.add(leadObj);
	            }
	        }
        } catch(Exception e) {}
        return newLeadObjs;
    }
    public static Boolean compare(String str, String value) {
    	if(str == null || str == ''){
    		return false;
    	}
    	if(str.equalsIgnoreCase(value)) {
    		return true;
    	}
    	return false;
    }
    public static Boolean hasExceptionRules(Lead leadObj) {
    	if(compare(leadObj.Email,'fake@email.com')) {
    		return true;
    	}
    	if(compare(leadObj.FirstName,'Something') && compare(leadObj.LastName, 'New')){
    		return true;
    	}
        if(compare(leadObj.FirstName,'rctu') && compare(leadObj.LastName,'2calls4me')){
        	return true;
        }
        if(compare(leadObj.LeadSource,'About To Be Cancelled') || compare(leadObj.LeadSource, 'About To Be Cancelled UK')) {
			return true;	
		}
		// Bypass Partner Lead Duplicacy check : Case# 02364068  
		system.debug('@@@@@@@@@@@@@@ leadObj.RecordType.developername  '+ partnerRCTypeId);
		if((leadObj.RecordTypeId != null) && (String.valueOf(leadObj.RecordTypeId).trim() == partnerRCTypeId)){
			return true;
		}
		return false;
    }
    
 /*   static testMethod void testLeadValidation(){
    	try {
	     	Test.startTest();
	     	List<Lead> leadObjList = new List<Lead>();
			Lead leadObj1 = new Lead();
			leadObj1.FirstName = 'Virendra';
			leadObj1.LastName = 'Singh';
			leadObj1.Phone = '9910106823';
			leadObj1.Email = 'lead005@lead005.com';
			leadObj1.Company = 'TestIndiaLead'; //
			leadObj1.Status = '1.5 Call Out';
			leadObj1.LeadSource = 'Inbound Call';
			leadObjList.add(leadObj1);
			
			Lead leadObj2 = new Lead();
			leadObj2.FirstName = 'Virendra';
			leadObj2.LastName = 'Singh';
			leadObj2.Phone = '9910106823';
			leadObj2.Email = 'lead005@lead005.com';
			leadObj2.Company = 'TestIndiaLead'; //
			leadObj2.Status = '1.5 Call Out';
			leadObj2.LeadSource = 'Inbound Call';
			leadObjList.add(leadObj2);
	     	
	     	insert leadObjList;
	     	ValidateLeadDuplicacy.validatePerToday(leadObjList);
	     	
	     	Lead leadObj3 = new Lead();
			leadObj3.FirstName = 'Virendra';
			leadObj3.LastName = 'Singh';
			leadObj3.Phone = '9910106823';
			leadObj3.Email = 'resr@test.com';
			leadObj3.Company = 'TestIndiaLead'; //
			leadObj3.Status = '1.5 Call Out';
			leadObj3.LeadSource = 'Inbound Chat';
			leadObjList.add(leadObj3);
			
	     	ValidateLeadDuplicacy.validatePerStages(leadObjList);
	     	Test.stopTest();
    	} catch(Exception e) {}
     }*/
}