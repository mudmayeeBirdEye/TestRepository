trigger Partner_Account_before on Account (before update) {
/*
    As a requirement for the partner portal, partners need to be able to see their customer accounts and contacts.
    To enable this,Account Record must be shared with Partner portal user . The triggers below are delete the old sharing rule 
    record if customer partner account id is changed
   
*/

	if(TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT || TriggerHandler.BY_PASS_ACCOUNT_ON_UPDATE || TriggerHandler.BY_PASS_PARTNER_ACCOUNT_ON_BEFORE){
		System.debug('### RETURNED FROM PARTNER ACCOUNT BEFORE ###');
		return;
	} else {
		TriggerHandler.BY_PASS_PARTNER_ACCOUNT_ON_BEFORE = true;
		System.debug('### STILL CONTINUE FROM PARTNER ACCOUNT BEFORE ###');
	}

RecordType objRecordType = [SELECT id,Name FROM RecordType where Name='Customer Account' ]; 
if(trigger.isUpdate){
       //if partner id is  changed in customer account then delete the sharing rule with customer accounts (associated with old partner id)
  try{
    Integer i=0;
     for(Account objAccount:trigger.new){
        //RecordType objRecordType = [SELECT Name FROM RecordType Where  Id =: objAccount.RecordTypeId ];
          if(trigger.old[i].Partner_ID__c!=null && trigger.old[i].Partner_ID__c !=objAccount.Partner_ID__c && objAccount.RecordTypeId == objRecordType.id){
               objRecordType = [SELECT id,Name FROM RecordType where Name='Partner Account' ]; 
 
                  AccountUpdateSharingRule.deleteOldSharingRuleForAccount(objAccount.id,trigger.old[i].Partner_ID__c,objRecordType.id); 
              
              } else  if(trigger.old[i].Partner_ID__c!=null && trigger.old[i].Partner_ID__c !=objAccount.Partner_ID__c && 
                            objRecordType.Name == 'Partner Account'){
                        
                          //if partner id is  changed in partner account then delete the sharing rule with customer accounts (associated with old partner id)
                    
                    objRecordType = [SELECT id,Name FROM RecordType where Name='Partner Account' ]; 
                    Set<Id> groupOruserid=new Set<Id>();
                   for(User objUserold:[Select id,UserRole.Name,Contact.Account.RecordTypeId  from User where Contact.Account.Partner_ID__c=:trigger.old[i].Partner_ID__c
                                        and Contact.Account.RecordTypeId=:objRecordType.id and UserRole.PortalType='Partner' and
                                        UserRole.PortalRole='Executive' and Contact.Account.IsPartner=true and Contact.Account.id=:objAccount.id limit 1]){
           
                    for(Group p:[Select id from group where RelatedId=:objUserold.UserRoleId ]){
                                 groupOruserid.add(p.id);
                 
                        }  
                     }
                  AccountUpdateSharingRule.deleteOldPrtnerSharingRuleForAccount(objAccount.id,trigger.old[i].Partner_ID__c,objRecordType.id,groupOruserid); 
              
              }
              i++;
           }

   }catch(Exception e){}
}

}