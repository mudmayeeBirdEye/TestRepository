public class solveSellLeadController {

    public Lead newLead {get; private set;}
    public String IncidentNumber {get; set;}
    String leadsell;  
    public List<cLead> leadList {get; set;}
    public String leadId;
    public String userID {get; set;}
   public String Status{get; set;}

    
    Boolean userIdNotFound = false;
    Boolean isLeadSaved = false;
    Boolean isPhoneFilled = true;
    Boolean isLastNameFilled = true; 
    Boolean isCompanyFilled = true;
    Boolean isFirstNameFilled = true;
    Boolean isEmailFilled = true;
    Boolean isAgentMailFilled = true;
    
    
    public solveSellLeadController(ApexPages.StandardController controller) {
        //Site.login('alok@simplion.com', 'verity10', 'https://tapp0.salesforce.com/secur/login_portal.jsp');
      userID = ApexPages.currentPage().getParameters().get('userid');     
      leadId = ApexPages.currentPage().getParameters().get('id');
      
      String startUrl = System.currentPageReference().getParameters().get('startURL');
      //Site.login(username, password, startUrl); 
      
       
       newLead = (leadId==null) ? new Lead() :
       [SELECT Id, FirstName, LastName, Name, Company, Email, Phone, LeadSource, Agent_Email_Address__c, Status, ConvertedOpportunity.StageName  FROM Lead WHERE Id= :leadId];
       //[SELECT id, FirstName,LastName, Name ,Company, Email,phone,LeadSource,Agent_Email_Address__c,Status FROM Lead WHERE Id= :leadId];
    
        searchLeads();
        if(leadId ==null) {
            try{
                Account A = [SELECT Id,RC_Brand__c,RC_Tier__c,RC_Service_name__c FROM Account WHERE RC_User_ID__c =: userID limit 1];   
                newLead.Account__c = A.Id;
                newLead.User_Id__c=userid;
                newLead.LeadSource = 'Solve then Sell';
                newLead.BMID__c = 'SOLVETHENSELL';
                
                //ALOK codetoworkON
                //newLead.OwnerId = '005800000036sJJ';
                //newLead.OwnerId = '005800000037Oaj';
                //User userAdmin = new User(id='005800000036sJJ');
               // System.runAs(userAdmin){
                        //User uTemp = [SELECT name, email from User WHERE profileid='00e80000000l1hK'];
               // }
               
               //User uTemp = [SELECT name, email from User WHERE profileid='00e80000000l1hK'];
               
               
               // newLead.LeadSource = Status;
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
    
    public PageReference save(){  
         PageReference p = Page.solveselllead;
         userIdNotFound = false;

      if(newlead.FirstName == null || newlead.FirstName == ''){
        isFirstNameFilled= false;
        return ApexPages.currentPage();
      }
      else { isFirstNameFilled= true; } 
                         
      if(newlead.LastName == null || newlead.LastName == ''){
        isLastNameFilled= false;
        return ApexPages.currentPage();
      }
      else { isLastNameFilled= true; } 
      
      
      if(newlead.Company== null || newlead.Company== ''){
        isCompanyFilled = false;
        return ApexPages.currentPage();
      }
      else { isCompanyFilled = true; } 
      
      if(newlead.Email == null || newlead.Email == ''){
        isEmailFilled= false;
        return ApexPages.currentPage();
      }
      else { isEmailFilled= true; } 
         
      if(newlead.Phone == null || newlead.Phone  == ''){
        isPhoneFilled = false;
        return ApexPages.currentPage();
      }
      else { isPhoneFilled = true; }   
      
      if(newlead.Agent_Email_Address__c == null || newlead.Agent_Email_Address__c  == ''){
        isAgentMailFilled = false;
        return ApexPages.currentPage();
      }
      else { isPhoneFilled = true; }   

         upsert newlead;
         searchLeads();   
         isLeadSaved = true;
         p.setRedirect(true);
         p.getParameters().put('userid', userID);
       return p;
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
}