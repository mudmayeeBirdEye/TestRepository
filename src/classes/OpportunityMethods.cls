/*************************************************
OpportunityMethods class
This Class is used by Account.trigger.
sendActivePipeLimitEmail sends an email notification to Opportunity owners who have crossed their activepipe limit
/************************************************/

public class OpportunityMethods {
	public static boolean OpportunityUpdate_FirstRun = true;
	/*
	sendActivePipeLimitEmail accepts an Opportunity and two Integers
	activePipeCount is the number of ActivePipe Opps the Opportunity owner has.
	activePipeLimit is the limit of ActivePipe Opps the Opportunity owner is supposed to have. 
	*/
	public void sendActivePipeLimitEmail(Opportunity o, Integer activePipeCount, Integer activePipeLimit){
		system.debug('THIS IS acivepipecount / limit: ' + activePipeCount + ', ' + activePipeLimit);
		// send out warning email	
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		// set recepient		
		mail.setTargetObjectId(UserInfo.getUserId());
		mail.setSaveAsActivity(false);
		String[] ccAddresses = new String[] {o.Owner_Manager_Email__c};
		mail.setCcAddresses(ccAddresses);
		
		mail.setSubject('RingCentral SalesForce: You have crossed your ActivePipe Opportunity Limit');												
							
		mail.setPlainTextBody('Your current total of ActivePipe Opportunties is ' + activePipeCount + '. Your ActivePipe limit is ' + activePipeLimit + ' Opportunities.\n\n\n' +
		'Please cleanup your ActivePipe Opportunities. \n\n\n' +
		'Thanks, \n' + 
		'Business Services Team' );						

	 try{
		Messaging.sendEmail(new Messaging.Singleemailmessage[] {mail});	
        }catch(Exception e){}	
	}
	
	/***************Code for updating the Parent Account*********************/   
	public void updateParentAccount(Map<Id,opportunity> newOppMap, Map<Id,opportunity> oldOppMap){
		Set<Id> setOppOwnerIds=new Set<Id>();
    	Map<Id, User> userMap = new Map<Id, User>();
        List<Account>  accountList = new List<Account> ();
        for(Opportunity  opp:newOppMap.values()){
	      	if(oldOppmap==null || (newOppMap.get(opp.Id).OwnerId != oldOppMap.get(opp.Id).OwnerId)) {
				setOppOwnerIds.add(opp.OwnerId);	
				// System.debug('***setOppOwnerOnUpdation***'+setOppOwnerIds);
		    }
    	}
		userMap = getOwnerList(setOppOwnerIds);
		for(Opportunity opp : newOppMap.values()){
	   		if(oldOppmap==null || (newOppMap.get(opp.Id).OwnerId != oldOppMap.get(opp.Id).OwnerId)) {
		    	Account objAcc = New Account(Id=opp.Accountid);
		    	objAcc.Most_Recent_Opportunity_Owner__c = opp.OwnerId;
		    	objAcc.Most_Recent_Opportunity_Owner_Email__c = userMap.get(opp.OwnerId).Email;
		    	objAcc.Most_Recent_Opportunity_Owner_FirstName__c = userMap.get(opp.OwnerId).FirstName;
                objAcc.Most_Recent_Opportunity_Owner_LastName__c = userMap.get(opp.OwnerId).LastName;
                objAcc.Most_Recent_Opportunity_Owner_Phone__c = userMap.get(opp.OwnerId).Phone;
		    	accountList.add(objAcc);
	   		}
		}   
		System.debug('***accountList***'+accountList); 
	    if(accountList !=null && accountList.size()>0) {
	    	try{
	    		TriggerHandler.BY_PASS_ACCOUNT_ON_UPDATE();
	    		update accountList;
	    		//TriggerHandler.RESET_VARIABLES();
	    		TriggerHandler.BY_PASS_ACCOUNT_ON_UPDATE = false;
	 	    } catch(Exception e){}
		}
	}
	
