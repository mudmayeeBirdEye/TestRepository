@isTest
private class TestRollUPTrigger {

	static testMethod void myTest() {
		/*
		
		//User usr = [select id,name from User limit 1];
		
		RecordType rtp = [Select id,Name from RecordType where name='Partner Account' limit 1];	
		RecordType rtc = [Select id,Name from RecordType where name='Customer Account' limit 1];	
		
		Account partner = (Account)SmartFactory.createSObject('Account');
		partner.RecordTypeId = rtp.id;
		Account partner2 = (Account)SmartFactory.createSObject('Account');
		partner2.RecordTypeId = rtp.id;
		 
		insert partner;
		//insert partner2;
		

		
		Account cust = (Account)SmartFactory.createSObject('Account');
		cust.RecordTypeId = rtc.id;
		cust.Partner_ID__c = partner.Partner_ID__c; 
		cust.RC_User_ID__c = '005800000036sJJ';
		insert cust;
		cust.Partner_ID__c = partner2.Partner_ID__c; 
		update cust;
		
		delete cust;

		
		Case cs = (Case)SmartFactory.createSObject('Case');
		
		cs.AccountId = partner.id;
		cs.Porting_Phone_to_be_Ported__c = '123456789';
	
		insert cs;
		cs.AccountId = partner2.id;
		update cs;
		delete cs;
		
		
		Contact con = (Contact)SmartFactory.createSObject('Contact');
		con.AccountId = partner.id;
		
		insert con;
		con.AccountId = partner2.id;
		update con;
		delete con;
		
		Opportunity opp = (Opportunity)SmartFactory.createSObject('Opportunity');
		opp.AccountId = partner.id;
		opp.StageName = 'QWERT';
		opp.CloseDate = System.today();
		insert opp;
		*/
	}

}