public class syncAccountLevelRollUps {

    //public List<SelectOption> listSchedule{get;set;}
    public String strScheduleName{get;set;}
    public Boolean isAlredyProcessed{get;set;}
    public Boolean isCompletedToday{get;set;}
   
    public syncAccountLevelRollUps(ApexPages.StandardController controller) {
             strScheduleName='';
             isAlredyProcessed=false;
             isCompletedToday=false;
             
            /* listSchedule=new List<SelectOption>();
             listSchedule.add(new SelectOption('None','-None-'));  
             listSchedule.add(new SelectOption('allchild','Account Parent-Child(Contact,Case,Activities)')); 
             listSchedule.add(new SelectOption('Partner','Total active Customer')); */
    }

     
   public List<Account> liAccount{get;set;}
   public Integer accountListSize{get;set;}
   
 
  public PageReference  massUpdateAccountRollUp(){
         liAccount=new List<Account>();
         accountListSize=liAccount.size();
         isAlredyProcessed=false;
         isCompletedToday=false;
         
       if(strScheduleName=='None'){
         ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Please select atleast one record from dropdown');
         ApexPages.addMessage(myMsg);
       return null;
       }
      if(strScheduleName=='allchild'){
           scheduleAccountRollup();
      }
       if(strScheduleName=='Partner'){
        setTotalActiveCustomer();
      }
     
         return null ;
    }

