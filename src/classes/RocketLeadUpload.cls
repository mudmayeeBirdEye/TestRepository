global class RocketLeadUpload implements Messaging.InboundEmailHandler {
	
	global Messaging.InboundEmailResult handleInboundEmail(Messaging.inboundEmail email, Messaging.InboundEnvelope envelope){
	
	// Create an inboundEmailResult object for returning 
	// the result of the Force.com Email Service
	    Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
		
		// If csv file is coming from DWH then it will be Binary. If edited by hand it will be a textAttachment so we need to consider both
	    Messaging.InboundEmail.TextAttachment[] tAttachments = email.textAttachments;
	    Messaging.InboundEmail.BinaryAttachment[] bAttachments = email.BinaryAttachments;
	
	    String csvbody='';
	    
	    String comma=',';
		List<string> csvList=new List<string>();    
	    List<string> currentrow=new List<string>();
	    Integer size;
	    Integer i=0;
	    Lead l;
	    
	    String lname;
	    String fname;
	    String vpOrder;
	    String street;
	    String street2;
	    String city;
	    String state;
	    String zip;
	    String country;
	    String phone1;
	    String phone2;
	    String contactEmail;
	    String source;
	    String Company;
	    String leadDesc;
	    String empCount;
	    
	    //String company;
	    Integer numberOfUKAgents = 1;
	    Integer numberOfPartnerAgents = 5;
	    Integer j=0;
	    String line='';
	    Boolean done=false;
	    
	    list<Lead> vpLeads = new List<Lead>();
	    Integer k=0;

		if(bAttachments !=null){
	        for(Messaging.InboundEmail.BinaryAttachment btt : bAttachments){
	        	System.debug('this looks like a binary attachment');
	            if(btt.filename.endsWith('.csv')){            	              
	                csvbody = btt.body.toString();
	                System.debug('this csvbody' + csvbody);
	            }
	        }
		}
		else                      
	    if(tAttachments !=null){
	    	for(Messaging.InboundEmail.TextAttachment ttt : tAttachments){
	        	System.debug('this looks like a text attachment');
	            if(ttt.filename.endsWith('.csv')){            	
	            	//heapsize=Limits.getHeapSize();
	            	//System.debug('Variable heapsize2 = ' + heapsize);                
	                csvbody = ttt.body;
	            }
	    	}
	    }	    
		
		/*
		Parse through csv string using comma as column deliminator and *EOL* and row deliminator.
		Try to clean up lead if column blanks are found. 
		For each line create a new lead and add it to list so all of them can be added at once at end.
		Assign correct SFDC campaign based on the keyword sent with each lead and country of customer. 
		*/
		while(!done){         	
							
			k=csvbody.indexOf('*EOL*', i);
			line=csvbody.substring(i,k);
			/* process line */
        	l = new Lead();
            currentrow = line.split(',');
            System.debug('this is current row' + line);
            fname=currentrow.get(0).trim();
            lname=currentrow.get(1).trim();
	        contactEmail = currentrow.get(2).trim();     
           /* if(lname.length() == 0){
            	if(fname=='Valued Customer'){
            		lname='Customer';
            		fname='Valued';
            	}
            	else{
            		lname=fname;
            	}
            }   */       
            //vpOrder=currentrow.get(2).trim();
            street=currentrow.get(3).trim();
            //street2=currentrow.get(4).trim();
            city=currentrow.get(4).trim();
            state=currentrow.get(5).trim();
           	zip=currentrow.get(6).trim();
            country=currentrow.get(7).trim();
            phone1=currentrow.get(8).trim();
            //phone2=currentrow.get(10).trim();
            Company =currentrow.get(9).trim();
            leadDesc =currentrow.get(10).trim();
            empCount = currentrow.get(11).trim();            
            source=currentrow.get(12).trim();
            
            //contactEmail=currentrow.get(12).trim();
            system.debug('current row size:' + currentrow.size());
          /*
            if(currentrow.size() > 13){
            	system.debug('this is the current row over 13:' + currentrow);
            	if(street2.length() == 0){
            		street2 = city;
            		city = state;
            		state = zip;
            		zip = country;
            		country = phone1;
            		phone1 = phone2;
            		phone2 = source;
            		source = contactEmail;
            		contactEmail = currentrow.get(13).trim();
            	}
            	if(city.length() == 0){
            		system.debug('now fix the city:');
            		city = state;
            		state = zip;
            		zip = country;
            		country = phone1;
            		phone1 = phone2;
            		phone2 = source;
            		source = contactEmail;
            		contactEmail = currentrow.get(13).trim();
            	}
            	if(state.length() == 0){
            		state = zip;
            		zip = country;
            		country = phone1;
            		phone1 = phone2;
            		phone2 = source;
            		source = contactEmail;
            		contactEmail = currentrow.get(13).trim();
            	}
        		else if(currentrow.size() == 15){
        			contactEmail = currentrow.get(14).trim();
        		}
        		system.debug('final info:' + street + ',' + street2 + ',' + city + ',' + state + ',' + zip + ',' + country + ',' + phone1 + ',' + phone2 + ',' + contactEmail);
           
            }
            */
            system.debug('final info:' + street + ',' + street2 + ',' + city + ',' + state + ',' + zip + ',' + country + ',' + phone1 + ',' + phone2 + ',' + contactEmail);                
    	                
           // company = lname + ',' + fname;
	                           
           // l = new Lead(FirstName=fname,LastName=lname,Vista_Print_Order_Number__c=vpOrder,Street=street,Street_2__c=street2,
            	//City=city,State=state,PostalCode=zip,Country=country,phone=phone1,Phone_2__c=phone2,Email=contactEmail,
            	//Company=company,LeadSource='Rocket');
            	
           l = new Lead(FirstName=fname,LastName=lname,Street=street,City=city,State=state,PostalCode=zip,Country=country,phone=phone1,
           Email=contactEmail,Company=company,LeadSource='ROCKET LAWYER',Description=leadDesc,NumberOfEmployees__c = empCount);
           l.BMID__c = 'ROCKETLAWYER';
		   l.PID__c = '6384';
		   l.AID__c = '11501';  
        	
        	/*if(l.Country == 'US'){
        		if(source == 'StandardTollFreeNumberOffer'){
        			l.BMID__c = 'VISTA1007';
        			l.PID__c = '2131';
        			l.AID__c = '6132';        			
        		}
        		else if(source == 'WebsiteDashboardOffer'){
					l.BMID__c = 'VISTA2009US';
        			l.PID__c = '2143';
        			l.AID__c = '6138';        			
        		}
        	}
        	else if(l.Country == 'UK'){
        		if(source == 'StandardTollFreeNumberOffer'){
        			l.BMID__c = 'VISTA2009UKRC';
        			l.PID__c = '6038';
        			//l.AID__c = '';        			
        		}
        	}
        	else if(l.Country == 'CA' && source == 'StandardTollFreeNumberOffer'){
        		l.BMID__c = 'VISTA2009CARC';
        		l.PID__c = '6037';        		
        	}*/
            				
            vpLeads.add(l);	                
            
            /* end process of line */

			if(k==csvbody.lastIndexOf('*EOL*')){
				done=true;
			}
			else{
				i=k+7;
			}
		}

		insert vpLeads;	
	
		return result;  
	}
	
	
	/*static testMethod void testRocketLeadUpload() {
		// Create a new email, envelope object and Attachment
	   Messaging.InboundEmail email = new Messaging.InboundEmail();
	   Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
	   Messaging.InboundEmail.Textattachment inAtt = new Messaging.InboundEmail.Textattachment();
	   Messaging.InboundEmail.Binaryattachment inBtt = new Messaging.InboundEmail.Binaryattachment();
	
	   email.subject = 'test';
	   env.fromAddress = 'user@acme.com';
	
	   // set the body of the attachment
	   inAtt.body = 'VPlast,VPfirst,999@test.com,123 happy drive,apt 234,san jose,IL,95128,US,4085556666,6508885555,StandardTollFreeNumberOffer,jesse@jimmyjack.com*EOL*';
	   inAtt.fileName = 'attach.csv';
	   inAtt.mimeTypeSubType = 'plain/txt';
	
	   email.textAttachments = new Messaging.inboundEmail.Textattachment[] {inAtt }; 
	
	   // call the class and test it with the data in the testMethod
	   RocketLeadUpload emailServiceObj = new RocketLeadUpload();
	   //Counter__c c=[select value__c from Counter__c where name='Partner'];
	   emailServiceObj.handleInboundEmail(email, env );

	   
	   inAtt.body = 'VPlast1,VPfirst1,999@test.com,123 happy drive,san jose,,IL,95128,UK,4085556666,6508885555,StandardTollFreeNumberOffer,jesse1@jimmyjack.com*EOL*';
	   email.textAttachments = new Messaging.inboundEmail.Textattachment[] {inAtt };
	   emailServiceObj.handleInboundEmail(email, env );	   
	   
	   inAtt.body = 'VPlast2,VPfirst2,999@test.com,123 happy drive,,floor5,san jose,IL,95128,US,4085556666,6508885555,WebsiteDashboardOffer,jesse2@jimmyjack.com*EOL*';
	   email.textAttachments = new Messaging.inboundEmail.Textattachment[] {inAtt };
	   emailServiceObj.handleInboundEmail(email, env );
	   
	   inAtt.body = 'VPlast3,VPfirst3,999@test.com,123 happy drive,floor5,,san jose,IL,95128,US,4085556666,6508885555,jesse2@jimmyjack.com*EOL*';
	   email.textAttachments = new Messaging.inboundEmail.Textattachment[] {inAtt };

	   
   	   inAtt.body = 'VPlast3,VPfirst3,999@test.com,123 happy drive,floor5,san jose,,IL,95128,US,4085556666,6508885555,jesse2@jimmyjack.com*EOL*';
	   email.textAttachments = new Messaging.inboundEmail.Textattachment[] {inAtt };

	   
	   inBtt.body = blob.valueOf('VPlast,VPfirst,999@test.com,123 happy drive,apt 234,san jose,IL,95128,US,4085556666,6508885555,StandardTollFreeNumberOffer,jesse@jimmyjack.com*EOL*');
	   inBtt.fileName = 'attach.csv';
		
	   email.binaryAttachments = new Messaging.inboundEmail.Binaryattachment[] {inBtt }; 
	

	   emailServiceObj.handleInboundEmail(email, env );

	   
	   inBtt.body = blob.valueOf('VPlast1,VPfirst1,999@test.com,123 happy drive,san jose,,IL,95128,US,4085556661,6508885551,jesse1@jimmyjack.com*EOL*');
	   email.binaryAttachments = new Messaging.inboundEmail.Binaryattachment[] {inBtt };

	   	   inBtt.body = blob.valueOf(',Valued Customer,999@test.com,123 happy drive,,floor5,san jose,IL,95128,US,4085556662,6508885552,jesse2@jimmyjack.com*EOL*');
	   email.binaryAttachments = new Messaging.inboundEmail.Binaryattachment[] {inBtt };

	   
	   inBtt.body = blob.valueOf(',Valued Customer,999@test.com,123 happy drive,floor5,,san jose,IL,95128,US,4085556663,6508885553,jesse3@jimmyjack.com*EOL*');
	   email.binaryAttachments = new Messaging.inboundEmail.Binaryattachment[] {inBtt };
	   inBtt.body = blob.valueOf(',Valued Customer,999@test.com,123 happy drive,floor5,san jose,,IL,95128,US,4085556664,6508885554,jesse4@jimmyjack.co.uk*EOL*');
	   email.binaryAttachments = new Messaging.inboundEmail.Binaryattachment[] {inBtt };
	   inBtt.body = blob.valueOf(',Valued Customer,999@test.com,123 happy drive,floor5,san jose,,IL,95128,US,444085556666,446508885555,jesse5@jimmyjack.com*EOL*');
	   email.binaryAttachments = new Messaging.inboundEmail.Binaryattachment[] {inBtt };

	}	*/

}