/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 */
@isTest  
private class Test_AccInfo {
	 static testMethod void myUnitTest1() {
	 	 Test.startTest();
	   Account acctest12 = new Account();
                acctest12.Name='TestAccount12';
                acctest12.RC_Attribution_Channel__c = 'National Accounts';
                acctest12.Partner_ID__c ='123';
                acctest12.RecordTypeId  = '01280000000UERq';
                insert acctest12;
                
                Opportunity Oppval12 = new Opportunity();
                Oppval12.Name = 'Test Opp12';
                Oppval12.AccountId = acctest12.Id;
                Oppval12.Type = 'Existing Business';
                Oppval12.StageName = '3. ActivePipe';
                Oppval12.Sales_Model__c = 'Direct';
                Oppval12.CloseDate = System.Today() + 10;
                Oppval12.CurrencyIsoCode = 'USD';
                Oppval12.Brand_Name__c= 'RingCentral';
                Oppval12.RecordTypeId = '01280000000UEtu';
                insert Oppval12;
                 
                Quote q12 = new Quote();
                q12.Name ='Test Name12';
                q12.OpportunityId = Oppval12.Id;
                q12.End_Date__c = system.today();
                q12.Status = 'Draft';
                q12.Start_Date__c = system.today()-5;
                q12.Auto_Renewal__c = true;
                q12.Term_months__c = '12';
                q12.Status ='Active';
                insert q12;
                
                 Test.stopTest();
	 }
    static testMethod void myUnitTest() {
       
                Test_Utils testUtilsObject = new Test_Utils();
                
                
                Account acctest = new Account();  
                acctest.Name='TestAccount';
                acctest.RC_Attribution_Channel__c='Sales Agents & Resellers';
                acctest.Partner_ID__c ='123';
                acctest.RecordTypeId  = '01280000000UERq';
                acctest.Technical_Account_Manager__c=userInfo.getUserId();
                insert acctest;
                
                AccountTeamMember atmObject = new AccountTeamMember();
                atmObject.AccountId = acctest.Id;
                atmObject.TeamMemberRole = 'Technical Account Manager - Primary';
                atmObject.UserId = testUtilsObject.createUserRecord(new List<User>{new User()})[0].Id;
                insert atmObject;
                
                Opportunity Oppval = new Opportunity();
                Oppval.Name = 'Test Opp';
                Oppval.AccountId = acctest.Id;
                Oppval.Type = 'Existing Business';
                Oppval.StageName = '3. ActivePipe';
                Oppval.Sales_Model__c = 'Direct';
                Oppval.CloseDate = System.Today() + 10;
                Oppval.CurrencyIsoCode = 'USD';
                Oppval.Brand_Name__c= 'RingCentral';
                Oppval.RecordTypeId = '01280000000UEtu';
                insert Oppval;
                 
                Quote q = new Quote();
                q.Name ='Test Name';
                q.OpportunityId = Oppval.Id;
                q.End_Date__c = system.today();
                q.Status = 'Draft';
                q.Start_Date__c = system.today()-5;
                q.Auto_Renewal__c = true;
                q.Term_months__c = '12';
                q.Status ='Active';
                insert q;
                
                Test.startTest();
                
                Account acctest11 = new Account();
                acctest11.Name='TestAccount11';
                acctest11.RC_Attribution_Channel__c = 'National Accounts';
                acctest11.RC_Attribution_Channel__c = 'Franchise & Assoc.';
                acctest11.Partner_Type__c = 'Franchisor';
                acctest11.Partner_ID__c ='123';
                acctest11.RecordTypeId  = '01280000000UERq';
                insert acctest11;
                
                Opportunity Oppval11 = new Opportunity();
                Oppval11.Name = 'Test Opp11';
                Oppval11.AccountId = acctest11.Id;
                Oppval11.Type = 'Existing Business';
                Oppval11.StageName = '3. ActivePipe';
                Oppval11.Sales_Model__c = 'Direct';
                Oppval11.CloseDate = System.Today() + 10;
                Oppval11.CurrencyIsoCode = 'USD';
                Oppval11.Brand_Name__c= 'RingCentral';
                Oppval11.RecordTypeId = '01280000000UEtu';
                insert Oppval11;
                 
                Quote q11 = new Quote();
                q11.Name ='Test Name11';
                q11.OpportunityId = Oppval11.Id;
                q11.End_Date__c = system.today();
                q11.Status = 'Draft';
                q11.Start_Date__c = system.today()-5;
                q11.Auto_Renewal__c = true;
                q11.Term_months__c = '12';
                q11.Status ='Active';
                insert q11;
                
                
                AccInfo acc = new AccInfo(new ApexPages.StandardController(acctest));
                acc.PopulateATM();
                Test.stopTest();
                
             
                                         
             /*   AccInfo acc1 = new AccInfo(new ApexPages.StandardController(acctest1));
                
                Account acctest2 = new Account();
                acctest2.Name='TestAccount';
                acctest2.RC_Attribution_Channel__c = 'National Accounts';
                acctest2.Partner_ID__c ='123';
                acctest2.RecordTypeId  = '01280000000UERv';
                insert acctest2;
                
                Opportunity Oppval2 = new Opportunity();
                Oppval2.Name = 'Test Opp';
                Oppval2.AccountId = acctest2.Id;
                Oppval2.Type = 'Existing Business';
                Oppval2.StageName = '3. ActivePipe';
                Oppval2.Sales_Model__c = 'Direct';
                Oppval2.CloseDate = System.Today() + 10;
                Oppval2.CurrencyIsoCode = 'USD';
                Oppval2.Brand_Name__c= 'RingCentral';
                Oppval2.RecordTypeId = '01280000000UEtu';
                insert Oppval2;
                 
                Quote q2 = new Quote();
                q2.Name ='Test Name';
                q2.OpportunityId = Oppval2.Id;
                q2.End_Date__c = system.today();
                q2.Status = 'Draft';
                q2.Start_Date__c = system.today()-5;
                q2.Auto_Renewal__c = true;
                q2.Term_months__c = 12;
                q2.Status ='Active';
                insert q2;
                                         
                AccInfo acc2 = new AccInfo(new ApexPages.StandardController(acctest2));
                
                acctest2.Partner_Type__c = 'Franchisor';
                update acctest2;
                
                AccInfo acc3 = new AccInfo(new ApexPages.StandardController(acctest2));
                
                Account acctest4 = new Account();
                acctest4.Name = 'TestAccount4';
                acctest4.RC_Attribution_Channel__c = 'National Accounts';
                acctest4.Partner_ID__c ='123';
                acctest4.RecordTypeId  = '01280000000UERq';
                acctest4.RC_Account_Status__c = 'Paid';
                acctest4.MRR__c = 0;
                acctest4.RC_SignUp_date__c = System.today();
                insert acctest4;
                
                AccInfo acc4 = new AccInfo(new ApexPages.StandardController(acctest4));*/
                
         
    }
}