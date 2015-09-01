/* This trigger is Used in Account Plan Object to get Employee Details from Employee and
  populates values of Owner Email,Owner Manager Name,Owner Manager Email,Owner Division and Owner Team in Account Plan */
  

trigger AccountPlan on Account_Plan__c (After Insert,After Update,Before Insert, Before Update) {

        if(trigger.isBefore){
              for(Account_Plan__c accPlan:trigger.new){
                     
                     //To get the Employee details From Employee Records
                      for(Employee__c empDetails: [SELECT Team__c,Email__c,Division__c, Manager_Employee_Number__c 
                                              from Employee__c where User__c =:accPlan.OwnerId limit 1 ]) {
                                                    accPlan.Owner_Team__c  = empDetails.Team__c;
                                                    accPlan.Owner_Division__c = empDetails.Division__c;
                                                    accPlan.Owner_Email__c = empDetails.Email__c;
                                         
                       //To get Employee Manager Deatils 
                         for(Employee__c mgrDetails: [SELECT First_Name__c, Last_Name__c, Email__c 
                                              from Employee__c where Id =:empDetails.Manager_Employee_Number__c limit 1 ]){
                                                    accPlan.Owner_Manager_Email__c = mgrDetails.Email__c;
                                                    accPlan.Owner_Manager_Name__c = mgrDetails.First_Name__c + ' ' +mgrDetails.Last_Name__c;
                          }
                       } 
                }
        }
 }