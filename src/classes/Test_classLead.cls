@isTest
private class Test_classLead {

    
        static testMethod void Test_FakeLeadController() {
	    	Lead leadObj = new Lead();
	        leadObj.FirstName = 'FName';
	        leadObj.Email= 'abc@test.com';
	        leadObj.LastName = 'LastName'; 
	        leadObj.Company  ='TestCompany';
	        leadObj.phone = '12222223321';
	        leadObj.Downgrade_Reason__c  = 'Not Enough Info';
	        leadObj.User_ID__c ='12345';
	        leadObj.Website = 'test.com';
	        leadObj.NumberOfEmployees = 5;
	        leadObj.Industry = 'Consulting: IT';
	        leadObj.NumberOfEmployees__c='2-19';
	        leadObj.Number_of_Locations__c ='2-4'; 
	        //leadObj.Account__c
			insert leadObj;
			Test.startTest();
	        ApexPages.StandardController controller = new ApexPages.StandardController(leadObj);
	        FakeLeadController objFLC = new FakeLeadController(controller);
	        objFLC.save();
	        FakeLeadController.FakeDataTest objFLC_FDT = new FakeLeadController.FakeDataTest();
	        objFLC_FDT.testingFakeData();
	        objFLC_FDT.testingFakeData02();
	        Test.stopTest();
	       
    	}
    	static testMethod void Test_LeadSpinner() {
			Profile prof = [SELECT Id, Name FROM Profile WHERE Name LIKE '%SDR%'  LIMIT 1];
			User user1 = new User(alias = 'newUser1', email='newuser1@simplion.com.test',
			emailencodingkey='UTF-8', lastname='Testing1', 
			languagelocalekey='en_US', localesidkey='en_US', profileid = prof.Id,
			timezonesidkey='America/Los_Angeles', username= System.now().millisecond() + 'newuser1@simplion.com.test');
			insert user1;
	        
	        User user2 = new User(alias = 'newUser2', email='newuser2@simplion.com.test',
			emailencodingkey='UTF-8', lastname='Testing2', 
			languagelocalekey='en_US', localesidkey='en_US', profileid = prof.Id,
			timezonesidkey='America/Los_Angeles', username= System.now().millisecond() + 'newuser2@simplion.com.test');
			insert user2;
			
			User user3 = new User(alias = 'newUser3', email='newuser3@simplion.com.test',
			emailencodingkey='UTF-8', lastname='Testing3', 
			languagelocalekey='en_US', localesidkey='en_US', profileid = prof.Id,
			timezonesidkey='America/Los_Angeles', username= System.now().millisecond() + 'newuser3@simplion.com.test');
			insert user3;
			
			System.runAs(user1) {
	            // Test.startTest();
	            Campaign campObj1 = new Campaign(Name='TestCampaign',Protected_Campaign__c=true ,Lead_Creation_Score__c='300', IsActive=true, 
			AID__c='test0121' );
	        
	        insert campObj1;
		
			Skill__c s1= new Skill__c(Name='Skill1');
			insert s1;
			Skill__c s2= new Skill__c(Name='Skill2');
			insert s2;
			User_Skill__c us1 = new User_Skill__c (Name='us1', User__c=user1.Id, Skill__c=s1.Id);
			insert us1;
			User_Skill__c us2 = new User_Skill__c (Name='us2', User__c=user2.Id, Skill__c=s1.Id);
			insert us2;
	        User_Skill__c us3 = new User_Skill__c (Name='us3', User__c=user1.Id, Skill__c=s2.Id);
			insert us3;
			User_Skill__c us4 = new User_Skill__c (Name='us3', User__c=user3.Id, Skill__c=s2.Id);
			insert us4;
	        Lead_Assignment_Rules__c lar1= new Lead_Assignment_Rules__c(Name='LAR1',IsSecondary__c=true, Campaign__c=campObj1.Id, Lead_Source__c='Inbaound Call',Skill__c=s1.Id);
	        Lead_Assignment_Rules__c lar2= new Lead_Assignment_Rules__c(Name='LAR1',IsSecondary__c=true, Campaign__c=campObj1.Id, Skill__c=s2.Id);
	        Lead_Assignment_Rules__c lar3= new Lead_Assignment_Rules__c(Name='LAR1',IsSecondary__c=false, Campaign__c=campObj1.Id,Lead_Source__c='Inbaound Call', Skill__c=s1.Id);
	        /*Lead_Assignment_Rules__c lar4= new Lead_Assignment_Rules__c(Name='LAR1',IsSecondary__c=true, Campaign__c=campObj3.Id,Skill__c=s2.Id);
	        Lead_Assignment_Rules__c lar5= new Lead_Assignment_Rules__c(Name='LAR1',IsSecondary__c=true, Campaign__c=campObj4.Id,Skill__c=s1.Id);
	        Lead_Assignment_Rules__c lar6= new Lead_Assignment_Rules__c(Name='LAR1',IsSecondary__c=true, Campaign__c=campObj5.Id,Skill__c=s2.Id);*/
	        Lead_Assignment_Rules__c lar7= new Lead_Assignment_Rules__c(Name='LAR1',IsSecondary__c=true, Lead_Source__c='Inbound Call',Skill__c=s1.Id);
	        Lead_Assignment_Rules__c lar8= new Lead_Assignment_Rules__c(Name='LAR1',IsSecondary__c=true, Lead_Source__c='Inbound Call',Skill__c=s2.Id);
	        List<Lead_Assignment_Rules__c> larList = new List<Lead_Assignment_Rules__c>();
	        larList.add(lar1);
	        larList.add(lar2);
	        /*larList.add(lar3);
	        larList.add(lar4);
	        larList.add(lar5);
	        larList.add(lar6);*/
	        larList.add(lar7);
	        larList.add(lar8);
	        insert larList;		
			
		
	        Lead leadObj = new Lead(firstName='Singh', Title='VP', Country='UK', AID__c='test0121',Downgrade_Reason__c='Not a Decision Maker'
	         ,LeadSource='Inbaound Call', lastname = 'Virendra', NumberOfEmployees__c='2-5',
	        company='Simplion', email='virendra.singh3@simplion.co.uk', phone='9910106803');
	        insert leadObj;
	        Test.startTest();
        	ApexPages.StandardController sc = new ApexPages.standardController(leadObj);
        	LeadSpinner ui = new LeadSpinner(sc);
			ui.getNextUser();
			ui.assignToSelectedUser();
			ui.getPreviousUser();
			ui.assignToSelectedUser();
			// ui.isUnique(us1);
			ui.assignOnCurrentOwner(us1);
			
			//ui.getIndex(-1, new List<User_Skill__c>{us1});  //---->
			//ui.getIndex(null, new List<User_Skill__c>{us1}); //----->
			
			Lead leadObj1 = new Lead(firstName='Singh1', Title='VP', Country='UK', AID__c='test0122',Downgrade_Reason__c='Not a Decision Maker'
	         ,LeadSource='Inbaound Call', lastname = 'Virendra1', NumberOfEmployees__c='2-5',
	        company='Simplion1', email='virendra.singh5@simplion.co.uk', phone='9910106804',ownerId = user1.Id);
	        insert leadObj1;
	        sc = new ApexPages.standardController(leadObj1);
        	ui = new LeadSpinner(sc);
        	
	        leadObj1.lead_folder__c = null;
           // ui.setDefaultFolder(); //------>
			//ui.isEmptyFolder = true; //------>
			ui.resetFolder();
			ui.getSDRProfiles();
        	try {
				String folder = leadObj1.lead_folder__c.trim();
			} catch(Exception ex) {
				//ui.setException(ex.getMessage());//----->
			}
			
			leadObj = new Lead(firstName='Singh', Title='VP', Country='UK',Downgrade_Reason__c='Not a Decision Maker'
             ,LeadSource='Inbound Call', lastname = 'Virendra', NumberOfEmployees__c=' ',
            company='Simplion', email='virendra.singh4@simplion.co.uk', phone='9910106803');
            insert leadObj;
			ui.goToLead();
        	sc = new ApexPages.standardController(leadObj);
        	ui = new LeadSpinner(sc);
        	
			ui.getNextUser();
			ui.getNextUser();
			ui.getNextUser();
			ui.getNextUser();
			ui.getPreviousUser();
			ui.getPreviousUser();
			ui.getPreviousUser();
			ui.getPreviousUser();
			ui.currentUserIndex = -1;
			ui.assignToSelectedUser();
			ui.assignOnCurrentOwner(us1);
			
			leadObj = new Lead(Downgrade_Reason__c='Not a Decision Maker');
			sc = new ApexPages.standardController(leadObj);
        	ui = new LeadSpinner(sc);
        	Test.stopTest();
		}
    }
     static testMethod void Test_ExceptionNotificationHistory() {
     try {
     	List<Exception_And_Notification_History__c> lstENH = new List<Exception_And_Notification_History__c>();
     	Exception_And_Notification_History__c obj1 = new Exception_And_Notification_History__c();
     	lstENH.add(obj1);
     	insert lstENH;
     	Test.startTest();
     	ApexPages.StandardSetController objSSC=new ApexPages.StandardSetController(Database.getQueryLocator([SELECT Id FROM Exception_And_Notification_History__c]));
     	
     	Set<ID> ids = new Set<ID>();
     	ids.add(obj1.id);
		List<selectOption> objSO = new List<selectOption> ();
        ExceptionNotificationHistory obj = new ExceptionNotificationHistory();
        objSO = obj.recordType;
        obj.con = objSSC;//ApexPages.Standardsetcontroller(lstENH);
        obj.setIds(ids);
        obj.recordTypename = 'Email Notification';
        obj.AllDeletecheck();
        obj.del();
        obj.first();
        obj.last();
        obj.test();
        obj.go();
        obj.Next();
        obj.previous();
        if(obj.hasPrevious){System.debug('true');}
        Set<id> s = obj.getIds();
        
        List<SelectOption> l = obj.getItems();
        Test.stopTest();
        } catch(Exception e){}
   
    }
   
}