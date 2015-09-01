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
private class TestCloseCase {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        try{
	        Case objCase1 = new Case();
	        insert objCase1;
	        ApexPages.currentPage().getParameters().put('id',objCase1.Id);
	        ApexPages.StandardController sc = new ApexPages.standardController(objCase1);
	        CloseCase objCloseCase = new CloseCase(sc);
	        objCloseCase.getStatus();
	        objCase1.Status='New';
	        upsert objCase1;
	        objCloseCase.strClosingComments='Test Comment';
	        objCloseCase.save();
        }catch(Exception ex){}
    }
}