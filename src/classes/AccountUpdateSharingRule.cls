global class AccountUpdateSharingRule{

@future 
public static void deleteOldSharingRuleForAccount(Id AccountIds,String partnerid,Id recordTypeId){
   
     Set<Id> groupOruserid=new Set<Id>();
     Set<Id> setUserRoleId=new Set<Id>();
     Boolean isExist=false;
     
     try{
         for(User objUserold:[Select id,UserRole.Name,Contact.Account.RecordTypeId  from User where Contact.Account.Partner_ID__c=:partnerid
                              and Contact.Account.RecordTypeId=:recordTypeId and UserRole.PortalType='Partner' and
                               UserRole.PortalRole='Executive' and Contact.Account.IsPartner=true limit 1]){
         
          List<Id> liParentRoleId=new List<Id>();
          Boolean isParentAccountExist=true;//suppose  parent account exist 
          Id setAccountId;
          Id currentAccountId;
          List<Id> liAccountId=new List<Id>();
          List<Id> liUserRoleId=new List<Id>();
          Id parentAccount;
        
            currentAccountId=objUserold.Contact.Account.id;
                  //find out all parent accounts, if exist
            while(isParentAccountExist){
                      //fetch  parent account id
                             for(Account objaccount :[Select id,ParentId  from Account where id=:currentAccountId limit 1]){
                                     liAccountId.add(objAccount.id);
                                  if(objaccount.ParentId !=null){
                                          isParentAccountExist=true;
                                          currentAccountId =objaccount.ParentId;
                                   }else{
                                      isParentAccountExist=false;
                                }
                           }
                      }
            List<User> liPartnerUser=[Select Contact.Account.Partner_id__c,UserRoleId,UserRole.Name from User where UserRoleId!=null and
                                             UserRole.Name!=null and Contact.Account.Partner_id__c!=null and UserRole.PortalType='Partner' and
                                                 UserRole.PortalRole='Executive' and Contact.Account.IsPartner=true and Contact.Account.id IN :liAccountId];
                       
              For(User objPrtnerUser: liPartnerUser)
              {
                  setUserRoleId.add(objPrtnerUser.UserRoleId);
              }
   
         }    
     for(Group p:[Select id from group where RelatedId IN:setUserRoleId]){
                 groupOruserid.add(p.id);
                 isExist=true;
      }  
        
      List<AccountShare> liAccountShare=new List<AccountShare>();
      if(isExist==true ){
            liAccountShare =[Select id from AccountShare where UserOrGroupId IN :groupOruserid
                             and AccountId =: AccountIds];
       }
       
          if(!liAccountShare.isEmpty()){
              delete liAccountShare;
         }
     }catch(Exception e){}   
     
   }

  public static void deleteOldPrtnerSharingRuleForAccount(Id AccountIds,String partnerid,Id recordTypeId,Set<Id> groupOruserid){

          Set<Id> sAccountId=new Set<Id>();
          RecordType  objRecordType = [SELECT id,Name FROM RecordType where Name='Customer Account' ]; 
          List<Account> liAccount=new List<Account>();
           
        try{     
         liAccount= [Select id,Partner_Id__c from Account where Partner_id__c  =:partnerid 
                             and RecordTypeId=:objRecordType.id ];
                  
         if(liAccount.size()>0){
                For(Account objAccount:  liAccount){
                         sAccountId.add(objAccount.id);
                      }
           
             List<AccountShare> liAccountShare=new List<AccountShare>();         
          
            liAccountShare =[Select id from AccountShare where UserOrGroupId IN :groupOruserid
                             and AccountId IN : sAccountId];
       
       
         if(!liAccountShare.isEmpty()){
              delete liAccountShare;
          }
     }  
   } catch(Exception e){}
    
  }
}