	public void updateAccountMostRecentContact(Map<Id,opportunity> newOppMap, Map<Id,opportunity> oldOppMap) {
		try {
			List<Account>  accountList = new List<Account>();
			map<id,id> mapOpportunityToContact = new map<id,id>();
	        for(OpportunityContactRole objOppContactRole: [SELECT Id, IsPrimary, ContactId, OpportunityId FROM OpportunityContactRole where OpportunityId 
	        												IN: newOppMap.keyset() and IsPrimary = true order by lastmodifieddate asc]) {
    			mapOpportunityToContact.put(objOppContactRole.OpportunityId,objOppContactRole.ContactId);											
			}
			set<Id> accountIdSet = new set<Id>();
			for(Opportunity oppObj : newOppMap.values()) {
				accountIdSet.add(oppObj.AccountId);
			}
			map<Id,Account> mapAccountMap = new map<Id,Account>([select Most_Recent_Opportunity_Contact__c from Account where Id IN : accountIdSet]);
			
			for(Opportunity opp : newOppMap.values()){
				if(!String.isBlank(opp.AccountId)) {
					Account objAcc1 = New Account(Id = opp.AccountId);
					if(mapAccountMap != null && mapAccountMap.get(opp.AccountId) != null && mapOpportunityToContact != null 
						&& mapOpportunityToContact.get(opp.id) != null && 
							mapAccountMap.get(opp.AccountId).Most_Recent_Opportunity_Contact__c !=  mapOpportunityToContact.get(opp.id)) {
						objAcc1.Most_Recent_Opportunity_Contact__c = mapOpportunityToContact.get(opp.id);
						accountList.add(objAcc1);
					}
				}
			} 
			System.debug('***accountList***'+accountList); 
		    if(accountList != null && accountList.size()>0) {
		    	try{
		    		TriggerHandler.BY_PASS_ACCOUNT_ON_UPDATE();
		    		update accountList;
		    		TriggerHandler.RESET_VARIABLES();
		 	    } catch(Exception e){}
			}
		} catch(Exception ex) {}
	} 
    
	private Map<Id, User> getOwnerList(Set<Id> setOppOwnerIds) {
    	return new Map<Id, User>([SELECT Id, Name, Email, FirstName, LastName, Phone FROM User WHERE Id IN:setOppOwnerIds]);
    }
    
