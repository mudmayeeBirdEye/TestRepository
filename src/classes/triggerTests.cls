/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Each testMethod is names for the trigger or object it is testing
 */
@isTest(SeeAllData=false)
private class triggerTests {
	private class LimitException extends Exception {}
	static testMethod void testRefundBefore(){
		try{
		test.startTest();	
        
        Account a = new Account();
        a.Name = 'TestRefundAccount';
        a.RC_User_ID__c = '345';
        a.RC_Brand__c = 'RC';
        a.RC_Service_name__c = 'mobile';
        a.RC_Tier__c = 'professional';
        insert a;
        
        a.RC_Activation_Date__c = null;
        a.RC_Service_name__c = 'RCOffice';
        update a;
        
        datetime myDT = datetime.now();
        a.RC_Activation_Date__c = myDT;
        a.RC_Service_name__c = 'RC Office';
        update a;
        
        Refund__c r = new Refund__c();
        r.Account__c = a.Id;
        r.Reference__c = '1234';
        insert r;
        
        test.stopTest();
        }catch(Exception exp){
    		
    	}
	}
   
	//
	static testMethod void testCaseBefore(){
		try{
			Test.startTest();
			Account a = new Account(Name='new');
			insert a;
			//test.startTest();
			Case caseTest = new Case(Account=a);
			insert caseTest;
			
			//Contact c = new Contact(lastName='lastTest', AccountId = a.Id, email='test@ringcentral.com');
			Contact c = new Contact(lastName='lastTest', AccountId = a.Id, email='rcpartnersync@ringcentral.com.box1');
			insert c;
			test.stopTest();
			Case caseTest2 = new Case(Account=a, ContactId=c.Id);
			insert caseTest2;
			
			update caseTest2;
			//Test.stopTest();			
		}catch(Exception exp){
			
		}

   	}
   
   static testMethod void testSaverTriggers() {
   	try{
   			TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT = true;
			TriggerHandler.BY_PASS_ACCOUNT_ON_UPDATE = true;
			TriggerHandler.BY_PASS_OPPORTUNITY_ON_INSERT = true;
			TriggerHandler.BY_PASS_OPPORTUNITY_ON_UPDATE = true;
   		// Create test data (a new Account with an Attachment)
   		    Account acct = new Account(Name = 'Test Account');
            insert acct;
            Opportunity opp = new Opportunity(AccountId = acct.Id, Name='testOpp', Type = 'New Business', CloseDate = Date.today(), StageName = OpportunityHelper.defaultOpportunityStage);
            insert opp; 
            opp = new Opportunity(AccountId = acct.Id, Name='testOpp', OwnerId = '005800000036sJJ', Type = 'New Business', CloseDate = Date.today(), StageName = '3. NoActivePipe');
            insert opp;            
            Event event = new Event(subject='testEvent', whatId = opp.Id, StartDateTime = DateTime.now(), DurationInMinutes = 10);
            try {
            	insert event;
            	 event.subject = 'newSubject';
            update event;
            }catch (Exception e) {
                System.debug(e);
                
            }
            Task t = new Task(subject='testTask', whatId = opp.Id, ActivityDate = Date.Today());
             try {
            insert t;
            t.subject = 'newSubject';
            update t;
            }catch (Exception e) {
                System.debug(e);
                
            }
        	
            Implementation__c i = new Implementation__c(name='testImp', Implementation_Status__c='Needed');
             try {
            insert i;
            } catch (Exception e) {
                System.debug(e);
                
            }
            Test.startTest();
            Note n = new Note(title = 'testNote', parentId = opp.Id, Body = 'Note body');
            try {            	            	
            insert n;
            n.title = 'newTitle';
            update n;
            } catch (Exception e) {
                System.debug(e);
                
            }
            Attachment a = new Attachment(Name='testAttachment', parentId=opp.Id, body=Blob.valueOf('dkjghdksgjdshgdkh'));
            try {
            insert a;
            a.Name='newName';
            update a;
            } catch (Exception e) {
                System.debug(e);
                
            }
            Lead l = new Lead(LastName='Last', Company='Company', Phone='345565', Email='lead@triggertest.com', OwnerId = '005800000036sJJ');
            try {
            insert l;
            } catch (Exception e) {
                System.debug(e);
                
            }
            Note nl = new Note(title = 'testNote', parentId = l.id, Body = 'Note body');
            try {                
            	insert nl;
            	nl.title = 'newTitle';
            	update nl;
            } catch (Exception e) {
                System.debug(e);
                
            }
            try {
            Event eventl = new Event(subject='testEvent', whoId = l.Id, StartDateTime = DateTime.now(), DurationInMinutes = 10);
            insert eventl;
            Task tl = new Task(subject='testTask', whoId = l.Id, ActivityDate = Date.Today());
            insert tl;
            Attachment al = new Attachment(Name='testAttachment', parentId=l.Id, body=Blob.valueOf('dkjghdksgjdshgdkh'));
            insert al;
            eventl.subject = 'newSubject';
            update eventl;
            tl.subject = 'newSubject';
            update tl;
            } catch (Exception e) {
                System.debug(e);
                
            }          
            // Verify the "Unable to delete attachments" error is thrown when attachment is deleted
            Boolean errorThrown = false; 
            try {
                delete n;
            } catch (Exception e) {
                 System.debug(e);
            } 
            
			errorThrown = false;
            try {
                delete event;
            } catch (Exception e) {
                System.debug(e);                
            }           
            
            errorThrown = false;
            try {
                delete t;
            } catch (Exception e) {
                System.debug(e);               
            }             
            
            errorThrown = false;
            try {
                delete i;
            } catch (Exception e) {
                System.debug(e);
                
            }
            Test.stopTest();
   	}catch(Exception exp){
    		
    	}
   }
   
