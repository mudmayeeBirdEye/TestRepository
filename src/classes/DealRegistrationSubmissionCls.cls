global class  DealRegistrationSubmissionCls{
    
    // Declare Property
    static Map<String,String> responseMap;
    static String STATUS_SUCCESS;
    static String STATUS_FAILURE;
    static String APPROVED_STATUS;
    static String REJECTED_PROTECTED;
    static String REJECTED_EXPIRED;
    static Integer DealRegistrationPeriod;
    static List<RecordsWrappper> recordsWrp;
    static List<RecordsWrappper> approvedRecords;
    static List<RecordsWrappper> expiredRecords;
    static List<RecordsWrappper> protectedRecords;
    static Map<String,String> mapStatus;
    static String strPartnerAgentName;
    static String strPartnerAgentId;
    static Integer approvedPartnerDealId;
    static Integer expiredPartnerDealId;
    static Integer protectedPartnerDealId;
    static String approvedPartnerDealExpDate;
    static String expiredPartnerDealExpDate;
    static String protectedPartnerDealExpDate;
    static Integer strPartnerDealId;
    static String strDealRegistrationDate;
    static Map<String,List<OpportunityContactRole>> contactOppCount;
    static String strBTBrand;
    
    static{
        contactOppCount = new Map<String,List<OpportunityContactRole>>();
        mapStatus = new Map<String,String>();
        mapStatus.put('approved', 'BT Approved');
        mapStatus.put('protected', 'BT Rejected (Protected)');
        mapStatus.put('expired', 'BT Rejected (Expired)');
        
        // Getting the Deal Registration Period and Response value from Custom Setting.
        if(!Test.isRunningTest()){
            DealRegistrationPeriod = Integer.valueOf(DealRegistrationPeriod__c.getAll().get('DealRegistrationPeriod').value__c);
            STATUS_SUCCESS = BT_API_Response__c.getAll().get('STATUS_SUCCESS').value__c;
            STATUS_FAILURE = BT_API_Response__c.getAll().get('STATUS_FAILURE').value__c;
            APPROVED_STATUS = BT_API_Response__c.getAll().get('APPROVED_STATUS').value__c;
            REJECTED_PROTECTED = BT_API_Response__c.getAll().get('REJECTED_PROTECTED').value__c;
            REJECTED_EXPIRED = BT_API_Response__c.getAll().get('REJECTED_EXPIRED').value__c;
            strBTBrand = RcDealHealper.getBTBrand();
        }else{
            DealRegistrationPeriod = 90;
            STATUS_SUCCESS = 'Success';
            STATUS_FAILURE = 'Failure';
            APPROVED_STATUS = 'Approved';
            REJECTED_PROTECTED = 'Rejected - Protected';
            REJECTED_EXPIRED = 'Rejected - Expired';
            strBTBrand = 'BT Business';
        }
    }
    
    Webservice static String submitDealRegistration(String partnerAgentName, String partnerAgentId, String company, String firstName, String lastName, 
                                                                    String email, String phone, String numberOfEmployees, String zipCode){
        system.debug('Inside DealRegistration API');
        String responseString = '';
        Boolean isError = false;
        Boolean isBTDealApproved = true;
        responseMap = new Map<String,String>();
        recordsWrp = new List<RecordsWrappper>();
        approvedRecords = new List<RecordsWrappper>();
        protectedRecords = new List<RecordsWrappper>();
        expiredRecords = new List<RecordsWrappper>();
        strPartnerAgentName = partnerAgentName;
        strPartnerAgentId = partnerAgentId;
        assingResponse('','','','','');
        List<String> conIds = new List<String>();
        
        try{
            if(String.isBlank(company) || String.isBlank(firstName) || String.isBlank(lastName) || String.isBlank(email) 
                                                                    || String.isBlank(phone) || String.isBlank(numberOfEmployees)){
                assingResponse(STATUS_FAILURE,'01','','','');
                isError = true;
            }
        
            if(!isError && !String.isBlank(email) && !isValidEmail(email)){
                assingResponse(STATUS_FAILURE,'02','','','');
                isError = true;
            }
            
            if(!isError){
                // Finding the Lead and Contacts on the basis of Email and Phone.
                RcDealHealper helperObj = new RcDealHealper();
                RcDealHealper.searchResultClass searchResult = helperObj.LeadContactSearch(email, phone);
                Boolean isFound = false;
                List<Lead> lstLeads = searchResult.leadResultList;
                List<Contact> lstContacts = searchResult.contactResultList;
                if((lstLeads != null && lstLeads.size() > 0) || (lstContacts != null && lstContacts.size() > 0)){
                    isFound = true;
                }
                
                if(isFound){
                    //If matching found.
                    for(Lead obj : lstLeads){
                        recordsWrp.add(new RecordsWrappper(obj.Id, 'Lead', Integer.valueOf(obj.PartnerDeal_Registration_ID__c), obj.PartnerDeal_Status__c, 
                                           obj.Status, obj.RecordType.Name, '', '', obj.PartnerDeal_Registration_Expiration_Date__c));
                    }
                    
                    for(Contact obj : lstContacts){
                        conIds.add(obj.Id);
                        recordsWrp.add(new RecordsWrappper(obj.Id, 'Contact', Integer.valueOf(obj.PartnerDeal_Registration_ID__c), obj.PartnerDeal_Status__c, 
                                           '', obj.RecordType.Name, obj.Account.RC_Account_Status__c, obj.AccountId, obj.PartnerDeal_Registration_Expiration_Date__c));
                    }
                    
                    recordsWrp.sort();
                    system.debug('recordsWrp == ' + recordsWrp);
                    if(conIds != null && conIds.size() > 0){
                        for(OpportunityContactRole ocrObj : [SELECT o.Opportunity.StageName, ContactId FROM OpportunityContactROLE o 
                                                                        WHERE o.ContactId IN :conIds AND o.IsPrimary = true]){
                            List<OpportunityContactRole> ocrLst = new List<OpportunityContactRole>();
                            if(contactOppCount.containsKey(ocrObj.ContactId)){
                                ocrLst = contactOppCount.get(ocrObj.ContactId);
                                ocrLst.add(ocrObj);
                                contactOppCount.put(ocrObj.ContactId, ocrLst);
                            }else{
                                ocrLst.add(ocrObj);
                                contactOppCount.put(ocrObj.ContactId, ocrLst);
                            }
                        }
                    }
                    
                    // Run BT Registred Logic for every matching record.
                    for(RecordsWrappper recordObj : recordsWrp){
                        isBTDealApproved(recordObj);
                    }
                    
                    
                    if(protectedRecords != null && protectedRecords.size() > 0){ // Rejected - Protected
                        updateProtectedRecords();
                        assingResponse(STATUS_SUCCESS, '', REJECTED_PROTECTED, String.valueOf(strPartnerDealId), strDealRegistrationDate);
                    }else if(expiredRecords != null && expiredRecords.size() > 0){ // Rejected - Expired
                        updateExpiredRecords();
                        assingResponse(STATUS_SUCCESS, '', REJECTED_EXPIRED, String.valueOf(strPartnerDealId), strDealRegistrationDate);
                    }else{ // All Approved
                        updateApprovedRecords();
                        assingResponse(STATUS_SUCCESS, '', APPROVED_STATUS, String.valueOf(strPartnerDealId), strDealRegistrationDate);
                    }
                    
                }else{
                    //If no matching found.
                    // Create a new Partner Lead and Mark BT Registerd.
                    Lead leadObj = new Lead();
                    leadObj.Partner_Agent_Name__c = partnerAgentName;
                    leadObj.Partner_Agent_ID__c = partnerAgentId;
                    leadObj.FirstName = firstName;
                    leadObj.LastName = lastName;
                    leadObj.Email = email;
                    leadObj.Company = company;
                    String formattedPhoneNumber = helperObj.getFormattedPhone(phone);
                    leadObj.Phone = formattedPhoneNumber;
                    leadObj.Lead_Brand_Name__c = strBTBrand;
                    leadObj.NumberOfEmployees__c = numberOfEmployees;
                    leadObj.PartnerDeal_Status__c = mapStatus.get('approved');
                    leadObj.PartnerDeal_Registration_Expiration_Date__c = system.today() + DealRegistrationPeriod;
                    leadObj.PartnerDeal_Registration_ID__c = generatePartnerDealId();
                    leadObj.Assignment_Source_hidden__c = 'BT Webservices';
                    leadObj.PostalCode = zipCode;
                    leadObj.RecordTypeId = OpportunityHelper.getOppRecordTypeMap('Partner Leads');
                    insert leadObj;
                    assingResponse(STATUS_SUCCESS, '', APPROVED_STATUS, String.valueOf(leadObj.PartnerDeal_Registration_ID__c), String.valueOf(leadObj.PartnerDeal_Registration_Expiration_Date__c));
                }
            }
        }catch(Exception ex){
            system.debug('Exception===' + ex.getMessage() + ex.getStackTraceString());
            assingResponse(STATUS_FAILURE,'03','','','');
        }
        try{
            // Generating the Response
            JSONGenerator generator = JSON.createGenerator(true);
            generator.writeStartObject();
            generator.writeStringField('Status', responseMap.get('Status'));
            generator.writeStringField('ErrorCode', responseMap.get('ErrorCode'));
            if(responseMap.containsKey('ApprovalStatus')){
                generator.writeStringField('ApprovalStatus', responseMap.get('ApprovalStatus'));
            }
            if(responseMap.containsKey('PartnerDealID')){
                generator.writeStringField('PartnerDealID', responseMap.get('PartnerDealID'));
            }
            if(responseMap.containsKey('ValidUntilDate')){
                generator.writeStringField('ValidUntilDate', responseMap.get('ValidUntilDate'));
            }
            generator.writeEndObject();
            responseString = generator.getAsString();
        }catch(Exception ex){
            system.debug('Exception===' + ex.getMessage() + ex.getStackTraceString());
            assingResponse(STATUS_FAILURE,'03','','','');
        }
        
        return  responseString;                                                             
    }
    
    public static void updateProtectedRecords(){
        system.debug('*** Updated Protected Records ***');
        List<Lead> leadsToUpdate = new List<Lead>();
        List<Contact> contactsToUpdate = new List<Contact>();
        strPartnerDealId = protectedPartnerDealId;
        strDealRegistrationDate = protectedPartnerDealExpDate;
        strPartnerDealId = strPartnerDealId == null || strPartnerDealId == 0.0 ? generatePartnerDealId() : strPartnerDealId;
        strDealRegistrationDate = String.isBlank(strDealRegistrationDate) ? '' : strDealRegistrationDate;
        String partnerDealStatus =  mapStatus.get('protected');
        
        if(protectedRecords != null && protectedRecords.size() > 0){
            for(RecordsWrappper recordObj : protectedRecords){
                String recordObjType = recordObj.objType;
                if('Lead'.equalsIgnoreCase(recordObjType)){
                    Lead leadObj = new Lead();
                    leadObj.Id = recordObj.objId;
                    if(recordObj.objPartnerDealId == null || recordObj.objPartnerDealId == 0.0){
                        leadObj.PartnerDeal_Registration_ID__c = strPartnerDealId;
                    }
                    
                    Date dealExpDate =  leadObj.PartnerDeal_Registration_Expiration_Date__c;
                    if(dealExpDate == null && !String.isBlank(strDealRegistrationDate)){ //If Date is null
                        leadObj.PartnerDeal_Registration_Expiration_Date__c = Date.valueOf(strDealRegistrationDate);
                    }
                    leadObj.PartnerDeal_Status__c = partnerDealStatus;
                    
                    leadsToUpdate.add(leadObj);
                }else if('Contact'.equalsIgnoreCase(recordObjType)){
                    Contact contactObj = new Contact();
                    contactObj.Id = recordObj.objId;
                    if(recordObj.objPartnerDealId == null || recordObj.objPartnerDealId == 0.0){
                        contactObj.PartnerDeal_Registration_ID__c = strPartnerDealId;
                    }
                    
                    Date dealExpDate =  contactObj.PartnerDeal_Registration_Expiration_Date__c;
                    if(dealExpDate == null && !String.isBlank(strDealRegistrationDate)){ //If Date is null
                        contactObj.PartnerDeal_Registration_Expiration_Date__c = Date.valueOf(strDealRegistrationDate);
                    }               
                    contactObj.PartnerDeal_Status__c = partnerDealStatus;
                    contactsToUpdate.add(contactObj);
                }
            }
            
            if(leadsToUpdate != null && leadsToUpdate.size() > 0){
                update leadsToUpdate;
            }
            if(contactsToUpdate != null && contactsToUpdate.size() > 0){
                update contactsToUpdate;
            }
        }
    }
    
    public static void updateApprovedRecords(){
        system.debug('*** Updated Approved Records ***');
        Date todayDate = system.today();
        List<Lead> leadsToUpdate = new List<Lead>();
        List<Contact> contactsToUpdate = new List<Contact>();
        List<Account> accountToUpdate = new List<Account>();
        Map<String,Boolean> checkAccMap = new Map<String,Boolean>();
        strPartnerDealId = approvedPartnerDealId;
        strDealRegistrationDate = approvedPartnerDealExpDate;
        strPartnerDealId = strPartnerDealId == null || strPartnerDealId == 0.0 ? generatePartnerDealId() : strPartnerDealId;
        strDealRegistrationDate = String.isBlank(strDealRegistrationDate) ? String.valueOf(todayDate + DealRegistrationPeriod) : strDealRegistrationDate;
        String partnerDealStatus =  mapStatus.get('approved');
        
        if(approvedRecords != null && approvedRecords.size() > 0){
            for(RecordsWrappper recordObj : approvedRecords){
                String recordObjType = recordObj.objType;
                if('Lead'.equalsIgnoreCase(recordObjType)){
                    Lead leadObj = new Lead();
                    leadObj.Id = recordObj.objId;
                    if(recordObj.objPartnerDealId == null || recordObj.objPartnerDealId == 0.0){
                        leadObj.PartnerDeal_Registration_ID__c = strPartnerDealId;
                    }
                    
                    Date dealExpDate =  recordObj.objDealRegistrationExpDate;
                    if(dealExpDate == null || todayDate > dealExpDate){//If Date is null or past than update
                        leadObj.PartnerDeal_Registration_Expiration_Date__c = Date.valueOf(strDealRegistrationDate);
                    }
                    leadObj.Partner_Agent_ID__c = strPartnerAgentId;
                    leadObj.Partner_Agent_Name__c = strPartnerAgentName;
                    leadObj.Lead_Brand_Name__c = strBTBrand;
                    leadObj.PartnerDeal_Status__c = partnerDealStatus;
                    
                    leadsToUpdate.add(leadObj);
                }else if('Contact'.equalsIgnoreCase(recordObjType)){
                    Contact contactObj = new Contact();
                    contactObj.Id = recordObj.objId;
                    if(recordObj.objPartnerDealId == null || recordObj.objPartnerDealId == 0.0){
                        contactObj.PartnerDeal_Registration_ID__c = strPartnerDealId;
                    }
                    
                    Date dealExpDate =  recordObj.objDealRegistrationExpDate;
                    if(dealExpDate == null || todayDate > dealExpDate){ //If Date is null or past than update
                        contactObj.PartnerDeal_Registration_Expiration_Date__c = Date.valueOf(strDealRegistrationDate);
                    }               
                    contactObj.Partner_Agent_ID__c = strPartnerAgentId;
                    if(String.isNotBlank(recordObj.objAccountId+'') && !checkAccMap.containsKey(recordObj.objAccountId+'')){
                        accountToUpdate.add(new Account(Id = recordObj.objAccountId, RC_Brand__c = strBTBrand));
                        checkAccMap.put(recordObj.objAccountId+'',true);
                    }
                    contactObj.Partner_Agent_Name__c = strPartnerAgentName;
                    contactObj.PartnerDeal_Status__c = partnerDealStatus;
                    contactsToUpdate.add(contactObj);
                }
            }
            if(leadsToUpdate != null && leadsToUpdate.size() > 0){
                update leadsToUpdate;
            }
            if(contactsToUpdate != null && contactsToUpdate.size() > 0){
                update contactsToUpdate;
            }
            if(accountToUpdate != null && accountToUpdate.size() > 0){
                TriggerHandler.BY_PASS_ACCOUNT_ON_UPDATE();
                update accountToUpdate;
            }
        }
        
    }
    
    public static void updateExpiredRecords(){
        system.debug('*** Updated Expired Records ***');
        List<Lead> leadsToUpdate = new List<Lead>();
        List<Contact> contactsToUpdate = new List<Contact>();
        strPartnerDealId = expiredPartnerDealId;
        strDealRegistrationDate = expiredPartnerDealExpDate;
        strPartnerDealId = strPartnerDealId == null || strPartnerDealId == 0.0 ? generatePartnerDealId() : strPartnerDealId;
        strDealRegistrationDate = String.isBlank(strDealRegistrationDate) ? '' : strDealRegistrationDate;
        String partnerDealStatus =  mapStatus.get('expired');
        
        if(expiredRecords != null && expiredRecords.size() > 0){
            for(RecordsWrappper recordObj : expiredRecords){
                String recordObjType = recordObj.objType;
                if('Lead'.equalsIgnoreCase(recordObjType)){
                    Lead leadObj = new Lead();
                    leadObj.Id = recordObj.objId;
                    if(recordObj.objPartnerDealId == null || recordObj.objPartnerDealId == 0.0){
                        leadObj.PartnerDeal_Registration_ID__c = strPartnerDealId;
                    }
                    
                    Date dealExpDate =  recordObj.objDealRegistrationExpDate;
                    if(dealExpDate == null && !String.isBlank(strDealRegistrationDate)){ //If Date is null
                        leadObj.PartnerDeal_Registration_Expiration_Date__c = Date.valueOf(strDealRegistrationDate);
                    }
                    leadObj.PartnerDeal_Status__c = partnerDealStatus;
                    
                    leadsToUpdate.add(leadObj);
                }else if('Contact'.equalsIgnoreCase(recordObjType)){
                    Contact contactObj = new Contact();
                    contactObj.Id = recordObj.objId;
                    if(recordObj.objPartnerDealId == null || recordObj.objPartnerDealId == 0.0){
                        contactObj.PartnerDeal_Registration_ID__c = strPartnerDealId;
                    }
                    
                    Date dealExpDate =  recordObj.objDealRegistrationExpDate;
                    if(dealExpDate == null && !String.isBlank(strDealRegistrationDate)){ //If Date is null
                        contactObj.PartnerDeal_Registration_Expiration_Date__c = Date.valueOf(strDealRegistrationDate);
                    }               
                    contactObj.PartnerDeal_Status__c = partnerDealStatus;
                    contactsToUpdate.add(contactObj);
                }
            }
            if(leadsToUpdate != null && leadsToUpdate.size() > 0){
                update leadsToUpdate;
            }
            if(contactsToUpdate != null && contactsToUpdate.size() > 0){
                update contactsToUpdate;
            }
        }
    
    }
    
    
    
    public static void isBTDealApproved(RecordsWrappper recordObj){
        Boolean isBTRegistered = false;
        Integer noOfDays;
        
        String recordStatus = recordObj.objDealStatus;
        if('BT Approved'.equalsIgnoreCase(recordStatus)){
            isBTRegistered = true;
        }
        
        if(isBTRegistered){
            // Already registered to BT
            Date dealValidDate = recordObj.objDealRegistrationExpDate;
            Date todayDate = system.today();
            noOfDays = todayDate.daysBetween(dealValidDate);
            if(noOfDays >= 0 && noOfDays <= DealRegistrationPeriod){
                //Deal is not expired
                if(approvedPartnerDealId == null || approvedPartnerDealId == 0){
                    approvedPartnerDealId = Integer.valueOf(recordObj.objPartnerDealId);
                }
                if(String.isBlank(approvedPartnerDealExpDate)){
                    approvedPartnerDealExpDate = String.valueOf(recordObj.objDealRegistrationExpDate);
                }
                approvedRecords.add(recordObj);
                
            }else{
                //Deal expired
                noOfDays = dealValidDate.daysBetween(todayDate);
                if(noOfDays > 273){
                    // 9 months after Expiration Date.
                    String recordObjType = recordObj.objType;
                    if('Lead'.equalsIgnoreCase(recordObjType)){
                        if(protectionEvaluationCriteriaLead(recordObj)){
                            if(approvedPartnerDealId == null || approvedPartnerDealId == 0){
                                approvedPartnerDealId = Integer.valueOf(recordObj.objPartnerDealId);
                            }
                            if(String.isBlank(approvedPartnerDealExpDate)){
                                approvedPartnerDealExpDate = String.valueOf(recordObj.objDealRegistrationExpDate);
                            }
                            approvedRecords.add(recordObj);
                        }else{
                            if(protectedPartnerDealId == null || protectedPartnerDealId == 0){
                                protectedPartnerDealId = Integer.valueOf(recordObj.objPartnerDealId);
                            }
                            if(String.isBlank(protectedPartnerDealExpDate)){
                                protectedPartnerDealExpDate = String.valueOf(recordObj.objDealRegistrationExpDate);
                            }
                            protectedRecords.add(recordObj);
                        }
                    }else if('Contact'.equalsIgnoreCase(recordObjType)){
                        if(protectionEvaluationCriteriaContact(recordObj)){
                            if(approvedPartnerDealId == null || approvedPartnerDealId == 0){
                                approvedPartnerDealId = Integer.valueOf(recordObj.objPartnerDealId);
                            }
                            if(String.isBlank(approvedPartnerDealExpDate)){
                                approvedPartnerDealExpDate = String.valueOf(recordObj.objDealRegistrationExpDate);
                            }
                            approvedRecords.add(recordObj);
                        }else{
                            if(protectedPartnerDealId == null || protectedPartnerDealId == 0){
                                protectedPartnerDealId = Integer.valueOf(recordObj.objPartnerDealId);
                            }
                            if(String.isBlank(protectedPartnerDealExpDate)){
                                protectedPartnerDealExpDate = String.valueOf(recordObj.objDealRegistrationExpDate);
                            }
                            protectedRecords.add(recordObj);
                        }
                    }
                }else{
                    // 9 months before Expiration Date.
                    if(expiredPartnerDealId == null || expiredPartnerDealId == 0){
                        expiredPartnerDealId = Integer.valueOf(recordObj.objPartnerDealId);
                    }
                    if(String.isBlank(expiredPartnerDealExpDate)){
                        expiredPartnerDealExpDate = String.valueOf(recordObj.objDealRegistrationExpDate);
                    }
                    expiredRecords.add(recordObj);
                }
            }
        }else{
            // Not registered to BT.
            String recordObjType = recordObj.objType;
            if('Lead'.equalsIgnoreCase(recordObjType)){
                if(protectionEvaluationCriteriaLead(recordObj)){
                    if(approvedPartnerDealId == null || approvedPartnerDealId == 0){
                        approvedPartnerDealId = Integer.valueOf(recordObj.objPartnerDealId);
                    }
                    if(String.isBlank(approvedPartnerDealExpDate)){
                        approvedPartnerDealExpDate = String.valueOf(recordObj.objDealRegistrationExpDate);
                    }
                    approvedRecords.add(recordObj);
                }else{
                    if(protectedPartnerDealId == null || protectedPartnerDealId == 0){
                        protectedPartnerDealId = Integer.valueOf(recordObj.objPartnerDealId);
                    }
                    if(String.isBlank(protectedPartnerDealExpDate)){
                        protectedPartnerDealExpDate = String.valueOf(recordObj.objDealRegistrationExpDate);
                    }
                    protectedRecords.add(recordObj);
                }
            }else if('Contact'.equalsIgnoreCase(recordObjType)){
                if(protectionEvaluationCriteriaContact(recordObj)){
                    if(approvedPartnerDealId == null || approvedPartnerDealId == 0){
                        approvedPartnerDealId = Integer.valueOf(recordObj.objPartnerDealId);
                    }
                    if(String.isBlank(approvedPartnerDealExpDate)){
                        approvedPartnerDealExpDate = String.valueOf(recordObj.objDealRegistrationExpDate);
                    }
                    approvedRecords.add(recordObj);
                }else{
                    if(protectedPartnerDealId == null || protectedPartnerDealId == 0){
                        protectedPartnerDealId = Integer.valueOf(recordObj.objPartnerDealId);
                    }
                    if(String.isBlank(protectedPartnerDealExpDate)){
                        protectedPartnerDealExpDate = String.valueOf(recordObj.objDealRegistrationExpDate);
                    }
                    protectedRecords.add(recordObj);
                }
            }
        }
    }
    
    public static Boolean protectionEvaluationCriteriaLead(RecordsWrappper recordObj){
        Boolean isDealApproved = false;
        String recordStatus = recordObj.objStatus;
        
        if('Partner Leads'.equalsIgnoreCase(recordObj.objRecordTypeName)){
            isDealApproved = false;
        } else if('2. Contacted'.equalsIgnoreCase(recordStatus)){
            isDealApproved = false;
        } else if('0. Downgraded'.equalsIgnoreCase(recordStatus) || 'X. Suspect'.equalsIgnoreCase(recordStatus) 
                            || 'X. Open'.equalsIgnoreCase(recordStatus) || '1. New'.equalsIgnoreCase(recordStatus) 
                            || '1.5 Call Out'.equalsIgnoreCase(recordStatus)){
            isDealApproved = true;
        }
        
        return isDealApproved;
    }
    
    public static Boolean protectionEvaluationCriteriaContact(RecordsWrappper recordObj){
        Boolean isDealApproved = false;
        
        if('VAR Visible'.equalsIgnoreCase(recordObj.objRecordTypeName)){
            isDealApproved = false;
        }else if('Paid'.equalsIgnoreCase(recordObj.objAccountStatus)){
            isDealApproved = false;
        }else{
            List<OpportunityContactRole> lstOppRole = contactOppCount.get(recordObj.objId);
            system.debug('lstOppRole = ' + lstOppRole);
            if(lstOppRole != null && lstOppRole.size() > 0){
                String stage_Name = lstOppRole.get(0).Opportunity.StageName;
                if('0. Downgraded'.equalsIgnoreCase(stage_Name)){
                    isDealApproved = true;
                } else if(OpportunityHelper.isActiveOpp(stage_Name) || OpportunityHelper.isClosedOpp(stage_Name)){
                    isDealApproved = false;
                }
            }else{
                isDealApproved = true;
            }
        }
        
        return isDealApproved;
    }
    
    public static Integer generatePartnerDealId(){
        Integer newParnterDealId = 0;
        List<Lead> listLead = [SELECT PartnerDeal_Registration_ID__c FROM Lead WHERE PartnerDeal_Registration_ID__c != NULL  Order By PartnerDeal_Registration_ID__c DESC LIMIT 1];
        List<Contact> listContact = [SELECT PartnerDeal_Registration_ID__c FROM Contact WHERE PartnerDeal_Registration_ID__c != NULL  Order By PartnerDeal_Registration_ID__c DESC LIMIT 1];
        Integer leadMaxPartnerDealId = listLead != null && listLead.size() > 0 && listLead.get(0).PartnerDeal_Registration_ID__c != null && listLead.get(0).PartnerDeal_Registration_ID__c != 0.0 ? Integer.valueOf(listLead.get(0).PartnerDeal_Registration_ID__c) : 0;
        Integer contactMaxPartnerDealId = listContact != null && listContact.size() > 0 && listContact.get(0).PartnerDeal_Registration_ID__c != null && listContact.get(0).PartnerDeal_Registration_ID__c != 0.0 ? Integer.valueOf(listContact.get(0).PartnerDeal_Registration_ID__c) : 0;
        if(contactMaxPartnerDealId > leadMaxPartnerDealId){
            newParnterDealId = contactMaxPartnerDealId + 1;
        } else{
            newParnterDealId = leadMaxPartnerDealId + 1;
        }
        return newParnterDealId;
    }
    
    public static void assingResponse(String Status, String ErrorCode, String ApprovalStatus, String PartnerDealID, String ValidUntilDate){
        responseMap.put('Status', Status);
        responseMap.put('ErrorCode', ErrorCode);
        responseMap.put('ApprovalStatus', ApprovalStatus);
        responseMap.put('PartnerDealID', PartnerDealID);
        responseMap.put('ValidUntilDate', ValidUntilDate);
    }
    
    public static Boolean isValidEmail(String InputString) {
        if(InputString != null && InputString != '') {
            String emailRegex = '([a-zA-Z0-9_\\-\\.]+)@((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})';
            Pattern MyPattern = Pattern.compile(emailRegex);
            Matcher MyMatcher = MyPattern.matcher(InputString);
            if (!MyMatcher.matches()) {
                return false;
            }
        }
        return true;
    }
    
    public class RecordsWrappper implements Comparable{
        String objId;
        String objType;
        Integer objPartnerDealId;
        String objStatus;
        String objDealStatus;
        String objRecordTypeName;
        String objAccountStatus;
        String objAccountId;
        Date objDealRegistrationExpDate;
        
        
        public RecordsWrappper(){}
        
        public RecordsWrappper(String objId, String objType, Integer objPartnerDealId, String objDealStatus, String objStatus, 
                                                            String objRecordTypeName, String objAccountStatus, String objAccountId, Date objDealRegistrationExpDate){
            this.objId = objId;
            this.objType = objType;
            this.objPartnerDealId = objPartnerDealId;
            this.objDealStatus = objDealStatus;
            this.objRecordTypeName = objRecordTypeName;
            this.objStatus = objStatus;
            this.objAccountStatus = objAccountStatus;
            this.objAccountId = objAccountId;
            this.objDealRegistrationExpDate = objDealRegistrationExpDate;
        }
        
        public Integer compareTo(Object compareTo) {
            RecordsWrappper comp = (RecordsWrappper) compareTo;
            Date objDealRegistrationExpDate = comp.objDealRegistrationExpDate;
            if(this.objDealRegistrationExpDate > objDealRegistrationExpDate || this.objDealRegistrationExpDate == null || objDealRegistrationExpDate == null){
                return -1;
            }else{
                return 1;
            }
        }
    }
}