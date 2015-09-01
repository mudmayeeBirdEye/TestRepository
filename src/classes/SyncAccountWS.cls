global class SyncAccountWS{
   
   //Define an object in apex that is exposed in apex web service
   global class syncAcctInputParam{
      /*InPut*/
      webservice String In_OpportunityID;
      webservice String In_RCUserID;
      webservice String In_RCPrimaryNumber;
      webservice String In_Company;
      webservice String In_FirstName;
      webservice String In_LastName;
      webservice String In_ContactEmail;
      webservice string In_Contactphone;
      webservice string In_RCBRAND;  
	  webservice string In_Partner_Deal_Registration_Id;
	  webservice string In_Bandwidth_Test_Id;
	  webservice Decimal In_Bandwidth_MOS_Score;
	  webservice Decimal In_Bandwidth_Num_Sim_Calls;
	  webservice Boolean In_Porting_Numbers;
	  
     /*New Field added*/    
      webservice string In_SignupType ;  
      webservice string In_SignupPlatform;  

      /*New fields added, 23/06/2011 */
      webservice string In_SERVICENAME;
      webservice string In_TIERNAME;
      /*New fields added, 28/06/2011 */
      webservice string In_Attribute_Key_01;
      webservice string In_Attribute_Value_01;
      webservice string In_Attribute_Key_02;
      webservice string In_Attribute_Value_02;
      webservice string In_Attribute_Key_03;
      webservice string In_Attribute_Value_03;
      webservice string In_Attribute_Key_04;
      webservice string In_Attribute_Value_04;
      webservice string In_Attribute_Key_05;
      webservice string In_Attribute_Value_05;
            
      /*OutPut*/
      webservice String Out_AccountID;
      webservice String Out_ContactID;
      webservice String Out_UserID;
      webservice String OutErrorMsg='';
      
      /*Processing*/
      webservice String proc_AccountId;
      webservice String proc_ContactId;
      webservice String proc_UserId;
      webservice String proc_UserRecCreation;
      webservice String proc_debugmsg;
      
      List<Contact> searchContact;
      List<Lead> searchlead;
      
      
   }
   public SyncAccountWS() {}
   
   webservice static syncAcctInputParam synAccountNew(syncAcctInputParam vsyncAcctInputParam) {   
         //handleCreateAccount(vsyncAcctInputParam);      
        if(searchAccountByUID(vsyncAcctInputParam) == true){            
            /*Block*/
            if(accountMatchingContactEmail(vsyncAcctInputParam) == true){
                if(contactHavingUserRecord(vsyncAcctInputParam) == true){
                    handleRetrun(vsyncAcctInputParam);
                }else{
                    if(handleCreateUser(vsyncAcctInputParam) == true){
                        handleRetrun(vsyncAcctInputParam);
                    }
                }
            }else{
                if(handleCreateContact(vsyncAcctInputParam) == true){
                    if(handleCreateUser(vsyncAcctInputParam) == true){
                        handleRetrun(vsyncAcctInputParam);
                    }
                }
            }
            /*Block*/
        }else{
			 if(String.isNotBlank(vsyncAcctInputParam.In_Partner_Deal_Registration_Id) && searchContactandLeadByDealId(vsyncAcctInputParam) == true){
if(vsyncAcctInputParam.searchContact != null){
system.debug('*** Contact found ***');
//Contact is Found
vsyncAcctInputParam.proc_AccountId = vsyncAcctInputParam.searchContact.get(0).AccountId;
vsyncAcctInputParam.proc_ContactId = vsyncAcctInputParam.searchContact.get(0).Id;
handleUpdateAccount(vsyncAcctInputParam);
handleRetrun(vsyncAcctInputParam);
}else if(vsyncAcctInputParam.searchlead != null){
system.debug('*** Lead found ***');
if(handleConverLead(vsyncAcctInputParam) == true){
handleUpdateAccount(vsyncAcctInputParam);
handleRetrun(vsyncAcctInputParam);
}
}
}else{
            if(vsyncAcctInputParam.In_OpportunityID != null && vsyncAcctInputParam.In_OpportunityID != ''){
                if(searchOppertunityByOID(vsyncAcctInputParam) == true){
                    if(handleUpdateAccount(vsyncAcctInputParam) == true){
                        /*Block*/
                        if(accountMatchingContactEmail(vsyncAcctInputParam) == true){
                            if(contactHavingUserRecord(vsyncAcctInputParam) == true){
                                handleRetrun(vsyncAcctInputParam);
                            }else{
                                if(handleCreateUser(vsyncAcctInputParam) == true){
                                    handleRetrun(vsyncAcctInputParam);
                                }
                            }
                        }else{
                            if(handleCreateContact(vsyncAcctInputParam) == true){
                                if(handleCreateUser(vsyncAcctInputParam) == true){
                                    handleRetrun(vsyncAcctInputParam);
                                }
                            }
                        }
                        /*Block*/
                    }else{
                        handleRetrun(vsyncAcctInputParam);
                    }
                }else{
                    if(searchContactByMail(vsyncAcctInputParam) == true){
                        if(handleUpdateAccount(vsyncAcctInputParam) == true){
                            /*Block*/
                            if(accountMatchingContactEmail(vsyncAcctInputParam) == true){
                                if(contactHavingUserRecord(vsyncAcctInputParam) == true){
                                    handleRetrun(vsyncAcctInputParam);
                                }else{
                                    if(handleCreateUser(vsyncAcctInputParam) == true){
                                        handleRetrun(vsyncAcctInputParam);
                                    }
                                }
                            }else{
                                if(handleCreateContact(vsyncAcctInputParam) == true){
                                    if(handleCreateUser(vsyncAcctInputParam) == true){
                                        handleRetrun(vsyncAcctInputParam);
                                    }
                                }
                            }
                            /*Block*/
                        }else{
                            handleRetrun(vsyncAcctInputParam);
                        }
                    }else{
                        if(searchLeadByEmail(vsyncAcctInputParam) == true){ 
                            if(handleConverLead(vsyncAcctInputParam) == true){
                                if(handleUpdateAccount(vsyncAcctInputParam) == true){
                                    /*Block*/
                                    if(accountMatchingContactEmail(vsyncAcctInputParam) == true){
                                        if(contactHavingUserRecord(vsyncAcctInputParam) == true){
                                            handleRetrun(vsyncAcctInputParam);
                                        }else{
                                            if(handleCreateUser(vsyncAcctInputParam) == true){
                                                handleRetrun(vsyncAcctInputParam);
                                            }
                                        }
                                    }else{
                                        if(handleCreateContact(vsyncAcctInputParam) == true){
                                            if(handleCreateUser(vsyncAcctInputParam) == true){
                                                handleRetrun(vsyncAcctInputParam);
                                            }
                                        }
                                    }
                                    /*Block*/
                                }else{
                                    handleRetrun(vsyncAcctInputParam);
                                }
                            }
                        }else{ 
                            if(handleCreateAccount(vsyncAcctInputParam) == true){ /**/
                                if(handleCreateContact(vsyncAcctInputParam) == true){
                                    if(handleCreateUser(vsyncAcctInputParam) == true){
                                        handleRetrun(vsyncAcctInputParam);
                                    }
                                }
                            }
                        }
                    }
                }
            }else{
                if(searchContactByMail(vsyncAcctInputParam) == true){
                    if(handleUpdateAccount(vsyncAcctInputParam) == true){
                        /*Block*/
                        if(accountMatchingContactEmail(vsyncAcctInputParam) == true){
                            if(contactHavingUserRecord(vsyncAcctInputParam) == true){
                                handleRetrun(vsyncAcctInputParam);
                            }else{
                                if(handleCreateUser(vsyncAcctInputParam) == true){
                                    handleRetrun(vsyncAcctInputParam);
                                }
                            }
                        }else{
                            if(handleCreateContact(vsyncAcctInputParam) == true){
                                if(handleCreateUser(vsyncAcctInputParam) == true){
                                    handleRetrun(vsyncAcctInputParam);
                                }
                            }
                        }
                        /*Block*/
                    }else{
                        handleRetrun(vsyncAcctInputParam);
                    }
                }else{
                    if(searchLeadByEmail(vsyncAcctInputParam) == true){
                        if(handleConverLead(vsyncAcctInputParam) == true){
                            if(handleUpdateAccount(vsyncAcctInputParam) == true){
                                /*Block*/
                                if(accountMatchingContactEmail(vsyncAcctInputParam) == true){
                                    if(contactHavingUserRecord(vsyncAcctInputParam) == true){
                                        handleRetrun(vsyncAcctInputParam);
                                    }else{
                                        if(handleCreateUser(vsyncAcctInputParam) == true){
                                            handleRetrun(vsyncAcctInputParam);
                                        }
                                    }
                                }else{
                                    if(handleCreateContact(vsyncAcctInputParam) == true){
                                        if(handleCreateUser(vsyncAcctInputParam) == true){
                                            handleRetrun(vsyncAcctInputParam);
                                        }
                                    }
                                }
                                /*Block*/
                            }else{
                                handleRetrun(vsyncAcctInputParam);
                            }
                        }
                    }else{
                        if(handleCreateAccount(vsyncAcctInputParam) == true){
                            if(handleCreateContact(vsyncAcctInputParam) == true){
                                if(handleCreateUser(vsyncAcctInputParam) == true){
                                    handleRetrun(vsyncAcctInputParam);
                                }
                            }
                        }   
                    }
                }
            }
            
        } 
        }    
        return vsyncAcctInputParam;
   }  
   
   
    webservice static syncAcctInputParam synAccountCreateUser(syncAcctInputParam vsyncAcctInputParam) {   
        String strGetIn_FirstName = vsyncAcctInputParam.In_FirstName;
        String strGetIn_ContactEmail = vsyncAcctInputParam.In_ContactEmail;
        
        /*Logic to get USRID*/
         /* community nick name = email user name + user Id
         email id is validated per null or @ string, if it is not found, 
         returns as input string else, split into Strings per @, provided that it is available in email, else we take an empty '' string.
         */
        String contactEmail = vsyncAcctInputParam.In_ContactEmail;
        String community_Nick_Name = (contactEmail != null && (contactEmail).indexOf('@') != -1 ? 
            ( (contactEmail.trim()).indexOf('@') == 0 ? '' : (contactEmail).split('@')[0]) : contactEmail) 
            + vsyncAcctInputParam.In_RCUserID;
        
        
        Integer resultUserNameLen = 0;
        String proc_EmailWORCUSERID = vsyncAcctInputParam.In_ContactEmail;
        String proc_EmailWithRCUSERID = vsyncAcctInputParam.In_RCUserID+vsyncAcctInputParam.In_ContactEmail;
        
        if(vsyncAcctInputParam.proc_UserRecCreation == '-1'){
            resultUserNameLen = proc_EmailWithRCUSERID.length();
            proc_EmailWithRCUSERID = proc_EmailWithRCUSERID.replace('@','.');
            if(resultUserNameLen > 70)
            {
                proc_EmailWithRCUSERID = proc_EmailWithRCUSERID.substring(0, 70); 
            }   
            proc_EmailWithRCUSERID = proc_EmailWithRCUSERID+'@rc.com';
            
            /**/    
            
            /*          
            If User found then return the userid 
            */
            List<User> objUser = new List<User>();  
            List<Contact> objContact = [SELECT Id FROM Contact WHERE Account.RC_User_ID__c =:vsyncAcctInputParam.In_RCUserID
            AND email =:vsyncAcctInputParam.In_ContactEmail];
            if(objContact.size() > 0)
            {
                objUser = [Select Id from User where contactid =:objContact[0].Id AND profileId = '00e80000001OK6k' AND IsActive = True];
                if(objUser.size() > 0)
                {
                    vsyncAcctInputParam.proc_UserId = objUser[0].Id; 
                    handleRetrun(vsyncAcctInputParam);  
                    return vsyncAcctInputParam;     
                } 
            }
                
            /* Create New USER*/
            try{                    
                Integer result = strGetIn_FirstName.length();               
                if(result > 8)
                {
                    strGetIn_FirstName = strGetIn_FirstName.substring(0, 8); 
                }
                 String strCommunityNickname=community_Nick_Name+system.Now().getTime();
                // String strUsername=proc_EmailWithRCUSERID+system.Now().getTime();
                
                User u = new User(alias = strGetIn_FirstName, 
                email=proc_EmailWORCUSERID,  
                emailencodingkey='UTF-8', 
                lastname=vsyncAcctInputParam.In_LastName, 
                languagelocalekey='en_US', 
                localesidkey='en_US', 
                profileid= '00e80000001OK6k', //On production '00e80000001OK6k', 00e80000001OJwY 
                contactId=vsyncAcctInputParam.proc_ContactId,
                timezonesidkey='America/Los_Angeles', 
                username=proc_EmailWithRCUSERID+system.Now().getTime(),
                CommunityNickname=(strCommunityNickname.length()>40?strCommunityNickname.substring(0,38):strCommunityNickname)
                );
                System.debug('Before');                                                                 
                insert u;
                System.debug('After');
                vsyncAcctInputParam.proc_UserId = u.Id;
                handleRetrun(vsyncAcctInputParam);
            } catch (Exception ex){
                vsyncAcctInputParam.outErrorMsg += ' Error while creating user :: ' + ex.getMessage(); 
                System.debug(ex.getMessage());
            } 
        } 
       
        return vsyncAcctInputParam;
    } 
    
    
   
   //webservice static syncAcctInputParam synAccountCreateUserOLD(syncAcctInputParam vsyncAcctInputParam) {} 
    
   
   public static Boolean searchAccountByUID(syncAcctInputParam vsyncAcctInputParam){
    try{        
      vsyncAcctInputParam.proc_debugmsg += 'IN searchAccountByUID::';
        List<Account> searchAccount = new List<Account>(); 
        searchAccount = (List<Account>)[Select Id, name,phone,RC_user_Id__c from Account 
        where RC_user_Id__c!=null and RC_user_Id__c=:vsyncAcctInputParam.In_RCUserID];
                
        if(searchAccount.size() > 0){           
            vsyncAcctInputParam.proc_AccountId = searchAccount[0].Id;
            return true;
        }else{
            return false;
        }
    }catch(Exception ex){           
        vsyncAcctInputParam.OutErrorMsg = 'searchAccountByUID:: '+ex.getMessage();
        return false;
    }    
    return true;
   }
   
    public static Boolean searchContactandLeadByDealId(syncAcctInputParam vsyncAcctInputParam){
system.debug('*** Inside searchContactandLeadByDealId ***');
try{
String PartnerDealId = vsyncAcctInputParam.In_Partner_Deal_Registration_Id;
Decimal decPartnerDealId = Decimal.valueOf(PartnerDealId);
List<Contact> lstContact = [SELECT Id, AccountId FROM Contact WHERE PartnerDeal_Registration_Id__c = :decPartnerDealId AND AccountId != NULL ORDER BY CreatedDate DESC limit 1];
if(lstContact != null && lstContact.size() > 0){
vsyncAcctInputParam.searchContact = lstContact;
return true;
}else{
List<Lead> lstLead = [SELECT Id FROM Lead WHERE PartnerDeal_Registration_Id__c = :decPartnerDealId AND IsConverted=false ORDER BY CreatedDate DESC LIMIT 1];
if(lstLead != null && lstLead.size() > 0){
vsyncAcctInputParam.searchlead = lstLead;
return true;
}
}
}catch(Exception ex){
vsyncAcctInputParam.OutErrorMsg = 'searchContactandLeadByDealId:: '+ex.getMessage();
return false;
}
return false;
}
   
   public static Boolean searchOppertunityByOID(syncAcctInputParam vsyncAcctInputParam){    
    try{
        vsyncAcctInputParam.proc_debugmsg += 'IN searchOppertunityByOID::';
        List<Opportunity> searchopportunity = [SELECT name,AccountId,Id ,StageName FROM Opportunity 
        WHERE Id=:vsyncAcctInputParam.In_OpportunityID 
        AND Account.RC_Sync_Status__c = 'Pending' 
        AND Account.RC_User_ID__c = NULL Order by createddate desc limit 1];
        if(searchopportunity.size() > 0){
            vsyncAcctInputParam.proc_AccountId = searchopportunity[0].AccountId;
        } else {
          return false;
        }
        
        return true;
    }catch(Exception ex){
        vsyncAcctInputParam.OutErrorMsg = 'searchOppertunityByOID:: '+ex.getMessage();
        return false;
    } 
    return true;
   }
   
   public static Boolean searchContactByMail(syncAcctInputParam vsyncAcctInputParam){
    try{
        vsyncAcctInputParam.proc_debugmsg += 'IN searchContactByMail::';
        /*
        List<Contact> searchcontact = (List<Contact>)[Select Id, name ,email,phone,AccountId  from 
        Contact where email =:vsyncAcctInputParam.In_ContactEmail AND
        Account.RC_Sync_Status__c = 'Pending' AND Account.RC_User_ID__c = NULL Order by CreatedDate DESC];
        if(searchcontact.size() > 0){
            vsyncAcctInputParam.proc_AccountId = searchcontact[0].AccountId;
            vsyncAcctInputParam.proc_ContactId = searchcontact[0].Id;
            return true;
        }else{
            return false;
        }       
        */
        List<Contact> searchcontact = (List<Contact>)[Select Id, name ,email,phone,AccountId  from 
        Contact where email =:vsyncAcctInputParam.In_ContactEmail AND
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
            Contact where email =:vsyncAcctInputParam.In_ContactEmail AND
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
   
   public static Boolean searchLeadByEmail(syncAcctInputParam vsyncAcctInputParam){
    try{
        vsyncAcctInputParam.proc_debugmsg += 'IN searchLeadByEmail::';
        vsyncAcctInputParam.searchlead = (List<Lead>)[SELECT ID, name, email,phone FROM Lead WHERE
        (LeadSource != 'About To Be Cancelled' AND LeadSource != 'About To Be Cancelled UK') AND  
        ((Phone!='' AND Phone!=null AND Phone =:vsyncAcctInputParam.In_Contactphone)  OR 
              (email!='' AND email!=null AND email =: vsyncAcctInputParam.In_ContactEmail))
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
   
   public static Boolean handleUpdateAccount(syncAcctInputParam vsyncAcctInputParam){
    try{
        vsyncAcctInputParam.proc_debugmsg += 'IN handleUpdateAccount::';
        List<Account> AcctUpdate = new Account[]{};
        
        Account acc = new Account(Id=vsyncAcctInputParam.proc_AccountId,
        RC_Account_Number__c = vsyncAcctInputParam.In_RCPrimaryNumber,
        RC_User_ID__c = vsyncAcctInputParam.In_RCUserID,
        Name = vsyncAcctInputParam.In_Company,
        RC_Account_Status__c = '',
        // RC_Account_Status__c = 'DWH Sync pending',
        SignupType__c = vsyncAcctInputParam.In_SignupType,
        RC_Brand__c = ((vsyncAcctInputParam.In_RCBRAND==null)?'':substringStr(vsyncAcctInputParam.In_RCBRAND, 127)),
        SignupPlatform__c = vsyncAcctInputParam.In_SignupPlatform
        ,RC_Service_name__c = ((vsyncAcctInputParam.In_SERVICENAME==null)?'':substringStr(vsyncAcctInputParam.In_SERVICENAME, 127))
		, Bandwidth_Test_Id__c = vsyncAcctInputParam.In_Bandwidth_Test_Id
		,Bandwidth_MOS_Score__c = vsyncAcctInputParam.In_Bandwidth_MOS_Score
		,Bandwidth_Num_Sim_Calls__c = vsyncAcctInputParam.In_Bandwidth_Num_Sim_Calls
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
        Upsert AcctUpdate;
        vsyncAcctInputParam.proc_AccountId = acc.Id;
        return true;
    }catch(Exception ex){
		system.debug('Exception === ' + ex.getMessage() + ex.getStackTraceString());
        vsyncAcctInputParam.OutErrorMsg = 'handleUpdateAccount:: '+ex.getMessage();
        return false;
    }     
    return true;
   }
   
   public static Boolean handleConverLead(syncAcctInputParam vsyncAcctInputParam){      
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
            Database.LeadConvertResult lcr = Database.convertLead(lc); 
            vsyncAcctInputParam.proc_AccountId = lcr.getAccountId();
            vsyncAcctInputParam.proc_ContactId = lcr.getContactId();
            TriggerHandler.RESET_VARIABLES();      
            vsyncAcctInputParam.proc_debugmsg += 'In handleConverLead:: Account ID' + l.Id + lcr.getAccountId() + 'Conytact ID'+lcr.getContactId();
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
   
   public static Boolean handleCreateAccount(syncAcctInputParam vsyncAcctInputParam){
     try{
         vsyncAcctInputParam.proc_debugmsg += 'IN handleCreateAccount::';
         Account a = new Account();
         a.Name = vsyncAcctInputParam.In_Company;
         a.RC_Account_Number__c= vsyncAcctInputParam.In_RCPrimaryNumber;
         a.Rc_User_Id__c= vsyncAcctInputParam.In_RCUserID;
         a.RC_Brand__c=vsyncAcctInputParam.In_RCBRAND;
         
         a.RC_Account_Status__c= '';
         // a.RC_Account_Status__c= 'DWH Sync pending';
         a.ownerId='005800000036sJJ';
         a.SignupType__c = vsyncAcctInputParam.In_SignupType;
         a.SignupPlatform__c = vsyncAcctInputParam.In_SignupPlatform;
         
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
         insert a;
         vsyncAcctInputParam.proc_AccountId = a.Id;
         return true;
     }catch(Exception ex){
        vsyncAcctInputParam.OutErrorMsg = 'handleCreateAccount:: '+ex.getMessage();
        return false;
     }  
    return true;
   }
   
   public static Boolean handleCreateContact(syncAcctInputParam vsyncAcctInputParam){
    try{
        String strGetIn_FirstName = vsyncAcctInputParam.In_FirstName;               
        Integer result = strGetIn_FirstName.length();
        Integer resultUserNameLen = 0;              
        if(result > 40){
            strGetIn_FirstName = strGetIn_FirstName.substring(0, 40); 
        }
        vsyncAcctInputParam.proc_debugmsg += 'IN handleCreateContact::';
        contact c = new contact();
        c.LastName = vsyncAcctInputParam.In_LastName;
        c.AccountId = vsyncAcctInputParam.proc_AccountId;
        c.FirstName = strGetIn_FirstName; //vsyncAcctInputParam.In_FirstName;
        c.CurrencyIsoCode= 'USD';
        resultUserNameLen = vsyncAcctInputParam.In_ContactEmail.length();
        if(resultUserNameLen > 80){
            c.email = vsyncAcctInputParam.In_ContactEmail.substring(resultUserNameLen-80, resultUserNameLen); 
        }else{
            c.email = vsyncAcctInputParam.In_ContactEmail;
        }
        c.Company__c = vsyncAcctInputParam.In_Company;
        c.Phone = vsyncAcctInputParam.In_ContactPhone;
        insert c;   
        vsyncAcctInputParam.proc_ContactId = c.Id;
        return true;
    }catch(Exception ex){
        vsyncAcctInputParam.OutErrorMsg = 'handleCreateContact:: '+ex.getMessage();
        return false;
    }  
    return true;
   }
   
   public static Boolean accountMatchingContactEmail(syncAcctInputParam vsyncAcctInputParam){
    try{
        vsyncAcctInputParam.proc_debugmsg += 'IN accountMatchingContactEmail::';
        List<Contact> matchacc = [select Id from Contact where AccountId =:vsyncAcctInputParam.proc_AccountId
        and Email=:vsyncAcctInputParam.In_ContactEmail];
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
   
   public static Boolean contactHavingUserRecord(syncAcctInputParam vsyncAcctInputParam){
    try{
        vsyncAcctInputParam.proc_debugmsg += 'IN contactHavingUserRecord::';
        /*
        List<User> objUser = [Select Id from User where (email =:vsyncAcctInputParam.In_ContactEmail 
        OR username =:vsyncAcctInputParam.In_ContactEmail) AND IsActive = True];
        String strGetIn_ContactEmailwithRCUSRID = vsyncAcctInputParam.In_RCUserID + vsyncAcctInputParam.In_ContactEmail;
        List<User> objUser = [Select Id from User where (email =:vsyncAcctInputParam.In_ContactEmail 
        OR username =:strGetIn_ContactEmailwithRCUSRID) AND IsActive = True];  
        */
        
        /*Logic to get USRID*/
        
       /* 
        String contactEmail = vsyncAcctInputParam.In_ContactEmail;
        String communityNickName = (contactEmail != null && (contactEmail).indexOf('@') != 0 ? 
            (contactEmail).split('@')[0] : contactEmail) + vsyncAcctInputParam.In_RCUserID;
        */  
        Integer resultUserNameLen = 0;
        String proc_EmailWORCUSERID = vsyncAcctInputParam.In_ContactEmail;
        String proc_EmailWithRCUSERID = vsyncAcctInputParam.In_RCUserID+vsyncAcctInputParam.In_ContactEmail;
                
        
        resultUserNameLen = proc_EmailWithRCUSERID.length();
        proc_EmailWithRCUSERID = proc_EmailWithRCUSERID.replace('@','.');
        if(resultUserNameLen > 70)
        {
            proc_EmailWithRCUSERID = proc_EmailWithRCUSERID.substring(0, 70); 
        }   
        proc_EmailWithRCUSERID = proc_EmailWithRCUSERID+'@rc.com';
        
        
        /**/        
        
        /*Logic to get CONTACT ID*/
        List<User> objUser = new List<User>();      
        List<Contact> objContact = [SELECT Id FROM Contact  WHERE Account.RC_User_ID__c =:vsyncAcctInputParam.In_RCUserID
        AND email =:vsyncAcctInputParam.In_ContactEmail];
        if(objContact.size() > 0)
        {
            objUser = [Select Id from User where contactid =:objContact[0].Id AND profileId = '00e80000001OK6k' AND IsActive = True]; 
            if(objUser.size() > 0){
                vsyncAcctInputParam.proc_UserId = objUser[0].Id;
                return true;
            }else{
                return false;
            }        
        }else{
            return false;
        }
        
        /*User check */
        /*
        objUser = [Select Id from User where username =:proc_EmailWithRCUSERID 
        AND profileId = '00e80000001OK6k' AND IsActive = True]; 
                        
        if(objUser.size() > 0){
            vsyncAcctInputParam.proc_UserId = objUser[0].Id;
            return true;
        }else{
            return false;
        }
        */
    }catch(Exception ex){
        vsyncAcctInputParam.OutErrorMsg = 'contactHavingUserRecord:: '+ex.getMessage();
    }  
    return true;
   }
   
   public static Boolean handleCreateUser(syncAcctInputParam vsyncAcctInputParam){
        vsyncAcctInputParam.proc_debugmsg += 'IN handleCreateUser::';
        vsyncAcctInputParam.proc_UserRecCreation = '-1';
        return true;
   }
   
   public static void handleRetrun(syncAcctInputParam vsyncAcctInputParam){
    vsyncAcctInputParam.proc_debugmsg += 'IN handleRetrun::';       
    vsyncAcctInputParam.Out_AccountID = vsyncAcctInputParam.proc_AccountId;
    vsyncAcctInputParam.Out_ContactID = vsyncAcctInputParam.proc_ContactId;
    vsyncAcctInputParam.Out_UserID = vsyncAcctInputParam.proc_UserId;   
   }     

}//End of Class