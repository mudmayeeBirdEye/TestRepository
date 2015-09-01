@isTest
private class TestPortalSystemStatusController {

    static testMethod void systemStatusTest() {
        RCSiteSetup__c objRCSiteName = new RCSiteSetup__c();
        objRCSiteName.RCSiteName__c = 'rcsupport';
        objRCSiteName.Brand_Filter__c = 'Brand:US';
        insert objRCSiteName;
        
        System_Status__c sysStatusObj1 = new System_Status__c();
        sysStatusObj1.Internal_Status__c = 'OPEN';
        sysStatusObj1.Region__c = 'US';
        sysStatusObj1.Severity__c = 'Level-1';
        sysStatusObj1.Public_Description__c = 'Test Description';
        insert sysStatusObj1;
        
        System_Status__c sysStatusObj2 = new System_Status__c();
        sysStatusObj2.Internal_Status__c = 'RESOLVED';
        sysStatusObj2.Region__c = 'US';
        sysStatusObj2.Severity__c = 'Level-0';
        sysStatusObj2.Public_Description__c = 'Test Description';
        insert sysStatusObj2;
        
        RCSupportPortalSystemStatusController obj = new RCSupportPortalSystemStatusController();
        
    }
}