/*
NO LONGER USED. CAN BE REMOVED
*/

global class DetailedEmailToLead implements Messaging.InboundEmailHandler {

	global Messaging.InboundEmailResult handleInboundEmail(Messaging.inboundEmail email, Messaging.InboundEnvelope envelope){
	
	// Create an inboundEmailResult object for returning 
	// the result of the Force.com Email Service
	    Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
	
	
	    return result;
	}
	
	/*static testMethod void testDetailedEmailToLead() {
		DetailedEmailToLead detl = new DetailedEmailToLead();
		
		
		// Create a new email, envelope object and Attachment
		Messaging.InboundEmail email = new Messaging.InboundEmail();
		Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
		Messaging.InboundEmail.BinaryAttachment inAtt = new Messaging.InboundEmail.BinaryAttachment();
		Messaging.InboundEmail.TextAttachment inAttText = new Messaging.InboundEmail.TextAttachment();
		
		email.subject = 'test';
		env.fromAddress = 'user@acme.com';
		
		// set the body of the attachment
		inAtt.body = blob.valueOf('"57580213","INIT","Monik","Wagner","monik Wagner","","","","","","5627081661","Monik@vanlinemovers.com","7076231756","INITIAL","Professional","RingCentral","","testpid","Pacific Standard Time","","","","","","",""*EOL*');
		inAtt.fileName = 'attach.csv';
		inAttText.fileName = 'attach.csv';
		// inAtt.mimeTypeSubType = 'plain/txt';
		
		email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] {inAtt }; 
		
		detl.handleInboundEmail(email, env );  		
	}*/
	
}