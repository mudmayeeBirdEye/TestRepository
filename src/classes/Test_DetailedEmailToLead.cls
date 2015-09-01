/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 */
@isTest
private class Test_DetailedEmailToLead {

    static testMethod void TestDetailedEmailToLead() {
        
		DetailedEmailToLead detl = new DetailedEmailToLead();
		Messaging.InboundEmail email = new Messaging.InboundEmail();
		Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
		Messaging.InboundEmail.BinaryAttachment inAtt = new Messaging.InboundEmail.BinaryAttachment();
		Messaging.InboundEmail.TextAttachment inAttText = new Messaging.InboundEmail.TextAttachment();
		email.subject = 'test';
		env.fromAddress = 'user@acme.com';
		inAtt.body = blob.valueOf('"57580213","INIT","Monik","Wagner","monik Wagner","","","","","","5627081661","Monik@vanlinemovers.com","7076231756","INITIAL","Professional","RingCentral","","testpid","Pacific Standard Time","","","","","","",""*EOL*');
		inAtt.fileName = 'attach.csv';
		inAttText.fileName = 'attach.csv';
		email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] {inAtt }; 
		detl.handleInboundEmail(email, env );  		
	
    }
    static testMethod void Test_EmployeeCustomLookupCtrl() {
 		Employee__c emp = new Employee__c();
        emp.First_Name__c = 'tuser';
        emp.Last_Name__c = 'lname';
        emp.Email__c ='clc@clc.com';
        emp.Location__c = 'Noida, India';
        emp.Department__c = 'IT';
        emp.Team__c = 'SE';
        emp.SPID__c = '12454';
        insert emp;
        
        PageReference pageRef = Page.CustomEmployeeLookup;   
 		Test.setCurrentPageReference(pageRef);
    	Apexpages.currentPage().getParameters().put('lksrch', 'tuser');
    	
    	EmployeeCustomLookupCtrl eclc = new EmployeeCustomLookupCtrl();
    	eclc.search();
    	eclc.getFormTag();
    	eclc.getTextBox(); 
    }
}