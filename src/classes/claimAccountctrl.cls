public with sharing class claimAccountctrl {
     String strConId = ApexPages.currentPage().getParameters().get('id');
     //String toRedirectURL = 'https://tapp0.salesforce.com/';
     //String toRedirectFinalURL = null;
     String strAccountID = null;
     String strNotAccountID=null;
     String getAcctID = null;
     String getNotAcctID = null;
     String userDet= null;
     Integer intLimit = 0;
     Integer iCount = 0;
    
     
    public claimAccountctrl(ApexPages.StandardController controller) {    
    }
     
     public PageReference actCreateLeadFromContact() {   
           List<User> userDet = [SELECT maxClaimLimit__c from User where Id =: UserInfo.getUserId()];
           for(User u : userDet ) {
               intLimit = u.maxClaimLimit__c.intValue();
           }
           system.debug('@@@1 intLimit ==> '+intLimit);
          //get the total number of Accounts currently assigned to logged in user
          try{
              iCount = [SELECT count() from Account where Current_Owner__c =: UserInfo.getUserId()];
              system.debug('@@@ --- iCount ---- '+iCount);
          }catch(Exception ex){}         
          //get the AccountID from Agent Credit
          List<Agent_Credit__c> agentCredit = [SELECT Account__c FROM Agent_Credit__c where id=:strConId];                    
          for(Agent_Credit__c c : agentCredit) {
              if (c.Account__c != null) {
                 strAccountID = c.Account__c;
                 //c.chkClaimLimitReached__c = true;
              }
          } 
          PageReference createLeadPage = new PageReference('/'+strAccountID);         
          if(iCount >= intLimit){ 
              createLeadPage.getParameters().put('maxlimit', '1');
          }else{ 
              //get the Account details as per Account ID above
              List<Account> acct = [SELECT Id from Account where Id =: strAccountID];
              for(Account a : acct){                    
                   a.Current_Owner__c = UserInfo.getUserId();
              }
              update acct;              
          }          
        // PageReference createLeadPage = new PageReference('/'+strAccountID);
          createLeadPage.setRedirect(true);
          return createLeadPage;
     }
     
    public String getAcctID(){
        return strAccountID;
    }
    public String getNotAcctID(){
        return strNotAccountID;
    }
    public String getAccountID(){
        return strAccountID;
    }
    public String getNotAccountID(){
        return getNotAcctID ;
    }
}