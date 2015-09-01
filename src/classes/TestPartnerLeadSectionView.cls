@isTest
private class TestPartnerLeadSectionView{
    static testmethod void UnitPrtledSecVw(){
        Schema.DescribeSObjectResult resultAccount = Account.SObjectType.getDescribe();
        Map<string,Schema.RecordTypeInfo> rtMapByIdAccount = resultAccount.getRecordTypeInfosByName();         
        Schema.DescribeSObjectResult resultled = Lead.SObjectType.getDescribe();
        Map<string,Schema.RecordTypeInfo> rtMapByIdled = resultled.getRecordTypeInfosByName();
                  
        Account accObj = new Account();
        accObj.Name = 'Test Account';
        accObj.RecordTypeId = rtMapByIdAccount.get('Partner Account').getRecordTypeId();
        accObj.Partner_ID__c = 'Test Partner 2';
        insert accObj;
        
        Account accObj1 = new Account();
        accObj1.Name = 'Test Account Child';
        accObj1.RecordTypeId = rtMapByIdAccount.get('Partner Account').getRecordTypeId();
        accObj1.Partner_ID__c = 'Test Partner 1 Child';
        accObj1.ParentId = accObj.id;
        insert accObj1;
        Test.startTest();
        
        Lead  ledObj = new Lead();
        ledObj.RecordTypeId = rtMapByIdled.get('Partner Leads').getRecordTypeId();
        ledObj.Company = 'xyz corpTest';
        ledObj.Email= 'xyztest@yahoo.com';
        ledObj.status= '1. New';
        ledObj.LeadPartnerID__c = 'Test Partner 2'; 
        ledObj.Phone = '9810112233';
        ledObj.FirstName = 'Test FName';
        ledObj.LastName = 'Test L Name';                         
        insert ledObj;
        
     	Lead  ledObj1 = new Lead();
        ledObj1.RecordTypeId = rtMapByIdled.get('Partner Leads').getRecordTypeId();
        ledObj1.Company = 'xyz corpTest1';
        ledObj1.Email= 'xyztest1@yahoo.com';
        ledObj1.status= '1. New';
        ledObj1.LeadPartnerID__c = 'Test Partner 1 Child'; 
        ledObj1.Phone = '9810112244';
        ledObj1.FirstName = 'Test FName1';
        ledObj1.LastName = 'Test L Name1';                           
        insert ledObj1;
        
       	Test.stopTest();

       	PartnerLeadSectionView partnerledViewObj = new PartnerLeadSectionView(new ApexPages.StandardController(accObj));
      
    }

 }