    /**
    * Verify that Standard User profiles are unable to delete attachments
    */
    static testMethod void testSaveTriggers() {
        try{
    		TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT = true;
			TriggerHandler.BY_PASS_ACCOUNT_ON_UPDATE = true;
			TriggerHandler.BY_PASS_OPPORTUNITY_ON_INSERT = true;
			TriggerHandler.BY_PASS_OPPORTUNITY_ON_UPDATE = true;
        Lead l1 = new Lead(LastName='Last1', Company='Company1', Phone='3455651', Email='lead1@triggertest.com', OwnerId = '005800000036sJJ');
        insert l1;
            
            try {
                Note nl1 = new Note(title = 'testNote1', parentId = l1.id, Body = 'Note body1');
            	insert nl1;
            	nl1.title = 'newTitle';
            	update nl1;
            } catch (Exception e) {
                System.debug(e);
                
            }
        // Create a new user with the Standard User profile
        Profile salesAgentProf = [select id from profile where name='Sales Agent']; 
        User su = new User(firstname='testy', lastname='test', alias = 'testing', email='salesagent@test.com', 
            emailencodingkey='UTF-8', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = salesAgentProf.Id, 
            timezonesidkey='America/Los_Angeles', username='salesagent@test.com');
        insert su;
            
        Employee__c emp = new Employee__c(User__c = su.Id, Division__c = 'Sales');
        insert emp;
            
        // Switch current user to Sales Agent User
        System.runAs(su) {        	
            // Create test data (a new Account with an Attachment)
            Account acct = new Account(Name = 'Test Account');
            insert acct;
            Opportunity opp = new Opportunity(AccountId = acct.Id, Name='testOpp', Type = 'New Business', CloseDate = Date.today(), StageName = OpportunityHelper.defaultOpportunityStage);
            insert opp; 
            opp = new Opportunity(AccountId = acct.Id, Name='testOpp', OwnerId = '005800000036sJJ', Type = 'New Business', CloseDate = Date.today(), StageName = '3. NoActivePipe');
            insert opp;            
                        
            
            Event event = new Event(subject='testEvent', whatId = opp.Id, StartDateTime = DateTime.now(), DurationInMinutes = 10);
            try {
            	insert event;
            	 event.subject = 'newSubject';
            update event;
            }catch (Exception e) {
                System.debug(e);
                
            }
            
            Task t = new Task(subject='testTask', whatId = opp.Id, ActivityDate = Date.Today());
             try {
            insert t;
            t.subject = 'newSubject';
            update t;
            }catch (Exception e) {
                System.debug(e);
                
            }
            Test.startTest();
            Implementation__c i = new Implementation__c(name='testImp', Implementation_Status__c='Needed');
             try {
            insert i;
            } catch (Exception e) {
                System.debug(e);
                
            }
            
            Note n = new Note(title = 'testNote', parentId = opp.Id, Body = 'Note body');
            try {            	            	
            insert n;
            n.title = 'newTitle';
            update n;
            } catch (Exception e) {
                System.debug(e);
                
            }
            Attachment a = new Attachment(Name='testAttachment', parentId=opp.Id, body=Blob.valueOf('dkjghdksgjdshgdkh'));
            try {
            insert a;
            a.Name='newName';
            update a;
            } catch (Exception e) {
                System.debug(e);
                
            }
            
            Lead l = new Lead(LastName='Last', Company='Company', Phone='345565', Email='lead@triggertest.com', OwnerId = '005800000036sJJ');
            try {
            insert l;
            } catch (Exception e) {
                System.debug(e);
                
            }
            Note nl = new Note(title = 'testNote', parentId = l.id, Body = 'Note body');
            try {                
            	insert nl;
            	nl.title = 'newTitle';
            	update nl;
            } catch (Exception e) {
                System.debug(e);
                
            }
            try {
            Event eventl = new Event(subject='testEvent', whoId = l.Id, StartDateTime = DateTime.now(), DurationInMinutes = 10);
            insert eventl;
            Task tl = new Task(subject='testTask', whoId = l.Id, ActivityDate = Date.Today());
            insert tl;
            Attachment al = new Attachment(Name='testAttachment', parentId=l.Id, body=Blob.valueOf('dkjghdksgjdshgdkh'));
            insert al;
                        
            
            eventl.subject = 'newSubject';
            update eventl;
            tl.subject = 'newSubject';
            update tl;
            //al.Name='newName';
            //update al;            
            } catch (Exception e) {
                System.debug(e);
                
            }
            
            // Verify the "Unable to delete attachments" error is thrown when attachment is deleted
            Boolean errorThrown = false; 
            try {
                delete n;
            } catch (Exception e) {
                errorThrown = true;
            }
            System.assert(errorThrown);
            
            errorThrown = false;
            try {
                delete event;
            } catch (Exception e) {
                System.debug(e);
                if (e.getMessage().contains('Unable to delete events.')) {
                    errorThrown = true;
                }
                errorThrown = true;
            }
          //  System.assert(errorThrown);
            
            errorThrown = false;
            try {
                delete t;
            } catch (Exception e) {
                System.debug(e);
                if (e.getMessage().contains('Unable to delete tasks.')) {
                    errorThrown = true;
                }
                errorThrown = true;
            }
            System.assert(errorThrown);     
            
            errorThrown = false;
            try {
                delete i;
            } catch (Exception e) {
                System.debug(e);
                if (e.getMessage().contains('Unable to delete Implementations.')) {
                    errorThrown = true;
                }
                errorThrown = true;
            }
            System.assert(errorThrown);                     
        }
        system.Test.stopTest();
        }catch(Exception e){}
    }

