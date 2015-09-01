@isTest
private class TestInitialLead {

    static testMethod void testLeadContactLeadAssignmentHelper() {
			Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Lead; 
			Map<String,Schema.RecordTypeInfo> LeadRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
			Id rtId = LeadRecordTypeInfo.get('Partner Leads').getRecordTypeId(); 
			
            Campaign campObj1 = new Campaign(Name='TestCampaign',Protected_Campaign__c=true
            , Shared_Lead_Campaign__c=true, Lead_Creation_Score__c='300', IsActive=true, AID__c='test0121' );
            insert campObj1;
            Campaign campObj2 = new Campaign(Name='TestCampaign',Protected_Campaign__c=false
            , Shared_Lead_Campaign__c=true, Lead_Creation_Score__c='test', IsActive=true, DNIS__c='test0121' );
            insert campObj2;
            Campaign campObj3 = new Campaign(Name='TestCampaign',Protected_Campaign__c=true
            , Shared_Lead_Campaign__c=true, Lead_Creation_Score__c='-200', IsActive=true, PID__c='test0121' );
            insert campObj3;
            Campaign campObj4 = new Campaign(Name='TestCampaign',Protected_Campaign__c=false
            , Shared_Lead_Campaign__c=true, Lead_Creation_Score__c='200.00', IsActive=true, BMID__c='test0121' );
            insert campObj4;
            Campaign campObj5 = new Campaign(Name='TestCampaign',Protected_Campaign__c=true
            , Shared_Lead_Campaign__c=true, IsActive=true, Lead_Entry_Source__c='ROI Form' );
            insert campObj5;
            Campaign campObj6 = new Campaign(Name='Default Campaign', Shared_Lead_Campaign__c=true, Protected_Campaign__c=true, IsActive=true );
            insert campObj6;
            Campaign campObj7 = new Campaign(Name='Partner Lead Campaign', Shared_Lead_Campaign__c=true, Protected_Campaign__c=true, IsActive=true );
            insert campObj7;
            
            
            User user1 = new User(alias = 'newUser1', email='newuser1@simplion.com.test',
			emailencodingkey='UTF-8', lastname='Testing1', 
			languagelocalekey='en_US', localesidkey='en_US', profileid = Userinfo.getProfileId(),
			timezonesidkey='America/Los_Angeles', username= System.now().millisecond() + 'newuser1@simplion.com.test');
			insert user1;
            
            User user2 = new User(alias = 'newUser2', email='newuser2@simplion.com.test',
			emailencodingkey='UTF-8', lastname='Testing2', 
			languagelocalekey='en_US', localesidkey='en_US', profileid = Userinfo.getProfileId(),
			timezonesidkey='America/Los_Angeles', username= System.now().millisecond() + 'newuser2@simplion.com.test');
			insert user2;
			
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
			
            Lead_Assignment_Rules__c lar1= new Lead_Assignment_Rules__c(Name='LAR1',Lead_Source__c='Inbaound Call',Skill__c=s1.Id); // Folder__c='A;'
            Lead_Assignment_Rules__c lar2= new Lead_Assignment_Rules__c(Name='LAR1',Campaign__c=campObj1.Id,Skill__c=s2.Id,Lead_Entry_Source__c = 'TestLEs');
            Lead_Assignment_Rules__c lar3= new Lead_Assignment_Rules__c(Name='LAR1',Campaign__c=campObj2.Id,Skill__c=s1.Id);
            Lead_Assignment_Rules__c lar4= new Lead_Assignment_Rules__c(Name='LAR1',Campaign__c=campObj3.Id,Skill__c=s2.Id);
            Lead_Assignment_Rules__c lar5= new Lead_Assignment_Rules__c(Name='LAR1',Campaign__c=campObj4.Id,Skill__c=s1.Id);
            Lead_Assignment_Rules__c lar6= new Lead_Assignment_Rules__c(Name='LAR1',Campaign__c=campObj5.Id,Skill__c=s2.Id);
            Lead_Assignment_Rules__c lar7= new Lead_Assignment_Rules__c(Name='LAR1',Lead_Source__c='Inbound Call',Skill__c=s1.Id);
            Lead_Assignment_Rules__c lar8= new Lead_Assignment_Rules__c(Name='LAR1',Lead_Source__c='Inbound Call',Skill__c=s2.Id);
            List<Lead_Assignment_Rules__c> larList = new List<Lead_Assignment_Rules__c>();
            larList.add(lar1);
            larList.add(lar2);
            larList.add(lar3);
            larList.add(lar4);
            larList.add(lar5);
            larList.add(lar6);
            larList.add(lar7);
            larList.add(lar8);
            insert larList;
            
            Folder fd = [SELECT Id FROM Folder WHERE Name='Lead Routing' LIMIT 1];
            Blob blbObj1 = Blob.valueOf('FIELD API NAME,LOOK INTO SHEET,OBJECT API NAME,OBJECT FIELD,SCORE RANGE,FOLDER,Status,EOLPrimary_Campaign__c,0,Campaign,Lead_Creation_Score__c,>=500,A,1. New A,EOLTitle,1,Lead,,300-499,B,1. New B,EOL,,,,0-299,C,1. New C,EOL,,,,<0,D,1. New D,EOL,,,,DEFAULT,C,,EOL');
            Document doc1 = new Document(Name='Lead Routing Criteria', Body=blbObj1 ,folderId=fd.Id,isPublic=true,type='csv' ); 
            insert doc1;
            Blob blbObj2 = Blob.valueOf('FIELDS,INCLUDE VALIUES,EXCLUDE VALUES,POINTS,EOLTitle,Director,,300,EOL,Owner,,300,EOL,President,,300,EOL,CEO,,300,EOL,CIO,,300,EOL,CFO,,300,EOL,Chief,,300,EOL,CTO,,300,EOL,VP,,300,EOL,Vice President,,300,EOLphone,,,200,EOLemail,,gmail.com,100,EOL,,yahoo.com,100,EOL,,hotmail.com,100,EOL,,aol.com,100,EOL,,comcast.net,100,EOL,,sbcglobal.net,100,EOL');
            Document doc2 = new Document(Name='Lead Routing Criteria Rules', Body=blbObj2 ,folderId=fd.Id,isPublic=true,type='csv' );
            insert doc2;
            
            Account accObj1 = new Account(Name='Simplion', Current_Owner__c=user2.Id, RC_User_ID__c='Test002',Type='Customer',
            								No_of_Employees__c = '12');
	    	insert accObj1;
	    	
	    	List<Contact> contactList = new List<Contact>();
	    	
	    	Contact contactObj1 = new Contact(firstName='Virendra1', indexedPhone__c='9910103404',indexedEmail__c='virendra.singhCon@simplion.com', lastname='Singh1', 
	    	accountId=accObj1.Id, email='virendra.singhCon@simplion.com', phone='9910103404',NumberOfEmployees__c = '12',
	    				Marketo_Duplicate_Lead__c = true, Primary_Campaign__c = campObj1.id,LeadSource='Inbound Call',folder__c = 'A;');
            contactList.add(contactObj1);
            
            Contact contactObj2 = new Contact(firstName='Virendra1', indexedPhone__c='9910103404',indexedEmail__c='virendra.singhCon11@simplion.com', lastname='Singh111', 
	    	accountId=accObj1.Id, email='virendra.singhCon11@simplion.com', phone='9910103404',Marketo_Duplicate_Lead__c = true,
	    				Primary_Campaign__c = campObj1.id, LeadSource = 'Inbaound Call',Lead_Entry_Source__c = 'TestLEs');
            contactList.add(contactObj2);
            insert contactList;
            
          /*  Opportunity oppObj = new Opportunity(name='Simplion',account=accObj1,type='New Business',sales_model__c='Direct',CloseDate=Date.Today(), StageName= OpportunityHelper.defaultOpportunityStage);
            insert oppObj;
            
            List<Lead> leadList = new List<Lead>();
            Lead leadObj1 = new Lead(firstName='Singh', Title='VP', Lead_Entry_Source__c='ROI Form', LeadSource='Initial', lastname = 'Virendra', 
            company='Simplion', email='virendra.singh@simplion.com', phone='9910106804');
            leadList.add(leadObj1);
            
            Lead leadObj2 = new Lead(firstName='Singh', Title='VP', AID__C='test0121', Referrer_RCUserID__c='Test002', 
            					LeadSource='About To Be Cancelled',User_ID__c='Test002', lastname = 'Virendra', 
            company='Simplion', email='virendra.singh1@simplion.com', phone='9910106805');
            leadList.add(leadObj2);
            
            Lead leadObj3 = new Lead(firstName='Singh', Title='VP', PID__c='test0121', NumberOfEmployees__c ='500+', LeadSource='Vista Print', lastname = 'Virendra', 
            company='Simplion', email='virendra.singh2@simplion.com', phone='(919)191-9128');
            leadList.add(leadObj3);
            
            Lead leadObj4 = new Lead(firstName='Singh', Title='VP', Country='UK', BMID__c='test0121',LeadSource='Solve then Sell',User_ID__c='Test002', lastname = 'Virendra', 
            company='Simplion', email='virendra.singh3@simplion.co.uk', phone='9910106803');
            leadList.add(leadObj4);
            
            Lead leadObj5 = new Lead(firstName='Singh', Title='VP', Five9_DNIS__c='test0121',NumberOfEmployees__c ='20-49', lastname = 'Virendra', 
            company='Simplion', email='virendra.singh4@simplion.com', phone='9910106808');
            leadList.add(leadObj5);
            
            Lead leadObj6 = new Lead(firstName='Singh', Title='VP', lastname = 'Virendra', 
            company='SimplionTest', email='virendra.singh5@simplion.com', phone='9910106809');
            leadList.add(leadObj6);
            
            Lead leadObj7 = new Lead(firstName='Singh', Title='VP', lastname = 'Virendra', LeadSource = 'Referral Programs',
            						Referrer_RCUserID__c='Test002', Sales_Agent_Email__c='newuser2@simplion.com.test', 
            						Referrer_Email__c='virendra.singhCon@simplion.com', 
            						company='SimplionTest', email='virendra.singh6@simplion.com', phone='9910106809');
            leadList.add(leadObj7);
            
            Lead leadObj8 = new Lead(firstName='Singh', Title='VP', lastname = 'Virendra', LeadSource='Inbound Call',
            				company='SimplionTest', email='virendra.singh8@simplion.com', recordTypeId=rtId, phone='9910106203');
            leadList.add(leadObj8); 
            insert leadList;*/
           
            map<Id,User> userMap = new map<Id,User>(); 
            for(Contact contObj : contactList) {
            	User userObj = new User(Id = contObj.OwnerId);
            	userMap.put(contObj.OwnerId,userObj);
            }
           
            Test.startTest();
           
             Lead leadObj11 = new Lead(firstName='Singh', Title='VP', Country='UK', BMID__c='test0121'
             ,LeadSource='Initial', lastname = 'Virendra', 
            company='Simplion', email='virendra.singh3@simplion.co.uk', phone='9910106803');
            Lead leadObj12 = new Lead(firstName='Singh', Title='VP', Country='UK', BMID__c='test0121'
             ,LeadSource='About To Be Cancelled', lastname = 'Virendra', 
            company='Simplion', email='virendra.singh3@simplion.co.uk', phone='9910106803');
            Lead leadObj13 = new Lead(firstName='Singh', Title='VP', Country='UK', BMID__c='test0121'
             ,LeadSource='Vista Print', lastname = 'Virendra', 
            company='Simplion', email='virendra.singh3@simplion.co.uk', phone='9910106803');
            Lead leadObj14 = new Lead(firstName='Singh', status='X. Suspect',
            LeadSource='Inbound Call', lastname = 'Virendra', 
            company='Simplion', email='virendra.singh4@simplion.com', phone='9910106803');
         	
         	Map<String, Campaign> campaignMap = ContactLeadAssignmentHelper.assignCampaignToContact(contactList);
          	ContactLeadAssignmentHelper.initialContacts(contactList,userMap);
          	
          	Test.stopTest();
	}
	
