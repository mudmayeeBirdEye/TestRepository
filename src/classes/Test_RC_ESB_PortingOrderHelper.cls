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
public class Test_RC_ESB_PortingOrderHelper {

    public static testMethod void myUnitTest() {
        // TO DO: implement unit test
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
	      
		   	Case caseObj = new Case();
	       	Id recordTypeId = rtMapByName.get('Support-Case').getRecordTypeId();
	       	system.debug('----------->'+recordTypeId);
	       	caseObj.RecordTypeId = recordTypeId;
	       	caseObj.Subject = 'Test Case 2';
	       	caseObj.Status = 'New';
	       	caseObj.AccountId = accObj.id;
	       	caseObj.ContactId = contactObj.id;
	       	caseObj.RC_Porting_Order_ID__c = 5.00;
	       	caseObj.No_Of_Private_Comments__c = 5; 
	       	caseObj.IsUpdatePermitted__c = true;
	       	insert caseObj;
	       	Test.startTest();
	        	RC_ESB_PortingOrderHelper.updatePortingOrder(caseObj.id);
	       	RC_ESB_PortingOrderHelper rcESbPortingObj = new RC_ESB_PortingOrderHelper();
	       	rcESbPortingObj.sendRequest('Endpoint');
	       	Test.stopTest();	
    }
}