    public static Map<string,Decimal> getAmountByLeadSource() {
    	map<string,Decimal> rtnLeadSourceAmountMap = new map<string,Decimal>();	
    	try {
		 	List<Document> docList = [Select body, bodyLength, ContentType, Url from Document where Name = 'OpportunityLeadSourceMapping'];
		 	if(docList != null && docList.size()>0) {
		 		if(docList[0].Body != null) {
		 			List<List<String>> parsedCSV =  parseCSV(docList[0].Body.toString(),true);
		 			if(parsedCSV != null) {
	 					for(List<String> listObj : parsedCSV) {
	 						if(!string.isBlank(listObj[0]) &&  !string.isBlank(listObj[3])) {
	 							system.Debug('>>listObj[3]>>>'+ listObj[3]);
	 							string formatAmount = listObj[3].replace('$','').replace('"','').replace(',','').trim();
	 							system.Debug('>>formatAmount>>>'+ formatAmount);
	 							rtnLeadSourceAmountMap.put(listObj[0],Decimal.valueOf(formatAmount));	
	 						}
                		} 
		 			}
		 		}		
		 	}
		 	return rtnLeadSourceAmountMap;
    	} catch(Exception ex) {
    		system.Debug('>>ex>>>'+ ex.getMessage());
    	}
    	return null;
    }
    /********************************************************************************************************************************************
    * @Description : This method is used to parse the CSV file Product_Forecast_Amounts. The file contains the Price depeding on the RC Tier and*
    *                RC Brand. 																													*
    * @Authot	   : Simplion Tecnologies. 25th April,2014.                                                                                     * 						
    * @Params      : void                                 				  																		*
    * @Return      : pageReference                                                         														* 
    ********************************************************************************************************************************************/
    public static Map<string,Decimal> getAmountByBrandAndTier() {
    	map<string,Decimal> rtnLeadSourceAmountMap = new map<string,Decimal>();	
    	try {
		 	List<Document> docList = [Select body, bodyLength, ContentType, Url from Document where Name = 'Product_Forecast_Amounts'];
		 	if(docList != null && docList.size()>0) {
		 		if(docList[0].Body != null) {
		 			List<List<String>> parsedCSV =  parseCSV(docList[0].Body.toString(),true);
		 			if(parsedCSV != null) {
	 					for(List<String> listObj : parsedCSV) {
	 						if(!string.isBlank(listObj[0]) &&  !string.isBlank(listObj[1])) {
	 							system.Debug('>>listObj[1]>>>'+ listObj[1]);
	 							string formatAmount = listObj[1].replace('$','').replace('"','').replace(',','').trim();
	 							system.Debug('>>formatAmount>>>'+ formatAmount);
	 							rtnLeadSourceAmountMap.put(listObj[0],Decimal.valueOf(formatAmount));	
	 						}
                		} 
		 			}
		 		}		
		 	}
		 	return rtnLeadSourceAmountMap;
    	} catch(Exception ex) {
    		system.Debug('>>ex>>>'+ ex.getMessage());
    	}
    	return null;
    }
    private static List<List<String>> parseCSV(string contents, Boolean skipHeaders) {
    	List<List<String>> allFields = new List<List<String>>();
        contents = contents.replaceAll(',"""',',"DBLQT').replaceall('""",','DBLQT",');
        contents = contents.replaceAll('""','DBLQT');
        List<String> lines = new List<String>();
        try {
            lines = contents.split('\n');
        } catch (System.ListException e) {
            System.debug('Limits exceeded?' + e.getMessage());
        }
        Integer num = 0;
        for(String line : lines) {
            if (line.replaceAll(',','').trim().length() == 0) break;
            List<String> fields = line.split(',');  
            List<String> cleanFields = new List<String>();
            String compositeField;
            Boolean makeCompositeField = false;
            for(String field : fields) {
                if (field.startsWith('"') && field.endsWith('"')) {
                    cleanFields.add(field.replaceAll('DBLQT','"'));
                } else if (field.startsWith('"')) {
                    makeCompositeField = true;
                    compositeField = field;
                } else if (field.endsWith('"')) {
                    compositeField += ',' + field;
                    cleanFields.add(compositeField.replaceAll('DBLQT','"'));
                    makeCompositeField = false;
                } else if (makeCompositeField) {
                    compositeField +=  ',' + field;
                } else {
                    cleanFields.add(field.replaceAll('DBLQT','"'));
                }
            }
            allFields.add(cleanFields);
        }
        if (skipHeaders) allFields.remove(0);
        return allFields; 
    }
    
  /*  public static testMethod void testOpportunityMethods() {
		try{
			Account accObj = new Account(name='testa');
	        insert accObj;
	        Set<Id> testSet=new  Set<Id>();
	        Map<Id,Opportunity> testMapOldOpp=new Map<Id,Opportunity>();
	        Opportunity oppObj = new Opportunity();
            oppObj.Name = 'TestaOppOwnerD';
            oppObj.AccountId = accObj.Id;
            oppObj.Type = 'New Business';
            oppObj.CloseDate = Date.today();
            oppObj.StageName = OpportunityHelper.defaultOpportunityStage;
            oppObj.OwnerId = '005800000037xj5';
            oppObj.Owner_Manager_Email__c = 'jesse2@ringcentral.com';
            testMapOldOpp.put(oppObj.Id,oppObj);
            insert testMapOldOpp.values();
            Test.startTest();
	        OpportunityMethods om = new OpportunityMethods();
	        om.sendActivePipeLimitEmail(oppObj, 2, 3); 
	        om.getOwnerList(testSet);
	        om.updateParentAccount(testMapOldOpp, null); 
	        Test.stopTest();     
     	} catch(Exception e){}   
    }*/
}