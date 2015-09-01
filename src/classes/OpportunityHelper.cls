public class OpportunityHelper {  
	public static string defaultOpportunityStage; // = '3. Qualified';
	public static string closedStage; //  = '8. Closed Won'; 
	public static Set<String> alteredStages = new Set<String>();
	public static Set<String> closedStagesSet = new Set<String>();
    static Map<String, Id> oppRecordTypeMap = new Map<String, Id>();
    static { 
        if(oppRecordTypeMap == null || oppRecordTypeMap.size() == 0) {
            oppRecordTypeMap = new Map<String, Id>(); 
            System.debug('### INSIDE STATIC BLOCK ###');
            for(RecordType recordObj : [SELECT Id, Name FROM RecordType]) { 
                oppRecordTypeMap.put(recordObj.name, recordObj.Id);
            } 
    	} 
   		if(alteredStages.size() == 0) {
       		// New Stages
            alteredStages.add('3. ActivePipe');
            alteredStages.add('1. Qualify');
            alteredStages.add('2. Problem');
            alteredStages.add('5. Proposal');
            alteredStages.add('3. Solution');
            alteredStages.add('5. Agreement');
            alteredStages.add('6. Order');
            
            // Old Stages
            alteredStages.add('3. Qualified');
            alteredStages.add('4. Discovery');
            alteredStages.add('5. Proposal');
            alteredStages.add('6. Agreement');
            alteredStages.add('7. Order');
   		}
   		if(closedStagesSet.size() == 0) {
       		// Old Stages
            closedStagesSet.add('4. Closed');
            closedStagesSet.add('8. Closed Won');   
            //New Stages
            closedStagesSet.add('7. Closed Won');		
   		}
   		if(String.isBlank(defaultOpportunityStage)) {
   			Schema.DescribeFieldResult fieldDesc = Opportunity.StageName.getDescribe(); 
			List<Schema.PicklistEntry> stagepickValueList = fieldDesc.getPicklistValues();
   			for(Schema.PicklistEntry stagepickValue : stagepickValueList) {
		        if(stagepickValue.isActive() && stagepickValue.isDefaultValue()) {
		        	defaultOpportunityStage = stagepickValue.getLabel();               
		            break;
		        } else if(stagepickValue.isActive() && stagepickValue.getLabel() == '3. ActivePipe') {
		        	defaultOpportunityStage = stagepickValue.getLabel();
		        	break; 
		        } else if(stagepickValue.isActive() && (stagepickValue.getLabel() == '1. Qualify' 
		        										|| stagepickValue.getLabel() == '3. Qualified')) {
		        	defaultOpportunityStage = stagepickValue.getLabel();
		        	break; 
		        }
    		}
    		System.debug('### defaultOpportunityStage ###'+defaultOpportunityStage);	
   		}
   		if(String.isBlank(closedStage)) {
   			Schema.DescribeFieldResult fieldDesc = Opportunity.StageName.getDescribe(); 
			List<Schema.PicklistEntry> stagepickValueList = fieldDesc.getPicklistValues();
   			for(Schema.PicklistEntry stagepickValue : stagepickValueList) {
    			if(stagepickValue.isActive() && stagepickValue.getLabel().containsIgnoreCase('Closed')) {
		        	closedStage = stagepickValue.getLabel();
		        	break; 
		        }
    		}
    		System.debug('### closedStage ###'+ closedStage);	
   		}
    }
    public static Id getOppRecordTypeMap (String recordType) {
        if(oppRecordTypeMap == null || oppRecordTypeMap.size() == 0) {
            oppRecordTypeMap = new Map<String, Id>();
            System.debug('### INSIDE MAP METHOD ###');
            for(RecordType recordObj : [SELECT Id, Name FROM RecordType]) {
                oppRecordTypeMap.put(recordObj.name, recordObj.Id);
            }
        } else {
            System.debug('### INSIDE MAP METHOD INITILIZED ###');
        }
        return oppRecordTypeMap.get(recordType);
    }
    public static Boolean isActiveOpp(String oppStage) {
    	if(String.isBlank(oppStage)) {
 			return false;
 		} 
    	return OpportunityHelper.alteredStages.contains(oppStage);
    }
    
 	public static Boolean isClosedOpp(String oppStage) {
 		if(String.isBlank(oppStage)) {
 			return false;
 		} 
    	return OpportunityHelper.closedStagesSet.contains(oppStage);
    }
    
    public static map<string,List<string>> getApprovedBrandList(List<Opportunity> newOpportunityList) {
    	map<string,List<string>> approvedBrandListMap = new map<string,List<string>>();
    	try {
    		if(UserInfo.getUserType() == 'PowerPartner') {
    			User userObjDetails = [select Contact.Account.Permitted_Brands__c,Contact.Account.Partner_ID__c 
    										from User where id = :UserInfo.getUserId()];
	    		if(userObjDetails != null && userObjDetails.Contact.Account.Permitted_Brands__c != null &&
	    			userObjDetails.Contact.Account.Partner_ID__c != null) {
	    			approvedBrandListMap.put(userObjDetails.Contact.Account.Partner_ID__c,
	    										userObjDetails.Contact.Account.Permitted_Brands__c.split(';'));
	    		}	
    		} else {
    			set<string> partnerIdSet = new set<string>();
    			for(Opportunity oppObj: newOpportunityList) {
    				if(!string.isBlank(oppObj.Partner_ID__c)) {
    					partnerIdSet.add(oppObj.Partner_ID__c);
    				}
    			}
    			for(Account accObj : [select Permitted_Brands__c,Partner_ID__c from Account where RecordType.Name = 'Partner Account' 
    									and Partner_ID__c IN :partnerIdSet]) {
    				if(accObj.Permitted_Brands__c != null) {
    					approvedBrandListMap.put(accObj.Partner_ID__c,accObj.Permitted_Brands__c.split(';'));		
    				}						
    			}
			}
    	} catch(Exception ex) {}
    	return approvedBrandListMap;  
    }
    
    public static void checkPartnerOpportunityPermittedByBrand(List<Opportunity> newoppList, map<Id,Opportunity> oppoldMap, 
    									map<string,List<string>> approvedBrandListMap) {
    	boolean isBrandPermitted = false;
    	try {
    		Schema.DescribeSObjectResult result = Opportunity.SObjectType.getDescribe();
    		Map<ID,Schema.RecordTypeInfo> rtMapByName = result.getRecordTypeInfosById(); 
    		if(newoppList != null ) { //&& newLeadList.size() == 1
    			for(Opportunity newOppObj : newoppList) {
    				isBrandPermitted = false;
    				if(newOppObj.RecordTypeId != null && rtMapByName != null && rtMapByName.get(newOppObj.RecordTypeId).getName() == 'VAR Opportunity' &&
    					approvedBrandListMap != null && newOppObj.Partner_ID__c != null && 
    					approvedBrandListMap.get(newOppObj.Partner_ID__c) != null && newOppObj.Partner_ID__c != null && 
    					(oppoldMap == null || oppoldMap.get(newOppObj.id).Brand_Name__c != newOppObj.Brand_Name__c)) {
	       				for(string strBrand : approvedBrandListMap.get(newOppObj.Partner_ID__c)) {
	       					if(strBrand.trim() == newOppObj.Brand_Name__c) {  
	       						isBrandPermitted = true;
	       						break;
	       					}
	       				}
	       				if(isBrandPermitted == false) {
	       					newOppObj.AddError('You are not permitted to sell this Brand. '+
                                        		'Please contact <a style="font-size:12px;" '+
                                        		'href=mailto:resellers@ringcentral.com>resellers@ringcentral.com</a> to gain access to this Brand.');
	       				}
	   				}	
    			}
	  		}
    	} catch(Exception ex) {}
    } 
}