public class CaseSolveSellOppController {

	public Opportunity newOpp {get; set;} 
	public OpportunityContactRole newOppContactRole {get; set;} 
	public Contact newContact {get;set;} 
	public List<oppDetailWrapper> oppList {get; set;}
	public String userId {get; set;}
    public String caseId;
    public Set<Id> ownerIds;   
    public Map<Id,User> userMap;
    public List<Case> caseList;	
    
    public string strFirstName{get;set;}
    public string strLastName{get;set;}
    public string strCompanyName{get;set;}
    public string strEmail{get;set;}
    public string strPhone{get;set;}
    public string strEmpRange{get;set;}
    public string strAgentEmail{get;set;}
    public Id accountCurrentOwner{get;set;}    
    
    //Standard Contoller Constructor of Opportunity. 
  	public CaseSolveSellOppController(ApexPages.StandardController controller) {
    	caseId=ApexPages.currentPage().getParameters().get('caseid');
    	userId = ApexPages.currentPage().getParameters().get('userid');
        newOppContactRole = new OpportunityContactRole();
        newContact = new Contact();
        newOpp = new Opportunity();
        ownerIds = new Set<Id>();
        ownerIds.add(UserInfo.getUserId());
        strAgentEmail = UserInfo.getUserEmail();
        
        searchOpportunities();  
        
        try{
            If(caseId != null && caseId !=''){                   
                resetOpportunityValues();
            }
         }catch(Exception ex){
            System.debug('==Exception=='+ex.getMessage()+'##'+ex.getLineNumber());
         }        
 	}
  
  	//Display Opportunities which are having same "RC User ID" which is coming form Case->Account-->RC User ID (From Url Parameter)
  	public void searchOpportunities(){
    	try{
          oppList = new List<oppDetailWrapper>(); 
          for(Opportunity opp : [SELECT Id, name,Agent_Email_Address__c,StageName,RC_User_ID__c,
          						(SELECT Contact.Email, Contact.FirstName, Contact.LastName, Contact.Phone FROM OpportunityContactRoles limit 1)
          						 FROM Opportunity WHERE  RC_User_ID__c =: userId ORDER BY lastModifiedDate DESC LIMIT 1000]){             
             if(opp.OpportunityContactRoles!=null && opp.OpportunityContactRoles.size() > 0){
             	List<OpportunityContactRole> oppContactRole = opp.OpportunityContactRoles;
             	oppList.add(new oppDetailWrapper(opp.Id,
             									 oppContactRole.get(0).Contact.FirstName,
             									 oppContactRole.get(0).Contact.LastName,
             									 opp.Name,
             									 oppContactRole.get(0).Contact.Email,
             									 oppContactRole.get(0).Contact.Phone,
             									 opp.Agent_Email_Address__c,
             									 opp.StageName)
             									 );
             }
		  }
    	}catch(Exception ex){
            System.debug('==Exception=='+ex.getMessage()+'##'+ex.getLineNumber());
        }
    }
    
    //Set Opportunity values before saving.
  	public void resetOpportunityValues(){
  		
  		caseList = new List<Case> ();
    	caseList = [SELECT Account.id,Account.Current_Owner__c, Account.Name, Account.RC_User_ID__c,Account.No_of_Employees__c,
					Contact.Id,Contact.Name,Contact.FirstName,Contact.LastName,Contact.Email,Contact.Phone,Contact.NumberOfEmployees__c
					FROM Case WHERE id=:caseId];
    	
        if(caseList!=null && caseList.size()>0){	
        	strCompanyName = caseList[0].Account.Name;  
            accountCurrentOwner = caseList[0].Account.Current_Owner__c;
            if(caseList[0].Contact.Id!=null){            	
        		strFirstName = caseList[0].Contact.firstName;
             	strLastName = caseList[0].Contact.lastName;
             	strEmail = caseList[0].Contact.email;
             	strPhone = caseList[0].Contact.phone;		             	             	
             	strEmpRange = (caseList[0].Contact.NumberOfEmployees__c!=null ? caseList[0].Contact.NumberOfEmployees__c : caseList[0].Account.No_of_Employees__c);
 				newOppContactRole.ContactId = caseList[0].Contact.Id;             	
            }
    	}
	}
    
    //Populate Contact Details on VF page.
    public void updateContact(){      
	    List<Contact> conList = [SELECT id, firstName, lastName, Account.RC_User_ID__c, Account.No_of_Employees__c, AccountId, Account.Name, email,
	    						 phone,NumberOfEmployees__c,Account.Current_Owner__c FROM Contact WHERE id =:newOppContactRole.ContactId];
	    if(conList!=null && conList.size() > 0){	      	
	      	strFirstName = conList[0].firstName;
	        strLastName = conList[0].lastName;
	        strEmail = conList[0].email;
	        strPhone = conList[0].phone;
	        strEmpRange = conList[0].NumberOfEmployees__c;
	        strCompanyName = conList[0].Account.Name;	        
	        if(strEmpRange==null || strEmpRange==''){
            	strEmpRange = conList[0].Account.No_of_Employees__c;	
            }
	        newOpp.AccountId = conList[0].AccountId;
	        newOpp.RC_User_ID__c = conList[0].Account.RC_User_ID__c;
	        accountCurrentOwner = conList[0].Account.Current_Owner__c;
	    }    
  	}
  
