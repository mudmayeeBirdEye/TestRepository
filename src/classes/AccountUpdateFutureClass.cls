global class AccountUpdateFutureClass{

 @future 
 public static void updateAccountAndContact(Id userId) {
  
     if(userId!=null){
         for(User objUser:[Select Contact.Account.Partner_ID__c,Contact.Account.RecordTypeId  from User where id=:userId limit 1]){ 
             RecordType  objRecordType = [SELECT name FROM RecordType Where  id=:objUser.Contact.Account.RecordTypeId ]; 
              
              if(objRecordType.name=='Partner Account'){ 
                     String strPartnerId=objUser.Contact.Account.Partner_ID__c;
                     List<Account> liAccount=new List<Account>();
                     List<Contact> liContact=new List<Contact>();  
                     List<Contact> liUpdatedContact=new List<Contact>(); 
                     List<Account> liUpdatedAccount=new List<Account>(); 
                     
                    Set<Id> liAccountId=new Set<Id>();
                
                     objRecordType = [SELECT id FROM RecordType Where  name='Customer Account' ]; 
                     liAccount =[Select id,ownerId from Account where Partner_ID__c=:strPartnerId and RecordTypeId=:objRecordType.id ];
                     for(Account objAccount:liAccount ){
                           liAccountId.add(objAccount.id);  
                      }
                   if(liAccount.size()>0 ){
                        liContact=[Select id,ownerId from Contact where AccountId IN : liAccountId ];
                        if(liContact.size()>0){
                           for(Contact objContact:liContact ){
                               objContact.ownerId=userId;
                               liUpdatedContact.add(objContact);
                           }
                           
                        update liUpdatedContact;
                       }
                        for(Account objUpdatedAccount:liAccount ){
                               objUpdatedAccount.ownerId=userId;
                               liUpdatedAccount.add(objUpdatedAccount);
                        }
                      update liUpdatedAccount;
                     }
     
                }}}
  }
}