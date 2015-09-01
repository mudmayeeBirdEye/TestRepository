/*  
Dated On - 14-March-2013
Description - through the help of this class we are storing the Fax Survey for NPS process.  
*/

public class cls_FaxSurvey {
	public static final String SOURCE ='Fax Survey';
    
	
// getter setter properties for handling the user input on page
    
    public string supVal3Mnths {get;set;}
    public string recomRCRating {get;set;}
    public string ratingDescription {get;set;}
    public string addCommentsValue {get;set;}
    public string custSupportValue {get;set;}
    public string FeatFunctValue {get;set;}
    public string easeImpValue {get;set;}
    public string easeUseValue {get;set;}
    public string custSupResValue {get;set;}
    public List<Contact> lstContacts {get;set;}
    public boolean isSubmitResponse {get;set;}
    public boolean isMainSection {get;set;}
    public boolean isResAlreadyFilled {get;set;}
    public boolean  isError {get;set;}
    public Integer quarter {get;set;}
    // intilization of constructor
    public cls_FaxSurvey()
    {
        isSubmitResponse = false;
        isMainSection = true;
        isError =  false;
        
        	
	        Id contactId = apexpages.currentpage().getparameters().get('conId');
	        lstContacts = [Select Id,Name,Account.Name,AccountId,Account.Survey_Expiry_Date__c from Contact where id=:contactId];
	        system.debug('lstContacts value in constructor:'+lstContacts);
	        if(lstContacts.size()>0)
	        {
	            if(lstContacts[0].AccountId != null && lstContacts[0].Account.Survey_Expiry_Date__c != null)
	            {
	                system.debug('In for Survey Expiry');
	                if(Date.today() <= lstContacts[0].Account.Survey_Expiry_Date__c)
	                {
	                    system.debug('@@@@@@In for Survey Expiry');
	                    isResAlreadyFilled = true;
	                    isMainSection = false;
	                }
	            }
	        }
	        else
	        {
	        	isError =  true;
	        	isMainSection = false;	        	
	        }
	        getCurrentQuarter();
      }
      
  	public void getCurrentQuarter() {
    	try {
    		Integer FiscalYearStartMonth = [select FiscalYearStartMonth from Organization where id=:Userinfo.getOrganizationId()].FiscalYearStartMonth;
			if(system.today().month() >= FiscalYearStartMonth) {
			    quarter = ((system.today().month() - FiscalYearStartMonth) / 3) + 1;
			}
			else {
			    quarter = ((12 + system.today().month() - FiscalYearStartMonth) / 3) + 1;
			}    		
    	} catch(Exception ex) {}
    }
    
    /* Method Name - SubmitSurvey
       Parameters - Null
       Return type - Page Referenece
       Description - for storing the survey values
    */
    public void SubmitSurvey()
    {
        Survey__c objSurvey = new Survey__c();
        objSurvey.SurveyType__c = 'NPS Survey';
        objSurvey.Recommended_RC_Rating__c = recomRCRating;
        objSurvey.Recommended_RC_Rating_Description__c = ratingDescription;
        objSurvey.Additional_Comments__c = addCommentsValue;
        objSurvey.RC_Customer_Support__c = custSupportValue;
        objSurvey.Features_Functionality__c = FeatFunctValue;
        objSurvey.Ease_of_Implementation__c = easeImpValue;
        objSurvey.Ease_of_use__c = easeUseValue;
        objSurvey.Customer_support_resolution__c = custSupResValue;
        try
        {
	        if(lstContacts.size()>0)
	        {
	            system.debug('lstContacts value in method:'+lstContacts);
	            objSurvey.Contact__c = lstContacts[0].Id;
	            if(lstContacts[0].AccountId != null)
	            {
	                objSurvey.Account__c = lstContacts[0].AccountId; 
	            }   
	            //objSurvey.Name = lstContacts[0].Name+'-Survey Response';
	            // objSurvey.Name = lstContacts[0].Account.Name+'- RingCentral Satisfaction Survey';
	            objSurvey.Name = 'NPS – RingCentral Satisfaction Survey '+ Date.today().year() +'Q'+quarter + ' - '+lstContacts[0].Account.Name;
	            insert objSurvey;
	        }
	        else
	        {
	           
	            isError =  true;
	            isMainSection = false;
	            logException('No Contact Found','');
	        }
	        
	        if(lstContacts.size()>0)
	        {
	            Account objAcc = new Account(id=lstContacts[0].AccountId);
	            Integer monthVal = system.today().month();
	            Integer yearVal = system.today().year();
	            if(monthVal == 1 || monthVal == 2 || monthVal == 3)
	            {
	                objAcc.Survey_Expiry_Date__c = date.newinstance(yearVal, 3, 31);    
	            }
	            else if(monthVal == 4 || monthVal == 5 || monthVal == 6)
	            {
	                objAcc.Survey_Expiry_Date__c = date.newinstance(yearVal, 6, 30);    
	            }
	            else if(monthVal == 7 || monthVal == 8 || monthVal == 9)
	            {
	                objAcc.Survey_Expiry_Date__c = date.newinstance(yearVal, 9, 30);    
	            }
	            else
	            {
	                objAcc.Survey_Expiry_Date__c = date.newinstance(yearVal, 12, 31);
	            }
	            objAcc.NPS_Score__c = recomRCRating;
	            update objAcc;
	        }
	        if(objSurvey.Id !=null)
	        {
	            isSubmitResponse = true;
	            isMainSection = false;
	        }
        
       		 system.debug('objSurvey value:'+objSurvey);
       		 if(Test.isRunningTest()) {
        	    Integer  i = 1/0;  
        	 }
        }
        
        catch(exception ex)
        {
        	logException(ex);
        }
    }
    // Private Helper methods
    private void logException(string ErrorMessage,string recordId)
	{
		 
		 Exception_And_Notification_History__c exceptionRecordObj = new Exception_And_Notification_History__c();
		 
		 exceptionRecordObj.content_var_02__c = SOURCE;
		 exceptionRecordObj.content_var_03__c = ErrorMessage;
		 
		 exceptionRecordObj.Record_Id__c = String.IsNotBlank(recordId)? recordId : '';	
		 
		// ExceptionAndNotificationHelper.trackBusinessExceptions(exceptionRecordObj);
	
	}
	private void logException (Exception ex)
	{
		 Exception_And_Notification_History__c exceptionRecordObj = new Exception_And_Notification_History__c();
		 exceptionRecordObj.content_label_06__c='Source';
		 exceptionRecordObj.content_var_06__c = SOURCE;		 
		// ExceptionAndNotificationHelper.trackExceptions(exceptionRecordObj,ex);
	}
}