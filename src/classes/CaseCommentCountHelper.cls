public class CaseCommentCountHelper {
	set<Id> caseIdSet = new set<Id>();
	set<Id> createdUserIdSet = new set<Id>();
	
	public map<Id,Case> getCaseCommentCountInfo(List<CaseComment> caseCommentList) {
		map<Id,Case> caseCommentMap = new map<Id,Case>();
		try {
			for(CaseComment caseCommentObj : caseCommentList) {
		    	if(!string.IsBlank(caseCommentObj.parentId)) {
		    		caseIdSet.add(caseCommentObj.parentId);
		    	}
	    	}
	    	if(caseIdSet != null && caseIdSet.size()>0) {
		    	caseCommentMap = new map<Id,Case>([select No_of_Private_Comments__c, No_of_Public_Comments__c, Created_by_customer__c,Created_by_Agent__c 
		    										from Case where Id IN :caseIdSet]);
		    }	
		} catch(Exception ex) {}
		return caseCommentMap;
	}
	
	public map<Id,User> getcreatedUserMap(List<CaseComment> caseCommentList) {
		map<Id,User> createdUserMap = new map<Id,User>();
		try {
			for(CaseComment caseCommentObj : caseCommentList) {
	    		createdUserIdSet.add(caseCommentObj.createdById);	
	    	}
	    	createdUserMap = new  map<Id,User>([select email from User where Id IN : createdUserIdSet]);	
		} catch(Exception ex) {}
		return createdUserMap;
	}
	
	public List<Case> getUpdatedCaseListOnDelete(List<CaseComment> caseCommentList,map<Id,Case> caseCommentMap,map<Id,User> createdUserMap) {
		List<Case> CaseListToUpd = new List<Case>();
		try {
			for(CaseComment caseCommentObj : caseCommentList) {
		    	if(caseCommentMap != null && caseCommentObj.parentId != null && caseCommentMap.get(caseCommentObj.parentId) != null) {
		    		Case caseObjTOUpd = new Case(Id = caseCommentObj.ParentId);
		    			if(caseCommentObj.IsPublished) {
		    				caseObjTOUpd.No_of_Public_Comments__c = (caseCommentMap.get(caseCommentObj.parentId).No_of_Public_Comments__c == null ||
		    															caseCommentMap.get(caseCommentObj.parentId).No_of_Public_Comments__c == 0) ? 
		    															0 : caseCommentMap.get(caseCommentObj.parentId).No_of_Public_Comments__c - 1;
		    			} else if(caseCommentObj.IsPublished == false) {
		    				caseObjTOUpd.No_of_Private_Comments__c = (caseCommentMap.get(caseCommentObj.parentId).No_of_Private_Comments__c == null ||	
		    															caseCommentMap.get(caseCommentObj.parentId).No_of_Private_Comments__c == 0) ? 
		    															0 : caseCommentMap.get(caseCommentObj.parentId).No_of_Private_Comments__c - 1;
		    			}
		    			if(createdUserMap != null && createdUserMap.get(caseCommentObj.createdByID).Email != null &&
		    					//createdUserMap.get(caseCommentObj.createdByID).Email.indexOf('@ringcentral.com') != -1) {
		    					createdUserMap.get(caseCommentObj.createdByID).Email.split('@')[1].containsIgnoreCase('ringcentral.com')) {
		    				caseObjTOUpd.Created_by_Agent__c = (caseCommentMap.get(caseCommentObj.parentId).Created_by_Agent__c == null ||
		    														caseCommentMap.get(caseCommentObj.parentId).Created_by_Agent__c == 0) ? 
		    															0 : caseCommentMap.get(caseCommentObj.parentId).Created_by_Agent__c - 1;
		    			} else {
		    				caseObjTOUpd.Created_by_customer__c = (caseCommentMap.get(caseCommentObj.parentId).Created_by_customer__c == null || 
		    														caseCommentMap.get(caseCommentObj.parentId).Created_by_customer__c == 0) ? 
		    															0 : caseCommentMap.get(caseCommentObj.parentId).Created_by_customer__c - 1;
		    			}
		    		CaseListToUpd.add(caseObjTOUpd); 
		    	}
	    	}
		} catch(Exception ex) {}
		return CaseListToUpd;
	}
	
	public List<Case> getUpdatedCaseListOnInsOrUpd(map<Id,CaseComment> caseCommentOldMap ,List<CaseComment> caseCommentListNew,map<Id,Case> caseCommentMap,map<Id,User> createdUserMap) {
		List<Case> CaseListToUpd = new List<Case>();
		try {
			for(CaseComment caseCommentObj : caseCommentListNew) {
		    	if(caseCommentMap != null && caseCommentObj.parentId != null && caseCommentMap.get(caseCommentObj.parentId) != null) {
		    		Case caseObjTOUpd = new Case(Id = caseCommentObj.ParentId);
		    		if(Trigger.isInsert) {
		    			if(caseCommentObj.IsPublished) {
		    				caseObjTOUpd.No_of_Public_Comments__c = (caseCommentMap.get(caseCommentObj.parentId).No_of_Public_Comments__c == null ||
		    														  caseCommentMap.get(caseCommentObj.parentId).No_of_Public_Comments__c == 0) ? 
		    															1 : caseCommentMap.get(caseCommentObj.parentId).No_of_Public_Comments__c + 1;
		    			} else {
		    				caseObjTOUpd.No_of_Private_Comments__c = (caseCommentMap.get(caseCommentObj.parentId).No_of_Private_Comments__c == null ||
		    														  caseCommentMap.get(caseCommentObj.parentId).No_of_Private_Comments__c == 0) ? 
		    															1 : caseCommentMap.get(caseCommentObj.parentId).No_of_Private_Comments__c + 1;
		    			}
		    			if(createdUserMap != null && createdUserMap.get(caseCommentObj.createdByID).Email != null &&
		    					createdUserMap.get(caseCommentObj.createdByID).Email.split('@')[1].containsIgnoreCase('ringcentral.com')) {
		    				caseObjTOUpd.Created_by_Agent__c = (caseCommentMap.get(caseCommentObj.parentId).Created_by_Agent__c == null ||
		    													caseCommentMap.get(caseCommentObj.parentId).Created_by_Agent__c == 0) ? 
		    															1 : caseCommentMap.get(caseCommentObj.parentId).Created_by_Agent__c + 1;
		    			} else {
		    				caseObjTOUpd.Created_by_customer__c = (caseCommentMap.get(caseCommentObj.parentId).Created_by_customer__c == null ||
		    														caseCommentMap.get(caseCommentObj.parentId).Created_by_customer__c == 0) ? 
		    															1 : caseCommentMap.get(caseCommentObj.parentId).Created_by_customer__c + 1;
		    			}
		    		} else if(Trigger.isUpdate) {
		    			CaseComment CasecommentObjOld = caseCommentOldMap.get(caseCommentObj.id);
		    			if(CasecommentObjOld.IsPublished == false &&  caseCommentObj.IsPublished) {
		    				//System.Debug('>>11>>'+ caseCommentMap.get(caseCommentObj.parentId).No_of_Public_Comments__c);
		    				//System.Debug('>>22>>'+ caseCommentMap.get(caseCommentObj.parentId).No_of_Private_Comments__c);
		    				caseObjTOUpd.No_of_Public_Comments__c = (caseCommentMap.get(caseCommentObj.parentId).No_of_Public_Comments__c == null 
		    															|| caseCommentMap.get(caseCommentObj.parentId).No_of_Public_Comments__c == 0) 
		    															? 1 : caseCommentMap.get(caseCommentObj.parentId).No_of_Public_Comments__c + 1;
		    				caseObjTOUpd.No_of_Private_Comments__c = (caseCommentMap.get(caseCommentObj.parentId).No_of_Private_Comments__c == null 
		    															|| caseCommentMap.get(caseCommentObj.parentId).No_of_Private_Comments__c == 0) 
		    															? 0 : caseCommentMap.get(caseCommentObj.parentId).No_of_Private_Comments__c - 1;	
		    				//System.Debug('>>55>>'+ caseObjTOUpd.No_of_Public_Comments__c);
		    				//System.Debug('>>66>>'+ caseObjTOUpd.No_of_Private_Comments__c);										
		    															
		    			} else if(CasecommentObjOld.IsPublished == true &&  caseCommentObj.IsPublished == false) {
		    				//System.Debug('>>33>>'+ caseCommentMap.get(caseCommentObj.parentId).No_of_Public_Comments__c);
		    				//System.Debug('>>44>>'+ caseCommentMap.get(caseCommentObj.parentId).No_of_Private_Comments__c);
		    				caseObjTOUpd.No_of_Private_Comments__c = (caseCommentMap.get(caseCommentObj.parentId).No_of_Private_Comments__c == null 
		    															|| caseCommentMap.get(caseCommentObj.parentId).No_of_Private_Comments__c == 0) 
		    															?  1 : caseCommentMap.get(caseCommentObj.parentId).No_of_Private_Comments__c + 1;
		    				caseObjTOUpd.No_of_Public_Comments__c = (caseCommentMap.get(caseCommentObj.parentId).No_of_Public_Comments__c == null 
		    															|| caseCommentMap.get(caseCommentObj.parentId).No_of_Public_Comments__c == 0) 
		    															? 0 : caseCommentMap.get(caseCommentObj.parentId).No_of_Public_Comments__c - 1;
		    				//System.Debug('>>77>>'+ caseObjTOUpd.No_of_Private_Comments__c);
		    				//System.Debug('>>88>>'+ caseObjTOUpd.No_of_Public_Comments__c);											
		    			}
		    		} 
		    		CaseListToUpd.add(caseObjTOUpd); 
		    	}
	    	}
		} catch(Exception ex) {}
		return CaseListToUpd;
	}
}