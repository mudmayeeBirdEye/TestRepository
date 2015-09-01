public class ShareUtil {

  public static Set<String> getParentAccountDetail(String strAccountID){
        Set<String> setAccountId=new set<String>();
        setAccountId.add(strAccountID);
        
        try{
        Account objAccount=[Select id,Parent_Detail__c from account where id=:strAccountID];
         if(objAccount.Parent_Detail__c!=null && objAccount.Parent_Detail__c!=''){
                 String strParentDetail=objAccount.Parent_Detail__c;
                 List<String> lst=strParentDetail.split(','); 
                   for(String objString:lst){
                         if(objString!=null && objString!=''){
                            List<String> lst2=objString.split('-');
                                if(lst2.size()==2){
                                setAccountId.add(lst2.get(1));
                           }
                         }
                   }
            }
        
        }catch(Exception e){}
          
        return setAccountId;
    }
   
   	public static void shareAccountToPartner(String objUserId,String strAccountId){
   	   	Map<id,UserRole> mapUserRole=new  Map<id,UserRole>();
   	   	List<AccountShare> liAccountShare=new List<AccountShare> ();
   		AccountShare  objAccountShare=new AccountShare();
   		string accountType = [select Contact.Account.Partner_Type__c from User where Id = :objUserId limit 1].Contact.Account.Partner_Type__c;
		List<AccountShare> liAccountShareDetail=[Select id from AccountShare where UserOrGroupId =:objUserId and   AccountId =: strAccountId]; 
        if(liAccountShareDetail.size()==0){
	        objAccountShare.UserOrGroupId=objUserId;
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
		    objAccountShare.AccountId=strAccountId;
		    liAccountShare.add(objAccountShare);
    	}
   	   	User objUserDetail = [Select id,Contact.AccountId,Contact.Account.Partner_id__c from User where Id=:objUserId];
   	   	String strUserAccountId = objUserDetail.Contact.AccountId;
   	   	Set<String> setRoleId = new Set<String>();
        Set<String> setAccount=getParentAccountDetail(strUserAccountId);
        for(UserRole objUserRole:[SELECT PortalAccountId, Name,id,PortalRole FROM UserRole where PortalAccountId IN :setAccount and 
        								(PortalRole='Manager' OR PortalRole='Executive')]){
            setRoleId.add(objUserRole.id);
            mapUserRole.put(objUserRole.id,objUserRole);
    	}
   	   	List<Group> liGroup=[Select id,RelatedId from Group where RelatedId IN :setRoleId and Type='Role'];
   	   	
   	   	for(Group objGroup:liGroup){
   	   	  	UserRole objUserRole=mapUserRole.get(objGroup.RelatedId);
   	   	  	objAccountShare=new AccountShare();
   	   	  	objAccountShare.UserOrGroupId=objGroup.id;
   	     	if(accountType == 'Partner Express Agent') { 
       	   	    objAccountShare.AccountAccessLevel='Read';
	            objAccountShare.ContactAccessLevel= 'Read';
	            objAccountShare.CaseAccessLevel= 'Read';
	            objAccountShare.OpportunityAccessLevel = 'Read';
   	   	 	} else {
         		if(objUserRole.PortalRole=='Manager'){
		   	   	    objAccountShare.AccountAccessLevel='Edit';
		            objAccountShare.ContactAccessLevel= 'Edit';
		            objAccountShare.CaseAccessLevel= 'Edit';
		            objAccountShare.OpportunityAccessLevel= 'Edit';
   	   	 		} else if(objUserRole.PortalRole=='Executive'){
		   	   	    objAccountShare.AccountAccessLevel='Read';
		         	objAccountShare.ContactAccessLevel= 'Read';
		            objAccountShare.CaseAccessLevel= 'Read';
		            objAccountShare.OpportunityAccessLevel= 'Read';
   	   	 		}
         	}
   	   	 	objAccountShare.AccountId=strAccountId;
   	   		liAccountShare.add(objAccountShare);
   	   	}
   	  	if(liAccountShare.size()>0){
   	 		insert liAccountShare;
   		} 
   	}
  	
  	/************* Sharing Rule Logic for Partner Lead Creation ************************/
  	public static void shareLeadToPartner(String leadId, String strUserId) {
 		List<LeadShare> liLeadShare = new List <LeadShare>();
     	LeadShare objLeadShare = new LeadShare();
     	Map<id,UserRole> mapUserRole = new Map<id,UserRole>();
		string accountType = [select Contact.Account.Partner_Type__c from User where Id = :strUserId limit 1].Contact.Account.Partner_Type__c;
     	List<LeadShare> liLeadShareDetail = [Select id from LeadShare where UserOrGroupId = : strUserId and LeadId = : leadId];
     	if(liLeadShareDetail.size() == 0) {
     		objLeadShare.UserOrGroupId = strUserId;
     		if(accountType == 'Partner Express Agent') {
     			objLeadShare.LeadAccessLevel = 'Read';
     		} else {
     			objLeadShare.LeadAccessLevel = 'Edit';
     		}
         	objLeadShare.LeadId = leadId;
         	liLeadShare.add(objLeadShare);
     	}
     
     	User objUserDetail = [Select id, Contact.AccountId, Contact.Account.Partner_id__c,Profile.Name from User where Id = : strUserId];
     	String strUserAccountId = objUserDetail.Contact.AccountId;
     	Set<String> setRoleId = new Set<String>();
     	Set<String> setAccount = getParentAccountDetail(strUserAccountId);
    	
    	for(UserRole objUserRole: [SELECT PortalAccountId, Name, id, PortalRole FROM UserRole where PortalAccountId IN: setAccount and 
 								(PortalRole = 'Manager' OR PortalRole = 'Executive')]) {
 			setRoleId.add(objUserRole.id);
     		mapUserRole.put(objUserRole.id,objUserRole);
 		}
 
     	List<Group> liGroup = [Select id, RelatedId from Group where RelatedId IN: setRoleId and Type = 'Role'];
     	
     	for(Group objGroup: liGroup) {
     		objLeadShare = new LeadShare();
         	objLeadShare.UserOrGroupId = objGroup.id;
     		if(accountType == 'Partner Express Agent') {
     			objLeadShare.LeadAccessLevel = 'Read';
	   		} else {
	         	if(mapUserRole.get(objGroup.RelatedId).PortalRole == 'Manager') {
	         		objLeadShare.LeadAccessLevel = 'Edit';
	         	} else {
	         		objLeadShare.LeadAccessLevel = 'Read';
	         	}
     		}
         	objLeadShare.LeadId = leadId;
         	liLeadShare.add(objLeadShare);
     	}
     	insert liLeadShare;
 	}
 	
 	/**********************************************************************************************************************************/
    
    /************* Sharing Rule Logic for Lead Qualification Creation by Partner for Partner Express leads ************************/
  	public static void shareLeadQualificationToPartner(String leadIdQualId, String strUserId) {
 		List<Lead_Qualification__Share> liLeadQualShare = new List <Lead_Qualification__Share>();
     	Lead_Qualification__Share objLeadQualShare = new Lead_Qualification__Share();
     	Map<id,UserRole> mapUserRole = new Map<id,UserRole>();

     	List<Lead_Qualification__Share> liLeadQualShareDetail = [Select id from Lead_Qualification__Share where 
     																UserOrGroupId = : strUserId and ParentID = : leadIdQualId];
     	if(liLeadQualShareDetail.size() == 0) {
     		objLeadQualShare.UserOrGroupId = strUserId;
         	objLeadQualShare.AccessLevel = 'Read';
         	objLeadQualShare.parentID = leadIdQualId;
         	liLeadQualShare.add(objLeadQualShare);
     	}
     
     	User objUserDetail = [Select id, Contact.AccountId, Contact.Account.Partner_id__c,Profile.Name from User where Id = : strUserId];
     	String strUserAccountId = objUserDetail.Contact.AccountId;
     	Set<String> setRoleId = new Set<String>();
     	Set<String> setAccount = getParentAccountDetail(strUserAccountId);
     
     	for(UserRole objUserRole: [SELECT PortalAccountId, Name, id, PortalRole FROM UserRole where PortalAccountId IN: setAccount and 
     								(PortalRole = 'Manager' OR PortalRole = 'Executive')]) {
     		setRoleId.add(objUserRole.id);
         	mapUserRole.put(objUserRole.id,objUserRole);
     	}

     	List <Group> liGroup = [Select id, RelatedId from Group where RelatedId IN: setRoleId and Type = 'Role'];
     	
     	for(Group objGroup: liGroup) {
     		objLeadQualShare = new Lead_Qualification__Share();
         	objLeadQualShare.UserOrGroupId = objGroup.id;
   			objLeadQualShare.AccessLevel = 'Read';
         	objLeadQualShare.ParentId = leadIdQualId;
         	liLeadQualShare.add(objLeadQualShare);
     	}
     	insert liLeadQualShare;
 	}
 	
 	/*****************************************************************************************************************/
  
   /************* new code added for Lead sharing, IF created or modified by SFDC user ****************/
 	public static String shareLeadToPartnerFromLeadTrigger(Map<String,String> mapNewPartnerLead,Map<String,String> mapOldPartnerLead, 
 															List<Lead> newLeadLst) {
 		String strMessage='';
 		try {
 	 		Map<String,List<Group>> mapUserGroupDetail = new  Map<String,List<Group>>();
	 		if(mapOldPartnerLead.size()>0){
 	 	 		mapUserGroupDetail = getUserGroupDetail(new Map<String,String>(),mapOldPartnerLead);
 	 	 		deleteLeadSharingRule(mapOldPartnerLead,mapUserGroupDetail);
	 	 	}
	 	  	mapAccountIDAndUSerId = new Map<String,String>();
	 	  	mapUserRole2 = new Map<id,UserRole>();
	 	  	mapUserGroupDetail = getUserGroupDetail(mapNewPartnerLead,new Map<String,String>()); 
	 		if(mapNewPartnerLead.size()>0){
	 	 		List<LeadShare> liLeadShare=new List<LeadShare> ();
	     		LeadShare objLeadShare=new LeadShare();
	     		Set<String> setLeadId=new Set<String>();
		 		Set<String> setPartnerOwnerId=new Set<String>();
		 		for(String str:mapNewPartnerLead.keySet()){
		 			setLeadId.add(str);
		 			setPartnerOwnerId.add(mapNewPartnerLead.get(str));
		  		}
		  		
		  		Set<String> setLeadCreatedByUserId = new Set<String>();
		  		for(Lead newLeadObj : newLeadLst) {
		  			setLeadCreatedByUserId.add(newLeadObj.createdById);
		  		}
		  		
		  		map<Id,User> mapUserProfile = new map<Id,User>([select Profile.Name, Contact.Account.Partner_Type__c 
		  															from User where Id IN :setPartnerOwnerId]);
		 		Map<String,String> mapExistingSharingRule= new Map<String,String>();
	 	 		for(LeadShare objLeadSha:[Select id, UserOrGroupId, LeadId from LeadShare where UserOrGroupId IN: setPartnerOwnerId 
	 	 									and LeadId IN : setLeadId]){
	 	 			mapExistingSharingRule.put(objLeadSha.UserOrGroupId,objLeadSha.LeadId);
	 	 		}
	 	
	 	 		for(String str:mapNewPartnerLead.keySet()){
	 		 		if(mapExistingSharingRule.get(mapNewPartnerLead.get(str))== null){
	 		   			objLeadShare.UserOrGroupId= mapNewPartnerLead.get(str);
	 		   			if(mapUserProfile != null && mapUserProfile.get(mapNewPartnerLead.get(str)) != null &&
	 		   				mapUserProfile.get(mapNewPartnerLead.get(str)).Contact.Account.Partner_Type__c == 'Partner Express Agent') {
	 		   				objLeadShare.LeadAccessLevel='Read';	
	 		   			} else {
	 		   				objLeadShare.LeadAccessLevel='Edit';
	 		   			}
		       			objLeadShare.LeadId=str;
	 		   			liLeadShare.add(objLeadShare);
	       			}
	 	   			if(mapUserGroupDetail.get(mapNewPartnerLead.get(str))!= null){
	 	   	   			for(Group objGroup:mapUserGroupDetail.get(mapNewPartnerLead.get(str))){
		 	   	   	   		objLeadShare=new LeadShare();
		               		objLeadShare.UserOrGroupId= objGroup.id;
		               		if(mapUserProfile != null && mapUserProfile.get(mapNewPartnerLead.get(str)) != null &&
	 		   					mapUserProfile.get(mapNewPartnerLead.get(str)).Contact.Account.Partner_Type__c == 'Partner Express Agent') {
		               				objLeadShare.LeadAccessLevel='Read';
		            			} else {
		               			if(mapUserRole2.get(objGroup.RelatedId).PortalRole == 'Manager') {
		             				objLeadShare.LeadAccessLevel = 'Edit';
		            			} else {
		            		 		objLeadShare.LeadAccessLevel = 'Read';
		            			}
		               		}
		                 	objLeadShare.LeadId=str;
			             	liLeadShare.add(objLeadShare);
	 	   	   			}
	 	   			}
	 			}
	 			if(liLeadShare.size()>0) {
	 				insert liLeadShare;
	 			}
	 		}
 	 		strMessage='Current lead is successfully synced with partner account(s).';
	 	} catch(Exception e){
	 		strMessage=e.getMessage();
	 	}
	 	return strMessage;	
 	}  
	
  	static Map<String,String> mapAccountIDAndUSerId=new Map<String,String>();
  	static Map<String,String> mapUserAccount=new Map<String,String>();
  	static Map<id,UserRole> mapUserRole2=new  Map<id,UserRole>();
   	public static Map<String,List<Group>> getUserGroupDetail(Map<String,String> mapNewPartnerLead,Map<String,String> mapOldPartnerLead){
 		Set<String> setPartnerOwnerId=new Set<String>();
     	Map<String,Set<String>> mapUserAccountId=new  Map<String,Set<String>>();
     	for(String str:mapNewPartnerLead.keySet()){
	   		setPartnerOwnerId.add(mapNewPartnerLead.get(str));
	 	}
	 	for(String str:mapOldPartnerLead.keySet()){
	 		setPartnerOwnerId.add(mapOldPartnerLead.get(str));
     	}
	 
     	List<User> lstUserDetail=getUserDetail(setPartnerOwnerId);
	
	
	 Set<String> setUserAccountId=new Set<String>();
	 for(User objUser:lstUserDetail){
	     mapAccountIDAndUSerId.put(get15DigitId(objUser.Contact.AccountId),objUser.id);
	     mapUserAccount.put(objUser.id,objUser.Contact.AccountId);
	 	 setUserAccountId.add(objUser.Contact.AccountId);
	 }
	  Set<String> setAccount=getMultipleParentAccountDetail(setUserAccountId);
	
	
	 Set<String> setRoleId=new Set<String>();
	 for(UserRole objUserRole:[SELECT PortalAccountId, Name,id,PortalRole FROM UserRole where PortalAccountId IN :setAccount and (PortalRole='Manager' OR PortalRole='Executive')]){
            setRoleId.add(objUserRole.id);
            mapUserRole2.put(objUserRole.id,objUserRole);
       }
	 
	 Map<String,List<Group>> mapUserGroupDetail=new Map<String,List<Group>>();
	  List<Group> liGroup=[Select id,RelatedId from Group where RelatedId IN :setRoleId and Type='Role'];
	  for(Group objGroup:[Select id,RelatedId from Group where RelatedId IN :setRoleId and Type='Role']){
	  if(mapUserRole2.get(objGroup.RelatedId).PortalRole!='User'){
	  	String strAccountID=mapUserRole2.get(objGroup.RelatedId)==null?null:mapUserRole2.get(objGroup.RelatedId).PortalAccountId;
	  	strAccountID=get15DigitId(strAccountID);
	  	if(strAccountID!=null && mapAccountIDAndUSerId.get(strAccountID)!=null){
	  		String strUserId=mapAccountIDAndUSerId.get(strAccountID);
	  		 if(mapUserGroupDetail.get(strUserId)==null){
	  		 	mapUserGroupDetail.put(strUserId,new List<Group>{objGroup});
	  		}else{
	  			mapUserGroupDetail.get(strUserId).add(objGroup);
	  		}
	  	}
      }
	  }
 	return mapUserGroupDetail;
 }
 
 public static List<User> getUserDetail(Set<String> setOwnerId){
 	return ([Select id,Contact.AccountId,Contact.Account.Partner_id__c from User where Id IN:setOwnerId]);
 	
 }
 
public static void deleteLeadSharingRule(Map<String,String> mapOldPartnerLead,Map<String,List<Group>> mapUserGroupDetail){
	Set<String> setLeadId=new Set<String>();
	Set<String> setPartnerOwnerId=new Set<String>();
	
	 for(String str:mapOldPartnerLead.keySet()){
	 	setLeadId.add(str);
	 	setPartnerOwnerId.add(mapOldPartnerLead.get(str));
	 	if(mapUserGroupDetail.get(mapOldPartnerLead.get(str))!=null){
	 		 for(Group objGroup:mapUserGroupDetail.get(mapOldPartnerLead.get(str))){
	 		 	setPartnerOwnerId.add(objGroup.id);
	 		 }
	 	}
	 }
	 
	 
	  List<LeadShare> liLeadShareDetail=[Select id from LeadShare where UserOrGroupId IN: setPartnerOwnerId and   LeadId IN : setLeadId];
	  if(liLeadShareDetail.size()>0){
	  	delete liLeadShareDetail;
	  }
	
}
 public static Set<String> getMultipleParentAccountDetail(Set<String> setAllAccount){
        Set<String> setAccountId=new set<String>();
        for(String str:setAllAccount){
        	setAccountId.add(str);
        }
     try{
        for(Account objAccount:[Select id,Parent_Detail__c from account where id IN :setAllAccount]){
         if(objAccount.Parent_Detail__c!=null && objAccount.Parent_Detail__c!=''){
                 String strParentDetail=objAccount.Parent_Detail__c;
                 List<String> lst=strParentDetail.split(','); 
                   for(String objString:lst){
                         if(objString!=null && objString!=''){
                            List<String> lst2=objString.split('-');
                                if(lst2.size()==2){
                                setAccountId.add(lst2.get(1));
                                String strUserId=mapAccountIDAndUSerId.get(get15DigitId(objAccount.id))!=null?mapAccountIDAndUSerId.get(get15DigitId(objAccount.id)):null;
                                 if(strUserId!=null){
	                                  	mapAccountIDAndUSerId.put(get15DigitId(lst2.get(1)),strUserId);
	                               }
                               }
                         }
                   }
            }
        }
        }catch(Exception e){}
          
        return setAccountId;
    }
     public static string get15DigitId(String strId){
    	return (strId.length()>15?strId.subString(0,15):strId);
    }
 /*End code added for Lead sharing, IF created by SFDC user*/
}