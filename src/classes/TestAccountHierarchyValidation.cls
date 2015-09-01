/***************************************************************************************************
* This class contains unit tests for validating the behavior of Apex classes
* and triggers.
*
* Target Class/Trigger: AccountHeirarchyValidation Class
*
* Update History:
* Updated by: eugenebasianomutya
* Date Updated: 4/8/2015
* Update Made: Enhance code coverage
****************************************************************************************************/

@isTest
private class TestAccountHierarchyValidation {


	static testMethod void myUnitTest1() {

		Test.startTest();
		
		list<Account> accountList = new list<Account>();
		
		//Account objAccount1= (Account)SmartFactory.createSObject('Account', true);
		Account objAccount1 = new Account();
		objAccount1.Name = 'TestAcc1';
		objAccount1.RC_User_ID__c = 'RC'+Math.random();
		insert objAccount1;
		accountList.add(objAccount1);
		
		//Account objAccount2= (Account)SmartFactory.createSObject('Account', true);
		Account objAccount2 = new Account();
		objAccount2.Name = 'TestAcc2';
		objAccount2.ParentId = objAccount1.id;
		objAccount2.RC_User_ID__c = 'RC'+Math.random();
		insert objAccount2;
		accountList.add(objAccount2);
		
		//Account objAccount3= (Account)SmartFactory.createSObject('Account', true);
		Account objAccount3 = new Account();
		objAccount3.Name = 'TestAcc3';
		objAccount3.ParentId=objAccount2.id;
		objAccount3.RC_User_ID__c='RC'+Math.random();
		insert objAccount3;
		accountList.add(objAccount3);
		
		//Account objAccount4= (Account)SmartFactory.createSObject('Account', true);
		Account objAccount4 = new Account();
		objAccount4.Name = 'TestAcc4';
		objAccount4.ParentId = objAccount3.id;
		objAccount4.RC_User_ID__c= 'RC'+ Math.random();
		insert objAccount4;
		accountList.add(objAccount4);
			
		//Account objAccount5= (Account)SmartFactory.createSObject('Account', true);
		Account objAccount5 = new Account();
		objAccount5.ParentId= objAccount4.id;
		objAccount5.Name = 'TestAcc5';
		objAccount5.RC_User_ID__c ='RC'+Math.random();
		insert objAccount5;
		accountList.add(objAccount5);
		
		//Account objAccount9= (Account)SmartFactory.createSObject('Account', true);
		Account objAccount9 = new Account();
		objAccount9.RC_User_ID__c='RC'+Math.random();
		objAccount9.Name = 'TestAcc9';
		insert objAccount9;
		accountList.add(objAccount9);
			
		//Account objAccount10 = (Account)SmartFactory.createSObject('Account', true);
		Account objAccount10 = new Account();
		objAccount10.RC_User_ID__c='RC'+Math.random();
		objAccount10.Name = 'TestAcc10';
		insert objAccount10;
		accountList.add(objAccount10);
				
		//Update Hierarchy to:
		//TestAcc2	TestAcc3	TestAcc4	TestAcc10
		//TestAcc1	TestAcc2	TestAcc3	TestAcc4
		//			TestAcc1	TestAcc2	TestAcc3
		//						TestAcc1	TestAcc2
		//									TestAcc1
		
		List<Account> lst = new List<Account>();
		accountList[0].parentId = accountList[1].id;
		lst.add(accountList[0]);
		accountList[1].parentId= accountList[2].id;
		lst.add(accountList[1]);
		accountList[2].parentId= accountList[3].id;
		lst.add(accountList[2]);
		accountList[3].parentId= accountList[6].id;
		lst.add(accountList[3]);
		upsert lst;
			
		AccountHierarchyValidation.validateAccountHierarchy(lst);
	
		Test.stopTest();

	}

}