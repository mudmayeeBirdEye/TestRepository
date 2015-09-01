public class LeadAssignmentHelper {
	public static List<User_Skill__c> getUserSkillsPerLeadEntrySource(LARWrapper wrapperObj,  
									List<Lead_Assignment_Rules__c> larList, Map<Id, List<User_Skill__c>> skillsToUserSkills, 
									List<Id> finalSkillList, String customerSize, Map<Id, Skill__c> skillsMap,
									Map<Id, Skill__c> finalSkillMap ) {
		List<User_Skill__c> allUserSkills = new List<User_Skill__c>(); 
		List<Lead_Assignment_Rules__c> larFinalList = new List<Lead_Assignment_Rules__c>();
		for(Lead_Assignment_Rules__c larObj : larList){
			if((!String.isEmpty(larObj.Lead_Entry_Source__c) && !String.isEmpty(wrapperObj.lesStr) 
			&& (larObj.Lead_Entry_Source__c.trim() == wrapperObj.lesStr.trim())) 
				&& (larObj.Customer_Employee_Size__c == null
					|| larObj.Customer_Employee_Size__c.containsIgnoreCase(customerSize)) ){				
				try{
					if(larObj.Skill__c != null
						&& skillsToUserSkills.get(larObj.Skill__c) != null 
						&& skillsToUserSkills.get(larObj.Skill__c).size() != 0) {
							if(finalSkillMap.get(larObj.Skill__c) == null) {
								larFinalList.add(larObj); 
								finalSkillList.add(larObj.Skill__c); 
								finalSkillMap.put(larObj.Skill__c, skillsMap.get(larObj.Skill__c));
							}  
					}
				} catch(System.Exception e){
					// leadObj.OwnerId = '005800000036sJJ';
					// leadObj.description = 'This lead could not find any users with the correct skill so assigned to rcsf.';
				}
				// leadObj.Lead_Score__c = larObj.Lead_Score__c;                                     
			}
		}
		for(Lead_Assignment_Rules__c larObj: larFinalList) {  
			if(larObj != null && larObj.Skill__c != null) {
				List<User_Skill__c> userSkills = skillsToUserSkills.get((Id)larObj.Skill__c);
				if(userSkills != null && userSkills.size() != 0) {
					allUserSkills.addAll(userSkills);
				} 
			}
		}
	    return allUserSkills;          							
	}
	public static List<User_Skill__c> getUserSkillsPerCampaign(LARWrapper wrapperObj, Campaign campaignObj, 
    									List<Lead_Assignment_Rules__c> larList, Map<Id, List<User_Skill__c>> skillsToUserSkills, 
    									List<Id> finalSkillList, String customerSize, Map<Id, Skill__c> skillsMap,
    									Map<Id, Skill__c> finalSkillMap ) {
    	List<User_Skill__c> allUserSkills = new List<User_Skill__c>();
		if(campaignObj != null && campaignObj.Name != 'Default Campaign') {
			List<Lead_Assignment_Rules__c> larFinalList = new List<Lead_Assignment_Rules__c>(); 
			for(Lead_Assignment_Rules__c larObj : larList) {
				if(larObj.Campaign__c != null){
					if(larObj.Campaign__c == wrapperObj.campaignStr 
						&& ( larObj.Customer_Employee_Size__c == null
						|| larObj.Customer_Employee_Size__c.containsIgnoreCase(wrapperObj.customerSize)) ){						
						try {     
							if(larObj.Skill__c != null 
									&& skillsToUserSkills.get(larObj.Skill__c) != null 
									&& skillsToUserSkills.get(larObj.Skill__c).size() != 0) {
								if(finalSkillMap.get(larObj.Skill__c) == null) {
									larFinalList.add(larObj);
									finalSkillList.add(larObj.Skill__c); 
									finalSkillMap.put(larObj.Skill__c, skillsMap.get(larObj.Skill__c));
								} 
							}
						} catch(System.Exception e){
							// leadObj.OwnerId = '005800000036sJJ';
						}                               
					}
				}
			}
			for(Lead_Assignment_Rules__c larObj: larFinalList) {
				if(larObj != null && larObj.Skill__c != null) {
					List<User_Skill__c> userSkills = skillsToUserSkills.get((Id)larObj.Skill__c);
					if(userSkills != null && userSkills.size() != 0) {
						allUserSkills.addAll(userSkills);
					} 
				}
			}
		}
		return allUserSkills;
	}
	public static List<User_Skill__c> getUserSkillsPerLeadSource(LARWrapper wrapperObj,  
    									List<Lead_Assignment_Rules__c> larList, Map<Id, List<User_Skill__c>> skillsToUserSkills, 
    									List<Id> finalSkillList, String customerSize, Map<Id, Skill__c> skillsMap,
    									Map<Id, Skill__c> finalSkillMap ) {
		List<User_Skill__c> allUserSkills = new List<User_Skill__c>();
		List<Lead_Assignment_Rules__c> larFinalList = new List<Lead_Assignment_Rules__c>();
		for(Lead_Assignment_Rules__c larObj : larList){
			if(!String.isBlank(larObj.Lead_Source__c)){
				if(wrapperObj.LeadSource != null && (larObj.Lead_Source__c.trim() == wrapperObj.LeadSource.trim()) 
					&& (larObj.Customer_Employee_Size__c == null
						|| larObj.Customer_Employee_Size__c.containsIgnoreCase(wrapperObj.customerSize)) ){					
					try{
						if(larObj.Skill__c != null
							&& skillsToUserSkills.get(larObj.Skill__c) != null 
							&& skillsToUserSkills.get(larObj.Skill__c).size() != 0) {
								if(finalSkillMap.get(larObj.Skill__c) == null) {
									larFinalList.add(larObj); 
									finalSkillList.add(larObj.Skill__c); 
									finalSkillMap.put(larObj.Skill__c, skillsMap.get(larObj.Skill__c));
								}  
						}
					} catch(System.Exception e){
						// leadObj.OwnerId = '005800000036sJJ';
						// leadObj.description = 'This lead could not find any users with the correct skill so assigned to rcsf.';
					}
					// leadObj.Lead_Score__c = larObj.Lead_Score__c;                                     
				}
			}                               
		}
		for(Lead_Assignment_Rules__c larObj: larFinalList) {
			if(larObj != null && larObj.Skill__c != null) {
				List<User_Skill__c> userSkills = skillsToUserSkills.get((Id)larObj.Skill__c);
				if(userSkills != null && userSkills.size() != 0) {
					allUserSkills.addAll(userSkills);
				} 
			}
		}
	    return allUserSkills;                       
	}         
	public static Map<Id, Skill__c> assignLeadPerLAR(LARWrapper wrapperObj, List<Id> finalSkillList, Map<Id, Skill__c> skillsMap,
							List<User_Skill__c> allUserSkills,Map<Id, List<User_Skill__c>> skillsToUserSkills ) {
		if(finalSkillList.size() != 0) {
			Id currentSkillId = finalSkillList.get(0);
			Skill__c skillObj = skillsMap.get(currentSkillId);
			
			/******Counter Updates*********/
			//Integer leadCount = Integer.valueOf(''+(skillObj.CurrentUserIndex__c == null ? 0 : skillObj.CurrentUserIndex__c));
			system.debug('==counter=='+wrapperObj.objectName);
			system.debug('==finalSkillList=='+finalSkillList);
			Integer leadCount = 0;
			if(wrapperObj.objectName=='OPPORTUNITY'){
				leadCount = Integer.valueOf((skillObj.OptyIndex__c == null ? 0 : skillObj.OptyIndex__c));
			}else if(wrapperObj.objectName=='CONTACT'){
				leadCount = Integer.valueOf((skillObj.ContactIndex__c == null ? 0 : skillObj.ContactIndex__c));
			}else{
				leadCount = Integer.valueOf((skillObj.CurrentUserIndex__c == null ? 0 : skillObj.CurrentUserIndex__c));
			}
			/****End of Counter Updates********/
			
			
			if(finalSkillList.size() != 1) {
					Integer larGlobalIndex = Integer.valueOf(''+(skillObj.GlobalUserSkillIndex__c == null ? 0 : skillObj.GlobalUserSkillIndex__c));
					/*System.debug('########### CURRENT SKILL ID = ' + currentSkillId 
					+ '\n ##### AND COUNTER = '+ leadCount 
					+ '\n ##### larGlobalIndex = ' + larGlobalIndex
					+ ' ####### ');*/
					if(larGlobalIndex == null || larGlobalIndex >= allUserSkills.size() ) {
						larGlobalIndex = 0;
					}
					// leadObj.Assignment_Source_hidden__c = 'LARs';
					wrapperObj.assignmentSource = 'LARs';
					wrapperObj.ownerStr = allUserSkills.get(larGlobalIndex).User__c;
					// leadObj.OwnerId = allUserSkills.get(larGlobalIndex).User__c;
					
					Integer previousSize = 0;
					for(Id skillId : finalSkillList) {
						if(skillId != null) {
							Integer currentSize = (skillsToUserSkills.get(skillId) == null ? 0 :  skillsToUserSkills.get(skillId).size());
							Integer countSum = currentSize+previousSize;
							if(countSum > larGlobalIndex) {
								Integer offset = 0;
								if(previousSize == 0) {
									offset = 0;
								} else {
									offset = countSum - currentSize;
								}
								currentSkillId = skillId;
								leadCount = larGlobalIndex - offset;
								Skill__c skillObjNew = skillsMap.get(skillId);
								++leadCount;
								skillObjNew.CurrentUserIndex__c = leadCount;
								skillsMap.put(skillId, skillObjNew);
								break;
							}
							previousSize += currentSize;
						}
					}
					
					++larGlobalIndex;
					for(Id skillId : finalSkillList) {
						if(skillId != null) {
							Skill__c skillObjNew = skillsMap.get(skillId);
							skillObjNew.GlobalUserSkillIndex__c = larGlobalIndex;
							skillsMap.put(skillId, skillObjNew);
						}
					}
			} else {
				Id skillId = currentSkillId;
				Integer currentSize = (skillsToUserSkills.get(skillId) == null ? 0 :  skillsToUserSkills.get(skillId).size());
				if(leadCount == null || leadCount >= currentSize) {
					leadCount = 0;
				}
				/*
				leadObj.Assignment_Source_hidden__c = 'LARs';
				leadObj.OwnerId = skillsToUserSkills.get(skillId).get(leadCount).User__c;
				*/
				wrapperObj.assignmentSource = 'LARs';
				wrapperObj.ownerStr = skillsToUserSkills.get(skillId).get(leadCount).User__c;
				
				
				Skill__c skillObjNew = skillsMap.get(skillId);
				++leadCount;
				
				System.debug('==SkillID=='+skillId);
				
				/****Counter Updates********/
				//skillObjNew.CurrentUserIndex__c = leadCount;
				if(wrapperObj.objectName=='OPPORTUNITY'){
					skillObj.OptyIndex__c = leadCount;
				}else if(wrapperObj.objectName=='CONTACT'){
					//system.debug('==ContactIndex__c=='+leadCount);
					skillObj.ContactIndex__c = leadCount;
				}else{
					skillObj.CurrentUserIndex__c = leadCount;
				}		
				System.debug('==SkillObj=='+skillObj);
				/****End of Counter Updates********/				
					
				skillsMap.put(skillId, skillObjNew); 
				/*********************************************************/
			}
		}
		return skillsMap;
	}
}