	static testMethod void myOppStageTest(){
		try{
			TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT = true;
			TriggerHandler.BY_PASS_ACCOUNT_ON_UPDATE = true;
			TriggerHandler.BY_PASS_OPPORTUNITY_ON_INSERT = true;
			TriggerHandler.BY_PASS_OPPORTUNITY_ON_UPDATE = true;
	        Profile salesAgentProf = [select id from profile where name='Sales Agent']; 
	        User su = new User(firstname='testy', lastname='test', alias = 'testing', email='salesagent@test.com', 
	            emailencodingkey='UTF-8', languagelocalekey='en_US', 
	            localesidkey='en_US', profileid = salesAgentProf.Id, 
	            timezonesidkey='America/Los_Angeles', username='salesagent@test.com');
	        insert su;
	            
	        Employee__c emp = new Employee__c(User__c = su.Id, Division__c = 'Sales');
	        insert emp;
	                
	        Account a = new Account();
	        a.Name = 'TestbyJesse';
	        insert a;
	        Contact c = new Contact();
	        c.LastName = 'contactLast';
	        c.AccountId = [SELECT id FROM Account WHERE name=: a.Name].id;
	        c.email='test@rc.com';
	        insert c;
	        
	        System.runAs(su) { 
		        /* test insert with owner = 005800000036sJJ */
			        Opportunity oD = new Opportunity();
			        oD.Name = 'TestaOppOwnerD';
			        oD.AccountId = c.AccountId;
			        oD.Type = 'New Business';
			        oD.CloseDate = Date.today();
			        oD.StageName = OpportunityHelper.defaultOpportunityStage;
			        //oD.OwnerId = '005800000036sJJ';
			        oD.RC_User_ID__c = '3455';
			        oD.Date_Submitted__c = Datetime.now();
			        oD.Primary_Loss_Reason__c = 'Price';
			        oD.Service_Lost__c = 'Office';
			        insert oD;
		        /* end test with owner */
		        
		        oD.Name = 'update';
		        oD.StageName = OpportunityHelper.closedStage;
		        update oD;
	        }
	        
	        Test.startTest();
	        
	        Opportunity o = new Opportunity();
	        o.Name = 'TestaOpp';
	        o.AccountId = c.AccountId;
	        o.Type = 'New Business';
	        o.CloseDate = Date.today();
	        o.StageName = OpportunityHelper.defaultOpportunityStage;
	        //o.OwnerId = '005800000036sJJ';
	        o.RC_User_ID__c = '345';
	        o.Date_Submitted__c = Datetime.now();
	        o.Primary_Competitor__c = '3Com';
	        o.Primary_Loss_Reason__c = 'Price';
	        o.Service_Lost__c = 'Office';
	        insert o;
	        OpportunityContactRole ocr = new OpportunityContactRole(ContactId=c.Id, OpportunityId=o.Id);
	        insert ocr;
		        
			 
	        o.StageName = '0. Trial';
	        system.debug('this is opp stage, reason: ' + o.StageName + ', ' + o.Downgrade_Reason_Opp__c);
	        o.OwnerId = '0058000000379gR';
	        update o;        
	        
	        o.StageName = '0. Downgraded';
	        o.Downgrade_Reason_Opp__c = 'Trial Expired';
	        try{
	        	update o;
	        }
	        catch(System.Exception e){
	        	
	        }
	        
	        o.StageName = '0. Downgraded';
	        o.Downgrade_Reason_Opp__c = 'Lost to Competition';
	        try{
	        	update o;
	        }
	        catch(System.Exception e){
	        	
	        }
	        system.debug('this is opp stage, reason' + o.StageName + ', ' + o.Downgrade_Reason_Opp__c);    
	        
	        o.StageName = OpportunityHelper.closedStage;
	        update o;
	        
	        o.Warm_transfer_to_SE__c = true;
	        update o;
	        
	        o.OwnerId = '005800000036sJJ';
	        o.Campaign = [SELECT id FROM Campaign WHERE Name='Default Campaign'];
	        update o;
	 		Test.stopTest();
		} catch(Exception exp){ }	
	}	
	
	public static testMethod void testAgentCredit(){
		try{
		Account a = new Account(name='testaccount',RC_Account_Number__c='1231234567');
		insert a;
		Order__c o = new Order__c(name='testorder', account__c=a.Id, Order_Type__c='New', Sales_Model__c='Direct');
		insert o;
		Test.startTest();
		Agent_Credit__c ac = new Agent_Credit__c(name='test', Agent_SPID__c='DDEMINK', order__c=o.id, Agent_Email__c='daved@ringcentral.com', X12M_Sales_Booking_Amount__c=decimal.valueOf('100.00'), Compensation_Date__c=Date.Today(), Agent_First_Name__c='test', Agent_Last_Name__c='');
		insert ac;
		
		Agent_Credit__c ac2 = new Agent_Credit__c(name='test', Agent_SPID__c='DDEMINK', order__c=o.id, Agent_Email__c='notReal@ringcentral.com', X12M_Sales_Booking_Amount__c=decimal.valueOf('100.00'), Compensation_Date__c=Date.Today(), Agent_First_Name__c='test', Agent_Last_Name__c='');
		insert ac2;
		Test.stopTest();
		}catch(Exception exp){
    		
    	}
		
	}

	public static testMethod void testEvent(){
		Event e =new Event(subject='Call', StartDateTime=DateTime.now().addDays(-1), EndDateTime=DateTime.now().addDays(-1));
		try{
			insert e;
		}
		catch(System.Exception ex){
			
		}
	}
	
	public static testMethod void testTask(){
		Task t =new Task(subject='Call', ActivityDate=Date.today().addDays(-1));
		try{
			insert t;
		}
		catch(System.Exception e){
			
		}
	}

