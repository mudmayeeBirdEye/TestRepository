/**************************************************************************************************
* Project Name..........: Case Before                                                             *
* File..................: CaseBeforeTrigHelper.class                                       		  *
* Salesforce.com API....: 27.0                                                                    *
* Created by............: Simplion Technologies                                                   *
* Created Date..........: 2/6/2014 11:00 PM                                                       *
* Last Modified by......: Simplion Technologies                                                   *
* Last Modified Date....: 6/11/2014 11:00 PM                                                      *
* Description...........: This is a Helper Class for Trigger CaseBefore contains many functionality 
						  of Case Before.                                                          *
**************************************************************************************************/


public  class CaseBeforeTrigHelper {
	
	private static final String SYSTEM_ADMINISTRATOR = 'System Administrator';
	private static final String Support_Agent_T1 = 'Support Agent - T1';
	private static final string IT_HELP_DESK = 'IT Helpdesk';
	
	
	public Static Void CustomSupportRecordType(){
		
		SupportRecordType__c PortingPhone = new SupportRecordType__c(Name = 'Porting - Phone',medalliaSurvey__c = true,SupportCaseOwnerChange__c = false);
    	SupportRecordType__c SupportChat = new SupportRecordType__c(Name = 'Support - Chat',medalliaSurvey__c = true,SupportCaseOwnerChange__c = true);
    	SupportRecordType__c SupportCustomerCompliance = new SupportRecordType__c(Name = 'Support - Customer Compliance',medalliaSurvey__c = false,SupportCaseOwnerChange__c = true);
    	SupportRecordType__c SupportCV = new SupportRecordType__c(Name = 'Support - CV',medalliaSurvey__c = false,SupportCaseOwnerChange__c = true);
    	SupportRecordType__c SupportEmail = new SupportRecordType__c(Name = 'Support - Email',medalliaSurvey__c = true,SupportCaseOwnerChange__c = true);
    	SupportRecordType__c SupportEngineering = new SupportRecordType__c(Name = 'Support - Engineering',medalliaSurvey__c = false,SupportCaseOwnerChange__c = true);
    	SupportRecordType__c SupportFaxBroadcast = new SupportRecordType__c(Name = 'Support - Fax Broadcast',medalliaSurvey__c = false,SupportCaseOwnerChange__c = true);
    	SupportRecordType__c SupportFeedBack = new SupportRecordType__c(Name = 'Support - FeedBack',medalliaSurvey__c = false,SupportCaseOwnerChange__c = true);
    	SupportRecordType__c SupportFraudInvestigation = new SupportRecordType__c(Name = 'Support - Fraud Investigation',medalliaSurvey__c = false,SupportCaseOwnerChange__c = true);
    	SupportRecordType__c SupportManager = new SupportRecordType__c(Name = 'Support - Manager',medalliaSurvey__c = true,SupportCaseOwnerChange__c = true);
    	SupportRecordType__c SupportMobile = new SupportRecordType__c(Name = 'Support - Mobile',medalliaSurvey__c = true,SupportCaseOwnerChange__c = false);
    	SupportRecordType__c SupportOfflineCase = new SupportRecordType__c(Name = 'Support - Offline Case',medalliaSurvey__c = false,SupportCaseOwnerChange__c = true);
    	SupportRecordType__c SupportShippingRecRMA = new SupportRecordType__c(Name = 'Support - Shipping/Rec/RMA',medalliaSurvey__c = false,SupportCaseOwnerChange__c = true);
    	SupportRecordType__c SupportSnap = new SupportRecordType__c(Name = 'Support - Snap',medalliaSurvey__c = false,SupportCaseOwnerChange__c = true);
    	SupportRecordType__c SupportSystemOps = new SupportRecordType__c(Name = 'Support - System Ops',medalliaSurvey__c = false,SupportCaseOwnerChange__c = true);
    	SupportRecordType__c SupportT1 = new SupportRecordType__c(Name = 'Support - T1',medalliaSurvey__c = true,SupportCaseOwnerChange__c = true);
    	SupportRecordType__c SupportT1VARPartners = new SupportRecordType__c(Name = 'Support - T1 (VAR & Partners)',medalliaSurvey__c = true,SupportCaseOwnerChange__c = false);
    	SupportRecordType__c SupportT2 = new SupportRecordType__c(Name = 'Support - T2',medalliaSurvey__c = true,SupportCaseOwnerChange__c = true);
    	SupportRecordType__c SupportT3 = new SupportRecordType__c(Name = 'Support - T3',medalliaSurvey__c = true,SupportCaseOwnerChange__c = true);
    	SupportRecordType__c SupportTechAssist = new SupportRecordType__c(Name = 'Support - Tech Assist',medalliaSurvey__c = false,SupportCaseOwnerChange__c = true);
    	SupportRecordType__c SupportTelecomOps = new SupportRecordType__c(Name = 'Support - Telecom (Ops)',medalliaSurvey__c = false,SupportCaseOwnerChange__c = true);
    	SupportRecordType__c SupportVIPFR = new SupportRecordType__c(Name = 'Support - VIPFR',medalliaSurvey__c = true,SupportCaseOwnerChange__c = false);
    	SupportRecordType__c SupportIAInbound = new SupportRecordType__c(Name = 'Support – IA Inbound',medalliaSurvey__c = false,SupportCaseOwnerChange__c = false);
    	SupportRecordType__c SupportCase = new SupportRecordType__c(Name = 'Support-Case',medalliaSurvey__c = false,SupportCaseOwnerChange__c = false);
    	SupportRecordType__c PortingIn = new SupportRecordType__c(Name = 'Porting - In',medalliaSurvey__c = false,SupportCaseOwnerChange__c = false,MedalliaSurveyiCount__c = true);
    	SupportRecordType__c PortingNeuStar = new SupportRecordType__c(Name = 'Porting - In (NeuStar)',medalliaSurvey__c = false,SupportCaseOwnerChange__c = false,MedalliaSurveyiCount__c = true);
    	SupportRecordType__c PortingRCUK = new SupportRecordType__c(Name = 'Porting - In (RC UK)',medalliaSurvey__c = false,SupportCaseOwnerChange__c = false,MedalliaSurveyiCount__c = true);
    	SupportRecordType__c PortingInTELUS = new SupportRecordType__c(Name = 'Porting - In (TELUS)',medalliaSurvey__c = false,SupportCaseOwnerChange__c = false,MedalliaSurveyiCount__c = true);
    	SupportRecordType__c PortingVanity = new SupportRecordType__c(Name = 'Porting - Vanity',medalliaSurvey__c = false,SupportCaseOwnerChange__c = false,MedalliaSurveyiCount__c = true);
    	
    	List<SupportRecordType__c> supportRecordList = new List<SupportRecordType__c>(); 
    	supportRecordList.add(PortingPhone);
    	supportRecordList.add(SupportChat);
    	supportRecordList.add(SupportCustomerCompliance);
    	supportRecordList.add(SupportCV);
    	supportRecordList.add(SupportEmail);
    	supportRecordList.add(SupportEngineering);
    	supportRecordList.add(SupportFaxBroadcast);
    	supportRecordList.add(SupportFeedBack);
    	supportRecordList.add(SupportFraudInvestigation);
    	supportRecordList.add(SupportManager);
    	supportRecordList.add(SupportMobile);
    	supportRecordList.add(SupportOfflineCase);
    	supportRecordList.add(SupportShippingRecRMA);
    	supportRecordList.add(SupportSnap);
    	supportRecordList.add(SupportSystemOps);
    	supportRecordList.add(SupportT1);
    	supportRecordList.add(SupportT1VARPartners);
    	supportRecordList.add(SupportT2);
    	supportRecordList.add(SupportT3);
    	supportRecordList.add(SupportTechAssist);
    	supportRecordList.add(SupportTelecomOps);
    	supportRecordList.add(SupportVIPFR);
    	supportRecordList.add(SupportIAInbound);
    	supportRecordList.add(PortingIn);
    	supportRecordList.add(PortingNeuStar);
    	supportRecordList.add(PortingRCUK);
    	supportRecordList.add(PortingInTELUS);
    	supportRecordList.add(SupportCase);
    	supportRecordList.add(PortingVanity);
		insert supportRecordList;
	}
	
	/************ Method For Case Owner change of Support Starts **************************************
	* @Description -                                     											  *
	* @Author      - Simplion Technologies                                                            * 
	**************************************************************************************************/
	
	public static void SupportCaseOwnerChange(List<Case> NewCase, Map<id,Case> OldCaseMap,Map<ID,Schema.RecordTypeInfo> rtMapByName,
	                                         Profile prof , Case FirstRecordCaseNew , Map<String,SupportRecordType__c> SupportRecordTypeMap ){      
	    System.debug('====NewCase===='+NewCase);
	    System.debug('====OldCaseMap===='+OldCaseMap);
	    System.debug('====rtMapByName===='+rtMapByName);
	    System.debug('====prof===='+prof);
	    System.debug('====FirstRecordCaseNew===='+FirstRecordCaseNew);
	    System.debug('====SupportRecordTypeMap===='+SupportRecordTypeMap);
		try{
			System.debug('====NewCase===='+NewCase);
			for(Case caseObj:NewCase) {
				System.debug('====caseObj===='+caseObj);
				System.debug('====SupportRecordTypeMap.get(rtMapByName.get(caseObj.RecordTypeId ).getName()).SupportCaseOwnerChange__c====' +SupportRecordTypeMap.get(rtMapByName.get(caseObj.RecordTypeId ).getName()).SupportCaseOwnerChange__c);
         		if(SupportRecordTypeMap != null && SupportRecordTypeMap.get(rtMapByName.get(caseObj.RecordTypeId).getName()) != null
	                && SupportRecordTypeMap.get(rtMapByName.get(caseObj.RecordTypeId ).getName()).SupportCaseOwnerChange__c == true) {
	                System.debug('====Entering====');
					if(prof != null && prof.Name != SYSTEM_ADMINISTRATOR) {
                        String oldId = OldCaseMap.get(caseObj.id).OwnerId; 
                        String newId = FirstRecordCaseNew.OwnerId;
                		System.debug('=======userinfo.getuserId()====='+userinfo.getuserId()+ '==caseObj.OwnerId==>' + caseObj.OwnerId);
                        if(userinfo.getuserId() != caseObj.OwnerId && ( oldId.startsWith('00G'))){// || oldId.startsWith('005') || oldId.startsWith('500'))) 
                            if(SupportCaseOwnerChangeCheck(OldCaseMap,FirstRecordCaseNew,caseObj)) {
                                  caseObj.OwnerId = Userinfo.getUserId();
                            }
                     	}  
	                }
                }
        	}
	    } catch(Exception e){GetException(e);}
	 }
	 
