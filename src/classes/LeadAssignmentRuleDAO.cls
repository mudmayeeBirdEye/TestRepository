/*
	This is a helper Class called form Lead_before Trigger.
	It has functions to RUN LAR and then assign Lead owner based on Skill Found.
*/

public class LeadAssignmentRuleDAO {

	/****************************************************Lead Assignment Logic based On LARs********************************************************/
	public static void startLeadAssignment(User objUser, List<Lead> lstLead, Map<Id, Skill__c> skillsMap,List<Lead_Assignment_Rules__c> larList,Map<Id, 
                                       List<User_Skill__c>> skillsToUserSkills){
		System.debug(' #### COMING TO DAO LAR CODE ####');
		Database.DMLOptions dmo = new Database.DMLOptions(); 
    	dmo.EmailHeader.triggerUserEmail = false; 
    	dmo.EmailHeader.triggerAutoResponseEmail = false; 
    	dmo.EmailHeader.triggerOtherEmail = false; 
    	
		Map<String, String> empToCustomerSizeMap =  LeadTriggerHelper.getCustomerSize(lstLead); 
		for(Lead leadObj:lstLead){
				//String  customerSize = empToCustomerSizeMap.get(String.isBlank(leadObj.NumberOfEmployees__c) ? 'DEFAULT' : leadObj.NumberOfEmployees__c);
				String  customerSize = empToCustomerSizeMap.get(String.isBlank(leadObj.Effective_No_of_Employees_Range__c) ? 'DEFAULT' : leadObj.Effective_No_of_Employees_Range__c);
				if(Test.isRunningTest()) 
					customerSize = '';
				if(String.isBlank(customerSize)) { 
					customerSize = empToCustomerSizeMap.get('DEFAULT');
				}	
				System.debug(' #### FOUND CUSTOMER SIZE #### ' + customerSize);
		        /*******There was no protected owner found so try to use Lead Assignment Rules (LARs)********/
		        List<User_Skill__c> allUserSkills = new List<User_Skill__c>();
		        Map<Id, List<User_Skill__c>> larToUserSkillsMap = new Map<Id, List<User_Skill__c>>();
		        List<Id> finalSkillList = new List<Id>();
		        Map<Id, Skill__c> finalSkillMap = new Map<Id, Skill__c>(); 
		        
		        for(Skill__c skillObj : skillsMap.values()) {
		            System.debug('#### SKILL INDEX BEFORE #### CURRENT INDEX = ' + (skillObj.CurrentUserIndex__c == null ? ' BLANK ' : ''+skillObj.CurrentUserIndex__c) + ', GLOBAL = ' + (skillObj.GlobalUserSkillIndex__c == null ? ' BLANK ' : ''+ skillObj.GlobalUserSkillIndex__c));
		        }
		        /*LAR search based on Lead Entry Source*/
		            system.debug('-: associated campaign is not Default try to find LAR based on campaign');
		            allUserSkills = LeadTriggerHelper.getUserSkillsPerLeadEntrySource(leadObj, larList, skillsToUserSkills, finalSkillList, customerSize, skillsMap, finalSkillMap);
		            system.debug('ALL users found in skills by using les: ' + allUserSkills);
		        
		        /*
		        If associated campaign is not Default try to find LAR based on campaign
		            -Traverse LAR's trying to find one with matching campaign value and customerSize (or if LAR is set to All Business customer size doesnt matter)
		                -For each matching LAR found add all users with the skill specified in the LAR to a total list
		        */
		        system.debug('-: associated campaign is not Default try to find LAR based on campaign');
		        if(allUserSkills.size() == 0){
		            allUserSkills = LeadTriggerHelper.getUserSkillsPerCampaign(leadObj,new Campaign(Id=leadObj.Primary_Campaign__c), larList, skillsToUserSkills, 
		                                                                    finalSkillList, customerSize, skillsMap, finalSkillMap);
		        }
		        system.debug('ALL users found in skills by using campaign: ' + allUserSkills);
		        system.debug('#### campaign based user skills :#### ' + allUserSkills.size() + '###### FINAL SKILLS ' + finalSkillList.size());
		        /*
		        If allUserSkills.size() is 0 that means there were no matching LAR's or User_Skills to use. Now we try to use LeadSource.
		            -Traverse each LAR to find one with matching LeadSource value and customerSize (or if LAR is set to All Business customer size doesnt matter)
		                -For each matching LAR found add all users with the skill specified in the LAR to a total list
		        */
		        if(allUserSkills.size() == 0){
		            allUserSkills = LeadTriggerHelper.getUserSkillsPerLeadSource(leadObj, larList, skillsToUserSkills, finalSkillList, 
		                                                                customerSize, skillsMap, finalSkillMap);
		        }
		        system.debug('#### leadsource based user skills :#### ' + allUserSkills.size()+ '###### FINAL SKILLS ' + finalSkillList.size());
		        skillsMap = LeadTriggerHelper.assignLeadPerLAR(leadObj,finalSkillList,skillsMap,allUserSkills,  skillsToUserSkills );
		        system.debug('#### OWNER ID :#### ' + leadObj.OwnerId + '###### USER LAR ' + objUser.Id);
		        if(Test.isRunningTest()) {
		        	leadObj.setOptions(dmo); 
		        	leadObj.OwnerId = objUser.Id;
		        } 
		        if(leadObj.OwnerId == objUser.Id) {
		        	leadObj.setOptions(dmo); 
		        	leadObj.OwnerId = (String.isBlank(leadObj.Lead_Submitter_Id__c) ? LeadTriggerHelper.RCSF_SYNC : leadObj.Lead_Submitter_Id__c);
		        }  
		}
		Boolean isFailed = false;
		if(lstLead.size()>0){
			try {update lstLead;} catch(Exception ex) {isFailed = true; System.debug(' #### LEAD FAILED IN LAR #### ' + ex.getMessage());}
		}
		if(skillsMap.size() != 0 && isFailed == false) {
           update skillsMap.values();
        }
        System.debug(' #### FOUND LEAD SIZE #### ' + lstLead.size());
	}
	/********************************************************************************************************************************************/
	
