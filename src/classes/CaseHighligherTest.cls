/**
 * This class contains unit tests for validating the behavior of Apex class CaseHighligher 
 */
@isTest
private class CaseHighligherTest {

	static testMethod void myUnitTest() {
    	try{
    		Test_Utils tutilss = new Test_Utils();
    		tutilss.initialiseTriggerBypass();
      		Account objAccount1= (Account)SmartFactory.createSObject('Account', true);
            objAccount1.RC_User_ID__c='RC'+Math.random();
      		upsert objAccount1;
     		Red_Account__c objRedAcc= (Red_Account__c)SmartFactory.createSObject('Red_Account__c', true);
            objRedAcc.EscalatedAccount__c=objAccount1.id;
            objRedAcc.Status__c='Inprogress';
      		upsert objRedAcc;
     		Case cas1 = new Case( Type = 'VoIP Device Back Order');
            upsert cas1;
  			ApexPages.StandardController controller=new ApexPages.Standardcontroller(cas1);
  			CaseHighlighter objCaseHighlighter=new CaseHighlighter(controller);
  			tutilss.deInitialiseTriggerBypass();
 	 	}catch(Exception e){}  
    }
}