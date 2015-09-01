global class syncPartnerAccountUpdateSharingRule implements  Database.Batchable<sObject> {
 
global syncPartnerAccountUpdateSharingRule () {
	
}
public Set<String> setChildAccountDetail(String strUserPartnerId,string accountId){
     RecordType  objRecordType1 = [SELECT id,Name FROM RecordType where Name='Partner Account' ]; 
	 Set<String> setAccountId=new Set<String>();
	 Map<id,Account>  mapAccountDetail=new Map<id,Account>();
	 string strQuery = '%' + (accountId.length()>15?accountId.substring(0,15):accountId)+ '%';
	 System.Debug('>>33>>'+strQuery);
	 mapAccountDetail = new Map<Id,Account>([SELECT id,Name,Parent_Detail__c,Number_of_DL_s__c,PartnerMrr__c,parentId,Partner_ID__c  
	 										from Account where  RecordTypeId=:objRecordType1.id and
	 										 ((parentId!=null and Parent_Detail__c Like :strQuery) OR Partner_ID__c = :strUserPartnerId) order by Name]);
    
     Set<String> setPartnerId=new Set<String>();   
     Set<String> setCustomerId=new Set<String>();
     /*Partner Account*/
     for(ID objAccId:mapAccountDetail.keySet()){ 
     	setCustomerId.add(objAccId);
     	setAccountId.add(objAccId); 
     	if(mapAccountDetail.get(objAccId).Partner_ID__c!=null){
     	   setPartnerId.add(mapAccountDetail.get(objAccId).Partner_ID__c);
     	 }
     }
         
   
       RecordType objRecordType2 = [SELECT id,Name FROM RecordType where Name='Customer Account' ];  
      /*Child of Partner Account*/
       for(Account objAcc:[Select id from Account where RecordTypeId=:objRecordType2.id and Partner_ID__c IN:setPartnerId]){
       	   String strId=objAcc.id;
       	   setCustomerId.add(strId.subString(0,15));
       	   setAccountId.add(objAcc.id);
       	}
       	
      /*List<Set<String>> lasAccountId=new list<Set<String>>();
	  Boolean isStart=false;
	  Set<String> setAcc=new  Set<String>();
	  for(String strId:setCustomerId){
	    if(setAcc.size()<100){
		   setAcc.add(strId);
		   isStart=true;
		}else{
		    setAcc.add(strId);
		    lasAccountId.add(setAcc);
			setAcc=new  Set<String>();
			isStart=false;
		}
	   }
	   if(isStart){
	     lasAccountId.add(setAcc);
	   }
	   setAcc=new  Set<String>();
       */	
     // for(Set<String>setCustomerId1 :lasAccountId){
      /*for child of customer account*/
       for(Account objAccount:[Select id,Name,Number_of_DL_s__c,PartnerMrr__c,parentId,Partner_ID__c,RecordTypeId,Parent_Detail__c 
                             from Account where (parentId!=null and Ultimate_Parent_Account_ID__c IN:setCustomerId ) order by RecordType.Name desc]){
             setAccountId.add(objAccount.id);
     	}
      //}	
     	return setAccountId; 
    }
	global Database.QueryLocator start(Database.BatchableContext BC){
		if(Test.isRunningTest()) {
			return Database.getQueryLocator('Select Contact.Account.Partner_id__c,UserRoleId,UserRole.PortalRole from User where UserRoleId!=null and '+
                       	'UserRole.Name!=null and Contact.Account.Partner_id__c!=null and UserRole.PortalType=\'Partner\' and '+
                       	'(UserRole.PortalRole=\'Executive\' OR UserRole.PortalRole=\'Manager\') and Contact.Account.IsPartner=true limit 1');	
		} else {
			 Map<String,String> mapUserAccount=new Map<String,String>();
			 Set<String> setUserId=new Set<String>();
			  for(User objUser:Database.query('Select Contact.Account.Partner_id__c,UserRoleId,UserRole.PortalRole,Contact.AccountId from User where UserRoleId!=null and '+
			                               	  'UserRole.Name!=null and Contact.Account.Partner_id__c!=null and UserRole.PortalType=\'Partner\' and '+
			                           	      '(UserRole.PortalRole=\'Executive\' OR UserRole.PortalRole=\'Manager\') and Contact.Account.IsPartner=true order by Name ')){
			  	 if(mapUserAccount.get(objUser.Contact.AccountId)==null){
			  	 	mapUserAccount.put(objUser.Contact.AccountId,objUser.id);
			  	 	setUserId.add(objUser.id);
			  	 }
			  	
			  }
			return Database.getQueryLocator('Select Contact.Account.Partner_id__c,UserRoleId,UserRole.PortalRole,Contact.AccountId, Contact.Account.Partner_Type__c from User where UserRoleId!=null and '+
			                           	'UserRole.Name!=null and Contact.Account.Partner_id__c!=null and UserRole.PortalType=\'Partner\' and '+
			                           	'(UserRole.PortalRole=\'Executive\' OR UserRole.PortalRole=\'Manager\') and Contact.Account.IsPartner=true and ID IN :setUserId order by Name ');
		}
		return null;
	}

	global void execute(Database.BatchableContext BC, List<sObject> scope){
      
       User objUser=new User();
       for(sObject objUsr : scope) {
       	  objUser=(User)objUsr;
        }
   
  Set<String> setAccountId=setChildAccountDetail(objUser.Contact.Account.Partner_id__c,objUser.Contact.AccountId); 
 
   Set<ID> sUserOrGroupId=new Set<Id>();//Create a set of UserOrGroup id
   Map<ID,ID> mapUserGroupRoleId=new Map<ID,ID>();
   List<Group> liGroup=new List<Group>();
   Set<Id> setRoleId=new Set<ID>();
   Map<String,UserRole> mapUserRole=new  Map<String,UserRole>();
   
    for(UserRole objUserRole:[SELECT PortalAccountId, Name,id,PortalRole FROM UserRole where PortalAccountId=:objUser.Contact.AccountId]){
	 if(objUserRole.PortalRole=='Manager' || objUserRole.PortalRole=='Executive'){
	  setRoleId.add(objUserRole.id);
	  mapUserRole.put(objUserRole.id,objUserRole);
	  }
     }
	  liGroup=[Select id,RelatedId,Type from Group where RelatedId IN :setRoleId ];
	  for(Group objGroup: liGroup){
	  	if(objGroup.Type=='Role'){
	       sUserOrGroupId.add(objGroup.id);
	       mapUserGroupRoleId.put(objGroup.RelatedId,ObjGroup.Id);
	  	}  
	 }
 
 
 List<AccountShare> liAccountShare=new List<AccountShare> ();
  liAccountShare=[Select id from AccountShare where UserOrGroupId IN :sUserOrGroupId and   AccountId IN: setAccountId]; 
    if(liAccountShare.size()>0){
      delete liAccountShare;
    }
    
   	liAccountShare=new List<AccountShare> ();
   	string accountType = [select Partner_Type__c from Account where Id = :objUser.Contact.AccountId limit 1].Partner_Type__c;        
    for(Id objAccID: setAccountId) {
		for(String str : mapUserRole.keySet()){
	 		AccountShare  objAccountShare=new AccountShare();
         	Id userOrGroupId= mapUserGroupRoleId.get(str);
    	 	objAccountShare.UserOrGroupId= userOrGroupId;
         	if(mapUserRole.get(str).PortalRole=='Manager'){
         		if(accountType == 'Partner Express Agent') {
	         		objAccountShare.AccountAccessLevel='Read';
		            objAccountShare.ContactAccessLevel= 'Read';
		            objAccountShare.CaseAccessLevel= 'Read';
		            objAccountShare.OpportunityAccessLevel= 'Read';
         		} else {
		            objAccountShare.AccountAccessLevel='Edit';
		            objAccountShare.ContactAccessLevel= 'Edit';
		            objAccountShare.CaseAccessLevel= 'Edit';
		            objAccountShare.OpportunityAccessLevel= 'Edit';
         		}
         	}else if(mapUserRole.get(str).PortalRole=='Executive'){
	         	objAccountShare.AccountAccessLevel='Read';
	         	objAccountShare.ContactAccessLevel= 'Read';
	            objAccountShare.CaseAccessLevel= 'Read';
	            objAccountShare.OpportunityAccessLevel= 'Read';
         	}else{
         	//objAccountShare.AccountAccessLevel='None';
         	}
     		objAccountShare.AccountId=objAccID;
           	liAccountShare.add(objAccountShare);
 		}  
  	}    
   	if(liAccountShare.size()>0){
   	 	insert liAccountShare;
   	}    
  	}      

public void createTree(Map<Id,List<Account>> nextMapPass,String strId,String strUserPartnerId){
	
}
global void finish(Database.BatchableContext BC){
	
}

}