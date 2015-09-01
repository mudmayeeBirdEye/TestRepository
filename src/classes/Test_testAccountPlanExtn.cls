@isTest
private class Test_testAccountPlanExtn {
static testMethod void testAccountPlanExtn() {
        Account accObj = new Account();
        accObj.Name = 'TestAccount';
        accObj.RC_Attribution_Channel__c = 'Sales Agents & Resellers';
        accObj.Partner_ID__c = '123';
        accObj.RecordTypeId  = '01280000000UERq';
        accObj.OwnerId = UserInfo.getUserId();
        insert accObj;
        
        ApexPages.currentPage().getParameters().put('Id',accObj.Id);
        
        AccountPlanExtn accountPlanExtnObj = new AccountPlanExtn(new ApexPages.StandardController(new Account()));
        accountPlanExtnObj.save();
        
        Account_Plan__c accountPlanObj = new Account_Plan__c();
        accountPlanObj.Account__c = accObj.Id;
        accountPlanObj.Account_ID__c = accObj.Id;
        insert accountPlanObj;
        
        AccountPlanExtn accountPlanExtnObj1 = new AccountPlanExtn(new ApexPages.StandardController(new Account())); 
        accountPlanExtnObj1.save();
     }
     }