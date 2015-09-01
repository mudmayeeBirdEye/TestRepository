public class OpportunityLARHelper {
	
	public static boolean IS_SOLVE_THEN_SELL_OPPORTUNITY = false;
	
	public static Map<String, Campaign> assignCampaignToOpportunity(List<Opportunity> oppList) {
		Map<String, Campaign> campaignMap = new Map<String, Campaign>(); 
		List<CampaignWrapper> camWrapperList = new List<CampaignWrapper>();
		
		for(Opportunity opportunityObj : oppList) {
			camWrapperList.add(new CampaignWrapper(opportunityObj.AID__c, opportunityObj.BMID__c, opportunityObj.PID__c, opportunityObj.CampaignId, false));
		}
		
		Map<String, Campaign> criteriaToCamapaignMap = CampaignAssignmentHelper.findCampaings(camWrapperList);
		for(Opportunity opportunityObj :oppList) {
			Campaign campaignObj = CampaignAssignmentHelper.getLeadCampaign(new CampaignWrapper(opportunityObj.AID__c, opportunityObj.BMID__c, opportunityObj.PID__c, opportunityObj.CampaignId, false), criteriaToCamapaignMap);
			if(campaignObj != null) {
				opportunityObj.CampaignId = campaignObj.Id;
				campaignMap.put((String)opportunityObj.CampaignId, campaignObj);
			}
		}
		return campaignMap;
	}
	private static Map<String, String> getOpportunityCustomerSize(List<Opportunity> opportunityList) {
		Set<Id> accountIds = new Set<Id>();
		for(Opportunity opportunityObj : opportunityList) {
			if(String.isBlank(opportunityObj.Number_of_Employees__c)) {
				accountIds.add(opportunityObj.AccountId);
			}
		}
		Map<Id, Account> accountMap = new Map<Id, Account>([SELECT Id, No_of_Employees__c FROM Account WHERE Id IN:accountIds]);
		Map<String, String> empToCustomerSizeMap = new Map<String, String>();
		Set<String> rangesOpp = new Set<String>();
		Set<String> rangesAccount = new Set<String>();
		Schema.DescribeFieldResult numberOfEmployees = Account.No_of_Employees__c.getDescribe();
        List<Schema.PicklistEntry> numberOfEmployeesRange = numberOfEmployees.getPicklistValues();
        for(Schema.PicklistEntry schObj : numberOfEmployeesRange) {
            rangesAccount.add(schObj.getValue());
        }
        numberOfEmployees = Opportunity.Number_of_Employees__c.getDescribe();
        numberOfEmployeesRange = numberOfEmployees.getPicklistValues();
        for(Schema.PicklistEntry schObj : numberOfEmployeesRange) {
            rangesOpp.add(schObj.getValue());
        }
        for(Opportunity opportunityObj : opportunityList) {
            Set<String> ranges = new Set<String>();
            if(!String.isBlank(opportunityObj.Number_of_Employees__c)) {
            	ranges.addAll(rangesOpp);
            } else {
            	ranges.addAll(rangesAccount);
            }
            /*Schema.DescribeFieldResult numberOfEmployees = (String.isBlank(opportunityObj.Number_of_Employees__c) ? Account.No_of_Employees__c.getDescribe() : Opportunity.Number_of_Employees__c.getDescribe());
            List<Schema.PicklistEntry> numberOfEmployeesRange = numberOfEmployees.getPicklistValues();
            for(Schema.PicklistEntry schObj : numberOfEmployeesRange) {
                ranges.add(schObj.getValue());
            }*/
            String customerSize = '2-9';
            String employeeSize = 'DEFAULT';
            if(!String.isBlank(opportunityObj.Number_of_Employees__c)) {
            	customerSize = opportunityObj.Number_of_Employees__c;
            	employeeSize = customerSize;
            } else if(!String.isBlank(accountMap.get(opportunityObj.AccountId).No_of_Employees__c) && ranges.contains(accountMap.get(opportunityObj.AccountId).No_of_Employees__c)) {
                customerSize = accountMap.get(opportunityObj.AccountId).No_of_Employees__c;
                employeeSize = customerSize;
            }
            empToCustomerSizeMap.put(employeeSize, customerSize);
        }
        return empToCustomerSizeMap;
	}
	public static void initialOpportunities(List<Opportunity> opportunityList, Map<Id, User> userMap) {
		String name = UserRC.rcsfSyncUserObj.Name;
        String indiaTeam = UserRC.indiaTeamUserObj.Name;
        String partnerSync = UserRC.rcPartnerSyncUserObj.Name;
		Map<Id, List<User_Skill__c>> larToUserSkillsMap = new Map<Id, List<User_Skill__c>>();
        List<Id> finalSkillList = new List<Id>();
        Map<Id, Skill__c> skillsMap = new Map<Id, Skill__c>();
        List<Lead_Assignment_Rules__c> larList = LeadTriggerHelper.getLarWithSkills(false);
        Set<String> skillIds = new Set<String>();
        List<User_Skill__c> allUserSkills = new List<User_Skill__c>();
        Map<Id, Skill__c> finalSkillMap = new Map<Id, Skill__c>(); 
        
        for(Lead_Assignment_Rules__c larObj : larList) {
            if(larObj.Skill__c != null) {
                skillIds.add(larObj.Skill__c);
                skillsMap.put(larObj.Skill__c, larObj.Skill__r);
            }
        }
        Map<Id, List<User_Skill__c>> skillsToUserSkills = LeadTriggerHelper.getSkillsToUserSkillsMap(skillsMap.keySet());
        Map<String, String> empToCustomerSizeMap =  getOpportunityCustomerSize(opportunityList);
        Set<Id> campaignIds = new Set<Id>();
        for(Opportunity opportunityObj : OpportunityList) {
        	if(!String.isBlank(opportunityObj.campaignId)) {
        		campaignIds.add(opportunityObj.campaignId); 
        	}
        }
        Map<Id, Campaign> campaignMap = new Map<Id, Campaign>([SELECT Id, Lead_Creation_Score__c, Lead_Entry_Source__c, AID__c, 
        PID__c, BMID__c, DNIS__c, Team__c, NumberOfLeads, Lead_Score__c, Name FROM Campaign WHERE IsActive=true AND Id IN:campaignIds]); 
		
		Set<Id> accountIds = new Set<Id>();
		for(Opportunity opportunityObj : opportunityList) {
			accountIds.add(opportunityObj.AccountId);
		}
		Map<Id, Account> accountMap = new Map<Id, Account>([SELECT Id, No_of_Employees__c FROM Account WHERE Id IN:accountIds]);
		
		List<Note> noteList = new List<Note>();
		for(Opportunity opportunityObj : opportunityList) {
			//if(opportunityObj.Marketo_Duplicate_Lead__c == true) { 
				User userObj = userMap.get(opportunityObj.ownerId);
				if(userObj == null || !userObj.isActive || (userObj.Name.equalsIgnoreCase(name) || userObj.Name.equalsIgnoreCase(indiaTeam) || 
					userObj.Name.equalsIgnoreCase(partnerSync) || IS_SOLVE_THEN_SELL_OPPORTUNITY == true)) {
					Campaign campaignObj = campaignMap.get((String) opportunityObj.campaignId);
	                String customerSize = '';
					if(!String.isBlank(opportunityObj.Number_of_Employees__c)) {
		            	customerSize = empToCustomerSizeMap.get(opportunityObj.Number_of_Employees__c);
		            } else if(!String.isBlank(accountMap.get(opportunityObj.AccountId).No_of_Employees__c)) {
		                customerSize = empToCustomerSizeMap.get(accountMap.get(opportunityObj.AccountId).No_of_Employees__c);
		            } else {
		            	customerSize = empToCustomerSizeMap.get('DEFAULT');
					}
	                LARWrapper wrapperObj = new LARWrapper('D', customerSize,opportunityObj.campaignId, opportunityObj.LeadSource, opportunityObj.Lead_Entry_Source__c, '', '','OPPORTUNITY');
	                allUserSkills = LeadAssignmentHelper.getUserSkillsPerLeadEntrySource(wrapperObj, larList, skillsToUserSkills, finalSkillList, customerSize, skillsMap, finalSkillMap);
	                if(allUserSkills.size() == 0){
	                	allUserSkills = LeadAssignmentHelper.getUserSkillsPerCampaign(wrapperObj, campaignObj, larList, skillsToUserSkills, 
	                                                                        finalSkillList, customerSize, skillsMap, finalSkillMap);
	                }
	                if(allUserSkills.size() == 0){
	                    allUserSkills = LeadAssignmentHelper.getUserSkillsPerLeadSource(wrapperObj, larList, skillsToUserSkills, finalSkillList, 
	                                                                        customerSize, skillsMap, finalSkillMap);
	                }
	                if(allUserSkills.size() != 0){
		                skillsMap = LeadAssignmentHelper.assignLeadPerLAR(wrapperObj,finalSkillList,skillsMap,
			                                    allUserSkills,  skillsToUserSkills );
                    	if(String.isBlank(wrapperObj.ownerStr)) {
			        		opportunityObj.OwnerId = '005800000036sJJ';
                    	} else {
                			opportunityObj.ownerId = wrapperObj.ownerStr;
                    	}
                    	system.debug('==skillsMap=='+skillsMap);
                    	update skillsMap.values();
                    	system.debug('==skillsMap1=='+skillsMap);
	                } else {
	                	opportunityObj.OwnerId = '005800000036sJJ';
	                }
	                	opportunityObj.Send_Duplicate_Lead_Email__c = true;
	                	TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT = true;
	                	TriggerHandler.BY_PASS_ACCOUNT_ON_UPDATE = true;
				}
			//}
		}
	}
}