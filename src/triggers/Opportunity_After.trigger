trigger Opportunity_After on Opportunity (after insert,after update) {
	/*********************** DFR CODE *******************************/
   	if (Trigger.new.size() == 1) {
   		try { 
			
			/*
			Map<String, String> mapDFRRType = new Map<String, String>();
			//Map<String, DFR_Opportunity_Record_Type__c> mapDFRRType = DFR_Opportunity_Record_Type__c.getAll();
			
			if(!test.isRunningTest()){			
				for(DFR_Opportunity_Record_Type__c d : [Select name from DFR_Opportunity_Record_Type__c]){
					mapDFRRType.put(d.name,d.name);
				}
			}else{
				mapDFRRType =  new Map<String,String>{
					'Sales_Opportunity' => 'Sales_Opportunity',
					'VAR_Opportunity' => 'VAR_Opportunity'};
			}
			*/
			list<String> DFROppRType = DG_DFR_Class.getDFROppRType(); 
			
			Map<Id,String> mapRTId = new Map<Id,String>();
			for(RecordType r : [Select r.Id, r.DeveloperName From RecordType r where r.SobjectType = 'Opportunity'
				and r.DeveloperName in :DFROppRType]){
				mapRTId.put(r.Id,r.DeveloperName);
			}
			/*if(Trigger.isUpdate  && trigger.isAfter){	          
				if (Trigger.old[0].Primary_Opportunity_Contact__c <> Trigger.new[0].Primary_Opportunity_Contact__c 
				&& Trigger.old[0].DFR_FromLeadConvert__c == Trigger.new[0].DFR_FromLeadConvert__c) {
					if (Trigger.new[0].Primary_Opportunity_Contact__c == Null){
						DG_DFR_Class.DFR_RemoveOpportunity(Trigger.new[0].id, Trigger.old[0].Primary_Opportunity_Contact__c);
					}
			 		if (Trigger.new[0].Primary_Opportunity_Contact__c <> Null
			 		&& mapRTId.containsKey(Trigger.new[0].RecordTypeId)){
						DG_DFR_Class.DFR_AddOpportunity(Trigger.new[0]);
					}
			    } 
		  	}*/
		  	if(Trigger.isUpdate  && trigger.isAfter){             
                if (Trigger.old[0].Primary_Opportunity_Contact__c <> Trigger.new[0].Primary_Opportunity_Contact__c 
                && Trigger.old[0].DFR_FromLeadConvert__c == Trigger.new[0].DFR_FromLeadConvert__c) {
                    String StrError = '';
                    try{
                        strError = StrError + 'Opportunity Id: ' + Trigger.new[0].id + ' \r\n';
                        strError = StrError + 'Contact Id: ' + Trigger.new[0].Primary_Opportunity_Contact__c + ' \r\n';
                        strError = StrError + 'Account Id: ' + Trigger.new[0].AccountId + ' \r\n';  
                        strError = StrError + '4000: Primary Contact added to Opportunity' + ' \r\n';
                        
                        if (Trigger.new[0].Primary_Opportunity_Contact__c == Null){
                            DG_DFR_Class.DFR_RemoveOpportunity(Trigger.new[0].id, Trigger.old[0].Primary_Opportunity_Contact__c);
                        }
                        if (Trigger.new[0].Primary_Opportunity_Contact__c <> Null
                        && mapRTId.containsKey(Trigger.new[0].RecordTypeId)){
                            strError = StrError + '4100: Qualified opp recordtype' + ' \r\n';
                            DG_DFR_Class.DFR_AddOpportunity(Trigger.new[0]);
                        }
                        
                        strError = StrError + '4200: Exit - Primary Contact added to Opportunity' + ' \r\n';
                    }catch(exception e){
                        strError = StrError + 'Error: Lead_After - ' + e.getMessage() + ' \r\n';
                    }
                    insert new Exception_And_Notification_History__c( 
                        Exception__c = 'Lead Conversion Exception - Opportunity_After Trigger - ' + System.Now().format(), 
                        Exception_Desc__c = strError,
                        RecordTypeId = '01280000000UF6F');  
                } 
            }  
		  	if(Trigger.isInsert  && trigger.isAfter){	          
				if (Trigger.new[0].Primary_Opportunity_Contact__c <> Null 
				&& mapRTId.containsKey(Trigger.new[0].RecordTypeId)) {
						DG_DFR_Class.DFR_AddOpportunity(Trigger.new[0]);
			    } 
		  	}    
		  	DG_DFR_Class.DFR_AddOpportunityToExistingDFR(Trigger.New);
   		} catch(Exception e) {} 
	}  
	/******************************************************************/
   if(trigger.isUpdate && trigger.isAfter){
		/************************* DFR CODE (DemandGen)***********************************/   		
   			DG_DFR_Class.DFR_OpportunityClosed(trigger.new, trigger.old);
   		/************************* DFR CODE (DemandGen) Ends **************************/
   		 
   		/************************* Code For Creating Medallia Survey Record ON OPPORTUNITY Update Starts*****************************
	    * @Description - Create Medallia Survey Record if Amount > $75													            *
	    * @Author      - Simplion Technologies                 										 	             		        * 
		****************************************************************************************************************************/
			try {
				Boolean isMedallia = (Medallia_Credentials__c.getInstance('Medallia') != NULL && Medallia_Credentials__c.getInstance('Medallia').isMedallia__c)?true:false;
				if(isMedallia){
					List<Opportunity> opptyList = new List<Opportunity>();
					for(Opportunity opp : trigger.new){
						/*
						system.debug(opp.StageName+ ' Stage');
						system.debug(userNam+' userNam');
						system.debug(userTyp+ ' userTyp');
						*/
						// if(opp.Amount >= 75 && (opp.StageName =='8. Closed Won' || opp.StageName == '7. Closed Won') && opp.StageName != trigger.oldMap.get(opp.id).StageName && !userNam.containsIgnoreCase('RCSF') && userTyp!='Customer')
						if(opp.Amount >= 75 && (opp.StageName == '8. Closed Won' || opp.StageName == '7. Closed Won') 
							&& opp.StageName != trigger.oldMap.get(opp.id).StageName 
							&& UserInfo.getUserType().equalsIgnoreCase('Standard') 
							&& !UserInfo.getName().containsIgnoreCase('RCSF')){	
								opptyList.add(opp);
						}
					}
					if(!opptyList.isEmpty()){
						MedalliaSurveyHelper.insertSignatureMedalliaSurvey(opptyList);
					}
				}
			}catch(Exception e){}	
		
		/*********************************** Code For Creating Medallia Survey Record ON OPPORTUNITY Update Ends**********************/  
   }
    
	
	/*New Code for Save CSAT create when Stag == '8. Closed Won' on creation*/
	if(TriggerHandler.BY_PASS_OPPORTUNITY_ON_INSERT || TriggerHandler.BY_PASS_OPPORTUNITY_ON_UPDATE){
		System.debug('### RETURNED FROM OPP INSERT-AFTER TRG ###');
		return;
	} else {
		System.debug('### STILL CONTINUE FROM OPP INSERT-AFTER TRG ###');
	}
	Profile prof = [select Name from Profile where Id = :UserInfo.getProfileId()];
	OpportunityMethods objOpportunityMethods = new OpportunityMethods();
    if(trigger.isInsert) {
    	Set<id> oppSetForCsatSurveyOnInsertion = new Set<Id>();
    	for(Opportunity NewOppObj :trigger.new) {
    		if(NewOppObj != NULL && OpportunityHelper.isClosedOpp(NewOppObj.StageName)  && !'Channel Sales Manager'.equalsIgnoreCase(prof.Name)) {
    	    	 /* 	 *Channel sales manager profile is excluded because we dont want to send those contacts surveys*/
					if(!'System Administrator'.equalsIgnoreCase(prof.Name)) {
						/*IF RecordType Save Opportunity AND Brand contains RingCentral Then CREATE CSAT Survey*/ 
						if(NewOppObj.RecordTypeId  == OpportunityHelper.getOppRecordTypeMap('Saves Opportunity') 
													   && NewOppObj.Brand_Name__c.contains('RingCentral')) {
															oppSetForCsatSurveyOnInsertion.add(NewOppObj.id);//Collecting Opp id/s for Survey
					 } 					 			
				}
			}
       }
       /*Creating survey*/ 
		if(oppSetForCsatSurveyOnInsertion.size() > 0) {
						OpportunitySurveyClass Osc = new OpportunitySurveyClass(oppSetForCsatSurveyOnInsertion,'Saves CSAT','ON_INSERT');
					 	System.debug('---------------------CSAT Survey on insertion---------------');	
		}
		objOpportunityMethods.updateParentAccount(trigger.newMap, null);
   }
   if(trigger.isUpdate) {
        objOpportunityMethods.updateParentAccount(trigger.newMap, trigger.oldMap);
        if(OpportunityMethods.OpportunityUpdate_FirstRun){
  			objOpportunityMethods.updateAccountMostRecentContact(trigger.newMap, trigger.oldMap);
			OpportunityMethods.OpportunityUpdate_FirstRun = false;
		}
   }
    /*******************************************************************
	 * @Description.: updating the Account's lastTouchbySalesAgent     *
	 * @updatedBy...: India team                                       *
	 * @updateDate..: 19/03/2014                                       *
	 * @Case Number.: 02432238                                         *
	 *******************************************************************/
	/*********************************************Code for Case Number:02432238 Start from here *****************************************/
	try{
		User userObj = [SELECT Id, FirstName, Lastname, Name, Email, Phone, ProfileId FROM User WHERE Id =: UserInfo.getUserId()];
		List<Account> accountList = new List<Account>();
		if(prof.Name.toLowerCase().contains('sales') && !prof.Name.toLowerCase().contains('engineer') ){
			for(Opportunity opportunityObj: trigger.New){
				if(opportunityObj.AccountId != null ) {
					/*setAccountId.add(opportunityObj.AccountId);*/
					accountList.add(new Account(Id=opportunityObj.AccountId));
				}
			}
			AccountTriggerHelperExt.updateLastTouchedSalesPerson(accountList,userObj);
		}
	}catch(Exception Ex){
		system.debug('#### Error on line - '+ex.getLineNumber());
		system.debug('#### Error message - '+ex.getMessage());
	}
	/******************************************Code for Case Number:02432238 End's here*************************************************/
}