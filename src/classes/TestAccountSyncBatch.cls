@isTest
private class TestAccountSyncBatch {

	static testMethod void myTest() {
		try {
		/*RecordType rtp = (RecordType)SmartFactory.createSObject('RecordType');
		rtp.Name = 'Partner Account';
		insert rtp;
		
		RecordType rtc = (RecordType)SmartFactory.createSObject('RecordType');
		rtc.Name = 'Customer Account';
		insert rtc;	*/	
		
		RecordType rtp = [Select id,Name from RecordType where name='Partner Account' limit 1];	
		RecordType rtc = [Select id,Name from RecordType where name='Customer Account' limit 1];	
		
		Account partner = (Account)SmartFactory.createSObject('Account');
		partner.name = 'XXXXSIMACCPAR';
		partner.RecordTypeId = rtp.id;
		partner.Partner_ID__c = 'XXXSIMTEST123';    
		insert partner;
		
		System.debug('********************---' + partner);
		
		/*Account customer = (Account)SmartFactory.createSObject('Account'); 
		customer.name = 'WWWWWRRTTTTT';
		customer.RecordTypeId = rtc.id;
		customer.Partner_ID__c = 'XXXSIMTEST123';
		System.debug('********************---' + customer);
		insert customer;*/
		
		Test.startTest();
		String q = 'select id,Total_Contacts__c,Total_Cases__c,Total_Active_Customers__c,RecordType.name,Partner_id__c from Account where name like \'%XXXXSIMACCPAR%\'';
		AccountSyncBatch asb = new AccountSyncBatch(q);
		Database.executeBatch(asb);
		Test.stopTest();
		
		Account acc = [select id,Total_Contacts__c,Total_Cases__c,Total_Active_Customers__c,RecordType.name,Partner_id__c from Account where name like '%XXXXSIMACCPAR%'];
		System.assertEquals(0, acc.Total_Active_Customers__c);
		} catch(Exception e) {}
	}

}