@istest
 public class testFakeScheduledMethod{
 static testMethod void unitFakeLeadController(){
	try{
         Test.StartTest();
		 List<Lead> leadListToDel = new List<Lead>();
		 Account acctest1 = new Account();
		 acctest1.Name = 'TestAccount101';
		 acctest1.Next_Renewal_Date__c = system.today() + 10;
		 acctest1.RecordTypeId  = '01280000000UERq';
		 insert acctest1;
         
		 insert new FakeLead_1__c(Name = 'something', First_Name__c = 'something', Last_Name__c = 'new');
		 insert new FakeLead_1__c(Name = 'rctu', First_Name__c = 'rctu', Last_Name__c = '2calls4me');
		 insert new FakeLead_7__c(Name = 'RingCentral', First_Name__c = 'RingCentral', Last_Name__c = 'RingCentral-Test');
            
		 Lead leadObj1 = new Lead();
		 leadObj1.FirstName='Ringcentral';
		 leadObj1.LastName='Ringcentral-Test';
		 leadObj1.Company='TestLead124CN';
		 leadObj1.Phone='9911112224';
		 leadObj1.email = 'testLead124@test.com';
		 leadObj1.LeadSource = 'About To be Cancelled';
		 leadObj1.ATBC_Stage__c = 'New';
		 // leadObj1.Account__c = acctest1.id;
		 leadObj1.User_ID__c = 'TestLead113';
		 insert leadObj1;
            
         Lead leadObj2 = new Lead();
         leadObj2.FirstName='something';
         leadObj2.LastName='new';
         leadObj2.Company='TestLead123CN';
         leadObj2.Phone='9911112222';
         leadObj2.email = 'testLead123@test.com';
         leadObj2.LeadSource = 'About To Be Cancelled UK';
         leadObj2.ATBC_Stage__c = 'New';
         // leadObj2.Account__c = acctest.id;
         leadObj2.User_ID__c = 'TestLead111';
         insert leadObj2;
            
            
         
     	 FakeScheduledMethod obj= new FakeScheduledMethod();
     	 obj.execute(null);
     	 Test.StopTest();          
        
         } catch(Exception ex) {
         	system.debug('Exception====='+ex.getMessage());
         }     
         }
    }