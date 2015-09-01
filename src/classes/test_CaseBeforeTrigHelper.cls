@istest
Public Class test_CaseBeforeTrigHelper{

    Public Static testmethod Void DoCoverage(){
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
      	User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
      	EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      	LocaleSidKey='en_US', ProfileId = p.Id, 
      	TimeZoneSidKey='America/Los_Angeles', UserName='standarduser121@testorg.com');
        insert u;
        System.runAs(u){
        	RecordType rTypeObject = new RecordType();
            List<RecordType> rtList = new List<RecordType>([SELECT  Name,Id, DeveloperName, SobjectType  FROM RecordType where name=:'Porting - In' and SobjectType='case' limit 1]);
            Map<id,Case> CaseMap = new Map<id,Case>();
	        Schema.DescribeSObjectResult result = Case.SObjectType.getDescribe();
	        Map<ID,Schema.RecordTypeInfo> rtMapByName = result.getRecordTypeInfosById();
	        Map<string,Schema.RecordTypeInfo> rtMapById = result.getRecordTypeInfosByName();
	        Profile prof = [SELECT Name FROM Profile WHERE Id = :UserInfo.getProfileId() LIMIT 1 ];
	        Map<String,SupportRecordType__c> SupportRecordTypeMap = SupportRecordType__c.getAll();
	        if(SupportRecordTypeMap.size() == 0){
		    	CaseBeforeTrigHelper.CustomSupportRecordType();
		    	SupportRecordTypeMap = SupportRecordType__c.getAll();
		    }
            
            if(rtList.size() > 0){
                rTypeObject = rtList[0];
            
        	Map<id,user> mapuser = new Map<id,user>();
            mapuser.put(u.id,u);
        	List<Case> CaseList = new List<Case>();
            Case caseObjectTest=new Case();
			caseObjectTest.Description = 'myPlainText';
			caseObjectTest.Priority = 'Low';
			caseObjectTest.Origin = 'Email';
			caseObjectTest.Status = 'New';
			caseObjectTest.SuppliedEmail ='rcindia@simplion.com';
			caseObjectTest.SuppliedPhone ='1234567890';
			caseObjectTest.SuppliedName ='Test Name';
			caseObjectTest.Subject = 'Test Subject';
			caseObjectTest.RecordTypeid=rTypeObject.id;
			caseObjectTest.Ops_ReAssig__c = 1;
			caseObjectTest.OwnerID = u.Id;
			//insert caseObjectTest;
			CaseList.add(caseObjectTest);
			
            system.debug('rTypeObject.id------->'+rTypeObject.id);
            Case caseObjectTest1=new Case();
			caseObjectTest1.Description = 'myPlainText';
			caseObjectTest1.Priority = 'Low';
			caseObjectTest1.Origin = 'Email';
			caseObjectTest1.Status = 'WIP';
			caseObjectTest1.SuppliedEmail ='rcindia@simplion.com';
			caseObjectTest1.SuppliedPhone ='1234567890';
			caseObjectTest1.SuppliedName ='Test Name';
			caseObjectTest1.Subject = 'Test Subject';
			caseObjectTest1.RecordTypeid=rTypeObject.id;
			caseObjectTest1.OwnerID = u.Id;
			caseObjectTest1.Ops_ReAssig__c = 1;
			//insert caseObjectTest1;
        	CaseList.add(caseObjectTest1);
        //CaseList.add(caseObjectTest);
        insert CaseList;
       OpsAssignmentRules__c objOpsAssignmentRules  = new OpsAssignmentRules__c(User__c = u.Id, AssignToUser__c =  u.Id);
       	insert objOpsAssignmentRules;
       
        system.debug('rtMapByName.get(caseObj.RecordTypeId).getName()------->'+rtMapByName.get(rTypeObject.id).getName());
        CaseMap.put(CaseList[0].id,CaseList[0]);
        List<Profile> ProfileList = [SELECT id , name  FROM Profile WHERE name =: 'System Administrator'
                                                      OR name =: 'Support Agent - T1'];
    	/*  Creating a Map to Access id by Profile Name, We can add the name in the Query and can directly use this map */
    	Map<String,Profile> ProfileMap = new Map<String,Profile>(); 
        for(Profile pro  :ProfileList){
            ProfileMap.put(pro.name , pro);
        } 
        Map<string,Id> groupMapBussUnit = new Map<string,Id>();
        List<Group> groupBussList = [SELECT id,Name FROM GROUP WHERE Type = 'Queue'];
        for(Group gp : groupBussList) {
            groupMapBussUnit.put(gp.Name,gp.Id);    
        }
       
        Account accObj = new Account(Name='Simplion', Partner_ID__c='Test12322');
        insert accObj;
        Map<id,Account> mapToCaseAccount = new Map<id,Account>(); 
        mapToCaseAccount.put(accObj.id,accObj);
        List<id> triggerNewIds = new List<id>();
        triggerNewIds.add(CaseList[0].id);
        List<Account> AccList = new List<Account>(); 
        AccList.add(accObj);  
        Boolean isMedallia = (Medallia_Credentials__c.getInstance('Medallia') != null && Medallia_Credentials__c.getInstance('Medallia').isMedallia__c) ? true : false;
        CaseBeforeTrigHelper cbth = new CaseBeforeTrigHelper();
        CaseBeforeTrigHelper.CustomSupportRecordType();
        CaseBeforeTrigHelper.SupportCaseOwnerChange(CaseList,CaseMap,rtMapByName,prof,CaseList[0],SupportRecordTypeMap);
        CaseBeforeTrigHelper.SupportCaseOwnerChangeCheck(CaseMap,CaseList[0],CaseList[1]);
        CaseBeforeTrigHelper.EscalateToSupportTier1(CaseList,mapuser,CaseMap,ProfileMap);
        CaseBeforeTrigHelper.IsUpdateOpsTicketingCase(CaseList,rtMapByName,groupMapBussUnit,CaseMap);
        CaseBeforeTrigHelper.medalliaSurvey(CaseList,CaseMap,rtMapByName,triggerNewIds,mapUser,isMedallia,SupportRecordTypeMap);
        CaseBeforeTrigHelper.PortingOut(CaseList,mapToCaseAccount,rtMapByName);
        CaseBeforeTrigHelper.PortingOutCloseCase(CaseList,CaseMap,rtMapByName,mapToCaseAccount);
        CaseBeforeTrigHelper.InsertCaseShare(CaseList,mapuser,CaseMap);
        CaseList[0].RecordTypeid = rtMapById.get('Internal OPS to OPS').getRecordTypeId();
        CaseList[0].OPS_Last_Action__c = 'Recall';
        CaseList[0].Assign_To__c = 'Business Unit';
        CaseList[0].OPS_Last_Action__c = 'Closed';
        CaseList[0].Ops_Bussiness_Units__c = 'Done';
        //update CaseList[0];
        CaseBeforeTrigHelper.IsUpdateOpsTicketingCase(CaseList,rtMapByName,groupMapBussUnit,CaseMap);
        
        CaseList[0].Assign_To__c = 'Business Unit';
        CaseBeforeTrigHelper.IsUpdateOpsTicketingCase(CaseList,rtMapByName,groupMapBussUnit,CaseMap);
        
        CaseList[0].Assigned_OPS_User__c = null;
        CaseList[0].OPS_Last_Action__c = 'Take Assignment';
        CaseList[1].Assign_To__c = 'User';
        CaseList[1].Assigned_OPS_User__c =  u.Id;
        CaseBeforeTrigHelper.IsUpdateOpsTicketingCase(CaseList,rtMapByName,groupMapBussUnit,CaseMap);
        CaseList[0].OPS_Last_Action__c = 'Complete';
        CaseList[0].Porting_First_Submit_Date__c = system.today();
        CaseList[0].Porting_First_Reject_Reason__c = null;
        CaseBeforeTrigHelper.medalliaSurvey(CaseList,CaseMap,rtMapByName,triggerNewIds,mapUser,isMedallia,SupportRecordTypeMap);
        
        CaseList[0].Porting_RC_Review_Reject_Reason__c = null;
        CaseList[0].Porting_RC_Review__c = 'Rejected';
        CaseList[0].Porting_Reject_Reason__c = 'LEC request COB';
        CaseBeforeTrigHelper.medalliaSurvey(CaseList,CaseMap,rtMapByName,triggerNewIds,mapUser,isMedallia,SupportRecordTypeMap);
         
    	}
        }

}
}