public class NPSLandingController {
    public static final String SOURCE ='NPS Landing Controller';
        public List<Contact> lstContacts {get;set;}
        public String SurveyType{get;set;}
        public Boolean isError {get;set;}
        public Boolean isValid {get;set;}
        public string contactId {get;set;}
    public NPSLandingController(ApexPages.StandardController controller) {
       
        // This is an over-ride to enable what survey customer fills out
        SurveyType = apexpages.currentpage().getparameters().get('Survey');
        contactId = apexpages.currentpage().getparameters().get('conId');
        
    }
    
    public PageReference initCheck()
    {
        PageReference surveyPage;
        isError = false;
        isValid = true; 
          if(contactId != null)
                lstContacts = [Select Id, Name, Account.RC_Brand__c,AccountId,Account.Service_Type__c,Account.RC_Service_Name__c ,Account.Survey_Expiry_Date__c from Contact where id=:contactId Limit 1];
           else
            {
               isError = true;
               logException('No Contact Found','');
               return null;
            } 
           try 
           { 
            if(lstContacts.size()>0)
            {
                //   If Service_Type__c like ‘office’ OR ‘professional’
                // Then use Office/Pro survey URL
                //   If Service_Type__c like ‘fax’
                // Then use Fax survey URL
              if(lstContacts[0].Account.RC_Brand__c=='AT&T')
              {
                isValid = false;
                                logException( 'AT&T user attepmted survey ',lstContacts[0].Id);
                                return null;
              }
              else if(String.IsNotBlank(SurveyType))
              {
                // This is to OverRide the Product Type Checking Condition
                if(SurveyType=='Fax')
                        surveyPage = new PageReference('/apex/faxSurvey?conId='+lstContacts[0].Id); 
                else if(SurveyType=='OfficePro')
                        surveyPage = new PageReference('/apex/OfficeProSurvey?conId='+lstContacts[0].Id);
                else
                        {
                          isError = true;
                          logException( 'Could Not Identify Correct Survey Type '+SurveyType,lstContacts[0].Id);
                        } 
              } 
              else
              {
                 // If Survey Type Override is not Present then Normal Logic will run
                     if( (String.IsNotBlank(lstContacts[0].Account.RC_Service_Name__c) && lstContacts[0].Account.RC_Service_Name__c.containsIgnoreCase('fax'))|| 
                          (String.IsNotBlank(lstContacts[0].Account.Service_Type__c) && lstContacts[0].Account.Service_Type__c.containsIgnoreCase('fax'))
                   )
                     {
                        surveyPage = new PageReference('/apex/faxSurvey?conId='+lstContacts[0].Id); 
                     }
                     else if(((String.IsNotBlank(lstContacts[0].Account.RC_Service_Name__c) &&( ( lstContacts[0].Account.RC_Service_Name__c.containsIgnoreCase('office')) || (lstContacts[0].Account.RC_Service_Name__c.containsIgnoreCase('professional'))))
                                || ((String.IsNotBlank(lstContacts[0].Account.Service_Type__c) && ((lstContacts[0].Account.Service_Type__c.containsIgnoreCase('office')) ||  lstContacts[0].Account.Service_Type__c.containsIgnoreCase('professional')))))
                             )
                     {
                      
                      surveyPage = new PageReference('/apex/OfficeProSurvey?conId='+lstContacts[0].Id); 
                     }
                     else 
                     {
                       isError = true;
                       logException( 'Could Not Identify Correct Survey Type',lstContacts[0].Id);
                     }
              }
             surveyPage.setRedirect(true);
            }
            else
            {
               isError = true;
               logException('No Contact Found','');
            }
           }
           catch(exception ex)
          {
                isError = true;
                logException(ex);
          }
         
         if(!isError )
           return surveyPage;
         else
         {
                logException('Unknown Error Occurred','');
                return null;
         }
    }
    
    // Private Helper methods
        private void logException(string ErrorMessage,string recordId)
        {
                 
                 Exception_And_Notification_History__c exceptionRecordObj = new Exception_And_Notification_History__c();
                 
                 exceptionRecordObj.content_var_02__c = SOURCE;
                 exceptionRecordObj.content_var_03__c = ErrorMessage;
                 
                 exceptionRecordObj.Record_Id__c = String.IsNotBlank(recordId)? recordId : '';  
               //  ExceptionAndNotificationHelper.trackBusinessExceptions(exceptionRecordObj);
                
        
        }
        
        private void logException (Exception ex)
        {
                 Exception_And_Notification_History__c exceptionRecordObj = new Exception_And_Notification_History__c();
                 exceptionRecordObj.content_label_06__c='Source';
                 exceptionRecordObj.content_var_06__c = SOURCE;          
                // ExceptionAndNotificationHelper.trackExceptions(exceptionRecordObj,ex);
        }

}