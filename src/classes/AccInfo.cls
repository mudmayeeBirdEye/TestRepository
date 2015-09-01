public class AccInfo {
	public String imgPath{get;set;}
	public String msg{get;set;}
   	public String salsAgreeDate{get;set;}
   	public List<String> tempList{get;set;}
   	public Map<String,AccHighlighterWrapper> mapAccHighlighter;
   	public String customerContactName {get;set;}
   	public String RcExecutiveName {get;set;}  
   	public Boolean isBTApproved {get;set;}
	public Boolean refreshBool {get; set;}		       
	static String strBTBrand;
	static{
		if(!Test.isRunningTest()) {
			strBTBrand = RcDealHealper.getBTBrand();
		} else {
			strBTBrand = 'BT Business';
        }
		strBTBrand = strBTBrand.trim();
	}
      /* String msg1 = '&#9830;&#160;<B>T</B>he account is under a sales agreement until : ';
      // public String msg1 {get;set;}
       
       String msg2 = '&#9830;&#160;<B>T</B>his is a Reseller Account. Direct sales should not make any changes to Reseller Accounts.'+
                     'Please request customer to contact the Reseller Support team at <B>800-595-8110</B> or ' + 
                     '<B><a href=mailto:resellers@ringcentral.com>resellers@ringcentral.com</a></B> if they need help.';
                     
       String msg3 = '&#9830;&#160;<B>T</B>his is a National Account. Direct sales should not make any changes to National Accounts.'+
                     'Please request customer contact the National Account support team at <B>(800) 757-5719</B>  or '+
                     '<B><a href=mailto:franchise.support@ringcentral.com>franchise.support@ringcentral.com</a></B> if they need help.';*/
       
	public Boolean warn1{get;set;}
	public Boolean warnHighlighter{get;set;}
	public Boolean warn2{get;set;}
   	public Boolean warn3{get;set;} 
	public Boolean warn4{get;set;}
	public Boolean warn5{get;set;}
	public Boolean preSupportFlag{get;set;}
	public Boolean boolTrailAccountMsg {get;set;}
	public String  strPaidDate {get;set;}  
	public String strTAM {get; set;} 
	public String strTAMId {get; set;}
       
	public Boolean bRedAccount {get;set;}
	public String strRedAccountId{get;set;}
	private Account acct ;
	public AccInfo(ApexPages.StandardController controller) {
		refreshBool = false;
		isBTApproved = false;
   		warnHighlighter = false;
   		mapAccHighlighter = new Map<String,AccHighlighterWrapper>();
   		tempList = new List<String>();
   		tempList.add('test');
        getDocument();
        this.acct = (Account)controller.getRecord();
        List<Account> lstAcc = [SELECT RC_User_ID__c, RC_Brand__c,Preferred_Language__c,Id from Account WHERE Id =:acct.id limit 1];
        String accUserId;
        if(lstAcc !=null && lstAcc.size()>0){
        	accUserId = lstAcc.get(0).RC_User_ID__c;
			 String rcBrand = lstAcc.get(0).RC_Brand__c;
			 if(String.isNotBlank(rcBrand) && strBTBrand.equalsIgnoreCase(rcBrand.trim())){
				isBTApproved = true;
			 }
        }
        AccHighlighterWrapper currWrap = mapAccHighlighter.get(accUserId);
        if(currWrap != null){
            customerContactName = currWrap.custContactName;
           	RcExecutiveName = currWrap.rcExecContactName;
           	warnHighlighter = true;
       	}
        boolTrailAccountMsg = false; 
        ImgPath = '/resource/warning';
        preSupportFlag = false;    
      	for(Quote quote_obj: [SELECT End_Date__c FROM Quote WHERE Account__c =:acct.id AND Status ='Active' LIMIT 1]){
                     String dateStr = '';
                     try { dateStr = '' + (quote_obj.End_Date__c == null ? '' : (''+quote_obj.End_Date__c));} catch(Exception e) {}
                   //  msg = msg1 + '<b>'+ (dateStr == '' ? '' : dateStr.substring(0, dateStr.length() - 8)) +'</b>';
                     salsAgreeDate = (dateStr == '' ? '' : dateStr.substring(0, dateStr.length() - 8));
                     warn1 = true; 
       }
       for(Account acc: [SELECT id, Name, RC_Account_Status__c, RC_Service_name__c FROM Account WHERE Id = :acct.id]) {  
       		//AND RC_Account_Status__c like :'Trial%' AND RC_Service_name__c like: '%Office%' LIMIT 1                                  
            if(!String.IsBlank(acc.RC_Account_Status__c) && !String.IsBlank(acc.RC_Service_name__c) 
            	&& acc.RC_Account_Status__c.containsIgnoreCase('Trial') 
            	&& acc.RC_Service_name__c.containsIgnoreCase('Office')) {
            	 warn4 = true ;	
            }
       }
       
       for(Account acc: [SELECT Account.RC_Attribution_Channel__c, Partner_Type__c , Premium_Support_Agent__c ,
                          RecordType.Name ,RC_SignUp_date__c,Partner_ID__c, MRR__c,RC_Account_Status__c,
                          (SELECT id,Status__c FROM Escalations__r where Status__c!='Resolved' and Status__c !='Yellow' order by 
                           LastModifiedDate desc limit 1) FROM Account WHERE Id =:acct.id LIMIT 1] ){    
                
                 if(acc.Premium_Support_Agent__c != NULL) {
                     preSupportFlag = true;
                 }
                 
                  try{
	                 if(acc.Escalations__r.size()>0){
	                 	bRedAccount=true;
	                 	strRedAccountId=acc.Escalations__r.get(0).id;
	                 }
                 }catch(Exception e){}
                 
                 if((acc.RC_Attribution_Channel__c!=null && acc.RC_Attribution_Channel__c.equalsIgnoreCase('Sales Agents & Resellers'))
                      && acc.Partner_ID__c !=  null 
                      && acc.RecordType.Name == 'Customer Account') {
                         warn2 = true;
                         /* if(msg != null){
                              msg +='<br/>'+ msg2;
                          }else{
                              msg = msg2;
                         }*/
                  } 
                  if(acc.RecordType.Name == 'Partner Account' && acc.Partner_Type__c != 'Franchisor') {
                        warn2 = true;
                          /*if(msg != null){
                              msg +='<br/>'+ msg2;
                          }else{
                              msg = msg2;
                         }*/
                  }
                  if((acc.RC_Attribution_Channel__c!=null 
                  	  && ( acc.RC_Attribution_Channel__c.equalsIgnoreCase('National Accounts') || acc.RC_Attribution_Channel__c.equalsIgnoreCase('Franchise & Assoc.')) )
                      && (acc.RecordType.Name == 'Customer Account')
                      && acc.Partner_ID__c !=  NULL) {
                        warn3 = true;
                         /*if(msg != null) {
                              msg +='<br/>'+ msg3;
                          } else {
                              msg = msg3;
                          }*/
                  }
                  if(acc.RecordType.Name == 'Partner Account' && acc.Partner_Type__c == 'Franchisor' ){
                        warn3 = true;
                        /* if(msg != null) {
                              msg +='<br/>'+ msg3;
                         } else {
                              msg = msg3;
                         }*/
                  }
                  if(acc.MRR__c != null && acc.RC_Account_Status__c != null && acc.MRR__c == 0 && acc.RC_Account_Status__c.equalsIgnoreCase('Paid')) {
                  		 if(acc.RC_SignUp_date__c  != null && String.valueOf(acc.RC_SignUp_date__c) != '') {
                  		 	boolTrailAccountMsg = true;
                  		 	Date paidDate = acc.RC_SignUp_date__c.Date() + 30;
                  		 	strPaidDate = paidDate.format();
                  		 } 
                  }
             } 
        }
        
        public void getDocument(){
        	String docName = 'Account_Highlighter';
			List<Document> doc = [SELECT body, Name, bodyLength, ContentType, Url FROM Document WHERE Name = :docName];
			if(doc != null && doc.size()>0){
				Blob b = doc[0].body;
				String content  = b.toString();
				List<List<String>> parsedCSV = new List<List<String>>();
				
				// Parse the CSV File
				parsedCSV =  parseCSV(content);
				if(parsedCSV != null && ! Test.isRunningTest()){
					parsedCSV.remove(0);
				}
				if(parsedCSV!=null){
					for (List<String> line : parsedCSV){
				    	if(line != null){
				    		String accName = line.get(0);
					        String custContactName = line.get(1);
					        String rcExecContactName = line.get(2);
					        String userId = line.get(3);
					        mapAccHighlighter.put(userId,new AccHighlighterWrapper(accName,custContactName,rcExecContactName,userId));
				    	}
					}
				}
			}
        }
        
        public class AccHighlighterWrapper{
        	public String accName;
        	public String custContactName;
        	public String rcExecContactName;
        	public String userId;
        	
        	public AccHighlighterWrapper(String accName, String custContactName, String rcExecContactName, String userId){
        		this.accName = accName;
        		this.custContactName = custContactName;
        		this.rcExecContactName = rcExecContactName;
        		this.userId = userId;
        	}
        }
        
        private List<List<String>> parseCSV(string contents) {
			List<List<String>> allFields = new List<List<String>>(); 
			try {
		        contents = contents.replaceAll(',"""',',"DBLQT').replaceall('""",','DBLQT",');
		        contents = contents.replaceAll('""','DBLQT');
		        List<String> lines = new List<String>();
	            lines = contents.split('\n'); 
		        Integer num = 0;
		        for(String line : lines) {
		            if (line.replaceAll(',','').trim().length() == 0) break;
		            List<String> fields = line.split(','); 
		            List<String> cleanFields = new List<String>();
		            String compositeField;
		            Boolean makeCompositeField = false;
		            for(String field : fields) {
		                if (field.startsWith('"') && field.endsWith('"')) {
		                    cleanFields.add(field.replaceAll('DBLQT','"').trim());
		                } else if (field.startsWith('"')) {
		                    makeCompositeField = true;
		                    compositeField = field.trim();
		                } else if (field.endsWith('"')) {
		                    compositeField += ',' + field.trim();
		                    cleanFields.add(compositeField.replaceAll('DBLQT','"').trim());
		                    makeCompositeField = false;
		                } else if (makeCompositeField) {
		                    compositeField +=  ',' + field.trim();
		                } else {
		                    cleanFields.add(field.replaceAll('DBLQT','"').trim());
		                }
		            }
		            allFields.add(cleanFields);
		        }	
			} catch(Exception ex) {}
			return allFields; 
    	}
    	
    	/*********************************************************************************************
        *@Description............: Update the Technical Account Manager field on Account,           *
        *                          with the most recently modified Technical Account Manager-Primary*
        *Param...................: none                                                             *
        *@Return.................: pageReference                                                    *
        ********************************************************************************************/
        
        /*
        public PageReference PopulateATM(){  
          try{
            Account accountRecord =  new Account(Id = acct.Id);
            accountRecord.Technical_Account_Manager__c = null;
            for(AccountTeamMember atm : [SELECT TeamMemberRole, User.Name, UserId,LastModifiedDate FROM AccountTeamMember 
                                         WHERE AccountId =: acct.Id AND TeamMemberRole =: 'Technical Account Manager - Primary' 
                                         ORDER BY CreatedDate ASC LIMIT 1]) {  
                if( atm.TeamMemberRole != null && (atm.TeamMemberRole.containsIgnoreCase('Technical Account Manager - Primary'))){ 
                    warn5 = true ;  
                    strTAM = atm.User.Name;
                    strTAMId = atm.UserId;
                    if(atm.UserId != null && accountRecord != null && accountRecord.Id != null){
                        accountRecord.Technical_Account_Manager__c = atm.UserId;
                    }
                 }       
             }
             system.debug('#### Account Record to be Update = '+accountRecord);
             if(accountRecord != null && accountRecord.Id != null){
               update accountRecord;
             }  
          }catch(Exception ex){
            system.debug('#### Exception at line = '+ex.getLineNumber()+' Message = '+ex.getMessage());
          }               
          return null;
     }
     
     */
     public PageReference PopulateATM(){  
          try{
          	system.debug('### ' + acct);
            system.debug('======== TAM =========== '+ acct.Technical_Account_Manager__c + ', CONTACT= ' + acct.Most_Recent_Implementation_Contact__c);
            Id tAMOldValue = acct.Technical_Account_Manager__c;
            Id tAMNewValue = null;
            Id oldContactId = null;
            Id newContactId = null;
            Boolean isContactRoleUpdated = false;
            List<AccountContactRole> accConRoleList = [SELECT Id, ContactId FROM AccountContactRole WHERE AccountId =: acct.Id AND IsPrimary=true];
            
            if(accConRoleList.size()>0){
            	AccountContactRole accConRoleObj = accConRoleList[0];
	            if(accConRoleObj != null) {
	            	Contact con = [SELECT Id, Preferred_Language__c FROM Contact WHERE id =: accConRoleObj.ContactId limit 1];
	            	oldContactId = acct.Most_Recent_Implementation_Contact__c;
	            	newContactId = accConRoleObj.ContactId;
	            	System.debug('### NEW Contact = ' + newContactId);
	            	System.debug('### OLD Contact = ' + oldContactId);
	            	if(acct.Most_Recent_Implementation_Contact__c != accConRoleObj.ContactId) {
	            		isContactRoleUpdated = true;
	            		acct.Most_Recent_Implementation_Contact__c =  accConRoleObj.ContactId;
	            		acct.Preferred_Language__c = con.Preferred_Language__c;
	            	}
	            }
	       }else{
           			list<Contact> conList = [SELECT Id, Preferred_Language__c FROM Contact WHERE AccountId =: acct.Id order by LastModifiedDate desc];
           			system.debug('conList--->'+conList);
           			boolean isLastModied = true;
           			Integer ii = 0;
           			for(Contact con :conList ){
           				if(acct.Most_Recent_Implementation_Contact__c != con.Id ) {
	           				if(isLastModied && ii==0){
	           					isContactRoleUpdated = true;
	           					acct.Most_Recent_Implementation_Contact__c =  con.Id;
		            			acct.Preferred_Language__c = con.Preferred_Language__c;
		            			isLastModied = false;
	           				}
           				}
           				ii++;
           			}
           			
           }
           if(String.isBlank(String.valueOf(acct.Preferred_Language__c))){
           		acct.Preferred_Language__c = 'en_US';
           }
           
           system.debug('acct.Most_Recent_Implementation_Contact__c--->'+acct.Most_Recent_Implementation_Contact__c);
            Boolean isTamUpdated = false;
            for(AccountTeamMember atm : [SELECT TeamMemberRole, User.Name, UserId,LastModifiedDate FROM AccountTeamMember 
                                         WHERE AccountId =: acct.Id AND TeamMemberRole =: 'Technical Account Manager - Primary' 
                                         ORDER BY CreatedDate ASC LIMIT 1]) {  
                if( atm.TeamMemberRole != null && (atm.TeamMemberRole.containsIgnoreCase('Technical Account Manager - Primary'))){ 
                    warn5 = true ;  
                    strTAM = atm.User.Name;
                    strTAMId = atm.UserId;
                    if(acct != null){
                        tAMNewValue = atm.UserId;
                    }
                 }
             }
             
             if(tAMNewValue != tAMOldValue && acct.Id != null){
               acct.Technical_Account_Manager__c = tAMNewValue;
               refreshBool = true;
               system.debug('####  New TAM = '+ acct.Technical_Account_Manager__c);
               TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT();
               TriggerHandler.BY_PASS_ACCOUNT_ON_UPDATE();  
               isTamUpdated = true; 
               update acct;
             }  
             if(!isTamUpdated && isContactRoleUpdated) {
				refreshBool = true;
               	system.debug('####  New TAM = '+ acct.Most_Recent_Implementation_Contact__c);
               	TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT();
               	TriggerHandler.BY_PASS_ACCOUNT_ON_UPDATE();  
               	update acct;
             }
          }catch(Exception ex){
            system.debug('#### Exception at line = '+ex.getLineNumber()+' Message = '+ex.getMessage());
          }
          return null;
     }
 }