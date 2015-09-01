@isTest
private class Test_LeadAssignmentRuleDAO {

    static testMethod void TestLeadAssignmentRuleDAO() {
		Profile prof = [SELECT Id, Name FROM Profile WHERE Name LIKE '%SDR%'  LIMIT 1];
		User user1 = new User(alias = 'newUser1', email='newuser1@simplion.com.test',
		emailencodingkey='UTF-8', lastname='Testing1', 
		languagelocalekey='en_US', localesidkey='en_US', profileid = prof.Id,
		timezonesidkey='America/Los_Angeles', username= System.now().millisecond() + 'newuser1@simplion.com.test');
		insert user1;
		
		Profile prof1 = [SELECT Id, Name FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
		User user2 = new User(alias = 'lar', firstname = 'LAR',lastname = 'System User',email='newuser2@simplion.com.test',
		emailencodingkey='UTF-8',
		languagelocalekey='en_US', localesidkey='en_US', profileid = prof1.Id,
		timezonesidkey='America/Los_Angeles', username= System.now().millisecond() + 'newuser2@simplion.com.test');
		insert user2;
		
		Campaign campObj1 = new Campaign(Name='TestCampaign',Protected_Campaign__c=true ,Lead_Creation_Score__c='300', IsActive=true,AID__c='test0121' );
		insert campObj1;
		
		Map<Id,Skill__c> mpSkill = new Map<Id,Skill__c>();
		List<Skill__c> lstSkill = new List<Skill__c>();
		Skill__c s1= new Skill__c(Name='Skill1');
		lstSkill.add(s1);
		
		Skill__c s2= new Skill__c(Name='Skill2');
		lstSkill.add(s2);
		insert lstSkill;
		mpSkill.put(s1.Id,s1);
		mpSkill.put(s2.Id,s2);
		
		Map<Id,List<User_Skill__c>> mpUserSkill = new Map<Id,List<User_Skill__c>>();
		
		List<User_Skill__c> lstUserSkill1 = new List<User_Skill__c>();
		List<User_Skill__c> lstUserSkill2 = new List<User_Skill__c>();
		
		User_Skill__c us1 = new User_Skill__c (Name='us1', User__c=user1.Id, Skill__c=s1.Id);
		lstUserSkill1.add(us1);
		
		User_Skill__c us2 = new User_Skill__c (Name='us2', User__c=user1.Id, Skill__c=s1.Id);
		lstUserSkill1.add(us2);
       
        User_Skill__c us3 = new User_Skill__c (Name='us3', User__c=user1.Id, Skill__c=s2.Id);
		lstUserSkill2.add(us3);
		User_Skill__c us4 = new User_Skill__c (Name='us3', User__c=user1.Id, Skill__c=s2.Id);
		lstUserSkill2.add(us4);
		
		insert lstUserSkill1;
		insert lstUserSkill2;
		
        mpUserSkill.put(s1.Id,lstUserSkill1);
		mpUserSkill.put(s2.Id,lstUserSkill2);
		
		List<Lead_Assignment_Rules__c> lstLAR = new List<Lead_Assignment_Rules__c>();
		Lead_Assignment_Rules__c lar1= new Lead_Assignment_Rules__c(Name='LAR1',IsSecondary__c= false, Campaign__c=campObj1.Id, Lead_Source__c='Inbaound Call',
											Skill__c=s1.Id);
        /*
        Lead_Assignment_Rules__c lar2= new Lead_Assignment_Rules__c(Name='LAR1',IsSecondary__c=false, Campaign__c=campObj1.Id, Skill__c=s2.Id,
											NextUserSkillIndex__c =4.0);
        Lead_Assignment_Rules__c lar7= new Lead_Assignment_Rules__c(Name='LAR1',IsSecondary__c=false, Lead_Source__c='Inbound Call',Skill__c=s1.Id);
        Lead_Assignment_Rules__c lar8= new Lead_Assignment_Rules__c(Name='LAR1',IsSecondary__c=false, Lead_Source__c='Inbound Call',Skill__c=s2.Id);
       */
        lstLAR.add(lar1);
        /*lstLAR.add(lar2);
        lstLAR.add(lar7);
        lstLAR.add(lar8);*/
        insert lstLAR;
        
        Test.startTest();
		
		List<Lead> lstLead = new List<Lead>();
		Lead  r = new Lead(FirstName = 'testabc',lastName ='testxyz',Leadsource ='Inbaound Call',Agent_Email_Address__c ='xyz',Phone='123654789',
						    Email='Test@Test.com',Downgrade_Reason__c ='Lost to Competition',Company = 'Test LTD',ownerId = user2.id);  
		lstLead.add(r);
		insert lstLead;
		Lead  r1 = new Lead(FirstName = 'testabc121',lastName ='testxyz121',Leadsource ='Inbaound Call',Agent_Email_Address__c ='xyz121',Phone='143654789',
						    Email='Test@Test.com',Downgrade_Reason__c ='Lost to Competition',Company = 'Test LTD',ownerId = user2.id); 
		insert r1;
        
		
        try {
        	//LeadAssignmentRuleDAO.scheduleLarCode();
        } catch(Exception e) {}
        try {
        	LeadAssignmentRuleDAO.startLeadAssignment(user2,lstLead, mpSkill, lstLAR, mpUserSkill);
    	} catch(Exception e) {} 	
        //LeadAssignmentRuleDAO.isOldCodeActive()	;
        try {
			LeadAssignmentRuleDAO.runLAR(user2, mpSkill, lstLAR, mpUserSkill);
		} catch(Exception e) {}
		
		Test.stopTest();
    }
}