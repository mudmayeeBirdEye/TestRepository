global class SyncPartnerAccountSharingBtn {
	global SyncPartnerAccountSharingBtn() {
		
	}
	
	webService static string sharePartnerAccount(string partnerId,string accountID) {
		try {
			set<String> setAccountId = new set<string>();
			set<string> parentAccountID = new set<String>();
			Set<ID> sUserOrGroupId = new Set<Id>(); // Create a set of UserOrGroup id
	   		Map<ID,ID> mapUserGroupRoleId = new Map<ID,ID>();
	  	 	List<Group> liGroup = new List<Group>();
	   		Set<Id> setRoleId = new Set<ID>();
	   		Map<String,UserRole> mapUserRole = new  Map<String,UserRole>();
	   		
			if(partnerId == null || partnerId == '') {
				return 'Partner Id is blank for current account.';  
			}
			
			List<Account> accDetail = [select recordtypeId,RecordType.Name from Account where Id = :accountID 
										and Partner_ID__c =:partnerId limit 1];
			if(accDetail != null && accDetail.size()>0 && accDetail[0].RecordType.Name == 'Partner Account') {
				setAccountId = setChildAccountDetail(partnerId,accountID);
				System.Debug('>>1144>>'+setAccountId);
				for(UserRole objUserRole:[SELECT PortalAccountId, Name,id,PortalRole FROM UserRole where PortalAccountId =:accountID]){
			 		if(objUserRole.PortalRole == 'Manager' || objUserRole.PortalRole == 'Executive'){
				  		setRoleId.add(objUserRole.id);
				  		mapUserRole.put(objUserRole.id,objUserRole);
				  	}
	     		}
	    	} else if(accDetail != null && accDetail.size()>0 && accDetail[0].RecordType.Name == 'Customer Account') {
				List<Account> accDetailPartner = [select id from Account where Partner_ID__c =:partnerId and recordType.Name = 'Partner Account' 
													limit 1];
				if(accDetailPartner != null && accDetailPartner.size()>0) {
					setAccountId.add(accountID);
					parentAccountID = ShareUtil.getParentAccountDetail(accDetailPartner[0].id);
					for(UserRole objUserRole:[SELECT PortalAccountId, Name,id,PortalRole FROM UserRole where PortalAccountId IN :parentAccountID]){
				 		if(objUserRole.PortalRole == 'Manager' || objUserRole.PortalRole == 'Executive'){
					  		setRoleId.add(objUserRole.id);
					  		mapUserRole.put(objUserRole.id,objUserRole);
					  	}
	     			}
				}
			}
			
			if(setRoleId == null || setRoleId.size() == 0) {
     			return 'Partner Account is not associated to any user with Partner Executive or Partner Manager Role.';
     		}
		  	
		  	liGroup = [Select id,RelatedId,Type from Group where RelatedId IN :setRoleId];
		  	for(Group objGroup: liGroup){
			  	if(objGroup.Type=='Role'){
			       sUserOrGroupId.add(objGroup.id);
			       mapUserGroupRoleId.put(objGroup.RelatedId,ObjGroup.Id);
			  	}  
		 	}
		 	
	 		List<AccountShare> liAccountShare=new List<AccountShare>();
	  		liAccountShare = [Select id from AccountShare where UserOrGroupId IN :sUserOrGroupId and AccountId IN: setAccountId]; 
	    	if(liAccountShare.size()>0){
	      		delete liAccountShare;
	    	}
	   		liAccountShare=new List<AccountShare>();
	   		string accountType = [select Partner_Type__c from Account where Id = :setAccountId limit 1].Partner_Type__c;    
	    	for(Id objAccID: setAccountId){
	    		for(String str:mapUserRole.keySet()){
	    	 		AccountShare  objAccountShare=new AccountShare();
		         	Id userOrGroupId= mapUserGroupRoleId.get(str);
		    	 	objAccountShare.UserOrGroupId= userOrGroupId;
		         	if(mapUserRole.get(str).PortalRole=='Manager'){
		         		if(accountType == 'Partner Express Agent') {
			         		objAccountShare.AccountAccessLevel='Read';
				            objAccountShare.ContactAccessLevel= 'Read';
				            objAccountShare.CaseAccessLevel= 'Read';
				            objAccountShare.OpportunityAccessLevel=  'Read';
		         		} else {
				            objAccountShare.AccountAccessLevel='Edit';
				            objAccountShare.ContactAccessLevel= 'Edit';
				            objAccountShare.CaseAccessLevel= 'Edit';
				            objAccountShare.OpportunityAccessLevel= 'Edit';
		         		}
		         	} else if(mapUserRole.get(str).PortalRole=='Executive'){
			         	objAccountShare.AccountAccessLevel='Read';
			         	objAccountShare.ContactAccessLevel= 'Read';
			            objAccountShare.CaseAccessLevel= 'Read';
			            objAccountShare.OpportunityAccessLevel= 'Read';
		         	}
		     		objAccountShare.AccountId=objAccID;
	           		liAccountShare.add(objAccountShare);
	    	 	}  
	      	}    
	   		if(liAccountShare.size()>0){
	   	 		insert liAccountShare;
	   		}
	   		return '' + setAccountId.size() +' Account(s) shared successfully.';   	
		} catch(Exception ex) {
			return 'Some exception occured.';
		}
		return null;
	}
	
	// For Partner Sharing
	public static Set<String> setChildAccountDetail(String strUserPartnerId,string accountId) {
 		RecordType  objRecordType1 = [SELECT id,Name FROM RecordType where Name='Partner Account']; 
	 	Set<String> setAccountId = new Set<String>();
	 	Map<id,Account> mapAccountDetail=new Map<id,Account>();
	 	string strQuery = '%' + (accountId.length()>15?accountId.substring(0,15):accountId)+ '%';
	 	System.Debug('>>33>>'+strQuery);
	 	mapAccountDetail = new Map<Id,Account>([SELECT id,Name,Parent_Detail__c,Number_of_DL_s__c,PartnerMrr__c,parentId,Partner_ID__c  
	 										from Account where  RecordTypeId=:objRecordType1.id and
	 										 ((parentId!=null and Parent_Detail__c Like :strQuery ) OR Partner_ID__c = :strUserPartnerId) order by Name]);
    
     	Set<String> setPartnerId=new Set<String>();   
     	Set<String> setCustomerId=new Set<String>();
     	/*Partner Account*/
     	for(ID objAccId:mapAccountDetail.keySet()){ 
     		setCustomerId.add(objAccId);
     		setAccountId.add(objAccId);
     		if(mapAccountDetail.get(objAccId).Partner_ID__c!=null) {
     	   		setPartnerId.add(mapAccountDetail.get(objAccId).Partner_ID__c);
     	 	}
     	}
         
   
       	RecordType objRecordType2 = [SELECT id,Name FROM RecordType where Name='Customer Account'];  
      	/*Child of Partner Account*/
       	for(Account objAcc:[Select id from Account where RecordTypeId=:objRecordType2.id and Partner_ID__c IN:setPartnerId]){
       	   String strId=objAcc.id;
       	   setCustomerId.add(strId.subString(0,15));
       	   setAccountId.add(objAcc.id);
       	}
       	
     
      	/*for child of customer account*/
       	for(Account objAccount:[Select id,Name,Number_of_DL_s__c,PartnerMrr__c,parentId,Partner_ID__c,RecordTypeId,Parent_Detail__c 
                             from Account where (parentId!=null and Ultimate_Parent_Account_ID__c IN:setCustomerId ) order by RecordType.Name desc]){
     		setAccountId.add(objAccount.id);
     	}
 		return setAccountId; 
    }
}