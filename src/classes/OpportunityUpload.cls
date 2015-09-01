/*************************************************
OpportunityUpload class
OpportunityUpload was made to take a list of RC User Ids and create opportunties directly into their Account.
This was so we could create Farming Opportunities without having to create lead's first.
Most of the class is commented out because it is not used and so it would not count as lines of code in production.
THIS CLASS IS NO LONGER USED AND CAN BE REMOVED. 
/************************************************/

global class OpportunityUpload implements Messaging.InboundEmailHandler {
//global class MasterLeadUpload 

	global Messaging.InboundEmailResult handleInboundEmail(Messaging.inboundEmail email, Messaging.InboundEnvelope envelope){
	
	// Create an inboundEmailResult object for returning 
	// the result of the Force.com Email Service
	    Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
	
	    Messaging.InboundEmail.TextAttachment[] tAttachments = email.textAttachments;
	    Messaging.InboundEmail.BinaryAttachment[] bAttachments = email.BinaryAttachments;
	    
	    //leadInsert li = new leadInsert();
	    
	    String csvbody='';
	    
	    List<string> csvList=new List<string>();
	    Integer size;
	    Integer i;
	    Integer k;
	    Integer z;
	    List<string> currentrow = new List<string>();
	            
	    Integer j=0;
	    Integer userID=0;
	    
	    String temp='';
	    String temp1='';
	    String company='';
	    String line='';
	    Boolean done=false;
	    
	    Opportunity o;
	    Contract c;
	           
	   // List<Opportunity> newOpps = new List<Opportunity>();
	   // List<OpportunityContactRole> newOcrs = new List<OpportunityContactRole>();
	    
	//    	Map<String, Opportunity> opMap = new Map<String, Opportunity>();
	    
	//   	Integer heapsize=Limits.getHeapSize();
	//	System.debug('Variable heapsize1 = ' + heapsize);
		
		if(bAttachments !=null){
	        for(Messaging.InboundEmail.BinaryAttachment btt : bAttachments){
	        	System.debug('this looks like a binary attachment');
	            if(btt.filename.endsWith('.csv')){            	              
	                csvbody = btt.body.toString();
	            }
	        }
		}
		else                      
	    if(tAttachments !=null){
	    	for(Messaging.InboundEmail.TextAttachment ttt : tAttachments){
	        	System.debug('this looks like a text attachment');
	            if(ttt.filename.endsWith('.csv')){
	            	
	                
	                csvbody = ttt.body;
	                
	            }
	    	}
	    }
	
	    i=0;
	    k=0;
	    z=0;
	    	//for (Lead lead : [SELECT Email,OwnerId FROM Lead WHERE Email IN :leadMap.KeySet()]) {
		/*while(!done){         	
							
			k=csvbody.indexOf('*EOL*', i);
			line=csvbody.substring(i,k);
			system.debug('this is line: ' + line);
			userID = Integer.valueOf(line);
			system.debug('this is userID' + userID);
			// process line 
	    	o = new Opportunity();
	    	//c = [SELECT Id,AccountId,RC_Primary_number__c,RC_Brand__c,RC_Tier__c,RC_User_ID__c FROM Contract WHERE RC_User_ID__c =: userID];
	 //system.debug('this is contact id' + c.Id);
	    	o.Name = 'Mobile Farming';
	    	//o.AccountId = c.AccountId;
	    	o.CloseDate = Date.today();
	    	//o.RC_Account_Number__c = c.RC_Primary_number__c;
	    	o.RC_User_ID__c = line;
	    	o.Brand_Name__c = c.RC_Brand__c;
	    	o.Tier_Name__c = c.RC_Tier__c;
	    	o.Type = 'Existing Business';
	    	o.Description = 'Opportunity created for Mobile farming. This customer has been identified as Mobile Professional or Plus account with 1 digital line.';
	    	//o.OwnerId = '005800000037OaK';
	    	system.debug('this is the mod number: ' + Math.mod(z, 2));
	    	if(Math.mod(z, 3) == 0){
	    		o.OwnerId = '0058000000379ZV';	//Izzah DeLa Cruz
	    	}
	    	else if(Math.mod(z, 3) == 1){
	    		o.OwnerId = '00580000001hRXk';	//may ramos
	    	}
	    	else if(Math.mod(z, 3) == 2){
	    		o.OwnerId = '0058000000383l8';	// girlie
	    	}
	
	
	    	
	    	o.StageName = 'Open';
	    	insert o;
	    	system.debug('new op id' + o.Id);
	    	
	    	
	    	for(ContractContactRole ccr : [SELECT id,ContactId FROM ContractContactRole WHERE ContractId =: c.Id]){
		       	OpportunityContactRole ocr = new OpportunityContactRole();
		    	ocr.ContactId = ccr.ContactId;
		    	ocr.OpportunityId = o.Id;
		    	ocr.Role = 'RC Primary Contact';
		    	insert ocr;
		    			system.debug('new ocr' + ocr.Id);
	    	}
	
	
	        //newOpps.add(o);	   
	        //newOcrs.add(ocr);             
	        
	        // end process of line 
	
			if(k==csvbody.lastIndexOf('*EOL*')){
				done=true;
			}
			else{
				
				i=k+7;
			}
			z++;
			
		}
	*/
	
	
	//	insert newOpps;
	//	insert newOcrs;
	
	    
	    return result;
	}

  /*  static testMethod void myUnitTest() {
        // TO DO: implement unit test
        OpportunityUpload emailServiceObj = new OpportunityUpload();
    	// Create a new email, envelope object and Attachment
		Messaging.InboundEmail email = new Messaging.InboundEmail();
		Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
		Messaging.InboundEmail.Textattachment inAtt = new Messaging.InboundEmail.Textattachment();
		Messaging.InboundEmail.Binaryattachment inBtt = new Messaging.InboundEmail.Binaryattachment();
		
	   	email.subject = 'test';
		env.fromAddress = 'user@acme.com';
	
		email.binaryAttachments = new Messaging.inboundEmail.Binaryattachment[] {inBtt }; 
	   
	   	///////////////////////////// binary tests
	   
	   	inBtt.body = blob.valueOf('*EOL*');
	   	inBtt.fileName = 'attach.csv';
	   	//inBtt.mimeTypeSubType = 'plain/txt';
		
	   
	   	inBtt.body = blob.valueOf('999*EOL*');
		email.binaryAttachments = new Messaging.inboundEmail.Binaryattachment[] {inBtt };
		emailServiceObj.handleInboundEmail(email, env );	   
	}	*/
	
}