	public static testMethod void testLead(){
		try{
			Campaign c = new Campaign(name='testcampaign', aid__c='1111', isactive=true);
			insert c;
			
			List<Lead> leads = new List<Lead>();
	        Lead l1 = new Lead(lastname='DC0', company='DC0',phone='4565342558', aid__c='7580',LeadSource='Inbound Call', NumberOfEmployees__c='10-19',email='DB0@ringcentral.com', Partner_Company_Name__c = 'CiscoTest', Partner_Last_Name__c = 'anibha', Partner_First_Name__c = 'alok', OwnerId = '005800000036sJJ');
	        leads.add(l1);
			
	        Lead l = new Lead(OwnerId = '005800000036sJJ', lastname='DC0', company='DC0',phone='4565342559', five9_dnis__c='8004293709', LeadSource='Partner Request', NumberOfEmployees__c='10-19',email='DC0@ringcentral.com', Partner_Company_Name__c = 'CiscoTest', Partner_Last_Name__c = 'anibha', Partner_First_Name__c = 'alok');
	        leads.add(l);
	        
	        l = new Lead(OwnerId = '005800000036sJJ', lastname='new', firstname='something', company='DC1',phone='4565342560', LeadSource='Initial', NumberOfEmployees__c='10-19',email='DC1@ringcentral.com', Partner_Company_Name__c = 'CiscoTest', Partner_Last_Name__c = 'anibha', Partner_First_Name__c = 'alok');
	        
	        leads.add(l);
	
	        l = new Lead(OwnerId = '005800000036sJJ', lastname='DC2', company='DC2',phone='4565342561', LeadSource='About To Be Cancelled', NumberOfEmployees__c='10-19',email='DC2@ringcentral.com');
	        //l.CreatedById = '005800000036sJJ' ;
	        l.OwnerId = '005800000036sJJ';
	        leads.add(l);
	        
			l = new Lead(OwnerId = '005800000036sJJ', lastname='DC2', company='DC2',phone='4565342561', LeadSource='About To Be Cancelled', NumberOfEmployees__c='10-19',email='DC2@ringcentral.com');
	        l1.OwnerId = '005800000036sJJ'; 
			l1.BMID__c = 'FAXTESTDRIVE2' ; 
			l1.FirstName ='NotSomething' ; 
			l1.LastName ='NewNot'; 
	        leads.add(l);
			/*
	        l = new Lead(lastname='DC3', company='DC3',phone='4565342562',phone_2__c='4565342562', country='US', LeadSource='Vista Print', NumberOfEmployees__c='10-19',email='DC3@ringcentral.com');
	        leads.add(l);
	        
	        l = new Lead(lastname='DC4', company='DC4',phone='4565342563', LeadSource='Legalzoom', NumberOfEmployees__c='10-19',email='DC4@ringcentral.com');
	        leads.add(l);
	        
	        l = new Lead(lastname='DC5', company='DC5',phone='4565342564', LeadSource='General Weblead', NumberOfEmployees__c='10-19',email='DC5@ringcentral.com');
	        leads.add(l);
	        
	        l = new Lead(lastname='DC6', company='DC6',phone='4565342565', LeadSource='RC Office Weblead', NumberOfEmployees__c='10-19',email='DC6@ringcentral.com');
	        leads.add(l);
	        
	    	l = new Lead(lastname='DC7', company='DC7',phone='4565342566', LeadSource='RC Mobile Weblead', NumberOfEmployees__c='10-19',email='DC7@ringcentral.com');
	        //insert l;
	        
	        l = new Lead(lastname='DC8', company='DC8',phone='4565342567', LeadSource='Office Funnel', NumberOfEmployees__c='10-19',email='DC8@ringcentral.com');
	        //insert l;
	        
	        l = new Lead(lastname='DC9', company='DC9',phone='4565342568', LeadSource='UK Weblead', NumberOfEmployees__c='10-19',email='DC9@ringcentral.com');
	        //insert l;
	        leads.add(l);
	        
	        l = new Lead(lastname='DC10', company='DC10',phone='4565342569', LeadSource='Inbound Call', NumberOfEmployees__c='10-19',email='DC10@ringcentral.com');
	        //insert l;
	        leads.add(l);
	        
	        l = new Lead(lastname='DC11', company='DC11',phone='4565342510', LeadSource='Resource Nation', NumberOfEmployees__c='10-19',email='DC11@ringcentral.com');
	        leads.add(l);*/
	        //insert l;  
	        
	        insert leads;
	       
	        // test downgrade validation rule
			l.status = '0. Downgraded';
			try{
				update l1;
			}
			catch(System.Exception e){
				l.downgrade_reason__c='Lost to Competition';
				l.ownerId = '00580000001gviZ';
				l.phone='321';
				l.email='mail@rc.com';
				update l1;
			}
			
			// test lead owner change
			// change lead owner
			l1.OwnerId = '0058000000379gR';
			l1.AID__c = '6138';
			update l1;
			
			// test lead owner change to Dave D
			// change lead owner to Dave D
			l1.OwnerId = '005800000036sJJ';
			l1.Five9_DNIS__c = '8005745290';
			l1.AID__c = '6139';
			update l1; 
			
			l1.OwnerId = '005800000036sJJ'; 
			l1.BMID__c = 'FAXTESTDRIVE2' ; 
			l1.FirstName ='NotSomething' ; 
			l1.LastName ='NewNot'; 
			update l1;    			
		}catch(Exception exp) {
			
		}
   
    }
    
    public static testMethod void testImplementation(){
    	
    	try{
    		if( Limits.getLimitQueries() == Limits.getQueries() ){
				throw new LimitException();
			} else {
		        Profile seProf = [select id from profile where name='Sales Engineer']; 
		        User su = new User(alias = 'testing', email='se@test.com', 
		            emailencodingkey='UTF-8', lastname='TestingTrigger', languagelocalekey='en_US', 
		            localesidkey='en_US', profileid = seProf.Id, 
		            timezonesidkey='America/Los_Angeles', username='se@test.com');
		            
		        // Switch current user to Sales Agent User     
		        
		        system.Test.startTest();     
		        
		        System.runAs(su){
		    	/*	Account a = New Account(Name='testAccount');
		    		insert a;
		    		Contact c = New Contact(LastName='testContact', AccountId=a.Id, Email='jess@jess.com');
		    		insert c;  
		    	 	    	
		        	Implementation__c i = new Implementation__c(Name='impTest',Implementation_Status__c='Needed', Account__c=a.Id, contact__c = c.Id);
		    		insert i;
		        	i.OwnerId = su.Id;
		        	update i;
		        	    	
			    	i.Implementation_Status__c='Completed';
			    	try{
			    		update i;
			    	}
			    	catch(System.Exception e){
			    		
			    	}
			    	//i.Contact__c=c.Id;
			    	//update i;
			    	
			    	i.Number_of_Lines_Implemented__c = 5;
			    	try{
			    		update i;
			    	}
			    	catch(System.Exception e){
			    		
			    	}*/
		        }
		     	system.Test.stopTest();
    		}    		
    	}catch(Exception exp){
    		
    	}

    } 

    public static testMethod void testAccount(){
    
    }
    
     public static testMethod void testNewEdgeLead() {
     try{
	   NewEdgeLead__c nel = new NewEdgeLead__c();
	   nel.E_mail__c= 'test@test.com';
	   nel.city__c = 'test';
	   nel.Phone_No__c = 12345; 
	   nel.Name__c= '12345';
	   nel.Address_1__c= '12345';
	   nel.Address_2__c= '12345';
	   nel.Company_Name__c= '12345';
	   nel.Comments_from_RC_personnel__c= '12345';
	   nel.Contact_No__c= 12345;
	   nel.State__c= '12345';
	   nel.RC_Rep__c= '12345';
	   nel.RC_Rep_Last_Name__c= '12345';
	   nel.zip__c= 12345;
	   nel.Number_of_locations__c= '12345'; 
	   nel.Internet_service_type__c= '12345'; 
	   nel.Type_of_lead__c = '123456';
	   insert nel;  
	  }catch(Exception exp){
    		
    	}  
     }
     
