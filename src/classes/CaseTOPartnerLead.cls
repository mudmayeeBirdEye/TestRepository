public with sharing class CaseTOPartnerLead {
public String caseId{get;set;}
public Boolean isErrorOccured{get;set;}
public Boolean isShowMessage{get;set;}
string userLouisMastrangelo;
public CaseTOPartnerLead(ApexPages.standardController objCont){
	caseId=ApexPages.currentPage().getParameters().get('id');
     if(caseId==null || caseId==''){
		isErrorOccured=true;
	}else{
	  isErrorOccured=false;
	}
	isShowMessage=false;
	Default_Partner_Owner__c dfltPartOwner = Default_Partner_Owner__c.getOrgDefaults();
    if(dfltPartOwner != null ) {
    	userLouisMastrangelo = dfltPartOwner.UserId__c;
    }
    System.Debug('>>>userLouisMastrangelo>>'+ userLouisMastrangelo); 
	
}
public String strMessage{get;set;}
public pagereference createPartnerLead(){
	strMessage='';
	try{
	    isShowMessage=true;    
		RecordType objRecordType=[SELECT id,Name FROM RecordType where SobjectType='Lead' and Name='Partner Leads' limit 1];
		Case objCase=[Select id ,Partner_Lead_FirstName__c,Partner_Lead_LastName__c,Partner_Lead_Title__c,Partner_Lead_Company__c,
			               Partner_Lead_Email__c,Partner_Lead_Phone__c,Partner_Lead_Source__c,Lead_Partner_ID__c,Partner_Lead_Owner__c 
		                	,Partner_Lead_Website__c,NumberOfEmployees__c,Number_of_Locations__c,Partner_Industry__c,Partner_Lead_Description__c,
		                	Number_of_Users__c,Partner_Tier__c,Partner_Country__c,Partner_State_Province__c,Partner_City__c,
		                	Partner_Lead_Source_Custom__c, Partner_Brand__c,(Select Id From Lead_Qualifications__r),
			                Partner_How_did_you_acquire_this_Lead__c,Partner_Estimated_Close_Date__c, Partner_Lead_Phone_Alternate__c 
			                FROM Case where id=:caseId];
	
	if(objCase.Partner_Lead_Owner__c!=null){
		 User objUserDetail=[Select id,Contact.Account.Current_Owner__c ,Contact.Account.Inside_Sales_Rep__c from User 
				                      where id=:objCase.Partner_Lead_Owner__c];
		  
		               
		 Lead objLead=new Lead(); 
		        
		 objLead.FirstName=objCase.Partner_Lead_FirstName__c;
		 objLead.LastName=objCase.Partner_Lead_LastName__c;
		 objLead.Title=objCase.Partner_Lead_Title__c;
		 objLead.Company=objCase.Partner_Lead_Company__c;
		 objLead.Email=objCase.Partner_Lead_Email__c;
		 objLead.Phone=objCase.Partner_Lead_Phone__c;
		 objLead.leadSource='Partner';
		 //objLead.leadSource=objCase.Partner_Lead_Source__c;
		 //objLead.Partner_Source__c=objCase.Partner_Source__c;
		 objLead.RecordTypeId=objRecordType.id; 
		 objLead.LeadPartnerID__c=objCase.Lead_Partner_ID__c;
		 objLead.Partner_Lead_Owner__c=objCase.Partner_Lead_Owner__c;
	    
	    objLead.Website= objCase.Partner_Lead_Website__c;
        objLead.NumberOfEmployees__c=objCase.NumberOfEmployees__c;
        objLead.Number_of_Locations__c=objCase.Number_of_Locations__c;
        objLead.industry=objCase.Partner_Industry__c;
        objLead.Description=objCase.Partner_Lead_Description__c;
        objLead.Number_of_Users__c=objCase.Number_of_Users__c;
        objLead.Lead_Brand_Name__c = objCase.Partner_Brand__c ;
         objLead.Lead_Tier_Name__c = objCase.Partner_Tier__c ;
         objLead.Country__c = objCase.Partner_Country__c ;
         objLead.Country = objCase.Partner_Country__c ;
         objLead.State__c = objCase.Partner_State_Province__c ;
         objLead.State = objCase.Partner_State_Province__c ;
         objLead.City__c = objCase.Partner_City__c ;
         objLead.City = objCase.Partner_City__c ;
         //objLead.Partner_Lead_Source__c = objCase.Partner_Lead_Source_Custom__c ;
         objLead.Estimated_Close_Date__c = objCase.Partner_Estimated_Close_Date__c ;
         objLead.How_did_you_acquire_this_Lead__c = objCase.Partner_How_did_you_acquire_this_Lead__c ;
         objLead.Phone_Alternate__c = objCase.Partner_Lead_Phone_Alternate__c;
	     /*if(objUserDetail.Contact.Account.Inside_Sales_Rep__c != null) {
		 	objLead.OwnerId = objUserDetail.Contact.Account.Inside_Sales_Rep__c;
 		 } else if(objUserDetail.Contact.Account.Current_Owner__c != null) {
                        objLead.OwnerId = objUserDetail.Contact.Account.Current_Owner__c;
  		 } else {
        	Group groupObj = getPartnerQueue();
        	if(groupObj !=null) {
        		objLead.OwnerId = groupObj.Id;
        	}
         }*/
     	system.debug('>>12345>>>>' + objUserDetail.Contact.Account.Current_Owner__c);
     	if(!String.isBlank(objUserDetail.Contact.Account.Current_Owner__c)) {
    		objLead.OwnerId = objUserDetail.Contact.Account.Current_Owner__c;
		} else {
        	objLead.OwnerId = userLouisMastrangelo;
    	}
    	if(objUserDetail.Contact.Account.Inside_Sales_Rep__c != null) {
        	objLead.Inside_Sales_Rep__c = objUserDetail.Contact.Account.Inside_Sales_Rep__c;
    	}
		 insert objLead; 
		 ShareUtil.shareLeadToPartner(objLead.id,objUserDetail.id);
		 if(objCase.Lead_Qualifications__r != null && objCase.Lead_Qualifications__r.size() == 1) {
	 		string leadQualId = objCase.Lead_Qualifications__r[0].id;
	 		Lead_Qualification__c leadQualObj = new Lead_Qualification__c(id = leadQualId);
	 		leadQualObj.lead__c = objLead.id;
	 		leadQualObj.Case__c = null;
	 		update leadQualObj;
	 		ShareUtil.shareLeadQualificationToPartner(leadQualObj.id, objUserDetail.id); 
	 	 }
		 strMessage=strMessage+'Lead successfully created.Please click <a href=/'+objLead.id+' >here</a> to see the lead details';
	     objCase.status='Closed';
	     TriggerHandler.BY_PASS_CASE_ON_INSERT = true;
	     TriggerHandler.BY_PASS_CASE_ON_UPDATE = true;
	     upsert objCase;
	     TriggerHandler.BY_PASS_CASE_ON_INSERT = false;
	     TriggerHandler.BY_PASS_CASE_ON_UPDATE = false;
		}else{
			strMessage='Partner Lead Owner Detail is not found.';
		} 
	   }catch(DMLException em){
        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, em.getDmlMessage(0)));
        	return null;
	   }catch(Exception e){
		strMessage=e.getMessage()+' Line Number:'+e.getLineNumber();
	}
	return null;
	}
 	private Group getPartnerQueue() {
        return [SELECT id,Name FROM Group WHERE Type='Queue' AND Name='Partner Lead Reviewer' LIMIT 1];
    }

}