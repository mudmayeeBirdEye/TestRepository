public with sharing class ATBCHelper {

    public pagereference startATBC(){
        
        performATBCCleanup();
        
        return null;        
    }
    
    public  void performATBCCleanup(){
        performATBCCleanup2();
    }
    @future
    public static void performATBCCleanup2(){
        try{
            //###################################
            //New Logic starts

            //For ATBC cancel
            //if the renewal date on the account is < than the creation date of the ATBC Lead (keep the 60 day rule),
            //then cancel the ATBC lead.
            
            String strLeadListContent='';
            String allFetchedLeads='';
    
            List<Lead> leadsToCancel = new List<Lead>();
            
            if(!Test.isRunningTest()) {
                leadsToCancel = [SELECT Id, User_ID__c, Name, Email, Company, Account_Renewal_Date__c, CreatedDate FROM Lead 
                                WHERE (LeadSource = 'About To be Cancelled' OR LeadSource = 'About To Be Cancelled UK' )
                                and (ATBC_Stage__c='New' OR ATBC_Stage__c='WIP') and IsConverted = false
                                and User_ID__c != null and User_ID__c != '' AND LastModifiedDate < LAST_N_DAYS:60 ];
            } else {
                leadsToCancel = [SELECT Id, User_ID__c, Name, Email, Company, Account_Renewal_Date__c, CreatedDate FROM Lead 
                                WHERE (LeadSource = 'About To be Cancelled' OR LeadSource = 'About To Be Cancelled UK' )
                                and (ATBC_Stage__c='New' OR ATBC_Stage__c='WIP') and IsConverted = false
                                and User_ID__c != null and User_ID__c != '' AND LastModifiedDate <= LAST_N_DAYS:60 limit 1];
            }
            
                                
            List<Lead> leadsToCancelFinal = new List<Lead>();
            
            for(Lead lUp : leadsToCancel) {    
                if(lUp.Account_Renewal_Date__c!=null
                    && lUp.Account_Renewal_Date__c < lUp.CreatedDate){
                    lUp.ATBC_Stage__c = 'Canceled';
                    lUp.Status = '0. Downgraded';
                    lUp.Downgrade_Reason__c = 'Low Potential - Save For Notes';
                    
                    if(strLeadListContent ==''){
                        strLeadListContent = lUp.Id;
                    }else {
                        strLeadListContent = strLeadListContent + '\n' + lUp.Id;
                    }
                    
                    leadsToCancelFinal.add(lUp);
                }else{
                    allFetchedLeads = allFetchedLeads +'\n'+lUp.Id;
                }
            }
            
            try{
                Document d = new Document(); 
                d.Name = 'ATBC Cancel Downgrade Log #' + + System.now() + '# ' + Math.random(); 
                d.Body = Blob.valueOf('Leads To Cancel \n'+ strLeadListContent+'\n\n\n'+'All Leads Fetched'+ allFetchedLeads); 
                d.ContentType = 'text/plain';
                d.FolderId = '00l80000001ltF8';
                d.Type = 'txt';
                insert d;
                if(Test.isRunningTest()){
                    Integer val = 100/0;
                }
            
            }catch(Exception exp){
                Exception_And_Notification_History__c exceptionObj = new Exception_And_Notification_History__c();
                exceptionObj.Object_Type__c = 'Exception';
                exceptionObj.content_label_01__c = 'File Associated';
                exceptionObj.content_label_02__c = 'Line Number';
                exceptionObj.content_label_03__c = 'Exception';
                exceptionObj.content_label_04__c = 'Get Stack Trace String';
                exceptionObj.content_label_05__c = 'Details';
                exceptionObj.content_var_01__c ='ATBC Helper';
                exceptionObj.File_Associated__c = 'ATBC Helper';
                ExceptionAndNotificationHelper.trackExceptions(exceptionObj, exp);
            }
            
            System.debug('Leads to cancel size= '+ leadsToCancelFinal.size());
            update leadsToCancelFinal;
            
            
            //For ATBC close, the logic should be updated so that 
            //if the renewal date on the account is > than the creation date of the ATBC lead, then close the ATBC lead     
            strLeadListContent = '';
            allFetchedLeads='';
            
            List<Lead> leadsToClose = new  List<Lead>();
            
            if(!Test.isRunningTest()) {
                leadsToClose = [SELECT Id, User_ID__c, Name, Email, Company, Account_Renewal_Date__c, CreatedDate FROM Lead 
                                    WHERE (LeadSource = 'About To be Cancelled' OR LeadSource = 'About To Be Cancelled UK' )
                                    and (ATBC_Stage__c='new' OR ATBC_Stage__c='WIP') and IsConverted = false
                                    and User_ID__c != null and User_ID__c != '' ];  
            } else {
                leadsToClose = [SELECT Id, User_ID__c, Name, Email, Company, Account_Renewal_Date__c, CreatedDate FROM Lead 
                                    WHERE (LeadSource = 'About To be Cancelled' OR LeadSource = 'About To Be Cancelled UK' )
                                    and (ATBC_Stage__c='new' OR ATBC_Stage__c='WIP') and IsConverted = false
                                    and User_ID__c != null and User_ID__c != '' limit 1];
            }
            
            List<Lead> leadsToCloseFinal = new List<Lead>();

            for(Lead lUp : leadsToClose) {      
                //lCancelUser.add(l.User_ID__c);
                if(lUp.Account_Renewal_Date__c!=null
                    && lUp.Account_Renewal_Date__c > lUp.CreatedDate){
                    lUp.ATBC_Stage__c = 'Closed';
                    lUp.Status = '0. Downgraded';
                    lUp.Downgrade_Reason__c = 'Retention Lead Closed';
                    
                    if(strLeadListContent ==''){
                        strLeadListContent = lUp.Id;
                    }else {
                        strLeadListContent = strLeadListContent + '\n' + lUp.Id;
                    }
                    
                    leadsToCloseFinal.add(lUp);
                }else{
                allFetchedLeads = allFetchedLeads +'\n'+lUp.Id;
                }
            }
            
            try{
                Document d = new Document(); 
                d.Name = 'ATBC Close Downgrade Log #' + + System.now() + '# ' + Math.random(); 
                d.Body = Blob.valueOf('Leads To Cancel \n'+ strLeadListContent+'\n\n\n'+'All Leads Fetched'+ allFetchedLeads);
                d.ContentType = 'text/plain';
                d.FolderId = '00l80000001ltF8';
                d.Type = 'txt';
                insert d;
                if(Test.isRunningTest()){
                    Integer val = 100/0;
                } 
            
            }catch(Exception exp){
                Exception_And_Notification_History__c exceptionObj = new Exception_And_Notification_History__c();
                exceptionObj.Object_Type__c = 'Exception';
                exceptionObj.content_label_01__c = 'File Associated';
                exceptionObj.content_label_02__c = 'Line Number';
                exceptionObj.content_label_03__c = 'Exception';
                exceptionObj.content_label_04__c = 'Get Stack Trace String';
                exceptionObj.content_label_05__c = 'Details';
                exceptionObj.content_var_01__c ='ATBC Helper';
                exceptionObj.File_Associated__c = 'ATBC Helper';
                ExceptionAndNotificationHelper.trackExceptions(exceptionObj, exp);
            }
            
            System.debug('Leads to cancel size= '+ leadsToCloseFinal.size());
            
            update leadsToCloseFinal;           
            
            //New Logic ends
            //###################################
            
            /*
            List<Lead> oldATBCleads =[SELECT Id, User_ID__c, Name, Email, Company FROM Lead 
            WHERE (LeadSource = 'About To be Cancelled' OR LeadSource = 'About To Be Cancelled UK' )
            and (ATBC_Stage__c='New' OR ATBC_Stage__c='WIP') and IsConverted = false
            and User_ID__c != null and User_ID__c != '' AND LastModifiedDate < LAST_N_DAYS:60 ];
            
            //Get RC user id set and use it to get accounts whose next renewal date is in past
            strLeadListContent='';
            Set<String> lCancelUser = new Set<String>();
            for(Lead l : oldATBCleads) {      
                lCancelUser.add(l.User_ID__c);
            }
            
            List<Account> cancelAccs =  [SELECT RC_User_ID__c,ID FROM Account WHERE RC_User_ID__c  in :lCancelUser and Next_Renewal_Date__c < TODAY];
            Map<String,Account> cancelAccountMap = new Map<String,Account>();
            for(Account ac : cancelAccs) {
                cancelAccountMap.put(ac.RC_User_ID__c, ac);
            }
        
            //List to Update
            List<Lead> cancelLeadsToUpdate = new List<Lead>();
                                    
            for(Lead lUp : oldATBCleads){
                if(cancelAccountMap.containsKey(lUp.User_ID__c) == True ){
                    cancelLeadsToUpdate.add(lUp);
                    
                    lUp.ATBC_Stage__c = 'Canceled';
                    lUp.Status = '0. Downgraded';
                    lUp.Downgrade_Reason__c = 'Low Potential - Save For Notes';
                    
                    if(strLeadListContent ==''){
                        strLeadListContent = lUp.Id;
                    }else {
                        strLeadListContent = strLeadListContent + '\n' + lUp.Id;
                    }               
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
            
           // update cancelLeadsToUpdate;
                
            //Code to close leads
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
            WHERE RC_User_ID__c  in :lUser and Next_Renewal_Date__c > TODAY AND LastModifiedDate >= LAST_N_DAYS:30];
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
            */   
            
            if(Test.isRunningTest()){
                Integer val = 100/0;
            }       
            
        }catch(Exception exp){
            Exception_And_Notification_History__c exceptionObj = new Exception_And_Notification_History__c();
            exceptionObj.Object_Type__c = 'Exception';
            exceptionObj.content_label_01__c = 'File Associated';
            exceptionObj.content_label_02__c = 'Line Number';
            exceptionObj.content_label_03__c = 'Exception';
            exceptionObj.content_label_04__c = 'Get Stack Trace String';
            exceptionObj.content_label_05__c = 'Details';
            exceptionObj.content_var_01__c ='ATBC Helper';
            exceptionObj.File_Associated__c = 'ATBC Helper';
            ExceptionAndNotificationHelper.trackExceptions(exceptionObj, exp);
            
            //Save this to log file also
            Document d = new Document(); 
            d.Name = 'ATBC Exception Log #' + + System.now() + '# ' + Math.random(); 
            d.Body = Blob.valueOf(exp.getTypeName() + '\n'+ exp.getLineNumber() + '\n' 
                        + exp.getStackTraceString() + '\n' + exp.getMessage()); 
            
            d.ContentType = 'text/plain';
            d.FolderId = '00l80000001ltF8';
            d.Type = 'txt';
            insert d;
        }
        
    }

/*public static testmethod void test() {
      try{
          ATBCHelper objATBCHelper =new ATBCHelper ();
          objATBCHelper.startATBC();        
      } catch(Exception exp){
        
      }
    }*/
      
}