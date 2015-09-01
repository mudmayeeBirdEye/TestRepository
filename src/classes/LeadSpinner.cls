public class LeadSpinner {
    public List<User_Skill__c> allUserSkills{get;set;}
    public List<User_Skill__c> avaialbleUserSkills{get;set;}
    public List<User_Skill__c> refreshUserSkills{get;set;}
    public Map<Id, Skill__c> finalSkillMap{get;set;}
    
    public Lead leadObj{get;set;}
    public Campaign campaignObj{get;set;}
    public Integer currentUserIndex{get;set;}
    
    List<Id> finalSkillList{get;set;}
    Map<Id, List<User_Skill__c>> skillsToUserSkills{get;set;} 
    Map<Id, Skill__c> skillsMap{get;set;}
    
    public Boolean isErrorOccured{get;set;}
    public Boolean isEmptyFolder{get;set;}
    
    public void getLeadObj(Id recordId) {
    	try {
            leadObj = [SELECT Id, Name, Company, Email, Phone, SDR_Agents__c, SDR_Agents__r.Name, Owner.Name, Status, OwnerId, LeadSource, 
            		   Lead_Folder__c, Primary_Campaign__c, NumberOfEmployees__c, Effective_No_of_Employees_Range__c FROM Lead WHERE Id=: recordId];
        } catch(Exception ex) {
        	setException('Lead does not exist.');
        }
    }
    public Set<Id> getSDRProfiles() {
    	Set<Id> sdrIds = new Set<Id>();
    	for(Profile prof : [SELECT Id, Name FROM Profile WHERE Name LIKE '%SDR%'  ]) {
    		sdrIds.add(prof.Id);
    	}
    	return sdrIds;
    }
    public LeadSpinner(ApexPages.StandardController controller) {
    	isEmptyFolder = false;
    	isErrorOccured = false;
    	avaialbleUserSkills = new List<User_Skill__c>();
        allUserSkills = new List<User_Skill__c>();
        currentUserIndex = 0;
        finalSkillMap = new Map<Id, Skill__c>(); 
        refreshUserSkills = new List<User_Skill__c>();
        try {
            Id recordId = controller.getId();
            getLeadObj(recordId);
            if(leadObj != null) {
                Map<Id, List<User_Skill__c>> larToUserSkillsMap = new Map<Id, List<User_Skill__c>>();
                finalSkillList = new List<Id>();
                skillsMap = new Map<Id, Skill__c>();
                List<Lead_Assignment_Rules__c> larList = LeadTriggerHelper.getLarWithSkills(true);
                Set<String> skillIds = new Set<String>();
                for(Lead_Assignment_Rules__c larObj : larList) {
                    if(larObj.Skill__c != null) {
                        skillIds.add(larObj.Skill__c);
                        skillsMap.put(larObj.Skill__c, larObj.Skill__r);
                    }
                }
                skillsToUserSkills = LeadTriggerHelper.getSkillsToUserSkillsMap(skillsMap.keySet());
                Map<Id, Campaign> campaignMap = new Map<Id, Campaign>([SELECT Id, Lead_Creation_Score__c, Lead_Entry_Source__c, AID__c, 
                PID__c, BMID__c, DNIS__c, Team__c, NumberOfLeads, Lead_Score__c, Name FROM Campaign WHERE IsActive=true AND Id=:leadObj.Primary_Campaign__c]); 
                campaignObj = campaignMap.get((String) leadObj.Primary_Campaign__c);
                setDefaultFolder();
                Map<String, String> empToCustomerSizeMap =  LeadTriggerHelper.getCustomerSize(new List<Lead>{leadObj});
                //String customerSize = empToCustomerSizeMap.get(String.isBlank(leadObj.NumberOfEmployees__c) ? 'DEFAULT' : leadObj.NumberOfEmployees__c);
                String customerSize = empToCustomerSizeMap.get(String.isBlank(leadObj.Effective_No_of_Employees_Range__c) ? 'DEFAULT' : leadObj.Effective_No_of_Employees_Range__c);
                if(String.isBlank(customerSize)) { 
                	customerSize = empToCustomerSizeMap.get('DEFAULT');
                }
                allUserSkills = LeadTriggerHelper.getUserSkillsPerCampaign(leadObj, campaignObj, larList, skillsToUserSkills, 
                                                                        finalSkillList, customerSize, skillsMap, finalSkillMap);
                if(allUserSkills.size() == 0){
                    allUserSkills = LeadTriggerHelper.getUserSkillsPerLeadSource(leadObj, larList, skillsToUserSkills, finalSkillList, 
                                                                        customerSize, skillsMap, finalSkillMap);
                }
                setUniqueUserSkills();
                // refreshUserSkills.addAll(allUserSkills);
                createFreshUserList();
                // createOwnerList();
                getSkillToAssign();
            } else {
            	setException('Lead does not exist.'); 
            }
        } catch(Exception e) {
        	setException(e.getMessage()); 
        }
    }
    private void setUniqueUserSkills() {
    	List<User_Skill__c> tempUserSkills = new List<User_Skill__c>();
    	Map<Id, Integer> uniqueUserSkills = new Map<Id, Integer>();
    	Integer i = 0;
    	Set<Id> uniqueSkillSet = new Set<Id>();
    	if(allUserSkills.size() != 0) {
	    	/*for(User_Skill__c userSkill : allUserSkills) {
	    		uniqueUserSkills.put(userSkill.Id, i);
	    		++i;
	    	}
	    	for(Id userSkillId : uniqueUserSkills.keySet()) {
	    		tempUserSkills.add(allUserSkills.get(uniqueUserSkills.get(userSkillId)));
	    	}*/
	    	for(User_Skill__c userSkill : allUserSkills) {
	    		if(!uniqueSkillSet.contains(userSkill.User__r.Id)) {
	    			tempUserSkills.add(userSkill);
	    			uniqueSkillSet.add(userSkill.User__r.Id);
	    		}
	    	}
	    	allUserSkills.clear();
	    	allUserSkills.addAll(tempUserSkills);
    	}
    }
    private void setException(String exceptionStr) {
    	isErrorOccured = true;
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, exceptionStr)); 
    }
    private void setDefaultFolder() {
    	if(String.isBlank(leadObj.Lead_Folder__c)) {
        	leadObj.Lead_Folder__c ='B';
        	isEmptyFolder = true;
        } 
    }
    public void resetFolder() {
    	if(isEmptyFolder) {
			leadObj.Lead_Folder__c = null;
			isEmptyFolder = false;
		}
    }
    /*public Boolean isUnique(User_Skill__c userSkill) {
    	for(User_Skill__c userSkillObj : refreshUserSkills) {
    		if(userSkillObj.User__c == userSkill.User__c) {
    			return false;
    		}
    	}
    	return true;
    }*/
    /*
    public void createFreshUserList() {
    	refreshUserSkills.clear();
    	for(User_Skill__c userSkill : allUserSkills) {
        	if(userSkill.User__c == leadObj.OwnerId) {
        		userSkill.isLeadAssigned__c = true;
        	}
        	if(userSkill.isLeadAssigned__c == null) {
        		userSkill.isLeadAssigned__c = false;
        	}
        	if(userSkill.isLeadAssigned__c == null || userSkill.isLeadAssigned__c == false) {
        		if(isUnique(userSkill)) {
        			refreshUserSkills.add(userSkill);
        		}
        	}
        }
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'==> ' + allUserSkills.size()));
    }
    */
     /*public void createFreshUserList() {
    	refreshUserSkills.clear();
    	for(User_Skill__c userSkill : allUserSkills) {
        	if(userSkill.User__c != leadObj.OwnerId) {
        		if(isUnique(userSkill)) {
        			refreshUserSkills.add(userSkill);
        		}
        	}
        }
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'==> ' + allUserSkills.size()));
    }*/
     public void createFreshUserList() {
    	refreshUserSkills.clear();
    	Boolean currentIndexFound = false;
    	Map<Id, Integer> userSkillIndexMap = new Map<Id, Integer>();
    	for(User_Skill__c userSkill : allUserSkills) {
        	if(userSkill.User__c != leadObj.OwnerId) {
        		refreshUserSkills.add(userSkill);
        	} else {
        		currentIndexFound = true;
        	}
    		userSkillIndexMap.put(userSkill.Id, refreshUserSkills.size());
    	}
    	Integer currentIndex = 0;
        if(currentIndexFound) {
        	for(User_Skill__c userSkill : allUserSkills) {
        		if(userSkill.User__c == leadObj.OwnerId) {
	        		currentIndex = userSkillIndexMap.get(userSkill.Id);
	        		//++currentIndex;
	        		break;
	        	} 
        	}
        }
        if(refreshUserSkills.size() != 0) { 
        	if(currentIndex >= refreshUserSkills.size()) {
        		currentIndex = 0;
        	}
			currentUserIndex = currentIndex;
			avaialbleUserSkills = new List<User_Skill__c>{refreshUserSkills.get(currentUserIndex)};
		}
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'==> ' + allUserSkills.size()));
    }
    public void getSkillToAssign() {
    	/*
    	Integer i = 0;
    	for(User_Skill__c userSkill : refreshUserSkills) {
            if(userSkill.User__c == leadObj.OwnerId) {
                userSkill.isLeadAssigned__c = true;
                refreshUserSkills.remove(i);
                break;
            }
            ++i;
        }
        i = 0;
        for(User_Skill__c userSkill : refreshUserSkills) {
        	if(userSkill.IsLeadAssigned__c == null || userSkill.IsLeadAssigned__c == false) {
        		currentUserIndex = i;
        		avaialbleUserSkills = new List<User_Skill__c>{userSkill};
        		break;
        	}
            ++i;
        }
        */
    }
    private Integer getIndex(Integer index, List<User_Skill__c> userSkills) {
    	if(userSkills != null && userSkills.size() !=0) {
	    	if(index == null || index >= userSkills.size()) {
		        index = 0;
	        } else if(index < 0) {
	        	index = userSkills.size()-1;
	        }
    	}
        return index;
    }
    public void getNextUser() {
    	if(refreshUserSkills.size() !=0) {
    		Integer nextIndex = currentUserIndex +1;
        	if(nextIndex >= refreshUserSkills.size()) {
        		nextIndex = 0; 
        	}
        	currentUserIndex = nextIndex;
        	currentUserIndex = getIndex(currentUserIndex, refreshUserSkills);
        	//ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,currentUserIndex +' ,CURRENT INDEX = ' + refreshUserSkills.size()));
        	avaialbleUserSkills = new List<User_Skill__c>{refreshUserSkills.get(currentUserIndex)};
        }
    }
    public void getPreviousUser() {
    	if(refreshUserSkills.size() !=0) {
    		Integer nextIndex = currentUserIndex -1;
        	if(nextIndex >= refreshUserSkills.size()) { 
        		nextIndex = 0; 
        	} else if(nextIndex < 0 && refreshUserSkills.size() != 0) {
        		nextIndex = refreshUserSkills.size()-1;
        	}
        	currentUserIndex = nextIndex;
        	currentUserIndex = getIndex(currentUserIndex, refreshUserSkills);
        	// ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'CURRENT INDEX = ' + currentUserIndex));
        	avaialbleUserSkills = new List<User_Skill__c>{refreshUserSkills.get(currentUserIndex)};
        }
    }
    public PageReference goToLead() {
    	return new PageReference('/'+ leadObj.Id);
    }
    public void assignToSelectedUser() {
    	try {
	    	if(currentUserIndex >= 0 && currentUserIndex < refreshUserSkills.size()) {
	    		currentUserIndex = getIndex(currentUserIndex, refreshUserSkills);
	    		User_Skill__c userSkill = refreshUserSkills.get(currentUserIndex);
	    		if(leadObj.OwnerId != userSkill.User__c) {
		    		leadObj.ownerId = userSkill.User__c;
					// userSkill.isLeadAssigned__c = true;
					if(getSDRProfiles().contains((Id)UserInfo.getProfileId())) {
						leadObj.SDR_Agents__c = UserInfo.getUserId();
					}
					resetFolder();
		    		update leadObj;
		    		/*try{
			            if(allUserSkills.size() != 0) {
			            	if(refreshUserSkills.size() ==1) {
			            		for(User_Skill__c userSkillOld : allUserSkills) {
					        		userSkillOld.isLeadAssigned__c = false;
						        }
			            	}
			                update allUserSkills;
			            }
			        } catch(Exception ex){}
			        */ 
		    		refreshList();
		    		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Owner is changed successfully.'));
	    		} else {
	    			assignOnCurrentOwner(userSkill);
	    		}
	    	}
    	} catch(Exception e) {
    		setException('Error occured while changing owner.');
    	}
    	// return goToLead();
    }
    
    public void assignOnCurrentOwner(User_Skill__c userSkill) {
   		/*userSkill.isLeadAssigned__c = true;
		try{
            if(allUserSkills.size() != 0) {
            	if(refreshUserSkills.size() ==1) {
            		for(User_Skill__c userSkillOld : allUserSkills) {
		        		userSkillOld.isLeadAssigned__c = false;
			        }
            	}
                update allUserSkills;
            }
        } catch(Exception ex){} */
		refreshList();
		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Selected user is already current lead owner.'));
    }
    
    public void refreshList() {
    	try {
	    	// leadObj = [SELECT Id, Name, Company, Email, Phone, Owner.Name, Status, OwnerId, SDR_Agents__c, SDR_Agents__r.Name, LeadSource, Lead_Folder__c, Primary_Campaign__c, NumberOfEmployees__c FROM Lead WHERE Id=: leadObj.Id];
	    	getLeadObj(leadObj.Id);
	    	setDefaultFolder();
			refreshUserSkills.clear();
			// refreshUserSkills.addAll(allUserSkills); 
			createFreshUserList();
			getSkillToAssign();
    	} catch(Exception e){
    		setException('Error occured while changing owner.');
    	}
    }
   /* private static TestMethod void testLeadSpinner() {
			Profile prof = [SELECT Id, Name FROM Profile WHERE Name LIKE '%SDR%'  LIMIT 1];
			User user1 = new User(alias = 'newUser1', email='newuser1@simplion.com.test',
			emailencodingkey='UTF-8', lastname='Testing1', 
			languagelocalekey='en_US', localesidkey='en_US', profileid = prof.Id,
			timezonesidkey='America/Los_Angeles', username= System.now().millisecond() + 'newuser1@simplion.com.test');
			insert user1;
	        
	        User user2 = new User(alias = 'newUser2', email='newuser2@simplion.com.test',
			emailencodingkey='UTF-8', lastname='Testing2', 
			languagelocalekey='en_US', localesidkey='en_US', profileid = prof.Id,
			timezonesidkey='America/Los_Angeles', username= System.now().millisecond() + 'newuser2@simplion.com.test');
			insert user2;
			
			User user3 = new User(alias = 'newUser3', email='newuser3@simplion.com.test',
			emailencodingkey='UTF-8', lastname='Testing3', 
			languagelocalekey='en_US', localesidkey='en_US', profileid = prof.Id,
			timezonesidkey='America/Los_Angeles', username= System.now().millisecond() + 'newuser3@simplion.com.test');
			insert user3;
			
			System.runAs(user1) {
	            // Test.startTest();
	            Campaign campObj1 = new Campaign(Name='TestCampaign',Protected_Campaign__c=true ,Lead_Creation_Score__c='300', IsActive=true, 
			AID__c='test0121' );
	        
	        insert campObj1;
		
			Skill__c s1= new Skill__c(Name='Skill1');
			insert s1;
			Skill__c s2= new Skill__c(Name='Skill2');
			insert s2;
			User_Skill__c us1 = new User_Skill__c (Name='us1', User__c=user1.Id, Skill__c=s1.Id);
			insert us1;
			User_Skill__c us2 = new User_Skill__c (Name='us2', User__c=user2.Id, Skill__c=s1.Id);
			insert us2;
	        User_Skill__c us3 = new User_Skill__c (Name='us3', User__c=user1.Id, Skill__c=s2.Id);
			insert us3;
			User_Skill__c us4 = new User_Skill__c (Name='us3', User__c=user3.Id, Skill__c=s2.Id);
			insert us4;
	        Lead_Assignment_Rules__c lar1= new Lead_Assignment_Rules__c(Name='LAR1',IsSecondary__c=true, Campaign__c=campObj1.Id, Lead_Source__c='Inbaound Call',Skill__c=s1.Id);
	        Lead_Assignment_Rules__c lar2= new Lead_Assignment_Rules__c(Name='LAR1',IsSecondary__c=true, Campaign__c=campObj1.Id, Skill__c=s2.Id);
	        Lead_Assignment_Rules__c lar3= new Lead_Assignment_Rules__c(Name='LAR1',IsSecondary__c=false, Campaign__c=campObj1.Id,Lead_Source__c='Inbaound Call', Skill__c=s1.Id);
	        /*Lead_Assignment_Rules__c lar4= new Lead_Assignment_Rules__c(Name='LAR1',IsSecondary__c=true, Campaign__c=campObj3.Id,Skill__c=s2.Id);
	        Lead_Assignment_Rules__c lar5= new Lead_Assignment_Rules__c(Name='LAR1',IsSecondary__c=true, Campaign__c=campObj4.Id,Skill__c=s1.Id);
	        Lead_Assignment_Rules__c lar6= new Lead_Assignment_Rules__c(Name='LAR1',IsSecondary__c=true, Campaign__c=campObj5.Id,Skill__c=s2.Id);*/
	       // Lead_Assignment_Rules__c lar7= new Lead_Assignment_Rules__c(Name='LAR1',IsSecondary__c=true, Lead_Source__c='Inbound Call',Skill__c=s1.Id);
	       // Lead_Assignment_Rules__c lar8= new Lead_Assignment_Rules__c(Name='LAR1',IsSecondary__c=true, Lead_Source__c='Inbound Call',Skill__c=s2.Id);
	       /* List<Lead_Assignment_Rules__c> larList = new List<Lead_Assignment_Rules__c>();
	        larList.add(lar1);
	        larList.add(lar2);
	        /*larList.add(lar3);
	        larList.add(lar4);
	        larList.add(lar5);
	        larList.add(lar6);*/
	       /* larList.add(lar7);
	        larList.add(lar8);
	        insert larList;		
			
		
	        Lead leadObj = new Lead(firstName='Singh', Title='VP', Country='UK', AID__c='test0121'
	         ,LeadSource='Inbaound Call', lastname = 'Virendra', NumberOfEmployees__c='2-5',
	        company='Simplion', email='virendra.singh3@simplion.co.uk', phone='9910106803');
	        insert leadObj;
	        
        	ApexPages.StandardController sc = new ApexPages.standardController(leadObj);
        	LeadSpinner ui = new LeadSpinner(sc);
			ui.getNextUser();
			ui.assignToSelectedUser();
			ui.getPreviousUser();
			ui.assignToSelectedUser();
			// ui.isUnique(us1);
			ui.assignOnCurrentOwner(us1);
			
			ui.getIndex(-1, new List<User_Skill__c>{us1});
			ui.getIndex(null, new List<User_Skill__c>{us1});
			
			Lead leadObj1 = new Lead(firstName='Singh1', Title='VP', Country='UK', AID__c='test0122'
	         ,LeadSource='Inbaound Call', lastname = 'Virendra1', NumberOfEmployees__c='2-5',
	        company='Simplion1', email='virendra.singh5@simplion.co.uk', phone='9910106804',ownerId = user1.Id);
	        insert leadObj1;
	        sc = new ApexPages.standardController(leadObj1);
        	ui = new LeadSpinner(sc);
        	
	        leadObj1.lead_folder__c = null;
            ui.setDefaultFolder();
			ui.isEmptyFolder = true;
			ui.resetFolder();
			ui.getSDRProfiles();
        	try {
				String folder = leadObj1.lead_folder__c.trim();
			} catch(Exception ex) {
				ui.setException(ex.getMessage());
			}
			
			leadObj = new Lead(firstName='Singh', Title='VP', Country='UK'
             ,LeadSource='Inbound Call', lastname = 'Virendra', NumberOfEmployees__c=' ',
            company='Simplion', email='virendra.singh4@simplion.co.uk', phone='9910106803');
            insert leadObj;
			ui.goToLead();
        	sc = new ApexPages.standardController(leadObj);
        	ui = new LeadSpinner(sc);
        	
			ui.getNextUser();
			ui.getNextUser();
			ui.getNextUser();
			ui.getNextUser();
			ui.getPreviousUser();
			ui.getPreviousUser();
			ui.getPreviousUser();
			ui.getPreviousUser();
			ui.currentUserIndex = -1;
			ui.assignToSelectedUser();
			ui.assignOnCurrentOwner(us1);
			
			leadObj = new Lead();
			sc = new ApexPages.standardController(leadObj);
        	ui = new LeadSpinner(sc);
        	// Test.stopTest();
		}
    }*/
}