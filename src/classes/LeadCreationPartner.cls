public class LeadCreationPartner {
    public Lead newLead{get;set;}
    public String rcUsers{get;set;}
    public string userLouisMastrangelo;
    public LeadCreationPartner(ApexPages.StandardController controller) {
        newLead = new Lead();
        newLead.Country__c = 'UNITED STATES';
        rcUsers = null;
        Default_Partner_Owner__c dfltPartOwner = Default_Partner_Owner__c.getOrgDefaults();
        if(dfltPartOwner != null ) {
        	userLouisMastrangelo = dfltPartOwner.UserId__c;
        }
    }
    public LeadCreationPartner() {}
    public PageReference createNew() {
        try {
            //resetFieldValue();
            /*
            if(isEmpty(newLead.Email)
                || isEmpty(newLead.Company)
                || isEmpty(newLead.LastName)
                || isEmpty(newLead.LeadSource)) {
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.ERROR,
                    'Please fill in Last Name, Company Name, Email and Lead Source to create a new lead.'); 
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,
                    'Other Message.'));
                    ApexPages.addMessage(myMsg);
                    return ApexPages.currentPage();
            }
            */
            Boolean errorFound = false;
            String errorMessage = 'Please provide the required information.';
            // 'Please provide the required information'
            if(isEmpty(newLead.FirstName)) {
                errorFound = true;
            	/*
            	ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.ERROR,
                    'Last Name is required.');
                ApexPages.addMessage(myMsg);
                */
            }
            if(isEmpty(newLead.LastName)) {
                errorFound = true;
            	/*
            	ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.ERROR,
                    'Last Name is required.');
                ApexPages.addMessage(myMsg);
                */
            }
            if(isEmpty(newLead.Company)) {
                errorFound = true;
                /*
            	ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.ERROR,
                    'Company name is required.');
                ApexPages.addMessage(myMsg);
                */
            }
            if(isEmpty(newLead.Email)) {
                errorFound = true;
            	/*
            	ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.ERROR,
                    'Email is required.');
                ApexPages.addMessage(myMsg);
                */
            }
            if(isEmpty(newLead.Phone)) {
                errorFound = true;
                /*
            	ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.ERROR,
                    'Phone is missing or invalid.');
                ApexPages.addMessage(myMsg);
                */
            }
           /* if(isEmpty(newLead.LeadSource)) {
                errorFound = true;
                
            	ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.ERROR,
                    'Leadsource is required.');
                ApexPages.addMessage(myMsg);
                
            }*/
           	if(isEmpty(rcUsers)) { 
                errorFound = true;
                /*
            	ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.ERROR,
                    'Number of RC Users is required.');
                ApexPages.addMessage(myMsg);
                */
	        }
	        if(!isEmpty(rcUsers) && !rcUsers.isNumeric()) {
                errorFound = true;
                errorMessage = 'Number of RC Users is invalid number.';
                /*
	        	ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.ERROR,
                    'Number of RC Users is invalid number.');
                ApexPages.addMessage(myMsg);
                */
	        }
            if(isEmpty(newLead.NumberOfEmployees__c)) {
            	errorFound = true;
            	/*
            	ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.ERROR,
                    'Number of Employees value is required.');
            	ApexPages.addMessage(myMsg);
            	*/
            }
            if(isEmpty(newLead.Number_of_Locations__c)) {
            	errorFound = true;
            	/*
            	ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.ERROR,
                    'Number of Locations value is required.');
            	ApexPages.addMessage(myMsg);
            	*/
            }
            if(isEmpty(newLead.Industry)) {
            	errorFound = true;
            	/*
            	ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.ERROR,
                    'Industry is required.');
            	ApexPages.addMessage(myMsg);
            	*/
            }
            if(isEmpty(newLead.Description)) {
            	errorFound = true;
            	/*
            	ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.ERROR,
                    'Description is required.');
            	ApexPages.addMessage(myMsg);
            	*/
            }
            if(isEmpty(newLead.Lead_Tier_Name__c)) {
            	errorFound = true;
            }
            if(isEmpty(newLead.Lead_Brand_Name__c)) {
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
            /*if(isEmpty(newLead.Partner_Lead_Source__c)) {
                errorFound = true;
            }*/
            if(isEmpty(newLead.Estimated_Close_Date__c)) {
                errorFound = true;
            }
            if(errorFound) {
            	ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.ERROR,
                    errorMessage);
            	ApexPages.addMessage(myMsg);
            	return ApexPages.currentPage();
            }
            system.debug('-------------------------------------->'+newLead.Email);//remove it
            if(!isValidEmail(newLead.Email.trim()) ){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.ERROR,
                    'The email entered is not in a valid format.'); 
                    ApexPages.addMessage(myMsg );
                    return ApexPages.currentPage();
            }
            if(!isEmpty(newLead.Phone)
                && newLead.Phone.trim().length() != 10 
                && newLead.Phone.trim().length() != 12) {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.ERROR,
                'The phone number should be entered as just 10 digits or 12 for UK numbers. i.e. 6504724066 or 441138680059.'); 
                ApexPages.addMessage(myMsg);
                return ApexPages.currentPage();
            }
        } catch(Exception e) {}
        newLead.leadSource = 'Partner';
        string rtnstring = checkLeadEmailAlreadyExists();
       
        User objUserDetail=[Select id,Contact.AccountId,Contact.Account.Partner_id__c,Contact.Account.Signup_Link__c ,
    						Contact.Account.Name, Contact.Account.Inside_Sales_Rep__c, Contact.Account.Current_Owner__c
                        	,Contact.Account.Ultimate_Parent_Account_ID__c,Contact.Account.Current_Owner_Name__c,contactId 
                        	FROM User where Id=:UserInfo.getUserId()];
        if(rtnstring == 'Contact Found' || rtnstring=='Lead Found') {
            createLeadApprovalRecord(rtnstring,objUserDetail);
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.Info,
                                       'This Lead is in conflict with RingCentral’s existing Business. You will be contacted by a Sales Agent soon.'); 
            ApexPages.addMessage(myMsg);
            return Page.PartnerMessagePage;
            //return null;
        }
        newLead.Number_of_Users__c = Double.valueOf(rcUsers);
        newLead.Lead_Score__c = 'A';
        newLead.Status = '1. New';
        newLead.RecordTypeId = OpportunityHelper.getOppRecordTypeMap('Partner Leads');
        
        if(objUserDetail.Contact.AccountId==objUserDetail.Contact.Account.Ultimate_Parent_Account_ID__c ){
        	newLead.Ultimate_Parent_Account_ID__c=objUserDetail.Contact.AccountId;
			newLead.Ultimate_Parent_Account_Name__c=objUserDetail.Contact.Account.Name;
			newLead.Ultimate_Parent_Account_Partner_ID__c=objUserDetail.Contact.Account.Partner_id__c;
         } else {
         	Account objParentAccount=[Select id,Partner_id__c,Name from Account where id=:objUserDetail.Contact.Account.Ultimate_Parent_Account_ID__c];
         	newLead.Ultimate_Parent_Account_ID__c=objParentAccount.Id;
			newLead.Ultimate_Parent_Account_Name__c=objParentAccount.Name;
			newLead.Ultimate_Parent_Account_Partner_ID__c=objParentAccount.Partner_id__c;
     	}
     	newLead.Current_Owner_Name__c = objUserDetail.Contact.Account.Current_Owner_Name__c; 
        try {        
            if(objUserDetail != null) {
                if(objUserDetail.Contact.Account.Partner_id__c != null) {
                    newLead.LeadPartnerID__c= objUserDetail.Contact.Account.Partner_id__c;
                    newLead.Partner_Account_Name__c = objUserDetail.Contact.Account.Name;
                }
                try {   
                    /*if(objUserDetail.Contact.Account.Inside_Sales_Rep__c != null) {
                        newLead.OwnerId = objUserDetail.Contact.Account.Inside_Sales_Rep__c;
                    } else if(objUserDetail.Contact.Account.Current_Owner__c != null) {
                        newLead.OwnerId = objUserDetail.Contact.Account.Current_Owner__c;
                    } else {
                        Group groupObj = getPartnerQueue();
                        if(groupObj !=null) {
                            newLead.OwnerId = groupObj.Id;
                        }
                    }*/
                    if(objUserDetail.Contact.Account.Current_Owner__c != null) {
                    	newLead.OwnerId = objUserDetail.Contact.Account.Current_Owner__c;
                    } else {
                    	newLead.OwnerId = userLouisMastrangelo;
                    }
                    if(objUserDetail.Contact.Account.Inside_Sales_Rep__c != null) {
                    	newLead.Inside_Sales_Rep__c = objUserDetail.Contact.Account.Inside_Sales_Rep__c;
                    }
                } catch(Exception e){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Exception Found= '+e.getMessage() + ', ' + e.getLineNumber());
                    ApexPages.addMessage(myMsg);
                    return null;
                }
            }
            newLead.Partner_Lead_Owner__c = UserInfo.getUserId();
            insert newLead;
           // shareLeadToPartner(newLead.id,UserInfo.getUserId());  
          ShareUtil.shareLeadToPartner(newLead.id,UserInfo.getUserId());     
        } catch(Exception e){
          ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Exception Found '+e.getMessage()+',  ' +e.getLineNumber());
          ApexPages.addMessage(myMsg);
          return null;
        }
        if(newLead.Id == null) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'The lead could not be created due to error occured!');
            //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, ex);
            ApexPages.addMessage(myMsg );
            return ApexPages.currentPage();
        }   
        PageReference leadPage = new ApexPages.StandardController(newLead).view();
        leadPage.setRedirect(true);
        return leadPage;
    }
    private Group getPartnerQueue() {
        return [SELECT id,Name FROM Group WHERE Type='Queue' AND Name='Partner Lead Reviewer' LIMIT 1];
    }
   // @future
  // String strData{get;set;}
  /*  public  void shareLeadToPartner(String leadId,String strUserId){
         
         List<LeadShare> liLeadShare=new List<LeadShare> ();
         LeadShare  objLeadShare=new LeadShare();
         objLeadShare.UserOrGroupId= UserInfo.getUserId();
         objLeadShare.LeadAccessLevel='Edit';
         objLeadShare.LeadId=leadId;
          liLeadShare.add(objLeadShare);
        
        User objUserDetail=[Select id,Contact.AccountId,Contact.Account.Partner_id__c from User where Id=:strUserId];
        String strUserAccountId=objUserDetail.Contact.AccountId;
        Set<String> setRoleId=new Set<String>();
        
        Set<String> setAccount=getParentAccountDetail(strUserAccountId);
        for(UserRole objUserRole:[SELECT PortalAccountId, Name,id FROM UserRole where PortalAccountId IN :setAccount]){
            setRoleId.add(objUserRole.id);
            //strData=strData+','+objUser.UserRoleId;
         }
        
        List<Group> liGroup=[Select id,RelatedId from Group where RelatedId IN :setRoleId];
       for(Group objGroup:liGroup){
               objLeadShare=new LeadShare();
             objLeadShare.UserOrGroupId= objGroup.id;
             objLeadShare.LeadAccessLevel='Edit';
             objLeadShare.LeadId=leadId;
             liLeadShare.add(objLeadShare);
        }
        insert liLeadShare;
     }
    
    public Set<String> getParentAccountDetail(String strAccountID){
        Set<String> setAccountId=new set<String>();
        setAccountId.add(strAccountID);
        
        try{
        Account objAccount=[Select id,Parent_Detail__c from account where id=:strAccountID];
         if(objAccount.Parent_Detail__c!=null && objAccount.Parent_Detail__c!=''){
                 String strParentDetail=objAccount.Parent_Detail__c;
                 List<String> lst=strParentDetail.split(','); 
                   for(String objString:lst){
                         if(objString!=null && objString!=''){
                            List<String> lst2=objString.split('-');
                                if(lst2.size()==2){
                                setAccountId.add(lst2.get(1));
                           }
                         }
                   }
            }
        
        }catch(Exception e){}
          
        return setAccountId;
    }
    
    */
    public void createLeadApprovalRecord(String rtnstring,User objUser) {
       // try {
            RecordType  objRecordType = [SELECT id,Name FROM RecordType where SobjectType='Case' and  Name='Partner Lead' limit 1];
            Group gp=[Select id,name from group where Type='Queue' and Name='Partner Lead Reviewer'];
            
            List<Case> lstCase=[Select id from Case where RecordTypeId=:objRecordType.id and Partner_Lead_Email__c=:newLead.Email.trim() and IsClosed=false];
       
        if(lstCase.size()==0){
            Case objCase=new Case();
            objCase.Partner_Lead_FirstName__c=newLead.FirstName;
            objCase.Partner_Lead_LastName__c=newLead.LastName;
            objCase.Partner_Lead_Title__c=newLead.Title;
            objCase.Partner_Lead_Company__c=newLead.Company;
            objCase.Partner_Lead_Email__c=newLead.Email.trim();
            objCase.Partner_Lead_Phone__c=newLead.Phone;
            objCase.Partner_Lead_Source__c=newLead.leadSource;
            objCase.Number_of_Users__c = newLead.Number_of_Users__c;
         	objCase.Number_of_Users__c = Double.valueOf(rcUsers);
            objCase.OwnerId = gp.id;
            /*if(objUser.Contact.Account.Current_Owner__c != null) {
        		objCase.OwnerId = objUser.Contact.Account.Current_Owner__c;
            } else {
            	objCase.OwnerId = userLouisMastrangelo;
            }*/
            if(objUser.Contact.Account.Inside_Sales_Rep__c != null) {
            	objCase.Inside_Sales_Rep__c = objUser.Contact.Account.Inside_Sales_Rep__c;
            }
            if(rtnstring == 'Contact Found' && objContact != null){
                objCase.ContactId = objContact.id;
                objCase.accountId = objContact.AccountId;
            } else if(rtnstring == 'Lead Found'){
            	objCase.ContactId = objUser.ContactId;
                objCase.accountId = objUser.Contact.AccountId;
            }
            objCase.RecordTypeId=objRecordType.id;
            objCase.Lead_Partner_ID__c= (objUser==null?null:objUser.Contact.Account.Partner_id__c);
            objCase.Partner_Lead_Owner__c=objUser.id;
            objCase.Partner_Lead_Website__c=newLead.Website;
            objCase.NumberOfEmployees__c=newLead.NumberOfEmployees__c;
            objCase.Number_of_Locations__c=newLead.Number_of_Locations__c;
            objCase.Partner_Industry__c=newLead.industry;
            objCase.Description=objUser.Contact.Account.Name+' submitted a Lead which was found to already exist in SFDC.  Please verify if this is a valid Lead or not.';
            objCase.Partner_Lead_Description__c=newLead.Description;
            objCase.Partner_Brand__c = newLead.Lead_Brand_Name__c;
            objCase.Partner_Tier__c = newLead.Lead_Tier_Name__c;
            objCase.Partner_Country__c = newLead.Country__c;
            objCase.Partner_State_Province__c = newLead.State__c;
            objCase.Partner_City__c = newLead.City__c;
            objCase.Partner_Lead_Source_Custom__c = newLead.Partner_Lead_Source__c;
            objCase.Partner_Estimated_Close_Date__c = newLead.Estimated_Close_Date__c;
            objCase.Partner_How_did_you_acquire_this_Lead__c = newLead.How_did_you_acquire_this_Lead__c;
            objCase.Subject='Duplicate Lead '+newLead.Company+' from Partner '+objUser.Contact.Account.Name;
            insert objCase; 
            
        }
             
        //} catch(Exception ex) {}
    }
    Contact objContact;
    public string checkLeadEmailAlreadyExists() {
        List<Lead> leadList = [select Id from Lead where email= :newLead.Email.trim() limit 1];
        if(leadList != null && leadList.size()>0) {
            return 'Lead Found';
        } else {
            List<Contact> contactList = [select Id,AccountId from Contact where email = :newLead.Email.trim() limit 1];
            if(contactList != null && contactList.size()>0) {
                 objContact=contactList.get(0);
                return 'Contact Found';
            }
        }
        return 'notfound';
    }
    
    public void resetFieldValue() {
        if(newLead.FirstName != null && newLead.FirstName =='First Name') {
            newLead.FirstName = '';
        }
        if(newLead.LastName != null && newLead.LastName =='Last Name') {
            newLead.LastName = '';
        }
        if(newLead.Title != null && newLead.Title == 'Business Title') {
            newLead.Title = '';
        }
        if(newLead.Company != null && newLead.Company =='Company Name') {
            newLead.Company = '';
        }
        if(newLead.Email != null && newLead.Email =='Email Address') {
            newLead.Email = '';
        }
        if(newLead.Website != null && newLead.Website =='Website') {
            newLead.Website = '';
        }
        if(newLead.Phone != null && !newLead.Phone.isNumeric()) {
            newLead.Phone = '';
        }
        if(rcUsers == 'Number of RC Users') {
        	rcUsers = '';
        }
    } 
    
    public Boolean isEmpty(String value) {
        return (value == null || value.trim() == '' ? true : false);
    }
    
    public Boolean isEmpty(Date dtvalue) {
        return (dtvalue == null || String.valueof(dtvalue).trim() == '' ? true : false);
    }
    
    public Boolean isFakeEmail(String email) {
        return (!isEmpty(email) && email.trim() ==  'fake@email.com');
    }
    public Boolean isValidEmail(String InputString) {
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
    /*public Lead getnewLead() {
        return newLead;
    }*/
    
    public PageReference cancelLead() {
        PageReference pg = new PageReference('/apex/PartnersLeadView?sfdc.tabName=01r80000000UJTG');
        pg.setRedirect(true);
        return pg;
    }
    
}