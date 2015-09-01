public class OpportunitySurveyClass {
	
	Set<Id> oppIds;
	Set<id> accIds;
	Map<id, String> SurveyOppMap;
	Map<id, Opportunity> newOppMap;
	Map<id, List<AccountContactRole>> newAccContRMap; //In the case when we have to fetch ContactRole form Account
	Map<id, List<Contact>> newAccContMap; //
	List<Survey__c> surveyList ;
	String surveyType;
	String event;
		
	public OpportunitySurveyClass(Set<id> oppSet, String sType, String onInsert) {
			
			event = onInsert;
			newAccContRMap = new Map<id, List<AccountContactRole>>();
			newAccContMap = new Map<id, List<Contact>>();
			surveyType = sType;
		
				/*Collect all Required data for creating survey*/
     			surveyList = new List<Survey__c>();
				newOppMap = new Map<id, Opportunity>([Select (Select SurveyType__c From Surveys__r),AccountID, 
											     Owner.Team__c, Owner.ManagerId, Owner.Manager.Name, Owner.Manager.Email , Owner.UserRoleId,Account.Is_Demo_Account__c, 
												 Owner.Email, Owner.Name, OwnerId From Opportunity WHERE id IN : OppSet AND AccountID != NULL]); 	
				
				if(newOppMap.size() > 0) {
					accIds = new Set<id>();
					for(Opportunity opp : newOppMap.values()){
						accIds.add(opp.Accountid);
					}
					
				}
				if(accIds.size() > 0){	
					/*for(Account acc: [Select id,(Select Id, AccountId, ContactId, IsPrimary, Contact.Email,CreatedDate 
												 From AccountContactRoles Order by  IsPrimary DESC LIMIT 1),
												 (Select Id, Email, HasOptedOutOfEmail, CreatedDate, marketingSuspend__c From Contacts 
												 WHERE HasOptedOutOfEmail = false AND marketingSuspend__c = false ORDER BY CreatedDate DESC LIMIT 1)
												 From Account  WHERE id IN: accIds]) {
							newAccContRMap.put(acc.id , acc.AccountContactRoles);
							newAccContMap.put(acc.id , acc.Contacts );
					}*/
					String queryStr = 'SELECT id,(SELECT Id, AccountId, ContactId, IsPrimary, Contact.Email,CreatedDate' 
											 +' From AccountContactRoles ORDER BY IsPrimary DESC LIMIT 1 ),'
											 +' (Select Id, Email, HasOptedOutOfEmail, CreatedDate, marketingSuspend__c From Contacts' 
											 +' WHERE HasOptedOutOfEmail = false AND marketingSuspend__c = false ORDER BY CreatedDate DESC LIMIT 1)'
											 +' From Account  WHERE id IN: accIds';
					System.debug(queryStr);
					List<sObject> sobjList = Database.query(queryStr);
					if(sobjList != null && sobjList.size() != 0) {
						for(SObject obj : sobjList) {
							Account acc = (Account) obj;
							newAccContRMap.put(acc.id , acc.AccountContactRoles);
							newAccContMap.put(acc.id , acc.Contacts );
						}
					}
				}
					
    	   	 	makeSurvey(newOppMap.values());
    		  
	}
		
	public OpportunitySurveyClass(Set<id> OppSet, String sType ) {
		
	 			surveyType = sType;
	 			newAccContMap = new Map<id, List<Contact>>();
				/*Collect all Required data for creating survey*/
     			surveyList = new List<Survey__c>();
				newOppMap = new Map<id, Opportunity>([Select (Select SurveyType__c From Surveys__r), 
											     (Select ContactId, Contact.Email, IsPrimary From OpportunityContactRoles WHERE Contact.Email !=null), 
												 Owner.Team__c, Owner.ManagerId, Owner.Manager.Name, Owner.Manager.Email , Owner.UserRoleId, Account.Is_Demo_Account__c, 
												 Owner.Email, Owner.Name, AccountID,OwnerId From Opportunity WHERE id IN : OppSet]); 	

    	   	 	if(newOppMap.size() > 0) {
					accIds = new Set<id>();
					for(Opportunity opp : newOppMap.values()){
						accIds.add(opp.Accountid);
					}
				}
    	   	 	System.debug('##########'+accIds);
    	   	 	if(accIds.size() > 0) {
	    	   	 	for(Account acc: [Select id,(Select Id, Email, HasOptedOutOfEmail, CreatedDate, marketingSuspend__c From Contacts 
												 WHERE HasOptedOutOfEmail = false AND marketingSuspend__c = false ORDER BY CreatedDate DESC LIMIT 1)
												 From Account  WHERE id IN: accIds]) {
							newAccContMap.put(acc.id , acc.Contacts );
					}
    	   	 	}
    	   	 	
    	   	 	makeSurvey(newOppMap.values());
    	   	 	
	}
	
	public void makeSurvey(List<Opportunity> oppList) {
		 for(Opportunity opp:oppList) {
				if(!isSurveyExist( surveyType , opp.id)) {
					surveyList.add(createSurvey(opp));
					/*if(!(surveyType == 'Sales' && opp.Account.Is_Demo_Account__c == true)) {
						surveyList.add(createSurvey(opp));
					}*/
				}
			}
			if(surveyList != null && surveyList.size() > 0) { 
				try {
					insert surveyList;
				} catch(Exception ex) {}
			}
	}
	
	/*public Boolean isSurveyExist(String surveyType, ID oppid) {
	  for(Survey__c surveyObj: newOppMap.get(oppid).Surveys__r ) {
			if(surveyObj.SurveyType__c == surveyType ) {
				return true;
			} else {
				return false;
		    }	
	  }
	  return false;
	}*/
	
	public Boolean isSurveyExist(String surveyType, ID oppid) {
	  boolean flag = false;	
	  for(Survey__c surveyObj: newOppMap.get(oppid).Surveys__r ) {
			if(surveyObj.SurveyType__c == surveyType ) {
				 flag = true;
				 return flag;
				//return true;
			} //else {
				//return false;
		    //}	
	  }
	  return false;
	}
	
		  
	public Survey__c createSurvey(Opportunity opp) { 
		Survey__c surveyObj = new Survey__c();
		if(event == null) {
			System.debug('### Preparing Contact info');
			if(newOppMap.get(opp.id).OpportunityContactRoles != NULL &&  newOppMap.get(opp.id).OpportunityContactRoles.size() != 0) {
				System.debug('### Contact Role'+'='+newOppMap.get(opp.id).OpportunityContactRoles );
				for(OpportunityContactRole Ocr : newOppMap.get(opp.id).OpportunityContactRoles ){
				/* Fetch primary contact if avialable*/	
					if(Ocr.IsPrimary) {
						surveyObj.Contact__c = Ocr.ContactId;
						surveyObj.Contact_Email__c = Ocr.Contact.Email;
						break;
					} else {
						surveyObj.Contact__c = Ocr.ContactId;
						surveyObj.Contact_Email__c = Ocr.Contact.Email;
					}
				}
			} else if(newAccContMap.get(opp.AccountID) != NULL && newAccContMap.get(opp.AccountID).size() !=0) {
				System.debug('### IN Contact Itself');
				for(Contact cont  :(List<Contact>) newAccContMap.get(opp.AccountID)) {
					surveyObj.Contact__c = cont.Id;
					surveyObj.Contact_Email__c = cont.Email;
				}	
			}
		 }
		 
		if(event != null && event=='ON_INSERT') {
			if(newAccContRMap.get(opp.AccountID) != NULL && newAccContRMap.get(opp.AccountID).size() !=0 ) {
				for(AccountContactRole acr :(List<AccountContactRole>) newAccContRMap.get(opp.AccountID)){
							/* Fetch primary contact if avialable*/	
							if(acr.IsPrimary) {
								surveyObj.Contact__c = acr.ContactId;
								surveyObj.Contact_Email__c = acr.Contact.Email;
								break;
							} else {
								surveyObj.Contact__c = acr.ContactId;
								surveyObj.Contact_Email__c = acr.Contact.Email;
						    }
					 }
			} else if(newAccContMap.get(opp.AccountID) != NULL && newAccContMap.get(opp.AccountID).size() !=0) {
				for(Contact cont  :(List<Contact>) newAccContMap.get(opp.AccountID)) {
								surveyObj.Contact__c = cont.Id;
								surveyObj.Contact_Email__c = cont.Email;
				}	
			}
		}
		surveyObj.Account__c = opp.AccountId;
		surveyObj.Opportunity__c = opp.Id;
		surveyObj.Agent__c = opp.OwnerId;
		surveyObj.Agent_Email__c = opp.Owner.Email;
		surveyObj.Agent_Name__c = opp.Owner.Name;
		surveyObj.Agent_Team__c = opp.Owner.Team__c;
		surveyObj.Agent_Manager_Name__c = opp.Owner.Manager.Name;
		surveyObj.Agent_Manager_Email__c = opp.Owner.Manager.Email;
		surveyObj.Name = surveyType +' - ' + Datetime.now().format();
		surveyObj.SurveyType__c = surveyType;
		return surveyObj;	
	}
	
	/*static testMethod void OpportunitySurveyClassTest() { 
	 	
	 	
	  Profile p = [SELECT Id FROM Profile WHERE Name='Sales Agent']; 
      User u = new User(Alias = 'satest', Email='sales@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='sales@testorg.com');
	 	
	  Account accTest = new Account(Name='TestAcc');
	  insert accTest;
	  
	  Contact contTest = new Contact();
	  contTest.AccountID = accTest.id;
	  contTest.LastName ='test Contact';
	  contTest.Email = 'test@test.com';
	  contTest.Phone = '123654789';
	  insert contTest;
	  
	  AccountContactRole acrTest = new AccountContactRole();
	  acrTest.AccountId= accTest.id;
	  acrTest.IsPrimary=true;
	  acrTest.ContactId= contTest.id;
	  acrTest.Role ='Business User'; 
	  insert acrTest;	
	  
	 
	 	
	  Opportunity oppTest = new Opportunity();
	  oppTest.Name ='TestOpp';
	  oppTest.AccountID = accTest.id;
	  oppTest.Type = 'New Business';
	  oppTest.Sales_Model__c = 'Direct';
	  oppTest.Brand_Name__c ='RingCentral';
	  oppTest.Tier_Name__c = 'Power';
	  oppTest.StageName = OpportunityHelper.closedStage;
	  oppTest.RecordTypeId = [SELECT id FROM RecordType Where Name='Saves Opportunity'].id;	
	  oppTest.CloseDate = System.today();
	  insert oppTest;
	  
	  OpportunityContactRole ocr = new OpportunityContactRole();
	  ocr.OpportunityId= oppTest.id;
	  ocr.IsPrimary=true;
	  ocr.ContactId= contTest.id;
	  ocr.Role ='Business User'; 
	  insert ocr;
	  
	  Set<Id> testOppId = new Set<Id>();
	  testOppId.add(oppTest.id);
	   
	   Test.startTest();
	   
	   System.runAs(u){
	  	OpportunitySurveyClass opscSales = new OpportunitySurveyClass(testOppId, 'Sales');
	 	OpportunitySurveyClass opscCsat = new OpportunitySurveyClass(testOppId, 'Saves CSAT');
	 	OpportunitySurveyClass  opscCsat_onCreation = new OpportunitySurveyClass(testOppId, 'Saves CSAT', 'ON_INSERT'); 
	   }
 		
 	   Test.stopTest();
	  
	  
	 
	 }*/
	/*static testMethod void OpportunitySurveyClassTest2() {
	  
	  Profile p = [SELECT Id FROM Profile WHERE Name='Sales Agent']; 
      User u = new User(Alias = 'satest', Email='sales@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='sales@testorg.com'); 
      
      Account accTest2 = new Account(Name='TestAcc');
	  insert accTest2;
	  
	  Contact contTest2 = new Contact();
	  contTest2.AccountID = accTest2.id;
	  contTest2.LastName ='test Contact';
	  contTest2.Email = 'test@test.com';
	  contTest2.Phone = '123654789';
	  insert contTest2;
	  
	  AccountContactRole acrTest2 = new AccountContactRole();
	  acrTest2.AccountId= accTest2.id;
	  acrTest2.IsPrimary=false;
	  acrTest2.ContactId= contTest2.id;
	  acrTest2.Role ='Business User'; 
	  insert acrTest2;	
	 
      Opportunity oppTest2 = new Opportunity();
	  oppTest2.Name ='TestOpp';
	  oppTest2.AccountID = accTest2.id;
	  oppTest2.Type = 'New Business';
	  oppTest2.Sales_Model__c = 'Direct';
	  oppTest2.Brand_Name__c ='RingCentral';
	  oppTest2.Tier_Name__c = 'Power';
	  oppTest2.StageName = OpportunityHelper.closedStage;	
	  oppTest2.CloseDate = System.today();
	  insert oppTest2;
	  
      OpportunityContactRole ocr2 = new OpportunityContactRole();
	  ocr2.OpportunityId= oppTest2.id;
	  ocr2.IsPrimary=false;
	  ocr2.ContactId= contTest2.id;
	  ocr2.Role ='Business User'; 
	  insert ocr2;
	  
	  Set<Id> testOppId2 = new Set<Id>();
	  testOppId2.add(oppTest2.id);
	  
	  Test.startTest();
	  
	  System.runAs(u){
		  	OpportunitySurveyClass opscSales = new OpportunitySurveyClass(testOppId2, 'Sales');
		 	OpportunitySurveyClass opscCsat = new OpportunitySurveyClass(testOppId2, 'Saves CSAT');
	 		OpportunitySurveyClass  opscCsat_onCreation = new OpportunitySurveyClass(testOppId2, 'Saves CSAT', 'ON_INSERT'); 
   	  }
	   
	  Test.stopTest();
	 
	  }*/
	 /* static testMethod void OpportunitySurveyClassTest3() {
		  Profile p = [SELECT Id FROM Profile WHERE Name='Sales Agent']; 
	      User u = new User(Alias = 'satest', Email='sales@testorg.com', 
	      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
	      LocaleSidKey='en_US', ProfileId = p.Id, 
	      TimeZoneSidKey='America/Los_Angeles', UserName='sales@testorg.com'); 
	      
	      Account accTest3 = new Account(Name='TestAcc');
		  insert accTest3;
		  
		  Contact contTest3 = new Contact();
		  contTest3.AccountID = accTest3.id;
		  contTest3.LastName ='test Contact';
		  contTest3.Email = 'test@test.com';
		  contTest3.Phone = '123654789';
		  insert contTest3;
		  
		  AccountContactRole acrTest3 = new AccountContactRole();
		  acrTest3.AccountId= accTest3.id;
		  acrTest3.IsPrimary=false;
		  acrTest3.ContactId= contTest3.id;
		  acrTest3.Role ='Business User'; 
		  insert acrTest3;	
		 
	      Opportunity oppTest3 = new Opportunity();
		  oppTest3.Name ='TestOpp';
		  oppTest3.AccountID = accTest3.id;
		  oppTest3.Type = 'New Business';
		  oppTest3.Sales_Model__c = 'Direct';
		  oppTest3.Brand_Name__c ='RingCentral';
		  oppTest3.Tier_Name__c = 'Power';
		  oppTest3.RecordTypeId = [SELECT id FROM RecordType Where Name='Saves Opportunity'].id;	
		  oppTest3.StageName = OpportunityHelper.closedStage;	
		  oppTest3.CloseDate = System.today();
		  insert oppTest3;
	
		  Account accTest3_1 = new Account(Name='TestAcc');
		  insert accTest3_1;
		  
		  Contact contTest3_1 = new Contact();
		  contTest3_1.AccountID = accTest3_1.id;
		  contTest3_1.LastName ='test Contact';
		  contTest3_1.Email = 'test@test.com';
		  contTest3_1.Phone = '123654789';
		  insert contTest3_1;
		  
		  AccountContactRole acrTest3_1 = new AccountContactRole();
		  acrTest3_1.AccountId= accTest3_1.id;
		  acrTest3_1.IsPrimary=true;
		  acrTest3_1.ContactId= contTest3_1.id;
		  acrTest3_1.Role ='Business User'; 
		  insert acrTest3_1;	
		
		  
		  Opportunity oppTest3_1 = new Opportunity();
		  oppTest3_1.Name ='TestOpp';
		  oppTest3_1.AccountID = accTest3_1.id;
		  oppTest3_1.Type = 'New Business';
		  oppTest3_1.Sales_Model__c = 'Direct';
		  oppTest3_1.Brand_Name__c ='RingCentral';
		  oppTest3_1.Tier_Name__c = 'Power';
		  oppTest3_1.StageName = OpportunityHelper.closedStage;	
		  oppTest3_1.CloseDate = System.today();
		  insert oppTest3_1;
		 
		  
		  Set<Id> testOppId3 = new Set<Id>();
		  testOppId3.add(oppTest3.id);
		  testOppId3.add(oppTest3_1.id);
		  
		  Test.startTest();
		  
		  System.runAs(u){
				 		OpportunitySurveyClass  opscCsat_onCreation = new OpportunitySurveyClass(testOppId3, 'Saves CSAT', 'ON_INSERT');
		 		
		   }
		  
		  Test.stopTest(); 
	  
	  }*/
 }