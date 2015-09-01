public class MailHelper {
    public void createMail(String textBody, String htmlBody, String targetObjectId, String replyTo,
                            Boolean activity, String displayName, String subject) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        // targetObjectId = '005T0000001CBAl';//  [india team id, for development]
        // targetObjectId  = '00580000003SZmNAAW'; // [testing env]
        try {
        	if(targetObjectId !=null)
	        	mail.setTargetObjectId(targetObjectId);
	        mail.setSaveAsActivity(activity);
	        mail.setSenderDisplayName(displayName); 
	        mail.setsubject(subject);
	        if(textbody != null)
	            mail.setPlainTextBody(textbody);
	        if(htmlBody != null)
	            mail.setHtmlBody(htmlBody);
	        
	        if(replyTo != null && replyTo != '')
	            mail.setReplyTo(replyTo);
	            
	        /*
	        	String[] toBCCAddresses = new String[] {'virendra.singh@simplion.com','garima.karnwal@simplion.com'};
	        	mail.setBccAddresses(toBCCAddresses);
        	*/
	        
	        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        } catch(Exception e) {}
    }
     public void createMail(String textBody, String htmlBody, String targetObjectId, String replyTo,
                            Boolean activity, String displayName, String subject, String[] toAddresses, String[] ccAddress, String[] bccAddress) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        try {
        	if(targetObjectId !=null)
	        	mail.setTargetObjectId(targetObjectId);
	        mail.setSaveAsActivity(activity);
	        mail.setSenderDisplayName(displayName);
	        mail.setsubject(subject);
	        if(textbody != null)
	            mail.setPlainTextBody(textbody);
	        if(htmlBody != null)
	            mail.setHtmlBody(htmlBody);
	        
	        if(!String.isBlank(replyTo))
	            mail.setReplyTo(replyTo);
	        if(toAddresses != null && toAddresses.size() != 0) {    
	        	mail.setToAddresses(toAddresses);
	        }
	        if(ccAddress != null && ccAddress.size() != 0) {    
	        	mail.setCcAddresses(ccAddress);
	        }
	        /*if(bccAddress != null && bccAddress.size() != 0) {    
	        	mail.setBccAddresses(bccAddress);
	        }
	        */
	        	//String[] toBCCAddresses = new String[] {'virendra.singh@simplion.com','garima.karnwal@simplion.com'};
	        	//mail.setBccAddresses(toBCCAddresses);
        	//System.debug('################ COMING HERE ###############');
	        
	        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        } catch(Exception e) {}
    }
    
    public void createMail(String textBody, String htmlBody, String targetObjectId, String replyTo,
                            Boolean activity, String displayName, String subject, String toAddress) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        // targetObjectId = '005T0000001CBAl';//  [india team id, for development]
        // targetObjectId  = '00580000003SZmNAAW'; // [testing env]
        try {
        	if(targetObjectId !=null)
	        	mail.setTargetObjectId(targetObjectId);
	        mail.setSaveAsActivity(activity);
	        mail.setSenderDisplayName(displayName);
	        mail.setsubject(subject);
	        if(textbody != null)
	            mail.setPlainTextBody(textbody);
	        if(htmlBody != null)
	            mail.setHtmlBody(htmlBody);
	        
	        if(replyTo != null && replyTo != '')
	            mail.setReplyTo(replyTo);
	        if(toAddress != null) {  
	        	String[] toAddresses = new String[] {toAddress}; 
	        	mail.setToAddresses(toAddresses);
	        } 
	        /*
		        String[] toBCCAddresses = new String[] {'virendra.singh@simplion.com','garima.karnwal@simplion.com'};
		        mail.setBccAddresses(toBCCAddresses);
	        */
	        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        } catch(Exception e) {}
    }
    /*public void sendMail(string email,string subject,string description) {
    	try {
	    	 Exception_And_Notification_History__c sendEmail = new Exception_And_Notification_History__c();
		     sendEmail.recordTypeId = ExceptionAndNotificationHelper.getRcId(ExceptionAndNotificationHelper.NOTIFICATION_RECORD_TYPE);
		     sendEmail.Email_Subject__c = subject;
		     sendEmail.Object_Type__c = 'Case';
		     sendEmail.content_var_01__c ='Case';
		     sendEmail.content_label_01__c = 'Case';
		     sendEmail.isEmailSent__c = true;
		     sendEmail.To_Address_1__c = email;
		     ExceptionAndNotificationHelper.notificationPerWorkflow(sendEmail);
    	} catch (Exception ex) { }
    }*/
    
   /*public static TestMethod void test() {
        new MailHelper().createMail(null, 'This is test email. Please ignore', '00580000003SZmNAAW',''
        , false, 'Test Email','Test Email');
    }
    
    /*public static TestMethod void test1() {
        new MailHelper().sendMail('virendra.singh@simplion.com','Test Mail','Test Mail');
    }*/
    
    /*public static TestMethod void test2() {
        new MailHelper().createMail(null, 'This is test email. Please ignore', null,''
        , false, 'Test Email','Test Email','virendra.singh@simplion.com');
    }
    public static TestMethod void test3() {
        new MailHelper().createMail(null, 'This is test email. Please ignore', null,''
        , false, 'Test Email','Test Email',new String[]{'virendra.singh@simplion.com'}, new String[]{'virendra.singh@simplion.com'}, new String[]{'virendra.singh@simplion.com'});
    }
    public static TestMethod void test4() {
        new MailHelper().createMail(null, 'This is test email. Please ignore', null,''
        , false, 'Test Email','Test Email',null, null, null);
    }*/
}