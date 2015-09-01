@isTest
private class TestPRAssignmentLogic {

    static testMethod void myUnitTest() {
    	
    	User indiaTeamUser = [Select id,IsActive,Email from user where id = '00580000003d9rB'];
    	
    	Account acctest = new Account();
        acctest.Name='TestAccount';
        acctest.RC_Attribution_Channel__c = 'Sales Agents & Resellers';
        acctest.Partner_ID__c ='123';
        acctest.RecordTypeId  = '01280000000UERq';
        acctest.Current_Owner__c = indiaTeamUser.id;
        insert acctest;
        
        Contact contactObj = new Contact();
        contactObj.AccountId =  acctest.id;
        contactObj.Email = 'test.test@test.com';
        contactObj.Phone = '9910106804';
        contactObj.LastName = 'TestLast';
        insert contactObj;
        
        system.debug('=contactObj='+contactObj.Account.RecordType.Name);
		system.debug('=contactObj='+contactObj.Account.Current_Owner__c);
		system.debug('=contactObj='+contactObj.Account.Current_Owner__r.IsActive);
		
		Campaign campObj1 = new Campaign(Name='TestCampaign',Protected_Campaign__c=true
        , Shared_Lead_Campaign__c=true, Lead_Creation_Score__c='300', IsActive=true, AID__c='test0121' );
        insert campObj1;
        
        /********************Segement Object Data Created**************************************************/
		List<Segment_Data__c> segmentDataList = new List<Segment_Data__c>();
		Segment_Data__c segData = new Segment_Data__c(Type__c='Industry',Attribute_1__c='1',Attribute_2__c='Transportation',Postal_Code__c='');
		Segment_Data__c segData1 = new Segment_Data__c(Type__c='Country',Attribute_1__c='USA',Attribute_2__c='United States',Postal_Code__c='');
		Segment_Data__c segData2 = new Segment_Data__c(Type__c='Area Code',Attribute_1__c='991',Attribute_2__c='United States',Postal_Code__c='100');
		
		Segment_Data__c segData3 = new Segment_Data__c(Type__c='Industry',Attribute_1__c='2',Attribute_2__c='Transportation',Postal_Code__c='');
		Segment_Data__c segData4 = new Segment_Data__c(Type__c='Country',Attribute_1__c='CN',Attribute_2__c='Canada',Postal_Code__c='');
		Segment_Data__c segData5 = new Segment_Data__c(Type__c='Area Code',Attribute_1__c='999',Attribute_2__c='Canada',Postal_Code__c='100');
		
		segmentDataList.add(segData);
		segmentDataList.add(segData1);
		segmentDataList.add(segData2);
		segmentDataList.add(segData3);
		segmentDataList.add(segData4);
		segmentDataList.add(segData5);
		insert segmentDataList;
		/*************************************************************************************************/
		
		/********************Territory Object Data Created**************************************************/
		List<Territory_Data__c> territoryDataList = new List<Territory_Data__c>();
		Territory_Data__c terrData = new Territory_Data__c(Type__c='Industry-Geo',Name='Data1',Country__c='United States',Industry__c='Transportation',
															Postal_Begin__c='100',Postal_End__c='200',Segment__c='50-249',Alternate_Owner__c=indiaTeamUser.Id);
		Territory_Data__c terrData1 = new Territory_Data__c(Type__c='Geo',Name='Data2',Country__c='United States',Industry__c='',
															Postal_Begin__c='100',Postal_End__c='200',Segment__c='50-249',Territory_Owner__c=indiaTeamUser.Id);			
		
		Territory_Data__c terrData2 = new Territory_Data__c(Type__c='Industry-Geo',Name='Data3',Country__c='Canada',Industry__c='Transportation',
															Postal_Begin__c='100',Postal_End__c='200',Segment__c='50-249',Alternate_Owner__c=indiaTeamUser.Id);
		Territory_Data__c terrData3 = new Territory_Data__c(Type__c='Geo',Name='Data4',Country__c='Canada',Industry__c='',
															Postal_Begin__c='100',Postal_End__c='200',Segment__c='50-249',Territory_Owner__c=indiaTeamUser.Id);
		
		territoryDataList.add(terrData);
		territoryDataList.add(terrData1);
		territoryDataList.add(terrData2);
		territoryDataList.add(terrData3);			
		insert territoryDataList;
		/*************************************************************************************************/	
		
		/*************************Custom Setting and Custom Label data Created*******************************************/
		Campaign_Subtype_Mapping__c mappingCS = new Campaign_Subtype_Mapping__c(Name='CPL_Shared',Queue_Id__c=indiaTeamUser.Id);
		insert mappingCS;
		
		system.debug('Label=='+Label.Territory_Employee_Size);
		//System.Label.Territory_Employee_Size = '50-249';
		//System.Label.Territory_By_Pass = 'true';
		/***********************************************************************************************/
    	
        Lead leadObj = new Lead();
        leadObj.FirstName='testFirst';
        leadObj.LastName='testLast';
        leadObj.Company='testCompany';
        leadObj.Email='test.test@test.com';
        leadObj.Phone='9910106804';
        leadObj.LeadSource = 'Inbound Call';
        leadObj.Notes__c = 'Test Notes'; 
        leadObj.Website = 'http://test.com';
        leadObj.NumberOfEmployees = 123;
        leadObj.Industry = 'Test';
        leadObj.NumberOfEmployees__c = '2-9';
        leadObj.Number_of_Locations__c = '2-4';
        leadObj.Agent_Email_Address__c = 'test@test.com';  
        leadObj.Lead_Owner_Email_Address__c = indiaTeamUser.Email;  
        leadObj.Eligible_Protection_Period__c = system.today();
        leadObj.Status = '2. Contacted';
        leadObj.Most_Recent_Campaign__c = campObj1.Id;
        leadObj.Country='USA';
        leadObj.postalcode = '100';
        leadObj.LS_Primary_NAIC__c='1';
        leadObj.Employees_Override__c='50-249';
        
        Lead leadObj1 = new Lead();
        leadObj1.FirstName='testFirst1';
        leadObj1.LastName='testLast1';
        leadObj1.Company='testCompany1';
        leadObj1.Email='test1.test@test.com';
        leadObj1.Phone='9990106801';
        leadObj1.LeadSource = 'Inbound Call';
        leadObj1.Notes__c = 'Test Notes'; 
        leadObj1.Website = 'http://test.com';
        leadObj1.NumberOfEmployees = 123;
        leadObj1.Industry = 'Test';
        leadObj1.NumberOfEmployees__c = '2-9';
        leadObj1.Number_of_Locations__c = '2-4';
        leadObj1.Agent_Email_Address__c = 'test@test.com';  
        leadObj1.Lead_Owner_Email_Address__c = indiaTeamUser.Email;  
        leadObj1.Eligible_Protection_Period__c = system.today();
        leadObj1.Status = '2. Contacted';
        leadObj1.Most_Recent_Campaign__c = campObj1.Id;
        leadObj1.Country='CN';        
        leadObj1.Employees_Override__c='50-249';
        
        Opportunity oppObj = new Opportunity(Name='TestOpp',StageName='1. Qualify',AccountId=acctest.Id,Type='New Business',Sales_Model__c='Online',
        									 Brand_Name__c='RingCentral',Tier_Name__c='Office',CloseDate=system.today());
		insert oppObj;
           
        OpportunityContactRole oppContRole = new OpportunityContactRole(opportunityId=oppObj.Id,ContactId=contactObj.Id,IsPrimary=true);
        insert oppContRole;        
        
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
        
        Skill__c s1= new Skill__c(Name='Skill1');
		insert s1;
		Skill__c s2= new Skill__c(Name='Skill2');
		insert s2;
		User_Skill__c us1 = new User_Skill__c (Name='us1', User__c=userInfo.getUserId(), Skill__c=s1.Id);
		insert us1;
		User_Skill__c us2 = new User_Skill__c (Name='us2', User__c=userInfo.getUserId(), Skill__c=s1.Id);
		insert us2;
        User_Skill__c us3 = new User_Skill__c (Name='us3', User__c=userInfo.getUserId(), Skill__c=s2.Id);
		insert us3;
		
        Lead_Assignment_Rules__c lar1= new Lead_Assignment_Rules__c(Name='LAR1',Lead_Source__c='Inbound Call', Folder__c='A;',Skill__c=s1.Id,Customer_Employee_Size__c='2-9');
        Lead_Assignment_Rules__c lar2= new Lead_Assignment_Rules__c(Name='LAR1',Campaign__c=campObj1.Id,Skill__c=s2.Id,Customer_Employee_Size__c='2-9');
        Lead_Assignment_Rules__c lar3= new Lead_Assignment_Rules__c(Name='LAR1',Campaign__c=campObj2.Id,Skill__c=s1.Id,Customer_Employee_Size__c='2-9');
        Lead_Assignment_Rules__c lar4= new Lead_Assignment_Rules__c(Name='LAR1',Campaign__c=campObj3.Id,Skill__c=s2.Id,Customer_Employee_Size__c='2-9');
        Lead_Assignment_Rules__c lar5= new Lead_Assignment_Rules__c(Name='LAR1',Campaign__c=campObj4.Id,Skill__c=s1.Id,Customer_Employee_Size__c='2-9');
        Lead_Assignment_Rules__c lar6= new Lead_Assignment_Rules__c(Name='LAR1',Campaign__c=campObj5.Id,Skill__c=s2.Id,Customer_Employee_Size__c='2-9');
        Lead_Assignment_Rules__c lar7= new Lead_Assignment_Rules__c(Name='LAR1',Lead_Source__c='Inbound Call',Skill__c=s1.Id,Customer_Employee_Size__c='2-9');
        Lead_Assignment_Rules__c lar8= new Lead_Assignment_Rules__c(Name='LAR1',Lead_Source__c='Inbound Call',Skill__c=s2.Id,Customer_Employee_Size__c='2-9');
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
        
        RcDealHealper.searchResultClass searchObj = new RcDealHealper.searchResultClass();
        searchObj.contactResultList = new List<Contact>{contactObj};
        searchObj.leadResultList = new List<Lead>{leadObj};        
        map<String,RcDealHealper.searchResultClass> searchResultMap = new map<String,RcDealHealper.searchResultClass>{leadObj.Email+leadObj.Phone=>searchObj};
        system.debug('searchResultMap='+searchResultMap);
        
        map<String,String> prOwnerMap = new map<String,String>();
        PRAssignmentLogic.checkAccountCurrentOwner(searchResultMap,prOwnerMap);  
        searchResultMap = new map<String,RcDealHealper.searchResultClass>{leadObj.Email+leadObj.Phone=>searchObj};  
        PRAssignmentLogic.checkActivePipeOrProtected(searchResultMap, prOwnerMap);
        searchObj.contactResultList = new List<Contact>();
        searchResultMap = new map<String,RcDealHealper.searchResultClass>{leadObj.Email+leadObj.Phone=>searchObj};
        PRAssignmentLogic.checkActivePipeOrProtected(searchResultMap, prOwnerMap);
        
        map<String,RcDealHealper.searchResultClass> activePipeOrProtectedMap = new map<String,RcDealHealper.searchResultClass>();        
        List<Lead> newLeadList = new List<Lead>();
        Map<Id,List<User_Skill__c>> skillsToUserSkills = new Map<Id,List<User_Skill__c>>();
        Map<Id, Skill__c> skillsMap = new  Map<Id, Skill__c>();
        //List<Lead_Assignment_Rules__c> larList = new List<Lead_Assignment_Rules__c>();    
        boolean assignUser = true;
        
        PRAssignmentLogic.createEmailOwnerMap(new List<Lead>{leadObj});
        PRAssignmentLogic.findSystemAdminUser();
        PRAssignmentLogic.findOwnerSkill(skillsToUserSkills, skillsMap, larList, leadObj, prOwnerMap, indiaTeamUser, assignUser);
        PRAssignmentLogic.runPRLogic(leadObj, leadObj.Email+leadObj.Phone, prOwnerMap, new map<String,Id>(), new User(),true);
        
        Map<string,Map<String,String>> segmentDataMap = PRAssignmentLogic.createSegmentDataMap();
        Map<String,Map<String,List<Territory_Data__c>>> territoryDataMap = PRAssignmentLogic.createTerritoryDataMap();
        Set<string> employeeSizeSet = new Set<string>{'50-249'};
        Set<string> leadSourceSet = new Set<string>{'Inbound Call'};
        PRAssignmentLogic.runGeoTerritoryRouting(leadObj,segmentDataMap,territoryDataMap,employeeSizeSet,leadSourceSet);
        PRAssignmentLogic.calculateLimits();
        PRAssignmentLogic.runGeoTerritoryRouting(leadObj1,segmentDataMap,territoryDataMap,employeeSizeSet,leadSourceSet);
    }
}