	 Public Static Boolean SupportCaseOwnerChangeCheck(Map<id,Case> OldCaseMap , Case FirstRecordCaseNew , Case caseObj){
	 	if(OldCaseMap.get(caseObj.id) != null && (OldCaseMap.get(caseObj.id).Status != caseObj.Status
	                                      ||OldCaseMap.get(caseObj.id).AccountId != caseObj.AccountId 
	                                      ||OldCaseMap.get(caseObj.id).ContactId != caseObj.ContactId
	                                      ||OldCaseMap.get(caseObj.id).Priority != caseObj.Priority
										/* When a user escalates a case, the owner and the recordtype should change.*/
	                                      ||OldCaseMap.get(caseObj.id).Subject != caseObj.Subject
	                                      ||OldCaseMap.get(caseObj.id).Description != caseObj.Description
	                                      ||OldCaseMap.get(caseObj.id).Support_Disposition_Level_1__c != caseObj.Support_Disposition_Level_1__c
	                                      ||OldCaseMap.get(caseObj.id).Support_Jira__c != caseObj.Support_Jira__c
	                                      ||OldCaseMap.get(caseObj.id).Support_RC911_Contact__c != caseObj.Support_RC911_Contact__c
	                                      ||OldCaseMap.get(caseObj.id).Support_Ops_Need_More_Info__c != caseObj.Support_Ops_Need_More_Info__c
	                                      ||OldCaseMap.get(caseObj.id).Support_Chat_Required_Callback__c != caseObj.Support_Chat_Required_Callback__c)){
	     	return true;                                 
	     }else{
	     	return false;
	     }
	 }
	
	/************ Method For Case Escalate to Support Tier1 Starts **************************************
	* @Description -                                     											    *
	* @Author      - Simplion Technologies                                                              * 
	*****************************************************************************************************/
	
	Public Static void EscalateToSupportTier1(List<Case> NewCaseList,Map<id,User> mapUser,Map<id,Case> OldCaseMap,Map<String,Profile> ProfileMap){
		
		Id SupportAgentT1  ; 
		if(ProfileMap != null && ProfileMap.get(Support_Agent_T1)!= null){
			SupportAgentT1 = ProfileMap.get(Support_Agent_T1).id;
		}
		try{
			for(Case caseObj : NewCaseList){
				if(mapUser != null && mapUser.get(caseObj.CreatedById) != null && caseObj.ownerid != caseObj.createdByid) {  
	            	User usr = mapUser.get(caseObj.CreatedById);
		            if(OldCaseMap.get(caseObj.id).Support_Escalate_To__c != 'Tier 1' && caseObj.Support_Escalate_To__c == 'Tier 1' 
		                && caseObj.Support_Tier_1_Esc_Count__c >= 1 && SupportAgentT1 != null &&
		                              usr.ProfileId == SupportAgentT1 && usr.IsActive == true) { 
		                system.debug(OldCaseMap.get(caseObj.id).Support_Escalate_To__c +'-------------'
		                   +caseObj.Support_Escalate_To__c  +'--------------'
		                   +caseObj.Support_Tier_1_Esc_Count__c+'----------'
		                   +usr.ProfileId +'------------'
		                   +usr.IsActive);     
		                caseObj.ownerid = caseObj.createdByid;         
		            }   
	             }
	        }
		}catch(Exception e){GetException(e);}
    }
    
    /************************Method For OpsTicketing Case on Update *************************************
	* @Description -                                     											    *
	* @Author      - Simplion Technologies                                                              * 
	*****************************************************************************************************/
    
    Public Static void IsUpdateOpsTicketingCase(List<Case> NewCaseList,Map<ID,Schema.RecordTypeInfo> rtMapByName
                                               ,Map<string,Id> groupMapBussUnit,Map<id,case> OldCaseMap){
                          
        Set<Id> caseOwnerId = new Set<Id>();
        for(Case caseObj : NewCaseList){
        	if(caseObj.OwnerId != null) {
            	caseOwnerId.add(caseObj.OwnerId);  
            }
            caseOwnerId.add(UserInfo.getUserId());
        }
        
        map<Id,Group> groupMapDet = new map<Id,Group>() ; 
    	map<Id,User> userMapDet = new map<Id,User>() ; 
    	map<Id,Id> opsAssignRuleMap =  new map<Id,Id>() ; 
    	List<OpsAssignmentRules__c> OpsAsgnmentRuleList ;
    	
    	if(caseOwnerId != null && caseOwnerId.size()>0) {
    		
	        groupMapDet = new map<Id,Group>([SELECT Email,Name FROM Group WHERE id IN :caseOwnerId AND type='Queue']);
	        userMapDet = new map<Id,User>([SELECT Email,Name FROM User WHERE id IN :caseOwnerId]);
	        OpsAsgnmentRuleList = [SELECT id,User__c,AssignToUser__c FROM OpsAssignmentRules__c WHERE 
	                               AssignToUser__c IN :caseOwnerId AND User__c IN :caseOwnerId];
	        if(OpsAsgnmentRuleList.size() > 0){
		        for(OpsAssignmentRules__c opsAssignedObj : OpsAsgnmentRuleList) {  // Created list for direct query in for loop
		            if(opsAssignedObj.AssignToUser__c == opsAssignedObj.User__c) {
		                opsAssignRuleMap.put(opsAssignedObj.AssignToUser__c,opsAssignedObj.Id);
		            }       
		        }
	        }  
        }
    	 system.debug('opsAssignRuleMap--->'+opsAssignRuleMap);	 
    	try {
	        for(Case caseObj:NewCaseList) {
	        	
	            if(rtMapByName.get(caseObj.RecordTypeId ).getName() == 'Internal OPS to OPS' && caseObj.OPS_Last_Action__c != 'Error') {
	                String strRecallstatus='No';
	                if( caseObj.OPS_Last_Action__c != null && caseObj.OPS_Last_Action__c.equalsIgnoreCase('Recall')) {
	                    strRecallstatus = 'Yes';
	                }
	                if(caseObj.Assign_To__c != null && caseObj.Assign_To__c.equalsIgnoreCase('Business Unit') && strRecallstatus.equalsIgnoreCase('No')) { 
	                    if(caseObj.OPS_Last_Action__c != null && !(caseObj.OPS_Last_Action__c.equalsIgnoreCase('Cancel') ||
	                       caseObj.OPS_Last_Action__c.equalsIgnoreCase('Closed'))) {
	                            caseObj.OPS_Last_Action__c=''; 
	                    }
	                    caseObj.Assigned_OPS_User__c = null;
	                    if(groupMapBussUnit != null && caseObj.Ops_Bussiness_Units__c != null) {
	                        string bussUnit = 'OPS '+ caseObj.Ops_Bussiness_Units__c;
	                        if(groupMapBussUnit.get(bussUnit) != null) {
	                            caseObj.ownerid = groupMapBussUnit.get(bussUnit);
	                            if(OldCaseMap.get(caseObj.id).Ops_ReAssig__c == caseObj.Ops_ReAssig__c && caseObj.Ops_ReAssig__c != null 
	                               && caseObj.OPS_Last_Action__c == null) {
	                               		caseObj.Ops_ReAssig__c = caseObj.Ops_ReAssig__c + 1;
	                            } 
	                            if(caseObj.status!=null && !caseObj.status.equalsIgnoreCase('Cancelled')) { 
	                                caseObj.status='New'; 
	                            }
	                        }
	                    }
				}else if(caseObj.Assign_To__c != null && caseObj.Assign_To__c.equalsIgnoreCase('User') && caseObj.Assigned_OPS_User__c != null 
	                         && strRecallstatus.equalsIgnoreCase('No')) {
					if(caseObj.OPS_Last_Action__c != null && !(caseObj.OPS_Last_Action__c.equalsIgnoreCase('Cancel') ||
					   caseObj.OPS_Last_Action__c.equalsIgnoreCase('Closed'))) {
					   		caseObj.OPS_Last_Action__c=''; 
					}
					if(OldCaseMap.get(caseObj.id).Ops_ReAssig__c == caseObj.Ops_ReAssig__c && caseObj.Ops_ReAssig__c != null &&  
					   caseObj.OPS_Last_Action__c == null) {
					   		caseObj.Ops_ReAssig__c=caseObj.Ops_ReAssig__c+1;
					}             
				}else if(caseObj.Assign_To__c != null && caseObj.Assign_To__c.equalsIgnoreCase('User') && caseObj.Assigned_OPS_User__c == null 
	                         && strRecallstatus.equalsIgnoreCase('No') && caseObj.OPS_Last_Action__c =='Take Assignment') {
					if(opsAssignRuleMap != null && caseObj.ownerid != null && opsAssignRuleMap.get(caseObj.ownerid) != null) {
					    caseObj.Assigned_OPS_User__c = opsAssignRuleMap.get(caseObj.ownerid);
					    system.Debug('>>caseObj.Assigned_OPS_User__c>>'+caseObj.Assigned_OPS_User__c);
					}
				}else if(caseObj.OPS_Last_Action__c == 'Recall') {
	                	   /***********************************************************************
	                	    *	Functionality -   Sends a mail to the previous owner              *
	                	    *   Author        -   Simplion Technology                             *
	                	    **********************************************************************/
	                	
					try {
					    String strTo;
					    String strName;
					    String strFromUser;
					    strFromUser = UserInfo.getUserName();
					    if(caseObj.ownerid != null && String.valueOf(caseObj.ownerid).startsWith('00G') && groupMapDet != null
					        && groupMapDet.get(caseObj.ownerid) != null) {
					        Group objGroup = groupMapDet.get(caseObj.ownerid);
					        strTo=objGroup.Email;
					        strName=objGroup.Name;
					    }else if(caseObj.ownerid != null && String.valueOf(caseObj.ownerid).startsWith('005') && userMapDet != null
					        && userMapDet.get(caseObj.ownerid) != null) {
					        User objUser = userMapDet.get(caseObj.ownerid);
					        strTo = objUser.Email;
					        strName = objUser.Name;
					    }
					    
					    try {
					        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
					        String[] toAddresses = new String[] {strTo}; 
					        mail.setToAddresses(toAddresses);
					        mail.setSenderDisplayName(strFromUser);
					        mail.setSubject('Case has been Recalled');
					        mail.setPlainTextBody('Dear '+strName+',\n\n' +
					         'Following case has been Recalled \n\n Case Number: '+caseObj.CaseNumber+
					         '\n\n Case Description: '+caseObj.Description+
					          //'\n\n Please click https://na6.salesforce.com/'+caseObj.id+' to see the case details.'+
					          '\n\n Please click https://'+System.URL.getSalesforceBaseURL().getHost()+'/'+caseObj.id+' to see the case details.'+
					          '\n\n Thank You');              
					        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
					    } catch(Exception e) {
					    	System.Debug('>>ex>>>'+ e.getmessage()); 
					    }
					 } catch(System.Exception ex1){
	                    		System.Debug('>>ex>>>'+ ex1.getmessage()); 
                     }
	                        
	                    caseObj.OPS_Last_Action__c='Recalled';
	                    caseObj.Ops_Recall__c=caseObj.Ops_Recall__c+1;
	                    caseObj.ownerid=userinfo.getUserId();
	                    caseObj.Ops_Bussiness_Units__c=null;
	                    caseObj.Ops_Department__c=null;
	                    system.Debug('>>caseObj.ownerid>>'+caseObj.ownerid);
	                    if(opsAssignRuleMap != null && caseObj.ownerid != null && opsAssignRuleMap.get(caseObj.ownerid) != null) {
	                        caseObj.Assigned_OPS_User__c = opsAssignRuleMap.get(caseObj.ownerid);
	                        system.Debug('>>caseObj.Assigned_OPS_User__c>>'+caseObj.Assigned_OPS_User__c);
	                    }    
					}
	            }
	        }
        }catch(System.Exception e) {
         	GetException(e);
        } 
     }
     
