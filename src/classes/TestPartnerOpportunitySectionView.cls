@isTest
private class TestPartnerOpportunitySectionView{
    static testmethod void UnitPrtOppSecVw(){
         /*RecordType rcrdtyp= [Select r.SobjectType, r.Name, r.IsActive, r.Id From RecordType r where Name='Partner Account' and SobjectType='Account'];       
         Account acc = new Account (Name ='test',Partner_ID__c='123321',parentId='001S000000cqaIU',recordtype=rcrdtyp);
         insert acc;          
         RecordType recortyp= [Select r.SobjectType, r.Name, r.IsActive, r.Id From RecordType r where Name='VAR Opportunity' and SobjectType='Opportunity'];
         
         Opportunity opp = new Opportunity (Name='test1',StageName='Closed',OwnerId = '00580000003d9rB',Partner_ID__c='123321' ,AccountId = acc.id ,CloseDate=date.today() ,Recordtype=recortyp,Brand_Name__c='Ringcentral Canada',Type='New Business');
         insert opp;     
         //Apexpages.currentPage().getParameters().put('id',acc.Id);   
         Apexpages.Standardcontroller controller = new Apexpages.Standardcontroller(acc); 
         PartnerOpportunitySectionView PartOppSectView =  new PartnerOpportunitySectionView(controller);*/
         
        Schema.DescribeSObjectResult resultAccount = Account.SObjectType.getDescribe();
   	 	Map<string,Schema.RecordTypeInfo> rtMapByIdAccount = resultAccount.getRecordTypeInfosByName();
   	 	 
   	 	Schema.DescribeSObjectResult resultOpp = Opportunity.SObjectType.getDescribe();
   	 	Map<string,Schema.RecordTypeInfo> rtMapByIdOpp = resultOpp.getRecordTypeInfosByName();
         
         
     	Account accObj = new Account();
     	accObj.Name = 'Test Account';
     	accObj.RecordTypeId = rtMapByIdAccount.get('Partner Account').getRecordTypeId();
     	accObj.Partner_ID__c = 'Test Partner 1';
     	insert accObj;
     	
     	Account accObj1 = new Account();
     	accObj1.Name = 'Test Account Child';
     	accObj1.RecordTypeId = rtMapByIdAccount.get('Partner Account').getRecordTypeId();
     	accObj1.Partner_ID__c = 'Test Partner 1 Child';
     	accObj1.ParentId = accObj.id;
     	insert accObj1;
     	
     	Test.startTest();
         
     	Opportunity oppObj = new Opportunity();
     	oppObj.Name = 'Test Opp';
     	oppObj.RecordTypeId = rtMapByIdOpp.get('VAR Opportunity').getRecordTypeId();
	 	oppObj.Partner_ID__c = 'Test Partner 1';
		oppObj.AccountId = accObj.Id;
		oppObj.Type = 'Existing Business';
    	oppObj.StageName = '3. ActivePipe';
    	oppObj.CloseDate = System.Today() + 10;
    	oppObj.CurrencyIsoCode = 'USD';
    	oppObj.Brand_Name__c = 'RingCentral';
    	insert oppObj;
    	
    	Opportunity oppObj1 = new Opportunity();
     	oppObj1.Name = 'Test Opp 1';
     	oppObj1.RecordTypeId = rtMapByIdOpp.get('VAR Opportunity').getRecordTypeId();
	 	oppObj1.Partner_ID__c = 'Test Partner 1 Child';
		oppObj1.AccountId = accObj1.Id;
		oppObj1.Type = 'Existing Business';
    	oppObj1.StageName = '3. ActivePipe';
    	oppObj1.CloseDate = System.Today() + 10;
    	oppObj1.CurrencyIsoCode = 'USD';
    	oppObj1.Brand_Name__c = 'RingCentral';
    	insert oppObj1;
    	
    	Test.stopTest();
    	
    	PartnerOpportunitySectionView partnerViewObj = new PartnerOpportunitySectionView(new ApexPages.StandardController(accObj));

    }

 }