/*
	Lead_Before on Lead trigger event BeforeInsert for
	Common Class to Search Lead and Contacts based On Email, Phone and Domain for BT Web service and Protection Rule Logic.
*/
public class RcDealHealper {
    
    /**************************************************STATIC VARIABLE DECLARATION*********************************************************/
    public static map<String,List<Lead>> emailLeadMap = new map<String,List<Lead>>();
    public static map<String,List<Contact>> emailContactMap = new map<String,List<Contact>>();
    public static map<String,List<Lead>> domainLeadMap = new map<String,List<Lead>>();
    public static map<String,List<Contact>> domainContactMap = new map<String,List<Contact>>();
    public static map<String,List<Lead>> phoneLeadMap = new map<String,List<Lead>>();
    public static map<String,List<Contact>> phoneContactMap = new map<String,List<Contact>>();
    /**************************************************************************************************************************************/
    
    /***************Method to search Lead and Contact on basis of Phone and Email For Single Lead************************/
    public searchResultClass LeadContactSearch(String emailId, String phoneNumber){
    	
        system.debug('Inside LeadContactSearch');
        String  domain;
        String formattedNumber = getFormattedPhone(phoneNumber);
        String conditionString = ' email =:emailId OR Phone =:phoneNumber OR Phone =:formattedNumber';
        String subConditionString = ' ORDER BY PartnerDeal_Registration_Expiration_Date__c DESC NULLS LAST LIMIT 1000';
        String leadQueryString = 'SELECT Id, PartnerDeal_Status__c, PartnerDeal_Registration_Expiration_Date__c, PartnerDeal_Registration_ID__c, RecordType.Name, Status FROM Lead WHERE IsConverted = false AND ';
        String contactExcludeRecordType = 'Internal Employee';
        String contactQueryString = 'SELECT Id, PartnerDeal_Status__c, PartnerDeal_Registration_Expiration_Date__c, PartnerDeal_Registration_ID__c, RecordType.Name, Account.RC_Account_Status__c FROM contact WHERE RecordType.Name != :contactExcludeRecordType AND ';
        List<Lead> leadList = new List<Lead>();
        List<Contact> contactList = new List<Contact>();
        searchResultClass resultClass;
        if(emailId != null){
            domain = getEmailDomain(emailId);
        }
        
        List<Segment_Data__c> DomainList = [SELECT Id, Attribute_1__c, Type__c from Segment_Data__c WHERE Attribute_1__c =:domain];
        resultClass = new searchResultClass();
        if(DomainList == null || DomainList.size() == 0){
            conditionString += ' OR email LIKE \'%@'+String.escapeSingleQuotes(domain.trim())+'\'';
        }
        conditionString = '('+conditionString+')';
        leadQueryString += conditionString + subConditionString;
        contactQueryString += conditionString + subConditionString;
        leadList = Database.query(leadQueryString);
        contactList = Database.query(contactQueryString);
        resultClass.leadResultList = leadList;
        resultClass.contactResultList = contactList;
        return resultClass;
    }
    /***************************************************************************************************************************/
    
    /*****************Method to get domain from email*********************************/
    public static String getEmailDomain(String emailId){
        String domain = emailId.substring(emailId.lastIndexOf('@')+1,emailId.length());
        return domain;    
    }
    /*********************************************************************************/
    
    /****************Wrapper classes*****************/
    public class searchResultClass{
        public List<Lead> leadResultList{get;set;}
        public List<Contact> contactResultList{get;set;}
    }
    /***********************************************/
    