    /************************Method For Medailla Survey**************************************************
	* @Description -                                     											    *
	* @Author      - Simplion Technologies                                                              * 
	*****************************************************************************************************/
     
    
    Public static void medalliaSurvey(List<Case> NewCaseList , Map<id,case> OldCaseMap ,Map<ID,Schema.RecordTypeInfo> rtMapByName,List<id> TriggerNewIds
                                     ,Map<Id,User> mapUser,Boolean isMedallia,Map<String,SupportRecordType__c> SupportRecordTypeMap){
    	     
    	   List<Survey__c> surveyToInsertList = new List<Survey__c>();
           List<Survey__c> surveyToInsertList1 = new List<Survey__c>();
           List<Survey__c> surveyToInsertList2 = new List<Survey__c>();
           List<Survey__c> surveyToInsertITHelp = new List<Survey__c>();  
           
           /********************** MEDALLIA SURVEY LIST DECLARATION *************************************/
        	List<Case> medalliaSurveyCaseList = new List<Case>();
           /*********************************************************************************************/
           
    	   /*Map<Id,Case> casePortingSurveyMap = new Map<Id,Case>([SELECT (SELECT Id FROM Surveys__r WHERE SurveyType__c = 'Porting') FROM Case 
                                                                 WHERE Id IN : TriggerNewIds]);*/
    	   
    	   /*Map<Id,Case> caseRogersSurveyMap = new Map<Id,Case>([SELECT (SELECT Id FROM Surveys__r WHERE SurveyType__c = 'Support Rogers') FROM Case 
                                                                WHERE Id IN : TriggerNewIds]);*/
                                                                    
          /* Map<Id,Case> caseCSATSurveyMap = new Map<Id,Case>([SELECT (SELECT Id FROM Surveys__r WHERE SurveyType__c = 'Support CSAT' OR 
                                                              SurveyType__c = 'Porting Phone Support' OR SurveyType__c = 'VAR Support CSAT') 
                                                              FROM Case WHERE Id IN : TriggerNewIds]); */
                                                                    
           Set<Id> caseAccountIdSet = new Set<Id>();
           Set<Id> caseContactIdSet = new Set<Id>();
           
           for(Case caseObj : NewCaseList) {
           	if(caseObj.AccountId != null)
            caseAccountIdSet.add(caseObj.AccountId);
            if(caseObj.contactId != null)
            caseContactIdSet.add(caseObj.contactId);
           }
           system.debug('=====Entering=====');
           Map<Id,Account> caseAccountMap = new Map<Id,Account>();
           Map<Id,Contact> caseContactMap = new Map<Id,Contact>();
           //Map<Id,Contact> contactSurveyMap = new Map<Id,Contact>(); 
           //Map<Id,Contact> contactSurveyMap1 = new Map<Id,Contact>() ; 
           Map<Id,Contact> contactSurveyMapITHelpDesk = new map<Id,Contact>(); 
           //Map<Id,Integer> contactPortingSurveyCount = new map<Id,Integer>();
           
           try{
	           if(caseAccountIdSet != null && caseAccountIdSet.size()>0) {
	            caseAccountMap = new Map<Id,Account>([SELECT RC_Brand__c,Premium_Support_Agent__c FROM Account WHERE Account.Id IN : caseAccountIdSet]);
	           }
	           
	           if(caseContactIdSet != null && caseContactIdSet.size()>0) {
	           		caseContactMap = new Map<Id,Contact>([SELECT id, firstName, email FROM Contact WHERE id IN : caseContactIdSet]);
	            	/*contactSurveyMap = new Map<Id,Contact>([SELECT (SELECT Name FROM Surveys__r WHERE createdDate = LAST_N_DAYS:7 AND 
	                                                  (SurveyType__c =: 'Support CSAT' OR SurveyType__c = 'Porting Phone Support' OR  
	                                                   SurveyType__c = 'VAR Support CSAT')) FROM Contact c WHERE id IN : caseContactIdSet]);*/
	            	/*contactSurveyMap1 = new Map<Id,Contact>([SELECT (SELECT Name FROM Surveys__r WHERE createdDate = LAST_N_DAYS:7 AND 
	                                                     SurveyType__c = :'Support Rogers') FROM Contact c WHERE id IN : caseContactIdSet]);  */                                                   
	            	contactSurveyMapITHelpDesk = new map<Id,contact>([Select (Select Name From Surveys__r where createdDate = LAST_N_DAYS:14 AND 
	                                                              SurveyType__c = :'IT Helpdesk CSAT') From Contact c where id IN : caseContactIdSet]);
		            /*for(AggregateResult objAggregateResult:[SELECT count(Id) cnt, ContactId FROM Case WHERE (Case.RecordType.Name = 'Porting - In' 
		                                                    OR Case.RecordType.Name = 'Porting - In (NeuStar)' OR Case.RecordType.Name = 'Porting - In (RC UK)'
		                                                    OR Case.RecordType.Name = 'Porting - In (RC)' OR Case.RecordType.Name = 'Porting - In (TELUS)' OR Case.RecordType.Name = 'Porting - Vanity') and 
		                                                    ContactId != null AND ContactId IN : caseContactIdSet 
		                                                    AND (Status = 'New' OR Status = 'Submitted' OR Status = 'Rejected' OR Status = 'Need Review') 
		                                                    GROUP BY ContactId]) {
		                                                        	
		            	contactPortingSurveyCount.put(String.valueOf(objAggregateResult.get('ContactId')),Integer.valueOf(objAggregateResult.get('cnt')));
		           } */                                                                                
	           }   
           }catch(Exception e){GetException(e);}
    	   system.debug('=====Entering=====');
    	   
    	    for(Case caseObj : NewCaseList) {
            /******************************************************************************************************
            *If field is empty and the case status has changed from any status to “Submitted” populate this field *
            *with the date from “Porting_Admin_Last_Change_Date” (set by RCAdmin).                                *
            *******************************************************************************************************/
            
				if(caseObj.Porting_First_Submit_Date__c == null && OldCaseMap != null) {
				    if(OldCaseMap.get(caseObj.id) != null && OldCaseMap.get(caseObj.id).Status != 'Submitted' && caseObj.Status == 'Submitted'){
				        if(caseObj.Porting_Admin_Last_Change_Date__c != null){ 
				           	caseObj.Porting_First_Submit_Date__c = caseObj.Porting_Admin_Last_Change_Date__c;
				        }
				        else{
				            caseObj.Porting_First_Submit_Date__c = Date.today();
				        }
				    }
				}
	            /*****************************************************************************************************
	            *Whenever the case status changes from any status to “Submitted” update this field with the date from*
	            *“Porting_Admin_Last_Change_Date” (set by RCAdmin)                                                   *
	            ******************************************************************************************************/
            system.debug('=====Entering=====');
				if(OldCaseMap.get(caseObj.id) != null && OldCaseMap.get(caseObj.id).Status != 'Submitted' && caseObj.Status == 'Submitted') {
				    if(caseObj.Porting_Admin_Last_Change_Date__c != null)
				        caseObj.Porting_Last_Submit_Date__c = caseObj.Porting_Admin_Last_Change_Date__c;
				    else
				        caseObj.Porting_Last_Submit_Date__c = Date.today();
				}
	            /*****************************************************************************************************
	            *If field is empty and the case status has changed from any status to “Rejected”                     *
	            *update this field with the Porting_Reject_Reason.                                                   * 
	            *UAT 01 -  Populate the first reject reason (Porting_First_Reject_Reason__c)                         *
	            *only if there is a first submit date (Porting_First_Submit_Date__c)                                 *
	            ******************************************************************************************************/   
                   
	            if(caseObj.Porting_First_Submit_Date__c != null) {
	                if(caseObj.Porting_First_Reject_Reason__c == null){
	                    if(OldCaseMap.get(caseObj.id) != null && OldCaseMap.get(caseObj.id).Status != 'Rejected' && caseObj.Status == 'Rejected'){
	                        caseObj.Porting_First_Reject_Reason__c = caseObj.Porting_Reject_Reason__c;
	                    }
	                }
	            }
            
	            if(rtMapByName != null && caseObj.RecordTypeId != null && 
	              (rtMapByName.get(caseObj.RecordTypeId).getName() == 'Porting – In' || 
	              rtMapByName.get(caseObj.RecordTypeId).getName() == 'Porting – Out' ||
	              rtMapByName.get(caseObj.RecordTypeId).getName() == 'Porting – Bulk/Project')) {
	              		if(caseObj.Porting_Complete_Date__c == null) {
		                    if(OldCaseMap.get(caseObj.id) != null && OldCaseMap.get(caseObj.id).Status != 'Closed' && caseObj.Status == 'Closed') {                 
		                        caseObj.Porting_Complete_Date__c = Date.today();             
		                    }
	                    }     
	            }
            	system.debug('=====Entering=====');
	            /*******************************************************************************************************
	            *UAT-01																								   *
	            *If Porting_RC_Review__c is “None” and Status is changed to “Submitted”                                * 
	            *then update Porting_RC_Review__c to “Accepted”                                                        *
	            ********************************************************************************************************/
            
	            system.debug(' here is the debug***' + caseObj.Porting_RC_Review__c);
	            if(caseObj.Porting_RC_Review__c == null && caseObj.Status == 'Submitted'){
	                caseObj.Porting_RC_Review__c = 'Accepted';                   
	            }
    
	            /*******************************************************************************************************
	            *UAT-01																								   *
	            *  If Porting_RC_Review__c is “None” and Status is changed to “Rejected” 							   *
	            *  then update Porting_RC_Review__c to “Rejected”  													   *
	            ********************************************************************************************************/
            
	            if(caseObj.Porting_RC_Review__c == null && caseObj.Status == 'Rejected'){
	                caseObj.Porting_RC_Review__c = 'Rejected';                   
	            }
            
	            /*******************************************************************************************************
	            *UAT-01																								   *
	            *For the Porting RC Review Reject Reason we should do the following:     							   *
	            *If Porting_RC_Review_Reject_Reason__c is “None” and Porting_RC_Review__c is changed “Rejected”        *
	            *      i.  If Porting_Reject_Reason__c = “LEC request COB”, set Porting_RC_Review_Reject_Reason__c = “COB”   
	            *      ii. If Porting_Reject_Reason__c = “PIN not Found”, set Porting_RC_Review_Reject_Reason__c = “PIN” 
	            *      iii.If Porting_Reject_Reason__c = “Incorrect account number”, set Porting_RC_Review_Reject_Reason__c = “Account”  
	            *      iv. If Porting_Reject_Reason__c = “Illegible auth name missing or not found”, set Porting_RC_Review_Reject_Reason__c = “LOA”  
	            *      v.  Else Porting_RC_Review_Reject_Reason__c = [No Value]  									   *
	            ********************************************************************************************************/
            
	            if(caseObj.Porting_RC_Review_Reject_Reason__c == null && caseObj.Porting_RC_Review__c == 'Rejected'){
	                if(caseObj.Porting_Reject_Reason__c == 'LEC request COB'){
	                    caseObj.Porting_RC_Review_Reject_Reason__c = 'COB';
	                }
	                else if(caseObj.Porting_Reject_Reason__c == 'PIN not Found'){
	                    caseObj.Porting_RC_Review_Reject_Reason__c = 'PIN';
	                }
	                else if(caseObj.Porting_Reject_Reason__c == 'Incorrect account number'){
	                    caseObj.Porting_RC_Review_Reject_Reason__c = 'Account';
	                }
	                else if(caseObj.Porting_Reject_Reason__c == 'Illegible auth name/name missing'){
	                    caseObj.Porting_RC_Review_Reject_Reason__c = 'LOA';
	                }else{
	                  caseObj.Porting_RC_Review_Reject_Reason__c = '[No Value]';
	                }
	            }
	            /*********************************************************************************************************
	             *Save data into Survey Object                                                                           *
	             *Fileter from Record Types                                                                              *
	             *********************************************************************************************************/
           
            //system.debug('=====OldCaseMap.get(caseObj.id).Status====='+OldCaseMap.get(caseObj.id).Status);
           		
           
	            if((caseObj.Status == 'Closed' || caseObj.Status == 'Completed') && OldCaseMap.get(caseObj.id).Status != caseObj.Status) {
	                if(isMedallia) {
	                    if(MedalliaSurveyHelper.isMedalliaSupportForPorting(caseObj, OldCaseMap.get(caseObj.id), rtMapByName) 
	                       && (caseObj.MedalliaRecordAlreadyCreated__c == null || caseObj.MedalliaRecordAlreadyCreated__c == false)
	                       && !String.isBlank(caseObj.ContactId)   ) {
	                        // surveyToInsertList.add(surveyObj); [NEED TO ADD CODE HERE]
	                        caseObj.MedalliaRecordAlreadyCreated__c = true;
	                        medalliaSurveyCaseList.add(caseObj);
	                    }
	                } /*else {
	                    system.debug('Check Else part');                     
	                    Integer sCheck = -1;
	
	                  		try {
		                        if(casePortingSurveyMap != null && casePortingSurveyMap.containsKey(caseObj.Id) && 
		                           casePortingSurveyMap.get(caseObj.Id).Surveys__r != null) {
		                                List<Survey__c> surveyList = casePortingSurveyMap.get(caseObj.Id).Surveys__r;
		                                system.debug('======surveyList'+surveyList);
		                                if(surveyList.size() >= 0) {
		                                    sCheck = surveyList.size(); 
		                                }
		                        }
	                        } catch(System.QueryException e){}
							system.debug('======scheck'+sCheck);
							system.debug('======caseObj.ContactId'+caseObj.ContactId);
		                    if(sCheck == 0 && !String.isBlank(caseObj.ContactId)) {
		                        Survey__c surveyObj = new Survey__c();
		                        surveyObj.Case__c = caseObj.Id;
		
		                        try{
		                            surveyObj.Contact__c = caseObj.ContactId;
		                            /********************************************************************************************************************* 
		                            *Confirm that the contact has no other port-in or port-out cases in status: New, Submitted, Rejected, or Need Review.* 
		                            *If no records are found, send out the survey, otherwise, do not send                                                *
		                            ********************************************************************************************************************** /
		                            Integer iCount = 0;
		                            if(contactPortingSurveyCount != null && caseObj.ContactId != null 
		                                    && contactPortingSurveyCount.get(caseObj.ContactId) != null) {
		                                system.debug('<<>FFF>> ' + contactPortingSurveyCount.get(caseObj.ContactId));
		                                iCount = contactPortingSurveyCount.get(caseObj.ContactId) - 1;            
		                                system.debug('chkCounter.size IS --> ' + caseObj.ContactId + '------' + iCount); 
		                            }               
		                        
		                            if(iCount == 0) {      
		                                if(/*rtMapByName.get( caseObj.RecordTypeId ).getName() == 'Porting - In'
		                                || rtMapByName.get( caseObj.RecordTypeId ).getName() == 'Porting - In (NeuStar)'
		                                || rtMapByName.get( caseObj.RecordTypeId ).getName() == 'Porting - In (RC UK)'
		                                || rtMapByName.get( caseObj.RecordTypeId ).getName() == 'Porting - In (RC)' 
		                                || rtMapByName.get( caseObj.RecordTypeId ).getName() == 'Porting - In (TELUS)'
		                                || rtMapByName.get( caseObj.RecordTypeId ).getName() == 'Porting - Vanity'* /
		                                SupportRecordTypeMap != null && SupportRecordTypeMap.get(rtMapByName.get(caseObj.RecordTypeId).getName()) != null
	                                    && SupportRecordTypeMap.get(rtMapByName.get(caseObj.RecordTypeId).getName()).MedalliaSurveyiCount__c == true ) {
		                                  	
		                                    if(caseAccountMap != null && caseObj.AccountId != null && 
		                                       caseObj.ContactId != null  && caseAccountMap.containskey(caseObj.AccountId) != null && caseAccountMap.get(caseObj.AccountId)!= null) {
		                                       	Account acc =   caseAccountMap.get(caseObj.AccountId);  
		                                        if(acc.RC_Brand__c != null && acc.RC_Brand__c.trim().equalsIgnoreCase('RingCentral')) {
		                                            Contact contactObj = caseContactMap.get(surveyObj.Contact__c);
		                                            surveyObj.Contact_Email__c = contactObj.email;                           
		                                            surveyObj.Name = 'Porting Survey - ' + Datetime.now().format();
		                                            surveyObj.SurveyType__c = 'Porting';
		                                            surveyObj.Agent_Email__c = 'portingsupport@ringcentral.com'; // Change as per Wilson March16 2011
		                                            if(mapUser != null && caseObj.OwnerId != null && mapUser.containskey(caseObj.OwnerId) && mapUser.get(caseObj.OwnerId) != null) {
		                                                User userObj = mapUser.get(caseObj.OwnerId);
		                                                surveyObj.Agent__c = userObj.Id;
		                                                surveyObj.Agent_Email__c = userObj.Email;
		                                                surveyObj.Agent_Name__c = userObj.Name;
		                                                if(userObj.Team__c != null)
		                                                surveyObj.Agent_Team__c = userObj.Team__c;
		                                                surveyObj.Account__c = caseObj.AccountId;
		                                                if(userObj.Manager.Email != null && userObj.Manager.Name != null) {
		                                                    surveyObj.Agent_Manager_Email__c = userObj.Manager.Email;
		                                                    surveyObj.Agent_Manager_Name__c = userObj.Manager.Name; 
													    }       
		                                            }
		                                            if(mapUser != null && mapUser.containskey(caseObj.CreatedById)) {
		                                                  User userObj = mapUser.get(caseObj.CreatedById);
		                                                  if(userObj != null && userObj.isActive == true) {
		                                                      surveyObj.ownerId = caseObj.CreatedById;
		                                                  }
		                                            }
		                                            surveyToInsertList.add(surveyObj);
		                                        }
		                                    }
		                                }
		                            }
		                        } catch(System.Exception e){
		                          		caseObj.addError(e);
		                        }
		                    }
	                }*/
	            }
                
            /*******************************************************************************************************
            ***********************************************CSAT Trigger*********************************************
            ********************************************************************************************************/
           
           system.debug('==========rtMapByName.get(caseObj.RecordTypeId)=========='+rtMapByName.get(caseObj.RecordTypeId));
           
           
           if((SupportRecordTypeMap != null && SupportRecordTypeMap.get(rtMapByName.get(caseObj.RecordTypeId).getName()) != null
	                && SupportRecordTypeMap.get(rtMapByName.get(caseObj.RecordTypeId).getName()).medalliaSurvey__c == true )
                 && (caseObj.Support_Jira__c == null)) {
        
                    /* Added New record Type 'Support - Tech Assist'  on 7/7/2011 */
                    /* Remove record Type 'Support - Tech Assist' on 1/4/2012 */     
                     
                       if(
                        ((caseObj.Status == 'Closed' && OldCaseMap.get(caseObj.id).Status != 'Closed')
                        /*&& !(rtMapByName.get( caseObj.RecordTypeId ).getName() == 'Support - FeedBack' 
                            || rtMapByName.get( caseObj.RecordTypeId ).getName() == 'Support - TalkToRCMgmt'
                            || rtMapByName.get( caseObj.RecordTypeId ).getName() == 'Support - Tech Assist'
                            || rtMapByName.get( caseObj.RecordTypeId ).getName() == 'Support - Mobile'
                            || rtMapByName.get(caseObj.RecordTypeId).getName() == 'Service Engineer'
                            || rtMapByName.get(caseObj.RecordTypeId).getName() == 'Support - CV' 
                            || rtMapByName.get(caseObj.RecordTypeId).getName() == 'Support - Executive Response Team' 
                            || rtMapByName.get(caseObj.RecordTypeId).getName() == 'Support - Red Account'
                            || rtMapByName.get(caseObj.RecordTypeId).getName() == 'Support – Social Media')*/
                         ) 
                        ){ 
                        /************************************************************************************************************** 
                        *When Dispositon Level 1 equalsIgnoreCase to 'Hot Issue' and Dispostionn Level 2 equalsIgnoreCase to 'Outage' then not survey******
                        ***************Other Conditions Added -  On 30 Aug 2012********************************************************
                        ***************MEDALLIA CODE FOR CSAT SURVEYs *****************************************************************
                        ***************************************************************************************************************/
                        
                        if(isMedallia){
                        	Account accObj = new Account();
                        	if(caseAccountMap.get(caseObj.AccountId)!=null) {
                            	 accObj =  caseAccountMap.get(caseObj.AccountId);
                        	}  
                            Boolean isBrandTelus = (accObj != null && !String.IsBlank(accObj.RC_Brand__c) && accObj.RC_Brand__c.trim().containsIgnoreCase('Telus')) ? true : false;
                            Boolean isrecordTypeIT = (String.valueOf(rtMapByName.get( caseObj.RecordTypeId ).getName()).contains('IT'))?true:false;
                            /*********************************************************************************************************************
                             *                            [DISPOSITIONS changes are taken cared by Medallia]                                     *
                             *********************************************************************************************************************/
                             
                            if(!isBrandTelus 
                                && !isrecordTypeIT 
                                && (caseObj.MedalliaRecordAlreadyCreated__c == null || caseObj.MedalliaRecordAlreadyCreated__c == false)
                                && !String.isBlank(caseObj.ContactId)   ) {
                                caseObj.MedalliaRecordAlreadyCreated__c = true;
                                
                                	medalliaSurveyCaseList.add(caseObj);
                            }
                        }/* else if((caseObj.Support_Disposition_Level_1__c != 'Internal Work Flow')
                            && (caseObj.Support_Disposition_Level_2__c != 'Feature Request'
                                && caseObj.Support_Disposition_Level_2__c != 'Outage'
                                && caseObj.Support_Disposition_Level_2__c != 'Do Not Contact Request'
                                && caseObj.Support_Disposition_Level_2__c != 'Cancellation Request')
                            && (caseObj.Support_Disposition_Level_3__c != 'RingCentral Blocked Country')) {         
	                                system.debug('IN CSAT');                     
	                                Integer sCheck = -1;
	                                Integer rCheck = -1;
	                                String surveyType = null;
	                                
	                                try {
	                                    if(caseCSATSurveyMap != null && caseCSATSurveyMap.containsKey(caseObj.Id)) {
	                                        List<Survey__c> surveyList = caseCSATSurveyMap.get(caseObj.Id).Surveys__r;
	                                        system.Debug('>>surveyList>>>'+surveyList);
	                                        if(surveyList != null) {
	                                            sCheck = surveyList.size();
	                                            system.Debug('>>sCheck>>>'+sCheck);
	                                        }
	                                    }
	                                    if(caseRogersSurveyMap != null && caseRogersSurveyMap.containsKey(caseObj.Id)) {
	                                        List<Survey__c> surveyList = caseRogersSurveyMap.get(caseObj.Id).Surveys__r;
	                                        system.Debug('>>surveyList>>>'+surveyList);
	                                        if(surveyList != null) {
	                                            rCheck = surveyList.size();
	                                            system.Debug('>>rCheck>>>'+rCheck);
	                                        }
	                                    }
	                                }catch(Exception e){GetException(e);}
	                                   
	                                if(sCheck == 0 || rCheck  == 0) {
	                                    Integer iCount = -1;
	                                    Integer oCount = -1;
	                                    if(contactSurveyMap != null && caseObj.ContactId != null && contactSurveyMap.containskey(caseObj.ContactId)) {
	                                        List<Survey__c> surveyList = contactSurveyMap.get(caseObj.ContactId).Surveys__r;
	                                        if(surveyList != null) {
	                                            iCount = surveyList.size();
	                                            system.Debug('>>iCount>>>'+iCount);
	                                        }   
	                                    }
	                                    if(contactSurveyMap1 != null && caseObj.ContactId != null && contactSurveyMap1.containskey(caseObj.ContactId)) {
	                                        List<Survey__c> surveyList = contactSurveyMap1.get(caseObj.ContactId).Surveys__r;
	                                        if(surveyList != null) {
	                                            oCount = surveyList.size();
	                                            system.Debug('>>oCount>>>'+oCount);
	                                        }   
	                                    }
	                                    /***************************************************************************************************************************************
	                                    * It is used to create survey object according to brand of an Account, provided that, it should handle the input null values.          *
	                                    * 1. getting the respective one record 																								   *
	                                    **************************************************************************************************************************************** /
	                                    
	                                    if(rtMapByName.get(caseObj.RecordTypeId ).getName() == 'Support - T1 (VAR & Partners)' 
	                                       && iCount == 0 && caseObj.ContactId != null) {
	                                        Survey__c surveyObj = new Survey__c();
	                                        surveyObj.Case__c = caseObj.Id;
	                                        try { 
	                                            surveyObj.Contact__c = caseObj.ContactId;
	                                            if(surveyObj.Contact__c != null && caseContactMap != null && caseContactMap.containskey(surveyObj.Contact__c)) {
	                                                Contact contactObj = caseContactMap.get(surveyObj.Contact__c);
	                                                surveyObj.Contact_Email__c = contactObj.email;      
	                                            }     
	                                     /**********************************************************************************************************************************
	                                      *      							getting the user information per case owner id basis 										   *
	                                      ********************************************************************************************************************************** /
	                                      
	                                            if(mapUser != null && caseObj.OwnerId != null && mapUser.containskey(caseObj.OwnerId) && mapUser.get(caseObj.OwnerId)!= null) {
	                                                User userObj = mapUser.get(caseObj.OwnerId);
	                                                surveyObj.Agent__c = userObj.Id;
	                                                surveyObj.Agent_Email__c = userObj.Email;
	                                                surveyObj.Agent_Name__c = userObj.Name;
	                                                if(userObj.Team__c != null)
	                                                surveyObj.Agent_Team__c = userObj.Team__c;
	                                                surveyObj.Account__c = caseObj.AccountId;
	                                                if(userObj.Manager.Email != null && userObj.Manager.Name != null) {
	                                                    surveyObj.Agent_Manager_Email__c = userObj.Manager.Email;
	                                                    surveyObj.Agent_Manager_Name__c = userObj.Manager.Name; 
	                                                }       
	                                            }                       
	                                            surveyObj.Name = 'VAR Support CSAT' + ' '+ Datetime.now().format();
                                                surveyObj.SurveyType__c = 'VAR Support CSAT'; 
                                                if(mapUser != null && mapUser.containskey(caseObj.CreatedById) && mapUser.get(caseObj.CreatedById) != null) {
                                                    User userObj = mapUser.get(caseObj.CreatedById);
                                                    if(userObj != null && userObj.isActive == true) {
                                                        surveyObj.ownerId = caseObj.CreatedById;
                                                    }
                                                }
	                                            surveyToInsertList2.add(surveyObj); 
	                                              
	                                            } catch(Exception e) {
	                                            	caseObj.addError(e);
	                                            }
	                                   			} else {
			                                    if(caseAccountMap != null && caseObj.AccountId != null && caseAccountMap.containskey(caseObj.AccountId) && caseAccountMap.get(caseObj.AccountId)!= null) {
			                                        Account acc =   caseAccountMap.get(caseObj.AccountId);
			                                        /************************************************************************************************
			                                         *                             Checking its not null values.                                    *
			                                         ************************************************************************************************ /
			                                        if(acc.RC_Brand__c != null) {
			                                        /************************************************************************************************
			                                         *  Taking the default conditions per provided data, and created the variables per conditions   *
			                                         ************************************************************************************************ /
			                                            
				                                            Boolean csatBrandStatus = false;
				                                            if((acc.RC_Brand__c.trim().startsWithIgnoreCase('RingCentral')
				                                                ||acc.RC_Brand__c.trim().equalsIgnoreCase('AT&T Office@Hand')
				                                                ||acc.RC_Brand__c.trim().equalsIgnoreCase('RingCentral Office@Hand from AT&T')
				                                                ||acc.RC_Brand__c.trim().equalsIgnoreCase('Clearwire')
				                                                || acc.RC_Brand__c.trim().containsIgnoreCase('Telus'))&& acc.Premium_Support_Agent__c == null) {
				                                                    
				                                                    csatBrandStatus = true;
				                                            }
				                                            Boolean rogersStatus = acc.RC_Brand__c.trim().equalsIgnoreCase('Rogers');
				                                            if(csatBrandStatus || rogersStatus) {
				                                            	
				                                     /***********************************************************************************************
			                                         *               The below is the default logic that is done in each conditions                 *
			                                         *         For adding new condition, the below field logic can be overridden into below code    *
			                                         ************************************************************************************************ /
				                                               
				                                               Map<String, String> hm = new Map<String, String>();
				                                               if(iCount == 0 && csatBrandStatus && rtMapByName.get( caseObj.RecordTypeId ).getName() != 'Porting - Phone') {
				                                                    if(rtMapByName.get( caseObj.RecordTypeId ).getName() == 'Support - Tech Assist') {
				                                                        hm.put('Survey-TechAssist', 'Support CSAT');                                    
				                                                    } else if(caseObj.Product_Assistance__c != 'Product Feedback') {
				                                                        hm.put('Survey-CSAT', 'Support CSAT');
				                                                    }
				                                                }
				                                               if(oCount == 0 && rogersStatus && rtMapByName.get( caseObj.RecordTypeId ).getName() != 'Porting - Phone') {
				                                                    hm.put('Support-Rogers', 'Support Rogers');
				                                               }
				                                               if(iCount == 0 && csatBrandStatus  && rtMapByName.get( caseObj.RecordTypeId ).getName() == 'Porting - Phone') {
				                                                      hm.put('Porting-Phone-Support', 'Porting Phone Support');
				                                               }
				                                                
				                                               for(String key: hm.keySet()) {
				                                                    Survey__c surveyObj1 = new Survey__c();
				                                                    surveyObj1.Case__c = caseObj.Id;
				                                                    try { 
				                                                        surveyObj1.Contact__c = caseObj.ContactId;
				                                                        if(surveyObj1.Contact__c != null && caseContactMap != null && 
				                                                            caseContactMap.containskey(surveyObj1.Contact__c)) {
				                                                            Contact contactObj = caseContactMap.get(surveyObj1.Contact__c);
				                                                            surveyObj1.Contact_Email__c = contactObj.email;     
				                                                        }
				                                               /**************************************************************************************************************
				                                                ****************************** getting the user information per case owner id basis **************************
				                                                ************************************************************************************************************** /
				                                                
				                                                        system.debug('>>>CaseOwner>>11>>>'+ caseObj.OwnerId);   
				                                                        system.debug('>>>mapUser>>11>>>'+ mapUser); 
				                                                        
				                                                        if(mapUser != null && caseObj.OwnerId != null && mapUser.containskey(caseObj.OwnerId)) {
				                                                            User userObj = mapUser.get(caseObj.OwnerId);
				                                                            surveyObj1.Agent__c = userObj.Id;
				                                                            surveyObj1.Agent_Email__c = userObj.Email;
				                                                            surveyObj1.Agent_Name__c = userObj.Name;
				                                                            if(userObj.Team__c != null)
				                                                            surveyObj1.Agent_Team__c = userObj.Team__c;
				                                                            if(caseObj.AccountId != null)
				                                                            surveyObj1.Account__c = caseObj.AccountId;
				                                                            if(userObj.Manager.Email != null && userObj.Manager.Name != null) {
				                                                                surveyObj1.Agent_Manager_Email__c = userObj.Manager.Email;
				                                                                surveyObj1.Agent_Manager_Name__c = userObj.Manager.Name;    
				                                                            }       
				                                                        }
				                                                        
				                                                        surveyObj1.Name = key + ' '+ Datetime.now().format();
				                                                        surveyObj1.SurveyType__c = hm.get(key);				                                                        
				                                                        if(mapUser != null && mapUser.containskey(caseObj.CreatedById) && mapUser.get(caseObj.CreatedById)!= null ) {
				                                                            User userObj = mapUser.get(caseObj.CreatedById);
				                                                            if(userObj != null && userObj.isActive == true) {
				                                                                surveyObj1.ownerId = caseObj.CreatedById;
				                                                            }
				                                                        }
				                                                        surveyToInsertList1.add(surveyObj1); 
				                                                      } catch(Exception e) {
				                                                        	caseObj.addError(e);
				                                                      }                             
				                                                   }
				                                               }
			                                                }
			                                            } 
	                                               }
	                                          }
	                                      }*/
                                      }               
                                   } 
                
                /*********************************************************************************************************************************
                *                                              CSAT Trigger  END                                                                 * 
                *                                              IT HelpDeskSurvey                                                                 *
                **********************************************************************************************************************************/
                
                System.Debug('>>>Start ITHelp>');
                
                if((rtMapByName.get( caseObj.RecordTypeId ).getName() == IT_HELP_DESK )) {
                    Integer itSurveyCount = -1; 
                    if(caseObj.Status == 'Closed' && OldCaseMap.get(caseObj.id).Status != 'Closed') {
                        try {
                            if(contactSurveyMapITHelpDesk != null && caseObj.ContactId != null && 
                                    contactSurveyMapITHelpDesk.containsKey(caseObj.ContactId) && contactSurveyMapITHelpDesk.get(caseObj.ContactId).Surveys__r != null) {
                                List<Survey__c> surveyList = contactSurveyMapITHelpDesk.get(caseObj.ContactId).Surveys__r;
                                System.Debug('>>surveyListIT>>>'+surveyList);
                                if(surveyList != null) {
                                    itSurveyCount = surveyList.size();
                                    System.Debug('>>itSurveyCount>>>'+itSurveyCount); 
                                }
                            }
                            
                            if(itSurveyCount == 0) {
                                Survey__c surveyObj1 = new Survey__c();
                                surveyObj1.Case__c = caseObj.Id;
                                surveyObj1.Contact__c = caseObj.ContactId;
                                if(surveyObj1.Contact__c != null && caseContactMap != null && 
                                    caseContactMap.containskey(surveyObj1.Contact__c)) {
                                    Contact contactObj = caseContactMap.get(surveyObj1.Contact__c);
                                    if(contactObj.email != null)
                                    surveyObj1.Contact_Email__c = contactObj.email;     
                                }
                              
                                if(mapUser != null && caseObj.OwnerId != null && mapUser.containskey(caseObj.OwnerId)) {
                                    User userObj = mapUser.get(caseObj.OwnerId);
                                    surveyObj1.Agent__c = userObj.Id;
                                    surveyObj1.Agent_Email__c = userObj.Email;
                                    surveyObj1.Agent_Name__c = userObj.Name;
                                    if(userObj.Team__c != null)
                                    surveyObj1.Agent_Team__c = userObj.Team__c;
                                    surveyObj1.Account__c = caseObj.AccountId;
                                    if(userObj.Manager.Email != null && userObj.Manager.Name != null) {
                                        surveyObj1.Agent_Manager_Email__c = userObj.Manager.Email;
                                        surveyObj1.Agent_Manager_Name__c = userObj.Manager.Name;    
                                    }       
                                }
                                surveyObj1.Name = 'IT Helpdesk CSAT' + ' '+ Datetime.now().format();
                                surveyObj1.SurveyType__c = 'IT Helpdesk CSAT';
                                surveyToInsertITHelp.add(surveyObj1);   
                            }
                        } catch(Exception ex) {
                            caseObj.addError(ex);
                        }   
                    }
                }
               /*************************************************************************************************************** 
                *                                          IT HelpDeskSurvey END                                              *
                ***************************************************************************************************************/  
          }
        if(surveyToInsertList != null && surveyToInsertList.size()>0) {
            try {
                insert surveyToInsertList;
            } catch(Exception ex) {GetException(ex);}
        }
        if(surveyToInsertList1 != null && surveyToInsertList1.size()>0) {
            try {
                insert surveyToInsertList1;
            } catch(Exception ex) {GetException(ex);}
        }
        if(surveyToInsertList2 != null && surveyToInsertList2.size()>0) {
            try {
                insert surveyToInsertList2;
            } catch(Exception ex) {GetException(ex);}
        }
        
        if(surveyToInsertITHelp != null && surveyToInsertITHelp.size()>0) {
            try {
                insert surveyToInsertITHelp;
            } catch(Exception ex) {GetException(ex);}
        }
               /***************************************************************************************************************** 
               *										Code edit for Medallia Survey Starts                                    *
               ******************************************************************************************************************/
               
        if(medalliaSurveyCaseList != null && medalliaSurveyCaseList.size()>0) {
            try {
                if(!TriggerHandler.BY_PASS_CASE_ON_UPDATE){
                    MedalliaSurveyHelper.insertSupportMedalliaSurvey(medalliaSurveyCaseList,rtMapByName);   
                }
                TriggerHandler.BY_PASS_CASE_ON_UPDATE();
            } catch(Exception ex) {GetException(ex);}
        }
               /***************************************************************************************************************** 
               *										Code edit for Medallia Survey ENDS                                      *
               ******************************************************************************************************************/
    }
    
