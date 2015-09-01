@istest
 public class testMassUpdateRecrd {
	public static testmethod void unittestMassUpdateRecrd() {   
    String strQuery='Select Total_Cases__c,Total_Contacts__c,Total_Activities__c,(Select Id From Cases),(Select Id From Contacts),(Select Id From OpenActivities) From Account a where account limit 1';
     String result = 'xyz';
     String objType ='abc';
     String  name   = 'test';    
     Test.StartTest();
     List<Account> liAccount=new List<Account>();
     Account testAccount = new Account(Name = 'TestAccount');
     testAccount.getsObjectType();
     insert testAccount;
     List<Opportunity> liOpp=new List<Opportunity>();
     Opportunity  opp = new Opportunity(name ='test2',AccountId=testAccount.id,Sales_Model__c='direct',Type='New Business',StageName='Qualified',CloseDate=system.today());
     insert opp; 
     liOpp.add(opp);
     liAccount.add(testAccount);     
     MassUpdateRecord obj=new MassUpdateRecord(liAccount);
     Database.executeBatch(obj,100);
     obj.sendMail('test2','test1','test3');     
     Test.StopTest();
   
   }
   
   static testMethod void TestMassUpdateRecord() {
	 String strQuery='Select Total_Cases__c,Total_Contacts__c,Total_Activities__c,(Select Id From Cases),(Select Id From Contacts),(Select Id From OpenActivities) From Account a where account limit 1';
    
     Test.StartTest();
     
     List<sObject>  sObjectlist = new List<sObject>();
     
     		Account acctest = new Account();
	        acctest.Name='TestAccount';
	        acctest.RC_Attribution_Channel__c='Sales Agents & Resellers';
	        acctest.Partner_ID__c ='123';
	        acctest.RecordTypeId  = '01280000000UERq';
	        insert acctest;
	        sObjectlist.add(acctest);
	        Contact contactObj = new Contact();
	        contactObj.AccountId =  acctest.id;
	        contactObj.Email = 'test123@test.com';
	        contactObj.LastName = 'TestLast';
	        insert contactObj;
	        sObjectlist.add(contactObj);
	        Opportunity Oppval2 = new Opportunity();
	        Oppval2.Name = 'Test Opp2';
	        Oppval2.AccountId = acctest.Id;
	        Oppval2.Type = 'Existing Business';
	        Oppval2.StageName = '3. ActivePipe';
	        Oppval2.Sales_Model__c = 'Direct';
	        Oppval2.CloseDate = System.Today() + 10;
	        Oppval2.CurrencyIsoCode = 'USD';
	        Oppval2.Brand_Name__c= 'RingCentral';
	        Oppval2.RecordTypeId = '01280000000UEtu';
	        insert Oppval2;
     		sObjectlist.add(Oppval2);
     		Lead leadObj = new Lead(LastName='Last11', Company='Company11', Phone='34556221', Email='lead@triggertest11.com',Downgrade_Reason__c='test');
            insert leadObj;
			 sObjectlist.add(leadObj);
			  Case cs = new Case();  
		    //cs.RecordTypeId = rtMapByName.get('IT Helpdesk').getRecordTypeId(); 
		    cs.Contact_ID__c =  contactObj.id;    
            cs.AccountId = acctest.Id;
            cs.Status = 'New';     
             insert cs;
             sObjectlist.add(cs);
		     MassUpdateRecord obj1 = new MassUpdateRecord();
		     MassUpdateRecord obj= new MassUpdateRecord(sObjectlist);
		     Test.StopTest();
		     Database.executeBatch(obj,100);
		     obj.sendMail('result', 'objType','name'); 
    }
 }