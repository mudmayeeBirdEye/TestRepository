public class ContactLeadAssignmentHelper { 
    public Static void validateCampaign(List<Contact> contactList) {
        Map<String, Campaign> defaultCampaignMap = CampaignAssignmentHelper.findCampaings(new List<CampaignWrapper>());
        Map<String, Campaign> defaultCampaign_15DigitMap = new Map<String, Campaign>();
        if(defaultCampaignMap!=null && defaultCampaignMap.size() > 0){
            for(String keyValue : defaultCampaignMap.keySet()){
                if(keyValue.length() > 15){
                    defaultCampaign_15DigitMap.put(keyValue.subString(0,15),defaultCampaignMap.get(keyValue));
                }
            }
        }
        for(Contact contactObj :contactList) {          
            if((!String.isBlank(contactObj.Primary_Campaign__c) && defaultCampaignMap != null && 
                            ((defaultCampaignMap.get(contactObj.Primary_Campaign__c.toUpperCase()) != null) || 
                            (defaultCampaign_15DigitMap != null && defaultCampaign_15DigitMap.get(contactObj.Primary_Campaign__c.toUpperCase()) != null))) 
                            ) {
                contactObj.Primary_Campaign__c = null;
            }
            //As per new case "02410144"
            if((!String.isBlank(contactObj.Most_Recent_Campaign__c) && defaultCampaignMap != null && 
                            ((defaultCampaignMap.get(string.valueOf(contactObj.Most_Recent_Campaign__c).toUpperCase()) != null) || 
                            (defaultCampaign_15DigitMap != null && defaultCampaign_15DigitMap.get(string.valueOf(contactObj.Most_Recent_Campaign__c).toUpperCase()) != null))) 
                            ) {
                contactObj.Most_Recent_Campaign__c = null;
            }
            //End As per new case "02410144"
        }
    }
    public static Map<String, Campaign> assignCampaignToContact(List<Contact> contactList) {
        Map<String, Campaign> campaignMap = new Map<String, Campaign>(); 
        List<CampaignWrapper> camWrapperList = new List<CampaignWrapper>();
        
        for(Contact contactObj : contactList) {
            //camWrapperList.add(new CampaignWrapper(contactObj.AID__c, contactObj.BMID__c, contactObj.PID__c, contactObj.Primary_Campaign__c, false));
            camWrapperList.add(new CampaignWrapper(contactObj.AID__c, contactObj.BMID__c, contactObj.PID__c, null, false));
        }
        
        Map<String, Campaign> criteriaToCamapaignMap = CampaignAssignmentHelper.findCampaings(camWrapperList);
        for(Contact contactObj :contactList) {
            Campaign campaignObj = CampaignAssignmentHelper.getLeadCampaign(new CampaignWrapper(contactObj.AID__c, contactObj.BMID__c, contactObj.PID__c, contactObj.Primary_Campaign__c, false), criteriaToCamapaignMap);
            if(campaignObj != null) {
                contactObj.Primary_Campaign__c = campaignObj.Id;
                contactObj.Most_Recent_Campaign__c = campaignObj.id;
                system.debug('==contactObj.Primary_Campaign__c=='+contactObj.Primary_Campaign__c);
                system.debug('==contactObj.Most_Recent_Campaign__c=='+contactObj.Most_Recent_Campaign__c);
                campaignMap.put((String)contactObj.Primary_Campaign__c, campaignObj);
            }
        }
        return campaignMap;
    }
    
    private static Map<String, String> getContactCustomerSize(List<Contact> contactList) {
        Map<String, String> empToCustomerSizeMap = new Map<String, String>();
        
        try{
            Set<Id> accountIds = new Set<Id>();
            for(Contact contactObj : contactList) {
                if(String.isBlank(contactObj.NumberOfEmployees__c)) {
                    accountIds.add(contactObj.AccountId);
                }
            }
            Map<Id, Account> accountMap = new Map<Id, Account>([SELECT Id, No_of_Employees__c FROM Account WHERE Id IN:accountIds]);
            
            
            Set<String> rangesCont = new Set<String>();
            Set<String> rangesAccount = new Set<String>();
            Schema.DescribeFieldResult numberOfEmployees = Account.No_of_Employees__c.getDescribe();
            List<Schema.PicklistEntry> numberOfEmployeesRange = numberOfEmployees.getPicklistValues();
            for(Schema.PicklistEntry schObj : numberOfEmployeesRange) {
                rangesAccount.add(schObj.getValue());
            }
            numberOfEmployees = Contact.NumberOfEmployees__c.getDescribe();
            numberOfEmployeesRange = numberOfEmployees.getPicklistValues();
            for(Schema.PicklistEntry schObj : numberOfEmployeesRange) {
                rangesCont.add(schObj.getValue());
            }
            
            for(Contact contactObj : contactList) {
                Set<String> ranges = new Set<String>();
                /*Schema.DescribeFieldResult numberOfEmployees = (String.isBlank(contactObj.NumberOfEmployees__c) ? Account.No_of_Employees__c.getDescribe() : Contact.NumberOfEmployees__c.getDescribe());
                List<Schema.PicklistEntry> numberOfEmployeesRange = numberOfEmployees.getPicklistValues();
                for(Schema.PicklistEntry schObj : numberOfEmployeesRange) {
                    ranges.add(schObj.getValue());
                }*/
                if(!String.isBlank(contactObj.NumberOfEmployees__c)) {
                    ranges.addAll(rangesCont);
                } else {
                    ranges.addAll(rangesAccount);
                }
                String customerSize = '2-9';
                String employeeSize = 'DEFAULT';
                if(!String.isBlank(contactObj.NumberOfEmployees__c)) {
                    customerSize = contactObj.NumberOfEmployees__c;
                    employeeSize = customerSize;
                } else if(contactObj.AccountId != null && accountMap.get(contactObj.AccountId) != null && !String.isBlank(accountMap.get(contactObj.AccountId).No_of_Employees__c) && ranges.contains(accountMap.get(contactObj.AccountId).No_of_Employees__c)) {
                    customerSize = accountMap.get(contactObj.AccountId).No_of_Employees__c;
                    employeeSize = customerSize;
                }
                empToCustomerSizeMap.put(employeeSize, customerSize);
            }
        }catch(Exception ex){
            system.debug('Exception ====='+ex.getMessage());
        }
        return empToCustomerSizeMap;
    }
    public static void initialContacts(List<Contact> contactList, Map<Id, User> userMap) {
        try{
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
            Map<String, String> empToCustomerSizeMap =  getContactCustomerSize(contactList);
            Set<Id> campaignIds = new Set<Id>();
            for(Contact contactObj : ContactList) {
                if(!String.isBlank(contactObj.Primary_Campaign__c)) {
                    campaignIds.add(contactObj.Primary_Campaign__c); 
                } 
            }
            Map<Id, Campaign> campaignMap = new Map<Id, Campaign>([SELECT Id, Lead_Creation_Score__c, Lead_Entry_Source__c, AID__c, 
            PID__c, BMID__c, DNIS__c, Team__c, NumberOfLeads, Lead_Score__c, Name FROM Campaign WHERE IsActive=true AND Id IN:campaignIds]); 
            
            Set<Id> accountIds = new Set<Id>();
            for(Contact contactObj : contactList) {
                accountIds.add(contactObj.AccountId);
            }
            Map<Id, Account> accountMap = new Map<Id, Account>([SELECT Id, No_of_Employees__c FROM Account WHERE Id IN:accountIds]);
            
            List<Note> noteList = new List<Note>();
            for(Contact contactObj : contactList) {
                if(contactObj.Marketo_Duplicate_Lead__c == true) {
                    User userObj = userMap.get(contactObj.ownerId);
                    // contactObj.addError('==== ');
                    if(userObj == null || !userObj.isActive || (userObj.Name.equalsIgnoreCase(name) || userObj.Name.equalsIgnoreCase(indiaTeam) || userObj.Name.equalsIgnoreCase(partnerSync))) {
                        
                        Campaign campaignObj = campaignMap.get((String) contactObj.Primary_Campaign__c);
                        String customerSize = '';
                        if(!String.isBlank(contactObj.NumberOfEmployees__c)) {
                            customerSize = empToCustomerSizeMap.get(contactObj.NumberOfEmployees__c);
                        } else if(!String.isBlank(accountMap.get(contactObj.AccountId).No_of_Employees__c)) {
                            customerSize = empToCustomerSizeMap.get(accountMap.get(contactObj.AccountId).No_of_Employees__c);
                        } else {
                            customerSize = empToCustomerSizeMap.get('DEFAULT');
                        }
                        LARWrapper wrapperObj = new LARWrapper((String.isBlank(contactObj.folder__c) ? 'D' : contactObj.folder__c), customerSize,contactObj.Primary_Campaign__c, contactObj.LeadSource, contactObj.Lead_Entry_Source__c, '', '','CONTACT');
                        // contactObj.addError('##### ' + customerSize + ' ##### ' + empToCustomerSizeMap.values().get(0));
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
                                contactObj.OwnerId = '005800000036sJJ';
                            } else {
                                contactObj.ownerId = wrapperObj.ownerStr;
                            }
                            update skillsMap.values();
                        } else {
                            contactObj.OwnerId = '005800000036sJJ';
                        }
                        contactObj.Send_Duplicate_Lead_Email__c = true; 
                    }
                }
            }
        }catch(Exception ex){
            system.debug('Exception ====='+ex.getMessage());
        }
    }
    
    /********************Update Most Recent Campaign on Contact***************************/
    public static void updateMostRecentCampaign(List<Contact> newContactList,map<id,Contact> oldContactMap){
        Set<string> UniqueCombinationSet = new Set<string>();
        List<Contact> updatedContactList = new List<Contact>();
        List<CampaignWrapper> camWrapperList = new List<CampaignWrapper>();
        try{
            for(Contact contactObj : newContactList){               
                if((contactObj.BMID__c!=null && contactObj.BMID__c != oldContactMap.get(contactObj.Id).BMID__c) ||
                    (contactObj.AID__c!=null && contactObj.AID__c != oldContactMap.get(contactObj.Id).AID__c) ||
                    (contactObj.PID__c!=null && contactObj.PID__c != oldContactMap.get(contactObj.Id).PID__c)) {
                    
                    map<String,boolean> fieldUpdateMap = new map<String,boolean>{'BMID'=>false,'AID'=>false,'PID'=>false};
                    if(contactObj.BMID__c != oldContactMap.get(contactObj.Id).BMID__c){ 
                        fieldUpdateMap.put('BMID',true);    
                    }
                    if(contactObj.AID__c != oldContactMap.get(contactObj.Id).AID__c){
                        fieldUpdateMap.put('AID',true);
                    }
                    if(contactObj.PID__c != oldContactMap.get(contactObj.Id).PID__c){
                        fieldUpdateMap.put('PID',true);
                    }
                    if(fieldUpdateMap!=null && fieldUpdateMap.get('BMID')!=null && fieldUpdateMap.get('BMID')==false){
                        contactObj.BMID__c = '';
                    }
                    if(fieldUpdateMap!=null && fieldUpdateMap.get('AID')!=null && fieldUpdateMap.get('AID')==false){
                        contactObj.AID__c = '';
                    }
                    if(fieldUpdateMap!=null && fieldUpdateMap.get('PID')!=null && fieldUpdateMap.get('PID')==false){
                        contactObj.PID__c = '';
                    }               
                    updatedContactList.add(contactObj);
                    camWrapperList.add(new CampaignWrapper(contactObj.AID__c, contactObj.BMID__c, contactObj.PID__c, null, false)); 
                                        
                } else if((contactObj.BMID__c != oldContactMap.get(contactObj.Id).BMID__c) ||
                    (contactObj.AID__c != oldContactMap.get(contactObj.Id).AID__c) ||
                    (contactObj.PID__c != oldContactMap.get(contactObj.Id).PID__c)){
                        updatedContactList.add(contactObj); 
                        camWrapperList.add(new CampaignWrapper(contactObj.AID__c, contactObj.BMID__c, contactObj.PID__c, null, false));                         
                }
            }
            
            if(updatedContactList!=null && updatedContactList.size() > 0){
                Map<String, Campaign> criteriaToCamapaignMap = CampaignAssignmentHelper.findCampaings(camWrapperList);
                for(Contact contactObj : updatedContactList){
                    Campaign campaignObj = CampaignAssignmentHelper.getLeadCampaign(new CampaignWrapper(contactObj.AID__c, contactObj.BMID__c, contactObj.PID__c, null, false), criteriaToCamapaignMap);
                    system.debug('==campaignObj=='+campaignObj);
                    if(campaignObj != null && campaignObj.Name!='Default Campaign') {
                        contactObj.Primary_Campaign__c = campaignObj.Id;
                        contactObj.Most_Recent_Campaign__c = campaignObj.Id;                
                    }
                }
            }
        }catch(exception e){
            System.debug('==Exception=='+e.getMessage()+'==Line=='+e.getLineNumber());
        }
    }
    /******End of Update Most Recent Campaign on Contact*******/ 
}