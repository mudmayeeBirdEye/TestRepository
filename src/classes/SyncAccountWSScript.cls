public class SyncAccountWSScript {
	
	public WRSyncAccountWSParameter wrParameterObj {get;set;}
	public WRSyncAccountWSParameter wrParameterObjOut {get;set;}
	public String strMsg {get;set;}
	
	public SyncAccountWSScript() {
		wrParameterObj = new WRSyncAccountWSParameter();
		wrParameterObjOut = new WRSyncAccountWSParameter();
	}
	
	public void callScript() {
		try {
			if(String.IsBlank(wrParameterObj.inContactEmail)) {
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Contact email is mandatory.'));
			} else {
				wrParameterObjOut = synAccountNew(wrParameterObj);
				System.debug('>>>11>>'+ wrParameterObj.outAccountID);
				System.debug('>>>22>>'+ wrParameterObj.outContactID);
				System.debug('>>>33>>'+ wrParameterObj.outUserID);
			}
		} catch(Exception ex) {}
	}
	
	public WRSyncAccountWSParameter synAccountNew(WRSyncAccountWSParameter vsyncAcctInputParam) {
		strMsg = ''; 
		wrParameterObj.outAccountID = null;  
		wrParameterObj.outContactID = null;  
		wrParameterObj.outUserID = null;
		vsyncAcctInputParam.proc_UserId = null; 
		vsyncAcctInputParam.proc_AccountId = null;
		vsyncAcctInputParam.proc_ContactId = null;
		vsyncAcctInputParam.proc_UserRecCreation = null;
		wrParameterObj = new WRSyncAccountWSParameter(); 
   	    if(searchAccountByUID(vsyncAcctInputParam) == true){
        	strMsg = 'Account found matching RCUser Id';            
            /*Block*/
            if(accountMatchingContactEmail(vsyncAcctInputParam) == true){
            	strMsg = strMsg + ' &#10152; ' + 'Contact found matching Email and account Id'; 
                if(contactHavingUserRecord(vsyncAcctInputParam) == true){
                	strMsg = strMsg + ' &#10152; ' + 'User found with same contact email & RCUser Id'; 
                    handleRetrun(vsyncAcctInputParam);
                    strMsg = strMsg + ' &#10152; ' + 'Returned Output Parameters.'; 
                }else{
                	strMsg = strMsg + ' &#10152; ' + 'No User found with same contact email & RCUser Id';
                    if(handleCreateUser(vsyncAcctInputParam) == true){
                    	strMsg = strMsg + ' &#10152; ' + 'New User will be created'; 
                        handleRetrun(vsyncAcctInputParam);
                        strMsg = strMsg + ' &#10152; ' + 'Returned Output Parameters.'; 
                    }
                }
            }else{
            	strMsg = strMsg + ' &#10152; ' + 'No Contact found matching contact mail and account Id'; 
                if(handleCreateContact(vsyncAcctInputParam) == true){
                	strMsg = strMsg + ' &#10152; ' + 'New contact will be created'; 
                    if(handleCreateUser(vsyncAcctInputParam) == true){
                    	strMsg = strMsg + ' &#10152; ' + 'New User will be created'; 
                        handleRetrun(vsyncAcctInputParam);
                        strMsg = strMsg + ' &#10152; ' + 'Returned Output Parameters.'; 
                    }
                }
            }
            /*Block*/
        }else{
        	strMsg = 'No Account found with matching RCUser Id';
        	strMsg = strMsg + ' &#10152; ' + 'Now search through opportunity Id';
            if(vsyncAcctInputParam.inOpportunityId != null && vsyncAcctInputParam.inOpportunityId != ''){
                if(searchOppertunityByOID(vsyncAcctInputParam) == true){
                	strMsg = strMsg + ' &#10152; ' + 'Opportunity found with matching Opportunity Id'; 
                    if(handleUpdateAccount(vsyncAcctInputParam) == true){
                        /*Block*/
                        if(accountMatchingContactEmail(vsyncAcctInputParam) == true){
                        	strMsg = strMsg + ' &#10152; ' + 'Contact found with matching mail & account Id'; 
                            if(contactHavingUserRecord(vsyncAcctInputParam) == true){
                            	strMsg = strMsg + ' &#10152; ' + 'User found with same contact found & RCUser Id'; 
                                handleRetrun(vsyncAcctInputParam);
                                strMsg = strMsg + ' &#10152; ' + 'Returned Output Parameters.'; 
                            }else{
                            	strMsg = strMsg + ' &#10152; ' + 'No User found with same contact found & RCUser Id'; 
                                if(handleCreateUser(vsyncAcctInputParam) == true){
                                	strMsg = strMsg + ' &#10152; ' + 'New User will be created.'; 
                                    handleRetrun(vsyncAcctInputParam);
                                     strMsg = strMsg + ' &#10152; ' + 'Returned Output Parameters.';
                                }
                            }
                        }else{
                        	strMsg = strMsg + ' &#10152; ' + 'No Contact found with matching mail & account Id'; 
                            if(handleCreateContact(vsyncAcctInputParam) == true){
                            	strMsg = strMsg + ' &#10152; ' + 'New contact will be created';
                                if(handleCreateUser(vsyncAcctInputParam) == true){
                                	strMsg = strMsg + ' &#10152; ' + 'New User will be created.'; 
                                    handleRetrun(vsyncAcctInputParam);
                                    strMsg = strMsg + ' &#10152; ' + 'Returned Output Parameters.'; 
                                }
                            }
                        }
                        /*Block*/
                    }else{
                        handleRetrun(vsyncAcctInputParam);
                    }
                }else{
                	strMsg = 'No opportunity found with matching opportunity Id';
                    if(searchContactByMail(vsyncAcctInputParam) == true){
                    	strMsg = strMsg + ' &#10152; ' + 'Contact found with matching email'; 
                        if(handleUpdateAccount(vsyncAcctInputParam) == true){
                            /*Block*/
                            if(accountMatchingContactEmail(vsyncAcctInputParam) == true){
                            	strMsg = strMsg + ' &#10152; ' + 'Contact found matching contact Id & account Id'; 
                                if(contactHavingUserRecord(vsyncAcctInputParam) == true){
                                	strMsg = strMsg + ' &#10152; ' + 'User found with same contact email & RCUser Id'; 
                                    handleRetrun(vsyncAcctInputParam);
                                    strMsg = strMsg + ' &#10152; ' + 'Returned Output Parameters.'; 
                                }else{
                                    if(handleCreateUser(vsyncAcctInputParam) == true){
                                    	strMsg = strMsg + ' &#10152; ' + 'New User will be created.'; 
                                        handleRetrun(vsyncAcctInputParam);
                                        strMsg = strMsg + ' &#10152; ' + 'Returned Output Parameters.'; 
                                    }
                                }
                            }else{
                            	strMsg = strMsg + ' &#10152; ' + 'No Contact found with matching Contact Email & account Id';
                                if(handleCreateContact(vsyncAcctInputParam) == true){
                                	strMsg = strMsg + ' &#10152; ' + 'New contact will be created';
                                    if(handleCreateUser(vsyncAcctInputParam) == true){
                                    	strMsg = strMsg + ' &#10152; ' + 'New User will be created.'; 
                                        handleRetrun(vsyncAcctInputParam);
                                        strMsg = strMsg + ' &#10152; ' + 'Returned Output Parameters.'; 
                                    }
                                }
                            }
                            /*Block*/
                        }else{
                            handleRetrun(vsyncAcctInputParam);
                        }
                    }else{
                    	strMsg = strMsg + ' &#10152; ' + 'No Contact found with matching email';
                        if(searchLeadByEmail(vsyncAcctInputParam) == true){
                        	strMsg = 'Searched by Lead email';  
                            if(handleConverLead(vsyncAcctInputParam) == true){
                            	strMsg = strMsg + ' &#10152; ' + 'Lead Converted';
                                if(handleUpdateAccount(vsyncAcctInputParam) == true){
                                    /*Block*/
                                    if(accountMatchingContactEmail(vsyncAcctInputParam) == true){
                                    	strMsg = strMsg + ' &#10152; ' + 'Contact found matching contact Id & account Id'; 
                                        if(contactHavingUserRecord(vsyncAcctInputParam) == true){
                                        	strMsg = strMsg + ' &#10152; ' + 'User found with same contact email & RCUser Id'; 
                                            handleRetrun(vsyncAcctInputParam);
                                         	strMsg = strMsg + ' &#10152; ' + 'Returned Output Parameters.'; 
                                        }else{
                                            if(handleCreateUser(vsyncAcctInputParam) == true){
                                            	strMsg = strMsg + ' &#10152; ' + 'New User will be created.'; 
                                                handleRetrun(vsyncAcctInputParam);
                                                strMsg = strMsg + ' &#10152; ' + 'Returned Output Parameters.'; 
                                            }
                                        }
                                    }else{
                                    	strMsg = strMsg + ' &#10152; ' + 'No Contact found with matching Contact Email & account Id';
                                        if(handleCreateContact(vsyncAcctInputParam) == true){
                                        	strMsg = strMsg + ' &#10152; ' + 'New contact will be created';
                                            if(handleCreateUser(vsyncAcctInputParam) == true){
                                            	strMsg = strMsg + ' &#10152; ' + 'New User will be created.';
                                                handleRetrun(vsyncAcctInputParam);
                                                strMsg = strMsg + ' &#10152; ' + 'Returned Output Parameters.'; 
                                            }
                                        }
                                    }
                                    /*Block*/
                                }else{
                                    handleRetrun(vsyncAcctInputParam);
                                }
                            }
                        }else{ 
                            if(handleCreateAccount(vsyncAcctInputParam) == true){   /**/
                                strMsg = strMsg + ' &#10152; ' + 'New Account will be created';
                                if(handleCreateContact(vsyncAcctInputParam) == true){
                                	strMsg = strMsg + ' &#10152; ' + 'New contact will be created';
                                    if(handleCreateUser(vsyncAcctInputParam) == true){
                                    	strMsg = strMsg + ' &#10152; ' + 'New User will be created.';
                                        handleRetrun(vsyncAcctInputParam);
                                        strMsg = strMsg + ' &#10152; ' + 'Returned Output Parameters.'; 
                                    }
                                }
                            }
                        }
                    }
                }
            }else{
            	strMsg = strMsg + ' &#10152; ' + 'Opportunity Id parameter is blank'; 
                if(searchContactByMail(vsyncAcctInputParam) == true){
                	strMsg = strMsg + ' &#10152; ' + 'Contact found with matching email'; 
                    if(handleUpdateAccount(vsyncAcctInputParam) == true){
                        /*Block*/
                        if(accountMatchingContactEmail(vsyncAcctInputParam) == true){
                        	strMsg = strMsg + ' &#10152; ' + 'Contact found matching contact Id & account Id'; 
                            if(contactHavingUserRecord(vsyncAcctInputParam) == true){
                            	strMsg = strMsg + ' &#10152; ' + 'User found with same contact email & RCUser Id';
                                handleRetrun(vsyncAcctInputParam);
                                strMsg = strMsg + ' &#10152; ' + 'Returned Output Parameters.'; 
                            }else{
                            	strMsg = strMsg + ' &#10152; ' + 'No User found with matching contact email & RCUser Id';
                                if(handleCreateUser(vsyncAcctInputParam) == true){
                                	strMsg = strMsg + ' &#10152; ' + 'New User will be created.';
                                    handleRetrun(vsyncAcctInputParam);
                                    strMsg = strMsg + ' &#10152; ' + 'Returned Output Parameters.'; 
                                }
                            }
                        }else{
                        	strMsg = strMsg + ' &#10152; ' + 'No Contact found matching mail & account Id'; 
                            if(handleCreateContact(vsyncAcctInputParam) == true){
                            	strMsg = strMsg + ' &#10152; ' + 'New contact will be created';
                                if(handleCreateUser(vsyncAcctInputParam) == true){
                                	strMsg = strMsg + ' &#10152; ' + 'New User will be created.';
                                    handleRetrun(vsyncAcctInputParam);
                                    strMsg = strMsg + ' &#10152; ' + 'Returned Output Parameters.'; 
                                }
                            }
                        }
                        /*Block*/
                    }else{
                        handleRetrun(vsyncAcctInputParam);
                    }
                }else{
                	strMsg = strMsg + ' &#10152; ' + 'No contact found with matching email'; 
                    if(searchLeadByEmail(vsyncAcctInputParam) == true){
                    	strMsg = strMsg + ' &#10152; ' + 'Lead found with matching email'; 
                        if(handleConverLead(vsyncAcctInputParam) == true){
                        	strMsg = strMsg + ' &#10152; ' + 'Lead Converted';
                            if(handleUpdateAccount(vsyncAcctInputParam) == true){
                                /*Block*/
                                if(accountMatchingContactEmail(vsyncAcctInputParam) == true){
                                	strMsg = strMsg + ' &#10152; ' + 'Contact found with matching email and account Id';
                                    if(contactHavingUserRecord(vsyncAcctInputParam) == true){
                                    	strMsg = strMsg + ' &#10152; ' + 'User found with matching contact email & RCUser Id';
                                        handleRetrun(vsyncAcctInputParam);
                                     	strMsg = strMsg + ' &#10152; ' + 'Returned Output Parameters.'; 
                                    }else{
                                    	strMsg = strMsg + ' &#10152; ' + 'No User found with matching contact email & RCUser Id';
                                        if(handleCreateUser(vsyncAcctInputParam) == true){
                                        	strMsg = strMsg + ' &#10152; ' + 'New User will be created.';
                                            handleRetrun(vsyncAcctInputParam);
                                         	strMsg = strMsg + ' &#10152; ' + 'Returned Output Parameters.'; 
                                        }
                                    }
                                }else{
                                	strMsg = strMsg + ' &#10152; ' + 'No Contact found with matching Contact Email & account Id';
                                    if(handleCreateContact(vsyncAcctInputParam) == true){
                                    	strMsg = strMsg + ' &#10152; ' + 'New contact will be created';
                                        if(handleCreateUser(vsyncAcctInputParam) == true){
                                        	strMsg = strMsg + ' &#10152; ' + 'New User will be created.';
                                            handleRetrun(vsyncAcctInputParam);
                                            strMsg = strMsg + ' &#10152; ' + 'Returned Output Parameters.'; 
                                        }
                                    }
                                }
                                /*Block*/
                            }else{
                                handleRetrun(vsyncAcctInputParam);
                            }
                        }
                    }else{
                    	strMsg = strMsg + ' &#10152; ' + 'No Lead found with matching email';
                        if(handleCreateAccount(vsyncAcctInputParam) == true){
                    	 	strMsg = strMsg + ' &#10152; ' + 'New Account will be created';
                            if(handleCreateContact(vsyncAcctInputParam) == true){
                            	strMsg = strMsg + ' &#10152; ' + 'New Contact will be created.';
                                if(handleCreateUser(vsyncAcctInputParam) == true){
                                	strMsg = strMsg + ' &#10152; ' + 'New User will be created.';
                                    handleRetrun(vsyncAcctInputParam);
                                    strMsg = strMsg + ' &#10152; ' + 'Returned Output Parameters.'; 
                                }
                            }
                        }   
                    }
                }
            }
        } 
        return vsyncAcctInputParam;
        return null;
    }
   
 	public static Boolean searchAccountByUID(WRSyncAccountWSParameter vsyncAcctInputParam){
	    try {        
	    	vsyncAcctInputParam.proc_debugmsg += 'IN searchAccountByUID::';
	        List<Account> searchAccount = new List<Account>(); 
	        searchAccount = (List<Account>)[Select Id, name,phone,RC_user_Id__c from Account 
	        where RC_user_Id__c!=null and RC_user_Id__c=:vsyncAcctInputParam.inRcUserId];
	                
	        if(searchAccount.size() > 0){           
	            vsyncAcctInputParam.proc_AccountId = searchAccount[0].Id;
	            return true;
	        }else{
	            return false;
	        }
	    } catch(Exception ex){           
	        vsyncAcctInputParam.OutErrorMsg = 'searchAccountByUID:: '+ex.getMessage();
	        return false;
	    }    
	    return true;
   	}
   
   	public static Boolean searchOppertunityByOID(WRSyncAccountWSParameter vsyncAcctInputParam){    
	    try {
	        vsyncAcctInputParam.proc_debugmsg += 'IN searchOppertunityByOID::';
	        List<Opportunity> searchopportunity = [SELECT name,AccountId,Id ,StageName FROM Opportunity 
	        WHERE Id=:vsyncAcctInputParam.inOpportunityId 
	        AND Account.RC_Sync_Status__c = 'Pending' 
	        AND Account.RC_User_ID__c = NULL Order by createddate desc limit 1];
	        if(searchopportunity.size() > 0){
	            vsyncAcctInputParam.proc_AccountId = searchopportunity[0].AccountId;
	        } else {
	        	return false;
	        }
	        return true;
	    } catch(Exception ex){
	        vsyncAcctInputParam.OutErrorMsg = 'searchOppertunityByOID:: '+ex.getMessage();
	        return false;
	    } 
	    return true;
   	}
   
   	public static Boolean searchContactByMail(WRSyncAccountWSParameter vsyncAcctInputParam){
	    try{
	        vsyncAcctInputParam.proc_debugmsg += 'IN searchContactByMail::';
	        List<Contact> searchcontact = (List<Contact>)[Select Id, name ,email,phone,AccountId  from 
	        Contact where email =:vsyncAcctInputParam.inContactEmail AND
	        Account.RC_User_ID__c = NULL AND Account.RecordTypeId ='01280000000UERq' Order by CreatedDate desc];
	        
	        if(searchcontact.size() == 1){
	            vsyncAcctInputParam.proc_AccountId = searchcontact[0].AccountId;
	            vsyncAcctInputParam.proc_ContactId = searchcontact[0].Id;
	            return true;
	        }else if(searchcontact.size() > 1){
	            for(Contact con: searchcontact)
	            {
	            	Id rcId = OpportunityHelper.getOppRecordTypeMap('Sales Opportunity');
	                List<Opportunity> opp = [Select Id from Opportunity where Account.id = :con.AccountId AND (RecordTypeId  =: rcId OR RecordTypeId = NULL)];
	                // List<Opportunity> opp = [Select Id from Opportunity where Account.id = :con.AccountId];
	                if(opp.size() > 0)
	                {
	                    vsyncAcctInputParam.proc_AccountId = con.AccountId;
	                    vsyncAcctInputParam.proc_ContactId = con.Id;
	                    return true;
	                }
	            }
	            /*If no account found having oppertunity then return with latest record. Do query and assign*/
	            List<Contact> searchcontactLT = (List<Contact>)[Select Id, name ,email,phone,AccountId  from 
	            Contact where email =:vsyncAcctInputParam.inContactEmail AND
	            Account.RC_User_ID__c = NULL Order by CreatedDate desc limit 1]; 
	            if(searchcontactLT != null && searchcontactLT.size() != 0) {           
	            	vsyncAcctInputParam.proc_AccountId = searchcontactLT[0].AccountId;
	            	vsyncAcctInputParam.proc_ContactId = searchcontactLT[0].Id;
	            } else {
	            	return false;
	            }
	            return true;
	            /**/
	        }else{
	            return false;
	        }        
	    }catch(Exception ex){
	        vsyncAcctInputParam.OutErrorMsg = 'searchContactByMail:: '+ex.getMessage();
	        return false;
	    }       
	    return true;
   	}
   
   	public static Boolean searchLeadByEmail(WRSyncAccountWSParameter vsyncAcctInputParam){
	    try{
	        vsyncAcctInputParam.proc_debugmsg += 'IN searchLeadByEmail::';
	        vsyncAcctInputParam.searchlead = (List<Lead>)[SELECT ID, name, email,phone FROM Lead WHERE
	        (LeadSource != 'About To Be Cancelled' AND LeadSource != 'About To Be Cancelled UK') AND  
	        ((Phone!='' AND Phone!=null AND Phone =:vsyncAcctInputParam.inContactPhone)  OR 
	              (email!='' AND email!=null AND email =: vsyncAcctInputParam.inContactEmail))
	        AND (Status ='2. Contacted' OR Status ='1.5 Call Out') 
	        AND Isconverted =False Order BY Name DESC Limit 1];
	        if(vsyncAcctInputParam.searchlead.size() > 0){
	            return true;
	        }else{
	            return false;
	        }
	    }catch(Exception ex){
	        vsyncAcctInputParam.OutErrorMsg = 'searchLeadByEmail:: '+ex.getMessage();
	        return false;
	    }  
	    return true;
   	}
   
   	public static Boolean handleUpdateAccount(WRSyncAccountWSParameter vsyncAcctInputParam){
	    try{
	        vsyncAcctInputParam.proc_debugmsg += 'IN handleUpdateAccount::';
	        List<Account> AcctUpdate = new Account[]{};
	        
	        Account acc = new Account(Id=vsyncAcctInputParam.proc_AccountId,
	        RC_Account_Number__c = vsyncAcctInputParam.inRcPrimaryNumber,
	        RC_User_ID__c = vsyncAcctInputParam.inRcUserId,
	        Name = vsyncAcctInputParam.inCompanyName,
	        RC_Account_Status__c = '',
	        // RC_Account_Status__c = 'DWH Sync pending',
	        SignupType__c = vsyncAcctInputParam.inSignupType,
	        RC_Brand__c = ((vsyncAcctInputParam.inRcBrand == null)?'': substringStr(vsyncAcctInputParam.inRcBrand, 127)),
	        SignupPlatform__c = vsyncAcctInputParam.inSignupPlatform
	        ,RC_Service_name__c = ((vsyncAcctInputParam.In_SERVICENAME==null)?'':substringStr(vsyncAcctInputParam.In_SERVICENAME, 127))
	        ,RC_Tier__c = ((vsyncAcctInputParam.In_TIERNAME==null)?'':substringStr(vsyncAcctInputParam.In_TIERNAME, 127))
	        ,Attribute_Key_01__c = ((vsyncAcctInputParam.In_Attribute_Key_01==null)?'':substringStr(vsyncAcctInputParam.In_Attribute_Key_01, 240))
	        ,Attribute_Key_02__c = ((vsyncAcctInputParam.In_Attribute_Key_02==null)?'':substringStr(vsyncAcctInputParam.In_Attribute_Key_02, 240))
	        ,Attribute_Key_03__c = ((vsyncAcctInputParam.In_Attribute_Key_03==null)?'':substringStr(vsyncAcctInputParam.In_Attribute_Key_03, 240))
	        ,Attribute_Key_04__c = ((vsyncAcctInputParam.In_Attribute_Key_04==null)?'':substringStr(vsyncAcctInputParam.In_Attribute_Key_04, 240))
	        ,Attribute_Key_05__c = ((vsyncAcctInputParam.In_Attribute_Key_05==null)?'':substringStr(vsyncAcctInputParam.In_Attribute_Key_05, 240))
	        ,Attribute_Value_01__c = ((vsyncAcctInputParam.In_Attribute_Value_01==null)?'':substringStr(vsyncAcctInputParam.In_Attribute_Value_01, 240))
	        ,Attribute_Value_02__c = ((vsyncAcctInputParam.In_Attribute_Value_02==null)?'':substringStr(vsyncAcctInputParam.In_Attribute_Value_02, 240))
	        ,Attribute_Value_03__c = ((vsyncAcctInputParam.In_Attribute_Value_03==null)?'':substringStr(vsyncAcctInputParam.In_Attribute_Value_03, 240))
	        ,Attribute_Value_04__c = ((vsyncAcctInputParam.In_Attribute_Value_04==null)?'':substringStr(vsyncAcctInputParam.In_Attribute_Value_04, 240))
	        ,Attribute_Value_05__c = ((vsyncAcctInputParam.In_Attribute_Value_05==null)?'':substringStr(vsyncAcctInputParam.In_Attribute_Value_05, 240))
	        );
	        AcctUpdate.add(acc);
	        //Upsert AcctUpdate;
	        vsyncAcctInputParam.proc_AccountId = acc.Id;
	        return true;
	    }catch(Exception ex){
	        vsyncAcctInputParam.OutErrorMsg = 'handleUpdateAccount:: '+ex.getMessage();
	        return false;
	    }     
	    return true;
  	 }
   
   	public static Boolean handleConverLead(WRSyncAccountWSParameter vsyncAcctInputParam){      
	    try{        
	        vsyncAcctInputParam.proc_debugmsg += 'IN handleConverLead::';
	        TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT();
			TriggerHandler.BY_PASS_ACCOUNT_ON_UPDATE();
			TriggerHandler.BY_PASS_CONTACT_ON_INSERT();
			TriggerHandler.BY_PASS_CONTACT_ON_UPDATE();
			TriggerHandler.BY_PASS_OPPORTUNITY_ON_INSERT();
			TriggerHandler.BY_PASS_OPPORTUNITY_ON_UPDATE();
	        for(Lead l: vsyncAcctInputParam.searchlead) {
	            vsyncAcctInputParam.proc_debugmsg += 'In handleConverLead::' + l.Id;
	            Database.LeadConvert lc = new database.LeadConvert();
	            lc.setLeadId(l.id);
	            LeadStatus convertStatus = [Select Id, MasterLabel from LeadStatus where IsConverted= true  limit 1];
	            lc.setConvertedStatus(convertStatus.MasterLabel);           
	            //Database.LeadConvertResult lcr = Database.convertLead(lc); 
	            //vsyncAcctInputParam.proc_AccountId = lcr.getAccountId();
	            //vsyncAcctInputParam.proc_ContactId = lcr.getContactId();
	            TriggerHandler.RESET_VARIABLES();      
	            //vsyncAcctInputParam.proc_debugmsg += 'In handleConverLead:: Account ID' + l.Id + lcr.getAccountId() + 'Conytact ID'+lcr.getContactId();
	            return true;
	        }
	    }catch(Exception ex){
	        vsyncAcctInputParam.OutErrorMsg = 'handleConverLead:: '+ex.getMessage();
	        return false;
	    }  
	    return true;
   	}
   
   	public static String substringStr(String str, Integer len) {
	    String result = str;
	        if(str.length() > len)
	            result = str.substring(0, len);
	    return result;
   	}
   
   	public static Boolean handleCreateAccount(WRSyncAccountWSParameter vsyncAcctInputParam){
	 	try{
         	vsyncAcctInputParam.proc_debugmsg += 'IN handleCreateAccount::';
         	Account a = new Account();
         	a.Name = vsyncAcctInputParam.inCompanyName;
         	a.RC_Account_Number__c= vsyncAcctInputParam.inRcPrimaryNumber;
         	a.Rc_User_Id__c= vsyncAcctInputParam.inRcUserId;
         	a.RC_Brand__c=vsyncAcctInputParam.inRcBrand;
         	a.RC_Account_Status__c= '';
         	// a.RC_Account_Status__c= 'DWH Sync pending';
         	a.ownerId='005800000036sJJ';
         	a.SignupType__c = vsyncAcctInputParam.inSignupType;
         	a.SignupPlatform__c = vsyncAcctInputParam.inSignupPlatform;
         	/*Added to populate Service name & Tier*/
         	a.RC_Service_name__c = ((vsyncAcctInputParam.In_SERVICENAME==null)?'':substringStr(vsyncAcctInputParam.In_SERVICENAME, 127));
         	a.RC_Tier__c = ((vsyncAcctInputParam.In_TIERNAME==null)?'':substringStr(vsyncAcctInputParam.In_TIERNAME, 127));
         	a.Attribute_Key_01__c = ((vsyncAcctInputParam.In_Attribute_Key_01==null)?'':substringStr(vsyncAcctInputParam.In_Attribute_Key_01, 240));
         	a.Attribute_Key_02__c = ((vsyncAcctInputParam.In_Attribute_Key_02==null)?'':substringStr(vsyncAcctInputParam.In_Attribute_Key_02, 240));
         	a.Attribute_Key_03__c = ((vsyncAcctInputParam.In_Attribute_Key_03==null)?'':substringStr(vsyncAcctInputParam.In_Attribute_Key_03, 240));
         	a.Attribute_Key_04__c = ((vsyncAcctInputParam.In_Attribute_Key_04==null)?'':substringStr(vsyncAcctInputParam.In_Attribute_Key_04, 240));
         	a.Attribute_Key_05__c = ((vsyncAcctInputParam.In_Attribute_Key_05==null)?'':substringStr(vsyncAcctInputParam.In_Attribute_Key_05, 240));
         	a.Attribute_Value_01__c = ((vsyncAcctInputParam.In_Attribute_Value_01==null)?'':substringStr(vsyncAcctInputParam.In_Attribute_Value_01, 240));
         	a.Attribute_Value_02__c = ((vsyncAcctInputParam.In_Attribute_Value_02==null)?'':substringStr(vsyncAcctInputParam.In_Attribute_Value_02, 240));
         	a.Attribute_Value_03__c = ((vsyncAcctInputParam.In_Attribute_Value_03==null)?'':substringStr(vsyncAcctInputParam.In_Attribute_Value_03, 240));
         	a.Attribute_Value_04__c = ((vsyncAcctInputParam.In_Attribute_Value_04==null)?'':substringStr(vsyncAcctInputParam.In_Attribute_Value_04, 240));
         	a.Attribute_Value_05__c = ((vsyncAcctInputParam.In_Attribute_Value_05==null)?'':substringStr(vsyncAcctInputParam.In_Attribute_Value_05, 240));
      		System.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'+a.RC_Brand__c);
         	//insert a;
         	//vsyncAcctInputParam.proc_AccountId = a.Id;
         	return true;
	     }catch(Exception ex){
	        vsyncAcctInputParam.OutErrorMsg = 'handleCreateAccount:: '+ex.getMessage();
	        return false;
	     }  
	    return true;
   	}
   
   	public static Boolean handleCreateContact(WRSyncAccountWSParameter vsyncAcctInputParam){
	    try{
	        /*String strGetIn_FirstName = vsyncAcctInputParam.inFirstName;               
	        Integer result = strGetIn_FirstName.length();
	        Integer resultUserNameLen = 0;              
	        if(result > 40){
	            strGetIn_FirstName = strGetIn_FirstName.substring(0, 40); 
	        }
	        vsyncAcctInputParam.proc_debugmsg += 'IN handleCreateContact::';
	        contact c = new contact();
	        c.LastName = vsyncAcctInputParam.inLastName;
	        c.AccountId = vsyncAcctInputParam.proc_AccountId;
	        c.FirstName = strGetIn_FirstName; //vsyncAcctInputParam.inFirstName;
	        c.CurrencyIsoCode= 'USD';
	        resultUserNameLen = vsyncAcctInputParam.inContactEmail.length();
	        if(resultUserNameLen > 80){
	            c.email = vsyncAcctInputParam.inContactEmail.substring(resultUserNameLen-80, resultUserNameLen); 
	        }else{
	            c.email = vsyncAcctInputParam.inContactEmail;
	        }
	        c.Company__c = vsyncAcctInputParam.inCompanyName;
	        c.Phone = vsyncAcctInputParam.inContactPhone;
	        //insert c;   
	        vsyncAcctInputParam.proc_ContactId = c.Id;*/
	        return true;
	    }catch(Exception ex){
	        vsyncAcctInputParam.OutErrorMsg = 'handleCreateContact:: '+ex.getMessage();
	        return false;
	    }  
	    return true;
   	}
   
   	public static Boolean accountMatchingContactEmail(WRSyncAccountWSParameter vsyncAcctInputParam){
	    try{
	        vsyncAcctInputParam.proc_debugmsg += 'IN accountMatchingContactEmail::';
	        List<Contact> matchacc = [select Id from Contact where AccountId =:vsyncAcctInputParam.proc_AccountId
	        and Email=:vsyncAcctInputParam.inContactEmail];
	        if(matchacc.size() > 0){                    
	             vsyncAcctInputParam.proc_ContactId = matchacc[0].id;
	             return true;
	        }else{
	            return false;
	        }
	    }catch(Exception ex){
	        vsyncAcctInputParam.OutErrorMsg = 'accountMatchingContactEmail:: '+ex.getMessage();
	    }         
	    return true;
   	}
   
   	public static Boolean contactHavingUserRecord(WRSyncAccountWSParameter vsyncAcctInputParam){
    	try {
	        vsyncAcctInputParam.proc_debugmsg += 'IN contactHavingUserRecord::';
	        Integer resultUserNameLen = 0;
	        String proc_EmailWORCUSERID = vsyncAcctInputParam.inContactEmail;
	        String proc_EmailWithRCUSERID = vsyncAcctInputParam.inRcUserId + vsyncAcctInputParam.inContactEmail;
	        resultUserNameLen = proc_EmailWithRCUSERID.length();
	        proc_EmailWithRCUSERID = proc_EmailWithRCUSERID.replace('@','.');
	        if(resultUserNameLen > 70) {
	            proc_EmailWithRCUSERID = proc_EmailWithRCUSERID.substring(0, 70); 
	        }   
	        proc_EmailWithRCUSERID = proc_EmailWithRCUSERID + '@rc.com';
	        
	        /**/        
	        
	        /*Logic to get CONTACT ID*/
	        List<User> objUser = new List<User>();      
	        List<Contact> objContact = [SELECT Id FROM Contact WHERE Account.RC_User_ID__c =:vsyncAcctInputParam.inRcUserId
	        								AND email =:vsyncAcctInputParam.inContactEmail];
	        if(objContact.size() > 0) {
	            objUser = [Select Id from User where contactid =:objContact[0].Id AND profileId = '00e80000001OK6k' AND IsActive = true]; 
	            if(objUser.size() > 0){
	                vsyncAcctInputParam.proc_UserId = objUser[0].Id;
                	return true;
	            }else{
                	return false;
	            }        
	        }else{
	            return false;
	        }
	    } catch(Exception ex){
	        vsyncAcctInputParam.OutErrorMsg = 'contactHavingUserRecord:: '+ex.getMessage();
	    }  
	    return true;
   	}
   
   	public static Boolean handleCreateUser(WRSyncAccountWSParameter vsyncAcctInputParam){
        vsyncAcctInputParam.proc_debugmsg += 'IN handleCreateUser::'; 
        vsyncAcctInputParam.proc_UserRecCreation = '-1';
        return true;
   	}
   
   	public void handleRetrun(WRSyncAccountWSParameter vsyncAcctInputParam){
	    vsyncAcctInputParam.proc_debugmsg += 'IN handleRetrun::';       
	    vsyncAcctInputParam.outAccountID = vsyncAcctInputParam.proc_AccountId;
	    vsyncAcctInputParam.outContactID = vsyncAcctInputParam.proc_ContactId;
	    vsyncAcctInputParam.outUserID = vsyncAcctInputParam.proc_UserId;
	    System.Debug('>>vsyncAcctInputParam.outAccountID>>'+ vsyncAcctInputParam.outAccountID);
	    System.Debug('>>vsyncAcctInputParam.outContactID>>'+vsyncAcctInputParam.outContactID);
	    System.Debug('>>vsyncAcctInputParam.outUserID>>'+vsyncAcctInputParam.outUserID);
	    wrParameterObj.outAccountID = vsyncAcctInputParam.outAccountID;
	    wrParameterObj.outContactID = vsyncAcctInputParam.outContactID;
	    wrParameterObj.outUserID = vsyncAcctInputParam.outUserID;  
   	}       
	
	public class WRSyncAccountWSParameter {
		public String inOpportunityId {get;set;}
		public String inRcUserId {get;set;}
		public String inRcPrimaryNumber {get;set;}
		public String inCompanyName {get;set;}
		public String inFirstName {get;set;}
		public String inLastName {get;set;}
		public String inContactEmail {get;set;}		
		public String inContactPhone {get;set;}
		public String inRcBrand {get;set;}
		public String inSignupType {get;set;}
		public String inSignupPlatform {get;set;}
		public String outAccountID {get;set;}
      	public String outContactID {get;set;}
      	public String outUserID {get;set;}
 	 	public String OutErrorMsg {get;set;}
 	 	public String proc_debugmsg;
 	 	public String proc_AccountId;
 	 	public String proc_ContactId;
 	 	public String proc_UserId;
 	 	public String proc_UserRecCreation;
 	 	public List<Lead> searchlead;
 	 	public String In_SERVICENAME;
      	public String In_TIERNAME;
      	public String In_Attribute_Key_01;
      	public String In_Attribute_Value_01;
      	public String In_Attribute_Key_02;
      	public String In_Attribute_Value_02;
      	public String In_Attribute_Key_03;
      	public String In_Attribute_Value_03;
      	public String In_Attribute_Key_04;
      	public String In_Attribute_Value_04;
      	public String In_Attribute_Key_05;
      	public String In_Attribute_Value_05;	
	}
}