    /******************Method to fetch Contacts and Leads on basis of Phone and Email for bulk data*********************/
    /*public static map<string,searchResultClass> LeadContactSearch(List<Lead> newLeadList,map<String,String> prOwnerMap, Map<String, Boolean> resultMap){
    	Set<String> phoneSet = new Set<String>();
    	Set<String> emailSet = new Set<String>();
    	map<String,phoneFormatWrapper> phoneFormatWrapperMap = new map<String,phoneFormatWrapper>();
    	map<String,RcDealHealper.searchResultClass> leadContactSearchMap = new map<String,RcDealHealper.searchResultClass>();
    	map<string,boolean> validDomainMap = new map<string,boolean>(); 
    	for(Lead leadObj : newLeadList){
    		if(leadObj.Bypass_PR__c == false || leadObj.Bypass_PR__c == NULL){
                if(leadObj.LeadSource != 'Other' && leadObj.RecordTypeName__c != 'Partner_Leads'){
                	if(!resultMap.get(leadObj.FirstName + '_' + leadObj.LastName)){
			    		if(!(string.isBlank(leadObj.Email))){
			    			emailSet.add(leadObj.Email);
			    			validDomainMap.put(RcDealHealper.getEmailDomain(leadObj.Email.trim()),false);    			
			    		}
			    		if(!(String.isBlank(leadObj.Phone))){ 				            
				            phoneFormatWrapper phoneFormatWrapperObj = new phoneFormatWrapper(); 
				            phoneFormatWrapperObj = RcDealHealper.formatPhoneNumber(leadObj.Phone);
				            phoneFormatWrapperMap.put(leadObj.Phone,phoneFormatWrapperObj);
				            
				            phoneSet.add(leadObj.Phone);
				            
				            if(!string.isBlank(phoneFormatWrapperObj.formattedNumber)){
				            	phoneSet.add(phoneFormatWrapperObj.formattedNumber);
				            }
				            if(!string.isBlank(phoneFormatWrapperObj.plusOnePhoneFormat)){
				            	phoneSet.add(phoneFormatWrapperObj.plusOnePhoneFormat);
				            }
			    		}
	                }
                }
    		}
    	}
    	
    	System.debug('=emailSet='+emailSet+'=phoneSet='+phoneSet+'=validDomainMap='+validDomainMap.keySet());
    	system.debug('=phoneSet='+phoneSet);    	
    	
    	List<String> domainList = new List<String>();    
    	set<string> finalDomainSet = new set<string>();
    	if(validDomainMap!=null && validDomainMap.size() > 0){
    		for(Segment_Data__c segmentObj : [SELECT ID,Attribute_1__c,Type__c FROM Segment_Data__c WHERE Attribute_1__c in : validDomainMap.keySet()]){   
	 			validDomainMap.put(segmentObj.Attribute_1__c,true);
    		}
    		for(String domainStr : validDomainMap.keySet()){
    			if(validDomainMap.get(domainStr)==false){
    				domainList.add('%'+domainStr);
    				finalDomainSet.add(domainStr);
    			}
    		}
    	}
    	
    	system.debug('=domainList='+domainList);
    	
        String contactExcludeRecordType = 'Internal Employee';
        String subConditionString = ' ORDER BY CreatedDate DESC ';
        String leadQueryString = 'SELECT Id,Phone,Email,Is_Protected__c,ownerId,owner.IsActive From Lead where (Is_Protected__c = true AND Owner.IsActive = true AND Email!=NULL) ';
        String contactQueryString = 'SELECT Id,Account.RecordType.Name,Account.Current_Owner__c,Account.Current_Owner__r.IsActive,Phone,Email From contact where (RecordType.Name != :contactExcludeRecordType AND Email!=NULL) ';
     	
     	Set<String> contactRecordType = new Set<String>{'VAR Visible','Internal'};
     	
        List<Lead> leadList = new List<Lead>();
        List<Contact> contactList = new List<Contact>();
        
        if(emailSet!=null && emailSet.size() > 0){
        	
    		//leadQueryString+= ' AND ( Email In : emailSet OR Domain__c In : finalDomainSet OR Phone In : phoneSet) ';    		
    		//contactQueryString+= ' AND ( Email In : emailSet OR Domain__c In : finalDomainSet OR Phone In : phoneSet) ';
    		
    		//leadQueryString = 'SELECT Id,Phone,Email,Is_Protected__c,ownerId,owner.IsActive From Lead where (Email IN : emailSet OR Phone IN : phoneSet) AND (Is_Protected__c = true AND Owner.IsActive = true)';
        	//leadQueryString = 'SELECT Id,Phone,Email,Is_Protected__c,ownerId,owner.IsActive From Lead where (Email LIKE : domainList) AND (Is_Protected__c = true AND Owner.IsActive = true) ';
        	//leadQueryString = 'SELECT Id,Phone,Email,Is_Protected__c,ownerId,owner.IsActive From Lead where (Domain__c IN : finalDomainSet) AND (Is_Protected__c = true AND Owner.IsActive = true) ';
        	//contactQueryString = 'SELECT Id,Account.RecordType.Name,Account.Current_Owner__c,Account.Current_Owner__r.IsActive,Phone,Email From contact where (Email IN : emailSet OR Phone IN : phoneSet OR Domain__c IN : finalDomainSet) AND RecordType.Name != :contactExcludeRecordType ';
        	
        	date startDate = date.parse('1/1/2014');
			date endDate = date.parse('12/31/2014');
        	
        	leadQueryString = 'SELECT Id,Phone,Email,Is_Protected__c,ownerId,owner.IsActive From Lead where (Email IN : emailSet OR Phone IN : phoneSet) AND (Is_Protected__c = true AND Owner.IsActive = true) ';
        	String leadQueryStringEmail = 'SELECT Id,Phone,Email,Is_Protected__c,ownerId,owner.IsActive From Lead where (Email LIKE : domainList) AND (Is_Protected__c = true AND Owner.IsActive = true) ';
        	contactQueryString = 'SELECT Id,Account.RecordType.Name,Account.Current_Owner__c,Account.Current_Owner__r.IsActive,Phone,Email From contact where (CreatedDate>=: startDate AND CreatedDate<=: endDate) AND (Email IN : emailSet OR Phone IN : phoneSet OR Domain__c IN : finalDomainSet) AND (RecordType.Name In : contactRecordType) ';
        	String contactQueryStringEmail = 'SELECT Id,Account.RecordType.Name,Account.Current_Owner__c,Account.Current_Owner__r.IsActive,Phone,Email From contact where (Domain__c IN : finalDomainSet) ';
        	
        	leadQueryString+=subConditionString;
			contactQueryString+=subConditionString;
			
			leadQueryStringEmail+=subConditionString+' LIMIT 1000 ';
			contactQueryStringEmail+=subConditionString;
			
			//newLeadList[0].addError('==>'+leadQueryString+'\n');
			//newLeadList[0].addError('==>'+contactQueryString);
			
			system.debug('leadQueryString='+leadQueryString);
        	system.debug('contactQueryString='+contactQueryString);
        	
        	leadList = Database.query(leadQueryString);
        	contactList = Database.query(contactQueryString);
        	
        	List<Lead> leadListEmail = new List<Lead>();
        	List<Contact> contactListEmail = new List<Contact>();
        	
        	//leadListEmail = Database.query(leadQueryStringEmail);
        	//contactListEmail = Database.query(contactQueryStringEmail); 
        	
        	//leadList.addAll(leadListEmail);
        	//contactList.addAll(contactListEmail);
        	
        	if( ( leadList!=null && leadList.size() > 0 ) || ( contactList!=null && contactList.size() > 0 ) ){        	
	        	createPhoneEmailMaps(leadList,contactList,emailSet,phoneSet,finalDomainSet,leadContactSearchMap);	        
	        	createLeadContactSearchMap(newLeadList,phoneFormatWrapperMap,leadContactSearchMap);
        	}
        }       
        
        system.debug('=emailLeadMap='+emailLeadMap);
        system.debug('=emailContactMap='+emailContactMap);
        system.debug('=phoneLeadMap='+phoneLeadMap);
        system.debug('=phoneContactMap='+phoneContactMap);
        system.debug('=leadContactSearchMap='+leadContactSearchMap);
        
        return leadContactSearchMap;    	
    }*/
    public static map<string,searchResultClass> LeadContactSearch(List<Lead> newLeadList,map<String,String> prOwnerMap, Map<String, Boolean> resultMap, 
																  Set<string> includedLeadStatusSet){
    	Set<String> phoneSet = new Set<String>();
    	Set<String> emailSet = new Set<String>();
    	map<String,phoneFormatWrapper> phoneFormatWrapperMap = new map<String,phoneFormatWrapper>();
    	map<String,RcDealHealper.searchResultClass> leadContactSearchMap = new map<String,RcDealHealper.searchResultClass>();
    	map<string,boolean> validDomainMap = new map<string,boolean>(); 
    	for(Lead leadObj : newLeadList){
    		if(leadObj.Bypass_PR__c == false || leadObj.Bypass_PR__c == NULL){
                if(leadObj.LeadSource != 'Other' && leadObj.RecordTypeName__c != 'Partner_Leads'){
                	if(!resultMap.get(leadObj.FirstName + '_' + leadObj.LastName)){
			    		if(!(string.isBlank(leadObj.Email))){
			    			emailSet.add(leadObj.Email);
			    			validDomainMap.put(RcDealHealper.getEmailDomain(leadObj.Email.trim()),false);    			
			    		}
			    		if(!(String.isBlank(leadObj.Phone))){ 				            
				            phoneFormatWrapper phoneFormatWrapperObj = new phoneFormatWrapper(); 
				            phoneFormatWrapperObj = RcDealHealper.formatPhoneNumber(leadObj.Phone);
				            phoneFormatWrapperMap.put(leadObj.Phone,phoneFormatWrapperObj);
				            
				            phoneSet.add(leadObj.Phone);
				            
				            if(!string.isBlank(phoneFormatWrapperObj.formattedNumber)){
				            	phoneSet.add(phoneFormatWrapperObj.formattedNumber);
				            }
				            if(!string.isBlank(phoneFormatWrapperObj.plusOnePhoneFormat)){
				            	phoneSet.add(phoneFormatWrapperObj.plusOnePhoneFormat);
				            }
			    		}
	                }
                }
    		}
    	}
    	
    	System.debug('=emailSet='+emailSet+'=phoneSet='+phoneSet+'=validDomainMap='+validDomainMap.keySet());
    	
    	List<String> domainList = new List<String>();    
    	set<string> finalDomainSet = new set<string>();
    	if(validDomainMap!=null && validDomainMap.size() > 0){
    		for(Segment_Data__c segmentObj : [SELECT ID,Attribute_1__c,Type__c FROM Segment_Data__c WHERE Attribute_1__c in : validDomainMap.keySet()]){   
	 			validDomainMap.put(segmentObj.Attribute_1__c,true);
    		}
    		for(String domainStr : validDomainMap.keySet()){
    			if(validDomainMap.get(domainStr)==false){
    				domainList.add('%'+domainStr);
    				finalDomainSet.add(domainStr);
    			}
    		}
    	}
     	
     	Set<String> contactRecordType = new Set<String>{'VAR Visible','Internal'};
     	Set<String> excludedLeadStatusSet = new Set<String>{'X. Suspect','0. Downgraded'};
     	
     	includedLeadStatusSet.removeAll(excludedLeadStatusSet);
     	
        List<Lead> leadList = new List<Lead>();
        List<Contact> contactList = new List<Contact>();
        
        Date lastDate = date.newinstance(2014, 1, 1);
        
        if(emailSet!=null && emailSet.size() > 0){
        	
        	String leadQueryString = 'SELECT Id,Phone,Email,Is_Protected__c,ownerId,owner.IsActive From Lead where (Email IN : emailSet OR Phone IN : phoneSet OR Domain__c IN : finalDomainSet) AND (Status IN : includedLeadStatusSet OR (Status IN : excludedLeadStatusSet AND CreatedDate >=: lastDate)) AND (Is_Protected__c = true AND Owner.IsActive = true) ';
        	//String leadQueryStringEmail = 'SELECT Id,Phone,Email,Is_Protected__c,ownerId,owner.IsActive From Lead where (Email LIKE : domainList) AND (Is_Protected__c = true AND Owner.IsActive = true) ';
        	String contactQueryString = 'SELECT Id,Account.RecordType.Name,Account.Current_Owner__c,Account.Current_Owner__r.IsActive,Phone,Email From contact where (Email IN : emailSet OR Phone IN : phoneSet OR Domain__c IN : finalDomainSet) AND (RecordType.Name In : contactRecordType) ';
        	//String contactQueryStringEmail = 'SELECT Id,Account.RecordType.Name,Account.Current_Owner__c,Account.Current_Owner__r.IsActive,Phone,Email From contact where (Email LIKE : domainList) AND (RecordType.Name In : contactRecordType) ';
        	
        	String subConditionString = ' ORDER BY CreatedDate DESC ';
        	
        	leadQueryString+=subConditionString;
			contactQueryString+=subConditionString;
			
			//leadQueryStringEmail+=subConditionString+' LIMIT 1000 ';
			//contactQueryStringEmail+=subConditionString+' LIMIT 1000 ';
			
			//newLeadList[0].addError('==>'+leadQueryString+'\n');
			//newLeadList[0].addError('==>'+contactQueryString);
			
			system.debug('leadQueryString='+leadQueryString);
        	system.debug('contactQueryString='+contactQueryString);
        	
        	leadList = Database.query(leadQueryString);
        	contactList = Database.query(contactQueryString);
        	
        	//List<Lead> leadListEmail = new List<Lead>();
        	//List<Contact> contactListEmail = new List<Contact>();
        	
        	//leadListEmail = Database.query(leadQueryStringEmail);
        	//contactListEmail = Database.query(contactQueryStringEmail); 
        	
        	//leadList.addAll(leadListEmail);
        	//contactList.addAll(contactListEmail);
        	
        	if( ( leadList!=null && leadList.size() > 0 ) || ( contactList!=null && contactList.size() > 0 ) ){        	
	        	createPhoneEmailMaps(leadList,contactList,emailSet,phoneSet,finalDomainSet,leadContactSearchMap);	        
	        	createLeadContactSearchMap(newLeadList,phoneFormatWrapperMap,leadContactSearchMap);
        	}
        }       
        
        system.debug('=emailLeadMap='+emailLeadMap);
        system.debug('=emailContactMap='+emailContactMap);
        system.debug('=phoneLeadMap='+phoneLeadMap);
        system.debug('=phoneContactMap='+phoneContactMap);
        system.debug('=leadContactSearchMap='+leadContactSearchMap);
        
        return leadContactSearchMap;    	
    }
    /*******************************************************************************************************************************/
    