    /************************Method For Porting Out    **************************************************
	* @Description -                                     											    *
	* @Author      - Simplion Technologies                                                              * 
	*****************************************************************************************************/
    
    Public Static void PortingOut(List<Case> NewCaseList,Map<Id,Account> mapToCaseAccount,Map<ID,Schema.RecordTypeInfo> rtMapByName){
    	
    	for(Case objcase:NewCaseList) {
            try {
                system.debug('********************* debug starts ************************');
                if(objcase.RecordTypeId != null && rtMapByName.get(objcase.RecordTypeId).getName() == 'Porting - Out' && objcase.AccountId != null) {
                    if(mapToCaseAccount != null && objcase.AccountId != null && mapToCaseAccount.get(objcase.AccountId) != null) {
                        Date startDate = mapToCaseAccount.get(objcase.AccountId).Sales_Agreement_Start_Date__c;
                        Date endDate = mapToCaseAccount.get(objcase.AccountId).Sales_Agreement_End_Date__c;
                        decimal n = 0.0;
                        if(mapToCaseAccount.get(objcase.AccountId).MRR__c == null) {
                            mapToCaseAccount.get(objcase.AccountId).MRR__c = 0;
                        }
                        if((endDate != null) && (startDate != null)){
                            if(system.today() < startDate){
                                n = Math.ceil(Decimal.valueOf((startDate.daysBetween(endDate)))/30);
                                objcase.Account_Balance__c  = n * mapToCaseAccount.get(objcase.AccountId).MRR__c;
                                system.debug('*********** 1 Account_Balance__c *******  '+ objcase.Account_Balance__c  );
                            } else if(system.today() >= startDate && system.today() < endDate){
                                n = Math.ceil(Decimal.valueOf((system.today().daysBetween(endDate)))/30);
                                system.debug('----- n2----'+n);
                                objcase.Account_Balance__c = n * mapToCaseAccount.get(objcase.AccountId).MRR__c;
                                system.debug('***********2 Account_Balance__c *******  '+ objcase.Account_Balance__c  );
                            }else if(system.today() >= endDate){
                                objcase.Account_Balance__c = 0;
                                system.debug('*********** 3 Account_Balance__c *******  '+ objcase.Account_Balance__c  );
                            }
                        }
                        
                        if(String.isBlank(objcase.No_Phone_Numbers_to_Port_Out__c)) {
                            objcase.No_Phone_Numbers_to_Port_Out__c = '0';
                        }
                        if(mapToCaseAccount.get(objcase.AccountId).Number_of_DL_s__c == null) {
                            mapToCaseAccount.get(objcase.AccountId).Number_of_DL_s__c = 0;
                        }   
                        if(Integer.valueOf(objcase.No_Phone_Numbers_to_Port_Out__c) <= mapToCaseAccount.get(objcase.AccountId).Number_of_DL_s__c) {
                            objcase.Full_or_Partial_Port_Out__c = 'Partial';
                        } else {
                            objcase.Full_or_Partial_Port_Out__c = 'Full';  
                        }
                    }
                }
            } catch(Exception e){objcase.addError(e);}
        }
    	
    }
    