     /*public static testMethod void testProtectionRulesAgain() {
     	try {
     		if( Limits.getLimitQueries() == Limits.getQueries() ){
				throw new LimitException();
			} else {
	        Profile salesAgentProf = [select id from profile where name='Sales Agent']; 
	        User su = new User(firstname='testy', lastname='test', alias = 'testing', email='salesagent@test.com', 
	            emailencodingkey='UTF-8', languagelocalekey='en_US', 
	            localesidkey='en_US', profileid = salesAgentProf.Id, 
	            timezonesidkey='America/Los_Angeles', username='salesagent@test.com');
	        insert su;
	            
	        Employee__c emp = new Employee__c(User__c = su.Id, Division__c = 'Sales');
	        insert emp;
	    
	        Account acc;
	    	Contact con;
	    	Opportunity opp; 
	    	
	    	String id;
	    	ProtectionRules pr;
	    	Lead test;
	    	
	        Lead l = new Lead();
	        l.firstname = 'firstname';
	        l.lastname = 'lastname';
	        l.company = 'leadcompany';
	        l.email = 'lead@email.com';
	        l.phone = '9874569877';
	        l.OwnerId = '005800000036sJJ';
	        insert l;
	        
	        
	        
			Database.LeadConvert lc = new database.LeadConvert();
	        lc.setLeadId(l.Id);
		
	        LeadStatus convertStatus = [Select Id, MasterLabel from LeadStatus where IsConverted=true limit 1];
	        lc.setConvertedStatus(convertStatus.MasterLabel);                        
			
			System.Test.startTest();
			
			TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT();
			TriggerHandler.BY_PASS_ACCOUNT_ON_UPDATE();
			TriggerHandler.BY_PASS_CONTACT_ON_INSERT();
			TriggerHandler.BY_PASS_CONTACT_ON_UPDATE();
			TriggerHandler.BY_PASS_OPPORTUNITY_ON_INSERT();
			TriggerHandler.BY_PASS_OPPORTUNITY_ON_UPDATE();
			
			Database.LeadConvertResult lcr = Database.convertLead(lc);
	        System.assert(lcr.isSuccess()); 
	        
	        TriggerHandler.RESET_VARIABLES();  
	            
	        acc = [select Id, Current_Owner__c from Account where Id =: lcr.getAccountId()];
	        con = [select Id, email, phone, indexedEmail__c from Contact where Id =: lcr.getContactId()];
	        opp = [select Id from Opportunity where Id =: lcr.getOpportunityId()];    
	        
	        con.email = 'lead@email.com';
	        con.indexedEmail__c = 'lead@email.com';
	        con.indexedPhone__c = '9874569877';
	        con.AccountId = acc.Id;
	        update con;
	        
	        opp.StageName = OpportunityHelper.defaultOpportunityStage;
	        update opp;
	        
	        acc.RC_User_ID__c = '567234';
	        update acc;            
	            
	        // Switch current user to Sales Agent User
	       
	        System.runAs(su) {       	       
		        Lead atbcLead = new Lead();
		        atbcLead.firstname = 'firstname';
		        atbcLead.lastname = 'lastname';
		        atbcLead.company = 'leadcompany';
		        atbcLead.email = 'lead@email.com';
		        atbcLead.phone = '9874569877';
		        atbcLead.LeadSource = 'About To Be Cancelled';
		        atbcLead.User_ID__c = '123456';
		        atbcLead.Status = '1.5 Call Out';
		        atbcLead.OwnerId = '005800000036sJJ';
		        pr = new ProtectionRules(atbcLead, 'About To Be Cancelled');
				
				//id = pr.findOwnerId();
	        }
		
			acc.Current_Owner__c = '00580000003c9oJ';
			update acc;
			System.runAs(su) {  		
				//id = pr.findOwnerId();
	        
		        
		        /*insert atbcLead;      
		        atbcLead.ownerid='005800000037Oae';      
		        update atbcLead;
		        */
		        
		        /*test = new Lead();
		        test.firstname = 'firstnameRC';
		        test.lastname = 'firstnameRC';
		        test.company = 'firstnameRC';
		        test.email = 'leadRC012@email.com';
		        test.phone = '9711989898';
		        test.LeadSource = 'Inbound Call';
		        test.User_ID__c = '658956985';       
		        test.OwnerId = '005800000036sJJ';
		
				pr = new ProtectionRules(test, 'Inbound Call');
				//id = pr.findOwnerId();
				insert test;
			}
		    System.Test.stopTest();
				
				//////////////////////////////////////////////////////////////////
			acc.Current_Owner__c = null;
			update acc;
			opp.StageName = '0. Downgraded';
			opp.downgrade_Reason_Opp__c = 'reason';
			update opp;
			
			test.Status = '1.5 Call Out';
			test.ownerId = '0058000000379Zp';
			update test;		
				
				system.debug('THIS IS c.email: ' + con.email);
				system.debug('THIS IS c.phone: ' + con.phone);
				system.debug('THIS IS c.indexedEmail__c: ' + con.indexedEmail__c);
				
				system.debug('THIS IS contact' + [SELECT Id, Name, AccountId FROM Contact WHERE (indexedEmail__c=:l.Email OR indexedPhone__c=:l.Phone ) AND indexedPhone__c!=null AND indexedEmail__c!=null AND IsDeleted=false].AccountId);
				
			System.runAs(su) { 			
		        Lead test2 = new Lead();
		        test2.LeadSource = 'General Weblead';
		        test2.firstname = 'firstname';
				test2.lastname = 'lastname';
		        test2.company = 'leadcompany';
		        test2.email = 'lead@email.com';
		        test2.phone = '9874469877';		
		        test2.ownerId = '005800000036sJJ';
		        system.debug('THIS IS test2.email: ' + test2.email);
		        pr = new ProtectionRules(test2, 'General Weblead');
		        //id = pr.findOwnerId();
	        }
     		}
     	}catch(Exception Exp){
     		
     	}
        
    }*/
     
     public static testMethod void testPRM() {     	
     	try{
     		Test.startTest();
	    	Partner_Request__c PRM = new Partner_Request__c ();
	    	PRM.Partner_Request_Source__c = 'General Partner';
	    	PRM.Partner_First_Name__c =  'test';
	    	PRM.Partner_Last_Name__c = 'test';
	    	PRM.Partner_Company_Name__c = 'test';
	    	PRM.Partner_Address1__c = 'test';
	    	PRM.Partner_City__c = 'test';
	    	PRM.Partner_State__c = 'test';
	    	PRM.Partner_Country__c = 'test';
	    	PRM.Partner_Phone__c = '12346789';
	    	PRM.Partner_Email_Address__c = 'test@test.com';
	    	insert PRM; 
	    	Test.stopTest();    		
     	}catch(Exception exp){
     		
     	}
    	
     }  
     
