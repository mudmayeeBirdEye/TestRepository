public class RC_ESB_PortingOrderHelper{
    @future(callout=true) 
    public static void updatePortingOrder(String caseId){
    
            Case objCase =[Select CaseNumber,status,Porting_Reject_Reason__c,Porting_last_status_change_date__c,Account.RC_User_ID__c,
                          Porting_Estimated_Completion_Date__c,RC_Porting_Order_ID__c from Case where id=:caseId];
            
            String pon=objCase.CaseNumber;
            String orderStatus=objCase.status;
            String jcode=objCase.Porting_Reject_Reason__c;
            DateTime timestamp=objCase.Porting_last_status_change_date__c;
            String rejectMessage=null;//need to confirm
            Date completionDate=objCase.Porting_Estimated_Completion_Date__c;
            string rcAccountId=null;
            String strAccountId=objCase.Account.RC_User_ID__c;
            if(objCase.Account.RC_User_ID__c != null){
              // if(objCase.Account.RC_User_ID__c.containsIgnoreCase('UID')){
                 strAccountId=strAccountId.removeStartIgnoreCase('UID'); 
              // }
             }
            rcAccountId=strAccountId;//need to confirm
            Double rcOrderId=Double.valueOf(objCase.RC_Porting_Order_ID__c);
            /*
            RC_ESB_PortingOrderSt.OrderStatusService obj=new RC_ESB_PortingOrderSt.OrderStatusService();
            Boolean isSuccess=obj.orderStatusUpdate(pon,orderStatus,jcode,timestamp,rejectMessage,completionDate,rcAccountId,rcOrderId);
            */
            System.debug('## CASE NUMBER = ' + pon 
            	+ '\n## ORDER STATUS = ' + orderStatus
            	+ '\n## JCODE = ' + jcode
            	+ '\n## TIMESTAMP = ' + timestamp
            	+ '\n## REJECT MESSAGE = ' + rejectMessage
            	+ '\n## COMPLETION DATE = ' + completionDate
            	+ '\n## RC ACCOUNT ID = ' + rcAccountId
            	+ '\n## RC ORDER ID = ' + rcOrderId
            );
            
            OrderStatusUpdateService.OrderStatusService obj=new OrderStatusUpdateService.OrderStatusService();
            obj.timeout_x = 60000;
            if(!Test.isRunningTest()) {
            	Boolean isSuccess = obj.orderStatusUpdate(pon,orderStatus,jcode,timestamp,rejectMessage,completionDate,rcAccountId,rcOrderId);
            	system.Debug('>>>isSuccess>>'+ isSuccess); 
            }
    }
	public void sendRequest(String endpoint) {
        // Create the request envelope
        DOM.Document doc = new DOM.Document();
        
        String soapNS = 'http://schemas.xmlsoap.org/soap/envelope/';
        String xsi = 'http://www.w3.org/2001/XMLSchema-instance';
        String serviceNS = 'https://esb-stage.ringcentral.com/porting/order/OrderStatusUpdateService/';
        
        dom.XmlNode envelope
            = doc.createRootElement('Envelope', soapNS, 'soapenv');
        envelope.setNamespace('xsi', xsi);
        envelope.setAttributeNS('schemaLocation', soapNS, xsi, null);
        
        dom.XmlNode body
            = envelope.addChildElement('Body', soapNS, null);
        
        body.addChildElement('echo', serviceNS, 'req').
           addChildElement('category', serviceNS, null).
           addTextNode('classifieds');
        
        System.debug(doc.toXmlString());
        
        // Send the request
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint(endpoint);
        req.setHeader('Content-Type', 'text/xml');
        
        req.setBodyDocument(doc);
        
        Http http = new Http();
        HttpResponse res = http.send(req);
        
        System.assertEquals(200, res.getStatusCode());
        
        dom.Document resDoc = res.getBodyDocument();
        
        envelope = resDoc.getRootElement();
        
        String wsa = 'http://schemas.xmlsoap.org/ws/2004/08/addressing';
        
        dom.XmlNode header = envelope.getChildElement('Header', soapNS);
        System.assert(header != null);
        
        String messageId
            = header.getChildElement('MessageID', wsa).getText();
        
        System.debug(messageId);
        System.debug(resDoc.toXmlString());
        System.debug(resDoc);
        System.debug(header);
        
        System.assertEquals(
         'http://schemas.xmlsoap.org/ws/2004/08/addressing/role/anonymous',
         header.getChildElement(
           'ReplyTo', wsa).getChildElement('Address', wsa).getText());
        
        
        System.assertEquals(
          envelope.getChildElement('Body', soapNS).
              getChildElement('echo', serviceNS).
              getChildElement('something', 'http://something.else').
              getChildElement(
                'whatever', serviceNS).getAttribute('bb', null),
                'cc');
        
        System.assertEquals('classifieds',
          envelope.getChildElement('Body', soapNS).
              getChildElement('echo', serviceNS).
              getChildElement('category', serviceNS).getText());
    }


}