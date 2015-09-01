public class PRMHelper {
    List<Account> PRMAccList;
    List<Contact> PRMAccContList;
    Map<id, Partner_Request__c>  PRMAcctMap; 
    Map<id, Account>  tempPRMAcctMap;
    public Map<String,Account> prmIdAccountMap = new Map<String,Account>();
    public Map<String, Account> PRMAcctMapInUpdate = new Map<String, Account>();
    public Map<String, Account> PRMAcctMap2 = new Map<String, Account>();
    public Map<String, Account> PRMFrancAccMap = new Map<String, Account>();
    
    public Set<String> PartnerCompanyName = new Set<String>();
    public Set<String> partnerId = new Set<String>();
    public Set<String> partnerComapanyNameUpdate = new Set<String>();
    
    public PRMHelper(List<Partner_Request__c> PRMList) {
    	List<Partner_Request__c> PRMFrancList = new List<Partner_Request__c>();
        for(Partner_Request__c PRM: PRMList){
            if(PRM.Partner_Type__c == 'Franchisor' && PRM.Partner_Request_Source__c == 'National Accounts' ) {
                  PRMFrancList.add(PRM);            
            } 
        }
        PRMAccList = new List<Account>();
        PRMAccContList = new List<Contact>();
        PRMAcctMap = new Map<id, Partner_Request__c>();
        tempPRMAcctMap = new Map<id, Account>();
        for(Partner_Request__c PRM : PRMFrancList) {
            tempPRMAcctMap.put(PRM.id , mapPRMtoACC(PRM));
        }
        try {
            if(tempPRMAcctMap.values().size() != 0)
                insert tempPRMAcctMap.values();
        } catch (Exception e) { }   
        for(Partner_Request__c PRM : PRMFrancList) {
            PRMAccContList.add( mapPRMAccToCont(tempPRMAcctMap.get(PRM.id).id , PRM) );
        } 
        try {
            if(PRMAccContList.size() != 0)
                insert PRMAccContList;
        } catch (Exception e) { }   
    }
    
    public void onInsertPRM(List<Partner_Request__c> triggerNewList){
    	 system.debug('@@@@@@@@@@@@@@@@+ on isert') ;   
    	/***************************************/
    	for(Partner_Request__c PRM: triggerNewList) {
            this.PartnerCompanyName.add(PRM.Partner_Company_Name__c);
        }
        for(Account acc: [SELECT  id, Name ,PartnerStatus__c ,Partner_Type__c, Partner_Source__c,Referring_DSR__c,
        					Partner_Sign_Up_Date__c FROM Account 
                            WHERE (Account.Name IN : this.PartnerCompanyName and Account.Name != '')
            AND type='Partner' ]) {
            PRMAcctMap2.put(acc.Name, acc);
        }
        /***************************************/
        /***************************************/
        List<Account> PRMAcct = new Account[]{};
        List<Contact> contactcon = new Contact[]{};
        Integer intAccExist = 0;
        for(Partner_Request__c PRM: triggerNewList) {
            try {
            	//integer i = 1/0;
            	/* List<Account> acc = [SELECT  id,Name,PartnerStatus__c FROM Account where (Account.Name=:PRM.Partner_Company_Name__c and Account.Name != '')
                and type='Partner'];   */         
               system.debug('@@@@@@@@@@@@@@@@+ PRMAcctMap2.get(PRM.Partner_Company_Name__c) = '+PRMAcctMap2.get(PRM.Partner_Company_Name__c)) ;
               if(PRMAcctMap2.get(PRM.Partner_Company_Name__c) == null) {   
               	  system.debug('@@@@@@@@@@@@@@@@+ creating new account') ; 
               	  system.debug('@@@@@@@@@@@@@@@@+ creating 1111111111'+ PRM.How_did_you_hear_about_the_RC_Part_Prog__c) ;         
                  Account acct = new Account(
                  External_SID__c=PRM.External_SID__c,
                  Current_Telephone_System_Solution_s__c=PRM.Current_Telephone_System_Solution_s__c,
                  Partner_Currently_resell__c=PRM.Partner_Currently_resell__c,
                  Partner_Cisco_Reseller__c=PRM.Partner_Cisco_Reseller__c,              
                  How_did_you_hear_about_the_RC_Part_Prog__c=PRM.How_did_you_hear_about_the_RC_Part_Prog__c,
                  Partner_Average_Customer_Size__c =PRM.Partner_Average_Customer_Size__c,
                  Partner_Additional_Information__c =PRM.Partner_Additional_Information__c,
                  PartnerStatus__c='New',              
                  Name = PRM.Partner_Company_Name__c,              
                  Partner_Country__c = PRM.Partner_Country__c,
                  Partner_State__c = PRM.Partner_State__c,
                  Partner_Address1__c = PRM.Partner_Address1__c,
                  Partner_Address2__c = PRM.Partner_Address2__c,
                  Partner_City__c = PRM.Partner_City__c,
                  Partner_Zip__c = PRM.Partner_Zip__c,
                  //Partner_Source__c = PRM.Partner_Request_Source__c,
                  Partner_Source__c = !string.isBlank(PRM.DSR_USER__c) ? 'Direct Sales Referral' : PRM.Partner_Request_Source__c,
                  Referring_DSR__c =  PRM.DSR_USER__c,                 
                  Partner_Company_Name__c =PRM.Partner_Company_Name__c,              
                  Partner_ID__c = PRM.Partner_ID__c,
                  Phone = PRM.Partner_Phone__c,
                  Other_TextField__c = PRM.Partner_Email_Address__c,
                  Partner_Description_of_Your_Business__c = PRM.Partner_Description_of_Your_Business__c,
                  OwnerID = '005800000038AHj',
                  Partner_Type__c = PRM.Partner_Type__c,
                  Type = 'Partner', 
                  Partner_Sign_Up_Date__c = Date.today(),   //27Dec   
                  Signup_Link__c = 'http://www.ringcentral.com/partner_signup.html?cid=reseller&partnerid='+PRM.Partner_ID__c,
                  Co_Branded_Funnel_Link__c= 'https://secure.ringcentral.com/partners/signup?partnerid='+PRM.Partner_ID__c,
                  BillingStreet = PRM.Partner_Address1__c,
                  BillingCity = PRM.Partner_City__c,
                  BillingState = PRM.Partner_State__c,
                  BillingPostalCode =  PRM.Partner_Zip__c,
                  BillingCountry = PRM.Partner_Country__c,     //27Dec 
                  Sales_Model__c = PRM.Sales_Model__c,
				  Which_verticals_do_you_sell_to_most__c=PRM.Which_verticals_do_you_sell_to_most__c,
				  Partner_Currently_Resell_Other__c=PRM.Partner_Currently_Resell_Other__c,
				  Customer_ready_to_place_an_order_now__c=PRM.Customer_ready_to_place_an_order_now__c,
				  How_d_you_like_us_to_follow_up_with_you__c=PRM.How_d_you_like_us_to_follow_up_with_you__c,
				  Partner_Best_Contact_Time__c=PRM.Partner_Best_Contact_Time__c,
				  Closest_Metro_Area__c=PRM.Closest_Metro_Area__c,
				  Certifications__c=PRM.Certifications__c,
				  Certifications_Other__c=PRM.Certifications_Other__c,
				  Contact_FName__c = PRM.Partner_First_Name__c,
	  			  Contact_LName__c = PRM.Partner_Last_Name__c,
	  			  Contact_Email__c = PRM.Partner_Email_Address__c,
	  	          Contact_Phone__c = PRM.Partner_Phone__c,
	  	          No_of_Employees__c = PRM.No_of_Employees__c,
	  	          Dist_Dealer__c =PRM.AFN__c,
		  	      Master_Distributor_Agent__c = 'Yes'.equalsIgnoreCase(PRM.AD__c) ?true:false,		  	          
	  	          Company_size_typically_sell_to__c =PRM.Company_size_typically_sell_to__c,
	  	          Annual_Gross_Revenue__c = PRM.Annual_Gross_Revenue__c);  
				  system.debug('@@@@@@@@@@@@@@@@+ creating 22222222222'+ acct.How_did_you_hear_about_the_RC_Part_Prog__c) ;           
                  if(acct.Name == null || acct.Name == '') {
						acct.Name = 'No name from PRM';
                    	System.debug('prm object did not pass name.');
                  }
                  PRMAcct.add(acct);
                } else {
                    intAccExist = 1;
                   // for(Account accObj : acc)
					for(Account accObj: (List<Account>)PRMAcctMap2.values()) {      
						if(accObj.PartnerStatus__c == 'Declined') {
                          Account acct = new Account(
                          External_SID__c=PRM.External_SID__c,
                          id = accObj.Id,Current_Telephone_System_Solution_s__c=PRM.Current_Telephone_System_Solution_s__c,
                          Partner_Currently_resell__c=PRM.Partner_Currently_resell__c,
                          Partner_Cisco_Reseller__c=PRM.Partner_Cisco_Reseller__c,              
                          How_did_you_hear_about_the_RC_Part_Prog__c=PRM.How_did_you_hear_about_the_RC_Part_Prog__c,
                          Partner_Average_Customer_Size__c =PRM.Partner_Average_Customer_Size__c,
                          Partner_Additional_Information__c =PRM.Partner_Additional_Information__c,
                          PartnerStatus__c='New',              
                          Name = PRM.Partner_Company_Name__c,              
                          Partner_Country__c = PRM.Partner_Country__c,
                          Partner_State__c = PRM.Partner_State__c,
                          Partner_Address1__c = PRM.Partner_Address1__c,
                          Partner_Address2__c = PRM.Partner_Address2__c,
                          Partner_City__c = PRM.Partner_City__c,
                          Partner_Zip__c = PRM.Partner_Zip__c,
                          Partner_Source__c = PRM.Partner_Request_Source__c,              
                          Partner_Company_Name__c =PRM.Partner_Company_Name__c,              
                          //Partner_ID__c = PRM.Partner_ID__c,
                          Partner_ID__c=(accObj.Partner_ID__c==null?PRM.Partner_ID__c:accObj.Partner_ID__c),
                          Phone = PRM.Partner_Phone__c,
                          Partner_Description_of_Your_Business__c = PRM.Partner_Description_of_Your_Business__c,
                          //Partner_Sign_Up_Date__c = Date.today(),   //27Dec 
                          Signup_Link__c = 'http://www.ringcentral.com/partner_signup.html?cid=reseller&partnerid='+PRM.Partner_ID__c,
                          Co_Branded_Funnel_Link__c= 'https://secure.ringcentral.com/partners/signup?partnerid='+PRM.Partner_ID__c, //27Dec 
                          Sales_Model__c = PRM.Sales_Model__c,
					      Which_verticals_do_you_sell_to_most__c=PRM.Which_verticals_do_you_sell_to_most__c,
					      Partner_Currently_Resell_Other__c=PRM.Partner_Currently_Resell_Other__c,
					      Customer_ready_to_place_an_order_now__c=PRM.Customer_ready_to_place_an_order_now__c,
					      How_d_you_like_us_to_follow_up_with_you__c=PRM.How_d_you_like_us_to_follow_up_with_you__c,
					      Partner_Best_Contact_Time__c=PRM.Partner_Best_Contact_Time__c,
					      Closest_Metro_Area__c=PRM.Closest_Metro_Area__c,
					      Certifications__c=PRM.Certifications__c,
					      Certifications_Other__c=PRM.Certifications_Other__c,
						  Contact_FName__c = PRM.Partner_First_Name__c,
			  			  Contact_LName__c = PRM.Partner_Last_Name__c,
			  			  Contact_Email__c = PRM.Partner_Email_Address__c,
			  	          Contact_Phone__c = PRM.Partner_Phone__c,
			  	          No_of_Employees__c = PRM.No_of_Employees__c,
			  	          Dist_Dealer__c =PRM.AFN__c,
		  	              Master_Distributor_Agent__c = 'Yes'.equalsIgnoreCase(PRM.AD__c) ?true:false,		  	          
  	                	  Company_size_typically_sell_to__c =PRM.Company_size_typically_sell_to__c,
			  	          Annual_Gross_Revenue__c = PRM.Annual_Gross_Revenue__c);
			  	          if(accObj.Partner_Sign_Up_Date__c == null) {
			  	          	acct.Partner_Sign_Up_Date__c = Date.today(); 
  	          			  }
                          if(acct.Name == null || acct.Name == '') {
                            acct.Name = 'No name from PRM';
                            System.debug('prm object did not pass name in else clause.');
                          }
                          PRMAcct.add(acct);                              
                         }
                     }              
                }
            } catch(Exception e){    
                try {
                     Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                     String[] toAddresses = new String[] {UserRC.rcsfSyncUserObj.Email__c}; //Need to replace when go LIVE --> rcsync
                     mail.setToAddresses(toAddresses);
                     //String[] ccAddresses = new String[] {'alok@simplion.com'}; //bonniel@ringcentral.com
                     //mail.setCcAddresses(ccAddresses);
                     mail.setSenderDisplayName('Partner Request Form');
                     mail.setSubject('Partner Request - Account was not created');
                     mail.setPlainTextBody('Account for following Partner Request has been not created due to some invalid data provided by user.\n\n' +
                     //'Partner Company Name: ' + PRM.Partner_Company_Name__c + '  ' + '\n\n'+'To view the details of this Partner Request in SFDC click on the following link: https://na6.salesforce.com/' + PRM.Id );
                     'Partner Company Name: ' + PRM.Partner_Company_Name__c + '  ' + '\n\n'+'To view the details of this Partner Request in SFDC click on the following link: https://'+System.URL.getSalesforceBaseURL().getHost()+'/' + PRM.Id );               
                     Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  
				} catch(Exception ex) {} 
			}
        }
        if(PRMAcct != null && PRMAcct.size() != 0){
        	upsert PRMAcct;
        	system.debug('@@@@@@@@@@@@@@@@+ creating new account  '+PRMAcct) ;   
        }
          // Creating CONTACT with RELTAION to ACCOUNT
          for(Partner_Request__c PRM: triggerNewList){
            if(intAccExist == 0){
                Contact cont = new Contact();
                cont.Firstname = PRM.Partner_First_Name__c;
                cont.lastname = PRM.Partner_Last_Name__c;
                try{
                    cont.AccountId = PRMAcct[0].Id; 
                }catch (Exception e) {
                    System.debug(e);
                }
                cont.Phone = PRM.Partner_Phone__c;
                cont.MobilePhone = PRM.Partner_Mobile__c;
                cont.Email = PRM.Partner_Email_Address__c;
                cont.MailingpostalCode = PRM.Partner_Zip__c;
                cont.MailingCity = PRM.Partner_City__c;
                cont.MailingState = PRM.Partner_State__c;
                cont.MailingCountry = PRM.Partner_Country__c;
                cont.MailingStreet = PRM.Partner_Address1__c;
                cont.Title=PRM.Partner_Title__c;
                cont.Company__c = PRM.Partner_Company_Name__c;                 
                insert cont;
            }
          }       
		upsert contactcon;
    }
    public void onUpdatePRM(List<Partner_Request__c> triggerNewList){
     	/***********************************************/
     	for(Partner_Request__c PRM: triggerNewList) {
            partnerId.add(PRM.Partner_ID__c );
            partnerComapanyNameUpdate.add(PRM.Partner_Company_Name__c);
        }
        for(Account acc: [SELECT  id,Name,PartnerStatus__c, Partner_Type__c ,Partner_Source__c ,Partner_ID__c, Partner_Sign_Up_Date__c 
        					FROM Account where (Account.Partner_ID__c IN: partnerId OR  Account.Name IN: partnerComapanyNameUpdate) 
        					AND type='Partner' ]) {
                
                    prmIdAccountMap.put(acc.Partner_ID__c, acc);
                    PRMAcctMapInUpdate.put(acc.Name, acc);
        }
     	/***********************************************/
        List<Account> PRMAcct = new Account[]{};
        List<Contact> contactcon = new Contact[]{};        
        integer intAccExist = 0;
		for(Partner_Request__c PRM: triggerNewList){
            //if Updateing same PRM Records with some diff company name
        /*   List<Account> accSame = [SELECT  id,Name,PartnerStatus__c FROM Account 
             where Account.Partner_ID__c=:PRM.Partner_ID__c 
             and type='Partner'];*/
        if(prmIdAccountMap.values().size() > 0){ 
                for(Account accObj :(List<Account>)prmIdAccountMap.values()) {    
                      Account acctSameUp = new Account(
                      External_SID__c=PRM.External_SID__c,
                      id = accObj.Id,
                      Current_Telephone_System_Solution_s__c=PRM.Current_Telephone_System_Solution_s__c,
                      Partner_Currently_resell__c=PRM.Partner_Currently_resell__c,
                      Partner_Cisco_Reseller__c=PRM.Partner_Cisco_Reseller__c,              
                      How_did_you_hear_about_the_RC_Part_Prog__c=PRM.How_did_you_hear_about_the_RC_Part_Prog__c,
                      Partner_Average_Customer_Size__c =PRM.Partner_Average_Customer_Size__c,
                      Partner_Additional_Information__c =PRM.Partner_Additional_Information__c,                                   
                      Name = PRM.Partner_Company_Name__c,              
                      Partner_Country__c = PRM.Partner_Country__c,
                      Partner_State__c = PRM.Partner_State__c,
                      Partner_Address1__c = PRM.Partner_Address1__c,
                      Partner_Address2__c = PRM.Partner_Address2__c,
                      Partner_City__c = PRM.Partner_City__c,
                      Partner_Zip__c = PRM.Partner_Zip__c,
                     // Partner_Source__c = PRM.Partner_Request_Source__c,
                      Partner_Source__c = (accObj.Partner_Source__c == 'National Accounts'? 'National Accounts' : PRM.Partner_Request_Source__c),
                      Partner_Type__c =  (accObj.Partner_Type__c == 'Franchisor'?'Franchisor': PRM.Partner_Type__c),                                  
                      Partner_Company_Name__c =PRM.Partner_Company_Name__c,              
                     // Partner_ID__c = PRM.Partner_ID__c,
                      Partner_ID__c=(accObj.Partner_ID__c==null?PRM.Partner_ID__c:accObj.Partner_ID__c),
                      Phone = PRM.Partner_Phone__c,
                      Partner_Description_of_Your_Business__c = PRM.Partner_Description_of_Your_Business__c,
                     // Partner_Sign_Up_Date__c = Date.today(),   //27Dec 
                      Signup_Link__c = 'http://www.ringcentral.com/partner_signup.html?cid=reseller&partnerid='+PRM.Partner_ID__c,
                      Co_Branded_Funnel_Link__c= 'https://secure.ringcentral.com/partners/signup?partnerid='+PRM.Partner_ID__c, //27Dec 
                      Sales_Model__c = PRM.Sales_Model__c,
					  Which_verticals_do_you_sell_to_most__c=PRM.Which_verticals_do_you_sell_to_most__c,
					  Partner_Currently_Resell_Other__c=PRM.Partner_Currently_Resell_Other__c,
					  Customer_ready_to_place_an_order_now__c=PRM.Customer_ready_to_place_an_order_now__c,
					  How_d_you_like_us_to_follow_up_with_you__c=PRM.How_d_you_like_us_to_follow_up_with_you__c,
					  Partner_Best_Contact_Time__c=PRM.Partner_Best_Contact_Time__c,
					  Closest_Metro_Area__c=PRM.Closest_Metro_Area__c,
					  Certifications__c=PRM.Certifications__c,
					  Certifications_Other__c=PRM.Certifications_Other__c,
					  Contact_FName__c = PRM.Partner_First_Name__c,
		  			  Contact_LName__c = PRM.Partner_Last_Name__c,
		  			  Contact_Email__c = PRM.Partner_Email_Address__c,
		  	          Contact_Phone__c = PRM.Partner_Phone__c,
		  	          No_of_Employees__c = PRM.No_of_Employees__c,
		  	          Dist_Dealer__c =PRM.AFN__c,
		  	          Master_Distributor_Agent__c = 'Yes'.equalsIgnoreCase(PRM.AD__c) ?true:false,		  	          
	  	              Company_size_typically_sell_to__c =PRM.Company_size_typically_sell_to__c,
		  	          Annual_Gross_Revenue__c = PRM.Annual_Gross_Revenue__c);
		  	          if(accObj.Partner_Sign_Up_Date__c == null) {
		  	              acctSameUp.Partner_Sign_Up_Date__c = Date.today(); 
		  	              System.Debug('>>44>>'+ acctSameUp.Partner_Sign_Up_Date__c);
  	          		  }
  	          		  accObj.Partner_Source__c = !string.isBlank(PRM.DSR_USER__c) ? 'Direct Sales Referral' : PRM.Partner_Request_Source__c;
                      PRMAcct.add(acctSameUp);                              
			}  
		}else{ //when updating the PRM Records which is not carried away fully              
            intAccExist = 1;
         	try {
                    /* List<Account> accNotbyName = [SELECT  id,Name,PartnerStatus__c FROM Account 
                     where Account.Name=:PRM.Partner_Company_Name__c  
                     and type='Partner'];*/
				if(PRMAcctMapInUpdate.values().size() == 0){ 
                     Account acctNewOne = new Account(
			          External_SID__c=PRM.External_SID__c,
			          Current_Telephone_System_Solution_s__c=PRM.Current_Telephone_System_Solution_s__c,
			          Partner_Currently_resell__c=PRM.Partner_Currently_resell__c,
			          Partner_Cisco_Reseller__c=PRM.Partner_Cisco_Reseller__c,              
			          How_did_you_hear_about_the_RC_Part_Prog__c=PRM.How_did_you_hear_about_the_RC_Part_Prog__c,
			          Partner_Average_Customer_Size__c =PRM.Partner_Average_Customer_Size__c,
			          Partner_Additional_Information__c =PRM.Partner_Additional_Information__c,
			          PartnerStatus__c='New',              
			          Name = PRM.Partner_Company_Name__c,              
			          Partner_Country__c = PRM.Partner_Country__c,
			          Partner_State__c = PRM.Partner_State__c,
			          Partner_Address1__c = PRM.Partner_Address1__c,
			          Partner_Address2__c = PRM.Partner_Address2__c,
			          Partner_City__c = PRM.Partner_City__c,
			          Partner_Zip__c = PRM.Partner_Zip__c,
			          //Partner_Source__c = PRM.Partner_Request_Source__c, 
			          Partner_Source__c = !string.isBlank(PRM.DSR_USER__c) ? 'Direct Sales Referral' : PRM.Partner_Request_Source__c,
			          Referring_DSR__c =  PRM.DSR_USER__c,              
			          Partner_Company_Name__c =PRM.Partner_Company_Name__c,              
			          Partner_ID__c = PRM.Partner_ID__c,
			          Phone = PRM.Partner_Phone__c,
			          Other_TextField__c = PRM.Partner_Email_Address__c,
			          Partner_Description_of_Your_Business__c = PRM.Partner_Description_of_Your_Business__c,
			          OwnerID = '005800000038AHj',
			          Partner_Type__c = PRM.Partner_Type__c,
			          Type = 'Partner', 
			          Partner_Sign_Up_Date__c = Date.today(),   //27Dec   
			          Signup_Link__c = 'http://www.ringcentral.com/partner_signup.html?cid=reseller&partnerid='+PRM.Partner_ID__c,
			          Co_Branded_Funnel_Link__c= 'https://secure.ringcentral.com/partners/signup?partnerid='+PRM.Partner_ID__c,
			          BillingStreet = PRM.Partner_Address1__c,
			          BillingCity = PRM.Partner_City__c,
			          BillingState = PRM.Partner_State__c,
			          BillingPostalCode =  PRM.Partner_Zip__c,
			          BillingCountry = PRM.Partner_Country__c,     //27Dec 
			  	      Sales_Model__c = PRM.Sales_Model__c,
			          Which_verticals_do_you_sell_to_most__c=PRM.Which_verticals_do_you_sell_to_most__c,
			          Partner_Currently_Resell_Other__c=PRM.Partner_Currently_Resell_Other__c,
			    	  Customer_ready_to_place_an_order_now__c=PRM.Customer_ready_to_place_an_order_now__c,
			          How_d_you_like_us_to_follow_up_with_you__c=PRM.How_d_you_like_us_to_follow_up_with_you__c,
			    	  Partner_Best_Contact_Time__c=PRM.Partner_Best_Contact_Time__c,
			    	  Closest_Metro_Area__c=PRM.Closest_Metro_Area__c,
			     	  Certifications__c=PRM.Certifications__c,
			    	  Certifications_Other__c=PRM.Certifications_Other__c,
					  Contact_FName__c = PRM.Partner_First_Name__c,
		  			  Contact_LName__c = PRM.Partner_Last_Name__c,
		  			  Contact_Email__c = PRM.Partner_Email_Address__c,
		  	          Contact_Phone__c = PRM.Partner_Phone__c,
		  	          No_of_Employees__c = PRM.No_of_Employees__c,
		  	          Dist_Dealer__c =PRM.AFN__c,
		  	          Master_Distributor_Agent__c = 'Yes'.equalsIgnoreCase(PRM.AD__c) ?true:false,		  	          
	  	              Company_size_typically_sell_to__c =PRM.Company_size_typically_sell_to__c,
		  	          Annual_Gross_Revenue__c = PRM.Annual_Gross_Revenue__c);             
			          PRMAcct.add(acctNewOne);  
                 }
             }catch(Exception e){ }
         }
     }
     upsert PRMAcct;
         // Creating CONTACT with RELTAION to ACCOUNT          
          for(Partner_Request__c PRM: triggerNewList){ 
            if(intAccExist == 1){         
                Contact cont = new Contact();
                cont.Firstname = PRM.Partner_First_Name__c;
                cont.lastname = PRM.Partner_Last_Name__c;
                try{
                    cont.AccountId = PRMAcct[0].Id; 
                }catch (Exception e) {
                    System.debug(e);
                }
                cont.Phone = PRM.Partner_Phone__c;
                cont.MobilePhone = PRM.Partner_Mobile__c;
                cont.Email = PRM.Partner_Email_Address__c;
                cont.MailingpostalCode = PRM.Partner_Zip__c;
                cont.MailingCity = PRM.Partner_City__c;
                cont.MailingCountry = PRM.Partner_Country__c;
                cont.MailingState = PRM.Partner_State__c;
                cont.MailingStreet = PRM.Partner_Address1__c;
                cont.Title=PRM.Partner_Title__c;
                cont.Company__c = PRM.Partner_Company_Name__c;                 
                insert cont;
            }           
          } 
    }
    
    public Contact mapPRMAccToCont(ID accId, Partner_Request__c PRM) {
		Contact cont = new Contact();
		cont.Firstname = PRM.Partner_First_Name__c;
		cont.lastname = PRM.Partner_Last_Name__c;
		try{
		    cont.AccountId = accId; 
		}catch (Exception e) {
		    System.debug(e);
		}
		cont.Phone = PRM.Partner_Phone__c;
		cont.MobilePhone = PRM.Partner_Mobile__c;
		cont.Email = PRM.Partner_Email_Address__c;
		cont.MailingpostalCode = PRM.Partner_Zip__c;
		cont.MailingCity = PRM.Partner_City__c;
		cont.MailingState = PRM.Partner_State__c;
		cont.MailingCountry = PRM.Partner_Country__c;
		cont.MailingStreet = PRM.Partner_Address1__c;
		cont.Title = PRM.Partner_Title__c;
		cont.Company__c = PRM.Partner_Company_Name__c;                 
		return cont;
    }
    public Account mapPRMtoACC(Partner_Request__c PRM) {
    	Account acct = new Account();
	  	acct.Current_Telephone_System_Solution_s__c = PRM.Current_Telephone_System_Solution_s__c;
	  	acct.Partner_Currently_resell__c =PRM.Partner_Currently_resell__c;
	  	acct.Partner_Cisco_Reseller__c = PRM.Partner_Cisco_Reseller__c;              
	  	acct.How_did_you_hear_about_the_RC_Part_Prog__c = PRM.How_did_you_hear_about_the_RC_Part_Prog__c;
	  	acct.Partner_Average_Customer_Size__c = PRM.Partner_Average_Customer_Size__c;
	  	acct.Partner_Additional_Information__c = PRM.Partner_Additional_Information__c;
	  	acct.PartnerStatus__c='New';              
	  	acct.Name = PRM.Partner_Company_Name__c;              
	  	acct.Partner_Country__c = PRM.Partner_Country__c;
	  	acct.Partner_State__c = PRM.Partner_State__c;
	  	acct.Partner_Address1__c = PRM.Partner_Address1__c;
	  	acct.Partner_Address2__c = PRM.Partner_Address2__c;
	  	acct.Partner_City__c = PRM.Partner_City__c;
	  	acct.Partner_Zip__c = PRM.Partner_Zip__c;
	  	acct.Partner_Company_Name__c =PRM.Partner_Company_Name__c;              
	 	acct.Partner_ID__c = PRM.Partner_ID__c;
	 	acct.Phone = PRM.Partner_Phone__c;
	 	acct.Other_TextField__c = PRM.Partner_Email_Address__c;
	 	acct.Partner_Description_of_Your_Business__c = PRM.Partner_Description_of_Your_Business__c;
	 	acct.OwnerID = '005800000038AHj';
	 	acct.Type = 'Partner'; 
	  	acct.Partner_Sign_Up_Date__c = Date.today();  //27Dec   
	  	acct.Signup_Link__c = 'http://www.ringcentral.com/partner_signup.html?cid=reseller&partnerid='+PRM.Partner_ID__c;
	  	acct.Co_Branded_Funnel_Link__c= 'https://secure.ringcentral.com/partners/signup?partnerid='+PRM.Partner_ID__c;
	  	acct.BillingStreet = PRM.Partner_Address1__c;
	  	acct.BillingCity = PRM.Partner_City__c;
	  	acct.BillingState = PRM.Partner_State__c;
	  	acct.BillingPostalCode =  PRM.Partner_Zip__c;
	  	acct.BillingCountry = PRM.Partner_Country__c;
	  	acct.Partner_Source__c = 'National Accounts';
	  	acct.Partner_Type__c = 'Franchisor';
	  	acct.Sales_Model__c = PRM.Sales_Model__c ;  
	  	acct.External_SID__c=PRM.External_SID__c;
	  	acct.Which_verticals_do_you_sell_to_most__c=PRM.Which_verticals_do_you_sell_to_most__c;
	  	acct.Partner_Currently_Resell_Other__c=PRM.Partner_Currently_Resell_Other__c;
	  	acct.Customer_ready_to_place_an_order_now__c=PRM.Customer_ready_to_place_an_order_now__c;
	  	acct.How_d_you_like_us_to_follow_up_with_you__c=PRM.How_d_you_like_us_to_follow_up_with_you__c;
	  	acct.Partner_Best_Contact_Time__c=PRM.Partner_Best_Contact_Time__c;
	 	acct.Closest_Metro_Area__c=PRM.Closest_Metro_Area__c;
	  	acct.Certifications__c=PRM.Certifications__c;
	  	acct.Certifications_Other__c=PRM.Certifications_Other__c;
	  	if(acct.Name == null || acct.Name == '') {
	        acct.Name = 'No name from PRM';
	  	}
	  	acct.Contact_FName__c = PRM.Partner_First_Name__c;
	  	acct.Contact_LName__c = PRM.Partner_Last_Name__c;
	  	acct.Contact_Email__c = PRM.Partner_Email_Address__c;
	  	acct.Contact_Phone__c = PRM.Partner_Phone__c;
	  	acct.No_of_Employees__c = PRM.No_of_Employees__c;
	  	acct.Dist_Dealer__c =PRM.AFN__c;
		acct.Master_Distributor_Agent__c = 'Yes'.equalsIgnoreCase(PRM.AD__c) ?true:false;	  	          
	    acct.Company_size_typically_sell_to__c =PRM.Company_size_typically_sell_to__c;
	  	acct.Annual_Gross_Revenue__c = PRM.Annual_Gross_Revenue__c; 
	 	return acct;         
  	}
  	
  	/*******************************************************************
     * @Description.: Checking the duplicate account for the Reseller custom Object     
     * @updatedBy...: India team                                       *
     * @updateDate..: 27/05/2014                                       *                                     
     *******************************************************************/
    /*************************************************** ***************** *******************************************/
    
    public void  onCheckDuplicateAccount(List<Partner_Request__c> triggerNewListt){
    	List<Account> PRMAcct = new List<Account>();   
        Map<String, Account> mapPRMName = new Map<String, Account>(); 
        set<String> accname = new set<String>();    
        for(Partner_Request__c PRM1 : triggerNewListt){
        	accname.add(PRM1.Partner_Company_Name__c);
        }
        for(Account accObj : [SELECT  Id, Name FROM Account where (Account.Name IN: accname and Account.Name != '') and 
        					    Account.Type = 'Partner']) {
        	mapPRMName.put(accObj.Name,accObj);
        }								
        
        List<Messaging.SingleEmailMessage> mailLst = new List<Messaging.SingleEmailMessage>();
        for(Partner_Request__c prmObj : triggerNewListt) {  
        	if(mapPRMName != null && prmObj.Partner_Company_Name__c != null && mapPRMName.get(prmObj.Partner_Company_Name__c) != null) {
    			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
         	 	String[] toAddresses = new String[] {UserRC.rcsfSyncUserObj.Email__c}; //Need to replace when go LIVE --> rcsync
	         	mail.setToAddresses(toAddresses);
	         	String[] ccAddresses = new String[] {'bonniel@ringcentral.com','danielle.hopkins@ringcentral.com',
		         										'anne.malaluan@ringcentral.com'}; //bonniel@ringcentral.com 'rachel.mackie@ringcentral.com', 
			 	mail.setCcAddresses(ccAddresses);
			 	String[] bccAddresses = new String[] {'ankit.garg@simplion.com'};
			 	mail.setBccAddresses(bccAddresses);
        	 	mail.setSenderDisplayName('Partner Request Form');
        	 	mail.setSubject('Partner Request - Duplicate Record');
       		 	string body = 'Account with following company name is already with us  <br> <br>  \n\n' + 'Account with Company  Name: ' + '<a href= '+ URL.getSalesforceBaseUrl().toExternalForm()+'/'+mapPRMName.get(prmObj.Partner_Company_Name__c).Id+' target="_blank">'+mapPRMName.get(prmObj.Partner_Company_Name__c).Name +'</a>'  + '\n\n';	       		
   		     	body = body+'  <br> <br> Duplicate Reseller Request Name : '+' <a href= '+ URL.getSalesforceBaseUrl().toExternalForm()+'/'+prmObj.Id+' target="_blank">'+prmObj.Partner_First_Name__c +' ' +prmObj.Partner_Last_Name__c +'</a>';
   		     	mail.setHtmlBody(body);
   		     	mailLst.add(mail);
        	}
        }
        try {      		 
 			Messaging.sendEmail(mailLst);
     	} catch(Exception exp){} 
    }
}