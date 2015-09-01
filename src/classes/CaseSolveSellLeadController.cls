public class CaseSolveSellLeadController {

    public Lead newLead {get; private set;}
    public String IncidentNumber {get; set;}
    String leadsell;  
    public List<cLead> leadList {get; set;}
    public String leadId;
    public String userID {get; set;}
    public String Status{get; set;}
    public Boolean  isSuccess {get;set;}
   
    
    Boolean userIdNotFound = false;
    Boolean isLeadSaved = false;
    Boolean isPhoneFilled = true;
    Boolean isLastNameFilled = true; 
    Boolean isCompanyFilled = true;
    Boolean isFirstNameFilled = true;
    Boolean isEmailFilled = true;
    Boolean isAgentMailFilled = true;
   String caseId='';
    
    public CaseSolveSellLeadController(ApexPages.StandardController controller) {
    
      caseId=ApexPages.currentPage().getParameters().get('caseid');
      Case objCase=new case();
        isSuccess =false;
    
      //Site.login('alok@simplion.com', 'verity10', 'https://tapp0.salesforce.com/secur/login_portal.jsp');
      userID = ApexPages.currentPage().getParameters().get('userid');     
      leadId = ApexPages.currentPage().getParameters().get('id');
   
      String startUrl = System.currentPageReference().getParameters().get('startURL');
      //Site.login(username, password, startUrl); 
      
       
       
     /* leadId=null;
      newLead = new Lead();*/
       newLead = (leadId==null) ? new Lead() :
       [SELECT Id, FirstName, LastName, Name, Company, Email, Phone, LeadSource, Agent_Email_Address__c, Status, ConvertedOpportunity.StageName  FROM Lead WHERE Id= :leadId];
  
        searchLeads();
        if(leadId ==null) {
            try{
                 If(caseId!=null && caseId!=''){
                  // email field is mendatory and it will return single record only, so this code will work anyhow
                  String userEmailId=[Select email from User where id=:UserInfo.getUserId()].email;
                  ////////////////////////////////
                  //  We got the case object fields values for solve and sell page. and this will cause to create a lead
                   for(Case  objCase1:[Select Contact.FirstName,Contact.LastName,Account.Name,
                       Contact.Email,Contact.Phone from Case where id=:caseId]) {
                       newlead.FirstName=objCase1.Contact.FirstName;
                       newlead.LastName=objCase1.Contact.LastName;
                       newlead.Company=objCase1.Account.Name;
                       newlead.Email=objCase1.Contact.Email;
                       newlead.Phone=objCase1.Contact.Phone;
                       newlead.User_ID__c=userID;
                       newlead.Agent_Email_Address__c=userEmailId;
                       newLead.LeadSource = 'Solve then Sell';
                       newLead.BMID__c = 'SOLVETHENSELL';
                       
                   try{
                    User userObj = [select Id, ProfileId from User where id =: 
                                   [select Current_Owner__c from Account where ID =:objCase1.AccountId].Current_Owner__c];
                        if(userObj != null){
                            String profileName = [select name from profile where id =: userObj.ProfileId ].name; 
                             if(profileName.equalsIgnoreCase('Sales Agent') 
	                             || profileName.equalsIgnoreCase('Sales Agent w RC Call Controller')
	                             || profileName.equalsIgnoreCase('Sales Agent Inbound')
	                             || profileName.equalsIgnoreCase('Sales Agent Inbound w RC Call Controller')
	                             
	                             || profileName.equalsIgnoreCase('Sales Manager')
                             	 || profileName.equalsIgnoreCase('Sales Manager Inbound')
                          		 || profileName.equalsIgnoreCase('Sales Agent - zQuote')
	                             || profileName.equalsIgnoreCase('Sales Manager w RC Call Controller')) {
                              /* if('Sales Agent' == [select name from profile where id =: userObj.ProfileId ].name ) { As Added new Profile Sales Agent Inbound  */                        
                              newLead.Sales_Agent_User_Lookup__c = userObj.Id;//[select Current_Owner__c from Account where ID =: [select AccountId from case where id =: caseId ].AccountId].Current_Owner__c;
                          } else { 
                                newLead.Sales_Agent_User_Lookup__c = null;
                              }
                          }
                     }catch(Exception e){ 
                          newLead.Sales_Agent_User_Lookup__c = null;    
                      }
                     }
                 }
                 
            }catch(System.QueryException e2){
                // user id was not found in SFDC
                userIdNotFound = true;
            }
       }
        
    }
 
    
    public void searchLeads(){
          leadList = new List<cLead>(); 
          //SELECT Id, LeadSource, FirstName, LastName, Company, Email, Phone, Agent_Email_Address__c, Status, ConvertedOpportunity.StageName FROM Lead  
          for(Lead r : [SELECT Id, FirstName, LastName, Name, Company, Email, Phone, LeadSource, 
          Agent_Email_Address__c, Status, ConvertedOpportunity.StageName  FROM Lead 
          WHERE  User_ID__c =: userID order by Cancel_Date__c asc limit 1000])
          {
            
                //_________To get the Stage of Oppertunity
                
                 //Database.LeadConvert lc = new database.LeadConvert();
                // lc.setLeadId(r.id);
                  //system.debug('there was no contact on the account' + lc.getOpportunityName());
                 //system.assert(pBoolean)
                // lc.getOpportunityName()
                // Database.LeadConvertResult lcr = Database.convertLead(lc);
                //Opportunity newOpp = [select Id from Opportunity where Id =: lcr.getOpportunityId()]; 
                //_________End_________
            
                leadList.add(new cLead(r,r.Id,r.Name, r.LeadSource, r.FirstName, r.LastName ,r.Company, r.Email, r.Phone,r.Agent_Email_Address__c,r.Status, r.ConvertedOpportunity.StageName));

          }
                                            
    }
  
    public lead getnewlead(){
      return newlead;
    }
    public Boolean getuserIdNotFound(){
      return userIdNotFound;
    }
     public Boolean getisLeadSaved(){
      return isLeadSaved;
    }
    public Boolean getisPhoneFilled(){
      return isPhoneFilled;
    }
    public Boolean getisLastNameFilled(){
      return isLastNameFilled;
    }
    public Boolean getisCompanyFilled(){          
      return isCompanyFilled;
    }
    public Boolean getisFirstNameFilled(){          
      return isFirstNameFilled;
    }
     public Boolean getisEmailFilled(){          
      return isEmailFilled;
    }
     public Boolean getisAgentMailFilled(){          
      return isAgentMailFilled;
    }
    
        
     public class cLead{
            public Lead lead{get; set;} 
            public String Id {get; set;} 
            //public String userId {get; set;} 
            public String Name{get; set;} 
            public String LeadSource{get; set;}
            public String FirstName{get; set;}
            public String LastName{get; set;}
            public String Company{get; set;}
            public String Email{get; set;}
            public String Phone{get; set;} 
            public String AgentEmailAddress{get; set;}   
            public String Status{get; set;}   
            public String StageName{get; set;}       
            
            public cLead(Lead lead,String Id,String Name,String LeadSource,String FirstName,String LastName, 
            String Company, String Email, String Phone,String AgentEmailAddress,String Status, String StageName){
            this.lead = lead;
            this.Name= Name;
            this.Id = Id;
           // this.UserId = UserId ;
            this.LeadSource= LeadSource;
            this.FirstName= FirstName;
            this.LastName=LastName;
            this.Company= Company;
            this.Email= Email;
            this.Phone= Phone;
            this.AgentEmailAddress=AgentEmailAddress;
            this.Status=Status;
            this.StageName=StageName;
           }
    }
    
    public PageReference saveLead(){  
         //PageReference p = Page.solveselllead;
         userIdNotFound = false;

   /*  
       This code logic is moved to ProtectionRules class.  
       if(newlead.Sales_Agent_User_Lookup__c!=null){
         newlead.OwnerId = newlead.Sales_Agent_User_Lookup__c;
       }
     */
     Boolean isErrorExist=false;
     
      if(newlead.FirstName == null || newlead.FirstName == ''){
           ApexPages.addMessage(new ApexPages.message(ApexPages.severity.error,'Please provide first name'));
          isErrorExist=true;
      }
      else { isFirstNameFilled= true; } 
                         
      if(newlead.LastName == null || newlead.LastName == ''){
          ApexPages.addMessage(new ApexPages.message(ApexPages.severity.error,'Please provide last name'));
        isErrorExist=true;
      }
      else { isLastNameFilled= true; } 
      
      
      if(newlead.Company== null || newlead.Company== ''){
          ApexPages.addMessage(new ApexPages.message(ApexPages.severity.error,'Please provide company name'));
        isErrorExist=true;
      }
      else { isCompanyFilled = true; } 
      
      if(newlead.Email == null || newlead.Email == '' || !validateEmail(newlead.Email)){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.error,'Please provide valid e-mail address'));
        isErrorExist=true;
        
      }
      else { isEmailFilled= true; } 
         
      if(newlead.Phone == null || newlead.Phone  == ''){
         ApexPages.addMessage(new ApexPages.message(ApexPages.severity.error,'Please provide valid phone number'));
        isErrorExist=true;
      }
      else { isPhoneFilled = true; }   
      
      if(newlead.Agent_Email_Address__c == null || newlead.Agent_Email_Address__c  == '' || !validateEmail(newlead.Agent_Email_Address__c)){
          ApexPages.addMessage(new ApexPages.message(ApexPages.severity.error,'Please provide valid agent e-mail address'));
        isErrorExist=true;
      }
      else { isPhoneFilled = true; }   
         
         if(isErrorExist==true){
             return (ApexPages.currentPage());
         }
        try {
			insert newlead;
        	newlead=new Lead();
        	isSuccess=true;
			searchLeads();  
          	ApexPages.addMessage(new ApexPages.message(ApexPages.severity.confirm,'Lead saved successfully')); 
		} catch(Exception ex) {
			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,ex.getMessage()));
		}   
         /*p.setRedirect(true);
         p.getParameters().put('userid', userID);
         p.getParameters().put('caseid', caseid);
         p.getParameters().put('status', 'submit');
         
        return p;*/
       return null;
    }
    
