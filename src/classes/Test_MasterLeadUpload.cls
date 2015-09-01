@isTest
private class Test_MasterLeadUpload {
	@isTest(seealldata = true)
    static  void TestMasterLeadUpload() {
    	Messaging.InboundEmail email = new Messaging.InboundEmail();
   		Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
   		Messaging.InboundEmail.BinaryAttachment inAtt = new Messaging.InboundEmail.BinaryAttachment();

   		email.subject = 'test';
   		env.fromAddress = 'user@acme.com';
		
		list<document> listdoc = [SELECT id,Name,Body FROM Document WHERE Name='TestLeadCSV' limit 1];
		
		inAtt.body = listdoc[0].body;
		inAtt.fileName = 'TestLeadCSV.csv';
		
   		email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] {inAtt }; 
   		
        MasterLeadUpload objMasLeadUpd = new MasterLeadUpload();
        objMasLeadUpd.handleInboundEmail(email, env);
    }
}