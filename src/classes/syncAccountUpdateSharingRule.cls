global class syncAccountUpdateSharingRule{
	static List<String> lstUserRolePortalRole = new List<String>{'Executive', 'Manager', 'Worker'};
	webService static String syncLeadToPartnerAccount(String objLeadId,String strLeadOwnerId) {
   	   String strMessage='';
   	   Lead objLead=[Select Partner_Lead_Owner__c,id,Ultimate_Parent_Account_ID__c,Ultimate_Parent_Account_Name__c,Ultimate_Parent_Account_Partner_ID__c from Lead where id=:objLeadId];                   
   	   strLeadOwnerId=objLead.Partner_Lead_Owner__c;
   	  strMessage=''+objLead;
   	  if(strLeadOwnerId==null || strLeadOwnerId==''){
   	  	strMessage='Partner Lead Owner field could not be blank!';
   	  }else{
   	   Map<String,String> mapPartnerLead= new Map<String,String>();
   	   Map<String,String> mapOldPartnerLead= new Map<String,String>();
   	  
   	    User objUserDetail=[Select id,Contact.AccountId,Contact.Account.Partner_id__c,Contact.Account.Signup_Link__c ,Contact.Account.Name, Contact.Account.Inside_Sales_Rep__c, 
   	                         Contact.Account.Current_Owner__c,Contact.Account.Current_Owner_Name__c
                            ,Contact.Account.Ultimate_Parent_Account_ID__c 
                            FROM User where Id=:strLeadOwnerId];
         
        
         Account objParentAccount=[Select id,Partner_id__c,Name,Ultimate_Parent_Account_ID__c from Account where id=:objUserDetail.Contact.Account.Ultimate_Parent_Account_ID__c];                   
   	    objLead.Ultimate_Parent_Account_ID__c=objParentAccount.Ultimate_Parent_Account_ID__c;
   	    objLead.Ultimate_Parent_Account_Name__c=objParentAccount.Name;
   	    objLead.Ultimate_Parent_Account_Partner_ID__c=objParentAccount.Partner_id__c;
   	    objLead.Partner_Account_Name__c = objUserDetail.Contact.Account.Name;
   	    objLead.Current_Owner_Name__c = objUserDetail.Contact.Account.Current_Owner_Name__c;
   	    update objLead;
   	  
   	     mapPartnerLead.put(objLeadId,strLeadOwnerId);
   	     List<Lead> leadList = new List<Lead>();
   	     leadList.add(new Lead(Id = objLeadId));
   	    //Set<String> setMessage=ShareUtil.shareLeadToPartnerFromLeadTrigger(mapPartnerLead,mapOldPartnerLead);
   	     strMessage=ShareUtil.shareLeadToPartnerFromLeadTrigger(mapPartnerLead,mapOldPartnerLead,leadList);  
   	    //strMessage='Message:Lead shared with:'+setMessage;
   	  }  
   	   return strMessage;
   }
    
    webService static String updateSingleAccountSharingRule(Id accountId) {
       
      List<User> liUser=[Select Contact.Account.Partner_id__c,UserRoleId,UserRole.Name from User where UserRoleId!=null and
                         UserRole.Name!=null and Contact.Account.Partner_id__c!=null and UserRole.PortalType='Partner' and
                        UserRole.PortalRole=:lstUserRolePortalRole and Contact.Account.IsPartner=true and Contact.Account.id=:accountId];
    
     String strMessage =insertSharingRule(liUser);
     return strMessage ;
    }

    public static String massUpdateSharingRule() {
        
        List<User> liUser=[Select Contact.Account.Partner_id__c,UserRoleId from User where UserRoleId!=null and
                           UserRole.Name!=null and Contact.Account.Partner_id__c!=null and UserRole.PortalType='Partner' and
                           UserRole.PortalRole=:lstUserRolePortalRole and Contact.Account.IsPartner=true ];
        
         String strMessage =insertSharingRule(liUser);
         return strMessage ;
    }

  private static  String insertSharingRule(List<User> liUser){
     
     Boolean isSuccess=true;
     String strMessage='';
   
     try{
             Set<String> sPartnerIds=new  Set<String>();//Create a set of partner ids
             Set<Id> sUserRoleId=new  Set<Id>();//Create a set of UserRole ids
             
              Map<String,List<ID>> mapPartnerIdUSerRole=new Map<String,List<ID>>() ;//Create a map of partner id and   user role id
             
             Set<ID> sAccountId=new Set<Id>();//Create Set of Account id
             Set<ID> sUserOrGroupId=new Set<Id>();//Create a set of UserOrGroup id
             
             Map<ID,ID> mapUserGroupRoleId=new Map<ID,ID>();//Create a map of userRole id and UserGroup Id
             Integer iCustomerAccountCout=0;
            
             if(liUser.size()>0){
                   RecordType  objRecordType1 = [SELECT id,Name FROM RecordType where Name='Partner Account' ]; 
                   Map<Id,Account> mapAccount=new Map<Id,Account>([select Id, ParentId, Name from Account where RecordTypeId=:objRecordType1.id order by Name]);
                   Map<Id,User> mapUser=new Map<Id,User>();
                   
                   for(User objPartnerUser:[Select Contact.Account.Partner_id__c,UserRoleId,UserRole.Name,Contact.Account.id from User where UserRoleId!=null and
                                             UserRole.Name!=null and Contact.Account.Partner_id__c!=null and UserRole.PortalType='Partner' and
                                                 UserRole.PortalRole=:lstUserRolePortalRole and Contact.Account.IsPartner=true]){
                             mapUser.put(objPartnerUser.Contact.Account.id,objPartnerUser);                      
                                                   
                       }
                      
            
            
                   For(User objUser: liUser)
                    {
                        sPartnerIds.add(objUser.Contact.Account.Partner_Id__c);
                        sUserRoleId.add(objUser.UserRoleId);
                       
                       List<Id> liParentRoleId=new List<Id>();
                       Boolean isExist=true;//suppose  parent account exist 
                       Id setAccountId;
                       Id currentAccountId;
                       List<Id> liAccountId=new List<Id>();
                       List<Id> liUserRoleId=new List<Id>();
                       Id parentAccount;
                       currentAccountId=objUser.Contact.Account.id;
                       
                  //find out all parent accounts, if exist
                  Integer i=0;//to check  infinite loop
                      while(isExist && i<10){
                                //fetch  parent account id
                                  Account objAccount=new Account();
                                  try{
                                      objAccount=mapAccount.get(currentAccountId);
                                    }catch(Exception e){
                                       objAccount=null;
                                       isExist=false;
                                    }
                                        
                                      // for(Account objaccount :[Select id,ParentId  from Account where id=:currentAccountId limit 1]){
                                       if(objAccount!=null){
                                           liAccountId.add(objAccount.id);
                                            if(objaccount.ParentId !=null){
                                                    isExist=true;
                                                    currentAccountId =objaccount.ParentId;
                                             }else{
                                                isExist=false;
                                          }
                                       }
                                    // }
                               i++;
                                }
                                           
                       /*  List<User> liPartnerUser=[Select Contact.Account.Partner_id__c,UserRoleId,UserRole.Name from User where UserRoleId!=null and
                                             UserRole.Name!=null and Contact.Account.Partner_id__c!=null and UserRole.PortalType='Partner' and
                                                 UserRole.PortalRole='Executive' and Contact.Account.IsPartner=true and Contact.Account.id IN :liAccountId]; */
                       
                       // For(User objPrtnerUser: liPartnerUser)
                   // {
                        for(Id objId:liAccountId){
                           try{  
                            if(mapUser!=null && mapUser.get(objId)!=null){
                               User objPrtnerUser=new User();
                               objPrtnerUser=mapUser.get(objId);
                                   sUserRoleId.add(objPrtnerUser.UserRoleId);
                                   liUserRoleId.add(objPrtnerUser.UserRoleId);
                                }
                        }catch(Exception e){}
                      }
                       
                        
                        //mapPartnerIdUSerRole.put(objUser.Contact.Account.Partner_Id__c,objUser.UserRoleId);
                         mapPartnerIdUSerRole.put(objUser.Contact.Account.Partner_Id__c,liUserRoleId);
                    }
                //System.debug('##############################'+sPartnerIds);
                 List<Account> liAccount=new List<Account>();//Create a list of customer account with  associated partner id (partner id is not null)
                
                 RecordType  objRecordType = [SELECT id,Name FROM RecordType where Name='Customer Account' ]; 
                 liAccount= [Select id,Partner_Id__c from Account where Partner_id__c  IN :  sPartnerIds 
                             and RecordTypeId=:objRecordType.id ];
                  
                  if(liAccount.size()>0){
                       For(Account objAccount:  liAccount){
                               sAccountId.add(objAccount.id);
                           }
                          iCustomerAccountCout =liAccount.size();
                           List<Group> liGroup=new List<Group>();
                           liGroup=[Select id,RelatedId from Group where RelatedId IN : sUserRoleId];
        
                            for(Group objGroup: liGroup){
                                 sUserOrGroupId.add(objGroup.id);
                                 mapUserGroupRoleId.put(objGroup.RelatedId,ObjGroup.Id);
                            }
        
                            List<AccountShare> liAccountShare=new List<AccountShare> ();
        
                            liAccountShare=[Select id from AccountShare where UserOrGroupId IN : sUserOrGroupId and   AccountId IN: sAccountId];
                           
                            if(liAccountShare.size()>0){
                                delete liAccountShare;
                            }
                            //OLD sharing recrods have been deleted in above step
        
                            //Logic to re-create sharing records
                            liAccountShare=new List<AccountShare> ();
        
                            try{
                                  for(Account objAccount: liAccount){
                                        for(Id objId:mapPartnerIdUSerRole.get(objAccount.Partner_id__c)){
                                                AccountShare  objAccountShare=new AccountShare();
                                                Id userOrGroupId= mapUserGroupRoleId.get(objId);
                
                                                objAccountShare.UserOrGroupId= userOrGroupId;
                                                objAccountShare.ContactAccessLevel= 'Read';
                                                objAccountShare.CaseAccessLevel= 'Read';
                                                objAccountShare.AccountAccessLevel='Read';
                                                objAccountShare.OpportunityAccessLevel= 'None';
                                                objAccountShare.AccountId=objAccount.id;
                                         
                                         liAccountShare.add(objAccountShare);
                                    }
                                  }
                                    if(liAccountShare.size()>0){
                                         insert liAccountShare;
                                    }else{
                                        strMessage='No customer account is shared';
                                        return strMessage;
                                    }
                             }catch(Exception e){
                               strMessage=''+e.getMessage();
                               return strMessage;
                           }
                   }else{
                   strMessage='No customers are found with this partner account.';
                   return strMessage;
                  }
                }else{
                 strMessage='This account user is not associated with Partner Executive or Manager or User Role';
                 return strMessage;
              }
              strMessage = iCustomerAccountCout+' ' +'Customer'+ ((iCustomerAccountCout > 1) ? ' Accounts are ' : ' Account is ') +'shared successfully';            
       }catch(Exception e){
           strMessage=''+e.getMessage();
       }
       
     return strMessage;
  }



}