global class authUserWS{


//Define an object in apex that is exposed in apex web service
   global class authUserInputParam{
        /*InPut*/
        webservice String In_RCUserID;
        webservice String In_RCPrimaryNumber;
        webservice String In_ContactMail;
        
        /*OutPut*/
        webservice Boolean Out_Status;
        webservice String Out_UserID;
        webservice String Out_Password;
        /*New Addedition */
        webservice String Out_Brand;
        webservice String Out_Service;
        webservice String Out_Tier;
        webservice String Out_Token;
        webservice String Out_ServiceVersion;
        
   }
   
   webservice static authUserInputParam authUser(authUserInputParam vauthUserInputParam) {          
        System.debug(''+ (vauthUserInputParam == null ? ' NULL INPUT ' : ' #### LOGIN CONTACT EMAIL ' + vauthUserInputParam.In_ContactMail + ' \n### USER ID = ' + vauthUserInputParam.In_RCUserID));
        /*Logic to get USRID*/
    	Integer resultUserNameLen = 0;
    	String proc_EmailWORCUSERID = vauthUserInputParam.In_ContactMail;
   		String proc_EmailWithRCUSERID = vauthUserInputParam.In_RCUserID + vauthUserInputParam.In_ContactMail;
   		       	    	
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
		
        List<Contact> objContact = [SELECT Id FROM Contact  WHERE Account.RC_User_ID__c =:vauthUserInputParam.In_RCUserID
        AND email =:vauthUserInputParam.In_ContactMail]; 
        
        if(objContact.size() > 0)
        {
        	objUser = [Select Id, username, profileId,IsActive from User where contactid =:objContact[0].Id
       		AND profileId = '00e80000001OK6k' limit 1];        	
        }else{
        	vauthUserInputParam.Out_Status = false;
        	return vauthUserInputParam;
        }
       
       if(objUser.size() > 0)
       {
       	  	if(objUser[0]!=null && objUser[0].IsActive!=true){
           		objUser[0].IsActive=true; 
           		update objUser[0];
           	}
       	
           for(User u: objUser)
           {
           	
            String strRandomPassword = getRandomPassword();//'verity11'; //'RC'+String.valueOf(Math.random());
            system.setPassword(u.Id, strRandomPassword);
            vauthUserInputParam.Out_UserID = u.Id;
            vauthUserInputParam.Out_Password = strRandomPassword;
            vauthUserInputParam.Out_Status = true;
            vauthUserInputParam.Out_Token = '';
            String strToken = 'un=' + u.username + '&pw=' +  strRandomPassword;
            // strToken = EncodingUtil.urlEncode(strToken, 'UTF-8');
            // Use generateAesKey to generate the private key
            Blob cryptoKey = Blob.valueOf('v7Y2g2webAqutAcr4DEC3uTAnaspEgA8');
            Blob initVector = Blob.valueof('da4atrABufastacr');
            // Generate the data to be encrypted.
            Blob data = Blob.valueOf(strToken);
            // Encrypt the data and have Salesforce.com generate the initialization vector
            Blob encryptedData = Crypto.encrypt('AES256', cryptoKey, initVector, data);
            String strBase64Encoded =  EncodingUtil.base64Encode(encryptedData);
            //vauthUserInputParam.Out_Token = EncodingUtil.urlEncode(strBase64Encoded, 'UTF-8') + '#' + strBase64Encoded;
            vauthUserInputParam.Out_Token = strBase64Encoded;         
           }
           List<Account> objAcctDet = [Select a.RC_User_ID__c, a.RC_Tier__c, a.RC_Service_name__c, a.RC_Brand__c, a.Id, a.Service_Version__c  
           From Account a where RC_User_ID__c!=null and RC_User_ID__c =:vauthUserInputParam.In_RCUserID];
           if(objAcctDet.size() > 0){
             for(Account acctDet: objAcctDet)
             {
               vauthUserInputParam.Out_Brand = acctDet.RC_Brand__c;
               vauthUserInputParam.Out_Service = acctDet.RC_Service_name__c;
               vauthUserInputParam.Out_Tier = acctDet.RC_Tier__c;
               vauthUserInputParam.Out_ServiceVersion = acctDet.Service_Version__c;
             }
           }
       }else{
            vauthUserInputParam.Out_Status = false;
       }
       
       return vauthUserInputParam;
   }
   
   public static string getRandomPassword(){
     String initPw = 'rc';
     datetime myDateTime = datetime.now();
     Decimal decTime = myDateTime.getTime() /1000;
     Integer utctime = Math.round(decTime);
     initPw = initPw + String.valueOf(myDateTime.getTime());
     return initPw;
   } 
   
  /* static testMethod void testauthUserWS(){
    	authUserWS syncAcc = new authUserWS();
    	authUserInputParam syncparam = new authUserInputParam();
    	syncparam.In_RCUserID='123456';
    	syncparam.In_RCPrimaryNumber='234567';
    	syncparam.In_ContactMail ='test@test.com';
    	//syncparam.Out_Status ='test';
    	syncparam.Out_UserID ='23456';
    	syncparam.Out_Password ='test';
    	authUser(syncparam);
    	
   }*/
   
}

//Test Class