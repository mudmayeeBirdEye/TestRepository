/*************************************************
Trigger on Event object
After Update: If AID or Five9 DNIS fields are updated try to find matching campaigns to add for membership
After Insert: Set Primary Campaign field.
              Send email notification to owner if owner is RCSF Sync (Means that lead was not distributed)
              Send email notification to owner if owner is not RCSF Sync but created by RCSF (Means that lead was distributed)
              Convert Partner Request leads                                         
/************************************************/

trigger Lead_After on Lead (after insert, after update) {
	
	string strError = '';
	strError = strError  + 'Lead After trigger started On Lead Conversion ' +  +' \r\n';
	strError = strError  + 'Lead After trigger Variable BY_PASS_LEAD_UPDATE: ' + TriggerHandler.BY_PASS_LEAD_UPDATE + ' \r\n';
	strError = strError  + 'Lead After trigger Variable BY_PASS_LEAD_UPDATE_ON_INSERT: ' + TriggerHandler.BY_PASS_LEAD_UPDATE_ON_INSERT + ' \r\n';
	
	if(Trigger.isUpdate && trigger.isAfter){
		if (Trigger.new.size() == 1) {                
		    if (Trigger.old[0].isConverted == false && Trigger.new[0].isConverted == true){
		    	strError = StrError + 'Lead Id: ' + Trigger.new[0].Id + ' \r\n';
				insert new Exception_And_Notification_History__c(
		    		Exception__c = 'Lead Conversion Exception - Lead_After Trigger 1 - '+ System.Now().format(), 
		    		Exception_Desc__c = strError, Object_Type__c = 'Lead',
		    		RecordTypeId = '01280000000UF6F'); 
		    }
		}
	}
	
	/*********For Desired Behaviour of Campaign Case**************/
	if(TriggerHandler.BY_PASS_LEAD_UPDATE){
		return;
	}
	/************************************************************/
	
    if(trigger.isUpdate){
    	if(TriggerHandler.BY_PASS_LEAD_UPDATE_ON_INSERT)
    		return;
    	
    	strError = strError  + 'Before Campaign Member Creation ' + ' \r\n';
		
		List<CampaignMember> campaignMemberList = new List<CampaignMember>();
    	Set<String> campaignIdSet = new Set<String>();
    	
    	try {
	    	for(Lead newLeadObj: trigger.new) {	  
	    		Lead oldLeadObj = Trigger.oldMap.get(newLeadObj.Id);  		
	    		if(newLeadObj.Most_Recent_Campaign__c !=null && newLeadObj.Most_Recent_Campaign__c != oldLeadObj.Most_Recent_Campaign__c){
	    			campaignIdSet.add(string.valueOf(newLeadObj.Most_Recent_Campaign__c).subString(0,15));
	    		}	    		
	    	}
    	} catch(Exception e) {
   			strError = strError  + 'Exception 1 Occured on Campaign creation: ' + e.getMessage() + ' \r\n';
		}
    	
    	/***************OLD Code For CampaignMember Creation**********************************/
    	
    	//LeadTriggerHelper.createCampaignMember(trigger.new,trigger.oldMap);
    	
    	/***************End of OLD Code*********************************************************/
    	
    	/********CampaignMember Creation on updation of Most Recent Campaign of Lead***********/
    	if(campaignIdSet!=null && campaignIdSet.size() > 0){
			map<Id,map<Id,boolean>> campaignLeadRelationMap = new map<Id,map<Id,boolean>>(); 
    		for(Campaign  campObj : [select id,(SELECT CampaignId, LeadId From CampaignMembers 
					WHERE LeadId IN: trigger.newMap.keySet()) from Campaign where Id in : campaignIdSet AND IsActive=true]){
				if(campObj.CampaignMembers!=null && campObj.CampaignMembers.size() > 0){
					for(CampaignMember campMemberObj : campObj.CampaignMembers){
						if(campaignLeadRelationMap.get(campObj.Id)!=null){
							map<Id,boolean> tempMap = campaignLeadRelationMap.get(campObj.Id);
							tempMap.put(campMemberObj.LeadId,true);
							campaignLeadRelationMap.put(campObj.Id,tempMap);
						}else{
							map<id,boolean> tempMap = new map<id,boolean>();
							tempMap.put(campMemberObj.LeadId,true);
							campaignLeadRelationMap.put(campObj.Id,tempMap);							
						}
					}
				}else{
					campaignLeadRelationMap.put(campObj.Id,new Map<id,boolean>());
				}		
			}
			List<CampaignMember> campaignMemberNewList = new List<CampaignMember>();
			for(Lead newLeadObj: trigger.new) {
				if(newLeadObj.Most_Recent_Campaign__c!=null && newLeadObj.Most_Recent_Campaign__c != trigger.oldMap.get(newLeadObj.Id).Most_Recent_Campaign__c){
					if(campaignLeadRelationMap!=null && campaignLeadRelationMap.get(newLeadObj.Most_Recent_Campaign__c)!=null){
						if(campaignLeadRelationMap.get(newLeadObj.Most_Recent_Campaign__c).get(newLeadObj.Id)!=null){
							//CampaignMember already exists for this CampaignId and LeadId combination.
						}else{
							//Create new CampaignMember for this CampaignId and LeadId combination.
							CampaignMember campMemberObj = new CampaignMember(campaignId=newLeadObj.Most_Recent_Campaign__c, leadId=newLeadObj.Id);
							campaignMemberNewList.add(campMemberObj);
						}
					}
				}
			}
			if(campaignMemberNewList!=null && campaignMemberNewList.size() > 0){
				try {					
					insert campaignMemberNewList;					
				} catch(Exception e) {
					system.debug('Campaign Error :'+e.getMessage());
	    			strError = strError  + ' Exception 2 Occured on Campaign creation: ' + e.getMessage() + ' \r\n';
				}
			}
    	}
    	/**************************************************/
    	strError = strError  + 'After Campaign Member Creation ' + ' \r\n';
    }
    
	if(trigger.isInsert){
		List<CampaignMember> campaignMemberList = new List<CampaignMember>();
		Map<Id, Id> leadCampMap = new Map<Id, Id>();
		try {
	    	for(Lead newLeadObj: trigger.new) {
	    		if((newLeadObj.FirstName == 'something' && newLeadObj.LastName == 'new') 
	    		|| (newLeadObj.FirstName == 'rctu' && newLeadObj.LastName == '2calls4me')){
	                Database.delete(newLeadObj.Id);
	            } else {  
	            	if(newLeadObj != null && newLeadObj.Primary_Campaign__c != null 
	            		&& newLeadObj.Primary_Campaign__c != ''){
	                    CampaignMember campMemberObj = new CampaignMember(CampaignId=newLeadObj.Primary_Campaign__c, LeadId=newLeadObj.Id);
	                    campMemberObj.Status = 'Responded';
	                    Boolean status = false;
	                    if(leadCampMap != null 
	                    	&& leadCampMap.get(newLeadObj.Primary_Campaign__c) != null 
	                    	&& leadCampMap.get(newLeadObj.Primary_Campaign__c) == newLeadObj.Id) {
		                	status = true;
		                }
		                if(status == false) {
			                leadCampMap.put(newLeadObj.Primary_Campaign__c, newLeadObj.Id);
		                    campaignMemberList.add(campMemberObj);
		                }
	                }
	            }
	    	}
		} catch(Exception e) {}
		try {
    		if(campaignMemberList.size() != 0) {
    			insert campaignMemberList;
    		}
		} catch(DMLException ex) {}	
    	
    	User loginUser = [SELECT Id,Systems_Integration_Users__c FROM User Where Id=: UserInfo.getUserId()];
        if(loginUser.Systems_Integration_Users__c) {
	        System.debug('******* CALLING ********');
	        try {
	        	LeadUpdationFutureHandler.overrideExistingLead();
	        } catch(Exception e) {}
        } 
    }
    
    /********************* DFR CODE (DemandGen)***********************************/
    if(trigger.isInsert && trigger.isAfter){
      	DG_DFR_Class.CreateLeadDFR(Trigger.New);  
    }
    if(Trigger.isUpdate && trigger.isAfter){
  		if(DG_DFR_Class.LeadAfterUpdate_FirstRun || test.isRunningTest()){
  			if(Trigger.new.size() == 1 && Trigger.old.size() == 1) {
  				DG_DFR_Class.DFR_LeadStatusChange(trigger.New,trigger.Old);
  			} else {
  				DG_DFR_Class.DFR_LeadStatusChange(trigger.New,trigger.Old);
  			}
			DG_DFR_Class.LeadAfterUpdate_FirstRun=false;
		}try{
			 DG_DFR_Class.DFR_ChangeLeadOwner(trigger.New,trigger.Old);
  		}catch(exception ex){}
  		 //( ### SAL Handoff
		 DG_DFR_Class.SALHandOff_OnUpdate(trigger.New,trigger.Old);
		 //) ### SAL Handoff
  	}
  	/*if(Trigger.isUpdate  && trigger.isAfter){
  	// no bulk processing; will only run from the UI
    	if(DG_DFR_Class.LeadAfterConvert_FirstRun || test.isRunningTest()){
      		if (Trigger.new.size() == 1) {	              
	        	if (Trigger.old[0].isConverted == false && Trigger.new[0].isConverted == true){
	            	DG_DFR_Class.DFR_ConvertLead(Trigger.new[0]);                        
	          	} 
	        }
	        DG_DFR_Class.LeadAfterConvert_FirstRun=false;
    	}   
  	}*/
  	
  	if(Trigger.isUpdate  && trigger.isAfter){
    // no bulk processing; will only run from the UI        
        if (Trigger.new.size() == 1) {
        	strError = strError  + 'Before DFR lead conversion logic ' + ' \r\n';                
            if (Trigger.old[0].isConverted == false && Trigger.new[0].isConverted == true){
                try{
                    strError = StrError + 'Lead Id: ' + Trigger.new[0].Id + ' \r\n';
                    strError = StrError + 'Opportunity Id: ' + Trigger.new[0].ConvertedOpportunityId + ' \r\n';
                    strError = StrError + 'Contact Id: ' + Trigger.new[0].ConvertedContactId + ' \r\n';
                    strError = StrError + 'Account Id: ' + Trigger.new[0].ConvertedAccountId + ' \r\n';
                    strError = StrError + '1000 Lead_After Lead being converted' + ' \r\n';
                    if(DG_DFR_Class.LeadAfterConvert_FirstRun || test.isRunningTest()){
                        strError = StrError + '1100 Lead_After Pass Recursive flag' + ' \r\n' ;
                        DG_DFR_Class.DFR_ConvertLead(Trigger.new[0]);   
                        DG_DFR_Class.LeadAfterConvert_FirstRun=false;
                    }
                    strError = StrError + '1200 Lead_After Completed Lead convert trigger' + ' \r\n';
                }catch(exception e){
                    strError = StrError + 'Error Lead_After - '+ e.getMessage() + ' \r\n';
                }
            } 
        } 
    } 
  	 
    /********************************************************/     
 	
     /*Shared the lead to partners if partner lead owner field is not blank*/
	try {
		if((UserInfo.getUserType()=='Standard')){
			strError = strError + 'Before Partner sharing logic ' + ' \r\n';  
	    	Map<String,String> mapNewPartnerLead= new Map<String,String>();
	    	Map<String,String> mapOldPartnerLead= new Map<String,String>();
     		if(Trigger.isInsert){
     	  		for(Lead objLead:trigger.new){
     	  	    	if(objLead.Partner_Lead_Owner__c!=null){
     	  	    		mapNewPartnerLead.put(objLead.id,objLead.Partner_Lead_Owner__c);
	     	  	    }
     	  	  	}
      	  	}
	        if(Trigger.isUpdate){
	        	if(TriggerHandler.BY_PASS_LEAD_UPDATE_ON_INSERT)
    				return;
     	  		for(Lead objLead:trigger.new){
     	  	    	if((trigger.OldMap.get(objLead.id).Partner_Lead_Owner__c != objLead.Partner_Lead_Owner__c) ||
     	  	    		(trigger.OldMap.get(objLead.id).ownerId != objLead.ownerId)){
     	  	    		if(trigger.OldMap.get(objLead.id).Partner_Lead_Owner__c != null && 
     	  	    			trigger.OldMap.get(objLead.id).Partner_Lead_Owner__c != objLead.Partner_Lead_Owner__c){
     	  	    	  		mapOldPartnerLead.put(objLead.id,trigger.OldMap.get(objLead.id).Partner_Lead_Owner__c);
	     	  	    	} 
	     	  	    	if(objLead.Partner_Lead_Owner__c != null){
     	  	    			mapNewPartnerLead.put(objLead.id,objLead.Partner_Lead_Owner__c);
	     	  	    	} 
	     	  	    }
     	  	  	}
	      	}
	      	if(mapNewPartnerLead.size()>0 || mapOldPartnerLead.size()>0){
	      		ShareUtil.shareLeadToPartnerFromLeadTrigger(mapNewPartnerLead,mapOldPartnerLead,Trigger.New);
	       	}
	       	strError = strError  + 'After Partner sharing logic ' + ' \r\n';  
  		}
 	}catch(Exception e){
		strError = strError  + 'Exception Partner sharing logic '+ e.getMessage() + ' \r\n';
	}
	
	if(Trigger.isUpdate && trigger.isAfter){
		if (Trigger.new.size() == 1) {                
		    if (Trigger.old[0].isConverted == false && Trigger.new[0].isConverted == true){
				insert new Exception_And_Notification_History__c(
		    		Exception__c = 'Lead Conversion Exception - Lead_After Trigger 2 - '+ System.Now().format(), 
		    		Exception_Desc__c = strError, Object_Type__c = 'Lead',
		    		RecordTypeId = '01280000000UF6F'); 
		    }
		}
	}
	system.debug('Lead After : 1' + PRAssignmentLogic.calculateLimits());
	//### Transaction Stack (
	if(DG_Transaction_Stack_Class.TSLeadUpdate_FirstRun || test.isRunningTest()){
		if(trigger.isUpdate && trigger.isAfter){
			DG_Transaction_Stack_Class.Log_TS_OnLeadUpdate(trigger.New,trigger.Old);
			DG_Transaction_Stack_Class.Update_TS_OnLeadConvert(trigger.New,trigger.Old);		
		}
		DG_Transaction_Stack_Class.TSLeadUpdate_FirstRun=false;
	} 
	//### Transaction Stack ) 
	system.debug('Lead After : 2' + PRAssignmentLogic.calculateLimits());  
}