    /******************Method to create Map on the basis of Email and Phone on searched result***********************************/
    public static void createPhoneEmailMaps(List<Lead>leadList, List<Contact> contactList, Set<String> emailSet,Set<String> phoneSet,
    										Set<String> finalDomainSet,map<String,RcDealHealper.searchResultClass> leadContactSearchMap){   
    	for(Lead leadObj : leadList){
        	if(!string.isBlank(leadObj.Email) && (emailSet.contains(leadObj.Email))){
        		if(emailLeadMap!=null && emailLeadMap.get(leadObj.Email)!=null){
        			List<Lead> tempLeadList = emailLeadMap.get(leadObj.Email);
        			tempLeadList.add(leadObj);
        			emailLeadMap.put(leadObj.Email,tempLeadList);    
        		} else {
        			emailLeadMap.put(leadObj.Email,new List<Lead>{leadObj});   
        		}
        	}
        	if(!string.isBlank(leadObj.Email) && finalDomainSet.contains(RcDealHealper.getEmailDomain(leadObj.Email.trim()))){
        		if(domainLeadMap!=null && domainLeadMap.get(RcDealHealper.getEmailDomain(leadObj.Email.trim()))!=null){
        			List<Lead> tempLeadList = domainLeadMap.get(RcDealHealper.getEmailDomain(leadObj.Email.trim()));
        			tempLeadList.add(leadObj);
        			domainLeadMap.put(RcDealHealper.getEmailDomain(leadObj.Email.trim()),tempLeadList);    
        		} else {
        			domainLeadMap.put(RcDealHealper.getEmailDomain(leadObj.Email.trim()),new List<Lead>{leadObj});   
        		}
        	}
        	
        	if(!string.isBlank(leadObj.Phone) && phoneSet.contains(leadObj.Phone) ){        		
        		if(phoneLeadMap!=null && phoneLeadMap.get(leadObj.Phone)!=null){
        			List<Lead> tempLeadList = phoneLeadMap.get(leadObj.Phone);
        			tempLeadList.add(leadObj);
        			phoneLeadMap.put(leadObj.Phone,tempLeadList);
        		}else{
        			phoneLeadMap.put(leadObj.Phone,new List<Lead>{leadObj});
        		}   		
        	}
        }
        
        for(Contact conObj : contactList){
        	if(conObj.Account.RecordType.Name != 'Partner Account'){
	        	if(!string.isBlank(conObj.Email) && (emailSet.contains(conObj.Email))){
	        		if(emailContactMap!=null && emailContactMap.get(conObj.Email)!=null){
	        			List<Contact> tempContactList = emailContactMap.get(conObj.Email);
	        			tempContactList.add(conObj);
	        			emailContactMap.put(conObj.Email,tempContactList);    
	        		} else {
	        			emailContactMap.put(conObj.Email,new List<Contact>{conObj});   
	        		}
	        	}
	        	if(!string.isBlank(conObj.Email) && finalDomainSet.contains(RcDealHealper.getEmailDomain(conObj.Email.trim()))){
	        		if(domainContactMap!=null && domainContactMap.get(RcDealHealper.getEmailDomain(conObj.Email.trim()))!=null){
	        			List<Contact> tempContactList = domainContactMap.get(RcDealHealper.getEmailDomain(conObj.Email.trim()));
	        			tempContactList.add(conObj);
	        			domainContactMap.put(RcDealHealper.getEmailDomain(conObj.Email.trim()),tempContactList);    
	        		} else {
	        			domainContactMap.put(RcDealHealper.getEmailDomain(conObj.Email.trim()),new List<Contact>{conObj});   
	        		}
	        	}
	        	
	        	if(!string.isBlank(conObj.Phone) && phoneSet.contains(conObj.Phone) ){        		
	        		if(phoneContactMap!=null && phoneContactMap.get(conObj.Phone)!=null){
	        			List<Contact> tempContactList = phoneContactMap.get(conObj.Phone);
	        			tempContactList.add(conObj);
	        			phoneContactMap.put(conObj.Phone,tempContactList);
	        		}else{
	        			phoneContactMap.put(conObj.Phone,new List<Contact>{conObj});
	        		}   		
	        	}
        	}
        }
    }
    /*****************************************************************************************************************************************/
    
