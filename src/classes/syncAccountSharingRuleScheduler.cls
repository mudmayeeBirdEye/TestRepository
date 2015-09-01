global class syncAccountSharingRuleScheduler implements Schedulable {
   
   
     global void execute(SchedulableContext ctx) 
     {
             syncAccountUpdateSharingRule.massUpdateSharingRule();
      }
       
  }