    /************************Method For Porting Out Close Case*******************************************
	* @Description -                                     											    *
	* @Author      - Simplion Technologies                                                              * 
	*****************************************************************************************************/
    
    Public Static Void PortingOutCloseCase(List<Case> NewCaseList,Map<id,case> OldCaseMap,Map<ID,Schema.RecordTypeInfo> rtMapByName,Map<Id,Account> mapToCaseAccount){
    	
        List<Exception_And_Notification_History__c> lstEANH = new List<Exception_And_Notification_History__c>();
    	String sUrlRewrite = System.URL.getSalesforceBaseUrl().getHost();
    	try{        
            for(Case objcase : NewCaseList) {
                String strStatus = OldCaseMap.get(objcase.id).Status;
                if(objcase.RecordTypeId != null && rtMapByName.get(objcase.RecordTypeId).getName() == 'Porting - Out' 
                    && strStatus != 'Closed' 
                    && objcase.Status == 'Closed' 
                    && mapToCaseAccount != null 
                    && objcase.AccountId != null 
                    && mapToCaseAccount.get(objcase.AccountId) != null
                    && (mapToCaseAccount.get(objcase.AccountId).Number_of_DL_s__c != null 
                        && mapToCaseAccount.get(objcase.AccountId).Number_of_DL_s__c != 0)
                ){
                    sUrlRewrite = 'https://' + sUrlRewrite + '/' + objcase.id;
                    String toAddress = '';
                    if(!String.isBlank(mapToCaseAccount.get(objcase.AccountId).Current_Owner_Email__c)){
                        toAddress = mapToCaseAccount.get(objcase.AccountId).Current_Owner_Email__c;
                    } else {
                        toAddress = mapToCaseAccount.get(objcase.AccountId).Most_Recent_Opportunity_Owner_Email__c;
                    }
                    if(!String.isBlank(toAddress) && toAddress != 'rcsfsync@ringcentral.com' ) {
                        Exception_And_Notification_History__c objEANH = new Exception_And_Notification_History__c();
                        objEANH.Email_Subject__c = 'Customer '+ mapToCaseAccount.get(objcase.AccountId).Name +' has just completed a '+ objcase.Full_or_Partial_Port_Out__c;
                        objEANH.To_Address_1__c = toAddress;
                        objEANH.Object_Type__c = 'case - PortOut';
                        objEANH.content_label_01__c = 'Account: ' ;
                        objEANH.content_var_01__c = mapToCaseAccount.get(objcase.AccountId).Name;
                        objEANH.content_label_02__c =' No. of DLs: ';
                        objEANH.content_var_02__c =  mapToCaseAccount.get(objcase.AccountId).Number_of_DL_s__c == null ? '': 
                                                        String.valueOf(mapToCaseAccount.get(objcase.AccountId).Number_of_DL_s__c);
                        objEANH.content_label_03__c = 'Partial vs. Full: ';
                        objEANH.content_var_03__c = + objcase.Full_or_Partial_Port_Out__c;
                        objEANH.content_label_04__c = 'Account Balance on Port-Out: ';
                        objEANH.content_var_04__c =  'USD '+ objcase.Account_Balance__c == null? '' : String.valueOf(objcase.Account_Balance__c);
                        objEANH.content_label_05__c = 'Port Out Case Number: ';
                        objEANH.content_var_05__c =  objcase.CaseNumber;
                        objEANH.content_label_06__c = 'Port Out Case Link: ';
                        objEANH.content_var_06__c = sUrlRewrite;
                        lstEANH.add(objEANH); 
                    }
                }
            }
            if(lstEANH != null && lstEANH.size()> 0){
                insert lstEANH;
            }
        } catch(exception e ){GetException(e);}      
    }
    