    /*********************Create Unique "Email+Phone" as a key for Map to get searched List of Lead and Contacts*******************************/ 
    public static void createLeadContactSearchMap(List<Lead> newLeadList,map<String,phoneFormatWrapper> phoneFormatWrapperMap,
    												map<String,RcDealHealper.searchResultClass> leadContactSearchMap){
    	for(Lead leadObj : newLeadList){
        	String uniqueKey = ( !string.isBlank(leadObj.Email) ? leadObj.Email : '') + ( !string.isBlank(leadObj.Phone) ? leadObj.Phone : '');        	
        	searchResultClass resultClass = new searchResultClass();
        	resultClass.leadResultList = new List<Lead>();
        	resultClass.contactResultList = new List<Contact>();
        	if(!string.isBlank(leadObj.Email)){
        		if(emailLeadMap!=null && emailLeadMap.get(leadObj.Email)!=null){
        			resultClass.leadResultList.addAll(emailLeadMap.get(leadObj.Email));
        			leadContactSearchMap.put(uniqueKey,resultClass);
        		}
        		if(emailContactMap!=null && emailContactMap.get(leadObj.Email)!=null){
        			resultClass.contactResultList.addAll(emailContactMap.get(leadObj.Email));
        			leadContactSearchMap.put(uniqueKey,resultClass);
        		}
        		if(domainLeadMap!=null && domainLeadMap.get(RcDealHealper.getEmailDomain(leadObj.Email.trim()))!=null){
        			resultClass.leadResultList.addAll(domainLeadMap.get(RcDealHealper.getEmailDomain(leadObj.Email.trim())));
        			leadContactSearchMap.put(uniqueKey,resultClass);
        		}
        		if(domainContactMap!=null && domainContactMap.get(RcDealHealper.getEmailDomain(leadObj.Email.trim()))!=null){
        			resultClass.contactResultList.addAll(domainContactMap.get(RcDealHealper.getEmailDomain(leadObj.Email.trim())));
        			leadContactSearchMap.put(uniqueKey,resultClass);
        		}
        		
        	}
        	if(!string.isBlank(leadObj.Phone)){
        		String formattedNumber = ( phoneFormatWrapperMap!=null && 
        								   phoneFormatWrapperMap.get(leadObj.Phone)!=null && 
        								   !string.isBlank(phoneFormatWrapperMap.get(leadObj.Phone).formattedNumber) 
        									? phoneFormatWrapperMap.get(leadObj.Phone).formattedNumber : '');
        		String plusOnePhoneFormat = ( phoneFormatWrapperMap!=null && 
        								   phoneFormatWrapperMap.get(leadObj.Phone)!=null && 
        								   !string.isBlank(phoneFormatWrapperMap.get(leadObj.Phone).plusOnePhoneFormat) 
        									? phoneFormatWrapperMap.get(leadObj.Phone).plusOnePhoneFormat : '');
        									
        		if(leadContactSearchMap!=null && leadContactSearchMap.get(uniqueKey)!=null){
        			resultClass = leadContactSearchMap.get(uniqueKey);
        		}
        		
        		if(phoneLeadMap!=null && phoneLeadMap.get(leadObj.Phone)!=null){
        			resultClass.leadResultList.addAll(phoneLeadMap.get(leadObj.Phone));
        		}
        		
        		if(phoneLeadMap!=null && phoneLeadMap.get(formattedNumber)!=null){
        			resultClass.leadResultList.addAll(phoneLeadMap.get(formattedNumber));
        		}
        		
        		if(phoneLeadMap!=null && phoneLeadMap.get(plusOnePhoneFormat)!=null){
        			resultClass.leadResultList.addAll(phoneLeadMap.get(plusOnePhoneFormat));
        		}
        		
        		if(phoneContactMap!=null && phoneContactMap.get(leadObj.Phone)!=null){
        			resultClass.contactResultList.addAll(phoneContactMap.get(leadObj.Phone));
        		}
        		
        		if(phoneContactMap!=null && phoneContactMap.get(leadObj.Phone)==null && phoneContactMap.get(formattedNumber)!=null){
        			resultClass.contactResultList.addAll(phoneContactMap.get(formattedNumber));
        		}
        		
        		if(phoneContactMap!=null && phoneContactMap.get(plusOnePhoneFormat)!=null){
        			resultClass.contactResultList.addAll(phoneContactMap.get(plusOnePhoneFormat));
        		}
        		
        		leadContactSearchMap.put(uniqueKey,resultClass);        		
        	}
        }	
    }
    /********************************************************************************************************************************/
    
