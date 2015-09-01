/*************************************************
ConfirmSale class
This Class made use of account authenticator for previous version of integration.
This class passed Account Number to API which passed back UserId if the number was valid.
No Longer Used. The bulk of it is commented out so it is not counted as lines of code when pushing to production.
/************************************************/

global class ConfirmSale {
 
 	WebService static void confirm(string oppID) { 	        
// 		String code;
// 		String success;
//		String theId = ApexPages.currentPage().getParameters().get('id'); 
 

 		Opportunity o = [select Id,RC_Account_Number__c,Type,description,RC_User_ID__c from Opportunity where id =:oppID];
 		
 	/*	if(o.Type == 'New Business' && o.RC_Account_Number__c != null){
			
			//use api to get userID by way of account number	
			// request authorization		
			HttpRequest req = new HttpRequest();
			req.setEndpoint('http://ws.ringcentral.com/ringcentral/API/Authenticator');
			//req.setEndpoint('http://212.119.189.144:80/ringcentral/API/Authenticator');
			req.setMethod('POST');
			req.setHeader('Host', 'ru-led-jedidev');
			req.setHeader('SOAPAction', '');
			req.setHeader('User-Agent', 'Jakarta Commons-HttpClient/3.0.1');
			req.setHeader('Content-Type', 'text/xml;charset=UTF-8');
			req.setBody('<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:aut="http://service.ringcentral.com/Authenticator/"> <soapenv:Header/> <soapenv:Body> <aut:partnerLogin> <login>foo</login> <password>bar</password> </aut:partnerLogin> </soapenv:Body> </soapenv:Envelope>');
			
			http h = new Http();
			HTTPResponse res = h.send(req);
			
			String cookie = res.getHeader('Set-Cookie');
			
			// call method
			HttpRequest reqID = new HttpRequest();
			reqID.setEndpoint('http://ws.ringcentral.com/ringcentral/API/SalesForce');
			reqID.setMethod('POST');
			reqID.setHeader('Cookie', cookie);
			reqID.setHeader('Host', 'ru-led-jedidev');
			reqID.setHeader('SOAPAction', '');
			reqID.setHeader('User-Agent', 'Jakarta Commons-HttpClient/3.0.1');
			reqID.setHeader('Content-Type', 'text/xml;charset=UTF-8');
			reqID.setBody('<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:sal="http://service.ringcentral.com/SalesForce/"> <soapenv:Header/> <soapenv:Body> <sal:getUserIdByPhoneNumber> <subscriber> <!--Optional:--> <ipAddress> <first>?</first> <fourth>?</fourth> <second>?</second> <third>?</third> </ipAddress> <requestId>?</requestId> <startTime>?</startTime> </subscriber> <numberRequest> <!--Optional:--> <phoneNumber>'+o.RC_Account_Number__c+'</phoneNumber> </numberRequest> </sal:getUserIdByPhoneNumber> </soapenv:Body> </soapenv:Envelope>');
			
			http hID = new Http();
			HTTPResponse resID = hID.send(reqID);
		
			//system.debug('this is the method response body: ' + resID.getBody());
			//system.debug('this is the response status: ' + resID.getStatus());
			
			if(resID.getStatus() == 'OK'){
				// Generate the HTTP response as an XML stream
				XmlStreamReader reader = resID.getXmlStreamReader();
				// Read through the XML
				while(reader.hasNext()) {
					System.debug('Event Type:' + reader.getEventType());
					if(reader.getEventType() == XmlTag.START_ELEMENT) {
						System.debug(reader.getLocalName());
						if(reader.getLocalName() == 'code'){
							reader.next();
							//system.debug('this is the code element: ' + reader.getText());
							code = reader.getText();		
						}
						else if(reader.getLocalName() == 'success'){
							reader.next();
							//system.debug('this is the success element: ' + reader.getText());
							success = reader.getText();		
						}
						else if((reader.getLocalName() == 'result') && (code == '0') && (success == 'true')){
							reader.next();
							//system.debug('this is the result element: ' + reader.getText());
							o.RC_User_ID__c = reader.getText();
						}	
					}
					reader.next();
				}
			}		
			if(o.RC_User_ID__c != null){
				o.StageName ='Closed-Submitted';
				o.Date_Submitted__c = Datetime.now();
				o.CloseDate = date.today();
			}
	
			update o;
 		}
       
		*/ 
		// Redirect the user back to the original page        
	//	PageReference pageRef = new PageReference('/' + opp.Id);
//		PageReference pageRef = new ApexPages.StandardController(o).view();		         
//		pageRef.setRedirect(true);        
//		return pageRef;     
	} 
}


/********************
public with sharing class ConfirmSale {
	// Constructor - this only really matters if the autoRun function doesn't work right 	    
	private final Opportunity o; 	    
	public ConfirmSale(ApexPages.StandardController stdController) {         
		this.o = (Opportunity)stdController.getRecord(); 	    
	} 

	// Code we will invoke on page load. 
	public PageReference autoRun() { 	        
		String theId = ApexPages.currentPage().getParameters().get('id'); 
	        
		if (theId == null) {     
			// Display the Visualforce page's content if no Id is passed over 
            return null; 
        } 

 		Opportunity o = [select Id,RC_Account_Number__c from Opportunity where id =:theId];
			
			//use api to get userID by way of account number
		
			
			//o.RC_User_ID__c = l.userIDgetUserID.(l.RC_Account_number__c);
			
			//o.StageName = 'Closed-Submitted';
			//o.DWsynched__c = true; 
       
		 
		// Redirect the user back to the original page        
	//	PageReference pageRef = new PageReference('/' + opp.Id);
		PageReference pageRef = new ApexPages.StandardController(o).view();		         
		pageRef.setRedirect(true);        
		return pageRef;     
	} 
	
    static testMethod void confirmSaleTest() {
        Opportunity o = new Opportunity();
        o.RC_Account_Number__c = '6504724063';
        o.StageName = 'Open';
        o.Type = 'New Business';
        o.Name = 'opp test';
        o.CloseDate = date.today();
        insert o;
        ConfirmSale.confirm(o.Id);  
        
        o = new Opportunity();
        o.RC_Account_Number__c = '6653568745';
        o.StageName = 'Open';
        o.Type = 'New Business';
        o.Name = 'opp test';
        o.CloseDate = date.today();
        insert o;
        ConfirmSale.confirm(o.Id);        
        //system.assertEquals(o.RC_User_ID__c, '37439510');

       
    }
	
}
***********************/