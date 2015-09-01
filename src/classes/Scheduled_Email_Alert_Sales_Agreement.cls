/*
	*This is a schedulaed Class which run every day to calculate the expried and renewable sales agreement.
	*Quote object refers here as sales agreement object.
*/

global class Scheduled_Email_Alert_Sales_Agreement implements Schedulable {
   private class SalesAgreementException extends Exception {}
   Quote quote_obj = null;
   List<Account> acc_sales_agreements_obj = null;
   Set<String> toEmailAddress = new Set<String>();  // Collection of ids for Users's email
   List<Exception_And_Notification_History__c> emailNotifictionList = new  List<Exception_And_Notification_History__c>();  
   List<Quote> salesAgreementLists;
   List<Quote>  Quote_list = new  List<Quote>();
   Map<id, String> userMap=null;
   Map<Id,ID> mapUserManger=null;
   Map<Id,String> mapManagerEmail=null;
   String INACTIVE = 'Inactive'; 
       
   global void execute(SchedulableContext ctx) {
            try{
            	 Quote_list = new  List<Quote>();
            	 emailNotifictionList = new  List<Exception_And_Notification_History__c>();  
   				 loadAllSaleAgreements();			
		   		 prepareListOfSalesAgreementsForSendAnEmail();		
	             updateAll();
             
            }catch(Exception e){}
        }
        
/*
	* load all agremments shich come under Expire/renew.
*/
    public void loadAllSaleAgreements(){
	    salesAgreementLists = new List<Quote>();
	    if(test.isRunningTest()){
	    	 salesAgreementLists =[SELECT CreatedByID,Name, Email, Term_months__c, Opportunity.OwnerId, Opportunity.Account.Current_Owner__c, Status, Account__r.name, 
			             			Start_Date__c, End_Date__c, Auto_Renewal__c FROM Quote WHERE status='Active' AND End_Date__c < TODAY
			             			 Limit 1];
	    }else{
	         salesAgreementLists =[SELECT CreatedByID,Name, Email, Term_months__c, Opportunity.OwnerId, Opportunity.Account.Current_Owner__c, Status, Account__r.name, 
	             				    Start_Date__c, End_Date__c, Auto_Renewal__c FROM Quote WHERE status='Active' AND End_Date__c < TODAY
	             				    Limit : Limits.getLimitDMLRows()];
	      }  				
	     System.debug('Total records----------------> :'+salesAgreementLists.size());         					
    }
    /*
    	*Process all SalesAgreements
    	*Update records if auto renew able true. e.g. End date + Term Months
    	*Update records if auto renewable false. e.g.  Status = inactive
    */
    
    public void prepareListOfSalesAgreementsForSendAnEmail(){
    	prepareUserMap();
    	
    	 for(Quote  quote_obj : salesAgreementLists ) {
           toEmailAddress.clear();	
           System.debug('## '+quote_obj.End_Date__c + ' ## '+ System.today() +'--------------->'+ (quote_obj.End_Date__c == System.today()));
               ID emailID = null;
          
                if(quote_obj.Opportunity.Account.Current_Owner__c != NULL){
                	emailID = quote_obj.Opportunity.Account.Current_Owner__c; 
                } else if( quote_obj.Opportunity.Account.Current_Owner__c == NULL){
                   	emailID = quote_obj.Opportunity.OwnerId;
                }
                 // Auto Renewal Logic
                // Case 1: Auto Renewal Is True
                // a. Term is zero --> Make the Quote Inactive
                // b. if the Renewal Term is 1,3,14 i.e random , continue to add term
                // Case 2: Auto Renewal Is False 
                // a. Quote is set to Inactive 
                 if( quote_obj.Auto_Renewal__c == true ) {
                 	
                 	     Integer QuoteTerms= quote_obj.Term_months__c!=null ? Integer.valueOf(quote_obj.Term_months__c) : 0;
                 		 quote_obj.End_Date__c = quote_obj.End_Date__c.addMonths(QuoteTerms);
                 		 
                 		 if(QuoteTerms== 0 )
                 		  quote_obj.status = INACTIVE; 
                 		  
                 		  toEmailAddress.add(userMap.get(emailID));
                       	 
                       	 String managerId=mapUserManger.get(emailID);
                         String strManagerEmail=mapManagerEmail.get(managerId);
                         if(strManagerEmail!=null){
                           toEmailAddress.add(strManagerEmail);
                         }
                         
                         Quote_list.add(quote_obj);
                         emailNotifictionList.add(createENobjectsAndSendAnEmail( setEmail(toEmailAddress), quote_obj.Auto_Renewal__c, quote_obj));
                   }
                 if( quote_obj.Auto_Renewal__c == false) {
                         quote_obj.status = INACTIVE;
                         
                         toEmailAddress.add(userMap.get(emailID));
                       	 String managerId=mapUserManger.get(emailID);
                         String strManagerEmail=mapManagerEmail.get(managerId);
                         if(strManagerEmail!=null){
                           toEmailAddress.add(strManagerEmail);
                         }
                         
                         Quote_list.add(quote_obj);
                         emailNotifictionList.add(createENobjectsAndSendAnEmail(setEmail(toEmailAddress), quote_obj.Auto_Renewal__c, quote_obj));
                   }
            } 
    }
   public void prepareUserMap(){
   	   Set<Id> setCurrentOwnerOrOwnerId=new Set<Id>();
   	   mapUserManger=new Map<Id,ID>();
       mapManagerEmail=new Map<Id,String>();	 
       userMap=new  Map<id, String>();
       
       for(Quote  quote_obj : salesAgreementLists) {
    	 	ID userID=null;
    	 	 if(quote_obj.Opportunity.Account.Current_Owner__c != NULL){
                	userID = quote_obj.Opportunity.Account.Current_Owner__c; 
                } else if( quote_obj.Opportunity.Account.Current_Owner__c == NULL){
                   	userID = quote_obj.Opportunity.OwnerId;
                }
    	 	setCurrentOwnerOrOwnerId.add(userID);
    	 }
       for(User objUser:[Select email from User where ID IN:setCurrentOwnerOrOwnerId]){
       	  userMap.put(objUser.id,objUser.email);
       }	 
    	 
   	  for( Employee__c objEmployee : [Select Manager_Employee_Number__r.User__r.email,Manager_Employee_Number__r.User__c,Manager_Employee_Number__c,
   	  									User__c From Employee__c WHERE 	User__c IN: setCurrentOwnerOrOwnerId] ) {
  		    if( objEmployee != null && objEmployee.Manager_Employee_Number__r.User__c != null){
   				mapUserManger.put(objEmployee.User__c,objEmployee.Manager_Employee_Number__r.User__c);
   				mapManagerEmail.put(objEmployee.Manager_Employee_Number__r.User__c,objEmployee.Manager_Employee_Number__r.User__r.email);
   		    }
   	
   }  
   }       
    
        
    /*
    	*@param empid is Employee Id to fetch Employee's Manager
    */
   /* public ID getManagerEmail(ID empid){
     try{
	      if( Limits.getLimitQueries() == Limits.getQueries() ){
	      	throw new SalesAgreementException();
	      } else {
	      		 for( Employee__c employee : [Select 
         									Manager_Employee_Number__r.User__c, 
         									Manager_Employee_Number__c 
         								From 
         									Employee__c 
         								WHERE 
            						   		User__c =: empid] ) {
          		  if( employee != null && employee.Manager_Employee_Number__r.User__c != null){
           				return employee.Manager_Employee_Number__r.User__c;
           		 }
         	 }  
	      }	
	     } catch(Exception ex){
	    	return null; 		
     	}
        return null;
    }
    */
/*
	*@param ids is id of Users to fetch out emails
*/
   
    public String[] setEmail(Set<String> emailIds){
   	try {	
   		List<String> emails = new List<String>();
       /* if( Limits.getLimitQueries() == Limits.getQueries() ){
	      	throw new SalesAgreementException();
        }else{	
          List<User> uEmail = [Select email from User where Id IN: ids ];
          String[] emails = new String[ids.size()];
          Integer i = 0;
            
          for(User usr : uEmail ){
              emails[i] = usr.email;
              i++; 
          }
        return emails;
        } */
        for(String objEmail:emailIds){
        	if(objEmail!=null){
        	  emails.add(objEmail);
        	} 
        }
        if(emails.size()>0){
        	return emails;
        }
          
	 }catch(Exception e){
	 	return null;
	 }  
	return null; 
   }
          
          
/*
	* Create Exception_And_Notification_History__c objects for sending email notificatios via WF.
	* @param emails address whom which we are going to send an email.
	* @param selfRenew  records are going to renew itself.
	* @param salesAgreement Object used the values for bind some value on email templates.    
*/
    
    public Exception_And_Notification_History__c createENobjectsAndSendAnEmail( String[] emails, Boolean selfRenew , Quote salesAgree ){
   		
   		Exception_And_Notification_History__c ENHobject = new Exception_And_Notification_History__c();
   		ENHobject.Object_Type__c = 'Quote';
   		ENHobject.content_label_01__c = salesAgree.Account__r.Name;
   		ENHobject.content_label_02__c = salesAgree.Name;
   		ENHobject.content_label_03__c = salesAgree.Id;
   		ENHobject.content_label_04__c = String.valueOf( selfRenew );
   		
   		/*Assuming the maximum emails addresses should be five*/
   		for(Integer i = 0 ; i < emails.size() ; i++ ){
	   			if( i == 0 ) {
	   				ENHobject.To_Address_1__c = emails[i];
	   			}
	   			else if( i == 1 ) {
	   				ENHobject.To_Address_2__c = emails[i];
	   			}
	   			else if( i == 2 ) {
	   				ENHobject.To_Address_3__c = emails[i];
	   			}
	   			else if( i == 3 ) {
	   				ENHobject.To_Address_4__c = emails[i];
	   			}
	   			else if( i == 4 ) {
	   				ENHobject.To_Address_5__c = emails[i];
	   			}
   		}
   		return ENHobject;
   }
   
/*
	*Update All Sales Agreements[Quote]
	*Insert ENH [Exception_And_Notification_History__c] Lists for sending Email, via workflow. 
*/
    
    public void updateAll(){
    	update Quote_list;
        insert emailNotifictionList;
       
    }   
}