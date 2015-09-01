/**************************************************************************************************
* Project Name..........: Implementation                                                          *
* File..................: Test_ImplementationSettingsPhoneSystem                                  *
* Version...............: 1.0                                                                     *
* Created by............: Simplion Technologies                                                   *
* Created Date..........: 26-06-2014                                                              *
* Last Modified by......: Simplion Technologies                                                   *
* Last Modified Date....: 26-06-2014                                                              *
* Description...........: This class is TestClass                                                 *
**************************************************************************************************/
@isTest
private class Test_ImplementationSettingsPhoneSystem {

    static testMethod void implementationSettingsPhoneSystemUnitTest() {
        Implementation__c objImplementation = new Implementation__c(Name='Test Impl',Account_Review__c='Test',Users__c='Test',
                                                                    Company_Numbers_and_Info__c='Test',Groups__c='Test',
                                                                    Phones_Devices__c='Test',Tools__c='Test');
        insert objImplementation;
        ApexPages.currentPage().getParameters().put('Id', objImplementation.Id);
         //ApexPages.StandardSetController controller = new ApexPages.Standardsetcontroller(objImplementation);
        ImplementationSettingsPhoneSystem objImplementationSettingsPhoneSystem = new ImplementationSettingsPhoneSystem(new ApexPages.StandardController(objImplementation));
        ApexPages.currentPage().getParameters().put('Id', objImplementation.Id);
        objImplementationSettingsPhoneSystem = new ImplementationSettingsPhoneSystem(new ApexPages.StandardController(objImplementation));
        objImplementationSettingsPhoneSystem.saveImplementation();
        objImplementationSettingsPhoneSystem.strEdit='editable';
        objImplementationSettingsPhoneSystem.saveImplementation();
        objImplementationSettingsPhoneSystem.getDisplayTelusValue();

    }
}// End of Class