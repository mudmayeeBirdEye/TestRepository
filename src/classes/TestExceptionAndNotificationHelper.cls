@istest
Private class TestExceptionAndNotificationHelper {
    static TestMethod void unitExceptionAndNotificationHelper() {
            try {
                String newList = null;
                Integer testCount = newList.length();
            } catch(Exception e) {
                Exception_And_Notification_History__c exceptionObj = new Exception_And_Notification_History__c();
                exceptionObj.recordTypeId = ExceptionAndNotificationHelper.getRcId(ExceptionAndNotificationHelper.EXCEPTION_RECORD_TYPE);
                exceptionObj.Object_Type__c = 'Exception';
                exceptionObj.content_label_01__c = 'File Associated';
                exceptionObj.content_label_02__c = 'Line Number';
                exceptionObj.content_label_03__c = 'Exception';
                exceptionObj.content_label_04__c = 'Get Stack Trace String';
                exceptionObj.content_label_05__c = 'Details';
                exceptionObj.content_var_01__c ='LeadUpdationFutureHandler';
                ExceptionAndNotificationHelper.trackExceptions(exceptionObj, e); 
            }
            try {
                Exception_And_Notification_History__c sendEmail = new Exception_And_Notification_History__c();
                sendEmail.recordTypeId = ExceptionAndNotificationHelper.getRcId(ExceptionAndNotificationHelper.NOTIFICATION_RECORD_TYPE);
                sendEmail.Email_Subject__c = 'Test Email';
                sendEmail.Object_Type__c = 'Lead';
                sendEmail.content_var_01__c ='Test Lead';
                sendEmail.content_label_01__c = 'Existing Lead Name';
                sendEmail.isEmailSent__c = true;
                sendEmail.To_Address_1__c = 'virendra.singh@simplion.com';
                ExceptionAndNotificationHelper.notificationPerWorkflow(sendEmail);
                List<Exception_And_Notification_History__c> sendEmails = new List<Exception_And_Notification_History__c>();
                sendEmails.add(sendEmail);
                ExceptionAndNotificationHelper.notificationPerWorkflow(sendEmails);
            } catch(Exception e) {}
    }
 }