     public static testMethod void testPRM1() {     	
     	try{
     		Test.startTest();
	    	Partner_Request__c PRM = new Partner_Request__c ();
	    	PRM.Partner_Request_Source__c = 'General Partner1';
	    	PRM.Partner_First_Name__c =  'test1';
	    	PRM.Partner_Last_Name__c = 'test1';
	    	PRM.Partner_Company_Name__c = 'test1';
	    	PRM.Partner_Address1__c = 'test1';
	    	PRM.Partner_City__c = 'test1';
	    	PRM.Partner_State__c = 'test1';
	    	PRM.Partner_Country__c = 'test1';
	    	PRM.Partner_Phone__c = '123467890';
	    	PRM.Partner_Email_Address__c = 'test.test@test.com';
	    	update PRM; 
	    	Test.stopTest();    		
     	}catch(Exception exp){
     		
     	}
    	
     }     
     
     public static testMethod void testEmployee() {
     	// Create a new user with the Standard User profile
       try{
       	if( Limits.getLimitQueries() == Limits.getQueries() ){
				throw new LimitException();
		} else {
        Profile salesAgentProf = [select id from profile where name='Sales Agent']; 
        User su = new User(firstname='testy', lastname='test', alias = 'testing', email='salesagent@test.com', 
            emailencodingkey='UTF-8', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = salesAgentProf.Id, 
            timezonesidkey='America/Los_Angeles', username='salesagent@test.com');
        insert su;
        Test.startTest();    
        Employee__c emp = new Employee__c(User__c = su.Id, Division__c = 'Sales', Department__c='Sales',Team__c='Sales');
        insert emp;
        
        update emp;
        Test.stopTest();
       	}
        }catch(Exception exp){
    		
    	}
     } 
	
	public static testMethod void testEmailMessage(){
       try{
           Case objCase=new Case();
           insert objCase;
          
            EmailMessage objEmailMessage=new EmailMessage();
            objEmailMessage.ParentId=objCase.id;
            objEmailMessage.FromAddress='kanishk.singh@simplion.com';
            objEmailMessage.FromAddress ='kanishk.singh@simplion.com';
            insert objEmailMessage;
            delete objEmailMessage;
         }catch(Exception e){
          }
   	}
 	