  	//Save opportunity after checking validations.
  	public PageReference saveOpportunity(){
   		Boolean isErrorExist=false;
   		
   		if(newOppContactRole.ContactId==null){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.error,'Please select contact.'));
            isErrorExist=true;
        }
                         
        if(string.isBlank(strLastName) || string.isBlank(strLastName.trim())){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.error,'Please provide last name'));
            isErrorExist=true;
        }      
      
        if(string.isBlank(strCompanyName) || string.isBlank(strCompanyName.trim())){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.error,'Please provide company name'));
            isErrorExist=true;
        }
            
        if(string.isBlank(strEmail) || string.isBlank(strEmail.trim()) || !validateEmail(strEmail.trim())){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.error,'Please provide valid e-mail address'));
            isErrorExist=true;        
        }
      
        if(string.isBlank(strPhone) || string.isBlank(strPhone.trim())){
           ApexPages.addMessage(new ApexPages.message(ApexPages.severity.error,'Please provide valid phone number'));
           isErrorExist=true;
        }
      
        if(string.isBlank(strAgentEmail) || string.isBlank(strAgentEmail.trim()) || !validateEmail(strAgentEmail.trim())){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.error,'Please provide valid agent e-mail address'));
            isErrorExist=true;
        }
       
        if(isErrorExist==true){
           return null;
        } 
          
    	try{
	      
	      newOpp.LeadSource = 'Solve Then Sell';
          newOpp.BMID__c = 'SOLVETHENSELL'; 
          newOpp.AID__c = '';
          newOpp.PID__c = '';
          newOpp.Five9_DNIS__c = '';     
          newOpp.CloseDate = getMonthEndDate();
          newOpp.StageName = '1. Qualify';          
          newOpp.RecordTypeId = OpportunityHelper.getOppRecordTypeMap('Sales Opportunity');
          
          if(newOpp.RC_User_ID__c==null){
          	newOpp.RC_User_ID__c = caseList[0].Account.RC_User_ID__c;
          }
          if(newOpp.AccountId==null){
          	newOpp.AccountId = caseList[0].Account.id;
          }   
          
	      newOpp.Name = strCompanyName;
	      newOpp.Agent_Email_Address__c = strAgentEmail;      
	      newOpp.Number_of_Employees__c = strEmpRange;
	      
	      if(newOpp.Sales_Agent_User__c!=null){
	      	  newOpp.OwnerId = newOpp.Sales_Agent_User__c;
	      }else if(accountCurrentOwner!=null){
	      	  newOpp.OwnerId = accountCurrentOwner;
	      }else{
		      List<Opportunity> newOppList = new List<Opportunity>();
		      newOppList.add(newOpp);
		      ownerIds.add(newOpp.OwnerId);
	      
		      userMap = new Map<Id, User>([SELECT Name, Profile.Name, IsTmtTriggersDisabled__c, Email, Manager.Email, Phone,Manager.Username, 
		                      IsActive, ManagerId, Mkto_Reply_Email__c FROM User WHERE Id IN: ownerIds]);
		                      
		      OpportunityLARHelper.IS_SOLVE_THEN_SELL_OPPORTUNITY = true; 
		      OpportunityLARHelper.assignCampaignToOpportunity(newOppList);
		      OpportunityLARHelper.initialOpportunities(newOppList, userMap);
		      OpportunityLARHelper.IS_SOLVE_THEN_SELL_OPPORTUNITY = false;
	      }
	      
	      List<Campaign> campList = [Select id from Campaign where BMID__c='SOLVETHENSELL' AND AID__c=NULL AND PID__c=NULL AND DNIS__c=NULL
	      							 AND IsActive=true];
      
	      TriggerHandler.BY_PASS_CONTACT_ON_UPDATE = true;
	      TriggerHandler.BY_PASS_CONTACT_ON_INSERT = true;
	      TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT = true;
	      TriggerHandler.BY_PASS_ACCOUNT_ON_UPDATE = true;	
	      //TriggerHandler.BY_PASS_OPPORTUNITY_ON_INSERT = true;
	      //TriggerHandler.BY_PASS_OPPORTUNITY_ON_UPDATE = true;    
      
	      if(Test.isRunningTest()) {
	        newOpp.OwnerId = UserInfo.getUserId();
	      }
	      
	      if(campList!=null && campList.size() > 0){
	      	newOpp.CampaignId = campList[0].Id;	      	
	      }
	      
	      system.debug('Before Opp Insert Limit ='+limits.getQueries());
	      
	      upsert newOpp;
	      
	      system.debug('After Opp Insert Limit ='+limits.getQueries());
      
	      TriggerHandler.BY_PASS_CONTACT_ON_UPDATE = false;
	      TriggerHandler.BY_PASS_CONTACT_ON_INSERT = false;
	      TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT = false;
	      TriggerHandler.BY_PASS_ACCOUNT_ON_UPDATE = false;	
	      TriggerHandler.UPDATE_CONTACT_BMID = false;  
	      //TriggerHandler.BY_PASS_OPPORTUNITY_ON_INSERT = false;
	      //TriggerHandler.BY_PASS_OPPORTUNITY_ON_UPDATE = false;    
	        
	      newOppContactRole.OpportunityId = newOpp.id;
	      newOppContactRole.IsPrimary=true;
	      
	      system.debug('Before OppContactRole Insert Limit ='+limits.getQueries());
	      
	      upsert newOppContactRole;	 
	      
	      system.debug('After OppContactRole Insert Limit ='+limits.getQueries());     
	      
	      if(campList!=null && campList.size() > 0){	      	
	      	List <CampaignMember> campMemberList = [Select id from CampaignMember where CampaignId=:campList[0].Id AND ContactId=:newOppContactRole.ContactId LIMIT 1];
		    if(campMemberList!=null && campMemberList.size() > 0){
		      	Contact conObj = new Contact(id=newOppContactRole.ContactId,BMID__c='SOLVETHENSELL',AID__c='',PID__c='',
	      								 Most_Recent_Campaign__c=campList[0].Id);
	      								 
  				system.debug('Before Contact Insert Limit ='+limits.getQueries());
  				upsert conObj;
  				system.debug('After Contact Insert Limit ='+limits.getQueries());
	      	}else{
	      		TriggerHandler.UPDATE_CONTACT_BMID = true;
		      		CampaignMember campaignMemberObj = new CampaignMember(CampaignId=campList[0].Id, ContactId=newOppContactRole.ContactId);
		      		system.debug('Before CampMember Insert Limit ='+limits.getQueries());
			      	insert campaignMemberObj;
			      	system.debug('After CampMember Insert Limit ='+limits.getQueries());
		      	TriggerHandler.UPDATE_CONTACT_BMID = false; 
	      	}	      		      	
	      }
	      
	      system.debug('Before Search Limit ='+limits.getQueries());
	      
	      searchOpportunities();
	      
	      system.debug('After Search Limit ='+limits.getQueries());
	      
	      ApexPages.addMessage(new ApexPages.message(ApexPages.severity.confirm,'Opportunity saved successfully')); 
	      
	      Id salesAgentId = newOpp.Sales_Agent_User__c;
	      Id contactId = newOppContactRole.ContactId;
	      newOppContactRole = new OpportunityContactRole(ContactId=contactId);      
	      newOpp = new Opportunity(Sales_Agent_User__c=salesAgentId);
	      
	    }catch(Exception ex){
	    	System.debug('==Exception=='+ex.getMessage()+'##'+ex.getLineNumber());
	    }
    	return null;
	}
  
  	//Provides last date of current month.
  	public Date getMonthEndDate(){
    	Date firstDayOfMonth = System.today().toStartOfMonth();
    	Date lastDayOfMonth = firstDayOfMonth.addDays(Date.daysInMonth(firstDayOfMonth.year(), firstDayOfMonth.month()) - 1);
    	return lastDayOfMonth;
  	}
  
  	//Validate Email address format.
  	public Boolean validateEmail(String email) {
    	Pattern myPattern = Pattern.compile('^[a-zA-Z][\\w\\.-]*[a-zA-Z0-9]@[a-zA-Z0-9][\\w\\.-]*[a-zA-Z0-9]\\.[a-zA-Z][a-zA-Z\\.]*[a-zA-Z]$');
      	Matcher matcher = myPattern.matcher(email.trim());
      	return matcher.find();
  	} 
  
  	//Wrapper calss for storing Opportunity details.
	public Class oppDetailWrapper{
	    public String Id {get; set;}	    
	    public String FirstName{get; set;}
	    public String LastName{get; set;}
	    public String Company{get; set;}
	    public String Email{get; set;}
	    public String Phone{get; set;} 
	    public String AgentEmailAddress{get; set;} 
	    public String StageName{get; set;}
	        
	    public oppDetailWrapper(String Id, String FirstName, String LastName, String Company, String Email, String Phone, String AgentEmailAddress,
	    						String StageName){
          	this.Id = Id; 
            this.FirstName= FirstName;
            this.LastName=LastName;
            this.Company= Company;
            this.Email= Email;
            this.Phone= Phone;
            this.AgentEmailAddress=AgentEmailAddress;
            this.StageName=StageName;
        }
    }
}