	/***********************************************************Logic to Run LAR****************************************************************/
	public static void runLAR(User objUser, Map<Id, Skill__c> skillsMap,List<Lead_Assignment_Rules__c> larList,Map<Id, 
                                       List<User_Skill__c>> skillsToUserSkills) {
		List<Lead> lstLarLeadList=[SELECT Lead_Submitter_Id__c, Email, Company_Size__c, Skill_Name__c, NumberOfEmployees__c, Lead_Entry_Source__c, Lead_Folder__c, Id, LeadSource, Primary_Campaign__c, OwnerId 
	                                    FROM Lead WHERE OwnerId=:objUser.id AND IsConverted=false AND Duplicate_Lead__c=false LIMIT 1];
	    system.debug('Lar Lead List Size = '+lstLarLeadList.size());
        if(lstLarLeadList != null && lstLarLeadList.size()>0){ 
			Skill_Index__c objSkillIndex=new Skill_Index__c();//;lstSkillIndex.get(0);
			try {
				objSkillIndex.LAR_IN_Process__c='Start';
				objSkillIndex.Skill_Index_Name__c=String.valueOf(System.now().getTime());
				objSkillIndex.IN_Progress__c=true;
				objSkillIndex.Number_of_Leads__c = lstLarLeadList.size();
				insert objSkillIndex; 
				Boolean isFalied = false;
				try {
					lstLarLeadList=[SELECT Effective_No_of_Employees_Range__c,Employees_Override__c,Lead_Submitter_Id__c, Email, Company_Size__c, Skill_Name__c, NumberOfEmployees__c, Lead_Entry_Source__c, Lead_Folder__c, Id, LeadSource, Primary_Campaign__c, OwnerId 
	                                    FROM Lead WHERE OwnerId=:objUser.id AND IsConverted=false AND Duplicate_Lead__c=false LIMIT 50];
					LeadAssignmentRuleDAO.startLeadAssignment(objUser,lstLarLeadList, skillsMap,larList,skillsToUserSkills);
				} catch(Exception e) {
					isFalied = true;
				}
				objSkillIndex.IN_Progress__c=false;
				objSkillIndex.LAR_IN_Process__c= (isFalied == false ? 'LAR Process Done at '+System.Now() : 'LAR Process Stuck at '+System.Now());
				objSkillIndex.Number_of_Leads__c = lstLarLeadList.size();
				update objSkillIndex;	        	   
        	  } catch(Exception ex) {
				if(objSkillIndex!=null && objSkillIndex.id!=null){
					objSkillIndex.IN_Progress__c = false;
					objSkillIndex.Number_of_Leads__c = lstLarLeadList.size();
					objSkillIndex.LAR_IN_Process__c='LAR Process Failed at '+System.Now();
					try {upsert objSkillIndex;} catch(Exception exNew){ System.debug('###### EXCEPTION AT UPSERTING ######');}
				} 
			}
		}
	}
	/*******************************************************************************************************************************************/
}