	static testMethod void testOpportunityLARHelper() {
			Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Lead; 
			Map<String,Schema.RecordTypeInfo> LeadRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
			Id rtId = LeadRecordTypeInfo.get('Partner Leads').getRecordTypeId(); 
			
            Campaign campObj1 = new Campaign(Name='TestCampaign',Protected_Campaign__c=true
            , Shared_Lead_Campaign__c=true, Lead_Creation_Score__c='300', IsActive=true, AID__c='test0121' );
            insert campObj1;
            Campaign campObj2 = new Campaign(Name='TestCampaign',Protected_Campaign__c=false
            , Shared_Lead_Campaign__c=true, Lead_Creation_Score__c='test', IsActive=true, DNIS__c='test0121' );
            insert campObj2;
            Campaign campObj3 = new Campaign(Name='TestCampaign',Protected_Campaign__c=true
            , Shared_Lead_Campaign__c=true, Lead_Creation_Score__c='-200', IsActive=true, PID__c='test0121' );
            insert campObj3;
            Campaign campObj4 = new Campaign(Name='TestCampaign',Protected_Campaign__c=false
            , Shared_Lead_Campaign__c=true, Lead_Creation_Score__c='200.00', IsActive=true, BMID__c='test0121' );
            insert campObj4;
            Campaign campObj5 = new Campaign(Name='TestCampaign',Protected_Campaign__c=true
            , Shared_Lead_Campaign__c=true, IsActive=true, Lead_Entry_Source__c='ROI Form' );
            insert campObj5;
            Campaign campObj6 = new Campaign(Name='Default Campaign', Shared_Lead_Campaign__c=true, Protected_Campaign__c=true, IsActive=true );
            insert campObj6;
            Campaign campObj7 = new Campaign(Name='Partner Lead Campaign', Shared_Lead_Campaign__c=true, Protected_Campaign__c=true, IsActive=true );
            insert campObj7;
            
            
            User user1 = new User(alias = 'newUser1', email='newuser1@simplion.com.test',
			emailencodingkey='UTF-8', lastname='Testing1', 
			languagelocalekey='en_US', localesidkey='en_US', profileid = Userinfo.getProfileId(),
			timezonesidkey='America/Los_Angeles', username= System.now().millisecond() + 'newuser1@simplion.com.test');
			insert user1;
            
            User user2 = new User(alias = 'newUser2', email='newuser2@simplion.com.test',
			emailencodingkey='UTF-8', lastname='Testing2', 
			languagelocalekey='en_US', localesidkey='en_US', profileid = Userinfo.getProfileId(),
			timezonesidkey='America/Los_Angeles', username= System.now().millisecond() + 'newuser2@simplion.com.test');
			insert user2;
			
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
			
            Lead_Assignment_Rules__c lar1= new Lead_Assignment_Rules__c(Name='LAR1',Lead_Source__c='Inbaound Call',Skill__c=s1.Id); // Folder__c='A;'
            Lead_Assignment_Rules__c lar2= new Lead_Assignment_Rules__c(Name='LAR1',Campaign__c=campObj1.Id,Skill__c=s2.Id,Lead_Entry_Source__c = 'TestLEs');
            Lead_Assignment_Rules__c lar3= new Lead_Assignment_Rules__c(Name='LAR1',Campaign__c=campObj2.Id,Skill__c=s1.Id);
            Lead_Assignment_Rules__c lar4= new Lead_Assignment_Rules__c(Name='LAR1',Campaign__c=campObj3.Id,Skill__c=s2.Id);
            Lead_Assignment_Rules__c lar5= new Lead_Assignment_Rules__c(Name='LAR1',Campaign__c=campObj4.Id,Skill__c=s1.Id);
            Lead_Assignment_Rules__c lar6= new Lead_Assignment_Rules__c(Name='LAR1',Campaign__c=campObj5.Id,Skill__c=s2.Id);
            Lead_Assignment_Rules__c lar7= new Lead_Assignment_Rules__c(Name='LAR1',Lead_Source__c='Inbound Call',Skill__c=s1.Id);
            Lead_Assignment_Rules__c lar8= new Lead_Assignment_Rules__c(Name='LAR1',Lead_Source__c='Inbound Call',Skill__c=s2.Id);
            List<Lead_Assignment_Rules__c> larList = new List<Lead_Assignment_Rules__c>();
            larList.add(lar1);
            larList.add(lar2);
            larList.add(lar3);
            larList.add(lar4);
            larList.add(lar5);
            larList.add(lar6);
            larList.add(lar7);
            larList.add(lar8);
            insert larList;
            
            Folder fd = [SELECT Id FROM Folder WHERE Name='Lead Routing' LIMIT 1];
            Blob blbObj1 = Blob.valueOf('FIELD API NAME,LOOK INTO SHEET,OBJECT API NAME,OBJECT FIELD,SCORE RANGE,FOLDER,Status,EOLPrimary_Campaign__c,0,Campaign,Lead_Creation_Score__c,>=500,A,1. New A,EOLTitle,1,Lead,,300-499,B,1. New B,EOL,,,,0-299,C,1. New C,EOL,,,,<0,D,1. New D,EOL,,,,DEFAULT,C,,EOL');
            Document doc1 = new Document(Name='Lead Routing Criteria', Body=blbObj1 ,folderId=fd.Id,isPublic=true,type='csv' ); 
            insert doc1;
            Blob blbObj2 = Blob.valueOf('FIELDS,INCLUDE VALIUES,EXCLUDE VALUES,POINTS,EOLTitle,Director,,300,EOL,Owner,,300,EOL,President,,300,EOL,CEO,,300,EOL,CIO,,300,EOL,CFO,,300,EOL,Chief,,300,EOL,CTO,,300,EOL,VP,,300,EOL,Vice President,,300,EOLphone,,,200,EOLemail,,gmail.com,100,EOL,,yahoo.com,100,EOL,,hotmail.com,100,EOL,,aol.com,100,EOL,,comcast.net,100,EOL,,sbcglobal.net,100,EOL');
            Document doc2 = new Document(Name='Lead Routing Criteria Rules', Body=blbObj2 ,folderId=fd.Id,isPublic=true,type='csv' );
            insert doc2;
            
            Account accObj1 = new Account(Name='Simplion', Current_Owner__c=user2.Id, RC_User_ID__c='Test002',Type='Customer',
            								No_of_Employees__c = '12');
	    	insert accObj1;
	    	
	    	/*List<Contact> contactList = new List<Contact>();
	    	
	    	Contact contactObj1 = new Contact(firstName='Virendra1', indexedPhone__c='9910103404',indexedEmail__c='virendra.singhCon@simplion.com', lastname='Singh1', 
	    	accountId=accObj1.Id, email='virendra.singhCon@simplion.com', phone='9910103404',NumberOfEmployees__c = '12',
	    				Marketo_Duplicate_Lead__c = true, Primary_Campaign__c = campObj1.id,LeadSource='Inbound Call',folder__c = 'A;');
            contactList.add(contactObj1);
            
            Contact contactObj2 = new Contact(firstName='Virendra1', indexedPhone__c='9910103404',indexedEmail__c='virendra.singhCon11@simplion.com', lastname='Singh111', 
	    	accountId=accObj1.Id, email='virendra.singhCon11@simplion.com', phone='9910103404',Marketo_Duplicate_Lead__c = true,
	    				Primary_Campaign__c = campObj1.id, LeadSource = 'Inbaound Call',Lead_Entry_Source__c = 'TestLEs');
            contactList.add(contactObj2);
            insert contactList;*/
            
            List<Opportunity> oppList = new List<Opportunity>();
            Opportunity oppObj = new Opportunity(name='Simplion',accountid=accObj1.id,type='New Business',sales_model__c='Direct',CloseDate=Date.Today(), 
            							StageName= OpportunityHelper.defaultOpportunityStage,Number_of_Employees__c = '12',campaignId =campObj1.id,
            							Marketo_Duplicate_Lead__c = true, LeadSource='Inbound Call');
            Opportunity oppObj1 = new Opportunity(name='Simplion1',accountid=accObj1.id,type='New Business',sales_model__c='Direct',CloseDate=Date.Today(), 
            							StageName= OpportunityHelper.defaultOpportunityStage,Number_of_Employees__c = '12',
            							Marketo_Duplicate_Lead__c = true,campaignId =campObj1.id ,
	    								LeadSource = 'Inbaound Call',Lead_Entry_Source__c = 'TestLEs');							
            oppList.add(oppObj);
            oppList.add(oppObj1);
            insert oppList;
           
            map<Id,User> userMap = new map<Id,User>(); 
            for(Opportunity opportunityObj : oppList) {
            	User userObj = new User(Id = opportunityObj.OwnerId);
            	userMap.put(opportunityObj.OwnerId,userObj);
            }
           
            Test.startTest();
         	
         	Map<String, Campaign> campaignMap = OpportunityLARHelper.assignCampaignToOpportunity(oppList);
          	OpportunityLARHelper.initialOpportunities(oppList,userMap);
          	
          	Test.stopTest();
	}
	
