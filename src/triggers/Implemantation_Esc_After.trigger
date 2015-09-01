trigger Implemantation_Esc_After on Implementation_Escalation__c (after insert, after update) {
    
    if(Trigger.isUpdate){
    System.debug('----------------Is update on After Trigger-----------------');        
        
        Set<id> implIds = new Set<id>();
        
        /*Collection Implementation (parent)*/  
        for(Implementation_Escalation__c impEsc: Trigger.new){
                implIds.add(impEsc.Implementation__c);
        
        }
        
                
        /* Collection of Parent Implementation__c */
        Map<id,Implementation__c> implMap = new Map<id,Implementation__c>([SELECT id, Brand__c, Account__c, OwnerId, Contact__c,
        Owner.UserRoleId, Owner.Email, Owner.Name, Contact__r.Email, Contact__r.FirstName From Implementation__c  WHERE id IN:implIds]);
        
        set<id> usrids = new set<id>();
        
        /*collection userids*/
        for(Implementation_Escalation__c impEsc: Trigger.new){
                usrids.add(implMap.get(impEsc.Implementation__c).OwnerId);
            if(impEsc.Escalation_Owner__c != null){
                usrids.add(impEsc.Escalation_Owner__c);
            }
        }
        
        /*User Map*/
        Map<id,User> userMap = new Map<id, User>([Select UserRole.Name, UserRoleId, Name, Manager.Email, Manager.Name, 
        ManagerId, Email From User WHERE id IN: usrids]);
        
        /*Creating MAP for Brand and Survey Type*/
        Map<String, String> SurveyType = new Map<String, String>();
        SurveyType.put('RINGCENTRAL','Implementation');
        SurveyType.put('RINGCENTRAL CANADA','Implementation');
        SurveyType.put('AT&T OFFICE@HAND','ATT Implementation');
        SurveyType.put('RINGCENTRAL OFFICE@HAND FROM AT&T','ATT Implementation');
        SurveyType.put('ROGERS','Rogers Implementation');
        
    
            
        for(Implementation_Escalation__c impEsc: Trigger.new){
   
          
            if(Trigger.oldMap.get(impEsc.id).Escalation_Status__c != 'Completed' 
            && impEsc.Escalation_Status__c == 'Completed' 
            && implMap.get(impEsc.Implementation__c).Brand__c != NULL){
                
                System.debug('-------------In IF Condition--------------');
                
                    
            /*Generic Block for all Implementation Esc's Survey*/
            
            if(implMap.get(impEsc.Implementation__c).Brand__c.equalsIgnoreCase('RingCentral') 
            || implMap.get(impEsc.Implementation__c).Brand__c.equalsIgnoreCase('RingCentral Canada') 
            || implMap.get(impEsc.Implementation__c).Brand__c.equalsIgnoreCase('AT&T Office@Hand')
            || implMap.get(impEsc.Implementation__c).Brand__c.equalsIgnoreCase('RingCentral Office@Hand from AT&T')
            || implMap.get(impEsc.Implementation__c).Brand__c.equalsIgnoreCase('Rogers')){
        
                                                    
                        
                        Survey__c s = new Survey__c();
                        s.SurveyType__c = SurveyType.get(implMap.get(impEsc.Implementation__c).Brand__c.toUpperCase());
                        s.Account__c = implMap.get(impEsc.Implementation__c).Account__c;
                       
                        s.Implementation_Escalation__c =  impEsc.id;
                        //s.Implementation__c = implMap.get(impEsc.Implementation__c).id;
                        
                        if(impEsc.Escalation_Owner__c != null){
                           s.OwnerId = userMap.get(impEsc.Escalation_Owner__c).id;
                           s.Agent__c = userMap.get(impEsc.Escalation_Owner__c).id;
                           s.Agent_Email__c = userMap.get(impEsc.Escalation_Owner__c).Email;
                           s.Agent_Name__c = userMap.get(impEsc.Escalation_Owner__c).Name;
                           s.Agent_Team__c = userMap.get(impEsc.Escalation_Owner__c).UserRole.Name;
                           s.Agent_Manager_Name__c = userMap.get(impEsc.Escalation_Owner__c).Manager.Name;
                           s.Agent_Manager_Email__c  = userMap.get(impEsc.Escalation_Owner__c).Manager.Email;
                                                    
                        }                       
                       /*else{ s.Agent__c = implMap.get(impEsc.Implementation__c).OwnerId;
                        s.Agent_Email__c = implMap.get(impEsc.Implementation__c).Owner.Email;
                        s.Agent_Name__c =implMap.get(impEsc.Implementation__c).Owner.Name;
                        s.Agent_Team__c = userMap.get(implMap.get(impEsc.Implementation__c).OwnerId).UserRole.Name;
                        s.Agent_Manager_Name__c = userMap.get(implMap.get(impEsc.Implementation__c).OwnerId).Manager.Name;
                        s.Agent_Manager_Email__c = userMap.get(implMap.get(impEsc.Implementation__c).OwnerId).Manager.Email;
                        }
                        */
                        
                        
                        s.Contact__c = implMap.get(impEsc.Implementation__c).Contact__c;
                        s.contact_email__c = implMap.get(impEsc.Implementation__c).Contact__r.Email;
                       //s.name = 'Escalation_'+SurveyType.get(implMap.get(impEsc.Implementation__c).Brand__c.toUpperCase());
                        s.name = 'Escalation Survey';
                        
                        insert s;
                        System.debug('-----------------------Survey Created----------------------------');
              }        
            
        }
     }
  }
}