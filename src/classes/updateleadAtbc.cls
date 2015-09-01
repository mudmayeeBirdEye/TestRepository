public class updateleadAtbc{
 public List<cLead> leadList {get; set;}
 public Integer leadcount{get;set;}

    public updateleadAtbc(ApexPages.StandardController controller) {
    searchLeads();
    }
    public void searchLeads()
    {
    	leadList = new List<cLead>();
	    Integer intCount = 0;
	    List<Lead> leads = [SELECT Id, User_ID__c, Name, Email, Company, LeadSource FROM Lead 
	    WHERE (LeadSource = 'About To be Cancelled' OR LeadSource = 'About To Be Cancelled UK' )
	    and (ATBC_Stage__c='new' OR ATBC_Stage__c='WIP') and IsConverted = false
	    and User_ID__c != null and User_ID__c != '' ];
	    
	    Set<String> lUser = new Set<String>();
	    for(Lead l : leads) {      
	        luser.add(l.User_ID__c);
	    }  
	    List<Account> accs =  [SELECT RC_User_ID__c,ID FROM Account WHERE RC_User_ID__c  in :lUser and Next_Renewal_Date__c > TODAY ];
	    Map<String,Account> accountMap = new Map<String,Account>();
	    for(Account ac : accs) {
	        accountMap.put(ac.RC_User_ID__c, ac);
	    }    
	    for(Lead l : leads){
	        if(accountMap.containsKey(l.User_ID__c) == True ){
	        	leadList.add(new cLead(l,l.Id,l.Name, l.LeadSource,l.Email,l.Company));
	        } else {
	            system.debug('Key not found in Map:: ' + l.User_ID__c);     
	        }
	    }
	    leadcount = leadList.size();
    
	    /*
	    leadList = new List<cLead>();
	    List<Lead> leads = [SELECT Id, User_ID__c, Name, Email, Company,Title, LeadSource 
	    FROM Lead WHERE LeadSource = 'About To be Cancelled' 
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
	    for(Lead l : leads)
	    {
	        if(accountMap.containsKey(l.User_ID__c) == True ){	        	
	        		leadList.add(new cLead(l,l.Id,l.Name, l.LeadSource,l.Email,l.Company));	        	
	        } else {
	            system.debug('Key not found in Map:: ' + l.User_ID__c);     
	        }	      
	    }
	    leadcount = leadList.size();
	    */
    }
    
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
    

     public class cLead{
            public Lead lead{get; set;} 
            public String Id {get; set;} 
            public String Name{get; set;} 
            public String LeadSource{get; set;}
            public String Email{get; set;} 
            public String Company{get; set;} 
            
            
     public cLead(Lead lead,String Id,String Name,String LeadSource,String Email,String Company)
           {
            this.lead = lead;
            this.Name= Name;
            this.Email= Email;
            this.Id = Id;
           // this.UserId = UserId ;
            this.LeadSource= LeadSource;  
            this.Company= Company;   
           }
         }    
         
  
                  
 /*        static testMethod void testupdateleadAtbc(){
         FakeDataTest FakeTest = new FakeDataTest();
         FakeTest.testingFakeData();
         FakeTest.testingFakeData02();    
         FakeTest.testingFakeData03(); 
    }  */

//*******************************/
//*******************************/
//*******************************/
//Test Class
/*   public class FakeDataTest{ 
            public void testingFakeData()       
            {
            String strData = '';
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
                
            } //--

        public void testingFakeData02()       
            {
            String strData = '';
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
                
            } //--
            public void testingFakeData03()       
            {
            String strData = '';
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
                
            } //--
    }*/
    
    
    //-
    

}