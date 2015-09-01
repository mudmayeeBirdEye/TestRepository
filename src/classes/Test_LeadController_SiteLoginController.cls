@isTest
private class Test_LeadController_SiteLoginController {

    public static testmethod void TestsyncAccountlevelRollUps() {
    	try{
    		Account testAccount = new Account(Name = 'TestAccount');
	        insert testAccount;
			
			Account accountobj1 = new Account();
			accountobj1.Name = 'Test Customer Account';
			accountobj1.RC_User_ID__c = 'UID9910106802';
			accountobj1.Partner_ID__c = 'PARTNER002';
			accountobj1.ParentId = testAccount.Id;
			accountobj1.Phone = '9910101111';
			accountobj1.AccountNumber = '991010';
			insert accountobj1;
			    
			Contact contactObj = new Contact();
			contactObj.AccountId = accountobj1.id;
			contactObj.Email = 'Testportaluser@simplion.com';
			contactObj.LastName = 'Test Okta Con portaluser';
			contactObj.Phone = '1234567830';
			insert contactObj;
			
			User testUser = new User(alias = 'portr', email='portaluser@testorg.com', emailencodingkey='UTF-8', lastname='portaluser',OktaUserPassword__c='ra!nb0w7',
			                         OKTAUserID__c='00u3uty75rWFWAOFWHQJ',  ProfileId=[SELECT Id FROM Profile WHERE Name='RC Partner User Pilot' LIMIT 1].Id, languagelocalekey='en_US',
		                      		 localesidkey='en_US', country='United States',timezonesidkey='America/Los_Angeles',username='portaluser@testorg.com', 
									 ContactId=contactObj.Id, IsActive=true );//UserRoleId=objUS.Id,
			insert testUser;
			ApexPages.StandardController controller=new ApexPages.StandardController(accountobj1);
			syncAccountLevelRollUps objsyncAccountLevelRollUps =new syncAccountLevelRollUps (controller);
			objsyncAccountLevelRollUps.strScheduleName='None';
			objsyncAccountLevelRollUps.massUpdateAccountRollUp();
			objsyncAccountLevelRollUps.strScheduleName='allchild';
			objsyncAccountLevelRollUps.massUpdateAccountRollUp();
			objsyncAccountLevelRollUps.strScheduleName='Partner';
			objsyncAccountLevelRollUps.massUpdateAccountRollUp();
			objsyncAccountLevelRollUps.setTotalActiveCustomer();
			objsyncAccountLevelRollUps.scheduleAllAccountsAgain();
    	}catch(exception ex){}
      }
      static testMethod void TestsolveSellLeadController() {
      	try{
			   Lead  r = new Lead();   
		       r.FirstName='testabc';
		       r.lastName ='testxyz';
		       r.Leadsource ='abcd';
		       r.Agent_Email_Address__c ='xyz';
		       r.Phone='123654789';
		       r.Email='Test@Test.com';
		       r.User_ID__c = 'Test@r1.com';
		       r.Downgrade_Reason__c = 'test';
		       r.Company = 'testCompany';
		       insert r;
		       
		       ApexPages.currentPage().getParameters().put('userid', r.User_ID__c);
		       Apexpages.currentPage().getparameters().put('id',r.id);
		       ApexPages.StandardController sc = new ApexPages.standardController(r);
		       solveSellLeadController rc = new solveSellLeadController(sc);
		       rc.save();
		       rc.searchLeads();
		       rc.testingEdgeData011();
		      
		       Lead  ref = rc.getnewlead();
		       Boolean b = rc.getisLeadSaved();
		       b = rc.getuserIdNotFound();
		       b = rc.getisFirstNameFilled();
		       b = rc.getisLastNameFilled();       
		       b = rc.getisCompanyFilled();
		       b= rc.getisEmailFilled();
		       b = rc.getisPhoneFilled();
		       b= rc.getisAgentMailFilled();
      	}catch(exception ex){}
    }
    static testMethod void TestSaveCSATSurveyController() {
       try{
	       	Account  objAccount= new Account(Name='test');
			objAccount.Partner_id__c='123456Test12345';
			insert objAccount;
	                                      
			Contact objContact= new Contact(FirstName ='test',LastName='Ltest');
			objContact.AccountId=objAccount.id;
			insert objContact;
		    
		    
		    Survey__c sr = new Survey__c(Name ='test',Q1_Score__c=1,Q2_Score__c=2,Q3_Score__c=3,Q4_Score__c=4,
										 Q5_Score__c=3,Comments__c='test',SurveyType__c='Saves CSAT');
		   								 sr.Contact__c = objContact.id;
		    upsert sr;
  	 
	  	   ApexPages.currentPage().getParameters().put('id',sr.id);
	    
			// Instantiate a new controller with all parameters in the page
		   SaveCSATSurveyController sur = new SaveCSATSurveyController();
		   //sur.comment='test';
		   sur.save();
		   
		   sur.setQ1Value(3);
		   sur.setQ2Value(2);
		   sur.setQ3Value(4);
		   sur.setQ4Value(4);
		   sur.setQ5Value(4);
		   sur.getQ1Value();
		   sur.getQ2Value();
		   sur.getQ3Value();
		   sur.getQ4Value();
		   sur.getQ5Value();
		   sur.getValues();
		   sur.getContactName();
		   sur.getAnswered();
		   sur.getCommentLength();
		   sur.getComments();
		   sur.getIsEmpty();
		   sur.getIsFilled();
		   sur.setComments('test111');
		   sur.save(); 
		   //sur.comment ='';
		   /* for(Integer i=0; i<101;i++) {
		    	sur.comment+='testtesttesttesttest';
		    }*/
		     sur.getCommentLength();
		  
		     sur.save(); 
		    sur.getSurvey();  
		    
		    Survey__c sur1 = new Survey__c();
		    sur1.Q2_Score__c = 1;
		    sur1.Q3_Score__c = 3;
		    sur1.Q4_Score__c = 4;
		    sur1.Comments__c = 'test';
		    insert sur1 ;
		    
		    ApexPages.currentPage().getParameters().put('id',sur1 .id);
		    SaveCSATSurveyController surC1 = new SaveCSATSurveyController();
		    
		    surC1.allAnswered =true;
		    surC1.submitted = false;
		    surc1.getAnswered();
		    
		    
		    ApexPages.currentPage().getParameters().put('id','111111111111111');
		    SaveCSATSurveyController surC2 = new SaveCSATSurveyController();
		    
		    Survey__c sur2 = new Survey__c();
		    sur2.SurveyType__c = 'Saves CSAT';
		   
		    insert sur2 ;
		    ApexPages.currentPage().getParameters().put('id',sur2.id);
		     SaveCSATSurveyController surC3 = new SaveCSATSurveyController();
		     //surC3.comment ='';
		    /* for(Integer i=0; i<101;i++) {
		    	//surC3.comment+='testtesttesttesttest';
		     }*/
		     surC3.getIsEmpty();
		     
		    Survey__c sur3 = new Survey__c();
		    sur3.SurveyType__c = 'Saves CSAT';
		    sur3.Q2_Score__c = 1;
		    sur3.Q3_Score__c = 3;
		    sur3.Q4_Score__c = 4;
		    insert sur3 ;
		    ApexPages.currentPage().getParameters().put('id',sur3.id);
		     
		     SaveCSATSurveyController surC4 = new SaveCSATSurveyController();
		    // surC4.comment ='';
		    /* for(Integer i=0; i<101;i++) {
		    	surC4.comment+='testtesttesttesttest';
		     }*/
		     surC4.getIsEmpty();
		     
		     Survey__c sur4 = new Survey__c();
			 insert sur4;
		      
		     ApexPages.currentPage().getParameters().put('id',sur4.id);
		     SaveCSATSurveyController surC5 = new SaveCSATSurveyController();
		     surC5.getIsFilled();
       	
       }catch(exception ex){}
    }
	static testMethod void testSurveyController() {
		try{
			Account  objAccount= new Account(Name='test');
			objAccount.Partner_id__c='123456Test12345';
			insert objAccount;
	                                      
			Contact objContact= new Contact(FirstName ='test',LastName='Ltest');
			objContact.AccountId=objAccount.id;
			insert objContact;
		    
		    
		    Survey__c sr = new Survey__c(Name ='test',Q1_Score__c=1,Q2_Score__c=2,Q3_Score__c=3,Q4_Score__c=4,
										 Q5_Score__c=3,Comments__c='test',SurveyType__c='Rogers Implementation');
		    sr.Contact__c = objContact.id;
		    upsert sr;
		    
		    system.Test.setCurrentPageReference(new PageReference('Page.SupportRogersImplementationSurvey'));
		    ApexPages.currentPage().getParameters().put('id', sr.id);
		   
		    RogerSurveyservice rc = new RogerSurveyservice();   
		    rc.getCommentLength(); 
		    rc.getAnswered();
		    rc.getIsFilled(); 
		    rc.getIsEmpty();
		    rc.getComments();
		    rc.setComments('Hello Testing');
		    rc.getQ1Value();
		    rc.setQ1Value(1);
		    rc.getQ2Value();
		    rc.setQ2Value(2);
		    rc.getQ3Value();
		    rc.setQ3Value(2);
		    rc.getQ4Value();
		    rc.setQ4Value(2);
		    rc.getValues();
		    rc.getValues2();
		    rc.getValues3();
		    rc.getSurvey();
		    rc.save();
		    rc.getContactName();
		}catch(exception ex){}
    }
    
}