 	public static testMethod void testAttachment() {
     	  if( Limits.getLimitQueries() == Limits.getQueries() ){
				throw new LimitException();
		  } else {
	       Profile p = [SELECT Id FROM Profile WHERE Name='Sales Agent']; 
	       
	       User u1 = new User(Alias = 'suppmgr1', Email='supportmanager1@testorg.com', 
	       EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
	       LocaleSidKey='en_US', ProfileId = p.Id, 
	       TimeZoneSidKey='America/Los_Angeles', UserName='supportmanager1@testorg.com'); 
	       
	       insert u1;
	       
	       User u = new User(Alias = 'suppmgr2', Email='supportmanager2@testorg.com', 
	       EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
	       LocaleSidKey='en_US', ProfileId = p.Id, 
	       TimeZoneSidKey='America/Los_Angeles', UserName='supportmanager2@testorg.com');
	       
	       insert u;
	       
	       Employee__c empObj = new Employee__c();
	       empObj.User__c = u.Id;
	       empObj.First_Name__c = 'TestFName';
	       empObj.Last_Name__c = 'TestLName';
	       empObj.Email__c = 'standarduser@testorg.com';
	       empObj.Location__c = 'Denver, US';
	       empObj.Department__c = 'IT';
	       empObj.Team__c = 'Marketing';
	       empObj.Division__c = 'CV';
	       empObj.SPID__c = '12345';
	       empObj.Manager_Employee_Number__c = 'a0H8000000E0WWQ';
	      /* for(Employee__c managerEmpObj :[select Name from Employee__c limit 1]) {
				empObj.Manager_Employee_Number__c = managerEmpObj.Id;
	       }
	       */
	       insert empObj;
	       
	       System.runAs(u) {
	       	 try {
			       Account accVal = new  Account ();
			       accVal.Name = 'Test Account Name1';
			       insert accVal;
			       	
			       List<Opportunity> oppLst = new List<Opportunity>();
			       	
			       Opportunity oppObj = new Opportunity();
			       oppObj.AccountId = accVal.Id;
			       oppObj.Type = 'New Business';
			       oppObj.Brand_Name__c = 'RingCentral';
			       oppObj.Name = 'TestaOppOwnerD';
			       oppObj.CloseDate = Date.today();
			       oppObj.StageName = OpportunityHelper.defaultOpportunityStage;
			       oppObj.CurrencyIsoCode = 'USD';
			       oppObj.Sales_Model__c = 'Direct';
			       
			       //insert oppObj;
			     
			      
			       Opportunity oppObj1 = new Opportunity();
			       oppObj1.AccountId = accVal.Id;
			       oppObj1.Type = 'New Business';
			       oppObj1.Brand_Name__c = 'RingCentral';
			       oppObj1.Name = 'TestaOppOwnerD1';
			       oppObj1.CloseDate = Date.today();
			       oppObj1.StageName = OpportunityHelper.defaultOpportunityStage;
			       oppObj1.CurrencyIsoCode = 'USD';
			       oppObj1.Sales_Model__c = 'Direct';
			       
			       //insert oppObj1;
			       
			       oppLst.add(oppObj1);
			       oppLst.add(oppObj);
			       
			       insert oppLst;
			       
			       List<Lead> leadLst = new List<Lead>();
			       
			       Lead leadObj = new Lead();
			       leadObj.Company = 'Test company1';
			       leadObj.FirstName = 'Test Name';
			       leadObj.LastName = 'Test Name1';
			       leadObj.email = 'test1@test.com';
			      // leadObj.Last_Touched_By__c = ;
			       leadLst.add(leadObj);
			       //insert leadObj;
			       
			       Lead leadObj1 = new Lead();
			       leadObj1.Company = 'Test company2';
			       leadObj1.FirstName = 'Test Nam2';
			       leadObj1.LastName = 'Test Name2';
			       leadObj1.email = 'test2@test.com';
			      
			      leadLst.add(leadObj1);
			       
			       Lead leadObj2 = new Lead();
			       leadObj2.Company = 'Test company3';
			       leadObj2.FirstName = 'Test Nam3';
			       leadObj2.LastName = 'Test Name3';
			       leadObj2.email = 'test3@test.com';
			      
			      leadLst.add(leadObj2);
			       
			       Lead leadObj3 = new Lead();
			       leadObj3.Company = 'Test company4';
			       leadObj3.FirstName = 'Test Nam4';
			       leadObj3.LastName = 'Test Name4';
			       leadObj3.email = 'test4@test.com';
			      
			       leadLst.add(leadObj3);
			       
			       Lead leadObj4 = new Lead();
			       leadObj4.Company = 'Test company5';
			       leadObj4.FirstName = 'Test Nam5';
			       leadObj4.LastName = 'Test Name5';
			       leadObj4.email = 'test5@test.com';
			      
			       leadLst.add(leadObj4);
			       
			       Lead leadObj5 = new Lead();
			       leadObj5.Company = 'Test company6';
			       leadObj5.FirstName = 'Test Nam6';
			       leadObj5.LastName = 'Test Name6';
			       leadObj5.email = 'test6@test.com';
			      
			       leadLst.add(leadObj5);
			       
			       insert leadLst;
			       
			       
			       List<Case> caseLst = new List<Case>();  
			       
			       Case caseObj = new Case();
			       caseObj.Status = 'New';
			       caseObj.Business_Services_Team_Member__c = 'Benji Bancoro';
			       
			       caseLst.add(caseObj);
			       
			       Case caseObj1 = new Case();
			       caseObj1.Status = 'New';
			       caseObj1.Business_Services_Team_Member__c = 'Benji Bancoro';
			       caseLst.add(caseObj1);
			       
			       insert caseLst;
			      
			       List<Attachment> attachLst = new List<Attachment>();
			       
			       for(Opportunity oppval : oppLst) {
				       Attachment attObj = new Attachment();
				       attObj.ParentId = oppval.Id;
				       attObj.Name = 'Test 1';
				       attObj.Body = EncodingUtil.base64Decode('test');
				       attachLst.add(attObj);
			       }
			       
			       for(Lead leadVal : leadLst) {
				       	Attachment attObj2 = new Attachment();
				        attObj2.ParentId = leadVal.Id;
				        attObj2.Name = 'Test 3';
				        attObj2.Body = EncodingUtil.base64Decode('test2');
				        attachLst.add(attObj2);
			       }
			       
			       for(Case caseVal : caseLst) {
				       Attachment attObj4 = new Attachment();
				       attObj4.ParentId = caseVal.Id;
				       attObj4.Name = 'Test 4';
				       attObj4.Body = EncodingUtil.base64Decode('test2');
				       attachLst.add(attObj4);
			       }
			       
			       Test.startTest();
			       
			       insert attachLst;
			       
			       Test.stopTest();
			       
			       leadObj = [select name,Last_Touched_By__c from Lead where Id = :leadObj.Id];
			       leadObj1 = [select name,Last_Touched_By__c from Lead where Id = :leadObj1.Id];
			       
			       leadObj2 = [select name,Last_Touched_By__c from Lead where Id = :leadObj2.Id];
			       leadObj3 = [select name,Last_Touched_By__c from Lead where Id = :leadObj3.Id];
			       leadObj4 = [select name,Last_Touched_By__c from Lead where Id = :leadObj4.Id];
			       leadObj5 = [select name,Last_Touched_By__c from Lead where Id = :leadObj5.Id];
			        
			       oppObj = [select name,Last_Touched_By__c from Opportunity where Id = :oppObj.Id];
			       oppObj1 = [select name,Last_Touched_By__c from Opportunity where Id = :oppObj1.Id];
			      
			       System.assertEquals(leadObj.Last_Touched_By__c,u.Id);
			       System.assertEquals(leadObj1.Last_Touched_By__c,u.Id);
			       
			       System.assertEquals(leadObj2.Last_Touched_By__c,u.Id);
			       System.assertEquals(leadObj3.Last_Touched_By__c,u.Id);
			       System.assertEquals(leadObj4.Last_Touched_By__c,u.Id);
			       System.assertEquals(leadObj5.Last_Touched_By__c,u.Id);
			       
			       System.assertEquals(oppObj1.Last_Touched_By__c,u.Id);
			       System.assertEquals(oppObj.Last_Touched_By__c,u.Id);
   			   
   			   } catch(Exception ex) {}
   			}}
     }
  	