    /***************Format the Phone Number and return its wrapper Object******************************/
    public static phoneFormatWrapper formatPhoneNumber(string phoneNumber){    	
        String strPhoneValue = phoneNumber.trim();  
        phoneFormatWrapper wrapperObj = new phoneFormatWrapper();                                   
        if(strPhoneValue!=''){
            if(strPhoneValue.startsWith('+44') || strPhoneValue.startsWith('44') || strPhoneValue.startsWith('0')){
                wrapperObj.formattedNumber = ValidationUtility.validatePhoneNumber(strPhoneValue,'UK');
            }else{
                wrapperObj.formattedNumber = ValidationUtility.commonUSandCAPhoneFormat(strPhoneValue);
            }                        
            if(!strPhoneValue.startsWith('+44') && !strPhoneValue.startsWith('44') && !strPhoneValue.startsWith('0')){
                wrapperObj.plusOnePhoneFormat = '1' + strPhoneValue;
            }
        } 
        return wrapperObj;
    }
    /************************************************************************************************/
    
    /*******************************Returns the Brand Name******************************************/
    public static String getBTBrand(){
    	String strBTBrand;
    	if(!Test.isRunningTest()){
	        String brandId = Brand_List__c.getAll().get('BT_Brand').Brand_Id__c;
	        String brandName = Brand_List__c.getAll().get('BT_Brand').Brand_Name__c;
	        String brandExtName = Brand_List__c.getAll().get('BT_Brand').Brand_Name_External__c;
	        if(String.isNotBlank(brandId)){
	        	strBTBrand = brandId;
	        }else if(String.isNotBlank(brandName)){
	        	strBTBrand = brandName;
	        }else if(String.isNotBlank(brandExtName)){
	        	strBTBrand = brandExtName;
	        }else{
	        	strBTBrand = 'BT Business';
	        }
	    }else{
	    	strBTBrand = 'BT Business';
	    }
    	return strBTBrand;
    }
    /***************************************************************************************************/
	
	/*****************************Return Formated Phone Number******************************************/
	public String getFormattedPhone(String phoneNumber){
        String formattedNumber = '';
        if(phoneNumber!=''){
            if(phoneNumber.startsWith('+44') || phoneNumber.startsWith('44') || phoneNumber.startsWith('0')){
                formattedNumber = ValidationUtility.validatePhoneNumber(phoneNumber,'UK');
            }else{
                formattedNumber = ValidationUtility.commonUSandCAPhoneFormat(phoneNumber);
            }
        } 
        return formattedNumber;
    }
    /*************************************************************************************************/
    
    /*********Wrapper for Phone Number Format******/ 
    public class phoneFormatWrapper{
    	public string formattedNumber;
    	public string plusOnePhoneFormat;
    }
    /*********************************************/    
}