@isTest
private class ValidationUtilityTest {

    static testMethod void myUnitTest() {
        ValidationUtility.validatePhoneNumber('+01234567890ext12','UK');
        ValidationUtility.validatePhoneNumber('+4401234567890ext12','UK');
        ValidationUtility.validatePhoneNumber('1234567890ext12','UK');
        ValidationUtility.validatePhoneNumber('01234567890','USA');
        ValidationUtility.validatePhoneNumber('012345678901','USA');
    }
}