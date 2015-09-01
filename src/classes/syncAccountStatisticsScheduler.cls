global class syncAccountStatisticsScheduler implements Schedulable {
   
   
     global void execute(SchedulableContext ctx) 
     {
          ApexClass objApexClass=new ApexClass();
          Boolean  isAlredyProcessed=false;
          try{
               objApexClass =[Select a.Id From ApexClass a where name='syncBatchAccountLevelRollUps' limit 1];
             }catch(Exception e){
            }
               for(AsyncApexJob objAsyncApexJob :[SELECT Status, ApexClassId,CompletedDate,CreatedDate,CreatedBy.Name,CreatedBy.Email,JobItemsProcessed,TotalJobItems,NumberOfErrors 
                                                  FROM AsyncApexJob where ApexClassId=:objApexClass.id and
                                                  ( Status='Queued' OR Status='Processing' OR Status='Preparing') limit 1]){
                                              	
                  isAlredyProcessed=true;
                }
          
          if(!isAlredyProcessed){
    	
          try{
               Account testAccount ;
               ApexPages.StandardController controller=new ApexPages.StandardController(testAccount);
               if(!test.isRunningTest()){
                 new syncAccountLevelRollUps(controller).setTotalActiveCustomer();
               }
             }catch(Exception e){}
     
         
          try{
              String strQuery='Select Total_Cases__c,Total_Contacts__c,Total_Activities__c,(Select Id From Cases),(Select Id From Contacts),(Select Id From OpenActivities) From Account a';
             syncBatchAccountLevelRollUps obj=new syncBatchAccountLevelRollUps(strQuery);
              if(!test.isRunningTest()){
                 Database.executeBatch(obj,100);
              }
           }catch(Exception e){}
        }
     }
  }