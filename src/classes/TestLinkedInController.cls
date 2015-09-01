@isTest
private class TestLinkedInController {

    static testMethod void myUnitTest() {
        LinkedInController linkedInCon = new LinkedInController();
        linkedInCon.companyName = 'test';
        linkedInCon.searchCompany();
    }
}