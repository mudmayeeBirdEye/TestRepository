/*************************************************
LeadCreationPartnerVAR class 
/************************************************/

public class LeadCreationPartnerVAR  {
 
    public Lead newLead {get;set;}
    public String rcUsers{get;set;}
    string userLouisMastrangelo;
    public LeadCreationPartnerVAR(ApexPages.StandardController controller) {
        boolToShowMainSection = true;
        newLead = new Lead();
        newLead.Country__c = 'United States';
        newLead.Partner_Lead_Source__c = 'Partner';
        rcUsers = null;
        Default_Partner_Owner__c dfltPartOwner = Default_Partner_Owner__c.getOrgDefaults();
        if(dfltPartOwner != null ) {
        	userLouisMastrangelo = dfltPartOwner.UserId__c;
        }
     }
    
    public string selectedPartnerOwnerId {get;set;}
    public void fillPartnerID() {
        try {
            if(!string.isblank(selectedPartnerOwnerId)) {
                newLead.Partner_Lead_Owner__c = selectedPartnerOwnerId;
                newLead.LeadPartnerID__c = [select Contact.Account.Partner_Id__c from User where Id = 
                                            :selectedPartnerOwnerId limit 1].Contact.Account.Partner_Id__c;
            } else {
                newLead.LeadPartnerID__c = '';
                newLead.Partner_Lead_Owner__c = '';
            }
        } catch(Exception ex) {} 
    }
   
    /*This method is used to do email validation.*/
    public Boolean isValidEmail(String InputString) {
        if(InputString != null && InputString != '') {
            String emailRegex = '([a-zA-Z0-9_\\-\\.]+)@((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})';
            Pattern MyPattern = Pattern.compile(emailRegex);
            
            // Then instantiate a new Matcher object "MyMatcher"
            Matcher MyMatcher = MyPattern.matcher(InputString);
            
            if (!MyMatcher.matches()) {
                return false;
            }
        }
        return true;
    }
    
    public void resetErrorVariables() {
        
    }
    
    public String numOfEmployees{get;set;}
    public void resetFieldValue() {
        
    }
    
    public string checkInputFieldLength() {
        return 'NoError';
    }
    
    /*
    Called on by search button on page.
    Checks field validations, passing errors if any fail.
    Formats different examples of phone field in case of old formating errors
    Uses any combination of the following fields that are available: LastName, Company, Email, Phone
    For each Opp found calls addOpp to determine which table on page to show in (protected or not)
    */
    public Boolean isEmpty(String value) {
        return (value == null || value.trim() == '' ? true : false);
    }
    
    public Boolean isEmpty(Date dtvalue) {
        return (dtvalue == null || String.valueof(dtvalue).trim() == '' ? true : false);
    }
    
    public Boolean isFakeEmail(String email) {
        return (!isEmpty(email) && email.trim() ==  'fake@email.com');
    }
    
    
    
    public Set<Id> getCurrentUser(Id ownerId) {
        Set<Id> oppOwnerIds = new Set<Id>();
        if(ownerId != null) {
            if((String.valueOf(ownerId)).startsWith('005')) {
                oppOwnerIds.add(ownerId);
            } 
        } 
        return oppOwnerIds;
    }
   