	static testMethod void testCampaignAssignedHelper() {
		   Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Lead; 
			Map<String,Schema.RecordTypeInfo> LeadRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
			Id rtId = LeadRecordTypeInfo.get('Partner Leads').getRecordTypeId(); 
			Campaign campObj1 = new Campaign(Name='TestCampaign',Protected_Campaign__c=true
            , Shared_Lead_Campaign__c=true, Lead_Creation_Score__c='300', IsActive=true, AID__c='test0121', BMID__c='test0121',PID__c='test0121' );
            insert campObj1;
            Campaign campObj2 = new Campaign(Name='TestCampaign',Protected_Campaign__c=false
            , Shared_Lead_Campaign__c=true, Lead_Creation_Score__c='test', IsActive=true, DNIS__c='test0121' );
            insert campObj2;
            Campaign campObj3 = new Campaign(Name='TestCampaign',Protected_Campaign__c=true
            , Shared_Lead_Campaign__c=true, Lead_Creation_Score__c='-200', IsActive=true, PID__c='test0121' );
            insert campObj3;
            Campaign campObj4 = new Campaign(Name='TestCampaign',Protected_Campaign__c=false
            , Shared_Lead_Campaign__c=true, Lead_Creation_Score__c='200.00', IsActive=true, BMID__c='test0121' );
            insert campObj4;
            Campaign campObj5 = new Campaign(Name='TestCampaign',Protected_Campaign__c=true
            , Shared_Lead_Campaign__c=true, IsActive=true, Lead_Entry_Source__c='ROI Form' );
            insert campObj5;
            Campaign campObj6 = new Campaign(Name='Default Campaign', Shared_Lead_Campaign__c=true, Protected_Campaign__c=true, IsActive=true );
            insert campObj6;
            Campaign campObj7 = new Campaign(Name='Partner Lead Campaign', Shared_Lead_Campaign__c=true, Protected_Campaign__c=true, IsActive=true );
            insert campObj7;
            
            List<Lead> leadList = new List<Lead>();
            Lead leadObj1 = new Lead(firstName='Singh', Title='VP', Lead_Entry_Source__c='ROI Form', LeadSource='Initial', lastname = 'Virendra', 
            company='Simplion', email='virendra.singh@simplion.com', phone='9910106804');
            leadList.add(leadObj1);
            
            Lead leadObj2 = new Lead(firstName='Singh', Title='VP', AID__C='test0121', Referrer_RCUserID__c='Test002', 
            					LeadSource='About To Be Cancelled',User_ID__c='Test002', lastname = 'Virendra', 
            company='Simplion', email='virendra.singh1@simplion.com', phone='9910106805');
            leadList.add(leadObj2);
            
            Lead leadObj3 = new Lead(firstName='Singh', Title='VP', PID__c='test0121', NumberOfEmployees__c ='500+', LeadSource='Vista Print', lastname = 'Virendra', 
            company='Simplion', email='virendra.singh2@simplion.com', phone='(919)191-9128');
            leadList.add(leadObj3);
            
            Lead leadObj4 = new Lead(firstName='Singh', Title='VP', Country='UK', BMID__c='test0121',LeadSource='Solve then Sell',User_ID__c='Test002', lastname = 'Virendra', 
            company='Simplion', email='virendra.singh3@simplion.co.uk', phone='9910106803');
            leadList.add(leadObj4);
            
            Lead leadObj5 = new Lead(firstName='Singh', Title='VP', Five9_DNIS__c='test0121',NumberOfEmployees__c ='20-49', lastname = 'Virendra', 
            company='Simplion', email='virendra.singh4@simplion.com', phone='9910106808');
            leadList.add(leadObj5);
            
            Lead leadObj6 = new Lead(firstName='Singh', Title='VP', lastname = 'Virendra', 
            company='SimplionTest', email='virendra.singh5@simplion.com', phone='9910106809');
            leadList.add(leadObj6);
            
            Lead leadObj7 = new Lead(firstName='Singh', Title='VP', lastname = 'Virendra', LeadSource = 'Referral Programs',
            						Referrer_RCUserID__c='Test002', Sales_Agent_Email__c='newuser2@simplion.com.test', 
            						Referrer_Email__c='virendra.singhCon@simplion.com', 
            						company='SimplionTest', email='virendra.singh6@simplion.com', phone='9910106809');
            leadList.add(leadObj7);
            
            Lead leadObj8 = new Lead(firstName='Singh', Title='VP', lastname = 'Virendra', LeadSource='Inbound Call',
            				company='SimplionTest', email='virendra.singh8@simplion.com', recordTypeId=rtId, phone='9910106203');
            leadList.add(leadObj8); 
            insert leadList;
            Test.startTest();
            List<CampaignWrapper> campaignWRList = new List<CampaignWrapper>();
            CampaignWrapper campaignWrObj = new CampaignWrapper(campObj1.AID__c,campObj1.BMID__c,campObj1.PID__c,campObj1.id,true);
            campaignWRList.add(campaignWrObj);
            Map<String, Campaign> criteriaToCamapaignMap = CampaignAssignmentHelper.findCampaings(campaignWRList);
            CampaignAssignmentHelper.getLeadCampaign(campaignWrObj, criteriaToCamapaignMap);
            CampaignWrapper campaignWrObj1 = new CampaignWrapper('Test1','Test1','Test1',null,true);
            CampaignAssignmentHelper.getLeadCampaign(campaignWrObj1, criteriaToCamapaignMap);
            Test.stopTest();
	}
}