      public void scheduleAccountRollup(){
         ApexClass objApexClass=new ApexClass();
       
          try{
               objApexClass =[Select a.Id From ApexClass a where name='syncBatchAccountLevelRollUps' limit 1];
             }catch(Exception e){
            }
        
          for(AsyncApexJob objAsyncApexJob :[SELECT Status, ApexClassId,CompletedDate,CreatedDate,CreatedBy.Name,CreatedBy.Email,JobItemsProcessed,TotalJobItems,NumberOfErrors  FROM AsyncApexJob where ApexClassId=:objApexClass.id and
                                              CreatedDate=TODAY and( Status='Queued' OR Status='Processing' OR Status='Preparing') limit 1]){
                  User objUser2=[Select Name from User where Id=:objAsyncApexJob.CreatedById ];
                  isAlredyProcessed=false;
                  if('Queued,Processing,Preparing'.contains(objAsyncApexJob.Status)){
                       ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'This is already scheduled by <b>'+objAsyncApexJob.CreatedBy.Name+' </b> in <b>Apex Batch</b> for updation at <b>'+objAsyncApexJob.CreatedDate+'</b>. It may take longer time depending on '+
                                                                                          'the records and workflows.'+
                                                                                          ' <br><br>You can monitor completion process in <b>Apex Jobs</b> under<b>'+
                                                                                          '<a href=https://'+ApexPages.currentPage().getHeaders().get('Host')+'/apexpages/setup/listAsyncApexJobs.apexp target=_blank>Monitor</a></b>'+
                                                                                          ' <br/><br/><b>Current status of Job is '+objAsyncApexJob.Status+'</b><b>'+(objAsyncApexJob.Status=='Processing'?('('+ objAsyncApexJob.JobItemsProcessed+' out of '+objAsyncApexJob.TotalJobItems)+' .Failure '+objAsyncApexJob.NumberOfErrors+')':'')+'</b>'+
                                                                                          ' <br/><br/><b>When compilation will be completed then message will send to your email id('+objAsyncApexJob.CreatedBy.Email+') automatically.</b>'));
                    
                      return ;    
                  }
                  }
                 for(AsyncApexJob objAsyncApexJob :[SELECT Status, ApexClassId,CompletedDate,CreatedBy.Name FROM AsyncApexJob where ApexClassId=:objApexClass.id and
                                              CreatedDate=TODAY and(Status='Completed') order by CreatedDate desc limit 1 ]){
                    if(objAsyncApexJob.Status=='Completed'){
                         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'All the Accounts are already updated by <b>'+objAsyncApexJob.CreatedBy.Name+'</b> at <b>'+objAsyncApexJob.CompletedDate+'</b>.'));

                     isCompletedToday=true;
                  return ;
                  }
         }
           
              Integer accountSize=0;
              if(test.isRunningTest()){
                accountSize=[Select count() from Account limit 100 ];
             }else{
             	accountSize=[Select count() from Account limit 25000 ];
              }
              /*for(AggregateResult objAggregateResult:[Select count(id) total from Account limit 49999]){
                accountSize=(Integer)objAggregateResult.get('total');
              }*/
              String strSize=accountSize==25000?'25000+':(accountSize+'');
             if(accountSize>0){
             
                  synbatchAccountRollup();
                  User objUser=[Select Email from user where id=:UserInfo.getUserId()];
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Records (<b>'+strSize+'</b>) have been added to <b>Apex Batch</b> for updation. It may take longer time depending on the records and '+
                                                                              'workflows.<br><br>You can monitor completion process in <b>Apex Jobs</b> under<b>'+
                                                                              '<a href=https://'+ApexPages.currentPage().getHeaders().get('Host')+'/apexpages/setup/listAsyncApexJobs.apexp target=_blank>Monitor</a></b>.<br/> <br/>'+
                                                                              ' When compilation will be completed then message will send to your email id (<b>'+objUser.Email+'</b>) automatically.'));
              }else{
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Account size is zero'));
              }
            
           
            return;
      
      }
      public void scheduleAllAccountsAgain(){
            isCompletedToday=false;
            Integer accountSize=0;
             if(test.isRunningTest()){
                accountSize=[Select count() from Account limit 100 ];
             }else{
             	accountSize=[Select count() from Account limit 25000 ];
              }
            /* for(AggregateResult objAggregateResult:[Select count(id) total from Account limit 49999]){
               accountSize=(Integer)objAggregateResult.get('total');
              } */
               String strSize=accountSize==25000?'25000+':(accountSize+'');
             if(accountSize>0){
                  synbatchAccountRollup();
         
                  User objUser=[Select Email from user where id=:UserInfo.getUserId()];
                           
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Records (<b>'+strSize+' <b>) have been added to <b>Apex Batch</b> for updation. It may take longer time depending on the records and '+
                                                                                      'workflows.<br><br>You can monitor completion process in <b>Apex Jobs</b> under<b>'+
                                                                                      '<a href=https://'+ApexPages.currentPage().getHeaders().get('Host')+'/apexpages/setup/listAsyncApexJobs.apexp target=_blank>Monitor</a></b>.<br/> <br/>'+
                                                                                      ' When compilation will be completed then message will send to your email id (<b>'+objUser.Email+'</b>) automatically.'));
            }else{
            
            }  
      return;
      } 
   
      public void synbatchAccountRollup(){
      
                  
          syncBatchAccountLevelRollUps obj=new syncBatchAccountLevelRollUps('');
          Database.executeBatch(obj,20);
      }
      
      public void setTotalActiveCustomer(){
      
      try{
          List<User> liUser = new List<User>();
          if(Test.isRunningTest()) {
          	liUser =[Select Contact.Account.Partner_id__c,Contact.AccountId from User where UserRoleId !=null and
                             UserRole.Name!=null and Contact.Account.Partner_id__c!=null and UserRole.PortalType='Partner' and 
                             UserRole.PortalRole='Executive' and Contact.Account.IsPartner=true limit 1];
          } else {
          	liUser =[Select Contact.Account.Partner_id__c,Contact.AccountId from User where UserRoleId!=null and
                             UserRole.Name!=null and Contact.Account.Partner_id__c!=null and UserRole.PortalType='Partner' and 
                             UserRole.PortalRole='Executive' and Contact.Account.IsPartner = true];
          }
         
         if(liUser.size()>0){
             Set<Id> setPartnerAccountId=new Set<Id>();
             Set<String> setPartnerId=new Set<String>();
             Set<Id> setCustomerAccountId=new Set<Id>();
               
             Map<String,Account> mapPartnerIdAccount=new Map<String,Account>();
             for(User objUser:liUser){
               setPartnerAccountId.add(objUser.Contact.AccountId);
               setPartnerId.add(objUser.Contact.Account.Partner_id__c);
              }
         
              for(Account objAccount:[Select id,Total_Active_Customers__c,Partner_Id__c,Total_Cases__c,Total_Contacts__c,
                                       Name,Total_Opportunities__c,Total_Activities__c
                                       from Account where id IN:setPartnerAccountId]){
                  objAccount.Total_Active_Customers__c=0;
                  objAccount.Total_Cases__c=objAccount.Total_Cases__c==null?0:objAccount.Total_Cases__c;
                  objAccount.Total_Contacts__c=objAccount.Total_Contacts__c==null?0:objAccount.Total_Contacts__c;
                  objAccount.Total_Activities__c=objAccount.Total_Activities__c==null?0:objAccount.Total_Activities__c;
                  
                  mapPartnerIdAccount.put(objAccount.Partner_Id__c,objAccount);
              }
             RecordType objCustomerRecordType = [Select id,Name from RecordType where name='Customer Account' limit 1];   
             List<User> liCustomerUser=[Select Contact.Account.Partner_id__c,Contact.AccountId from User where isActive=true 
                                        and Contact.Account.Partner_id__c IN:setPartnerId and Contact.Account.RecordTypeId=:objCustomerRecordType.id];
             
                if(liCustomerUser.size()>0){
                  for(User objUser2:liCustomerUser ){
                     setCustomerAccountId.add(objUser2.Contact.AccountId);
                  }
                  
                for(AggregateResult objCustomerAccount:[Select count(id) total,Partner_id__c from Account where Id IN:setCustomerAccountId 
                                                         group by Partner_id__c  ]){
                  
                Account objPartnerAccount=new Account();
                objPartnerAccount=mapPartnerIdAccount.get((String)objCustomerAccount.get('Partner_id__c'));
                objPartnerAccount.Total_Active_Customers__c=(Integer)objCustomerAccount.get('total');
                //liAccount.add(objPartnerAccount);
                }
                liAccount=mapPartnerIdAccount.values();
                if(liAccount.size()>0){
                  update liAccount;
                }
               accountListSize=liAccount.size();
              }else{
                  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'No active customer found under any patner accounts'));  
            }
           }else{
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'No Partner Account Found'));  
             
             }
          }catch(Exception e){
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));  
           }
      
      
  	
      }
  		/*public static testmethod void test() {
      		Account testAccount = new Account(Name = 'TestAccount');
      		ApexPages.StandardController controller=new ApexPages.StandardController(testAccount);
      		syncAccountLevelRollUps objsyncAccountLevelRollUps =new syncAccountLevelRollUps (controller);
      		objsyncAccountLevelRollUps.strScheduleName='None';
      		Test.startTest();
      		objsyncAccountLevelRollUps.massUpdateAccountRollUp();
      		objsyncAccountLevelRollUps.strScheduleName='allchild';
      		objsyncAccountLevelRollUps.massUpdateAccountRollUp();
 		  	objsyncAccountLevelRollUps.strScheduleName='Partner';
      		objsyncAccountLevelRollUps.setTotalActiveCustomer();
      		objsyncAccountLevelRollUps.scheduleAllAccountsAgain();
      		Test.stopTest();
  		}*/
   }