    /************************Method For Case Share Insert************************************************
	* @Description -                                     											    *
	* @Author      - Simplion Technologies                                                              * 
	*****************************************************************************************************/
    
    Public Static Void InsertCaseShare(List<Case> NewCaseList,Map<id,User> mapUser,Map<id,case> OldCaseMap){
    	
    	for(Case caseObj : NewCaseList) {

	        try {
	                if(mapUser != null && caseObj.OwnerId != null && mapUser.containsKey(caseObj.OwnerId)){
	                    if(OldCaseMap == null && mapUser.get(caseObj.OwnerId).Manager.Email != null ){
	                        caseObj.Case_Owner_Manager_Email__c =  mapUser.get(caseObj.OwnerId).Manager.Email;
	                    }else if(OldCaseMap.get(caseObj.Id).OwnerId != caseObj.OwnerId){
	       /************************************************************************************************
	       *                  Create new sharing object for case.                                          *
	       *************************************************************************************************/
	                        
	                          ID loggedinUserId = userinfo.getUserId();
	                          List<CaseShare> caseShrList = new List<CaseShare>(); 
	                          CaseShare caseShrObj1 = new CaseShare();
	                          CaseShare caseShrObj2 = new CaseShare();
	                          caseShrObj1.CaseId = caseObj.Id;
	                          caseShrObj2.CaseId = caseObj.Id;
	                          caseShrObj1.UserOrGroupId = caseObj.OwnerId;
	                          caseShrObj2.UserOrGroupId = loggedinUserId;
	                          caseShrList.add(caseShrObj1);
	                          if(loggedinUserId != caseObj.OwnerId){
	                            caseShrList.add(caseShrObj2);
	                          }
	                         
	                          caseShrObj1.CaseAccessLevel = 'Edit';
	                          caseShrObj2.CaseAccessLevel = 'Edit';
	                          List<Database.SaveResult> sr1 = Database.insert(caseShrList,false);
	                          integer counts = 0;
	                          for(Database.SaveResult sr : sr1){
	                            if(sr.isSuccess()){
	                                counts++;	                                
	                                if(loggedinUserId ==caseObj.OwnerId && mapUser.get(caseObj.OwnerId).Manager.Email != null){
	                                    caseObj.Case_Owner_Manager_Email__c =  mapUser.get(caseObj.OwnerId).Manager.Email;  
	                                }else{
	                                    if(counts ==2 && mapUser.get(caseObj.OwnerId).Manager.Email != null){
	                                        caseObj.Case_Owner_Manager_Email__c =  mapUser.get(caseObj.OwnerId).Manager.Email;
	                                    }
	                                }
	                            }
	                          }
	                    }
	            }else{
	                 caseObj.Case_Owner_Manager_Email__c = '';
	            }   
	        } catch(Exception ex) {GetException(ex);}
      }
    }
    
