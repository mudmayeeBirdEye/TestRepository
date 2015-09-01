@isTest
private class TestNeustar {
    
    static testMethod void myUnitTest() {
      try {
      Schema.DescribeSObjectResult result = Case.SObjectType.getDescribe();  
          Map<String,Schema.RecordTypeInfo> rtMapByName = result.getRecordTypeInfosByName();
           
           Account accObj = new Account();
           accObj.Name = 'TestNS';
           accObj.RC_User_ID__c = 'Test2312';
           insert accObj;
           Contact contactObj = new Contact();
           contactObj.LastName = 'contactLast';
           contactObj.AccountId = accObj.id;
           contactObj.email='test@rc11.com';
           insert contactObj;
           
           Test.startTest();
         Case caseObj = new Case();
           Id recordTypeId = rtMapByName.get('Porting - In (RC)').getRecordTypeId();
           caseObj.RecordTypeId = recordTypeId;
           caseObj.Subject = 'Test Case 1';
           caseObj.Status = 'New';
           caseObj.AccountId = accObj.id;
           caseObj.ContactId = contactObj.id;
           caseObj.RC_Porting_Order_ID__c = 5.00;
           insert caseObj;
           caseObj.Status = 'Closed';
           update caseObj;
           Test.stopTest();  
      } catch(Exception ex) {} 
    }
    
     static testMethod void myUnitTest1() {
       try {
         Schema.DescribeSObjectResult result = Case.SObjectType.getDescribe();  
          Map<String,Schema.RecordTypeInfo> rtMapByName = result.getRecordTypeInfosByName();
           
           Account accObj = new Account();
           accObj.Name = 'TestNS';
           accObj.RC_User_ID__c = 'Test23121';
           insert accObj;
           Contact contactObj = new Contact();
           contactObj.LastName = 'contactLast';
           contactObj.AccountId = accObj.id;
           contactObj.email='test@rc112.com';
           insert contactObj;
           
           Test.startTest();
         Case caseObj = new Case();
           Id recordTypeId = rtMapByName.get('Porting - In (RC)').getRecordTypeId();
           caseObj.RecordTypeId = recordTypeId;
           caseObj.Subject = 'Test Case 2';
           caseObj.Status = 'New';
           caseObj.AccountId = accObj.id;
           caseObj.ContactId = contactObj.id;
           caseObj.RC_Porting_Order_ID__c = 5.00;
           insert caseObj;
           RC_ESB_PortingOrderHelper.updatePortingOrder(caseObj.id);
           RC_ESB_PortingOrderHelper rcESbPortingObj = new RC_ESB_PortingOrderHelper();
           rcESbPortingObj.sendRequest('EndPoint');
           Test.stopTest();  
       } catch(Exception ex) {}
     }
     
     static testMethod void myUnitTest2() {
       try {
       	 datetime dtstart = Datetime.newInstance(2008, 20 , 12, 00, 00, 00);
     	 date myDate = date.today();
         OrderStatusUpdateService.orderStatusUpdateResponse_element resObj = new OrderStatusUpdateService.orderStatusUpdateResponse_element();
         OrderStatusUpdateService.OrderStatusService orderServiceObj = new OrderStatusUpdateService.OrderStatusService();
         orderServiceObj.orderStatusUpdate('pon', 'orderStatus', 'jcode', dtstart, 'rejectMessage', myDate, 'rcAccountId', 12345676);
         OrderStatusUpdateService.orderStatusUpdate_element updateEleObj = new OrderStatusUpdateService.orderStatusUpdate_element();   
       } catch(Exception ex) {}
     }
}