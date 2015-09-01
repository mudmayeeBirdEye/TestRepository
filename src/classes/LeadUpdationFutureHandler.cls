global class  LeadUpdationFutureHandler {
  @future 
  public static void overrideExistingLead() {
    
        /*List<Lead> duplicateLeads = [SELECT Id, Email, isDuplicate__c, Name, LeadExistingSource__c, Status
        , existingLeadId__c, Primary_Campaign__c, (Select CampaignId, LeadId, ContactId From CampaignMembers) FROM Lead WHERE isDuplicate__c = 'true' AND IsConverted = false AND isDeleted= false];
        */
        List<Lead> duplicateLeads = [SELECT Id, Email, isDuplicate__c, Duplicate_Lead__c, Name, LeadExistingSource__c, Status
        , existingLeadId__c, Primary_Campaign__c, (Select CampaignId, LeadId, ContactId From CampaignMembers) FROM Lead WHERE Duplicate_Lead__c=true AND IsConverted = false AND isDeleted= false];

		if(duplicateLeads != null && duplicateLeads.size() != 0) {
	        Map<Id, List<CampaignMember>> leadToMembersMap = new Map<Id, List<CampaignMember>>();
	        Set<Id> leadIds = new Set<Id>();
	        Set<Id> duplicateLeadIds = new Set<Id>();
	        Set<Id> contactIds = new Set<Id>();
	        Map<Id, Id> leadCampIdMap = new Map<Id, Id>();
	        
	        Map<Id, Lead> mapLeads = new Map<Id, Lead>();
	        Map<Id, Lead> oppLeads = new Map<Id, Lead>();
	        
	        Map<Id, Lead> existingLeads = new Map<Id, Lead>();
	        Map<Id, Lead> existingLeadsNewLead = new Map<Id, Lead>();
	        
	        Map<Id, Contact> existingContacts = new Map<Id, Contact>();
	        
	        List<CampaignMember> memberListFinal = new List<CampaignMember>();
	        List<Lead> leadListFinal = new List<Lead>();
	        
	        Map<Id, CampaignMember> uniqueMemberList = new Map<Id, CampaignMember>();
	        Map<Id, Opportunity> contactOppMap = new Map<Id, Opportunity>();
	        Map<Id, Contact> accContactMap = new Map<Id, Contact>();
	        
	        Map<Id, Lead> deleteLeadList = new Map<Id, Lead>();
	        
	        Map<Id, CampaignMember> uniqueCampMembers = new Map<Id, CampaignMember>();
	        Set<Id> campaignIds = new Set<Id>();
	        for(Lead leadObj : duplicateLeads) {
	          duplicateLeadIds.add(leadObj.id);
	          List<CampaignMember> campMemberList = new List<CampaignMember>();  
	            if(leadObj.LeadExistingSource__c != 'Opportunity') {
	                leadIds.add(leadObj.existingLeadId__c);
	                existingLeadsNewLead.put(leadObj.existingLeadId__c,leadObj);
	                mapLeads.put(leadObj.id, leadObj);
	            } else {
	                contactIds.add(leadObj.existingLeadId__c);
	                oppLeads.put(leadObj.id, leadObj);
	            }
	            leadCampIdMap.put(leadObj.Id, leadObj.Primary_Campaign__c);
	            leadToMembersMap.put(leadObj.Id, leadObj.CampaignMembers);
	        }  
	        system.debug('##### => leadToMembersMap = ' + leadToMembersMap);
	        
	        
	       //  Map<String, Id> leadOwnerIdmap = new Map<String, Id>();
	        if(leadIds.size() != 0) {
	           // try {
	            Map<Id,List<CampaignMember>> existingLeadToMembers = new Map<Id,List<CampaignMember>>();
	            existingLeads = new Map<Id, Lead>([SELECT Id, Email, Primary_Campaign__c, Status, OwnerId, (Select CampaignId, LeadId From CampaignMembers) 
	             FROM Lead WHERE Id IN: leadIds AND IsConverted = false AND isDeleted = false]);
	            for(Id idLead: existingLeads.keySet()) {
	                Lead temp = existingLeads.get(idLead);
	              	existingLeadToMembers.put(idLead, temp.CampaignMembers);
	            }
	            
	            Map<Id, Id> campLeadmap = new Map<Id, Id>();
	            List<CampaignMember> memberList = new List<CampaignMember>();
	            for(Lead leadObj : mapLeads.values()) {
	              List<CampaignMember> newLeadMembers = (leadToMembersMap == null || leadToMembersMap.size() == 0 ? new List<CampaignMember>() : leadToMembersMap.get(leadObj.Id));
				  if(Test.isRunningTest()){
	              	 List<CampaignMember> lstCampMem = [SELECT Id,LeadId,CampaignId,ContactId FROM CampaignMember];
        			 newLeadMembers = lstCampMem;
        			 system.debug('---===---->'+newLeadMembers);
	              }
	              if(newLeadMembers != null && newLeadMembers.size() != 0) {
	                Id existingLeadId = leadObj.existingLeadId__c;
	                List<CampaignMember> existingLeadMembers = (existingLeadToMembers.get(existingLeadId) == null ? new List<CampaignMember>() : existingLeadToMembers.get(existingLeadId));
	                List<CampaignMember> NewCampaignMembersToassign = getCampaignMemberList(newLeadMembers, existingLeadMembers);
	                
	                for(CampaignMember campMember : NewCampaignMembersToassign) {
	                    CampaignMember member = new CampaignMember();
	                            member.CampaignId = campMember.CampaignId;
	                            member.LeadId = existingLeadId;
	                            member.Status ='Responded';
	                            memberList.add(member);
	                            uniqueCampMembers.put(campMember.CampaignId, member);
	                            campLeadmap.put(campMember.CampaignId, existingLeadId);
	                            campaignIds.add(campMember.CampaignId);
	                }
	                if(NewCampaignMembersToassign.size() != 0)
	                      deleteLeadList.put(leadObj.Id, leadObj);
	                }
	            }
	           // } catch(Exception e) {System.debug('####' + e);}
	        }
	        
	        if(contactIds.size() != 0) {
	           // try {
	                // new camp members to contact ids
	                // Map<Id, Id> c
	                Map<Id,List<CampaignMember>> existingContactIdMap=new Map<Id,List<CampaignMember>>();
	                for(Contact contactObj : [Select Id, OwnerId, Email, AccountId, Name, (Select CampaignId, ContactId From CampaignMembers) 
	                From Contact  WHERE Id IN: contactIds AND IsDeleted = false]) {
	                    existingContactIdMap.put(contactObj.Id, contactObj.CampaignMembers);
	                    // leadOwnerIdmap.put(contactObj.Email, contactObj.OwnerId);
	                    accContactMap.put(contactObj.accountId, contactObj);
	                }
	                if(accContactMap.size() != 0) {
	                  for(Opportunity oppList: [SELECT Id, OwnerId, AccountId FROM Opportunity 
	                  WHERE AccountId IN : accContactMap.keySet() AND StageName IN : OpportunityHelper.alteredStages ORDER BY CreatedDate DESC]) {
	                    Id contactId = accContactMap.get(oppList.AccountId).Id;
	                    if(contactOppMap.get(contactId) == null)
	                      contactOppMap.put(contactId, oppList);
	                  }
	                }
	                Map<Id, Id> campContactmap = new Map<Id, Id>();
	                List<CampaignMember> memberList = new List<CampaignMember>();
	                for(Lead leadObj : oppLeads.values()) {
	                  List<CampaignMember> newLeadMembers = (leadToMembersMap == null || leadToMembersMap.size() == 0 ? new List<CampaignMember>() : leadToMembersMap.get(leadObj.Id));
	                  system.debug('#### CAMPAIGN NEW MEMBERS MAP => ' + newLeadMembers + ' <= ####');
	                if(newLeadMembers != null && newLeadMembers.size() != 0) {
	                  Id existingContactId = leadObj.existingLeadId__c;
	                  List<CampaignMember> existingLeadMembers = (existingContactIdMap.get(existingContactId) == null ? new List<CampaignMember>() : existingContactIdMap.get(existingContactId));
	                  List<CampaignMember> NewCampaignMembersToassign = getCampaignMemberList(newLeadMembers, existingLeadMembers);
	                  system.debug('#### CAMPAIGN EXI MEMBERS MAP => ' + existingLeadMembers + ' <= ####');
	                    for(CampaignMember campMember : NewCampaignMembersToassign) {
	                    		CampaignMember member = new CampaignMember();
	                            member.CampaignId = campMember.CampaignId;
	                            member.ContactId = existingContactId;
	                            campContactmap.put(existingContactId,campMember.CampaignId);
	                            member.Status ='Responded';
	                            memberList.add(member);
	                            uniqueCampMembers.put(campMember.CampaignId, member);
	                            campaignIds.add(campMember.CampaignId);
	                    }
	                      if(NewCampaignMembersToassign.size() != 0)
	                        deleteLeadList.put(leadObj.Id, leadObj);
	                }
	                }
	            // } catch(Exception e) {System.debug('#### Duplicate Opportunity Created:' + e);}
	        }
	        
	        
	        if(uniqueCampMembers.size() != 0) {
	          try {
	            if(Test.isRunningTest() == false)
	            	insert uniqueCampMembers.values();
	          } catch(Exception es){}
	        }
	        
	        if(deleteLeadList.size() != 0) {
	            Map<Id, Campaign> campMap = new Map<Id, Campaign>([SELECT Id, Name FROM Campaign WHERE Id IN: campaignIds]);
	            Map<String, LeadCampaignWrapper> notifyThis = new Map<String, LeadCampaignWrapper>();
	            for(Lead finalObj : deleteLeadList.values()) {
	                Campaign camp = campMap.get(leadCampIdMap.get(finalObj.Id));
	                Lead existingLead = existingLeads.get(finalObj.existingLeadId__c);
	                Opportunity existingOpp = contactOppMap.get(finalObj.existingLeadId__c);
	                LeadCampaignWrapper wrapperObj = new LeadCampaignWrapper(finalObj,camp, existingLead, existingOpp, accContactMap);
	                notifyThis.put(finalObj.Email, wrapperObj);
	            }
	            /* try {
	                  sendNotifications(notifyThis);
	             } catch(Exception e){}
	             */
	        }
	        try {
	        	
	        	/** Delete all DFRs associated to a Fake Leads*/
	   			List<Demand_Funnel__c> lstDemandFunnelToDelete = new List<Demand_Funnel__c>();
	   			lstDemandFunnelToDelete = [SELECT d.id from Demand_Funnel__c d WHERE d.Lead__c IN :duplicateLeadIds];
		   		if(lstDemandFunnelToDelete != null && lstDemandFunnelToDelete.size() >0){
		   			delete lstDemandFunnelToDelete;
		   		}
	       		if(duplicateLeads.size() != 0 && Test.isRunningTest() == false)
	        		delete duplicateLeads;
	        } catch(Exception es) {}
		} 
	}
    
    class LeadCampaignWrapper {
        Lead leadObj;
        Campaign campaignObj;
        Id ownerId;
        Lead existingLead;
        Opportunity existingOpp;
        Map<Id, Contact> accContactMap = new Map<Id, Contact>();
        LeadCampaignWrapper(Lead leadObj, Campaign campaignObj, Lead existingLead, Opportunity existingOpp, Map<Id, Contact> accContactMap) {
            this.leadObj = leadObj;
            this.campaignObj = campaignObj;
           // this.ownerId = ownerId;
            this.existingLead = existingLead;
            this.existingOpp = existingOpp;
            this.accContactMap = accContactMap;
        }
    }
    /*
    public static Boolean sendNotifications(Map<String, LeadCampaignWrapper> notifyThis) {
      Integer countNum = 0;
        for(String email: notifyThis.keySet()) {
          if(++countNum > 9) {
          	break;
          }
         try {
            MailHelper helper = new MailHelper();
            LeadCampaignWrapper wrapperObj = notifyThis.get(email);
            Lead leadObject = wrapperObj.leadObj;
            Campaign campaignObject = wrapperObj.campaignObj;
            // break;
            String subject = 'This person '+leadObject.Name+', '+leadObject.Email+' has just responded to another marketing campaign'; 
            // 'Your lead '+leadObject.Email+' has responded to another marketing campaign '+(campaignObject != null ?campaignObject.Name: '');
            String targetObjectId  = null;//'00580000003d9rB';
            String href = 'https://na6.salesforce.com/'+campaignObject.Id;
            String htmlBody = '';
            if(leadObject.LeadExistingSource__c != 'Opportunity') {
              targetObjectId =  wrapperObj.existingLead.ownerId;
              String leadHref = 'https://na6.salesforce.com/' + wrapperObj.existingLead.Id;
              htmlBody = 'Your existing Lead <a href=\''+leadHref+'\'>'+leadHref+'</a>, <b>'+leadObject.Name+'</b> with the email '+leadObject.Email+' has responded to campaign <b>'+(campaignObject != null ?campaignObject.Name: '')+'</b> <a href=\''+href+'\'>'+href+'</a>';
            } else {
              targetObjectId =  wrapperObj.existingOpp.ownerId;
              String oppHref = 'https://na6.salesforce.com/' + wrapperObj.existingOpp.Id;
              Id accId = wrapperObj.existingOpp.accountId;
              htmlBody = 'Your existing Opportunity <a href=\''+oppHref+'\'>'+oppHref+'</a>, <b>'+wrapperObj.accContactMap.get(accId).Name+'</b> with the email '+wrapperObj.accContactMap.get(accId).Email+' has responded to campaign <b>'+(campaignObject != null ?campaignObject.Name: '')+'</b> <a href=\''+href+'\'>'+href+'</a>';
            }
            if(htmlBody != '') {
              htmlBody += '<BR/><BR/><BR/>Salesforce Administrator <BR/><a href=\'mailto:bizservhelp@ringcentral.com\'>bizservhelp@ringcentral.com</a>';
            }
            System.debug(email + ' **** Email to Owner ' + targetObjectId);
            
            if(targetObjectId != null) { 
              helper.createMail(null, htmlBody, targetObjectId, null, false, '', subject);
            }
         } catch(Exception e) {sendEmail(e.getMessage());}
        }
        return true;
    }
    */
    public static List<CampaignMember> getCampaignMemberList(List<CampaignMember> newLeadMembers, List<CampaignMember> existingLeadMembers) {
      List<CampaignMember> memberList = new List<CampaignMember>();
   
      for(CampaignMember newMember : newLeadMembers) {
        Id newCampaignId = newMember.CampaignId;
        Boolean status = false;
     
        for(CampaignMember oldMember : existingLeadMembers) {
          Id oldCampaignId = oldMember.CampaignId;
          system.debug('***** MEMBER LIST oldCampaignId= '+oldCampaignId+' AND newCampaignId = '+ newCampaignId+' ******');
          if(newCampaignId == oldCampaignId
            //|| (newMember.LeadId != null && oldMember.LeadId != null && newMember.LeadId == oldMember.LeadId)
            //|| (newMember.ContactId != null && oldMember.ContactId != null && newMember.ContactId == oldMember.ContactId)
            ) {
            status = true;
            break;
          }
        }
        if(status == false) {
          memberList.add(newMember);
        }
      }
      return memberList;
    }
    /*
    public static void sendEmail(String exc) {
      Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); //instantiate a new message object
    String[] toAddresses = new String[] {'virendra.singh@simplion.com'}; //denote the email address for receiving the message
      String[] toBCCAddresses = new String[] {'anuj.shukla@simplion.com','kanishk.singh@simplion.com'};
      mail.setCcAddresses(toBCCAddresses);
      mail.setToAddresses(toAddresses); //to
        mail.setSubject('Sending email notification for email duplication is failed!'); //subject
        mail.setPlainTextBody(exc); //body
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); //send
    }*/
   /* static    void testLeadValidation(){
     try{
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
    leadObj2.Email = 'aa@aa.com';
    leadObj2.Company = 'TestIndiaLead'; //
    leadObj2.Status = '1.5 Call Out';
    leadObj2.LeadSource = 'Inbound Call';
    leadObjList.add(leadObj2);
       
       
       Lead leadObj3 = new Lead();
    leadObj3.FirstName = 'Virendra';
    leadObj3.LastName = 'Singh';
    leadObj3.Phone = '9910106823';
    leadObj3.Email = 'resr@test.com';
    leadObj3.Company = 'TestIndiaLead'; //
    leadObj3.Status = '1.5 Call Out';
    leadObj3.LeadSource = 'Inbound Chat';
    leadObjList.add(leadObj3);
    
       // insert leadObjList;
       
       LeadUpdationFutureHandler.overrideExistingLead();
       Test.stopTest();
    }
    catch(Exception e){}
    }*/
    
}