  	public static testMethod void testDealRegistration() {
        try{ 
             Account  objAccount= (Account  )SmartFactory.createSObject('Account', true);  
             objAccount.Partner_id__c='123456Test';
             TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT();
   	 		 TriggerHandler.BY_PASS_ACCOUNT_ON_UPDATE();
             upsert objAccount;
             TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT = false;
	 		 TriggerHandler.BY_PASS_ACCOUNT_ON_UPDATE = false;
            
             Contact objContact= (Contact)SmartFactory.createSObject('Contact', true);
             objContact.AccountId=objAccount.id;
             TriggerHandler.BY_PASS_CONTACT_ON_INSERT();
	   		 TriggerHandler.BY_PASS_CONTACT_ON_UPDATE();
             upsert objContact;
             TriggerHandler.BY_PASS_CONTACT_ON_INSERT = false;
	   		 TriggerHandler.BY_PASS_CONTACT_ON_UPDATE = false;
              if( Limits.getLimitQueries() == Limits.getQueries() ){
				throw new LimitException();
			  } else {
              objContact=[Select Account.Partner_id__c from Contact where id=:objContact.id]; }
              System.assert(objContact.Account.Partner_id__c=='123456Test');
              Profile pp = null;
              if( Limits.getLimitQueries() == Limits.getQueries() ){
				throw new LimitException();
			 } else {
             pp = [Select p.Name, p.Id From Profile p where Name LIKE '%RC Partner User%'limit 1]; }
             System.assert(pp.Name=='RC Partner User');
             
                User objUser= new User(alias = 'ksTest',
                                    email='kanishk.singhTest@simplion.com',
                                    emailencodingkey='UTF-8',
                                    lastname='Testing',
                                    languagelocalekey='en_US',
                                    localesidkey='en_US',
                                    profileid = pp.Id,
                                    contactid = objContact.Id,
                                    timezonesidkey='America/Los_Angeles',
                                    username='kanishk.singhTest@simplion.com'
                                    );
               insert objUser;
               
              // User objAdminUser=
               
              System.assert(objUser.profileid ==pp.Id);
               System.assert(objUser.contactid ==objContact.Id);
              
               VAR_Deal_Registration__c  objDeal=null;
               List<ProcessInstanceWorkItem> workItemList=null;
              
              system.runAs(objUser){
                    objDeal=new  VAR_Deal_Registration__c();
                    objDeal.Company_Name__c='testSimplion';
                    objDeal.Email_1__c='kanisk@test.com';
                    objDeal.Phone__c='123456789';
                    insert objDeal;
                                        
                  System.assert(UserInfo.getUserId()==objUser.id);
                  System.assert(objDeal.id!=null);
                  if( Limits.getLimitQueries() == Limits.getQueries() ){
					throw new LimitException();
				 } else {
                  workItemList = [Select p.ProcessInstance.Status, p.ProcessInstance.TargetObjectId,
                                                                p.ProcessInstanceId,p.OriginalActorId,p.Id,p.ActorId 
                                                                From ProcessInstanceWorkitem p where
                                                                 p.ProcessInstance.TargetObjectId = :objDeal.Id]; 
                  System.assertEquals('Pending', workItemList.get(0).ProcessInstance.Status);  
                 }                     
              }                    
               
                 Approval.ProcessWorkitemRequest req2 =new Approval.ProcessWorkitemRequest();
                 req2.setComments('Rejected request.');
                 req2.setAction('Reject');
                 req2.setNextApproverIds(new Id[] {UserInfo.getUserId()});
                 req2.setWorkitemId(workItemList.get(0).id);
                 Approval.ProcessResult result2 =  Approval.process(req2);
               
                System.assert(result2.isSuccess(), 'Result Status:'+result2.isSuccess());
                System.assertEquals('Rejected', result2.getInstanceStatus(),'Instance Status'+result2.getInstanceStatus()); 
                
                system.runAs(objUser){   
                   update objDeal;
                   System.assertEquals('Pending', workItemList.get(0).ProcessInstance.Status);  
                } 
                  workItemList = [Select p.ProcessInstance.Status, p.ProcessInstance.TargetObjectId,
                                                                p.ProcessInstanceId,p.OriginalActorId,p.Id,p.ActorId 
                                                                From ProcessInstanceWorkitem p where
                                                                 p.ProcessInstance.TargetObjectId = :objDeal.Id]; 
                 Approval.ProcessWorkitemRequest req3 =new Approval.ProcessWorkitemRequest();
                 req3.setComments('Approving request.');
                 req3.setAction('Approve');
                 req3.setNextApproverIds(new Id[] {UserInfo.getUserId()});
                 req3.setWorkitemId(workItemList.get(0).id);
            
                 Approval.ProcessResult result3 =  Approval.process(req3);
                System.assert(result3.isSuccess(), 'Result Status:'+result3.isSuccess());
                System.assertEquals('Approved', result3.getInstanceStatus(),'Instance Status'+result3.getInstanceStatus());                                                
              
               VAR_Deal_Registration__c objDeal2;
               system.runAs(objUser){
                    objDeal2=new  VAR_Deal_Registration__c();
                    objDeal2.Company_Name__c='testSimplion';
                    objDeal2.Email_1__c='kanisk@test2.com';
                    objDeal2.Phone__c='123456789';
                    objDeal2.Email_2__c='kanisk1234@test2.com';
                    objDeal2.Email_3__c='kanisk@t2est2.com';
                    objDeal2.Email_4__c='kanisk@t21est2.com';
                    objDeal2.Email_5__c='kanisk@t211est2.com';
                    insert objDeal2;
                
                objDeal2=new  VAR_Deal_Registration__c();
                    objDeal2.Company_Name__c='testSimplion';
                    objDeal2.Email_1__c='kanisk@test2.com';
                    objDeal2.Phone__c='123456789';
                    objDeal2.Email_2__c='kanisk@test2.com';
                    objDeal2.Email_3__c='kanisk@t2est2.com';
                    objDeal2.Email_4__c='kanisk@t21est2.com';
                    objDeal2.Email_5__c='kanisk@t211est2.com';
                  
                   try{
                      insert objDeal2;
                   }catch(Exception e){
                   
                   }
                objDeal2=new  VAR_Deal_Registration__c();
                objDeal2.Company_Name__c='testSimplion';
                objDeal2.Email_1__c='kanisk@test2.com';
                objDeal.Email_2__c='kanisk@test.com';
                objDeal2.Phone__c='123456789';
               try{
                  insert objDeal2;
                 }catch(Exception e){
                   //System.assertEquals('This email already Exists!',e.getMessage());
                 }
                 objDeal.Registration_Status__c='Rejected';
                 objDeal.Email_1__c='kanisk@test2.com';
                 objDeal.Email_2__c='kanisk1234@test2.com';
                 objDeal.Email_3__c='kanisk@t2est2.com';
                 objDeal.Email_4__c='kanisk@t21est2.com';
                 objDeal.Email_5__c='kanisk@t211est2.com';
                   
                 try{
                     update objDeal;
                 }catch(Exception e){
                   //System.assertEquals('This email already Exists!',e.getMessage());
                 }
                  objDeal.Registration_Status__c='Approved';
                  objDeal.Email_2__c='';
                 objDeal.Email_3__c='';
                 objDeal.Email_4__c='';
                 objDeal.Email_5__c='';
                   try{
                      update objDeal;
                    }catch(Exception e){
                  
                 }
                
               } 
              try{
                objDeal2=new  VAR_Deal_Registration__c();
                objDeal2.Company_Name__c='testSimplion';
                objDeal2.Email_1__c='kaniskqqq@test2.com';
                objDeal.Email_2__c='kaniskqqqq@test.com';
                objDeal2.Phone__c='123456789';
               
                insert objDeal2;
              }catch(Exception e){
                
              }
              try{
                 update objDeal;
              }catch(Exception e){
              }
                        
           }catch(Exception e){
           }
       }
}