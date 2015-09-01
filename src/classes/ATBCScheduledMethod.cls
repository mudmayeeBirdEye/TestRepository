global class ATBCScheduledMethod implements Schedulable {
    /*
    Look for any lead in Lead Source=‘About To be Cancelled’ and ATBC Stage=New or WIP for the same RC UserID
    and check the renewal date on Account  -> if renewal date is in future
    Move the ATBC Stage to ‘Closed’
    Move Lead Status to ‘0. Downgraded’
    Move Downgrade Reason to ‘Retention Lead Closed’  
  */
    // This test runs a scheduled job at midnight Sept. 3rd. 2022
    //public static String CRON_EXP = '0 0 0 1 0 ? 0';
   
     global void execute(SchedulableContext ctx) 
     {
     	/*ATBCHelper objATBCHelper = new ATBCHelper();
        objATBCHelper.performATBCCleanup();*/
        
        ATBCBatch objATBCBatch = new ATBCBatch(); 
   		objATBCBatch.strQuery =	 'SELECT Id, User_ID__c, Name, Email, Company, Account_Renewal_Date__c, CreatedDate FROM Lead ' +
									'WHERE (LeadSource = \'About To be Cancelled\' OR LeadSource = \'About To Be Cancelled UK\' ) '  +
								 	'and (ATBC_Stage__c=\'New\' OR ATBC_Stage__c=\'WIP\') and IsConverted = false ' +
								 	'and User_ID__c != null and User_ID__c != \'\' AND LastModifiedDate < LAST_N_DAYS:60';		 
							    	
		objATBCBatch.strIsCancel = '1';
		List<AsyncApexJob> atbcjobs = new List<AsyncApexJob>([SELECT Status, ApexClass.Name FROM AsyncApexJob  
        												 		WHERE ApexClass.Name = 'ATBCBatch' and 
        												 		status IN ('Processing', 'Queued', 'Preparing') Limit 1]);
		if(atbcjobs != null && atbcjobs.size() == 0) {
		    Database.executeBatch(objATBCBatch,200);
		} 					    	
     	
     	/*
     	List<Lead> oldATBCleads =[SELECT Id, User_ID__c, Name, Email, Company FROM Lead 
	    WHERE (LeadSource = 'About To be Cancelled' OR LeadSource = 'About To Be Cancelled UK' )
	    and (ATBC_Stage__c='New' OR ATBC_Stage__c='WIP') and IsConverted = false
	    and User_ID__c != null and User_ID__c != '' and  CreatedDate != TODAY AND CreatedDate < LAST_N_DAYS:60 ];
	  
	    
	    Set<ID> oldATBCleads_id = new Set<ID>();
	    String strLeadListContent='';
	    	    	    
	    for(Lead lUp : oldATBCleads){
	    //Adding list of old ATBC lead's ids so later we filter next query 
	    	oldATBCleads_id.add(lUp.id);
	    	
	    	lUp.ATBC_Stage__c = 'Canceled';
	        lUp.Status = '0. Downgraded';
	        lUp.Downgrade_Reason__c = 'Low Potential - Save For Notes';
	        //system.debug('This Lead is going to UPDATE::' + lUp.Id);
	        
			if(strLeadListContent ==''){
				strLeadListContent = lUp.Id;
			}else {
				strLeadListContent = strLeadListContent + '\n' + lUp.Id;
			}	        
    	}
    	
	    try{
		    Document d = new Document(); 
		
		    d.Name = 'ATBC Downgrade Log #' + + System.now() + '# ' + Math.random(); 
		    d.Body = Blob.valueOf(strLeadListContent); 
		    d.ContentType = 'text/plain';
		    d.FolderId = '00l80000001ltF8';
		    d.Type = 'txt';
		    insert d;
		
		}catch(Exception exp){}
	    
	    update oldATBCleads;
     	 	
     	
        Integer intCount = 0;
	    List<Lead> leads = [SELECT Id, User_ID__c, Name, Email, Company FROM Lead 
	    WHERE (LeadSource = 'About To be Cancelled' OR LeadSource = 'About To Be Cancelled UK' )
	    and (ATBC_Stage__c='new' OR ATBC_Stage__c='WIP') and IsConverted = false
	    and User_ID__c != null and User_ID__c != '' ];
	    
	    Set<String> lUser = new Set<String>();
	    for(Lead l : leads) {      
	        luser.add(l.User_ID__c);
	    }  
	    //List<Account> accs =  [SELECT RC_User_ID__c,ID FROM Account 
	    //WHERE RC_User_ID__c  in :lUser and Next_Renewal_Date__c > TODAY];
	    List<Account> accs =  [SELECT RC_User_ID__c,ID FROM Account 
	    WHERE RC_User_ID__c  in :lUser and Next_Renewal_Date__c > TODAY AND LastModifiedDate >= LAST_N_DAYS:7];
	    Map<String,Account> accountMap = new Map<String,Account>();
	    for(Account ac : accs) {
	        accountMap.put(ac.RC_User_ID__c, ac);
	    }
	    //system.debug(' lUser USED in MAP Query IS:: '+lUser);
	
		//List to Update
   		List<Lead> leadsToUpdate = new List<Lead>();
    	
    	strLeadListContent='';
    	
	    for(Lead l : leads){                   
	        if(accountMap.containsKey(l.User_ID__c) == True ){
	        	//Adding in another List to Update       	        	
	            leadsToUpdate.add(l);
	            
	            if(strLeadListContent ==''){
	            	strLeadListContent = l.Id;
	            }else {
	            	strLeadListContent = strLeadListContent + '\n' + l.Id;
	            }
	        } else {
	            //system.debug('Key not found in Map :: ' + l.User_ID__c);     
	        }
	    }
	    
	    for(Lead lUp : leadsToUpdate){
	    	lUp.ATBC_Stage__c = 'Closed';
	        lUp.Status = '0. Downgraded';
	        lUp.Downgrade_Reason__c = 'Retention Lead Closed';
	        //system.debug('This Lead is going to UPDATE::' + lUp.Id);
    	}
	    
	    try{
            Document d = new Document(); 

            d.Name = 'ATBC Close Log #' + + System.now() + '# ' + Math.random(); 
            d.Body = Blob.valueOf(strLeadListContent); 
            d.ContentType = 'text/plain';
            d.FolderId = '00l80000001ltF8';
            d.Type = 'txt';
            insert d;
            
        }catch(Exception exp){}
        
	    update leadsToUpdate; 
	    
		//New hack to close leads for accounts with Next Renewal Date as Past   
        try{
	        List<Lead> newLeads = [SELECT Id, User_ID__c, Name, Email, Company, createddate FROM Lead 
		    WHERE (LeadSource = 'About To be Cancelled' OR LeadSource = 'About To Be Cancelled UK' )
		    and (ATBC_Stage__c='new' OR ATBC_Stage__c='WIP') and IsConverted = false
		    and User_ID__c != null and User_ID__c != ''  and createddate < LAST_N_DAYS:60 ];
		    
		    Set<String> lUserIds = new Set<String>();
		    for(Lead l : newLeads) {      
		        lUserIds.add(l.User_ID__c);
		    }  
		    List<Account> newAccounts =  [SELECT RC_User_ID__c,ID FROM Account WHERE RC_User_ID__c  in :lUserIds and Next_Renewal_Date__c < TODAY ];
		    Map<String,Account> newAccountMap = new Map<String,Account>();
		    for(Account ac : newAccounts) {
		        newAccountMap.put(ac.RC_User_ID__c, ac);
		    }
		    //system.debug(' lUser USED in MAP Query IS:: '+lUser);
		
			//List to Update
	   		List<Lead> newLeadsToUpdate = new List<Lead>();
	    	
	    	//Clear earlier string which contains IDs
	    	strLeadListContent='';
	    	
		    for(Lead l : newLeads){                   
		        if(newAccountMap.containsKey(l.User_ID__c) == True ){
		            newLeadsToUpdate.add(l);
		            
		            if(strLeadListContent ==''){
	            		strLeadListContent = l.Id;
		            }else {
		            	strLeadListContent = strLeadListContent + '\n' + l.Id;
		            }
		        }
		    }
		    
		    for(Lead lUp : newLeadsToUpdate){
		    	lUp.ATBC_Stage__c = 'Closed';
		        lUp.Status = '0. Downgraded';
		        lUp.Downgrade_Reason__c = 'Low Potential - Save For Notes';
		        //system.debug('This Lead is going to UPDATE::' + lUp.Id);
	    	}
		    
		    try{
	            Document d = new Document(); 
	
	            d.Name = 'ATBC Close Hack Log #' + + System.now() + '# ' + Math.random(); 
	            d.Body = Blob.valueOf(strLeadListContent); 
	            d.ContentType = 'text/plain';
	            d.FolderId = '00l80000001ltF8';
	            d.Type = 'txt';
	            insert d;
	            
        	}catch(Exception exp){}
        
		    update newLeadsToUpdate;
		             	
        }catch(Exception exp){
        	//MailHelper mailHelper = new MailHelper();
        	//mailHelper.createMail();
        	
        }
        */	    		            
    }     
    
    //Code for test case
    
        public class RNIncidentDataTest{ 
            public void testingIncidentData()       
            {
            String strData = '';
            strData = 'sec_string=rc1450&xml_doc=<connector ret_type="i_id"><function name="search"><parameter name="args" type="pair"><pair name="search_args" type="pair"><pair name="search_field1" type="pair"><pair name="name" type="string">contactid</pair><pair name="compare_val" type="string">0012210</pair></pair></pair></parameter><parameter name="ac_id" type="integer">106070</parameter></function></connector>';
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

        public void testingIncidentData02()       
            {
            String strData = '';
            strData = 'sec_string=rc1450&xml_doc=<connector ret_type="i_id"><function name="search"><parameter name="args" type="pair"><pair name="search_args" type="pair"><pair name="search_field1" type="pair"><pair name="name" type="string">contactid</pair><pair name="compare_val" type="string">0012210</pair></pair></pair></parameter><parameter name="ac_id" type="integer">106070</parameter></function></connector>';
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
  
  }
}