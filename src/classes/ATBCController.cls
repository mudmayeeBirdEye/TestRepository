/*
    Look for any lead in Lead Source=‘About To be Cancelled’ and ATBC Stage=New or WIP for the same RC UserID
    and check the renewal date on Account  -> if renewal date is in future
    Move the ATBC Stage to ‘Closed’
    Move Lead Status to ‘0. Downgraded’
    Move Downgrade Reason to ‘ATBC Lead Closed’ 
  */
  
public with sharing class ATBCController{
  public ATBCController(){} 
  public ATBCController(ApexPages.StandardController ctr){}
  
  public PageReference save() {  
  	
  	Integer intCount = 0;
	    List<Lead> leads = [SELECT Id, User_ID__c, Name, Email, Company FROM Lead 
	    WHERE (LeadSource = 'About To be Cancelled' OR LeadSource = 'About To Be Cancelled UK' )
	    and (ATBC_Stage__c='new' OR ATBC_Stage__c='WIP') and IsConverted = false
	    and User_ID__c != null and User_ID__c != '' ];
	    Set<String> lUser = new Set<String>();
	    for(Lead l : leads) {      
	        luser.add(l.User_ID__c);
	    }  
	    List<Account> accs =  [SELECT RC_User_ID__c,ID FROM Account WHERE RC_User_ID__c  in :lUser 
	    and Next_Renewal_Date__c > TODAY];
	    Map<String,Account> accountMap = new Map<String,Account>();
	    for(Account ac : accs) {
	        accountMap.put(ac.RC_User_ID__c, ac);
	    }
	    //system.debug(' lUser USED in MAP Query IS:: '+lUser);
	
		/*List to Update*/
   		List<Lead> leadsToUpdate = new List<Lead>();
    
	    for(Lead l : leads){                   
	        if(accountMap.containsKey(l.User_ID__c) == True ){
	        	/*Adding in another List to Update*/       	        	
	            leadsToUpdate.add(l);
	        } else {
	            //system.debug('Key not found in Map :: ' + l.User_ID__c);     
	        }
	    }
	    
	    for(Lead lUp : leadsToUpdate){
	    	//lUp.ATBC_Stage__c = 'Closed';
	        //lUp.Status = '0. Downgraded';
	        //lUp.Downgrade_Reason__c = 'Retention Lead Closed';
	        //system.debug('This Lead is going to UPDATE::' + lUp.Id);
    	}
    	
    	//update leadsToUpdate;  
  		return null;
  }
  
  /*
  public PageReference save() {    
     
    Integer intCount = 0;
    List<Lead> leads = [SELECT Id, User_ID__c, Name, Email, Company,Title
    FROM Lead WHERE (LeadSource = 'About To be Cancelled' OR LeadSource = 'About To Be Cancelled UK')
    and (ATBC_Stage__c='new' OR ATBC_Stage__c='WIP') and IsConverted = false
    and User_ID__c != null and User_ID__c != ''];
      
    
    Set<String> lUser = new Set<String>();
    Integer lCounter = 0;
    Map<String,Account> accountMap = new Map<String,Account>();
    Integer batchSize = 5000;
    for(Lead l : leads) {
    	lCounter++;     	
    	lUser.add(l.User_ID__c);
    	if(lCounter == leads.size() || lUser.size() == batchSize){
    		accountMap.putAll(getAccounts(lUser));
    		lUser = new Set<String>();
    	}    	
    }  
    system.debug(Logginglevel.INFO,' # leads USED in  Query IS:: --------' + leads.size()); 
    system.debug(Logginglevel.INFO,' # accountMap USED in MAP Query IS:: --------' + accountMap.size()); 
    
	//List to Update  
    List<Lead> leadsToUpdate = new List<Lead>();
    
    for(Lead l : leads){
        if(accountMap.containsKey(l.User_ID__c) == True ){        		     	        	
	            leadsToUpdate.add(l);  
	            system.debug('This Lead is going to UPDATE::' + l.Id);     
        } else {
            system.debug('Key not found in Map:: ' + l.User_ID__c);     
        }
    }
    
    system.debug(Logginglevel.INFO, ' # of leads set to be updated is:: --------' + leadsToUpdate.size()); 
    
    for(Lead lUp : leadsToUpdate){
    	lUp.ATBC_Stage__c = 'Closed';
        lUp.Status = '0. Downgraded';
        lUp.Downgrade_Reason__c = 'Retention Lead Closed';            
        //lUp.Title = lUp.Title;
        //system.debug('This Lead is going to UPDATE::' + lUp.Id);
    }
    //update leadsToUpdate;  
    return null;
}
*/

public Map<String,Account> getAccounts(Set<String> lUser) {
	Map<String,Account> accountMap = new Map<String,Account>();
    List<Account> accs =  [SELECT RC_User_ID__c,ID FROM Account 
    WHERE RC_User_ID__c  in :lUser
    and Next_Renewal_Date__c > TODAY ];    
    for(Account ac : accs) {
        accountMap.put(ac.RC_User_ID__c, ac);
    }
    return accountMap;
}


  //*******************************************
  //*******************************************
  //*******************************************  
  //*******************************************
  //*******************************************
  //*******************************************
  //*******************************************
  //*******************************************
  //*******************************************
  
   /* static testMethod void testATBCController(){
        ATBCController atbcObj = new ATBCController();
        Lead leadObj = new Lead();
       	leadObj.LeadSource = 'About To be Cancelled'; 
        leadObj.ATBC_Stage__c = 'WIP';
        leadObj.IsConverted = false;
        leadObj.User_ID__c = UserInfo.getUserId();
        leadObj.FirstName='Virendra';
        leadObj.LastName='Singh';
        leadObj.Company='Simplion';
        leadObj.Email='vps@sss.ss221.com';
        leadObj.Phone='9910106804';
        insert leadObj;
        
        Account acctest2 = new Account();
        acctest2.Name='TestAccount';
        acctest2.RC_User_ID__c = UserInfo.getUserId();
        acctest2.Next_Renewal_Date__c = Date.today() + 10;
        insert acctest2;
        atbcObj.save();
        Set<string> lUser1 = new Set<string>();
        lUser1.add(UserInfo.getUserId());
        atbcObj.getAccounts(lUser1);        
    }*/
}