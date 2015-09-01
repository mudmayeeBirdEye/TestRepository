global class DealRegistrationSharingBatch implements  Database.Batchable<sObject> {
	map<Id,VAR_Deal_Registration__c> mapDealRegistration = new  map<Id,VAR_Deal_Registration__c>();
	map<Id,List<VAR_Deal_Registration__c>> mapUserToDealRegistration = new map<Id,List<VAR_Deal_Registration__c>>();
	global DealRegistrationSharingBatch() {
		mapDealRegistration = new map<Id,VAR_Deal_Registration__c>([select createdById, Partner_Account_Id__c,Partner_Id__c 
																	from VAR_Deal_Registration__c where Partner_Account_Id__c != null 
																	and Partner_Id__c != null 
																	order by createddate desc]);
		for(VAR_Deal_Registration__c vardealObj : mapDealRegistration.values()) {
			List<VAR_Deal_Registration__c> varDealRegList = new List<VAR_Deal_Registration__c>();
			if(mapUserToDealRegistration.get(vardealObj.createdById) != null) {
				varDealRegList = (mapUserToDealRegistration.get(vardealObj.createdById));
			}
			varDealRegList.add(vardealObj);
			mapUserToDealRegistration.put(vardealObj.createdById,varDealRegList);
		}
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		if(Test.isRunningTest()) {
			return Database.getQueryLocator('Select Contact.AccountId,Contact.Account.Partner_id__c,UserRoleId,UserRole.PortalRole from User where UserRoleId!=null and '+
                       	'UserRole.Name!=null and Contact.Account.Partner_id__c!=null and UserRole.PortalType=\'Partner\' and '+
                       	'(UserRole.PortalRole=\'Executive\' OR UserRole.PortalRole=\'Manager\') and Contact.Account.IsPartner=true limit 1');	
		} else {
			return Database.getQueryLocator('Select Contact.AccountId,Contact.Account.Partner_id__c,UserRoleId,UserRole.PortalRole from User where UserRoleId!=null and '+
			                           	'UserRole.Name!=null and Contact.Account.Partner_id__c!=null and UserRole.PortalType=\'Partner\' and '+
			                           	'(UserRole.PortalRole=\'Executive\' OR UserRole.PortalRole=\'Worker\' OR UserRole.PortalRole=\'Manager\') '+
			                           	' and Contact.Account.IsPartner=true order by Name '); //and Id IN (\'005S0000004DYGG\')
		}
		return null;
	}
	
	global void execute(Database.BatchableContext BC, List<sObject> scope) {
		User userObj = new User();
  		for(sObject objUsr : scope) {
       		userObj = ((User)objUsr);
       	}
       	set<string> setAccountId = new set<string>();
        Map<id,UserRole> mapUserRole = new Map<id,UserRole>();
		map<Id,List<UserRole>> mapAccountIdUserRole = new map<Id,List<UserRole>>();
		Set<ID> sUserOrGroupId = new Set<Id>();
    	Map<ID,ID> mapUserGroupRoleId = new Map<ID,ID>();
    	Set<String> setRoleId = new Set<String>();
       	setAccountId = ShareUtil.getParentAccountDetail(userObj.Contact.AccountId);
       	System.Debug('>>11>>'+ setAccountId);
       	
       	for(UserRole objUserRole :[SELECT PortalAccountId, Name,id,PortalRole FROM UserRole where PortalAccountId IN :setAccountId and 
        							(PortalRole='Manager' OR PortalRole='Executive')]){
            setRoleId.add(objUserRole.id);
            mapUserRole.put(objUserRole.id,objUserRole);
            List<UserRole> userRoleList = new List<UserRole>();
			if(mapAccountIdUserRole.get(objUserRole.PortalAccountId) != null) {
				userRoleList = mapAccountIdUserRole.get(objUserRole.PortalAccountId);
			}
			userRoleList.add(objUserRole);
			mapAccountIdUserRole.put(objUserRole.PortalAccountId,userRoleList);
        }
        
        System.Debug('>>22>>'+ mapAccountIdUserRole);
        
        List<Group> liGroup = [Select id,RelatedId,Type from Group where RelatedId IN :setRoleId and Type ='Role'];
       	for(Group objGroup: liGroup){
		  	if(objGroup.Type =='Role') {
		       sUserOrGroupId.add(objGroup.id);
		       mapUserGroupRoleId.put(objGroup.RelatedId,ObjGroup.Id);
		  	}  
	 	}
       	
       	List<VAR_Deal_Registration__Share> liDealRegistrationShare = new List<VAR_Deal_Registration__Share>();
     	set<Id> dealShareIdTODelete = new set<Id>();
     	set<Id> userOrGroupIdToDel = new set<Id>();
     	if(mapUserToDealRegistration != null && mapUserToDealRegistration.get(userObj.id) != null) {
     		for(VAR_Deal_Registration__c varDealRegistrationOnj : mapUserToDealRegistration.get(userObj.id)) {
     			for(string accountIDObj : setAccountId) {
     				if(mapAccountIdUserRole != null && mapAccountIdUserRole.get(accountIDObj) != null) {
     					for(UserRole userRoleObj : mapAccountIdUserRole.get(accountIDObj)){
			         		VAR_Deal_Registration__Share objdealRegistrationShare = new VAR_Deal_Registration__Share();
			             	objdealRegistrationShare.UserOrGroupId = mapUserGroupRoleId.get(userRoleObj.id);
			            	if(mapUserRole.get(userRoleObj.id).PortalRole == 'Manager'){
			             		objdealRegistrationShare.AccessLevel = 'Edit';
				            } else if(mapUserRole.get(userRoleObj.id).PortalRole == 'Executive') {
				            	objdealRegistrationShare.AccessLevel = 'Read';
				            }
			             	objdealRegistrationShare.ParentId = varDealRegistrationOnj.id;
			             	liDealRegistrationShare.add(objdealRegistrationShare);
			             	userOrGroupIdToDel.add(mapUserGroupRoleId.get(userRoleObj.id));
	        			}	
     				}
     			}
     			dealShareIdTODelete.add(varDealRegistrationOnj.id);
     		}	
     	}
        
        List<VAR_Deal_Registration__Share> liDealRegShare = new List<VAR_Deal_Registration__Share> ();
  		liDealRegShare = [Select id from VAR_Deal_Registration__Share where UserOrGroupId IN :userOrGroupIdToDel and parentid IN: dealShareIdTODelete]; 
    	if(liDealRegShare.size()>0) {
      		delete liDealRegShare;
    	}
        if(liDealRegistrationShare != null && liDealRegistrationShare.size()>0) {
        	insert liDealRegistrationShare;
        }
	}
	
	global void finish(Database.BatchableContext BC) {
		
	}
}