    /************************Method For Ops Ticketing Case***********************************************
	* @Description -                                     											    *
	* @Author      - Simplion Technologies                                                              * 
	*****************************************************************************************************/
    
    public static void OpsTicketingCase(Set<id> setOPSAssUser,List<Case> caseList,Map<ID,Schema.RecordTypeInfo> rtMapByName,
                                        map<string,Id> groupMapBussUnit,List<Account> listAccountOPS,Map<String,Profile> ProfileMap){
    	
    	Set<Id> setAssingnedToUser = new Set<Id>();
    	Map<Id,OpsAssignmentRules__c> mapOPSAssRules =  new Map<Id,OpsAssignmentRules__c>();
    	Id userProfileId ;
    	if(ProfileMap != null && ProfileMap.get( SYSTEM_ADMINISTRATOR ) != null){
    		userProfileId = ProfileMap.get( SYSTEM_ADMINISTRATOR ).id;
    		system.debug('=========userProfileId==========='+userProfileId);
    	}
    	if(setOPSAssUser != null && setOPSAssUser.size()>0) {
    	mapOPSAssRules  = new Map<Id,OpsAssignmentRules__c>([SELECT AssignToUser__c,User__c FROM OpsAssignmentRules__c WHERE  
                                                                    id IN : setOPSAssUser]);
              if(mapOPSAssRules != null && mapOPSAssRules.values() != null) {
                   for(OpsAssignmentRules__c Obj : mapOPSAssRules.values()) {
                   	if(Obj.AssignToUser__c != null) {
                        setAssingnedToUser.add(Obj.AssignToUser__c);
                    }   
                }   
            }                                                             
    	}
    	
    	Map<Id,User> mapAssignedToUser = new Map<Id,User>();
        Map<Id,Id> mapAssignedUser1 = new Map<Id,Id>();
        Set<Id> setOPSTeam = new Set<Id>();
        
        if(setAssingnedToUser != null && setAssingnedToUser.size()>0) {
        	List<OpsAssignmentRules__c> opsAssignRules = [SELECT id,AssignToUser__c,User__c FROM OpsAssignmentRules__c WHERE 
                                                        AssignToUser__c IN :setAssingnedToUser and User__c IN :setAssingnedToUser];
        	for(OpsAssignmentRules__c opsAssignedObj : opsAssignRules) {
                                                        	
            	if(opsAssignedObj.AssignToUser__c == opsAssignedObj.User__c) {
                    mapAssignedUser1.put(opsAssignedObj.AssignToUser__c,opsAssignedObj.Id);
                }
           }
                mapAssignedToUser = new Map<Id,User>([SELECT Ops_TeamMemName__c FROM User WHERE id IN : setAssingnedToUser AND 
                                                    (Ops_LeaveToDate__c >= Today) AND (Ops_LeaveFromDate__c<=Today)]); 
                if(mapAssignedToUser != null && mapAssignedToUser.values() != null) {
	                for(User userObj : mapAssignedToUser.values()) {
	                    if(userObj.Ops_TeamMemName__c != null) {
	                        setOPSTeam.add(userObj.Ops_TeamMemName__c);
	                    }   
	               	}   
            	 }                                        
        }
        
        Map<Id,Id> mapAssignedUser2 = new Map<Id,Id>();
        if(setOPSTeam != null && setOPSTeam.size()>0) {
        	List<OpsAssignmentRules__c> opsAssignRules1 = [SELECT id,AssignToUser__c,User__c FROM OpsAssignmentRules__c WHERE 
                                                           AssignToUser__c IN :setOPSTeam and User__c IN :setOPSTeam];
            for(OpsAssignmentRules__c opsAssignedObj : opsAssignRules1) {
                if(opsAssignedObj.AssignToUser__c == opsAssignedObj.User__c) {
                    mapAssignedUser2.put(opsAssignedObj.AssignToUser__c,opsAssignedObj.Id);
                }       
            }       
        }
        
        try {
        	for(Case caseObj:caseList) {
            /***********************************************************************************************************************
            *                               Hack to bypass migration issues                                                        *
            ************************************************************************************************************************/ 
            if(userProfileId != null && !UserInfo.getProfileId().equalsIgnoreCase(userProfileId)) {  
                if(rtMapByName.get( caseObj.RecordTypeId ).getName() == 'Internal OPS to OPS') {
            /***********************************************************************************************************************
            *                               Escalation Check starts                                                                *
            *                   If case has been updated by RCSF Sync user, means escalation has fired                             *
            ************************************************************************************************************************/            
                        
                    if(caseObj.IsEscalated  && caseObj.OPS_ESCALATED__c == null) {
                                 caseObj.OPS_ESCALATED__c ='Yes';
                                 caseObj.Assign_To__c='User';
                                 caseObj.Status='Assigned' ;
                                 caseObj.OPS_Last_Action__c ='Take Assignment';
                    }
            /***********************************************************************************************************************
            *                                      End escalation                                                                  *
            ************************************************************************************************************************/
                          
                    if(caseObj.ownerid!=userinfo.getUserId() && caseObj.OPS_Last_Action__c!='Recall' &&
                             caseObj.OPS_Last_Action__c !='Take Assignment' ) {
                         caseObj.OPS_Last_Action__c ='Error';
                    } else {                       
                            if(caseObj.Ops_Recall__c==null) {
                                caseObj.Ops_Recall__c=0; 
                            } 
                            if(caseObj.Ops_ReAssig__c==null) {
                                caseObj.Ops_ReAssig__c=0; 
                            }            
                           
            /****************************************************************************************************************
             *                                 For Ops Contact field update start                                           *
             ***************************************************************************************************************/
                            
                            try {  
                                if(caseObj.OPS_Last_Action__c=='Recalled'){
                                      caseObj.OPS_Last_Action__c='';
                                }
                                System.Debug('>>!!>>>'+listAccountOPS);
                                if(listAccountOPS != null) {
                                    for(Account accObj : listAccountOPS) {
                                        for(Contact cont : accObj.Contacts) {
                                            if(UserInfo.getUserEmail() == cont.Email) {
                                                caseObj.ContactId = cont.Id;
                                            }
                                        }   
                                    }
                                }
                            }
                            catch(Exception e){GetException(e);}
             /*************************************************************************************************************
             *                                 For Ops Contact field update END                                           *
             **************************************************************************************************************/
               
                            if(caseObj.Assign_To__c != null && caseObj.Assign_To__c.equalsIgnoreCase('Business Unit')) {
                                caseObj.Assigned_OPS_User__c = null;
                                if(groupMapBussUnit != null && caseObj.Ops_Bussiness_Units__c != null) {
                                    string bussUnit = 'OPS '+ caseObj.Ops_Bussiness_Units__c;
                                    if(groupMapBussUnit.get(bussUnit) != null) {
                                        caseObj.ownerid = groupMapBussUnit.get(bussUnit);
                                        System.Debug('>>22>>>'+caseObj.ownerid);
                                    }
                                }
                            }
                            else if(caseObj.Assign_To__c != null && caseObj.Assign_To__c.equalsIgnoreCase('User')&& caseObj.Assigned_OPS_User__c!=null ) {
                            		if(mapOPSAssRules != null && caseObj.Assigned_OPS_User__c != null && 
                                        mapOPSAssRules.get(caseObj.Assigned_OPS_User__c) != null) {
                                    System.Debug('>>10>>>'+ mapOPSAssRules.get(caseObj.Assigned_OPS_User__c));      
                                    OpsAssignmentRules__c oppAssignObj = mapOPSAssRules.get(caseObj.Assigned_OPS_User__c);
                                    System.Debug('>>11>>>'+ oppAssignObj);       
                                    caseObj.ownerid = oppAssignObj.AssignToUser__c;
                                    System.Debug('>>122>>>'+ caseObj.ownerid);  
                                    if(mapAssignedUser1 != null && oppAssignObj.AssignToUser__c != null &&  
                                            mapAssignedUser1.get(oppAssignObj.AssignToUser__c) != null) {
                                                System.Debug('>>12>>>'+ mapAssignedUser1.get(oppAssignObj.AssignToUser__c));  
                                                System.Debug('>>13>>>'+ oppAssignObj);  
                                                caseObj.Assigned_OPS_User__c = mapAssignedUser1.get(oppAssignObj.AssignToUser__c);
                                                System.Debug('>>14>>>'+ caseObj.Assigned_OPS_User__c);  
                                    }
             						/*********************************************************************************************
             						*                                 Start delegation process                                   *
             						**********************************************************************************************/
                                    
                                    if(mapAssignedToUser != null && oppAssignObj.AssignToUser__c != null && 
                                        mapAssignedToUser.get(oppAssignObj.AssignToUser__c) != null) {
                                        User u = mapAssignedToUser.get(oppAssignObj.AssignToUser__c);
                                        if(u.Ops_TeamMemName__c != null)
                                        caseObj.ownerid = u.Ops_TeamMemName__c; 
                                        if(mapAssignedUser2 != null && u.Ops_TeamMemName__c != null && 
                                            mapAssignedUser2.get(u.Ops_TeamMemName__c) != null) {
                                            caseObj.Assigned_OPS_User__c = mapAssignedUser2.get(u.Ops_TeamMemName__c);
                                        }   
                                    }
						             /**********************************************************************************************
						             *                                 End delegation process                                      *
						             ***********************************************************************************************/
                                    
                          
                                    if(caseObj.OPS_Last_Action__c != 'Recall') {
                                        caseObj.status = caseObj.status == 'New' ? 'Assigned' :caseObj.status;
                                    }
                                }
                            }
                        }
                   }
               }
            } 
        }catch(System.Exception e) { 
            GetException(e);
        }       
    }
    
