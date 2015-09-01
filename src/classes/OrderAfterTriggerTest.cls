@isTest
private class OrderAfterTriggerTest {

    static testMethod void myUnitTest() {
    	Schema.DescribeSObjectResult result = Account.SObjectType.getDescribe();
    	Map<string,Schema.RecordTypeInfo> rtMapById = result.getRecordTypeInfosByName();
		Account accObj = new Account();
        accObj.Name = 'TestAccount';
        accObj.Number_of_DL_s__c = 5;
        accObj.RecordTypeId = rtMapById.get('Partner Account').getRecordTypeID();
        accObj.Type ='Partner';
        accObj.Partner_ID__c = '12345';
        accObj.RC_Attribution_Channel__c = 'Sales Agents & Resellers';
        TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT = true;
        insert accObj;
        TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT = false;
        
        Order__c orderVal = new  Order__c();
        orderVal.Name = '12345678';
        orderVal.X12M_Company_Booking_Amount__c = 100.00;
        orderVal.Order_Date__c = system.today();
        orderVal.account__c = accObj.Id;
        orderVal.Lead_Source__c = 'Referral Program';
        insert  orderVal;
        
        orderVal.Name='test';
        update orderVal;
    }
}