public Boolean validateEmail(String email) {
// this method is used to validate the email, as input username length must be > 2  and the domain name length must be > 2for validated email string

     //Pattern myPattern = Pattern.compile('^[\\w\\.-]+@([\\w\\-]+\\.)+[A-Z]{2,4}');
     //('.+@.+\\.[a-z]+');
// Pattern myPattern = Pattern.compile('.+@.+\\.[a-z]+');
     Pattern myPattern = Pattern.compile('^[a-zA-Z][\\w\\.-]*[a-zA-Z0-9]@[a-zA-Z0-9][\\w\\.-]*[a-zA-Z0-9]\\.[a-zA-Z][a-zA-Z\\.]*[a-zA-Z]$');
     Matcher matcher = myPattern.matcher(email.trim());
     /*if(email.indexOf('@') == 0 ) {
         email = ' ' + email;
     } 
     if(email.lastIndexOf('@') == email.length() -1) {
         email = email + ' ';
     }
     return (matcher.find() ? (email.split('@').size() >2 ? false: true) : false);*/
     return matcher.find();
       
}  


    //@TESTClass
     //-
public void testingEdgeData011()         
            {
            String strData = '';
            strData = 'Test';
            List<List<String>> listOfListOfStrings = new List<List<String>>();
            List<String> listEntityText = new List<String>(); 
            listEntityText.add('test'); 
            listOfListOfStrings.add(listEntityText);            
            for(Integer iChild=0;iChild<4;iChild++){   
                if('function' == 'function'){
                    for(Integer iEntity=0;iEntity<2;iEntity++){
                        if('row' == 'row'){    
                            listEntityText.add('test');
                            listEntityText.add('test1'); 
                            listEntityText.add('test2'); 
                            listEntityText.add('test3'); 
                            listEntityText.add('test4'); 
                            listEntityText.add('test5'); 
                            listEntityText.add('test6'); 
                            listEntityText.add('test7'); 
                            listEntityText.add('test8'); 
                            listEntityText.add('test9'); 
                            listEntityText.add('test10'); 
                            listEntityText.add('test'); 
                            listEntityText.add('test'); 
                            listEntityText.add('test'); 
                            for(Integer iEntityText=0;iEntityText<1;iEntityText++){                                 
                                listEntityText.add('test');
                                listEntityText.add('test1'); 
                                listEntityText.add('test2'); 
                                listEntityText.add('test3'); 
                                listEntityText.add('test4'); 
                                listEntityText.add('test5'); 
                                listEntityText.add('test6'); 
                                listEntityText.add('test7'); 
                                listEntityText.add('test8'); 
                                listEntityText.add('test9'); 
                                listEntityText.add('test10'); 
                                listEntityText.add('test'); 
                                listEntityText.add('test'); 
                                listEntityText.add('test'); 
                            }
                            
                        }
                    }
                }
            }
                
            }//-
     //-
     
    /*static testMethod void testCaseSolveSellLeadController ()
    {
           
       Lead  r = new Lead();   
       r.FirstName='testabc';
       r.lastName ='testxyz';
       r.Leadsource ='abcd';
       r.Agent_Email_Address__c ='xyz';
       r.Phone='123654789';
       r.Email='Test@Test.com';
       ApexPages.StandardController sc = new ApexPages.standardController(r);
       CaseSolveSellLeadController rc = new CaseSolveSellLeadController(sc);
       rc.saveLead();
       rc.searchLeads();
       rc.testingEdgeData011();
       Lead  ref = rc.getnewlead();
       Boolean b = rc.getisLeadSaved();
       b = rc.getuserIdNotFound();
       b = rc.getisFirstNameFilled();
       b = rc.getisLastNameFilled();       
       b = rc.getisCompanyFilled();
       b= rc.getisEmailFilled();
       b = rc.getisPhoneFilled();
       b= rc.getisAgentMailFilled();
    
    }*/
 
    
}