    /************************Method For Insert Manager For Support***************************************
	* @Description -                                     											    *
	* @Author      - Simplion Technologies                                                              * 
	*****************************************************************************************************/
    
    
    Public Static Void InsertManagerForSupport(List<Case> NewCaseList,Map<id,User> mapUser,Set<Id> setUserId,List<Id> profileIds){
    	
    	Id userProfileId = [SELECT id FROM Profile WHERE name =: SYSTEM_ADMINISTRATOR LIMIT 1].id;
    	Map<Id,Profile> profMap = new Map<Id, Profile>([SELECT Name FROM Profile WHERE Id IN :profileIds]);
    	List<Employee__c> EmpList = [SELECT Manager_Employee_Number__r.Last_Name__c, Manager_Employee_Number__r.First_Name__c, 
                                Manager_Employee_Number__c, User__c FROM Employee__c WHERE User__c IN:  setUserId LIMIT 1000]; 
        Map<id, Employee__c> empMap = new Map<id, Employee__c>();
	    for(Employee__c empObj: EmpList){
	        empMap.put(empObj.User__c , empObj);        
	    }
    	
    	List<String> s = null;
          String emailStr;
          for(Case caseObj: NewCaseList) { 
              //Profile Pro = null;
              if(!UserInfo.getProfileId().equalsIgnoreCase(userProfileId)) {   
                        /* Added New Record Type 'Support - System Ops' And 'Support - DSAT' On 6/23/2011 */
                        /* Added New Record Type 'Support - Tech Assist' on 7/7/2011 */
                        String idCheck = caseObj.OwnerId;
                        if(!idCheck.startsWith('00G') && userProfileId != null && !UserInfo.getProfileId().equalsIgnoreCase(userProfileId) && mapUser != null){
                            User user1;
                            if(mapUser.get(caseObj.OwnerId) != null)
                            user1 = mapUser.get(caseObj.OwnerId);
                            if(user1 != null){
                                if(profMap != null && profMap.get(user1.ProfileId).Name != SYSTEM_ADMINISTRATOR ){   
                                      if(empMap != null && empMap.get( caseObj.OwnerId ) != NULL 
                                        && empMap.get( caseObj.OwnerId ).Manager_Employee_Number__r.First_Name__c != NULL
                                        && empMap.get( caseObj.OwnerId ).Manager_Employee_Number__r.Last_Name__c != NULL){
                                        	
                                              String fName = empMap.get( caseObj.OwnerId ).Manager_Employee_Number__r.First_Name__c ;
                                              String LName = empMap.get( caseObj.OwnerId ).Manager_Employee_Number__r.Last_Name__c;
                                              caseObj.Support_Owner_Manager__c = fName +' '+lName ;
                                              
                                        } 
                                 }else {
                                      caseObj.Support_Owner_Manager__c = null;
                                 }
                            }
                         }else {
                          		caseObj.Support_Owner_Manager__c = null;
                         }
                 }
               }
             }
             
       Public Static List<Profile> ProfileListMethod(){
       	
       		return 	[SELECT id , name  FROM Profile WHERE name =: 'System Administrator'
                                                      OR name =: 'Support Agent - T1'];
       } 
       
       Public Static List<User> UserListMethod(Set<id> setUserId){
       
       		return [SELECT ProfileId, Team__c, Manager.Name, Manager.Email , UserRoleId, IsActive, ManagerId, Name, 
                                            Email FROM User WHERE Id IN:setUserId];
       }
       
       Public Static List<Group> GroupBussListMethod(Set<String> setOPSBussUnit){
       		
       		return [SELECT id,Name FROM GROUP WHERE Type = 'Queue' AND Name IN :setOPSBussUnit];
       }
       
       Public Static List<Account> AccountListMethod(){
       	
       		return [SELECT (SELECT Id,Email,Name FROM Contacts) FROM Account WHERE Name='RC OPS Team'];
       } 
       
       Public Static List<User> UserListMedalliaSurvey(Set<Id> setUserId){
       		
       		return [SELECT ProfileId, Team__c, Manager.Name, Manager.Email , UserRoleId, IsActive, ManagerId, Name, 
                                                    Id, Email,Username FROM User WHERE Id IN : setUserId];
       }
       
       Public Static List<Account> AccountListPotingOut(Set<id> setAccountId){
       
       		return [SELECT Id,MRR__c,inContract__c,Sales_Agreement_End_Date__c,Number_of_DL_s__c,Account.Name, 
                                                    Current_Owner_Email__c,Most_Recent_Opportunity_Owner_Email__c,Sales_Agreement_Start_Date__c 
                                                    FROM Account WHERE Id IN:setAccountId];
       }
       
	   Public Static Void GetException(Exception e){
			
			system.debug('Exception type caught: ' + e.getTypeName());    
    		system.debug('Message: ' + e.getMessage());    
    		system.debug('Cause: ' + e.getCause());  
    		system.debug('Line number: ' + e.getLineNumber());    
    		system.debug('Stack trace: ' + e.getStackTraceString());   
		}
	}