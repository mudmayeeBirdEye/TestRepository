/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class Test_multiselect {

    static testMethod void myUnitTest() {
        Test.startTest();
        
             Account accObj = new Account();
             accObj.Name = 'TestAccount1023';
             insert accObj; 
        
        	 Contact c = new Contact();
	         c.LastName = 'contactLast1';
	         c.AccountId = accObj.Id;   //[SELECT id FROM Account WHERE name=: acctest.Name].id;
	         c.email='test@test.com';
	         c.Phone='1234567890';
	         insert c;
        	
            ApexPages.currentPage().getParameters().put('acc_id',accObj.id);
        	ApexPages.currentPage().getParameters().put('rtype','00Q');
        	ApexPages.currentPage().getParameters().put('lemail','test@test.com');
        	Map<String,String> ccContactMap1 = new Map<String,String>(); 
        	List<String> gsl = new List<String>();
			gsl.add(c.id);
        	gsl.add(c.id);
            multiselect ms = new multiselect();
        	ms.isEmailValidated = true;
        	ms.ccContactMap = ccContactMap1;
        	ms.globalSelectedList = gsl;
        	ms.selectedBccList = gsl;
        	ms.searchContact();
        	ms.setToAddress();
        	ms.removeToAddress();
        	ms.setAdditionalTo();
        	ms.removeAdditionalTo();
        	ms.setCCList();
        	ms.removeCCList();
        	ms.setBccList();
        	ms.removeBccList();
        	ms.emailAuthor();
        	ms.cancel();
        	ms.OptedOutOfEmail();
            ms.getGlobalContactOptions();
        	ms.getAllAdditionalTo();
        	ms.getAllCCOptionsList();
        	ms.getAllBccOptionsList();
        Test.stopTest();
    }
}