    public string strSelectedBrand {get;set;}
    public List<SelectOption> getRCPartnerBrandItems() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('--None--','--None--')); 
        options.add(new SelectOption('RingCentral','RingCentral'));
        options.add(new SelectOption('RingCentral Canada','RingCentral Canada'));  
        options.add(new SelectOption('RingCentral UK','RingCentral UK')); 
        return options; 
    }
    
    public string strSelectedTier {get;set;}
    public List<SelectOption> getRCPartnerBrandTierItems() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('--None--','--None--')); 
        options.add(new SelectOption('Fax','Fax'));
        options.add(new SelectOption('Pro','Pro'));  
        options.add(new SelectOption('Office','Office')); 
        return options; 
    }
    
   
    /*
    Make sure that latest information has been searched with and that all fields are valid.
    Insert newLead and return page reference to it
    */
    string rtnString;
    public boolean boolToShowMainSection {get;set;}
    public PageReference createNew(){
        /*ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.severity.ERROR,
                selectedPartnerOwnerId);
        ApexPages.addMessage(myMsg1);
        return null;*/
        newLead.Lead_Brand_Name__c = strSelectedBrand;
        newLead.Lead_Tier_Name__c = strSelectedTier;
        system.debug('>>newLead.Lead_Brand_Name__c>>'+newLead.Lead_Brand_Name__c);
        system.debug('>>newLead.Lead_Tier_Name__c>>'+newLead.Lead_Tier_Name__c);
        resetErrorVariables();
        resetFieldValue();
        Boolean errorFound = false;
        String errorMessage = 'Please provide the required information.';
        
        if(isEmpty(newLead.FirstName)) {
            errorFound = true;
        }
        if(isEmpty(newLead.LastName)) {
            errorFound = true;
        }
        if(isEmpty(newLead.Company)) {
            errorFound = true;
        }
        if(isEmpty(newLead.Email)) {
            errorFound = true;
        }
        if(isEmpty(newLead.Phone)) {
            errorFound = true;
        }
        if(isEmpty(rcUsers)) { 
            errorFound = true;
        }
        if(!isEmpty(rcUsers) && !rcUsers.isNumeric()) {
            errorFound = true;
            errorMessage = 'Number of RC Users is invalid number.';
        }
        if(isEmpty(newLead.NumberOfEmployees__c)) {
            errorFound = true;
        }
        if(isEmpty(newLead.Number_of_Locations__c)) {
            errorFound = true;
        }
        if(isEmpty(newLead.Industry)) {
            errorFound = true;
        }
        if(isEmpty(newLead.Description)) {
            errorFound = true;
        }
        if(isEmpty(newLead.Lead_Tier_Name__c) || newLead.Lead_Tier_Name__c == '--None--') {
            errorFound = true;
        }
        if(isEmpty(newLead.Lead_Brand_Name__c) || newLead.Lead_Brand_Name__c == '--None--') {
            errorFound = true;
        }
        if(isEmpty(newLead.Country__c)) {
            errorFound = true;
        }
        if(isEmpty(newLead.State__c)) {
            errorFound = true;
        }
        if(isEmpty(newLead.City__c)) {
            errorFound = true;
        }
        if(isEmpty(newLead.How_did_you_acquire_this_Lead__c)) {
            errorFound = true;
        }
        if(isEmpty(newLead.Estimated_Close_Date__c)) {
            errorFound = true;
        }
        if(isEmpty(newLead.LeadPartnerID__c)) {
             errorFound = true;
        }
        if(isEmpty(newLead.Partner_Lead_Owner__c)) {
             errorFound = true;
        }
        if(errorFound) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.ERROR,
                errorMessage);
            ApexPages.addMessage(myMsg);
            return null;
        }
        system.debug('-------------------------------------->'+newLead.Email);//remove it
        if(!isValidEmail(newLead.Email.trim())) {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.ERROR,
                'The email entered is not in a valid format.'); 
                ApexPages.addMessage(myMsg );
                return null;
        }
        
        /*if(!isEmpty(newLead.Phone)
            && newLead.Phone.trim().length() != 10 
            && newLead.Phone.trim().length() != 12) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.ERROR,
            'The phone number should be entered as just 10 digits or 12 for UK numbers. i.e. 6504724066 or 441138680059.'); 
            ApexPages.addMessage(myMsg);
            return null;
        }*/
        
        User userObjPartner = [Select id,Contact.AccountId,Contact.Account.Partner_id__c,Contact.Account.Signup_Link__c 
                                ,Contact.Account.Name, Contact.Account.Inside_Sales_Rep__c, Contact.Account.Current_Owner__c
                                ,Contact.Account.Ultimate_Parent_Account_ID__c,Contact.Account.Current_Owner_Name__c,
                                Profile.Name, UserRole.PortalRole,contactId 
                                 FROM User where Id = :selectedPartnerOwnerId];
        if(userObjPartner.Contact.Account.Partner_Id__c != newLead.LeadPartnerID__c) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.ERROR,
            'Partner Id not matches with the selected Partner Owner.'); 
            ApexPages.addMessage(myMsg );
            return null; 
        }
        
        system.Debug('>>1>>'+ userObjPartner.Id);
        system.Debug('>>2>>' + userObjPartner.Profile.Name);
        system.Debug('>>3>>' + userObjPartner.UserRole.PortalRole);
        
        if(userObjPartner.Profile.Name.equalsIgnoreCase('RC Partner Express')) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.ERROR,
            'You must login to PRM as a Partner Express Contact to create a Partner Express Lead.'); 
            ApexPages.addMessage(myMsg );
            return null; 
        } 
        
        if(userObjPartner.UserRole.PortalRole.equalsIgnoreCase('Executive')) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.ERROR,
            'Executive Partner Contacts cannot Own Leads.  Please select a non-Executive Contact.'); 
            ApexPages.addMessage(myMsg );
            return null; 
        }                       
        
        system.debug('about to create lead');
        newLead.leadSource = 'Partner';
        newLead.Number_of_Users__c = Double.valueOf(rcUsers);
        newLead.Lead_Score__c = 'A';
        newLead.Status = '1. New';
        newLead.RecordTypeId = OpportunityHelper.getOppRecordTypeMap('Partner Leads');
        newLead.OwnerId = UserInfo.getUserId();
        newlead.Partner_Lead_Owner__c = selectedPartnerOwnerId;
        
        if(userObjPartner.Contact.AccountId == userObjPartner.Contact.Account.Ultimate_Parent_Account_ID__c){
            newLead.Ultimate_Parent_Account_ID__c = userObjPartner.Contact.AccountId;
            newLead.Ultimate_Parent_Account_Name__c = userObjPartner.Contact.Account.Name;
            newLead.Ultimate_Parent_Account_Partner_ID__c = userObjPartner.Contact.Account.Partner_id__c;
         } else {
            Account objParentAccount= [Select id,Partner_id__c,Name from Account where 
                                        id=:userObjPartner.Contact.Account.Ultimate_Parent_Account_ID__c];
            newLead.Ultimate_Parent_Account_ID__c = objParentAccount.Id;
            newLead.Ultimate_Parent_Account_Name__c = objParentAccount.Name;
            newLead.Ultimate_Parent_Account_Partner_ID__c = objParentAccount.Partner_id__c;
        }
        
        newLead.Current_Owner_Name__c = userObjPartner.Contact.Account.Current_Owner_Name__c; 
        if(userObjPartner != null) {
            if(userObjPartner.Contact.Account.Partner_id__c != null) {
                newLead.Partner_Account_Name__c = userObjPartner.Contact.Account.Name;
            }
            try {   
                /*if(userObjPartner.Contact.Account.Inside_Sales_Rep__c != null) {
                    newLead.OwnerId = userObjPartner.Contact.Account.Inside_Sales_Rep__c;
                } else if(userObjPartner.Contact.Account.Current_Owner__c != null) {
                    newLead.OwnerId = userObjPartner.Contact.Account.Current_Owner__c;
                } else {
                    Group groupObj = getPartnerQueue();
                    if(groupObj !=null) {
                        newLead.OwnerId = groupObj.Id;
                    }
                }*/
                if(userObjPartner.Contact.Account.Current_Owner__c != null) {
            		newLead.OwnerId = userObjPartner.Contact.Account.Current_Owner__c;
                } else {
                	newLead.OwnerId = userLouisMastrangelo;
                }
                if(userObjPartner.Contact.Account.Inside_Sales_Rep__c != null) {
            		newLead.Inside_Sales_Rep__c = userObjPartner.Contact.Account.Inside_Sales_Rep__c;
                }
            } catch(Exception e){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Exception Found= '+e.getMessage() + ', ' + e.getLineNumber());
                ApexPages.addMessage(myMsg);
                return null;
            }
        }
        
        /******************* Case Creation *******************************/
        rtnString = checkLeadEmailAlreadyExists();
        if(rtnString == 'Contact Found' || rtnString == 'Lead Found') {
            createCaseForPartnerLead(userObjPartner);
            /*ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.Info,
                                       'This Lead is in conflict with RingCentral’s existing Business. Lead is submitted for review'); 
            ApexPages.addMessage(myMsg);
            boolToShowMainSection = false;*/
            PageReference pgRef = new PageReference('/apex/PartnerMessagePageVAR');
            pgRef.setRedirect(true);
            return pgRef;
            //return Page.PartnerMessagePageVAR;
            //return null;
        }
        /*****************************************************************/
        
        try {        
            insert newLead;
            ShareUtil.shareLeadToPartner(newLead.id,newLead.Partner_Lead_Owner__c);     
        } catch(Exception e){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, e.getMessage());
            ApexPages.addMessage(myMsg );
            return null;
        }
        if(newLead.Id == null) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'The lead could not be created due to error occured!');
            //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, ex);
            ApexPages.addMessage(myMsg );
            return ApexPages.currentPage();
        }   
        //PageReference leadPage = new PageReference('/00Q/e?');
        PageReference leadPage = new ApexPages.StandardController(newLead).view();
        leadPage.setRedirect(true);
        return leadPage;
    }
    
    private Group getPartnerQueue() {
        return [SELECT id,Name FROM Group WHERE Type='Queue' AND Name='Partner Lead Reviewer' LIMIT 1];
    }
    
    Contact objContact;
    public string checkLeadEmailAlreadyExists() {
        List<Lead> leadList = [select Id from Lead where email =:newLead.Email.trim() limit 1];
        if(leadList != null && leadList.size()>0) {
            return 'Lead Found';
        } else {
            List<Contact> contactList = [select Id,accountId from Contact where email = :newLead.Email.trim() limit 1];
            if(contactList != null && contactList.size()>0) {
                objContact = contactList.get(0);
                return 'Contact Found';
            }
        }
        return 'notfound';
    }
    
    public void createCaseForPartnerLead(User userObjPartner) { 
       try {
            RecordType  objRecordType = [SELECT id, Name FROM RecordType where SobjectType = 'Case' and Name = 'Partner Lead' limit 1];
            Group gp = [Select id, name from group where Type ='Queue' and Name = 'Partner Lead Reviewer'];
            List<Case> lstCase = [Select id from Case where RecordTypeId =:objRecordType.id and Partner_Lead_Email__c = :newLead.Email.trim() 
                                    and IsClosed = false];
           // system.debug('@@@@@@@@@@@ 111111111');
                        system.debug('33333333333'+lstCase);
                       system.debug('66666666666666'+objRecordType.id);
                        
            if(lstCase.size() == 0) {
                system.debug('@@@@@@@@@@@ 222222222222');
                Case objCase = new Case();
                objCase.Partner_Lead_FirstName__c = newLead.FirstName;
                objCase.Partner_Lead_LastName__c = newLead.LastName;
                objCase.Partner_Lead_Title__c = newLead.Title;
                objCase.Partner_Lead_Company__c = newLead.Company;
                objCase.Partner_Lead_Email__c = newLead.Email;
                objCase.Partner_Lead_Phone__c = newLead.Phone;
                System.debug('>>newLead.leadSource>>>'+ newLead.leadSource);
                objCase.Number_of_Users__c = Double.valueOf(rcUsers);
                System.debug('>>objCase.Number_of_Users__c>>>'+ objCase.Number_of_Users__c);
                objCase.OwnerId = gp.id;
                /*if(userObjPartner.Contact.Account.Current_Owner__c != null) {
        			objCase.OwnerId = userObjPartner.Contact.Account.Current_Owner__c;
            	} else {
            		objCase.OwnerId = userLouisMastrangelo;
            	}*/
            	if(userObjPartner.Contact.Account.Inside_Sales_Rep__c != null) {
            		objCase.Inside_Sales_Rep__c = userObjPartner.Contact.Account.Inside_Sales_Rep__c;
            	}
                if(rtnString == 'Contact Found' && objContact !=null){
                    objCase.ContactId = objContact.id;
                    objCase.accountId = objContact.AccountId;
                } else if(rtnstring == 'Lead Found'){
	            	objCase.ContactId = userObjPartner.ContactId;
	                objCase.accountId = userObjPartner.Contact.AccountId;
            	}
                objCase.RecordTypeId = objRecordType.id;
                objCase.Lead_Partner_ID__c = newlead.LeadPartnerID__c;
                objCase.Partner_Lead_Owner__c = selectedPartnerOwnerId;
                objCase.Partner_Lead_Website__c = newLead.Website;
                objCase.NumberOfEmployees__c = newLead.NumberOfEmployees__c;
                objCase.Number_of_Locations__c = newLead.Number_of_Locations__c;
                objCase.Partner_Industry__c = newLead.industry;
                objCase.Description = userObjPartner.Contact.Account.Name +' submitted a Lead which was found to already exist in SFDC.' + 
                                        'Please verify if this is a valid Lead or not.';
                objCase.Partner_Lead_Description__c = newLead.Description;
                objCase.Partner_Brand__c = newLead.Lead_Brand_Name__c;
                objCase.Partner_Tier__c = newLead.Lead_Tier_Name__c;
                objCase.Partner_Country__c = newLead.Country__c;
                objCase.Partner_State_Province__c = newLead.State__c;
                objCase.Partner_City__c = newLead.City__c;
                objCase.Partner_Lead_Source_Custom__c = newLead.Partner_Lead_Source__c;
                objCase.Partner_Estimated_Close_Date__c = newLead.Estimated_Close_Date__c;
                objCase.Partner_How_did_you_acquire_this_Lead__c = newLead.How_did_you_acquire_this_Lead__c;
                objCase.Subject = 'Duplicate Lead '+ newLead.Company +' from Partner '+ userObjPartner.Contact.Account.Name;
                objCase.Partner_Lead_Phone_Alternate__c = newLead.Phone_Alternate__c;
                insert objCase; 
            }
        } catch(Exception ex) {}
    }
        
    public PageReference cancel(){
        string strRtnUrl = ApexPages.currentPage().getParameters().get('rtnURL');
        PageReference leadRtnPage;
        if(strRtnUrl != null && strRtnUrl != '') {
            leadRtnPage = new PageReference(strRtnUrl);
        } else {
            leadRtnPage = new PageReference('/00Q/o');
        }
        leadRtnPage.setRedirect(true);
        return leadRtnPage;
    }
}